Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9712E6C2289
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 21:24:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbjCTUY5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 16:24:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbjCTUYz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 16:24:55 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 914A99EDF
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 13:24:52 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id r16so14716413qtx.9
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 13:24:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679343891;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pydtgT+7v0cju30MJcNRWWaLuxk5ERuwNf/eKdgFBIc=;
        b=rXjX5bwIxHdfctQ6V3TG59Oyh3QpXwfzgUiGxqpkqiSZutjp00I48TAaSex3tgun/F
         fmirya5bpOeZU0CD+L+3ghhdRdImBObY+fWeAsg/faiQs+/YB98ILJXNKWnzx+zh6zP+
         dWAhNVVVcsG4nSyucT1R1HN6OSxs4HTZnq3O4dc+HJT49CrJjNjZ48UNdiVm+LeUlk+Q
         IceFMgI+l4ZOK9ZzzvY/jqxd30i2PpqvbyvZlDkiVc66yqir2rgcgr+GPvslJsyOUaGs
         PBdv6Z2zsSuqMXhQWSDTg7MK9rBKt607QD/4XSinJOh8DXqUZ82HLnox2/xrd9tmMqF+
         wYag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679343891;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pydtgT+7v0cju30MJcNRWWaLuxk5ERuwNf/eKdgFBIc=;
        b=p9cy12BJZ2/B33QtaZ5cwNEIvHzHB/P61C5JUxK4lGg7I97QOGRue8HjBUMxOKbrHo
         KLHfamhlMQP6IKrDeaMnjU2oA4wRCobXdNjpN61x9uf/Fpwdp2ZUZZBvWKpAIKQLevBm
         CPg1htQ/y74+n7KoLpbL5joKE7u1HlEFPyhtMq6LnvmD8t7B92FgAEyW1lY7R6iGYJE4
         4G+rYA3Eb/1c9CDAOhrTGqFi4N3s0iqKFrnDYUrNyKWumNu04znYhHQm5+ScRcKyLnjC
         CZPOUe8iNdQ1S67E9ZvTT2XSbcKWKUyubVFkxoE3Mz0V33BSfeAh1885wa4dq2taLTNP
         no9g==
X-Gm-Message-State: AO0yUKURpn/B971NLb7q82U2uUD0zNZcvynW9c+q46Sz9Cl7ScPvxhzg
        H6BxX0K73v5VmQF3Ngv74FQKUzaLcM36KTE8BrovbQ==
X-Google-Smtp-Source: AK7set/4fs8LRafPX4/mj6DOeUTP9gQaUhdfs+2p0RLSsRilO5Ui9bXCybb4NU4NJCFH1KhLpkKIGA==
X-Received: by 2002:ac8:5c16:0:b0:3c0:401f:9c24 with SMTP id i22-20020ac85c16000000b003c0401f9c24mr662117qti.63.1679343891675;
        Mon, 20 Mar 2023 13:24:51 -0700 (PDT)
Received: from localhost.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id d184-20020a3768c1000000b0074688c36facsm2568371qkc.56.2023.03.20.13.24.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 13:24:51 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/3] net: ipa: fully support IPA v5.0
Date:   Mon, 20 Mar 2023 15:24:44 -0500
Message-Id: <20230320202447.2048016-1-elder@linaro.org>
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

At long last, add the IPA and GSI register definitions, and the
configuration data required to support IPA v5.0.  This enables IPA
support for the Qualcomm SDX65 SoC.

					-Alex

Alex Elder (3):
  net: ipa: add IPA v5.0 register definitions
  net: ipa: add IPA v5.0 GSI register definitions
  net: ipa: add IPA v5.0 configuration data

 drivers/net/ipa/Makefile             |   4 +-
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
 11 files changed, 1380 insertions(+), 6 deletions(-)
 create mode 100644 drivers/net/ipa/data/ipa_data-v5.0.c
 create mode 100644 drivers/net/ipa/reg/gsi_reg-v5.0.c
 create mode 100644 drivers/net/ipa/reg/ipa_reg-v5.0.c

-- 
2.34.1

