Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70580559278
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 07:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbiFXFpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 01:45:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbiFXFpN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 01:45:13 -0400
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5225E699B2
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 22:45:12 -0700 (PDT)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-3178ea840easo14264527b3.13
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 22:45:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UUGqTgN+5YKv2H0rf/ztiANxsWf1MI3a/7GrwKOQcgM=;
        b=VWOlSEOdFiePk9Rc5gCg1TK+lVqlDRMW8n9OQyh6w4erjgn20jqCcBjiyzbPeEZkm/
         Ju3DJRybXMomwT4SKbwv6AoRGa8i06EDXov0akpTQSw2VVZfmiL+N8uKdpKC6GAqyXrg
         XLNNQRLU7BkoOv7W/61vjxPbuxN3h9QYx7UHfu3UqhJkGHdevTZAqrYlmVFW7uQQ++HK
         9oOh+E/03sukVd8lf6Jl+FKqID9qaVM8fSN1m0cuK3dUi4PQOeYXhtPJeikMdaqgt/YL
         7s30iAUICIM1bsnf1ub4rqh8GV1lNDCECsTSq1H3Vqwo8vD4ZPmGqICzqh0ia+ZWym65
         fanw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UUGqTgN+5YKv2H0rf/ztiANxsWf1MI3a/7GrwKOQcgM=;
        b=ge5Xb6ujZjpOsQcJ0dP8CQ6Jfeewv3b69jlGC4luYiPr6Wd6vXDBrGZdHquc049xHK
         a27LUXEc4Rr6izvZptfriuiDaqf2wA0fQfMypX22eNp+Fg2RIohTUeDTCFPqZ8e7znEI
         OHPyBkFasmkye185AGqNy6n+hzHlMVIIjiISJBCLWf1PTNI27of2pDCXN89gxJ9msI2f
         OxIxDGSzR6oVrkiOug2t/dds/Gd4gOAmsO5Zf4UkEC6Qm8RmiMqcRa/U2RxhVsKAMEmI
         nFqyg3ec85QiwIpLps+LK85UypUOoqvIRXnMuz7ox5/lslxwUeVNq91BTuudblgxza0d
         tuFA==
X-Gm-Message-State: AJIora+q7p/0U8QU2bacRI4KcYb5141DOnJnqagRpZASWCqOukQ+bZDk
        qiMxrWVAAkQjQYP8gKnvC9l3cU3B89RwrbEyOnfIfQ==
X-Google-Smtp-Source: AGRyM1sGmW1bcpDPhuGfi1tODFyvBPsSQPhj1u2FdrTxYlZVUp1IWGCGVa7x0KMrFG85ujhORR0J1SjmvvKnNbwvSj0=
X-Received: by 2002:a81:1809:0:b0:317:c014:f700 with SMTP id
 9-20020a811809000000b00317c014f700mr14454062ywy.255.1656049511378; Thu, 23
 Jun 2022 22:45:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220619150456.GB34471@xsang-OptiPlex-9020> <20220622172857.37db0d29@kernel.org>
 <CADvbK_csvmkKe46hT9792=+Qcjor2EvkkAnr--CJK3NGX-N9BQ@mail.gmail.com>
 <CADvbK_eQUmb942vC+bG+NRzM1ki1LiCydEDR1AezZ35Jvsdfnw@mail.gmail.com>
 <20220623185730.25b88096@kernel.org> <CANn89iLidqjiiV8vxr7KnUg0JvfoS9+TRGg=8ANZ8NBRjeQxsQ@mail.gmail.com>
 <20220624051351.GA72171@shbuild999.sh.intel.com>
In-Reply-To: <20220624051351.GA72171@shbuild999.sh.intel.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 24 Jun 2022 07:45:00 +0200
Message-ID: <CANn89iLwwN7hRsJD_skbcRNY9sBtPh1fhULKco5wosx_i4x6gg@mail.gmail.com>
Subject: Re: [net] 4890b686f4: netperf.Throughput_Mbps -69.4% regression
To:     Feng Tang <feng.tang@intel.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Xin Long <lucien.xin@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        kernel test robot <oliver.sang@intel.com>,
        Shakeel Butt <shakeelb@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        network dev <netdev@vger.kernel.org>,
        linux-s390@vger.kernel.org, MPTCP Upstream <mptcp@lists.linux.dev>,
        "linux-sctp @ vger . kernel . org" <linux-sctp@vger.kernel.org>,
        lkp@lists.01.org, kbuild test robot <lkp@intel.com>,
        Huang Ying <ying.huang@intel.com>,
        zhengjun.xing@linux.intel.com, fengwei.yin@intel.com,
        Ying Xu <yinxu@redhat.com>
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

On Fri, Jun 24, 2022 at 7:14 AM Feng Tang <feng.tang@intel.com> wrote:
>
> Hi Eric,
>
> On Fri, Jun 24, 2022 at 06:13:51AM +0200, Eric Dumazet wrote:
> > On Fri, Jun 24, 2022 at 3:57 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > >
> > > On Thu, 23 Jun 2022 18:50:07 -0400 Xin Long wrote:
> > > > From the perf data, we can see __sk_mem_reduce_allocated() is the one
> > > > using CPU the most more than before, and mem_cgroup APIs are also
> > > > called in this function. It means the mem cgroup must be enabled in
> > > > the test env, which may explain why I couldn't reproduce it.
> > > >
> > > > The Commit 4890b686f4 ("net: keep sk->sk_forward_alloc as small as
> > > > possible") uses sk_mem_reclaim(checking reclaimable >= PAGE_SIZE) to
> > > > reclaim the memory, which is *more frequent* to call
> > > > __sk_mem_reduce_allocated() than before (checking reclaimable >=
> > > > SK_RECLAIM_THRESHOLD). It might be cheap when
> > > > mem_cgroup_sockets_enabled is false, but I'm not sure if it's still
> > > > cheap when mem_cgroup_sockets_enabled is true.
> > > >
> > > > I think SCTP netperf could trigger this, as the CPU is the bottleneck
> > > > for SCTP netperf testing, which is more sensitive to the extra
> > > > function calls than TCP.
> > > >
> > > > Can we re-run this testing without mem cgroup enabled?
> > >
> > > FWIW I defer to Eric, thanks a lot for double checking the report
> > > and digging in!
> >
> > I did tests with TCP + memcg and noticed a very small additional cost
> > in memcg functions,
> > because of suboptimal layout:
> >
> > Extract of an internal Google bug, update from June 9th:
> >
> > --------------------------------
> > I have noticed a minor false sharing to fetch (struct
> > mem_cgroup)->css.parent, at offset 0xc0,
> > because it shares the cache line containing struct mem_cgroup.memory,
> > at offset 0xd0
> >
> > Ideally, memcg->socket_pressure and memcg->parent should sit in a read
> > mostly cache line.
> > -----------------------
> >
> > But nothing that could explain a "-69.4% regression"
>
> We can double check that.
>
> > memcg has a very similar strategy of per-cpu reserves, with
> > MEMCG_CHARGE_BATCH being 32 pages per cpu.
>
> We have proposed patch to increase the batch numer for stats
> update, which was not accepted as it hurts the accuracy and
> the data is used by many tools.
>
> > It is not clear why SCTP with 10K writes would overflow this reserve constantly.
> >
> > Presumably memcg experts will have to rework structure alignments to
> > make sure they can cope better
> > with more charge/uncharge operations, because we are not going back to
> > gigantic per-socket reserves,
> > this simply does not scale.
>
> Yes, the memcg statitics and charge/unchage update is very sensitive
> with the data alignemnt layout, and can easily trigger peformance
> changes, as we've seen quite some similar cases in the past several
> years.
>
> One pattern we've seen is, even if a memcg stats updating or charge
> function only takes about 2%~3% of the CPU cycles in perf-profile data,
> once it got affected, the peformance change could be amplified to up to
> 60% or more.
>

Reorganizing "struct mem_cgroup" to put "struct page_counter memory"
in a separate cache line would be beneficial.

Many low hanging fruits, assuming nobody will use __randomize_layout on it ;)

Also some fields are written even if their value is not changed.

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index abec50f31fe64100f4be5b029c7161b3a6077a74..53d9c1e581e78303ef73942e2b34338567987b74
100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -7037,10 +7037,12 @@ bool mem_cgroup_charge_skmem(struct mem_cgroup
*memcg, unsigned int nr_pages,
                struct page_counter *fail;

                if (page_counter_try_charge(&memcg->tcpmem, nr_pages, &fail)) {
-                       memcg->tcpmem_pressure = 0;
+                       if (READ_ONCE(memcg->tcpmem_pressure))
+                               WRITE_ONCE(memcg->tcpmem_pressure, 0);
                        return true;
                }
-               memcg->tcpmem_pressure = 1;
+               if (!READ_ONCE(memcg->tcpmem_pressure))
+                       WRITE_ONCE(memcg->tcpmem_pressure, 1);
                if (gfp_mask & __GFP_NOFAIL) {
                        page_counter_charge(&memcg->tcpmem, nr_pages);
                        return true;
