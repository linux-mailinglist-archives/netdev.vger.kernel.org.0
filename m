Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF7D84017
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 03:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730281AbfHGBhQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 21:37:16 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38114 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729781AbfHGBee (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 21:34:34 -0400
Received: by mail-pf1-f196.google.com with SMTP id y15so42511811pfn.5;
        Tue, 06 Aug 2019 18:34:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Puv5caB6Xd1AJbwd7nGzyFKNouoVWAfL+vJwz/b+4QQ=;
        b=tmsRy1GqXUm98oxjqXOZPjsWspl9AXdfGLJi4f4YSRE4p2Xnzia+lP7gOvMdJeaaOV
         ZMTpzk7cqa5s9Whlhun0Z7Axe9U+exCqGVHdHS/nwzXnj2PJKIWBdXJBCa3H/2BHiz19
         BnEnordNgtmPL4Xz5g5gGRNQFD3awe5Sds/iOUIPfzMq0+Xzzslt2XeYTRCDaqUoB/tZ
         5WSuCY8UmuqBDYfQsynPZOWWiAW9iVZeFmsUs+zlPeiO0OHcuVwV2drvqj8qlA8ICP6u
         9yeV7By6zGvwf0U2BDyf/bSCue82V2u+FVMGjOFTaa85KNQg5C2wQoPnNjOXVsaihczq
         TD/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Puv5caB6Xd1AJbwd7nGzyFKNouoVWAfL+vJwz/b+4QQ=;
        b=Q03DRZ3tf5A+pbE5S1gqyimCcMlVapdsNbpUNAzfKAbAOLU3/Slg0hoIUHcqdm6LdG
         G0KevIBHZDlvbZ3s308sF3fyx/J/BIT/RIL83s7RAGcIh6boQ2MA+qds8z7/oXLPyt/n
         612EqqlSFJaL+luiB4u/5uKiraEJxpMx/u61GxZq/L/i+0ND5jurTAARhlkekh3MeQlO
         kVvQ2nTcFNqsIOFQ9tuLU/7IQpf2WRGGdLSpQQn++X9616zQjC+bvoPYrRNcudBLPxPC
         /Veh5Ep/ZWvNEZR5579iT38Gn1iHfGQPuS3Q4JWzYfPlcJWdXB3qWhXvPdSntIDBKoZd
         wBFQ==
X-Gm-Message-State: APjAAAVCoekNwY4WL4EOYONwdXubukJVhB+ExI3OmZHO49R9p3cGiSY+
        4NziCXdh4gp8+OtF3AkS1zA=
X-Google-Smtp-Source: APXvYqw2Uz+wsO3yNwpRHMDLbJirCIxZ4A4X8U6+Fg2LdiPaNY42ayE9pYwjEAVQClZpIkVOBc80qg==
X-Received: by 2002:a17:90a:e38f:: with SMTP id b15mr6129518pjz.85.1565141672902;
        Tue, 06 Aug 2019 18:34:32 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id u69sm111740800pgu.77.2019.08.06.18.34.31
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 18:34:32 -0700 (PDT)
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
Subject: [PATCH v3 30/41] mm/madvise.c: convert put_page() to put_user_page*()
Date:   Tue,  6 Aug 2019 18:33:29 -0700
Message-Id: <20190807013340.9706-31-jhubbard@nvidia.com>
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

