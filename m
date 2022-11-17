Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2F362E029
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 16:41:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239708AbiKQPlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 10:41:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239679AbiKQPkq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 10:40:46 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB417E0F5
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 07:40:44 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id 140so2126729pfz.6
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 07:40:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YXBE4c0bQF7I0eIkv6UTkINV8n+xSb5KU8CMf36EQc4=;
        b=A9PnsiwrtqXW7VqZVjrvvqZT846udynLXca2Pet2RXbhQbWlscxz2JayEN2gLe7AMN
         pw7qAsdYUU5cIQi2d4QzuSMSK2Ts17mvhEHQH+dM/WI20bWgzKAMV4Laq5ejABpyXVKi
         wvsApRNZNzkNGPv5xZ906Byh2+j4hI2BUdkEttArIR5xxOw9H1FMh+EZZTh5t1fkQloj
         OHaGhOJuZ70eGIl+SOE/JxH8y9981JInhpVABuZfoD84vGwnizGtlB1En6R4kEkvhyHD
         Wvt0QXGWeF6m1tQSNGzpLRuNF/g9FSkqWxFSp4bXJ44cPvwIRrlalMnbg+7C7kJ4qBKV
         CgBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YXBE4c0bQF7I0eIkv6UTkINV8n+xSb5KU8CMf36EQc4=;
        b=W2RNQukHVNQ/flTL1joJrRou4ZglZzbczkb9tLAyrI5T254YhDGZJmTSX9WUeJlKLX
         modSUmiNzXryPZBwyFwyjnQZja/DT4P2DD2A2zyN4T6T+EIKuS2c4j0ss6WItxhAaRnT
         gfYf5IV7Ewa1PaoNlA+7vYGeUiNIRNcmGVNnlH6ZRgJzPCno06qBLt6drnvzpVcTnij+
         Kus6BDK4MIeZXAFCwfArLos/axUy+Zh+p039NYrUHhlUhDFtXBlw6hmsrVXL66+7d+C5
         WoY6RStSMcqWCEv9Z45Lkhl+MoJOcAEVmyES0lLXYN8qiSkME2I7BoRv5gnmm1tWqPUX
         //MQ==
X-Gm-Message-State: ANoB5pksDOmEnJIjCrFu8WzYtyhVE+KxqzoWoz+VeemNHzbRpXa0d5k3
        Zhs2Xxi0X6AbhL5URtaMN9xeEw==
X-Google-Smtp-Source: AA0mqf5FiR6os7pqdyAZOlRNU3CP+OUehkfh4DYsNgwXw973Q0Oy5B78sXOQ5oJ34gUFxHvIWVqUaw==
X-Received: by 2002:a62:3181:0:b0:572:149c:e1ba with SMTP id x123-20020a623181000000b00572149ce1bamr3544364pfx.19.1668699644463;
        Thu, 17 Nov 2022 07:40:44 -0800 (PST)
Received: from archlinux.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id b7-20020aa79507000000b0056bcfe015c9sm1252363pfp.204.2022.11.17.07.40.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 07:40:44 -0800 (PST)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     davem@davemloft.net, andrew@lunn.ch, kuba@kernel.org,
        michal.simek@xilinx.com, radhey.shyam.pandey@xilinx.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, robh+dt@kernel.org,
        pabeni@redhat.com, edumazet@google.com, andy.chiu@sifive.com,
        greentime.hu@sifive.com, Rob Herring <robh@kernel.org>
Subject: [PATCH v5 net-next 2/3] dt-bindings: describe the support of "clock-frequency" in mdio
Date:   Thu, 17 Nov 2022 23:40:13 +0800
Message-Id: <20221117154014.1418834-3-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20221117154014.1418834-1-andy.chiu@sifive.com>
References: <20221117154014.1418834-1-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mdio bus frequency is going to be configurable at boottime by a property
in DT now, so add a description to it.

Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Reviewed-by: Greentime Hu <greentime.hu@sifive.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Acked-by: Rob Herring <robh@kernel.org>
---
 Documentation/devicetree/bindings/net/xilinx_axienet.txt | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/xilinx_axienet.txt b/Documentation/devicetree/bindings/net/xilinx_axienet.txt
index 1aa4c6006cd0..80e505a2fda1 100644
--- a/Documentation/devicetree/bindings/net/xilinx_axienet.txt
+++ b/Documentation/devicetree/bindings/net/xilinx_axienet.txt
@@ -68,6 +68,8 @@ Optional properties:
  - mdio		: Child node for MDIO bus. Must be defined if PHY access is
 		  required through the core's MDIO interface (i.e. always,
 		  unless the PHY is accessed through a different bus).
+		  Non-standard MDIO bus frequency is supported via
+		  "clock-frequency", see mdio.yaml.
 
  - pcs-handle: 	  Phandle to the internal PCS/PMA PHY in SGMII or 1000Base-X
 		  modes, where "pcs-handle" should be used to point
-- 
2.36.0

