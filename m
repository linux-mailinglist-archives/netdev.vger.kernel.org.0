Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30BA568F922
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 21:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231651AbjBHU5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 15:57:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbjBHU5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 15:57:09 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DC372D159
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 12:57:05 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id w13so35791ilv.3
        for <netdev@vger.kernel.org>; Wed, 08 Feb 2023 12:57:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=X7DbHR2X4ikzGML+8RSgjSp5z9M8mOscrwv14ksuvbE=;
        b=o7p1Nfn08Is1mnXiRABTzJCZmryeX2S81JDnh0V49J98QaEzONWLLYMf5XPtRFC0kd
         IF9T2yssdc2vFpNHb2JsqRItppXhMz4YOkLwrCzH1TU8I7u0RpyZOhv2z2zs5MbStbWE
         Z8p5ZdVvlZWcalenusDnsTRCSsv3+jIO7FW7D+UHYHe3gCTBkDmaDzLOOLN1o+at+HGn
         gZC7SvkcoQA0aR9lPsGUSjbIFKhE6ZQOvKe1IKCPJBgeAduMiOtktYOU9hQ05wIdZsTG
         dFFWSiKqYKQDXzmGlk99mA0d7s+ew722SNEK5P+motrbTGJoXnWXc6MLjLCxWEh+OFyt
         XaUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X7DbHR2X4ikzGML+8RSgjSp5z9M8mOscrwv14ksuvbE=;
        b=TOut/rTJk+zksmH+u5mEPijS8U4Am1Yw1vJEeSIQFT9+ruiksq8t0DZx5OPHyeL4zL
         Mk/bcLDIEGGHyVxQL4RGXkYcJrrrW73g1t/oi+E5QeHWcBdCySM5o/NNYZpXdDFUJDmC
         hyTGxrKCORKiZbxYDsnIfgDnp8IOOewlNnQ7XJX8T5dw2Xa0l6smKs04RNlZ0sTQx8wz
         /8G9Gw1/65RAI7CrIdM96nO46NyesD2XkA44S+Uf9yzEscWj/gEq9whkWHar7U/cHw/c
         I8out4BVGycni6rX2/ZQeFsOoR0Z2doEnIf+EHnA0RfeaebBi4wPM3bdVUuRIJDnqu1w
         hfPg==
X-Gm-Message-State: AO0yUKUt9E/lFwQ9Bds+3UCdF/EHG3ml4fj1HLqaZaXVPSO/Rilbl5p3
        yqV05TIvux1SBRGu0VIKx//JNQ==
X-Google-Smtp-Source: AK7set8q4iB/9jh/+7RXot17Ayryd9mkrRNbCum2GTQHANayZ98srghoenzxtJ/3Nlp/VgrW+p/u0Q==
X-Received: by 2002:a05:6e02:219e:b0:312:7ca2:fee6 with SMTP id j30-20020a056e02219e00b003127ca2fee6mr9075974ila.30.1675889824765;
        Wed, 08 Feb 2023 12:57:04 -0800 (PST)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id r6-20020a922a06000000b0031093e9c7fasm5236704ile.85.2023.02.08.12.56.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 12:56:59 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/9] net: ipa: prepare for GSI register updtaes
Date:   Wed,  8 Feb 2023 14:56:44 -0600
Message-Id: <20230208205653.177700-1-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

An upcoming series (or two) will convert the definitions of GSI
registers used by IPA so they use the "IPA reg" mechanism to specify
register offsets and their fields.  This will simplify implementing
the fairly large number of changes required in GSI registers to
support more than 32 GSI channels (introduced in IPA v5.0).

A few minor problems and inconsistencies were found, and they're
fixed here.  The last three patches in this series change the
"ipa_reg" code to separate the IPA-specific part (the base virtual
address, basically) from the generic register part, and the now-
generic code is renamed to use just "reg_" or "REG_" as a prefix
rather than "ipa_reg" or "IPA_REG_".

					-Alex

Alex Elder (9):
  net: ipa: generic command param fix
  net: ipa: get rid of ipa->reg_addr
  net: ipa: add some new IPA versions
  net: ipa: tighten up IPA register validity checking
  net: ipa: use bitmasks for GSI IRQ values
  net: ipa: GSI register cleanup
  net: ipa: start generalizing "ipa_reg"
  net: ipa: generalize register offset functions
  net: ipa: generalize register field functions

 drivers/net/ipa/gsi.c                |  82 +++++---
 drivers/net/ipa/gsi_reg.h            | 109 +++++------
 drivers/net/ipa/ipa.h                |   4 +-
 drivers/net/ipa/ipa_cmd.c            |   6 +-
 drivers/net/ipa/ipa_endpoint.c       | 205 ++++++++++---------
 drivers/net/ipa/ipa_interrupt.c      |  29 ++-
 drivers/net/ipa/ipa_main.c           | 114 +++++------
 drivers/net/ipa/ipa_mem.c            |  14 +-
 drivers/net/ipa/ipa_reg.c            |  90 +++++----
 drivers/net/ipa/ipa_reg.h            | 139 ++-----------
 drivers/net/ipa/ipa_resource.c       |  16 +-
 drivers/net/ipa/ipa_table.c          |  35 ++--
 drivers/net/ipa/ipa_uc.c             |   6 +-
 drivers/net/ipa/ipa_version.h        |   6 +-
 drivers/net/ipa/reg.h                | 133 +++++++++++++
 drivers/net/ipa/reg/ipa_reg-v3.1.c   | 277 +++++++++++++-------------
 drivers/net/ipa/reg/ipa_reg-v3.5.1.c | 263 +++++++++++++------------
 drivers/net/ipa/reg/ipa_reg-v4.11.c  | 265 +++++++++++++------------
 drivers/net/ipa/reg/ipa_reg-v4.2.c   | 249 ++++++++++++------------
 drivers/net/ipa/reg/ipa_reg-v4.5.c   | 281 +++++++++++++--------------
 drivers/net/ipa/reg/ipa_reg-v4.7.c   | 265 +++++++++++++------------
 drivers/net/ipa/reg/ipa_reg-v4.9.c   | 265 +++++++++++++------------
 22 files changed, 1451 insertions(+), 1402 deletions(-)
 create mode 100644 drivers/net/ipa/reg.h

-- 
2.34.1

