Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91B086DE546
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 22:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbjDKUFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 16:05:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbjDKUFP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 16:05:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CFDB3C3B
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 13:04:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681243466;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=cxcg4D7oOn+vhVnnmmIAydop7TdCDBp1rp6PwiTdQPw=;
        b=iNGUMYXgOsuDTVO1ldoAGf09MRwjRca251MVio7z/NRinx5IeDuPLxr9ylk+wKm0ejuc7s
        PsLQQdZT2roF+tTCgVAAn9Fy1gHcpTf2STZNey5r9xImH8voFy/mmeNs7zNSK/9S5jp8pA
        y1zkzJ7d3RyttT5VyDP00/3TDHKTaWk=
Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com
 [209.85.160.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-631-AwR7bbLtMaeWTwzzr27hNQ-1; Tue, 11 Apr 2023 16:04:25 -0400
X-MC-Unique: AwR7bbLtMaeWTwzzr27hNQ-1
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-17fd0d597dcso20407487fac.6
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 13:04:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681243464;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cxcg4D7oOn+vhVnnmmIAydop7TdCDBp1rp6PwiTdQPw=;
        b=6vOMDdwH+RJQ8B1+EO4xbzzxLDgyQwoqe4+iqIMMR717YdP1nBMugVUywSEKsyQnEv
         Kpueh96uCsOlCYzmSXKU7mb3erHZIdEW8TXOjG5d7JJaX1GWqvWyB9CMc98rAy+tdnHK
         /9w0A6RKlM1O+jJtFkvYiyOuAb1HwuWoj2dbjMCeBbJ0mnvnbK/IAcM4X+uTrRjml2tK
         6zuYiVW/fa5jlW/YQWw35YdhM7EdI4iKxvR2tQuxS4S70C0RDweI6p8Peo/JxCbY4Pgw
         9TggtF8JlPfmj8mAADDd6++4q6Y8s3/hd7VustBu2Bb3dammeaWcdeuaMcRByDbgMXju
         Qofw==
X-Gm-Message-State: AAQBX9fAtKA6CTnmNxf0x/l+DBbjLwpl9RbTj0WTGOOLM/mS788xwrva
        7kWiMhCL8+Z2eI7YEuDeteexniRxy3JrQpwCCDxiO4fzy3H9UrOxJXFgxSny4IeQ8mT/uEKXYCh
        L2hs1D0IjSwbdJ7PV
X-Received: by 2002:aca:d743:0:b0:386:9720:77da with SMTP id o64-20020acad743000000b00386972077damr5007460oig.26.1681243464509;
        Tue, 11 Apr 2023 13:04:24 -0700 (PDT)
X-Google-Smtp-Source: AKy350azWr6mlU8tkLsqApkkAbbpQnuMkm8iMeE0b6zA76CdTeqoq06KhY/ps1Hoi3qB/iOjMgYrUA==
X-Received: by 2002:aca:d743:0:b0:386:9720:77da with SMTP id o64-20020acad743000000b00386972077damr5007433oig.26.1681243464151;
        Tue, 11 Apr 2023 13:04:24 -0700 (PDT)
Received: from halaney-x13s.attlocal.net (104-53-165-62.lightspeed.stlsmo.sbcglobal.net. [104.53.165.62])
        by smtp.gmail.com with ESMTPSA id e20-20020a056808149400b00387764759a3sm5868545oiw.24.2023.04.11.13.04.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 13:04:23 -0700 (PDT)
From:   Andrew Halaney <ahalaney@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     agross@kernel.org, andersson@kernel.org, konrad.dybcio@linaro.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, vkoul@kernel.org,
        bhupesh.sharma@linaro.org, wens@csie.org, jernej.skrabec@gmail.com,
        samuel@sholland.org, mturquette@baylibre.com,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        richardcochran@gmail.com, linux@armlinux.org.uk, veekhee@apple.com,
        tee.min.tan@linux.intel.com, mohammad.athari.ismail@intel.com,
        jonathanh@nvidia.com, ruppala@nvidia.com, bmasney@redhat.com,
        andrey.konovalov@linaro.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, ncai@quicinc.com,
        jsuraj@qti.qualcomm.com, hisunil@quicinc.com, echanude@redhat.com,
        Andrew Halaney <ahalaney@redhat.com>
Subject: [PATCH net-next v4 00/12] Add EMAC3 support for sa8540p-ride
Date:   Tue, 11 Apr 2023 15:03:57 -0500
Message-Id: <20230411200409.455355-1-ahalaney@redhat.com>
X-Mailer: git-send-email 2.39.2
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

This is a forward port / upstream refactor of code delivered
downstream by Qualcomm over at [0] to enable the DWMAC5 based
implementation called EMAC3 on the sa8540p-ride dev board.

From what I can tell with the board schematic in hand,
as well as the code delivered, the main changes needed are:

    1. A new address space layout for dwmac5/EMAC3 MTL/DMA regs
    2. A new programming sequence required for the EMAC3 based platforms

This series makes the changes above as well as other housekeeping items
such as converting dt-bindings to yaml, etc.

As requested[1], it has been split up by compilation deps / maintainer tree.
I will post a link to the associated devicetree changes that together
with this series get the hardware functioning.

Patches 1-3 are clean ups of the currently supported dt-bindings and
IMO could be picked up as is independent of the rest of the series to
improve the current codebase. They've all been reviewed in prior
versions of the series.

Patches 5-7 are also clean ups of the driver and are worth picking up
independently as well. They don't all have explicit reviews but should
be good to go (trivial changes on non-reviewed bits).

The rest of the patches have new changes, lack review, or are specificly
being made to support the new hardware, so they should wait until the
series as a whole is deemed ready to go by the community.

[0] https://git.codelinaro.org/clo/la/kernel/ark-5.14/-/commit/510235ad02d7f0df478146fb00d7a4ba74821b17
[1] https://lore.kernel.org/netdev/20230320202802.4e7dc54c@kernel.org/

v3: https://lore.kernel.org/netdev/20230331214549.756660-1-ahalaney@redhat.com/
v2: https://lore.kernel.org/netdev/20230320221617.236323-1-ahalaney@redhat.com/
v1: https://lore.kernel.org/netdev/20230313165620.128463-1-ahalaney@redhat.com/

Thanks,
Andrew

Andrew Halaney (9):
  dt-bindings: net: qcom,ethqos: Add Qualcomm sc8280xp compatibles
  net: stmmac: Remove unnecessary if statement brackets
  net: stmmac: Fix DMA typo
  net: stmmac: Remove some unnecessary void pointers
  net: stmmac: Pass stmmac_priv in some callbacks
  net: stmmac: dwmac4: Allow platforms to specify some DMA/MTL offsets
  net: stmmac: dwmac-qcom-ethqos: Respect phy-mode and TX delay
  net: stmmac: dwmac-qcom-ethqos: Use loopback_en for all speeds
  net: stmmac: dwmac-qcom-ethqos: Add EMAC3 support

Bhupesh Sharma (3):
  dt-bindings: net: snps,dwmac: Update interrupt-names
  dt-bindings: net: snps,dwmac: Add Qualcomm Ethernet ETHQOS compatibles
  dt-bindings: net: qcom,ethqos: Convert bindings to yaml

 .../devicetree/bindings/net/qcom,ethqos.txt   |  66 ------
 .../devicetree/bindings/net/qcom,ethqos.yaml  | 111 ++++++++++
 .../devicetree/bindings/net/snps,dwmac.yaml   |   9 +-
 MAINTAINERS                                   |   2 +-
 .../net/ethernet/stmicro/stmmac/chain_mode.c  |  10 +-
 drivers/net/ethernet/stmicro/stmmac/common.h  |   2 +-
 .../stmicro/stmmac/dwmac-qcom-ethqos.c        | 178 ++++++++++++----
 .../net/ethernet/stmicro/stmmac/dwmac-sun8i.c |  36 ++--
 .../ethernet/stmicro/stmmac/dwmac1000_core.c  |   3 +-
 .../ethernet/stmicro/stmmac/dwmac1000_dma.c   |  19 +-
 .../ethernet/stmicro/stmmac/dwmac100_dma.c    |  14 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4.h  | 101 +++++++--
 .../net/ethernet/stmicro/stmmac/dwmac4_core.c |  50 +++--
 .../ethernet/stmicro/stmmac/dwmac4_descs.c    |   8 +-
 .../net/ethernet/stmicro/stmmac/dwmac4_dma.c  | 201 +++++++++++-------
 .../net/ethernet/stmicro/stmmac/dwmac4_dma.h  |  92 +++++---
 .../net/ethernet/stmicro/stmmac/dwmac4_lib.c  | 105 +++++----
 .../net/ethernet/stmicro/stmmac/dwmac_dma.h   |  22 +-
 .../net/ethernet/stmicro/stmmac/dwmac_lib.c   |  18 +-
 .../ethernet/stmicro/stmmac/dwxgmac2_core.c   |   9 +-
 .../ethernet/stmicro/stmmac/dwxgmac2_descs.c  |   6 +-
 .../ethernet/stmicro/stmmac/dwxgmac2_dma.c    |  71 ++++---
 .../net/ethernet/stmicro/stmmac/enh_desc.c    |  11 +-
 drivers/net/ethernet/stmicro/stmmac/hwif.h    | 176 ++++++++-------
 .../net/ethernet/stmicro/stmmac/norm_desc.c   |   8 +-
 .../net/ethernet/stmicro/stmmac/ring_mode.c   |  10 +-
 .../net/ethernet/stmicro/stmmac/stmmac_mdio.c |   3 +-
 include/linux/stmmac.h                        |  19 ++
 28 files changed, 886 insertions(+), 474 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/qcom,ethqos.txt
 create mode 100644 Documentation/devicetree/bindings/net/qcom,ethqos.yaml

-- 
2.39.2

