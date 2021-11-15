Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA39450879
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 16:31:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236521AbhKOPeb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 10:34:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236500AbhKOPe0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 10:34:26 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC440C061202
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 07:31:29 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id e9so36379814ljl.5
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 07:31:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=des7qVRMz1bc3eP/QEMS3RjICNd6OKBTMqZdowxjNLo=;
        b=aN9ZxbNg4Hd4RpgMBeciRPwQqrpLQoCaMvHToNRBBQOn6HHLtZ4kemfKwWfCF+Oixf
         tvSVl3OYK1o+W2NIn/YUrSzGb4Zw6aW5f6Im6HM74tK83D1cC+m3UdjE438vJKhDWssQ
         MboomaGgc7YZh5XBXPieT8i+01bDB5OScoZxwUSTWXp9tsNukeeqqIvukiqQ6lnxZ2ZF
         DBZEDaQ8nGPXT0Jt25W4JlO7JlB7kmBwX5afwPh6TiLDTggcQOKQl0muKOO9KpVguyjd
         XnAjiua2+LCddM1AuI1EwOqT70U0KUtug1ljCNJOeAnU8HXcMZU3zQ4IMTqLKldIisC7
         j1LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=des7qVRMz1bc3eP/QEMS3RjICNd6OKBTMqZdowxjNLo=;
        b=74fY9rwFYm2cJEABZBRnyIdNyTIs7BeIsSH5dCcZBxvcvU9moUTfBLs0KDY5tMYqBW
         WCGdnd6RtTm7Xu9WZwPxM0rlVL28j1NLnQe9HOtB3od1fsv2k56iN2jztbSz4y/Gmafi
         Pc1y34x5lpDKG6cu9wkY30cbZ7UZZUYYsryQbwPlrNTzySv/bCaoa8UdSuvFdFDA4CyY
         dL8q2cche2rlz98rUYPOmQxvBAY7vCHIJtF8N7YOMV91ScyN8qzAan7CT4K7Z/NyBhCK
         z5yHbknX/301FM6d6PYC9YfMy5eeGpE5T+NVloMxCFmP/0qaaEWnEd4KQ+hIEOYRzA4r
         yuig==
X-Gm-Message-State: AOAM531M6Z1quupTHvIiqpCHR8pPT7LwrrsJNUmYTEXvG5Pp7lSak0ty
        1lT8aTfknB7XwveE5mIAkyecElE+zLMIzw==
X-Google-Smtp-Source: ABdhPJxr7ZcVibLcJRIjlDO5EivoD0ORdJ0C9O1Dt3nqLf7sH9Sigc4AXlU+Y8akETeV+IHMRMEzrw==
X-Received: by 2002:a2e:8554:: with SMTP id u20mr40248259ljj.70.1636990288296;
        Mon, 15 Nov 2021 07:31:28 -0800 (PST)
Received: from gilgamesh.lab.semihalf.net ([83.142.187.85])
        by smtp.gmail.com with ESMTPSA id s9sm1458031lfr.304.2021.11.15.07.31.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Nov 2021 07:31:27 -0800 (PST)
From:   Marcin Wojtas <mw@semihalf.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, upstream@semihalf.com,
        Marcin Wojtas <mw@semihalf.com>,
        kernel test robot <lkp@intel.com>
Subject: [net: PATCH] net: mvmdio: fix compilation warning
Date:   Mon, 15 Nov 2021 16:30:24 +0100
Message-Id: <20211115153024.209083-1-mw@semihalf.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The kernel test robot reported a following issue:

>> drivers/net/ethernet/marvell/mvmdio.c:426:36: warning:
unused variable 'orion_mdio_acpi_match' [-Wunused-const-variable]
   static const struct acpi_device_id orion_mdio_acpi_match[] = {
                                      ^
   1 warning generated.

Fix that by surrounding the variable by appropriate ifdef.

Fixes: c54da4c1acb1 ("net: mvmdio: add ACPI support")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Marcin Wojtas <mw@semihalf.com>
---
 drivers/net/ethernet/marvell/mvmdio.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/marvell/mvmdio.c b/drivers/net/ethernet/marvell/mvmdio.c
index 62a97c46fba0..ef878973b859 100644
--- a/drivers/net/ethernet/marvell/mvmdio.c
+++ b/drivers/net/ethernet/marvell/mvmdio.c
@@ -429,12 +429,14 @@ static const struct of_device_id orion_mdio_match[] = {
 };
 MODULE_DEVICE_TABLE(of, orion_mdio_match);
 
+#ifdef CONFIG_ACPI
 static const struct acpi_device_id orion_mdio_acpi_match[] = {
 	{ "MRVL0100", BUS_TYPE_SMI },
 	{ "MRVL0101", BUS_TYPE_XSMI },
 	{ },
 };
 MODULE_DEVICE_TABLE(acpi, orion_mdio_acpi_match);
+#endif
 
 static struct platform_driver orion_mdio_driver = {
 	.probe = orion_mdio_probe,
-- 
2.29.0

