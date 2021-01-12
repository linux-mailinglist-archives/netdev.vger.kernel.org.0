Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DD512F2A2B
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 09:44:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392368AbhALIlL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 03:41:11 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:41465 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729871AbhALIlL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 03:41:11 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 0AA5E5C0203;
        Tue, 12 Jan 2021 03:40:05 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 12 Jan 2021 03:40:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Yda/zRcYSHtTFGCzL
        xifWY/0m1OLVMRDyuKkcZsvl2s=; b=pL5KAXRJ68swVQjzvUXAwLsoQ9p5So4gV
        EsdHGaprlk24pz+whJuc5KVFzZcm55F+FSO+y8aoDUIl2xj4tgr+DvLCmspDXXM0
        9/4HcLh6TfmuYhB9YXkiGcvWHkJws/NP/TiklMcgbw/gFIi8NrQh/pxM0KMISIDO
        Pa3oWy5iI8ZnNhPL7q7qOXzhjfs1dz0Xq2am0+U6i+ubi5prOpL65C4P0NdFhbCI
        B7C56q/nVCU4B7aPa8jBWHqLX9XTOhBBWteXoRQifBuBk7ERrNgDyupjWz3HSTf/
        4cCrbQhdepdQWnahTCFioWSn/FD1NzCNgY9xSa7VVqPXT15Ngnb0g==
X-ME-Sender: <xms:ZGD9X1nTC365FIrB0O7m3noLUqqIkAEMmXLLBx8T1wzqTMIu3KJ7lw>
    <xme:ZGD9Xw0P7Za7gsSB-lY1LFfo0-cwdWBZHA_Cy7OevvwZK1gE3OPfSk8VvwaiMrNk7
    V3yeWssgUVjZkw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdehvddguddvfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeetveeghfevgffgffekueffuedvhfeuhe
    ehteffieekgeehveefvdegledvffduhfenucfkphepkeegrddvvdelrdduheefrdeggeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:ZGD9X7pu0VtwXLCheThWxGSdkckaMiKpa5wSDtGsRMC7J4CHodGzbw>
    <xmx:ZGD9X1mtAuZHLdDT3w-fFrvV4RYmALrvddJBrZiF0GwrVJleYJGRhg>
    <xmx:ZGD9Xz2JMY9uFKbq9dyyAMZZLrYQxj1zHreJeeR7ZXD25dorbL0EOw>
    <xmx:ZWD9X0z91phewgCAdRz_6cCbWhb3c89bTX4dQEpTV-Bc_5qxOpfHvg>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 867831080063;
        Tue, 12 Jan 2021 03:40:01 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        danieller@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 0/2] mlxsw: Expose number of physical ports
Date:   Tue, 12 Jan 2021 10:39:29 +0200
Message-Id: <20210112083931.1662874-1-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The switch ASIC has a limited capacity of physical ports that it can
support. While each system is brought up with a different number of
ports, this number can be increased via splitting up to the ASIC's
limit.

Expose physical ports as a devlink resource so that user space will have
visibility into the maximum number of ports that can be supported and
the current occupancy. With this resource it is possible, for example,
to write generic (i.e., not platform dependent) tests for port
splitting.

Patch #1 adds the new resource and patch #2 adds a selftest.

Danielle Ratson (2):
  mlxsw: Register physical ports as a devlink resource
  selftests: mlxsw: Add a scale test for physical ports

 drivers/net/ethernet/mellanox/mlxsw/core.c    | 77 ++++++++++++++++---
 drivers/net/ethernet/mellanox/mlxsw/core.h    |  5 ++
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  2 +-
 .../selftests/drivers/net/mlxsw/port_scale.sh | 64 +++++++++++++++
 .../net/mlxsw/spectrum-2/port_scale.sh        | 16 ++++
 .../net/mlxsw/spectrum-2/resource_scale.sh    |  2 +-
 .../drivers/net/mlxsw/spectrum/port_scale.sh  | 16 ++++
 .../net/mlxsw/spectrum/resource_scale.sh      |  2 +-
 8 files changed, 171 insertions(+), 13 deletions(-)
 create mode 100644 tools/testing/selftests/drivers/net/mlxsw/port_scale.sh
 create mode 100644 tools/testing/selftests/drivers/net/mlxsw/spectrum-2/port_scale.sh
 create mode 100644 tools/testing/selftests/drivers/net/mlxsw/spectrum/port_scale.sh

-- 
2.29.2

