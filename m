Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB401E180D
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 01:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388479AbgEYXGR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 19:06:17 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51259 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387942AbgEYXGQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 19:06:16 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 73F235C017D;
        Mon, 25 May 2020 19:06:15 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 25 May 2020 19:06:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=QinADWmHArGiUqPsh
        XfYO5XT08TktQuIHZ70ngegIt4=; b=li/E6ZH9Lyj5Uj0TDofHqOUVyO/m2+/31
        z75PSmY2r+sn7yDrds8IrTLW3qoOuc4mjFKidpmSMMX4+R+meAuJdw8K8iTCK+Gz
        OmPD1dGuYEyGA1m6ZB3gGQxV1bZ2mawIBfrOHwDGBzIAMsxODNa8DdFPLIGSan2I
        P+kdtraGC982oMQXEJgA/Ldkt0tFXRiFS3h4c/lE8sauZmDxcHeaX7HUR1TsoFqe
        rQMEjBmPJrYBYSy/pDueH1euv69SBv8F9rGFKe6oUtk5MRvn6ASmJmBHuwhqh1Ae
        oS7hX77kGUvAwtn7+iYXGvGWE+2BQxRf5UoUtRwPZzaXK8/vUsOSw==
X-ME-Sender: <xms:Z0_MXgwyQsgDt5CaD6QV6446bL6AH27cFPjn2vvrtujmEvGfP5PtUQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddvuddgudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecukfhppeejledrudejiedrvdegrddutdejnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstg
    hhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:Z0_MXkQzLJBIsQJhseNmWSbHcHcSSuo0jNaBih8zv3DbGFiRtWIdeA>
    <xmx:Z0_MXiVE8UqFf4dy24S7PFur89K7iUUq6x_SafTRCV0tb70ZiuWwGw>
    <xmx:Z0_MXuit8tiwY-n4wJtSK7PVIvAkbFEG5p_ApFccrHstCGRgsKYAzw>
    <xmx:Z0_MXj6OKgexJ_uwMOSmtHaSc54_7tJFwmNo8uOfRHVSf61ujrqe8g>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 13C763280059;
        Mon, 25 May 2020 19:06:13 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 00/14] mlxsw: Various trap changes - part 2
Date:   Tue, 26 May 2020 02:05:42 +0300
Message-Id: <20200525230556.1455927-1-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

This patch set contains another set of small changes in mlxsw trap
configuration. It is the last set before exposing control traps (e.g.,
IGMP query, ARP request) via devlink-trap.

Tested with existing devlink-trap selftests. Please see individual
patches for a detailed changelog.

Ido Schimmel (14):
  mlxsw: spectrum: Use dedicated trap group for ACL trap
  mlxsw: spectrum: Use same switch case for identical groups
  mlxsw: spectrum: Rename IPv6 ND trap group
  mlxsw: spectrum: Use same trap group for various IPv6 packets
  mlxsw: spectrum: Use separate trap group for FID miss
  mlxsw: spectrum: Use same trap group for local routes and link-local
    destination
  mlxsw: spectrum: Reduce priority of locally delivered packets
  mlxsw: switchx2: Move SwitchX-2 trap groups out of main enum
  mlxsw: spectrum_trap: Do not hard code "thin" policer identifier
  mlxsw: reg: Move all trap groups under the same enum
  mlxsw: spectrum: Share one group for all locally delivered packets
  mlxsw: spectrum: Treat IPv6 link-local SIP as an exception
  mlxsw: spectrum: Add packet traps for BFD packets
  mlxsw: spectrum_router: Allow programming link-local prefix routes

 drivers/net/ethernet/mellanox/mlxsw/reg.h     | 17 ++++----
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 40 +++++++++++--------
 .../ethernet/mellanox/mlxsw/spectrum_router.c |  6 ++-
 .../ethernet/mellanox/mlxsw/spectrum_trap.c   | 17 +++++---
 .../ethernet/mellanox/mlxsw/spectrum_trap.h   |  2 +
 .../net/ethernet/mellanox/mlxsw/switchx2.c    |  5 +++
 drivers/net/ethernet/mellanox/mlxsw/trap.h    |  2 +
 .../drivers/net/mlxsw/sharedbuffer.sh         |  2 +-
 8 files changed, 56 insertions(+), 35 deletions(-)

-- 
2.26.2

