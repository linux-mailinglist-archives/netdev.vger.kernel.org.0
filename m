Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32D102ACBDD
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 04:32:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732032AbgKJDcc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 22:32:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731256AbgKJDb0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 22:31:26 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 020AEC0613D3;
        Mon,  9 Nov 2020 19:31:26 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id 62so8934580pgg.12;
        Mon, 09 Nov 2020 19:31:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bynb1YnmKltcGUlFQ6pnG5+egTbzs7qC5i/nlM2ATyc=;
        b=buev63DaHHo8Yja2v1IGyRX7OEH0038TQ8RIMx6G1cqRc61BAPQYIOlGsNgbPWJsaG
         330Sb0i4uigXIBbIGs6OJLzvVIZTA41se1FsCkDOGHT0hSMBKM1JMJcPzGNY8XhGkGgR
         MtnppP6tuu8mxbtgmEhWTj8zQ4gcSC50xEVcexbDroReRob4vNndiALwreoqqaJ72jgq
         6xys5b3b5g+a0O3MFWbtHMVEwNhuLT8+Ui36C62fzkM+tGGjbKc75GfUp7E+IlcUJG6e
         cV+V8ut3BV14eC8prVjfgPYPxJwOZJmoBHSowqavHRwsqC0C7q3vWkPEcPQlLX0oESrG
         LoiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bynb1YnmKltcGUlFQ6pnG5+egTbzs7qC5i/nlM2ATyc=;
        b=K6hlQ9k2HBa7W89YGwKxqmW7j5iqlE3HuZ3xOvpCf7v8Uml058et438MBdeaVeg2Cw
         qfyEt1h6bZCzeKC0Xz9HLbIgNYIjBEGoBZELRm/u90sjvRs3ciDXL7EhR+W5GHItyAYQ
         Hwwbf6qz1J3GcLpj+ABScN3yzP6yNjUZ7enG5xEQNZZhaCB4qMgXpZH9W0ouMmM5hfXB
         X690+GjIKCxWP+OA+M1nKQcHX8ZGyQWkGIYGV/N9blV+3tizVg8qufYeoiXPbjfPUW+A
         GCCQwpCGJ8i/ztOUEOVbkm2QNneNtCylBArhWfaD7z8HUGR5UJVE1v72qH/jKk6JHSqR
         OYbA==
X-Gm-Message-State: AOAM530xI8TKjPxZCM4BM4U0k7ZXby0ojHcd6DBGZZ+7vGei/1aLHxZe
        uCdXu28qfM4J6AvsY5XBGNAiXQrEFTg=
X-Google-Smtp-Source: ABdhPJw9LSzlAnZT/xTmCVTJVoyxQAYfULTN2ZdJnF5+wODNEyyrliyCoZK6ucs8iKdWYydX9YDgbw==
X-Received: by 2002:a17:90a:e997:: with SMTP id v23mr2718592pjy.89.1604979085182;
        Mon, 09 Nov 2020 19:31:25 -0800 (PST)
Received: from 1G5JKC2.Broadcom.net (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id k12sm965677pjf.22.2020.11.09.19.31.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 19:31:24 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com (maintainer:BROADCOM IPROC ARM
        ARCHITECTURE), Hauke Mehrtens <hauke@hauke-m.de>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:BROADCOM IPROC ARM
        ARCHITECTURE), Kurt Kanzenbach <kurt@kmk-computers.de>
Subject: [PATCH 02/10] dt-bindings: net: dsa: Document sfp and managed properties
Date:   Mon,  9 Nov 2020 19:31:05 -0800
Message-Id: <20201110033113.31090-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201110033113.31090-1-f.fainelli@gmail.com>
References: <20201110033113.31090-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 'sfp' and 'managed' properties are commonly used to describe
Ethernet switch ports connecting to SFP/SFF cages, describe these two
properties as valid that we inherit from ethernet-controller.yaml.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 Documentation/devicetree/bindings/net/dsa/dsa.yaml | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
index 5f8f5177938a..8e044631bcf7 100644
--- a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
@@ -78,6 +78,10 @@ patternProperties:
 
           mac-address: true
 
+          sfp: true
+
+          managed: true
+
         required:
           - reg
 
-- 
2.25.1

