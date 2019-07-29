Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35ABF79909
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 22:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730510AbfG2UMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 16:12:34 -0400
Received: from gateway21.websitewelcome.com ([192.185.45.147]:24368 "EHLO
        gateway21.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730492AbfG2UMd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 16:12:33 -0400
X-Greylist: delayed 651 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Jul 2019 16:12:33 EDT
Received: from cm17.websitewelcome.com (cm17.websitewelcome.com [100.42.49.20])
        by gateway21.websitewelcome.com (Postfix) with ESMTP id E4289400C52FF
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 15:12:32 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id sC0Why4Zm90onsC0Whpf5e; Mon, 29 Jul 2019 15:12:32 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=oENqlPZb6frT+9DV38Oo3+KZ9Fe2eujoFK1IJWgO4vw=; b=bvchi7hMrWhQPxGx54HWPe1FFE
        9Q7FdSp3dSqUxWMZ+3xyYnsciVZgTrxHcDFC371vq/52zy+/8aD/Hz/ggxNEn2bwxK3flx8V3/g2g
        l7sfwySfRiFiZq9P3gVtkvj/emQCy/xz3ccUV2c999hwW9IqmPuVRsCn/LXhRnjBiKzTI28sAKyHf
        lE9nn1YYGg3ji/WXTmN+J7XAE6mIimvc6ZhHwqMzGiwyTiNWol3A4FK13CZFKKY3ZMilxo3uITFrW
        rY27zgrimQSiK5JbrN+igpeqSesCY2ah3B+6RZf0HhxA3la4QRsbCyutGKebvwisgI03eU+eO+ByX
        5Ufd6JwQ==;
Received: from [187.192.11.120] (port=59540 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.92)
        (envelope-from <gustavo@embeddedor.com>)
        id 1hsC0V-000znM-P1; Mon, 29 Jul 2019 15:12:31 -0500
Date:   Mon, 29 Jul 2019 15:12:31 -0500
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Thomas Sailer <t.sailer@alumni.ethz.ch>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH] net: hamradio: baycom_epp: Mark expected switch fall-through
Message-ID: <20190729201231.GA7576@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.192.11.120
X-Source-L: No
X-Exim-ID: 1hsC0V-000znM-P1
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [187.192.11.120]:59540
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 14
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mark switch cases where we are expecting to fall through.

This patch fixes the following warning (Building: i386):

drivers/net/hamradio/baycom_epp.c: In function ‘transmit’:
drivers/net/hamradio/baycom_epp.c:491:7: warning: this statement may fall through [-Wimplicit-fallthrough=]
    if (i) {
       ^
drivers/net/hamradio/baycom_epp.c:504:3: note: here
   default:  /* fall through */
   ^~~~~~~

Notice that, in this particular case, the code comment is
modified in accordance with what GCC is expecting to find.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/hamradio/baycom_epp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/hamradio/baycom_epp.c b/drivers/net/hamradio/baycom_epp.c
index daab2c07d891..9303aeb2595f 100644
--- a/drivers/net/hamradio/baycom_epp.c
+++ b/drivers/net/hamradio/baycom_epp.c
@@ -500,8 +500,9 @@ static int transmit(struct baycom_state *bc, int cnt, unsigned char stat)
 				}
 				break;
 			}
+			/* fall through */
 
-		default:  /* fall through */
+		default:
 			if (bc->hdlctx.calibrate <= 0)
 				return 0;
 			i = min_t(int, cnt, bc->hdlctx.calibrate);
-- 
2.22.0

