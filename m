Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9860B7E9A7
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 04:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387665AbfHBCZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 22:25:24 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33235 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390803AbfHBCUf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 22:20:35 -0400
Received: by mail-pf1-f193.google.com with SMTP id g2so35158605pfq.0;
        Thu, 01 Aug 2019 19:20:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6zqhiQUR/t5HSZML/x55nFGZKGW5GK1LULKEmO0k7kA=;
        b=F6zwcO4LIlIH0MhJxHttCJTdvFyVFQT/4arw8VEiUMf3H4eEoUX+759aMNEB4E5yQk
         Nz2fCbsNakzpI2Ix1oQ23cChuh59P2OEpLwWSX6x9IY/wvMOZe6lEWSb2zFdzp0gprdi
         y9rnyWNc6RyhaZMvzhG8ve4bXMhMFks51tm4rHvgstN2tswx5ZOG0+I0UrLn8K8liKz6
         o59abaE04tV7AfXXxMZta+A8VG8S0kkDg1uyI4tR9b3t+a4fVwe1pYra9FjftWzgoUTS
         x4tLp6R3lAg/evT8dl18ZgG3qJOUMIaQFDribAsCQyGjHMfkpuycFyZQ36o14QJqnxy+
         vrdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6zqhiQUR/t5HSZML/x55nFGZKGW5GK1LULKEmO0k7kA=;
        b=Ld8qlRJZtPudTc32vFMo8Rgln0ZiND+2RA1utiur3FYerYDNaoyTTcHW/X8wYhwLxI
         TznwRgbpL8VdZmssbTdlCxUfl7uVyvqZe4M4lylCT0H5RJr0km0p6oeuB3Fnm5qV00l/
         i/QxEV+n1VoXpSQ5KDOKmQXQ00wp5fgrJHdcQanAvZRNM3t9e1YiD3ar0wssScDYmOtR
         /Pq1+/L4vz7ZqK+znYLECPh+RRlQB04eWJ1xQmiD1/lqHdX/x+Vkup8fNa4iYE2Zwp9E
         MuYEYwtpuGWlr5jIu5E/S2snSpN+BGjafxxOz0aYKhjoEjkZfbMDZY+wLlFk8c/V5erU
         lJqg==
X-Gm-Message-State: APjAAAW2WNfodl0++Qq3nWemamKFOFhzHDzsoazhjciOf1RJm0CT5QHk
        nPh4oloU3QzX63pn/mu9bLc=
X-Google-Smtp-Source: APXvYqxawjrrBWhVHWqru35UkhsNUwOEktD3Ze9ukSGMVZSHmBDx+KHUyZVGOPhrL6EFpIA4EvvUgw==
X-Received: by 2002:a63:b64:: with SMTP id a36mr113099405pgl.215.1564712434076;
        Thu, 01 Aug 2019 19:20:34 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id u9sm38179744pgc.5.2019.08.01.19.20.32
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 01 Aug 2019 19:20:33 -0700 (PDT)
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
Subject: [PATCH 14/34] oradax: convert put_page() to put_user_page*()
Date:   Thu,  1 Aug 2019 19:19:45 -0700
Message-Id: <20190802022005.5117-15-jhubbard@nvidia.com>
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

