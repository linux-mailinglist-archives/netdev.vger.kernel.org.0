Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45C725BE26A
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 11:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbiITJwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 05:52:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbiITJwj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 05:52:39 -0400
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 042346F268;
        Tue, 20 Sep 2022 02:52:31 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0VQIttFl_1663667542;
Received: from localhost(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0VQIttFl_1663667542)
          by smtp.aliyun-inc.com;
          Tue, 20 Sep 2022 17:52:28 +0800
From:   Wen Gu <guwen@linux.alibaba.com>
To:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 0/2] Separate SMC parameter settings from TCP sysctls
Date:   Tue, 20 Sep 2022 17:52:20 +0800
Message-Id: <1663667542-119851-1-git-send-email-guwen@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SMC shares some sysctls with TCP, but considering the difference
between these two protocols, it may not be very suitable for SMC
to reuse TCP parameter settings in some cases, such as keepalive
time or buffer size.

So this patch set aims to introduce some SMC specific sysctls to
independently and flexibly set the parameters that suit SMC.

v2->v1:
- Use proc_dointvec_jiffies as proc_handler and allow value 0 to
  disable TEST_LINK.

Tony Lu (1):
  net/smc: Unbind r/w buffer size from clcsock and make them tunable

Wen Gu (1):
  net/smc: Introduce a specific sysctl for TEST_LINK time

 Documentation/networking/smc-sysctl.rst | 25 +++++++++++++++++++++++++
 include/net/netns/smc.h                 |  3 +++
 net/smc/af_smc.c                        |  5 ++---
 net/smc/smc_core.c                      |  8 ++++----
 net/smc/smc_llc.c                       |  2 +-
 net/smc/smc_llc.h                       |  1 +
 net/smc/smc_sysctl.c                    | 30 ++++++++++++++++++++++++++++++
 7 files changed, 66 insertions(+), 8 deletions(-)

-- 
1.8.3.1

