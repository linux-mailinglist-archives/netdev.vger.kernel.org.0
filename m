Return-Path: <netdev+bounces-2448-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 61D8F701F83
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 22:40:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7B43D2810A5
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 20:40:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91AACBA55;
	Sun, 14 May 2023 20:40:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 847218BEC
	for <netdev@vger.kernel.org>; Sun, 14 May 2023 20:40:35 +0000 (UTC)
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 080EEE48;
	Sun, 14 May 2023 13:40:34 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1aad5245632so84927565ad.3;
        Sun, 14 May 2023 13:40:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684096833; x=1686688833;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zwPLcczfHaotQQ5Bh17U80i7Ky8OX0CQkStxEqL6Fgc=;
        b=arhp3JVNanZ3mDqxFjZiB8gxrZ2yc95p3ehPSMQFIs0pBDN4GbhW15bAYkDArYXWxe
         PNRazoUGwkZcqLpQTzdbfWNgij0PHRAnzd64cRaFqsHE+iwK1VV3UMB33oKkJFL3vI7V
         Nj/9qGw2lSCmCIxYcoayNVOK4aQFrp47AfwYIWqXxUNZ0m4Xj5yI1KpQ/5d9Dxf9T6zV
         hWYgREcS4L5Z9Pkapd8Zr0mdgoz7WOJC6wikeSf4VIRhKz3L+K9QfzxzYQig4MXwTpb1
         jGf2NXr7bbPLPgYzbHpv2YYvrgWkUCNGbz+QNuu0nutgKO/mDlJHxiY+I1Hl0SoNIGlI
         wQIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684096833; x=1686688833;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zwPLcczfHaotQQ5Bh17U80i7Ky8OX0CQkStxEqL6Fgc=;
        b=U331c464BuQJiID2OOyHKLU+FkmSu68zEx+m2byUnGVbsnZ9dXQpHA1qCFhFS6b15R
         dzN1OoQIz1MJ/9JaM0xszdiwsnvcp7ko60s2AJyLmAbGvKOuMbP+3jcVRSJbSe69gUNB
         xFQkvVgDX/L42LbKcB2RyW/E5vL2Rqd9t9hgHjcOFxyIW99gMJ9Rqgr1IeN3eDI5gZON
         lYliVK15gBeFSalaFGanZYWwsY2FSbHf+mxMzEePETTuuf6j4+pj0QA4dRrb5XXRQoqU
         AWBxr+dt570RvclbtMddpz/zdUfFWX7pvjs9RfHls0OGOuL24dRVbbYQJ1dVtmqVvu8m
         47Ug==
X-Gm-Message-State: AC+VfDzwBrv907dlOQALp4vZU5Et/oWUUwZppbpy5L99haAVacDGrbey
	zgKi5Ai+a+QZ0Ry6D4B8pLPpH3I+Kn/J509E
X-Google-Smtp-Source: ACHHUZ7fHlQcMNMqR0RvcWfFlbZEad1kN5FXzfk/2sm3wmpI7CBb72k4x1lLrqrl/n0GmaU3NXYhOQ==
X-Received: by 2002:a17:902:cece:b0:1a6:413c:4a3e with SMTP id d14-20020a170902cece00b001a6413c4a3emr41204234plg.5.1684096832828;
        Sun, 14 May 2023 13:40:32 -0700 (PDT)
Received: from [127.0.1.1] ([2601:644:8f00:4f:728d:4faf:7256:5a34])
        by smtp.gmail.com with ESMTPSA id q6-20020a170902b10600b001ab06958770sm11851906plr.161.2023.05.14.13.40.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 May 2023 13:40:32 -0700 (PDT)
From: Abhijeet Rastogi <abhijeet.1989@gmail.com>
Date: Sun, 14 May 2023 13:40:24 -0700
Subject: [PATCH v2] ipvs: increase ip_vs_conn_tab_bits range for 64BIT
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230412-increase_ipvs_conn_tab_bits-v2-1-994c0df018e6@gmail.com>
X-B4-Tracking: v=1; b=H4sIADdHYWQC/42OQQrDIBREr1Jc16JGQtNV71GCfI0mHxoT/CItI
 XevyQm6fDPDzGyMfEJP7HHZWPIFCZdYQV0vzE0QR89xqMyUUI3QUnGMLnkgb3AtZNwSo8lgjcV
 MXDdKuU4MoGTLaoOtOW4TRDcdHTNQ9ukw1uQDfs7ZV195QspL+p4vijzU/waL5JK3AnTognb3o
 J7jDPi+uWVm/b7vPyYGOiXfAAAA
To: Simon Horman <horms@verge.net.au>, Julian Anastasov <ja@ssi.bg>, 
 Pablo Neira Ayuso <pablo@netfilter.org>, 
 Jozsef Kadlecsik <kadlec@netfilter.org>, Florian Westphal <fw@strlen.de>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org, lvs-devel@vger.kernel.org, 
 netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
 linux-kernel@vger.kernel.org, Abhijeet Rastogi <abhijeet.1989@gmail.com>
X-Mailer: b4 0.12.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1684096831; l=4400;
 i=abhijeet.1989@gmail.com; s=20230412; h=from:subject:message-id;
 bh=QKVsMjlQX/gTjNeKg6CZJYA0FFD+ARtEhFp33qX1UfA=;
 b=sDfvG6taPYG+iOeJr8xKMiapaAP0Fg4ONAtQiELClNWJMnRmkP3Q2skQOHBpGSL7wsrR+M1YZ
 WxQ2My9Kk2YArg0ZTXCHQZxUctAsIDaldhamEzKBnYNpDguqE6Era3r
X-Developer-Key: i=abhijeet.1989@gmail.com; a=ed25519;
 pk=VinODWUuJys1VAWZP2Uv9slcHekoZvxAp4RY1p5+OfU=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Current range [8, 20] is set purely due to historical reasons
because at the time, ~1M (2^20) was considered sufficient.
With this change, 27 is the upper limit for 64-bit, 20 otherwise.

Previous change regarding this limit is here.

Link: https://lore.kernel.org/all/86eabeb9dd62aebf1e2533926fdd13fed48bab1f.1631289960.git.aclaudi@redhat.com/T/#u

Signed-off-by: Abhijeet Rastogi <abhijeet.1989@gmail.com>
---
The conversation for this started at: 

https://www.spinics.net/lists/netfilter/msg60995.html

The upper limit for algo is any bit size less than 32, so this
change will allow us to set bit size > 20. Today, it is common to have
RAM available to handle greater than 2^20 connections per-host.

Distros like RHEL already allow setting limits higher than 20.
---
Changes in v2:
- Lower the ranges, 27 for 64bit, 20 otherwise
- Link to v1: https://lore.kernel.org/r/20230412-increase_ipvs_conn_tab_bits-v1-1-60a4f9f4c8f2@gmail.com
---
 net/netfilter/ipvs/Kconfig      | 26 +++++++++++++-------------
 net/netfilter/ipvs/ip_vs_conn.c |  4 ++--
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/net/netfilter/ipvs/Kconfig b/net/netfilter/ipvs/Kconfig
index 271da8447b29..aac5d6bd82e6 100644
--- a/net/netfilter/ipvs/Kconfig
+++ b/net/netfilter/ipvs/Kconfig
@@ -44,7 +44,8 @@ config	IP_VS_DEBUG
 
 config	IP_VS_TAB_BITS
 	int "IPVS connection table size (the Nth power of 2)"
-	range 8 20
+	range 8 20 if !64BIT
+	range 8 27 if 64BIT
 	default 12
 	help
 	  The IPVS connection hash table uses the chaining scheme to handle
@@ -52,18 +53,17 @@ config	IP_VS_TAB_BITS
 	  reduce conflicts when there are hundreds of thousands of connections
 	  in the hash table.
 
-	  Note the table size must be power of 2. The table size will be the
-	  value of 2 to the your input number power. The number to choose is
-	  from 8 to 20, the default number is 12, which means the table size
-	  is 4096. Don't input the number too small, otherwise you will lose
-	  performance on it. You can adapt the table size yourself, according
-	  to your virtual server application. It is good to set the table size
-	  not far less than the number of connections per second multiplying
-	  average lasting time of connection in the table.  For example, your
-	  virtual server gets 200 connections per second, the connection lasts
-	  for 200 seconds in average in the connection table, the table size
-	  should be not far less than 200x200, it is good to set the table
-	  size 32768 (2**15).
+	  Note the table size must be power of 2. The table size will be the value
+	  of 2 to the your input number power. The number to choose is from 8 to 27
+	  for 64BIT(20 otherwise), the default number is 12, which means the table
+	  size is 4096. Don't input the number too small, otherwise you will lose
+	  performance on it. You can adapt the table size yourself, according to
+	  your virtual server application. It is good to set the table size not far
+	  less than the number of connections per second multiplying average lasting
+	  time of connection in the table.  For example, your virtual server gets
+	  200 connections per second, the connection lasts for 200 seconds in
+	  average in the connection table, the table size should be not far less
+	  than 200x200, it is good to set the table size 32768 (2**15).
 
 	  Another note that each connection occupies 128 bytes effectively and
 	  each hash entry uses 8 bytes, so you can estimate how much memory is
diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index 13534e02346c..e1b9b52909a5 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -1484,8 +1484,8 @@ int __init ip_vs_conn_init(void)
 	int idx;
 
 	/* Compute size and mask */
-	if (ip_vs_conn_tab_bits < 8 || ip_vs_conn_tab_bits > 20) {
-		pr_info("conn_tab_bits not in [8, 20]. Using default value\n");
+	if (ip_vs_conn_tab_bits < 8 || ip_vs_conn_tab_bits > 27) {
+		pr_info("conn_tab_bits not in [8, 27]. Using default value\n");
 		ip_vs_conn_tab_bits = CONFIG_IP_VS_TAB_BITS;
 	}
 	ip_vs_conn_tab_size = 1 << ip_vs_conn_tab_bits;

---
base-commit: 09a9639e56c01c7a00d6c0ca63f4c7c41abe075d
change-id: 20230412-increase_ipvs_conn_tab_bits-4322c90da216

Best regards,
-- 
Abhijeet Rastogi <abhijeet.1989@gmail.com>


