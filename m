Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01665529CF0
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 10:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243005AbiEQIwM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 04:52:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240133AbiEQIwK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 04:52:10 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0340C3D1DE
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 01:52:09 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id u3so23776257wrg.3
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 01:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ooWlQ28C/ClIW8HO0hTRJ5kiNA3CspqPARdyx4NVCD8=;
        b=MSbiK9eEJXS/oJ70H4cp3xrjRR4Ljpv3P03ZEdI50I+DexPSEflno1g5a9pfoftm1+
         w/F7yn5BHR7GmFdBbLbdOCm6Bna6yeFNhybFjP8K4IWN4PiCaPNx3tEuOKkPa6lxG5cI
         tkeqUT2xCqU52MhtKMsEmWcl7lQgUBlaZ5TaPBeyXqlWp5/1fFD5NWQp8vJQGTORtN5j
         Urd83GmdAweJSN3cT/MjAT/oeRsgikQCXs7WvDNY7N+akjOXXHvi6zZkPG6NYK0b7AtA
         6O+G86e7XTdK5JPueksWLAK/BoYbbhOPhkT8+39YvOqnQNV84x/1ppBW5ZxCByelk2C2
         11rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ooWlQ28C/ClIW8HO0hTRJ5kiNA3CspqPARdyx4NVCD8=;
        b=vJVh840KWDpJQRdjVvj03OZU85xQrY6IpSA9Otj4UMYKuZ2KvFwUegrJIBD1LgbOjs
         7zAp57NmGEiWwQI2o7qAydm+lwPQKo/4KLGUo9Vu5CGRZlOZChSWx4bUNjZiLahc6hWa
         +5YfqdfSA24FouAzHu4hvBSi/tITP2dyrehzQb70CoJldjm/k+agLzVU9mRevCElzVFu
         Nwd3d+hMyKRfoRAGdAUju4728BTKXj6U36V1NLdW8iSfA76l3AZoaIZRrW5vQgP02voq
         gaerZ1uAhHWOewswd2UA+q4vFQhGMzN0d4FSDX1BL4w3ECVs2RpkRHhWJA533VOEObh4
         hivg==
X-Gm-Message-State: AOAM530Y+lnHSqOYozTc+U2CPijzBKqWoudpnb8M1Ju/9UcpHGJMcLcS
        f+gpp1SsJ+dOdWQ6CXtjq0kMQumyCZZXMRbjz6Q=
X-Google-Smtp-Source: ABdhPJwlRx9ds5nyRXekh9cGBHUs9foHSodx09y747rTWrLHUvRMeQJLQtWnRDzTAvgjwcvSRllNrA==
X-Received: by 2002:a05:6000:1f03:b0:20c:4d9e:7400 with SMTP id bv3-20020a0560001f0300b0020c4d9e7400mr17708041wrb.257.1652777527359;
        Tue, 17 May 2022 01:52:07 -0700 (PDT)
Received: from localhost.localdomain (bzq-82-81-54-179.red.bezeqint.net. [82.81.54.179])
        by smtp.gmail.com with ESMTPSA id d24-20020adfa358000000b0020d02cbbb87sm7652497wrb.16.2022.05.17.01.52.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 01:52:06 -0700 (PDT)
From:   Josua Mayer <josua@solid-run.com>
To:     netdev@vger.kernel.org
Cc:     alvaro.karsz@solid-run.com, Josua Mayer <josua@solid-run.com>
Subject: [PATCH v5 0/3] adin: add support for clock output
Date:   Tue, 17 May 2022 11:51:36 +0300
Message-Id: <20220517085143.3749-1-josua@solid-run.com>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds support for configuring the two clock outputs of adin
1200 and 1300 PHYs. Certain network controllers require an external reference
clock which can be provided by the PHY.

One of the replies to v1 was asking why the common clock framework isn't used.
Currently no PHY driver has implemented providing a clock to the network
controller. Instead they rely on vendor extensions to make the appropriate
configuration. For example ar8035 uses qca,clk-out-frequency - this patchset
aimed to replicate the same functionality.

Finally the 125MHz free-running clock is enabled in the device-tree for
SolidRun i.MX6 SoMs, to support revisions 1.9 and later, where the original phy
has been replaced with an adin 1300.
To avoid introducing new warning messages during boot for SoMs before rev 1.9,
the status field of the new phy node is disabled by default, and will be
enabled by U-Boot on demand.

Changes since v4:
- removed recovered clock options

Changes since v3:
- fix coding style violations reported by Andrew and checkpatch
- changed type of adi,phy-output-reference-clock from flag to boolean

Changes since v2:
- set new phy node status to disabled
- fix integer-as-null-pointer compiler warning
  Reported-by: kernel test robot <lkp@intel.com>

Changes since v1:
- renamed device-tree property and changed to enum
- added device-tree property for second clock output
- implemented all bits from the clock configuration register

Josua Mayer (3):
  dt-bindings: net: adin: document phy clock output properties
  net: phy: adin: add support for clock output
  ARM: dts: imx6qdl-sr-som: update phy configuration for som revision
    1.9

 .../devicetree/bindings/net/adi,adin.yaml     | 15 +++++++
 arch/arm/boot/dts/imx6qdl-sr-som.dtsi         | 10 +++++
 drivers/net/phy/adin.c                        | 40 +++++++++++++++++++
 3 files changed, 65 insertions(+)

-- 
2.35.3

