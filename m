Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB1745AA39
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 18:41:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239376AbhKWRou (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 12:44:50 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:34377 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239375AbhKWRot (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 12:44:49 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 602955C00F3;
        Tue, 23 Nov 2021 12:41:40 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 23 Nov 2021 12:41:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=CwFfsmJrlSpA/jGeMXK/nr7qnI2bWKt+/CIqGoP5O2Q=; b=MoF8qgy0
        R7Jru+droGxoFg27DNLiiVX0MynOcJTIp5bHogWkIXmxG9KIUmtvKVbwL1giSDy1
        wVTA0axnaS73wgCDi3+BCeFM4pdnCEFeHGPQoIjQAsExBox7AMBJf1IStHDiuPNo
        S7pEagmZHmQ8QDzP4+zphfULdq7nAQLMc/Vub1cwdbkVpXKX1BiYL9xs7mEWGZpm
        M5zJWYIRsf/vHRDj9+89nNXwGbWyNAOxg1IqXKp8MCbMqD86ruHpcYdLwTUiA3tt
        qZDRN4okCBDOqEYH3LE1gZEjn3wVAqFRpTHCx7T60iIgfsjfztzrjCAFD0tBd9eb
        kj15BafrxgmhCQ==
X-ME-Sender: <xms:1CedYdmnR2Rh0reOuvq3Uyoqooq00GZyg88cGk985QRfdpNBuGL2wQ>
    <xme:1CedYY2JUUX1jYz_KIO5HU2JjIAk89hMUgMsl4JHz5kw7Hx7MKsO6Agt5UrkG76Ew
    DIADQ3568iqAXg>
X-ME-Received: <xmr:1CedYTqXqNCKPo3xhGh5rO4fDgk8aP5O_tgyl_dXu2TjdXxSGun9BOoRWZBuBV5HJ9RLiEBd7FF6-vL_8oTR4AeAD_5PbswQ2YWxg1FLB_GnOA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrgeeigddutdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgepfeenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:1CedYdnrAUrSU3w0qcyJ59Zx0miKqb3ynBI-AzZfOqslO2rqEFNC6Q>
    <xmx:1CedYb0lBhMtd78oZTM9Wp0rR3QBM_ctB-2e07Zn0ms0RQl-TRbMLA>
    <xmx:1CedYct7qNCaQ6ykOnCd14tUkQJK-o8p_CKZYtUvDzBapW5pb80p1g>
    <xmx:1CedYWSB1odhCwCSS3PXgGNG97ozPPmTWEp6jaBnGkUTpbwC7Od6iA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 23 Nov 2021 12:41:38 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, popadrian1996@gmail.com, andrew@lunn.ch,
        mlxsw@nvidia.com, moshe@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH ethtool-next 8/8] sff-8636: Print Power set and Power override bits
Date:   Tue, 23 Nov 2021 19:41:02 +0200
Message-Id: <20211123174102.3242294-9-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211123174102.3242294-1-idosch@idosch.org>
References: <20211123174102.3242294-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Print the SFF-8636 Power set and Power override bits when dumping EEPROM
contents via the '-m' option. They can be used to understand low power
mode enforcement by the host.

The 'SFF8636_LOW_PWR_MODE' define is renamed to 'SFF8636_LOW_PWR_SET' to
reflect its naming in the standard for QSFP+/QSFP28.

Example output:

 # ethtool -m swp13
 Identifier                                : 0x11 (QSFP28)
 ...
 Extended identifier description           : 5.0W max. Power consumption,  High Power Class (> 3.5 W) enabled
 Power set                                 : Off
 Power override                            : On
 ...
 Transmit avg optical power (Channel 1)    : 0.7633 mW / -1.17 dBm
 Transmit avg optical power (Channel 2)    : 0.7649 mW / -1.16 dBm
 Transmit avg optical power (Channel 3)    : 0.7696 mW / -1.14 dBm
 Transmit avg optical power (Channel 4)    : 0.7739 mW / -1.11 dBm
 Rcvr signal avg optical power(Channel 1)  : 0.9240 mW / -0.34 dBm
 Rcvr signal avg optical power(Channel 2)  : 0.9129 mW / -0.40 dBm
 Rcvr signal avg optical power(Channel 3)  : 0.9194 mW / -0.36 dBm
 Rcvr signal avg optical power(Channel 4)  : 0.8708 mW / -0.60 dBm

 # ethtool --set-module swp13 power-mode-policy auto

 # ethtool -m swp13
 Identifier                                : 0x11 (QSFP28)
 ...
 Extended identifier description           : 5.0W max. Power consumption,  High Power Class (> 3.5 W) not enabled
 Power set                                 : On
 Power override                            : On
 ...
 Transmit avg optical power (Channel 1)    : 0.0000 mW / -inf dBm
 Transmit avg optical power (Channel 2)    : 0.0000 mW / -inf dBm
 Transmit avg optical power (Channel 3)    : 0.0000 mW / -inf dBm
 Transmit avg optical power (Channel 4)    : 0.0000 mW / -inf dBm
 Rcvr signal avg optical power(Channel 1)  : 0.0000 mW / -inf dBm
 Rcvr signal avg optical power(Channel 2)  : 0.0000 mW / -inf dBm
 Rcvr signal avg optical power(Channel 3)  : 0.0000 mW / -inf dBm
 Rcvr signal avg optical power(Channel 4)  : 0.0000 mW / -inf dBm

 # ethtool --set-module swp13 power-mode-policy high

 # ethtool -m swp13
 Identifier                                : 0x11 (QSFP28)
 ...
 Extended identifier description           : 5.0W max. Power consumption,  High Power Class (> 3.5 W) enabled
 Power set                                 : Off
 Power override                            : On
 ...
 Transmit avg optical power (Channel 1)    : 0.7733 mW / -1.12 dBm
 Transmit avg optical power (Channel 2)    : 0.7754 mW / -1.10 dBm
 Transmit avg optical power (Channel 3)    : 0.7885 mW / -1.03 dBm
 Transmit avg optical power (Channel 4)    : 0.7886 mW / -1.03 dBm
 Rcvr signal avg optical power(Channel 1)  : 0.9248 mW / -0.34 dBm
 Rcvr signal avg optical power(Channel 2)  : 0.9129 mW / -0.40 dBm
 Rcvr signal avg optical power(Channel 3)  : 0.9187 mW / -0.37 dBm
 Rcvr signal avg optical power(Channel 4)  : 0.8785 mW / -0.56 dBm

In the above example, the LPMode signal is ignored (Power override is
always on) and low power mode is controlled via software only.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 qsfp.c | 6 ++++++
 qsfp.h | 2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/qsfp.c b/qsfp.c
index b3c9e1516af9..57aac86bd5f6 100644
--- a/qsfp.c
+++ b/qsfp.c
@@ -268,6 +268,12 @@ static void sff8636_show_ext_identifier(const struct sff8636_memory_map *map)
 		printf(" High Power Class (> 3.5 W) enabled\n");
 	else
 		printf(" High Power Class (> 3.5 W) not enabled\n");
+	printf("\t%-41s : ", "Power set");
+	printf("%s\n", ONOFF(map->lower_memory[SFF8636_PWR_MODE_OFFSET] &
+			     SFF8636_LOW_PWR_SET));
+	printf("\t%-41s : ", "Power override");
+	printf("%s\n", ONOFF(map->lower_memory[SFF8636_PWR_MODE_OFFSET] &
+			     SFF8636_PWR_OVERRIDE));
 }
 
 static void sff8636_show_connector(const struct sff8636_memory_map *map)
diff --git a/qsfp.h b/qsfp.h
index 1d8f24b5cbc2..aabf09fdc623 100644
--- a/qsfp.h
+++ b/qsfp.h
@@ -180,7 +180,7 @@
 
 #define	SFF8636_PWR_MODE_OFFSET		0x5D
 #define	 SFF8636_HIGH_PWR_ENABLE		(1 << 2)
-#define	 SFF8636_LOW_PWR_MODE			(1 << 1)
+#define	 SFF8636_LOW_PWR_SET			(1 << 1)
 #define	 SFF8636_PWR_OVERRIDE			(1 << 0)
 
 #define	SFF8636_TX_APP_SELECT_4_OFFSET	0x5E
-- 
2.31.1

