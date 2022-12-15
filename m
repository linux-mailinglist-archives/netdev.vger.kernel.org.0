Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA9DE64DCA0
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 14:59:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbiLON70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 08:59:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbiLON7M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 08:59:12 -0500
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58F062FBED
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 05:59:11 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id f16so9977426ljc.8
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 05:59:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c0ZeZrgSVWHTcIpRsB0S0g4iAzmT0ygD3nkVTl3/R7o=;
        b=oE1vDLoQyL8C7RmGbteghPvnTtN6f2g55eK9T9ekTRj00Vlzw8iPpSCD8cr3iofpE+
         WKmQsU3IM5/ybZ0a1oJCj09Yms4JjyCIwABTcpX9d7U+hnYtOH12sjQuzXA3IPErcBUB
         imKpzn2HvVydR/VyHLS3rO5vM4wvr9qCoolTYDVA0wpPuqL/VYKIgqlgqzzp+Q0wlL+3
         ob5m051OIuXKoOeI/AK9ZCve/efarmrOskzR4WBQ8OTDkqGEU/uFTFNwWQp04zInSHMH
         Uk3AFasWDXO8HtqE5wgMqSbqcwxyF/Wd9sjwRUFWKfIO5lVyoIiwNlGuJ9qBPwxMyDM3
         WSvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c0ZeZrgSVWHTcIpRsB0S0g4iAzmT0ygD3nkVTl3/R7o=;
        b=Ds6Xh0trVZ15WTjb2x5tWhG47nXnNByrMYWrT/AOmj0YlLP5RIV+n4KN+b4E5PPdCZ
         sKO7BCphAhM59NVaQC3RghnBJlFIfX81zxyOq30iIZFEuHiTFqbsggIxN0xupQE5wwD4
         GSp4czppo+eHxjzbS///qReBorBoszr3CQBiPZAADNrxLktHslRzoB32Yi8XYz/C/Mr4
         91t3GhGO/wpXbgGKP3BqoQjN4ylZOOy5pZzhcnBUjkMhOG92Feb+Im7YcZRMH86Nrm6d
         BkBdnIqlzZ+hzmxs1rQRAx/yY5q6RyDJ2mO5meZm7xgkpilXBL23ZuQgMTFy6D27EaqH
         x+2g==
X-Gm-Message-State: ANoB5pkdIx3FttkmbpAN7zYJUi5abHtXubxVplrix7x0fcPEk9/mBglT
        46h0eAxjAbJmlaci63YclLWmImZxDOKqRqGX5a523WEZ5VZd2qKh
X-Google-Smtp-Source: AA0mqf4NO/jkYriyMhdyaopy4MkuL9UzdzeUGktjtak6eXCOj+6m8ssh1S4wVRPO4J7KonrAJPyYak0sVwlQnoGPelg=
X-Received: by 2002:a2e:a806:0:b0:277:4b35:d94a with SMTP id
 l6-20020a2ea806000000b002774b35d94amr22176731ljq.21.1671112749659; Thu, 15
 Dec 2022 05:59:09 -0800 (PST)
MIME-Version: 1.0
References: <20221214022058.3625300-1-jun.nie@linaro.org> <f8af2b70e3c2074de04b2117100b2cdc5ec4ec6d.camel@redhat.com>
In-Reply-To: <f8af2b70e3c2074de04b2117100b2cdc5ec4ec6d.camel@redhat.com>
From:   Jun Nie <jun.nie@linaro.org>
Date:   Thu, 15 Dec 2022 21:59:05 +0800
Message-ID: <CABymUCNC=WNmHVLi0V+NZXQ+uLUUuGQYGHxW1jN0wjFyXNzT0g@mail.gmail.com>
Subject: Re: [PATCH net v2] net: sched: ematch: reject invalid data
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Paolo Abeni <pabeni@redhat.com> =E4=BA=8E2022=E5=B9=B412=E6=9C=8815=E6=97=
=A5=E5=91=A8=E5=9B=9B 20:50=E5=86=99=E9=81=93=EF=BC=9A
>
> On Wed, 2022-12-14 at 10:20 +0800, Jun Nie wrote:
> > syzbot reported below bug. Refuse to compare for invalid data case to f=
ix
> > it.
> >
> > general protection fault, probably for non-canonical address 0xdffffc00=
00000001: 0000 [#1] PREEMPT SMP KASAN
> > KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
> > CPU: 0 PID: 6 Comm: kworker/0:0 Not tainted 5.15.77-syzkaller-00764-g70=
48384c9872 #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS=
 Google 10/26/2022
> > Workqueue: wg-crypt-wg2 wg_packet_tx_worker
> > RIP: 0010:em_cmp_match+0x4e/0x5f0 net/sched/em_cmp.c:25
> > Call Trace:
> >  <TASK>
> >  tcf_em_match net/sched/ematch.c:492 [inline]
> >  __tcf_em_tree_match+0x194/0x720 net/sched/ematch.c:518
> >  tcf_em_tree_match include/net/pkt_cls.h:463 [inline]
> >  basic_classify+0xd8/0x250 net/sched/cls_basic.c:48
> >  __tcf_classify net/sched/cls_api.c:1549 [inline]
> >  tcf_classify+0x161/0x430 net/sched/cls_api.c:1589
> >  prio_classify net/sched/sch_prio.c:42 [inline]
> >  prio_enqueue+0x1d3/0x6a0 net/sched/sch_prio.c:75
> >  dev_qdisc_enqueue net/core/dev.c:3792 [inline]
> >  __dev_xmit_skb+0x35c/0x1650 net/core/dev.c:3876
> >  __dev_queue_xmit+0x8f3/0x1b50 net/core/dev.c:4193
> >  dev_queue_xmit+0x17/0x20 net/core/dev.c:4261
> >  neigh_hh_output include/net/neighbour.h:508 [inline]
> >  neigh_output include/net/neighbour.h:522 [inline]
> >  ip_finish_output2+0xc0f/0xf00 net/ipv4/ip_output.c:228
> >  __ip_finish_output+0x163/0x370
> >  ip_finish_output+0x20b/0x220 net/ipv4/ip_output.c:316
> >  NF_HOOK_COND include/linux/netfilter.h:299 [inline]
> >  ip_output+0x1e9/0x410 net/ipv4/ip_output.c:430
> >  dst_output include/net/dst.h:450 [inline]
> >  ip_local_out+0x92/0xb0 net/ipv4/ip_output.c:126
> >  iptunnel_xmit+0x4a2/0x890 net/ipv4/ip_tunnel_core.c:82
> >  udp_tunnel_xmit_skb+0x1b6/0x2c0 net/ipv4/udp_tunnel_core.c:175
> >  send4+0x78d/0xd20 drivers/net/wireguard/socket.c:85
> >  wg_socket_send_skb_to_peer+0xd5/0x1d0 drivers/net/wireguard/socket.c:1=
75
> >  wg_packet_create_data_done drivers/net/wireguard/send.c:251 [inline]
> >  wg_packet_tx_worker+0x202/0x560 drivers/net/wireguard/send.c:276
> >  process_one_work+0x6db/0xc00 kernel/workqueue.c:2313
> >  worker_thread+0xb3e/0x1340 kernel/workqueue.c:2460
> >  kthread+0x41c/0x500 kernel/kthread.c:319
> >  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:298
> >
> > Reported-by: syzbot+963f7637dae8becc038f@syzkaller.appspotmail.com
> > Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
>
> Very likely this is not the correct fixes tag.
>
> > Signed-off-by: Jun Nie <jun.nie@linaro.org>
> > ---
> >  net/sched/em_cmp.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/sched/em_cmp.c b/net/sched/em_cmp.c
> > index f17b049ea530..0284394be53f 100644
> > --- a/net/sched/em_cmp.c
> > +++ b/net/sched/em_cmp.c
> > @@ -22,9 +22,14 @@ static int em_cmp_match(struct sk_buff *skb, struct =
tcf_ematch *em,
> >                       struct tcf_pkt_info *info)
> >  {
> >       struct tcf_em_cmp *cmp =3D (struct tcf_em_cmp *) em->data;
> > -     unsigned char *ptr =3D tcf_get_base_ptr(skb, cmp->layer) + cmp->o=
ff;
> > +     unsigned char *ptr;
> >       u32 val =3D 0;
> >
> > +     if (!cmp)
> > +             return 0;
>
> It feels like this is papering over the real issue. Why em->data is
> NULL here? why other ematches are not afflicted by this issue?
>
> is em->data really NULL or some small value instead? KASAN seams to
> tell it's a small value, not 0, so this patch should not avoid the
> oops. Have you tested it vs the reproducer?
>
> Thanks,
>
> Paolo
>

The test with the reproducer[1] shows it does resolve the issue. The data
is NULL so that deferring cmp can be avoided with the patch. I did not
investigate why the em->data is NULL in WireGuard secure network tunnel
case as I am not familiar with network stack. So you can also call this pat=
ch
as a workaround.

[1]
https://syzkaller.appspot.com/bug?id=3Dd96c4958dc8d4da11f56e18471dfc4f64d21=
ef6e

Regards,
Jun
