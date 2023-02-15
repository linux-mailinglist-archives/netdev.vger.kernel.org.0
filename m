Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 540BD698472
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 20:26:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbjBOT0L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 14:26:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjBOT0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 14:26:10 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC7023B659
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 11:26:07 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id f18-20020a7bcd12000000b003e206711347so1394106wmj.0
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 11:26:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=jnKQDEjQ7FYsCUihSNgb4cFfV97JlTQd3ezBLUkeXEY=;
        b=fCkM/Og/V5rdAepcJ0MzqKNtegdETutk2puKi8i4BjV6HSC1+wubPxUWhfckcdVBl8
         r271EhDzcKvgEm7tX/OlJgk2e4kBoQcvMXnijnyKPxUQ+UT7HbAf+71rsFUV31hQ4dXd
         DEiU1B2AMxBY9HI9FoHa22gXFekblE+aWNartXk9VSjU3GzB3iUsayNrCAUDLZuyBmhO
         F3jczsE+0wlGsQeIVGkBkqj9GE3Q/CKQW1rIQ5ihmE1Tn9kLlFTCia1C34M7k7Apt1Uq
         hSxCLIpTxl9FGOS/y+4jtKbkJpCVgooY0nE+LEIjLVRrISnpATKO4lItE9tntuk95yLC
         CrFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jnKQDEjQ7FYsCUihSNgb4cFfV97JlTQd3ezBLUkeXEY=;
        b=sBXRWV+BLhc0F0ZVn8PaQ2tFyq+opjmAI49sk8oLTgHlnFxts4VT7ryqNN0/r+N29R
         CJP/puxrSrrTguUPLDGAT6IyukDcapXAnqPH09GqNKvsmD5Zexvy94mfhbCi9ocY7eDM
         05M/lECufUSZHBP/pSIQjd4ve67uosXGKiNa/PDhZRO9oDueS8FCTkn7iNQoAfY/VjGv
         VoC1BDGpBKM2f6X/5AzANd7V/clkPlzUAXwZ5iaRe/HUj9PGMg6dsM04h1BxZdpqMGYS
         DrA496E1wVpAlyczHs4tfLql3PPE0RoDvsvyj2pPUWgYpFK6fFOHeMX0Bf84u/rt9u57
         ishg==
X-Gm-Message-State: AO0yUKXcmXZ8kjpL+rVMX5yjOA78yFuXtoOEc9C+CjbDYVqIErUckPNS
        6md3GkXf9EYhPKMJz9AXNQ98tPdUZfA=
X-Google-Smtp-Source: AK7set/bnJ0QU23turowBejZniBCL4khCklPaDInhX+oq+syqjrWcGQBH1FFlzorUqRo75UiAVSeKw==
X-Received: by 2002:a05:600c:1d1f:b0:3dc:50c1:5fd4 with SMTP id l31-20020a05600c1d1f00b003dc50c15fd4mr3488501wms.15.1676489166283;
        Wed, 15 Feb 2023 11:26:06 -0800 (PST)
Received: from localhost.localdomain (p200300c1c74c0400ba8584fffebf2b17.dip0.t-ipconnect.de. [2003:c1:c74c:400:ba85:84ff:febf:2b17])
        by smtp.gmail.com with ESMTPSA id u1-20020a7bc041000000b003d1d5a83b2esm3024399wmc.35.2023.02.15.11.26.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 11:26:05 -0800 (PST)
Sender: Zahari Doychev <zahari.doychev@googlemail.com>
From:   Zahari Doychev <zahari.doychev@linux.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, hmehrtens@maxlinear.com,
        Zahari Doychev <zahari.doychev@linux.com>
Subject: [PATCH net-next 0/2] flower add cfm support
Date:   Wed, 15 Feb 2023 20:25:52 +0100
Message-Id: <20230215192554.3126010-1-zahari.doychev@linux.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first patch adds cfm support to the flower classifier. 
The second adds a selftest for the flower cfm functionality.

iproute2 changes will come in follow up patches.

rfc->v1:
 - add selftest to the makefile TEST_PROGS.

Zahari Doychev (2):
  net: flower: add support for matching cfm fields
  selftests: net: add tc flower cfm test

 include/net/flow_dissector.h                  |  11 ++
 include/uapi/linux/pkt_cls.h                  |  12 ++
 net/core/flow_dissector.c                     |  41 +++++
 net/sched/cls_flower.c                        | 118 +++++++++++-
 .../testing/selftests/net/forwarding/Makefile |   1 +
 .../selftests/net/forwarding/tc_flower_cfm.sh | 168 ++++++++++++++++++
 6 files changed, 350 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/net/forwarding/tc_flower_cfm.sh

-- 
2.39.1

