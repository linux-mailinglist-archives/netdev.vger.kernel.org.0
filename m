Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3A06661FE
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 18:33:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232010AbjAKRdl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 12:33:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234534AbjAKRdH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 12:33:07 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E0383BEAF;
        Wed, 11 Jan 2023 09:30:50 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id bk16so15780604wrb.11;
        Wed, 11 Jan 2023 09:30:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5lCIjpl82CzyQ9DLJqGOFekdFTPfE3rqk93pI2+6RCg=;
        b=JFyHpTmjV2ktsBTtUkSir6897ZzIzbH3VAXvtwP9WqkZnYp5yoTNK1yBLuGnLEBJRA
         2APxeY+bhqa1LA4OTc16nCD6094SFKlQrHIbFK1gG02xlpsb0dmu71qzCzVwd7FPz2rV
         DSlslvordNvtjdnq3PvQ8GX/sMy1kAKig8NA/PnubDWOMoq6Eo/TJq0Vq6X2kqiB5kS0
         8xgHhzp37TA0aPyYLJkpzaunmvi6HdWz8FUuKMQstKi4VDtMS3aufC10rhuqDKFn7FNF
         h3+K5gBtpyAcTfNiVv9LGll6I8uaOFBwvfXBNpJY++G8Ir9i6DtJrbfU3yd09JbMCLtO
         /8aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5lCIjpl82CzyQ9DLJqGOFekdFTPfE3rqk93pI2+6RCg=;
        b=JoO0HtagURHOI69VSO4D6x8DK2cGARwW/8VFzEGXMmEndGNaIDF2AVMLstRhbs5L8o
         KLecKhm7sQf/VdQ4rBxAhqrEwRBYZ7Kj/C2YeJuDPiSMCKOXRqSBSI8swUh5XG4r9xKp
         56UOlWLaPndlAa+n2y9TC4mbG1Cyp9r9oLNzGFQdDuNMiOOc6iQ+LGP/xK8YxQg05jI1
         RA+zm198X6dbLwBzoo47ayOMf5hnkZkdGGbMzzXiH9A1sBcKyTP0qR9VG4jRPERJrI2+
         zC/nx24HargI4tHSDAIp+QfLsnrEbJiWKsqaOGLfaIlLr1m+XzMTL0JLGUmdtHVVk1CH
         ksHg==
X-Gm-Message-State: AFqh2kqQUcv6tlxMlyS1shS03ai98YWPgT2iamV8us8T+JZdxTZQBjDB
        on2cDBcGu2NwsM9cCdmSr/4=
X-Google-Smtp-Source: AMrXdXun2J/AW4CSFGRbivSq0G71AzxC/TGQBBB4ZiIgIXV4l5eloWq19fsRpdy0fB7z6keUnKb91g==
X-Received: by 2002:a05:6000:501:b0:26b:8177:a5e6 with SMTP id a1-20020a056000050100b0026b8177a5e6mr43766013wrf.51.1673458249265;
        Wed, 11 Jan 2023 09:30:49 -0800 (PST)
Received: from gvm01 (net-5-89-66-224.cust.vodafonedsl.it. [5.89.66.224])
        by smtp.gmail.com with ESMTPSA id u5-20020adfdb85000000b002ba2646fd30sm16850827wri.36.2023.01.11.09.30.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 09:30:48 -0800 (PST)
Date:   Wed, 11 Jan 2023 18:30:48 +0100
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
Subject: [PATCH net-next 1/1] plca.c: fix obvious mistake in checking retval
Message-ID: <f6b7050dcfb07714fb3abdb89829a3820e6a555c.1673458121.git.piergiorgio.beruto@gmail.com>
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

This patch addresses a wrong fix that was done during the review
process. The intention was to substitute "if(ret < 0)" with
"if(ret)". Unfortunately, in this specific file the intended fix did not
meet the code.

Signed-off-by: Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
---
 net/ethtool/plca.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/ethtool/plca.c b/net/ethtool/plca.c
index d9bb13ffc654..9c7d29186b4e 100644
--- a/net/ethtool/plca.c
+++ b/net/ethtool/plca.c
@@ -61,7 +61,7 @@ static int plca_get_cfg_prepare_data(const struct ethnl_req_info *req_base,
 	}
 
 	ret = ethnl_ops_begin(dev);
-	if (!ret)
+	if (ret)
 		goto out;
 
 	memset(&data->plca_cfg, 0xff,
@@ -151,7 +151,7 @@ int ethnl_set_plca_cfg(struct sk_buff *skb, struct genl_info *info)
 					 tb[ETHTOOL_A_PLCA_HEADER],
 					 genl_info_net(info), info->extack,
 					 true);
-	if (!ret)
+	if (ret)
 		return ret;
 
 	dev = req_info.dev;
@@ -171,7 +171,7 @@ int ethnl_set_plca_cfg(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	ret = ethnl_ops_begin(dev);
-	if (!ret)
+	if (ret)
 		goto out_rtnl;
 
 	memset(&plca_cfg, 0xff, sizeof(plca_cfg));
@@ -189,7 +189,7 @@ int ethnl_set_plca_cfg(struct sk_buff *skb, struct genl_info *info)
 		goto out_ops;
 
 	ret = ops->set_plca_cfg(dev->phydev, &plca_cfg, info->extack);
-	if (!ret)
+	if (ret)
 		goto out_ops;
 
 	ethtool_notify(dev, ETHTOOL_MSG_PLCA_NTF, NULL);
@@ -233,7 +233,7 @@ static int plca_get_status_prepare_data(const struct ethnl_req_info *req_base,
 	}
 
 	ret = ethnl_ops_begin(dev);
-	if (!ret)
+	if (ret)
 		goto out;
 
 	memset(&data->plca_st, 0xff,
-- 
2.37.4

