Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1242C644F63
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 00:10:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbiLFXKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 18:10:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiLFXKw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 18:10:52 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B664342990
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 15:10:51 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id 94-20020a17090a09e700b002191897f70aso14151922pjo.9
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 15:10:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=H30kxZZAF5jNAG74FSVbdmAZx19VpCBztd5KoQzCrP8=;
        b=Jlk1MmZCRjTlJDcMa2AlTVoJLrTt+/m+1AA4uwx+MttAi+FmUNRsMX8SzhrD1HHgXX
         d81kNXOA1lGLcF+WHEmHQo1v1bFG4omVEdJD7yIqGo8TB3Yt5ZVtaZARZqYKl/9iAx5M
         Ip2C0G4UFGPZaZYJb+DSc6cmX73dTrJ37Hku2SMBzeSGOXzMKMp1vVoHaJhAsGL1m2Lo
         cKtochCKQNZ2Aat3boBLKDEdB+ibi5/spc/sAVj6Nmq2vhlYKpKSeDxMzQwvTvE+fNqK
         L6rj/E8c0TzzAExGWhtgPxUFwhopdoD46Xa10DctN43JPpt1Q266DAF3IiT5L4puAbzi
         i6hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=H30kxZZAF5jNAG74FSVbdmAZx19VpCBztd5KoQzCrP8=;
        b=F9yynjLRQJnDWNXvPAu4zbR1H0fxsnyfGzMU3MzGC+6ZeFszXYHiPdKJXHcQqdq/1G
         vgykiNxJGESJyJs1y/MHhI+NRaHwsKLJd2sLImyUySroDKjCemO/6LbBbdkEHAh9iEp8
         yPoZq1OMlL7zTxyDia998sFbKzu/zPqoaCUid4fHEHZhSyBhtM9MSgGngAiDZeWHAZi8
         Yf5Kmrt7XqrgijnV4X7fb4GEEH4VxAP7zmwk5JNgHtsmfIFT2WrlB1Ci8tD5XZm740Hd
         0MblF4wL6MTzct3ZFOOafc3Yn20VyfDrzMZK5qX1n3/mB/BbOgniaIWmP4iz+gIqZ/b6
         vEOw==
X-Gm-Message-State: ANoB5pn3VwNG7Is/KqnUq1zHNUkBg86XuK76vznSvL0WSOruzmK0K3oQ
        W6ARv+KW4ptjWrPLAB+ZHrjENyJnupLf3Q==
X-Google-Smtp-Source: AA0mqf4pNzogl/JUXLfYSBY3pMqRBpS5Ca9/0oJMM041D8rSTyO+eYpsF6Dzqyhh467WIFCAgnYNhCX16y0THw==
X-Received: from shakeelb.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:262e])
 (user=shakeelb job=sendgmr) by 2002:a05:6a00:1391:b0:575:eaa:c28c with SMTP
 id t17-20020a056a00139100b005750eaac28cmr46822396pfg.76.1670368251140; Tue,
 06 Dec 2022 15:10:51 -0800 (PST)
Date:   Tue, 6 Dec 2022 23:10:49 +0000
In-Reply-To: <Y4+rNYF9WZyJyBQp@cmpxchg.org>
Mime-Version: 1.0
References: <CABWYdi0G7cyNFbndM-ELTDAR3x4Ngm0AehEp5aP0tfNkXUE+Uw@mail.gmail.com>
 <Y30rdnZ+lrfOxjTB@cmpxchg.org> <CABWYdi3PqipLxnqeepXeZ471pfeBg06-PV0Uw04fU-LHnx_A4g@mail.gmail.com>
 <CABWYdi0qhWs56WK=k+KoQBAMh+Tb6Rr0nY4kJN+E5YqfGhKTmQ@mail.gmail.com>
 <Y4T43Tc54vlKjTN0@cmpxchg.org> <CABWYdi0z6-46PrNWumSXWki6Xf4G_EP1Nvc-2t00nEi0PiOU3Q@mail.gmail.com>
 <CABWYdi25hricmGUqaK1K0EB-pAm04vGTg=eiqRF99RJ7hM7Gyg@mail.gmail.com>
 <Y4+RPry2tfbWFdSA@cmpxchg.org> <CANn89iJfx4QdVBqJ23oFJoz5DJKou=ZwVBNNXFNDJRNAqNvzwQ@mail.gmail.com>
 <Y4+rNYF9WZyJyBQp@cmpxchg.org>
Message-ID: <20221206231049.g35ltbxbk54izrie@google.com>
Subject: Re: Low TCP throughput due to vmpressure with swap enabled
From:   Shakeel Butt <shakeelb@google.com>
To:     Johannes Weiner <hannes@cmpxchg.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Ivan Babrou <ivan@cloudflare.com>,
        Linux MM <linux-mm@kvack.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, cgroups@vger.kernel.org,
        kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 06, 2022 at 09:51:01PM +0100, Johannes Weiner wrote:
> On Tue, Dec 06, 2022 at 08:13:50PM +0100, Eric Dumazet wrote:
> > On Tue, Dec 6, 2022 at 8:00 PM Johannes Weiner <hannes@cmpxchg.org> wrote:
> > > @@ -1701,10 +1701,10 @@ void mem_cgroup_sk_alloc(struct sock *sk);
> > >  void mem_cgroup_sk_free(struct sock *sk);
> > >  static inline bool mem_cgroup_under_socket_pressure(struct mem_cgroup *memcg)
> > >  {
> > > -       if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && memcg->tcpmem_pressure)
> > > +       if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && memcg->socket_pressure)
> > 
> > && READ_ONCE(memcg->socket_pressure))
> > 
> > >                 return true;
> > >         do {
> > > -               if (time_before(jiffies, READ_ONCE(memcg->socket_pressure)))
> > > +               if (memcg->socket_pressure)
> > 
> > if (READ_ONCE(...))
> 
> Good point, I'll add those.
> 
> > > @@ -7195,10 +7194,10 @@ bool mem_cgroup_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages,
> > >                 struct page_counter *fail;
> > >
> > >                 if (page_counter_try_charge(&memcg->tcpmem, nr_pages, &fail)) {
> > > -                       memcg->tcpmem_pressure = 0;
> > 
> > Orthogonal to your patch, but:
> > 
> > Maybe avoid touching this cache line too often and use READ/WRITE_ONCE() ?
> > 
> >     if (READ_ONCE(memcg->socket_pressure))
> >       WRITE_ONCE(memcg->socket_pressure, false);
> 
> Ah, that's a good idea.
> 
> I think it'll be fine in the failure case, since that's associated
> with OOM and total performance breakdown anyway.
> 
> But certainly, in the common case of the charge succeeding, we should
> not keep hammering false into that variable over and over.
> 
> How about the delta below? I also flipped the branches around to keep
> the common path at the first indentation level, hopefully making that
> a bit clearer too.
> 
> Thanks for taking a look, Eric!
> 

I still think we should not put a persistent state of socket pressure on
unsuccessful charge which will only get reset on successful charge. I
think the better approach would be to limit the pressure state by time
window same as today but set it on charge path. Something like below:


diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index d3c8203cab6c..7bd88d443c42 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -287,7 +287,6 @@ struct mem_cgroup {

        /* Legacy tcp memory accounting */
        bool                    tcpmem_active;
-       int                     tcpmem_pressure;

 #ifdef CONFIG_MEMCG_KMEM
        int kmemcg_id;
@@ -1712,8 +1711,6 @@ void mem_cgroup_sk_alloc(struct sock *sk);
 void mem_cgroup_sk_free(struct sock *sk);
 static inline bool mem_cgroup_under_socket_pressure(struct mem_cgroup *memcg)
 {
-       if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && memcg->tcpmem_pressure)
-               return true;
        do {
                if (time_before(jiffies, READ_ONCE(memcg->socket_pressure)))
                        return true;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 48c44229cf47..290444bcab84 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5286,7 +5286,6 @@ static struct mem_cgroup *mem_cgroup_alloc(void)
        vmpressure_init(&memcg->vmpressure);
        INIT_LIST_HEAD(&memcg->event_list);
        spin_lock_init(&memcg->event_list_lock);
-       memcg->socket_pressure = jiffies;
 #ifdef CONFIG_MEMCG_KMEM
        memcg->kmemcg_id = -1;
        INIT_LIST_HEAD(&memcg->objcg_list);
@@ -7252,10 +7251,12 @@ bool mem_cgroup_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages,
                struct page_counter *fail;

                if (page_counter_try_charge(&memcg->tcpmem, nr_pages, &fail)) {
-                       memcg->tcpmem_pressure = 0;
+                       if (READ_ONCE(memcg->socket_pressure))
+                               WRITE_ONCE(memcg->socket_pressure, 0);
                        return true;
                }
-               memcg->tcpmem_pressure = 1;
+               if (READ_ONCE(memcg->socket_pressure) < jiffies + HZ)
+                       WRITE_ONCE(memcg->socket_pressure, jiffies + HZ);
                if (gfp_mask & __GFP_NOFAIL) {
                        page_counter_charge(&memcg->tcpmem, nr_pages);
                        return true;
@@ -7263,12 +7264,21 @@ bool mem_cgroup_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages,
                return false;
        }

-       if (try_charge(memcg, gfp_mask, nr_pages) == 0) {
-               mod_memcg_state(memcg, MEMCG_SOCK, nr_pages);
-               return true;
+       if (try_charge(memcg, gfp_mask & ~__GFP_NOFAIL, nr_pages) < 0) {
+               if (READ_ONCE(memcg->socket_pressure) < jiffies + HZ)
+                       WRITE_ONCE(memcg->socket_pressure, jiffies + HZ);
+               if (gfp_mask & __GFP_NOFAIL) {
+                       try_charge(memcg, gfp_mask, nr_pages);
+                       goto out;
+               }
+               return false;
        }

-       return false;
+       if (READ_ONCE(memcg->socket_pressure))
+               WRITE_ONCE(memcg->socket_pressure, 0);
+out:
+       mod_memcg_state(memcg, MEMCG_SOCK, nr_pages);
+       return true;
 }

 /**
