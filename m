Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0914B7EA0C
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 04:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389868AbfHBC0d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 22:26:33 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:44701 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389155AbfHBCUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 22:20:22 -0400
Received: by mail-pl1-f194.google.com with SMTP id t14so32989913plr.11;
        Thu, 01 Aug 2019 19:20:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fEUR/G5OnJcefSlX4AYJWWcgqHhC+JXxEofDOG22P/4=;
        b=ZjBIvPI6FGYYuQaoM3wYb6xPjNep6A1qdBgLoxOD+angQDRZC9mN7qZBiGsA4x1Mmk
         DVp0b1Fq3km/l8LFUFJZZReS797zF2kYF9KrMWUllVa8HFfcUrM1hAE1P/qQjXzrMnOX
         JxD/xFl+WZHXSEuAGF9iElPEIqC+TRo873joNlnRMAHY9AMqSmLW3nsU27bTpXhcFKV6
         4LeM2yIf45e6IoMit2yX6aFzmLhkspb/EkG8Tlqf3bZNN4WeHI7tMYFctQdF6liMtwoJ
         IvfT9HS49sxx2bYOPNOBswTMjccuTwXWnzyhwEMT1ktty7/Al6mbgY/88Wt++RCGQUor
         cVVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fEUR/G5OnJcefSlX4AYJWWcgqHhC+JXxEofDOG22P/4=;
        b=qJzMtOS01K6ueHV/44EeVtQPdGkbZLE2O2uO+47uZD/U0bwhygx6cqTGwjV5cxAdAj
         RlyFwzZeweTvTqwM2fhIZ23mf7Y1OyUV121E/gSx+Oe38oH5rxHAZW1xsXy9yCRCtkmc
         9/MRH5gdEhoyd0799QxgUS/c/sOPmoRIF+6COVz8MMn/KFQo9wHGxdIFs26KV60dxFSS
         XDAb9zz1ubHtl5aypj1xbr35OxdWGhiRZPuAggBnD7mHXZ3zqMOcGu0YJAfG+M0Dl6dP
         qnQgGhS+NzHjWABW+Pvfn4Hdwjtn6ZpG1OZkMxildRUoq6AO0AufUu7LjDJUVZM1OhYf
         lCvw==
X-Gm-Message-State: APjAAAX9SubK8EaeleW2X1NDvPlTJUOSqLrDWWvv8QP1XjckOXJehhUt
        BLrGTWY3gfyyAqajHFkZ2vY=
X-Google-Smtp-Source: APXvYqx7CDlh0PC+iGQbvpFabXIK4hA95kcB6ECyCRgjU7tdLEhAXCZnA9jGvinS59yHHVq1pirulQ==
X-Received: by 2002:a17:902:a409:: with SMTP id p9mr130268364plq.218.1564712421229;
        Thu, 01 Aug 2019 19:20:21 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id u9sm38179744pgc.5.2019.08.01.19.20.19
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 01 Aug 2019 19:20:20 -0700 (PDT)
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
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>
Subject: [PATCH 06/34] drm/i915: convert put_page() to put_user_page*()
Date:   Thu,  1 Aug 2019 19:19:37 -0700
Message-Id: <20190802022005.5117-7-jhubbard@nvidia.com>
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

Note that this effectively changes the code's behavior in
i915_gem_userptr_put_pages(): it now calls set_page_dirty_lock(),
instead of set_page_dirty(). This is probably more accurate.

As Christophe Hellwig put it, "set_page_dirty() is only safe if we are
dealing with a file backed page where we have reference on the inode it
hangs off." [1]

[1] https://lore.kernel.org/r/20190723153640.GB720@lst.de

Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: David Airlie <airlied@linux.ie>
Cc: intel-gfx@lists.freedesktop.org
Cc: dri-devel@lists.freedesktop.org
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 drivers/gpu/drm/i915/gem/i915_gem_userptr.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_userptr.c b/drivers/gpu/drm/i915/gem/i915_gem_userptr.c
index 528b61678334..c18008d3cc2a 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_userptr.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_userptr.c
@@ -527,7 +527,7 @@ __i915_gem_userptr_get_pages_worker(struct work_struct *_work)
 	}
 	mutex_unlock(&obj->mm.lock);
 
-	release_pages(pvec, pinned);
+	put_user_pages(pvec, pinned);
 	kvfree(pvec);
 
 	i915_gem_object_put(obj);
@@ -640,7 +640,7 @@ static int i915_gem_userptr_get_pages(struct drm_i915_gem_object *obj)
 		__i915_gem_userptr_set_active(obj, true);
 
 	if (IS_ERR(pages))
-		release_pages(pvec, pinned);
+		put_user_pages(pvec, pinned);
 	kvfree(pvec);
 
 	return PTR_ERR_OR_ZERO(pages);
@@ -663,11 +663,8 @@ i915_gem_userptr_put_pages(struct drm_i915_gem_object *obj,
 	i915_gem_gtt_finish_pages(obj, pages);
 
 	for_each_sgt_page(page, sgt_iter, pages) {
-		if (obj->mm.dirty)
-			set_page_dirty(page);
-
 		mark_page_accessed(page);
-		put_page(page);
+		put_user_pages_dirty_lock(&page, 1, obj->mm.dirty);
 	}
 	obj->mm.dirty = false;
 
-- 
2.22.0

