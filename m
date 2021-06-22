Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB8D3AFD64
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 08:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230422AbhFVGyW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 02:54:22 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:49591 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230339AbhFVGyT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 02:54:19 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id EB6735C00D4;
        Tue, 22 Jun 2021 02:52:03 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Tue, 22 Jun 2021 02:52:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=7w8L8HyL89jrL2sZ6u2F2y8nYukUlqI0tkLF5SH5wDg=; b=ohkeF3xR
        Pw5DEIo9K1PocVnJDqrjlYZUetB83aazt3skhNCVt9QSXJARwuopj8zn/V4ap4Yh
        you8IeNQjNBL6M33J6sqUA7aaKJY+Ske32eqHXYb4emswJdZeLqjvRq1xrZok5aR
        hMc5Omh2Q45qpvzr1WXk8feIDg36Q0qqCljKUhTv+HXiCCcTEev5fHFhAxeerlOQ
        7S/ePBVKyc0DsyOAqHFz5OPuKDbSkXEJn44Uq8/5J3C9LTkUOxNrEBaN8RTc4x8z
        2dOPWWgvk3GWUMnOBnwy8tTtt7C30Lo64bBCBpN8J9/ZjzuNVl83V9iZaHwO4SM3
        Th4DHR/cIRaXzg==
X-ME-Sender: <xms:k4jRYE4FBQzJFVAW1oA2_KifECuZ3CnwSlQXH9HksfaakD4F6jXfcA>
    <xme:k4jRYF5yxXB-gQE3QDuhKXV_Qui4KC60kfONu4MmF8mEkg8aIM9jnhZstNEWzqS7_
    EZezc_BWw8Wn2Y>
X-ME-Received: <xmr:k4jRYDd-2lJPzLWgUCZM_xBDbKLxoUjr0q1gvUYTNH8vRBYQ5wHKv4s2zCL1MI1zxSc2uebqX7Xqt26y2RMXsD9Vzt7rDvOTW8LAvyxzltCHYg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeegtddguddufecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucevlhhushhtvghrufhiiigvpedtnecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:k4jRYJKTBOYgCgCo9vIAaWLoTAzQC2YbKLP11DdmoF8vX4hPDPPA1w>
    <xmx:k4jRYILFY-9kJLr7K_raH-1LtdriyOmQwLW5w0Cb4uiutHoakRDwbQ>
    <xmx:k4jRYKyArOGSc-YMWNL8DJ3B2tE6t5O_S1u79Zk4jk358BUYJqw9Dw>
    <xmx:k4jRYA9aFmrU4K-z4EkwWsVnhe1e1PwMJt202dPaM8yQSCTakRMsMA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 22 Jun 2021 02:52:02 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vladyslavt@nvidia.com, mkubecek@suse.cz, moshe@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 5/7] ethtool: Use kernel data types for internal EEPROM struct
Date:   Tue, 22 Jun 2021 09:50:50 +0300
Message-Id: <20210622065052.2545107-6-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210622065052.2545107-1-idosch@idosch.org>
References: <20210622065052.2545107-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The struct is not visible to user space and therefore should not use the
user visible data types.

Instead, use internal data types like other structures in the file.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 include/linux/ethtool.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index e030f7510cd3..29dbb603bc91 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -401,12 +401,12 @@ struct ethtool_rmon_stats {
  * required information to the driver.
  */
 struct ethtool_module_eeprom {
-	__u32	offset;
-	__u32	length;
-	__u8	page;
-	__u8	bank;
-	__u8	i2c_address;
-	__u8	*data;
+	u32	offset;
+	u32	length;
+	u8	page;
+	u8	bank;
+	u8	i2c_address;
+	u8	*data;
 };
 
 /**
-- 
2.31.1

