Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 799DF3F3122
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 18:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235533AbhHTQI7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 12:08:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236845AbhHTQHz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 12:07:55 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88979C061A06
        for <netdev@vger.kernel.org>; Fri, 20 Aug 2021 09:01:33 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id a13so12870226iol.5
        for <netdev@vger.kernel.org>; Fri, 20 Aug 2021 09:01:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SeHRAWquHTn4hGLpQjsJcxnYwY3Lu6w2QiJLnpMqNOw=;
        b=VkGzd/mYw2ewB6X0l3s7Qa1BcA3xgxV/9O62Y88d0q2q1fbCCTDxQSO/YfFL466rLA
         4YSbTQQKMbJwwtJAAM1+mUPeo7aoACvGfygD7xuxjVmIMQSPtesyau+0pIVq9EX0uAIM
         IQEYMWvHU2IgGAbhuU/bTnSHBFLzBUfaEAKqaD9x+9gT/caACHqzKvMFfsavmvx86MvE
         aJqblb1ZVaQVUIjsq38FilCMC3HF3iFDND7UeGvMOVrkM5+9fBAeTmCDbAhUd+3GAce7
         M7+fewihWraxndx8n2GAG5DIWpP/+DNRMq/E8Kfqb6f/cJ4Pdh+5d49le8ESfclSOJF4
         d+Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SeHRAWquHTn4hGLpQjsJcxnYwY3Lu6w2QiJLnpMqNOw=;
        b=mVtxSLWUW5+FaEwR6LkVA6bWDedGbuHf1SuhOzrsig+w/i0Xnp2hdx+UFgrhl7CmA1
         bNYPILYE/TEuNryDFypdAEioK3S3znlvSiTDhZlHIJ+4SpqIZnVAfJs4tbI5S/i2hpYs
         AmTLxyUb2Es5Fbdgbo7J3yNQtDgkUNR6d9ml5QRnRFhi5TW3U4CpJ5InKO2OeLpUsZdY
         LbgnjzF0TBEVCxEc1Vl3VqUW7+CCvJK74NiM3jluLPIoEP51u685ZAyfeop1apLqvXNp
         W677ZwNAXg9V7mrG4L9dVB0eoEam0QaxTBn8peJNBZK+uptn23pvE7BbMAC7Zrr8Au03
         tV6Q==
X-Gm-Message-State: AOAM533UlcOrsTHqoK7tbesEpJEM8S81JkUSd23KZc98GvUvfn9k6B0j
        obmqEKbxfHyahuTIn7kFJmKsJg==
X-Google-Smtp-Source: ABdhPJxEryUpSXb0eR/hAZkq3gGR4Yk/Q+EKBaQjC9zkxmEO5fbUl85GV13NJee6IqFQBKsOt8JIOA==
X-Received: by 2002:a02:a488:: with SMTP id d8mr18090104jam.50.1629475292937;
        Fri, 20 Aug 2021 09:01:32 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id a8sm3521317ilq.63.2021.08.20.09.01.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Aug 2021 09:01:32 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/3] net: ipa: enable automatic suspend
Date:   Fri, 20 Aug 2021 11:01:26 -0500
Message-Id: <20210820160129.3473253-1-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At long last, the first patch in this series enables automatic
suspend managed by the power management core.  The remaining two
just rename things to be "power" oriented rather than "clock"
oriented.

					-Alex

Alex Elder (3):
  net: ipa: use autosuspend
  net: ipa: rename ipa_clock_* symbols
  net: ipa: rename "ipa_clock.c"

 drivers/net/ipa/Makefile                     |   2 +-
 drivers/net/ipa/ipa.h                        |  20 +--
 drivers/net/ipa/ipa_data-v3.1.c              |   4 +-
 drivers/net/ipa/ipa_data-v3.5.1.c            |   4 +-
 drivers/net/ipa/ipa_data-v4.11.c             |   4 +-
 drivers/net/ipa/ipa_data-v4.2.c              |   4 +-
 drivers/net/ipa/ipa_data-v4.5.c              |   4 +-
 drivers/net/ipa/ipa_data-v4.9.c              |   4 +-
 drivers/net/ipa/ipa_data.h                   |  10 +-
 drivers/net/ipa/ipa_endpoint.c               |   4 +-
 drivers/net/ipa/ipa_interrupt.c              |   3 +-
 drivers/net/ipa/ipa_main.c                   |  45 ++---
 drivers/net/ipa/ipa_modem.c                  |  20 ++-
 drivers/net/ipa/{ipa_clock.c => ipa_power.c} | 163 +++++++++----------
 drivers/net/ipa/{ipa_clock.h => ipa_power.h} |  26 +--
 drivers/net/ipa/ipa_smp2p.c                  |  66 ++++----
 drivers/net/ipa/ipa_smp2p.h                  |   2 +-
 drivers/net/ipa/ipa_uc.c                     |  26 +--
 drivers/net/ipa/ipa_uc.h                     |  10 +-
 19 files changed, 217 insertions(+), 204 deletions(-)
 rename drivers/net/ipa/{ipa_clock.c => ipa_power.c} (72%)
 rename drivers/net/ipa/{ipa_clock.h => ipa_power.h} (69%)

-- 
2.27.0

