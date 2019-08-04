Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3FC380D67
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 00:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727964AbfHDWuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Aug 2019 18:50:32 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35170 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727851AbfHDWuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Aug 2019 18:50:14 -0400
Received: by mail-pg1-f195.google.com with SMTP id n4so3391534pgv.2;
        Sun, 04 Aug 2019 15:50:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cegKTIaYJ+tSle0YiC1yJpybmvJrVZXG5Xryw9OToL0=;
        b=aCkaquioWJVgZ9oxi+kgs0xYn9XvezpV99sLT07IcNs8SpVl8RxEWxB8NfzIRBrjBL
         2B4dJHw2cG5TO6qtCk6u4ZcIwavE5x+pbFyHjAA9Gawo5yJz/cR/RN7KLFsBrzcuwVZV
         WP2fTbo7D/YmdMo3LfJiKW1AjSHc3oDEIZmC59HJW1UrPrOWaY8WJXtwgsxilT0195Uq
         ocw3UqvOC5KedpAwMEgqM2mZYVxGq6/tGgBNtuTtcR3B451sP4Bb3FZmj7gUlwzeWEUc
         XzVXXNThe+NP4na45hxvXL3T6bslaXSJNEyIhO73A4aiizrSPKRgEZ7pYwnnfabRC/Y3
         oqhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cegKTIaYJ+tSle0YiC1yJpybmvJrVZXG5Xryw9OToL0=;
        b=R0OBge7xlskAREalUc4IgtIyuIX1H2PZ6jI8WzXviu44sVM+vRz97caUS/TB5yJjJS
         iClDwKm+dRynEYD9qXpIncRKQxeGZLZNYUJNMtAaIy2rOM2NCOeKDmAkpKfIohuNX0G/
         b/EOmS8J16HpJKuHKk/IG3Z5IkjqG8ojSwnN7eOg44zhifMYa6fcAAy6FmyUUJAO2Q+p
         QdhM4RanjlObvbog8Ozfwkt9x1zOEtqC1pmksZ4QJ6HQxjM29pgTAgYd2tnYWY0lmjvu
         lHlANQtFOkEwcXpNd+27YgJT2M83aiX72X5epT/ATM60eXFACPuCpG0fgyuzNrTGyvVo
         dKvA==
X-Gm-Message-State: APjAAAXw1aibgHaSM4ozGSjc8Vidnopgne/iDeEByIUJLkcQ1+/baIDw
        0zWKzASGlvwVa+fj7QwGjIg=
X-Google-Smtp-Source: APXvYqwQo0taKdXUQzpI7809Qn44c5UC2qpj3t9n7qUuNadX/5xLSvSBDLCQnHDNoFHPmzlJl8WofQ==
X-Received: by 2002:a17:90a:2767:: with SMTP id o94mr14743655pje.25.1564959012976;
        Sun, 04 Aug 2019 15:50:12 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id r6sm35946836pjb.22.2019.08.04.15.50.11
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 04 Aug 2019 15:50:12 -0700 (PDT)
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
        xen-devel@lists.xenproject.org, John Hubbard <jhubbard@nvidia.com>
Subject: [PATCH v2 34/34] fs/binfmt_elf: convert put_page() to put_user_page*()
Date:   Sun,  4 Aug 2019 15:49:15 -0700
Message-Id: <20190804224915.28669-35-jhubbard@nvidia.com>
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

From: Ira Weiny <ira.weiny@intel.com>

For pages that were retained via get_user_pages*(), release those pages
via the new put_user_page*() routines, instead of via put_page() or
release_pages().

This is part a tree-wide conversion, as described in commit fc1d8e7cca2d
("mm: introduce put_user_page*(), placeholder versions").

get_dump_page calls get_user_page so put_user_page must be used
to match.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 fs/binfmt_elf.c       | 2 +-
 fs/binfmt_elf_fdpic.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index d4e11b2e04f6..92e4a5ca99d8 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -2377,7 +2377,7 @@ static int elf_core_dump(struct coredump_params *cprm)
 				void *kaddr = kmap(page);
 				stop = !dump_emit(cprm, kaddr, PAGE_SIZE);
 				kunmap(page);
-				put_page(page);
+				put_user_page(page);
 			} else
 				stop = !dump_skip(cprm, PAGE_SIZE);
 			if (stop)
diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index d86ebd0dcc3d..321724b3be22 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -1511,7 +1511,7 @@ static bool elf_fdpic_dump_segments(struct coredump_params *cprm)
 				void *kaddr = kmap(page);
 				res = dump_emit(cprm, kaddr, PAGE_SIZE);
 				kunmap(page);
-				put_page(page);
+				put_user_page(page);
 			} else {
 				res = dump_skip(cprm, PAGE_SIZE);
 			}
-- 
2.22.0

