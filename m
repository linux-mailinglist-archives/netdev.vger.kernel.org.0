Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B06346E2F51
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 08:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbjDOGpl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 02:45:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjDOGpk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 02:45:40 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74E36559D;
        Fri, 14 Apr 2023 23:45:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681541139; x=1713077139;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=XPf0NWZspgmTmraWV1B8of1VGZ27Uk2q/PwjqH0foXk=;
  b=LoS2NEQQYFS+rj03ionLpzDk1zhJ+7Cihz/6QhiB01rsd/BbuEHqzS79
   UxnP8HvG1dQfRglyMMuPiFK1vjAD9I+oKYtuOpSlVO3PasYt4leJfoDfE
   d4HrLt1Z45If9WvTNiSvr0wXn+fiyJC5PL1X9H8BfO3FbEnx02i9WPjb6
   l675rN+EarEYkUfNzdIZ3wb9Tbes+AKfUX+Q8m6l7aa3qp7nLEntNb4Su
   AVyEyLVyzTQpA3bf21CMbnFPQchA/x+Zq+HDKbcBGfthgaBERPpjRlNEM
   S/k1XhmD+kVlBXFltrRHGRG0zudlGKadCnoW6aiJ74IlQwcnyMPtTg7ds
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10680"; a="343379257"
X-IronPort-AV: E=Sophos;i="5.99,199,1677571200"; 
   d="scan'208";a="343379257"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2023 23:45:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10680"; a="754727538"
X-IronPort-AV: E=Sophos;i="5.99,199,1677571200"; 
   d="scan'208";a="754727538"
Received: from p12ill20yoongsia.png.intel.com ([10.88.227.28])
  by fmsmga008.fm.intel.com with ESMTP; 14 Apr 2023 23:45:33 -0700
From:   Song Yoong Siang <yoong.siang.song@intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, xdp-hints@xdp-project.net,
        Song Yoong Siang <yoong.siang.song@intel.com>
Subject: [PATCH net-next v6 0/3] XDP Rx HWTS metadata for stmmac driver
Date:   Sat, 15 Apr 2023 14:45:00 +0800
Message-Id: <20230415064503.3225835-1-yoong.siang.song@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implemented XDP receive hardware timestamp metadata for stmmac driver.

This patchset is tested with tools/testing/selftests/bpf/xdp_hw_metadata.
Below are the test steps and results.

Command on DUT:
	sudo ./xdp_hw_metadata <interface name>

Command on Link Partner:
	echo -n xdp | nc -u -q1 <destination IPv4 addr> 9091
	echo -n skb | nc -u -q1 <destination IPv4 addr> 9092

Result for port 9091:
	poll: 1 (0) skip=1 fail=0 redir=1
	xsk_ring_cons__peek: 1
	0x55f69f65f6d0: rx_desc[0]->addr=100000000008000 addr=8100 comp_addr=8000
	rx_timestamp: 1677762069053692631
	No rx_hash err=-95
	0x55f69f65f6d0: complete idx=8 addr=8000

Result for port 9092:
	poll: 1 (0) skip=2 fail=0 redir=1
	found skb hwtstamp = 1677762071.937207680

changelog:
v5 -> v6: improve field naming of struct stmmac_xdp_buff

v4 -> v5: remove zeroing operation on ctx variable

v3 -> v4: directly retrieve Rx HWTS in stmmac_xdp_rx_timestamp(), instead
	  of reuse stmmac_get_rx_hwtstamp()

v2 -> v3: To reduce packet processing cost, get the Rx HWTS only when
	  xmo_rx_timestamp() is called

v1 -> v2: Add static to stmmac_xdp_metadata_ops declaration

---

Song Yoong Siang (3):
  net: stmmac: introduce wrapper for struct xdp_buff
  net: stmmac: add Rx HWTS metadata to XDP receive pkt
  net: stmmac: add Rx HWTS metadata to XDP ZC receive pkt

 drivers/net/ethernet/stmicro/stmmac/stmmac.h  |  7 ++
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 80 ++++++++++++++++---
 2 files changed, 77 insertions(+), 10 deletions(-)

-- 
2.34.1

