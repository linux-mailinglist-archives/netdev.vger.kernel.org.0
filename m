Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 583627E935
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 04:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389441AbfHBCXk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 22:23:40 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:41089 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390928AbfHBCUu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 22:20:50 -0400
Received: by mail-pf1-f196.google.com with SMTP id m30so35165086pff.8;
        Thu, 01 Aug 2019 19:20:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rRiJNzkH0bRoPJKYXoQcsROADD9YH4USeXVLEsmAa1E=;
        b=IdQZjyJhMTiA3ru+rOrbTXLCRfg1Iz7YPF+8DSWpdWDcWtOO1jwAD+njJSqb4AFsL3
         BoorK7WVXpk5wvzf+3MNWsWlqvxT2AU71m913kuKWpgnoA+0ZYT8hPv0DG2k2t5CL0So
         4HfYIB1+xctKU8nZMy0TNVHkmmwgfvFDwPBOEjDSZMguKyYiKdAvH/kYmRGOOCm1PmW7
         4QVOBE2D85KD1ebTOdlBPaqm/TGzFf20gzANQLnGH2MHePv/KbpSRa5elxYK3OTWVg7W
         lX3umVSebAxAiH6LaR7v6UhLbExl0YmQ1qyvKE73k3aH42K6tSy55ZxlEvZWhHEAZhKs
         EwnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rRiJNzkH0bRoPJKYXoQcsROADD9YH4USeXVLEsmAa1E=;
        b=AbFwA1Uu+pcF8pEqEcAUrfocBm9hf+Tk7+jwXDXXUrHTiLrZXC+GUuxOLrULgU8uRz
         jeJhDDLqhap1RAhWfFeODvxoZqlhxzMDMQkQPrrvsNEz9fud1nR49+orx+NGCMQxvM5W
         DtLpW46RLQf57SQe2XerKvyzgUZC6+Ahhtlq7r+qbA1H9NjwJ4SxDMw1pG7VmiKpiOWt
         PQMe456cyul85gR/OXG1kO7kQjT5/JI/R3Zv6Ewf9HTr942sMbCplSpTBk7BOq02eCc7
         j90AMOFeibWqqj1YX68qQxW+4GBgoLbMMfcWONpQ8UP1u04rZyAZ+Bmo1MtI9sFW9dnX
         YUhQ==
X-Gm-Message-State: APjAAAVdVKyaoyEQK6+PgS9APZcr6UMgm26WQetGxI2qPUPJwoSXti0Q
        yJvu2JHTI39aBt/22QkhpHg=
X-Google-Smtp-Source: APXvYqyQ9NWbm7e7UjvOHtMhAwjS+tkI0uFYNRjX3KlyXdyqOSjy3adbw2n2ONz+amcM+RqqbPvknQ==
X-Received: by 2002:a17:90a:cb15:: with SMTP id z21mr1894788pjt.87.1564712449418;
        Thu, 01 Aug 2019 19:20:49 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id u9sm38179744pgc.5.2019.08.01.19.20.47
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 01 Aug 2019 19:20:48 -0700 (PDT)
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
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@infradead.org>
Subject: [PATCH 24/34] futex: convert put_page() to put_user_page*()
Date:   Thu,  1 Aug 2019 19:19:55 -0700
Message-Id: <20190802022005.5117-25-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802022005.5117-1-jhubbard@nvidia.com>
References: <20190802022005.5117-1-jhubbard@nvidia.com>
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

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Darren Hart <dvhart@infradead.org>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 kernel/futex.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 6d50728ef2e7..4b4cae58ec57 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -623,7 +623,7 @@ get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key, enum futex_a
 		lock_page(page);
 		shmem_swizzled = PageSwapCache(page) || page->mapping;
 		unlock_page(page);
-		put_page(page);
+		put_user_page(page);
 
 		if (shmem_swizzled)
 			goto again;
@@ -675,7 +675,7 @@ get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key, enum futex_a
 
 		if (READ_ONCE(page->mapping) != mapping) {
 			rcu_read_unlock();
-			put_page(page);
+			put_user_page(page);
 
 			goto again;
 		}
@@ -683,7 +683,7 @@ get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key, enum futex_a
 		inode = READ_ONCE(mapping->host);
 		if (!inode) {
 			rcu_read_unlock();
-			put_page(page);
+			put_user_page(page);
 
 			goto again;
 		}
@@ -702,7 +702,7 @@ get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key, enum futex_a
 		 */
 		if (!atomic_inc_not_zero(&inode->i_count)) {
 			rcu_read_unlock();
-			put_page(page);
+			put_user_page(page);
 
 			goto again;
 		}
@@ -723,7 +723,7 @@ get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key, enum futex_a
 	}
 
 out:
-	put_page(page);
+	put_user_page(page);
 	return err;
 }
 
-- 
2.22.0

