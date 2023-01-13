Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BC6D6698A2
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 14:34:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241716AbjAMNe2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 08:34:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241855AbjAMNdf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 08:33:35 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFE585D6B9;
        Fri, 13 Jan 2023 05:26:40 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id ss4so45052440ejb.11;
        Fri, 13 Jan 2023 05:26:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yp6uv5Fh7h8BQa8qt2GS5w6smCQU5e2VSr/x8Q9YfvE=;
        b=ii596FfO+j0K+Dy6HVm/KD7JigQ7QzO5khKfNwp8UydDZX5et7C5USxvSlSbBde6Sv
         WzZUqGFE2ZbPVLRVDYBBxAzv8948v2v6/84yIdvVXPR77QlXUR0zZV7w2dDXA2IaczSe
         fYbauv9aJJjrjWuR5fgW15eXdam/U0z1oAP8fwuU08+dm73f7NoeuByn8X4HRqac4L08
         wNWlloInPUnWnpdtBgEsJEM6ACKwC82oTs6z9bOOrTTWT6MS444YgOFJ+4wNXoDOxHj/
         QyvYA1UIYEUGyIuY89mP61ieyMHjs9VVqSoeByaUWMRC+9K7+iLcgtdkAKSdmG5AoIAj
         uQ5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yp6uv5Fh7h8BQa8qt2GS5w6smCQU5e2VSr/x8Q9YfvE=;
        b=ZMk6wgEF1qEpZCHtb72Vh/JMvXSjlGo5DNCxqppQ76hnkNTpWx7URgATN/702bjLVM
         vIueUJnrF9joy25OmBshZ/0eiqkIgAta0strAz6+es4M/PvWHsYds+2BGJdUENbr0xg5
         nUBtyH4OYdfSsq7dzU43h11AoRWXDCgwXgLJAD0jC+RxuKURhPSxRMmMdOJ23aBGb5J/
         jxoIXFbbj7p2q5jwWqB5Kv7gX1NBobooKKTH3Gw00eYZG3KezyMJ0yUqDfnry/hnLQe2
         IUgVAqxywKqAyLBa4PJFzpxKBesbFzcWZqdaEXYP+M0zW6G9M1/A+1AR8X/9tHOAP3s8
         gSCA==
X-Gm-Message-State: AFqh2krkvAqzOPe7e6bHSQNDo9yJyS4tpP/T2f6wWVhmH05Xy3j8t/08
        rsHkW08mTP1AuT9g9ay4mJk=
X-Google-Smtp-Source: AMrXdXt2pmH2TiFRrfTNJAGFePZqFtv88U1sNedtV8TqhHuAZJ5v5JpqI9eONCj0x1NXAqQdjcLRew==
X-Received: by 2002:a17:907:cbc8:b0:84d:428f:be90 with SMTP id vk8-20020a170907cbc800b0084d428fbe90mr3487954ejc.42.1673616399398;
        Fri, 13 Jan 2023 05:26:39 -0800 (PST)
Received: from gvm01 (net-5-89-66-224.cust.vodafonedsl.it. [5.89.66.224])
        by smtp.gmail.com with ESMTPSA id c23-20020a170906155700b007a9c3831409sm8510938ejd.137.2023.01.13.05.26.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 05:26:38 -0800 (PST)
Date:   Fri, 13 Jan 2023 14:26:35 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        mailhol.vincent@wanadoo.fr, sudheer.mogilappagari@intel.com,
        sbhatta@marvell.com, linux-doc@vger.kernel.org,
        wangjie125@huawei.com, corbet@lwn.net, lkp@intel.com,
        gal@nvidia.com, gustavoars@kernel.org, bagasdotme@gmail.com
Subject: [PATCH v3 net-next 1/1] plca.c: fix obvious mistake in checking
 retval
Message-ID: <f2277af8951a51cfee2fb905af8d7a812b7beaf4.1673616357.git.piergiorgio.beruto@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Revert a wrong fix that was done during the review process. The
intention was to substitute "if(ret < 0)" with "if(ret)".
Unfortunately, the intended fix did not meet the code.
Besides, after additional review, it was decided that "if(ret < 0)"
was actually the right thing to do.

Fixes: 8580e16c28f3 ("net/ethtool: add netlink interface for the PLCA RS")
Signed-off-by: Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 net/ethtool/plca.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/ethtool/plca.c b/net/ethtool/plca.c
index d9bb13ffc654..be7404dc9ef2 100644
--- a/net/ethtool/plca.c
+++ b/net/ethtool/plca.c
@@ -61,7 +61,7 @@ static int plca_get_cfg_prepare_data(const struct ethnl_req_info *req_base,
 	}
 
 	ret = ethnl_ops_begin(dev);
-	if (!ret)
+	if (ret < 0)
 		goto out;
 
 	memset(&data->plca_cfg, 0xff,
@@ -151,7 +151,7 @@ int ethnl_set_plca_cfg(struct sk_buff *skb, struct genl_info *info)
 					 tb[ETHTOOL_A_PLCA_HEADER],
 					 genl_info_net(info), info->extack,
 					 true);
-	if (!ret)
+	if (ret < 0)
 		return ret;
 
 	dev = req_info.dev;
@@ -171,7 +171,7 @@ int ethnl_set_plca_cfg(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	ret = ethnl_ops_begin(dev);
-	if (!ret)
+	if (ret < 0)
 		goto out_rtnl;
 
 	memset(&plca_cfg, 0xff, sizeof(plca_cfg));
@@ -189,7 +189,7 @@ int ethnl_set_plca_cfg(struct sk_buff *skb, struct genl_info *info)
 		goto out_ops;
 
 	ret = ops->set_plca_cfg(dev->phydev, &plca_cfg, info->extack);
-	if (!ret)
+	if (ret < 0)
 		goto out_ops;
 
 	ethtool_notify(dev, ETHTOOL_MSG_PLCA_NTF, NULL);
@@ -233,7 +233,7 @@ static int plca_get_status_prepare_data(const struct ethnl_req_info *req_base,
 	}
 
 	ret = ethnl_ops_begin(dev);
-	if (!ret)
+	if (ret < 0)
 		goto out;
 
 	memset(&data->plca_st, 0xff,
-- 
2.37.4

