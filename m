Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22A4D4E51E4
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 13:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234249AbiCWMLx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 08:11:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236449AbiCWMLs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 08:11:48 -0400
Received: from chinatelecom.cn (prt-mail.chinatelecom.cn [42.123.76.227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C42623983D;
        Wed, 23 Mar 2022 05:10:18 -0700 (PDT)
HMM_SOURCE_IP: 172.18.0.48:39292.1744386625
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-202.80.192.38 (unknown [172.18.0.48])
        by chinatelecom.cn (HERMES) with SMTP id 5D1EF280091;
        Wed, 23 Mar 2022 20:10:11 +0800 (CST)
X-189-SAVE-TO-SEND: +sunshouxin@chinatelecom.cn
Received: from  ([172.18.0.48])
        by app0024 with ESMTP id b50bb167c0cd45d59b86a04e4d195a3f for j.vosburgh@gmail.com;
        Wed, 23 Mar 2022 20:10:16 CST
X-Transaction-ID: b50bb167c0cd45d59b86a04e4d195a3f
X-Real-From: sunshouxin@chinatelecom.cn
X-Receive-IP: 172.18.0.48
X-MEDUSA-Status: 0
Sender: sunshouxin@chinatelecom.cn
From:   Sun Shouxin <sunshouxin@chinatelecom.cn>
To:     j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, oliver@neukum.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        huyd12@chinatelecom.cn, sunshouxin@chinatelecom.cn
Subject: [PATCH v6 0/4] Add support for IPV6 RLB to balance-alb mode
Date:   Wed, 23 Mar 2022 08:09:02 -0400
Message-Id: <20220323120906.42692-1-sunshouxin@chinatelecom.cn>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is implementing IPV6 RLB for balance-alb mode.

Sun Shouxin (4):
  net:ipv6:Add void *data to ndisc_send_na function
  net:ipv6:Refactor ndisc_send_na to support sending na by slave
    directly
  net:ipv6:Export inet6_ifa_finish_destroy and ipv6_get_ifaddr
  net:bonding:Add support for IPV6 RLB to balance-alb mode

 drivers/net/bonding/bond_3ad.c     |   2 +-
 drivers/net/bonding/bond_alb.c     | 612 ++++++++++++++++++++++++++++-
 drivers/net/bonding/bond_debugfs.c |  14 +
 drivers/net/bonding/bond_main.c    |   6 +-
 drivers/net/usb/cdc_mbim.c         |   3 +-
 include/net/bond_3ad.h             |   2 +-
 include/net/bond_alb.h             |   7 +
 include/net/bonding.h              |   6 +-
 include/net/ipv6_stubs.h           |   3 +-
 include/net/ndisc.h                |   9 +-
 net/ipv6/addrconf.c                |   4 +-
 net/ipv6/ndisc.c                   |  64 ++-
 12 files changed, 696 insertions(+), 36 deletions(-)


base-commit: 2af7e566a8616c278e1d7287ce86cd3900bed943
-- 
2.27.0

