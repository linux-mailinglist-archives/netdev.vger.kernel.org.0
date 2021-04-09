Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CCD035A21C
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 17:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232855AbhDIPhy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 11:37:54 -0400
Received: from 5.mo66.mail-out.ovh.net ([46.105.34.232]:44208 "EHLO
        5.mo66.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbhDIPhy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 11:37:54 -0400
X-Greylist: delayed 4207 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Apr 2021 11:37:53 EDT
Received: from ex2.mail.ovh.net (unknown [10.108.16.196])
        by mo66.mail-out.ovh.net (Postfix) with ESMTPS id A55E71BF22D;
        Fri,  9 Apr 2021 12:50:00 +0200 (CEST)
Received: from lnx01.mybll.net (84.167.156.165) by EX10.indiv2.local
 (172.16.2.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2106.2; Fri, 9 Apr
 2021 12:49:59 +0200
From:   Christian Poessinger <christian@poessinger.com>
To:     <stephen@networkplumber.org>
CC:     <christian@poessinger.com>, <netdev@vger.kernel.org>,
        <u9012063@gmail.com>
Subject: [PATCH] erspan/erspan6: fix JSON output
Date:   Fri, 9 Apr 2021 12:49:47 +0200
Message-ID: <20210409104947.36827-1-christian@poessinger.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210406162802.9041-1-stephen@networkplumber.org>
References: <20210406162802.9041-1-stephen@networkplumber.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [84.167.156.165]
X-ClientProxiedBy: CAS11.indiv2.local (172.16.1.11) To EX10.indiv2.local
 (172.16.2.10)
X-Ovh-Tracer-Id: 3555591908993438190
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduledrudekuddgfeegucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucenucfjughrpefhvffufffkofgjfhgggfgtihesthekredtredttdenucfhrhhomhepvehhrhhishhtihgrnhcurfhovghsshhinhhgvghruceotghhrhhishhtihgrnhesphhovghsshhinhhgvghrrdgtohhmqeenucggtffrrghtthgvrhhnpeejheeuhfffgeeigfeugeefhfdtffeigeffieefkeejtddtjedtfeegveekhfefudenucfkpheptddrtddrtddrtddpkeegrdduieejrdduheeirdduieehnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhpqdhouhhtpdhhvghlohepvgigvddrmhgrihhlrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpegthhhrihhsthhirghnsehpohgvshhsihhnghgvrhdrtghomhdprhgtphhtthhopehuledtuddvtdeifeesghhmrghilhdrtghomh
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The format for erspan/erspan6 output is not valid JSON, as on version 2 a
valueless key was presented. The direction should be value and erspan_dir
should be the key.

Fixes: 289763626721 ("erspan: add erspan version II support")
Cc: u9012063@gmail.com
Cc: Stephen Hemminger <stephen@networkplumber.org>
Reported-by: Christian Poessinger <christian@poessinger.com>
Signed-off-by: Christian Poessinger <christian@poessinger.com>
---
 ip/link_gre.c  | 4 ++--
 ip/link_gre6.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/ip/link_gre.c b/ip/link_gre.c
index 0461e5d0..6d4a8be8 100644
--- a/ip/link_gre.c
+++ b/ip/link_gre.c
@@ -536,10 +536,10 @@ static void gre_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 
 		if (erspan_dir == 0)
 			print_string(PRINT_ANY, "erspan_dir",
-				     "erspan_dir ingress ", NULL);
+				     "erspan_dir %s ", "ingress");
 		else
 			print_string(PRINT_ANY, "erspan_dir",
-				     "erspan_dir egress ", NULL);
+				     "erspan_dir %s ", "egress");
 	}
 
 	if (tb[IFLA_GRE_ERSPAN_HWID]) {
diff --git a/ip/link_gre6.c b/ip/link_gre6.c
index 9d270f4b..f33598af 100644
--- a/ip/link_gre6.c
+++ b/ip/link_gre6.c
@@ -594,10 +594,10 @@ static void gre_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
 
 		if (erspan_dir == 0)
 			print_string(PRINT_ANY, "erspan_dir",
-				     "erspan_dir ingress ", NULL);
+				     "erspan_dir %s ", "ingress");
 		else
 			print_string(PRINT_ANY, "erspan_dir",
-				     "erspan_dir egress ", NULL);
+				     "erspan_dir %s ", "egress");
 	}
 
 	if (tb[IFLA_GRE_ERSPAN_HWID]) {
-- 
2.20.1

