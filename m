Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4E89634BC4
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 01:44:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235312AbiKWAov (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 19:44:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233443AbiKWAou (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 19:44:50 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AE4AC6943
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 16:44:49 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id z9so7883149ilu.10
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 16:44:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qt0Oia7FwaxA/+PML2ZHZEDGbQNkFk0tG08XyL42aso=;
        b=HgwUhGpb33lLR5Ugn3ck6loKESVPF+muFD2n7g9xAqGCgk+iXjDli12LYoWqeAOrci
         V58UVErhfmJkb8fexsEJtvDKBMIDN/PQ6yaxPgykccn9xBnGZuEq8Cp9Pw2Yd+QziERV
         wIQbQOKm76lQJ3jfzJ4yFwXwu64V78qH60+vy6tsE66sT9S7WzbfLhKvBNuRIydbFuWA
         Ikb3/PR4Ep2k2UqCFkwnebgWeZqPXNQ/NBN4ksDtHEw+UafQjqlMfyoU5g+kHkGpb4j2
         4D7vwm/J9pjdkou6LGgJK6qBvATodfaV4bKkEUA7oIIdcKra4IihOLjatPFywDAkQGml
         YPOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qt0Oia7FwaxA/+PML2ZHZEDGbQNkFk0tG08XyL42aso=;
        b=BpceeJ0nbiPi1i/dBGt//JViEdKzDrLQKdjxkW9tvaGwqg/7TCK/7qfw471qGjJhwt
         rNQVWNh6UpMP4ikQWnyryTvJDQBX7Qrnd00qRUbN0OqXBN69MSjwONw/y/XhILHPow7f
         0Er0mpe+cT4yLNS3S7En7mGerfnYhKN+xDLJSjxqsczUE9IJzUoDIfpbg9sBhrRi2Iqp
         QztCJr8SsuTqwVHwDjGsoLs8faGisEP0J8aSg3JnrJgyPImZ9nK15gGoatdKQ+HN8KmT
         kjCoULBbUlIrvt2N+cQ3Ua4yxPxMF52ffY/83LSURGzl9fw/x5i3WknjmDFbBMqOywtd
         BY9g==
X-Gm-Message-State: ANoB5pkS0HkZa3A30X41TAzWoqvGZ45WAi+Uw8u4jwV4xWIi5JZkV1Ah
        7ATl7fDoe/1tIi1WiGgeX0yg6xKoRmMCSQ==
X-Google-Smtp-Source: AA0mqf6zhajD41LQHGsku1D72fTtdOapRkc5Le4GLeMD3oRGuOLOFO0UH1PgSQNqMi55bgnDU0xwRw==
X-Received: by 2002:a05:6e02:50a:b0:302:a672:a25a with SMTP id d10-20020a056e02050a00b00302a672a25amr2836612ils.68.1669164288366;
        Tue, 22 Nov 2022 16:44:48 -0800 (PST)
Received: from google.com ([2620:15c:183:200:5e97:e61d:2d36:6a3f])
        by smtp.gmail.com with ESMTPSA id d15-20020a0566022bef00b006cecd92164esm5807898ioy.34.2022.11.22.16.44.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 16:44:47 -0800 (PST)
Date:   Tue, 22 Nov 2022 17:44:44 -0700
From:   Yu Zhao <yuzhao@google.com>
To:     Ivan Babrou <ivan@cloudflare.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Cc:     Linux MM <linux-mm@kvack.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeelb@google.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, cgroups@vger.kernel.org,
        kernel-team <kernel-team@cloudflare.com>
Subject: Re: Low TCP throughput due to vmpressure with swap enabled
Message-ID: <Y31s/K8T85jh05wH@google.com>
References: <CABWYdi0G7cyNFbndM-ELTDAR3x4Ngm0AehEp5aP0tfNkXUE+Uw@mail.gmail.com>
 <CAOUHufYd-5cqLsQvPBwcmWeph2pQyQYFRWynyg0UVpzUBWKbxw@mail.gmail.com>
 <CAOUHufYSeTeO5ZMpnCR781esHV4QV5Th+pd=52UaM9cXNNKF9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOUHufYSeTeO5ZMpnCR781esHV4QV5Th+pd=52UaM9cXNNKF9w@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 01:05:32PM -0700, Yu Zhao wrote:
> On Tue, Nov 22, 2022 at 12:46 PM Yu Zhao <yuzhao@google.com> wrote:
> >
> > On Mon, Nov 21, 2022 at 5:53 PM Ivan Babrou <ivan@cloudflare.com> wrote:
> > >
> > > Hello,
> > >
> > > We have observed a negative TCP throughput behavior from the following commit:
> > >
> > > * 8e8ae645249b mm: memcontrol: hook up vmpressure to socket pressure
> > >
> > > It landed back in 2016 in v4.5, so it's not exactly a new issue.
> > >
> > > The crux of the issue is that in some cases with swap present the
> > > workload can be unfairly throttled in terms of TCP throughput.
> > >
> > > I am able to reproduce this issue in a VM locally on v6.1-rc6 with 8
> > > GiB of RAM with zram enabled.
> > >
> > > The setup is fairly simple:
> > >
> > > 1. Run the following go proxy in one cgroup (it has some memory
> > > ballast to simulate useful memory usage):
> > >
> > > * https://gist.github.com/bobrik/2c1a8a19b921fefe22caac21fda1be82
> > >
> > > sudo systemd-run --scope -p MemoryLimit=6G go run main.go
> > >
> > > 2. Run the following fio config in another cgroup to simulate mmapped
> > > page cache usage:
> > >
> > > [global]
> > > size=8g
> > > bs=256k
> > > iodepth=256
> > > direct=0
> > > ioengine=mmap
> > > group_reporting
> > > time_based
> > > runtime=86400
> > > numjobs=8
> > > name=randread
> > > rw=randread
> >
> > Is it practical for your workload to apply some madvise/fadvise hint?
> > For the above repro, it would be fadvise_hint=1 which is mapped into
> > MADV_RANDOM automatically. The kernel also supports MADV_SEQUENTIAL,
> > but not POSIX_FADV_NOREUSE at the moment.
> 
> Actually fadvise_hint already defaults to 1. At least with MGLRU, the
> page cache should be thrown away without causing you any problem. It
> might be mapped to POSIX_FADV_RANDOM rather than MADV_RANDOM.
> POSIX_FADV_RANDOM is ignored at the moment.
> 
> Sorry for all the noise. Let me dig into this and get back to you later today.
> 
> 
> > We actually have similar issues but unfortunately I haven't been able
> > to come up with any solution beyond recommending the above flags.
> > The problem is that harvesting the accessed bit from mmapped memory is
> > costly, and when random accesses happen fast enough, the cost of doing
> > that prevents LRU from collecting more information to make better
> > decisions. In a nutshell, LRU can't tell whether there is genuine
> > memory locality with your test case.
> >
> > It's a very difficult problem to solve from LRU's POV. I'd like to
> > hear more about your workloads and see whether there are workarounds
> > other than tackling the problem head-on, if applying hints is not
> > practical or preferrable.

Apparently MADV_RANDOM isn't properly handled in MGLRU. (I think I broke
it at some point but have yet to find out when.)

I tried the patch below with a test case similar to yours and it shows
improvements for both the baseline and MGLRU. It should fix the problem
for your repro but not your production unless it also does madvise. So
no worries if you don't care to try.


Hi Johannes,

Do you think it makes sense to have the below for both the baseline and
MGLRU or it's some behavior change that the baseline doesn't want to
risk?

Thanks.


diff --git a/include/linux/fs.h b/include/linux/fs.h
index e654435f1651..632e0f462df9 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -166,6 +166,8 @@ typedef int (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 /* File supports DIRECT IO */
 #define	FMODE_CAN_ODIRECT	((__force fmode_t)0x400000)
 
+#define	FMODE_NOREUSE		((__force fmode_t)0x800000)
+
 /* File was opened by fanotify and shouldn't generate fanotify events */
 #define FMODE_NONOTIFY		((__force fmode_t)0x4000000)
 
diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 2f53c31216de..4122a4db5b49 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -595,4 +595,15 @@ pte_install_uffd_wp_if_needed(struct vm_area_struct *vma, unsigned long addr,
 #endif
 }
 
+static inline bool vma_has_locality(struct vm_area_struct *vma)
+{
+	if (vma->vm_flags & (VM_SEQ_READ | VM_RAND_READ))
+		return false;
+
+	if (vma->vm_file && (vma->vm_file->f_mode & FMODE_NOREUSE))
+		return false;
+
+	return true;
+}
+
 #endif
diff --git a/mm/fadvise.c b/mm/fadvise.c
index c76ee665355a..2ba24d865bf5 100644
--- a/mm/fadvise.c
+++ b/mm/fadvise.c
@@ -80,7 +80,7 @@ int generic_fadvise(struct file *file, loff_t offset, loff_t len, int advice)
 	case POSIX_FADV_NORMAL:
 		file->f_ra.ra_pages = bdi->ra_pages;
 		spin_lock(&file->f_lock);
-		file->f_mode &= ~FMODE_RANDOM;
+		file->f_mode &= ~(FMODE_RANDOM | FMODE_NOREUSE);
 		spin_unlock(&file->f_lock);
 		break;
 	case POSIX_FADV_RANDOM:
@@ -107,6 +107,9 @@ int generic_fadvise(struct file *file, loff_t offset, loff_t len, int advice)
 		force_page_cache_readahead(mapping, file, start_index, nrpages);
 		break;
 	case POSIX_FADV_NOREUSE:
+		spin_lock(&file->f_lock);
+		file->f_mode |= FMODE_NOREUSE;
+		spin_unlock(&file->f_lock);
 		break;
 	case POSIX_FADV_DONTNEED:
 		__filemap_fdatawrite_range(mapping, offset, endbyte,
diff --git a/mm/memory.c b/mm/memory.c
index f88c351aecd4..69fba1d58eb2 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1448,8 +1448,7 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
 					force_flush = 1;
 					set_page_dirty(page);
 				}
-				if (pte_young(ptent) &&
-				    likely(!(vma->vm_flags & VM_SEQ_READ)))
+				if (pte_young(ptent) && likely(vma_has_locality(vma)))
 					mark_page_accessed(page);
 			}
 			rss[mm_counter(page)]--;
@@ -5161,8 +5160,7 @@ static inline void mm_account_fault(struct pt_regs *regs,
 #ifdef CONFIG_LRU_GEN
 static void lru_gen_enter_fault(struct vm_area_struct *vma)
 {
-	/* the LRU algorithm doesn't apply to sequential or random reads */
-	current->in_lru_fault = !(vma->vm_flags & (VM_SEQ_READ | VM_RAND_READ));
+	current->in_lru_fault = vma_has_locality(vma);
 }
 
 static void lru_gen_exit_fault(void)
diff --git a/mm/rmap.c b/mm/rmap.c
index 2ec925e5fa6a..b1bb492115ae 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -823,25 +823,14 @@ static bool folio_referenced_one(struct folio *folio,
 		}
 
 		if (pvmw.pte) {
-			if (lru_gen_enabled() && pte_young(*pvmw.pte) &&
-			    !(vma->vm_flags & (VM_SEQ_READ | VM_RAND_READ))) {
+			if (lru_gen_enabled() && pte_young(*pvmw.pte)) {
 				lru_gen_look_around(&pvmw);
 				referenced++;
 			}
 
 			if (ptep_clear_flush_young_notify(vma, address,
-						pvmw.pte)) {
-				/*
-				 * Don't treat a reference through
-				 * a sequentially read mapping as such.
-				 * If the folio has been used in another mapping,
-				 * we will catch it; if this other mapping is
-				 * already gone, the unmap path will have set
-				 * the referenced flag or activated the folio.
-				 */
-				if (likely(!(vma->vm_flags & VM_SEQ_READ)))
-					referenced++;
-			}
+						pvmw.pte))
+				referenced++;
 		} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
 			if (pmdp_clear_flush_young_notify(vma, address,
 						pvmw.pmd))
@@ -875,7 +864,15 @@ static bool invalid_folio_referenced_vma(struct vm_area_struct *vma, void *arg)
 	struct folio_referenced_arg *pra = arg;
 	struct mem_cgroup *memcg = pra->memcg;
 
-	if (!mm_match_cgroup(vma->vm_mm, memcg))
+	if (!vma_has_locality(vma))
+		return true;
+
+	/*
+	 * If we are reclaiming on behalf of a cgroup, skip
+	 * counting on behalf of references from different
+	 * cgroups
+	 */
+	if (memcg && !mm_match_cgroup(vma->vm_mm, memcg))
 		return true;
 
 	return false;
@@ -921,14 +918,7 @@ int folio_referenced(struct folio *folio, int is_locked,
 			return 1;
 	}
 
-	/*
-	 * If we are reclaiming on behalf of a cgroup, skip
-	 * counting on behalf of references from different
-	 * cgroups
-	 */
-	if (memcg) {
-		rwc.invalid_vma = invalid_folio_referenced_vma;
-	}
+	rwc.invalid_vma = invalid_folio_referenced_vma;
 
 	rmap_walk(folio, &rwc);
 	*vm_flags = pra.vm_flags;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 7d3cc787b840..97ce5d37d67c 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3742,7 +3742,10 @@ static int should_skip_vma(unsigned long start, unsigned long end, struct mm_wal
 	if (is_vm_hugetlb_page(vma))
 		return true;
 
-	if (vma->vm_flags & (VM_LOCKED | VM_SPECIAL | VM_SEQ_READ | VM_RAND_READ))
+	if (!vma_has_locality(vma))
+		return true;
+
+	if (vma->vm_flags & (VM_LOCKED | VM_SPECIAL))
 		return true;
 
 	if (vma == get_gate_vma(vma->vm_mm))
