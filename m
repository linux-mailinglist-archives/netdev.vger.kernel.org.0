Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3986B7E942
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 04:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729624AbfHBCX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 22:23:58 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:40766 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390912AbfHBCUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 22:20:45 -0400
Received: by mail-pg1-f194.google.com with SMTP id w10so35239958pgj.7;
        Thu, 01 Aug 2019 19:20:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6GC3vp7Kgk6wrS2t1aIFSliRmKpmpPmHRVTf1Sq+2hE=;
        b=p2jdLnF+o2jszv2jswOdGKVlOI6oap0/O8UoWJ6UXd1vWJ7ZTNuGXBJzfbZP+U3/qi
         otCtgNo0FYJGbVJMagQHVxCjJNv9DsL+tAgpbtcseuLRjx2D2oJRJvb8QUEovItoJ4yu
         tqM1+sKVNJqdRAOn+U29/OmuIVN0dCZaqyMULYrLeNzvWGSINvgRw2ctCEPTtpJHvG4Y
         9Lt1J9Pu4o6vmxc1Dlj1+fWckvxFMkS2v0xzgYEyRXbpmL6oLpAd8HeumDihMK2pn/qS
         boIjYLobOad+m+G9IYsoBFXJgOFcyiWgGfoj3yVWjcIkFyKdq3aTzC8VwLjAVimMrt3Q
         7cZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6GC3vp7Kgk6wrS2t1aIFSliRmKpmpPmHRVTf1Sq+2hE=;
        b=a0NKh6vtymSja85yHS8BRzvzT9SZKjJ6Tg8MrP3JRxBZtC/KqEdZD6lFDw7vSHKUWU
         yali7K71vlySSyo/iU9mVYAcaH0ElhlcBFFR8M2WmgaB7B1quPtULOG9qBsVjwLT0wiN
         6kadK6DsDqLmprzyUvknb+fg5E70b2q6WQQl1RTjTm1SlXTJVBiGabbCKmERbomVStRZ
         szBjRpM2fyvfHu3DViLdav+Skaf95LD2IGab+CdlOIM8KrBQgYxo/7GEQC/+KspTlgaj
         10d9lfWtCdkTijWq2AvX2ViDloNyDhBDK3a0ub8dHDbii2Giaw3+5CMPIQ8E4c5fi1yg
         9eCg==
X-Gm-Message-State: APjAAAUoUd4bJlNZaz4BjpibIwlhXnnTAM/vXNv1btaputmD+KC6FykV
        vUl3CKTGle6Jxo6rU19tPcE=
X-Google-Smtp-Source: APXvYqyrk8OHD0K9x3jg/zl4sLls8epCiHibtZqTP4ohZ230SxHbnF+YASroUXHGf8XghjTINYs0fA==
X-Received: by 2002:a17:90a:b394:: with SMTP id e20mr1897367pjr.76.1564712444816;
        Thu, 01 Aug 2019 19:20:44 -0700 (PDT)
Received: from blueforge.nvidia.com (searspoint.nvidia.com. [216.228.112.21])
        by smtp.gmail.com with ESMTPSA id u9sm38179744pgc.5.2019.08.01.19.20.43
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 01 Aug 2019 19:20:44 -0700 (PDT)
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
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 21/34] fs/exec.c: convert put_page() to put_user_page*()
Date:   Thu,  1 Aug 2019 19:19:52 -0700
Message-Id: <20190802022005.5117-22-jhubbard@nvidia.com>
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

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 fs/exec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/exec.c b/fs/exec.c
index f7f6a140856a..ee442151582f 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -227,7 +227,7 @@ static struct page *get_arg_page(struct linux_binprm *bprm, unsigned long pos,
 
 static void put_arg_page(struct page *page)
 {
-	put_page(page);
+	put_user_page(page);
 }
 
 static void free_arg_pages(struct linux_binprm *bprm)
-- 
2.22.0

