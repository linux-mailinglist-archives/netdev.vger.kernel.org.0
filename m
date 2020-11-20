Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ECD22BB2DF
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 19:37:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729366AbgKTS0s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 13:26:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:47692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728002AbgKTS0r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 13:26:47 -0500
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 624DA2224C;
        Fri, 20 Nov 2020 18:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605896807;
        bh=MeKVa89bjFAaYgcLc1fUItpAvL7pe24eM5yo8zjhQ4U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hWsULgWAmhRu/Dh2HkOo1HT/wQluzHylYW3QAiGqhdY5Ub7yYm3uN56LbwUwGFmCU
         FSU8Hi060GR+7lKq/PVKC10zBk3NfJKsx3pPRWRAFA5rMYul9cPgwBmozJHiiH9Dwf
         sg6fqSXLCGYW7pKryEa3U5xOAh0Ms+eo5vF7pZP0=
Date:   Fri, 20 Nov 2020 12:26:52 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Ariel Elior <aelior@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     GR-everest-linux-l2@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 018/141] qed: Fix fall-through warnings for Clang
Message-ID: <35915deb94f9ad166f8984259050cfadd80b2567.1605896059.git.gustavoars@kernel.org>
References: <cover.1605896059.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1605896059.git.gustavoars@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation to enable -Wimplicit-fallthrough for Clang, fix multiple
warnings by explicitly adding a couple of break statements instead of
just letting the code fall through to the next case.

Link: https://github.com/KSPP/linux/issues/115
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed_l2.c    | 1 +
 drivers/net/ethernet/qlogic/qed/qed_sriov.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_l2.c b/drivers/net/ethernet/qlogic/qed/qed_l2.c
index 07824bf9d68d..dfaf10edfabf 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_l2.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_l2.c
@@ -396,6 +396,7 @@ int qed_sp_eth_vport_start(struct qed_hwfn *p_hwfn,
 		tpa_param->tpa_ipv6_en_flg = 1;
 		tpa_param->tpa_pkt_split_flg = 1;
 		tpa_param->tpa_gro_consistent_flg = 1;
+		break;
 	default:
 		break;
 	}
diff --git a/drivers/net/ethernet/qlogic/qed/qed_sriov.c b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
index b8dc5c4591ef..ed2b6fe5a78d 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_sriov.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
@@ -4734,6 +4734,7 @@ void qed_inform_vf_link_state(struct qed_hwfn *hwfn)
 			 */
 			link.speed = (hwfn->cdev->num_hwfns > 1) ?
 				     100000 : 40000;
+			break;
 		default:
 			/* In auto mode pass PF link image to VF */
 			break;
-- 
2.27.0

