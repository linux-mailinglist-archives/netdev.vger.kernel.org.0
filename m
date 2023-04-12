Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F00426E002A
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 22:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbjDLUtP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 16:49:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbjDLUtO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 16:49:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4022261A1;
        Wed, 12 Apr 2023 13:49:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF79662ED0;
        Wed, 12 Apr 2023 20:49:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2ACF9C433EF;
        Wed, 12 Apr 2023 20:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681332552;
        bh=N6CxG92Ed4Yn5LSSbnRciB027afcs82cjOQu+THWcO0=;
        h=From:Date:Subject:To:Cc:Reply-To:From;
        b=UF5C/YyP9SfpWtDmeWKN+982ajzjj6BoiCHMDIS0cSGCSgo/a56pKaRsfYDIfhhw6
         Yw3Mnhgqz36vi98izKUlyqQCBc4qL92l7qlowAQdig4hk/oWaHJeZP88Ir+hPQRsTg
         f52ijdMe+DrRO51YXq75Ukj07uE92UYBefjbEwOREVEzljhcSJSXqvoS8CdLDTZRnZ
         1gZktu2W99imJqt56DTncCPLs3Wx81qwzIHuySKKQGoHxjmmbsa6Mz3x/ErLnpybl4
         V8NJJW/ByX4xrXa4YUEu5I8XtppiOyhqjYEK4Yp5LIfLYg7/vMu+6W3NyP+Bo78N0e
         C0PJh5/yR8q3A==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.lore.kernel.org (Postfix) with ESMTP id 0E6CAC77B6C;
        Wed, 12 Apr 2023 20:49:12 +0000 (UTC)
From:   Abhijeet Rastogi via B4 Relay 
        <devnull+abhijeet.1989.gmail.com@kernel.org>
Date:   Wed, 12 Apr 2023 13:49:08 -0700
Subject: [PATCH] ipvs: change ip_vs_conn_tab_bits range to [8,31]
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230412-increase_ipvs_conn_tab_bits-v1-1-60a4f9f4c8f2@gmail.com>
X-B4-Tracking: v=1; b=H4sIAEMZN2QC/x2N0QqDMAxFf0XyvEIbZbD9yhglrdnMw6IkIgPx3
 1f3eDiXc3dwNmGHe7eD8SYuszZIlw7qRPrmIGNjwIh9HBIG0WpMzlmWzXOdVfNKJRdZPQw9Yr3
 FkTBdoRVK24VipHU6Gx/yle0Ui/FLvv/bx/M4ftkrbyCGAAAA
To:     Simon Horman <horms@verge.net.au>, Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org,
        Abhijeet Rastogi <abhijeet.1989@gmail.com>
X-Mailer: b4 0.12.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1681332551; l=2681;
 i=abhijeet.1989@gmail.com; s=20230412; h=from:subject:message-id;
 bh=diB2UNBoozij8cEFsyQbJS4LF1vmwJ3a6Chw+mzNh7I=;
 b=P+q2BDiUkpHSIUlanv0uhX+uIFT2uT4OzEwmTdXXla/nmmIrpI/IXDTzgS0FBPJ5E2k2s7yp6
 BTzbnfMaj1vAOe9Em5PMNAMEQLfL4s9XOHYeLIGoyhXO/lySLPcoEuQ
X-Developer-Key: i=abhijeet.1989@gmail.com; a=ed25519;
 pk=VinODWUuJys1VAWZP2Uv9slcHekoZvxAp4RY1p5+OfU=
X-Endpoint-Received: by B4 Relay for abhijeet.1989@gmail.com/20230412 with auth_id=40
X-Original-From: Abhijeet Rastogi <abhijeet.1989@gmail.com>
Reply-To: <abhijeet.1989@gmail.com>
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FORGED_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Abhijeet Rastogi <abhijeet.1989@gmail.com>

Current range [8, 20] is set purely due to historical reasons
because at the time, ~1M (2^20) was considered sufficient.

Previous change regarding this limit is here.

Link: https://lore.kernel.org/all/86eabeb9dd62aebf1e2533926fdd13fed48bab1f.1631289960.git.aclaudi@redhat.com/T/#u

Signed-off-by: Abhijeet Rastogi <abhijeet.1989@gmail.com>
---
The conversation for this started at: 

https://www.spinics.net/lists/netfilter/msg60995.html

The upper limit for algo is any bit size less than 32, so this
change will allow us to set bit size > 20. Today, it is common to have
RAM available to handle greater than 2^20 connections per-host.

Distros like RHEL already have higher limits set.
---
 net/netfilter/ipvs/Kconfig      | 4 ++--
 net/netfilter/ipvs/ip_vs_conn.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/ipvs/Kconfig b/net/netfilter/ipvs/Kconfig
index 271da8447b29..3e3371f8c0f9 100644
--- a/net/netfilter/ipvs/Kconfig
+++ b/net/netfilter/ipvs/Kconfig
@@ -44,7 +44,7 @@ config	IP_VS_DEBUG
 
 config	IP_VS_TAB_BITS
 	int "IPVS connection table size (the Nth power of 2)"
-	range 8 20
+	range 8 31
 	default 12
 	help
 	  The IPVS connection hash table uses the chaining scheme to handle
@@ -54,7 +54,7 @@ config	IP_VS_TAB_BITS
 
 	  Note the table size must be power of 2. The table size will be the
 	  value of 2 to the your input number power. The number to choose is
-	  from 8 to 20, the default number is 12, which means the table size
+	  from 8 to 31, the default number is 12, which means the table size
 	  is 4096. Don't input the number too small, otherwise you will lose
 	  performance on it. You can adapt the table size yourself, according
 	  to your virtual server application. It is good to set the table size
diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index 13534e02346c..bc0fe1a698d4 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -1484,8 +1484,8 @@ int __init ip_vs_conn_init(void)
 	int idx;
 
 	/* Compute size and mask */
-	if (ip_vs_conn_tab_bits < 8 || ip_vs_conn_tab_bits > 20) {
-		pr_info("conn_tab_bits not in [8, 20]. Using default value\n");
+	if (ip_vs_conn_tab_bits < 8 || ip_vs_conn_tab_bits > 31) {
+		pr_info("conn_tab_bits not in [8, 31]. Using default value\n");
 		ip_vs_conn_tab_bits = CONFIG_IP_VS_TAB_BITS;
 	}
 	ip_vs_conn_tab_size = 1 << ip_vs_conn_tab_bits;

---
base-commit: 09a9639e56c01c7a00d6c0ca63f4c7c41abe075d
change-id: 20230412-increase_ipvs_conn_tab_bits-4322c90da216

Best regards,
-- 
Abhijeet Rastogi <abhijeet.1989@gmail.com>

