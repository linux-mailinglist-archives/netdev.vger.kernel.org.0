Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 779715A8237
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 17:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231325AbiHaPvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 11:51:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231226AbiHaPvJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 11:51:09 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23CD5A00FB
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 08:51:08 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id y3so29287877ejc.1
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 08:51:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=8YXY7kgcCtlxEkuep5vzMOjNh6z7ODopnaBrOHxrTC4=;
        b=h+WPwNZYU3rEtRvyqj4ThKglx/jFTlzmkV0+Ofhx5o2UUF0uHluzf2B1yFksmI3IAI
         UGizuvIBSfEWHEGv0Xp98l5QMD4xjHY0OcHOZwkGV+NYK2ndpULGEdHXgEzl2dasOXPa
         0BB7wvfTyvMIB1Z1KAJaWQKfbM9KdblMP1TySCX2mr3I9D/XHnrYRbFvJSdLBkf+FKGi
         kt/ggXNyHDnumMF2TCDIWg5pp2q6ONXkvkNirEW/+v9xuYJC5/nVXZcPElPScqGoW0/g
         jUCni0vnyGYPGE5cMPRn8avy6RLn7HVoAZN6piFgcKf7VV7rvNNToiXzhVxSL66P3Gr1
         LfWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=8YXY7kgcCtlxEkuep5vzMOjNh6z7ODopnaBrOHxrTC4=;
        b=P+ftk1puZU7kV7ir4ZwZNMjTHrxSctfu49jBfAaB4Kgxnj3wr0JKMkVvqSZ5jKFjfV
         un17CiHLrGwdKoTT6iz5TwvXr+71+CCa4fDcunuZBw/v1RxFfoLOm2g7QmU20O1nZrv/
         myedivKGRR/iuSbIY8kH4c/Yv+CyzLNwqQOBMzwZBOkt5ZzmcPSFkFAXvBnvLnvc8gIj
         eSkkhTnOE+PJZnWEZCRCFiTzT/16OmAEOv9G5J3n/e228bVtRT4ShQMikWOYYIzBba7o
         KcAzo887sXmNYG5DVBr6Hte1p49TgVSxkc+BDSwuP0Ab8FQvIk0IykAB4Hk2YXawoelx
         f2yA==
X-Gm-Message-State: ACgBeo1aso3aSkAe3OvcynhMjTUcRh1eTJ2HaQw+tzJOqXzM6DwW1vZl
        g0TvaMyIo5u0PBwNZoJ2Xu0=
X-Google-Smtp-Source: AA6agR4M8ntdHyfj8dsJi4q19vQvMTXxVNyjQx0j6LztmoVE+p5H4VsFc/J1W5SUBZKJD9nMU2wBmQ==
X-Received: by 2002:a17:906:99c1:b0:6fe:b01d:134 with SMTP id s1-20020a17090699c100b006feb01d0134mr20337438ejn.598.1661961066673;
        Wed, 31 Aug 2022 08:51:06 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id fh10-20020a1709073a8a00b007307d099ed7sm7188562ejc.121.2022.08.31.08.51.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 08:51:05 -0700 (PDT)
Date:   Wed, 31 Aug 2022 18:51:03 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Romain Naour <romain.naour@smile.fr>
Cc:     netdev@vger.kernel.org, linux@armlinux.org.uk, pabeni@redhat.com,
        kuba@kernel.org, edumazet@google.com, davem@davemloft.net,
        f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        UNGLinuxDriver@microchip.com, woojung.huh@microchip.com,
        Romain Naour <romain.naour@skf.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>
Subject: Re: [PATCH v2 1/2] net: dsa: microchip: add KSZ9896 switch support
Message-ID: <20220831155103.2v7lfzierdji3p3e@skbuf>
References: <20220830075900.3401750-1-romain.naour@smile.fr>
 <20220831153804.mqkbw2ln6n67m6jf@skbuf>
 <e7ba61d7-de75-3cfe-ee92-3f234dd36289@smile.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e7ba61d7-de75-3cfe-ee92-3f234dd36289@smile.fr>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 31, 2022 at 05:43:27PM +0200, Romain Naour wrote:
> The patch was runtime tested on a 6.0-rc2 kernel and a second time on a 6.0-rc3
> kernel but not on net-next.
> 
> Is it ok with rc releases or do I need to test on net-next too?

The kernel development process is that you normally test a patch on the
git tree on which it is to be eventually applied.

The net-next.git tree is periodically (weekly) merged with the 6.0
release candidates where bug fixes land, but it contains newly developed
material intended for the 6.1 release candidates (hence the "next" name).

If you keep formatting development patches against the plain 6.0 release
candidates, you may eventually run into a conflict with some other new
development, and you may never even know.
