Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A196517CA19
	for <lists+netdev@lfdr.de>; Sat,  7 Mar 2020 02:05:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbgCGBEb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 20:04:31 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:52587 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726892AbgCGBEX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Mar 2020 20:04:23 -0500
Received: by mail-pj1-f67.google.com with SMTP id lt1so1764334pjb.2
        for <netdev@vger.kernel.org>; Fri, 06 Mar 2020 17:04:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=UDCCqqbOFCeRU+4k7aYMxmRsVqZz8gcsCbapPm06bfg=;
        b=rExHgF1Fsy3f3msf/8kHmwtwAdHDui+PcRSGBTU3Dyp2TqaopQXHGoEM8yZuXtdfF3
         LQbuJlYRwWBqh9OqsQq2/rwUDJ4VtkvaeZmoGV4EnDjHCm7875IpSAKj4W3K2Laea5kj
         WLzYKPjzjTss1YKt4VrAX1E8P9JavOq4wWH7KNtibOBaU4uAQbrH7zRewCEvdTlWltVC
         3R5xyymxzds8+fTTX8TPS/QgXw3UOYZ5BmzQRjmcB0SqukCPgFbDV5sxZGAPNSA6nQxw
         vFe0r8paxNHKDX8B9NYzJZRmMHjFxlypi2TPSdDcDZvUe9UubfSPgNqXC609MeXOYTVC
         i2lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=UDCCqqbOFCeRU+4k7aYMxmRsVqZz8gcsCbapPm06bfg=;
        b=MkQIdnNN+UIXvOn0zS9+Du5/XhmqM+TgWa4gKr78hRDxRg6U/BQAr+r4sGscXaSwiw
         laMwepocdrOtmfhIg4JtIgRokrqXKMUv1zr+q2gUolEapqxH7fAzRGPTXLIuK/XzKaQG
         aV1EjCbij321jxD/S86L6jkOzCxgxZbC1oo3tPdXGFdstrsvMW+tXDoUL4/7myv7EGK5
         xQH9ewALcMYTT2S9RENvFxgfju4Xbn3kieA27x0uyAxmxU3Naqb4xxMXMH3DzPqEC6/W
         El6eyMbn7eq2SrZrQ7jjH4oy8nsveQUjQXW6gzczveSB82ygZLMkNX6ohLb+Y4gZADfw
         fMHw==
X-Gm-Message-State: ANhLgQ32Glx+S4mvBL+FUZrf/2S8ddNWe8UUiUb2WAOacvcfcgQrmYea
        XdJdkHt4vSW3CK+stup0o73o0nqikRo=
X-Google-Smtp-Source: ADFU+vtx2DLpWIXNrvvPwqjaEnkOfT9xamcrGF2QL0PrLArHA1lA8Zamcwv7t1eJJEbmj0bs9sm/rA==
X-Received: by 2002:a17:90a:2308:: with SMTP id f8mr6521931pje.108.1583543062799;
        Fri, 06 Mar 2020 17:04:22 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id o66sm23224949pfb.93.2020.03.06.17.04.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Mar 2020 17:04:22 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v4 net-next 6/8] ionic: print pci bus lane info
Date:   Fri,  6 Mar 2020 17:04:06 -0800
Message-Id: <20200307010408.65704-7-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200307010408.65704-1-snelson@pensando.io>
References: <20200307010408.65704-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Print the PCI bus lane information so people can keep an
eye out for poor configurations that might not support
the advertised speed.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
index 0ac6acbc5f31..2924cde440aa 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
@@ -248,6 +248,7 @@ static int ionic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	pci_set_master(pdev);
+	pcie_print_link_status(pdev);
 
 	err = ionic_map_bars(ionic);
 	if (err)
-- 
2.17.1

