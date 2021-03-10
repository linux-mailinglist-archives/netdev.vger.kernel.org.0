Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44F48333587
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 06:46:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbhCJFpn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 00:45:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:33672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229632AbhCJFpZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Mar 2021 00:45:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3116264FE5;
        Wed, 10 Mar 2021 05:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615355124;
        bh=ZnmCBtPGQPDnAgSACc/Eq90x0likYccLH8rqGBUrHYk=;
        h=Date:From:To:Cc:Subject:From;
        b=OwIuUEMNOD5wFB2QixhzUjkIbDmgMk5PFi5jg6CFWT5n3dkKey+9OS3JTZttkfpJk
         WJyM6hHCZUAQir7oqSL4zYZDGN1JukA05rflE3PCNoEAlx9kLekbAdTsJHE+A+NtaO
         K2MZ9tviW5HrDK33jaPDgOVelJaYgJ/RT9S3B4lqdWXh5Qy5WySuLIeuvga872CJWb
         zTZpzaLJZdRZIFN2I7QHVWugoPTGfQlfknQ7eLowpeEzc57pRrD0NdZa8DihMJSwWv
         7MI+jsKZAyuMBrFe+4l9HL9fx9TGlsqtq01LL96RHiYC6gyOnMYiqhXsIa1Ah/5JdP
         +fTnKql3j6XfQ==
Date:   Tue, 9 Mar 2021 23:45:22 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH RESEND][next] net: plip: Fix fall-through warnings for Clang
Message-ID: <20210310054522.GA286165@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation to enable -Wimplicit-fallthrough for Clang, fix multiple
warnings by explicitly adding multiple break statements instead of
letting the code fall through to the next case.

Link: https://github.com/KSPP/linux/issues/115
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 Changes in RESEND:
 - None. Resending now that net-next is open.

 drivers/net/plip/plip.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/plip/plip.c b/drivers/net/plip/plip.c
index 4406b353123e..e26cf91bdec2 100644
--- a/drivers/net/plip/plip.c
+++ b/drivers/net/plip/plip.c
@@ -516,6 +516,7 @@ plip_receive(unsigned short nibble_timeout, struct net_device *dev,
 		*data_p |= (c0 << 1) & 0xf0;
 		write_data (dev, 0x00); /* send ACK */
 		*ns_p = PLIP_NB_BEGIN;
+		break;
 	case PLIP_NB_2:
 		break;
 	}
@@ -808,6 +809,7 @@ plip_send_packet(struct net_device *dev, struct net_local *nl,
 				return HS_TIMEOUT;
 			}
 		}
+		break;
 
 	case PLIP_PK_LENGTH_LSB:
 		if (plip_send(nibble_timeout, dev,
-- 
2.27.0

