Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6452A42A5A8
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 15:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236923AbhJLN2a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 09:28:30 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:40649 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237049AbhJLN2V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 09:28:21 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id C2EE65C01B7;
        Tue, 12 Oct 2021 09:26:19 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 12 Oct 2021 09:26:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=E/JsxXRB4zdVs8oZvi/IUOP88op31uOiCnLdFcyfrUo=; b=B7RmG1Tw
        bELYcN9dT/6w5M+pQ5rFSVgxgQZm/SRCWSp87I2Z5cHEeJ6R4CbZDqCWXA5t8mCl
        lQOnqYdaFf0aV2TfL6CcqOFHiC5qH6GWYNX0geTig4u/PeHpwPSdUow1RL7fZIJ7
        upREDDZzhh+mljTebHXGgoGLp/dsNY24HsXW9E4wD/pRkN4Nl/eoLJE/vmW+/aEs
        aLoJzFI164ArZi1onq4NoM4gS6ayygo16LI040Fh/squrjVZr2ll5dA5gD29PJcT
        G4t6A4SGA69KCgSAGypUYJn6MnZXP4WlVww4IC8hX24Xqe0CnYBGqxL++jDHR7XX
        mZryCVWMRIoZAw==
X-ME-Sender: <xms:-4xlYdxIcqTsdePsIlZKu7N4HGSpMvGbIfogLUNi4DPV6uq9bRWF8g>
    <xme:-4xlYdTJ5Ozx01-l8LPcJQh_uEQsP-hidHahYjx_FeLDlgtk5wpkC1AB6BAfz4uEP
    g5Ibe7HP1iENqc>
X-ME-Received: <xmr:-4xlYXW_jkm0vJaU5e_VhbqRbVQOhWlSJy18aa7KIxVTrgVOepWg_XZJxeL98I9dnszWX0mFSAvo06KGKOhf1ue4-kpWqUd7zzsbFoQfU6YWyw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddtkedgiedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgepjeenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:-4xlYfgOisyZZGcd4BZ68xN265priK3e65JxYqqq0WyO8dUBPhiH7Q>
    <xmx:-4xlYfDzHjm772-o4ayAlJYj646Fb8oMrCq3NioE4wlQ255hdmIyXg>
    <xmx:-4xlYYIZfqO80Cup8Klvb3D02YRlPISN5X8rMlbCCwBWNgr34Qv9-w>
    <xmx:-4xlYa8kfGEbp4cSAP5EjZRwFSjm3FicI_QbGo2MRqn0xyHioPLlLQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 12 Oct 2021 09:26:17 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, popadrian1996@gmail.com, andrew@lunn.ch,
        mlxsw@nvidia.com, moshe@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH ethtool-next 13/14] sff-8079: Request specific pages for parsing in netlink path
Date:   Tue, 12 Oct 2021 16:25:24 +0300
Message-Id: <20211012132525.457323-14-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211012132525.457323-1-idosch@idosch.org>
References: <20211012132525.457323-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Convert the SFF-8079 code to request the required EEPROM contents in the
netlink path as was done for CMIS and SFF-8636. It will allow us to
remove standard-specific code from the netlink code (i.e.,
netlink/module-eeprom.c).

In addition, in the future, it will allow the netlink path to support
parsing of SFF-8472.

Tested by making sure that the output of 'ethtool -m' does not change
before and after the patch.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 internal.h              |  2 +-
 netlink/module-eeprom.c |  2 +-
 sfpid.c                 | 20 ++++++++++++++++++--
 3 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/internal.h b/internal.h
index 2407d3c223fa..0d9d816ab563 100644
--- a/internal.h
+++ b/internal.h
@@ -385,7 +385,7 @@ int rxclass_rule_del(struct cmd_context *ctx, __u32 loc);
 
 /* Module EEPROM parsing code */
 void sff8079_show_all_ioctl(const __u8 *id);
-void sff8079_show_all_nl(const __u8 *id);
+int sff8079_show_all_nl(struct cmd_context *ctx);
 
 /* Optics diagnostics */
 void sff8472_show_all(const __u8 *id);
diff --git a/netlink/module-eeprom.c b/netlink/module-eeprom.c
index f04f8e134223..6d76b8a96461 100644
--- a/netlink/module-eeprom.c
+++ b/netlink/module-eeprom.c
@@ -321,7 +321,7 @@ static void decoder_print(struct cmd_context *ctx)
 
 	switch (module_id) {
 	case SFF8024_ID_SFP:
-		sff8079_show_all_nl(page_zero->data);
+		sff8079_show_all_nl(ctx);
 		break;
 	case SFF8024_ID_QSFP:
 	case SFF8024_ID_QSFP28:
diff --git a/sfpid.c b/sfpid.c
index c214820226d1..621d1e86c278 100644
--- a/sfpid.c
+++ b/sfpid.c
@@ -8,8 +8,13 @@
  */
 
 #include <stdio.h>
+#include <errno.h>
 #include "internal.h"
 #include "sff-common.h"
+#include "netlink/extapi.h"
+
+#define SFF8079_PAGE_SIZE	0x80
+#define SFF8079_I2C_ADDRESS_LOW	0x50
 
 static void sff8079_show_identifier(const __u8 *id)
 {
@@ -445,7 +450,18 @@ void sff8079_show_all_ioctl(const __u8 *id)
 	sff8079_show_all_common(id);
 }
 
-void sff8079_show_all_nl(const __u8 *id)
+int sff8079_show_all_nl(struct cmd_context *ctx)
 {
-	sff8079_show_all_common(id);
+	struct ethtool_module_eeprom request = {
+		.length = SFF8079_PAGE_SIZE,
+		.i2c_address = SFF8079_I2C_ADDRESS_LOW,
+	};
+	int ret;
+
+	ret = nl_get_eeprom_page(ctx, &request);
+	if (ret < 0)
+		return ret;
+	sff8079_show_all_common(request.data);
+
+	return 0;
 }
-- 
2.31.1

