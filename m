Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B73A4AB4EB
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 07:41:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbiBGGbK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 01:31:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350287AbiBGFwj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 00:52:39 -0500
Received: from mail-ua1-x929.google.com (mail-ua1-x929.google.com [IPv6:2607:f8b0:4864:20::929])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52EC1C043181
        for <netdev@vger.kernel.org>; Sun,  6 Feb 2022 21:52:38 -0800 (PST)
Received: by mail-ua1-x929.google.com with SMTP id w21so21007066uan.7
        for <netdev@vger.kernel.org>; Sun, 06 Feb 2022 21:52:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L1Rjq/ql7urNH275JgtjOWwPnTNap7zuvbeGPfxz5dk=;
        b=tL/3b03W+JH4On8JGgN+G47JSKM16N+ZylsEH2Q+KcbF0UWlZPv6twnFjWKgw5c0dF
         AvSIKFiZATE9/oAob2ijdRc1Kvnqf/qJTUmhLSPzDBwdKuDPH7TBiAmt2ZWaB1F8RRSr
         R1IRIEZInH/VzkMCFE0KgWXm7hR5RApKseRzY6riVWkK3gF2bCMQxZTvmUvjjuY88xgg
         8nTdCkJN+nLW23abPt/7Q2A5f2KvTK04HrBn8aDNUi0j1g4xgljEsxxCFDBd2X30xdG5
         NB/Vc51Zu2B8j2nCo1L8+Porb2szl7slQXrXqcRpTcmIS+vT7jCk9/34VbA5IRiqdBbQ
         GhDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L1Rjq/ql7urNH275JgtjOWwPnTNap7zuvbeGPfxz5dk=;
        b=1MPUGWHoXoLYWY++MIOHFG1Cx3vjVWTL2wX9pVwmJFcp7W0iKEKwalGNYINdzzMEDa
         ESLcza1DnpnuM1QNGGV55BiB0WKLoDywp2lUhOQVJodtGs5lrJh+zu521vfJvs4Zrsbx
         gf/uHzvZydtqHpgVlS1h6KtmAXljfddoOyk8tOqrZQwaOyPhTmmoBvSNixoID9US/j2d
         4LOin+74XOOS2mnYTzUNKNMCk9QbUVKkSGvfl+r3QFfyJ5LqYdbXkgNlOTvl08iM5UTv
         TAHQxyycWwCVCGhY7UEc47IQ+/YvCN9QSiVKOxDMGGZ3dCppPIxHbddpC6Fk+SvVp3TD
         hZIA==
X-Gm-Message-State: AOAM5329m550gGd4qTXugMI2BdbmoHzxXNEyVVGaMCwwZHvPYsN9jtqP
        XtT4ToCmhb4fvzB2t0LnSpiPC2my2+Tn5kabpVmI2A==
X-Google-Smtp-Source: ABdhPJyQMFft69kTngWJY32onjRKjzuIa9UTH3B/P0UB3PJj3eviBJJrXE/Du+TXKVjNBDKiDhHQNyBcATIz/FNM3y0=
X-Received: by 2002:a9f:36c1:: with SMTP id p59mr2814471uap.41.1644213157165;
 Sun, 06 Feb 2022 21:52:37 -0800 (PST)
MIME-Version: 1.0
References: <20220204000653.364358-1-maheshb@google.com> <20792.1643935830@famine>
 <20220204195949.10e0ed50@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220204195949.10e0ed50@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?= 
        <maheshb@google.com>
Date:   Sun, 6 Feb 2022 21:52:11 -0800
Message-ID: <CAF2d9jjLdLjrOAwPR8JZNPTNyy44vxYei0X7NW_pKkzkCt5WSA@mail.gmail.com>
Subject: Re: [PATCH v3 net-next] bonding: pair enable_port with slave_arr_updates
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jay Vosburgh <jay.vosburgh@canonical.com>,
        Netdev <netdev@vger.kernel.org>,
        Andy Gospodarek <andy@greyhouse.net>,
        Veaceslav Falico <vfalico@gmail.com>,
        David Miller <davem@davemloft.net>,
        Mahesh Bandewar <mahesh@bandewar.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 4, 2022 at 7:59 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 03 Feb 2022 16:50:30 -0800 Jay Vosburgh wrote:
> > Mahesh Bandewar <maheshb@google.com> wrote:
> >
> > >When 803.2ad mode enables a participating port, it should update
> > >the slave-array. I have observed that the member links are participating
> > >and are part of the active aggregator while the traffic is egressing via
> > >only one member link (in a case where two links are participating). Via
> > >krpobes I discovered that that slave-arr has only one link added while
>
> kprobes
> that that
>
> The commit message would use some proof reading in general.
>
:( will fix the typo and send it to you again.

> > >the other participating link wasn't part of the slave-arr.
> > >
> > >I couldn't see what caused that situation but the simple code-walk
> > >through provided me hints that the enable_port wasn't always associated
> > >with the slave-array update.
> > >
> > >Signed-off-by: Mahesh Bandewar <maheshb@google.com>
> >
> > Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
>
> Quacks like a fix, no? It's tagged for net-next and no fixes tag,
> is there a reason why?

Though this fixes some corner cases, I couldn't find anything obvious
that I can report as "fixes" hence decided otherwise. Does that make
sense?

thanks,
--mahesh..
