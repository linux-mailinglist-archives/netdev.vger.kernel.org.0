Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FDDC558B65
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 00:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbiFWWuh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 18:50:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiFWWug (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 18:50:36 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2136527F4;
        Thu, 23 Jun 2022 15:50:35 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id bd16so1386404oib.6;
        Thu, 23 Jun 2022 15:50:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Y+Dg0mM96GxdgWzW8Q0806WYRu+tu0Ie+VcO+cMcI4U=;
        b=FYk61bvDh5JwGf5WdZIwNZW8B6+57IJxN4Nk3SgOVQUCUsYiOm3ErEX+kq3vz0b1jl
         ehO4ycV50KjmXNOG82d4ajlgj9CqbebkKJ4SWJJqHREo4pk+ilQPgbCv6IB6zHid79iP
         rqmZHNnlfQ/rPeGGBvDbNZN9ZMa975cK8vv+RyGLosEe6hd4C5Y35Ob1uvZYTwiiw7Y6
         b7DLV4jzyNghScUUIIDElRVSlbKCQALz3tZIOKZJAGj2eZTZ+H5JRAhWbVmRsDvMSzlp
         R9wiUFpG2WjWK042boAletT6C5cPLJc0Zo+RjXzFx7sR8PaYb7ukt2dzVz3wkwtF6YIr
         Md9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Y+Dg0mM96GxdgWzW8Q0806WYRu+tu0Ie+VcO+cMcI4U=;
        b=VdVX1KljLiXQtwwWL+4BBgDe5GU+eIyxjseEaV403AReEJ0gt3ZoqHVlw8xyr7DeT+
         flJy5IRLl1Db1zCP2UqBkY/Ace2yLfZSkJiv7jwrSg/GGpsKSNhnk7FbcCqghgJkMr6w
         NDYOKI4pmMh9ZeX+k7DgsJGxXSReAAJsFUTXVBWj6+MCNlu6StTrx9+MfnHYr7r3+4Vf
         SvsR3y4h6smzBcPFn3e0KzzrQ4ulI174rgSKx1xNQJ+cL5u3preoHgaRnfc+MCV1APfw
         zJSy5HNyddC1YN6ZX/nCfOkHk+jHgt2DUq1sZC+/WkNeFXJ27RWSmN9D3Lpx6ApL/n7j
         Kxvg==
X-Gm-Message-State: AJIora9pUBzBhvdnFmGSBw0s9iTRpH4/E8LkjTxCMG12DPyIwcQfa48+
        0Yqg4hCC3dzhTju87nJhPnvph/bFFtOCg4jPYmA8JWxT1p0=
X-Google-Smtp-Source: AGRyM1uj/Q9s5zKn4L4uThaMvEnMiPzOqEF1sLtJVqTO12h9dB2vaIo0yv0Uh2i5b+OALrND/sp8sTGWW12NFpQK0Us=
X-Received: by 2002:a05:6808:179a:b0:32f:fd4:3ad6 with SMTP id
 bg26-20020a056808179a00b0032f0fd43ad6mr199172oib.190.1656024634956; Thu, 23
 Jun 2022 15:50:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220619150456.GB34471@xsang-OptiPlex-9020> <20220622172857.37db0d29@kernel.org>
 <CADvbK_csvmkKe46hT9792=+Qcjor2EvkkAnr--CJK3NGX-N9BQ@mail.gmail.com>
In-Reply-To: <CADvbK_csvmkKe46hT9792=+Qcjor2EvkkAnr--CJK3NGX-N9BQ@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Thu, 23 Jun 2022 18:50:07 -0400
Message-ID: <CADvbK_eQUmb942vC+bG+NRzM1ki1LiCydEDR1AezZ35Jvsdfnw@mail.gmail.com>
Subject: Re: [net] 4890b686f4: netperf.Throughput_Mbps -69.4% regression
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        kernel test robot <oliver.sang@intel.com>,
        Eric Dumazet <edumazet@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        network dev <netdev@vger.kernel.org>,
        linux-s390@vger.kernel.org, mptcp@lists.linux.dev,
        "linux-sctp @ vger . kernel . org" <linux-sctp@vger.kernel.org>,
        lkp@lists.01.org, kbuild test robot <lkp@intel.com>,
        Huang Ying <ying.huang@intel.com>, feng.tang@intel.com,
        zhengjun.xing@linux.intel.com, fengwei.yin@intel.com,
        Ying Xu <yinxu@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 22, 2022 at 11:08 PM Xin Long <lucien.xin@gmail.com> wrote:
>
> Yes, I'm working on it. I couldn't see the regression in my env with
> the 'reproduce' script attached.
> I will try with lkp tomorrow.
>
> Thanks.
>
> On Wed, Jun 22, 2022 at 8:29 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > Could someone working on SCTP double check this is a real regression?
> > Feels like the regression reports are flowing at such rate its hard
> > to keep up.
> >
> > >
> > > commit:
> > >   7c80b038d2 ("net: fix sk_wmem_schedule() and sk_rmem_schedule() err=
ors")
> > >   4890b686f4 ("net: keep sk->sk_forward_alloc as small as possible")
> > >
> > > 7c80b038d23e1f4c 4890b686f4088c90432149bd6de
> > > ---------------- ---------------------------
> > >          %stddev     %change         %stddev
> > >              \          |                \
> > >      15855           -69.4%       4854        netperf.Throughput_Mbps
> > >     570788           -69.4%     174773        netperf.Throughput_tota=
l_Mbps
...
> > >       0.00            +5.1        5.10 =C2=B1  5%  perf-profile.callt=
race.cycles-pp.__sk_mem_reduce_allocated.sctp_wfree.skb_release_head_state.=
consume_skb.sctp_chunk_put
> > >       0.17 =C2=B1141%      +5.3        5.42 =C2=B1  6%  perf-profile.=
calltrace.cycles-pp.skb_release_head_state.consume_skb.sctp_chunk_put.sctp_=
outq_sack.sctp_cmd_interpreter
> > >       0.00            +5.3        5.35 =C2=B1  6%  perf-profile.callt=
race.cycles-pp.sctp_wfree.skb_release_head_state.consume_skb.sctp_chunk_put=
.sctp_outq_sack
> > >       0.00            +5.5        5.51 =C2=B1  6%  perf-profile.callt=
race.cycles-pp.__sk_mem_reduce_allocated.skb_release_head_state.kfree_skb_r=
eason.sctp_recvmsg.inet_recvmsg
> > >       0.00            +5.7        5.65 =C2=B1  6%  perf-profile.callt=
race.cycles-pp.skb_release_head_state.kfree_skb_reason.sctp_recvmsg.inet_re=
cvmsg.____sys_recvmsg
...
> > >       0.00            +4.0        4.04 =C2=B1  6%  perf-profile.child=
ren.cycles-pp.mem_cgroup_charge_skmem
> > >       2.92 =C2=B1  6%      +4.2        7.16 =C2=B1  6%  perf-profile.=
children.cycles-pp.sctp_outq_sack
> > >       0.00            +4.3        4.29 =C2=B1  6%  perf-profile.child=
ren.cycles-pp.__sk_mem_raise_allocated
> > >       0.00            +4.3        4.32 =C2=B1  6%  perf-profile.child=
ren.cycles-pp.__sk_mem_schedule
> > >       1.99 =C2=B1  6%      +4.4        6.40 =C2=B1  6%  perf-profile.=
children.cycles-pp.consume_skb
> > >       1.78 =C2=B1  6%      +4.6        6.42 =C2=B1  6%  perf-profile.=
children.cycles-pp.kfree_skb_reason
> > >       0.37 =C2=B1  8%      +5.0        5.40 =C2=B1  6%  perf-profile.=
children.cycles-pp.sctp_wfree
> > >       0.87 =C2=B1  9%     +10.3       11.20 =C2=B1  6%  perf-profile.=
children.cycles-pp.skb_release_head_state
> > >       0.00           +10.7       10.66 =C2=B1  6%  perf-profile.child=
ren.cycles-pp.__sk_mem_reduce_allocated
...
> > >       0.00            +1.2        1.19 =C2=B1  7%  perf-profile.self.=
cycles-pp.try_charge_memcg
> > >       0.00            +2.0        1.96 =C2=B1  6%  perf-profile.self.=
cycles-pp.page_counter_uncharge
> > >       0.00            +2.1        2.07 =C2=B1  5%  perf-profile.self.=
cycles-pp.page_counter_try_charge
> > >       1.09 =C2=B1  8%      +2.8        3.92 =C2=B1  6%  perf-profile.=
self.cycles-pp.native_queued_spin_lock_slowpath
> > >       0.29 =C2=B1  6%      +3.5        3.81 =C2=B1  6%  perf-profile.=
self.cycles-pp.sctp_eat_data
> > >       0.00            +7.8        7.76 =C2=B1  6%  perf-profile.self.=
cycles-pp.__sk_mem_reduce_allocated

From the perf data, we can see __sk_mem_reduce_allocated() is the one
using CPU the most more than before, and mem_cgroup APIs are also
called in this function. It means the mem cgroup must be enabled in
the test env, which may explain why I couldn't reproduce it.

The Commit 4890b686f4 ("net: keep sk->sk_forward_alloc as small as
possible") uses sk_mem_reclaim(checking reclaimable >=3D PAGE_SIZE) to
reclaim the memory, which is *more frequent* to call
__sk_mem_reduce_allocated() than before (checking reclaimable >=3D
SK_RECLAIM_THRESHOLD). It might be cheap when
mem_cgroup_sockets_enabled is false, but I'm not sure if it's still
cheap when mem_cgroup_sockets_enabled is true.

I think SCTP netperf could trigger this, as the CPU is the bottleneck
for SCTP netperf testing, which is more sensitive to the extra
function calls than TCP.

Can we re-run this testing without mem cgroup enabled?

Thanks.
