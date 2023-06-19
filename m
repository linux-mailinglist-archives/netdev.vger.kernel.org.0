Return-Path: <netdev+bounces-11869-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 50E0B734FC0
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 11:24:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 79A991C209C0
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 09:24:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0450FC122;
	Mon, 19 Jun 2023 09:24:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED236BE5E
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 09:24:16 +0000 (UTC)
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D197E197
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 02:24:13 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id 5b1f17b1804b1-3f8d5262dc8so23238155e9.0
        for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 02:24:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20221208.gappssmtp.com; s=20221208; t=1687166652; x=1689758652;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NQTveEsgflRe93KWoqKfVrG8nlhmeJM2igknKYDTnhc=;
        b=IZtOngQUj48lgG6+O3gJagYiNPDkkKMc7uI2DjMmiXkaARrGWmmQvNwSiNHfP3KdKp
         dozz3gHy+RHYrFV4qgVZ4vtDPnXGAc6pOR2sGowPourxz9omYODemTCa+hKq73BSuP2z
         /5ofFH/d5yWb38OupfrR1VIsUG6BQo/lqQ1xM5wyudFSS3eLfyNoPFf46zx2e1b+1EL1
         m+BqoUq0JHODu5HlzPhPNlzttRHatazImjhorjexyLFNbBl+zm1TGmtAOqGWl716j3p/
         v/JchKmSDWZdtsDfqTTEvnuUZ8VRMyQN/ge0sJShHNNYEs5HbTC5moAI3pTv7UFzbP3h
         f+Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687166652; x=1689758652;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NQTveEsgflRe93KWoqKfVrG8nlhmeJM2igknKYDTnhc=;
        b=BjX2PlEeRjP/1bGPAm13Lyxhj24FwuAAHik5r1NjQbY9iXTRgU1uLvLmAXbX5ODuZO
         +76SBRwqOTwSPp12w+kiWDZ1/VNx2pX3baCVBpI264yTPSBK9uoq7Jejm8cm+poxOYMA
         +4nhev/ODSvoNmOB6eSiwDWn/n6uSY0J5YHqdS7DFyVgUf9v9XQ0NTj/iih5XaZf75vN
         bqYYWbAlpv3KF3PDdHx5YJfBsf10WjavYSSxyOfYAbWmh4cIEMkmSRm6A2dTtJSt4sJa
         vfKC+aXEonNNNBs2a6GNbybAVZN5dCTAncseTEv7XljbqzshOAfkys2AXwG4rN3RyIKW
         EkGQ==
X-Gm-Message-State: AC+VfDyah5aVOj4I1Bofym2AIAquQ9q+QhqOiFeJH5RookFceDIPXK/F
	Ctp/0g1I3fm3mF42wc/DOvD/yg==
X-Google-Smtp-Source: ACHHUZ5TX/nrqYHgNnCprkhTEFlW0oqAmEf9RibG7Vs2uuQjjjYsYzduC9TIQoszFHG3eJiYems05Q==
X-Received: by 2002:a05:600c:4f96:b0:3f7:f302:161 with SMTP id n22-20020a05600c4f9600b003f7f3020161mr13122941wmq.8.1687166651986;
        Mon, 19 Jun 2023 02:24:11 -0700 (PDT)
Received: from brgl-uxlite.home ([2a01:cb1d:334:ac00:d9e8:ddbf:7391:a0b0])
        by smtp.gmail.com with ESMTPSA id q9-20020a7bce89000000b003f7cb42fa20sm10045229wmj.42.2023.06.19.02.24.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jun 2023 02:24:11 -0700 (PDT)
From: Bartosz Golaszewski <brgl@bgdev.pl>
To: Vinod Koul <vkoul@kernel.org>,
	Bhupesh Sharma <bhupesh.sharma@linaro.org>,
	Andy Gross <agross@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Jose Abreu <joabreu@synopsys.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Andrew Halaney <ahalaney@redhat.com>
Cc: netdev@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [RESEND PATCH net-next v2 00/14] net: stmmac: dwmac-qcom-ethqos: add support for EMAC4
Date: Mon, 19 Jun 2023 11:23:48 +0200
Message-Id: <20230619092402.195578-1-brgl@bgdev.pl>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

Extend the dwmac-qcom-ethqos driver to support EMAC4. While at it: rework the
code somewhat. The bindings have been reviewed by DT maintainers.

This is a sub-series of [1] with only the patches targetting the net subsystem
as they can go in independently.

[1] https://lore.kernel.org/lkml/20230617001644.4e093326@kernel.org/T/

Bartosz Golaszewski (14):
  net: stmmac: dwmac-qcom-ethqos: shrink clock code with devres
  net: stmmac: dwmac-qcom-ethqos: rename a label in probe()
  net: stmmac: dwmac-qcom-ethqos: tweak the order of local variables
  net: stmmac: dwmac-qcom-ethqos: use a helper variable for &pdev->dev
  net: stmmac: dwmac-qcom-ethqos: add missing include
  net: stmmac: dwmac-qcom-ethqos: add a newline between headers
  net: stmmac: dwmac-qcom-ethqos: remove stray space
  net: stmmac: dwmac-qcom-ethqos: add support for the optional serdes
    phy
  net: stmmac: dwmac-qcom-ethqos: add support for the phyaux clock
  net: stmmac: dwmac-qcom-ethqos: prepare the driver for more PHY modes
  net: stmmac: dwmac-qcom-ethqos: add support for SGMII
  net: stmmac: add new switch to struct plat_stmmacenet_data
  dt-bindings: net: qcom,ethqos: add description for sa8775p
  net: stmmac: dwmac-qcom-ethqos: add support for emac4 on sa8775p
    platforms

 .../devicetree/bindings/net/qcom,ethqos.yaml  |  12 +-
 .../devicetree/bindings/net/snps,dwmac.yaml   |   3 +
 .../stmicro/stmmac/dwmac-qcom-ethqos.c        | 284 +++++++++++++-----
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |   2 +-
 include/linux/stmmac.h                        |   1 +
 5 files changed, 226 insertions(+), 76 deletions(-)

-- 
2.39.2


