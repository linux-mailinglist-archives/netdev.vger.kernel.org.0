Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A85F933826F
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 01:33:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231241AbhCLAcg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 19:32:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbhCLAcP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 19:32:15 -0500
Received: from mail-oo1-xc32.google.com (mail-oo1-xc32.google.com [IPv6:2607:f8b0:4864:20::c32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62712C061761
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 16:32:15 -0800 (PST)
Received: by mail-oo1-xc32.google.com with SMTP id c12-20020a4ae24c0000b02901bad05f40e4so1138299oot.4
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 16:32:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XxSa1u7IyhhucY0ze3n3dBYIqxQ4tI9IFhWrRdx0ULk=;
        b=zWgt1QAsksXwn37LZRT7NIO21xaLAynJ+w5PvmhbectrWotS+n50h0x+Uo5GlhZGiJ
         V4ecIoUP/8fA+uao7odaE+Rhx5x+K7qQ1mGlL3Le3aP2dhIFEB1XDJG4UPW0pMIZKQ39
         2H/RnWfSRrzxf3Shoi0y6i+x3yNXBKQUqLqbjMV/kU2qUb8HxdOVOjLnV50DHurc1fzb
         504DbhhatvTwPWNfMb8OD0DQRcAsIBvigp9+7bLvl8FfzFX3AbpYyeICSfXiZc+2rYw6
         ZePy/D6tmeber9lr/OekoFWDUkpLv+DPWDo21xUItVFCbqa778Zh9dnJ/5TQ/KM8rolB
         K7mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XxSa1u7IyhhucY0ze3n3dBYIqxQ4tI9IFhWrRdx0ULk=;
        b=iegj2IPF8874PksUHQPpFX22GpS1rkgvm1eFSZi3lo5qbrXB7sw1uY6CLiIr4VfgZN
         qW5JwnGwxuRWiYIeaXjm/4aQjpJxiz4xpWEm6jcF+Iggpu/JPaD98oWxzNItPr7GprWy
         f/nHLsX6Strx0LfDXiAPew9RtvtNczh+M4Px+C3xsCW9oLHCmw9s6o/bP/O+xl3Q4pbR
         HMgLm8yireyBV2+am2zLlULNOB4RbzN8AAehZJXo264IngqBDZ0iDkkIKbrhTOP/W/Dy
         c9Ox8MA2T22R4Z7Sgo7jNuzKEGpU2T40VHvTRtjAVnek4TJ0lCVVCoxNqkpKyzBPcBbC
         XtSw==
X-Gm-Message-State: AOAM531UKx03DPCudbW0lh3w64kRYB6MZhmOqjdPRfTyrQMEt7Cadcbu
        x4rAYHoDKcRdJUYZeeNu53qMsA==
X-Google-Smtp-Source: ABdhPJz6UIt7SjxfugwIFCAKdOTG8YHF2em4Ltec3Ma2jacxcarQZOOzmo/0z43hYlYZv20QAiPhkA==
X-Received: by 2002:a4a:dc51:: with SMTP id q17mr1259347oov.76.1615509134671;
        Thu, 11 Mar 2021 16:32:14 -0800 (PST)
Received: from localhost.localdomain (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id l190sm670835oig.39.2021.03.11.16.32.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 16:32:14 -0800 (PST)
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Cc:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 0/5] qcom: wcnss: Allow overriding firmware form DT
Date:   Thu, 11 Mar 2021 16:33:13 -0800
Message-Id: <20210312003318.3273536-1-bjorn.andersson@linaro.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The wireless subsystem found in Qualcomm MSM8974 and MSM8916 among others needs
platform-, and perhaps even board-, specific firmware. Add support for
providing this in devicetree.

Bjorn Andersson (5):
  dt-bindings: soc: qcom: wcnss: Add firmware-name property
  wcn36xx: Allow firmware name to be overridden by DT
  soc: qcom: wcnss_ctrl: Introduce local variable "dev"
  soc: qcom: wcnss_ctrl: Allow reading firmware-name from DT
  arm64: dts: qcom: msm8916: Enable modem and WiFi

 .../devicetree/bindings/soc/qcom/qcom,wcnss.txt   |  7 +++++++
 arch/arm64/boot/dts/qcom/apq8016-sbc.dtsi         | 12 ++++++++++++
 arch/arm64/boot/dts/qcom/msm8916.dtsi             |  2 +-
 drivers/net/wireless/ath/wcn36xx/main.c           |  7 +++++++
 drivers/net/wireless/ath/wcn36xx/smd.c            |  4 ++--
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h        |  1 +
 drivers/soc/qcom/wcnss_ctrl.c                     | 15 ++++++++++-----
 7 files changed, 40 insertions(+), 8 deletions(-)

-- 
2.29.2

