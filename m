Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 465CB67D7D1
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 22:36:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233009AbjAZVgL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 16:36:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230363AbjAZVgJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 16:36:09 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25FA65587
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 13:36:05 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id bk15so8720596ejb.9
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 13:36:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wIV+Q732OCBJD0p4AmY7v+jtOPaCIpj1Xm7fn1GMOyc=;
        b=I44+h8L6l6h2SvZ5Z6XtzccMc4n2OExyAOP8PgwyV1C7x4gdmUjeYgwd6q+bEwQt4L
         oeDXF3HlJR3/orc4OGrU4iLUUqYj+aPzXbCtu8S3emI1Z+X89mvvb9D1DbGz+QIUOMXX
         Xd8MU8IXoZxxhyHINYbNo77Hju5bh3VWmuHMqio686kqgVtdiMCITSkOuvt6EM1ae++Z
         3BAgWBdThbNcQhm+X4WtjPcQZ7QSBRPgbbBreUNY8sDR6kTzLWmg1TBFV6jn47BYtR9K
         RwkxGGTCzLYbe75JlK21W0SG3T3z5cC8H12kgKKAV1HXIONn50Znhxc1e0pvOmWPmeV3
         d/fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wIV+Q732OCBJD0p4AmY7v+jtOPaCIpj1Xm7fn1GMOyc=;
        b=3WzKcWVHAmmqV0CX/l4Kpt+zOIprVKUTjq+Wk592/+eWUCPuAIsQOIKoDuAIdYUUzm
         HRWMLQi2et2XfXvE/y+X370KZqp1WFmmxsMoRs+yt7UdA2WCg0v5Lv9N/NKzYcKgqD28
         4amiNoVgQybXAk0GgR860eU+ToyhZBapJKp+rIYLerLH0zb8XWvfMaDRPa9bPOiiny0k
         CpvSdp0pIoxLtaq8nEmdH1YVmlw+maTNE4wOVzHPV943S1L1n3oWL0i1UH6vtX6mRxXh
         zvz09D4u09SGUIWeGiTZchybV1pU0olwAeQSfaD4Q0YEfd1Rv375WNYxQ3BHxNg/QYhD
         lH0Q==
X-Gm-Message-State: AFqh2kpp6MqG/lcyGRQp49BtXN9oHUoDpTrzt2JhCdS4YdhPR2XtA+GR
        nZOI/clcCPV1G9qjfwpjnLyPhA==
X-Google-Smtp-Source: AMrXdXsnvPaWHDjgsBn+HZ/GVOyl2b2GyhHJeg94Ac0afrLPKAuV5G9MnwKxUHumh/XBqb7xrBs44g==
X-Received: by 2002:a17:906:670b:b0:7c1:8f53:83a0 with SMTP id a11-20020a170906670b00b007c18f5383a0mr35445316ejp.13.1674768963598;
        Thu, 26 Jan 2023 13:36:03 -0800 (PST)
Received: from Lat-5310.. ([87.116.162.186])
        by smtp.gmail.com with ESMTPSA id gy4-20020a170906f24400b0083ffb81f01esm1148486ejb.136.2023.01.26.13.36.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jan 2023 13:36:03 -0800 (PST)
From:   Andrey Konovalov <andrey.konovalov@linaro.org>
To:     vkoul@kernel.org, bhupesh.sharma@linaro.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        andrew@lunn.ch, robh@kernel.org, alexandre.torgue@foss.st.com,
        peppe.cavallaro@st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Andrey Konovalov <andrey.konovalov@linaro.org>
Subject: [PATCH 0/1] net: stmmac: do not stop RX_CLK in Rx LPI state for qcs404 SoC
Date:   Fri, 27 Jan 2023 00:35:38 +0300
Message-Id: <20230126213539.166298-1-andrey.konovalov@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a different, for one SoC only solution to the issue described below
vs a generic one submitted earlier [1].

On my qcs404 based board the ethernet MAC has issues with handling
Rx LPI exit / Rx LPI entry interrupts.

When in LPI mode the "refresh transmission" is received, the driver may
see both "Rx LPI exit", and "Rx LPI entry" bits set in the single read from
GMAC4_LPI_CTRL_STATUS register (vs "Rx LPI exit" first, and "Rx LPI entry"
then). In this case an interrupt storm happens: the LPI interrupt is
triggered every few microseconds - with all the status bits in the
GMAC4_LPI_CTRL_STATUS register being read as zeros. This interrupt storm
continues until a normal non-zero status is read from GMAC4_LPI_CTRL_STATUS
register (single "Rx LPI exit", or "Tx LPI exit").

The reason seems to be in the hardware not being able to properly clear
the "Rx LPI exit" interrupt if GMAC4_LPI_CTRL_STATUS register is read
after Rx LPI mode is entered again.

The current driver unconditionally sets the "Clock-stop enable" bit
(bit 10 in PHY's PCS Control 1 register) when calling phy_init_eee().
Not setting this bit - so that the PHY continues to provide RX_CLK
to the ethernet controller during Rx LPI state - prevents the LPI
interrupt storm.

Until this bug is confirmed by the SoC and the ethernet IP vendors,
and until we get the information of what IP versions are affected,
the solution could be to keep RX_CLK running in Rx LPI state for qcs404
SoC - for the moment, the only SoC which is known to have this issue.

[1] https://www.spinics.net/lists/netdev/msg875806.html

Andrey Konovalov (1):
  net: stmmac: do not stop RX_CLK in Rx LPI state for qcs404 SoC

 drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c | 2 ++
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c       | 3 ++-
 include/linux/stmmac.h                                  | 1 +
 3 files changed, 5 insertions(+), 1 deletion(-)

-- 
2.34.1

