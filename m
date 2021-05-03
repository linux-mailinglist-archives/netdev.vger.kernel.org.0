Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 633513718DF
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 18:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231190AbhECQJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 12:09:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:41064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230210AbhECQJ2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 May 2021 12:09:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 354BB611BF;
        Mon,  3 May 2021 16:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620058115;
        bh=FEwUCDlAm6chn2kBOtPdpM7Y6AZV/SDgq2nwnG6k6BI=;
        h=From:To:Cc:Subject:Date:From;
        b=RBH4vg9z516f3+n0Kf4IpvNZGSwulOSCWOdFU3beo1kWcOwzCjO3NlXOAlkv3z7Mo
         030iBtxWwnxq2nQjik32t3wZtOAeh+E9ZGdMMN4NkRFFk/JaET+f9j7UmEZIZJf0Mf
         NSH3hCVB9ti+Qtagds4R2b8S74hVAi6bPKK0C7mD+ycwT5bUE8LEMxUiuBBth31QDO
         k+3oMVAUMKOJQJ4gSmqNT1IqNvzTei9mFes+i8xcy9NrJBPn2wsLcmhgdTg9h2jAX+
         kqx6zO31NkX4mQEvlhFA1ueGSs0808UoUzmhzWA2DfLvfruc0XykJeOqOPh5nC9hdF
         Amw8uBTihRNZw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     mkubecek@suse.cz
Cc:     netdev@vger.kernel.org, idosch@idosch.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PACTH ethtool-next v3 0/7] ethtool: support FEC and standard stats
Date:   Mon,  3 May 2021 09:08:23 -0700
Message-Id: <20210503160830.555241-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support for FEC requests via netlink
and new "standard" stats.

Changes from v2:
 - update headers
 - fix --disable-netlink build
 - rename equivalency groups to alternatives
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
  netlink: stats: add an --all-groups option

 Makefile.am                  |   3 +-
 ethtool.8.in                 |  23 ++-
 ethtool.c                    |  12 +-
 json_print.c                 |  20 +-
 json_print.h                 |   4 +-
 netlink/desc-ethtool.c       |  51 +++++
 netlink/extapi.h             |  14 +-
 netlink/fec.c                | 359 +++++++++++++++++++++++++++++++++++
 netlink/monitor.c            |   4 +
 netlink/netlink.c            |   9 +-
 netlink/netlink.h            |   1 +
 netlink/parser.c             |  17 +-
 netlink/parser.h             |   4 +
 netlink/stats.c              | 319 +++++++++++++++++++++++++++++++
 uapi/linux/ethtool.h         | 109 +++++++----
 uapi/linux/ethtool_netlink.h | 187 ++++++++++++++++++
 uapi/linux/if_link.h         |   2 +-
 uapi/linux/rtnetlink.h       |  13 ++
 18 files changed, 1096 insertions(+), 55 deletions(-)
 create mode 100644 netlink/fec.c
 create mode 100644 netlink/stats.c

-- 
2.31.1

