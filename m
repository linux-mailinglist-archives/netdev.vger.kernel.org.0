Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB8BE19C31B
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 15:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732847AbgDBNvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 09:51:36 -0400
Received: from mail-wr1-f99.google.com ([209.85.221.99]:40937 "EHLO
        mail-wr1-f99.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732625AbgDBNvg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 09:51:36 -0400
Received: by mail-wr1-f99.google.com with SMTP id s8so2150267wrt.7
        for <netdev@vger.kernel.org>; Thu, 02 Apr 2020 06:51:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=flowbird.group; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1/pNS0FhaTO2BgGmZP8T3UuHjqYyNV8AcJR7abT3rIo=;
        b=NrQV2I3WGCGDBwf39bLMjY/gJ3ZGaxu/25t4RsjbQlMP1hM+a9Rs0fv2OGzKrng000
         Ijj7S0a1l0ydJIr1HpLVrjcosb1USFHWv/pF3/FGhiVsFC28eUUQnHzQ2/nFiU8NbAoT
         K6Ggkm2p5xK+06QSo3qKyo9ccs5ohdd3MlpFHovgbHJP291/gmglvBntq07kvn7y0Oq2
         yX2Wd18LQTGwillvDPbtjRimSezxm9m29d/wnV9iYZYDTFRF0YqekPq/H7gp+U5gyQTq
         Os8BWEcLu4E26fi0mUu4m+otJGATxbBbL1IH6I2JC6zENzVK8DSQebfeCHVT+a/WnYHE
         aReg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=1/pNS0FhaTO2BgGmZP8T3UuHjqYyNV8AcJR7abT3rIo=;
        b=Vl8uhYMacnRLrS+1hkQTv/UwUhd6ohrFMFh/w7EXSkLZNDHy6vpcn4Z6aiTX0oTTzU
         981N+CsnOhIBx4/lmKZ0OTUwVniUhzEPm1+2u7tjzHgYqXE/yBgcm70mKhYWVBCpxjrB
         YVVrQRU4fKHsglYHjhUVIxuyfWRuc6t5Pr4ohW8kY7uf7Gk9oMjaynvTbH2EHVEXtbcO
         zykk/lssp6dSUttCFxVSTDgKt2NjL7VR2LIq63cvbSjLY5obWeWaiT7648zWxPTMsisv
         UfLy8P27fZzyiznC5YQtf0YdIBZo1UtMve8HkGdWB9I0yO3kamByQL9N+7iWBlmlY1LM
         JUMA==
X-Gm-Message-State: AGi0PuawMr9Zb++wjWqo1LQURDWXRl51eXYzwuablgLoU1UNPEGF9RCq
        /5Lxf2V/Xc6nl0H/OKvTeiPwyUJ1AMtOMciDctGC5JmDsmpJ
X-Google-Smtp-Source: APiQypJY9EzxmH/Jgql516W/Q2BkMW7gK2obhxiqK/xRfP2uO4FmrgIw/rVDr58Q5fzfT0BFGHdSNLTpzXJs
X-Received: by 2002:adf:a457:: with SMTP id e23mr3650108wra.21.1585835493748;
        Thu, 02 Apr 2020 06:51:33 -0700 (PDT)
Received: from mail.besancon.parkeon.com ([185.149.63.251])
        by smtp-relay.gmail.com with ESMTPS id v63sm64490wma.16.2020.04.02.06.51.33
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Thu, 02 Apr 2020 06:51:33 -0700 (PDT)
X-Relaying-Domain: flowbird.group
Received: from [172.16.12.10] (port=55896 helo=PC12445-BES.dynamic.besancon.parkeon.com)
        by mail.besancon.parkeon.com with esmtp (Exim 4.71)
        (envelope-from <martin.fuzzey@flowbird.group>)
        id 1jK0Fp-0001KP-3T; Thu, 02 Apr 2020 15:51:33 +0200
From:   Martin Fuzzey <martin.fuzzey@flowbird.group>
To:     Fugang Duan <fugang.duan@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        linux-kernel@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        devicetree@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v3 3/4] dt-bindings: fec: document the new gpr property.
Date:   Thu,  2 Apr 2020 15:51:29 +0200
Message-Id: <1585835490-3813-4-git-send-email-martin.fuzzey@flowbird.group>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1585835490-3813-1-git-send-email-martin.fuzzey@flowbird.group>
References: <1585835490-3813-1-git-send-email-martin.fuzzey@flowbird.group>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This property allows the gpr register bit to be defined
for wake on lan support.

Signed-off-by: Martin Fuzzey <martin.fuzzey@flowbird.group>
Reviewed-by: Fugang Duan <fugang.duan@nxp.com>
Acked-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/net/fsl-fec.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/fsl-fec.txt b/Documentation/devicetree/bindings/net/fsl-fec.txt
index 5b88fae0..ff8b0f2 100644
--- a/Documentation/devicetree/bindings/net/fsl-fec.txt
+++ b/Documentation/devicetree/bindings/net/fsl-fec.txt
@@ -22,6 +22,8 @@ Optional properties:
 - fsl,err006687-workaround-present: If present indicates that the system has
   the hardware workaround for ERR006687 applied and does not need a software
   workaround.
+- gpr: phandle of SoC general purpose register mode. Required for wake on LAN
+  on some SoCs
  -interrupt-names:  names of the interrupts listed in interrupts property in
   the same order. The defaults if not specified are
   __Number of interrupts__   __Default__
-- 
1.9.1

