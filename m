Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 023086C2E13
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 10:39:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbjCUJjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 05:39:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjCUJjN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 05:39:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98D3410A99;
        Tue, 21 Mar 2023 02:39:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 366EDB81339;
        Tue, 21 Mar 2023 09:39:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D06C0C433EF;
        Tue, 21 Mar 2023 09:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679391548;
        bh=V6kdOKfFIbHI/ykoqHBq8eQrNQHaxHZhhUL4P5DUTFY=;
        h=From:To:Cc:Subject:Date:From;
        b=j2AKqO47VVWmdswohU3B1RKEjSLYMkMWntcy9Ry2AahnAgp27+zOoUIMUgxrene5F
         JrlfHDyK+jOifH3JfbSLWZzBJxfOCGMyZdcUyPjxXzyev/FzZg3/XtBwkzPgolN5gl
         prdlH669lMSNT2gw55uBfdWivYtkKdaIEK7S8F9KgXrErOvJywdZp/eQum3sBG1wsU
         jI6ZcNWsol5VGD8jPVAwRizLojwDFmC+y8AYumopQUJ3cCDZjOfHrePHsks57/XtIt
         SpOLheIp3gz68lW/CBu36sNpbg/jcWEBIPJZkXqJvGWfIGDULJE7wTlRBbHlxieeMu
         llSkuKOO7e6CQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan+linaro@kernel.org>)
        id 1peYTo-0002Xw-6q; Tue, 21 Mar 2023 10:40:32 +0100
From:   Johan Hovold <johan+linaro@kernel.org>
To:     Kalle Valo <kvalo@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Steev Klimaszewski <steev@kali.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        ath11k@lists.infradead.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>
Subject: [PATCH v2 0/2] arm64: dts: qcom: sc8280xp-x13s: add wifi calibration variant
Date:   Tue, 21 Mar 2023 10:40:09 +0100
Message-Id: <20230321094011.9759-1-johan+linaro@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds the missing calibration variant devicetree property
which is needed to load the (just released) calibration data and use the
ath11k wifi on the Lenovo Thinkpad X13s.

Kalle, can you take the binding through your tree and then Bjorn can
take the devicetree update through the qcom tree?

Johan


Changes in v2
 - rename DT schema file
 - fix model name typo in binding comment
 - amend calibration variant description
 - drop the corresponding change for the sc8280xp-crd which will need
   its own set of calibration data


Johan Hovold (2):
  dt-bindings: wireless: add ath11k pcie bindings
  arm64: dts: qcom: sc8280xp-x13s: add wifi calibration variant

 .../net/wireless/qcom,ath11k-pci.yaml         | 58 +++++++++++++++++++
 .../qcom/sc8280xp-lenovo-thinkpad-x13s.dts    | 17 ++++++
 2 files changed, 75 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/wireless/qcom,ath11k-pci.yaml

-- 
2.39.2

