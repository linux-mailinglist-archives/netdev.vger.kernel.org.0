Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA6E245860
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 17:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729190AbgHPPZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Aug 2020 11:25:45 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55206 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728346AbgHPPZl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 16 Aug 2020 11:25:41 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k7KXT-009aYe-TB; Sun, 16 Aug 2020 17:25:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH ethtool] cable-test: TDR Amplitude is signed
Date:   Sun, 16 Aug 2020 17:25:08 +0200
Message-Id: <20200816152508.2285431-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the signed JSON helper for printing the TDR amplitude. Otherwise
negative values, i.e. cable shorts, become very large positive values.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 netlink/cable_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/netlink/cable_test.c b/netlink/cable_test.c
index d39b7d8..8a71453 100644
--- a/netlink/cable_test.c
+++ b/netlink/cable_test.c
@@ -354,7 +354,7 @@ static int nl_cable_test_tdr_ntf_attr(struct nlattr *evattr)
 
 		open_json_object(NULL);
 		print_string(PRINT_ANY, "pair", "%s ", nl_pair2txt(pair));
-		print_uint(PRINT_ANY, "amplitude", "Amplitude %4d\n", mV);
+		print_int(PRINT_ANY, "amplitude", "Amplitude %4d\n", mV);
 		close_json_object();
 		break;
 	}
-- 
2.27.0

