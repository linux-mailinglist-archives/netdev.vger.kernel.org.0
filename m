Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 656543F0886
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 17:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240299AbhHRPyX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 11:54:23 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:51515 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240078AbhHRPyN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 11:54:13 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id BB589583012;
        Wed, 18 Aug 2021 11:53:38 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 18 Aug 2021 11:53:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=/j8AmpA1SIEwBogYgkLwBX6Fe4Mrxe8M/Pp546t55cw=; b=L1cza4Cl
        lSgT5opjbRKEBegGe1rx2lHT7C3i/Rc2SED1XYtl2bCn2girxce/o1uhXw9uVH58
        MfHSl/3GEwvKKZqj/EByOa8JBBqoB9sqacVBeAEtXSZvFdtrp6VkJXZXLhuFPAte
        m820MvPIvgvU4nqY5Fs+2cdPcIF4sPv3MUbZ7+WZwA3iarBrp0Fd64S2fynunS4S
        y2hwn2gzVtEeuEDy3LQovC15JraCdyL7wJ6VAVzd4YcUoy/QfooKKR7jkw3PmWCI
        q5iztMu/aGKbetUBPSlz3GJzh0JHXgqxmv+42REjUwdLKfaucWWFc+g1ttJH1H4J
        8/ypTc802ZvLCg==
X-ME-Sender: <xms:Ai0dYWfi81Vi6xP800tXLXd16kIX3_60VjjcQS3cuTJ56T1i4Z9eXw>
    <xme:Ai0dYQMMKgfvZaxoWcqIUlEgdBaSFZ7R_Kny_zVeIpaYDVFJgEEKdKF6eHW_oQhqs
    MG1Ae3liha5Ct8>
X-ME-Received: <xmr:Ai0dYXgn1nc2uFQguVaCcfmnrO3a-pCvi7XCbJZR4JT4354xv6VkhaVDTOfuu4udRr_PL0gZNQPmIOnEmhosdZgPMEBffujAeVI2iEbghl_fbw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrleehgdelfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucevlhhushhtvghrufhiiigvpedunecurfgr
    rhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:Ai0dYT8KKCWbnvepdZgKK3VmYG-IvPJnhtWcVDY61lia6xa9tFeIjQ>
    <xmx:Ai0dYSu7mBtU1dKwFbQDv3i9fAkMAIrUF3ZSiKIfW5Vbxs8mYp9AbQ>
    <xmx:Ai0dYaHvuk48zLO7XbMiUHojZ9IM6zyiF2ER0VTSLwbYy4fL0ZZhVw>
    <xmx:Ai0dYQDevTPOhPHwv5iIGBN-zm_O3-yla-YBMpUvjWMZ8qWRMUkqUg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 18 Aug 2021 11:53:36 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        mkubecek@suse.cz, pali@kernel.org, jacob.e.keller@intel.com,
        jiri@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH ethtool-next v2 5/6] ethtool: Print SFF-8636 Power set and Power override bits
Date:   Wed, 18 Aug 2021 18:53:05 +0300
Message-Id: <20210818155306.1278356-6-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210818155306.1278356-1-idosch@idosch.org>
References: <20210818155306.1278356-1-idosch@idosch.org>
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

 # ethtool --set-module swp13 power-mode-policy low

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

