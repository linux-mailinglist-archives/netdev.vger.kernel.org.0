Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2ED934362B
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 02:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbhCVBQs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 21:16:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbhCVBQk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 21:16:40 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A0CCC061574
        for <netdev@vger.kernel.org>; Sun, 21 Mar 2021 18:16:40 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id m7so7567747pgj.8
        for <netdev@vger.kernel.org>; Sun, 21 Mar 2021 18:16:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=R0gSJ7USoh3JXMjTvFTQOupDMzvtxPeR+7V/pxtsTOc=;
        b=HGnhqItLGpj1J1TKe6HO/Hq+U4WNsjtlB+HPmnYiy56DpnJXuFoA2tSwRIWNNiLAy+
         Vd0z9T0ciFOOOqGaPukwwmN9d++4VA04EbNW+spSXjRa9uR1JTwqMmlYNFseCzNyN7Og
         mtyIjQg3PItRdYvGTeuzc9fQtJDueITeeChsrbWNx00px3mTZxdEn33QWCZ8l3OxsvvB
         bptzzWedVj5znM9j68hbou42YHBIQowYW+6NYFjEIlfqr6Re7QTgSg3g32cNReGa3Sr5
         vmSDkDBRgvq57ZzbAJ6ZvW27OsFjE57j6n0hdBVqGlDyi4ksy21cjld61BZ9KtkB4Q5K
         DQew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=R0gSJ7USoh3JXMjTvFTQOupDMzvtxPeR+7V/pxtsTOc=;
        b=X4FMwofptWe0uO9bsDDVN8bUEg95UY4FvuJDnjWg3YKpGGYlV7DY9ti3gNYIi5lVhL
         Qr5MJ8GAIrPsFk8u2voKoTTjSBrkLOS8sRSj0BMB8CCpfRsxJOUI5SPi8kghqmaJPdOc
         eJRRlKfNdQ646PQCndZ+MyH4wPJEtMP/n2DTHbElhg1aNRJuT6ZxEQAByH9jMtnLCBRU
         BPkN56QW6ZGnMIPOympA+h0CRf54sdZ2izj2+okcJ+xyB2vD6Iztm5ZAvvvCgnYNZBoy
         vqLwg5calU12/7v/vPZvoP7i16siuMPTkyagGLJ0upMCParPjl1BcLeNp1ubLCEGMIiw
         28hw==
X-Gm-Message-State: AOAM5327FO33yqRyMuNfzYOCaHlqaip0XqBU7+PMzAnup5+WhJVJE+6X
        6KJDZa8iwRXbeDZ0GmV+QRdfgDJJAQsVEg==
X-Google-Smtp-Source: ABdhPJw4UTsZIL9DoyAKmC+yPr5khs4+xyjdkTXLOiNyTTbHA5HzrOK1oV0x6/y238EU52U64L6KRg==
X-Received: by 2002:aa7:9246:0:b029:1ed:cfa4:f1a8 with SMTP id 6-20020aa792460000b02901edcfa4f1a8mr19318538pfp.73.1616375799574;
        Sun, 21 Mar 2021 18:16:39 -0700 (PDT)
Received: from Leo-laptop-t470s ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j2sm10683567pgh.39.2021.03.21.18.16.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Mar 2021 18:16:39 -0700 (PDT)
Date:   Mon, 22 Mar 2021 09:16:28 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Petr Machata <petrm@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Guillaume Nault <gnault@redhat.com>
Subject: Re: [PATCH net] selftests: forwarding: vxlan_bridge_1d: Fix vxlan
 ecn decapsulate value
Message-ID: <20210322011628.GC2900@Leo-laptop-t470s>
References: <20210319143314.2731608-1-liuhangbin@gmail.com>
 <YFeAdxAOYcx3CMYJ@shredder.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YFeAdxAOYcx3CMYJ@shredder.lan>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 21, 2021 at 07:20:55PM +0200, Ido Schimmel wrote:
> On Fri, Mar 19, 2021 at 10:33:14PM +0800, Hangbin Liu wrote:
> > The ECN bit defines ECT(1) = 1, ECT(0) = 2. So inner 0x02 + outer 0x01
> > should be inner ECT(0) + outer ECT(1). Based on the description of
> > __INET_ECN_decapsulate, the final decapsulate value should be
> > ECT(1). So fix the test expect value to 0x01.
> > 
> > Before the fix:
> > TEST: VXLAN: ECN decap: 01/02->0x02                                 [FAIL]
> >         Expected to capture 10 packets, got 0.
> > 
> > After the fix:
> > TEST: VXLAN: ECN decap: 01/02->0x01                                 [ OK ]
> > 
> > Fixes: a0b61f3d8ebf ("selftests: forwarding: vxlan_bridge_1d: Add an ECN decap test")
> > Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> 
> Fixes: b723748750ec ("tunnel: Propagate ECT(1) when decapsulating as recommended by RFC6040")
> 
> The commit you cited is from 2018 whereas this one is from 2020. The
> test stopped working after the latter. The reason I didn't see it is
> because this commit only changed one caller of __INET_ECN_decapsulate().
> Another caller is mlxsw which uses the function to understand how to
> program the hardware to perform decapsulation. See commit 28e450333d4d
> ("inet: Refactor INET_ECN_decapsulate()").

Hi Ido,

Thanks for this info. I don't have mlxsw card in hand, so I never
run the driver test before.

Cheers
Hangbin

> 
> After your patch I get:
> 
> TEST: VXLAN: ECN decap: 01/02->0x01                                 [FAIL]
>         Expected to capture 10 packets, got 0.
> 
> Fixed by:
> 
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
> index b8b08a6a1d10..61eb34e20fde 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
> @@ -341,7 +341,12 @@ static int mlxsw_sp_ipip_ecn_decap_init_one(struct mlxsw_sp *mlxsw_sp,
>         u8 new_inner_ecn;
>  
>         trap_en = __INET_ECN_decapsulate(outer_ecn, inner_ecn, &set_ce);
> -       new_inner_ecn = set_ce ? INET_ECN_CE : inner_ecn;
> +       if (set_ce)
> +               new_inner_ecn = INET_ECN_CE;
> +       else if (outer_ecn == INET_ECN_ECT_1)
> +               new_inner_ecn = INET_ECN_ECT_1;
> +       else
> +               new_inner_ecn = inner_ecn;
>  
>         mlxsw_reg_tidem_pack(tidem_pl, outer_ecn, inner_ecn, new_inner_ecn,
>                              trap_en, trap_en ? MLXSW_TRAP_ID_DECAP_ECN0 : 0);
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c
> index e5ec595593f4..74f2c4ce7063 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c
> @@ -913,7 +913,12 @@ static int __mlxsw_sp_nve_ecn_decap_init(struct mlxsw_sp *mlxsw_sp,
>         u8 new_inner_ecn;
>  
>         trap_en = !!__INET_ECN_decapsulate(outer_ecn, inner_ecn, &set_ce);
> -       new_inner_ecn = set_ce ? INET_ECN_CE : inner_ecn;
> +       if (set_ce)
> +               new_inner_ecn = INET_ECN_CE;
> +       else if (outer_ecn == INET_ECN_ECT_1)
> +               new_inner_ecn = INET_ECN_ECT_1;
> +       else
> +               new_inner_ecn = inner_ecn;
>  
>         mlxsw_reg_tndem_pack(tndem_pl, outer_ecn, inner_ecn, new_inner_ecn,
>                              trap_en, trap_en ? MLXSW_TRAP_ID_DECAP_ECN0 : 0);
> 
> I will prepare a patch
