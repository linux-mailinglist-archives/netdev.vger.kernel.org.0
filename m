Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A92EE6F1184
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 07:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbjD1F5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 01:57:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbjD1F5e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 01:57:34 -0400
Received: from smtpbgbr2.qq.com (smtpbgbr2.qq.com [54.207.22.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A24712685
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 22:57:31 -0700 (PDT)
X-QQ-mid: bizesmtp65t1682661443tf13nzuh
Received: from localhost.localdomain ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Fri, 28 Apr 2023 13:57:11 +0800 (CST)
X-QQ-SSF: 01400000000000N0S000000A0000000
X-QQ-FEAT: 7QbCsSX/jDZZj6WWr3FObjB9Ekknf0t+lWnrPopSuZEtMDtJNjP+ts8V6zZC9
        ezLIfHMG+Ka5kuATWUy6CFjFkOaWYxHQtq+SF1k+21RaKkUF3m6/C3g6GI5qXI9PtNF6ceM
        XOzn2NJijBXObhzdDPfdmfc916XQq4Mz3sYqyX7j050l4N5x1CdSSpxPLS2Lkc2kDqrw2Ad
        FOl3MzgCQy09Dhz+wMu2l0egHFHZubPBUmwBF195/iAf+UiGuIE34PhGMpWGbU/rLsfbQm1
        riWnDlgNV2YdttGmni4q4AwPqBAQOqjvrEFZbE8P2o4eKXeWA2u3AIfmIe0fGBUrOA3lJTH
        q8rm9FGshWh4uKHxCPOlKgewyXYM+1FDu3IfLjMlYGrlD/R3NA4pDqtkCRrVw==
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 14948391135153430874
From:   Mengyuan Lou <mengyuanlou@net-swift.com>
To:     netdev@vger.kernel.org
Cc:     jiawenwu@trustnetic.com, Mengyuan Lou <mengyuanlou@net-swift.com>
Subject: [RFC PATCH net-next v4 0/7] Wangxun netdev features support
Date:   Fri, 28 Apr 2023 13:57:02 +0800
Message-Id: <20230428055709.66071-1-mengyuanlou@net-swift.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:net-swift.com:qybglogicsvrgz:qybglogicsvrgz6a-1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement tx_csum and rx_csum to support hardware checksum offload.
Implement ndo_vlan_rx_add_vid and ndo_vlan_rx_kill_vid.
Enable macros in netdev features which wangxun can support.

changes v4:
- Yunsheng Lin:
https://lore.kernel.org/netdev/c4b9765d-7213-2718-5de3-5e8231753b95@huawei.com/
changes v3:
- Yunsheng Lin: Tidy up logic for wx_encode_tx_desc_ptype.
changes v2:
- Andrew Lunn:
Add ETH_P_CNM Congestion Notification Message to if_ether.h.
Remove lro support.
- Yunsheng Lin:
https://lore.kernel.org/netdev/eb75ae23-8c19-bbc5-e99a-9b853511affa@huawei.com/

Mengyuan Lou (7):
  net: wangxun: libwx add tx offload functions
  net: wangxun: libwx add rx offload functions
  net: wangxun: Implement vlan add and kill functions
  net: ngbe add netdev features support
  net: ngbe: Implement vlan add and remove ops
  net: txgbe add netdev features support
  net: txgbe: Implement vlan add and remove ops

 drivers/net/ethernet/wangxun/libwx/wx_hw.c    | 275 +++++++-
 drivers/net/ethernet/wangxun/libwx/wx_hw.h    |   3 +
 drivers/net/ethernet/wangxun/libwx/wx_lib.c   | 600 +++++++++++++++++-
 drivers/net/ethernet/wangxun/libwx/wx_type.h  | 362 ++++++++++-
 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c |  19 +-
 drivers/net/ethernet/wangxun/ngbe/ngbe_type.h |   1 +
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   |  24 +-
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |   1 +
 8 files changed, 1265 insertions(+), 20 deletions(-)

-- 
2.40.0

