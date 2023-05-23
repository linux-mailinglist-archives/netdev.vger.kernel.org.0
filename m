Return-Path: <netdev+bounces-4506-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C269C70D230
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 05:07:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 490631C20C1A
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 03:07:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 741D06D1B;
	Tue, 23 May 2023 03:07:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 602BC5385
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 03:07:23 +0000 (UTC)
Received: from smtpbgeu2.qq.com (smtpbgeu2.qq.com [18.194.254.142])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A286E8F
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 20:07:16 -0700 (PDT)
X-QQ-mid: bizesmtp73t1684811228tj1rodw1
Received: from localhost.localdomain ( [122.235.247.1])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 23 May 2023 11:07:03 +0800 (CST)
X-QQ-SSF: 01400000000000N0Z000000A0000000
X-QQ-FEAT: +ynUkgUhZJnjzrN7mCdPlpOCHNcqC2SBfRddTyJ0QWBIVZVCTslpAG8GBH49T
	kZ3hbmNTOMuge4CZMDVjTWOCVZb5O8TeJF63j6b5Z8hSx0uExJuAMY3umhthsHrW8Ar4+r+
	N5MrbOv5swkDMqWwA7aKfBxmFm77w0q1A5vWWo4lzn7a1EUgQk+H3K7bNdrUd33yfdi0iFb
	J5XioEV5fUxXxnkswMoLmgB5MzVqhr0rBBSyWpOOM8VGLF4Sh/8r2QwcycLw0rvzLTqhBaD
	XDYAbqxhvBgsJICRKJsZNzu+bBEhaSL5uapxdQwC7JB1678juHTs98bj6EqDrviiiK2ZHu3
	TtndhJJAjc2/H1C81EZ0evm96pOoX/HffJ8yTeC8KzPQPHZvWqjOmDiW1zoxpooVb+/J7OU
	/en2Z/A1hMM=
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 2128189509286045280
From: Mengyuan Lou <mengyuanlou@net-swift.com>
To: netdev@vger.kernel.org
Cc: jiawenwu@trustnetic.com,
	Mengyuan Lou <mengyuanlou@net-swift.com>
Subject: [PATCH net-next v6 0/8] Wangxun netdev features support
Date: Tue, 23 May 2023 11:06:50 +0800
Message-Id: <20230523030658.17738-1-mengyuanlou@net-swift.com>
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
	RCVD_IN_MSPIKE_H2,SPF_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Implement tx_csum and rx_csum to support hardware checksum offload.
Implement ndo_vlan_rx_add_vid and ndo_vlan_rx_kill_vid.
Implement ndo_set_features.
Enable macros in netdev features which wangxun can support.

changes v6:
- Fix some code spelling errors.
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
 drivers/net/ethernet/wangxun/libwx/wx_type.h  | 214 ++++-
 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c |  20 +-
 drivers/net/ethernet/wangxun/ngbe/ngbe_type.h |   1 +
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   |  25 +-
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |   1 +
 9 files changed, 1273 insertions(+), 21 deletions(-)

-- 
2.40.1


