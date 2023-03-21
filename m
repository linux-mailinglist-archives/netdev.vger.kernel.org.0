Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2DE6C384C
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 18:34:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230150AbjCURez (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 13:34:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjCURev (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 13:34:51 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F9655505C;
        Tue, 21 Mar 2023 10:34:21 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id j24so5643662wrd.0;
        Tue, 21 Mar 2023 10:34:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679420057;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=smJRVW/FrnuNdUD8cl2fR53KDB/Y49Fg7o55MfQn18I=;
        b=okE/S97qVRKsRy5os7SLORRU5OGGTC124JaJcFqYmezLMUzBZTWmPb/PXD3i51jvTl
         Wus9Lb3ndeS7AD4Ot8+8V7eso0AkNA3YtE+3kFWs/HA4XHDriMkfx75YTuvvGXx025b1
         9SIWTIQ7ePidnbSURXPTogR8ft6GWnB00HLOHGmxuTO7tbzudfQXken+tepVUvSmTo8b
         QNaAWJngOcp6V5PVud1wr6wNqM0WS423zAjEJc4HpnBf6gUY5oDJ3DaPMdgtWV/IT6rr
         b4bO3G/xqtOTJufWgI3pP2rXQqNNyEgG8DCk1bjc5f/LIzzCdV5eP+aI+G3gu4M2hLI2
         /W5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679420057;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=smJRVW/FrnuNdUD8cl2fR53KDB/Y49Fg7o55MfQn18I=;
        b=oy69jKOLuovBKZzTN2KOy/dwM+6Mokf9TlH37PY0EJcgZ8uW+PKlTXxu56YQgKcA7V
         nu8L6YDPGzd81Kb2KRPf2O7robVJIWL8EmKOezbxaSCTJvDdQf1SfAtQmQ2cUdJQ+ya2
         wn2nmbPojfsrcRetx/5woCAGX+eUlNMyEcvx+O82otMhVW1iOal3WuRmOqKv3C/QBOG9
         0aqOJ6hpwRnvorWPjGQXVjS5HQ0VhhWcJOhMub+cgYRv+sCPZAjzcRHQaOwHo3Rfm9cL
         0PPbM2VnJ8t54u9CGmaDp9gvPFx5IGLJHNU8DH3ugXL2NLY48T7oVqJuwYUirN4UUD4c
         p+ZQ==
X-Gm-Message-State: AO0yUKWThv/bZuf1mMg1aMmYO48GX5bbx1SrzQFfsfXUkFlBrH8uEmkf
        rWOVkpz8Ir+6Q5J3aoQWNvM=
X-Google-Smtp-Source: AK7set/C04ryg0NorzhacJUWhL7vs6/KZ3lU5EbnosyNfsNkrZxMsTsuQX7tFXCFAvfGMOz1Favxfw==
X-Received: by 2002:adf:ead0:0:b0:2cf:e710:a4b9 with SMTP id o16-20020adfead0000000b002cfe710a4b9mr2725892wrn.32.1679420056462;
        Tue, 21 Mar 2023 10:34:16 -0700 (PDT)
Received: from atlantis.lan (255.red-79-146-124.dynamicip.rima-tde.net. [79.146.124.255])
        by smtp.gmail.com with ESMTPSA id b13-20020a056000054d00b002da1261aa44sm184775wrf.48.2023.03.21.10.34.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 10:34:13 -0700 (PDT)
From:   =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
To:     f.fainelli@gmail.com, jonas.gorski@gmail.com, andrew@lunn.ch,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>
Subject: [PATCH v2 0/4] net: dsa: b53: configure 6318 and 63268 RGMII ports
Date:   Tue, 21 Mar 2023 18:33:55 +0100
Message-Id: <20230321173359.251778-1-noltari@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230320155024.164523-1-noltari@gmail.com>
References: <20230320155024.164523-1-noltari@gmail.com>
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

BCM6318 and BCM63268 need special configuration for their RGMII ports, so we
need to be able to identify them as a special BCM63xx switch.
In the meantime, let's add some missing BCM63xx SoCs to B53 MMAP device table.

This should be applied after "net: dsa: b53: add support for BCM63xx RGMIIs":
https://patchwork.kernel.org/project/netdevbpf/patch/20230319220805.124024-1-noltari@gmail.com/

Álvaro Fernández Rojas (4):
  dt-bindings: net: dsa: b53: add more 63xx SoCs
  net: dsa: b53: mmap: add more 63xx SoCs
  net: dsa: b53: mmap: allow passing a chip ID
  net: dsa: b53: add BCM63268 RGMII configuration

 .../devicetree/bindings/net/dsa/brcm,b53.yaml |  3 ++
 drivers/net/dsa/b53/b53_common.c              | 19 +++++++++++-
 drivers/net/dsa/b53/b53_mmap.c                | 29 +++++++++++++++----
 drivers/net/dsa/b53/b53_priv.h                |  9 +++++-
 drivers/net/dsa/b53/b53_regs.h                |  1 +
 5 files changed, 53 insertions(+), 8 deletions(-)

-- 
2.30.2

