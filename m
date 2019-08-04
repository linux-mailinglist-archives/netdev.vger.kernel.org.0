Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B36D480E08
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 00:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728252AbfHDWwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 18:52:36 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:37348 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727614AbfHDWt4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 18:49:56 -0400
Received: by mail-pl1-f195.google.com with SMTP id b3so35710478plr.4;
        Sun, 04 Aug 2019 15:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lKIFYbXGeRFczJ7GPuSawhtMV9YIx2+MYUTps7oOTAE=;
        b=TDggbkgRiGIAFGZg+jjgHpzcEiYccMBQ6jptVLtuAINCBCAa7tBLSYJdtzRqQAkVQq
         tQ08R+kd1zAphQz9pkaaBX/hg9RvlkTaePPnO2E1bu2f/76JhzKynqi5fDXQgm3u+sje
         C80KY3nOvFeOz/PfxhVfGvol35idNxGJp30wpqdrZCtYSNKWJHD3OZzPkmpz9TZ2iydK
         zGtAdXJa7uyuK2GhTVtmCk46eJaIXB31IST9V3s1VEcpQHy9Y1uuVubQ/wNf6EoCYZeE
         iY7ztWwDS8B1eHyY4QnXS4dvWcICmGOtU1XZ3uVoXugfKVLMqqSM2fvbIrY7TrJ6h/xd
         OTrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lKIFYbXGeRFczJ7GPuSawhtMV9YIx2+MYUTps7oOTAE=;
        b=tABZWdKdYpIgrcVWeiAxnoafL7HXkKXhgvjv1l75FXJCdYPdOXkP0ic/CNTd6u6+/k
         oL07x0avDlDWn9Px1GhAtqI1hY3puO2YSJMxVDbx51AuhIuhtyvGgGOaLc+/NhRF48XA
         kszuf+lfdRSbqIIRN2oW3Sm+7DvbbDw9sPSt2L3Klc7BLDxxZs8V2b3dEvoH4Rjk5NVN
         uYhD4xHs8yi7T+wNauEsZb9UnyuGZ/VCLiPyn3G2nE5mEZgZ+KZke07M6k8EOjdV6HaF
         E9Dxm/+0B7A+9el8Ceo71fduZMdTWA2+kvQNRqwlJu8Cqrnt7vh5E57YEfSM1BcHP3f7
         Do0A==
X-Gm-Message-State: APjAAAUILQhO4ipbigFHkYTmMqbzHXkSyxEXZ7/HoO+6S1CiDeTmQdfW
        m7hXUpjTV+IYO02Bwal4xwk=
X-Google-Smtp-Source: APXvYqxpyFBswVwCpmbWWUYW5zokWhx2pCk/sdTQw8977867DfmKTOqoiHBx6Glc/HUCem3kZHec6Q==
X-Received: by 2002:a17:902:8689:: with SMTP id g9mr131877551plo.252.1564958995585;
        Sun, 04 Aug 2019 15:49:55 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id r6sm35946836pjb.22.2019.08.04.15.49.53
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 04 Aug 2019 15:49:55 -0700 (PDT)
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
Subject: [PATCH v2 23/34] uprobes: convert put_page() to put_user_page*()
Date:   Sun,  4 Aug 2019 15:49:04 -0700
Message-Id: <20190804224915.28669-24-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190804224915.28669-1-jhubbard@nvidia.com>
References: <20190804224915.28669-1-jhubbard@nvidia.com>
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
 kernel/events/uprobes.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 84fa00497c49..4a575de8cec8 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -397,7 +397,7 @@ __update_ref_ctr(struct mm_struct *mm, unsigned long vaddr, short d)
 	ret = 0;
 out:
 	kunmap_atomic(kaddr);
-	put_page(page);
+	put_user_page(page);
 	return ret;
 }
 
@@ -504,7 +504,7 @@ int uprobe_write_opcode(struct arch_uprobe *auprobe, struct mm_struct *mm,
 	ret = __replace_page(vma, vaddr, old_page, new_page);
 	put_page(new_page);
 put_old:
-	put_page(old_page);
+	put_user_page(old_page);
 
 	if (unlikely(ret == -EAGAIN))
 		goto retry;
@@ -1981,7 +1981,7 @@ static int is_trap_at_addr(struct mm_struct *mm, unsigned long vaddr)
 		return result;
 
 	copy_from_page(page, vaddr, &opcode, UPROBE_SWBP_INSN_SIZE);
-	put_page(page);
+	put_user_page(page);
  out:
 	/* This needs to return true for any variant of the trap insn */
 	return is_trap_insn(&opcode);
-- 
2.22.0

