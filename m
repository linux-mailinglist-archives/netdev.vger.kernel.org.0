Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1954083FEB
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 03:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729858AbfHGBeg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 21:34:36 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:43311 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729743AbfHGBed (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 21:34:33 -0400
Received: by mail-pg1-f195.google.com with SMTP id r26so6587190pgl.10;
        Tue, 06 Aug 2019 18:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GAYBkmVoEF3i3+udFKn42Z4HyLG0jAAiACtL32v96bk=;
        b=SyrfptYHZmeMKLLq8uTuDSlh448/TZCFpG6Zn4FeLZy9cTZZGFbCJ1UNBJPoCIn+aW
         ygsAzBiAVH0kcipZ4ihTHldNmhfD0znPMjSBKoUKvh0NP49BRvqIlmsIg6DT8KHAwPBe
         4kKUVEJdNXvGigLmpKs15CkjDKUzxh1vmFZZWbslFSuyKlpacG3oD1RXF7xFsxcwBIbL
         0fmLLMJWYpY6/OBVXor4D0pE1ZvktHc8OSEdcNEszsvYRmiqmzBZ8eGFZOKusFOHPIrj
         /e89tRQCCSxcnEZ4JUtQARmnCroQo1zfhGtcxjcGVNa5FV+aQSWzJVN76YDHje0qrdo9
         NXRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GAYBkmVoEF3i3+udFKn42Z4HyLG0jAAiACtL32v96bk=;
        b=lJO8rtBVEwGgrUORHpOyjxTue4Pb0QLNu7657mTltZU5d3/+xsP5kCEVDW9nDMgSuu
         ZYzutopVQf5F4E0ILnlNHEKQjXvHvyAaKEnYp2xIt/Xtz9JOC/jOGnPk5MuldADLGiBQ
         cVRF68vj24re73iStc2SVOq8YlUDCmjyTUByidDQr35kb13UEKRuC7igJn2kWtiX4x1Y
         noGUnH2um0mbRv62B46VUbgGaE25IiHXnnYtBK7qXztbTQW36uegeSof5w6+8OAiqGHx
         148WGqJXSqOMaJt7jV6EgXxkXwZvHv8uoDAgBi7PHbz80XYLERoU2pH08eagFBU4jOW9
         w50Q==
X-Gm-Message-State: APjAAAXCVQjC+oZmS2iLNUCK01sVOeDd6mOX3bdd0aMDisXL3w+vb0+n
        h1I2vjZsTz3D+S+s0k9dTmg=
X-Google-Smtp-Source: APXvYqwmirpRx7sRgblxTdJDdZc3lNLPB7sz+os8JHE4peLsZYES+zILuE4KL76TUaGsLoa8NjKqJA==
X-Received: by 2002:a62:ae02:: with SMTP id q2mr6578356pff.1.1565141671450;
        Tue, 06 Aug 2019 18:34:31 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id u69sm111740800pgu.77.2019.08.06.18.34.29
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 18:34:30 -0700 (PDT)
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
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Huang Ying <ying.huang@intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Michal Hocko <mhocko@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Rik van Riel <riel@surriel.com>,
        Souptick Joarder <jrdr.linux@gmail.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH v3 29/41] mm/memory.c: convert put_page() to put_user_page*()
Date:   Tue,  6 Aug 2019 18:33:28 -0700
Message-Id: <20190807013340.9706-30-jhubbard@nvidia.com>
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

Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Souptick Joarder <jrdr.linux@gmail.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 mm/memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
index e2bb51b6242e..8870968496ea 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4337,7 +4337,7 @@ int __access_remote_vm(struct task_struct *tsk, struct mm_struct *mm,
 						    buf, maddr + offset, bytes);
 			}
 			kunmap(page);
-			put_page(page);
+			put_user_page(page);
 		}
 		len -= bytes;
 		buf += bytes;
-- 
2.22.0

