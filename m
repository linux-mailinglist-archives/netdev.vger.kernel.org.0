Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4596E319D
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 15:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbjDONiU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 09:38:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjDONiT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 09:38:19 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AD533A9A
        for <netdev@vger.kernel.org>; Sat, 15 Apr 2023 06:38:18 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id 4fb4d7f45d1cf-5055141a8fdso2455125a12.3
        for <netdev@vger.kernel.org>; Sat, 15 Apr 2023 06:38:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681565896; x=1684157896;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=lfwoIWq66HClk6b22JLSOioQxz/ZJ0/vIYhJq+Ag21Y=;
        b=Adx2I4NK+DlMEVRxWVSYOETb2dparY1WLGzqq845f6xnuv8lsU2RkhAOuL8AUCeI85
         wgdJC23pypQIbntHzYTDyp3337ZI3J2+amaRtulhiaqiBq5teHMl5M+dIuOY6OH3NiIm
         fM1vkHPWE3pYImAa9G4jDmBM6cLSGQv6AgWMX2SmHe3Y/a1ntrEOXLx1UNpVBZvDfglp
         SfbieDc1ABLisnsSNPC8S2LO/Z/lm4vdQ3Vhl0/aSN3wfJVkoJUwNRYgByY9K7kMKCWM
         ZGTkopdxnJPa5LadsaAo8OJbDmxAKfw2ILryr8FXmSmqZKKVy3Dp67t3obBeMC2g+64c
         WKDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681565896; x=1684157896;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lfwoIWq66HClk6b22JLSOioQxz/ZJ0/vIYhJq+Ag21Y=;
        b=Po73tkqjLNjzdEfDM1mOAQR1kmA9Jr8Ps0tsekcVSfw2OtmAnbxb2k45JldzLFx2+u
         QZtNv9mbIHhdilUiuQmxPmDF44JLGfSb4ynZ16hiDQJNCMm1tpefivJ3db7cqP/JQOF5
         5/bSePXfMiEMyE1kQDTHOfAGOOgoyrNGIZS9apJjoUK3Y5c1fIcnb5KNSb2ojb/O3zWx
         YPvmhRLxucqNAvDJeysJ3RD4gPv7hAJtStl6hNicrTLmoZQ9k0mfYGgmSNRlcXWcvO+n
         XZidEIfNvwB9xHjBYcodfNfLsVWIXm8za+de1SGhgluFEVO3aDlmsfrUzTr9yksmbDxv
         HReA==
X-Gm-Message-State: AAQBX9e7hadxZ09dDCsOLOYElJQfGWzhHWO6eN3EM30cT1NTONhbSsV9
        PFWlDdYNzK5/gkMiEKmrajk=
X-Google-Smtp-Source: AKy350ZZU6+jlCrYCWj69EZwW7+/jEDEgY8P4JXdAjujfZAhI/BSfUjvCFYR9A4Lces7fPaiFRioFg==
X-Received: by 2002:a05:6402:14c6:b0:504:9b06:fec7 with SMTP id f6-20020a05640214c600b005049b06fec7mr8291868edx.37.1681565896265;
        Sat, 15 Apr 2023 06:38:16 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id ld4-20020a1709079c0400b0094eaa31aa63sm3620385ejc.77.2023.04.15.06.38.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Apr 2023 06:38:15 -0700 (PDT)
Date:   Sat, 15 Apr 2023 16:38:13 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     Daniel Golle <daniel@makrotopia.org>,
        Frank Wunderlich <frank-w@public-files.de>,
        netdev <netdev@vger.kernel.org>, erkin.bozoglu@xeront.com,
        Thibaut <hacks@slashdirt.org>
Subject: Re: mt7530: dsa_switch_parse_of() fails, causes probe code to run
 twice
Message-ID: <20230415133813.d4et4oet53ifg2gi@skbuf>
References: <896514df-af33-6408-8b33-d8fd06e671ef@arinc9.com>
 <ZDnYSVWTUe5NCd1w@makrotopia.org>
 <e10aa146-c307-8a14-3842-ae50ceabf8cc@arinc9.com>
 <ZDnnjcG5uR9gQrUb@makrotopia.org>
 <5e10f823-88f1-053a-d691-6bc900bd85a6@arinc9.com>
 <ZDn1QabUsyZj6J0M@makrotopia.org>
 <01fe9c85-f1e0-107a-6fb7-e643fb76544e@arinc9.com>
 <ZDqb9zrxaZywP5QZ@makrotopia.org>
 <9284c5c0-3295-92a5-eccc-a7b3080f8915@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9284c5c0-3295-92a5-eccc-a7b3080f8915@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 15, 2023 at 04:19:46PM +0300, Arınç ÜNAL wrote:
> While speaking here, let's discuss what should be considered probing.
> 
> One thing that complicates this is that the MT7530 switch has got a unique
> feature, PHY muxing. I want to be able to use this feature without
> registering the switch at all. And that requires the switch to be at least
> reset.

All DSA switch drivers end their probing with a successful call to
dsa_register_switch(). I would appreciate if you wouldn't start adding
exceptions to that.
