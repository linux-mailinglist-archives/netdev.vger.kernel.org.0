Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 086162B6B75
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 18:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728980AbgKQRNw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 12:13:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:55402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728356AbgKQRNv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 12:13:51 -0500
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD4F5238E6;
        Tue, 17 Nov 2020 17:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605633231;
        bh=7WkRxK5arTeUCAbPIL8VlU4xOQ6TguSLJpKy9GcF8H0=;
        h=Date:From:To:Cc:Subject:From;
        b=Pcoq605PrL84qpEFbT01Hud2NgXAAZUjgPcHRukkdgwNJUMl44XxbwOg+zHwGFvqu
         0rjX/N87jauhH6oDcKVqD5khZIQVOX21mokbUowHFirCUHcRz2Jn5uRAAu4PRW8rVS
         JeP8bM87Sp1lRlHhmIOB3Wc1dOWvRCLIduqqE8Qw=
Date:   Tue, 17 Nov 2020 11:13:47 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Simon Horman <simon.horman@netronome.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     oss-drivers@netronome.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH][next] nfp: tls: Fix unreachable code issue
Message-ID: <20201117171347.GA27231@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following unreachable code issue:

   drivers/net/ethernet/netronome/nfp/crypto/tls.c: In function 'nfp_net_tls_add':
   include/linux/compiler_attributes.h:208:41: warning: statement will never be executed [-Wswitch-unreachable]
     208 | # define fallthrough                    __attribute__((__fallthrough__))
         |                                         ^~~~~~~~~~~~~
   drivers/net/ethernet/netronome/nfp/crypto/tls.c:299:3: note: in expansion of macro 'fallthrough'
     299 |   fallthrough;
         |   ^~~~~~~~~~~

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/ethernet/netronome/nfp/crypto/tls.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/crypto/tls.c b/drivers/net/ethernet/netronome/nfp/crypto/tls.c
index 76c51da5b66f..9b32ae46011c 100644
--- a/drivers/net/ethernet/netronome/nfp/crypto/tls.c
+++ b/drivers/net/ethernet/netronome/nfp/crypto/tls.c
@@ -295,8 +295,8 @@ nfp_net_tls_add(struct net_device *netdev, struct sock *sk,
 			ipv6 = true;
 			break;
 		}
-#endif
 		fallthrough;
+#endif
 	case AF_INET:
 		req_sz = sizeof(struct nfp_crypto_req_add_v4);
 		ipv6 = false;
-- 
2.27.0

