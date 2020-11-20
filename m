Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C98D2BB394
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 19:38:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731036AbgKTSgb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 13:36:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:54704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730741AbgKTSga (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 13:36:30 -0500
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9623B24181;
        Fri, 20 Nov 2020 18:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605897389;
        bh=7S93R+eoNCKQZlGjseYylH7acpfwBG3SpW0Kxq4QE48=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BQsFoDfPt97Hqe4bMx/+nJFBErE3ihpYfstpHH32WMT49PEd4wRxgDpUD34xKhXQE
         saTC+HYJtwePMgK+VHzkWcy7hHruj3NGoAhcd15x4PD6dQAsW/S8b9Gf6VZD5+3L6V
         ZCvrFiQE92MpRAglO182rMzltAxj1IX4ZE4MKVpE=
Date:   Fri, 20 Nov 2020 12:36:35 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 091/141] iwlwifi: iwl-drv: Fix fall-through warnings for Clang
Message-ID: <edd98d194bfc98b4be93a9bdc303630b719c0e66.1605896060.git.gustavoars@kernel.org>
References: <cover.1605896059.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1605896059.git.gustavoars@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation to enable -Wimplicit-fallthrough for Clang, fix a
warning by replacing a /* fall through */ comment with the new
pseudo-keyword macro fallthrough; instead of letting the code fall
through to the next case.

Notice that Clang doesn't recognize /* fall through */ comments as
implicit fall-through markings.

Link: https://github.com/KSPP/linux/issues/115
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 9dcd2e990c9c..6a9be73d7661 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1579,7 +1579,7 @@ static void iwl_req_fw_callback(const struct firmware *ucode_raw, void *context)
 		break;
 	default:
 		WARN(1, "Invalid fw type %d\n", fw->type);
-		/* fall through */
+		fallthrough;
 	case IWL_FW_MVM:
 		op = &iwlwifi_opmode_table[MVM_OP_MODE];
 		break;
-- 
2.27.0

