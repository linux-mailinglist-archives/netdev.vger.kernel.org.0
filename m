Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3A0D40AC67
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 13:28:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232043AbhINL3T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 07:29:19 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:55817 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232056AbhINL3R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 07:29:17 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 22E465803A6;
        Tue, 14 Sep 2021 07:27:59 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 14 Sep 2021 07:27:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=SDiMyj
        QUvv7Q6DVKEVSY2ENb+ITtLR4xL6jSv3EDzgA=; b=oWbxQ8tbdBp0VGXbu9LzWX
        O9LEoFPqYym/pomSnZ8J0r0dPfRNNsvCKfnUnXg4n9inf1jT6ZhUW0z5TBTA5Xrm
        ciyKWL1V5Wk/eHoCBCWTk3AVh/Za4brdPk2/Fyrna7tcPDOMX+5r5Nj7pyW3VjEN
        HZ+AL76fPkMW7QMzG8AfHM428lcgE4+TW2CsMO1xgh/TUrboN93IdvagZBFECx2e
        g2l5BO7ZzK6cmpzGsxQ3qD9Zb/QZsiPVlliXoqGVcnDReACuS9mWraQRj1Gh0Iuh
        LKvtcbGKtoc0eOE7UBdCy5mGN50SrcKJUCVYJ2KsSGo7j3m1wxXjr6XZ/s2GoWng
        ==
X-ME-Sender: <xms:PodAYSGKm6nb2IRr6fRaYcl6mi2rqm9jSJzdDWxebLv_p6_47Zg2QA>
    <xme:PodAYTWStTEOh6DH0YqdR4AZTZIpFSLi2tvlKyjDfQMSI1a14gIdtoYAL3FuMBooQ
    XuSa5NAUUPWpiM>
X-ME-Received: <xmr:PodAYcI25wEbF0PP1EupR0hjOsCx78drP7VuIYjKaRyiK3jFQlgzOEiH9AXxrG6BTSCP3b2DJ4AxnaV51YcF2-JXMSErqHcCxA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudegledgfeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofggtgfgsehtkeertd
    ertdejnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeetffegheejueehkeehffeugedtffejte
    efgfejheeuhfevfeeggedugeekgfdvgfenucffohhmrghinhepghhithhhuhgsrdgtohhm
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:PodAYcEIYIYodt5c4Vlz4Adq4A_HZFGPE-PWiiyLZfnImF5UxiafSg>
    <xmx:PodAYYXk8CqORUeJAN6_5qx5_7S_3pZbKlRt5N2p30m_fSd65YyrNg>
    <xmx:PodAYfNmYzc7y0x54F0a9bwmL5-t1QtK8DC3Dg3YMAFxzbN2CIz7tA>
    <xmx:P4dAYcpTuRFUnxYmz2okEUYUGHGKMd5IiFbgOJ5zSQYjBiKtdWUgAA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 14 Sep 2021 07:27:55 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, kuba@kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        vladyslavt@nvidia.com, moshe@nvidia.com, popadrian1996@gmail.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH ethtool 0/5] ethtool: Module EEPROM fixes
Date:   Tue, 14 Sep 2021 14:27:33 +0300
Message-Id: <20210914112738.358627-1-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

This patchset contains fixes for various issues I noticed while working
on the module EEPROM parsing code.

In addition to these fixes, I have the following submissions ready for
the next branch [1]:

* Trivial coding style / documentation changes

* Reworking the EEPROM parsing code to use a memory map with pointers to
  individual pages as the current state is sub-optimal. In the IOCTL path,
  one large buffer is passed to parsers (e.g., SFF-8636, CMIS). In the
  netlink path, individual pages are passed, some of which might not be
  valid. With the proposed changes, the IOCTL and netlink paths only
  differ in the way they initialize the memory map. The parsing code is
  completely shared

* Extending the CMIS parser to request and parse diagnostic information
  (already present in SFF-8636) from optional / banked pages

[1] https://github.com/idosch/ethtool/commits/submit/cmis_dump_v1

Ido Schimmel (5):
  sff-8636: Fix parsing of Page 03h in IOCTL path
  cmis: Fix invalid memory access in IOCTL path
  netlink: eeprom: Fallback to IOCTL when a complete hex/raw dump is
    requested
  ethtool: Fix compilation warning when pretty dump is disabled
  netlink: eeprom: Fix compilation when pretty dump is disabled

 cmis.c                  |  2 +-
 ethtool.c               | 13 ++++++++-----
 netlink/module-eeprom.c | 14 ++++++++++++++
 qsfp.c                  |  2 +-
 4 files changed, 24 insertions(+), 7 deletions(-)

-- 
2.31.1

