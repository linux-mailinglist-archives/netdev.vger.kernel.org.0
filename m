Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E365F6C2498
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 23:19:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbjCTWTT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 18:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbjCTWSi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 18:18:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D9E63668D
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 15:17:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679350636;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pge60lbtNXyjhIC7xM2HbTt6URs0YcanlV/EtqaeLXQ=;
        b=Q+0m7kEGGSIgz5QuVZqUxT5hEh/OJUATNtPwaR1YXlWFntufOgCH0fOCCMMr/F/i8Us4Go
        nr9awWLm917pHo3Eu337Km7Mzjbtq7Is0R6TZymDxddj13twQfu3y10DVEHuF+nZQqHzMv
        5IpaMcNAygAv0SGhz3TGb46gDihRx8w=
Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com
 [209.85.160.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-395-GZBqBKJvMQa0XSMuPSSAUQ-1; Mon, 20 Mar 2023 18:17:13 -0400
X-MC-Unique: GZBqBKJvMQa0XSMuPSSAUQ-1
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-177bf70751bso7715659fac.16
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 15:17:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679350633;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pge60lbtNXyjhIC7xM2HbTt6URs0YcanlV/EtqaeLXQ=;
        b=kRAoJda9QWtcF/bBzaXGAhMWJTFVdtaJrZajkFWk7dFPUoNrj4Ayw6QZfOwTnep+4t
         m/cnMnG9ZnD3WuJmolnWka9kZ6cXoUbWgwNn6qffuxcZzLtgWH+aSOIYxsczGbBQzhoU
         moKfQ8zBQbZvsIDAXCRV7w0NfnblUD2PSSMOCVaO8Mj3kKHPXHlr9o66ZpuMucNbzzMc
         wnikuSGqZ/R0a/qzCSEVc3pxkr0PZhP2k1G6UjEBzBWhEBplHS5nFUht0Ko3sVdVKsDG
         xmwAlt3DAEdWjsVQHbsg94L6rVoqtfZwvdCaaklVbulE4vs8ZHeuNurzaMAk1iqNzRG6
         HbSA==
X-Gm-Message-State: AO0yUKVWIxHLL8MzLOp77MdKZHhoJ89tTGLISixzbr6RCQBsOPHQ8GpP
        Jr2VtB6g1B94lDf6OR1RodXqm/GWwjO0va1mNrskEAIv2XbF0M37THz7KhrXsBUAj13AXeiG8fU
        hAhxkSzc8jOivih/n
X-Received: by 2002:a4a:4942:0:b0:536:584c:eb1f with SMTP id z63-20020a4a4942000000b00536584ceb1fmr679541ooa.2.1679350632835;
        Mon, 20 Mar 2023 15:17:12 -0700 (PDT)
X-Google-Smtp-Source: AK7set+Tggwv6X8YXBBYlPzxDeaPL/yXFE5Kx8UTm2ESFLzqErgx22ScqfI1N/KEIqaxjClaqy3gqw==
X-Received: by 2002:a4a:4942:0:b0:536:584c:eb1f with SMTP id z63-20020a4a4942000000b00536584ceb1fmr679529ooa.2.1679350632616;
        Mon, 20 Mar 2023 15:17:12 -0700 (PDT)
Received: from halaney-x13s.redhat.com (104-53-165-62.lightspeed.stlsmo.sbcglobal.net. [104.53.165.62])
        by smtp.gmail.com with ESMTPSA id q204-20020a4a33d5000000b0053853156b5csm4092465ooq.8.2023.03.20.15.17.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 15:17:12 -0700 (PDT)
From:   Andrew Halaney <ahalaney@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     agross@kernel.org, andersson@kernel.org, konrad.dybcio@linaro.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, vkoul@kernel.org,
        bhupesh.sharma@linaro.org, mturquette@baylibre.com,
        sboyd@kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com, richardcochran@gmail.com,
        linux@armlinux.org.uk, veekhee@apple.com,
        tee.min.tan@linux.intel.com, mohammad.athari.ismail@intel.com,
        jonathanh@nvidia.com, ruppala@nvidia.com, bmasney@redhat.com,
        andrey.konovalov@linaro.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-clk@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, ncai@quicinc.com,
        jsuraj@qti.qualcomm.com, hisunil@quicinc.com, echanude@redhat.com,
        Andrew Halaney <ahalaney@redhat.com>
Subject: [PATCH net-next v2 10/12] net: stmmac: dwmac-qcom-ethqos: Respect phy-mode and TX delay
Date:   Mon, 20 Mar 2023 17:16:15 -0500
Message-Id: <20230320221617.236323-11-ahalaney@redhat.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230320221617.236323-1-ahalaney@redhat.com>
References: <20230320221617.236323-1-ahalaney@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver currently sets a MAC TX delay of 2 ns no matter what the
phy-mode is. If the phy-mode indicates the phy is in charge of the
TX delay (rgmii-txid, rgmii-id), don't do it in the MAC.

Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
---

Changes since v1:
	* Use a consistent subject prefix with other stmmac changes in series (myself)

 .../stmicro/stmmac/dwmac-qcom-ethqos.c        | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
index 32763566c214..e89937916741 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
@@ -279,6 +279,16 @@ static int ethqos_dll_configure(struct qcom_ethqos *ethqos)
 
 static int ethqos_rgmii_macro_init(struct qcom_ethqos *ethqos)
 {
+	int phy_mode;
+	int phase_shift;
+
+	/* Determine if the PHY adds a 2 ns TX delay or the MAC handles it */
+	phy_mode = device_get_phy_mode(&ethqos->pdev->dev);
+	if (phy_mode == PHY_INTERFACE_MODE_RGMII_ID || phy_mode == PHY_INTERFACE_MODE_RGMII_TXID)
+		phase_shift = 0;
+	else
+		phase_shift = RGMII_CONFIG2_TX_CLK_PHASE_SHIFT_EN;
+
 	/* Disable loopback mode */
 	rgmii_updatel(ethqos, RGMII_CONFIG2_TX_TO_RX_LOOPBACK_EN,
 		      0, RGMII_IO_MACRO_CONFIG2);
@@ -300,9 +310,9 @@ static int ethqos_rgmii_macro_init(struct qcom_ethqos *ethqos)
 			      RGMII_CONFIG_PROG_SWAP, RGMII_IO_MACRO_CONFIG);
 		rgmii_updatel(ethqos, RGMII_CONFIG2_DATA_DIVIDE_CLK_SEL,
 			      0, RGMII_IO_MACRO_CONFIG2);
+
 		rgmii_updatel(ethqos, RGMII_CONFIG2_TX_CLK_PHASE_SHIFT_EN,
-			      RGMII_CONFIG2_TX_CLK_PHASE_SHIFT_EN,
-			      RGMII_IO_MACRO_CONFIG2);
+				  phase_shift, RGMII_IO_MACRO_CONFIG2);
 		rgmii_updatel(ethqos, RGMII_CONFIG2_RSVD_CONFIG15,
 			      0, RGMII_IO_MACRO_CONFIG2);
 		rgmii_updatel(ethqos, RGMII_CONFIG2_RX_PROG_SWAP,
@@ -336,8 +346,7 @@ static int ethqos_rgmii_macro_init(struct qcom_ethqos *ethqos)
 		rgmii_updatel(ethqos, RGMII_CONFIG2_DATA_DIVIDE_CLK_SEL,
 			      0, RGMII_IO_MACRO_CONFIG2);
 		rgmii_updatel(ethqos, RGMII_CONFIG2_TX_CLK_PHASE_SHIFT_EN,
-			      RGMII_CONFIG2_TX_CLK_PHASE_SHIFT_EN,
-			      RGMII_IO_MACRO_CONFIG2);
+				  phase_shift, RGMII_IO_MACRO_CONFIG2);
 		rgmii_updatel(ethqos, RGMII_CONFIG_MAX_SPD_PRG_2,
 			      BIT(6), RGMII_IO_MACRO_CONFIG);
 		rgmii_updatel(ethqos, RGMII_CONFIG2_RSVD_CONFIG15,
@@ -375,7 +384,7 @@ static int ethqos_rgmii_macro_init(struct qcom_ethqos *ethqos)
 		rgmii_updatel(ethqos, RGMII_CONFIG2_DATA_DIVIDE_CLK_SEL,
 			      0, RGMII_IO_MACRO_CONFIG2);
 		rgmii_updatel(ethqos, RGMII_CONFIG2_TX_CLK_PHASE_SHIFT_EN,
-			      0, RGMII_IO_MACRO_CONFIG2);
+				  phase_shift, RGMII_IO_MACRO_CONFIG2);
 		rgmii_updatel(ethqos, RGMII_CONFIG_MAX_SPD_PRG_9,
 			      BIT(12) | GENMASK(9, 8),
 			      RGMII_IO_MACRO_CONFIG);
-- 
2.39.2

