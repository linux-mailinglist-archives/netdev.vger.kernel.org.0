Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C37A5FF576
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 23:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbiJNVdm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 17:33:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbiJNVdl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 17:33:41 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE5741DD893
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 14:33:38 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id g1so9119295lfu.12
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 14:33:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mW/7734DTN1y7Y84OiEwHnT+yRfPOMTAoIPWG7Voljw=;
        b=PgFR0tEGuo3vVa/CnuAlTPfOfTELLs3aGGGMb9IXzOYePq3nCpO5+4OEsvz/kOxF2A
         79yQVzo+NK/ltxBghNxezmA0alKaNFReFj3T8+RFNiORJuxO3asWB+7FGcXOsRaR6CKH
         fJmaks9zQNjnFeWRiBDyNKdpuS3Aar4YMYhPW6RuHbCjl2krHzMquR6LAKzC+F2+1G2c
         hC9vZgo0cJ4twjeTA/Giah3yGE5G79sjV69EF8OuDdoHR4OsCecddgyMDtWdSWwrGVxb
         QvxttGQ1CCNtrHgV5I+XXWlfcv0EMsTVL0XQdisXmRp7S2YaZA7eJqlE4Q71mGypaJ8x
         vyEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mW/7734DTN1y7Y84OiEwHnT+yRfPOMTAoIPWG7Voljw=;
        b=LOHHFaPAXW4R7uejdycZNHCOSX7LRBGBEEyV6WpitwKqJwfBJ17G3zIBWTbw5ZELki
         0J6koV7z/iJlX/pMt8gsdpCCe3p5znXNFsLNUeCoGidH96998lmVkYuXG2gM2p4AKcrF
         o0sR/wg5WR0M9yO/6x4G2xtpQeYrh0hK1K5iGvL47LricAtkpYBB8jlpN1803mN7mJHx
         jMe3sghlDJvmkh2UEgrWy7ZcnXc0yLzEVVQ21YrYxgH/yWavz3+DBoy8NwIK60ASYd+8
         /Gk96GWPXkOJdKsxW1heSAnzIYZ2lOSwCu6nQrkZI0uZ3cmJiLlNofxJDzBv4KEDxk8D
         pjwA==
X-Gm-Message-State: ACrzQf0UIbqERWBhllvYXsZeZbJ1w0WX5/JEN74KpEmtI+iSHib1ZD2R
        PdWPqM5TYzyIRJeVMEEBQgY+eg==
X-Google-Smtp-Source: AMsMyM7GgugwNIIkfWkvLdGyp4sIaNYuvJRRWZgRBGTLjTUjCybeUUq9Ahem1s1muto2zKZqx17MiQ==
X-Received: by 2002:a05:6512:3e01:b0:4a2:5c6e:d88e with SMTP id i1-20020a0565123e0100b004a25c6ed88emr2604305lfv.431.1665783217299;
        Fri, 14 Oct 2022 14:33:37 -0700 (PDT)
Received: from fedora.. ([78.10.207.24])
        by smtp.gmail.com with ESMTPSA id d4-20020ac24c84000000b00494978b0caesm494036lfl.276.2022.10.14.14.33.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 14:33:36 -0700 (PDT)
From:   =?UTF-8?q?Micha=C5=82=20Grzelak?= <mig@semihalf.com>
To:     devicetree@vger.kernel.org
Cc:     mw@semihalf.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        upstream@semihalf.com,
        =?UTF-8?q?Micha=C5=82=20Grzelak?= <mig@semihalf.com>
Subject: [PATCH v5 0/3] further improvements to marvell,pp2.yaml
Date:   Fri, 14 Oct 2022 23:32:51 +0200
Message-Id: <20221014213254.30950-1-mig@semihalf.com>
X-Mailer: git-send-email 2.37.3
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

This patchset addresses problems with reg ranges and 
additional $refs. It also limits phy-mode and aligns examples.

Best regards,
Michał

---
Changelog:
v4->v5
- drop '+' from all patternProperties
- restrict range of patternProperties to [0-2] in top level
- drop the $ref in patternProperties:'^...':properties:reg
- add patternProperties:'^...':properties:reg:maximum:2
- drop $ref in patternProperties:'^...':properties:phys
- add patternProperties:'^...':properties:phys:maxItems:1
- limit phy-mode to the subset found in dts files
- reflect the order of subnodes' properties in subnodes' required:
- restrict range of pattern to [0-2] in marvell,armada-7k-pp22 case
- restrict range of pattern to [0-1] in marvell,armada-375-pp2 case
- align to 4 spaces all examples:
- add specified maximum to allOf:if:then-else:properties:reg

v3->v4
- change commit message of first patch
- move allOf:$ref to patternProperties:'^...':$ref
- deprecate port-id in favour of reg
- move reg to front of properties list in patternProperties
- reflect the order of properties in required list in
  patternProperties
- add unevaluatedProperties: false to patternProperties
- change unevaluated- to additionalProperties at top level
- add property phys: to ports subnode
- extend example binding with additional information about phys and sfp
- hook phys property to phy-consumer.yaml schema

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

 .../devicetree/bindings/net/marvell,pp2.yaml  | 305 ++++++++++++++++++
 .../devicetree/bindings/net/marvell-pp2.txt   | 141 --------
 MAINTAINERS                                   |   2 +-
 arch/arm/boot/dts/armada-375.dtsi             |  12 +-
 arch/arm64/boot/dts/marvell/armada-cp11x.dtsi |  17 +-
 5 files changed, 325 insertions(+), 152 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/marvell,pp2.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/marvell-pp2.txt

-- 
2.37.3

