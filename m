Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 295916D2A7F
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 23:59:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232917AbjCaV7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 17:59:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232373AbjCaV7i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 17:59:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 954892369F
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 14:58:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680299896;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=7tV7oZA0rf1CWc0Q6Zc1vdOEds4O2Q0Uu3zvNJJAMp4=;
        b=a2ysPphvUiPkh5g0+KU786AtEMG9H/ZcNY83xwH/g005r983pC+LSVyK2GBjR9iXB1rXSi
        +WL9rpa6KQ0NfcFR+TiAhVhB2Z7hLD8I0+EMWC/YK8w4u8wJMr7d0Sy5DYjUBrs+ztjyiq
        bS7u1A8bnAuvX63b2pmbmHiDCIutuRc=
Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com
 [209.85.160.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-391-0xegcdkPOwe8cPkoSc7LDg-1; Fri, 31 Mar 2023 17:58:15 -0400
X-MC-Unique: 0xegcdkPOwe8cPkoSc7LDg-1
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-177c9cc7db5so12196475fac.15
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 14:58:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680299895;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7tV7oZA0rf1CWc0Q6Zc1vdOEds4O2Q0Uu3zvNJJAMp4=;
        b=Qcr247BgNnQ3d0/DjObRFGudEbo49DCQUnFa1t3OSGEcVrqMKKfX645aBmPl30gIHf
         4SZrGTTx2PNHjmdlCUQ9CH4WkSwApZPuXiEkX0vxM2BmV/KYNr0bZOxCYbM1EEgfAZ9y
         d9nOAI+bjzyUhQFoUA8oTZFZkJpbC9D8MuRgWu9gu7Z7ZJ8TuJim/lXB05IQkL8dfkqX
         KtpZcTcADcRScEvkKDdFwYOKGFWY2ZBKrIXeA9+bViluyMb65357xXUyZg1lJ49lW0bT
         Zg6vEJZVqE0c2byLHvAm3EJrKzNiR3UsqU6LpJR7y6tF1ifCZ1lITME36Zauzh7BDGcs
         qXnw==
X-Gm-Message-State: AAQBX9fCnCzMa+kwoPY8urnxm9noroyEeSE7ESlRTSBjCZd6K98PvQBI
        lZ6WsT8XccUgVAsu4zKCLk7u/pMPzCwWbyw3kzDLzohN0Rb/tyW1wPB0XyZFTa79uyMNDcj18Y6
        D06D4jzfZa+47zXte
X-Received: by 2002:a05:6808:317:b0:389:802c:e05c with SMTP id i23-20020a056808031700b00389802ce05cmr2914620oie.36.1680299893299;
        Fri, 31 Mar 2023 14:58:13 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZfSnIHSiAs6qQFCSFg5oXHvf1l57MZRo45w4kEano5Uf6AfeqYj1UlImKAN6fHj3KUzjv9+A==
X-Received: by 2002:a05:6808:317:b0:389:802c:e05c with SMTP id i23-20020a056808031700b00389802ce05cmr2914579oie.36.1680299891595;
        Fri, 31 Mar 2023 14:58:11 -0700 (PDT)
Received: from halaney-x13s.attlocal.net (104-53-165-62.lightspeed.stlsmo.sbcglobal.net. [104.53.165.62])
        by smtp.gmail.com with ESMTPSA id g11-20020a4a894b000000b0053bb2ae3a78sm1299277ooi.24.2023.03.31.14.58.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 14:58:11 -0700 (PDT)
From:   Andrew Halaney <ahalaney@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     agross@kernel.org, andersson@kernel.org, konrad.dybcio@linaro.org,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        mturquette@baylibre.com, sboyd@kernel.org,
        richardcochran@gmail.com, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-clk@vger.kernel.org,
        netdev@vger.kernel.org, bmasney@redhat.com, echanude@redhat.com,
        ncai@quicinc.com, jsuraj@qti.qualcomm.com, hisunil@quicinc.com,
        Andrew Halaney <ahalaney@redhat.com>
Subject: [PATCH v3 0/3] Add EMAC3 support for sa8540p-ride (devicetree/clk bits)
Date:   Fri, 31 Mar 2023 16:58:01 -0500
Message-Id: <20230331215804.783439-1-ahalaney@redhat.com>
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


This series addresses the devicetree and clock changes to support this
hardware bringup.

As requested[1], it has been split up by compile time / maintainer tree.
The associated v3 of the netdev specific changes can be found at [2].
Together, they result in the ethernet controller working for
both controllers on this platform.

[0] https://git.codelinaro.org/clo/la/kernel/ark-5.14/-/commit/510235ad02d7f0df478146fb00d7a4ba74821b17
[1] https://lore.kernel.org/netdev/20230320202802.4e7dc54c@kernel.org/
[2] https://lore.kernel.org/netdev/20230331214549.756660-1-ahalaney@redhat.com/T/#m0afcad0e8031c02bcb5dbfb86cb8acfc287968fe

v2: https://lore.kernel.org/netdev/20230320221617.236323-1-ahalaney@redhat.com/
v1: https://lore.kernel.org/netdev/20230313165620.128463-1-ahalaney@redhat.com/

Thanks,
Andrew

Andrew Halaney (3):
  clk: qcom: gcc-sc8280xp: Add EMAC GDSCs
  arm64: dts: qcom: sc8280xp: Add ethernet nodes
  arm64: dts: qcom: sa8540p-ride: Add ethernet nodes

 arch/arm64/boot/dts/qcom/sa8540p-ride.dts     | 181 ++++++++++++++++++
 arch/arm64/boot/dts/qcom/sc8280xp.dtsi        |  59 ++++++
 drivers/clk/qcom/gcc-sc8280xp.c               |  18 ++
 include/dt-bindings/clock/qcom,gcc-sc8280xp.h |   2 +
 4 files changed, 260 insertions(+)

-- 
2.39.2

