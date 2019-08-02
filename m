Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 767AD7E9FD
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 04:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389246AbfHBCUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 22:20:19 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:40730 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389155AbfHBCUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 22:20:17 -0400
Received: by mail-pg1-f196.google.com with SMTP id w10so35239351pgj.7;
        Thu, 01 Aug 2019 19:20:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=weSPcOAlMB+nks0BWLOsxsBmAu907UZGrfndvq6oQnc=;
        b=g/PNAVO1jcA7rjmvur5Gi5SyBm+cHCwd0FZu0S4Yd4WKYY8nqKUy+Kjq5L8LbAIDam
         oq+DMw/apiFaV6V9t2AYTvJ0UtZRGdqpPgiFYeIHq5U9A659jHv3iijVBsi80zStn1WW
         yA7d3ZYX2ikKALXpz54vXEPMXgXSlYxT87JksMZBQueD34Vn0QLhvvHOTCuzyirgAxhY
         PS1hXIRKbtV044f7MD5ThhAFxJavcS5DN9nP30sURDOyWv4TACAbp0MhELnCZVrxEr+Y
         L5R1pu68TEBkTXOjXzFMyL79KTHMlgJNcYv+KmIulF31bskwh/7J7wKRv6nstiIy1Eix
         KMbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=weSPcOAlMB+nks0BWLOsxsBmAu907UZGrfndvq6oQnc=;
        b=o4Eqi8NJ0wrOgekR+b4mBIVpr6KbsQXS3DQa9QvDakCgzYaTpPlxZZ50AH1P0+qVhz
         Y4Qdv9sHWh2WJtP5AA8Ajzv385nmCb7cL+tSMKs6fD4pKIXe6gnlUx+P380aYNAT20nK
         0x21ZufVpnU+TdhQVIS6cGOlWksgQkg1Pvm+AbyR+FAtjGLmXb+Fpfw+jRL5k/YxIyRw
         LqyaWFSH+QgWM/2HigiM7wPqVEnpx8ahi/nHdR+7jnlbowtdZaPjIP0I+XZbzIhAsUHG
         l3FBUsS3UpggWPWtH2Oj62tam+4TqHrqe02Xqbra4O/bXG7DJ8gMkZCAsffn26XJMAFb
         Pi+w==
X-Gm-Message-State: APjAAAXeIYaK0sqKy/FlsaNEbgpXd6EvbXHN7Dza7eHie3mkT3ADHUyn
        sO0AAF8XzSe8iRThNQnLlaIqrhd3
X-Google-Smtp-Source: APXvYqxciGgcMDXcQ3A2dbcQcp1f7eltXWtJvGVKyn0lRu+bq9UEFtA9QCl9A6sNDZqj7/W8XpREEA==
X-Received: by 2002:a17:90a:2385:: with SMTP id g5mr1977411pje.12.1564712416439;
        Thu, 01 Aug 2019 19:20:16 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id u9sm38179744pgc.5.2019.08.01.19.20.14
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 01 Aug 2019 19:20:16 -0700 (PDT)
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
        Ilya Dryomov <idryomov@gmail.com>, Sage Weil <sage@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH 03/34] net/ceph: convert put_page() to put_user_page*()
Date:   Thu,  1 Aug 2019 19:19:34 -0700
Message-Id: <20190802022005.5117-4-jhubbard@nvidia.com>
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

Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: Sage Weil <sage@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: ceph-devel@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 net/ceph/pagevec.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/net/ceph/pagevec.c b/net/ceph/pagevec.c
index 64305e7056a1..c88fff2ab9bd 100644
--- a/net/ceph/pagevec.c
+++ b/net/ceph/pagevec.c
@@ -12,13 +12,7 @@
 
 void ceph_put_page_vector(struct page **pages, int num_pages, bool dirty)
 {
-	int i;
-
-	for (i = 0; i < num_pages; i++) {
-		if (dirty)
-			set_page_dirty_lock(pages[i]);
-		put_page(pages[i]);
-	}
+	put_user_pages_dirty_lock(pages, num_pages, dirty);
 	kvfree(pages);
 }
 EXPORT_SYMBOL(ceph_put_page_vector);
-- 
2.22.0

