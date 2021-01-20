Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74E052FE315
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 07:42:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729920AbhATXnb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 18:43:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729047AbhATV1g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 16:27:36 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36979C0613D6
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 13:26:11 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id e22so26111401iog.6
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 13:26:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YXXV9c9WKgadxq6Z4uVJs3qrKStMf5F06B0reLAMGUg=;
        b=obICub08u3TKWOIQP8jWfqoQ65pQAelEhsWLTsxpQ9mflzxooSx1BtRS3lyh9PJuYD
         1VyMyg8xLR1wMSUVXSBXj1N3Wd19xOOciQMCfo9U574wFO6zRWC0EvUe4+UzgpzwgX19
         e2JABF15y2eiQ7jmqu+PGuWjon+e1CvSa3p+Ld0dezU5lO3WYI6XcLAv4Z1w2Nqa95/9
         52w94SX2lv9xF1M8Qa+Uvykw+sCgJSd7RoL7IT6swChFD2u8x5jJgPfT5XwBxvx7ABTB
         ZCDEINHZlv8Oe79UyxKSqJJgztthWZVMZwONgDhuV2dQbfbaEZMhwWJzc+CTVe9t/g8u
         i4ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YXXV9c9WKgadxq6Z4uVJs3qrKStMf5F06B0reLAMGUg=;
        b=jBljP4KjftJMTf0UQP+XtqDSmVI3kq5X/W5lYbNahMLPh6UqqXUoFszP/zzCOqb3uW
         eU0aAKUX9eWVcafDveiWaKOOTuur6r6XZ/mhRFHItnX/Sf4ozQ/864cWU/am58QDSMny
         QnI0GbEVLN+OpyoQwWuDK8arV4Gt39ueUfG2m+PDGn23J5BuMdKuZSB3T3dA6ED9BdHt
         ZoSUtE4Im3Xl2/KINFzhYhLN2NjIuK1P4gmwl7k8CQKfenq2vUhVpk3u3lnGX5bPfRj3
         KAydRvj6RtstzYbNtdA58QzIc7h9eZB2ifE8TT3xpUWqJiPzPI17zfHF3kEkajDz8jT7
         xpAA==
X-Gm-Message-State: AOAM532sdGvSKqDUysDa2N6ZaLnFQQkA8NXQCLn1X0ZkX3+4OS+kSSIe
        Su4oBp/Ua2Zr4g+MAmsJfzlouw==
X-Google-Smtp-Source: ABdhPJydebF8rvITp21O4iWGarRssmn+Okq1r/VxSdQjhCSwnLHM6s5tJW9QDIJIE4KeuSZZvp8q4w==
X-Received: by 2002:a92:a010:: with SMTP id e16mr9038816ili.38.1611177970421;
        Wed, 20 Jan 2021 13:26:10 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id q196sm1335687iod.27.2021.01.20.13.26.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 13:26:09 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, bjorn.andersson@linaro.org, agross@kernel.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, robh+dt@kernel.org, rdunlap@infradead.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH v3 net-next 0/4] net: ipa: remove a build dependency
Date:   Wed, 20 Jan 2021 15:26:02 -0600
Message-Id: <20210120212606.12556-1-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(David/Jakub, please take these all through net-next if they are
acceptable to you, once Rob has acked the binding.  Rob, please ack
if the binding looks OK to you.)

Version 3 removes the "Fixes" tag from the first patch, and updates
the addressee list to include some people I apparently missed.

Version 2 includes <.../arm-gic.h> rather than <.../irq.h> in the
example section of the DT binding, to ensure GIC_SPI is defined.
I verified this passes "make dt_bindings_check".

The rest of the series is unchanged.  Below is the original cover
letter.

---

Unlike the original (temporary) IPA notification mechanism, the
generic remoteproc SSR notification code does not require the IPA
driver to maintain a pointer to the modem subsystem remoteproc
structure.

The IPA driver was converted to use the newer SSR notifiers, but the
specification and use of a phandle for the modem subsystem was never
removed.

This series removes the lookup of the remoteproc pointer, and that
removes the need for the modem DT property.  It also removes the
reference to the "modem-remoteproc" property from the DT binding,
and from the DT files that specified them.

David/Jakub, please take these all through net-next if they are
acceptable to you, once Rob has acked the binding and DT patches.

Thanks.

					-Alex

Alex Elder (4):
  net: ipa: remove a remoteproc dependency
  dt-bindings: net: remove modem-remoteproc property
  arm64: dts: qcom: sc7180: kill IPA modem-remoteproc property
  arm64: dts: qcom: sdm845: kill IPA modem-remoteproc property

 .../devicetree/bindings/net/qcom,ipa.yaml     | 15 ++------
 arch/arm64/boot/dts/qcom/sc7180.dtsi          |  2 -
 arch/arm64/boot/dts/qcom/sdm845.dtsi          |  2 -
 drivers/net/ipa/ipa.h                         |  2 -
 drivers/net/ipa/ipa_main.c                    | 38 +------------------
 5 files changed, 5 insertions(+), 54 deletions(-)

-- 
2.20.1

