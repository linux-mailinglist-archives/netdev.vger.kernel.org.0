Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 373023E43DF
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 12:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234624AbhHIKXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 06:23:50 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:56023 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234595AbhHIKXl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 06:23:41 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 42DFA5C00C3;
        Mon,  9 Aug 2021 06:23:19 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 09 Aug 2021 06:23:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=NbpqQJcVgrujMx5OM
        HK9uAoqF0ZQuLsOroYvlRJ23rw=; b=SWtNLF3ziryjaugZx/fjpOww8ovxt7w0N
        UHjBJD7WWYW7UaoFOC1sZXv5BTyEeaLpGPZw9krp7fsieq0oWlYFf5JzzBYUzuCA
        uQTM1MNFHb3deZ8J6I9Fh1uHGkQcKa6xLP9del6cqYBsqj+3NoRhSrz6ItmDDlGX
        YOo0KeS+48rf036GGX0kyZy93fgaFm27EghvyDDPl4usw38ILtI23/1+fecXDQQr
        tHg9I3+vb70h6h21RlQCJNUB2ESoZrToW6P97jinNC/6liZVhttpP+HJz+WXkx1c
        k99DtHuM7yzyFFHgM3VeJVdIa86RbszGWFKdy3t/8mq6IhBmf3uow==
X-ME-Sender: <xms:FwIRYfuJyOO3xStREvjkNFCd6MUbmbuojyQ8X03YfW91QBqvyOuRtw>
    <xme:FwIRYQdetE2NK9lAjZhuTPeJHzO5BtfbPaBF57z12WTjp3SUAtIRS60XkX-H2WeVT
    4_ENvsgIHhLljQ>
X-ME-Received: <xmr:FwIRYSyrGtohkZsnxlYiotqKWUaH_wLntR4Jymh6pIRhpvNTR_o44G8G-SmkO53ZsuMWsbAHcIosQTKugc2NOI9cxzmx2niWVDgyvwC2EUIE1Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrjeejgddvkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucggtffrrghtthgvrhhnpeetveeghfevgffgffekueffuedvhfeuheehte
    ffieekgeehveefvdegledvffduhfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgr
    mhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:FwIRYePVlwz03PVRmEBQn7ylc14vuyDfoSA-izRcmRtX1tvb2Ryg4Q>
    <xmx:FwIRYf_HVwrGMydRGC0-DvklInsZ9jQBIa6CWJAGN2CPB273t0PGaQ>
    <xmx:FwIRYeXdCUceunHmpwB-i8d_GOAba1pOY2fleWIxxz7EOJFKjT1EJA>
    <xmx:FwIRYfxjKLgd32NTpOgBJAiNhowhFpO-3MwxdpkuxiSqOCmxdMTsIg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 9 Aug 2021 06:23:16 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        mkubecek@suse.cz, pali@kernel.org, vadimp@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH ethtool-next 0/6] ethtool: Add ability to control transceiver modules
Date:   Mon,  9 Aug 2021 13:22:50 +0300
Message-Id: <20210809102256.720119-1-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Patch #1 updates the UAPI headers.

Patch #2 adds the actual implementation that allows user space to set
transceiver modules' low power mode. See the commit message for example
output.

Patches #3-#5 parse more fields from SFF-8636 and CMIS EEPROMs to
provide better observability regarding the low power mode of the
modules.

Patch #6 adds the ability to reset transceiver modules. See the commit
message for example usage.

Ido Schimmel (6):
  Update UAPI header copies
  ethtool: Add ability to control transceiver modules' low power mode
  ethtool: Print CMIS Module State
  ethtool: Print CMIS Module-Level Controls
  ethtool: Print SFF-8636 Power set and Power override bits
  ethtool: Add ability to reset transceiver modules

 Makefile.am                   |   2 +-
 cmis.c                        |  52 +++++++++
 cmis.h                        |  13 +++
 ethtool.8.in                  |  24 +++++
 ethtool.c                     |  16 +++
 netlink/desc-ethtool.c        |  12 +++
 netlink/extapi.h              |   6 ++
 netlink/module.c              | 191 ++++++++++++++++++++++++++++++++++
 netlink/monitor.c             |   8 ++
 netlink/netlink.h             |   2 +
 qsfp.c                        |   6 ++
 qsfp.h                        |   2 +-
 shell-completion/bash/ethtool |  23 ++++
 uapi/linux/ethtool.h          |   4 +-
 uapi/linux/ethtool_netlink.h  |  35 ++++++-
 uapi/linux/if_link.h          |  19 ++++
 uapi/linux/net_tstamp.h       |  17 ++-
 uapi/linux/netlink.h          |   5 +-
 18 files changed, 428 insertions(+), 9 deletions(-)
 create mode 100644 netlink/module.c

-- 
2.31.1

