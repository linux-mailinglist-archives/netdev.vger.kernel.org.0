Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA0780D29
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 00:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727569AbfHDWtw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 18:49:52 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:33013 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727532AbfHDWtt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 18:49:49 -0400
Received: by mail-pg1-f196.google.com with SMTP id n190so3535788pgn.0;
        Sun, 04 Aug 2019 15:49:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Zk7mJfsjIPJK9Qgsn0u5osZJajJrXebF0c1tZrgdgoI=;
        b=WszdJ6eSiS6l8Z9/5N/vbNe3jNFvMTjmOIbyGI43X/lqn/ujHi2UxXu88CH1bmo3Pr
         auVxGpa3TkNwR224TaYOB1ePcD+ho6gM00/37bER1kKjl0rL2SnnzYvGvu3vN/SXHfk+
         wtblnQHWP5rqAtZxjvFWL+wwPm4ICxkBWE6EXcMAD+BIssgCDDepKV59lPfeJfOzGgFr
         KW9V0+2vgt3eaIWXLk7U/hy0iBaj5GHPE+ZLhIwPVMA8/7B6uNEiy5Dm26EoCBxtBU9T
         tUYfOzYB8/UlHywiUxmEUaaGe/mgWuOGErPZVtfj1mQo23l9R0hEud7H5SM/CqJoFOsO
         zJVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Zk7mJfsjIPJK9Qgsn0u5osZJajJrXebF0c1tZrgdgoI=;
        b=LMNAW5Tv6iUPZo4tf/OxnJKRi5+oaR86bcS5QyjdfmOWGGnBeSxYduBU5wVxnJCglj
         N2FQM4gOOcDajLDt29wUsB+l3Klakf6qDRRIM5G20IARMK4Iq3YkXXqoWkXO/L10yTf6
         632DQ0ceufSys1PlQvNPI625Y6lCxb5cIOAJ8I50a2p+AF6/0KyvTDcRU4dRm4GWj0y9
         y9AkcgTY5lru+UfIHWI0sBlJlsoNuPQAcBMdrH6T0mccw4cz9Q+SCWR5OLtA9nIuQWtz
         0lURxc7KkkSH/ecEHvwqjJVPkhdysPMJp3LqjvErf4CakWTVPqrT69BLLwkHEk+4gqAc
         pKiw==
X-Gm-Message-State: APjAAAVsVN0s8h8cp0B5NR3HwdhOnA0BSDx3n/TsKaHVGgv5upg/ZSqx
        fnbvN1DgNBlD0pOn69GOGns=
X-Google-Smtp-Source: APXvYqzXOrOAw0v6KK/XGb3+LYPhc4s7KW/tJCUCwczRKyA5tVzLB0NIrofddWwwfme3ueTIgYzfbg==
X-Received: by 2002:a63:3407:: with SMTP id b7mr22111094pga.143.1564958987901;
        Sun, 04 Aug 2019 15:49:47 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id r6sm35946836pjb.22.2019.08.04.15.49.46
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 04 Aug 2019 15:49:47 -0700 (PDT)
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
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kees Cook <keescook@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH v2 18/34] fbdev/pvr2fb: convert put_page() to put_user_page*()
Date:   Sun,  4 Aug 2019 15:48:59 -0700
Message-Id: <20190804224915.28669-19-jhubbard@nvidia.com>
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

Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Bhumika Goyal <bhumirks@gmail.com>
Cc: Arvind Yadav <arvind.yadav.cs@gmail.com>
Cc: dri-devel@lists.freedesktop.org
Cc: linux-fbdev@vger.kernel.org
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 drivers/video/fbdev/pvr2fb.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/video/fbdev/pvr2fb.c b/drivers/video/fbdev/pvr2fb.c
index 7ff4b6b84282..0e4f9aa6444d 100644
--- a/drivers/video/fbdev/pvr2fb.c
+++ b/drivers/video/fbdev/pvr2fb.c
@@ -700,8 +700,7 @@ static ssize_t pvr2fb_write(struct fb_info *info, const char *buf,
 	ret = count;
 
 out_unmap:
-	for (i = 0; i < nr_pages; i++)
-		put_page(pages[i]);
+	put_user_pages(pages, nr_pages);
 
 	kfree(pages);
 
-- 
2.22.0

