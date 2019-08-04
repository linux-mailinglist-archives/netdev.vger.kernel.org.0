Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D71C680DDC
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 00:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728192AbfHDWwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 18:52:05 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:40977 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727686AbfHDWt7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 18:49:59 -0400
Received: by mail-pf1-f194.google.com with SMTP id m30so38608480pff.8;
        Sun, 04 Aug 2019 15:49:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XDFswRI13oGzit66yuxshlgOj+nOKd4gwJhAdxr7MGM=;
        b=rRmTjwmKQyZXs+w2fc61p+6blqitgFt44VDlq2hBJa3msEqsCjE3iMA0N59ImENjx1
         pWxFmzHovpTywgJof2duXF6btSgoIVe+p+WICBao5KO8pBkE9NcaTV9gfxHpi58Jd393
         DFKgJ0xyVx8/IYN8IUERTh2Rxf2HWoXWnWj+XPN7lRyL0wmkPmCXMh8pOjTaDWP9OB/k
         giTYlSTz/ZRaJt6cAxVDISU3w6TbcicUIO0JMUvDlHhqw/CPHipUdbC11SYdC5WWsNXd
         vc/vSbii+ZbRuDVkTzr0tcFTEidEPQ4hRCQUhyIepPPKxZC6v01QDasnaLKNedkEXXRF
         M2wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XDFswRI13oGzit66yuxshlgOj+nOKd4gwJhAdxr7MGM=;
        b=ke2Y1gKrPgV/oA/60dBAHquyvJGir3hjY0nCT73PoYCpmMbCXcVpy6r40XRCNXlBhB
         +khwwkRyNvaYnf68aCW7ksvE5IA1f5g/wdfvXSZ+Z2/+r9x7n/ddIsCfWbFa5cIejvjW
         CkdXLWYzuUgD5VzrZCtpAgn8wugRQIzxgH+bziDuZsvx9hS2kKLPH0RW8jEL+MxLw4QZ
         nQQKf/cR/BgXl4JDWrgKD1tpGUWQ6Hyknv0vHjqxfk7sxq3imJ6LPEJ4eA2nyXuuV9oD
         iWhZOlea8nwefKb2UHiUhakBtuDWHzPyCG89exoji/6GrP+H7ZgU2qLAdN2ekuPLyTT/
         b2Mg==
X-Gm-Message-State: APjAAAXsyqpyf3dN4q+/L45kJM79UaaPm5i49YdmKWvkl+segNcvNWum
        5HKEf0ORINgyNqL7uCCqP3Q=
X-Google-Smtp-Source: APXvYqwlrqrBPfbU3uzw56VyHFJ2u/Wv2Z0KkmEAsOsnKmMeY4aJMueEUB/6oS1u2+NCnzOVxWkmSA==
X-Received: by 2002:a63:4a51:: with SMTP id j17mr133593330pgl.284.1564958998921;
        Sun, 04 Aug 2019 15:49:58 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id r6sm35946836pjb.22.2019.08.04.15.49.57
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 04 Aug 2019 15:49:58 -0700 (PDT)
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
        Mel Gorman <mgorman@suse.de>, Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH v2 25/34] mm/frame_vector.c: convert put_page() to put_user_page*()
Date:   Sun,  4 Aug 2019 15:49:06 -0700
Message-Id: <20190804224915.28669-26-jhubbard@nvidia.com>
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

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 mm/frame_vector.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/mm/frame_vector.c b/mm/frame_vector.c
index c64dca6e27c2..f590badac776 100644
--- a/mm/frame_vector.c
+++ b/mm/frame_vector.c
@@ -120,7 +120,6 @@ EXPORT_SYMBOL(get_vaddr_frames);
  */
 void put_vaddr_frames(struct frame_vector *vec)
 {
-	int i;
 	struct page **pages;
 
 	if (!vec->got_ref)
@@ -133,8 +132,7 @@ void put_vaddr_frames(struct frame_vector *vec)
 	 */
 	if (WARN_ON(IS_ERR(pages)))
 		goto out;
-	for (i = 0; i < vec->nr_frames; i++)
-		put_page(pages[i]);
+	put_user_pages(pages, vec->nr_frames);
 	vec->got_ref = false;
 out:
 	vec->nr_frames = 0;
-- 
2.22.0

