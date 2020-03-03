Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9046E176DE6
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 05:16:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727381AbgCCEQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 23:16:11 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40769 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727073AbgCCEQG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 23:16:06 -0500
Received: by mail-pf1-f196.google.com with SMTP id l184so780203pfl.7
        for <netdev@vger.kernel.org>; Mon, 02 Mar 2020 20:16:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=s5+2M55qCyjMNWRRfZa1qww5IAjEysQ2sF63nol+NPk=;
        b=Jepfb/088kvGsck2bouaP+Mj2+rl5+Qk7/228uH/qhYMQE1b3vsCLNpqxDfbt4FHtZ
         CTjZ48yd/K1I1WZ2V/X3pFjwi8nbjayfuJ/yG0F0TWn+xRX0bIaLM1OX12EeYbz4pD2U
         J1lWMQt7Su34dy4v9McjkAiuWDGQYhA8QAx7w6+eevzpzzuHT3I+dzfjT6hagAmKRRyO
         mg5DZv2DfsCMdXkxaWGzzbWxc4Ypp6+A9dldw+1Xo2s/7UxcTy3sP1SL8/+3E+WKseW5
         +jmBWX4iPIGz/AGfMsJmkBqe3DuZ4cY1IyJnWOEcqru6KfXYTC4ZPQL51L7QCcy1K2Ec
         lWyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=s5+2M55qCyjMNWRRfZa1qww5IAjEysQ2sF63nol+NPk=;
        b=FEnf5xaZnhO56gtgoHhYjlz++PII1rYV2JpqNlZaS6qv/YJBYnxOkhxky2R8UANwEa
         Bk52zEw7r8UpSI3plB1amlFlG+qURe7qB7rfWPgZXwrFpKuKESmN2QAhJqjOQgsyBn2p
         298jnbqEsUeZF1dYFMtvNuUBFaQTsd/QgnvBozc3okBpJ0G/VX5PBjKCZOxRHYXy3VJi
         P/TeYnrmojBRscRe9MsG1i+qalJTbsxmjvwNjSK88uJYvZoXjiIQTd/5ebpJwD3pO9bn
         Pr0zG6DWkude6BjaZ3QBYNIvy+XaAXI7pm0tPbWGkj/W5XTXA8p7Z6LjhTomrZ/jd5ds
         0Uvg==
X-Gm-Message-State: ANhLgQ3tmIe5MuVci518Hf3pABe6mdBYO7yfnc+tf2/UNaKevrAt/aFZ
        EP9d5H57EVI0I0Srbs14dnWptKLUP3c=
X-Google-Smtp-Source: ADFU+vvFA0pulPXSCBsB+tOO0HGq+LVO1BY11VkygPMPPKHX20K2UrsoW1mBd4I5xGPfCO5wn+uyCQ==
X-Received: by 2002:a62:cdc6:: with SMTP id o189mr2392167pfg.254.1583208965371;
        Mon, 02 Mar 2020 20:16:05 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id t7sm396682pjy.1.2020.03.02.20.16.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Mar 2020 20:16:04 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 6/8] ionic: print pci bus lane info
Date:   Mon,  2 Mar 2020 20:15:43 -0800
Message-Id: <20200303041545.1611-7-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200303041545.1611-1-snelson@pensando.io>
References: <20200303041545.1611-1-snelson@pensando.io>
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
index 554bafac1147..59b0091146e6 100644
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

