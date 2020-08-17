Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16BA4245A6C
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 03:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbgHQBeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Aug 2020 21:34:24 -0400
Received: from smtprelay0230.hostedemail.com ([216.40.44.230]:59522 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726221AbgHQBeX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Aug 2020 21:34:23 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id 607B5180A7FEF;
        Mon, 17 Aug 2020 01:34:22 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:69:355:379:541:968:973:988:989:1260:1311:1314:1345:1437:1515:1534:1542:1711:1730:1747:1777:1792:1978:1981:2194:2198:2199:2200:2393:2559:2562:3138:3139:3140:3141:3142:3353:3865:3867:3870:4419:4605:5007:6261:10004:10848:11026:11658:11914:12043:12296:12297:12679:12683:12895:13095:13894:14096:14394:14721:21080:21325:21433:21451:21627:21965:30030:30054,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: queen59_160526327012
X-Filterd-Recvd-Size: 3007
Received: from joe-laptop.perches.com (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf01.hostedemail.com (Postfix) with ESMTPA;
        Mon, 17 Aug 2020 01:34:20 +0000 (UTC)
From:   Joe Perches <joe@perches.com>
To:     ceph-devel@vger.kernel.org, linux-block@vger.kernel.org
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        Dongsheng Yang <dongsheng.yang@easystack.cn>,
        Jens Axboe <axboe@kernel.dk>, Jeff Layton <jlayton@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH V2 0/6] ceph: Use more generic logging
Date:   Sun, 16 Aug 2020 18:34:03 -0700
Message-Id: <cover.1597626802.git.joe@perches.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the dout macro to the normal pr_debug.
Convert embedded function names in these changes to %s, __func__
Remove the dout macro definitions

Joe Perches (6):
  ceph: Use generic debugging facility
  ceph: Remove embedded function names from pr_debug uses
  net: ceph:  Use generic debugging facility
  net: ceph: Remove embedded function names from pr_debug uses
  rbd: Use generic debugging facility
  ceph_debug: Remove now unused dout macro definitions

 drivers/block/rbd.c             | 231 +++++++-------
 fs/ceph/addr.c                  | 266 ++++++++--------
 fs/ceph/cache.c                 |  22 +-
 fs/ceph/caps.c                  | 533 ++++++++++++++++----------------
 fs/ceph/debugfs.c               |   4 +-
 fs/ceph/dir.c                   | 141 ++++-----
 fs/ceph/export.c                |  36 +--
 fs/ceph/file.c                  | 170 +++++-----
 fs/ceph/inode.c                 | 338 ++++++++++----------
 fs/ceph/ioctl.c                 |   6 +-
 fs/ceph/locks.c                 |  42 +--
 fs/ceph/mds_client.c            | 374 +++++++++++-----------
 fs/ceph/mdsmap.c                |  16 +-
 fs/ceph/metric.c                |   4 +-
 fs/ceph/quota.c                 |   4 +-
 fs/ceph/snap.c                  | 135 ++++----
 fs/ceph/super.c                 |  67 ++--
 fs/ceph/xattr.c                 |  64 ++--
 include/linux/ceph/ceph_debug.h |  30 --
 include/linux/ceph/messenger.h  |   2 +-
 net/ceph/auth.c                 |  21 +-
 net/ceph/auth_none.c            |   4 +-
 net/ceph/auth_x.c               |  85 ++---
 net/ceph/buffer.c               |   6 +-
 net/ceph/ceph_common.c          |  18 +-
 net/ceph/cls_lock_client.c      |  32 +-
 net/ceph/crypto.c               |   8 +-
 net/ceph/debugfs.c              |   4 +-
 net/ceph/messenger.c            | 330 ++++++++++----------
 net/ceph/mon_client.c           |  99 +++---
 net/ceph/msgpool.c              |  14 +-
 net/ceph/osd_client.c           | 393 ++++++++++++-----------
 net/ceph/osdmap.c               | 101 +++---
 net/ceph/pagevec.c              |  10 +-
 34 files changed, 1835 insertions(+), 1775 deletions(-)

-- 
2.26.0

