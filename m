Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C88E5A8297
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 18:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbiHaQBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 12:01:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230451AbiHaQBf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 12:01:35 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC32DA8965;
        Wed, 31 Aug 2022 09:01:30 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id t5so18974926edc.11;
        Wed, 31 Aug 2022 09:01:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=S1sQqh7aVGxhRu+Xon140SackMTmmwu0lxm8zTTRpgI=;
        b=CDLTcAAyrWQVBsqaZ5liQIJj98AoAttQ0XYjdaJBnPejldTJRrOU6LUmARex4lHgFQ
         WtD7ILUHb/YWFhTR+2cY35yLkTo5inc2K+XNO77RHnhZWjjSnHR/0qXOgF/YhPf7xlz0
         i20msxUzAphWJREiDKEDk64iQ+a11NHfMtw1oKz3QldDiQ/TSIDkdK0CXuA14pQPhjrz
         gfvxyFcORnrikow4dlENinicNQfBU/i7I1g83a+oeJh/yxF/H00KfVAz1yKR5a6WzU67
         N6gwbYPPBqAmAoEii168si7RmXefE8IrILo/zK383TotI1VGEtL+HMrU7aboQucZ2cFT
         fOpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=S1sQqh7aVGxhRu+Xon140SackMTmmwu0lxm8zTTRpgI=;
        b=sAhRO0a8Wke5Qu9HJl+DYSL/ST+tZHNE0ZoNXzcD25KxENWeF9vuvg3QHbSAtrl5+u
         PTe5FSG3WEFLs0Ih873JSHVsLeVWkijOPBnIsKDG7LMWwBwWl+Q2zRmVIh8myTXgX1np
         8ijF1SZpSYP42OQkJAuyTfqZrWv8YKWBAXy5UyEnvggWQYCdmWuEM3zCafevbDxT5gTN
         LnXwaJhlN2CVe/0H86S0r+X3NFDg2RHMW48PI+9Vy6QQfp473y3mqLowOLwl9qxAqIwo
         YmzTiZpkcFqun3Ihx/CXCoVDctWkLdQGmzY37ZEOGtmZbMU2OXPJOieOoDy99rk0Hgfy
         KHAA==
X-Gm-Message-State: ACgBeo1QyGC+etu/9Gl19MsrvB7HthDpsdZRtd5Lc0X8Qa2lO4ckkg93
        geET75Zxo49P/sHi/zCNUDYbkQo569Q=
X-Google-Smtp-Source: AA6agR5uivc3gBlTpjogcVNIm/eBU0c15flYBV2OCs+D4FrNIFa5rcR+W7N0f1vmJFc3HCBqYt4u7A==
X-Received: by 2002:a05:6402:270b:b0:448:76f0:4f55 with SMTP id y11-20020a056402270b00b0044876f04f55mr12381355edd.215.1661961688118;
        Wed, 31 Aug 2022 09:01:28 -0700 (PDT)
Received: from localhost.localdomain ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id b5-20020a17090630c500b0073dde7c1767sm7277537ejb.175.2022.08.31.09.01.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 09:01:27 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     devicetree@vger.kernel.org
Cc:     netdev@vger.kernel.org, Shawn Guo <shawnguo@kernel.org>,
        Li Yang <leoyang.li@nxp.com>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michael Walle <michael@walle.cc>
Subject: [PATCH v2 devicetree 0/3] NXP LS1028A DT changes for multiple switch CPU ports
Date:   Wed, 31 Aug 2022 19:01:21 +0300
Message-Id: <20220831160124.914453-1-olteanv@gmail.com>
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

The Ethernet switch embedded within the NXP LS1028A has 2 Ethernet ports
towards the host, for local packet termination. In current device trees,
only the first port is enabled. Enabling the second port allows having a
higher termination throughput.

Care has been taken that this change does not produce regressions when
using updated device trees with old kernels that do not support multiple
DSA CPU ports. The only difference for old kernels will be the
appearance of a new net device (for &enetc_port3) which will not be very
useful for much of anything.

Vladimir Oltean (3):
  arm64: dts: ls1028a: move DSA CPU port property to the common SoC dtsi
  arm64: dts: ls1028a: mark enetc port 3 as a DSA master too
  arm64: dts: ls1028a: enable swp5 and eno3 for all boards

 .../dts/freescale/fsl-ls1028a-kontron-kbox-a-230-ls.dts  | 9 ++++++++-
 .../boot/dts/freescale/fsl-ls1028a-kontron-sl28-var2.dts | 9 ++++++++-
 arch/arm64/boot/dts/freescale/fsl-ls1028a-rdb.dts        | 9 ++++++++-
 arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi           | 2 ++
 4 files changed, 26 insertions(+), 3 deletions(-)

-- 
2.34.1

