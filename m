Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E5983947E6
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 22:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbhE1UYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 16:24:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:40638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229482AbhE1UYD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 May 2021 16:24:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3C7D6139A;
        Fri, 28 May 2021 20:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622233348;
        bh=5re2MKgn5nTgc6z6Y4UjVE6+Qn8hJ/F2jLPD8BSqhYY=;
        h=Date:From:To:Cc:Subject:From;
        b=fITFSG+lMurpbDMmhbtvoMlncj90plNSX9yBQoU+A0R/5nZGRnU52eIA7mqeJNyFh
         /8DPlHOD3xtGq/TmYbVA8KedyqfuCUD8y9OQUU+HNS0bMcty3OgmUF1vNqValBxx4l
         mbEMZQUaZVOiFau6hPVfFNT+lmD3Q0IQGJjV1hp43PCL4ElazyqTHeiY9pi1P7/cfF
         tMU5nn3rpCo0RoISWet7IazqILa0U557eisibZIY4J660xJYGmVrg7S51o0F96uMii
         hfAv83BzogFtBkPYoIet4u+9/8NcFYDpxzdAmZcsQgSjiXm3F5Fur1lHnSFof+kWfC
         iGxJdVkcwf5pw==
Date:   Fri, 28 May 2021 15:23:27 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     nic_swsd@realtek.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] r8169: Fix fall-through warning for Clang
Message-ID: <20210528202327.GA39994@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation to enable -Wimplicit-fallthrough for Clang, fix a warning
by explicitly adding a break statement instead of letting the code fall
through to the next case.

Link: https://github.com/KSPP/linux/issues/115
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
JFYI: We had thousands of these sorts of warnings and now we are down
      to just 25 in linux-next. This is one of those last remaining
      warnings.

 drivers/net/ethernet/realtek/r8169_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 1663e0486496..64f94a3fe646 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4115,6 +4115,7 @@ static unsigned int rtl_quirk_packet_padto(struct rtl8169_private *tp,
 	case RTL_GIGA_MAC_VER_61:
 	case RTL_GIGA_MAC_VER_63:
 		padto = max_t(unsigned int, padto, ETH_ZLEN);
+		break;
 	default:
 		break;
 	}
-- 
2.27.0

