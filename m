Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9921BCF28
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 23:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbgD1Vvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 17:51:55 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:60383 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbgD1Vvz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 17:51:55 -0400
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue109 [212.227.15.145]) with ESMTPA (Nemesis) id
 1Mnac7-1imkao3kfN-00jX3M; Tue, 28 Apr 2020 23:51:36 +0200
From:   Arnd Bergmann <arnd@arndb.de>
To:     Netanel Belgazal <netanel@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Sameeh Jubran <sameehj@amazon.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Guy Tzalik <gtzalik@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        Zorik Machulsky <zorik@amazon.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH] net: ena: fix gcc-4.8 missing-braces warning
Date:   Tue, 28 Apr 2020 23:51:25 +0200
Message-Id: <20200428215131.3948527-1-arnd@arndb.de>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:eio/Sn10wNZ8eP76k+ivMjpj0w9kH5VYdd8pKjIDDJmnyUTYjlj
 wNLeF4Ab9tqskgvYVtVf3p4+v45TDrWL2xMEh0zywuz8ncc91zI4xMW9gK2XlkIMwDzjEEQ
 1p21YFg9T6glNvKht4dHZG8fEanK9c4mPx7W4b/9zW4BMtAEuJGQEvPMqjAWht7MVx2XBzT
 qe0HjXBmkfRSro17xVhcA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:aJcnJT7sWcE=:lgUJlhr00A1DGCATYjS5sm
 FBU2X7hVhPIi8k2M47qCv7Qk82Vfh1sUNybcQmV//wnR4rgKQ3vnZWSPXvsHViWXNYUWTE4m+
 h9XScbryIV5m2Ip/wOcuDQIPqLJYXOl3yFbdNsMLKtjFMsN9vvmnAnrU9p4cK/B12DsQ8oE7K
 tMk3GWWCQ2dpNzxf8pYpugaHLzhrZLQ7iUCPLNQL0D/rOIum27FpH5tek5MrHR8J41RY1fr76
 i9a1PyTtOttcF+VOb1u10jLDGwkovXJcZXqtjb6+MAa+0xQ8Gm+2vJBUSQtUnweDB4S8O9Cn3
 hIM92CTJonXKgmJHL61ZoK04MNRO+Tnjji9BEALjlUgCqCr46OvVLywHmwjjtvSKO1sdtoGkV
 k5jMKg3qEGuqfNzHi+Ef06m8YIzu1BGcr0g94wgZwLCo6BAbX2+6ypMDw5Rvbqsh4BWgwxVX4
 pU/vxpXPYQ8YMp54+inALnufyyd7n2bqvqin/3EVcuiCz+i0NOPriM+z9jOTK0YNxLdWk2iBA
 mnpFhk4H0bsTFre57cdPW0mJqUgdf9npr8nWSyKJrtECdd8k29fSk6LZZzL1WQui1OBKGsClz
 sFCmJqH3bkKByehwr0LbzhzAvO8QdDHLc09OhN1GUOG7hktmm3ocTqBHPSPqr57HvUP1HaT9C
 OzOx9BHBAarIsKPFlsCm+LyrfGQOpFkTHd0tev263YcivAcpuOQ6oWgw1jdLgzq/JyppmAFTx
 GVmW0FoThNUsUhzFfbsVXWYpwoqIRT4khv1WS51hPGuO4tXY7IrJJWSZY2S84NmI+CNs4DCVg
 6HB04JnlLnoGnguNcItK9vhHzzVc7OFFfNvVoZCP49wFRimUhU=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Older compilers warn about initializers with incorrect curly
braces:

drivers/net/ethernet/amazon/ena/ena_netdev.c: In function 'ena_xdp_xmit_buff':
drivers/net/ethernet/amazon/ena/ena_netdev.c:311:2: error: expected ',' or ';' before 'struct'
  struct ena_tx_buffer *tx_info;
  ^~~~~~
drivers/net/ethernet/amazon/ena/ena_netdev.c:321:2: error: 'tx_info' undeclared (first use in this function)
  tx_info = &xdp_ring->tx_buffer_info[req_id];
  ^~~~~~~
drivers/net/ethernet/amazon/ena/ena_netdev.c:321:2: note: each undeclared identifier is reported only once for each function it appears in

Use the GNU empty initializer extension to avoid this.

Fixes: 31aa9857f173 ("net: ena: enable negotiating larger Rx ring size")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 2cc765df8da3..ad385652ca24 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -307,7 +307,7 @@ static int ena_xdp_xmit_buff(struct net_device *dev,
 			     struct ena_rx_buffer *rx_info)
 {
 	struct ena_adapter *adapter = netdev_priv(dev);
-	struct ena_com_tx_ctx ena_tx_ctx = {0};
+	struct ena_com_tx_ctx ena_tx_ctx = { };
 	struct ena_tx_buffer *tx_info;
 	struct ena_ring *xdp_ring;
 	u16 next_to_use, req_id;
-- 
2.26.0

