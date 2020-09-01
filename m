Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4C925A0EA
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 23:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729509AbgIAVn7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 17:43:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727918AbgIAVnz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 17:43:55 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97EFEC061245;
        Tue,  1 Sep 2020 14:43:54 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id s10so770048plp.1;
        Tue, 01 Sep 2020 14:43:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AyKMQ8WKejiUbQ0uoIq3ttpVPmq3IB07qohgDLCsLRM=;
        b=iYk3UcD1MRyTugIBSur90bL7s2ttFeEfAlYOfb9ezgpcRS8uU0w9JsNsAFKqXZk+LV
         Y+VCsuf6/hyA0h1lNvC1scXpdPYYAyqk3RU0VsgGINcituOdlLBEK9ewKhxtjFnCktgr
         59eYUvwTyZI3P/qXO8uQZwCPHQQPRrmOXiX+Bs6Q9obAbjJcguuY+d/1cmBwBx9LIHQz
         QOBjrJerAPTy4UujMsojfVRK5Xv6eOj0pfOLVcZ0rfjJ39d/UC/NNIn+PjUgXgktE+gs
         gxqqZD8ejKwpgNrSL2JKHhLDY65MhZVpJQSV7iOCNu2yhs9rMTy0P5LRRtmlEt58Kcj/
         kXxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AyKMQ8WKejiUbQ0uoIq3ttpVPmq3IB07qohgDLCsLRM=;
        b=ZJxoJUoMtO9A+vRYop8C97Q0IoNWt2rxEz0lx6U/FCXKnk2WW3wXGZrDNvXxpm6voD
         3OFbYBSjjIeWwWOx1ZmVSrfb/S8H/H5lxOCGkUdBAMTt+JaCoCTGyvk63l6XJCOMUw6g
         W/bPITSU3ujOvWLB0DNNK/bW3oO+NH3B63iAbux/PsXp3qXPnRes5zhjAFeAzXw9hwwF
         G9MILdy8Xz3T5DifFnm56ih6Tgw6Vcqp6988nsnGo+TH/+BxpY6HNL4p3FCJ37e0+9Nk
         jPr6Kp52gv1uFecb6M0yAzcqvuSNQOq1TeZpWJGlsx8LKEgO+83KlOlTcwJHymCknzGA
         qWmw==
X-Gm-Message-State: AOAM531iPRmGoY4b+43on2xiAW1zr0qCABaFpk0B9i5aAHPc5xtmCoNz
        +xKefuiqN92FsOcOe21ElZ1OnBfjXtE=
X-Google-Smtp-Source: ABdhPJy7WjLjS4YhujBCm9ZAknj1AcuJdwvIuC4GttjemzaULadTZxoB1GkEvfiv7gZOFlyuK4WyWw==
X-Received: by 2002:a17:902:7e82:b029:cf:85aa:69f6 with SMTP id z2-20020a1709027e82b02900cf85aa69f6mr782949pla.3.1598996633483;
        Tue, 01 Sep 2020 14:43:53 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 131sm128663pfy.5.2020.09.01.14.43.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 14:43:52 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list),
        bcm-kernel-feedback-list@broadcom.com (open list:BROADCOM SYSTEMPORT
        ETHERNET DRIVER)
Subject: [PATCH net-next 1/3] dt-bindings: net: Document Broadcom SYSTEMPORT clocks
Date:   Tue,  1 Sep 2020 14:43:46 -0700
Message-Id: <20200901214348.1523403-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200901214348.1523403-1-f.fainelli@gmail.com>
References: <20200901214348.1523403-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Broadcom SYSTEMPORT adapters require the use of two clocks for
normal operations and during Wake-on-LAN, document those in the binding
document.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 Documentation/devicetree/bindings/net/brcm,systemport.txt | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/brcm,systemport.txt b/Documentation/devicetree/bindings/net/brcm,systemport.txt
index 83f29e0e11ba..745bb1776572 100644
--- a/Documentation/devicetree/bindings/net/brcm,systemport.txt
+++ b/Documentation/devicetree/bindings/net/brcm,systemport.txt
@@ -20,6 +20,11 @@ Optional properties:
 - systemport,num-tier1-arb: number of tier 1 arbiters, an integer
 - systemport,num-txq: number of HW transmit queues, an integer
 - systemport,num-rxq: number of HW receive queues, an integer
+- clocks: When provided, must be two phandles to the functional clocks nodes of
+  the SYSTEMPORT block. The first phandle is the main SYSTEMPORT clock used
+  during normal operation, while the second phandle is the Wake-on-LAN clock.
+- clock-names: When provided, names of the functional clock phandles, first
+  name should be "sw_sysport" and second should be "sw_sysportwol".
 
 Example:
 ethernet@f04a0000 {
-- 
2.25.1

