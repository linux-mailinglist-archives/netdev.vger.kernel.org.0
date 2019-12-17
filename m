Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADE9B122A3A
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 12:36:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727451AbfLQLg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 06:36:56 -0500
Received: from imap2.colo.codethink.co.uk ([78.40.148.184]:35360 "EHLO
        imap2.colo.codethink.co.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726560AbfLQLgz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 06:36:55 -0500
X-Greylist: delayed 966 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Dec 2019 06:36:54 EST
Received: from [167.98.27.226] (helo=rainbowdash.codethink.co.uk)
        by imap2.colo.codethink.co.uk with esmtpsa  (Exim 4.92 #3 (Debian))
        id 1ihAuB-0004YP-Pn; Tue, 17 Dec 2019 11:20:43 +0000
Received: from ben by rainbowdash.codethink.co.uk with local (Exim 4.92.3)
        (envelope-from <ben@rainbowdash.codethink.co.uk>)
        id 1ihAuB-008gM1-AW; Tue, 17 Dec 2019 11:20:43 +0000
From:   "Ben Dooks (Codethink)" <ben.dooks@codethink.co.uk>
To:     ben.dooks@codethink.co.uk
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH] net: dsa: make unexported dsa_link_touch() static
Date:   Tue, 17 Dec 2019 11:20:38 +0000
Message-Id: <20191217112038.2069386-1-ben.dooks@codethink.co.uk>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

dsa_link_touch() is not exported, or defined outside of the
file it is in so make it static to avoid the following warning:

net/dsa/dsa2.c:127:17: warning: symbol 'dsa_link_touch' was not declared. Should it be static?

Signed-off-by: Ben Dooks (Codethink) <ben.dooks@codethink.co.uk>
---
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Vivien Didelot <vivien.didelot@gmail.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
---
 net/dsa/dsa2.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 9ef2caa13f27..c66abbed4daf 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -124,7 +124,8 @@ static struct dsa_port *dsa_tree_find_port_by_node(struct dsa_switch_tree *dst,
 	return NULL;
 }
 
-struct dsa_link *dsa_link_touch(struct dsa_port *dp, struct dsa_port *link_dp)
+static struct dsa_link *dsa_link_touch(struct dsa_port *dp,
+				       struct dsa_port *link_dp)
 {
 	struct dsa_switch *ds = dp->ds;
 	struct dsa_switch_tree *dst;
-- 
2.24.0

