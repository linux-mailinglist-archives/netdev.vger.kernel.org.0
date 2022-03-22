Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE044E3682
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 03:21:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235324AbiCVCRS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 22:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235304AbiCVCRR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 22:17:17 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4EFC2C65C;
        Mon, 21 Mar 2022 19:14:35 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id j13-20020a05600c1c0d00b0038c8f94aac2so578297wms.3;
        Mon, 21 Mar 2022 19:14:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sdd1MbpFc96EBVpraGZv4SQwPLUuIivkyZm7CBii8j4=;
        b=hHtXisGIKgsRgXl2aaPr+EUuYc2u2wadLeKL9y1/9kq6i6bDr0HKXKMI5/FZsDK5gg
         q3wN8h/jyBmmk0hPvyeu7NVjLUu1eYvL8Li5lt/unA49x/toQa27Xn8tVTIIXTebXhvW
         AINfBpgRxBtH0hMVHwzdr7KwIk/vnbVK2+vjZnBesEtij35VOBf9+X7FQqPAON/hGQ3T
         /IVDb/F6XO1jj04l/IFAva/ZHZKQA8tZHB9Jwz7mBLkyvjnrRVVW/4SX2E45Y92PFZ1o
         6Zvwoj9BmlzChxw6hWfuKXoszG5lDIFFznq1IoKrcRdDwXSuKP87QOEdUsNymvS2UuCP
         2HBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=sdd1MbpFc96EBVpraGZv4SQwPLUuIivkyZm7CBii8j4=;
        b=QH072dpp3+rGbF/KKKrBeETUODXgZ9HyY5JfRsE5nyrHU6CBxRZhcPOg+KztWdDlWc
         RHdaU+UfWljUA9jpkI80Qb8mzNU1UG0VhyvKuL/zeL3EI/awhnyBu09yoDtAKFXa9PtF
         nS5UtfFlmsvX7YYOgt4AtADp2EgYrTrJSydrAhpsHnMr96x2o22zlV7AbPvr4b+xTMrj
         YC28lm3rAw5ivlHBO9RlYoavU1KvU3ieRE0Dq2gIp4OKVnKHWXjj/+fGuxKL1XhE7ul6
         V0VGYhjcSSa0FAF5yyVkFvz90CPJ5MFhaPTaFES1EZRIDJjhmDYn4E5C2ztDlx5/WZ4f
         jXfg==
X-Gm-Message-State: AOAM5325EilczHeJWrIZ4LCQJu82GMh1fbZLP4th3oJ1h5JBXE7w8rT2
        S5TGUxL4HCB32d8J0tHQ1Qc=
X-Google-Smtp-Source: ABdhPJykoBybX4K3S8TnzSGe7g3kCe/Omzqb01qUiONSvRLJkL+Cl5UvGOKE+z7qlZjzGztqRjUcoA==
X-Received: by 2002:a05:600c:a08:b0:38c:93c8:36e9 with SMTP id z8-20020a05600c0a0800b0038c93c836e9mr1601092wmp.97.1647915274083;
        Mon, 21 Mar 2022 19:14:34 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-69-170.ip85.fastwebnet.it. [93.42.69.170])
        by smtp.googlemail.com with ESMTPSA id m2-20020a056000024200b00205718e3a3csm177968wrz.2.2022.03.21.19.14.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 19:14:33 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH 0/4] Reduce qca8k_priv space usage
Date:   Tue, 22 Mar 2022 02:45:02 +0100
Message-Id: <20220322014506.27872-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.34.1
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

These 4 patch is a first attempt at reducting qca8k_priv space.
The code changed a lot during times and we have many old logic
that can be replaced with new implementation

The first patch drop the tracking of MTU. We now base all on the
MTU saved in the slave dev. Just like DSA core does to get the max
MTU across all port to set a correct MTU for the cpu port.

The second patch finally drop a piece of story of this driver.
The ar8xxx_port_status struct was used by the first implementation
of this driver to put all sort of status data for the port...
With the evolution of DSA all that stuff got dropped till only
the enabled state was the only part of the that struct.
Since it's overkill to keep an array of int, we convert the variable
to a simple u8 where we store the status of each port. This is needed
to don't reanable ports on system resume.

The third patch is a preparation for patch 4. As Vladimir explained
in another patch, we waste a tons of space by keeping a duplicate of
the switch dsa ops in qca8k_priv. The only reason for this is to
dynamically set the correct mdiobus configuration (a legacy dsa one,
or a custom dedicated one)
To solve this problem, we just drop the phy_read/phy_write and we
declare a custom mdiobus in any case. 
This way we can use a static dsa switch ops struct and we can drop it
from qca8k_priv

Patch 4 finally drop the duplicated dsa_switch_ops.

Ansuel Smith (4):
  drivers: net: dsa: qca8k: drop MTU tracking from qca8k_priv
  drivers: net: dsa: qca8k: drop port_sts from qca8k_priv
  drivers: net: dsa: qca8k: rework and simplify mdiobus logic
  drivers: net: dsa: qca8k: drop dsa_switch_ops from qca8k_priv

 drivers/net/dsa/qca8k.c | 157 +++++++++++++++++-----------------------
 drivers/net/dsa/qca8k.h |  12 +--
 2 files changed, 71 insertions(+), 98 deletions(-)

-- 
2.34.1

