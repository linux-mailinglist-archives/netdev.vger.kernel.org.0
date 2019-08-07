Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F33883F56
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 03:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730122AbfHGBev (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 21:34:51 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:45793 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730008AbfHGBep (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 21:34:45 -0400
Received: by mail-pl1-f195.google.com with SMTP id y8so38603236plr.12;
        Tue, 06 Aug 2019 18:34:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=S+0IdzDd5LiY8AHwrYdqvSEMzcb9gWZ2lznukLTa4fI=;
        b=TH7xsIR8mdN6BLY7JG8/eF6RsdDCkk2cRD3dBopErpIToembDlJ6DvjPGThWxgNDHN
         izZnY8v+rrCTqbMQXBbwMmFJJ4/nvmF6zRWW4Xs6qUrfZ8o0czAW/fGIDrwD7Q1ygI7M
         9Zf8Re7QredxsFLkJT7ZLJf014g9dC9bvOiPKF2NgNaHSnsjvFjfZ4bBzwffrRrGp9/v
         vlT+JVAmAuL0sqc4zONRKIioMJS5mLcrWMkUTsb2T5dvyeXECRBNXvR++1qedsjna65N
         Bpeio/uU7dJ/a25yv6b3onr0A5BIr5z5tUmsUB0sHub+eppjPv5sJ1ZexYmVLUXkgvRa
         bJaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S+0IdzDd5LiY8AHwrYdqvSEMzcb9gWZ2lznukLTa4fI=;
        b=LRymV5gLf9ueWfhdXNeVK6k2qapEZreM12FOedqkw7boO4g3lHS6v12agEk9R0GuDh
         HK2sxbay3SKEfJlGE7iPlhCC2FqguxGDha+/qBvLqvCxcS7wnDWdIPu3OERDy1+Yfews
         BcrptiUnE9XCkBn3kNGcLs4Lm7X1cJoo7d/cS0au3brU1tno59bKX/ZuLp2yGcJwB6Z/
         6vEbADfgHPFSQvfgr0CKsF6zfthsQsghCPDvOvvBgd0G9r3kI8t0ERjt17yDC7yyFXCb
         1mVw9KcHWl/Z0CO2Kg4c2aDQjFuAcQ/7pF5VUqOwiavKeCqi9eAh1m7Qtrn3FLfmliLa
         Ba4A==
X-Gm-Message-State: APjAAAUFPN9o7Yly9kLnnR0M2d60FrmGDp4Ek16Ilg+gU2Dy347811XB
        7GRHnZWpGRFdVZ17rJUwC84=
X-Google-Smtp-Source: APXvYqwBIISXTWf4C+eZPMoIO/o34tgUz/S5eMQixOLDQAsdZlLcpYV/uzVG2wEPWDAc94LDsKhJ9w==
X-Received: by 2002:a17:902:9a49:: with SMTP id x9mr5953327plv.282.1565141683818;
        Tue, 06 Aug 2019 18:34:43 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id u69sm111740800pgu.77.2019.08.06.18.34.42
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 18:34:43 -0700 (PDT)
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
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Kentaro Takeda <takedakn@nttdata.co.jp>,
        linux-security-module@vger.kernel.org
Subject: [PATCH v3 37/41] security/tomoyo: convert put_page() to put_user_page*()
Date:   Tue,  6 Aug 2019 18:33:36 -0700
Message-Id: <20190807013340.9706-38-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190807013340.9706-1-jhubbard@nvidia.com>
References: <20190807013340.9706-1-jhubbard@nvidia.com>
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

Acked-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

Cc: Kentaro Takeda <takedakn@nttdata.co.jp>
Cc: linux-security-module@vger.kernel.org
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 security/tomoyo/domain.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/tomoyo/domain.c b/security/tomoyo/domain.c
index 8526a0a74023..6887beecfb6e 100644
--- a/security/tomoyo/domain.c
+++ b/security/tomoyo/domain.c
@@ -931,7 +931,7 @@ bool tomoyo_dump_page(struct linux_binprm *bprm, unsigned long pos,
 	}
 	/* Same with put_arg_page(page) in fs/exec.c */
 #ifdef CONFIG_MMU
-	put_page(page);
+	put_user_page(page);
 #endif
 	return true;
 }
-- 
2.22.0

