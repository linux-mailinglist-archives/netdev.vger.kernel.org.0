Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79EB04E3A5E
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 09:16:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbiCVISP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 04:18:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbiCVISH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 04:18:07 -0400
X-Greylist: delayed 1838 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 22 Mar 2022 01:16:38 PDT
Received: from mail-m965.mail.126.com (mail-m965.mail.126.com [123.126.96.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 947A752B3B;
        Tue, 22 Mar 2022 01:16:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=SN5WM
        GZNZQGwXdpNkm6YJj92Bkaye8WMwaev+X6OB10=; b=MSRQChtl1u1ymgLb+7dpt
        VgxkQw52yGC4V/pEf+MhnlIbY88PxjXuYhOJRRv4Cgx27xOXSQOIn0wwwLFta5s4
        6dDa8zXXfFgvpBAxEIwDw6Zc/557+Xa4cf+ck+XmHEtTciRQLuEbXWO8ubv2qrzp
        wD3IIEwXTv3t5rpzwMGEws=
Received: from localhost.localdomain (unknown [39.99.236.58])
        by smtp10 (Coremail) with SMTP id NuRpCgAXuUWhfjli60UTCw--.24849S2;
        Tue, 22 Mar 2022 15:45:40 +0800 (CST)
From:   hongbin wang <wh_bin@126.com>
To:     davem@davemloft.net
Cc:     yoshfuji@linux-ipv6.org, sahern@kernel.org, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] p6_tunnel: Remove duplicate assignments
Date:   Tue, 22 Mar 2022 15:45:25 +0800
Message-Id: <20220322074525.136560-1-wh_bin@126.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: NuRpCgAXuUWhfjli60UTCw--.24849S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73
        VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxU7eMKDUUUU
X-Originating-IP: [39.99.236.58]
X-CM-SenderInfo: xzkbuxbq6rjloofrz/1tbiGATLolpEGEM4QwAAsL
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_BL,RCVD_IN_MSPIKE_L4,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

there is a same action when the variable is initialized

Signed-off-by: hongbin wang <wh_bin@126.com>
---
 net/ipv6/ip6_tunnel.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 97ade833f58c..013e9998a45a 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -257,8 +257,6 @@ static int ip6_tnl_create2(struct net_device *dev)
 	struct ip6_tnl_net *ip6n = net_generic(net, ip6_tnl_net_id);
 	int err;
 
-	t = netdev_priv(dev);
-
 	dev->rtnl_link_ops = &ip6_link_ops;
 	err = register_netdevice(dev);
 	if (err < 0)
-- 
2.25.1

