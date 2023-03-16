Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82C326BCB28
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 10:39:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231181AbjCPJjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 05:39:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230282AbjCPJjW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 05:39:22 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95E5E1114F
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 02:39:20 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id r1so1096203ybu.5
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 02:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112; t=1678959560;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CcW4g6xSRtuNDpEyutZJ0TfZEqtg4oweNQUtUkk4w6A=;
        b=SuY3HoePNjvwdMYcrZoR+4ASuw2tjTDYFdGKWj+GsjUMWDO6MuuCl6S1A3KulGmhVl
         K7M2dVnXZQYshy7dqgZnbKcA9CcimCKb6qF+C5eNnfDQy4bI6YMgwVmIvSt8b/UBNrOw
         qoQF2Ba0YcGIuv/NJRvqOSRgJki2k05mXqMiu24OO/6i0QMpR/jhPmbsKXZT+mKq1VC5
         x0qxahNQOvhdcIQ78M1D4h7wBBb0rsGWleaDrybyv7s9n7Inq+VPzeLudQmWYfAxKxb0
         Jxbji0FOfXS9hUe+dxkvrNZaAs7TC/swhK5Wcw7cd00iOyVUxmLGVO+T3jk+mmhVdCWQ
         MdxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678959560;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CcW4g6xSRtuNDpEyutZJ0TfZEqtg4oweNQUtUkk4w6A=;
        b=5cBsHo8mYXL7mIDnuMPX3kE2XZ/Dzai2Jows3d/D1HhlEzLOHIdfJP8iVws6aQi/Qo
         7gg5OoSGujljj06FX/Jm/lj0RY3oMwQGvKzs9GmDVmJ3EudzD2sTS6Nq0fve7rPFd8+z
         7kqL165IgK+SJRGyBUjtVTqsZJWFdjBqu/7bLkBT3mj2MYq8gy00eUrH4gd1KDUhHn6S
         kiJ8/qUL2LNRAJfMr9OGPJ4X4icc6cbMNexrQBykeIpEosGgpO63Jju4cShgEHc4jvU3
         ndjFR9hTDeYKbB+eLskBWUmR8H8CLazVVPGxbytpBN87WhhLQQonmxol/bB21w4gQ+xB
         VE2w==
X-Gm-Message-State: AO0yUKX2xXEOchqePhwjFJwqMPVcktoaIOxBd1RiXmxM8PjO7gNob8TM
        pK1G2QWCiE9b5E4WvbddScA3aKwe454uX6+YoMKNSKLbRyU+/Zke
X-Google-Smtp-Source: AK7set+TnqeFR4lq2NIkvw5arlxlx6LhNvEndsx1hZzkmxeCeLp/o7WoZ4anlr1QDQ1fqcK8qg5IIKNxkCX9q6fZQYk=
X-Received: by 2002:a05:6902:188c:b0:b50:77a7:ccb with SMTP id
 cj12-20020a056902188c00b00b5077a70ccbmr3676418ybb.2.1678959559833; Thu, 16
 Mar 2023 02:39:19 -0700 (PDT)
MIME-Version: 1.0
References: <20230314065802.1532741-1-liuhangbin@gmail.com>
 <20230314065802.1532741-3-liuhangbin@gmail.com> <CAM0EoM=mcejihaG5KthJyXqjPiPiTWvhgLFNqZCthE8VJ23Q9w@mail.gmail.com>
 <ZBGUJt+fJ61yRKUB@Laptop-X1> <CAM0EoM=pNop+h9Eo_cc=vwS6iY7-f=rJK-G9g+SSJJupnZVy8g@mail.gmail.com>
 <ZBKOFpG80d3vU++j@Laptop-X1>
In-Reply-To: <ZBKOFpG80d3vU++j@Laptop-X1>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Thu, 16 Mar 2023 05:39:08 -0400
Message-ID: <CAM0EoMkFvU0Pm7x7tnby3RFdMH7QMZDEJ9A_w70wCp2sZG0RNQ@mail.gmail.com>
Subject: Re: [PATCH net 2/2] net/sched: act_api: add specific EXT_WARN_MSG for
 tc action
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Davide Caratti <dcaratti@redhat.com>,
        Pedro Tammela <pctammela@mojatatu.com>,
        Marcelo Leitner <mleitner@redhat.com>,
        Phil Sutter <psutter@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 15, 2023 at 11:33=E2=80=AFPM Hangbin Liu <liuhangbin@gmail.com>=
 wrote:
>
> On Wed, Mar 15, 2023 at 02:49:43PM -0400, Jamal Hadi Salim wrote:
> > On Wed, Mar 15, 2023 at 5:47=E2=80=AFAM Hangbin Liu <liuhangbin@gmail.c=
om> wrote:
> > >
> > > On Tue, Mar 14, 2023 at 06:35:29PM -0400, Jamal Hadi Salim wrote:
> > > > Sorry, only thing i should have mentioned earlier - not clear from =
here:
> > > > Do you get two ext warns now in the same netlink message? One for t=
he
> > > > action and one for the cls?
> > > > Something to check:
> > > > on terminal1 > tc monitor
> > > > on terminal2 > run a command which will get the offload to fail and
> > > > see what response you get
> > > >
> > > > My concern is you may be getting two warnings in one message.
> > >
> > > From the result we only got 1 warning message.
> > >
> > > # tc qdisc add dev enp4s0f0np0 ingress
> > > # tc filter add dev enp4s0f0np0 ingress flower verbose ct_state +trk+=
new action drop
> > > Warning: mlx5_core: matching on ct_state +new isn't supported.
> > >
> > > # tc monitor
> > > qdisc ingress ffff: dev enp4s0f0np0 parent ffff:fff1 ----------------
> > > added chain dev enp4s0f0np0 parent ffff: chain 0
> > > added filter dev enp4s0f0np0 ingress protocol all pref 49152 flower c=
hain 0 handle 0x1
> > >   ct_state +trk+new
> > >   not_in_hw
> > >         action order 1: gact action drop
> > >          random type none pass val 0
> > >          index 1 ref 1 bind 1
> > >
> > > mlx5_core: matching on ct_state +new isn't supported
> > > ^C
> >
> > Thanks for checking. I was worried from the quick glance that you will
> > end up calling the action code with extack from cls and that the
> > warning will be duplicated.
>
> The action info should be filled via dump function, which will not call
> tca_get_fill(). So I think it should be safe. Please correct me if I miss=
ed
> anything.


Right - for a similar scenario, it will only be called when you
offload an action independent of the filter.

cheers,
jamal
