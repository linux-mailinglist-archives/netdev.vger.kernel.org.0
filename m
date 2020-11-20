Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF48A2BB33C
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 19:38:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730594AbgKTSbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 13:31:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:50620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730290AbgKTSbT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 13:31:19 -0500
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A0C02415A;
        Fri, 20 Nov 2020 18:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605897079;
        bh=XIKYmKdjRI1gzWhxZBG74EcKpmMnCy+d6L7fpt4lhpU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VV8fsxo8EX/RFHekr1c3eC9PXyl/gd0O1mMGagRxUtQFNnvJ+5PWhV8VJZgPwfaEs
         mX1EWT9GhYCSYCfVLdYioqA8OnWa3XIUROs+UdPA/+z8QBo6hdlDNT13szvDz9xaZH
         y4gv5wAkRoa8hb8X5uu/JS5/Pl658dSJvk6DhdVE=
Date:   Fri, 20 Nov 2020 12:31:24 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Manish Chopra <manishc@marvell.com>,
        Rahul Verma <rahulv@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 046/141] netxen_nic: Fix fall-through warnings for Clang
Message-ID: <e66c4bcf4b1347cfc14075dc7b17ed8c3300c0f7.1605896059.git.gustavoars@kernel.org>
References: <cover.1605896059.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1605896059.git.gustavoars@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation to enable -Wimplicit-fallthrough for Clang, fix a warning
by explicitly adding a goto statement instead of just letting the code
fall through to the next case.

Link: https://github.com/KSPP/linux/issues/115
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c
index 94546ed5f867..2cd089cca622 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c
@@ -1686,6 +1686,7 @@ netxen_process_rcv_ring(struct nx_host_sds_ring *sds_ring, int max)
 			break;
 		case NETXEN_NIC_RESPONSE_DESC:
 			netxen_handle_fw_message(desc_cnt, consumer, sds_ring);
+			goto skip;
 		default:
 			goto skip;
 		}
-- 
2.27.0

