Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89A7E6BC4F9
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 04:53:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbjCPDxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 23:53:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjCPDw7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 23:52:59 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DC3525966
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 20:52:58 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id l9-20020a17090a3f0900b0023d32684e7fso4826195pjc.1
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 20:52:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678938777;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4DMw6ELaFJUBs7ypcrvd8gPZTo3StaMjHVL/UPB0wZU=;
        b=WHhL9T4nbpcvEPkinJEZY0w09E5JQ1QtuG89iMmUtMzzE8+IhwR6VoyhtNlWlWViyL
         Tq1v0CM/Dbzqpe9GqIKQV+XRlRsDmlkkPDkaAdVmNaU8P0HDJnFYjcn9+1rweQWDJ8Zo
         4sZMiRhVvIiP4tWeRnWnONCajPYi0hmXnJhDczRmCNiLirxZGevWeC1HQT5U8vlwqS4d
         PvuWRvhEYrz3S0QNTc1xkhtnmNTyu8FrojqiCX9rw1+jMxQs8D8EWC+lufPwoqS+iwyA
         qyJimaOncX86dnHqTU01e5hf2YjzByZHb0PR2NW7BS6xI2ENWU2G7mIqYJcVFz9ajCev
         lONQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678938777;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4DMw6ELaFJUBs7ypcrvd8gPZTo3StaMjHVL/UPB0wZU=;
        b=OfjrIpxhgDtaUsSeceJAxLHJ2YUP/fYrgbzNr1YmWrzx6C66E/7EFonV4v5WtuLkrU
         gglxeCsKc9CSxC+8+VNuZXRsaNR0T3qRAH1LFUWWPCIFyCYWeg1Pygeva3xoliyrxHrq
         fcpOji4FGGGUD+5WlMifIUNDgak5CPmfBSntY0xDNf3luXpW/Ro7D0qNRDmdpXmAPlnN
         MvE4bDCeM//HW78+G9jo65jhI27vipdmPXwypj8Awa1oTXGXG5PCpKzRJGylYAOi114M
         buFNAEOvYSS2A5rLeYW8gsv2F9yPxUjYNiQzsK4Abw2QXyAklfdlr2y37KMqMGRuW+58
         6QsQ==
X-Gm-Message-State: AO0yUKXoKmPgdxS2QfsoraD4ETXm0QlNms+hmOx72dXpMLI0IpaKumMZ
        7Ix03MJNiIxA/NY5Doa2xxJN9PIVcIgBWTY7
X-Google-Smtp-Source: AK7set+sFQLPVeEeUsxH4aQnVijPAf4VaM60dafLzYpzrJ7K7NJYrBlxvtFbA04gv/g25U2Qx9Q/Zw==
X-Received: by 2002:a17:903:245:b0:199:2b9f:f369 with SMTP id j5-20020a170903024500b001992b9ff369mr2325370plh.32.1678938777437;
        Wed, 15 Mar 2023 20:52:57 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id kb14-20020a170903338e00b001990028c0c9sm4393923plb.68.2023.03.15.20.52.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 20:52:56 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Davide Caratti <dcaratti@redhat.com>,
        Pedro Tammela <pctammela@mojatatu.com>,
        Marcelo Leitner <mleitner@redhat.com>,
        Phil Sutter <psutter@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCHv2 iproute2 0/2] tc: fix parsing of TCA_EXT_WARN_MSG
Date:   Thu, 16 Mar 2023 11:52:40 +0800
Message-Id: <20230316035242.2321915-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The TCA_EXT_WARN_MSG enum belongs to __TCA_MAX namespace. We can't use it
in tc action as it use TCA_ROOT_MAX enum. Fix it by adding a new
TCA_ROOT_EXT_WARN_MSG enum.

Hangbin Liu (2):
  Revert "tc: m_action: fix parsing of TCA_EXT_WARN_MSG"
  tc: m_action: fix parsing of TCA_EXT_WARN_MSG by using different enum

 include/uapi/linux/rtnetlink.h | 1 +
 tc/m_action.c                  | 8 +++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

-- 
2.38.1

