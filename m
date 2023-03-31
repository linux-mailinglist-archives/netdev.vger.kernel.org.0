Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ACB96D2A2D
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 23:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232671AbjCaVrD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 17:47:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232327AbjCaVrC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 17:47:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9B3420310
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 14:46:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680299171;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=qRXp4dQiGms/64nGsSVBVjLN6Pe4B52p8MOn8ojXq0c=;
        b=SCgdhLkq81Vl2bH6YKcNoP2DgwX2hYLl37ljqp8bBGdVFyD47aqPfY5ZbeoWSw9LdOm+/e
        frOGVt7XSx0xslKKuNkVVzvFzTXm6PQjhozRBdmcM757bDDwjjGr0zKmidiupRoqX2t62u
        KKRqW7Wud6R6Paf5A20i0FriCxIUNJU=
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com
 [209.85.160.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-117-adCTKJX1N9WCu1xOh5_KiA-1; Fri, 31 Mar 2023 17:46:09 -0400
X-MC-Unique: adCTKJX1N9WCu1xOh5_KiA-1
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-17714741d9dso11877665fac.4
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 14:46:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680299169;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qRXp4dQiGms/64nGsSVBVjLN6Pe4B52p8MOn8ojXq0c=;
        b=CkT8wma6oCnVEtusMqDQ7kMH0CjU4ll37t/k2+R85EWL1OToH+EkW7vIYoFR5LUIxG
         HmltoBFa9IW47MG8pDZiq/y3SnxWiaEFMKQPxOlpe65I+x2wnxJMHU23TYWo9vtHQtWv
         BVoKWlIlRF3g+ta+C7+gVaIjteUTBJV5a1A2kVEetVm/BOAQJmbzRqJpHJA2S8j90Llt
         gq7YZegBZPtQFwNEXxhevr5np7bzCVdtfT+pGlDUYb0ioH4MRLvd9ziiNMw5frMxoRNF
         8Us5Q9oi5RgYGz/ASos7G58KrTgZ/LiUC21WuoVp89BpI713gQKKIZ53hQ92tYmp8NT/
         AvJg==
X-Gm-Message-State: AAQBX9ftWIfH52vPl0Ubs9NLrIsWcJBRokhjxtaVUp1wuzAGOilVDf+H
        24jIVkBTCBq/nWJmyaziEgeJ9VgpvMH0GdoUhX9ovkiwoVLMMl2LMPVkkLiJriI9bPaDU5z1F5x
        Fu3J33Seh8B/4SclP
X-Received: by 2002:a9d:7310:0:b0:698:d198:fe9b with SMTP id e16-20020a9d7310000000b00698d198fe9bmr13806493otk.10.1680299169052;
        Fri, 31 Mar 2023 14:46:09 -0700 (PDT)
X-Google-Smtp-Source: AKy350bgDIpshy7eRbTWkRwLsC3s4240Hq2Oc16KqDrLzmDT3k9i5ye972UijmCNDTVHDvOHjC4iow==
X-Received: by 2002:a9d:7310:0:b0:698:d198:fe9b with SMTP id e16-20020a9d7310000000b00698d198fe9bmr13806471otk.10.1680299168800;
        Fri, 31 Mar 2023 14:46:08 -0700 (PDT)
Received: from halaney-x13s.attlocal.net (104-53-165-62.lightspeed.stlsmo.sbcglobal.net. [104.53.165.62])
        by smtp.gmail.com with ESMTPSA id x80-20020a4a4153000000b0053d9be4be68sm1328531ooa.19.2023.03.31.14.46.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 14:46:08 -0700 (PDT)
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
Subject: [PATCH net-next v3 00/12] Add EMAC3 support for sa8540p-ride
Date:   Fri, 31 Mar 2023 16:45:37 -0500
Message-Id: <20230331214549.756660-1-ahalaney@redhat.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
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

    1. A new address space layout for /dwmac5/EMAC3 MTL/DMA regs
    2. A new programming sequence required for the EMAC3 base platforms

This series makes the change for 1 above as well as other housekeeping items
such as converting dt-bindings to yaml, etc.

As requested[1], it has been split up by compile time / maintainer tree.
I will post a link to the associated devicetree changes that together
with this series get the hardware functioning.

[0] https://git.codelinaro.org/clo/la/kernel/ark-5.14/-/commit/510235ad02d7f0df478146fb00d7a4ba74821b17
[1] https://lore.kernel.org/netdev/20230320202802.4e7dc54c@kernel.org/

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
 .../stmicro/stmmac/dwmac-qcom-ethqos.c        | 177 +++++++++++----
 .../net/ethernet/stmicro/stmmac/dwmac-sun8i.c |  36 ++--
 .../ethernet/stmicro/stmmac/dwmac1000_core.c  |   3 +-
 .../ethernet/stmicro/stmmac/dwmac1000_dma.c   |  19 +-
 .../ethernet/stmicro/stmmac/dwmac100_dma.c    |  14 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4.h  |  91 ++++++--
 .../net/ethernet/stmicro/stmmac/dwmac4_core.c |  50 +++--
 .../ethernet/stmicro/stmmac/dwmac4_descs.c    |   8 +-
 .../net/ethernet/stmicro/stmmac/dwmac4_dma.c  | 201 +++++++++++-------
 .../net/ethernet/stmicro/stmmac/dwmac4_dma.h  |  89 +++++---
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
 28 files changed, 871 insertions(+), 475 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/qcom,ethqos.txt
 create mode 100644 Documentation/devicetree/bindings/net/qcom,ethqos.yaml

-- 
2.39.2

