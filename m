Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E44635FBB12
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 21:07:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbiJKTHB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 15:07:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiJKTHA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 15:07:00 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21DD14DB6C
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 12:06:58 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id f37so22526636lfv.8
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 12:06:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yTgWeajzUik/wX4AtUecfU2eGL0YO972G/Xn1vBhwCM=;
        b=sy+hXByYVLz567exgGzOBYbvpi87ZeK3JuTTIRD/XGsigG63/rzDJpfDhgwQpACfjW
         9zvKR4pi5JBiecW3anJCDGc5gpPWlwCP+WDdwi8m8FDXEW/PoafGD3WLfB6kx5T84Cuk
         jyjosHjfxtbEWxME5lxRLOJ7936qQohvAgMZsXhsf91cgKHOCDEhT1yrLMtSlzYITu9s
         5Aknas5QZtBiYJlvF/Z+YgO/I2J1S+LRrNNQRiKLgk8IP7gGpC/4S4F//dNJ+7w2KHqt
         1PmZ7nMDqO03JVxjjyFVLMoCzNlEahdxNJJv5uQfWcusKzV5w2Xurev9gqXxtaxm2W+U
         D43g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yTgWeajzUik/wX4AtUecfU2eGL0YO972G/Xn1vBhwCM=;
        b=ax+0CnEl2cRAcv1olQPQP0gLhBDmaOY10PtQjjJJSKUlUphxzijeI5crpKNeuZ5Zjn
         Xuv0NO6MOH0VlBRP7O0LfJerFcaG4EK57isEuVAJ18ygcYOgYdjUKG522gDdViJcFnkm
         TojQwY7zPIDxnLs92b7Oe1GpzhQ3+eIV30/c901HykaI6Q9MA2lfpPVWKIyPxICaRjUf
         xT1GlZ/OfIU/uT7KcFJvumPgzTBr53luo+MwoSs9CTofbY3Nw+mqUnlBl/evrx1UD7sq
         rFSksFnkxrJln0pVCpkgS22icPTshDYT+LN/cCCCDQ65B46miaMjzucGadnUy9COZcMj
         X6EQ==
X-Gm-Message-State: ACrzQf2RTG0QS8/nGmz8DFbBrVUOVo+SJM8YQMGBmqcLtfya93Qd7ALh
        +Oe2HRyHcIBVwsvZ7DaNdWz9PQ==
X-Google-Smtp-Source: AMsMyM69LHz4pad3omDX9Ac0rmEAZ9RxnAPNWESsNWh5VOrfr0q9zt/MscFu3WmDdQeXYD16XsAEDQ==
X-Received: by 2002:ac2:551d:0:b0:4a2:7c75:6e37 with SMTP id j29-20020ac2551d000000b004a27c756e37mr9656913lfk.398.1665515216393;
        Tue, 11 Oct 2022 12:06:56 -0700 (PDT)
Received: from michal-H370M-DS3H.office.semihalf.net ([83.142.187.84])
        by smtp.googlemail.com with ESMTPSA id p9-20020a2eb7c9000000b00262fae1ffe6sm2270477ljo.110.2022.10.11.12.06.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Oct 2022 12:06:56 -0700 (PDT)
From:   =?UTF-8?q?Micha=C5=82=20Grzelak?= <mig@semihalf.com>
To:     devicetree@vger.kernel.org
Cc:     mw@semihalf.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        upstream@semihalf.com,
        =?UTF-8?q?Micha=C5=82=20Grzelak?= <mig@semihalf.com>
Subject: [PATCH v3 0/3] marvell,pp2.yaml and .dtsi improvements
Date:   Tue, 11 Oct 2022 21:06:10 +0200
Message-Id: <20221011190613.13008-1-mig@semihalf.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This patch series introduces changes of port names from ethX to 
ethernet-port@X in all relevant .dtsi files. It includes also all
considerations from thread about v2. 

Would appreciate if you had time to review that version.

Best regards,
Michał

---
Changelog:
v2->v3
- move 'reg:description' to 'allOf:if:then'
- change '#size-cells: true' and '#address-cells: true'
  to '#size-cells: const: 0' and '#address-cells: const: 1'
- replace all occurences of pattern "^eth\{hex_num}*"
  with "^(ethernet-)?port@[0-9]+$"
- add description in 'patternProperties:^...'
- add 'patternProperties:^...:interrupt-names:minItems: 1'
- add 'patternProperties:^...:reg:description'
- update 'patternProperties:^...:port-id:description'
- add 'patternProperties:^...:required: - reg'
- update '*:description:' to uppercase
- add 'allOf:then:required:marvell,system-controller'
- skip quotation marks from 'allOf:$ref'
- add 'else' schema to match 'allOf:if:then'
- restrict 'clocks' in 'allOf:if:then'
- restrict 'clock-names' in 'allOf:if:then'
- add #address-cells=<1>; #size-cells=<0>; in 'examples:'
- change every "ethX" to "ethernet-port@X" in 'examples:'
- add "reg" and comment in all ports in 'examples:'
- change /ethernet/eth0/phy-mode in examples://Armada-375
  to "rgmii-id"
- replace each cpm_ with cp0_ in 'examples:'
- replace each _syscon0 with _clk0 in 'examples:'
- remove each eth0X label in 'examples:'
- update armada-375.dtsi and armada-cp11x.dtsi to match
  marvell,pp2.yaml

v1->v2
- move 'properties' to the front of the file
- remove blank line after 'properties'
- move 'compatible' to the front of 'properties'
- move 'clocks', 'clock-names' and 'reg' definitions to 'properties' 
- substitute all occurences of 'marvell,armada-7k-pp2' with
  'marvell,armada-7k-pp22'
- add properties:#size-cells and properties:#address-cells 
- specify list in 'interrupt-names'
- remove blank lines after 'patternProperties'
- remove '^interrupt' and '^#.*-cells$' patterns
- remove blank line after 'allOf'
- remove first 'if-then-else' block from 'allOf'
- negate the condition in allOf:if schema
- delete 'interrupt-controller' from section 'examples'
- delete '#interrupt-cells' from section 'examples'

Marcin Wojtas (2):
  arm64: dts: marvell: Update network description to match schema
  ARM: dts: armada-375: Update network description to match schema

Michał Grzelak (1):
  dt-bindings: net: marvell,pp2: convert to json-schema

 .../devicetree/bindings/net/marvell,pp2.yaml  | 286 ++++++++++++++++++
 .../devicetree/bindings/net/marvell-pp2.txt   | 141 ---------
 MAINTAINERS                                   |   2 +-
 arch/arm/boot/dts/armada-375.dtsi             |  12 +-
 arch/arm64/boot/dts/marvell/armada-cp11x.dtsi |  17 +-
 5 files changed, 306 insertions(+), 152 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/marvell,pp2.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/marvell-pp2.txt

-- 
2.25.1

