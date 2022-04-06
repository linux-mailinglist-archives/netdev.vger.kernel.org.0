Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0682B4F5D54
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 14:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232286AbiDFMJF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 08:09:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232339AbiDFMI0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 08:08:26 -0400
X-Greylist: delayed 1873 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 05 Apr 2022 19:38:46 PDT
Received: from m15113.mail.126.com (m15113.mail.126.com [220.181.15.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A4AFB1A394C
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 19:38:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=cBzQY
        bALC2Ft4VBebUDpTOM6eZy0ea20UFYYZFAlbxg=; b=Ue82tJbY8gIXtkv7iVep0
        E2NOmACflFjlZXfTmk8SeiJDQnpOuN4f4JCdhhXFdgaSlJDHg4sgrbAS8qCWRF4s
        eeM+qiYHZHZxSckG7kBLk+9Mgf52YZHH1OvaJvz+8JNnCZS037AbSb2Is6IQX7Fk
        RzV8bnQr+dgsS4ydUQcRWo=
Received: from localhost.localdomain (unknown [39.99.236.58])
        by smtp3 (Coremail) with SMTP id DcmowAAXHV229Uxi5SFMAQ--.31622S2;
        Wed, 06 Apr 2022 10:06:46 +0800 (CST)
From:   Hongbin Wang <wh_bin@126.com>
To:     davem@davemloft.net
Cc:     yoshfuji@linux-ipv6.org, sahern@kernel.org, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ip6_tunnel: Remove duplicate assignments
Date:   Tue,  5 Apr 2022 22:06:34 -0400
Message-Id: <20220406020634.72995-1-wh_bin@126.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DcmowAAXHV229Uxi5SFMAQ--.31622S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73
        VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxU7nNVDUUUU
X-Originating-IP: [39.99.236.58]
X-CM-SenderInfo: xzkbuxbq6rjloofrz/1tbiGBbaolpEGNmrIwAAsh
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a same action when the variable is initialized

Signed-off-by: Hongbin Wang <wh_bin@126.com>
---
 net/ipv6/ip6_tunnel.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 53f632a560ec..19325b7600bb 100644
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

