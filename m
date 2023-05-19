Return-Path: <netdev+bounces-4029-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D44F270A2BC
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 00:19:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BCA911C20A41
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 22:19:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B95B118008;
	Fri, 19 May 2023 22:19:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2DDA17AC9
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 22:19:49 +0000 (UTC)
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04C191A6;
	Fri, 19 May 2023 15:19:48 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-64d2ca9ef0cso1287756b3a.1;
        Fri, 19 May 2023 15:19:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684534787; x=1687126787;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=t3Q1MOEK6ChpXw3jkAO0kwtWOdAAbJAxYZ/CrlPUGvE=;
        b=BZZHMiOXl1ct/fb83CfPSeSMu6Yn/UNlNgrTwNeeMyWcTW3XNrkjij+gSTrpTwqQT4
         4XraRf70oVaNFE8K6SqYSihK3CRX7HjFpjmuGVAKU2FfKgUuoLrwdFtIf0C1r0cv4dqI
         6EV8UES9bAECh2fqJKkiDJ2FWECirzjZumWu7IyeiiA9Rp7WqZPHobgm3+jO4SY3ouxe
         rLo+0t9dYztIGy00J3WuO2oUUpZp1aSlJDF/6hPWH9DpXv7edKEz+obErVGbSNnbyAAW
         JaGv953J2vunS4l30VLQWX+lS6Zae/k1OWzi6cEOapOMOnzFy8MwTo4NhHMLEadPiC0w
         Kh6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684534787; x=1687126787;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t3Q1MOEK6ChpXw3jkAO0kwtWOdAAbJAxYZ/CrlPUGvE=;
        b=O7bB52B9jCQkFMmJtddH2NHvrDs+xvX1LbtLI7aOJ/eRfGlCERx2uwJmcDzQpYLS1c
         DCOEP04dkXjvoQJjtb4tunZLcyRhSBLNJgYa/fnX9zIe4Gr+1/Xe3yLpXJE5AzTOtijz
         huQaJvOPryQnqIcdc2VYnD9aLTZziJ+3xx9PHXcJgOa0v3uDY+GEYBTRPBXOJAB4DAah
         U7uZ27odU3+b+O1EBoM9+UgLBykjVL3uQbos3cNCNGVjKXpbnhHgxbiSB+64+ixrimHa
         SyU+gzDo4tAFVSqQwfLjk9sqcW/Y5naBv9S2OQ5N0q1ovv+pmtY1TcREOaLoI5aThVZk
         D3lA==
X-Gm-Message-State: AC+VfDxjKSUpb/Gk5sgXup++PF9YTR6RlID7IrKB4ifRkJj6Fk+CxEAh
	dPyNYPfNtq8U4tyE07H4zAQ=
X-Google-Smtp-Source: ACHHUZ6Mg9zUUTOTx2za/xpUveNMXiqZ/tzEt+9rsusxRzUze+ZXCv+dpl9/tyHECw8he3Pf419fSA==
X-Received: by 2002:a05:6a20:1614:b0:106:8534:514 with SMTP id l20-20020a056a20161400b0010685340514mr4171275pzj.43.1684534787452;
        Fri, 19 May 2023 15:19:47 -0700 (PDT)
Received: from ubuntu777.domain.name (36-228-97-28.dynamic-ip.hinet.net. [36.228.97.28])
        by smtp.gmail.com with ESMTPSA id c19-20020aa78813000000b0064d2d0ff8d5sm146417pfo.163.2023.05.19.15.19.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 May 2023 15:19:46 -0700 (PDT)
From: Min-Hua Chen <minhuadotchen@gmail.com>
To: Nicolas Ferre <nicolas.ferre@microchip.com>,
	Claudiu Beznea <claudiu.beznea@microchip.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Min-Hua Chen <minhuadotchen@gmail.com>,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] net: macb: use correct __be32 and __be16 types
Date: Sat, 20 May 2023 06:19:39 +0800
Message-Id: <20230519221942.53942-1-minhuadotchen@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This patch fixes the following sparse warnings. No functional changes.

Use cpu_to_be16() and cpu_to_be32() to convert constants before comparing
them with __be16 type of psrc/pdst and __be32 type of ip4src/ip4dst.
Apply be16_to_cpu() in GEM_BFINS().

Also, remove unnecessary parentheses reported by checkpatch.pl.

drivers/net/ethernet/cadence/macb_main.c:3448:39: sparse: warning: restricted __be32 degrades to integer
drivers/net/ethernet/cadence/macb_main.c:3453:39: sparse: warning: restricted __be32 degrades to integer
drivers/net/ethernet/cadence/macb_main.c:3458:40: sparse: warning: restricted __be16 degrades to integer
drivers/net/ethernet/cadence/macb_main.c:3458:69: sparse: warning: restricted __be16 degrades to integer
drivers/net/ethernet/cadence/macb_main.c:3483:20: sparse: warning: restricted __be32 degrades to integer
drivers/net/ethernet/cadence/macb_main.c:3497:20: sparse: warning: restricted __be32 degrades to integer
drivers/net/ethernet/cadence/macb_main.c:3511:21: sparse: warning: restricted __be16 degrades to integer
drivers/net/ethernet/cadence/macb_main.c:3511:50: sparse: warning: restricted __be16 degrades to integer
drivers/net/ethernet/cadence/macb_main.c:3517:30: sparse: warning: restricted __be16 degrades to integer
drivers/net/ethernet/cadence/macb_main.c:3518:30: sparse: warning: restricted __be16 degrades to integer
drivers/net/ethernet/cadence/macb_main.c:3525:36: sparse: warning: restricted __be16 degrades to integer
drivers/net/ethernet/cadence/macb_main.c:3526:38: sparse: warning: restricted __be16 degrades to integer
drivers/net/ethernet/cadence/macb_main.c:3529:38: sparse: warning: restricted __be16 degrades to integer

Signed-off-by: Min-Hua Chen <minhuadotchen@gmail.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 29a1199dad14..034ec42eaf6d 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -3445,17 +3445,18 @@ static void gem_enable_flow_filters(struct macb *bp, bool enable)
 		/* only enable fields with no masking */
 		tp4sp_m = &(fs->m_u.tcp_ip4_spec);
 
-		if (enable && (tp4sp_m->ip4src == 0xFFFFFFFF))
+		if (enable && tp4sp_m->ip4src == cpu_to_be32(0xFFFFFFFF))
 			t2_scr = GEM_BFINS(CMPAEN, 1, t2_scr);
 		else
 			t2_scr = GEM_BFINS(CMPAEN, 0, t2_scr);
 
-		if (enable && (tp4sp_m->ip4dst == 0xFFFFFFFF))
+		if (enable && tp4sp_m->ip4dst == cpu_to_be32(0xFFFFFFFF))
 			t2_scr = GEM_BFINS(CMPBEN, 1, t2_scr);
 		else
 			t2_scr = GEM_BFINS(CMPBEN, 0, t2_scr);
 
-		if (enable && ((tp4sp_m->psrc == 0xFFFF) || (tp4sp_m->pdst == 0xFFFF)))
+		if (enable && (tp4sp_m->psrc == cpu_to_be16(0xFFFF) ||
+			       tp4sp_m->pdst == cpu_to_be16(0xFFFF)))
 			t2_scr = GEM_BFINS(CMPCEN, 1, t2_scr);
 		else
 			t2_scr = GEM_BFINS(CMPCEN, 0, t2_scr);
@@ -3480,7 +3481,7 @@ static void gem_prog_cmp_regs(struct macb *bp, struct ethtool_rx_flow_spec *fs)
 	tp4sp_m = &(fs->m_u.tcp_ip4_spec);
 
 	/* ignore field if any masking set */
-	if (tp4sp_m->ip4src == 0xFFFFFFFF) {
+	if (tp4sp_m->ip4src == cpu_to_be32(0xFFFFFFFF)) {
 		/* 1st compare reg - IP source address */
 		w0 = 0;
 		w1 = 0;
@@ -3494,7 +3495,7 @@ static void gem_prog_cmp_regs(struct macb *bp, struct ethtool_rx_flow_spec *fs)
 	}
 
 	/* ignore field if any masking set */
-	if (tp4sp_m->ip4dst == 0xFFFFFFFF) {
+	if (tp4sp_m->ip4dst == cpu_to_be32(0xFFFFFFFF)) {
 		/* 2nd compare reg - IP destination address */
 		w0 = 0;
 		w1 = 0;
@@ -3508,25 +3509,26 @@ static void gem_prog_cmp_regs(struct macb *bp, struct ethtool_rx_flow_spec *fs)
 	}
 
 	/* ignore both port fields if masking set in both */
-	if ((tp4sp_m->psrc == 0xFFFF) || (tp4sp_m->pdst == 0xFFFF)) {
+	if (tp4sp_m->psrc == cpu_to_be16(0xFFFF) ||
+	    tp4sp_m->pdst == cpu_to_be16(0xFFFF)) {
 		/* 3rd compare reg - source port, destination port */
 		w0 = 0;
 		w1 = 0;
 		w1 = GEM_BFINS(T2CMPOFST, GEM_T2COMPOFST_IPHDR, w1);
 		if (tp4sp_m->psrc == tp4sp_m->pdst) {
-			w0 = GEM_BFINS(T2MASK, tp4sp_v->psrc, w0);
-			w0 = GEM_BFINS(T2CMP, tp4sp_v->pdst, w0);
+			w0 = GEM_BFINS(T2MASK, be16_to_cpu(tp4sp_v->psrc), w0);
+			w0 = GEM_BFINS(T2CMP, be16_to_cpu(tp4sp_v->pdst), w0);
 			w1 = GEM_BFINS(T2DISMSK, 1, w1); /* 32-bit compare */
 			w1 = GEM_BFINS(T2OFST, IPHDR_SRCPORT_OFFSET, w1);
 		} else {
 			/* only one port definition */
 			w1 = GEM_BFINS(T2DISMSK, 0, w1); /* 16-bit compare */
 			w0 = GEM_BFINS(T2MASK, 0xFFFF, w0);
-			if (tp4sp_m->psrc == 0xFFFF) { /* src port */
-				w0 = GEM_BFINS(T2CMP, tp4sp_v->psrc, w0);
+			if (tp4sp_m->psrc == cpu_to_be16(0xFFFF)) { /* src port */
+				w0 = GEM_BFINS(T2CMP, be16_to_cpu(tp4sp_v->psrc), w0);
 				w1 = GEM_BFINS(T2OFST, IPHDR_SRCPORT_OFFSET, w1);
 			} else { /* dst port */
-				w0 = GEM_BFINS(T2CMP, tp4sp_v->pdst, w0);
+				w0 = GEM_BFINS(T2CMP, be16_to_cpu(tp4sp_v->pdst), w0);
 				w1 = GEM_BFINS(T2OFST, IPHDR_DSTPORT_OFFSET, w1);
 			}
 		}
-- 
2.34.1


