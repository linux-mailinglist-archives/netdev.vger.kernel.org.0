Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 926EB3A4F4F
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 16:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231520AbhFLOk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Jun 2021 10:40:58 -0400
Received: from mail-il1-f176.google.com ([209.85.166.176]:45681 "EHLO
        mail-il1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231314AbhFLOk4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Jun 2021 10:40:56 -0400
Received: by mail-il1-f176.google.com with SMTP id b5so8128880ilc.12
        for <netdev@vger.kernel.org>; Sat, 12 Jun 2021 07:38:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RoTW6JTlZnNd0l9BUF/eHwMYa4PJcYiPHlW2YFHC00U=;
        b=ll5Kwoii5v9IfxRGoOoezv9Cic/5ZupbSWJpSuJIdPv+MJtvXr3x/LeBFigQCJxHwg
         L3MePC8AAA35Y7ThNUcU4L1JEAo2iYrgHdsYd12sWNews8WtMYokBT5vqNf7T34vAl+J
         jT5j9QJ6u8oiOEgPerth7vmDQvNnr/0u+Avo59oLdauos/lFDv4LLlKSclwh6N/60+fm
         /shgX7jj5Db1AKPovKFL1PGhexMahw1C4ONE2XYj3Hs1t1MwtZX8RRxoEWf0qyRube9I
         ZeHDfH4tXpljVXDZJMYhgnZOYolUSkya8z3vGDtNfGfyiA66g7fDENN4Gz2Yh1lpBLNh
         gyuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RoTW6JTlZnNd0l9BUF/eHwMYa4PJcYiPHlW2YFHC00U=;
        b=Cb+qJo0QA8u2UgGx/ChxxtpBDSJxorIx1hp7OaeKcnmN7C/ZCQLJm7UtYMrdJqehVV
         pjksnST3KzX3PYm2OwGSh3dwvsJxZJLIKL0zEF/2SunPqyyeVX0CiG6+ex4dsuMVpSwu
         W0BNckChNDbrKAxZ/eyK+iohFK7LP8NtEJXfZcXDMBb9Hh1mu+bahbzlNl5ojGZ1OChe
         qd3Bp7swYHZAkjevtPqlT1RlLK1fYCXjJJlHsv4mik05S7bhUakQ+CXxPsTFpoNAlm2I
         jB/Q0ogRqEa4VMA6tY0JvY0nf7LJaihugnFYlL4l4qKGyitH/Gdx3Ydrh61zL4/M7UDq
         Xj4g==
X-Gm-Message-State: AOAM532goNZHsWzMwCadGPARcL5yDk1Fsc5llS3NVGfY6WYgLm3Nk9ma
        M6dXAnOKWf+uqYuZx/qEB7LmDA==
X-Google-Smtp-Source: ABdhPJyXgPWx0r1IZ08U4nolcSUN2OrwcR0KCTL0wIQeEK8MvcTu7k6cKwMf08jNICON4auukPYMXA==
X-Received: by 2002:a92:4446:: with SMTP id a6mr7348379ilm.9.1623508660514;
        Sat, 12 Jun 2021 07:37:40 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id k4sm5126559ior.55.2021.06.12.07.37.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Jun 2021 07:37:40 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     subashab@codeaurora.org, stranche@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/8] net: qualcomm: rmnet: remove some local variables
Date:   Sat, 12 Jun 2021 09:37:29 -0500
Message-Id: <20210612143736.3498712-2-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210612143736.3498712-1-elder@linaro.org>
References: <20210612143736.3498712-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In rmnet_map_ipv4_dl_csum_trailer(), remove the "csum_temp" and
"addend" local variables, and simplify a few lines of code.

Remove the "csum_temp", "csum_value", "ip6_hdr_csum", and "addend"
local variables in rmnet_map_ipv6_dl_csum_trailer(), and simplify a
few lines of code there as well.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 .../ethernet/qualcomm/rmnet/rmnet_map_data.c  | 37 +++++++------------
 1 file changed, 13 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
index d4d23ab446ef5..3e6feef0fd252 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
@@ -35,10 +35,9 @@ rmnet_map_ipv4_dl_csum_trailer(struct sk_buff *skb,
 {
 	struct iphdr *ip4h = (struct iphdr *)skb->data;
 	void *txporthdr = skb->data + ip4h->ihl * 4;
-	__sum16 *csum_field, csum_temp, pseudo_csum;
+	__sum16 *csum_field, pseudo_csum;
 	__sum16 ip_payload_csum;
-	u16 csum_value_final;
-	__be16 addend;
+	__sum16 csum_value_final;
 
 	/* Computing the checksum over just the IPv4 header--including its
 	 * checksum field--should yield 0.  If it doesn't, the IP header
@@ -83,14 +82,11 @@ rmnet_map_ipv4_dl_csum_trailer(struct sk_buff *skb,
 	pseudo_csum = ~csum_tcpudp_magic(ip4h->saddr, ip4h->daddr,
 					 ntohs(ip4h->tot_len) - ip4h->ihl * 4,
 					 ip4h->protocol, 0);
-	addend = (__force __be16)pseudo_csum;
-	pseudo_csum = csum16_add(ip_payload_csum, addend);
+	pseudo_csum = csum16_add(ip_payload_csum, (__force __be16)pseudo_csum);
 
-	addend = (__force __be16)*csum_field;
-	csum_temp = ~csum16_sub(pseudo_csum, addend);
-	csum_value_final = (__force u16)csum_temp;
+	csum_value_final = ~csum16_sub(pseudo_csum, (__force __be16)*csum_field);
 
-	if (unlikely(csum_value_final == 0)) {
+	if (unlikely(!csum_value_final)) {
 		switch (ip4h->protocol) {
 		case IPPROTO_UDP:
 			/* RFC 768 - DL4 1's complement rule for UDP csum 0 */
@@ -105,7 +101,7 @@ rmnet_map_ipv4_dl_csum_trailer(struct sk_buff *skb,
 		}
 	}
 
-	if (csum_value_final == (__force u16)*csum_field) {
+	if (csum_value_final == *csum_field) {
 		priv->stats.csum_ok++;
 		return 0;
 	} else {
@@ -122,12 +118,10 @@ rmnet_map_ipv6_dl_csum_trailer(struct sk_buff *skb,
 {
 	struct ipv6hdr *ip6h = (struct ipv6hdr *)skb->data;
 	void *txporthdr = skb->data + sizeof(*ip6h);
-	__sum16 *csum_field, pseudo_csum, csum_temp;
-	__be16 ip6_hdr_csum, addend;
+	__sum16 *csum_field, pseudo_csum;
 	__sum16 ip6_payload_csum;
 	__be16 ip_header_csum;
-	u16 csum_value_final;
-	__be16 csum_value;
+	__sum16 csum_value_final;
 	u32 length;
 
 	/* Checksum offload is only supported for UDP and TCP protocols;
@@ -145,23 +139,18 @@ rmnet_map_ipv6_dl_csum_trailer(struct sk_buff *skb,
 	 * of the IP header from the trailer checksum.  We then add the
 	 * checksum computed over the pseudo header.
 	 */
-	csum_value = ~csum_trailer->csum_value;
 	ip_header_csum = (__force __be16)ip_fast_csum(ip6h, sizeof(*ip6h) / 4);
-	ip6_hdr_csum = (__force __be16)~ip_header_csum;
-	ip6_payload_csum = csum16_sub((__force __sum16)csum_value,
-				      ip6_hdr_csum);
+	ip6_payload_csum = csum16_sub((__force __sum16)~csum_trailer->csum_value,
+				      ~ip_header_csum);
 
 	length = (ip6h->nexthdr == IPPROTO_UDP) ?
 		 ntohs(((struct udphdr *)txporthdr)->len) :
 		 ntohs(ip6h->payload_len);
 	pseudo_csum = ~csum_ipv6_magic(&ip6h->saddr, &ip6h->daddr,
 				       length, ip6h->nexthdr, 0);
-	addend = (__force __be16)pseudo_csum;
-	pseudo_csum = csum16_add(ip6_payload_csum, addend);
+	pseudo_csum = csum16_add(ip6_payload_csum, (__force __be16)pseudo_csum);
 
-	addend = (__force __be16)*csum_field;
-	csum_temp = ~csum16_sub(pseudo_csum, addend);
-	csum_value_final = (__force u16)csum_temp;
+	csum_value_final = ~csum16_sub(pseudo_csum, (__force __be16)*csum_field);
 
 	if (unlikely(csum_value_final == 0)) {
 		switch (ip6h->nexthdr) {
@@ -180,7 +169,7 @@ rmnet_map_ipv6_dl_csum_trailer(struct sk_buff *skb,
 		}
 	}
 
-	if (csum_value_final == (__force u16)*csum_field) {
+	if (csum_value_final == *csum_field) {
 		priv->stats.csum_ok++;
 		return 0;
 	} else {
-- 
2.27.0

