Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE7438406F
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 03:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730400AbfHGBiZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 21:38:25 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36706 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729522AbfHGBeX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 21:34:23 -0400
Received: by mail-pg1-f193.google.com with SMTP id l21so42540418pgm.3;
        Tue, 06 Aug 2019 18:34:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6GC3vp7Kgk6wrS2t1aIFSliRmKpmpPmHRVTf1Sq+2hE=;
        b=NDRrGTHqLYH0GVc6uMIRr4mVyV40WfAqYn7w+X7B2+KxadDpBkUoDH1692sptrKq4y
         C2b84L9+UrVSHeZfQfv6N2zieXkMMjWSuutP0ntWCNqq+OA3nS79IQYMOR/Bean1Ukkm
         w7u/RLKab4ibriFSyZKOgsWuNa5tCFv8C2bD6EQGHf8xo4i0ZMfxDnYEz3SYXrEQ1CAQ
         ph6xeZb31fEX0ILajRxBkvT5tnY8c7uU4gyqYPRAJWZF0hsMvVjXdHAtEuwcqejfTPc4
         Etr29q0fUGsdTj13fryfrujh6CCSRKTL9s9VWAxoxYETeOz9px/+oFZuuGBV9dnVGiqV
         vySQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6GC3vp7Kgk6wrS2t1aIFSliRmKpmpPmHRVTf1Sq+2hE=;
        b=tCRLTh+bR3OqbuD0NA3YklVOaTgsUHrUmvuRb/o6ZPScJdVDv0xAynsJVVftwR49qG
         5AwzbWLzAqk1tqE1tM9HxfhSFvRvvips0WFZLUbTcYSs4+HN6TsxjkVKMYDFFSVuTblr
         dWYwe5cVbDCmmO0PYtATxTphlwIthNcVOxGZCGFdNdNVTnUiThd+gPXltT5fakCY+osz
         oTzOhXaOkYwxsY6sND8cDG1H4XlDUuW3k0udTVnl/dVCfualte/duSxSs/qN4FBAerzl
         F4klGi1v6NIk0YZreOBIGSLavvGYWAZzLogJ2+NCtMuEgiVFBzmjiszCxbnC683yKkYs
         l9Jg==
X-Gm-Message-State: APjAAAWoFkPpdF6qNbEolmVODBZ58qWExoIlZeVeg+ezsI8hHzrdQt96
        Ieg9it6pmqMJF079w1QhlBM=
X-Google-Smtp-Source: APXvYqwBJlH3d0L/1BSxFnL+vLT8aQU3g2pJmlFcXlcqO/GjIhh0NRs5+pZNe4h8FrEWDwW4ivgjRA==
X-Received: by 2002:a63:124a:: with SMTP id 10mr5554258pgs.254.1565141661706;
        Tue, 06 Aug 2019 18:34:21 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id u69sm111740800pgu.77.2019.08.06.18.34.20
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 18:34:21 -0700 (PDT)
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
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH v3 23/41] fs/exec.c: convert put_page() to put_user_page*()
Date:   Tue,  6 Aug 2019 18:33:22 -0700
Message-Id: <20190807013340.9706-24-jhubbard@nvidia.com>
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

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 fs/exec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/exec.c b/fs/exec.c
index f7f6a140856a..ee442151582f 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -227,7 +227,7 @@ static struct page *get_arg_page(struct linux_binprm *bprm, unsigned long pos,
 
 static void put_arg_page(struct page *page)
 {
-	put_page(page);
+	put_user_page(page);
 }
 
 static void free_arg_pages(struct linux_binprm *bprm)
-- 
2.22.0

