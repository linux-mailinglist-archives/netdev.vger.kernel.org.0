Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C656D32E2F9
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 08:34:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbhCEHeI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 02:34:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:34650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229446AbhCEHeH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Mar 2021 02:34:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B173964F59;
        Fri,  5 Mar 2021 07:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614929647;
        bh=S2MMb6iAzEnkRQJZsxsHQCU5Dz1C7ovitVWgE5EloxQ=;
        h=Date:From:To:Cc:Subject:From;
        b=a0IXR79ZJaymLhmqN4IwpsNfUI+n1jvBglRlmKKAxwbLcmpK0sbGIN8+N28mFJa+O
         lvfk+/r6L4RQh2jnnun3xxgaOiIy/PRq7Md2dx+I5+RhmgJjE8h6XAfSnM9Ju1bMGN
         YaqoSaDNehwurRQ1vDmqM5YvSDGkTwIZAwQiQnbSoKGwsL/bWR8/azThA05RTfEgHW
         SWqTNbwPal3HR+P5B009UNGpT+UGuspsc1nx41WnxpJOt+lcOYewE1Sj9WJbGI/ULh
         ACND8fZaV8B8XE4Yhg7sVd0qe8RawFPQa6MBOcc6jNeC/IACkDW39i3I9Tyd8WPq4E
         xRFHfec0pbanw==
Date:   Fri, 5 Mar 2021 01:34:03 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] net: mscc: ocelot: Fix fall-through warnings for Clang
Message-ID: <20210305073403.GA122237@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation to enable -Wimplicit-fallthrough for Clang, fix a warning
by explicitly adding a break statement instead of just letting the code
fall through to the next case.

Link: https://github.com/KSPP/linux/issues/115
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_vcap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
index 37a232911395..7945393a0655 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -761,6 +761,7 @@ static void is1_entry_set(struct ocelot *ocelot, int ix,
 			vcap_key_bytes_set(vcap, &data, VCAP_IS1_HK_ETYPE,
 					   etype.value, etype.mask);
 		}
+		break;
 	}
 	default:
 		break;
-- 
2.27.0

