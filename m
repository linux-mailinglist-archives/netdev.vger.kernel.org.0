Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A652155CC8
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 18:27:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727009AbgBGR1M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Feb 2020 12:27:12 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:48539 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726874AbgBGR1M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Feb 2020 12:27:12 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 3DE3A21ACF;
        Fri,  7 Feb 2020 12:27:11 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 07 Feb 2020 12:27:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=sY8sWYs/9BwE4JzfU
        rg4CYuvbIsSbsJpr4rAIOJiqIA=; b=Z17JnNp5GwqHMmGDG7lIEVaDyfVX0uQaQ
        Yk8phsmqKMA1ES7tIgfP+mNU+Oc2jjTj4Xvcabif0bC9f91ukYrp52x0CKPe38Ar
        zFpZ/Iqfv6SqLhTBASFQgXzRZ8NZP9QZhi50blorQgSr2ZWhE098xd0BFEawGjRg
        CUKTWOlkT+gRD6EAgF9aKOJFSd3PqIGtno5mS5I+7pK57qCZ7fYFKky/MCiGsNou
        KPwttSLqXUMMQRsrT7JKug2HliwAN0jzlN0p/mI10i3Wf/yip8E1AlPvJ5IQlOIR
        6a1qPBgZ/TGDoJZCIYDEgodSQmJEr18V19szmeaG9fJZWMZ7GJyHg==
X-ME-Sender: <xms:7509XhUB6M_ojG0hcE_EQvJBOKRh-h-mV6wxQ8wsGGEk5jDjPcCwcQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrheehgddutdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecukfhppeejledrudekfedruddtjedruddvtdenucevlhhushhtvghruf
    hiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghh
    rdhorhhg
X-ME-Proxy: <xmx:7509Xl1JQs086tuS3mlNPiPLydY-va8n6CbzDtlWdtncH-hXDS2KPg>
    <xmx:7509Xoa3ifxXE0eTgRAcFG7qhPAEdHnWqcm_cdFVAqoUA-uK3tYCsA>
    <xmx:7509XoqRDLR_xzaEZwmaEbgGbm7JUgua3vAL1uixtJuB75EFNeygFg>
    <xmx:7509XgEUw15kGZ9lQRIEKTb1qLpywNmC3rc9nmOSkVaRqFuKn_9Gng>
Received: from splinter.mtl.com (bzq-79-183-107-120.red.bezeqint.net [79.183.107.120])
        by mail.messagingengine.com (Postfix) with ESMTPA id A24453060272;
        Fri,  7 Feb 2020 12:27:09 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net 0/5] mlxsw: Various fixes
Date:   Fri,  7 Feb 2020 19:26:23 +0200
Message-Id: <20200207172628.128763-1-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

This patch set contains various fixes for the mlxsw driver.

Patch #1 fixes an issue introduced in 5.6 in which a route in the main
table can replace an identical route in the local table despite the
local table having an higher precedence.

Patch #2 contains a test case for the bug fixed in patch #1.

Patch #3 also fixes an issue introduced in 5.6 in which the driver
failed to clear the offload indication from IPv6 nexthops upon abort.

Patch #4 fixes an issue that prevents the driver from loading on
Spectrum-3 systems. The problem and solution are explained in detail in
the commit message.

Patch #5 adds a missing error path. Discovered using smatch.

Ido Schimmel (4):
  mlxsw: spectrum_router: Prevent incorrect replacement of local table
    routes
  selftests: mlxsw: Add test cases for local table route replacement
  mlxsw: spectrum_router: Clear offload indication from IPv6 nexthops on
    abort
  mlxsw: spectrum_dpipe: Add missing error path

Vadim Pasternak (1):
  mlxsw: core: Add validation of hardware device types for MGPIR
    register

 .../net/ethernet/mellanox/mlxsw/core_hwmon.c  |  6 +-
 .../ethernet/mellanox/mlxsw/core_thermal.c    |  8 +-
 .../ethernet/mellanox/mlxsw/spectrum_dpipe.c  |  3 +-
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 55 +++++++++++++-
 .../selftests/drivers/net/mlxsw/fib.sh        | 76 +++++++++++++++++++
 5 files changed, 142 insertions(+), 6 deletions(-)

-- 
2.24.1

