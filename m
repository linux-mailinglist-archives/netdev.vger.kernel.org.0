Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D60880D0B
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 00:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727193AbfHDWtb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 18:49:31 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:33975 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727067AbfHDWt2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 18:49:28 -0400
Received: by mail-pf1-f195.google.com with SMTP id b13so38598518pfo.1;
        Sun, 04 Aug 2019 15:49:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VkIZ9MNYeaRKdR8dFo+dHbwqWBHsgbjux0NTtbbQ8Os=;
        b=DhwBCoFCjpXXdmoliRK4JR+mRQlogKVYcH9LUuFtCy5jqYLU3k2OV3s9LP9elRQpt2
         2Qt+Jvy9o/orbaOtkd5nujRaPffgwNAgLXVc5HDVur7G30S2Sl9zwlVnpzafHXHFDZ1Y
         umZN5BHQdMTYT4X05o9uchQBU3Ah8LnDb0ocwD8ZU/M3RqzWJ8pCyTsH7SaHwW7GrjOD
         aK4wvB8Fvq+qEmTkGzq512g25DZ6euAbWJjnzFQ81OfVHghvVkS7cIlTWY1k0D9tavPD
         XawoZ7kFyduEl8FG9r2zLh1TsUY0NTur+fJ3ZJLf5PCbd+OiidMkSeuctXmr4WSpmpht
         zqKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VkIZ9MNYeaRKdR8dFo+dHbwqWBHsgbjux0NTtbbQ8Os=;
        b=nyE+J3Cd6KklAKfj4X0cqb3gYj5AYn3Prq2QxMsuBi+rW6RQvZbUWGMj/oMT3TIPIR
         L8hERP9NTBbA1wkV0sGdp0UOI6a18+/wArDrPxJqnd1Aah9p+iIiMhxi+FnBc5Tn6jvO
         SQqRMbuJNzGVgbnuHswXda2gMhGAmpOxjlVJ6s/KbbJhRQv0d+ZM38qLrNE752m7wn1S
         TXzopWyRy8EdYp7mThFFr4Gh335QH/UMW1UZNrf/J1lPw388hMlTxAZmbW8ltshreqUJ
         qoljtkAsIIltqjm1RaQDD38Md1BTn+NZApGx9r0DbD4b3etHLvjkayip8PWIGwo5u92c
         U1EQ==
X-Gm-Message-State: APjAAAVGgA4ZKKhGV43LePMpaDNp1JOx6uZwHgyEZFba62wvOLB2KhTX
        NAB8HREHpg2JdffMt4itAy4=
X-Google-Smtp-Source: APXvYqzRKprB2NEk077YJTrqhmGmbwyku3vUkgW0ycQFuEdLCQ5MyA814ojj8/NKptlwnKhmOHLKBQ==
X-Received: by 2002:a65:6815:: with SMTP id l21mr45892702pgt.146.1564958966963;
        Sun, 04 Aug 2019 15:49:26 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id r6sm35946836pjb.22.2019.08.04.15.49.25
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 04 Aug 2019 15:49:26 -0700 (PDT)
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
        Joerg Roedel <joro@8bytes.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v2 05/34] drm/etnaviv: convert release_pages() to put_user_pages()
Date:   Sun,  4 Aug 2019 15:48:46 -0700
Message-Id: <20190804224915.28669-6-jhubbard@nvidia.com>
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

Cc: Joerg Roedel <joro@8bytes.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: x86@kernel.org
Cc: kvm@vger.kernel.org
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 drivers/gpu/drm/etnaviv/etnaviv_gem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/etnaviv/etnaviv_gem.c b/drivers/gpu/drm/etnaviv/etnaviv_gem.c
index e8778ebb72e6..a0144a5ee325 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_gem.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gem.c
@@ -686,7 +686,7 @@ static int etnaviv_gem_userptr_get_pages(struct etnaviv_gem_object *etnaviv_obj)
 		ret = get_user_pages_fast(ptr, num_pages,
 					  !userptr->ro ? FOLL_WRITE : 0, pages);
 		if (ret < 0) {
-			release_pages(pvec, pinned);
+			put_user_pages(pvec, pinned);
 			kvfree(pvec);
 			return ret;
 		}
@@ -710,7 +710,7 @@ static void etnaviv_gem_userptr_release(struct etnaviv_gem_object *etnaviv_obj)
 	if (etnaviv_obj->pages) {
 		int npages = etnaviv_obj->base.size >> PAGE_SHIFT;
 
-		release_pages(etnaviv_obj->pages, npages);
+		put_user_pages(etnaviv_obj->pages, npages);
 		kvfree(etnaviv_obj->pages);
 	}
 }
-- 
2.22.0

