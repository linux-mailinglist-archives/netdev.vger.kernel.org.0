Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC4666EDA13
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 03:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232809AbjDYBxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 21:53:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231350AbjDYBxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 21:53:44 -0400
Received: from smtpbgsg2.qq.com (smtpbgsg2.qq.com [54.254.200.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A3375FFD
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 18:53:42 -0700 (PDT)
X-QQ-mid: bizesmtp86t1682387422tylgoz2x
Received: from localhost.localdomain ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 25 Apr 2023 09:50:13 +0800 (CST)
X-QQ-SSF: 01400000000000N0S000000A0000000
X-QQ-FEAT: O/PHvn+k0TLIYqhbFecw67LyTsLRjbz37gI5heb9GHHgxBmUC7NreHBicbCon
        JOAVysZo9xI5opTAeC5ON6FuRoCiWu9ouU5CzX6QRnRgw90R1pF/ywnicfwSgRcrEwfUTkW
        LV6lyb+bpf2b6K0DDII9e5Not9ruWSXDBhcT9KarLkns0JvGnzX+9hGg47cEwE634WOsYJu
        SpIbdtOg0R/IhJapzmqPDVP+r3WgyWMIlgQq2wTykBbhTWkylyR916OWLYUjuo+cqZMnV8V
        SQTuE1VURor4GxjHk6bzKXm00gH1SSJdgHeX8S6oZnSR3y6bnZuhoOONHlqvlo1lB/6lRVG
        ONL4UOPnRFYKvzp3JwWu2uyoAt45FXfGMQ67rd63a7D21pgs+OuyVcWlIKkug==
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 4171407881376632857
From:   Mengyuan Lou <mengyuanlou@net-swift.com>
To:     netdev@vger.kernel.org
Cc:     jiawenwu@trustnetic.com, linyunsheng@huawei.com,
        Mengyuan Lou <mengyuanlou@net-swift.com>
Subject: [PATCH net-next 0/7] Wangxun netdev features support
Date:   Tue, 25 Apr 2023 09:50:04 +0800
Message-Id: <20230425015011.19980-1-mengyuanlou@net-swift.com>
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

