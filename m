Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9D713DFB
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 08:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727425AbfEEGsj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 02:48:39 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:45017 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725792AbfEEGsj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 02:48:39 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 47B6220365;
        Sun,  5 May 2019 02:48:36 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 05 May 2019 02:48:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=vo37RLrli0WIqY/HE
        97M+5DkJXjsQS5cLDYy1CffgDg=; b=QvlhN+S5uD2q3jBdj7HKVBpVBuPC9cnol
        +WpKsy4LXYYhx02c/BsWAiSApaKjud/pYcEUkTZ4repHHCDpW3sf2QBmrcv3+5O4
        9EeI+c0nnu3K9W1B8i1eL3CAudvXVtTg9ufSWRUdWl56PGkGQjtnYZHeI+dC+9M/
        K31Niw91YFvzopaqRZ0fvg+SvWfwZ790wVXbVzKm+Cuv9/F+OZzZ5geTPbhWWsv+
        FZAxPEbXwdz7cr00Tyi/xQX3syDE0jH8wumjS3dd4rjWPqFo0yNa3WhfRZwmeJn9
        pF8WKgD8QEx5PaAxedDgzmangNDqrssKForr8puTXJUYJ1WXO4r9w==
X-ME-Sender: <xms:Q4fOXAlf34WNri9A9jYgJzaZK29iRhU5ysw9r-YY9RgAVAMwAXJaTg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrjeeggdduudefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpehmrg
    hilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghrufhi
    iigvpedt
X-ME-Proxy: <xmx:Q4fOXON2PG3fTKdkGosGojW29dysomzVIi-aoEIZNXVvd15SC-S9cw>
    <xmx:Q4fOXKpJPsSWemderQPWuk3xAIFzdJNCFbrGkiIP4OOSHCGTa1fF8Q>
    <xmx:Q4fOXPuvx5mMsWdVoxfwu3Fi7T_E5oq0KKwmtHqy0IzEUtEe2oxJFg>
    <xmx:RIfOXLzurTS6eI3pH2J68S7yQpdKaLjQkt3a3LGLncchKKlSVCaejQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id B0545E40C3;
        Sun,  5 May 2019 02:48:34 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 0/3] mlxsw: spectrum: Implement loopback ethtool feature
Date:   Sun,  5 May 2019 09:48:04 +0300
Message-Id: <20190505064807.27925-1-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

This patchset from Jiri allows users to enable loopback feature for
individual ports using ethtool. The loopback feature is useful for
testing purposes and will also be used by upcoming patchsets to enable
the monitoring of buffer drops.

Patch #1 adds the relevant device register.

Patch #2 Implements support in the driver.

Patch #3 adds a selftest.

Jiri Pirko (3):
  mlxsw: reg: Add Port Physical Loopback Register
  mlxsw: spectrum: Implement loopback ethtool feature
  selftests: Add loopback test

 drivers/net/ethernet/mellanox/mlxsw/reg.h     | 37 ++++++++
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 35 ++++++-
 .../selftests/net/forwarding/loopback.sh      | 94 +++++++++++++++++++
 3 files changed, 164 insertions(+), 2 deletions(-)
 create mode 100755 tools/testing/selftests/net/forwarding/loopback.sh

-- 
2.20.1

