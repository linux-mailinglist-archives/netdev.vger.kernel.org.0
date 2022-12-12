Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DCDD64984F
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 04:57:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231165AbiLLD47 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Dec 2022 22:56:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231144AbiLLD46 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Dec 2022 22:56:58 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D49DEBE11
        for <netdev@vger.kernel.org>; Sun, 11 Dec 2022 19:56:57 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id o12so10622234pjo.4
        for <netdev@vger.kernel.org>; Sun, 11 Dec 2022 19:56:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Mcps76rEDVp7Vzmxddxg0B3lW31XzboHjwQTUgL0UTY=;
        b=nmGlUhDbRkt5EUV+5fZAX9SQeFyblOEbp4mmGInm9PA0cYwEftwsEoPKMJ70EUfzzG
         sO0ejuJCZ4T0Lnfh9KN4FDiM9tGOXnw/6CbPuoofOhfXWQ/V7ueWFtVB6UqLCMcJDU0E
         L7qVaTJ/HU+JiY7SQZWV4ePHq9AS0MqjD+YS38D+Al61F5G2dYkF0dqtSawIJeaIgjKG
         /eTvCPmOgpoOQbYSEDjjXHbJT69AzLl3G6OW7TEgUm3hOt+xpN5cFokKCpqnF9jbAf+q
         ajsus3jtKKQQsRSXrFoRTl2dzCVXlgFEALdght7sFVWWbEGr/tQLtVJafVwlKjIcZCvG
         n5rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Mcps76rEDVp7Vzmxddxg0B3lW31XzboHjwQTUgL0UTY=;
        b=UFcuUfkPPcm4mUDmss6e7OX9Awj9omjAF3J/xkTJzdiCgmlf+g4hVVWTo1aIeH9IYg
         fdpyS7AZVb7OYucjGJyndpPl2qFV9g83GyHFIyhFWkflF2GffdstR0X77jmBpNmSA8ff
         IG7G0C8UPwhgL8FwrEtXl5bKLHKRk0E1737W0PI8ovfShPhxWzYESrEtC2KRvLMa2MSI
         sTSe+hlUkQe8sJCv4tU+F2uR/8g7jXyA0MypNTNfrOjT/5bcng4/kWelAXZcsxMkZ2Er
         LONRnSUMqXAZhDgL9bEh4S0L3ElXAUv+YMapB7y1Sfi9EEU1IjbNgeuZpDgCYsbrddlK
         GueA==
X-Gm-Message-State: ANoB5plSx0GgCGBubz7XVu4HUcs8+yvna1alplJeSO6AGuprRgmYGeau
        ttJ6/qLpYf7GAlEc+9StFH4dLajHj5BAbLYB
X-Google-Smtp-Source: AA0mqf4Qyg2F+GLnsHyfJbziGLci0SaOwFdTjXD6b3slfvvVmjWUOBBBbrTbfZtIF7/X6VCwZ9ECVg==
X-Received: by 2002:a17:90a:31c5:b0:221:11b4:d5b7 with SMTP id j5-20020a17090a31c500b0022111b4d5b7mr7177283pjf.21.1670817416928;
        Sun, 11 Dec 2022 19:56:56 -0800 (PST)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w190-20020a6362c7000000b00476dc914262sm4231207pgb.1.2022.12.11.19.56.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Dec 2022 19:56:56 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, liali <liali@redhat.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net 0/3] Bonding: fix high prio not effect issue
Date:   Mon, 12 Dec 2022 11:56:44 +0800
Message-Id: <20221212035647.1053865-1-liuhangbin@gmail.com>
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

When a high prio link up, if there has current link, it will not do
failover as we missed the check in link up event. Fix it in this patchset
and add a prio option test case.

v2:
1. use rcu_access_pointer() instead of rtnl_dereference().
2: make do_failover after looping all slaves

Hangbin Liu (2):
  bonding: add missed __rcu annotation for curr_active_slave
  bonding: do failover when high prio link up

Liang Li (1):
  selftests: bonding: add bonding prio option test

 drivers/net/bonding/bond_main.c               |  24 +-
 .../selftests/drivers/net/bonding/Makefile    |   3 +-
 .../drivers/net/bonding/option_prio.sh        | 245 ++++++++++++++++++
 3 files changed, 262 insertions(+), 10 deletions(-)
 create mode 100755 tools/testing/selftests/drivers/net/bonding/option_prio.sh

-- 
2.38.1

