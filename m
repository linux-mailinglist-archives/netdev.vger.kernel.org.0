Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76080160065
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 21:10:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727720AbgBOUK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 15:10:57 -0500
Received: from mail-lf1-f65.google.com ([209.85.167.65]:41350 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726273AbgBOUK4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Feb 2020 15:10:56 -0500
Received: by mail-lf1-f65.google.com with SMTP id m30so9077768lfp.8
        for <netdev@vger.kernel.org>; Sat, 15 Feb 2020 12:10:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:references:organization:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5JzMAcehIW0t8vOej7xQ3xrVv74ciyUM2eWJe6uWF9E=;
        b=zH6T2ujxqo/0Zi0j0Dyr2EvPKt24cwn1mbuAh+RT0neLM2Vexcg7Rmje84LdAh7qfg
         yXcnN3hklG4pfaVA3xU8PeazrqMwbDVEpaqhxJQH4huoYQXyCngti2b1fvwzQq5xNmbN
         /ZfUlFPC0z/7wGeBiiDGjzNQ8XAfCiFf6T9EaQ99Kkb9NdSWJ2KEsopwMsZukDLv7+zO
         OW84t7vzyEp4SMhyUV3ZDy9H+/UTfshpVFldGHwHeVrKACwExhcnWn93mc1+tlE+k1zB
         vnxeKHDtTT4Eo6m1L6j5/JCjrEcWCYNqeZ6xdHftW5zKp8nZNGx1luidVtwXmG9E55TV
         tREg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=5JzMAcehIW0t8vOej7xQ3xrVv74ciyUM2eWJe6uWF9E=;
        b=Kpn/ZP2surn27L0OE+Ip5dUPW54aC26sEf7TRIyF3n94tjZv/1CFdYIR4y991tLwvw
         XuVA1SBn7m4TVY5VCDuoaRQaSCgfyHVxmLjtwcjkj/Q3lnY100hHHidBzDK1u07EmFef
         DeLPY3xLOQeh7vNyTN4/0ZR8bNvmC/h6XFklLBt3W6BgS+l6g1RWq2/pUooa5BvB8FzT
         UX2FiTG1l64tfnB9bBmJY8oPrvOpmuuSfDGPu1wH033sHOK/PRQqThvg0coZV2bxBSt6
         qJMD+uWZLmq1y9sZ5/+JeLN1D3csTtKNemwmbCgWsyN8V3GhRM9zQqsB+RfoLAHPuUlb
         4BXQ==
X-Gm-Message-State: APjAAAVtJ0xielqmek24hCECVBuQXemL9nv96Iy8sZ7rNAsxa5PPJA0z
        HGKFao2cULkYInaes6XvfC6QYi80jNw=
X-Google-Smtp-Source: APXvYqycDEfqCi1zZ721tz1gV3OlWsRLUixG71UjcIXTbfXrlqxA9ZtGSeYVCvAReEUAbjEsennV6Q==
X-Received: by 2002:a19:3f16:: with SMTP id m22mr4607800lfa.116.1581797454736;
        Sat, 15 Feb 2020 12:10:54 -0800 (PST)
Received: from wasted.cogentembedded.com ([2a00:1fa0:49d:f851:9745:99c9:a1aa:2f9c])
        by smtp.gmail.com with ESMTPSA id x18sm4772988lfe.37.2020.02.15.12.10.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 15 Feb 2020 12:10:54 -0800 (PST)
Subject: [PATCH net-next v2 3/5] sh_eth: check sh_eth_cpu_data::no_xdfar when
 dumping registers
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
To:     "David S. Miller" <davem@davemloft.net>,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
References: <effa9dea-638b-aa29-2ec3-942974de12a0@cogentembedded.com>
Organization: Cogent Embedded
Message-ID: <d267d4f2-58b1-e55f-bbbf-cf82535aee0b@cogentembedded.com>
Date:   Sat, 15 Feb 2020 23:10:53 +0300
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

When adding the sh_eth_cpu_data::no_xdfar flag I forgot to add the flag
check to  __sh_eth_get_regs(), causing the non-existing RDFAR/TDFAR to be
considered for dumping on the R-Car gen1/2 SoCs (the register offset check
has the final say here)...

Fixes: 4c1d45850d5 ("sh_eth: add sh_eth_cpu_data::cexcr flag")
Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Tested-by: Chris Brandt <chris.brandt@renesas.com>

---
Changes in version 2:
- added Chris' tag.

 drivers/net/ethernet/renesas/sh_eth.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: net-next/drivers/net/ethernet/renesas/sh_eth.c
===================================================================
--- net-next.orig/drivers/net/ethernet/renesas/sh_eth.c
+++ net-next/drivers/net/ethernet/renesas/sh_eth.c
@@ -2140,11 +2140,13 @@ static size_t __sh_eth_get_regs(struct n
 	add_reg(EESR);
 	add_reg(EESIPR);
 	add_reg(TDLAR);
-	add_reg(TDFAR);
+	if (!cd->no_xdfar)
+		add_reg(TDFAR);
 	add_reg(TDFXR);
 	add_reg(TDFFR);
 	add_reg(RDLAR);
-	add_reg(RDFAR);
+	if (!cd->no_xdfar)
+		add_reg(RDFAR);
 	add_reg(RDFXR);
 	add_reg(RDFFR);
 	add_reg(TRSCER);
