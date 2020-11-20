Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 373D82BB37A
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 19:38:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730426AbgKTSeq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 13:34:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:53220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729325AbgKTSep (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 13:34:45 -0500
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40AA524124;
        Fri, 20 Nov 2020 18:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605897285;
        bh=nz88fsZ1iiyhj5l4g83Cwd3d4ZGW41AGCuBE6uJLGY0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=A2FEfeRbuwWYgAexc9zWbjZnLfdqHWknDRKV4Sr/vRN3Mn9OdaBVCdaDJ32+6LqgX
         n6jDNNxDKL+E+6Wd6UoNIxSQ/N9lnIHxSrwSUcipOVCS4K/DtIVnXTChn/JtqKIXlY
         HoRtMrl0zD+HQ+w6SECL2isAkYaavZuqWCaTHd/A=
Date:   Fri, 20 Nov 2020 12:34:50 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 074/141] cfg80211: Fix fall-through warnings for Clang
Message-ID: <ed94a115106fa9c6df94d09b2a6c5791c618c4f2.1605896059.git.gustavoars@kernel.org>
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
by explicitly adding a break statement instead of letting the code fall
through to the next case.

Link: https://github.com/KSPP/linux/issues/115
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 net/wireless/util.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index f01746894a4e..623a4dfb9877 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -335,6 +335,7 @@ int cfg80211_validate_key_settings(struct cfg80211_registered_device *rdev,
 	case WLAN_CIPHER_SUITE_WEP104:
 		if (key_idx > 3)
 			return -EINVAL;
+		break;
 	default:
 		break;
 	}
-- 
2.27.0

