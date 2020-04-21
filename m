Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C49C1B1CCD
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 05:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728294AbgDUD2A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 23:28:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726628AbgDUD16 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 23:27:58 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71037C061A0E;
        Mon, 20 Apr 2020 20:27:58 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id n17so9823755ejh.7;
        Mon, 20 Apr 2020 20:27:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=wFUAHksPBRAFfm0oT11F+1uEzTcenvzx6QM0fJ+VVOk=;
        b=Qp7VOZlvSF8XwlgdLJDUt8YtWJQYIO0KvozZgBSt3uAyJevyOVMfxjUUout6S4AP08
         2u+TrWWopA4DjCHuDDlXkxNCcHbEI1r7zPqb0vH3b6FtQKqI/z9cpXQ+uF0G6r9Gpr6I
         H63wk4f4QJZ1FsnIix0844IZcrmt+5mW1nec1gE/8VGijvjSSWfYxvj2lLyhRiYBlgvi
         W294lY/ZL6H8e1N0xoSgWQ2iO4gjmLR7TulhAcLWaCP1wklKsFlxnbYpiCP/6q9zRdwD
         eQq0iGTxDIFLqPBrnFKDnudYOfzmM24aHrieMQ5jrpPYeh6/DSeitp+hRpLvmkcYNHGo
         Ob5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=wFUAHksPBRAFfm0oT11F+1uEzTcenvzx6QM0fJ+VVOk=;
        b=LVfek76O6iMhsh7DwAKZqFmasqcD4YLScvGKNNiP5xEiQPfetJC2xKZJCHL3w5raTJ
         1r58hmnQA+wCCDQc5VJTmq9vmcLOXBZU+K7oSpKZmEZPWS7LvWJTgn5qxECfDmk6UIF/
         9A7ke9MXoomNFO8hzbQKzGJRkuL25jxJQsQVDNGMzyU0zefPOgTYCfl0I+MI9qWg7rSI
         o1d1NnZEvzQLX7gyyc0G45ouEr1ak35cHYREeH82Tb2nQ6YFbOuz3xiwPrt7X6LLx8M8
         5ZMda31pt1XnVdR2V31/3VS/Lka0NI6wxwy10xj9dRMXRsNN/ROGauo4XaQ+jtvodMhZ
         1tvA==
X-Gm-Message-State: AGi0PuY0oXXOSeNeAfswGYkfTEbZys6+1lti8/1BIhVGyuJDB2DhyMKf
        9gudtevkKn0IafyIG7Jyv5TQ+jZF
X-Google-Smtp-Source: APiQypIMOh+GBXJK4z2BsAarn9Md69Dr7IHUQfG2i74hwfe2lfrc4MywjOuGsrb8B2RjKQXs8pqOrA==
X-Received: by 2002:a17:906:d14b:: with SMTP id br11mr19683143ejb.213.1587439676864;
        Mon, 20 Apr 2020 20:27:56 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j9sm216836edl.67.2020.04.20.20.27.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 20:27:56 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        linux-kernel@vger.kernel.org (open list), davem@davemloft.net,
        kuba@kernel.org
Subject: [PATCH net v2 3/5] net: dsa: b53: Fix ARL register definitions
Date:   Mon, 20 Apr 2020 20:26:53 -0700
Message-Id: <20200421032655.5537-4-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200421032655.5537-1-f.fainelli@gmail.com>
References: <20200421032655.5537-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ARL {MAC,VID} tuple and the forward entry were off by 0x10 bytes,
which means that when we read/wrote from/to ARL bin index 0, we were
actually accessing the ARLA_RWCTRL register.

Fixes: 1da6df85c6fb ("net: dsa: b53: Implement ARL add/del/dump operations")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/b53/b53_regs.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_regs.h b/drivers/net/dsa/b53/b53_regs.h
index 2a9f421680aa..d914e756cdab 100644
--- a/drivers/net/dsa/b53/b53_regs.h
+++ b/drivers/net/dsa/b53/b53_regs.h
@@ -304,7 +304,7 @@
  *
  * BCM5325 and BCM5365 share most definitions below
  */
-#define B53_ARLTBL_MAC_VID_ENTRY(n)	(0x10 * (n))
+#define B53_ARLTBL_MAC_VID_ENTRY(n)	((0x10 * (n)) + 0x10)
 #define   ARLTBL_MAC_MASK		0xffffffffffffULL
 #define   ARLTBL_VID_S			48
 #define   ARLTBL_VID_MASK_25		0xff
@@ -316,7 +316,7 @@
 #define   ARLTBL_VALID_25		BIT(63)
 
 /* ARL Table Data Entry N Registers (32 bit) */
-#define B53_ARLTBL_DATA_ENTRY(n)	((0x10 * (n)) + 0x08)
+#define B53_ARLTBL_DATA_ENTRY(n)	((0x10 * (n)) + 0x18)
 #define   ARLTBL_DATA_PORT_ID_MASK	0x1ff
 #define   ARLTBL_TC(tc)			((3 & tc) << 11)
 #define   ARLTBL_AGE			BIT(14)
-- 
2.17.1

