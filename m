Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2F3160069
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 21:13:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbgBOUNv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 15:13:51 -0500
Received: from mail-lj1-f175.google.com ([209.85.208.175]:33980 "EHLO
        mail-lj1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726273AbgBOUNv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Feb 2020 15:13:51 -0500
Received: by mail-lj1-f175.google.com with SMTP id x7so14455459ljc.1
        for <netdev@vger.kernel.org>; Sat, 15 Feb 2020 12:13:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:references:organization:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vA7Kqm1XaQFtm6icVqmb88lhToAgHCoQdr47+e6FfV4=;
        b=SSuro70st7A2cuRA/MPHKOUJ4LDptsbMO2XoyHuRqVyxr1S4uFlZgzFBPP5MPyAUO/
         QR9E9h6RT4vAG9T9gz2d1597LlQn79Trhz5d2ptS5+QXsylb/+0q+bDRULGP2IdQksuM
         UfDZBMck5rT4boDZNThUdbPeOSQkbcD/Hh8rVdoVa7mnnUgu07SnIvO4P35XgzNtDTwr
         xa5uJVTtey8hva/TPsIC1kO9Y/PHIc+m76bW3Jk+7BbX7KhUgpODVTcjK/S/hR6lc9Xe
         7OfmWgs/JknAH5Q+IjkuJmQqJnEdDYUc9gjnXSIERTgU2AfnyAUiQHeiEtP78oa3Co9x
         ZCeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=vA7Kqm1XaQFtm6icVqmb88lhToAgHCoQdr47+e6FfV4=;
        b=sEg6jfAULqckildQNy8JwzYZj1Y4Tt9UzrD3sp2rqXm/q1IASZ8HKu9HhkwoFYhOHW
         +nrxen3E5YgqDa1wMcHek2CZQmFBcK2q2ZlUrftQ87AWN+rvPKwuxOE4uuuPcLwNPcVa
         ByZyXXjzq2e/sg57VpNyp0SIXAhoR/fY3L2NQnATFDsDKlUXE1R0DEe1Lwe5EZqrZB63
         c6fKxySpdrznIJWki3iUUAu1XqntBO74x4FKf8ru0Ng+Ag/eZdOykRMRuUqkk68sEw6v
         TI9vod6wgpGDEyIhHxFOJQxZwdl28AaCdloN5kEH3Qzv8SwDkB5skXIwfv8JpUgeomX0
         pjMA==
X-Gm-Message-State: APjAAAWWylsQRFQR3Ed38byxnu1BQUT6c73xj5Md7+K93g536gK29VZP
        4z6P4ZQRG7YXoT9MEQ5kuy3cxZUNWWo=
X-Google-Smtp-Source: APXvYqzP3/p9CU/3XLQIruKJMjj99oWYKV+E7Tq/JegZwOOyC8ZO2u111on29P/GCF8Vdi+0s2vljg==
X-Received: by 2002:a2e:a361:: with SMTP id i1mr5477298ljn.29.1581797628404;
        Sat, 15 Feb 2020 12:13:48 -0800 (PST)
Received: from wasted.cogentembedded.com ([2a00:1fa0:49d:f851:9745:99c9:a1aa:2f9c])
        by smtp.gmail.com with ESMTPSA id m15sm5739984ljg.4.2020.02.15.12.13.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 15 Feb 2020 12:13:47 -0800 (PST)
Subject: [PATCH net-next v2 4/5] sh_eth: add sh_eth_cpu_data::gecmr flag
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
To:     "David S. Miller" <davem@davemloft.net>,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
References: <effa9dea-638b-aa29-2ec3-942974de12a0@cogentembedded.com>
Organization: Cogent Embedded
Message-ID: <6849ccc1-12aa-c4b5-e977-93951edadbfe@cogentembedded.com>
Date:   Sat, 15 Feb 2020 23:13:45 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <effa9dea-638b-aa29-2ec3-942974de12a0@cogentembedded.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Not all Ether controllers having the Gigabit register layout have GECMR --
RZ/A1 (AKA R7S72100) actually has the same layout but no Gigabit speed
support and hence no GECMR. In the past, the new register map table was
added for this SoC, now I think we should have used the existing Gigabit
table with the differences (such as GECMR) covered by the mere flags in
the 'struct sh_eth_cpu_data'. Add such flag for GECMR -- and then we can
get rid of the R7S72100 specific layout in the next patch...

Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Tested-by: Chris Brandt <chris.brandt@renesas.com>

---
Changes in version 2:
- added Chris' tag.

 drivers/net/ethernet/renesas/sh_eth.c |   14 +++++++++++++-
 drivers/net/ethernet/renesas/sh_eth.h |    1 +
 2 files changed, 14 insertions(+), 1 deletion(-)

Index: net-next/drivers/net/ethernet/renesas/sh_eth.c
===================================================================
--- net-next.orig/drivers/net/ethernet/renesas/sh_eth.c
+++ net-next/drivers/net/ethernet/renesas/sh_eth.c
@@ -569,6 +569,9 @@ static void sh_eth_set_rate_gether(struc
 {
 	struct sh_eth_private *mdp = netdev_priv(ndev);
 
+	if (WARN_ON(!mdp->cd->gecmr))
+		return;
+
 	switch (mdp->speed) {
 	case 10: /* 10BASE */
 		sh_eth_write(ndev, GECMR_10, GECMR);
@@ -663,6 +666,7 @@ static struct sh_eth_cpu_data r8a7740_da
 	.apr		= 1,
 	.mpr		= 1,
 	.tpauser	= 1,
+	.gecmr		= 1,
 	.bculr		= 1,
 	.hw_swap	= 1,
 	.rpadir		= 1,
@@ -788,6 +792,7 @@ static struct sh_eth_cpu_data r8a77980_d
 	.apr		= 1,
 	.mpr		= 1,
 	.tpauser	= 1,
+	.gecmr		= 1,
 	.bculr		= 1,
 	.hw_swap	= 1,
 	.nbst		= 1,
@@ -957,6 +962,9 @@ static void sh_eth_set_rate_giga(struct
 {
 	struct sh_eth_private *mdp = netdev_priv(ndev);
 
+	if (WARN_ON(!mdp->cd->gecmr))
+		return;
+
 	switch (mdp->speed) {
 	case 10: /* 10BASE */
 		sh_eth_write(ndev, 0x00000000, GECMR);
@@ -1002,6 +1010,7 @@ static struct sh_eth_cpu_data sh7757_dat
 	.apr		= 1,
 	.mpr		= 1,
 	.tpauser	= 1,
+	.gecmr		= 1,
 	.bculr		= 1,
 	.hw_swap	= 1,
 	.rpadir		= 1,
@@ -1042,6 +1051,7 @@ static struct sh_eth_cpu_data sh7734_dat
 	.apr		= 1,
 	.mpr		= 1,
 	.tpauser	= 1,
+	.gecmr		= 1,
 	.bculr		= 1,
 	.hw_swap	= 1,
 	.no_trimd	= 1,
@@ -1083,6 +1093,7 @@ static struct sh_eth_cpu_data sh7763_dat
 	.apr		= 1,
 	.mpr		= 1,
 	.tpauser	= 1,
+	.gecmr		= 1,
 	.bculr		= 1,
 	.hw_swap	= 1,
 	.no_trimd	= 1,
@@ -2181,7 +2192,8 @@ static size_t __sh_eth_get_regs(struct n
 	if (cd->tpauser)
 		add_reg(TPAUSER);
 	add_reg(TPAUSECR);
-	add_reg(GECMR);
+	if (cd->gecmr)
+		add_reg(GECMR);
 	if (cd->bculr)
 		add_reg(BCULR);
 	add_reg(MAHR);
Index: net-next/drivers/net/ethernet/renesas/sh_eth.h
===================================================================
--- net-next.orig/drivers/net/ethernet/renesas/sh_eth.h
+++ net-next/drivers/net/ethernet/renesas/sh_eth.h
@@ -490,6 +490,7 @@ struct sh_eth_cpu_data {
 	unsigned apr:1;		/* EtherC has APR */
 	unsigned mpr:1;		/* EtherC has MPR */
 	unsigned tpauser:1;	/* EtherC has TPAUSER */
+	unsigned gecmr:1;	/* EtherC has GECMR */
 	unsigned bculr:1;	/* EtherC has BCULR */
 	unsigned tsu:1;		/* EtherC has TSU */
 	unsigned hw_swap:1;	/* E-DMAC has DE bit in EDMR */
