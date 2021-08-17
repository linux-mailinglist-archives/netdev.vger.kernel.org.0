Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEEFC3EE1C0
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 02:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235635AbhHQAzt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 20:55:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235200AbhHQAzr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 20:55:47 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 243D3C0617AD
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 17:55:15 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id h9so30118892ljq.8
        for <netdev@vger.kernel.org>; Mon, 16 Aug 2021 17:55:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=C/jXyVM8A6IIIf73CUW3opic/WD75vfkmRvuKQWW4Jo=;
        b=Ilqv4TYrhWro5ne/pyK8Z8uNieTgQV6uYOzuf7BRghGmB8vnlhfGvOr/0/e/S1IwQs
         7hQf66rKkZbN2FzNg/lAkY8kGf8968Opho/WF3Oda7z3Bq5zGkHWUDeKdTIMK9vnpdcr
         Q21Q+ebQypHAX5SMsmdNk0shvXZpPmldQV8JkAnN+rTBj1EPUQqbI161vTAsodd2SjvZ
         MCqb1O1Ze+1fb4BtL/U3gENTSpiIzkKkc+t3xLBPezJesXnuxw+T6kn1KhGum0t21LcO
         jMIXT/hfLcwRdk65I9OuXZg0sgiZ+Ph1sisDURKJYN/RBaSvnazEEt1aLfLUFDVTen6Z
         an+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=C/jXyVM8A6IIIf73CUW3opic/WD75vfkmRvuKQWW4Jo=;
        b=LH1E2AbJl9Y17mtDSySuQsXyZ2T+aTfWkW3cRc65xVcUk5/Lv8Q8Ww5J/seBizc4OA
         NkFNr/jfWhh4godc1f5qUl6kLM72PZZStw5k2JwU/+K5BKyBJ+7McxoBw7tWlknf5Vg2
         9tO1TyK1fwoD3PUOB1YiNpRsaobj/ObDDDZ+2VdTJ/+PAgfx4X5m++i9RkzioG6hmKqm
         Dvt9axK5RN+94CyLIk4L1/j6DiehSVklo+M/609BJi+84MInsUbVdmpBeFO880cLZ3T3
         Hz7yv5c0EbKjoivsrrWu/REJDCM7lm9JOFmopSM3q7zVn8/XEONhvc5HQ+wRTgEArBHy
         Ailw==
X-Gm-Message-State: AOAM5317zjYJmaKYYixIjKAfj5xxmgFIoCOcJdB6MbD/YRlcHDT3Qd0K
        UBTtHZn9Gv19+qyeWbCL3Pt4xg==
X-Google-Smtp-Source: ABdhPJxgPqsyxqeCXBI3IsVJLkcFyXipmzYz3hTJEmurF1pvQfTvThKjXBvusty3YDmk6qnRjBkDxQ==
X-Received: by 2002:a05:651c:118f:: with SMTP id w15mr779302ljo.47.1629161713357;
        Mon, 16 Aug 2021 17:55:13 -0700 (PDT)
Received: from eriador.lan ([37.153.55.125])
        by smtp.gmail.com with ESMTPSA id z6sm40719lfb.251.2021.08.16.17.55.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 17:55:12 -0700 (PDT)
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
Subject: [RFC PATCH 00/15] create power sequencing subsystem
Date:   Tue, 17 Aug 2021 03:54:52 +0300
Message-Id: <20210817005507.1507580-1-dmitry.baryshkov@linaro.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an RFC of the proposed power sequencer subsystem. This is a
generification of the MMC pwrseq code. The subsystem tries to abstract
the idea of complex power-up/power-down/reset of the devices.

The primary set of devices that promted me to create this patchset is
the Qualcomm BT+WiFi family of chips. They reside on serial+platform
interfaces (older generations) or on serial+PCIe (newer generations).
They require a set of external voltage regulators to be powered on and
(some of them) have separate WiFi and Bluetooth enable GPIOs.

This patchset being an RFC tries to demonstrate the approach, design and
usage of the pwrseq subsystem. Following issues are present in the RFC
at this moment but will be fixed later if the overall approach would be
viewed as acceptable:

 - No documentation
   While the code tries to be self-documenting proper documentation
   would be required.

 - Minimal device tree bindings changes
   There are no proper updates for the DT bindings (thus neither Rob
   Herring nor devicetree are included in the To/Cc lists). The dt
   schema changes would be a part of v1.

 - Lack of proper PCIe integration
   At this moment support for PCIe is hacked up to be able to test the
   PCIe part of qca6390. Proper PCIe support would require automatically
   powering up the devices before the scan basing on the proper device
   structure in the device tree.

----------------------------------------------------------------
Dmitry Baryshkov (15):
      power: add power sequencer subsystem
      pwrseq: port MMC's pwrseq drivers to new pwrseq subsystem
      mmc: core: switch to new pwrseq subsystem
      ath10k: add support for pwrseq sequencing
      Bluetooth: hci_qca: merge qca_power into qca_serdev
      Bluetooth: hci_qca: merge init paths
      Bluetooth: hci_qca: merge qca_power_on with qca_regulators_init
      Bluetooth: hci_qca: futher rework of power on/off handling
      Bluetooth: hci_qca: add support for pwrseq
      pwrseq: add support for QCA BT+WiFi power sequencer
      arm64: dts: qcom: sdm845-db845c: switch bt+wifi to qca power sequencer
      arm64: dts: qcom: qrb5165-rb5: add bluetooth support
      arm64: dts: qcom: sdm845-db845c: add second channel support to qca power sequencer
      WIP: PCI: qcom: use pwrseq to power up bus devices
      WIP: arm64: dts: qcom: qrb5165-rb5: add bus-pwrseq property to pcie0

 .../{mmc => power/pwrseq}/mmc-pwrseq-emmc.yaml     |   0
 .../{mmc => power/pwrseq}/mmc-pwrseq-sd8787.yaml   |   0
 .../{mmc => power/pwrseq}/mmc-pwrseq-simple.yaml   |   0
 arch/arm64/boot/dts/qcom/qrb5165-rb5.dts           |  51 +++
 arch/arm64/boot/dts/qcom/sdm845-db845c.dts         |  28 +-
 arch/arm64/boot/dts/qcom/sdm845.dtsi               |   6 +
 drivers/bluetooth/hci_qca.c                        | 286 +++++++-------
 drivers/mmc/core/Kconfig                           |  32 --
 drivers/mmc/core/Makefile                          |   4 -
 drivers/mmc/core/core.c                            |   9 +-
 drivers/mmc/core/host.c                            |   8 +-
 drivers/mmc/core/mmc.c                             |   3 +-
 drivers/mmc/core/pwrseq.c                          | 117 ------
 drivers/mmc/core/pwrseq.h                          |  58 ---
 drivers/mmc/core/pwrseq_emmc.c                     | 120 ------
 drivers/mmc/core/pwrseq_sd8787.c                   | 107 ------
 drivers/mmc/core/pwrseq_simple.c                   | 164 --------
 drivers/net/wireless/ath/ath10k/snoc.c             |  63 +++-
 drivers/net/wireless/ath/ath10k/snoc.h             |   2 +
 drivers/pci/controller/dwc/pcie-qcom.c             |  13 +
 drivers/power/Kconfig                              |   1 +
 drivers/power/Makefile                             |   1 +
 drivers/power/pwrseq/Kconfig                       |  57 +++
 drivers/power/pwrseq/Makefile                      |  11 +
 drivers/power/pwrseq/core.c                        | 411 +++++++++++++++++++++
 drivers/power/pwrseq/pwrseq_emmc.c                 | 118 ++++++
 drivers/power/pwrseq/pwrseq_qca.c                  | 291 +++++++++++++++
 drivers/power/pwrseq/pwrseq_sd8787.c               |  97 +++++
 drivers/power/pwrseq/pwrseq_simple.c               | 160 ++++++++
 include/linux/mmc/host.h                           |   4 +-
 include/linux/pwrseq/consumer.h                    |  88 +++++
 include/linux/pwrseq/driver.h                      |  71 ++++
 32 files changed, 1592 insertions(+), 789 deletions(-)
 rename Documentation/devicetree/bindings/{mmc => power/pwrseq}/mmc-pwrseq-emmc.yaml (100%)
 rename Documentation/devicetree/bindings/{mmc => power/pwrseq}/mmc-pwrseq-sd8787.yaml (100%)
 rename Documentation/devicetree/bindings/{mmc => power/pwrseq}/mmc-pwrseq-simple.yaml (100%)
 delete mode 100644 drivers/mmc/core/pwrseq.c
 delete mode 100644 drivers/mmc/core/pwrseq.h
 delete mode 100644 drivers/mmc/core/pwrseq_emmc.c
 delete mode 100644 drivers/mmc/core/pwrseq_sd8787.c
 delete mode 100644 drivers/mmc/core/pwrseq_simple.c
 create mode 100644 drivers/power/pwrseq/Kconfig
 create mode 100644 drivers/power/pwrseq/Makefile
 create mode 100644 drivers/power/pwrseq/core.c
 create mode 100644 drivers/power/pwrseq/pwrseq_emmc.c
 create mode 100644 drivers/power/pwrseq/pwrseq_qca.c
 create mode 100644 drivers/power/pwrseq/pwrseq_sd8787.c
 create mode 100644 drivers/power/pwrseq/pwrseq_simple.c
 create mode 100644 include/linux/pwrseq/consumer.h
 create mode 100644 include/linux/pwrseq/driver.h


