Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECD8641F08C
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 17:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355053AbhJAPIy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 11:08:54 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:39597 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1354973AbhJAPIn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 11:08:43 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 50D2A5C00FF;
        Fri,  1 Oct 2021 11:06:59 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Fri, 01 Oct 2021 11:06:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=x4J8reGaSF8uDtTVxmggr85GwMO34kOnvq4DCaJfDv0=; b=BM7hBnQU
        1bkWOV+nELVOtugqbOJ7LFathOcS4GN2YdEW0eGTAWSP3d51a451MWhnPH24hy0X
        CIIIKfLZAzO2kWBFapf2/lUdzdx2U2wPlIaVzDT5u3wqq+RD719S460n9bhCSdhq
        uwu2IqD/yhRFnaYSnc1VJcMDHFdk4IhusQXE9wPLi13TFlxBOzUreicxxumzNjs9
        33xvzBiWoj7IFi2cft1A55C4RpgXof0Mgr/dtaAN5cs/qQTaxWTQtEYrIGevyFzS
        GCgVlO0mpjiNaMhxnfNKIC5EiJUscLzO4kR1NrJ6N1tzkJxLzfqZzoPr6oqMdTqF
        x6dQ0ZKnzPbnHA==
X-ME-Sender: <xms:EyRXYcvMdjuqgZRu5T1wfA8LTxtaoWPYQ5KyCktSp1-enKKTXBH4MQ>
    <xme:EyRXYZewrSpb0uZkOnUgTNRVdgM_XYXH1IalEF1W7PDDqRp3ogPNlLFmY-zEt55ZU
    Mk7RL94toSa0QQ>
X-ME-Received: <xmr:EyRXYXwyMO1gwtRvKfuS3o6jMkLM6uT720GmfEQ70iyhGxGdC7GoxhA5OpOSzaea1_8q_HAwEbrObsQ1BJ4nG4lA48M7Mx63fg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudekiedgkeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgepudenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:EyRXYfNSFKLlwrQzPGetOd1NsirHmwARln35CzCY8ZOBh-gO5AhHOQ>
    <xmx:EyRXYc9ndbOnNDSLU_mEXNlVfv4ayP2XQu_xzy1cWpcWCqDMjNdhyQ>
    <xmx:EyRXYXXJ-5mYOYClLtztN6ZR41LABig7k8wc4wRQUo6ygtp46aeGdw>
    <xmx:EyRXYeL_UVx5aSpU82Hv9_jxPwCntBWwaYnft31XYhcGEyBbeJeAwA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 1 Oct 2021 11:06:58 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, popadrian1996@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH ethtool-next v2 6/7] sff-8636: Convert if statement to switch-case
Date:   Fri,  1 Oct 2021 18:06:26 +0300
Message-Id: <20211001150627.1353209-7-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211001150627.1353209-1-idosch@idosch.org>
References: <20211001150627.1353209-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The indentation is wrong and the statement can be more clearly
represented using a switch-case statement. Convert it.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 qsfp.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/qsfp.c b/qsfp.c
index 3401db84352d..d1464cb50fdc 100644
--- a/qsfp.c
+++ b/qsfp.c
@@ -863,11 +863,13 @@ void sff8636_show_all(const __u8 *id, __u32 eeprom_len)
 	}
 
 	sff8636_show_identifier(id);
-	if ((id[SFF8636_ID_OFFSET] == SFF8024_ID_QSFP) ||
-		(id[SFF8636_ID_OFFSET] == SFF8024_ID_QSFP_PLUS) ||
-		(id[SFF8636_ID_OFFSET] == SFF8024_ID_QSFP28)) {
+	switch (id[SFF8636_ID_OFFSET]) {
+	case SFF8024_ID_QSFP:
+	case SFF8024_ID_QSFP_PLUS:
+	case SFF8024_ID_QSFP28:
 		sff8636_show_page_zero(id);
 		sff8636_show_dom(id, id + 3 * 0x80, eeprom_len);
+		break;
 	}
 }
 
-- 
2.31.1

