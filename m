Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC51480D97
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 00:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727659AbfHDWuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 18:50:08 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:44271 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727726AbfHDWuE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 18:50:04 -0400
Received: by mail-pl1-f194.google.com with SMTP id t14so35655548plr.11;
        Sun, 04 Aug 2019 15:50:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Puv5caB6Xd1AJbwd7nGzyFKNouoVWAfL+vJwz/b+4QQ=;
        b=n2GzADBCRaGfCHf6HbXgRg+V0C89X4GtWNxkv2j3+LQsrqKpmTUVe0ByTHKQwdeBJn
         2GjNEQhUsYm7dhY4Od2Sd6r20534hykhUqRe4t1VnKwQ4DMvNZ5YhS01Fzzgrjh0SFnz
         cOALy97h5W1lbkzKyPwHr+vFBFBbcXlcy5zpFAQBNWN4n0Cj0kftmPhY24PBwGy3tLN5
         iaVwvJuxvheoQgKbgYArnZAnGqCyndt7VZwBKzGO0BC6OrGMqarpUlPnyV+UVYDmCU/k
         M/mEk0A479arzsza58VY7eIxZdZ0ZSau4HrT6ltuIf1VzdnlaHlbMs8Cfp7zJmoWUVEJ
         eBOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Puv5caB6Xd1AJbwd7nGzyFKNouoVWAfL+vJwz/b+4QQ=;
        b=GOB6Wn+Qx4Lco+3J+fQAPjs3H4X16WtX94Sc/LOjOnw3ffOBouIfy2eASOYG6tYge/
         nZduX9s6/PIN4UkbHiCQ1YfynPL0F/9KTws0HLFfKI9fhpKZdbq7rE/QLEdkjPbuMecT
         64jLcCoigcj56ozSESlekZhDp7MmUBAFPmChJMm607/nqejZXCdqEujQVho8TnqeXMzA
         pq8rVdHzQ34HmaIdZjmjQY/NFaZEXveLuZ5wfXqzsZAtyL8o/nP85WSzxbPqlqkzkhvp
         e2jWEJEm7EKYIF2vT9qd+EjHvxyaxliezTrIWVfryCWv8UV46lgJKE5HisHon8NM08O3
         EuOg==
X-Gm-Message-State: APjAAAXCzQryubidO0k67nx34jKfv4tLqKu9cZR72GTYJ3RdSAOzgHjN
        H1wx1UxE270oe2CiEGZUBck=
X-Google-Smtp-Source: APXvYqwABL/owZcbuKs02BqFh/fswcnIOGTkP8u9lrE9SbNiB96M9TYbiEw8R+LSl6DRBzA56M1pUA==
X-Received: by 2002:a17:902:bb81:: with SMTP id m1mr58194086pls.125.1564959003903;
        Sun, 04 Aug 2019 15:50:03 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id r6sm35946836pjb.22.2019.08.04.15.50.02
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 04 Aug 2019 15:50:03 -0700 (PDT)
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
Subject: [PATCH v2 28/34] mm/madvise.c: convert put_page() to put_user_page*()
Date:   Sun,  4 Aug 2019 15:49:09 -0700
Message-Id: <20190804224915.28669-29-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190804224915.28669-1-jhubbard@nvidia.com>
References: <20190804224915.28669-1-jhubbard@nvidia.com>
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
 mm/madvise.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 968df3aa069f..1c6881a761a5 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -672,7 +672,7 @@ static int madvise_inject_error(int behavior,
 		 * routine is responsible for pinning the page to prevent it
 		 * from being released back to the page allocator.
 		 */
-		put_page(page);
+		put_user_page(page);
 		ret = memory_failure(pfn, 0);
 		if (ret)
 			return ret;
-- 
2.22.0

