Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4CB53E43E5
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 12:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234760AbhHIKYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 06:24:32 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:59023 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234956AbhHIKXy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 06:23:54 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 96C3D5C0134;
        Mon,  9 Aug 2021 06:23:33 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 09 Aug 2021 06:23:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=VusrUf+aL/BE0BgECObih5nPPGS0t017EDaB8u8IHqw=; b=Q0OpULZi
        ythwED51oFpuro9SpylcHs5X84dmDbBIzL/cGtSlHIbwPenBGDbDGbjybd80+n7A
        k9bYQqt2kREyANU2bU/2cvsCHSpWwcGBXRyuQDwsBi6vZC1MF1tGsWiam5ov+r2L
        crgfJtWh6TvEl1D/IZ6xzj9DTo/oWU1CoRXjKNELPpoYdSZmtch8yxW7LlXvPbIp
        D6nigt+Oi/kUzN31S+DfMocZGzxloxe/22U5/rv45T5L1Ei83wOLQHCju+VfaWQQ
        w5oue/Gu6bPU12QFsWeh95tsiF2v7+6AxFAdzluoZSKPNLfVjfrVqP3Q8t3MzQ3x
        X0Px+cJ5Up76cA==
X-ME-Sender: <xms:JQIRYXg7WxQUGV-lppfiKX_MGffy5kpo9W489IMUsEPfAcpgWwkflg>
    <xme:JQIRYUA-3MxmeHGoTe4Hy1X5dtSWDtIW6pSkN8G9R69gv_LialXz8qf-3cU3LTpuf
    fiU76eCStLjTQ8>
X-ME-Received: <xmr:JQIRYXFZFPQXWfHoKDeSxBSH-_f_sNUDSWpODIJUsr4w1kxK6Ojcym5Yo2SdAFzCPOFXNZ-U0ehFCnlhE7cMKkX3PgJf7Ib0-74cTr83P4-b9w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrjeejgddvkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucevlhhushhtvghrufhiiigvpeefnecurfgr
    rhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:JQIRYUQHFez6GpbxSt4IE4I1L0Qxu9jUQ-1qPy2kRazUi8ddz3njKw>
    <xmx:JQIRYUz0blCOc0Ra7rGPTJbdfztYRrl5JqPdbMOtlzgiz6vQDP0irw>
    <xmx:JQIRYa7osI1u3XZ78Jfnid1nkUF810rN2Bex9FTpMJofTrExvRpaMw>
    <xmx:JQIRYblubn_Va9xOaEHVB9SEqQsmkZpYtvyFOMs0ylU45Y247vwLjA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 9 Aug 2021 06:23:31 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        mkubecek@suse.cz, pali@kernel.org, vadimp@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH ethtool-next 5/6] ethtool: Print SFF-8636 Power set and Power override bits
Date:   Mon,  9 Aug 2021 13:22:55 +0300
Message-Id: <20210809102256.720119-6-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210809102256.720119-1-idosch@idosch.org>
References: <20210809102256.720119-1-idosch@idosch.org>
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

 # ethtool --set-module swp13 low-power on

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

 # ethtool --set-module swp13 low-power off

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
index 644fe148a5aa..08ffb90447f3 100644
--- a/qsfp.c
+++ b/qsfp.c
@@ -252,6 +252,12 @@ static void sff8636_show_ext_identifier(const __u8 *id)
 		printf(" High Power Class (> 3.5 W) enabled\n");
 	else
 		printf(" High Power Class (> 3.5 W) not enabled\n");
+	printf("\t%-41s : ", "Power set");
+	printf("%s\n", ONOFF(id[SFF8636_PWR_MODE_OFFSET] &
+			     SFF8636_LOW_PWR_SET));
+	printf("\t%-41s : ", "Power override");
+	printf("%s\n", ONOFF(id[SFF8636_PWR_MODE_OFFSET] &
+			     SFF8636_PWR_OVERRIDE));
 }
 
 static void sff8636_show_connector(const __u8 *id)
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

