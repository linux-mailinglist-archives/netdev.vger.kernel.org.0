Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C30E233F6E
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 08:50:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731472AbgGaGuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 02:50:14 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:8866 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731365AbgGaGuO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 02:50:14 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 4481D2660323F7D3D8C8;
        Fri, 31 Jul 2020 14:50:08 +0800 (CST)
Received: from localhost (10.174.179.108) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.487.0; Fri, 31 Jul 2020
 14:50:01 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <steffen.klassert@secunet.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>, <kuba@kernel.org>,
        <lucien.xin@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH net-next] ip_vti: Fix unused variable warning
Date:   Fri, 31 Jul 2020 14:49:52 +0800
Message-ID: <20200731064952.36900-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.108]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If CONFIG_INET_XFRM_TUNNEL is set but CONFIG_IPV6 is n,

net/ipv4/ip_vti.c:493:27: warning: 'vti_ipip6_handler' defined but not used [-Wunused-variable]

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 net/ipv4/ip_vti.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/ip_vti.c b/net/ipv4/ip_vti.c
index 49daaed89764..f687abb069fa 100644
--- a/net/ipv4/ip_vti.c
+++ b/net/ipv4/ip_vti.c
@@ -490,6 +490,7 @@ static struct xfrm_tunnel vti_ipip_handler __read_mostly = {
 	.priority	=	0,
 };
 
+#if IS_ENABLED(CONFIG_IPV6)
 static struct xfrm_tunnel vti_ipip6_handler __read_mostly = {
 	.handler	=	vti_rcv_tunnel,
 	.cb_handler	=	vti_rcv_cb,
@@ -497,6 +498,7 @@ static struct xfrm_tunnel vti_ipip6_handler __read_mostly = {
 	.priority	=	0,
 };
 #endif
+#endif
 
 static int __net_init vti_init_net(struct net *net)
 {
-- 
2.17.1


