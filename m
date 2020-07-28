Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 268BB2300CB
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 06:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbgG1EbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 00:31:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726004AbgG1EbV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 00:31:21 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD253C061794;
        Mon, 27 Jul 2020 21:31:21 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id k18so3005011pfp.7;
        Mon, 27 Jul 2020 21:31:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=v+vZ5D4lzefV/m6Wri5yBEiubcUZ9dLbHVAGhnF8Sco=;
        b=dHFpNLnBI7i7q/GgeRddp2ijwrw3IwVr0tWLgS+N0fmjwKV853MwLy70ChD1bZFUO1
         wl5wRHC1MgjqvggoTT3AuZo57TTkAr11qpEHEFbTpsHOUWNb6tfx16bX0tp7sRZ3A0J9
         66dIYDQ6dWJz2IVqGpRng1iNq7TN36GtwWceIsL70xAvFWh12VyD4QLWPhEiBuD3uhZe
         c6yN0+iQaREWBLptbBivah1QzKhJniHcb0w42gUgyQwwcM/+GtJ3EkYBy02AEiNT1G5c
         W5IVhAOqoSOkNPkZm1PVZ9LBCVJnf9SYFbDdviBAMqc6BzE/TFCdytDb5k1QNMu7yZb9
         XmGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=v+vZ5D4lzefV/m6Wri5yBEiubcUZ9dLbHVAGhnF8Sco=;
        b=MKovf2/i+BIrGRViI8UPaXxJdZDHT+Lyqun6ScJh58v3BXtIFQSx+H9tBw/PiecfPd
         DrWlav4a1XIV7FZfQtnavojkpZST8pyl2O8TPOxC8aZgpZp/+h27hvaXCUELEV0uDgdx
         GxciixBYsMwKthqOqXHESGCrYe3VuwfpkSw49MlrRX+H/UvjjcwLKvT1JmD1VItjzAw7
         vACvtJTkM12SWtON8HjgMn7xTCtKfR2YBj9N7dlOsMgejNX7+vH3X9Y26ZSCR7jAyVyg
         BQ0ljZPsC/MNWIu33pZth7h2mYN15amMoHgLaauokJOy646ai7DbTVK45fxTsUNIdG11
         9LoQ==
X-Gm-Message-State: AOAM531I8rtIGY/yaFaHsIZNFduOecinRKu1sZ23HpbAxkZdQ9Yy0zYF
        O8fnlbS7tMRTZEPCmIGwCR0=
X-Google-Smtp-Source: ABdhPJxNSKY8nqzWNqUmpduCVcvLv5t3RJfq1EJosoCcXwZzA8Tp2Mh5firF6Od4Bd4KmDGn77+BDQ==
X-Received: by 2002:a62:e202:: with SMTP id a2mr23719262pfi.8.1595910680994;
        Mon, 27 Jul 2020 21:31:20 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.152.86])
        by smtp.gmail.com with ESMTPSA id b82sm16914992pfb.215.2020.07.27.21.31.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2020 21:31:20 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kevin Curtis <kevin.curtis@farsite.co.uk>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH v1] farsync: use generic power management
Date:   Tue, 28 Jul 2020 09:58:10 +0530
Message-Id: <20200728042809.91436-1-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The .suspend() and .resume() callbacks are not defined for this driver.
Still, their power management structure follows the legacy framework. To
bring it under the generic framework, simply remove the binding of
callbacks from "struct pci_driver".

Change code indentation from space to tab in "struct pci_driver".

Signed-off-by: Vaibhav Gupta <vaibhavgupta40@gmail.com>
---
 drivers/net/wan/farsync.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wan/farsync.c b/drivers/net/wan/farsync.c
index 7916efce7188..15dacfde6b83 100644
--- a/drivers/net/wan/farsync.c
+++ b/drivers/net/wan/farsync.c
@@ -2636,12 +2636,10 @@ fst_remove_one(struct pci_dev *pdev)
 }
 
 static struct pci_driver fst_driver = {
-        .name		= FST_NAME,
-        .id_table	= fst_pci_dev_id,
-        .probe		= fst_add_one,
-        .remove	= fst_remove_one,
-        .suspend	= NULL,
-        .resume	= NULL,
+	.name		= FST_NAME,
+	.id_table	= fst_pci_dev_id,
+	.probe		= fst_add_one,
+	.remove		= fst_remove_one,
 };
 
 static int __init
-- 
2.27.0

