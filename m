Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E59E364F7F
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 02:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbhDTAbq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 20:31:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:45336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230182AbhDTAbq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 20:31:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D847610CC;
        Tue, 20 Apr 2021 00:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618878675;
        bh=wYPbiyiBEgX0K1jF4x2kI2eydyYdgOUVlYMBRVElmo8=;
        h=From:To:Cc:Subject:Date:From;
        b=i/uSJZzTO9rggD2apkdQBO1PoE4fj6e1ffPrvibm9mqfybGNpYf73+15Pb2eAdsQE
         Os0mUKWq0+FFOjOYIGujlTM7t4er+WOocZIRJNiINMKzasBrCw9pMHyKEIJubmoaUI
         L5bWmsqs2TZN+bH5GQTTzfoA6F9zS2bpCeKpxSyUCUKctYy0qjkKcl/UMaHfJmp8H2
         lljuq3RnwtC7Gash5OgW2hTKSEWqtwMQfU7GSMS6cZIVaeyeZKX43ZXMErVEUda0Hj
         XJiMP8qNhjdxrcO5C8t1WVlteHOaiHxseBMS6w4fzZdcLUgaSt77ELArPsZJ6g3+YZ
         0hNGsgJmTL6ew==
From:   Jakub Kicinski <kuba@kernel.org>
To:     mkubecek@suse.cz
Cc:     netdev@vger.kernel.org, idosch@idosch.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH ethtool-next 0/7] ethtool: support FEC and standard stats
Date:   Mon, 19 Apr 2021 17:31:05 -0700
Message-Id: <20210420003112.3175038-1-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support for FEC requests via netlink
and new "standard" stats.

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
 uapi/linux/ethtool.h         | 111 +++++++----
 uapi/linux/ethtool_netlink.h | 188 ++++++++++++++++++
 uapi/linux/if_link.h         |   9 +-
 uapi/linux/netlink.h         |   2 +-
 uapi/linux/rtnetlink.h       |  33 +++-
 19 files changed, 1119 insertions(+), 63 deletions(-)
 create mode 100644 netlink/fec.c
 create mode 100644 netlink/stats.c

-- 
2.30.2

