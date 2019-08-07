Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDD6F84124
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 03:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728927AbfHGBeC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 21:34:02 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37008 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728828AbfHGBeA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 21:34:00 -0400
Received: by mail-pf1-f196.google.com with SMTP id 19so42486452pfa.4;
        Tue, 06 Aug 2019 18:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=o2GwgSJoRuvPfZ2J7Awdgxw+WyrY01QvDnyFb1fV9Xk=;
        b=DBS4QEOYd7JEbPuapIEybK6yPbT9yH436NCQH6rDrbBzuYucty6BaNvhoi5hH6v0CL
         JtOgJ70gNZTF533IB2dCY0X/unBQS7PQHTF2oj+dliPmRRfT3OJ5pHnotZJGhHxVZbfq
         YQRB/9ot1828nW5dFsiXI0WjJ5tnCXQL7Z7DBkE4dxbfbAjeZHXxEyOO1PgLYGM0R/tb
         bQj3p4j+QH0APLbNBrYDCK8UA7Rjj5eJjYvOiTQSaFgxud4esYtpeLsQ7vEEpZptaSxw
         yfJ/AgnnMUJmxUFLjnK1nFuoz+yKZ9OxcxA/Lu5XV7Z6R3lgOiOVPkE/r0yTZn6GHACF
         KMsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o2GwgSJoRuvPfZ2J7Awdgxw+WyrY01QvDnyFb1fV9Xk=;
        b=PP3Y9450sjoMUdNy9U7q7TwNw/XmZlO0XO8t9Q0NAdEYiOFL4X0FTsLchdmXXHA9DI
         IMDpKYmsO8MNHC02MNZeEBZVZ/Mj6LVA+jTjppsYpGNZyJqw8NzXpzFpnULMqk3KcRro
         xYhsn6kgrIcATGzXwfwI2T+8omsmnBPTWZQ2OQO1RxBWwmKpu3frbT89TgMjsvMi7JqF
         63869nwfh/T6WM5D1u6mDJ52eUh5e/ZMtSldIQ/jWSNpI6zkJQsIwk0ufmTRILAPaiz6
         Pzi4OtrltWkRyd2BzIqYSjFtYpWiO7DdIq0mzZ1tBnTybovtSW/h9GkFL6S1yGTgVSoT
         +Gog==
X-Gm-Message-State: APjAAAVnz420e/3tpHcX3VmhijB+FM1TXZksvNQrRMUrxVz1Do6p63rg
        r/yV74GeSkJw7WyKLmka6IQ=
X-Google-Smtp-Source: APXvYqy30p2NohP2KIU0EnEWVyTf80c7khXPPY91tyi1XYk0o5oiq5Uprgt54o6LNZgppKd61nE9YQ==
X-Received: by 2002:a17:90a:6097:: with SMTP id z23mr6014303pji.75.1565141638870;
        Tue, 06 Aug 2019 18:33:58 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id u69sm111740800pgu.77.2019.08.06.18.33.57
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 18:33:58 -0700 (PDT)
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
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        David Zhou <David1.Zhou@amd.com>,
        David Airlie <airlied@linux.ie>
Subject: [PATCH v3 09/41] drm/radeon: convert put_page() to put_user_page*()
Date:   Tue,  6 Aug 2019 18:33:08 -0700
Message-Id: <20190807013340.9706-10-jhubbard@nvidia.com>
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

Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: David (ChunMing) Zhou <David1.Zhou@amd.com>
Cc: David Airlie <airlied@linux.ie>
Cc: amd-gfx@lists.freedesktop.org
Cc: dri-devel@lists.freedesktop.org
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 drivers/gpu/drm/radeon/radeon_ttm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/radeon_ttm.c b/drivers/gpu/drm/radeon/radeon_ttm.c
index fb3696bc616d..4c9943fa10df 100644
--- a/drivers/gpu/drm/radeon/radeon_ttm.c
+++ b/drivers/gpu/drm/radeon/radeon_ttm.c
@@ -540,7 +540,7 @@ static int radeon_ttm_tt_pin_userptr(struct ttm_tt *ttm)
 	kfree(ttm->sg);
 
 release_pages:
-	release_pages(ttm->pages, pinned);
+	put_user_pages(ttm->pages, pinned);
 	return r;
 }
 
-- 
2.22.0

