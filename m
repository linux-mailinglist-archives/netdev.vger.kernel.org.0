Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 555E25A267F
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 13:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245675AbiHZLFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 07:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243036AbiHZLEe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 07:04:34 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 613651A821
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 04:04:14 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id gb36so2444888ejc.10
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 04:04:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=GQ+MAoXqsWmo7jz2wvL1XauaPa7NECFee15tdvLHbmk=;
        b=38zU9NQ0O9gPiOdynqHP8Tk97fiNSVd8W0c9Omd/huRqGYc5kWdgIpcRaxhp7CLUYE
         l5G5vdP7+4lrL4QisF6veTtglEHSFC4pI2w37VtqYUdZoyeDm9H1tVMhm8Q654etoOEs
         HhU0K0ZbWy5dh94b09731LW5R02XheAH0hukH54N2KpHjOqrX7B9cT3Jri8YixFPo89b
         UQnXb1Aw61mC4uYFixkq1qgYB9fXOY6b8/UozBCTQMbRkjxfW+ukxpYHM12+2KkdJZI7
         jCjcgTAmX6jCkPUbZeF7J63KTJ8D6f9B+mSx1Vmp0Efm09MdH6Q+8Sk+mhRcMghlhpCF
         gbWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=GQ+MAoXqsWmo7jz2wvL1XauaPa7NECFee15tdvLHbmk=;
        b=zFCHUCag4tXncJZ/VozQzeCyNvS4wvy8dAjvBPFDHf5p8s1O9/fFNr7agS+8w0qZkY
         v0AsRNdhY6isnjX+/yVpUGShBk6RyIwkjLFTi3x587ntAfRWtQOKBTquhXyZApCaRwLe
         r+cpDREWTfcXSiKjVVJV7exUsB0LWKLyxzFk0Y3NGEN8WdTltBzd1HDfjwmeJhYnHN4G
         ZZZ72apPfo5RXBzb8BYjdXlpJ3J311/Yhe6KeiFT8Qbm3uvDACmfqWnLzdxp6VMjMnMB
         h7Z+MolRhDc9x03Lz4kxlidH+7Wbv3q2i0n13sRhDQaS2SRNKl1+JiJFHNp85gqtdbg8
         bdxQ==
X-Gm-Message-State: ACgBeo0k+ggOeSr+IEn+xpQZebEhRveni7H/l0Xhxyu72DHBWni1Gmrb
        XVvkSjlv2k2yghLRDNanluJMOM07CJkNS1bV
X-Google-Smtp-Source: AA6agR4FQwJ32XdBZud1rt1/RW5p7TT5Zlk88ze8P4esrLejjI5flJTyXKwntfcvPyfzhS96KDWi3g==
X-Received: by 2002:a17:907:94c2:b0:73d:c534:1ac0 with SMTP id dn2-20020a17090794c200b0073dc5341ac0mr5222985ejc.461.1661511852980;
        Fri, 26 Aug 2022 04:04:12 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id 21-20020a170906319500b007402796f065sm529612ejy.132.2022.08.26.04.04.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Aug 2022 04:04:12 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, dmichail@fungible.com
Subject: [patch net-next] funeth: remove pointless check of devlink pointer in create/destroy_netdev() flows
Date:   Fri, 26 Aug 2022 13:04:11 +0200
Message-Id: <20220826110411.1409446-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Once devlink port is successfully registered, the devlink pointer is not
NULL. Therefore, the check is going to be always true and therefore
pointless. Remove it.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/ethernet/fungible/funeth/funeth_main.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/fungible/funeth/funeth_main.c b/drivers/net/ethernet/fungible/funeth/funeth_main.c
index f247b7ad3a88..b6de2ad82a32 100644
--- a/drivers/net/ethernet/fungible/funeth/funeth_main.c
+++ b/drivers/net/ethernet/fungible/funeth/funeth_main.c
@@ -1802,16 +1802,14 @@ static int fun_create_netdev(struct fun_ethdev *ed, unsigned int portid)
 	if (rc)
 		goto unreg_devlink;
 
-	if (fp->dl_port.devlink)
-		devlink_port_type_eth_set(&fp->dl_port, netdev);
+	devlink_port_type_eth_set(&fp->dl_port, netdev);
 
 	return 0;
 
 unreg_devlink:
 	ed->netdevs[portid] = NULL;
 	fun_ktls_cleanup(fp);
-	if (fp->dl_port.devlink)
-		devlink_port_unregister(&fp->dl_port);
+	devlink_port_unregister(&fp->dl_port);
 free_stats:
 	fun_free_stats_area(fp);
 free_rss:
@@ -1830,10 +1828,8 @@ static void fun_destroy_netdev(struct net_device *netdev)
 	struct funeth_priv *fp;
 
 	fp = netdev_priv(netdev);
-	if (fp->dl_port.devlink) {
-		devlink_port_type_clear(&fp->dl_port);
-		devlink_port_unregister(&fp->dl_port);
-	}
+	devlink_port_type_clear(&fp->dl_port);
+	devlink_port_unregister(&fp->dl_port);
 	unregister_netdev(netdev);
 	fun_ktls_cleanup(fp);
 	fun_free_stats_area(fp);
-- 
2.37.1

