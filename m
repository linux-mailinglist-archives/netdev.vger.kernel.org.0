Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2D91632D7
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 21:17:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbgBRUQ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 15:16:59 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39906 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726811AbgBRUQU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 15:16:20 -0500
Received: by mail-wm1-f68.google.com with SMTP id c84so4322051wme.4;
        Tue, 18 Feb 2020 12:16:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KO1P8TdhCF+ETf7N0G7DCO6PDxSuep8oXUSJME3PY5U=;
        b=rRUEd5Ys244cV+9+fCeybZ3/qRaIGZIc7ZgqLnxKXfVDeSOycb7xNY9gHTVqdy4PxD
         sjiStvp9luDgLGIrPuR5Y8BZk27Bmpl3UXL9DIXo60G1YPQtITRxt7BIDoNQoB22dHqS
         xf9ObloDWjAPR7C2GU9UZj8o+LWZbq/4GuQP3mzaWy0s/jxnVMUlVHTe3W/bZzvMBnXX
         7kvVmPCcjjWP+U+NqhHMAjQcxVs66vXFjJHnUnCKY9Yt1uNWrrK2LusEaUar+Wazcx9k
         v1BK/lgU8oy2Uh5zN6tUfg4hEKSq+0gtXisPxzZpPAgXLOB9YgCQUCSpJjFaYVwtCjvB
         G8CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KO1P8TdhCF+ETf7N0G7DCO6PDxSuep8oXUSJME3PY5U=;
        b=h0IJSaBh2t+MqqqzWU/MWitaQ7qwDdslPSwGHELRQD5eqAC2VFgaQjMhoDFlT+O3C+
         PP0H8e6vKOHge549ZSeS2zr45q/yH5K0eMaCCAC/J+oU9qdpp/CMT0jZiN3YVNUezBJ5
         fQEPDuEjGlrYEO6bdcfw9JaBxEYVm7JXFgAqSHAGZdmAFMoenRkaRVqHS1TYY24elaCj
         fhtBazmn/cwa11AhxFmezyhst5Z84eoe60enwNE1s5Z/Lm3PPKREPxODMYeTCsUH88P8
         B7dbLtoS1WP+RDgJWh02NF2rWInss/Enxr6vQrvDD1KGCUSdS5vtzspuyeuVzY5Ic24t
         oE9w==
X-Gm-Message-State: APjAAAUgNUJjCRikZXU8gMEZYz++dtFNIshWaIDHzfX0B0ArGmiZ5Vtd
        sU8tNmIpRK/duxXvLm/xEOOBbAw0
X-Google-Smtp-Source: APXvYqxFvQJshXF+hlst3EZZ7WhubwUoRajwaHk+PuguQm/0lfFRnmjnP3Y7G2aeGeyOP/0tRzQHvw==
X-Received: by 2002:a05:600c:10d2:: with SMTP id l18mr4855422wmd.122.1582056978481;
        Tue, 18 Feb 2020 12:16:18 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:5cb0:582f:968:ec00? (p200300EA8F2960005CB0582F0968EC00.dip0.t-ipconnect.de. [2003:ea:8f29:6000:5cb0:582f:968:ec00])
        by smtp.googlemail.com with ESMTPSA id p5sm7485636wrt.79.2020.02.18.12.16.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2020 12:16:18 -0800 (PST)
Subject: [PATCH net-next v2 10/13] net: socionext: use new helper
 tcp_v6_gso_csum_prep
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     David Miller <davem@davemloft.net>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <fffc8b6d-68ed-7501-18f1-94cf548821fb@gmail.com>
Message-ID: <6f02ce1c-aef7-6127-1724-72f7eee56810@gmail.com>
Date:   Tue, 18 Feb 2020 21:09:17 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <fffc8b6d-68ed-7501-18f1-94cf548821fb@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use new helper tcp_v6_gso_csum_prep in additional network drivers.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/socionext/netsec.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index e8224b543..6266926fe 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -1148,11 +1148,7 @@ static netdev_tx_t netsec_netdev_start_xmit(struct sk_buff *skb,
 				~tcp_v4_check(0, ip_hdr(skb)->saddr,
 					      ip_hdr(skb)->daddr, 0);
 		} else {
-			ipv6_hdr(skb)->payload_len = 0;
-			tcp_hdr(skb)->check =
-				~csum_ipv6_magic(&ipv6_hdr(skb)->saddr,
-						 &ipv6_hdr(skb)->daddr,
-						 0, IPPROTO_TCP, 0);
+			tcp_v6_gso_csum_prep(skb);
 		}
 
 		tx_ctrl.tcp_seg_offload_flag = true;
-- 
2.25.1


