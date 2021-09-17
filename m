Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA20F40FA79
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 16:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242867AbhIQOm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 10:42:26 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:55029 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343695AbhIQOmY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 10:42:24 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id CCF495C021E;
        Fri, 17 Sep 2021 10:41:01 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 17 Sep 2021 10:41:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=4pki6aSXrAcSkuV+lNxXgLLin8sdbB2exH8Az+G4kiQ=; b=iLlLHub8
        L2Es/Kiy57KAC4+FdPF6Z/XExBwUzA3Hw5MLgv+GXHYj+dfHX+4Ld0o3K9L60g18
        yZZe9Johr0b0qcc4/ZAR1EXM5ihfaZAhfXmw/+n33UdaaPLMJBU3yLn6532KWYnd
        WSUtBUOT6PTuhPaLsG5zcC7w3T/HSPSm1xLsiIsdyEJa7qGsdWP+BbhRkLMDZ+6h
        wOFkgXvKINxmKNxM0Zy5MZy1MAuM8P7bwXnFEd4q30YbK4Tb/WohwYG9XdgJKpeG
        pmlxcXg/B66Un0zgw+RLVMCHzLvGGTO3u2OkUnIt1IgV68KofVYxQA8Yq9MC0rNx
        LXLO99yJiT3gBQ==
X-ME-Sender: <xms:_ahEYf8uxJ_AdIpR30P5QnrVQtujE_7qSZdIuuAg9XtZjSyhK_82UQ>
    <xme:_ahEYbs4ywX1H0h-QN7nfdsyjk10i8giKR2NN6Kay1nXbfRszI5tL1_0eRh5Iy1Ny
    EZF6WpWDS-umFY>
X-ME-Received: <xmr:_ahEYdCBQ3o0uWC1YZYhIXamNbVWZhmvpwBOTBJCw7nUBo3Ng9pBlfeSJAlTbA5MwIHDjYG0LeBsHMweoLzEZ80eKlWIp_SKLQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudehiedgjeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:_ahEYbeRAgbu6LeZ79ksqRneBWKFtWxKAnzrGp8IEAKjVB7sNB-v-Q>
    <xmx:_ahEYUM5-iBc2miQlp3knyrTmNAfTqFJc8Qy1RCw5ZqsZdIzbqwhhw>
    <xmx:_ahEYdkvpz52hzq0pJrIDEsXn1x2JEAfuAYIl6xGGC6MJSEja2D7Kg>
    <xmx:_ahEYRpI5_179NDJaXdZmL23ijXUzh7yjfuVZjMXq8T0ydZZv23V5Q>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 17 Sep 2021 10:40:59 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, vadimp@nvidia.com, moshe@nvidia.com,
        popadrian1996@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH ethtool-next 1/7] cmis: Fix CLEI code parsing
Date:   Fri, 17 Sep 2021 17:40:37 +0300
Message-Id: <20210917144043.566049-2-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210917144043.566049-1-idosch@idosch.org>
References: <20210917144043.566049-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

In CMIS, unlike SFF-8636, there is no presence indication for the CLEI
code (Common Language Equipment Identification) field. The field is
always present, but might not be supported. In which case, "a value of
all ASCII 20h (spaces) shall be entered".

Therefore, remove the erroneous check which seems to be influenced from
SFF-8636 and only print the string if it is supported and has a non-zero
length.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 cmis.c | 8 +++++---
 cmis.h | 3 +--
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/cmis.c b/cmis.c
index 1a91e798e4b8..2a48c1a1d56a 100644
--- a/cmis.c
+++ b/cmis.c
@@ -307,6 +307,8 @@ static void cmis_show_link_len(const __u8 *id)
  */
 static void cmis_show_vendor_info(const __u8 *id)
 {
+	const char *clei = (const char *)(id + CMIS_CLEI_START_OFFSET);
+
 	sff_show_ascii(id, CMIS_VENDOR_NAME_START_OFFSET,
 		       CMIS_VENDOR_NAME_END_OFFSET, "Vendor name");
 	cmis_show_oui(id);
@@ -319,9 +321,9 @@ static void cmis_show_vendor_info(const __u8 *id)
 	sff_show_ascii(id, CMIS_DATE_YEAR_OFFSET,
 		       CMIS_DATE_VENDOR_LOT_OFFSET + 1, "Date code");
 
-	if (id[CMIS_CLEI_PRESENT_BYTE] & CMIS_CLEI_PRESENT_MASK)
-		sff_show_ascii(id, CMIS_CLEI_START_OFFSET,
-			       CMIS_CLEI_END_OFFSET, "CLEI code");
+	if (strlen(clei) && strcmp(clei, CMIS_CLEI_BLANK))
+		sff_show_ascii(id, CMIS_CLEI_START_OFFSET, CMIS_CLEI_END_OFFSET,
+			       "CLEI code");
 }
 
 void qsfp_dd_show_all(const __u8 *id)
diff --git a/cmis.h b/cmis.h
index 78ee1495bc33..d365252baa48 100644
--- a/cmis.h
+++ b/cmis.h
@@ -34,10 +34,9 @@
 #define CMIS_DATE_VENDOR_LOT_OFFSET		0xBC
 
 /* CLEI Code (Page 0) */
-#define CMIS_CLEI_PRESENT_BYTE			0x02
-#define CMIS_CLEI_PRESENT_MASK			0x20
 #define CMIS_CLEI_START_OFFSET			0xBE
 #define CMIS_CLEI_END_OFFSET			0xC7
+#define CMIS_CLEI_BLANK				"          "
 
 /* Cable assembly length */
 #define CMIS_CBL_ASM_LEN_OFFSET			0xCA
-- 
2.31.1

