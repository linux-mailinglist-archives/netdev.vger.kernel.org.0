Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8AC761457
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 10:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727127AbfGGICe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 04:02:34 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:47769 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726325AbfGGICd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 04:02:33 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id CB3E91924;
        Sun,  7 Jul 2019 04:02:32 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 07 Jul 2019 04:02:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=vK4k7LU/wWyat3HmO4l0pM5uRaHSBhf3IAIyTyJDGiE=; b=0NPwJEFZ
        qTcdQX5a0gdf9Pqs03/hJjy8vQgdpxFLxAB2nkrpMQc49q/4Fq5e1eb/DBtt0qJq
        6v6ep1WCBRgt3Di+aAIx4vj7PTCACXaEMiLeXl65TtkCJww+n2u+hCkAmkAZsuu2
        wJLy/XHuzuvBbScyW2eR1b8Tmy+2/fzfLxgTyKipatdDsWNtwbVAS5X17xGCz5ET
        +XAEpFdq8axsMGV/hwQmnTSZcgxvGfF5h5z0D4A5LD4Z9gQKBlKHVTcTuHDqetPT
        XNeTjw1Ey6hHFbS4skjrl4Wjt7bi+Y90rPdzloMc86Eg/YM0OEMek2kYFKrUqXG7
        axpkYar8fl+oHg==
X-ME-Sender: <xms:F6chXeqF9hZac5OS9IUZ7pX-ss2YhW2ZswsTEiqv4PPdPQQQ261ltQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrfeejgdduvdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:F6chXfBmcYaob7eqMqPVM2Si4pfPj1m5iWRhbAWH470zpdKoTMYK-A>
    <xmx:F6chXcd1lx8bU6ijRyTGkHCiv4EoLmvhZ3Dx8mOsXYzBh0ORmnvcZw>
    <xmx:F6chXRCbgjjOAAMjn_rPBJJQ-F5RMADBL2L0uwad8zbLZDg4p6H-tQ>
    <xmx:GKchXQAdxI8UjdxahtLKRaIrTBb0Bhay7IqJ8iNePL1J25AlxKCB6A>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id AD7F88005A;
        Sun,  7 Jul 2019 04:02:28 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, andy@greyhouse.net,
        pablo@netfilter.org, jakub.kicinski@netronome.com,
        pieter.jansenvanvuuren@netronome.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH iproute2-next 0/7] Add devlink-trap support
Date:   Sun,  7 Jul 2019 11:01:53 +0300
Message-Id: <20190707080200.3699-1-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190707075828.3315-1-idosch@idosch.org>
References: <20190707075828.3315-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

This patchset adds devlink-trap support in iproute2.

Patch #1 increases the number of options devlink can handle.

Patches #2-#4 gradually add support for all devlink-trap commands.

Patches #5-#6 perform small tweaks in devlink code.

Patch #7 adds a man page for devlink-trap.

See individual commit messages for example usage and output.

Ido Schimmel (7):
  devlink: Increase number of supported options
  devlink: Add devlink trap set and show commands
  devlink: Add devlink trap group set and show commands
  devlink: Add devlink trap monitor support
  devlink: Set NETLINK_NO_ENOBUFS when monitoring events
  devlink: Add fflush() to print functions
  devlink: Add man page for devlink-trap

 devlink/devlink.c          | 568 +++++++++++++++++++++++++++++++++++--
 devlink/mnlg.c             |  12 +
 devlink/mnlg.h             |   2 +
 man/man8/devlink-monitor.8 |   3 +-
 man/man8/devlink-trap.8    | 166 +++++++++++
 man/man8/devlink.8         |  11 +-
 6 files changed, 742 insertions(+), 20 deletions(-)
 create mode 100644 man/man8/devlink-trap.8

-- 
2.20.1

