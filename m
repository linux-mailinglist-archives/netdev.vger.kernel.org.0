Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87D324CD9E3
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 18:14:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240938AbiCDRPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 12:15:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240943AbiCDRPU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 12:15:20 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A02A1B3708
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 09:14:32 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id w16so18116205ybi.12
        for <netdev@vger.kernel.org>; Fri, 04 Mar 2022 09:14:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ip+ao6k+ZndAM1FQFLo0WeRgyK3IKbG/PSwwUjybTVo=;
        b=TsBust4lk2f6NZXH2fLvUXt0jm1wMZTsR4NtgiCDQn95SYuMU7HdYM1N0D2U0295DQ
         qoDifyY/DnQBFfq0kdtdhPyF4JUWzDkAiXW+Jg1QkQH+FuBUV6iNEmCh5L106aDn/31K
         CALHm/04yzgXUQ4WeyHlE4tCWue/93rL2kDEOd9VHN8PKZ97CZidSQg2rIw+D0x94cPx
         oon/AlPMeSKnWKNiqpl4wTKvltjrlkMAlNA6Yh7t0eG+NaykE3Ho9w9dshQ9Gmt1cpNN
         p7hzJVCKFT39i3Hi66N1cxZa5HZKSMZGGvQxGoICvS12TgvJ94Ye9huGWRiYbOOdEwZh
         Cn7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ip+ao6k+ZndAM1FQFLo0WeRgyK3IKbG/PSwwUjybTVo=;
        b=7A8tt+Xzvzkn5IIpCmhionXt9HXE5IhtVp16X/55HwB16ZZAC7ALiT1jc+9p5EPqMi
         Hk12zYoerNKio72Xkp5VS2+IVz59CdHLvAFI4OUnCTEvB/A3XEHE80wYnYyMpk8Cr8J/
         +X9zv3DY5V8nKdgFjTThtDtLsbL4MSCHwxed4xZKdN/0FDcEhMIfdZjv9h/GYykQ67Tn
         vIHZcckYxQqKJBSvTU5ARiRcCByAibp1+02ufz+e6AeGu12rea8wYE3Vfq0csaKjaDaR
         Vfio0xZZ3Yz8yG1o1j5SgrnQu+3s76+izoroCDWEulHc2k0stPSFrXefi/dARbmU+DzC
         BZxA==
X-Gm-Message-State: AOAM532lo2uF+X8bFBPxsb5rENWMENkaPgNiKRgHUbaJqu1Zg9bX9Z9n
        dYM49z1hUaRvk0sIqlmr6ZhdjLcFTR845wBNSQn/gBJurj8=
X-Google-Smtp-Source: ABdhPJwhlqqjXXdUEAQdWRn3PBvMLQVCxOtLHC1vh1Ho+bU+ArA1thkesypOCUbmAd/3b04q8Nd+HYp43olYYsk6DvI=
X-Received: by 2002:a25:f45:0:b0:628:b4c9:7a9f with SMTP id
 66-20020a250f45000000b00628b4c97a9fmr11151905ybp.55.1646414070808; Fri, 04
 Mar 2022 09:14:30 -0800 (PST)
MIME-Version: 1.0
References: <20220303181607.1094358-1-eric.dumazet@gmail.com>
 <20220303181607.1094358-15-eric.dumazet@gmail.com> <c9f5c261-c263-a6b4-7e00-17dfefd36a7a@kernel.org>
In-Reply-To: <c9f5c261-c263-a6b4-7e00-17dfefd36a7a@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 4 Mar 2022 09:14:19 -0800
Message-ID: <CANn89iJKEV6Y+2mY1Gs_zJTrnm+TTXOHoW_D3AWYE0ELijrm+w@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 14/14] mlx5: support BIG TCP packets
To:     David Ahern <dsahern@kernel.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 3, 2022 at 8:43 PM David Ahern <dsahern@kernel.org> wrote:
>
> On 3/3/22 11:16 AM, Eric Dumazet wrote:
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > index b2ed2f6d4a9208aebfd17fd0c503cd1e37c39ee1..1e51ce1d74486392a26568852c5068fe9047296d 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> > @@ -4910,6 +4910,7 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
> >
> >       netdev->priv_flags       |= IFF_UNICAST_FLT;
> >
> > +     netif_set_tso_ipv6_max_size(netdev, 512 * 1024);
>
>
> How does the ConnectX hardware handle fairness for such large packet
> sizes? For 1500 MTU this means a single large TSO can cause the H/W to
> generate 349 MTU sized packets. Even a 4k MTU means 128 packets. This
> has an effect on the rate of packets hitting the next hop switch for
> example.

I think ConnectX cards interleave packets from all TX queues, at least
old CX3 have a parameter to control that.

Given that we already can send at line rate, from a single TX queue, I
do not see why presenting larger TSO packets
would change anything on the wire ?

Do you think ConnectX adds an extra gap on the wire at the end of a TSO train ?
