Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A02B70CBD
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 00:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733281AbfGVWef (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 18:34:35 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:45556 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733248AbfGVWeX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 18:34:23 -0400
Received: by mail-pg1-f195.google.com with SMTP id o13so18325311pgp.12;
        Mon, 22 Jul 2019 15:34:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/ofa5EhPy5N+KM7nweAsOE7rWC5Duznu1d2IMlN4I/Y=;
        b=Sw0HvJJTDmzbJlbRnGPA0tEKa9wBsoXOpSBSyyCpXXoTDy/oLlPojLp975N/iZT3Rt
         8jfBQuYyMJoyHlJ2fyV7WUkxYIldTegTihpxRiAvNY8zRba3PO9qS3NZSvTUxei06Rk0
         uOGdeG1FwadWsIBYlsr2yV0g+UwUeH2FEFiAyASHNNXam+5nvwUOaLXqS8GitFl6ninp
         eVYAIz6e9bu5JJNLX4jLtYsSme3OBg4qojzmnb1QA+ka0SBTx6a2p/N+h2SdySOnbmnd
         qH6vvH98sRnmJjM2M9uSzbppXdvFGZyQFLd9B0l+ZOt4ywhtBFZH/zZ3Y6U5IOl5jKuB
         XGJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/ofa5EhPy5N+KM7nweAsOE7rWC5Duznu1d2IMlN4I/Y=;
        b=nQt9Bnhijl78wihrIrOnFKmCFYUnu+x8HxtHt8m4TeO104UJziZrGVWZY0UAXs0KOO
         XO8/WVxyHVBG5ixf98t40r1P1DrSt7NUE3UunuVsWXwoIP8LT3p0aR43V/aW8Op+N4H5
         cbpl2BjeuTbAaLOgiRwBeMlfYIeZtjTgcaMMAtPX5J2lfmAEG0eHEM1iuRndHZ83e0yq
         eh4QWL8UMx3bwRsCu/eAPYJ69TUIsqvnOoeAt/NNUihVWOHoOAYFFsLgLbrsrEEq3ecQ
         0VJ39BxrEeER1ZWG7f/dLjEUlsv5larFeIKBe9DtHORW4ia7N35IdXGA8NDzts0g5qpg
         TkMA==
X-Gm-Message-State: APjAAAW1RyKoMQ6V4NLv/JvmQv8m7v8pLLu5MxYdd8N7Ae+zTAHwZRFE
        KiGi45FnS1H7Byuw4PJFVsY=
X-Google-Smtp-Source: APXvYqwVaJn+EzirdPn13F0RFZ1U5rQgVF9dbTt0Dcd+iQUjCIySQADzRQKVKnRyYTBRNLHQ9Mrw9A==
X-Received: by 2002:a62:7990:: with SMTP id u138mr2390135pfc.191.1563834863230;
        Mon, 22 Jul 2019 15:34:23 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id r18sm30597570pfg.77.2019.07.22.15.34.21
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 22 Jul 2019 15:34:22 -0700 (PDT)
From:   john.hubbard@gmail.com
X-Google-Original-From: jhubbard@nvidia.com
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Boaz Harrosh <boaz@plexistor.com>,
        Christoph Hellwig <hch@lst.de>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Chinner <david@fromorbit.com>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>,
        Ilya Dryomov <idryomov@gmail.com>, Jan Kara <jack@suse.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Ming Lei <ming.lei@redhat.com>, Sage Weil <sage@redhat.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Yan Zheng <zyan@redhat.com>, netdev@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
        linux-rdma@vger.kernel.org, bpf@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        John Hubbard <jhubbard@nvidia.com>
Subject: [PATCH 3/3] net/xdp: convert put_page() to put_user_page*()
Date:   Mon, 22 Jul 2019 15:34:15 -0700
Message-Id: <20190722223415.13269-4-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190722223415.13269-1-jhubbard@nvidia.com>
References: <20190722223415.13269-1-jhubbard@nvidia.com>
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

Cc: Björn Töpel <bjorn.topel@intel.com>
Cc: Magnus Karlsson <magnus.karlsson@intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 net/xdp/xdp_umem.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index 83de74ca729a..0325a17915de 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -166,14 +166,7 @@ void xdp_umem_clear_dev(struct xdp_umem *umem)
 
 static void xdp_umem_unpin_pages(struct xdp_umem *umem)
 {
-	unsigned int i;
-
-	for (i = 0; i < umem->npgs; i++) {
-		struct page *page = umem->pgs[i];
-
-		set_page_dirty_lock(page);
-		put_page(page);
-	}
+	put_user_pages_dirty_lock(umem->pgs, umem->npgs);
 
 	kfree(umem->pgs);
 	umem->pgs = NULL;
-- 
2.22.0

