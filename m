Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE4D34E1E6
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 09:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231383AbhC3HNl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 03:13:41 -0400
Received: from mail-m118208.qiye.163.com ([115.236.118.208]:37836 "EHLO
        mail-m118208.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230344AbhC3HNB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 03:13:01 -0400
Received: from vivo-HP-ProDesk-680-G4-PCI-MT.vivo.xyz (unknown [58.251.74.232])
        by mail-m118208.qiye.163.com (Hmail) with ESMTPA id B2F54E02FC;
        Tue, 30 Mar 2021 15:05:19 +0800 (CST)
From:   Wang Qing <wangqing@vivo.com>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Luis de Bethencourt <luisbg@kernel.org>,
        Salah Triki <salah.triki@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Richard Weinberger <richard@nod.at>,
        Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Wang Qing <wangqing@vivo.com>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-hams@vger.kernel.org,
        netdev@vger.kernel.org, linux-decnet-user@lists.sourceforge.net
Cc:     gregkh@linuxfoundation.org
Subject: [PATCH 4/6] fs/jffs2: Delete obsolete TODO file
Date:   Tue, 30 Mar 2021 15:02:47 +0800
Message-Id: <1617087773-7183-5-git-send-email-wangqing@vivo.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1617087773-7183-1-git-send-email-wangqing@vivo.com>
References: <1617087773-7183-1-git-send-email-wangqing@vivo.com>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSE83V1ktWUFJV1kPCR
        oVCBIfWUFZTBkfQ0wZQ0lCSUNNVkpNSkxLQ0xCSUtNSk9VEwETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKQ1VLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NhQ6CSo*AT8cQzcyEB5KTiEu
        IwsaCk5VSlVKTUpMS0NMQklLQkhNVTMWGhIXVQwaFRwKEhUcOw0SDRRVGBQWRVlXWRILWUFZTkNV
        SU5KVUxPVUlISVlXWQgBWUFPTEhLNwY+
X-HM-Tid: 0a7881f3797d2c17kusnb2f54e02fc
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The TODO file here has not been updated for 14 years, and the function 
development described in the file have been implemented or abandoned.

Its existence will mislead developers seeking to view outdated information.

Signed-off-by: Wang Qing <wangqing@vivo.com>
---
 fs/jffs2/TODO | 37 -------------------------------------
 1 file changed, 37 deletions(-)
 delete mode 100644 fs/jffs2/TODO

diff --git a/fs/jffs2/TODO b/fs/jffs2/TODO
deleted file mode 100644
index ca28964..0000000
--- a/fs/jffs2/TODO
+++ /dev/null
@@ -1,37 +0,0 @@
-
- - support asynchronous operation -- add a per-fs 'reserved_space' count,
-   let each outstanding write reserve the _maximum_ amount of physical
-   space it could take. Let GC flush the outstanding writes because the
-   reservations will necessarily be pessimistic. With this we could even
-   do shared writable mmap, if we can have a fs hook for do_wp_page() to
-   make the reservation.
- - disable compression in commit_write()?
- - fine-tune the allocation / GC thresholds
- - chattr support - turning on/off and tuning compression per-inode
- - checkpointing (do we need this? scan is quite fast)
- - make the scan code populate real inodes so read_inode just after 
-	mount doesn't have to read the flash twice for large files.
-	Make this a per-inode option, changeable with chattr, so you can
-	decide which inodes should be in-core immediately after mount.
- - test, test, test
-
- - NAND flash support:
-	- almost done :)
-	- use bad block check instead of the hardwired byte check
-
- - Optimisations:
-   - Split writes so they go to two separate blocks rather than just c->nextblock.
-	By writing _new_ nodes to one block, and garbage-collected REF_PRISTINE
-	nodes to a different one, we can separate clean nodes from those which
-	are likely to become dirty, and end up with blocks which are each far
-	closer to 100% or 0% clean, hence speeding up later GC progress dramatically.
-   - Stop keeping name in-core with struct jffs2_full_dirent. If we keep the hash in 
-     the full dirent, we only need to go to the flash in lookup() when we think we've
-     got a match, and in readdir(). 
-   - Doubly-linked next_in_ino list to allow us to free obsoleted raw_node_refs immediately?
-   - Remove size from jffs2_raw_node_frag. 
-
-dedekind:
-1. __jffs2_flush_wbuf() has a strange 'pad' parameter. Eliminate.
-2. get_sb()->build_fs()->scan() path... Why get_sb() removes scan()'s crap in
-   case of failure? scan() does not clean everything. Fix.
-- 
2.7.4

