Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 611926D38AA
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 17:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbjDBPK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 11:10:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231207AbjDBPKw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 11:10:52 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19A11AD27
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 08:10:48 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id n10-20020a05600c4f8a00b003ee93d2c914so17932943wmq.2
        for <netdev@vger.kernel.org>; Sun, 02 Apr 2023 08:10:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112; t=1680448246;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=YkyZSXN9M/4nT992JTK/5MyDTCzlifb+kBGQpeZuDLE=;
        b=FWQZLtDpxlZGpRGjvlUhf3eUWLfsvvG7UM5AGwWbpwpp6MWdjfekny0KrzGGWCSZm9
         7cXxwZGTwrBCJU4OPwYx00IPHf4WtNZpFgJYJ7WFhYd+pDx7akjHSmPMUNNC7OwtvaCV
         eyRNiPyPcV5yPqQLTOQFqXyCVVTepJNh/wbT69dg21zkqWVekX3XPt01HGzjmZYXXmK5
         E1xvdGGGkCaDQxdRjt5Wf2J3MvWc7uheiHQmW0QpAj2exbXclwrI+HOJmB3HqNUGingS
         6LLKzqLduW9+DktIobQOuLkcYjyHAiFZOwwSidkSyMCmBIZD0vHMvr9sMv+35H8y8d/D
         RIEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680448246;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YkyZSXN9M/4nT992JTK/5MyDTCzlifb+kBGQpeZuDLE=;
        b=mPZGO5w47jSoI0doASy8axsyQbwUPKOtnKZ2NkoTN0G4/7jb1WypWHufKW755RRB/f
         NXXHgATTJCI/4InEKsCThx6tqwMZe/N27Qypi5GRxT2eyl4306rHQrRPgldiKfjjmGP7
         wetWqvT9pWgbUgnS7KkSHRfgzLPURnjaewCkR2j42RM51v0WoRpuumbrNnm5YUwQfK/N
         YhFE2bcyvq3XXCaRyu9sKoPv+oDsc0XmZ+rTPvRsZusr3wWPvwQl+RyhwsecQlZne77f
         34GcgA7jdMlPxV1kFt25FBlj64OViCshJWEzYG4m7H+4q4pp7y1KIsGP8P+L4P79dUqg
         dntQ==
X-Gm-Message-State: AO0yUKWnkWb13UM17lvBW7NWJLoTo7Va87lj3mHG0LR+EGuWsjRufsap
        K2OWMfJLrYie+Auau/DF71fEY+J4u+nP3ics
X-Google-Smtp-Source: AK7set/tEWfAiRibdnRNOW+f4PGLCPlKN4N27scIUzCvqI6huRzHJ5ytpORXZReXq7TScTwwlSZCNw==
X-Received: by 2002:a1c:7206:0:b0:3ed:2352:eebd with SMTP id n6-20020a1c7206000000b003ed2352eebdmr25163783wmc.11.1680448246426;
        Sun, 02 Apr 2023 08:10:46 -0700 (PDT)
Received: from localhost.localdomain (p200300c1c74c0400ba8584fffebf2b17.dip0.t-ipconnect.de. [2003:c1:c74c:400:ba85:84ff:febf:2b17])
        by smtp.gmail.com with ESMTPSA id y5-20020a1c4b05000000b003edd1c44b57sm9307529wma.27.2023.04.02.08.10.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Apr 2023 08:10:45 -0700 (PDT)
Sender: Zahari Doychev <zahari.doychev@googlemail.com>
From:   Zahari Doychev <zahari.doychev@linux.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, hmehrtens@maxlinear.com,
        aleksander.lobakin@intel.com,
        Zahari Doychev <zdoychev@maxlinear.com>
Subject: [PATCH net-next v2 0/2] net: flower: add cfm support
Date:   Sun,  2 Apr 2023 17:10:29 +0200
Message-Id: <20230402151031.531534-1-zahari.doychev@linux.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zahari Doychev <zdoychev@maxlinear.com>

The first patch adds cfm support to the flower classifier. 
The second adds a selftest for the flower cfm functionality.

iproute2 changes will come in follow up patches.

---

v1->v2:
 - add missing comments
 - improve cfm packet dissection
 - move defines to header file
 - fix code formatting
 - remove unneeded attribute defines

rfc->v1:
 - add selftest to the makefile TEST_PROGS.


Zahari Doychev (2):
  net: flower: add support for matching cfm fields
  selftests: net: add tc flower cfm test

 include/net/flow_dissector.h                  |  21 +++
 include/uapi/linux/pkt_cls.h                  |   9 +
 net/core/flow_dissector.c                     |  29 +++
 net/sched/cls_flower.c                        | 108 ++++++++++-
 .../testing/selftests/net/forwarding/Makefile |   1 +
 .../selftests/net/forwarding/tc_flower_cfm.sh | 175 ++++++++++++++++++
 6 files changed, 342 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/net/forwarding/tc_flower_cfm.sh

-- 
2.40.0

