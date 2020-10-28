Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4F9A29DBCB
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 01:13:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390841AbgJ2ANs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 20:13:48 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50784 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390834AbgJ2ANr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 20:13:47 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kXZEu-003th5-1u; Wed, 28 Oct 2020 01:22:56 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 2/2] net: rose: Escape trigraph to fix warning with W=1
Date:   Wed, 28 Oct 2020 01:22:35 +0100
Message-Id: <20201028002235.928999-3-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201028002235.928999-1-andrew@lunn.ch>
References: <20201028002235.928999-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

net/rose/af_rose.c: In function ‘rose_info_show’:
net/rose/af_rose.c:1413:20: warning: trigraph ??- ignored, use -trigraphs to enable [-Wtrigraphs]
 1413 |    callsign = "??????-?";

??- is a trigraph, and should be replaced by a ˜ by the
compiler. However, trigraphs are being ignored in the build. Fix the
warning by escaping the ?? prefix of a trigraph.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 net/rose/af_rose.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index cf7d974e0f61..2c297834d268 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -1410,7 +1410,7 @@ static int rose_info_show(struct seq_file *seq, void *v)
 			   ax2asc(buf, &rose->dest_call));
 
 		if (ax25cmp(&rose->source_call, &null_ax25_address) == 0)
-			callsign = "??????-?";
+			callsign = "????\?\?-?";
 		else
 			callsign = ax2asc(buf, &rose->source_call);
 
-- 
2.28.0

