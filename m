Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E48C93B0D1
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 10:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388041AbfFJIlj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 04:41:39 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:37177 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387979AbfFJIli (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 04:41:38 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id E388720D12;
        Mon, 10 Jun 2019 04:41:37 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 10 Jun 2019 04:41:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Ua6vYOh1KhabBgJd/
        qvWKbPuYg4dumXPwEs6r21B2Z8=; b=MBVZAyJR1HTK8tQ1GLoqKnreTmPpPsE0p
        zEyB5jHbGmaUYLbEQW9zDFU4YDSB+E7dKQ9TQxXoivtKDHa0LV9njCRgfD44zTev
        p8fS0ooOOtyGzFf7ntG4NRqgVwONr1IXCJ4VWBIkrZGvceOgWmR8iorot8LK++Pn
        ZUjRe/PItClSdd+ZlZu8upLyCdNe6NmeFiXP4a8Sgm6Cp/ALTF462Gel+e/nx1IT
        s17k2RCGBci7BfNWzKbXyTL0BHwA5u4CGKhEA/W08/WBwYavUePa7pFxM0oQbq1x
        SDN/ID0evwVa1PLIfLmIgoxhiocMgZTt3hEDHAxN0oYONkXTjOb2w==
X-ME-Sender: <xms:wRf-XNQzgXfC-Vl4dHAre05COfRZJhEQjw3J7ndJ2DS-OEpm_ATzeg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudehvddgtdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpehmrg
    hilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghrufhi
    iigvpedt
X-ME-Proxy: <xmx:wRf-XCkRVaoPOsq9yHaMwMnVFq_37KXKW8nygbYYBc9m_Th-Cd-sbg>
    <xmx:wRf-XIVi9TJ9-nm1ewsBmXsA1MxNEFXdEeT-Hi3UvN47NdVDd5ximQ>
    <xmx:wRf-XHeMlsc_UCy_CTc5M6RzrzzKPTdxwbyePe3IMudVR4oj3pBZPA>
    <xmx:wRf-XGRxznsngmN2802xTV1-jV6YLr1R6eFLYRGdPVv_AZAaag44XA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 61CA980060;
        Mon, 10 Jun 2019 04:41:36 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, amitc@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 0/3] mlxsw: Add speed and auto-negotiation test
Date:   Mon, 10 Jun 2019 11:40:42 +0300
Message-Id: <20190610084045.6029-1-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Amit says:

This patchset adds a selftest which tests different speeds and
auto-negotiation.

Patch #1 Adds functions that retrieve information from ethtool.

Patch #2 Adds option to wait for device with limit of iterations.

Patch #3 Adds the test.

Amit Cohen (3):
  selftests: mlxsw: Add ethtool_lib.sh
  selftests: mlxsw: lib.sh: Add wait for dev with timeout
  selftests: mlxsw: Add speed and auto-negotiation test

 .../selftests/drivers/net/mlxsw/ethtool.sh    | 308 ++++++++++++++++++
 .../selftests/net/forwarding/ethtool_lib.sh   |  91 ++++++
 tools/testing/selftests/net/forwarding/lib.sh |  28 +-
 3 files changed, 424 insertions(+), 3 deletions(-)
 create mode 100755 tools/testing/selftests/drivers/net/mlxsw/ethtool.sh
 create mode 100755 tools/testing/selftests/net/forwarding/ethtool_lib.sh

-- 
2.20.1

