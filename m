Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 072166C391F
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 19:26:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230016AbjCUS0v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 14:26:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbjCUS0u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 14:26:50 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA1E321A36
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 11:26:48 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id i19so8572223ila.10
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 11:26:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679423208;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WSRg3UwiWx5q9be6JhA5mF+WRWWeufdq0mI3kG3DhDQ=;
        b=B7qNG1T3HQfCWfnV9uJDkS3jUdM9XU1ovZd6r3yLk5PyGg4JuaQbULfq0i/9h98BLO
         5jQ7ERgCkYMNYdfHxJGCc5el6kup2ql66MQrhFxEB7kKq1aerT+DaBvsqwwd6bFaHsVv
         1H+LdfkIySx14YER+LQg+4k0nYrU5TIzjXucDet7Hmo+QL9d6WVyaQyDzNFcLy1P22T3
         REmXUv0tEbVnLCzpXMtPHxt6Pc1ynveHb4Du2rZjsMSWcSbba96URjYJvJ+B1glLzwLU
         bWZJYFIbyh5w7/0s7cnYDh4pnm0+p0In3106m0GzdYjKhoLYGXMehk+F0OTrEEvjCgCK
         8vCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679423208;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WSRg3UwiWx5q9be6JhA5mF+WRWWeufdq0mI3kG3DhDQ=;
        b=UMQKdAzrI6wpeiu4n+fz0hU33+oGCfs6GBYH1/bXz426gVe0WjRM9shddwe+ItranG
         YaT2JMEHJMh/l7tdckt0Cf4HI4tTQI+xLo7N3qVrWWULYpjchToKviq+Wuq1isxpbC58
         YM7P9eYnwk3JoIvVEAZCEL66ynGaIAif8emsVuPnWcEIFPODtPQVyMj1poOTT2aCjpD/
         XsFpukeJWQYwxmWZk1+s1nxHELfxf5ibPMk/z7LzNlzuMqCXSEO2uBbo5tVxZVEKTytx
         88Jjltk4GbMQqRIgCng/Yos6gI7n1OaQNkZAJQ70Kdo8XAj9WTyFZ5612snIDh3JAd7g
         rb8w==
X-Gm-Message-State: AO0yUKVU7N3Bz83quCl8+69IB2d8lBqMXJ5vOTIVyyJMCN6gRyIQLDk2
        xyIfBRNOgp3t4cxJsft/e56dNQ==
X-Google-Smtp-Source: AK7set8AQ2p/dXGEKnkDcrGkBVFdm340FDS4MKnZTUQBbNkWHRi6s60imswXjoB+Ou1LR1Eq9vStow==
X-Received: by 2002:a92:d249:0:b0:315:34b8:4c6d with SMTP id v9-20020a92d249000000b0031534b84c6dmr2293144ilg.17.1679423208064;
        Tue, 21 Mar 2023 11:26:48 -0700 (PDT)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id m1-20020a0566380dc100b004064207454bsm3405858jaj.30.2023.03.21.11.26.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 11:26:47 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 0/3] net: ipa: fully support IPA v5.0
Date:   Tue, 21 Mar 2023 13:26:41 -0500
Message-Id: <20230321182644.2143990-1-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At long last, add the IPA and GSI register definitions, and the
configuration data required to support IPA v5.0.  This enables IPA
support for the Qualcomm SDX65 SoC.

The first version of this series had build errors due to a
non-existent source file being required.  This version addresses
that by changing how required files are specified in the Makefile.

Note that the second patch has some warnings about lines starting
with spaces; those spaces align text with the open parenthesis on
the previous line.

					-Alex

Alex Elder (3):
  net: ipa: add IPA v5.0 register definitions
  net: ipa: add IPA v5.0 GSI register definitions
  net: ipa: add IPA v5.0 configuration data

 drivers/net/ipa/Makefile             |  12 +-
 drivers/net/ipa/data/ipa_data-v5.0.c | 481 +++++++++++++++++++++++
 drivers/net/ipa/gsi.h                |   4 +-
 drivers/net/ipa/gsi_reg.c            |   3 +
 drivers/net/ipa/gsi_reg.h            |   1 +
 drivers/net/ipa/ipa_data.h           |   3 +-
 drivers/net/ipa/ipa_main.c           |   6 +-
 drivers/net/ipa/ipa_reg.c            |   2 +
 drivers/net/ipa/ipa_reg.h            |   1 +
 drivers/net/ipa/reg/gsi_reg-v5.0.c   | 317 +++++++++++++++
 drivers/net/ipa/reg/ipa_reg-v5.0.c   | 564 +++++++++++++++++++++++++++
 11 files changed, 1385 insertions(+), 9 deletions(-)
 create mode 100644 drivers/net/ipa/data/ipa_data-v5.0.c
 create mode 100644 drivers/net/ipa/reg/gsi_reg-v5.0.c
 create mode 100644 drivers/net/ipa/reg/ipa_reg-v5.0.c

-- 
2.34.1

