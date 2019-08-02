Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6190C7E98A
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 04:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390830AbfHBCUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 22:20:36 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:40229 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389247AbfHBCU0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 22:20:26 -0400
Received: by mail-pl1-f194.google.com with SMTP id a93so32956332pla.7;
        Thu, 01 Aug 2019 19:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5vxuyadJL7U7uLaLdbmi0wM48++CcjfxvCZKqh2vh4A=;
        b=IPnKJ+t+ZuscR+9jkZCr9SYsDod9H1pKxsH7GEiMUhOWm9vGlL+eTdFKhv7CAbJqfW
         uU/KQltFOReuOI2Tb15OkXQ52DWMqedLb39cjCQmyiEWLJR87wjugh79Hhbg0qc6zuHg
         MYJzaAbjIW3STqDPj5Lq2JXvJEE6XELaroV158AptkQMUJ7o1/IZqEXjs4JGgfMi9wWi
         x8L4AJBxrRgeZMqNQthxmzZvgld8OAsmXF7S7qthmuL3HABTVNmwDglQdeK4bcdDS+le
         GYNA0EDvk+skaAjBLW5tt19+LuDGuf6feAdMRYQaTc3LrWG+I4hPzx8Lwm1aQRwe4UW2
         hk+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5vxuyadJL7U7uLaLdbmi0wM48++CcjfxvCZKqh2vh4A=;
        b=XiEvnki4u/6jXZUIvuMR0xm9iccsyEsoCXiAYl0AYLCLjnTPIYcRrWK1cCLz2R/f73
         KTPKmPMhZnV8bDIMcxJ3gRI/O9A3COr5FQSF7A+pCXgIcA5Pf+e+300WoJHFV8PzpRf+
         kydv8r+pZLFK0aeDOY5KzlKB8P3h4bQTrCPC+ujoV9Fbvl6MBORnJhlitfarWRXxkFSB
         zmJ+T8dIPgG6B2UWZ/f8ICnSehXYgHGUJgvzFV43djOOC0KxJUtCwBfpEZyk1TMk8yAv
         nCXFar19o2MiHRuJrdNUaX4j6R+Zns9D0DMYYYG/OyGWsXLxrE823cximEUI0VUNH1Kw
         EGAg==
X-Gm-Message-State: APjAAAVuoQ2uqdFYtDrmjIVQO8sT3QLmJ/r5YUiyjq1EgPYs4LUoR/sw
        DfijiZEE2vG+GMDDnrl6ZGU=
X-Google-Smtp-Source: APXvYqx4n4e9g9/ly0KjHqDWX94uIzBzDxMQOC1nP9LzDlFTNiWIDkQ4j/aY6KUtiphGoFtrA+EDzw==
X-Received: by 2002:a17:902:f301:: with SMTP id gb1mr126844849plb.292.1564712425718;
        Thu, 01 Aug 2019 19:20:25 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id u9sm38179744pgc.5.2019.08.01.19.20.24
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 01 Aug 2019 19:20:25 -0700 (PDT)
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
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Souptick Joarder <jrdr.linux@gmail.com>
Subject: [PATCH 09/34] media/v4l2-core/mm: convert put_page() to put_user_page*()
Date:   Thu,  1 Aug 2019 19:19:40 -0700
Message-Id: <20190802022005.5117-10-jhubbard@nvidia.com>
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

Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Souptick Joarder <jrdr.linux@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: linux-media@vger.kernel.org
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 drivers/media/v4l2-core/videobuf-dma-sg.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/videobuf-dma-sg.c b/drivers/media/v4l2-core/videobuf-dma-sg.c
index 66a6c6c236a7..d6eeb437ec19 100644
--- a/drivers/media/v4l2-core/videobuf-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf-dma-sg.c
@@ -349,8 +349,7 @@ int videobuf_dma_free(struct videobuf_dmabuf *dma)
 	BUG_ON(dma->sglen);
 
 	if (dma->pages) {
-		for (i = 0; i < dma->nr_pages; i++)
-			put_page(dma->pages[i]);
+		put_user_pages(dma->pages, dma->nr_pages);
 		kfree(dma->pages);
 		dma->pages = NULL;
 	}
-- 
2.22.0

