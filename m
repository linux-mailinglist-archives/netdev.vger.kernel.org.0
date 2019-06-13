Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC5844B2A
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 20:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729383AbfFMSxg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 14:53:36 -0400
Received: from mga12.intel.com ([192.55.52.136]:64322 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729290AbfFMSxc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 14:53:32 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Jun 2019 11:53:31 -0700
X-ExtLoop1: 1
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by FMSMGA003.fm.intel.com with ESMTP; 13 Jun 2019 11:53:31 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 12/12] i40e: mark expected switch fall-through
Date:   Thu, 13 Jun 2019 11:53:47 -0700
Message-Id: <20190613185347.16361-13-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190613185347.16361-1-jeffrey.t.kirsher@intel.com>
References: <20190613185347.16361-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>

In preparation to enabling -Wimplicit-fallthrough, mark switch cases
where we are expecting to fall through.

This patch fixes the following warning:

drivers/net/ethernet/intel/i40e/i40e_xsk.c: In function ‘i40e_run_xdp_zc’:
drivers/net/ethernet/intel/i40e/i40e_xsk.c:217:3: warning: this statement may fall through [-Wimplicit-fallthrough=]
   bpf_warn_invalid_xdp_action(act);
   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/intel/i40e/i40e_xsk.c:218:2: note: here
  case XDP_ABORTED:
  ^~~~

In preparation to enabling -Wimplicit-fallthrough, mark switch cases
where we are expecting to fall through.

This patch fixes the following warning:

Signed-off-by: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 1b17486543ac..557c565c26fc 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -215,6 +215,7 @@ static int i40e_run_xdp_zc(struct i40e_ring *rx_ring, struct xdp_buff *xdp)
 		break;
 	default:
 		bpf_warn_invalid_xdp_action(act);
+		/* fall through */
 	case XDP_ABORTED:
 		trace_xdp_exception(rx_ring->netdev, xdp_prog, act);
 		/* fallthrough -- handle aborts by dropping packet */
-- 
2.21.0

