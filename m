Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02EE784160
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 03:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730405AbfHGBmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 21:42:13 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42301 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728747AbfHGBd4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 21:33:56 -0400
Received: by mail-pf1-f195.google.com with SMTP id q10so42482766pff.9;
        Tue, 06 Aug 2019 18:33:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VkIZ9MNYeaRKdR8dFo+dHbwqWBHsgbjux0NTtbbQ8Os=;
        b=WodjfRMNXRpfn8eDFiq237p2GDsP83iVPB5OCq8NqovKXXtmSfGMO2YcZK3qaRiOMq
         V+1Wp3U4Ouo1tRWYwqfWu9duqPs4fCXrKz87Da9i0IezRC3CosqffIajL738UQ/eBy1Q
         8bGkemq1iEa5/xtBXuYNtAC1RV+0n9U9hgutinWmqUfG/v6xBvqP7GCtby2XRnRchtz/
         0cYIJLRbrEXn7xRE/60/clx008LELTPxuZr9t/SYNy+7x5xLG72AD6O6vZ88uF2XgMPR
         ACpc5Lz6LUvFr+xpSFpVcKN4ZMG15RxRazNc9G/jbrPxZR9s341vQyb0SHXjN70nitnK
         1NJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VkIZ9MNYeaRKdR8dFo+dHbwqWBHsgbjux0NTtbbQ8Os=;
        b=I1KqN2R0IzkxdJn7cYfE51c7ooQj/xhl5UIbfDa//xiv0ChvVB6GWUjosqbACib+0a
         0HiFgwZJwAESuM5MhvL2Zx7D4z+kYf+IYfluMDCjC8NIdOQ/iwJHczIksnAxcuvPutr0
         FKAQBziZbcyvx3mux3XSijkDGIa5ok6HLkDWOXtK3yS64ULODgwluKZykm1nX/FIzHWQ
         YWL2SA3WBUJH7xlSacGZaeHrG/7eSv0+3YrvlrO4eCfsvrGVzbc1p2iRjyb19Pu57bRc
         zgbDnJMdTJniwghAEs5G4mSedpZKmuNm74wMs2GjmjjN+8uuEGdhUnb+y2867SQmDUGM
         w0Uw==
X-Gm-Message-State: APjAAAXb5mlxL8WoW9+Az/Qy68ImKvlie/c3BEW+RoPQ5JqO59mHlT4c
        nwUS7kNi1sF3eY3IQdZ3E58=
X-Google-Smtp-Source: APXvYqzbAGNeyGcbWdWkzYvFP0KeX9sV24V25gxtoPIbubmiIgKmQ4weQ/h5itUQb1wb0VhoIYmEzw==
X-Received: by 2002:a17:90a:5884:: with SMTP id j4mr6207412pji.142.1565141635740;
        Tue, 06 Aug 2019 18:33:55 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id u69sm111740800pgu.77.2019.08.06.18.33.54
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 18:33:55 -0700 (PDT)
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
Subject: [PATCH v3 07/41] drm/etnaviv: convert release_pages() to put_user_pages()
Date:   Tue,  6 Aug 2019 18:33:06 -0700
Message-Id: <20190807013340.9706-8-jhubbard@nvidia.com>
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

