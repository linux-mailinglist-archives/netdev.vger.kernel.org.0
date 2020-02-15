Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4A716005D
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 21:08:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbgBOUIZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 15:08:25 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:40852 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726254AbgBOUIZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Feb 2020 15:08:25 -0500
Received: by mail-lf1-f67.google.com with SMTP id c23so9094841lfi.7
        for <netdev@vger.kernel.org>; Sat, 15 Feb 2020 12:08:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:references:organization:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Y6Syhw75DrL/16mAWZKPGflpkoRvzzkNCkSXFPlmCNs=;
        b=rrY8u+9Frg69lzoWFdHxPGeU2h+jaAZsO+XklwtINHXTEM3fmjhMnKJ0Qi5ouo9PvL
         d47dvCkzy3FFZqtgKdvPcEwEbgUYSotrK6rXGtezu5NiGTCUsNS2Hcd8V/MHYAAw/kdk
         fahYQrxk9v2vrVawZatXj3cj+MKuRu3p3lyolusjKalW6BHAuxu44R7x33g+37Fq/t1L
         aYphiy6UbBDeIrSjCotARJBLQRXAnLZEWXU7GnLXCJ1rDA/t1BQ3iI/RuMSxlAEXysUi
         Eg9v51h0cqquuZJk2nkWcgmg0I9Mm/kUkQS/kxztxpyvNqRmY2pdQYHBQJ+AkRbmmagW
         4V4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Y6Syhw75DrL/16mAWZKPGflpkoRvzzkNCkSXFPlmCNs=;
        b=sJkkCIVLO0tNhYWxiRMTjCazeSoVABjAXGZuyo6R+1KXnupprE2pZ4Kw3iX5ZvkQeL
         7fhBes0cKlPovor3Ud6ejucrNlMmkddfc+67JEDeFZiVZfEXZn0qOX35aq+NgWsR6giL
         S5UZ5HSF1j1rAUATSb55ErL9lODXZs6nsd7qtmioIviQjq41JvuLjSuBL+7NFESugFi3
         TUSe2SDV9To0LspPcEa+QGc8mD0e1GGzZQm1SnmnPeBFeU61VBLsHxQ0wCfke762xhFg
         vgYjfK6z1h/6Ph2G8seDdtfx729PZqnFuG714OyXYnXOcVg7iLrJdfSbbKyXai7ZLtfi
         aRWA==
X-Gm-Message-State: APjAAAUyhZHWj8UU5uOWk5ly9Wq+Ta/ufHPk/Qix9GDId/x3d+Xy0yzt
        Pb5d/vJPmoV34uqxtXypCZ7Rod+dwP4=
X-Google-Smtp-Source: APXvYqwGKQqCwZBZ0tGmI0lv4dS9Xjx/PnxrwASG5U85v8SnuwyNWY2IXacu5lNza5eOzmz2a80fCQ==
X-Received: by 2002:a19:dc1e:: with SMTP id t30mr4487922lfg.34.1581797302698;
        Sat, 15 Feb 2020 12:08:22 -0800 (PST)
Received: from wasted.cogentembedded.com ([2a00:1fa0:49d:f851:9745:99c9:a1aa:2f9c])
        by smtp.gmail.com with ESMTPSA id u16sm5506417ljo.22.2020.02.15.12.08.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 15 Feb 2020 12:08:22 -0800 (PST)
Subject: [PATCH net-next v2 1/5] sh_eth: check sh_eth_cpu_data::no_tx_cntrs
 when dumping registers
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
To:     "David S. Miller" <davem@davemloft.net>,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org
References: <effa9dea-638b-aa29-2ec3-942974de12a0@cogentembedded.com>
Organization: Cogent Embedded
Message-ID: <495ef7e8-43e4-9cda-b0a5-5fbec4a5668e@cogentembedded.com>
Date:   Sat, 15 Feb 2020 23:08:20 +0300
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

When adding the sh_eth_cpu_data::no_tx_cntrs flag I forgot to add the
flag check to  __sh_eth_get_regs(), causing the non-existing TX counter
registers to be considered for dumping on the R7S72100 SoC (the register
offset sanity check has the final say here)...

Fixes: ce9134dff6d9 ("sh_eth: add sh_eth_cpu_data::no_tx_cntrs flag")
Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Tested-by: Chris Brandt <chris.brandt@renesas.com>

---
Changes in version 2:
- added Chris' tag.

 drivers/net/ethernet/renesas/sh_eth.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

Index: net-next/drivers/net/ethernet/renesas/sh_eth.c
===================================================================
--- net-next.orig/drivers/net/ethernet/renesas/sh_eth.c
+++ net-next/drivers/net/ethernet/renesas/sh_eth.c
@@ -2184,10 +2184,12 @@ static size_t __sh_eth_get_regs(struct n
 		add_reg(BCULR);
 	add_reg(MAHR);
 	add_reg(MALR);
-	add_reg(TROCR);
-	add_reg(CDCR);
-	add_reg(LCCR);
-	add_reg(CNDCR);
+	if (!cd->no_tx_cntrs) {
+		add_reg(TROCR);
+		add_reg(CDCR);
+		add_reg(LCCR);
+		add_reg(CNDCR);
+	}
 	add_reg(CEFCR);
 	add_reg(FRECR);
 	add_reg(TSFRCR);
