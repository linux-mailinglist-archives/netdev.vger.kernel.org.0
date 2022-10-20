Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87A26605B5F
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 11:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229841AbiJTJl3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 05:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbiJTJl0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 05:41:26 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 390F7191D76
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 02:41:19 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id f9so1331917plb.13
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 02:41:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lu/Q+My0d0ZJp0MXkrJy5vys7anyhTLA0nDtYHB/OvM=;
        b=MiQBa8dSIOH7lGMIZBxpa/IvxMnz2uilvJw1Kj18eKcdSUsIWkBVa/lrpjUqS0Y8DM
         1uI5PcezLwNguOyeofuwoTBlMhNH2MsNh4YkOyYkO9EPls54jmHXADSZ4pa7nwQvMas0
         WKGlyFbjrsIDfFUKOrN6Tz8cSZBO7pE+c1GCcxkO++9NCN2AcpezGwB6ZnEs7rfDEyBt
         cxiEIE1MC8w5qaGkt5kIsvmqNBrDDCv1LYiF7HjmAHYggCkJfuG9sLphm+6QJj51Hxb2
         aaIFxNYDxECx94C7eTRy5dWr0QdjTvt5pNkECQy8hRor8ARz8SbT2UML0Tlb+/rXYz0/
         DNmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lu/Q+My0d0ZJp0MXkrJy5vys7anyhTLA0nDtYHB/OvM=;
        b=e37li/L3my9st/fD3upODicHxEpnn97dnEsmZTNyEAvOShJPyAfiAHtCUAQkffLKRl
         z+3wTx3eH45xJ653Bgob5yQhdjhj3KqTumnWFbqeVrUe0gFL2KMsTWPzbhhgCWPFSHKc
         IffkEI/xZv19G79INljc5eQsHTwIQmEtk0Vbi54SjscM5C+21xEBI9H8yJDVv6uAZLMd
         HSp+sCbzyQ5PWNPcBLFutX0bRTCF72m8aHAO3pRIu6JueYyPKqkkKZX3+UXy7nTghQrk
         1BEvCjvp4cag9icFU8YMojFLP4j4nTYd/TFxGqRU+YvqMFPIn/GSfrq729ivFq9mCHKW
         Kymw==
X-Gm-Message-State: ACrzQf10S23+xyVVQJbJ0KVAhEcNIBLHms9rDMgoTPE7cY2BFWZt1Me0
        Drfj8RhC/o3B2yebs+SEV6x2MNvzjH5hTg==
X-Google-Smtp-Source: AMsMyM5yclQegyW9oOtG584tPYotVoNT59Ds9iM06q8wifMIcgH0xMo6fym+G8TEFKV/xTR+zIOlGg==
X-Received: by 2002:a17:90a:e548:b0:211:2c0c:cb74 with SMTP id ei8-20020a17090ae54800b002112c0ccb74mr4631912pjb.69.1666258878720;
        Thu, 20 Oct 2022 02:41:18 -0700 (PDT)
Received: from archlinux.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id o12-20020a170902d4cc00b0016d9d6d05f7sm12425675plg.273.2022.10.20.02.41.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 02:41:18 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     davem@davemloft.net, kuba@kernel.org, michal.simek@xilinx.com,
        radhey.shyam.pandey@xilinx.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org,
        pabeni@redhat.com, edumazet@google.com, andy.chiu@sifive.com,
        greentime.hu@sifive.com
Subject: [PATCH net-next 2/2] dt-bindings: add mdio frequency description
Date:   Thu, 20 Oct 2022 17:41:06 +0800
Message-Id: <20221020094106.559266-3-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20221020094106.559266-1-andy.chiu@sifive.com>
References: <20221020094106.559266-1-andy.chiu@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a property to set mdio bus frequency at runtime by DT.

Signed-off-by: Andy Chiu <andy.chiu@sifive.com>
Reviewed-by: Greentime Hu <greentime.hu@sifive.com>
---
 Documentation/devicetree/bindings/net/xilinx_axienet.txt | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/xilinx_axienet.txt b/Documentation/devicetree/bindings/net/xilinx_axienet.txt
index 1aa4c6006cd0..d78cf402aa2a 100644
--- a/Documentation/devicetree/bindings/net/xilinx_axienet.txt
+++ b/Documentation/devicetree/bindings/net/xilinx_axienet.txt
@@ -43,6 +43,9 @@ Optional properties:
 		  support both 1000BaseX and SGMII modes. If set, the phy-mode
 		  should be set to match the mode selected on core reset (i.e.
 		  by the basex_or_sgmii core input line).
+- xlnx,mdio-freq: Define the clock frequency of the MDIO bus. If the property
+		  does not pressent on the DT, then the mdio driver would use
+		  the default 2.5 MHz clock, as mentioned on 802.3 spc.
 - clock-names: 	  Tuple listing input clock names. Possible clocks:
 		  s_axi_lite_clk: Clock for AXI register slave interface
 		  axis_clk: AXI4-Stream clock for TXD RXD TXC and RXS interfaces
-- 
2.36.0

