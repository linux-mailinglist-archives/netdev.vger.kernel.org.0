Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 569D2160064
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 21:09:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727705AbgBOUJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 15:09:40 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:34442 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726273AbgBOUJk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Feb 2020 15:09:40 -0500
Received: by mail-lj1-f196.google.com with SMTP id x7so14449159ljc.1
        for <netdev@vger.kernel.org>; Sat, 15 Feb 2020 12:09:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:references:organization:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qpX9ISWHkFz309IXO/pHmDobf1VYnv7TZgYLqKmvfb8=;
        b=U2q2vERZSDysh5V7hiSxxCh5uVVST41IFhM+4rZTGyvEJxM9Fw4/IgEOMa50LuV5Tv
         AujzE687myiUrd5t6LR0w3Gj6r4VkrRP/v5BgHg+0BsEb7ecWuzYNKeoPpfP0Hl2G230
         AYUjjAGeGYVt7DWQvjf2WRRTnx2k88Po2cpBexrTFh9wTkorusD2sLUU996r6Fnekgl2
         d4MW5YOUX/aw31Dze+dYRXTsSiGfW9gp7/0mFFWSJ3ONB1EqKu9r1hmWlT5dKnXy6sfj
         U3n5eYdGcN5c1v0jJ/edoMduHQ+JwOUX/Xk4bboMG9HPGrCRkFm274tvhhvsVicxJRGs
         nzcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=qpX9ISWHkFz309IXO/pHmDobf1VYnv7TZgYLqKmvfb8=;
        b=PHFGUQ9M7JJTUX25kak/Vi1mBhoKk49LgOASY1k7AQTw/wN64UzJrN35mpgpQoGsgd
         92o6ZQ+4PGxT8Hr1HIPYVzUtFE8oPMmAcNpajxEsZBpkmlFwBF57bjZCSY+/DKylDrdQ
         KKt/9i5pMBz6QnzIrx+qATWQpOBP5/wanbrHnAEU8nqydu/HBVRbwROTs4fO8na6IP+c
         lTaWJhMLCkNREBF00y4GHDOcad67U2Q2ZorD0+YeiwFugUZqPSe1ivUhM4nEifALHBKh
         w7TmSEy8MM0d+VbH+LlQEXFQMrrHg2SfoInS6J4YTD0gcB7q6OaosHaDwWEbKBJGJ7FU
         OXnw==
X-Gm-Message-State: APjAAAUEr2w18Z1llHnqC7+6okqt6Jty6202IZEDDwmDptxA3FLw4+zC
        ftZXTCwBRUMcUE3Cj/9SWpS9Q66/rtc=
X-Google-Smtp-Source: APXvYqzHwkrRU13DQqLL2wXx9dr+nlAHSaCZK6QIA6osFHRgzGGN2qPs7FkyWBAIYGVHhqCgOe5JUQ==
X-Received: by 2002:a2e:b4f6:: with SMTP id s22mr5250018ljm.218.1581797376582;
        Sat, 15 Feb 2020 12:09:36 -0800 (PST)
Received: from wasted.cogentembedded.com ([2a00:1fa0:49d:f851:9745:99c9:a1aa:2f9c])
        by smtp.gmail.com with ESMTPSA id v13sm4835581lfq.69.2020.02.15.12.09.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 15 Feb 2020 12:09:36 -0800 (PST)
Subject: [PATCH net-next v2 2/5] sh_eth: check sh_eth_cpu_data::cexcr when
 dumping registers
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
To:     "David S. Miller" <davem@davemloft.net>,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
References: <effa9dea-638b-aa29-2ec3-942974de12a0@cogentembedded.com>
Organization: Cogent Embedded
Message-ID: <6614e21b-228b-9ad0-0f41-f3b14153b7e6@cogentembedded.com>
Date:   Sat, 15 Feb 2020 23:09:35 +0300
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

When adding the sh_eth_cpu_data::cexcr flag I forgot to add the flag
check to  __sh_eth_get_regs(), causing the non-existing RX packet counter
registers to be considered for dumping on  the R7S72100 SoC (the register
offset sanity check has the final say here)...

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
@@ -2194,8 +2194,10 @@ static size_t __sh_eth_get_regs(struct n
 	add_reg(FRECR);
 	add_reg(TSFRCR);
 	add_reg(TLFRCR);
-	add_reg(CERCR);
-	add_reg(CEECR);
+	if (cd->cexcr) {
+		add_reg(CERCR);
+		add_reg(CEECR);
+	}
 	add_reg(MAFCR);
 	if (cd->rtrate)
 		add_reg(RTRATE);
