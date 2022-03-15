Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83B4A4D954C
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 08:32:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345523AbiCOHdK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 03:33:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345442AbiCOHc4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 03:32:56 -0400
Received: from chinatelecom.cn (prt-mail.chinatelecom.cn [42.123.76.222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6DA6C4B1CA;
        Tue, 15 Mar 2022 00:31:44 -0700 (PDT)
HMM_SOURCE_IP: 172.18.0.48:41014.619685907
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-202.80.192.38 (unknown [172.18.0.48])
        by chinatelecom.cn (HERMES) with SMTP id 1D2D82800BD;
        Tue, 15 Mar 2022 15:31:37 +0800 (CST)
X-189-SAVE-TO-SEND: +sunshouxin@chinatelecom.cn
Received: from  ([172.18.0.48])
        by app0024 with ESMTP id c0602a13fffb4ad588a48c84e8f1aa50 for j.vosburgh@gmail.com;
        Tue, 15 Mar 2022 15:31:41 CST
X-Transaction-ID: c0602a13fffb4ad588a48c84e8f1aa50
X-Real-From: sunshouxin@chinatelecom.cn
X-Receive-IP: 172.18.0.48
X-MEDUSA-Status: 0
Sender: sunshouxin@chinatelecom.cn
From:   Sun Shouxin <sunshouxin@chinatelecom.cn>
To:     j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, oliver@neukum.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        huyd12@chinatelecom.cn, sunshouxin@chinatelecom.cn
Subject: [PATCH v2 0/4] net:bonding:Add support for IPV6 RLB to balance-alb mode
Date:   Tue, 15 Mar 2022 03:30:04 -0400
Message-Id: <20220315073008.17441-1-sunshouxin@chinatelecom.cn>
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
  net:ipv6:Refactor ndisc_send_na to support sending na by slave
    directly
  net:ipv6:Export inet6_ifa_finish_destroy and ipv6_get_ifaddr
  net:bonding:Add support for IPV6 RLB to balance-alb mode
  net: usb:Refactor ndisc_send_na

 drivers/net/bonding/bond_3ad.c     |   2 +-
 drivers/net/bonding/bond_alb.c     | 591 ++++++++++++++++++++++++++++-
 drivers/net/bonding/bond_debugfs.c |  14 +
 drivers/net/bonding/bond_main.c    |   6 +-
 drivers/net/usb/cdc_mbim.c         |   2 +-
 include/net/bond_3ad.h             |   2 +-
 include/net/bond_alb.h             |   7 +
 include/net/bonding.h              |   6 +-
 include/net/ipv6_stubs.h           |   3 +-
 include/net/ndisc.h                |   9 +-
 net/ipv6/addrconf.c                |   4 +-
 net/ipv6/ndisc.c                   |  65 +++-
 12 files changed, 675 insertions(+), 36 deletions(-)


base-commit: bdd6a89de44b9e07d0b106076260d2367fe0e49a
-- 
2.27.0

