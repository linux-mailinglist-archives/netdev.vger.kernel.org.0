Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFC706436B8
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 22:24:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233345AbiLEVXw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 16:23:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233204AbiLEVXu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 16:23:50 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8755240AD;
        Mon,  5 Dec 2022 13:23:48 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id w15-20020a17090a380f00b0021873113cb4so12829357pjb.0;
        Mon, 05 Dec 2022 13:23:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JtLU3/8HyiCf4s0wY+n1hyp3mRB+91HtBLr7ZVcrjF4=;
        b=JnuSXlPEGBQwNHB05AdDysY5Z9AEYAxaFW2ENi0g6T2Dl/ghKbHxtMNeDbSOxVdu/u
         FIbR5kAx5ICDPFVzXBKr27cIHOnyRAyRdgh6L/E+Xs4pGtPupfkTBQDFpCeZ2kSFlqv5
         MUUAKpIn1OtXJPdfb3CFuCz0UXyaplbMrVl10ep/zhZmi2wQWySvD3U8yaLuqdlEjzLh
         IspF9aLuKw+0V+cqodHzsj+1ufzbovj11eCpsKbfYL58xqpdij3jn1b7u4JgbH+QllRh
         OgHtc/EUJoTNLF8UdfICSDsmAr7pjSvhukgK+Hi+mO0t7rIfFPI/2ScMEiwQeaZhpjuh
         1uhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JtLU3/8HyiCf4s0wY+n1hyp3mRB+91HtBLr7ZVcrjF4=;
        b=FDMpVc14S8UuH73zwkmM3iTKF/1EvXI08wjDUE0scl1PDjBy0mfkTAMaSe85Qec0BZ
         1HbEyNzTxczNGPmEHX5WfzT9c8ocpQaCyoWJzZXPXNzq4kBGTCLiKjE17O7QLSMp1gDy
         Sb1zovlD0Z1upUFRQiAzChjnL5AC7+W/YPzx9+OtduPLrW6WauoAdMy13ygmF/DHHPAL
         YqwQxtBvil01w2xBlii1z2icxBBvXvDujDBHXM8x+MGP6U8KCCE/dnDtyC6FtfkYGdKu
         SL+ZmNtNm5sqVwPV5LLff0mDI789vGktPYwEsmtdRJUJCm+lHIVfb5Ut0fl1ke3njyEv
         B8lg==
X-Gm-Message-State: ANoB5pmC/mOu6dzzhFs9F2n2BJrXSIe+89NCr0/RYQz1DfX8ik+oOWir
        ZYMAWZbSHBh1Ii4HpR+1iUgZY8RyY75rSA==
X-Google-Smtp-Source: AA0mqf6b5+NUzab1hIAmnznGVT/EJLmF+qEqglFHUH0D0wRl0pcBNJuEcWrZbCWg5i1dk+LQk12Qdg==
X-Received: by 2002:a17:902:ea06:b0:186:abaf:8fe with SMTP id s6-20020a170902ea0600b00186abaf08femr80167079plg.95.1670275427934;
        Mon, 05 Dec 2022 13:23:47 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y2-20020a17090264c200b00189348ab156sm4029270pli.283.2022.12.05.13.23.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 13:23:47 -0800 (PST)
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
Subject: [PATCH net 1/2] MAINTAINERS: Update NXP FEC maintainer
Date:   Mon,  5 Dec 2022 13:23:39 -0800
Message-Id: <20221205212340.1073283-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221205212340.1073283-1-f.fainelli@gmail.com>
References: <20221205212340.1073283-1-f.fainelli@gmail.com>
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

Emails to Joakim Zhang bounce, add Shawn Guo (i.MX architecture
maintainer) and the NXP Linux Team exploder email.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 MAINTAINERS | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 256f03904987..ba25d5af51a0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8187,7 +8187,8 @@ S:	Maintained
 F:	drivers/i2c/busses/i2c-cpm.c
 
 FREESCALE IMX / MXC FEC DRIVER
-M:	Joakim Zhang <qiangqing.zhang@nxp.com>
+M:	Shawn Guo <shawnguo@kernel.org>
+M:	NXP Linux Team <linux-imx@nxp.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	Documentation/devicetree/bindings/net/fsl,fec.yaml
-- 
2.34.1

