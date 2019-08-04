Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2784180E1C
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 00:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728258AbfHDWwx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 18:52:53 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:45950 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727591AbfHDWtx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 18:49:53 -0400
Received: by mail-pg1-f193.google.com with SMTP id o13so38646908pgp.12;
        Sun, 04 Aug 2019 15:49:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6GC3vp7Kgk6wrS2t1aIFSliRmKpmpPmHRVTf1Sq+2hE=;
        b=dM/IGJPKx3vHMSaH2jjH8cddB9IjzpJgXXKkO7CuRXnxMJrRMmXVqwBAlQ88WzjX5h
         dPH11zKs16Cup5MqaIdJ1qgQ5dnUSJO3TyirSMdWy1ehRY6u0fAfZaZVJnTvSLI1QoSZ
         1OPtp46Njt0JJnUOBtfou4qDlL/RKFcmnKhvrMMghCphBN24qaIVDJrBrmeB7g2Z62x7
         9z4wjKe5TgqpPsxN1F6MtFwbERWIIYczU3Vlcoi9Bn6Io4pS8zl9BxvD7OfIkvOk2DHe
         bKWOTx3ItGlZJtYz9ERx5/QSr4d6lkRb9ThyPESwSqEPXbfdWPFzLZ85HYqnnwwoanPc
         GvtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6GC3vp7Kgk6wrS2t1aIFSliRmKpmpPmHRVTf1Sq+2hE=;
        b=JUIHZ2gwKKm20q1TjMkNvKR6J1817UySQULYW1WPi+DTw86hR5sVfePl8z93L9g1x/
         840ZyHocRYjV+Puch94aKZ106vJAvcB5He+DwsBDcx3bDZO4vkVqwuJHG9oLq3y9ZuRf
         khEZNzstACWi7qvw6RRyOa7c3gozlSNqTyMg+7NI8Hs0F15lFDmnv10par+J/d0yag2N
         Rwh2l+Z4nhxy35FUPE8Q22bhjDF4NtHNRJ7/0MiVmPO+r9Qy5GTlIxAEqoUDa04giUcU
         /0Z2MS1I9lqiT3Y8+qvm502eoNImDSPW0oJXLKW1vVM+MCLAC0Ge2e8kWj5gP1bCghce
         Fpvw==
X-Gm-Message-State: APjAAAVCuY8heHKpYTYBfIEZKne+ZFoqXJ/02ynvvdHyQBNT1kEV1ILH
        Bvy2L0ip7qnqNCIK7Yi2y3M=
X-Google-Smtp-Source: APXvYqwq/YfHOhrmZHkD7vjJE2TMWCM5ZcaZGqo7qwngyLyrDMEmQDpJGD3vf7HiLmlT/OfJiu4DXA==
X-Received: by 2002:a17:90a:360c:: with SMTP id s12mr15495527pjb.30.1564958992495;
        Sun, 04 Aug 2019 15:49:52 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id r6sm35946836pjb.22.2019.08.04.15.49.51
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 04 Aug 2019 15:49:52 -0700 (PDT)
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
Subject: [PATCH v2 21/34] fs/exec.c: convert put_page() to put_user_page*()
Date:   Sun,  4 Aug 2019 15:49:02 -0700
Message-Id: <20190804224915.28669-22-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190804224915.28669-1-jhubbard@nvidia.com>
References: <20190804224915.28669-1-jhubbard@nvidia.com>
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

