Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3A9F26A111
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 10:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726142AbgIOIlp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 04:41:45 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:56257 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726087AbgIOIln (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 04:41:43 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id EBA9C5C00F7;
        Tue, 15 Sep 2020 04:41:41 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 15 Sep 2020 04:41:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=rtPo9mROJo4+zh8Ju
        Eaos8a98nNNY0Jko9o8pezIRlc=; b=j44AQMBIYEWOu1cUzDDdKy/t6wnAT785c
        jthAiIQWzjQ21keWdwuIrvlKfffudYxJFXPdPkoI8hMgu/6P4qp4VZcUN612hn0j
        musC6Siuaz0CAfdkMr5yUejExArIkTIN5LaMPtjg6qR9VS4xazVUNWSgIvv7Irgj
        48ZS8PoyXrt51rNURkyiIQ8BB1Y+X6cuRYgAHzmhhSkEd3e1f5YpTWClMfRsAcC/
        cglMAWpOmG41g9UZUyAWzSrLka5bPj9QkQ4UEiscaV5EuBWavApvzx1mN7klNqJX
        FARcgmlVrHaGQFb60eoFZRrDW6EgAL04tw964W/T/Q2nk4SpPhhXA==
X-ME-Sender: <xms:RX5gX9mJEWo-QMhKNm7sFrR3J58RYvdeZu5pqzo2_dTCtJPTH80X-A>
    <xme:RX5gX43DUnWJDUxqyqRdoOI7EYnT2lZMKcp1oCSrSOr9IdmAgZeMDLLGhy5SPDBAj
    BUH429iAZnbOEw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudeikedgtdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecukfhppeekgedrvddvledrfeeirdekvdenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthh
    esihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:RX5gXzpJStNtY4ov9z88c3gx82f5qVWWC6QhuAK1jpO7OXHdNYF6CA>
    <xmx:RX5gX9m1xsYDNfeq-VyLiOjUJZXlKAvu0Ajl6D_erX-HwdkX85BFHg>
    <xmx:RX5gX70nTDivY0I80jXPQlnDcxpHH_o9c8HnyFf4b2BfTSRdUezIaA>
    <xmx:RX5gX5CPm2xCPIugrP7HgOu2Ga2fFlUm_0fcdcg5gc7le-bvLrMHWw>
Received: from shredder.mtl.com (igld-84-229-36-82.inter.net.il [84.229.36.82])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1C57A3064683;
        Tue, 15 Sep 2020 04:41:39 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 0/8] mlxsw: Introduce fw_fatal health reporter and test cmd to trigger test event
Date:   Tue, 15 Sep 2020 11:40:50 +0300
Message-Id: <20200915084058.18555-1-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Jiri says:

This patch set introduces a health reporter for mlxsw that reports FW
fatal events. Alongside that, it introduces a test command that is used
to trigger a dummy FW fatal event by user:

$ sudo devlink health test pci/0000:03:00.0 reporter fw_fatal

$ devlink health
pci/0000:03:00.0:
  reporter fw_fatal
    state error error 1 recover 0 last_dump_date 2020-07-27 last_dump_time 16:33:27 auto_dump true

$ sudo devlink health dump show pci/0000:03:00.0 reporter fw_fatal -j -p
{
    "irisc_id": 0,
    "event": [
        "id": 3 ],
    "method": "query",
    "long_process": false,
    "command_type": "mad",
    "reg_attr_id": 0
}

As a dependency, the FW validation and flashing is moved to core.c.

Jiri Pirko (8):
  mlxsw: Bump firmware version to XX.2008.1310
  mlxsw: Move fw flashing code into core.c
  mlxsw: core: Push code doing params register/unregister into separate
    helpers
  mlxsw: Move fw_load_policy devlink param into core.c
  mlxsw: reg: Add Monitoring FW Debug Register
  mlxsw: reg: Add Monitoring FW General Debug Register
  devlink: introduce the health reporter test command
  mlxsw: core: Introduce fw_fatal health reporter

 drivers/net/ethernet/mellanox/mlxsw/core.c    | 605 +++++++++++++++++-
 drivers/net/ethernet/mellanox/mlxsw/core.h    |   9 +-
 drivers/net/ethernet/mellanox/mlxsw/reg.h     | 101 +++
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 371 +----------
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   2 -
 drivers/net/ethernet/mellanox/mlxsw/trap.h    |   2 +
 include/net/devlink.h                         |   3 +
 include/uapi/linux/devlink.h                  |   2 +
 net/core/devlink.c                            |  30 +
 9 files changed, 742 insertions(+), 383 deletions(-)

-- 
2.26.2

