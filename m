Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D24A605B5C
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 11:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbiJTJl1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 05:41:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbiJTJlT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 05:41:19 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEC55168E7A
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 02:41:13 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id c24so19817530plo.3
        for <netdev@vger.kernel.org>; Thu, 20 Oct 2022 02:41:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=sZj/eVLpdJMM0Opwr/jyaIO+SCciGX2AZjn/GdTBpQA=;
        b=g4Ktt73Av5DXHtUWRPhkdozUzK84MSOlDP4t9zFfn5Ay2EoFxhswo8kFzrKqIMLV6+
         gu7JOw1OvB9Rc5nUsPDl7rPZydUlCihCYsO7dYzCWnNKtpw1vto5tDEweR0+uyoVqVU4
         yICAqLbC+XTmxFjAKsCNbKLcac/LKz0U7luRlBYuv8xRZRGdXP7m4R5LalKkw3t1V7rW
         sTLPRTftvpzNFsjtc0HCrIxAp/w5Jk/TAEe8S6jKtUDrZH3eSNN+8dMPdyNmkXCifU2T
         KCH5pg8FKMHiobdwQoq/yl0fvZTMzKkYFWWmFedHZMgetBoLRIZu9svfXEYztCDaFqla
         xzNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sZj/eVLpdJMM0Opwr/jyaIO+SCciGX2AZjn/GdTBpQA=;
        b=DNYzaMrIEuk0mhZ8b2zqFDPJThf46PvFp2o0xaq/OGZM+V2msQAv7yfa2VaPLc16v0
         ZOgrbWRa1MAwd1GvXxNjfazZKmq+0oPxvPItmV+k9MVKWdv7blMqAeMbdhaA0v4nje+B
         MOtN8xre3xxIcMMlKHWI3bf3mSpU1OzRdFV/GTomIWLr52BZQm4JRSqMyia/UuDpam1q
         UY+PwWEVxvBwopfgCluwqnoCHLUs+BkNyasp6NQrXP2wYdJSSinma4UuydPMzvpqzlaQ
         eu/pBr0FipKMbAZRhFapoEAQTKtqHjZ54cxkA7QFUk07CgUw5AEVDTiEtoScVNtTDA1Y
         tt7Q==
X-Gm-Message-State: ACrzQf2HDcbn5o8sB6xKc9ILN+dRhUppVaepZ5XIgg8r+0y4dDmF04KZ
        HpW2M7muA8T6ebvyoN/dhXERIQ==
X-Google-Smtp-Source: AMsMyM4xMHPMd+JkuggU22gCnF/yOECwQKjnCoK1Xr+jDuEeDH1kYic+FddQvw8PUs++ii3dG6DAcQ==
X-Received: by 2002:a17:903:2442:b0:17f:8069:533a with SMTP id l2-20020a170903244200b0017f8069533amr12880046pls.46.1666258872801;
        Thu, 20 Oct 2022 02:41:12 -0700 (PDT)
Received: from archlinux.internal.sifive.com (59-124-168-89.hinet-ip.hinet.net. [59.124.168.89])
        by smtp.gmail.com with ESMTPSA id o12-20020a170902d4cc00b0016d9d6d05f7sm12425675plg.273.2022.10.20.02.41.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 02:41:12 -0700 (PDT)
From:   Andy Chiu <andy.chiu@sifive.com>
To:     davem@davemloft.net, kuba@kernel.org, michal.simek@xilinx.com,
        radhey.shyam.pandey@xilinx.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org,
        pabeni@redhat.com, edumazet@google.com, andy.chiu@sifive.com,
        greentime.hu@sifive.com
Subject: [PATCH net-next 0/2] net:axienet: Add a DT property to configure frequency of the MDIO bus
Date:   Thu, 20 Oct 2022 17:41:04 +0800
Message-Id: <20221020094106.559266-1-andy.chiu@sifive.com>
X-Mailer: git-send-email 2.36.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some FPGA platforms have to set frequency of the MDIO bus lower than 2.5
MHz. Thus, we add a DT property to work with them at boot time. The
default 2.5 MHz would be set if the property is not pressent.

Andy Chiu (2):
  net:xilinx_axi: set mdio frequency according to DT
  dt-bindings: add mdio frequency description

 .../bindings/net/xilinx_axienet.txt           |  3 +++
 .../net/ethernet/xilinx/xilinx_axienet_mdio.c | 25 ++++++++++++++++---
 2 files changed, 24 insertions(+), 4 deletions(-)

-- 
2.36.0

