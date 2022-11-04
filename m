Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F20AD6190A4
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 07:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbiKDGDg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 02:03:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230405AbiKDGDY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 02:03:24 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A319EFD3
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 23:03:21 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id b21so3984339plc.9
        for <netdev@vger.kernel.org>; Thu, 03 Nov 2022 23:03:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y76ZfgfBJidUYPCMV+vRUvTiWIMgw/TUrl068PoooHY=;
        b=PE/rENiTU+6qsRgooGFqIGfkwz2L9wEXrvqXli/0gaQtG5+Hy2HVVo0ZbBe1EUkpt9
         M0lZgYU1IQKQCdlLLOzp80AH2McXyRT/z+hIFvxhHjGHJuRpERqpZoCFbtHoj5QhMOiL
         tQkDX66ndvJi9kTGT16MSRWJA52i/Uv6LaNW6fqEl8VtT5WXkkvruDPY1VG7kd/HUIg/
         zwNl9dIFkSjkTDgNyZf3HQ7RCvdaK0rGylgHpvWWQmn2fEFqrO7UWAckGPBASb/YSsvj
         fqFNqbIHQnjqfsMpvV6qOrge5bypTPerxbBaGvLsfRa89zCLSOmVh3NGFPQcKvESRmHK
         I/XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y76ZfgfBJidUYPCMV+vRUvTiWIMgw/TUrl068PoooHY=;
        b=P9HZrX3NEDBaSpzAqCmtIsdjEFhq11Fb1IDsdW8NG2n6iWcKn+9KMkeJXUjWFXYal/
         b4TqYOhItt9lb76YLQvfzj+VQnozVh2p6YkJhgdH9XPogzCpStalmw+PDavC7tow0U99
         FJYMv1FcYpgqk9WHnECcFZlIkdH+FY1cZ2gx/y5cmb1dWlQFIizZQxD0UYeDb2g54spk
         wPcfkfXgngOtJiXF0GS5RpDig1oDi31wXNjp09XIuGw0X4yOCeVFk3wNG+MKeHXkHe88
         7TPp/2cH8kGTgJw9+lQIxSJGRaADlhL085/G8aFcF1iRP3Je5QozPHXWEvsXgc7jFtOM
         ViIw==
X-Gm-Message-State: ACrzQf1c5uG+TvUwU7oKIYlHx9ZpJeIW6AujFz9cL84JDj0HZKtp71yB
        8eghOZJA+5SG0SehS5zG81sGYg==
X-Google-Smtp-Source: AMsMyM4xORzyTbUlrpibxiTu1Sv2vy1m4t8DS+3oatfq2ut0ihUkH8uzEoQUANg5DmMVbhJJiuOIeg==
X-Received: by 2002:a17:90b:2549:b0:212:84c:1e59 with SMTP id nw9-20020a17090b254900b00212084c1e59mr248307pjb.88.1667541800987;
        Thu, 03 Nov 2022 23:03:20 -0700 (PDT)
Received: from archlinux.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id f15-20020a170902684f00b00186bc66d2cbsm1727180pln.73.2022.11.03.23.03.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 23:03:20 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     davem@davemloft.net, andrew@lunn.ch, kuba@kernel.org,
        michal.simek@xilinx.com, radhey.shyam.pandey@xilinx.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, robh+dt@kernel.org,
        pabeni@redhat.com, edumazet@google.com, andy.chiu@sifive.com,
        greentime.hu@sifive.com, Rob Herring <robh@kernel.org>
Subject: [PATCH v3 net-next 3/3] dt-bindings: describe the support of "clock-frequency" in mdio
Date:   Fri,  4 Nov 2022 14:03:05 +0800
Message-Id: <20221104060305.1025215-4-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20221104060305.1025215-1-andy.chiu@sifive.com>
References: <20221104060305.1025215-1-andy.chiu@sifive.com>
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

mdio bus frequency can be configured at boottime by a property in DT
now, so add a description to it.

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

