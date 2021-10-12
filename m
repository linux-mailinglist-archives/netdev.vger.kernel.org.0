Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4475A42A5A4
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 15:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236881AbhJLN2X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 09:28:23 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:57329 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236926AbhJLN2N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 09:28:13 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 88C325C0198;
        Tue, 12 Oct 2021 09:26:11 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 12 Oct 2021 09:26:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=ePCGWvYhQ87oNl23CB0D2IhNL+R7UsvKJkNQnBYgWas=; b=IFSrTAuy
        Lc47C/gGpOmmcHnnOE/YIVqd4Xf8c6Xl8M8F9jBvxI+RQDjXCX3n7tWQn93S7KhO
        du25Ta8c+nkbBblqSVXV1nsPICkq1MZ7HCa48m0QyNalP4CmI7zVfUU6xsjuafmZ
        SLIXEbidSOG0OWT4Lr6ogF+tMqRq5e8UE9geQd+HbzJqAmwqNSLOZIAfzFY+yOAb
        wFVUvN1f+GtyAMsEV2ozrZ7Oy07Vuhn8eqPb5ikNI4sdE4p2eHVtsYxet8Y16DWh
        9HMNysaWmoOEWM0WGMJi1GxPT3QemNaYAlG6ETF33x/mXEIDQMhmvzfBD3+3Y/9I
        rWKyL3D0oh62cg==
X-ME-Sender: <xms:84xlYfBiCnRZv6whD9SLUmMgsED9yh8K9506fa5WwUVdlPCGNKZEZw>
    <xme:84xlYVjchVpc3fuNzVlXW8_1tg-B-XyP1yPcRsEoruFGkGu9C9xfYRjDIset2JVNl
    4nk33azQ2rLXDw>
X-ME-Received: <xmr:84xlYak5djdLc75m2AwjQFccrO70cy_Ovo77HWRcnIsDaMS7o_7yd5QQeC5mjcRrSU7_X1fTURJaTyps0DEc2ug1j8QJRPtGAxZCJQCwb7RGsA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddtkedgiedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgepheenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:84xlYRzP08_rPvgVHA2B5zQJeua91PiAmtTq6o-BT3l_RJhKCVTFHA>
    <xmx:84xlYUQbVjvjdRkhQDVHxomRVbvBr6sbg6ux_EpATT870YLdj0AdCQ>
    <xmx:84xlYUZQvzvywSohSj8zIPHfYhiu_84fh1cuJGP1XVjgbFqXPLd00w>
    <xmx:84xlYaPIdBnix6k95RTyCiFzGtdujsSDzcqMKkG2z8pUtMMiednJ7Q>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 12 Oct 2021 09:26:09 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, popadrian1996@gmail.com, andrew@lunn.ch,
        mlxsw@nvidia.com, moshe@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH ethtool-next 09/14] sff-8079: Split SFF-8079 parsing function
Date:   Tue, 12 Oct 2021 16:25:20 +0300
Message-Id: <20211012132525.457323-10-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211012132525.457323-1-idosch@idosch.org>
References: <20211012132525.457323-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

SFF-8079, unlike CMIS and SFF-8636, only has a single page and therefore
its parsing function (i.e., sff8079_show_all()) is called from both the
IOCTL and netlink paths with a buffer pointing to that single page.

In future patches, the netlink code (i.e., netlink/module-eeprom.c) will
no longer call the SFF-8079 code with a buffer pointing to the first 128
bytes of the EEPROM. Instead, the SFF-8079 code will need to request the
needed EEPROM data, as will be done in CMIS and SFF-8636.

Therefore, as a preparation for this change, split the main parsing
function into IOCTL and netlink variants.

No functional changes intended.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 ethtool.c               |  4 ++--
 internal.h              |  3 ++-
 netlink/module-eeprom.c |  2 +-
 sfpid.c                 | 12 +++++++++++-
 4 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/ethtool.c b/ethtool.c
index e3347db78fc3..064bc697926e 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -4900,10 +4900,10 @@ static int do_getmodule(struct cmd_context *ctx)
 			switch (modinfo.type) {
 #ifdef ETHTOOL_ENABLE_PRETTY_DUMP
 			case ETH_MODULE_SFF_8079:
-				sff8079_show_all(eeprom->data);
+				sff8079_show_all_ioctl(eeprom->data);
 				break;
 			case ETH_MODULE_SFF_8472:
-				sff8079_show_all(eeprom->data);
+				sff8079_show_all_ioctl(eeprom->data);
 				sff8472_show_all(eeprom->data);
 				break;
 			case ETH_MODULE_SFF_8436:
diff --git a/internal.h b/internal.h
index 7ca6066d4e12..a77efd385698 100644
--- a/internal.h
+++ b/internal.h
@@ -384,7 +384,8 @@ int rxclass_rule_ins(struct cmd_context *ctx,
 int rxclass_rule_del(struct cmd_context *ctx, __u32 loc);
 
 /* Module EEPROM parsing code */
-void sff8079_show_all(const __u8 *id);
+void sff8079_show_all_ioctl(const __u8 *id);
+void sff8079_show_all_nl(const __u8 *id);
 
 /* Optics diagnostics */
 void sff8472_show_all(const __u8 *id);
diff --git a/netlink/module-eeprom.c b/netlink/module-eeprom.c
index 18b1abbe1252..101d5943c2bc 100644
--- a/netlink/module-eeprom.c
+++ b/netlink/module-eeprom.c
@@ -323,7 +323,7 @@ static void decoder_print(void)
 
 	switch (module_id) {
 	case SFF8024_ID_SFP:
-		sff8079_show_all(page_zero->data);
+		sff8079_show_all_nl(page_zero->data);
 		break;
 	case SFF8024_ID_QSFP:
 	case SFF8024_ID_QSFP28:
diff --git a/sfpid.c b/sfpid.c
index da2b3f4df3d2..c214820226d1 100644
--- a/sfpid.c
+++ b/sfpid.c
@@ -396,7 +396,7 @@ static void sff8079_show_options(const __u8 *id)
 		printf("%s Power level 3 requirement\n", pfx);
 }
 
-void sff8079_show_all(const __u8 *id)
+static void sff8079_show_all_common(const __u8 *id)
 {
 	sff8079_show_identifier(id);
 	if (((id[0] == 0x02) || (id[0] == 0x03)) && (id[1] == 0x04)) {
@@ -439,3 +439,13 @@ void sff8079_show_all(const __u8 *id)
 		sff8079_show_ascii(id, 84, 91, "Date code");
 	}
 }
+
+void sff8079_show_all_ioctl(const __u8 *id)
+{
+	sff8079_show_all_common(id);
+}
+
+void sff8079_show_all_nl(const __u8 *id)
+{
+	sff8079_show_all_common(id);
+}
-- 
2.31.1

