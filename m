Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7575FDE83
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 18:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbiJMQwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 12:52:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiJMQwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 12:52:32 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC0110A7C4
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 09:52:30 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id j4so3457719lfk.0
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 09:52:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=J7z7cCyCHDIzHVx45lHOsuFvxs9CIE7teOYxW0OHgas=;
        b=nhMy6r5YlIFKjYT/AOd96gSZqy7OL8OYB3egyaXHDqF6b6YSBZ4SVY+uMQiuGw66+Z
         vw0KpfpnijRyaIAPqn/Fb3EFaOKkNOfhV03uGCrLnRbc7RMsumK0lgFDIioxXxKJECUD
         soFWBjqV9I++zzWc4cL63ecm0hiyK51qOSL9BTsTp2HuzJDHKSbIiMwjtGHTx9l+6FdJ
         pbNv+can8rj6bpLJKY6Xaw4mRPl6LfTfp8oBq1kkR/MxZ7ocYJA8DlJSrqzfZrutQrra
         V6Fo1CZ2YwVKU1dFHaD3IoQ65pxc6PbnafbfTqUCK64wDzZGteZTOYUSqzjfs0gygrd0
         MLmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J7z7cCyCHDIzHVx45lHOsuFvxs9CIE7teOYxW0OHgas=;
        b=D5RBVMpJWmIJtRjWCVKmJi4+c4CzfZshpbRDuj2zj7KLERebOZxG2nFfg4kkh+BZ8H
         7VO987C8NUbeVatEWLI2QxLPBDft037k64VG3uJPthe2iF3nIKrLuCT6aSjDN4UblO/x
         DkCiD/5uGdlqQY93sM/daxUST3tsqL4d4xZOYsGchEvvRA1p1HLSOMgJ8Jketo8yr4y5
         PLY9rG/EuHVAoCgRZNDskhmG4mQ+YSGMIcu+b/j4F5SUcza8pY+IRBLCzaK+3ETc0EaA
         r7H/l4PZfygKZ34S5PWPGjNocmghu6D/Mldf2K7LNzLkQan4tuik3JQTtHcljYFtvEg4
         cFuQ==
X-Gm-Message-State: ACrzQf3zqlnHY4BCnIsR+ueleg5s++XIkHtYjcUNheIoG2ve2LmKEqu6
        fnaWmKiNd319N2dO61jvJ85tOA==
X-Google-Smtp-Source: AMsMyM5VTqEH2JfRbXjT227CROHnUMC2UyrNnrJOUYPv74Srq4t4JVaEZCQGJXDsmBdzWuIXZBgv/g==
X-Received: by 2002:a05:6512:3a8b:b0:4a2:5155:dca5 with SMTP id q11-20020a0565123a8b00b004a25155dca5mr210801lfu.70.1665679946834;
        Thu, 13 Oct 2022 09:52:26 -0700 (PDT)
Received: from fedora.. ([78.10.206.53])
        by smtp.gmail.com with ESMTPSA id k7-20020a2e9207000000b00262fae1ffe6sm540752ljg.110.2022.10.13.09.52.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 09:52:26 -0700 (PDT)
From:   =?UTF-8?q?Micha=C5=82=20Grzelak?= <mig@semihalf.com>
To:     devicetree@vger.kernel.org
Cc:     mw@semihalf.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        upstream@semihalf.com,
        =?UTF-8?q?Micha=C5=82=20Grzelak?= <mig@semihalf.com>
Subject: [PATCH v4 0/3] marvell,pp2.yaml and .dtsi further improvements
Date:   Thu, 13 Oct 2022 18:51:31 +0200
Message-Id: <20221013165134.78234-1-mig@semihalf.com>
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

This patch series deprecates port-id in comparison to previous patches
and moves $ref:ethernet-controller.yaml to subnodes. Furthermore, it
adds phys: as an optional property of a subnode because of adding
unevaluatedProperties: false.

Best regards,
Michał

---
Changelog:
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

 .../devicetree/bindings/net/marvell,pp2.yaml  | 288 ++++++++++++++++++
 .../devicetree/bindings/net/marvell-pp2.txt   | 141 ---------
 MAINTAINERS                                   |   2 +-
 arch/arm/boot/dts/armada-375.dtsi             |  12 +-
 arch/arm64/boot/dts/marvell/armada-cp11x.dtsi |  17 +-
 5 files changed, 308 insertions(+), 152 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/marvell,pp2.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/marvell-pp2.txt

-- 
2.37.3

