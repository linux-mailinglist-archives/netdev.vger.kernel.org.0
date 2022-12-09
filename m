Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9557A648A7D
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 23:05:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbiLIWFg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 17:05:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbiLIWF3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 17:05:29 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F27BA4325;
        Fri,  9 Dec 2022 14:05:27 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id a9so6288111pld.7;
        Fri, 09 Dec 2022 14:05:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=R5ynP/kug7q9pvisedoLXtD7y5fa0EC9wG9eb6fGHjg=;
        b=bb74m5BSJQ//omkjVVZx2N4ZmFPglFGKQpnTSm5ecm6/WsdoMnvJ4ZsIoDwKkqvZ+/
         /rzLVreN2KKQm++UdqmgyN38aI1GitOh8+fhx8Y0u3U5lTT4n2pRT3SAj9oal0yXB/7e
         iDfXI1Cqj2e6ov2Q0V2a9PLndTspiezzKuWFZkmBfVI3XO+5IgNG40w82EB4ftvEgZGi
         SZoabTgCYdEiF/CgyJh+F8aFmp6acDaQpSsAgSHZwwoc+m5b0wLagT9lMQk6bDIHo2k7
         M6NY/TmJwnJ+1OcHNt7yu9Zh7wprXswsK0f9stQDSvHPYE/WNZr4d9U1AqWnfe01+wv3
         3msg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R5ynP/kug7q9pvisedoLXtD7y5fa0EC9wG9eb6fGHjg=;
        b=xu87XsJwYDQedg2qC83N+zjN7wBu0U6Cl5ANH+/+tpNiyVSRtSKqeJcNHbmBlzadeY
         JVz2cak/qujJHwhDrbsoq35eGZYmhb+eyZtg1C1EG3qTa0B35CIxYdDijqR1xGi8WRLC
         i5MtiLd61AXFqPFjyJtqfZWnxwBHAxdsBG1TEivCzsNUmCAuIwQXYQWkUGqN/XBrC3Xs
         PgrB8QZzJNyX1d4uJ051BhdNJqaoD7iqpQjiNZ7MtSHs6sTRr1QhMih7X/w3KYKJ3NfL
         sasRcCHN+V3A0LX+UbSJtsS6Nsy6y8JGUmns4Us/SxZXHjfRwd3F+mKvkMq6/p50QQ9V
         Qj/w==
X-Gm-Message-State: ANoB5plr0hhm/MtQ/oVtPGRsadmY3M9ZxcSt5AAUhyT8K93oZfhpXjuq
        7T6VGKl+6VFICmrToIkU6oOMABFkNjsZ+g==
X-Google-Smtp-Source: AA0mqf4k4NupC5ZbOGoH6Ln4InkCNtE7SubICKpaNMHFdttyqNvcBkYPfJEJjELgAcOIN/HOqqjjGw==
X-Received: by 2002:a17:90a:4f45:b0:219:aa98:ee9c with SMTP id w5-20020a17090a4f4500b00219aa98ee9cmr7360940pjl.19.1670623526183;
        Fri, 09 Dec 2022 14:05:26 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id h7-20020a17090ac38700b0021870b2c7absm1528096pjt.42.2022.12.09.14.05.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Dec 2022 14:05:25 -0800 (PST)
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
        / MXC ARM ARCHITECTURE), Clark Wang <xiaoning.wang@nxp.com>,
        Wei Fang <wei.fang@nxp.com>,
        Shenwei Wang <shenwei.wang@nxp.com>
Subject: [PATCH net v2 0/2] Update Joakim Zhang entries
Date:   Fri,  9 Dec 2022 14:05:17 -0800
Message-Id: <20221209220519.1542872-1-f.fainelli@gmail.com>
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

Changes in v2:

- update the maintainers entry per Clark Wang's recommendations

Florian Fainelli (2):
  MAINTAINERS: Update NXP FEC maintainer
  dt-bindings: FEC/i.MX DWMAC and INTMUX maintainer

 .../devicetree/bindings/interrupt-controller/fsl,intmux.yaml | 3 ++-
 Documentation/devicetree/bindings/net/fsl,fec.yaml           | 4 +++-
 Documentation/devicetree/bindings/net/nxp,dwmac-imx.yaml     | 4 +++-
 MAINTAINERS                                                  | 5 ++++-
 4 files changed, 12 insertions(+), 4 deletions(-)

-- 
2.34.1

