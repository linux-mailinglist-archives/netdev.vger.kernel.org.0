Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7ECB3F0884
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 17:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230481AbhHRPyM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 11:54:12 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:43031 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240078AbhHRPx7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 11:53:59 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailnew.nyi.internal (Postfix) with ESMTP id 16178582FD7;
        Wed, 18 Aug 2021 11:53:24 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Wed, 18 Aug 2021 11:53:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=pvKyJWM2nb3jhPpel
        ja98cBMQZMdh5icYbL8D//6WM8=; b=jjErXgbT8WexsEeTMxtWPjSbfoU4CxXMj
        XIV7zpNLLMKBm+Nl5onvV/8w/W4Q8Qp57hfaX9kkwGIIctViGQUycYdNMGcVB7/N
        hPuEyMP0J7Z3pBZJg04L28Uss6j3hQtn1gqNDMPVIW8Ha9dCOMXOSd/C3In8xczk
        vj5uZmiwBGRpMK6aRTI6nXxmzvZQEiNfAQpCtlGrOPA33YnstnkfFX0MsrdLNZZZ
        re/5gIwzNx/DkqAP40XTAHLHptWiI547YPX7ddCJu53pxh/HXQdnhrmAGhGMALn2
        S7QdbmBAQPXYr0HZIBfJLGGiE/fWCEy0tLHm3k9D7sGqUmA5RxpdA==
X-ME-Sender: <xms:8iwdYZYy5WhoBmNt2-YqIR3dZbqFVeUg5fTRHT-MzFyac0qYvCuibg>
    <xme:8iwdYQZqR5MUi71hQVXEv1CKgJRWNn_Ox_FF0QjsuJ_ffMeBa5SMpKu1Hglafp4h_
    8r9gfYUxSSYpTs>
X-ME-Received: <xmr:8iwdYb_gkccvr0CnolpIKVSNGzd7TqLUmFMVBleqrLL4mTkF8ftFIeIy-vs77wnqcxy9Dm5XPvgW5bIbbhXS93hYwwpkHr8b9UqNyfJcfmJvlQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrleehgdelfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucggtffrrghtthgvrhhnpeetveeghfevgffgffekueffuedvhfeuheehte
    ffieekgeehveefvdegledvffduhfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgr
    mhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:8iwdYXq3_x8Q_ITnygXsTHoLxZbT4jxucUIy_EezfdHCtyIr-HI7GQ>
    <xmx:8iwdYUp_dIv9jObE0OYrlIDDX7i6ekbnUTEDbSRed-XW9CQfnFs26g>
    <xmx:8iwdYdRKFRAwXPpUgBaoXie8FTCf4cZws5gyJ066PyVNo8FcfaU5rQ>
    <xmx:9CwdYQd3Bn4_Q-TTOy3ttsL9jd4SM-L2lMYFFE8-UH3HSo3pjA9aOw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 18 Aug 2021 11:53:20 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        mkubecek@suse.cz, pali@kernel.org, jacob.e.keller@intel.com,
        jiri@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH ethtool-next v2 0/6] ethtool: Add ability to control transceiver modules' power mode
Date:   Wed, 18 Aug 2021 18:53:00 +0300
Message-Id: <20210818155306.1278356-1-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Patch #1 updates the UAPI headers.

Patch #2 adds the actual implementation that allows user space to
control transceiver modules' power mode. See the commit message for
example output.

Patches #3-#5 parse more fields from SFF-8636 and CMIS EEPROMs to
provide better observability regarding the power mode of the modules.

Patch #6 adds support for two new extended link states in order to allow
user space to troubleshoot link down issues related to transceiver
modules. See the commit message for example output.

Ido Schimmel (6):
  Update UAPI header copies
  ethtool: Add ability to control transceiver modules' power mode
  ethtool: Print CMIS Module State
  ethtool: Print CMIS Module-Level Controls
  ethtool: Print SFF-8636 Power set and Power override bits
  ethtool: Add transceiver module extended states

 Makefile.am                   |   2 +-
 cmis.c                        |  87 ++++++++++++++++
 cmis.h                        |  20 ++++
 ethtool.8.in                  |  27 +++++
 ethtool.c                     |  11 ++
 netlink/desc-ethtool.c        |  11 ++
 netlink/extapi.h              |   4 +
 netlink/module.c              | 182 ++++++++++++++++++++++++++++++++++
 netlink/monitor.c             |   4 +
 netlink/netlink.h             |   1 +
 netlink/settings.c            |  12 +++
 qsfp.c                        |   6 ++
 qsfp.h                        |   2 +-
 shell-completion/bash/ethtool |  23 +++++
 uapi/linux/ethtool.h          |  36 ++++++-
 uapi/linux/ethtool_netlink.h  |  34 ++++++-
 uapi/linux/if_link.h          |  21 ++++
 uapi/linux/net_tstamp.h       |  17 +++-
 uapi/linux/netlink.h          |   5 +-
 19 files changed, 496 insertions(+), 9 deletions(-)
 create mode 100644 netlink/module.c

-- 
2.31.1

