Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54B336C1AC9
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 17:01:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233392AbjCTQBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 12:01:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233533AbjCTQAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 12:00:15 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8FE23D925;
        Mon, 20 Mar 2023 08:50:36 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id ip21-20020a05600ca69500b003ed56690948so7389814wmb.1;
        Mon, 20 Mar 2023 08:50:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679327428;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8s8/JOGPhBBFbxq/FCZEd4jcgUa2mKxpAMVRWqREkRM=;
        b=ShOr3y6OuFbGC9zVtGQ2ZRg8AFfgvr0gPoP4oO1uzXt3GusImqDDBCpIqYssvAYT4J
         onXI1FrhyFesQlgXDLF64DFPVLBxuCpFP4IHzT/w33Ojn8q4ELDwk1VCbZG5i+YUgfSr
         Y+tteP2Fa1CTWHDlDwmjG6Q2787PkHIt5F9JWHgAHMCpUSJwAgvKymQOljLAiRPVW2FI
         NrLSoAW5unDi8QpLelwdSETWjh4fUKa9Bk7/OHwGmXAySghtvhvg5AZVOhErTtUfSCox
         CLzuf2w/12zJEPKvKLqG7ViP24fSuy4SfUcUn2RZYGhLtGHifO+8v3QM5/4NsI7j9XRV
         V6Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679327428;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8s8/JOGPhBBFbxq/FCZEd4jcgUa2mKxpAMVRWqREkRM=;
        b=3lblBWLb/oRGhDvI2jm8LFMbbAV9KTTmSmAQGdpbA935HoVg0vkv9/9vMy+e3wPeoS
         EJKygokSW59J6LDI+HqIk/AJ8xcgeR9rIZC4W+PZuX4I4C7YC4OmbXbRvnb0AJgIC5/e
         HGCWNihY0nLpDKfFHeP8GIxTdRd5S2/gtNddZwYKprFOX3oi1mEa9Bwt7TpMBswm1KWC
         ZQsnfoO6IWWw76h31bLEZxbbksHcyG8iR33AtmVUwmic+zmpJUW1P02GbIP4dZjQKaqp
         QHRzoqCrPUnqLLhw4tCAzRuAldVbMKNf2OkDvSKjijKXsEZ55EKKmKdfOXX97RwxYYcc
         m09w==
X-Gm-Message-State: AO0yUKW7WK9DFiq9+Yo61e2/7MhDWYlYCHl1JkLQZv/pNaTay/KfQzOw
        1fQOwG+Q7dLLH5xZ03cLt/Q=
X-Google-Smtp-Source: AK7set8do8ILEwdc5St03HmMiJkFUVCTXqdKLZDFL6Rj6OGj+HdLSlVVlAMZSrtXceSq7DC29F2fKw==
X-Received: by 2002:a05:600c:4690:b0:3ea:f6c4:305e with SMTP id p16-20020a05600c469000b003eaf6c4305emr33328097wmo.38.1679327428207;
        Mon, 20 Mar 2023 08:50:28 -0700 (PDT)
Received: from atlantis.lan (255.red-79-146-124.dynamicip.rima-tde.net. [79.146.124.255])
        by smtp.gmail.com with ESMTPSA id 3-20020a05600c020300b003eddefd8792sm4812333wmi.14.2023.03.20.08.50.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 08:50:27 -0700 (PDT)
From:   =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
To:     f.fainelli@gmail.com, andrew@lunn.ch, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
Subject: [PATCH 0/4] net: dsa: b53: configure BCM63268 RGMII ports
Date:   Mon, 20 Mar 2023 16:50:20 +0100
Message-Id: <20230320155024.164523-1-noltari@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

BCM63268 need special configuration for their RGMII ports, so we need to be
able to identify them as a special BCM63xx switch.
In the meantime, let's add some missing BCM63xx SoCs to B53 MMAP device table.

This should be applied after "net: dsa: b53: add support for BCM63xx RGMIIs":
https://patchwork.kernel.org/project/netdevbpf/patch/20230319220805.124024-1-noltari@gmail.com/

Álvaro Fernández Rojas (4):
  dt-bindings: net: dsa: b53: add more 63xx SoCs
  net: dsa: b53: mmap: add more BCM63xx SoCs
  net: dsa: b53: mmap: allow passing a chip ID
  net: dsa: b53: add BCM63268 RGMII configuration

 .../devicetree/bindings/net/dsa/brcm,b53.yaml |  3 ++
 drivers/net/dsa/b53/b53_common.c              |  6 +++-
 drivers/net/dsa/b53/b53_mmap.c                | 29 +++++++++++++++----
 drivers/net/dsa/b53/b53_priv.h                |  9 +++++-
 drivers/net/dsa/b53/b53_regs.h                |  1 +
 5 files changed, 40 insertions(+), 8 deletions(-)

-- 
2.30.2

