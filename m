Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D749644D86
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 21:51:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbiLFUv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 15:51:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbiLFUv2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 15:51:28 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8C1C45094
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 12:51:26 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id kw15so5871823ejc.10
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 12:51:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MhNNBuU3zhWHic7xb6ZOwSKSyK5OVL6db6+6pmE+Q3M=;
        b=ew9hSEgOp7zxS5LHySeYnEzHgmaD+v212Cb4Fd4PwkYBPj5pH62iZWOulKd0ei+VIF
         hG4aPrHYGGD2WjWCwTeiUbs4eJpgiBWAD11E9kH3ukMi930ryVJILwhbma6Z6EzrMM05
         mLbvFWbLYmMuszo96rfDjQSt3bGw11HgQ5uhXrEPsPukevWYu9Se1bCczpK+/vleLV5K
         AGPm4VSO4i06JLwAL1yP1lr+XAgD8QZhihWIylphT7Vy0PwUMDgG1DNbLcgxqTsHQe/q
         icM80qePTJzH/mDe7I8K1001EPbcfyl2/qvXn1BCmCuF8HDKBXbdkhqjrLXdTuledxeF
         tJ2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MhNNBuU3zhWHic7xb6ZOwSKSyK5OVL6db6+6pmE+Q3M=;
        b=F7AoWxWVTBRyvtxO7tvLVVAA+A3gdWsuckm0PDbwS7E7sM8a7GukMpECDqn5dibTDg
         nkISAXL13oVElUPy/SKqtLaZ0eSsWVL4ICj/db3DQFRiqSDO0tMYJjKJ9Gv8ainDT2MT
         3OkmCBSmJ9k/Cwt4ouAVrbxXy+mWM0CRzI8yVZYt7bQRg8bWxLzo85XQSjI9FnB77c/e
         VaQ63kqtasP8LUkKOO87Uhwv6GFQ3ihWMFftWVASmM/C9k+cbNvm+BI3qDrgWEiTzmGv
         P9DkqcVv7w4rQVTq3bXv1QEcyoiFhx9MXfGk5rw+9FnOGBodg+8/9OCDPYbDDJAa+6j8
         vzRA==
X-Gm-Message-State: ANoB5pkumoa+Cyg36q7+4vl0qpkhu/DpJBgIt6wNMCGy/Doozm0Pa347
        hBgE3+kmfUHfUhakUzexNZ+Law==
X-Google-Smtp-Source: AA0mqf5xxsOgNUB2YZXbcbbtJVAVE6QcQm9i9oyuo3Txh3iXPhEwR4ypb+UnCsY8aq8y04JS3YdgNA==
X-Received: by 2002:a17:906:fa11:b0:7c0:d94c:f9f with SMTP id lo17-20020a170906fa1100b007c0d94c0f9fmr12177439ejb.542.1670359885503;
        Tue, 06 Dec 2022 12:51:25 -0800 (PST)
Received: from localhost ([2a02:8070:6387:ab20:15aa:3c87:c206:d15e])
        by smtp.gmail.com with ESMTPSA id fi22-20020a1709073ad600b007c0d4d3a0c1sm4576925ejc.32.2022.12.06.12.51.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 12:51:25 -0800 (PST)
Date:   Tue, 6 Dec 2022 21:51:01 +0100
From:   Johannes Weiner <hannes@cmpxchg.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Ivan Babrou <ivan@cloudflare.com>, Linux MM <linux-mm@kvack.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeelb@google.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, cgroups@vger.kernel.org,
        kernel-team <kernel-team@cloudflare.com>
Subject: Re: Low TCP throughput due to vmpressure with swap enabled
Message-ID: <Y4+rNYF9WZyJyBQp@cmpxchg.org>
References: <CABWYdi0G7cyNFbndM-ELTDAR3x4Ngm0AehEp5aP0tfNkXUE+Uw@mail.gmail.com>
 <Y30rdnZ+lrfOxjTB@cmpxchg.org>
 <CABWYdi3PqipLxnqeepXeZ471pfeBg06-PV0Uw04fU-LHnx_A4g@mail.gmail.com>
 <CABWYdi0qhWs56WK=k+KoQBAMh+Tb6Rr0nY4kJN+E5YqfGhKTmQ@mail.gmail.com>
 <Y4T43Tc54vlKjTN0@cmpxchg.org>
 <CABWYdi0z6-46PrNWumSXWki6Xf4G_EP1Nvc-2t00nEi0PiOU3Q@mail.gmail.com>
 <CABWYdi25hricmGUqaK1K0EB-pAm04vGTg=eiqRF99RJ7hM7Gyg@mail.gmail.com>
 <Y4+RPry2tfbWFdSA@cmpxchg.org>
 <CANn89iJfx4QdVBqJ23oFJoz5DJKou=ZwVBNNXFNDJRNAqNvzwQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iJfx4QdVBqJ23oFJoz5DJKou=ZwVBNNXFNDJRNAqNvzwQ@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 06, 2022 at 08:13:50PM +0100, Eric Dumazet wrote:
> On Tue, Dec 6, 2022 at 8:00 PM Johannes Weiner <hannes@cmpxchg.org> wrote:
> > @@ -1701,10 +1701,10 @@ void mem_cgroup_sk_alloc(struct sock *sk);
> >  void mem_cgroup_sk_free(struct sock *sk);
> >  static inline bool mem_cgroup_under_socket_pressure(struct mem_cgroup *memcg)
> >  {
> > -       if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && memcg->tcpmem_pressure)
> > +       if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && memcg->socket_pressure)
> 
> && READ_ONCE(memcg->socket_pressure))
> 
> >                 return true;
> >         do {
> > -               if (time_before(jiffies, READ_ONCE(memcg->socket_pressure)))
> > +               if (memcg->socket_pressure)
> 
> if (READ_ONCE(...))

Good point, I'll add those.

> > @@ -7195,10 +7194,10 @@ bool mem_cgroup_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages,
> >                 struct page_counter *fail;
> >
> >                 if (page_counter_try_charge(&memcg->tcpmem, nr_pages, &fail)) {
> > -                       memcg->tcpmem_pressure = 0;
> 
> Orthogonal to your patch, but:
> 
> Maybe avoid touching this cache line too often and use READ/WRITE_ONCE() ?
> 
>     if (READ_ONCE(memcg->socket_pressure))
>       WRITE_ONCE(memcg->socket_pressure, false);

Ah, that's a good idea.

I think it'll be fine in the failure case, since that's associated
with OOM and total performance breakdown anyway.

But certainly, in the common case of the charge succeeding, we should
not keep hammering false into that variable over and over.

How about the delta below? I also flipped the branches around to keep
the common path at the first indentation level, hopefully making that
a bit clearer too.

Thanks for taking a look, Eric!

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index ef1c388be5b3..13ae10116895 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1701,10 +1701,11 @@ void mem_cgroup_sk_alloc(struct sock *sk);
 void mem_cgroup_sk_free(struct sock *sk);
 static inline bool mem_cgroup_under_socket_pressure(struct mem_cgroup *memcg)
 {
-	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && memcg->socket_pressure)
+	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) &&
+	    READ_ONCE(memcg->socket_pressure))
 		return true;
 	do {
-		if (memcg->socket_pressure)
+		if (READ_ONCE(memcg->socket_pressure))
 			return true;
 	} while ((memcg = parent_mem_cgroup(memcg)));
 	return false;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 0d4b9dbe775a..96c4ec0f11ca 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -7193,31 +7193,29 @@ bool mem_cgroup_charge_skmem(struct mem_cgroup *memcg, unsigned int nr_pages,
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
 		struct page_counter *fail;
 
-		if (page_counter_try_charge(&memcg->tcpmem, nr_pages, &fail)) {
-			memcg->socket_pressure = false;
-			return true;
+		if (!page_counter_try_charge(&memcg->tcpmem, nr_pages, &fail)) {
+			WRITE_ONCE(memcg->socket_pressure, true);
+			if (gfp_mask & __GFP_FAIL) {
+				page_counter_charge(&memcg->tcpmem, nr_pages);
+				return true;
+			}
+			return false;
 		}
-		memcg->socket_pressure = true;
+		if (unlikely(READ_ONCE(memcg->socket_pressure)))
+			WRITE_ONCE(memcg->socket_pressure, false);
+	}
+
+	if (try_charge(memcg, gfp_mask & ~__GFP_NOFAIL, nr_pages) < 0) {
+		WRITE_ONCE(memcg->socket_pressure, true);
 		if (gfp_mask & __GFP_NOFAIL) {
-			page_counter_charge(&memcg->tcpmem, nr_pages);
+			try_charge(memcg, gfp_mask, nr_pages);
+			mod_memcg_state(memcg, MEMCG_SOCK, nr_pages);
 			return true;
 		}
 		return false;
 	}
-
-	if (try_charge(memcg, gfp_mask & ~__GFP_NOFAIL, nr_pages) == 0) {
-		memcg->socket_pressure = false;
-		goto success;
-	}
-	memcg->socket_pressure = true;
-	if (gfp_mask & __GFP_NOFAIL) {
-		try_charge(memcg, gfp_mask, nr_pages);
-		goto success;
-	}
-
-	return false;
-
-success:
+	if (unlikely(READ_ONCE(memcg->socket_pressure)))
+		WRITE_ONCE(memcg->socket_pressure, false);
 	mod_memcg_state(memcg, MEMCG_SOCK, nr_pages);
 	return true;
 }
