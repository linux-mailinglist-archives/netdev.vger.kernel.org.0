Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15C6F40AC6B
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 13:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232194AbhINL3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 07:29:31 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:40341 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231941AbhINL31 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 07:29:27 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 413005805A9;
        Tue, 14 Sep 2021 07:28:10 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 14 Sep 2021 07:28:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=FJcN3GzOTm+TBWoN47pHFIzN3bdvmzDUMGUOy5zBY
        uo=; b=AsI5oesNPxWnE6c38NbbnCyP5egzPwsEeA7c5ium73FoTXjSYbUIh2PGs
        Pxz5K98ePe4Z5xWm3iQY1c+uGApjz+CcWpfNhPc5mmFh1Qe0JB4ybQmWxk8yMcEe
        XhlG6FAFY8jnGvvDQ6jQgruKr3WRnedACCWUh7PkQBahwVdcP+tm2QIlltwPEH58
        coiIe4apbbekGLuSmcBHpCRFzbEZTqsLgE9957c9bGoT3dRzNHC7xGYcuNddRlbq
        kwgJiCEGloFT8s5P0u19BeJY8Yb6l91c3JMc5pkqgkmMfFp4O2fhVISC/wBle41E
        ZrIIxvFzYwtzhNAOyGaoe3BnPQB1A==
X-ME-Sender: <xms:SYdAYSBft-azSg0RpzSUV3RWUDcbxN8rEciDmC339XmrwWnJRXOZ2Q>
    <xme:SYdAYchcALXu1Fsge1oG1sZYK1ihhHIrwWOYWqG4DElBRcMWP96hYB63PwKex9WKc
    iUWzWWnDWR-U_k>
X-ME-Received: <xmr:SYdAYVmJQ1To6A_yduNefr3mhxCV0PlOm0oV-sgQZBHZHfajjcGfJGJw7dmPjS_hHtu5zMvEkIPnV-ny838gl_D4237juCz_FQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudegledgfeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhggtgfgsehtke
    ertdertdejnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeekheelfeefffdthfeuhfeuieeltd
    fgffejffdvuddtgeefvefhleffteeujeethfenucevlhhushhtvghrufhiiigvpedtnecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:SYdAYQzdFp8Jf49AU0k1YzkeMb13Vl00k0AHH070Oy0bLMz5_ag1bw>
    <xmx:SYdAYXSqqLLyWhWoWmH2YUQin0H-QQT8xE4WH8GaGN6ElxbMhOBTYA>
    <xmx:SYdAYbZny9YLnYD6CpL9NAA4P2xCoDaFI92XdDvomkfMiqK8-bElGA>
    <xmx:SodAYSF6O8Ar2VJfpeJJ_4yVrF5x1LSXl2vb7WbVE8axGq_raN1rIg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 14 Sep 2021 07:28:07 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, kuba@kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        vladyslavt@nvidia.com, moshe@nvidia.com, popadrian1996@gmail.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH ethtool 4/5] ethtool: Fix compilation warning when pretty dump is disabled
Date:   Tue, 14 Sep 2021 14:27:37 +0300
Message-Id: <20210914112738.358627-5-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210914112738.358627-1-idosch@idosch.org>
References: <20210914112738.358627-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

When pretty dump is disabled (i.e., configure --disable-pretty-dump),
gcc 11.2.1 emits the following warning:

ethtool.c: In function ‘dump_regs’:
ethtool.c:1160:31: warning: comparison is always false due to limited range of data type [-Wtype-limits]
 1160 |                 for (i = 0; i < ARRAY_SIZE(driver_list); i++)
      |                               ^

Fix it by avoiding iterating over 'driver_list' when pretty dump is
disabled.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 ethtool.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/ethtool.c b/ethtool.c
index a6826e9f9e3f..46887c7263e1 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -1089,12 +1089,12 @@ static int parse_hkey(char **rss_hkey, u32 key_size,
 	return 0;
 }
 
+#ifdef ETHTOOL_ENABLE_PRETTY_DUMP
 static const struct {
 	const char *name;
 	int (*func)(struct ethtool_drvinfo *info, struct ethtool_regs *regs);
 
 } driver_list[] = {
-#ifdef ETHTOOL_ENABLE_PRETTY_DUMP
 	{ "8139cp", realtek_dump_regs },
 	{ "8139too", realtek_dump_regs },
 	{ "r8169", realtek_dump_regs },
@@ -1129,8 +1129,8 @@ static const struct {
 	{ "fec", fec_dump_regs },
 	{ "igc", igc_dump_regs },
 	{ "bnxt_en", bnxt_dump_regs },
-#endif
 };
+#endif
 
 void dump_hex(FILE *file, const u8 *data, int len, int offset)
 {
@@ -1149,14 +1149,15 @@ void dump_hex(FILE *file, const u8 *data, int len, int offset)
 static int dump_regs(int gregs_dump_raw, int gregs_dump_hex,
 		     struct ethtool_drvinfo *info, struct ethtool_regs *regs)
 {
-	unsigned int i;
-
 	if (gregs_dump_raw) {
 		fwrite(regs->data, regs->len, 1, stdout);
 		goto nested;
 	}
 
-	if (!gregs_dump_hex)
+#ifdef ETHTOOL_ENABLE_PRETTY_DUMP
+	if (!gregs_dump_hex) {
+		unsigned int i;
+
 		for (i = 0; i < ARRAY_SIZE(driver_list); i++)
 			if (!strncmp(driver_list[i].name, info->driver,
 				     ETHTOOL_BUSINFO_LEN)) {
@@ -1168,6 +1169,8 @@ static int dump_regs(int gregs_dump_raw, int gregs_dump_hex,
 				 */
 				break;
 			}
+	}
+#endif
 
 	dump_hex(stdout, regs->data, regs->len, 0);
 
-- 
2.31.1

