Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC0244280AB
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 13:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231898AbhJJLSM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 07:18:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231824AbhJJLSJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 07:18:09 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7422BC061570;
        Sun, 10 Oct 2021 04:16:10 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id a25so39497711edx.8;
        Sun, 10 Oct 2021 04:16:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vSbsp53GPbC1UoykdeP64z97Nxwqf8jxKnT8asaP0f0=;
        b=O2yP2cLW6KnAHjXD/m9a+06KXYobHq+FxS/PsdmcAdSXxTkCY5R7jAYAMcrMYd+UPd
         LxcUsuB4xSKmALM+kK0ZFnnqZAA5LCNyOVkIIMjpqK511dxW9Jmmc+eMOBvl9yuXvYQ3
         9Een4Rqnti7xob1TBdRx+s8O7+1UlGvzdqdwq71hXOS00HX9Ni4MzY4JQu5NPL20y6Ct
         JuAD4nZ3d2+ZyLkq7vQrdGHFuOTwdQJEkPjLO9M/UBQM18Dx2xTTPJ9yf7aXhgIwMnfd
         5DRXHKLHMvTO2c/azfHRtgTm0YZWb8/hsI+mx3esD1g86DcQjOVniybSXccUDBraGtPR
         r0Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vSbsp53GPbC1UoykdeP64z97Nxwqf8jxKnT8asaP0f0=;
        b=Uc7NotVBORNtS2p1FdVej8jk5Jz2Qxa09jEzsqrVOsv+9K0fmdJ8blaKYs+6IXYn/o
         fJjES0z1HU+EH0NWkweKtWfQ2TtrMVuk0RRTv3ixehg7Yys3Y0LLVUMS5u2RpI/IOROg
         mKLKgONUB0q/Qg2eWRLwaL9fuWxyqPtwZySViqsewjNkKRJVfEWvUxFnXjSxZNASmDE6
         rrFeyxZGnHlu6B1PrXiA9Nh9eYS+55nhWi7y/oksL5PcGMIXcHoLQBErSrNENqata9y5
         6q+QmzIaOa4occT//lkzCi3Wxxyh0cb/nSV0mH6prTPSniuXRykHVBWT7MvLQOioB6yK
         46mw==
X-Gm-Message-State: AOAM532H2E4Vs4SDb0KzaXQUrOQ6V1M9v36BkqdpfXOVD+YgKqOUIoVE
        o9RZdwbLpmYlWWXKX+KIHkU=
X-Google-Smtp-Source: ABdhPJxeXCItcnrOjod8t+wu5c3Vh352J/F3xbeMBWK7xXfcvrrDvsqW6DTlB4wFcgG550P2tyadaw==
X-Received: by 2002:a17:906:d975:: with SMTP id rp21mr17744055ejb.104.1633864568910;
        Sun, 10 Oct 2021 04:16:08 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id z5sm2414438edm.82.2021.10.10.04.16.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Oct 2021 04:16:08 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        Matthew Hagan <mnhagan88@gmail.com>
Subject: [net-next PATCH v4 03/13] dt-bindings: net: dsa: qca8k: Add MAC swap and clock phase properties
Date:   Sun, 10 Oct 2021 13:15:46 +0200
Message-Id: <20211010111556.30447-4-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211010111556.30447-1-ansuelsmth@gmail.com>
References: <20211010111556.30447-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add names and descriptions of additional PORT0_PAD_CTRL properties.
qca,sgmii-(rx|tx)clk-falling-edge are for setting the respective clock
phase to failling edge.

Signed-off-by: Matthew Hagan <mnhagan88@gmail.com>
Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 Documentation/devicetree/bindings/net/dsa/qca8k.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
index 8c73f67c43ca..cc214e655442 100644
--- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
+++ b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
@@ -37,6 +37,10 @@ A CPU port node has the following optional node:
                           managed entity. See
                           Documentation/devicetree/bindings/net/fixed-link.txt
                           for details.
+- qca,sgmii-rxclk-falling-edge: Set the receive clock phase to falling edge.
+                                Mostly used in qca8327 with CPU port 0 set to
+                                sgmii.
+- qca,sgmii-txclk-falling-edge: Set the transmit clock phase to falling edge.
 
 For QCA8K the 'fixed-link' sub-node supports only the following properties:
 
-- 
2.32.0

