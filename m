Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4750736838D
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 17:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236563AbhDVPlb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 11:41:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:37396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236305AbhDVPl2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 11:41:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 23F2561208;
        Thu, 22 Apr 2021 15:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619106053;
        bh=TxCmScN9AURf11nkjJgUn84MO3sWfZFWqhgEELakVWE=;
        h=From:To:Cc:Subject:Date:From;
        b=Qv7npRtqIQd1k2L0RWsxP1Fk6LZvQnYddVizidILNRnco+KFdqE2G13JX1PS8Ifb1
         1BryBjefPHOQOvhvMJSqNkzwzlmoEcrSXQPEHgfLRZakE4B5KeOcnfhnPb/BrxwW3/
         l7E+YNTc2zhf+nHtpfxujB3fsmZhYSVPR8DsRYVxRSB0tSAo4Ty1kXiNF0kZxR0oFs
         zAMj3frsn+lflJ1HAx6kg/si++aaCEGfauWoo45LxDLQgqANBW1RBN2XeKH3scboXI
         WdO5D+RkZRmqRHpZFpOA4qKuLT99hSVSJCDfVUqJsqYoY4ENjfhcMf7HmC/YQp3cAa
         ji9NWWSEG3HLw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     mkubecek@suse.cz
Cc:     netdev@vger.kernel.org, idosch@idosch.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH ethtool-next v2 0/7] ethtool: support FEC and standard stats
Date:   Thu, 22 Apr 2021 08:40:43 -0700
Message-Id: <20210422154050.3339628-1-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support for FEC requests via netlink
and new "standard" stats.

Changes from v1:
 - rebase on next, only conflicts in uAPI update
 - fix the trailing "and" in patch 6
Changes compared to RFC:
 - improve commit messages
 - fix Rx vs Tx histogram in JSON
 - make histograms less hardcoded to RMON
 - expand man page entry for -S a little
 - add --all-groups (last patch)

Jakub Kicinski (7):
  update UAPI header copies
  json: improve array print API
  netlink: add FEC support
  netlink: fec: support displaying statistics
  ethtool: add nlchk for redirecting to netlink
  netlink: add support for standard stats
  netlink: stats: add on --all-groups option

 Makefile.am                  |   3 +-
 ethtool.8.in                 |  23 ++-
 ethtool.c                    |  12 +-
 json_print.c                 |  20 +-
 json_print.h                 |   4 +-
 netlink/desc-ethtool.c       |  51 +++++
 netlink/extapi.h             |  13 +-
 netlink/fec.c                | 359 +++++++++++++++++++++++++++++++++++
 netlink/monitor.c            |   4 +
 netlink/netlink.c            |   9 +-
 netlink/netlink.h            |   1 +
 netlink/parser.c             |  17 +-
 netlink/parser.h             |   4 +
 netlink/stats.c              | 319 +++++++++++++++++++++++++++++++
 uapi/linux/ethtool.h         | 109 +++++++----
 uapi/linux/ethtool_netlink.h | 187 ++++++++++++++++++
 uapi/linux/rtnetlink.h       |  13 ++
 17 files changed, 1094 insertions(+), 54 deletions(-)
 create mode 100644 netlink/fec.c
 create mode 100644 netlink/stats.c

-- 
2.30.2

