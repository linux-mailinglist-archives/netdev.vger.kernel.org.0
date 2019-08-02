Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 605F37E81D
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 04:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390913AbfHBCUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 22:20:45 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:36745 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390798AbfHBCUl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 22:20:41 -0400
Received: by mail-pl1-f196.google.com with SMTP id k8so33033470plt.3;
        Thu, 01 Aug 2019 19:20:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Zk7mJfsjIPJK9Qgsn0u5osZJajJrXebF0c1tZrgdgoI=;
        b=nL5gA8HkBp1qUXL8uSk44yRPDpQM1GzztnKY+vjFkpLO4+ej8Ho3KCm6C4y+E5m8LE
         h9Iaftsjh1UsJUr+Pb21bHX0tSSHXapiGzhmehbpJMXTX/8OVSokepo7ZYp/sAOufRJM
         Dn+Q/LNbJL1I2nNGcQbJ8ZQUaKHbOXUsbWTmj876BCAWOoZWZ6NdZCYaUx//X8gLE1Fe
         Ao4iR+EL7uUQrdQvqWcLAimsvB7jPrqJUl8VTCYTJSYJDpeTKlwz9tVoL0Kex6hlm0oH
         POKBdW3YOuZavjeRiRdEl20H0UanKpKGw2d45prgvnfRqnKjFtcxDl+Dci+NMwFW+1GP
         a0XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Zk7mJfsjIPJK9Qgsn0u5osZJajJrXebF0c1tZrgdgoI=;
        b=TqWGNxAa9xTzZ6eTxQtVeXu0BqbtE5RovYv1uXo2HtK9iBvecz6PZX/FBw9eAVpLMH
         9B1tbz2k3ycmBKA/CZ2+tZlMZEEDUq+ytS9rJ2dS/PhAMA3vvK/fsKJ08lA6ZBbgb06x
         RwhQ3NeSe8rnbQ2WQD2spuerX6VX5mY2XnOdNhy7AE3hozcafrXW4aJZ7nM0oNR5DsxJ
         A5ZWo526LXllNbwpxrAH4SWvjOglFfBlI0y2j1DO28u5qTisAP1nnyp7T+TYsGHIQkxC
         8Lp8UjWv2nxhxntPyAJuWT3438v6k6FEyCqqavjrjWPGJp7vDIw9UQlccp0eqgkl/o1S
         6rSQ==
X-Gm-Message-State: APjAAAWLCv6BlwngHn5AckS0e+Js3dH7M6wJNrx/ZbSwSK9PlvIJe9j5
        SHKlpOKqUW4KkyhMoD6hm70=
X-Google-Smtp-Source: APXvYqztsbUVpJnR1pWJXE324fW+SugJBxHHKLNQRZirN/VnD1v0OsiDr/qT4pG5Y0OOV3QlfOZRKQ==
X-Received: by 2002:a17:902:830c:: with SMTP id bd12mr131600821plb.237.1564712440479;
        Thu, 01 Aug 2019 19:20:40 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id u9sm38179744pgc.5.2019.08.01.19.20.39
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 01 Aug 2019 19:20:40 -0700 (PDT)
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
Subject: [PATCH 18/34] fbdev/pvr2fb: convert put_page() to put_user_page*()
Date:   Thu,  1 Aug 2019 19:19:49 -0700
Message-Id: <20190802022005.5117-19-jhubbard@nvidia.com>
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

