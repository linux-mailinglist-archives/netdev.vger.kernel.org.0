Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DD8A83FF2
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 03:37:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730430AbfHGBgw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 21:36:52 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:38789 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729807AbfHGBef (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 21:34:35 -0400
Received: by mail-pl1-f195.google.com with SMTP id az7so38558663plb.5;
        Tue, 06 Aug 2019 18:34:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=P44t64b1Yt2CczJo6SOAPYnnEfAXhRMhGjbg0YSdFKY=;
        b=oYwU8ETglc6KiHkcA0RyRS5vGqCW2i7AIOfUQ1rGo+vD39eROBW26/892d5mL8jCka
         9NN3Xib7WtATsBiYJqkB3ezAv9jDjLgX0Nt2lJwKPO87RMwjfI/ercmqj2pogsz06Wb7
         pt7t+tRi22lEyEbjwYG4pvxEn5EP2upJ7sBYXvkRkx1OZr8K8A0zsi1zsXDmxeKjKGdS
         rd7sOAmNlVKLyRrCXgSP759pVqt58t0Qr3CX/SHM65KMfp9F8GOgkLwibGL9VUlsrg7f
         RCrbiDazxsGGGqq8tug1r4v+hpbk+DodA1qAwxGhZjgi6TOY5xhcloApNp8UIjMczhiZ
         1TFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=P44t64b1Yt2CczJo6SOAPYnnEfAXhRMhGjbg0YSdFKY=;
        b=bsLJ3tXUXUWASIgmL+I0A4zQsCCo3ZAnnkIM6g4/UilS3ZEjcVvmSLvMd0dRklRr8X
         hyoqDXH9DtMmY91+h8xoM7IhLK21oHfzvce+48oyfg5DM1mRqP2vGSXgch+xfa2y2bEt
         7jlEbKHdHSBKD8Dfz5oH4WCD6wLpnEeCIjdro041sNyjHyFnFVpSRiEV88/z/1C3ZjOI
         /NbxlGFL2ZdNby34elbdb68Q11lGLk3yHjOjV5tyOCvtGYIXIbe6P/JAALWPTzP9DgB3
         auaffKQsvjqsnua5pSxLQrLRsi4CGpVPno1aW6XYEZUboF6FqbqdasoqBUcPmJL63SXk
         +E7w==
X-Gm-Message-State: APjAAAUslQu9CLEkPRDToRLK0yv8UX2Xtsbeg2a9DzXWKOASdfvWFL41
        87McRU3aPO3EN9l1H4Q1OAE=
X-Google-Smtp-Source: APXvYqw8+L1VoxRPbf6Y+c4qD8GNaA9eNx8R+zkKMbLiZR/mjctguTvKD53OkN4n/knnADLxacIAYA==
X-Received: by 2002:a17:902:7782:: with SMTP id o2mr5960829pll.12.1565141674655;
        Tue, 06 Aug 2019 18:34:34 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id u69sm111740800pgu.77.2019.08.06.18.34.32
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 18:34:34 -0700 (PDT)
From:   john.hubbard@gmail.com
X-Google-Original-From: jhubbard@nvidia.com
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Chinner <david@fromorbit.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        amd-gfx@lists.freedesktop.org, ceph-devel@vger.kernel.org,
        devel@driverdev.osuosl.org, devel@lists.orangefs.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-block@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linux-nfs@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org, linux-xfs@vger.kernel.org,
        netdev@vger.kernel.org, rds-devel@oss.oracle.com,
        sparclinux@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xenproject.org, John Hubbard <jhubbard@nvidia.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Christopher Yeoh <cyeoh@au1.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Jann Horn <jann@thejh.net>,
        Lorenzo Stoakes <lstoakes@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Rashika Kheria <rashika.kheria@gmail.com>
Subject: [PATCH v3 31/41] mm/process_vm_access.c: convert put_page() to put_user_page*()
Date:   Tue,  6 Aug 2019 18:33:30 -0700
Message-Id: <20190807013340.9706-32-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190807013340.9706-1-jhubbard@nvidia.com>
References: <20190807013340.9706-1-jhubbard@nvidia.com>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: John Hubbard <jhubbard@nvidia.com>

For pages that were retained via get_user_pages*(), release those pages
via the new put_user_page*() routines, instead of via put_page() or
release_pages().

This is part a tree-wide conversion, as described in commit fc1d8e7cca2d
("mm: introduce put_user_page*(), placeholder versions").

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Christopher Yeoh <cyeoh@au1.ibm.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jann Horn <jann@thejh.net>
Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Rashika Kheria <rashika.kheria@gmail.com>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 mm/process_vm_access.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/mm/process_vm_access.c b/mm/process_vm_access.c
index 357aa7bef6c0..4d29d54ec93f 100644
--- a/mm/process_vm_access.c
+++ b/mm/process_vm_access.c
@@ -96,7 +96,7 @@ static int process_vm_rw_single_vec(unsigned long addr,
 		flags |= FOLL_WRITE;
 
 	while (!rc && nr_pages && iov_iter_count(iter)) {
-		int pages = min(nr_pages, max_pages_per_loop);
+		int pinned_pages = min(nr_pages, max_pages_per_loop);
 		int locked = 1;
 		size_t bytes;
 
@@ -106,14 +106,15 @@ static int process_vm_rw_single_vec(unsigned long addr,
 		 * current/current->mm
 		 */
 		down_read(&mm->mmap_sem);
-		pages = get_user_pages_remote(task, mm, pa, pages, flags,
-					      process_pages, NULL, &locked);
+		pinned_pages = get_user_pages_remote(task, mm, pa, pinned_pages,
+						     flags, process_pages, NULL,
+						     &locked);
 		if (locked)
 			up_read(&mm->mmap_sem);
-		if (pages <= 0)
+		if (pinned_pages <= 0)
 			return -EFAULT;
 
-		bytes = pages * PAGE_SIZE - start_offset;
+		bytes = pinned_pages * PAGE_SIZE - start_offset;
 		if (bytes > len)
 			bytes = len;
 
@@ -122,10 +123,9 @@ static int process_vm_rw_single_vec(unsigned long addr,
 					 vm_write);
 		len -= bytes;
 		start_offset = 0;
-		nr_pages -= pages;
-		pa += pages * PAGE_SIZE;
-		while (pages)
-			put_page(process_pages[--pages]);
+		nr_pages -= pinned_pages;
+		pa += pinned_pages * PAGE_SIZE;
+		put_user_pages(process_pages, pinned_pages);
 	}
 
 	return rc;
-- 
2.22.0

