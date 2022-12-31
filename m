Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01A2A65A4B9
	for <lists+netdev@lfdr.de>; Sat, 31 Dec 2022 14:48:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231878AbiLaNsV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Dec 2022 08:48:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbiLaNsT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Dec 2022 08:48:19 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BA601142
        for <netdev@vger.kernel.org>; Sat, 31 Dec 2022 05:48:18 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id v126so26119236ybv.2
        for <netdev@vger.kernel.org>; Sat, 31 Dec 2022 05:48:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=M0gxGo5FKSspdJgFZkMBTdJlwn5nvz9+Wm7JP5MsIP4=;
        b=dTZnuK6HzXpDAtzjkHzIDNdtexNhUFytsA8NmxWTzpPkPoFchDfcxoz7u0G8dVXvtz
         rTDjp8H0g4Uy558HxVzCy5vzFznONp7C+/zVL13iU1ZpUw1Lx4BikEE0RqJ3BXAVI2tT
         nkFqRAKJ0uv1M21mccxjk+ukyCSTN/ojCxCx3vl8RwnnkXtHjwJK3frhzdcwlNXkS13C
         9yUYkpmMNUZ2dNPo/J8ylsL/YVO7MvbfdvTXgUen6ldvQnMy/f7YEU1qQ/AWl8j1Re/7
         q1Z5S72/EFcKThEES5IgOHZr3yY151BTsgK099KOIo2oaQ3HCSTglhEOhQXaAcpc5lEp
         HAeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M0gxGo5FKSspdJgFZkMBTdJlwn5nvz9+Wm7JP5MsIP4=;
        b=ubFVJYQcee/cS6Ywz8nlcIF/eQXzLaJZOix/snXoq2t/35zrFb25TauTgtKm8qinso
         zC8rDOwY/ZIMU7mmxd9cy3hVh2SnKU4gt8jA4p/mjuwDj7PmTPgQl0gFAWMVGbEcdxVB
         RtO+RbSVzuHhmj1IVX4EvxXffXFLrErXU+in1yD3dDUrfPMabrSoNNlyJjDOA1AL6FHS
         1r+2vdQA4D1MF+BRZgwBSwQTiY6PCRx8s5ojJiOOYo4VznKd29BmHCXomsSFOjw8Z7/J
         3xCRzAP9UNnpCDZ5miHx6+bJ4rYvgk2iFox8h8SmWfhUBDw2xEMy+YgkRFAHaYo1Dvw9
         bMAg==
X-Gm-Message-State: AFqh2kpzs7Ep0fRrR74gblDp3TG/joi+JUqNsECIbmVTm0L9Nhru4BfW
        j/EN+AlwGCfPYLkadcUPgB2WqYdogq3CUwpua4xCpw==
X-Google-Smtp-Source: AMrXdXuid8UHX6m9tYBU8D9aePwjTLEhYmPLdwpbhNup/Ohuqvp61ZUUMQqI/7fE+cbqqDUr3lwrkCHKC/SyzwUU5Jk=
X-Received: by 2002:a25:7910:0:b0:6f6:e111:a9ec with SMTP id
 u16-20020a257910000000b006f6e111a9ecmr2582928ybc.259.1672494497665; Sat, 31
 Dec 2022 05:48:17 -0800 (PST)
MIME-Version: 1.0
References: <20221221093940.2086025-1-liuhangbin@gmail.com>
 <20221221172817.0da16ffa@kernel.org> <Y6QLz7pCnle0048z@Laptop-X1>
 <de4920b8-366b-0336-ddc2-46cb40e00dbb@kernel.org> <Y6UUBJQI6tIwn9tH@Laptop-X1>
 <CAM0EoMndCfTkTBhG4VJKCmZG3c58eLRai71KzHG-FfzyzSwbew@mail.gmail.com>
 <Y6ptX6Sq+F+tE+Ru@Laptop-X1> <CAM0EoM=rMPpXEs6xdRvfJtXFo8OjtGiOOMViFuWR7QiRQfx7DA@mail.gmail.com>
 <Y6wBLyUfRT2p/6UJ@Laptop-X1>
In-Reply-To: <Y6wBLyUfRT2p/6UJ@Laptop-X1>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Sat, 31 Dec 2022 08:48:06 -0500
Message-ID: <CAM0EoMmeD=D7rVLnmvyyuAzvS6cL5ep+K29=EzwxcrwpJToMcQ@mail.gmail.com>
Subject: Re: [PATCHv2 net-next] sched: multicast sched extack messages
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Vlad Buslov <vladbu@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sounds good to me.

cheers,
jamal

On Wed, Dec 28, 2022 at 3:41 AM Hangbin Liu <liuhangbin@gmail.com> wrote:
>
> On Tue, Dec 27, 2022 at 11:23:23AM -0500, Jamal Hadi Salim wrote:
> > Hi Hangbin,
> >
> > On Mon, Dec 26, 2022 at 10:58 PM Hangbin Liu <liuhangbin@gmail.com> wrote:
> > >
> > > Hi Jamal,
> > > On Mon, Dec 26, 2022 at 11:31:24AM -0500, Jamal Hadi Salim wrote:
> > > > My only concern is this is not generic enough i.e can other objects
> > > > outside of filters do this?
> > > > You are still doing it only for the filter (in tfilter_set_nl_ext() -
> > > > sitting in cls_api)
> > > > As i mentioned earlier, actions can also be offloaded independently;
> > > > would this work with actions extack?
> > > > If it wont work then perhaps we should go the avenue of using
> > > > per-object(in this case filter) specific attributes
> > > > to carry the extack as suggested by Jakub earlier.
> > >
> > > Yes, I think we can do it on action objects, e.g. call tfilter_set_nl_ext()
> > > in tca_get_fill:
> > >
> > > tcf_add_notify() - tca_get_fill()
> > >
> > > I will rename tfilter_set_nl_ext() to tc_set_nl_ext(). BTW, should we also
> > > do it in qdisc/ class?
> > >
> > > tclass_notify() - tc_fill_tclass()
> > > qdisc_notify() - tc_fill_qdisc()
> > >
> >
> > The only useful cases imo are the ones that do h/w offload. So those two seem
> > reasonable. Not sure where you place that tc_set_nl_ext() so it is
> > visible for all.
>
> How about put tc_set_nl_ext() to net/sched/sch_generic.c?
>
> Hangbin
