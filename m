Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08D6A34C9A6
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 10:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233259AbhC2Ian (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 04:30:43 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60139 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233876AbhC2IaI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 04:30:08 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 1AEC75C00C5;
        Mon, 29 Mar 2021 04:30:07 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 29 Mar 2021 04:30:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=m7OJSGCn6FJ6cMxIHBIJMijx6Er1fjR+zCfdeFlGQQE=; b=HgXBCYXo
        mYkWAgXv9N3N0VdWlZXaKT5RKpyPO+YBfBzPAx8BtqTYPKFz2+zW4AuiSEWOUNk9
        WSAhEXRNRkK53iCaVGt6FOBT0KVELmfK9+IveS3i3sO0K5g6UhV9V5xi9PNM227E
        oe8LDYudiqIsJghJZoIy72EWQbeWzgnMvCfJ1ozC3nF3SW36CQ0HJJr2IrTQ3bLW
        KHjHxbvNRmqv5wmEaDjit4nlNuzG+MrxCuYBSOYiDDbqjj3wzcoup0WHjqFZ5tLI
        LUjR/xqWYngjwMNguYmUUZ2tAxJnA9E7L7EGc3vid/28yCHaZdegNLIJu8fwuKHs
        8e4YgdAOqxcYog==
X-ME-Sender: <xms:D5BhYMkn7oZj_DHizQB_qFSScMLei0Ydwrg9pgQTu4jz9jE86SKdxA>
    <xme:D5BhYL2iZ64XBhIjIl4WO2qEzPdz2iBd83DIe_GGeHg9dx0C162D2LJLRNyWT4R_m
    U-rQ4PUp9fa56o>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudehkedgtdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:D5BhYKpw8kEzBVeuyYLi78IGKB3NLbp1i6xQ5qLiJ_0m4tDejJK8wA>
    <xmx:D5BhYIkgDnOuHaZbEXBEmCIX5_87p_bhfBfEIwjYdSgCaMJMSM0bHg>
    <xmx:D5BhYK20zraTSUO3wcP-pociaxXUJltm47obaozajnt_RAc3NEN44Q>
    <xmx:D5BhYG_7so9aw4iBOClgEArqUzK9kWGqIfgckCQnUmmOO-wSbwXwRQ>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6501624005C;
        Mon, 29 Mar 2021 04:30:05 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, liuhangbin@gmail.com, toke@redhat.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net mlxsw v2 0/2] mlxsw: spectrum: Fix ECN marking in tunnel decapsulation
Date:   Mon, 29 Mar 2021 11:29:25 +0300
Message-Id: <20210329082927.347631-4-idosch@idosch.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210329082927.347631-1-idosch@idosch.org>
References: <20210329082927.347631-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Patch #1 fixes a discrepancy between the software and hardware data
paths with regards to ECN marking after decapsulation. See the changelog
for a detailed description.

Patch #2 extends the ECN decap test to cover all possible combinations
of inner and outer ECN markings. The test passes over both data paths.

v2:
* Only set ECT(1) if inner is ECT(0)
* Introduce a new helper to determine inner ECN. Share it between NVE
  and IP-in-IP tunnels
* Extend the selftest

Ido Schimmel (2):
  mlxsw: spectrum: Fix ECN marking in tunnel decapsulation
  selftests: forwarding: vxlan_bridge_1d: Add more ECN decap test cases

 drivers/net/ethernet/mellanox/mlxsw/spectrum.h    | 15 +++++++++++++++
 .../net/ethernet/mellanox/mlxsw/spectrum_ipip.c   |  7 +++----
 .../net/ethernet/mellanox/mlxsw/spectrum_nve.c    |  7 +++----
 .../selftests/net/forwarding/vxlan_bridge_1d.sh   | 13 ++++++++++++-
 4 files changed, 33 insertions(+), 9 deletions(-)

-- 
2.30.2

