Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCC737E87F
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 04:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403968AbfHBCVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 22:21:07 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:43864 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389236AbfHBCVE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 22:21:04 -0400
Received: by mail-pf1-f194.google.com with SMTP id i189so35157808pfg.10;
        Thu, 01 Aug 2019 19:21:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rv0dCo+fqAQ13SgPxACDlFOa16RsKjSPlFe+eBoZNRU=;
        b=FnXZWigmXks7P7vrWF7fKqdJ1mEC+gV48nu3UaSpxK4YL8v+ZyKfQNiGbSuus211Io
         +fy2JCOQXe0u+yVyht7IUnGNiz1ytce226/iQ1Wda7n+sWhgorrLFCh54sw2yd22N9l0
         AXL2/cPWN7xjLjU338yB5B7ZEpAB76ymwzaqr46s48M64gK8WOGJ87UIWJj0TMsT00ZG
         rYH/3SCw5LcEELiN57lLCnYUd8Lx6hylUyDzZKFYq9GvzONQ8cx9AYXJHJgmouhXLCeg
         1q2sn/m6YtRZPuqIGm/1JYTBARn6QQkL/1+apRqX4+bW7vcNXDLWp8NZbJWw7fVf637Q
         Jc5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rv0dCo+fqAQ13SgPxACDlFOa16RsKjSPlFe+eBoZNRU=;
        b=HJqG/flgOGh/fii3iWu6xG4g8HGiVkekK+v30qJjv6sxDaZ9a1InrCq7TMbMngKdAa
         Hi/ppnJEOGQSCwsJdpmUuxN85WF4swh3E4csWLQce2+vobf3sREjtFICjXvhxp4/5PwR
         CAVc6KIE8mJIsRcvhBTTADRVXRyDgGcuHm2UrEA8RF1konf2mBx+2hjzh5jLHaYWjfqz
         uxAoLRJP+FiM6VrinMl4wlmhfw+ivkej+5Msq0x/TJ9XTKp6SF7Vxmd8zylTH4kbg80H
         A2tn07F/r3Pt3GnUIZKO336NCKNonYjzd197a6ViB8whG5rtex0Dzec+ofX+slwEc3rv
         +fGg==
X-Gm-Message-State: APjAAAVJydwGJZ2wlhtKLl+uGR8RrmQzoAnmnLz15NEFL5VciviGzYn3
        E4uUOAwFc96qdLgGEM66W4M=
X-Google-Smtp-Source: APXvYqw6pZRI02L0RsJ0l51BCisQWQi/OHFOULF/U1jaQbwym1DWFopp5ASpqFdR23hpYNhrKVILMg==
X-Received: by 2002:a17:90a:bf92:: with SMTP id d18mr1939362pjs.128.1564712463758;
        Thu, 01 Aug 2019 19:21:03 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id u9sm38179744pgc.5.2019.08.01.19.21.02
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 01 Aug 2019 19:21:03 -0700 (PDT)
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
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 33/34] kernel/events/core.c: convert put_page() to put_user_page*()
Date:   Thu,  1 Aug 2019 19:20:04 -0700
Message-Id: <20190802022005.5117-34-jhubbard@nvidia.com>
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

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 kernel/events/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 0463c1151bae..7be52bbbfe87 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6426,7 +6426,7 @@ static u64 perf_virt_to_phys(u64 virt)
 			phys_addr = page_to_phys(p) + virt % PAGE_SIZE;
 
 		if (p)
-			put_page(p);
+			put_user_page(p);
 	}
 
 	return phys_addr;
-- 
2.22.0

