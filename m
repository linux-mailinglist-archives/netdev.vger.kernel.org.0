Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F29DD6D0878
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 16:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232148AbjC3Oka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 10:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231322AbjC3Ok2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 10:40:28 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11B486583;
        Thu, 30 Mar 2023 07:40:25 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id gp15-20020a17090adf0f00b0023d1bbd9f9eso22216858pjb.0;
        Thu, 30 Mar 2023 07:40:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680187224;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=FY+SKBw7Qws18lttqqyOjOtRuuw+3DmhSxmnLbT/52w=;
        b=PhBx0T8X/JnR4d0ibxFzbJ44GRdXpGaCriPHRVrFr01ZlATYTI9SVbj6qxuZQmzsAr
         ARslTQDGsKfwH8CMWEXU9r/fT1HkOGRXdkQVbj+2QpU0uge/dbsyXpfaepcTEceG3Myf
         6ytEbobn8m2E336ztDazWRrcXHIzU4ou4iioqaiPfwbIwpAiSSxkOZVC6bGVQzS0faoF
         GYd47aNw3EWA6lGSS4RCkmT+glMtltOTgQjW4gF3sDBeAPo73DQxLUN+dfFGLuOS0JpG
         yHxSa9+KYEehJnn8reyn3Yuy4J/cu1WsXVnRmcKacEPZB4h82wbeZ5evarjgwbFze/X9
         HqGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680187224;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FY+SKBw7Qws18lttqqyOjOtRuuw+3DmhSxmnLbT/52w=;
        b=7Sv3j33ctpmJ41dDavQwdCL50xuusVs1FqGbj0Oiwy8U9zuRI2h5CkH+v/7Y02mij/
         e4ek7PTGM2FhIb8U916OheRSxs+ANIoyz6a6xD7eHm0kKg+CNmDjlA8d2hmGK0itIPUZ
         8jkxj/BxXDZ/6RilzamqdIaEv0xkwzyvKBv6rPsiOH3WUjxkIbCeiH94EIW7Cb6adhno
         QDCT9i7tZ+p8jZTbQmQhTHZuW3GPJDj9CSHcrBYsN3Jsmoyk/P4wNfxDklJU0Jml/mvH
         bVdNREbMcoT6I/w+7hN7C+ar5wfVlosWnE2CInKBGUmyc838UvheT2nskItfyRZJxYAm
         k+0A==
X-Gm-Message-State: AO0yUKXC4HT1GFPzUnUuZncqhxekIBNG2uLJzHbm2Y3CJBpG0BTd5tEp
        xw7TCcuC5dL7w+OZ8U/e630=
X-Google-Smtp-Source: AK7set9FV3bbfuxtVRPrY/z2/LfXKixW3w6DLZaeN9utJpucgU4ShkHeuaprtv9cthsxTNiXKg19cQ==
X-Received: by 2002:a05:6a20:be0a:b0:d6:a2f9:ca9a with SMTP id ge10-20020a056a20be0a00b000d6a2f9ca9amr20431667pzb.42.1680187224450;
        Thu, 30 Mar 2023 07:40:24 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id y17-20020aa78051000000b006288ca3cadfsm7284185pfm.35.2023.03.30.07.40.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 07:40:24 -0700 (PDT)
Date:   Thu, 30 Mar 2023 17:40:09 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?utf-8?Q?Miqu=C3=A8l?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        Arun Ramadoss <Arun.Ramadoss@microchip.com>,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexis Lothore <alexis.lothore@bootlin.com>
Subject: Re: [PATCH RESEND net-next v4 3/3] net: dsa: rzn1-a5psw: add vlan
 support
Message-ID: <20230330144009.3lqsqt7h5qc7siuw@skbuf>
References: <20230314163651.242259-1-clement.leger@bootlin.com>
 <20230314163651.242259-4-clement.leger@bootlin.com>
 <20230314163651.242259-4-clement.leger@bootlin.com>
 <20230314233454.3zcpzhobif475hl2@skbuf>
 <20230315155430.5873cdb6@fixe.home>
 <20230324220042.rquucjt7dctn7xno@skbuf>
 <20230328104429.5d2e475a@fixe.home>
 <20230328104429.5d2e475a@fixe.home>
 <20230329131613.zg4whzzoa4yna7lh@skbuf>
 <20230330110959.2132cd07@fixe.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230330110959.2132cd07@fixe.home>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 30, 2023 at 11:09:59AM +0200, Clément Léger wrote:
> Yes indeed, and we noticed the handling of VLANVERI and VLANDISC in
> vlan_filtering() should be set according to the fact there is a PVID or
> not (which is not the case right now).

I was thinking the other way around, that the handling of
VLAN_IN_MODE_ENA should be moved to port_vlan_filtering().

The expected behavior relating to VLANs is documented in the "Bridge
VLAN filtering" section of Documentation/networking/switchdev.rst btw.
