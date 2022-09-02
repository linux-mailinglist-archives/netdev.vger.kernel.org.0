Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC8575AA8D2
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 09:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235259AbiIBHhg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 03:37:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233218AbiIBHhe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 03:37:34 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A32D73936;
        Fri,  2 Sep 2022 00:37:33 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id l65so1099931pfl.8;
        Fri, 02 Sep 2022 00:37:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=SUpu6LE3Bg1N7sM9B4FOf+h9/LVY6PqSU+bwKRQ0w90=;
        b=HUTjs1pkKOMO9HiNmZRNq0ZWGNuOat/h1TmqrfLtlyWhL6h+fikdz6CdTQWOyK8reX
         yfIRKADSqRrU/H9u3XON+IhtzSTXKeTqqY2fjqyiqvg9g+EPURIJSsIq5fTwHymmapAt
         LQDvGPyRyzYTgxScNKjLl+80lZ/JFaIwlqe6C4aMJQg9bho6A+Y0osIs59notUHacSy8
         lQl9D0zLHHgL80WmSnNqijg/7zjotcbziOskOYnGlXzAsP2Wo2cR7RilsY2HGyWfm5ph
         L7bf4MkVcgR2L4Z1mRNYXPE5EAONynVeCJ5B5MgkGhA6aFcrHtp/b7a7V1uOBuBsvmA2
         2wJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=SUpu6LE3Bg1N7sM9B4FOf+h9/LVY6PqSU+bwKRQ0w90=;
        b=zXNAWvh7xTuFTF9u6yY3sBj2fuScHVAKFuJYSP9luX+498sbvUjwQXZGixZRpFy7aE
         U5P46D6sRVT/TVjwqFfK6omjn4noZr2LfKRc/2Gxhh6jc8t+uxM+xFmi6M/qsmv1YQY2
         LyCyLNE5wkuveo89z5ldSDcEjr61IF9gBN/SBLNFWfLN4PxSrHdWLCUnkmN8EtBynvVX
         g5xtB57/x5Oy5sIjWNx/ik4c73AapTnoch1lFZEtNujaYrDIYwvKIhKOzGnSMwnQ9pIJ
         Eb3BfS0z5Bs0inIkC4HlVNt0+6SZoX4ljeBglJe3wgQXxbdHaJ0bmziOJXEzFMnYrndW
         O4wA==
X-Gm-Message-State: ACgBeo3Ai4IMa69j7aF4opXMjRPxHUMQPz+MwWGmgwPuSQoEMOm3bP5d
        E3VkzI9qZrdJDpQ0Usc6Z2PTpsst/Y8=
X-Google-Smtp-Source: AA6agR5/tXJBEmsdkgToFTmjPmHUsp/dvq5yBzTMQr6MrvRZDCpTpntr/t05Wcfx+NcnFLfwSuWE2Q==
X-Received: by 2002:a63:fe12:0:b0:42a:e57:7464 with SMTP id p18-20020a63fe12000000b0042a0e577464mr29836274pgh.552.1662104252627;
        Fri, 02 Sep 2022 00:37:32 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id l64-20020a639143000000b0042b435c6526sm729221pge.79.2022.09.02.00.37.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Sep 2022 00:37:32 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: zhang.songyi@zte.com.cn
To:     steffen.klassert@secunet.com
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        zhang songyi <zhang.songyi@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH linux-next] xfrm: Remove the unneeded result variable
Date:   Fri,  2 Sep 2022 07:37:17 +0000
Message-Id: <20220902073717.319844-1-zhang.songyi@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: zhang songyi <zhang.songyi@zte.com.cn>

Return the xfrmi_create() directly instead of storing it in another
redundant variable.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: zhang songyi <zhang.songyi@zte.com.cn>
---
 net/xfrm/xfrm_interface.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index 5a67b120c4db..5508dc11ce42 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -774,7 +774,6 @@ static int xfrmi_newlink(struct net *src_net, struct net_device *dev,
 	struct net *net = dev_net(dev);
 	struct xfrm_if_parms p = {};
 	struct xfrm_if *xi;
-	int err;
 
 	xfrmi_netlink_parms(data, &p);
 	if (p.collect_md) {
@@ -804,8 +803,7 @@ static int xfrmi_newlink(struct net *src_net, struct net_device *dev,
 	xi->net = net;
 	xi->dev = dev;
 
-	err = xfrmi_create(dev);
-	return err;
+	return xfrmi_create(dev);
 }
 
 static void xfrmi_dellink(struct net_device *dev, struct list_head *head)
-- 
2.25.1


