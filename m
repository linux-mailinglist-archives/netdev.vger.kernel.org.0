Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 583A214ACBF
	for <lists+netdev@lfdr.de>; Tue, 28 Jan 2020 00:54:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbgA0Xyp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 18:54:45 -0500
Received: from mail-pl1-f202.google.com ([209.85.214.202]:54030 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726921AbgA0Xyp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 18:54:45 -0500
Received: by mail-pl1-f202.google.com with SMTP id m13so4632739pls.20
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 15:54:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=LtaIREjg0GbBNJyJVnqCp3W9hRUEU+wNigeViXWJb/o=;
        b=QJWVurVz83htEHzzAukWZOjRvkslLJAt6RkcCPRQgUwcrrqnp2W42ISvpNSlJqhLYI
         HDzfPU81B/8MhLW3/BOHOTSm3GJr/tMW4jJ1uZjzTbJHZI7r00deF2uuiZE1jDlE3Ujn
         MIMSuULUgAiE5dl8Nrbk0b8EeQoezOApOBHVkrgqe0dU+IightjL6OUCro+mwIxTLbFb
         t2pFhrqSSkm11dR+u1q94/yUiey4cwHOn48bYfK20V0lZ9Glrn/woVo38KYoMyo6/pXm
         Ki9LI1z6JOEkTJvqF9Ngr3gnj3PxZwspaCM9AexVBTeEbEa6NoLses4XF2PhfQahE7g1
         UGtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=LtaIREjg0GbBNJyJVnqCp3W9hRUEU+wNigeViXWJb/o=;
        b=ZxW/k8w24p6a299VjWbpX6bCD9utUmwVKehj4DtQENKWKme+noK5wZlvJ0NFOBYEj8
         HBl/JdmOTCWawxbgdVdfKjBreLoynJXkIJfqYPn/MRc2KtBQVFpMs9bGxjxdv2ZXykwk
         B/mOrIOZAVitJKrayP6e7SkoxaN+ME12ZlH1KH/fmjFnMWUNv8yC3rlTcERPr67oE/+t
         254TDuptWMiP68yU18EFjDkKroScn/zpV7jdQHNdRwEY3CHNK4dXX6e8WBjy03SH/3Vb
         +NUHIZZ2nkEkfca9bv/1nTof7XRMr5/jExZ8TdDFSTu7X6xgq3CyrNF0xB6XTimcmfAG
         5O9g==
X-Gm-Message-State: APjAAAUAFuRNTlDLQEnkS107sK83RDOW0byvbPc4OOyO6Uo6pjQyzce3
        afxi2KNtewJyPCEJ66mfvNj07PQMuSaoEkUgLT+dTw==
X-Google-Smtp-Source: APXvYqweRQ8m5hhu1HXuRMedVPc2bAFe5tdPFCvhiapDMmB+s6KJgSZdl7ge+tHS5zEbJYelkAeAJQhRjXaIFteOOxWnoQ==
X-Received: by 2002:a63:234f:: with SMTP id u15mr21895366pgm.88.1580169284558;
 Mon, 27 Jan 2020 15:54:44 -0800 (PST)
Date:   Mon, 27 Jan 2020 15:53:52 -0800
In-Reply-To: <20200127235356.122031-1-brendanhiggins@google.com>
Message-Id: <20200127235356.122031-2-brendanhiggins@google.com>
Mime-Version: 1.0
References: <20200127235356.122031-1-brendanhiggins@google.com>
X-Mailer: git-send-email 2.25.0.341.g760bfbb309-goog
Subject: [PATCH v1 1/5] net: axienet: add unspecified HAS_IOMEM dependency
From:   Brendan Higgins <brendanhiggins@google.com>
To:     jdike@addtoit.com, richard@nod.at, anton.ivanov@cambridgegreys.com,
        "David S . Miller" <davem@davemloft.net>,
        Michal Simek <michal.simek@xilinx.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Robert Hancock <hancock@sedsystems.ca>,
        Esben Haabendal <esben@geanix.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Cc:     linux-um@lists.infradead.org, linux-kernel@vger.kernel.org,
        davidgow@google.com, heidifahim@google.com,
        Brendan Higgins <brendanhiggins@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently CONFIG_XILINX_AXI_EMAC=y implicitly depends on
CONFIG_HAS_IOMEM=y; consequently, on architectures without IOMEM we get
the following build error:

/usr/bin/ld: drivers/net/ethernet/xilinx/xilinx_axienet_main.o: in function `axienet_probe':
drivers/net/ethernet/xilinx/xilinx_axienet_main.c:1680: undefined reference to `devm_ioremap_resource'
/usr/bin/ld: drivers/net/ethernet/xilinx/xilinx_axienet_main.c:1779: undefined reference to `devm_ioremap_resource'
/usr/bin/ld: drivers/net/ethernet/xilinx/xilinx_axienet_main.c:1789: undefined reference to `devm_ioremap_resource'

Fix the build error by adding the unspecified dependency.

Signed-off-by: Brendan Higgins <brendanhiggins@google.com>
---
 drivers/net/ethernet/xilinx/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/xilinx/Kconfig b/drivers/net/ethernet/xilinx/Kconfig
index 6304ebd8b5c69..b1a285e693756 100644
--- a/drivers/net/ethernet/xilinx/Kconfig
+++ b/drivers/net/ethernet/xilinx/Kconfig
@@ -25,6 +25,7 @@ config XILINX_EMACLITE
 
 config XILINX_AXI_EMAC
 	tristate "Xilinx 10/100/1000 AXI Ethernet support"
+	depends on HAS_IOMEM
 	select PHYLINK
 	---help---
 	  This driver supports the 10/100/1000 Ethernet from Xilinx for the
-- 
2.25.0.341.g760bfbb309-goog

