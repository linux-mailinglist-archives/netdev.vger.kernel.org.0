Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2229686162
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 09:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbjBAIO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 03:14:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231817AbjBAIOy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 03:14:54 -0500
Received: from unicom146.biz-email.net (unicom146.biz-email.net [210.51.26.146])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FDD14A1C4;
        Wed,  1 Feb 2023 00:14:52 -0800 (PST)
Received: from ([60.208.111.195])
        by unicom146.biz-email.net ((D)) with ASMTP (SSL) id XCQ00146;
        Wed, 01 Feb 2023 16:14:46 +0800
Received: from localhost.localdomain (10.200.104.97) by
 jtjnmail201607.home.langchao.com (10.100.2.7) with Microsoft SMTP Server id
 15.1.2507.16; Wed, 1 Feb 2023 16:14:47 +0800
From:   Bo Liu <liubo03@inspur.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <olteanv@gmail.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Bo Liu <liubo03@inspur.com>
Subject: [PATCH] net: dsa: Use sysfs_emit() to instead of sprintf()
Date:   Wed, 1 Feb 2023 03:14:38 -0500
Message-ID: <20230201081438.3151-1-liubo03@inspur.com>
X-Mailer: git-send-email 2.18.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.200.104.97]
tUid:   20232011614466310a5e9a06ae6a434aa35a611ad0e17
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Follow the advice of the Documentation/filesystems/sysfs.rst and show()
should only use sysfs_emit() or sysfs_emit_at() when formatting the
value to be returned to user space.

Signed-off-by: Bo Liu <liubo03@inspur.com>
---
 net/dsa/master.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/master.c b/net/dsa/master.c
index 26d90140d271..dcbd88fe4281 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -299,7 +299,7 @@ static ssize_t tagging_show(struct device *d, struct device_attribute *attr,
 	struct net_device *dev = to_net_dev(d);
 	struct dsa_port *cpu_dp = dev->dsa_ptr;
 
-	return sprintf(buf, "%s\n",
+	return sysfs_emit(buf, "%s\n",
 		       dsa_tag_protocol_to_str(cpu_dp->tag_ops));
 }
 
-- 
2.27.0

