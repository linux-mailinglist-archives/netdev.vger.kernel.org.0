Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AABB292022
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 23:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728061AbgJRVb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 17:31:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:46984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726458AbgJRVb7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Oct 2020 17:31:59 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C177222267;
        Sun, 18 Oct 2020 21:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603056719;
        bh=6KI30idMGcVRbUqpq9/HRGXf2Qty0LVh9WUWd4kGO7E=;
        h=From:To:Cc:Subject:Date:From;
        b=Xe67WeAzXiH4bTRMBhdPym7ZanS3Yx4wmBHk0oOCFcoaOSeK3tTM5ATS9F/vgPnta
         P+xW5kMn1PldU0Rup5wwNPu5LaPs3ikXFc53Gaw9fB5ifZKB9ScTs/G0B1nKYffJBH
         mi3mmu/dIwUNdPcWgW6lrf78RnrCzyEGJ8BGFqRE=
From:   Jakub Kicinski <kuba@kernel.org>
To:     mkubecek@suse.cz
Cc:     netdev@vger.kernel.org, kernel-team@fb.com, idosch@idosch.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH ethtool v3 0/7] pause frame stats
Date:   Sun, 18 Oct 2020 14:31:44 -0700
Message-Id: <20201018213151.3450437-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

Sorry about the delay from v2.


This set adds support for pause frame statistics.

First pause frame info is extended to support --json.

Pause stats are first of this kind of statistics so add
support for a new flag (--include-statistics).

Next add support for dumping policy to check if the statistics
flag is supported for a given subcommand.

Last but not least - display statistics.

v3:
 - rename the ctx variable to policy_ctx
 - instead of returning the flags policy save it to a member
   of struct nl_context, for potential reuse. Also we don't
   have to worry about returning flags and negative errors
   from the read helper this way :)

Jakub Kicinski (7):
  update UAPI header copies
  pause: add --json support
  separate FLAGS out in -h
  add support for stats in subcommands
  netlink: prepare for more per-op info
  netlink: use policy dumping to check if stats flag is supported
  pause: add support for dumping statistics

 ethtool.8.in           |   7 ++
 ethtool.c              |  17 +++-
 internal.h             |   1 +
 netlink/coalesce.c     |   6 +-
 netlink/msgbuff.h      |   6 ++
 netlink/netlink.c      | 179 ++++++++++++++++++++++++++++++++++++++---
 netlink/netlink.h      |  31 +++++--
 netlink/pause.c        | 111 ++++++++++++++++++++++---
 uapi/linux/genetlink.h |  11 +++
 uapi/linux/netlink.h   |   4 +
 10 files changed, 336 insertions(+), 37 deletions(-)

-- 
2.26.2

