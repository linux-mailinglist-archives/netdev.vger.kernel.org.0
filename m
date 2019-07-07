Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04D386145D
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 10:02:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727329AbfGGICs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 04:02:48 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:40255 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727259AbfGGICr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 04:02:47 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 815831C2E;
        Sun,  7 Jul 2019 04:02:46 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 07 Jul 2019 04:02:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=rm7kWBoTiupsYJF0hXOuWHRvFGvVGtgnjz/KRcNVGbc=; b=fR2juOQw
        wJGfHLSxNcPu8ihr7XS8XTCQzJv7QxkVy2CapcmYkYIdH1K74BBr97abaYTQbY1k
        IAgqORcPidcBKI/esuTt2mvrHLgMIpRStqvtHGPzwPQiH8rJGluo5xNGyxcE5hnW
        aKs+Wb37CUyriHgIHsH/uzI0PLmfkKOSBFPpwdzx8vFY7ZRwpm6heTAVno3snVdC
        nkw5lhf2GCiELhbglIU42rNX1FNMAnjpap3VNnqifzxzpGaEt/4RY6t/I0Q5kvJJ
        JlQR2CODpDfWqzTrBzdmBHRSeLjJGZNv9KTng+k31rCL0eV1+OlPVM+tE/vzyUTb
        7dvGNkb/Q1opbQ==
X-ME-Sender: <xms:JqchXT4T5UbhyZa7Ul-RAKd2NNAvCScXdL8_siMtK6cuPmzJYwxNJA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrfeejgdduvdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:JqchXfUgfMVuwJma5w9-jg1qHJGUhYsonqUct_kczPninVOXO806QQ>
    <xmx:JqchXTQ57F0iEJmsExVAORx3a0FzVJjtl-rSGh8gBRW33GPOWSpbjQ>
    <xmx:JqchXXD4VBHoRPHfidJDLGTVEoQELUOS2o6z1ejCCwITZKc6ceDkiw>
    <xmx:JqchXRJBNe4XUdDexfNFkm5thWmS63J_GY8Z_dhT_hY32ewL-CSCFA>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id E781A8005B;
        Sun,  7 Jul 2019 04:02:43 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, andy@greyhouse.net,
        pablo@netfilter.org, jakub.kicinski@netronome.com,
        pieter.jansenvanvuuren@netronome.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH iproute2-next 6/7] devlink: Add fflush() to print functions
Date:   Sun,  7 Jul 2019 11:01:59 +0300
Message-Id: <20190707080200.3699-7-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190707080200.3699-1-idosch@idosch.org>
References: <20190707075828.3315-1-idosch@idosch.org>
 <20190707080200.3699-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Similar to commit 09e0528cf977 ("ip: mroute: add fflush to
print_mroute"), we need to add fflush() to the print functions to get
the following to work:

# devlink mon &> log

Without it, stdout output is buffered and not written to the disk.

This is useful when writing tests that rely on devlink-monitor output.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 devlink/devlink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 817b74259ec3..6fa3be69ff1a 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -58,6 +58,7 @@ static int g_new_line_count;
 		}						\
 		fprintf(stdout, ##args);			\
 		g_new_line_count = 0;				\
+		fflush(stdout);					\
 	} while (0)
 
 #define pr_out_sp(num, args...)					\
@@ -66,6 +67,7 @@ static int g_new_line_count;
 		if (ret < num)					\
 			fprintf(stdout, "%*s", num - ret, "");	\
 		g_new_line_count = 0;				\
+		fflush(stdout);					\
 	} while (0)
 
 static int g_indent_level;
-- 
2.20.1

