Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA652C7B8C
	for <lists+netdev@lfdr.de>; Sun, 29 Nov 2020 23:02:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728355AbgK2WBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 17:01:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbgK2WBD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Nov 2020 17:01:03 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AD5EC0613CF;
        Sun, 29 Nov 2020 14:00:23 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id s8so12835201wrw.10;
        Sun, 29 Nov 2020 14:00:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pK9Ea/lgfc3fvgVFGg7cOxa+M9VALejH1ACdbsPKEMs=;
        b=KRAtgg0hzXOZxVS59NHBhpHOhG9Y9rIM0498RODGWISfOJvYCPTtE1HNUOAlm/tVJM
         lIL/AdC8S/7SY0luV1cuPsHQdVkJRRxk6Ie+zM1LlHJWSXa83F2r4nHFi8Yi0Tc5g8Io
         ksFL1a/vsj/U/O3Ez1YpAl5Jgyl9rOQzADqp91GWC6cBqkqzVTPqhUyBvWeq3EBE/UyG
         26sLDscyH6thWo8DdjfK047YRJTSaVS8qzk2YVNaEzdY+/BFW4QlwzZVHRnJONAyS1Tg
         dLKHfB1dkXDHHJuXi63P3FfueS83o7qhFcOS7ZO8c+CHL+SfEeOFtTac5UYF4ePuscyC
         RQFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pK9Ea/lgfc3fvgVFGg7cOxa+M9VALejH1ACdbsPKEMs=;
        b=VMPu3Vqct/mjBffcHRo11VbUWpwGINpIhgNucw3cEmRANNv88P1YvBQ/61lE/+kT6b
         Pn3y85egfTYHyaJekuZAGfD/LoqtXhNNOPCzHdhKQONSDEHNOSAbNucUlSmEkoLOe5Ru
         TSXaUlSf8n8UgdZMkRtiCGrLCQVA7zyQDPNOEahxNMiwtYKeb0m1mMIq2sr73KxD0uzA
         /lyuOqVtYQj8eWcNCKaDqsSCpmfdRbAHjp3lVfLCUG6aROU3zwOSAmj0NmQuo+Hfgn5x
         FdN24Q2l79+jYDwNa/mrAnjatoY88XjiF6ljyErnrJi9wRTMa4cjPbdXZtyABq9uOPJA
         htXQ==
X-Gm-Message-State: AOAM533hIef5EufMOLFoQ/4ox9JjxBEdqMOIBY2aXBNe1bXwD9IfpHnm
        oxg9jWYglfWkLxe4zuQ6mb0=
X-Google-Smtp-Source: ABdhPJx5M4ah82QopUDttcRrjU+9UwtDA2W6mq8D6gp/WYVTb2oi4QvdYVcx+Dji0qHlQXg04kBbLQ==
X-Received: by 2002:adf:a495:: with SMTP id g21mr24207576wrb.213.1606687221985;
        Sun, 29 Nov 2020 14:00:21 -0800 (PST)
Received: from adgra-XPS-15-9570.home (lfbn-idf1-1-1007-144.w86-238.abo.wanadoo.fr. [86.238.83.144])
        by smtp.gmail.com with ESMTPSA id b4sm4938080wrr.30.2020.11.29.14.00.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Nov 2020 14:00:21 -0800 (PST)
From:   Adrien Grassein <adrien.grassein@gmail.com>
Cc:     fugang.duan@nxp.com, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Adrien Grassein <adrien.grassein@gmail.com>
Subject: [PATCH v2 1/3] dt-bindings: net: fsl-fec add mdc/mdio bitbang option
Date:   Sun, 29 Nov 2020 22:59:58 +0100
Message-Id: <20201129220000.16550-1-adrien.grassein@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201128225425.19300-1-adrien.grassein@gmail.com>
References: <20201128225425.19300-1-adrien.grassein@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add dt-bindings explanation for the two new gpios
(mdio and mdc) used for bitbanging.

Signed-off-by: Adrien Grassein <adrien.grassein@gmail.com>
---
 Documentation/devicetree/bindings/net/fsl-fec.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/fsl-fec.txt b/Documentation/devicetree/bindings/net/fsl-fec.txt
index 9b543789cd52..e9fa992354b7 100644
--- a/Documentation/devicetree/bindings/net/fsl-fec.txt
+++ b/Documentation/devicetree/bindings/net/fsl-fec.txt
@@ -22,6 +22,10 @@ Optional properties:
 - fsl,err006687-workaround-present: If present indicates that the system has
   the hardware workaround for ERR006687 applied and does not need a software
   workaround.
+- mdc-gpios: Bitbanged MDIO Management Data Clock GPIO. If specified,
+mdio-gpios should be specified too.
+- mdio-gpios: Bitbanged MDIO Management Data I/O GPIO. If specified,
+mdc-gpios should be specified too.
 - fsl,stop-mode: register bits of stop mode control, the format is
 		 <&gpr req_gpr req_bit>.
 		 gpr is the phandle to general purpose register node.
-- 
2.20.1

