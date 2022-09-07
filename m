Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0973C5AFBDC
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 07:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbiIGFpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 01:45:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiIGFpB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 01:45:01 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FA682CC99;
        Tue,  6 Sep 2022 22:45:00 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id jm11so13380628plb.13;
        Tue, 06 Sep 2022 22:45:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=jSw/8OWhZl8emStQst9ay10XSQWcoQ/kVcUGvAh1sIA=;
        b=YNxJIScsom9bak2HrRlByiNiWh+8luudX9NpkHoxt9LEXlos4S+VVpefAsKjRoIoSj
         8KvWvnC9m//L4RZ1j71qOMWcGKcdD2EAwVrPxqr8n9Y/1k6R6n9Ym9bCPIHpSwbiN+/E
         j+lo0AL9RCfxFunKj7zSrmfmqFTVWp3iC/+NUxwHI/cBDmmRQPXEzjNe229QC1UeSQZA
         0Bs1lIYeNz43/l3lQL42nsIxrED7VbLEaoRmZIMIPen29+hef3eSR8Qay5QOFkdRFKMr
         mrsmLhMJPXkAvHIWmZO69HgSUzZ5fPBd34hWlbHCcZXWxrHPU/dGm9SdGuOI/yE2Piep
         mBzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=jSw/8OWhZl8emStQst9ay10XSQWcoQ/kVcUGvAh1sIA=;
        b=xImRS95WtvJ/xJ2rtyNtAS787bpcfO+xadvVkVA6QpvO7zuhpv0iUlUAjK+kUufAAd
         YlNBd76VkiUb2wDqnBVVehpb4QjvbieZ5qLsnjH91Q0wci98cdU5wpZEJNndWGYYpme0
         z5rcX8Go0CfS+EMue6i+uiATMQCHwbdW72impVz1UHlwfAdIHLgEVxxB0it2QdcilJOR
         2XsYLdw1os3owppVLLlaiofz/BOJAeYFgWviTjdmMPdtTnFID3ehOqixRxslA3yrj0Q+
         d22oQlWU/BQmZFo5XGymG1AQC6x6TrThdaCASxi6yWVtz+43SRir77kalVO7g6eVETX5
         /xaA==
X-Gm-Message-State: ACgBeo0wpCjtqebcgSFRA2kJMUAcD4Fv6Q2Q/eEP8jQwm0IJxwuiqT2C
        Z7sOyyc4idPiX2JF5PfXY1c=
X-Google-Smtp-Source: AA6agR4BvSVDHcizdQDkcJB+aUoUijXpapQ45qqP8WG2juNShVwux9p94CzEVbm0sXkor79i5r2xdg==
X-Received: by 2002:a17:90b:33c5:b0:1fe:9dc:2b1b with SMTP id lk5-20020a17090b33c500b001fe09dc2b1bmr2153895pjb.211.1662529499795;
        Tue, 06 Sep 2022 22:44:59 -0700 (PDT)
Received: from localhost.localdomain ([76.132.249.1])
        by smtp.gmail.com with ESMTPSA id b2-20020a170902d50200b0016c0c82e85csm11222798plg.75.2022.09.06.22.44.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Sep 2022 22:44:59 -0700 (PDT)
From:   rentao.bupt@gmail.com
To:     Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heyi Guo <guoheyi@linux.alibaba.com>,
        Dylan Hung <dylan_hung@aspeedtech.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Liang He <windhl@126.com>, Hao Chen <chenhao288@hisilicon.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>, Tao Ren <taoren@fb.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-kernel@vger.kernel.org
Cc:     Tao Ren <rentao.bupt@gmail.com>
Subject: [PATCH net-next v3 0/2] net: ftgmac100: support fixed link
Date:   Tue,  6 Sep 2022 22:44:51 -0700
Message-Id: <20220907054453.20016-1-rentao.bupt@gmail.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tao Ren <rentao.bupt@gmail.com>

The patch series adds fixed link support to ftgmac100 driver.

Patch #1 adds fixed link logic into ftgmac100 driver.

Patch #2 enables mac3 controller in Elbert dts: Elbert mac3 is connected
to the onboard switch BCM53134P's IMP_RGMII port directly (no PHY
between BMC MAC and BCM53134P).

Tao Ren (2):
  net: ftgmac100: support fixed link
  ARM: dts: aspeed: elbert: Enable mac3 controller

 .../boot/dts/aspeed-bmc-facebook-elbert.dts   | 18 ++++++++++++++
 drivers/net/ethernet/faraday/ftgmac100.c      | 24 +++++++++++++++++++
 2 files changed, 42 insertions(+)

-- 
2.37.3

