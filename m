Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 970015ADFA6
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 08:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232215AbiIFGUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 02:20:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbiIFGUf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 02:20:35 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D13BB222AE;
        Mon,  5 Sep 2022 23:20:34 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id fa2so10246612pjb.2;
        Mon, 05 Sep 2022 23:20:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=delLkvjT8PCP+Ncz2RgacJbjqYhQsYq5ByGTAUQohKI=;
        b=AB50cPp4YWn/0IYxLsU/3B3UTojp/d4KXUj/q1xX6JS2ZseKmIvcJZjRvv3kqLo6NA
         l+8eaRrkN7ElsC6NsnpcFQH/rKPYmIDOg8ypvlYzo39naFopoGuK7ONUjYZN4fVBX9ni
         QhWmQzlWjFV0t3wXlxdMXRkrr20u5+DLae/EIFKFzHFjFeOsDRpLHj9qjejFNya70bcc
         XBaN3+H+/KQU8Bgs0nafT0roBxNRvX/umh801T99OaOZ1ssmYI8vS+zUo2Vb9g/QCVHg
         JLrOeK0FttAPYuqXDHy7pFJ4E8rPgkTsOeEMyRkIWmzAbzKF7JbV6Jz6H2RfDQ3lM30r
         k6Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=delLkvjT8PCP+Ncz2RgacJbjqYhQsYq5ByGTAUQohKI=;
        b=6T0yCB9v6RR4+ESAJ+XdgsDS9n+nP8EsRBp660wOi+ct7CmeEwAz0wXtLFJHc37C41
         bSARqwC/NbNk+oNWda21KXLqhQVmbixZkcyqwyKgslH3sFajXRocoessl9+CfwlAtyru
         55FpNVOt2wSUxUfUr2F5vQz+s2h2NAJ6fPYUJ8crs0kv3bJxM8HWStBtT7UsC15Me01I
         5W0ODSeiPXfcQapbLhItxoJZl/u9T4NHxT6tMCZ2/IwTctxQrSVUDWDhp9oLPF8cZ+t3
         Hvc+dMi3yH8oUej3vxOe3mMBlbkkXoVz69uBw5EsAP3BBHaB+XbaDC1lossGGcJfaVGt
         eC9A==
X-Gm-Message-State: ACgBeo2+BVrZbGzYlCVvp+ULm3nzoXwDV+ocZLziUQiTMEXyjsxsq92X
        MhdU5gsFCw3K+bhoMZGK4Co=
X-Google-Smtp-Source: AA6agR5U9d9xHuCBeBjB3Bsy0w5WuyL0CxOpnm27siaJBDHBM6cwNBK8dAAtaDTNDXunhC/T34P3IA==
X-Received: by 2002:a17:903:110e:b0:171:3afa:e68c with SMTP id n14-20020a170903110e00b001713afae68cmr51767140plh.12.1662445233400;
        Mon, 05 Sep 2022 23:20:33 -0700 (PDT)
Received: from localhost.localdomain ([76.132.249.1])
        by smtp.gmail.com with ESMTPSA id m16-20020a170902db1000b00172dd10f64fsm8877798plx.263.2022.09.05.23.20.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 23:20:32 -0700 (PDT)
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
Subject: [PATCH net-next v2 0/2] net: ftgmac100: support fixed link
Date:   Mon,  5 Sep 2022 23:20:24 -0700
Message-Id: <20220906062026.57169-1-rentao.bupt@gmail.com>
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

 .../boot/dts/aspeed-bmc-facebook-elbert.dts   | 20 ++++++++++++++++
 drivers/net/ethernet/faraday/ftgmac100.c      | 24 +++++++++++++++++++
 2 files changed, 44 insertions(+)

-- 
2.37.3

