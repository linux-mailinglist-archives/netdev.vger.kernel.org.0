Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEA9A188B1D
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 17:50:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbgCQQuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 12:50:14 -0400
Received: from mail-wr1-f100.google.com ([209.85.221.100]:41522 "EHLO
        mail-wr1-f100.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726864AbgCQQuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 12:50:13 -0400
Received: by mail-wr1-f100.google.com with SMTP id f11so9839270wrp.8
        for <netdev@vger.kernel.org>; Tue, 17 Mar 2020 09:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=flowbird.group; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=W+6ZKJBJf+pKwV43v7D0zXLM6cx+OowEeRYTF5Vw6ZI=;
        b=SCcPbUq30tR/prj61InCo+jM2BXD3s60F25UdjYzuRQplgzUsltf69ymeBoRzIGEb0
         vtE9HsnpsSoXPVDZlyYzcw0wOTWlg+LFQ3J4cmoAKvVe2lIGr1AME+wH9LWyl6ECdkVM
         dZcR0yu7xcpgcBAEYF7/IBr6ljO+51N+9D4OUq42XvchQ3rXDK5Z1yO6tMJ3fkuRyrrQ
         8H5jtFeTC+UJNRqFXAqh6mSFAYuiHM6dAeoGBu3GAcae6jdbEIyeO5GKH9FcAUYcCzxe
         BOU+9LH9hJZ2j+o6OLA4qyPooBafGPTkK1WeCO4ri4Q0nEz8bIKVfXgGSOrW91M54usT
         ps9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=W+6ZKJBJf+pKwV43v7D0zXLM6cx+OowEeRYTF5Vw6ZI=;
        b=rYIqd5Z2jfc3hYzEP3GsDMASdAS0apLhnqbxIYNITuMv3OPhzQHTBcqSvJcLT9P7h7
         CletcOmO5ZkgRKRx7DKjRdhsaZcDAtC24oqFke/YMB6GEjOE+1X+q4ZHirueAo5eFpHB
         IMlBW5A+7VjFjbFkxp8nKxkxXtofuYIGnHLdHenevcPdwbQdfNubZQgSt+juj4U1ihqQ
         qoyHCtQQI6fH2oRVCgunyQNOePlNOQ/K56k10Ye7RX9r1Y9M1EGpU6kFXX1fvwctybo6
         7LSBNKMNjgwy/lad72lUm0wdA23Ytj/1ZOO85qHFYeTTQaMpT7hFOIw67EW+HkQXkAbf
         A+bg==
X-Gm-Message-State: ANhLgQ3wPAqccXeu3ujZ+goevAmbep64RYzxpsQgbZyMHxhvnkCvanC0
        w6dtar/mKNzQv247pAIZMbMNsdfERfXBT7FMRE8Py5e8TlX1
X-Google-Smtp-Source: ADFU+vszNHfESmANhggvCujeZijt/jiQU/OqttiEYWULD0g88JMltQ686sxPnonItDyeMlLJfLJPdRvN4SRh
X-Received: by 2002:a5d:52d0:: with SMTP id r16mr6758202wrv.379.1584463810086;
        Tue, 17 Mar 2020 09:50:10 -0700 (PDT)
Received: from mail.besancon.parkeon.com ([185.149.63.251])
        by smtp-relay.gmail.com with ESMTPS id r5sm64059wrt.7.2020.03.17.09.50.09
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Tue, 17 Mar 2020 09:50:10 -0700 (PDT)
X-Relaying-Domain: flowbird.group
Received: from [172.16.13.134] (port=56876 helo=PC12445-BES.dynamic.besancon.parkeon.com)
        by mail.besancon.parkeon.com with esmtp (Exim 4.71)
        (envelope-from <martin.fuzzey@flowbird.group>)
        id 1jEFPt-0000dJ-Ml; Tue, 17 Mar 2020 17:50:09 +0100
From:   Martin Fuzzey <martin.fuzzey@flowbird.group>
To:     Fugang Duan <fugang.duan@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        linux-kernel@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        devicetree@vger.kernel.org
Subject: [PATCH 3/4] dt-bindings: fec: document the new fsl,stop-mode property
Date:   Tue, 17 Mar 2020 17:50:05 +0100
Message-Id: <1584463806-15788-4-git-send-email-martin.fuzzey@flowbird.group>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1584463806-15788-1-git-send-email-martin.fuzzey@flowbird.group>
References: <1584463806-15788-1-git-send-email-martin.fuzzey@flowbird.group>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This property allows the appropriate GPR register bit to be set
for wake on lan support.

Signed-off-by: Martin Fuzzey <martin.fuzzey@flowbird.group>
---
 Documentation/devicetree/bindings/net/fsl-fec.txt | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/fsl-fec.txt b/Documentation/devicetree/bindings/net/fsl-fec.txt
index 5b88fae0..bd0ef5e 100644
--- a/Documentation/devicetree/bindings/net/fsl-fec.txt
+++ b/Documentation/devicetree/bindings/net/fsl-fec.txt
@@ -19,6 +19,11 @@ Optional properties:
   number to 1.
 - fsl,magic-packet : If present, indicates that the hardware supports waking
   up via magic packet.
+- fsl,stop-mode: register bits of stop mode control, the format is
+		 <&gpr reg bit>.
+		 gpr is the phandle to general purpose register node.
+		 reg is the gpr register offset for the stop request.
+		 bit is the bit offset for the stop request.
 - fsl,err006687-workaround-present: If present indicates that the system has
   the hardware workaround for ERR006687 applied and does not need a software
   workaround.
-- 
1.9.1

