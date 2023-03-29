Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 089B46CD781
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 12:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231530AbjC2KTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 06:19:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231496AbjC2KTN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 06:19:13 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2A4040DC
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 03:19:11 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id u38so9927166pfg.10
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 03:19:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680085151;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5Maw3ieVPN8hMyGutFnHgbivdiNNbL3ewtzwUiV77go=;
        b=gK8XQMQTdruzUK4D+fl5TLMv5ojRAjQaqXHZXglYiaafmYbtJM5K080HktxO3uSw/3
         +C4Ryh+wZB37w4PuueEJyEUE6A3Z/AZf7XC5LEHLywQmD7zGVdl9Ud0yjYsOfm9OjcMB
         B5DxYshnIc7augw2V15fqA1qnzPWutWFwA7GAjmBfHsT/6Bzw5TGNobUhkvrCiY3UNPN
         IGu0nnCrJR7UVWOPAepXzphtIF5sX9FOMH2kQId3+qneuFJicYsc3/RMdOLzoXHojn2S
         JRja7Ix6d4Q1Llym9fLhFcll2FlY2Ur+A4E0qL2kWcdeRUgDmlFdYMffXMcq7GsZL+Tf
         w6aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680085151;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5Maw3ieVPN8hMyGutFnHgbivdiNNbL3ewtzwUiV77go=;
        b=1gnoGWPOgfRucPFpgSXsHkJo2eLg4+R7f+7OQOUQfZD5ZL0Y51xwyaRJulXVol8y5D
         vpAQ4kx0/ddcMIticyJ2uiCz1lcJKbPdIixEAbCFHCFJNfIw8j6ypBiao4vqqH1bGs72
         Fwm8xS1ThpeC/tHrow4MSg/cgrl3666yey+nbnRRtYQcCGytr6xKD4gL0pS0hGivRLqH
         1Tasr4s4+EZcGdxz+SlhGP7/wWftRoKRgtjvj3n9ZrKi57U3YrOBObfj1K9KSWtq9d6w
         obT6e3vqleYQMsBnWh/RVBxbxWbSASO91YoZL8r+eydQrd1i97yGWNd+MnXHYNfzAAt7
         0G7A==
X-Gm-Message-State: AAQBX9eV2CDus4UnAMDAA6irT/BUWcMFyh6IHM+QBoHp2d/c6k/Z+k5t
        Z01pCJgFrnVajebFGFSOoiZb19hSU5fnMA==
X-Google-Smtp-Source: AKy350Z6tYRWEZDpjg1jM5b+FwRbm8BvQi1s1IitFDNWN4vV1714BXfv6iRWvgJBoCUoouAa6simqg==
X-Received: by 2002:a62:3891:0:b0:622:3621:b2a8 with SMTP id f139-20020a623891000000b006223621b2a8mr17265555pfa.17.1680085150624;
        Wed, 29 Mar 2023 03:19:10 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([2409:8a02:7821:7c20:eae8:14e5:92b6:47cb])
        by smtp.gmail.com with ESMTPSA id a17-20020a631a11000000b0051322ab5ccdsm9304653pga.28.2023.03.29.03.19.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 03:19:09 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Liang Li <liali@redhat.com>, Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net 0/3] bonding: fix ns validation on backup slaves
Date:   Wed, 29 Mar 2023 18:18:56 +0800
Message-Id: <20230329101859.3458449-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first patch fixed a ns validation issue on backup slaves. The second
patch re-format the bond option test and add a test lib file. The third
patch add the arp validate regression test for the kernel patch.

Here is the new bonding option test without the kernel fix:

]# ./bond_options.sh
TEST: prio (active-backup miimon primary_reselect 0)           [ OK ]
TEST: prio (active-backup miimon primary_reselect 1)           [ OK ]
TEST: prio (active-backup miimon primary_reselect 2)           [ OK ]
TEST: prio (active-backup arp_ip_target primary_reselect 0)    [ OK ]
TEST: prio (active-backup arp_ip_target primary_reselect 1)    [ OK ]
TEST: prio (active-backup arp_ip_target primary_reselect 2)    [ OK ]
TEST: prio (active-backup ns_ip6_target primary_reselect 0)    [ OK ]
TEST: prio (active-backup ns_ip6_target primary_reselect 1)    [ OK ]
TEST: prio (active-backup ns_ip6_target primary_reselect 2)    [ OK ]
TEST: prio (balance-tlb miimon primary_reselect 0)             [ OK ]
TEST: prio (balance-tlb miimon primary_reselect 1)             [ OK ]
TEST: prio (balance-tlb miimon primary_reselect 2)             [ OK ]
TEST: prio (balance-tlb arp_ip_target primary_reselect 0)      [ OK ]
TEST: prio (balance-tlb arp_ip_target primary_reselect 1)      [ OK ]
TEST: prio (balance-tlb arp_ip_target primary_reselect 2)      [ OK ]
TEST: prio (balance-tlb ns_ip6_target primary_reselect 0)      [ OK ]
TEST: prio (balance-tlb ns_ip6_target primary_reselect 1)      [ OK ]
TEST: prio (balance-tlb ns_ip6_target primary_reselect 2)      [ OK ]
TEST: prio (balance-alb miimon primary_reselect 0)             [ OK ]
TEST: prio (balance-alb miimon primary_reselect 1)             [ OK ]
TEST: prio (balance-alb miimon primary_reselect 2)             [ OK ]
TEST: prio (balance-alb arp_ip_target primary_reselect 0)      [ OK ]
TEST: prio (balance-alb arp_ip_target primary_reselect 1)      [ OK ]
TEST: prio (balance-alb arp_ip_target primary_reselect 2)      [ OK ]
TEST: prio (balance-alb ns_ip6_target primary_reselect 0)      [ OK ]
TEST: prio (balance-alb ns_ip6_target primary_reselect 1)      [ OK ]
TEST: prio (balance-alb ns_ip6_target primary_reselect 2)      [ OK ]
TEST: arp_validate (active-backup arp_ip_target arp_validate 0)  [ OK ]
TEST: arp_validate (active-backup arp_ip_target arp_validate 1)  [ OK ]
TEST: arp_validate (active-backup arp_ip_target arp_validate 2)  [ OK ]
TEST: arp_validate (active-backup arp_ip_target arp_validate 3)  [ OK ]
TEST: arp_validate (active-backup arp_ip_target arp_validate 4)  [ OK ]
TEST: arp_validate (active-backup arp_ip_target arp_validate 5)  [ OK ]
TEST: arp_validate (active-backup arp_ip_target arp_validate 6)  [ OK ]
TEST: arp_validate (active-backup ns_ip6_target arp_validate 0)  [ OK ]
TEST: arp_validate (active-backup ns_ip6_target arp_validate 1)  [ OK ]
TEST: arp_validate (interface eth1 mii_status DOWN)                 [FAIL]
TEST: arp_validate (interface eth2 mii_status DOWN)                 [FAIL]
TEST: arp_validate (active-backup ns_ip6_target arp_validate 2)  [FAIL]
TEST: arp_validate (interface eth1 mii_status DOWN)                 [FAIL]
TEST: arp_validate (interface eth2 mii_status DOWN)                 [FAIL]
TEST: arp_validate (active-backup ns_ip6_target arp_validate 3)  [FAIL]
TEST: arp_validate (active-backup ns_ip6_target arp_validate 4)  [ OK ]
TEST: arp_validate (active-backup ns_ip6_target arp_validate 5)  [ OK ]
TEST: arp_validate (interface eth1 mii_status DOWN)                 [FAIL]
TEST: arp_validate (interface eth2 mii_status DOWN)                 [FAIL]
TEST: arp_validate (active-backup ns_ip6_target arp_validate 6)  [FAIL]

Here is the test result after the kernel fix:
TEST: arp_validate (active-backup arp_ip_target arp_validate 0)  [ OK ]
TEST: arp_validate (active-backup arp_ip_target arp_validate 1)  [ OK ]
TEST: arp_validate (active-backup arp_ip_target arp_validate 2)  [ OK ]
TEST: arp_validate (active-backup arp_ip_target arp_validate 3)  [ OK ]
TEST: arp_validate (active-backup arp_ip_target arp_validate 4)  [ OK ]
TEST: arp_validate (active-backup arp_ip_target arp_validate 5)  [ OK ]
TEST: arp_validate (active-backup arp_ip_target arp_validate 6)  [ OK ]
TEST: arp_validate (active-backup ns_ip6_target arp_validate 0)  [ OK ]
TEST: arp_validate (active-backup ns_ip6_target arp_validate 1)  [ OK ]
TEST: arp_validate (active-backup ns_ip6_target arp_validate 2)  [ OK ]
TEST: arp_validate (active-backup ns_ip6_target arp_validate 3)  [ OK ]
TEST: arp_validate (active-backup ns_ip6_target arp_validate 4)  [ OK ]
TEST: arp_validate (active-backup ns_ip6_target arp_validate 5)  [ OK ]
TEST: arp_validate (active-backup ns_ip6_target arp_validate 6)  [ OK ]

Hangbin Liu (3):
  bonding: fix ns validation on backup slaves
  selftests: bonding: re-format bond option tests
  selftests: bonding: add arp validate test

 drivers/net/bonding/bond_main.c               |   5 +-
 include/net/bonding.h                         |   8 +-
 .../selftests/drivers/net/bonding/Makefile    |   3 +-
 .../selftests/drivers/net/bonding/bond_lib.sh | 145 ++++++++++
 .../drivers/net/bonding/bond_options.sh       | 271 ++++++++++++++++++
 .../drivers/net/bonding/option_prio.sh        | 245 ----------------
 6 files changed, 427 insertions(+), 250 deletions(-)
 create 100644 tools/testing/selftests/drivers/net/bonding/bond_lib.sh
 create 100755 tools/testing/selftests/drivers/net/bonding/bond_options.sh
 delete 100755 tools/testing/selftests/drivers/net/bonding/option_prio.sh

-- 
2.38.1

