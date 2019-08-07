Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE7A840DA
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 03:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729275AbfHGBeO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 21:34:14 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:38767 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729163AbfHGBeL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 21:34:11 -0400
Received: by mail-pl1-f196.google.com with SMTP id az7so38558272plb.5;
        Tue, 06 Aug 2019 18:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6zqhiQUR/t5HSZML/x55nFGZKGW5GK1LULKEmO0k7kA=;
        b=EFr+1Ao3qBWmnJE02e7LcpB6YUVuRVbr9fx2rTH0O8yhq0D77M0YGPm0P+jSp6Jtuq
         2YlUZC321Nw3VSKn/00GLAANBgeiSrRJFaGZRoVjMnZ04FL9NLT6sKwnd0vV7JxKBdum
         Sqd0ag8jbhm9lcgz/XGxcy282zyTuU0Inaax4Btd/pAUlY3wTglSAc2wTFu9hSsedu/U
         Ux8BLgDEL4leQ7GXOOnEQmGonJeNt4nNmRZIhNi+Q94mV14xLfJWcwz4/pgXWu55VGQ6
         7Ogfd27qokaRQiNc+s9HO/wimpOVcSkVDqUWnVlQuzAm83PkUtGh2xlJDzKo+0GLPz99
         7D+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6zqhiQUR/t5HSZML/x55nFGZKGW5GK1LULKEmO0k7kA=;
        b=m28iuDYAWThQk1QUTfYddd9W71o8ubn2zAF0joOcLj+J62OWKJH7MmkL+d+fCh4Ivm
         iaX/pBZQKSPt0TaRWwxpF7esIztQwgnUUmoWKnnzzrHnKunk+Sum0XMUqyYBcrPpK+hB
         5VFL9tDwlufWIgx3CMlkoGSYzQACBZRI2F21Ef/6FrW5829FvP6NgWkt1ebL7UtwbjVt
         LXeQngglRYiDJmI7ydLjOwFdXs9gISR58IhNRio2lojzvPsNg3okT27/+VzrFS4UPcIv
         K92VL7rR3nJk3X8kNUR8sfZ+4EAb+gW4kjAS1LC+uBe0YHAxKDKpNEQmKOLOMmxFLPpU
         xHKQ==
X-Gm-Message-State: APjAAAXAuD5w9A+ouOaYEhTzXrkbWBZ9yadAsBl4cMwMbTsOoP4Ln0U/
        P+/GTmWFh9JJY5tjR36avV0=
X-Google-Smtp-Source: APXvYqwoNo1PQmUv0ey0ILQvIwCoxxeyMFQeV7g8XASyN0XYGLEtQs3kplEx5vqWyqtJhS4NAvKAHg==
X-Received: by 2002:a17:902:20e5:: with SMTP id v34mr2979392plg.136.1565141650096;
        Tue, 06 Aug 2019 18:34:10 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id u69sm111740800pgu.77.2019.08.06.18.34.08
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 18:34:09 -0700 (PDT)
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
        "David S . Miller" <davem@davemloft.net>,
        Jonathan Helman <jonathan.helman@oracle.com>,
        Rob Gardner <rob.gardner@oracle.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH v3 16/41] oradax: convert put_page() to put_user_page*()
Date:   Tue,  6 Aug 2019 18:33:15 -0700
Message-Id: <20190807013340.9706-17-jhubbard@nvidia.com>
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

Cc: David S. Miller <davem@davemloft.net>
Cc: Jonathan Helman <jonathan.helman@oracle.com>
Cc: Rob Gardner <rob.gardner@oracle.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Wei Yongjun <weiyongjun1@huawei.com>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: sparclinux@vger.kernel.org
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 drivers/sbus/char/oradax.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/sbus/char/oradax.c b/drivers/sbus/char/oradax.c
index 8af216287a84..029e619992fc 100644
--- a/drivers/sbus/char/oradax.c
+++ b/drivers/sbus/char/oradax.c
@@ -412,7 +412,7 @@ static void dax_unlock_pages(struct dax_ctx *ctx, int ccb_index, int nelem)
 				dax_dbg("freeing page %p", p);
 				if (j == OUT)
 					set_page_dirty(p);
-				put_page(p);
+				put_user_page(p);
 				ctx->pages[i][j] = NULL;
 			}
 		}
-- 
2.22.0

