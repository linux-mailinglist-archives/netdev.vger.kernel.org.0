Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 346223F5EA8
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 15:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237472AbhHXNGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 09:06:40 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:46985 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237398AbhHXNGj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 09:06:39 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailnew.nyi.internal (Postfix) with ESMTP id 1A9C5580B18;
        Tue, 24 Aug 2021 09:05:55 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Tue, 24 Aug 2021 09:05:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=YkSy1ym60ptnh/k8y4bFym8sVbbCuBqlkXJM6GeKXUY=; b=nMprv/MA
        sCWkIioES2UZEZzpDjdDw5kjVXfCEUWy2IR9+N9yb4iweY+qyYVjbiHXvxvtv6Xt
        tERzEVbW0Pc3e+ulaOLSJpMk5bRAyXinnuxhE0+jPI7y1Cn3pH1/ae25rcNnuo4S
        RTKR5+BXYscb3qnNJUi145R1v78V7RQ+jqCZpN7By4yJ/bFh2ta7aoIZEwK0qTvZ
        lN13aTdiaIw1FtA64+eCzhwFNDtgrrYhFjslrG/aPFDFu7LTNLvcECISkBh4euWB
        uKGm1jyAQIYZVaNv0aMSLfbR4pF2MLGZXOXS4DowWeJq1W1SX9InivouR8zBGABv
        8QsZuz4i4Vkh/Q==
X-ME-Sender: <xms:se4kYZu-vxGf2PeQzphvJU2CcBM3RT4h9pJi90u8HyjcqbDcfxqq2Q>
    <xme:se4kYSeGvTwVKMWf8CR-XqFYWZ3vosnSbX_MBqFt2CXjz6akTUm2WOgM9AWxdZnfo
    i-lKngMX8xL8qA>
X-ME-Received: <xmr:se4kYcyAjZgFmp_mbZGAvRryQSa2c_0pvVZKKmp1LSwYIz-izvyyNkWLbdz0FInesKrOBEZrHvYn2m8lCQcviJpL6chLXXjKc99X0c2vNBXZ1A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtjedgheelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgepvdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:se4kYQOL6v4oo8DY4JEUSZVgOOOVGPfwEgU5IPZfEybK8gT7nzasxg>
    <xmx:se4kYZ-myT_-D-MiUd0DPxL0k2y8Q1-jcgj-P7HfL8mLnWU2gMbtow>
    <xmx:se4kYQVoCVIs67HUSPJVhiERvYjfO6qb8fftoTxH3UFz2-fg4rKzUw>
    <xmx:s-4kYVQ0Duv100kSrVO-6MAtMDX58D1f7jiD6ZZacewqVRw8Dvm_9A>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 24 Aug 2021 09:05:50 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        mkubecek@suse.cz, pali@kernel.org, jacob.e.keller@intel.com,
        jiri@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH ethtool-next v3 5/6] ethtool: Print SFF-8636 Power set and Power override bits
Date:   Tue, 24 Aug 2021 16:05:14 +0300
Message-Id: <20210824130515.1828270-6-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210824130515.1828270-1-idosch@idosch.org>
References: <20210824130515.1828270-1-idosch@idosch.org>
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

