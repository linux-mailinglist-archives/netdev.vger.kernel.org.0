Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D35F6DE59B
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 22:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbjDKUVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 16:21:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbjDKUVV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 16:21:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8AC81700
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 13:20:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681244427;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=1X1257RiPm0+EqIQdLdY8EZJdNOboaVApm9s8W5RPoA=;
        b=dcKlDDAYXHDtFmxllzFF1vWU/e5RklSZSz3hNU98DrZVH4Xqf18atPaMnK/a6/6ZwhlsOe
        5OARl9Op97XLIplTrPRK2TjS8Wvthea2jKmCyLt2IfXoBgcumzVYQ2+fSCb6WH0pM4ity4
        ULjgMoPYULVSjIk4sypVN7mUrH3u/rE=
Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com
 [209.85.160.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-467-RAstr_9vMVaqxZ4v5znfqg-1; Tue, 11 Apr 2023 16:20:24 -0400
X-MC-Unique: RAstr_9vMVaqxZ4v5znfqg-1
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-1840884e926so7027772fac.15
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 13:20:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681244423;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1X1257RiPm0+EqIQdLdY8EZJdNOboaVApm9s8W5RPoA=;
        b=AT2twSpHSFaV0JivwYaJnY6ETW2EIswnavrJMWit753fKYDv6kTqoAiPLbeKlGFcf7
         vCveCen9bKuhsaaDOPMi5JtvlQoQYybKiYtqSNHzt/PPzc4MyuPOPTGnEKxitEQh3cCA
         J3WtNvzxNh66GjR6xv5KU5LD5yrOUNw1n9IZQdxL2fBjiLxT5V4nKWt5KAGG05LHw4Qi
         dxhE4x9O/oWHxYdn6BcSFyZsxoE2ysQij2TA7tyfvF7PiXiPR6hUR369y5xGKSdY7xAm
         xAO3i+ilNHm8IVU5/D/eAsJN/hWafJWQ80g6csIFzg+JRArv0Lp/iOQJfA3ux+AAj1hU
         2urg==
X-Gm-Message-State: AAQBX9dTQTD4o67Vn2ioqlTGxXdwS5SFisR298YODLpzOgI6qXSwPkyK
        Fx63+ifyZ0lpWM24hWuWCAmiPprF2z5J+oWc5H0YD1fnHCcnnZO3hw1C1YmHwSQS6yZGx4XCuVw
        zG2N5exmpW2Q5a5HC
X-Received: by 2002:aca:2116:0:b0:384:2d3d:8dab with SMTP id 22-20020aca2116000000b003842d3d8dabmr6403622oiz.58.1681244423569;
        Tue, 11 Apr 2023 13:20:23 -0700 (PDT)
X-Google-Smtp-Source: AKy350YJHMM7YveuM1hzKClhx7F7zKb9Wmh+6PKHIi//bXeiNy/POD5elG9ihQ3BmihU0dfLzqgvfg==
X-Received: by 2002:aca:2116:0:b0:384:2d3d:8dab with SMTP id 22-20020aca2116000000b003842d3d8dabmr6403605oiz.58.1681244423339;
        Tue, 11 Apr 2023 13:20:23 -0700 (PDT)
Received: from halaney-x13s.attlocal.net (104-53-165-62.lightspeed.stlsmo.sbcglobal.net. [104.53.165.62])
        by smtp.gmail.com with ESMTPSA id a6-20020a056808120600b003874631e249sm5976710oil.36.2023.04.11.13.20.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 13:20:22 -0700 (PDT)
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
Subject: [PATCH v4 0/3] Add EMAC3 support for sa8540p-ride (devicetree/clk bits)
Date:   Tue, 11 Apr 2023 15:20:06 -0500
Message-Id: <20230411202009.460650-1-ahalaney@redhat.com>
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
    2. A new programming sequence required for the EMAC3 base platforms

This series addresses the devicetree and clock changes to support this
hardware bringup.

As requested[1], it has been split up by compile deps / maintainer tree.
The associated v4 of the netdev specific changes can be found at [2].
Together, they result in the ethernet controller working for
both controllers on this platform.

[0] https://git.codelinaro.org/clo/la/kernel/ark-5.14/-/commit/510235ad02d7f0df478146fb00d7a4ba74821b17
[1] https://lore.kernel.org/netdev/20230320202802.4e7dc54c@kernel.org/
[2] https://lore.kernel.org/netdev/20230411200409.455355-1-ahalaney@redhat.com/T/#t

v3: https://lore.kernel.org/netdev/20230331215804.783439-1-ahalaney@redhat.com/T/#m2f267485d215903494d9572507417793e600b2bf
v2: https://lore.kernel.org/netdev/20230320221617.236323-1-ahalaney@redhat.com/
v1: https://lore.kernel.org/netdev/20230313165620.128463-1-ahalaney@redhat.com/

Thanks,
Andrew


Andrew Halaney (3):
  clk: qcom: gcc-sc8280xp: Add EMAC GDSCs
  arm64: dts: qcom: sc8280xp: Add ethernet nodes
  arm64: dts: qcom: sa8540p-ride: Add ethernet nodes

 arch/arm64/boot/dts/qcom/sa8540p-ride.dts     | 180 ++++++++++++++++++
 arch/arm64/boot/dts/qcom/sc8280xp.dtsi        |  59 ++++++
 drivers/clk/qcom/gcc-sc8280xp.c               |  18 ++
 include/dt-bindings/clock/qcom,gcc-sc8280xp.h |   2 +
 4 files changed, 259 insertions(+)

-- 
2.39.2

