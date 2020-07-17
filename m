Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 825902246B3
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 01:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728425AbgGQXKb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 19:10:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728383AbgGQXK1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 19:10:27 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47F7EC0619D2
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 16:10:27 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id h22so14502512lji.9
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 16:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FmUurtNr8DsvIpsatQ0QZyiVO7vjkVTvgORSNA0VraU=;
        b=lfiFnDf5/hcNt4iNktxDTmBsFCUZHL+MYzpIy6YNbC7QlUQM6TakFJr+XrIzoNORkW
         8bmsLA3Oq27caiG0e1TMNOoCcIVS4Tb72dSY7RCl1FF7MIGsm/fFV605IUaObL4EcZt3
         elb6TRQJKRqg2Fd8aruQ1TrqlQsCQXoU0U9rAQPp93E9u0boxAPvyUzHnVwSN17g/zTJ
         oOgAiaPAN2sfkTG6KMPsu262V+0oxoemiJMnmKXOnaRuvVOdx4wkl9qWw97Y8YLmD4Ns
         cDtvEaVHQiO5i4j70j5qwCqwgnFUf7Eb/04zpIMGgGROC6T30AuKqOKg2OpAY4gmSVff
         7qpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FmUurtNr8DsvIpsatQ0QZyiVO7vjkVTvgORSNA0VraU=;
        b=Fg9oVychsP7kOYC9mHoxmk1NFMV7Mq1sru2farIr1JxlxM/1laa/cr6/OflbNTZZz5
         ZgpbDGGymdlyN7HqcWvFzutsJzYILUcgVfOB4+2LZFFKNcR5mD/6fORE2jjhpumD0gTR
         ZhpYE4tO3aYWe3vutrNZCD6KTV+BgU9cU0eAZznUeufMnoX6aXlZCxXrH3JhgFLPJu20
         cOV0yfhOxb3yrewbGLWO5+92ioaxRWLcMGHEPGCF1I+BDtxc/CGjnQ6f1CO/YLwAfqoY
         +lnT2dOrj9Zm7Vc9c7FBP3rdRKm6W9VJxysoZY9NrJFtdTe4YghjNCYV6d2qcHhLOzp9
         A2Mg==
X-Gm-Message-State: AOAM533M39CxSaJ8MDsw0xtRon+o5gesCHbKskJRCjTIpRqmM+Pk17Ov
        dU3vbc8b2yz2/Lv9WF8/pBCbVw==
X-Google-Smtp-Source: ABdhPJxFWdc1CHNgacIHbLK/JJTWJWTShV9FV/auq+6FQoYOgSaMz+P+4z+UfxI/oCDgLUPopItmAA==
X-Received: by 2002:a2e:3316:: with SMTP id d22mr5578396ljc.18.1595027425548;
        Fri, 17 Jul 2020 16:10:25 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id i8sm1880972ljg.57.2020.07.17.16.10.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2020 16:10:24 -0700 (PDT)
Received: by box.localdomain (Postfix, from userid 1000)
        id EA54F10216B; Sat, 18 Jul 2020 02:10:23 +0300 (+03)
Date:   Sat, 18 Jul 2020 02:10:23 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     syzbot <syzbot+ed318e8b790ca72c5ad0@syzkaller.appspotmail.com>
Cc:     akpm@linux-foundation.org, kirill.shutemov@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        torvalds@linux-foundation.org, william.kucharski@oracle.com,
        yang.shi@linux.alibaba.com, ziy@nvidia.com
Subject: Re: general protection fault in khugepaged
Message-ID: <20200717231023.tawtcmpwwqi2qsni@box>
References: <000000000000358aec05a9fc8aa8@google.com>
 <0000000000008ad07505aaaad631@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000008ad07505aaaad631@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 17, 2020 at 03:40:04PM -0700, syzbot wrote:
> syzbot has bisected this issue to:
> 
> commit ffe945e633b527d5a4577b42cbadec3c7cbcf096
> Author: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Date:   Wed Jun 3 23:00:09 2020 +0000
> 
>     khugepaged: do not stop collapse if less than half PTEs are referenced
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17356c2f100000
> start commit:   e44f65fd xen-netfront: remove redundant assignment to vari..
> git tree:       net-next
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=14b56c2f100000
> console output: https://syzkaller.appspot.com/x/log.txt?x=10b56c2f100000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=829871134ca5e230
> dashboard link: https://syzkaller.appspot.com/bug?extid=ed318e8b790ca72c5ad0
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=113406a7100000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=175597d3100000
> 
> Reported-by: syzbot+ed318e8b790ca72c5ad0@syzkaller.appspotmail.com
> Fixes: ffe945e633b5 ("khugepaged: do not stop collapse if less than half PTEs are referenced")
> 
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> 

My guess is that anonymous VMA got replaced by file VMA under us.

Could you reproduce the issue with the patch below? I have hard time
triggering it myself.

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index b043c40a21d4..f8ec58a1e72b 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1107,6 +1107,8 @@ static void collapse_huge_page(struct mm_struct *mm,
 	if (mm_find_pmd(mm, address) != pmd)
 		goto out;
 
+	if (!vma->anon_vma)
+		dump_vma(vma);
 	anon_vma_lock_write(vma->anon_vma);
 
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, NULL, mm,
-- 
 Kirill A. Shutemov
