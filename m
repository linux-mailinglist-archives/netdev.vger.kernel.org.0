Return-Path: <netdev+bounces-901-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 48AE66FB4B6
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 18:08:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8A82D28100F
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 16:08:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6C224424;
	Mon,  8 May 2023 16:08:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 986DE17D0
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 16:08:18 +0000 (UTC)
Received: from mail-oa1-x34.google.com (mail-oa1-x34.google.com [IPv6:2001:4860:4864:20::34])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D4564EE5;
	Mon,  8 May 2023 09:08:17 -0700 (PDT)
Received: by mail-oa1-x34.google.com with SMTP id 586e51a60fabf-1927718b240so3014939fac.1;
        Mon, 08 May 2023 09:08:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683562096; x=1686154096;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6LD3Dby/8UnB2TQdVJHksGEYFyHRfIWgMsXp5YA/0W4=;
        b=GuULG0dFG4Gxqjka1BMjjqZYVwBW/eqTi7RbBsNnecmEjYYWA9o8qIGlEYiZAbc+/w
         GwLZHIfkGa5H0FnCHVxFECpfJJvPhrfUnmgYs6K2A9ODVCABo4/j61lTT7j1sT13EcuN
         zM32xn17/1/8UzEKoKjIky2C2chRSRUelo6ZBA8iec4vIZEeP8mpaCQF+Q5HcXRJB0C6
         mLCwpEbUBo0Nspi07r2e8B1XAn1HbGE4/i8jnoH+9vyWDqGKEPIMp2ZU2l2T4Of16laf
         nDmNT53k5cfMDf2hKM5UGsKWiL81XQF6+YfSlDkEpulWqEMc/mJF17YMCDisFBf0LTeJ
         bv2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683562096; x=1686154096;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6LD3Dby/8UnB2TQdVJHksGEYFyHRfIWgMsXp5YA/0W4=;
        b=Ei4GKEh0Z87VpXo0f8wvgRg1NZJeFVK0Go7eJSaD5mluNvBeg18RUfpbLtjapdzF6Q
         2MFi55hBymF3prgudMXBUzw7qW5LirSQZJTa6QY1ogbxW1z2Uf/vG+iP8hlRdbPnDJuv
         BwNBrU8fARhUzAAFfOwDmtLaLJXf1jlPA8x1xCxbea5/XCpgQODQpFinZopVcVjOBAWd
         EJ+qtkZfrO2xWMDoAWSsDDoPFY0DhilzDDN6iqKH+/h0sThXHC2KRMRnGqap60dWNp7o
         DBD614Mz3A8mRS96wag5CqffKO0fag4O+I8O3HUil3NnLsWqqUJONzMsfJsrMoLCNwro
         o9Tw==
X-Gm-Message-State: AC+VfDyYpP9ym3h3WyDReVIUoDP3Z+voC+UznNpdrws1PzQtwXEURZ7t
	yY1GUiIN3FBpf+1IdjshsAb+4ZWbokg2KQ==
X-Google-Smtp-Source: ACHHUZ6s4IMyzdiFjAyMenwg+XGqfN9NJsOwu0Yq0SrvJQ7Ut9Qxq/5PQju1U3Mrr+lZYef3ZHGkNA==
X-Received: by 2002:aca:2b06:0:b0:38c:11b3:a397 with SMTP id i6-20020aca2b06000000b0038c11b3a397mr4754488oik.14.1683562096550;
        Mon, 08 May 2023 09:08:16 -0700 (PDT)
Received: from localhost.localdomain ([76.244.6.13])
        by smtp.gmail.com with ESMTPSA id v206-20020aca61d7000000b0038c0a359e74sm136391oib.31.2023.05.08.09.08.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 09:08:16 -0700 (PDT)
From: Chris Morgan <macroalpha82@gmail.com>
To: devicetree@vger.kernel.org
Cc: linux-rockchip@lists.infradead.org,
	netdev@vger.kernel.org,
	anarsoul@gmail.com,
	alistair@alistair23.me,
	heiko@sntech.de,
	conor+dt@kernel.org,
	krzysztof.kozlowski+dt@linaro.org,
	robh+dt@kernel.org,
	pabeni@redhat.com,
	kuba@kernel.org,
	edumazet@google.com,
	davem@davemloft.net,
	Chris Morgan <macromorgan@hotmail.com>
Subject: [PATCH 0/2] Correct fallback compatible for rtl8821cs bluetooth
Date: Mon,  8 May 2023 11:08:09 -0500
Message-Id: <20230508160811.3568213-1-macroalpha82@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Chris Morgan <macromorgan@hotmail.com>

The realtek 8821cs bluetooth module is functionally very similar to the
8822cs and 8723bs modules, however unlike the 8822 module it seems to
struggle when power management features are enabled. By switching the
fallback string from realtek,rtl8822cs-bt to realtek,rtl8723bs-bt we
can instruct the driver to not enable advanced power management
features that cause the issues.

Chris Morgan (2):
  dt-bindings: net: realtek-bluetooth: Fix RTL8821CS binding
  arm64: dts: rockchip: Fix compatible for Bluetooth

 Documentation/devicetree/bindings/net/realtek-bluetooth.yaml | 2 +-
 arch/arm64/boot/dts/rockchip/rk3566-anbernic-rgxx3.dtsi      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

-- 
2.34.1


