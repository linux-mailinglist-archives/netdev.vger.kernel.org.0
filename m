Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD0B83F91
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 03:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730305AbfHGBfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 21:35:38 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:40834 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730010AbfHGBes (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 21:34:48 -0400
Received: by mail-pg1-f196.google.com with SMTP id w10so42542887pgj.7;
        Tue, 06 Aug 2019 18:34:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=H0Etnn7JHR8H7TocLV05oLauZ77NAi3PGTTr9FTaKTw=;
        b=eS3YB7ZT4YXwuCcgQbB/xbD+n10dBypw+iZZVQIUwi66vhDfcSIp39QkGkG7an7OJl
         OiukENJvNGRlLtpSvoOFB7XysgcSlBHri3dSlfLLl2JoybffI8wnImTZeHQEdnORxVLa
         EBXGZhIf+YSKbjfkupoovScD765pOoXW+wmQ3q47Y78G67P4azJFj7Z03p0IlFla0TF0
         WGS9epzDu3lNP0Hir82G8T/Dsucq+VMZQ717BtULEmOp/zZ+HeTgTfaZfag+K5X0r5bl
         +CKlJZyT3xTot1t0x6sX+RloIZlzVtbmPtAqvydRbxbh9+Ay6+ppy+Ss6WRVBPk23UrF
         ZgCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H0Etnn7JHR8H7TocLV05oLauZ77NAi3PGTTr9FTaKTw=;
        b=fSJ2AsSOXC0LDl/D/lBc6CzNf4M1WdOxZm1Vt0frrTx+zBGvKl7bgvLvDtyhkboebH
         fptzv6R8IhMcZkVwxmjQo1g+gWV+RYsD1evXUJB/1ulkagtGsA65lnK46DLV84UqIMJz
         OuuDK2sUbKjNoFitVLK0NRS+O7XiWfvBuWenhcT1zDkRpczvuCCYGwBYctBeV7Q6R3Xe
         pP6/EnTNOkLBhidjWKWgVq9zbnkeT6i5BTjIRIMTx8uIzKIcuxMwiYwowuzqZ9vXyHpH
         EcIVnzZqngEHm1fKStnApLrRffNFHsLJOONy7Ikd4koQB44iHAuq7/6+b1eo2oqKbQQT
         0Frw==
X-Gm-Message-State: APjAAAXNMcwFSP0vdANjL5DkOeyIha8hAu+NAfeMQuLX9ZV1XmHZOHMJ
        XqxLU+aQ1IKUIhT+ktvDWgs=
X-Google-Smtp-Source: APXvYqzWWP/A0o9J09jCJjajCJWgGO/EPyZUANiBcpDufZXSuOwgzfu98JYNHWmK3CJ1oF9MD+qnUg==
X-Received: by 2002:aa7:8201:: with SMTP id k1mr6559788pfi.97.1565141687010;
        Tue, 06 Aug 2019 18:34:47 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id u69sm111740800pgu.77.2019.08.06.18.34.45
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 18:34:46 -0700 (PDT)
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
        Daniel Black <daniel@linux.ibm.com>,
        Matthew Wilcox <willy@infradead.org>,
        Mike Kravetz <mike.kravetz@oracle.com>
Subject: [PATCH v3 39/41] mm/mlock.c: convert put_page() to put_user_page*()
Date:   Tue,  6 Aug 2019 18:33:38 -0700
Message-Id: <20190807013340.9706-40-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190807013340.9706-1-jhubbard@nvidia.com>
References: <20190807013340.9706-1-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Daniel Black <daniel@linux.ibm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 mm/mlock.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/mlock.c b/mm/mlock.c
index a90099da4fb4..b980e6270e8a 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -345,7 +345,7 @@ static void __munlock_pagevec(struct pagevec *pvec, struct zone *zone)
 				get_page(page); /* for putback_lru_page() */
 				__munlock_isolated_page(page);
 				unlock_page(page);
-				put_page(page); /* from follow_page_mask() */
+				put_user_page(page); /* from follow_page_mask() */
 			}
 		}
 	}
@@ -467,7 +467,7 @@ void munlock_vma_pages_range(struct vm_area_struct *vma,
 		if (page && !IS_ERR(page)) {
 			if (PageTransTail(page)) {
 				VM_BUG_ON_PAGE(PageMlocked(page), page);
-				put_page(page); /* follow_page_mask() */
+				put_user_page(page); /* follow_page_mask() */
 			} else if (PageTransHuge(page)) {
 				lock_page(page);
 				/*
@@ -478,7 +478,7 @@ void munlock_vma_pages_range(struct vm_area_struct *vma,
 				 */
 				page_mask = munlock_vma_page(page);
 				unlock_page(page);
-				put_page(page); /* follow_page_mask() */
+				put_user_page(page); /* follow_page_mask() */
 			} else {
 				/*
 				 * Non-huge pages are handled in batches via
-- 
2.22.0

