Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 661F64B32BE
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 03:41:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230353AbiBLClr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 21:41:47 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:51464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiBLClr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 21:41:47 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21EE92982D
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 18:41:45 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id o19so29991773ybc.12
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 18:41:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MlPkl0/j4A968F1UOGz1btEHXruRjrJ+twnpMqIBKuc=;
        b=XmPSFJiZYJdorHslig0aAnDifJeFO7Ui/9hV4k/eKk47vfIocAIj0s4WDw+RWz9AUy
         IMJVjT7X0XZzGqlmkmvOcjJ0L1/9Q56wn7RTGW+TjzSHBxuO/8mTeoSSHNsBm0AMqdwF
         iJ86Pm7IfAD4Ajy4GFbmHYVHhJiaXhDZCXf98/f6shPEp3xVv1kYHZt1lL3xz5a+O8L8
         6PZJNd6ADISnGKGunYrZa/d5D/9jZAH48o9LKqFOGv36VTsVDbsDZ0N9dTdosqoly6Mt
         wL5jti0XzPYTXjw/SDyz5gZYvleN++c+ag+zzTaMjfT+iy9VZ1KCtKvEsXPa6E9m3Lme
         sbzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MlPkl0/j4A968F1UOGz1btEHXruRjrJ+twnpMqIBKuc=;
        b=KWOXHxbkbc2X5O7+JChKzS7TUu2cWD0MurTn5DN4AXFkF+3dqEgJx4ZEnTfDBWlP05
         ogapTFYnk2MnhjRYGBuSTc0aKdaov/ifAY8xznGSw4lV70oykf6H440bfJoNP6y+B1Ia
         madUnjvTx/brz6BM2t4i/hEcSViD/3c0ymMF0qOu/M2QuqnkOMu9lELwfBDWvBt7Jb8a
         AZzD+o3RAsM/NLoeMqcH5S2hciv1r0vpQ2S7INcXcqHJJB+1G44Xtj5w6ejI8E/6COAE
         I4JOGR6XdmyIqIzRwZdTAMfoRe29U3w2iKpn8ku+ARp4cv7kvWBjzOQbhlvnqfIMUdb7
         omuQ==
X-Gm-Message-State: AOAM532vjg4iUYVL50UHbDeTSWPFEuaexAVi794ziPatCrTcsSthvlDV
        TPQvEb0DlYC0Vi089CS//AtAe19hT23/k/Ki1po4hQ==
X-Google-Smtp-Source: ABdhPJxCrqQAM0RtbCh+j48i1wq+HUZGjDW46/p5m1BgKtG4jEC0xZ/hsik2mkNMZ3f3k3n2VXfewpcGR67jzSm8k6o=
X-Received: by 2002:a25:e7d6:: with SMTP id e205mr894092ybh.277.1644633704076;
 Fri, 11 Feb 2022 18:41:44 -0800 (PST)
MIME-Version: 1.0
References: <20220210175557.1843151-1-eric.dumazet@gmail.com>
 <20220210175557.1843151-5-eric.dumazet@gmail.com> <20220211141624.14d6f4ac@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220211141624.14d6f4ac@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 11 Feb 2022 18:41:33 -0800
Message-ID: <CANn89iJy+__9r9h0HGuy7s=P915EEGOMHvqrcp_rvzqnrsbBpg@mail.gmail.com>
Subject: Re: [PATCH net-next 4/4] net: introduce a config option to tweak MAX_SKB_FRAGS
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>
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

On Fri, Feb 11, 2022 at 2:16 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 10 Feb 2022 09:55:57 -0800 Eric Dumazet wrote:
> > From: Eric Dumazet <edumazet@google.com>
> >
> > Currently, MAX_SKB_FRAGS value is 17.
> >
> > For standard tcp sendmsg() traffic, no big deal because tcp_sendmsg()
> > attempts order-3 allocations, stuffing 32768 bytes per frag.
> >
> > But with zero copy, we use order-0 pages.
>
> If I read this right BIG TCP works but for zc cases, without this patch,
> but there's little point to applying this patch without BIG TCP.
>
> Shouldn't the BIG TCP work go in first and then we'll worry about how
> many frags can each skb carry?

This is orthogonal really.

My guess is that most people do not use TCP RX zerocopy, apart from Google ?
