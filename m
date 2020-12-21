Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB2562DFA9E
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 10:57:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbgLUJ4v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 04:56:51 -0500
Received: from nautica.notk.org ([91.121.71.147]:60161 "EHLO nautica.notk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725976AbgLUJ4v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Dec 2020 04:56:51 -0500
X-Greylist: delayed 445 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Dec 2020 04:56:50 EST
Received: by nautica.notk.org (Postfix, from userid 1001)
        id 7E30CC009; Mon, 21 Dec 2020 10:48:43 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1608544123; bh=yaoe7VEoIsbp6ANgyjvB2rbl6fDDGfIoT92WryR11jA=;
        h=Date:From:To:Cc:Subject:From;
        b=l45pzB0m0fqAo09GFPF53/iGtj27iX1hR5cWIsE8auoQyemq/OkWReTXL/7Nrc84p
         gRprPtw6k2DuST4DT5ZpFDCLPBHleC0ttIDDi/Paq2fHUDaSXOpOMgjyeqP9BcHawC
         nwJPm4rc/0wlS843TIBX490a/uxhgjOeEQAZvWRdMI5txx2wTiQkLGDoHRoqY3dAXE
         Q6+rIo+i7Zt6pC+JMvpm947jOTqVk90ESexSVnjS/zTpqqkLOUZ8utoXgJ2+ZiwCDT
         2zA2cSxY84+KY7DR4iPuLOVspzEr9oNOP2Mb1Ql4XvFKzwYy75XInYJw4v5C3Me+gF
         rCN9sahac3tKw==
Date:   Mon, 21 Dec 2020 10:48:28 +0100
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, v9fs-developer@lists.sourceforge.net
Subject: [GIT PULL] 9p update for 5.11-rc1
Message-ID: <20201221094828.GA6602@nautica>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Linus,

here's this cycle's update, finally finished on some very old patches
(originally april 2015!) to allow fixing open-unlink-fgetattr pattern.

Thanks to Eric, Greg and Jianyong for the bulk of the work, and Dan for
static analysis fixes on -next.


The following changes since commit 3cea11cd5e3b00d91caf0b4730194039b45c5891:

  Linux 5.10-rc2 (2020-11-01 14:43:51 -0800)

are available in the Git repository at:

  https://github.com/martinetd/linux tags/9p-for-5.11-rc1

for you to fetch changes up to cfd1d0f524a87b7d6d14b41a14fa4cbe522cf8cc:

  9p: Remove unnecessary IS_ERR() check (2020-12-01 08:19:02 +0100)

----------------------------------------------------------------
9p for 5.11-rc1

- fix long-standing limitation on open-unlink-fop pattern
- add refcount to p9_fid (fixes the above and will allow for more
cleanups and simplifications in the future)

----------------------------------------------------------------
Dan Carpenter (2):
      9p: Uninitialized variable in v9fs_writeback_fid()
      9p: Remove unnecessary IS_ERR() check

Dominique Martinet (2):
      9p: apply review requests for fid refcounting
      9p: Fix writeback fid incorrectly being attached to dentry

Eric Van Hensbergen (1):
      fs/9p: fix create-unlink-getattr idiom

Greg Kurz (2):
      fs/9p: track open fids
      fs/9p: search open fids first

Jianyong Wu (1):
      9p: add refcount to p9_fid struct

 fs/9p/fid.c             | 65  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 fs/9p/fid.h             | 11 ++++++++++-
 fs/9p/vfs_dentry.c      |  2 ++
 fs/9p/vfs_dir.c         |  6 +++++-
 fs/9p/vfs_file.c        |  7 ++++---
 fs/9p/vfs_inode.c       | 47  ++++++++++++++++++++++++++++++++++++++---------
 fs/9p/vfs_inode_dotl.c  | 35 +++++++++++++++++++++++++++++------
 fs/9p/vfs_super.c       |  1 +
 fs/9p/xattr.c           | 16 +++++++++++++---
 include/net/9p/client.h |  7 +++++++
 net/9p/client.c         | 14 +++++++++-----
 11 files changed, 178 insertions(+), 33 deletions(-)

-- 
Dominique
