Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57BAD5A8299
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 18:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbiHaQBp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 12:01:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231161AbiHaQBf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 12:01:35 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FB9FAB429;
        Wed, 31 Aug 2022 09:01:34 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id u6so18966303eda.12;
        Wed, 31 Aug 2022 09:01:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=zOcOZ3dEJs/GiAU0RutnwDCQ7L9W0T3xRCFO1jLQMhw=;
        b=FsrOa/4KhJrWIqKbhDQ5cQXxMI7mRI9fZz88vMcgeKMxPoSHKB75WZlHxft72mIC6q
         sE8w5/DHzchsFiWLITL6slEwVfL0+vgBnFnulLMkqKJrB4RLO7DJgZhzlmhxxV2YYixN
         I/p7qWSeKqpQRlzQ2Y9Qlmu54/ntgrApHoz84QEiKKiW2Y29XZl2FXW20E0ui+qF9IiK
         rSKOgyuV4V5cjMIB+1jcdDUg5KdodWYneHH9Ptz6CzkcHPUe0V9DcVEp3REk6gy0Dx+I
         swR1aboZf8iZBsExOpZqgjqdKGHOxcqpJhOtYGkFuSVL2Xnq8MfUdxWIM2qLSExdyl33
         QvHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=zOcOZ3dEJs/GiAU0RutnwDCQ7L9W0T3xRCFO1jLQMhw=;
        b=71dcpwH/tMzHMRFW2KUsNWjCKkhI4P7h5rRpNoT3eX+giW6kJtwrifeg+xAHVdX3Ag
         6R1M6tZcECqmShNa1gGpc9YTP7svKkHsajkxHM3dSvQ4xmOybE6ICuy9UeV99lNm4EQL
         m6drtVJwZ58JvdyHGAFHFbw8naOK67w35HVhj5/yNMoKSZAN+Z3C3+GNfHJwl9NNLRN5
         8FHipd8qTpU8BbjP7hjRoQpWlWScehnb1c/bk9nwYC0KCx0inn4edBJKFi8bsdBa0qzB
         IUyJ17MYlLMiTSx9mvzYU4cqS0c5+QGlsGRAVRi4adwFxvvNNxMpG1jzsHF5QM2xtM2p
         QV2g==
X-Gm-Message-State: ACgBeo11F/R97LVp7En56FenBp1C6yN4QpSzBZMJnGIgXxPmj4tULr2L
        iq+mWEIAvsE0wwmerL9JbBQtEc8agT4=
X-Google-Smtp-Source: AA6agR6nF6kH968KCqC+W/3X6AHNaQ8Viv4BBeTqmTVELDWmPpb4qyGLt6cOzf0GlVJKLo/7ub2dzw==
X-Received: by 2002:a05:6402:428e:b0:443:8279:13ea with SMTP id g14-20020a056402428e00b00443827913eamr25438115edc.294.1661961692583;
        Wed, 31 Aug 2022 09:01:32 -0700 (PDT)
Received: from localhost.localdomain ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id b5-20020a17090630c500b0073dde7c1767sm7277537ejb.175.2022.08.31.09.01.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 09:01:31 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     devicetree@vger.kernel.org
Cc:     netdev@vger.kernel.org, Shawn Guo <shawnguo@kernel.org>,
        Li Yang <leoyang.li@nxp.com>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michael Walle <michael@walle.cc>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 devicetree 2/3] arm64: dts: ls1028a: mark enetc port 3 as a DSA master too
Date:   Wed, 31 Aug 2022 19:01:23 +0300
Message-Id: <20220831160124.914453-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220831160124.914453-1-olteanv@gmail.com>
References: <20220831160124.914453-1-olteanv@gmail.com>
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The LS1028A switch has 2 internal links to the ENETC controller.

With DSA's ability to support multiple CPU ports, we should mark both
ENETC ports as DSA masters.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: keep 'status' property last

 arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
index 1215fcdf70fa..ac1c3a7e5f7a 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
@@ -1169,6 +1169,7 @@ fixed-link {
 					mscc_felix_port5: port@5 {
 						reg = <5>;
 						phy-mode = "internal";
+						ethernet = <&enetc_port3>;
 						status = "disabled";
 
 						fixed-link {
-- 
2.34.1

