Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 525E93EE1B2
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 02:56:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237095AbhHQA43 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 20:56:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237025AbhHQA4O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 20:56:14 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2F2BC061146
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 17:55:26 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id k5so10212465lfu.4
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 17:55:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Pgxc5wTtAPJJ0DGyppg9xAOqF0AZtpwhIIHZ/fU+CFw=;
        b=HwDbiofct0TMB65omGXGchoWcB9pqFmXgylYFqrV+IPCkhhIk+Lc+xUFVyK+iwexVh
         BaN/elu+aEntGCLUZUMK9LwbqVepb8vBqq3+KkGl5eq8ph6kQo8uBRg3iNbL9p8MQDRk
         AGUcbP/cOzbyQR0fSHRxKQKuYlF8U3Tqb0kDQ0693qSsC1JRhX7XsgaFSljyZZND0yDD
         daJBvqi3qdAEnp9q9MoUaMSI4eshxddlIFStgVVccRzTIoWvtzhSNPzZkYDrQNyIV1sk
         5uteB81rUcjsgWOQpQlN8qjpaUmFXIbrjX4RVsaLWEcCoZJ7LnZpbhjwzWkAm3w2ipSa
         fPnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Pgxc5wTtAPJJ0DGyppg9xAOqF0AZtpwhIIHZ/fU+CFw=;
        b=btJuMHaaHwLKG+fzL61+k6vrQj52x86J1FrrHjtEapRZcD0LnWBego0Tp63pRg/1B9
         e+bm2PWkgW4hzXnnfKYbDqhokmekSVdJ2ClzjU2u7JOdCaQOphjIXReJ3dF4/wub4U7y
         paYkWNbNV0hVK4FHbok+hSIhMruKXkF7A6l5d/r9rdQTPiRVbMwq6KaluXh9/HE4FID5
         uEANB7xZZBmfKXJobO+vlAuWi1PgNo4gwCCRr2QcXCWM5Z1fharwGv7GtYwEsL35dFGx
         eZj5XkEPNrG1VbXDNjy5SqdaEzKFEo611W6aTxpvgIbqo1BSeDZS7U1nGAIAgymwk4LZ
         pFdA==
X-Gm-Message-State: AOAM5329zxffX2UjP9jf/PARJqnVjJt65ceaHPyYlU93NFMzTeQVq+MV
        i6oxd9Z5vayIGtVmFsdKJBl1Fg==
X-Google-Smtp-Source: ABdhPJxyuF7Jousa0ekVBo+HPfYk8A5Rq4PfYVTtE7a4QI12mfqo2ijMQkjYqeBcThS28ycqDu/ONA==
X-Received: by 2002:a05:6512:3a83:: with SMTP id q3mr420518lfu.28.1629161725069;
        Mon, 16 Aug 2021 17:55:25 -0700 (PDT)
Received: from eriador.lan ([37.153.55.125])
        by smtp.gmail.com with ESMTPSA id z6sm40719lfb.251.2021.08.16.17.55.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 17:55:24 -0700 (PDT)
From:   Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stanimir Varbanov <svarbanov@mm-sol.com>
Cc:     linux-arm-msm@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [RFC PATCH 15/15] WIP: arm64: dts: qcom: qrb5165-rb5: add bus-pwrseq property to pcie0
Date:   Tue, 17 Aug 2021 03:55:07 +0300
Message-Id: <20210817005507.1507580-16-dmitry.baryshkov@linaro.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210817005507.1507580-1-dmitry.baryshkov@linaro.org>
References: <20210817005507.1507580-1-dmitry.baryshkov@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
---
 arch/arm64/boot/dts/qcom/qrb5165-rb5.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/qrb5165-rb5.dts b/arch/arm64/boot/dts/qcom/qrb5165-rb5.dts
index 326330f528fc..0c347cb6f8e0 100644
--- a/arch/arm64/boot/dts/qcom/qrb5165-rb5.dts
+++ b/arch/arm64/boot/dts/qcom/qrb5165-rb5.dts
@@ -689,6 +689,7 @@ wifi-therm@1 {
 
 &pcie0 {
 	status = "okay";
+	bus-pwrseq = <&qca_pwrseq 0>;
 };
 
 &pcie0_phy {
-- 
2.30.2

