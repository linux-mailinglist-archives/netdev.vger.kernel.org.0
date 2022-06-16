Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B73D754ED2A
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 00:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378413AbiFPWQ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 18:16:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiFPWQ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 18:16:28 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFA9356391;
        Thu, 16 Jun 2022 15:16:27 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id fu3so5300762ejc.7;
        Thu, 16 Jun 2022 15:16:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DVRo4CvEL41HYQa+CoQccyZMSsu+VyU+c+CNeOdKaAY=;
        b=hSRY3xSKb+x0uxV1uqJd1PPuvsy44iHgFHSbyyMzsPCKdgXOM18U7eh3uCpbyPaHIh
         qPqfWbwppxrw7rLBlkVYMjaPg5kash4tvtUuY648vyCmsworvOcsJujcPDx2EZw2Aj74
         SnFpJUTah/V/Gpt7hveDUVbKj+GFPSE3Rs+y65r8lM0Egns0HjmNDd0C8M+y+EqO3aJf
         bdRyONKYLVolgL1xN18ijUKYAPBbtakwkirPXhmPOfsnJtb5gzaCFIc/y2ZLgfQc+3Od
         V52ztJYcwQLGTnxiQGbpMv1fTcpY+lfO6pmjf7JghoXMPBbzUiHdRorTHZ0l01U1sEAb
         VyMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DVRo4CvEL41HYQa+CoQccyZMSsu+VyU+c+CNeOdKaAY=;
        b=TNtwH3/028qRrEW0HPq25139lslMdkkPJliOakxpia+IgEOKUEwsXt/n59skxZ050I
         DPI77pGM/Sg6jItpdYy+L14W+xceoJ0Stg6wurVKlyiqwPv2BMsv71gHTebP1weLavIO
         TtwcDYsw2eq7eDuq7g73rlxzJr6TRZ/La9SHuK0buwd1ONoqLfAeqSxwpPsZULqbmXLW
         yV9vAcGqJhrPW+MXQVQQysfyRAQ+LsrZPICojDG6XN6I4uYycMbOGqArOixkuiHGHp/M
         9G7QFYOSEUfyQ+y836tbg+zeCgQx8m33U2DlInOUr+uhJE0OMMxdTwFIEPKi0R88vbj7
         rs4g==
X-Gm-Message-State: AJIora+edfEeFyn14gfFhqzPD/6e/8bZwtA34uFYript4fdLo9k6gYOp
        1Sb0yXkySkK+fl6It1d/DUc=
X-Google-Smtp-Source: AGRyM1tM9sbDP5+nf78h0PyaUU0M5ak6/lgXRf4DpIfVxQ1sVPb0Gujh4AdJFUO/wy9JsWqFQGORBg==
X-Received: by 2002:a17:906:5350:b0:711:f866:ed8 with SMTP id j16-20020a170906535000b00711f8660ed8mr6205922ejo.441.1655417786075;
        Thu, 16 Jun 2022 15:16:26 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.googlemail.com with ESMTPSA id u9-20020a1709061da900b006fef557bb7asm1276340ejh.80.2022.06.16.15.16.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 15:16:25 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "Christian 'Ansuel' Marangi" <ansuelsmth@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     kernel test robot <lkp@intel.com>
Subject: [net-next PATCH] net: ethernet: stmmac: remove select QCOM_SOCINFO and make it optional
Date:   Fri, 17 Jun 2022 00:15:54 +0200
Message-Id: <20220616221554.22040-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.36.1
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

QCOM_SOCINFO depends on QCOM_SMEM but is not selected, this cause some
problems with QCOM_SOCINFO getting selected with the dependency of
QCOM_SMEM not met.
To fix this remove the select in Kconfig and add additional info in the
DWMAC_IPQ806X config description.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: 9ec092d2feb6 ("net: ethernet: stmmac: add missing sgmii configure for ipq806x")
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/net/ethernet/stmicro/stmmac/Kconfig | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig b/drivers/net/ethernet/stmicro/stmmac/Kconfig
index c4bca16dae57..31ff35174034 100644
--- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
+++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
@@ -83,7 +83,6 @@ config DWMAC_IPQ806X
 	default ARCH_QCOM
 	depends on OF && (ARCH_QCOM || COMPILE_TEST)
 	select MFD_SYSCON
-	select QCOM_SOCINFO
 	help
 	  Support for QCA IPQ806X DWMAC Ethernet.
 
@@ -92,6 +91,9 @@ config DWMAC_IPQ806X
 	  acceleration features available on this SoC. Network devices
 	  will behave like standard non-accelerated ethernet interfaces.
 
+	  Select the QCOM_SOCINFO config flag to enable specific dwmac
+	  fixup based on the ipq806x SoC revision.
+
 config DWMAC_LPC18XX
 	tristate "NXP LPC18xx/43xx DWMAC support"
 	default ARCH_LPC18XX
-- 
2.36.1

