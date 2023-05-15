Return-Path: <netdev+bounces-2630-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D6EF702C50
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 14:09:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 54A071C20B30
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 12:08:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84A03C8C1;
	Mon, 15 May 2023 12:08:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A227C139
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 12:08:59 +0000 (UTC)
Received: from smtpbg156.qq.com (smtpbg156.qq.com [15.184.82.18])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4554EB8
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 05:08:55 -0700 (PDT)
X-QQ-mid: bizesmtp77t1684152527tkz8d16g
Received: from localhost.localdomain ( [115.200.228.151])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 15 May 2023 20:08:36 +0800 (CST)
X-QQ-SSF: 01400000000000N0Z000000A0000000
X-QQ-FEAT: CR3LFp2JE4kOYXtybtVeFjrzwtPk2P+GzUP+JFXrbrQRNgIDO44s6Urb4joX4
	YvhSejtIqtZyi7Lv8sZwAJBMpD5rkoC+OF2oZDwMWV3aLLOL3xbtfsgdo7o+h4gsDAZIvFR
	ZNzGscJmJFPRFXVu7zd7KBlNrbdCpGXQwIMbEB8/X0dZmCS4OUKTc5ciHXnOOa4K4TWBe5J
	5sXsL6nZoymvFlhyOTzLzdslVoRTDymxPH8M1+YbNdv66g6gqqm4eWjKjWsX3VkgYr+d079
	l2yDwk4Gq1CswKjNRgIR8cbel3+fel40VBmnuMJHC5r8qPxKmBgbT/Hp0TlusKwNK6csoHE
	7Hi+qraiObMtMCDg144q8gZGST3eSc2EsFPfANYMDLHyJ5D7MZgFNd9leyCAcdHMqyQmtOo
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 374876480080082013
From: Mengyuan Lou <mengyuanlou@net-swift.com>
To: netdev@vger.kernel.org
Cc: jiawenwu@trustnetic.com,
	Mengyuan Lou <mengyuanlou@net-swift.com>
Subject: [PATCH net-next v5 0/8] Wangxun netdev features support
Date: Mon, 15 May 2023 20:08:21 +0800
Message-Id: <20230515120829.74861-1-mengyuanlou@net-swift.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:net-swift.com:qybglogicsvrgz:qybglogicsvrgz5a-3
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
	SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Implement tx_csum and rx_csum to support hardware checksum offload.
Implement ndo_vlan_rx_add_vid and ndo_vlan_rx_kill_vid.
Implement ndo_set_features.
Enable macros in netdev features which wangxun can support.

changes v5:
- Add ndo_set_features support.
- Move wx_decode_ptype() and wx_ptype_lookup to C file.
- Remove wx_fwd_adapter.
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

Mengyuan Lou (8):
  net: wangxun: libwx add tx offload functions
  net: wangxun: libwx add rx offload functions
  net: wangxun: Implement vlan add and kill functions
  net: libwx: Implement xx_set_features ops
  net: ngbe: Add netdev features support
  net: ngbe: Implement vlan add and remove ops
  net: txgbe: Add netdev features support
  net: txgbe: Implement vlan add and remove ops

 drivers/net/ethernet/wangxun/libwx/wx_hw.c    | 272 ++++++-
 drivers/net/ethernet/wangxun/libwx/wx_hw.h    |   3 +
 drivers/net/ethernet/wangxun/libwx/wx_lib.c   | 757 +++++++++++++++++-
 drivers/net/ethernet/wangxun/libwx/wx_lib.h   |   1 +
 drivers/net/ethernet/wangxun/libwx/wx_type.h  | 219 ++++-
 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c |  20 +-
 drivers/net/ethernet/wangxun/ngbe/ngbe_type.h |   1 +
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   |  25 +-
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |   1 +
 9 files changed, 1278 insertions(+), 21 deletions(-)

-- 
2.40.1


