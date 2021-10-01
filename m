Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFBEC41F081
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 17:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354871AbhJAPIl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 11:08:41 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:41855 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1354964AbhJAPIg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 11:08:36 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 0361E5C0101;
        Fri,  1 Oct 2021 11:06:51 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Fri, 01 Oct 2021 11:06:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=M8wYl+e+ESzswgsA5o2loHZs0TD9do/fA253uUv7uWI=; b=GbtKqTvE
        JbXnuq0He1zZ5jsYRWNhw8JxTfGUxLAE+UYbs7TJq6RKkYhlr6h2Ot4PB9IDALK8
        r1hkFpnmArWtObUs8it/puPdDIz/HI4lbcEmlfD0xPoImbc9YX1UYV0oegMU9TFx
        /xpVRHRvs0Kr3qgCdz7e47XAjQER0G5ooNjQg8bAzTiuBbZQjvDxeblQoAXgrqHH
        x4e2nXoZWUFN3+Sta3FxC4VuABY9Nu0BNJpXEfsbyK3T4OoMSxiefpX8NkY/jpJA
        ewvuNZy+mI1d4Y3vljQBq/cGqcBjc1KryUdJ7CkWDo72koUsfwN+B27qe6+muGst
        ewSrNAscFlRb3w==
X-ME-Sender: <xms:CiRXYZ2zkMjoDe2-0I70J5nS7M8MrZEpOS89le4vJTxsYgMEii7iQA>
    <xme:CiRXYQGkrWnYYgmbLP2R84gHHtQwhLx3l4uYoXx_wgOS30h1II2INEghs_9CSztPI
    9Tl0GOPwZj85V0>
X-ME-Received: <xmr:CiRXYZ4SlAYiOVCCDQaiXXSlnjY4YvjtgVaihX1V9VUfSB9C41Zut_mvMuSr4ajDat-iCfDVNaxQislU-6W9NwGn0DUk9SuRzg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudekiedgkeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:CiRXYW1NUUiVYk6gtvA7r9le9LtFO3pBxru_oaGIO3iUvL6aOSBxSw>
    <xmx:CiRXYcGp7fhNlPHtQ_JGJJpa1LP2Xdc0NziH6rBTRpjDhdFg58ndSQ>
    <xmx:CiRXYX9Jh-DsWqJcAsSYsKTKSTXeunJ1sm335JoZ9UPBREYQExu9Rw>
    <xmx:CyRXYRTOwdcnjDTXn_rGwqUU2foBK8VkmxeXfTqGSnX7rliWPe-ZoQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 1 Oct 2021 11:06:49 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, popadrian1996@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH ethtool-next v2 1/7] cmis: Fix CLEI code parsing
Date:   Fri,  1 Oct 2021 18:06:21 +0300
Message-Id: <20211001150627.1353209-2-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211001150627.1353209-1-idosch@idosch.org>
References: <20211001150627.1353209-1-idosch@idosch.org>
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
 cmis.h | 4 ++--
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/cmis.c b/cmis.c
index 1a91e798e4b8..499355d0e024 100644
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
+	if (*clei && strncmp(clei, CMIS_CLEI_BLANK, CMIS_CLEI_LEN))
+		sff_show_ascii(id, CMIS_CLEI_START_OFFSET, CMIS_CLEI_END_OFFSET,
+			       "CLEI code");
 }
 
 void qsfp_dd_show_all(const __u8 *id)
diff --git a/cmis.h b/cmis.h
index 78ee1495bc33..cfac08f42904 100644
--- a/cmis.h
+++ b/cmis.h
@@ -34,10 +34,10 @@
 #define CMIS_DATE_VENDOR_LOT_OFFSET		0xBC
 
 /* CLEI Code (Page 0) */
-#define CMIS_CLEI_PRESENT_BYTE			0x02
-#define CMIS_CLEI_PRESENT_MASK			0x20
 #define CMIS_CLEI_START_OFFSET			0xBE
 #define CMIS_CLEI_END_OFFSET			0xC7
+#define CMIS_CLEI_BLANK				"          "
+#define CMIS_CLEI_LEN				0x0A
 
 /* Cable assembly length */
 #define CMIS_CBL_ASM_LEN_OFFSET			0xCA
-- 
2.31.1

