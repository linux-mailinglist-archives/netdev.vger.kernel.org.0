Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA5A724CDF9
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 08:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726216AbgHUG2P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 02:28:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:41414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725268AbgHUG2P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Aug 2020 02:28:15 -0400
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B898620738;
        Fri, 21 Aug 2020 06:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597991294;
        bh=0MGVliHRNiKQ4/z6mRwpRlF0hwNE6dspbCVHx4C7XIM=;
        h=Date:From:To:Cc:Subject:From;
        b=lHHiwIGLcdRgRoF8qp6tFDMVHrmTnjm+0vaeS1QhFZuJTfT8+vTj0MFGnx+qA+Wg4
         37Kp+dWqrwOJEzPidulDvejiwuFjMT8sUHCYak6Eq5QXX86HPykcxpVp4C0JtYGHPd
         3YgonBmigKvXt2OTtmEfkY1m+p48qP83PZ0O34sQ=
Date:   Fri, 21 Aug 2020 01:34:02 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH][next] orinoco: Use fallthrough pseudo-keyword
Message-ID: <20200821063402.GA12500@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace the existing /* fall through */ comments and its variants with
the new pseudo-keyword macro fallthrough[1].

[1] https://www.kernel.org/doc/html/v5.7/process/deprecated.html?highlight=fallthrough#implicit-switch-case-fall-through

Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/wireless/intersil/orinoco/main.c        | 4 ++--
 drivers/net/wireless/intersil/orinoco/orinoco_usb.c | 8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intersil/orinoco/main.c b/drivers/net/wireless/intersil/orinoco/main.c
index 00264a14e52c..a1e041c91190 100644
--- a/drivers/net/wireless/intersil/orinoco/main.c
+++ b/drivers/net/wireless/intersil/orinoco/main.c
@@ -1503,7 +1503,7 @@ void __orinoco_ev_info(struct net_device *dev, struct hermes *hw)
 			schedule_work(&priv->join_work);
 			break;
 		}
-		/* fall through */
+		fallthrough;
 	case HERMES_INQ_HOSTSCAN:
 	case HERMES_INQ_HOSTSCAN_SYMBOL: {
 		/* Result of a scanning. Contains information about
@@ -1594,7 +1594,7 @@ void __orinoco_ev_info(struct net_device *dev, struct hermes *hw)
 		/* Ignore this frame for now */
 		if (priv->firmware_type == FIRMWARE_TYPE_AGERE)
 			break;
-		/* fall through */
+		fallthrough;
 	default:
 		printk(KERN_DEBUG "%s: Unknown information frame received: "
 		       "type 0x%04x, length %d\n", dev->name, type, len);
diff --git a/drivers/net/wireless/intersil/orinoco/orinoco_usb.c b/drivers/net/wireless/intersil/orinoco/orinoco_usb.c
index 11fa38fedd87..db316b6ff9ae 100644
--- a/drivers/net/wireless/intersil/orinoco/orinoco_usb.c
+++ b/drivers/net/wireless/intersil/orinoco/orinoco_usb.c
@@ -535,7 +535,7 @@ static void ezusb_request_out_callback(struct urb *urb)
 						       flags);
 				break;
 			}
-			/* fall through */
+			fallthrough;
 		case EZUSB_CTX_RESP_RECEIVED:
 			/* IN already received before this OUT-ACK */
 			ctx->state = EZUSB_CTX_COMPLETE;
@@ -557,7 +557,7 @@ static void ezusb_request_out_callback(struct urb *urb)
 		case EZUSB_CTX_REQ_SUBMITTED:
 		case EZUSB_CTX_RESP_RECEIVED:
 			ctx->state = EZUSB_CTX_REQ_FAILED;
-			/* fall through */
+			fallthrough;
 
 		case EZUSB_CTX_REQ_FAILED:
 		case EZUSB_CTX_REQ_TIMEOUT:
@@ -897,11 +897,11 @@ static int ezusb_access_ltv(struct ezusb_priv *upriv,
 	case EZUSB_CTX_REQ_SUBMITTED:
 		if (!ctx->in_rid)
 			break;
-		/* fall through */
+		fallthrough;
 	default:
 		err("%s: Unexpected context state %d", __func__,
 		    state);
-		/* fall through */
+		fallthrough;
 	case EZUSB_CTX_REQ_TIMEOUT:
 	case EZUSB_CTX_REQ_FAILED:
 	case EZUSB_CTX_RESP_TIMEOUT:
-- 
2.27.0

