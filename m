Return-Path: <netdev+bounces-5573-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C6B987122E1
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 11:02:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 68B0D1C20FD1
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 09:02:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDC45101FC;
	Fri, 26 May 2023 09:02:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B00E9101CF
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 09:02:50 +0000 (UTC)
Received: from smtpbgau2.qq.com (smtpbgau2.qq.com [54.206.34.216])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5DD512A
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 02:02:47 -0700 (PDT)
X-QQ-mid: bizesmtp89t1685091760teab997h
Received: from localhost.localdomain ( [125.120.148.168])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 26 May 2023 17:02:39 +0800 (CST)
X-QQ-SSF: 01400000000000N0Z000000A0000000
X-QQ-FEAT: CR3LFp2JE4ldUsx3gPFYMu1nBqusFnJ7flb62Da9e/lSCbWS5G3DOf29Sbz28
	79iR9Wb1TjKSCkknbWZ8bOXxCupMHuh/qWn0IlajEyusOh0/SffRUCNjyh2ZZKW9phboSgK
	1DY+aYExJTDL0jvp/W1t3F9xrCqZEGQd/WiHhQINmbJgl8iPbJB9+N5d/AYVrOQvbBVxAii
	jcdiK8SgjvsvTmWw/haKSsu1VoVtM2J3Y1CZ6QU3uyziNjfM0Hs0BAfdrH06K4eTrICdTg4
	C0JspNS1LnINwZsmV3edPuifEc9sU2yp9K93bjhijNVTW+630bqcVj3iD77JevDKR2/PFw7
	J5E0L6Cp/XQCW69CCbdvfWu54fd6DF59us1U5Q5V+hEPmBJ511e7/HzNGjP4Q==
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 10782373647122257453
From: Mengyuan Lou <mengyuanlou@net-swift.com>
To: netdev@vger.kernel.org
Cc: jiawenwu@trustnetic.com,
	Mengyuan Lou <mengyuanlou@net-swift.com>
Subject: [PATCH net-next v7 0/8] Wangxun netdev features support
Date: Fri, 26 May 2023 17:02:22 +0800
Message-Id: <20230526090230.71487-1-mengyuanlou@net-swift.com>
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
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Implement tx_csum and rx_csum to support hardware checksum offload.
Implement ndo_vlan_rx_add_vid and ndo_vlan_rx_kill_vid.
Implement ndo_set_features.
Enable macros in netdev features which wangxun can support.

changes v7:
- Remove fragmented packets parsing.
- Jakub Kicinski:
https://lore.kernel.org/netdev/20230523210454.12963d67@kernel.org/
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
 drivers/net/ethernet/wangxun/libwx/wx_lib.c   | 734 +++++++++++++++++-
 drivers/net/ethernet/wangxun/libwx/wx_lib.h   |   1 +
 drivers/net/ethernet/wangxun/libwx/wx_type.h  | 214 ++++-
 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c |  20 +-
 drivers/net/ethernet/wangxun/ngbe/ngbe_type.h |   1 +
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   |  25 +-
 .../net/ethernet/wangxun/txgbe/txgbe_type.h   |   1 +
 9 files changed, 1250 insertions(+), 21 deletions(-)

-- 
2.40.1


