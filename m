Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D265F3C7F3A
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 09:16:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238289AbhGNHTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 03:19:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238251AbhGNHTM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 03:19:12 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17487C061574;
        Wed, 14 Jul 2021 00:16:20 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id jx7-20020a17090b46c7b02901757deaf2c8so873890pjb.0;
        Wed, 14 Jul 2021 00:16:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4jskSB1DiBrCiUAFGdix3WJoQ/5LpAf9kLsHxzYGWlc=;
        b=aBnm4uMqxZz/6szSq4h3/Lvp5XYySG8q5QI6oVkY5qjzZC4JfcgSfMK5SWr9wYC3RV
         d2ejs98KdVRLplXz9TnVZ5PS9VUifrC2E0MpdQtZ+BIxS0u/3KPqsH5ZCq5nZ2r4060I
         K3aqYT2vmmcjBM7ApJsS93Sndqj47afxjL22lLoHy9b+fxt9sPHZN+V7yI2ztNEHIgBg
         YtOM/uZIgT+OB9zhQ+iooVzsJCGofqbUGqD1Q2q3Keh2S5v7ff30BRYBScpH0ldyOJSI
         Ho7KEmwKC2601WcLw6k4SXHZcFBwlpLF85LMEj5V97EGa1DRgLogrFas5mUM4rdRMWh9
         iSag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4jskSB1DiBrCiUAFGdix3WJoQ/5LpAf9kLsHxzYGWlc=;
        b=qViiocWBSwa3CdUlt4IXGgblCeQcpQm3eXnGvYj+nVcpjGyIJNSeAkYZS/U5W8c+z0
         uM0qlNQ6bYlB3v4HGP90G3Vz0DACjq+ynp9zo3PC75igaYJIMvP4na+4GqYdL2W+bK44
         2nBVqSsjY+sBA0o9ZAt9YN12reO4lhkz6BCLT4FHqsj4FZUoQaE1AnmDT/Y6RqyAK56K
         ThCK/4+9qA6xKnG+49poHbc7Pc1oZYOjtcqZiMftFEm63ynJe0FiZDC+QqeQ3To8ZYJu
         lCCFUNF5Aldxjy56+Vt8xbpJUyhlMAvGOnHP1afqmRe4jRZ3h7k6n35Ir1tdTX3igrnY
         sMrg==
X-Gm-Message-State: AOAM532cKVpYQ87tZD7s6ZSio5QG97QvKaRnD3WhTm+/YYu63LFJ8Z3T
        GQTDXiJnsz/DtteQtuBQC5M=
X-Google-Smtp-Source: ABdhPJyM8jMHSnCRzzj3bfdyJuQOdTHPQcEJPFcr+YrIBVa+uFcpvm4t8wVSK6oC2YVjFrQEbATvdQ==
X-Received: by 2002:a17:902:830a:b029:128:bcba:6be9 with SMTP id bd10-20020a170902830ab0290128bcba6be9mr6674289plb.53.1626246979637;
        Wed, 14 Jul 2021 00:16:19 -0700 (PDT)
Received: from localhost.localdomain ([154.16.166.218])
        by smtp.gmail.com with ESMTPSA id 133sm1583623pfx.39.2021.07.14.00.16.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 00:16:19 -0700 (PDT)
From:   Dongliang Mu <mudongliangabcd@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Oliver Neukum <oneukum@suse.com>,
        Anirudh Rayabharam <mail@anirudhrb.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dongliang Mu <mudongliangabcd@gmail.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Emil Renner Berthing <kernel@esmil.dk>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] usb: hso: remove the bailout parameter
Date:   Wed, 14 Jul 2021 15:15:33 +0800
Message-Id: <20210714071547.656587-2-mudongliangabcd@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210714071547.656587-1-mudongliangabcd@gmail.com>
References: <20210714071547.656587-1-mudongliangabcd@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are two invocation sites of hso_free_net_device. After
refactoring hso_create_net_device, this parameter is useless.
Remove the bailout in the hso_free_net_device and change the invocation
sites of this function

Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
---
 drivers/net/usb/hso.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index 90fa4d9fa119..91cace7aa657 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -2353,7 +2353,7 @@ static int remove_net_device(struct hso_device *hso_dev)
 }
 
 /* Frees our network device */
-static void hso_free_net_device(struct hso_device *hso_dev, bool bailout)
+static void hso_free_net_device(struct hso_device *hso_dev)
 {
 	int i;
 	struct hso_net *hso_net = dev2net(hso_dev);
@@ -2376,7 +2376,7 @@ static void hso_free_net_device(struct hso_device *hso_dev, bool bailout)
 	kfree(hso_net->mux_bulk_tx_buf);
 	hso_net->mux_bulk_tx_buf = NULL;
 
-	if (hso_net->net && !bailout)
+	if (hso_net->net)
 		free_netdev(hso_net->net);
 
 	kfree(hso_dev);
@@ -3137,7 +3137,7 @@ static void hso_free_interface(struct usb_interface *interface)
 				rfkill_unregister(rfk);
 				rfkill_destroy(rfk);
 			}
-			hso_free_net_device(network_table[i], false);
+			hso_free_net_device(network_table[i]);
 		}
 	}
 }
-- 
2.25.1

