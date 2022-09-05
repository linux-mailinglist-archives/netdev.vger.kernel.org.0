Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB7355ADC0D
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 01:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232222AbiIEX4t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 19:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbiIEX4r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 19:56:47 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 173EA5AA26;
        Mon,  5 Sep 2022 16:56:47 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id r69so9160129pgr.2;
        Mon, 05 Sep 2022 16:56:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date;
        bh=yG2nsd5/34KZh2Ljv+YOVUI4bCWzz44qCZZJaZQXcIE=;
        b=jwQ7xjGRpjqZBJX0RitfI2JOv3JRzOaCEou9RQnxmEomm8uZkMG+4mu9e+sPoJpI/L
         /lI6ZAMYDXGUtEyUSquoiaqZ+j1EKewkC5I2uOv+awexiajeL93T1UaVNVLmQBVYVrcb
         bnBzAuCji5LGJgQ1WCuR497gA9WwQVeuAqDyenytoOnGB5ZenLYmUXenXyyieaQAZfil
         zjJg5QC5T+P7cojQyNL9yIOPLHXjmiwj2pzHdaXv/SJ79CQk4dM7bIOG0lZMPPvO6F6B
         7Fc4Q6Ca3Wsqoo5JHdHgoa+f5cxDB0wu7E5n0IDkzKrk4CMcSqsOrfnouX5d0SJKgam+
         vWaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date;
        bh=yG2nsd5/34KZh2Ljv+YOVUI4bCWzz44qCZZJaZQXcIE=;
        b=UTL5FP8doLKjGLgks6J9SqtNxzpwpkTLirybSjS/mgpN6KkfCzyPIzSjg61JJhspu0
         A2E1iOkgNsURoh0TuvjkTPJVjrae/pcg+SOgDNFdSEo9e0/+6TN8jhI+AWMWrv/K64A+
         OfunzokTzSAmfy6gDVVAUx/PJUvN9gfRZQ2PxRUX7ODodcrViOszb5qFarBTl1mSAYS/
         WTz0LjX6qUAvllZ4qiXq1JHODySYN/iXGz1oHRgRGPS66gSoF+RDyn7uuwipVBCed3R/
         73TVJ9pBiP4yIzkSRb+9ikUEXjB7oYf87Aw1IGWf49XsEHzDgVzEDE/U8EhI692AMIeB
         YW0A==
X-Gm-Message-State: ACgBeo32Ah0TN14EdkLxBrOFgN80gXhObLcjGOCTbxBBshDUwNb5oauJ
        M61dAuLVovkOufxlV+0Z/Jk=
X-Google-Smtp-Source: AA6agR6AyDvPMSYp2d+Sum7aE/V0wjZupDIJx2E1mWHPq7oRrMlI7aTHTfXVrD6sMl2K6TZXzSB7Pg==
X-Received: by 2002:a05:6a00:88a:b0:53a:b7a0:ea3a with SMTP id q10-20020a056a00088a00b0053ab7a0ea3amr29406689pfj.21.1662422206546;
        Mon, 05 Sep 2022 16:56:46 -0700 (PDT)
Received: from localhost.localdomain ([76.132.249.1])
        by smtp.gmail.com with ESMTPSA id g26-20020aa79dda000000b00537f13d217bsm8405530pfq.76.2022.09.05.16.56.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 16:56:45 -0700 (PDT)
From:   rentao.bupt@gmail.com
To:     "David S . Miller" <davem@davemloft.net>,
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
Subject: [PATCH net-next 0/2] net: ftgmac100: support fixed link
Date:   Mon,  5 Sep 2022 16:56:32 -0700
Message-Id: <20220905235634.20957-1-rentao.bupt@gmail.com>
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

From: Tao Ren <taoren@fb.com>

The patch series adds fixed link support to ftgmac100 driver.

Patch #1 adds fixed link logic into ftgmac100 driver.

Patch #2 enables mac3 controller in Elbert dts, and mac3 is connected to
the onboard switch directly.

Tao Ren (2):
  net: ftgmac100: support fixed link
  ARM: dts: aspeed: elbert: Enable mac3 controller

 .../boot/dts/aspeed-bmc-facebook-elbert.dts   | 11 +++++++++
 drivers/net/ethernet/faraday/ftgmac100.c      | 24 +++++++++++++++++++
 2 files changed, 35 insertions(+)

-- 
2.30.2

