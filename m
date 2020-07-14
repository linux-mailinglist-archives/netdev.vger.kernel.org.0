Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75D1B21F3CA
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 16:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728418AbgGNOV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 10:21:56 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:54125 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728530AbgGNOVy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 10:21:54 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 2281C5C00EA;
        Tue, 14 Jul 2020 10:21:53 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 14 Jul 2020 10:21:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=1aV8EcGJvwrHV7ozVih5LMw4xGRlZ9emM2Q9czO2wAE=; b=RcVfr/BP
        1Yuit27yQ2b7SGn8d6V8JdJ9K0rQZlGMYugrdIrZaBPUwOczL/gC+aU1QohAChd4
        2fPRNXtwrrjtUJdWgalzHQO4vmH4zlvll8SGRasetd9grD/DgwYhzQyIdFoF6zJD
        QMtroGf0A8tfuYRn4GNBtpU385QpZf7GeOOfyS3/vxiiosczq4dnbWEEmTtSd8Gw
        cILbq5N7W8chTD3utKueTrbMjJ3qI/2kxSfw6UZWyluSxenxVqB+7+v8sKiuDSfT
        yvTcQHqT1QOB8nbyUeErv4nq2J2h1twQRRKE+VEk0pcumJhab/zAfjaZLI+lR8bF
        07jWiCFpnFTEnA==
X-ME-Sender: <xms:gb8NX2Oclju4VGxEp173F90SwRaqou5OxW7qhW5jtiSE6e1KLIJMQg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrfedtgdejkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepuddtledrieeirdduledrudeffeen
    ucevlhhushhtvghrufhiiigvpeejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:gb8NX0-k2_y_DGyiq9Hs0s2-gPvfIB8H643SOysdGuE8NTj7oGZguw>
    <xmx:gb8NX9RHWPGU5r1ZD4inbbfaEvTbt3kR4AAjNKGwMgZYytvw_x_Mww>
    <xmx:gb8NX2t5cmeYUwulumUKQUS14cLJOJVavT2a_prCnxCUxsC0XDx8eA>
    <xmx:gb8NX-4uNwuSIzGA9924FO0V22ewNRLY_YEnTadhIvvyYJ9TyQuKmg>
Received: from shredder.mtl.com (bzq-109-66-19-133.red.bezeqint.net [109.66.19.133])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4444830600B7;
        Tue, 14 Jul 2020 10:21:51 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, amitc@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 09/13] mlxsw: reg: Increase trap identifier to 10 bits
Date:   Tue, 14 Jul 2020 17:21:02 +0300
Message-Id: <20200714142106.386354-10-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200714142106.386354-1-idosch@idosch.org>
References: <20200714142106.386354-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amitc@mellanox.com>

The trap identifier was increased to 10 bits in new versions of the
Programmer's Reference Manual (PRM).

Increase it accordingly in the Host PacKet Trap (HPKT) register and in
the Completion Queue Element (CQE).

This is significant for subsequent patches that will introduce trap
identifiers which utilize the extended range.

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/pci_hw.h | 2 +-
 drivers/net/ethernet/mellanox/mlxsw/reg.h    | 2 +-
 drivers/net/ethernet/mellanox/mlxsw/trap.h   | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h b/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h
index 32c7cabfb261..697593e44f8a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci_hw.h
@@ -176,7 +176,7 @@ MLXSW_ITEM32(pci, cqe, byte_count, 0x04, 0, 14);
 /* pci_cqe_trap_id
  * Trap ID that captured the packet.
  */
-MLXSW_ITEM32(pci, cqe, trap_id, 0x08, 0, 9);
+MLXSW_ITEM32(pci, cqe, trap_id, 0x08, 0, 10);
 
 /* pci_cqe_crc
  * Length include CRC. Indicates the length field includes
diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 6af44aee501d..408003520602 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -5778,7 +5778,7 @@ MLXSW_ITEM32(reg, hpkt, trap_group, 0x00, 12, 6);
  * Note: A trap ID can only be associated with a single trap group. The device
  * will associate the trap ID with the last trap group configured.
  */
-MLXSW_ITEM32(reg, hpkt, trap_id, 0x00, 0, 9);
+MLXSW_ITEM32(reg, hpkt, trap_id, 0x00, 0, 10);
 
 enum {
 	MLXSW_REG_HPKT_CTRL_PACKET_DEFAULT,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/trap.h b/drivers/net/ethernet/mellanox/mlxsw/trap.h
index 28e60697d14e..8cbb9cf5b57b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/trap.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/trap.h
@@ -108,7 +108,7 @@ enum {
 	MLXSW_TRAP_ID_DISCARD_INGRESS_ACL = 0x1C3,
 	MLXSW_TRAP_ID_DISCARD_EGRESS_ACL = 0x1C4,
 
-	MLXSW_TRAP_ID_MAX = 0x1FF
+	MLXSW_TRAP_ID_MAX = 0x3FF,
 };
 
 enum mlxsw_event_trap_id {
-- 
2.26.2

