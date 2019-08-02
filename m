Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D17AE7E975
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 04:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390871AbfHBCUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 22:20:39 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:33240 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390828AbfHBCUg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 22:20:36 -0400
Received: by mail-pf1-f196.google.com with SMTP id g2so35158665pfq.0;
        Thu, 01 Aug 2019 19:20:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UPRfD7vyasD2XVfdl0NeBW26eHm6l3ABDQSSTKq1HX4=;
        b=TDJzpDwE2oXFjm8cRNjQ8xrt4Ta2d3wf2Cpo0GoFM9thJ0XtvCvH4mP4rm1obsYrxe
         XfcKcMWeGW7+jGqqsIeZqIQivf0rjt9KMIQPJwYrX9aXaeynZfYblNMyZkWwFJwZth79
         e4fMCJd20kqdE18/wOh4Jbz0PSr2Nv8bt8KSNv7hBSUy22vg0EGXVDctxg6pWi24C6E/
         aytHIR9O0Oe5Nfk4mH6Tawu8cduDw0xsgEveOl493+9jCWiudUUBNmztlAbrHUK6dK5c
         cZre9/z25iL+oH1skqqYaquBXUxt6bEZ/OhP0nmn5k+Ox8GOIXBHEB9I8h3iWNYPWkz5
         1iug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UPRfD7vyasD2XVfdl0NeBW26eHm6l3ABDQSSTKq1HX4=;
        b=O/2on/4TleY8TsZaVSCoBciH1qwiLdHVE75yph/dULXGk3HO2dgFenWiiinp8zbzTN
         mEB1HfkKBMs3rEl0FLSpHoKhxEUyYkgE8vYKTwXXXGEgEdT5+puJlUesrmTq0FgM58p7
         09Zq8FCsq1AHRcWL7MqWjVTBi2RGsHO7SLhC9b54lWkjxYdZQVILr4o7E7H/X35Pp1FQ
         dy5KY8Q9be4KVlIyqbHCskgtQPcIZon3UrVe4vVtRPzI2SvFCJkueVgXbagQ6ZFesoWH
         oETs9J/cZx2Na9pZp0+ElNsbNA62NAqyCP29okc3zFyS3U6Xkq1x22TcEhiKmJp9i0UU
         VDig==
X-Gm-Message-State: APjAAAXmIZ27TjAwu2+6iFdPH1CztuOXrCWxWuyUiBN7XXEWP+8skThi
        IbC9woUPiJAFONU6neV5WjRjVKJC51s=
X-Google-Smtp-Source: APXvYqzQQn/4+/qhyIZ5gzUBopHqYfn0J/db4aXm+9arPe8eAWsGtJFKretZ1QBLJdXBLY5X+jbCWQ==
X-Received: by 2002:a17:90a:7f85:: with SMTP id m5mr1901500pjl.78.1564712435904;
        Thu, 01 Aug 2019 19:20:35 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id u9sm38179744pgc.5.2019.08.01.19.20.34
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 01 Aug 2019 19:20:35 -0700 (PDT)
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
        Eric Anholt <eric@anholt.net>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mihaela Muraru <mihaela.muraru21@gmail.com>,
        Suniel Mahesh <sunil.m@techveda.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Sidong Yang <realwakka@gmail.com>,
        Kishore KP <kishore.p@techveda.org>
Subject: [PATCH 15/34] staging/vc04_services: convert put_page() to put_user_page*()
Date:   Thu,  1 Aug 2019 19:19:46 -0700
Message-Id: <20190802022005.5117-16-jhubbard@nvidia.com>
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

Cc: Eric Anholt <eric@anholt.net>
Cc: Stefan Wahren <stefan.wahren@i2se.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mihaela Muraru <mihaela.muraru21@gmail.com>
Cc: Suniel Mahesh <sunil.m@techveda.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Sidong Yang <realwakka@gmail.com>
Cc: Kishore KP <kishore.p@techveda.org>
Cc: linux-rpi-kernel@lists.infradead.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: devel@driverdev.osuosl.org
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 .../vc04_services/interface/vchiq_arm/vchiq_2835_arm.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_2835_arm.c b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_2835_arm.c
index 61c69f353cdb..ec92b4c50e95 100644
--- a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_2835_arm.c
+++ b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_2835_arm.c
@@ -336,10 +336,7 @@ cleanup_pagelistinfo(struct vchiq_pagelist_info *pagelistinfo)
 	}
 
 	if (pagelistinfo->pages_need_release) {
-		unsigned int i;
-
-		for (i = 0; i < pagelistinfo->num_pages; i++)
-			put_page(pagelistinfo->pages[i]);
+		put_user_pages(pagelistinfo->pages, pagelistinfo->num_pages);
 	}
 
 	dma_free_coherent(g_dev, pagelistinfo->pagelist_buffer_size,
@@ -454,10 +451,7 @@ create_pagelist(char __user *buf, size_t count, unsigned short type)
 				       __func__, actual_pages, num_pages);
 
 			/* This is probably due to the process being killed */
-			while (actual_pages > 0) {
-				actual_pages--;
-				put_page(pages[actual_pages]);
-			}
+			put_user_pages(pages, actual_pages);
 			cleanup_pagelistinfo(pagelistinfo);
 			return NULL;
 		}
-- 
2.22.0

