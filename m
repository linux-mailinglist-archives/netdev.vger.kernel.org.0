Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DEF235FE85
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 01:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbhDNXlB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 19:41:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:52636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229573AbhDNXkx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 19:40:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A3C161154;
        Wed, 14 Apr 2021 23:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618443631;
        bh=6AMkfmhqZ+ymzH4TXPVxlcheUmcqj8cx9zcbIe0hIRo=;
        h=Date:From:To:Cc:Subject:From;
        b=jqzshXe9OUNCXR0GWBT1J0ZmqgnmXnFAetB/B8094/kJuUEHDcv6qQLU7MSmtOrTx
         wxPjDwZCIZ+Iq65ZP1e/n4s94ga3cIZdyHAMmpoQn0MMQaqXv6MjdMd9AnV87ENlMb
         RjAerF0IgIjm3SgUCSr6DbdpuRSzKB/+IK3pKMMp9/DgE7mLZj9uFfoqfOJYyvcEPQ
         q9fIucTpzW9AUka+aAXITUOqMyUdr+e/yd7MLGHJHbKbE3VdRD4/qjXOAmNNTf7RlT
         R71dTiY9Qj3y9NTt7TREPCb7dfoCXOiokKG8i+UgAvAJNUz/Ha25rqqwsCPeW2FeWZ
         cijBd7FB3sdnw==
Date:   Wed, 14 Apr 2021 18:40:41 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     linux-kernel@vger.kernel.org
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH v3 0/2] Fix out-of-bounds warnings
Message-ID: <cover.1618442265.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix multiple out-of-bounds warnings by making the code a bit more
structured.

This helps with the ongoing efforts to globally enable -Warray-bounds
and get us closer to being able to tighten the FORTIFY_SOURCE routines
on memcpy().

Link: https://github.com/KSPP/linux/issues/109

Changes in v3:
 - Add new struct wl3501_req.
 - Update changelog text in patch 2/2.
 - Add Kees' RB tag to patch 1/2.
 - Fix one more instance of this same issue in both patches.

Changes in v2:
 - Update changelog text in patch 1/2.
 - Replace a couple of magic numbers with new variable sig_addr_len.

Gustavo A. R. Silva (2):
  wl3501_cs: Fix out-of-bounds warnings in wl3501_send_pkt
  wl3501_cs: Fix out-of-bounds warnings in wl3501_mgmt_join

 drivers/net/wireless/wl3501.h    | 47 ++++++++++++++-------------
 drivers/net/wireless/wl3501_cs.c | 54 +++++++++++++++++---------------
 2 files changed, 52 insertions(+), 49 deletions(-)

-- 
2.27.0

