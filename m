Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E66B397EF4
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 04:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231329AbhFBCYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 22:24:42 -0400
Received: from mail-m965.mail.126.com ([123.126.96.5]:45418 "EHLO
        mail-m965.mail.126.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231213AbhFBCYY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 22:24:24 -0400
X-Greylist: delayed 1869 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Jun 2021 22:24:22 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=80pSLhRf/8rCSlUCNF
        1s13qJD4oXhHRlLvBUXDmnQuI=; b=JLPHaUS2FRVO2BRw4boZvFBBrbQSESpwul
        mdAeDOMcC91cEXXPeSiPLaudyumfAwL0OyVj+mrUlmbBxYBdjc1HaCu7jZZsha7P
        mHlhcgdftNpPQckiyw2f7PeXb7dpf24wogTRRLvAYvxpkMhu6RNHSKKeYmSiLFXy
        EucIjb6PI=
Received: from localhost.localdomain (unknown [114.250.195.27])
        by smtp10 (Coremail) with SMTP id NuRpCgBX164X5LZgFIUhpQ--.28277S4;
        Wed, 02 Jun 2021 09:51:21 +0800 (CST)
From:   zhang kai <zhangkaiheb@126.com>
To:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     zhang kai <zhangkaiheb@126.com>
Subject: [PATCH] sit: replace 68 with micro IPV4_MIN_MTU
Date:   Wed,  2 Jun 2021 09:50:39 +0800
Message-Id: <20210602015039.26559-1-zhangkaiheb@126.com>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: NuRpCgBX164X5LZgFIUhpQ--.28277S4
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
        VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvj4RXrcSUUUUU
X-Originating-IP: [114.250.195.27]
X-CM-SenderInfo: x2kd0wxndlxvbe6rjloofrz/1tbi8xml-lpc6j3IXwAAs3
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use meaningfull micro IPV4_MIN_MTU

Signed-off-by: zhang kai <zhangkaiheb@126.com>
---
 net/ipv6/sit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index aa98294a3..71b57bdb1 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -970,7 +970,7 @@ static netdev_tx_t ipip6_tunnel_xmit(struct sk_buff *skb,
 	if (df) {
 		mtu = dst_mtu(&rt->dst) - t_hlen;
 
-		if (mtu < 68) {
+		if (mtu < IPV4_MIN_MTU) {
 			dev->stats.collisions++;
 			ip_rt_put(rt);
 			goto tx_error;
-- 
2.17.1

