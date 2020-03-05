Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9CA179F1D
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 06:23:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbgCEFXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 00:23:37 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:45722 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726004AbgCEFXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 00:23:36 -0500
Received: by mail-pg1-f195.google.com with SMTP id m15so2148852pgv.12
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 21:23:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=s5+2M55qCyjMNWRRfZa1qww5IAjEysQ2sF63nol+NPk=;
        b=DkLmPL16mkXXWsgVO5Tg8AiuA3Y7UohKEKxfo0xBAv1GooPWROJThgG2fDFoVejXK4
         lvYVgpkiY3NP4dgBALOR5ou/rHfYOus1lcqxiHC46mDPXynpPeVA2P6Dd4OtKFbqyfsD
         F5H9MSf60Di516TuP/JKex9t3zy/ddLOllxdiQzcAwQTQesDZqwd3AvSYGeyMVK9HMW/
         h1QxHjvvBMpZ7noXo/QZHi/HGx+zkuqEMIsCO+nezioOoPWqfm3ugqCXAXuAdUQeh5VU
         izGiUgB2OVQC+AIDL8gC6Xpm88EOcvipMcT6Y1mNyS0+0f8hOtvkq0H5jlYg9LE78CNO
         I3fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=s5+2M55qCyjMNWRRfZa1qww5IAjEysQ2sF63nol+NPk=;
        b=sMx4jMfM8psbp2g6MqLkuxL0YPrYWGZUPxSDwlV3TQ4NOXn3ktREAsfqPH90Rz8+Zk
         xwvwANBu43FL2jF+9EBY9DvjMcP0QkjGK7zyDvR4Q0ut5zU7jbCZRNdqMoZ97e5cDoDy
         o2sLVH7a+n4Po7aaOqZHKJeWOPZzkM256uvffILX9JixZeLLfQ+V1ESjNRiRLTtRrrou
         hHogoBdwghOyd9+i1ZNR+C3FpzNq4uZrQ4zqG1wzlWep/KokBJhZODFRsN2Ei6pB24oA
         m0vu8OQSrcWdMScdi6wFg2k2CzwREYt3YYzafUnLY8QWYlUlCN5h6bpaSsPe4QSD8Ftu
         cN4Q==
X-Gm-Message-State: ANhLgQ24hiTs/YMXmRonN+qiR5XGSCZXkGx/UDFj+Y9QDmyCLJqoImqo
        YJ3mjfqwpK0FBC+coi2QMZR32yjh07w=
X-Google-Smtp-Source: ADFU+vtUq4b5rOBmzoLUcb/lsj6vaRNcMBzsuceXwbZN1fY4/L4DNkVaKF31iW54RXe3c0sTPYR7xw==
X-Received: by 2002:aa7:875a:: with SMTP id g26mr6759732pfo.193.1583385813800;
        Wed, 04 Mar 2020 21:23:33 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id h2sm29337759pgv.40.2020.03.04.21.23.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Mar 2020 21:23:33 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v3 net-next 6/8] ionic: print pci bus lane info
Date:   Wed,  4 Mar 2020 21:23:17 -0800
Message-Id: <20200305052319.14682-7-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200305052319.14682-1-snelson@pensando.io>
References: <20200305052319.14682-1-snelson@pensando.io>
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

