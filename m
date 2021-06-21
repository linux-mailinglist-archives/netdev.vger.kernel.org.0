Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D9C23AE460
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 09:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbhFUHxv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 03:53:51 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:53461 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229618AbhFUHxu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 03:53:50 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 7C9015C006A;
        Mon, 21 Jun 2021 03:51:36 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 21 Jun 2021 03:51:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=GMAchcXaWxbHGLWsDwaEn/g7yc8oz9KXkrrn8SUoexg=; b=CJDGEupv
        enQ9nVOpiV4+7ikPWZdg64h2dtqgFg/fWmFzdIALt3S+3aywJ22itSiHeoOww8hV
        xVX7aJxx55uI4Z/Cjuzp/JdVv/M7wa0pzJ0VrzxB+LN1F3egnWlNqxCtfZl04gjB
        KUxJpXpaPChKEnqw3mDvC8Mq5wVSGbCbHKafSlwjt+ohqPZVwYd8Ki8NVgvILltE
        7jWHGXENwO7vxhIgQ5hgfsQu3HIejD3Pa4Zj614Q/n/kyfYuyXLAQCazATOrnH0t
        NlSikEYZt6sMNgXj/VerPyQzRbMGRsAABsdVmQ/ppXjYuVGbkECStFCAeabXL7Yx
        UYPk3wze+qlc8w==
X-ME-Sender: <xms:B0XQYDSufOSCFyom2043iOchcgV7s7qWMHo86xwpaX9vgkin8vxWNQ>
    <xme:B0XQYEwAf0X3JBr-_NPGx5SDG-THG2GzyY1cmjEv9O9FJf1zGyq17gup0QceknAbG
    mcmYtq87gNiK0s>
X-ME-Received: <xmr:B0XQYI3Ax9avEKGNFHzeJ8AahCAfl4JRtGM8D2u70ktcawRNAPZFuojavvC9_ul-bDP-BGGkfJtGJGo04OW8ri8IWhb1eIyGTJqT0mH9Kcl6BA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeefkedguddvudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucevlhhushhtvghrufhiiigvpedtnecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:B0XQYDAW6_aUjz4eeYgPHq13SkPOAANMkVQRNFQAsseFOwHlGDHRoQ>
    <xmx:B0XQYMhWi6hbvs5kWvfbtZE7v4Dw160ibn-Ool5DKFWnzc8nSHPnLg>
    <xmx:B0XQYHo_kuSY9t0mk4ykL4CIjbOWqYiMeaz37cMTZOpzXMkfWP3X3A>
    <xmx:CEXQYEfaiDcIz3c7fvQ28vTyedNC7Nmu8b5ZtXP2hOIVEoRF5ClRNw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 21 Jun 2021 03:51:33 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 1/3] mlxsw: reg: Add bank number to MCIA register
Date:   Mon, 21 Jun 2021 10:50:39 +0300
Message-Id: <20210621075041.2502416-2-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210621075041.2502416-1-idosch@idosch.org>
References: <20210621075041.2502416-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Add bank number to MCIA (Management Cable Info Access) register in order
to allow access to banked pages on EEPROMs using CMIS (Common Management
Interface Specification) memory map.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 93f1db3927af..cd60a0f91933 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -9714,6 +9714,12 @@ MLXSW_ITEM32(reg, mcia, page_number, 0x04, 16, 8);
  */
 MLXSW_ITEM32(reg, mcia, device_address, 0x04, 0, 16);
 
+/* reg_mcia_bank_number
+ * Bank number.
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, mcia, bank_number, 0x08, 16, 8);
+
 /* reg_mcia_size
  * Number of bytes to read/write (up to 48 bytes).
  * Access: RW
-- 
2.31.1

