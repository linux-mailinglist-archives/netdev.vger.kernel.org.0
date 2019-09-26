Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA7EABF205
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 13:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbfIZLoU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 07:44:20 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:48817 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726195AbfIZLoU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 07:44:20 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 695C721FC5;
        Thu, 26 Sep 2019 07:44:19 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 26 Sep 2019 07:44:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=kK2x/WkQf9bFe85P2
        JUoPv0Wl/am5NJTR4JRm/TTCsU=; b=ckBLiIKtOe2InZ/INSEiBWa3LMpKIsCCt
        aWTfNsLZMMq9XDYBgd2NbwZDOVtyR003AeqfSyfKyA9mt7uYmkaefy813fc2tc5b
        qYKULTaGP/ablEgNHxib485zncD0H1pvRQ5H+EnKrMEPQNYKFR7RAUfLUOBbup3K
        Xx7QxD27pHyc/TZV2NMlU2KFx/xGx4+3KnsSgobFBr8/8R/T4gIble5cWU43Sm4R
        guruiThuL60wg1cgkuuK7qXrCGZWi2f8dVIMoOBaEY3olrFyMka72yR+lCe1OuQI
        t9mkJqs4U52s4YDsIZ5vj4yWv2u8m2sXiH3SNMIKlUg0ydbSiDojw==
X-ME-Sender: <xms:k6SMXYrB6Mo1LPp0JNQzLhaakFWSW731e51c5EJljB-AyalUKML8Ng>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrfeeggdegfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghh
    rdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihii
    vgeptd
X-ME-Proxy: <xmx:k6SMXdloXy7RqbdSVbxc9ED6QHRRs33OktsseaMlCrxacTsYU3ClRA>
    <xmx:k6SMXZQNiYBbHpR6s73l8VHUxkAl05TbKFjpnBVK2Uk07XljI2wkcA>
    <xmx:k6SMXTYw4RnGvSfjzwYQFkSMDyrJzfxIQUTCWuJwpIXN6ibeoVAcsA>
    <xmx:k6SMXVosyxZen4IuwMnilhDWgyn4nKLECEMt-XQmwvx7pWfA-vK5Dg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id A35D380060;
        Thu, 26 Sep 2019 07:44:16 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, alexanderk@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net 0/3] mlxsw: Various fixes
Date:   Thu, 26 Sep 2019 14:43:37 +0300
Message-Id: <20190926114340.9483-1-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

This patchset includes two small fixes for the mlxsw driver and one
patch which clarifies recently introduced devlink-trap documentation.

Patch #1 clears the port's VLAN filters during port initialization. This
ensures that the drop reason reported to the user is consistent. The
problem is explained in detail in the commit message.

Patch #2 clarifies the description of one of the traps exposed via
devlink-trap.

Patch #3 from Danielle forbids the installation of a tc filter with
multiple mirror actions since this is not supported by the device. The
failure is communicated to the user via extack.

Danielle Ratson (1):
  mlxsw: spectrum_flower: Fail in case user specifies multiple mirror
    actions

Ido Schimmel (2):
  mlxsw: spectrum: Clear VLAN filters during port initialization
  Documentation: Clarify trap's description

 Documentation/networking/devlink-trap.rst                | 3 ++-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c           | 9 +++++++++
 drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c    | 6 ++++++
 .../selftests/drivers/net/mlxsw/devlink_trap_l2_drops.sh | 7 -------
 4 files changed, 17 insertions(+), 8 deletions(-)

-- 
2.21.0

