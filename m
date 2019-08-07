Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5AB683EDD
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 03:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728736AbfHGBdy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 21:33:54 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:41939 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728654AbfHGBdu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 21:33:50 -0400
Received: by mail-pg1-f194.google.com with SMTP id x15so32192406pgg.8;
        Tue, 06 Aug 2019 18:33:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GHzc1obwFKwJgG7nswfPGhmCYytguM8zaNUDmj5ciqU=;
        b=SVC7DSqJ1aViuFyLacSuD9ekUuon1nsbmGXQ+rccZqQD0M5OpWv4FInOJYOUS0zDrw
         iiaUKlpU3oYT6EB+TLC7fde9FCQbqLPjcDOo/pPYr/Dy4w9ZLyTeVh++4NmqxXNEZ0Um
         gS5DfjjL21uHhIzIHJrVsnAGurOzAGDNfpv0OIjYG3RHWT96uJJIGB6LIuNQuZVc7Ym2
         eeEnUQ4CldleB6IB/9Fxp6/W0nXsF/e4MjOETkKBsrMtb7StZJlqXJT9WcIpX7tnyI6X
         9gewZeHtS0mR3vhC08tQKk4aqf3pL5knJE/hrGJP04i1jVNIaCHMRTQVdWFD0VLC/Xeg
         c3+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GHzc1obwFKwJgG7nswfPGhmCYytguM8zaNUDmj5ciqU=;
        b=cOfbVzM+PrU74DhiOEMUXussskP/9CaxgiwTAt9LuZ+P6TyuJDJ48GM+Oa8GIfHZU0
         cuOWuMv8uXhLrMQUVDhlaG8IcDCEHDgV9ag+O63VRPlnAuOJYRj4UazHEjPuVezwUq+k
         aDhkjLqdQPazzXzkmbn1EHrSjbr6lv3A57pnxxFpNR1ErkQmZgfyXD1P+tr+C4uRkZfC
         ZACwVAF81mBC4YRHi9mc06q3ZtB4/5lyYhf8UgllT+JXcbNIbR3VaMyMBvitwFDhDFTr
         VuWMucgcvul7vGgZ1D4dTCo8e0rlImzAtnhw8a9EUWG/+ZIS5oLse6QFmvuF4RbocIAf
         P4KA==
X-Gm-Message-State: APjAAAUZKt/Nj59i4FgJbxNvcbPuGRZP5WjY5s4CdN3TJJh64Pi4p0aL
        uZkfXImwuCznRxvAYZ6bTas=
X-Google-Smtp-Source: APXvYqxeOvPea8wN4/1KbcpbOcv0WCKYw/yUT+8N/xQtvHJFmkBBq3xYGl9YYXdHhoFcN7NXCSJlJw==
X-Received: by 2002:a17:90a:e397:: with SMTP id b23mr5992770pjz.117.1565141629443;
        Tue, 06 Aug 2019 18:33:49 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id u69sm111740800pgu.77.2019.08.06.18.33.47
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 18:33:48 -0700 (PDT)
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
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH v3 03/41] net/xdp: convert put_page() to put_user_page*()
Date:   Tue,  6 Aug 2019 18:33:02 -0700
Message-Id: <20190807013340.9706-4-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190807013340.9706-1-jhubbard@nvidia.com>
References: <20190807013340.9706-1-jhubbard@nvidia.com>
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

Acked-by: Björn Töpel <bjorn.topel@intel.com>
Cc: Magnus Karlsson <magnus.karlsson@intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 net/xdp/xdp_umem.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index 83de74ca729a..17c4b3d3dc34 100644
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
+	put_user_pages_dirty_lock(umem->pgs, umem->npgs, true);
 
 	kfree(umem->pgs);
 	umem->pgs = NULL;
-- 
2.22.0

