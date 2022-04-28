Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51912512E8F
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 10:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbiD1IgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 04:36:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344435AbiD1Ifx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 04:35:53 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDDEBA6239
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 01:29:09 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id s21so5678518wrb.8
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 01:29:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solid-run-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=s06qisv7MTdD7YM5ZDgjLFIutuhY/Wyf7MBMoH1xRvU=;
        b=ZwL8Nz2+HCH7HjinkNRFbneippVy3uAvrvt+T/QATX2y5asMq/+k40/RmAnAzLwIOG
         erFT/omF/Xhot6gr63xYFbmCcI7IVXXatDJ9LNQp1ji2imuBVyYioJ92RwAjihtIcrdx
         FA9Qa4TPGy0Y/3j1dMG8gTr1PrMUNGJjDFIzwtjIyyUqiympi/ptOH42Rep8Ovu4hwtF
         kwH84K2sW+4gTTvu5nKsSFZ4lZ1fM4kIkSi4QyqZqOR+fbPbfcK212MdBDHkeMNObzAv
         wBcF/BGzS6SSFlZHcHCZBS//rdNfo0HhTWwEj8tnp2J/Xr2QINC68oytADsCNGCmGo2n
         Z/Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=s06qisv7MTdD7YM5ZDgjLFIutuhY/Wyf7MBMoH1xRvU=;
        b=pPHZC7YbsKniZIfIctA05h2FRKmIDR5HRSzOaODUiQlkAWzMeWcMullVAf5BXJOb2H
         LpNWcA7RwGbHbZg0od6nFoSktIeo/7BK0QfNtp+hvbbDCLX0538f/EjMtjlDEL7C2R5q
         jfqzzJL+DxS+MFSP2XPOnkpgOZlOUKCdCl5219nbqg/YTRkf9f0iN4s57Iy6o+2hz4we
         gIabZeOo/U21ukTdGVpfWypIUuplZwgog6XaMK0lGrH8QTMXFG/FmL06419+3r02LmG6
         U2MZsNKaPHG8db/LBKPDEAv3+lN2VrClBSTz2EB+YKh3URaljzd1laRACIqyz5Fgz084
         c4RA==
X-Gm-Message-State: AOAM532mlzl2KjC0w8xzPpA9OuC3MBeiKMg3cmlJPGLdZPGyEWXcrqfT
        XsqzCiDb9koBFa3Dxs0mRHeDhL97XhHWeGTo0Kk=
X-Google-Smtp-Source: ABdhPJzbJkjxdpBa0BQJSEUe11fP4UmLSCUr3yx6DLGbG1oacfzfiduVKDzdZbCemHcM6QTWPYzSWQ==
X-Received: by 2002:a05:6000:1788:b0:20a:a4b0:dbbc with SMTP id e8-20020a056000178800b0020aa4b0dbbcmr25177052wrg.384.1651134548032;
        Thu, 28 Apr 2022 01:29:08 -0700 (PDT)
Received: from josua-work.lan (bzq-82-81-222-124.cablep.bezeqint.net. [82.81.222.124])
        by smtp.gmail.com with ESMTPSA id bj3-20020a0560001e0300b0020af3d365f4sm1876249wrb.98.2022.04.28.01.29.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 01:29:07 -0700 (PDT)
From:   Josua Mayer <josua@solid-run.com>
To:     netdev@vger.kernel.org
Cc:     alvaro.karsz@solid-run.com, Josua Mayer <josua@solid-run.com>
Subject: [PATCH v3 0/3] adin: add support for clock output
Date:   Thu, 28 Apr 2022 11:28:45 +0300
Message-Id: <20220428082848.12191-1-josua@solid-run.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220419102709.26432-1-josua@solid-run.com>
References: <20220419102709.26432-1-josua@solid-run.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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

 .../devicetree/bindings/net/adi,adin.yaml     | 17 +++++++
 arch/arm/boot/dts/imx6qdl-sr-som.dtsi         | 10 +++++
 drivers/net/phy/adin.c                        | 44 +++++++++++++++++++
 3 files changed, 71 insertions(+)

-- 
2.34.1

