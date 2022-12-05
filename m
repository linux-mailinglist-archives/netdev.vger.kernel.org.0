Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95CB66436B6
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 22:23:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233114AbiLEVXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 16:23:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230100AbiLEVXr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 16:23:47 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 178B9240AD;
        Mon,  5 Dec 2022 13:23:47 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id d3so12046132plr.10;
        Mon, 05 Dec 2022 13:23:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Oqw42TAUE/YjCYP3ea6wZv0qMyuIlb809z0kPS2OjGs=;
        b=JqkVPPUtlEvwJH9hNkzmERSCuPsycqZ4Nonb2GJZ4fnDUW8wAD45oIvSXGsX7CMxxX
         bdZeW0j9NQUkzXTsrDVpWsF+MP1J6HsyHsSGksh5qguXsAw3BRSNA0b8NXCUGO6SEI0h
         yiwER9nO1QzVUuGMjn1TbBExW/2Vz+jncI+kdHmZjq1R3CxIPW9ERxbad1yicKCGnU2d
         QomOc+zWh5+aWGbHHVpOxCTdFvXt6+dn0ylZXCy6/lcS3mh+J+ATVAPUv2sh7QqBMX1i
         jItaOXASi2IEEHa5xk7PTzemAU9wnmH9uaofVm5zyckpEunAH+/glfnoxhwCHwmGihZU
         BERw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Oqw42TAUE/YjCYP3ea6wZv0qMyuIlb809z0kPS2OjGs=;
        b=MVpfcFv0b8sEQU+OsX62PSdZzrgxcInbU2SB5fApgrX4/Jr9htz37v9WUifoE5hhw4
         wgOJ2eCHhnPqS5Fc5WsYSum5463RCjBXxLdogq+0t7HTNjEkoJXu7jOqm3cbEQNKTE+X
         WLU9kSv/AD/8/HzEbrhMQhHTN/prz1iq5AZ+1SM5nKgoJKBwgxLSVMGgNrlh+CpRi9z1
         SmI2fLkKdE6DU3n+1twKCa3QNfMnTHY/DuiFZDchIWUtsHrDy1kh0a2GJ/J4tbHRoyO3
         bJj5AiZt1BacP5HA4uIf719KwOomrBYnb34g2E1uXk00ydAOoCTGKZ8lg7pDkpx3z8if
         uN5A==
X-Gm-Message-State: ANoB5pmGZoQKwGvihrFkKBdaow23NPT476vZIQaFUisstkYFD3BVFQI/
        MX6DtnUQ34TW5n5OE8cvwuARi2iLe96eog==
X-Google-Smtp-Source: AA0mqf4TRoFef9dAkjio+oQlREb9eLb0nDBwFsWGmKK3Xoc35/cWfiLvLYe9e6VSdk9p+UbnMohRmg==
X-Received: by 2002:a17:902:8604:b0:186:fe2d:f3cb with SMTP id f4-20020a170902860400b00186fe2df3cbmr70106898plo.132.1670275426148;
        Mon, 05 Dec 2022 13:23:46 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y2-20020a17090264c200b00189348ab156sm4029270pli.283.2022.12.05.13.23.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 13:23:45 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>,
        NXP Linux Team <linux-imx@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        linux-kernel@vger.kernel.org (open list:IRQCHIP DRIVERS),
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/FREESCALE IMX
        / MXC ARM ARCHITECTURE)
Subject: [PATCH net 0/2] Update Joakim Zhang entries
Date:   Mon,  5 Dec 2022 13:23:38 -0800
Message-Id: <20221205212340.1073283-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Shawn, since you are the i.MX maintainer I added you and the NXP Linux
Team as the de-facto maintainers for those entries, however there may be
other people to list, thanks!

Florian Fainelli (2):
  MAINTAINERS: Update NXP FEC maintainer
  dt-bindings: FEC/i.MX DWMAC and INTMUX maintainer

 .../devicetree/bindings/interrupt-controller/fsl,intmux.yaml   | 3 ++-
 Documentation/devicetree/bindings/net/fsl,fec.yaml             | 3 ++-
 Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml       | 3 ++-
 MAINTAINERS                                                    | 3 ++-
 4 files changed, 8 insertions(+), 4 deletions(-)

-- 
2.34.1

