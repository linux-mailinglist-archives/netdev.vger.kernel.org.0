Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DDEF3987B2
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 13:08:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231357AbhFBLJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 07:09:46 -0400
Received: from m15112.mail.126.com ([220.181.15.112]:50537 "EHLO
        m15112.mail.126.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbhFBLJp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 07:09:45 -0400
X-Greylist: delayed 1867 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Jun 2021 07:09:44 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=WwkpAIUENU38Gv1JRi
        PQTpNDBjAvk902pkO/FF2D7EU=; b=AKNp6PMr3DC/9JCqqlOw0phzhfpuxNg1fk
        Kd+EgYV0QT29hcu30jkzQNL7swy5HSCHmm5yYv/N7phC2L8BaPBXS/uaNkR5hyJC
        Sfq9L3NHDPz85XvuGc0Dhb+ST3v1Ql2UMsh89wodoImnJtDaCvIvUlTdwbt9rLrH
        lTvN0o8QY=
Received: from localhost.localdomain (unknown [114.250.195.27])
        by smtp2 (Coremail) with SMTP id DMmowAC3nEk7X7dgnXrgBw--.832S4;
        Wed, 02 Jun 2021 18:36:44 +0800 (CST)
From:   zhang kai <zhangkaiheb@126.com>
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     zhang kai <zhangkaiheb@126.com>
Subject: [PATCH] sit: set name of device back to struct parms
Date:   Wed,  2 Jun 2021 18:36:26 +0800
Message-Id: <20210602103626.26873-1-zhangkaiheb@126.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: DMmowAC3nEk7X7dgnXrgBw--.832S4
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
        VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxUb5l1DUUUU
X-Originating-IP: [114.250.195.27]
X-CM-SenderInfo: x2kd0wxndlxvbe6rjloofrz/1tbiFxyl-lpEBcQ+7gAAsf
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

addrconf_set_sit_dstaddr will use parms->name.

Signed-off-by: zhang kai <zhangkaiheb@126.com>
---
 net/ipv6/sit.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 71b57bdb1..e0a39b0bb 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -271,6 +271,9 @@ static struct ip_tunnel *ipip6_tunnel_locate(struct net *net,
 	if (ipip6_tunnel_create(dev) < 0)
 		goto failed_free;
 
+	if (!parms->name[0])
+		strcpy(parms->name, dev->name);
+
 	return nt;
 
 failed_free:
-- 
2.17.1

