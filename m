Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65D5E667A48
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 17:05:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234284AbjALQFT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 11:05:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232316AbjALQEz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 11:04:55 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14C2558D12;
        Thu, 12 Jan 2023 07:56:12 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id tz12so45850154ejc.9;
        Thu, 12 Jan 2023 07:56:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pDQZ8VZwl5KhjAItQfxHiU6aWmum35dmJVfQv+8C2E8=;
        b=KIkiQMQDsWJqtqoECLPbne0v0wW1pWL+l7x53ZS3nhj0+nyq3tfma+Wuu7F36FlSy4
         Hw1SnjNkfnspSkIo7eWtxOGMGMPhQf9A8HfEp4elCNdn1lmZRLHWppRnRocc+eRxPTFw
         i9G/sN1NmxO3dONdrtNrMOjGv0oGdMBxSp4EP5dKQJqvLc6QrN9mlOst7s8v8I2BRnEP
         xNtBP21W/dWArmI9/NeREtGxWFswhiyMcQAgn/81Habm0Iv3HCRhvgbvMNJQiaqZSrWN
         kfDGzwSZJp3WzwSyp/5HMLkNXwFUb1cL41NC7q2kC377tcstoC7bGXk/jv+ct/Jmt76S
         N60g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pDQZ8VZwl5KhjAItQfxHiU6aWmum35dmJVfQv+8C2E8=;
        b=PLzbLtpivuysxtm3QA1CMmjkPzCh7r2KDe8TZqrmGZ/d11OHmU+no3fJOTK14Yu8N/
         bQFxlBQjQASli4sFPGYiIWmuXyXumCEAdkgq/JoNkwCN0Hj4H+4DAtEkm10dmovZZvYF
         ukOyaMsYC/NlQ+rNeK4HdZ8cQBauS0AuFPJnajaN0GxDhu3+K8vvlhr4lK9FPl9CuIhp
         MD0T3jVyC7I43iiIescKQ5oQn7zj8YcFy3sDns23ZAV7WM1pKMr9reegmBY/pJ5iRLsZ
         8UvQ2uTPOvozQsHGfvsOQGmuApXTURkCCpGodmmkL75mu6EFc8QHBBNX7EXOguGwE1jy
         QjiA==
X-Gm-Message-State: AFqh2kptS1FnWF7mM3wJ9EnbHiK/NEQt+KfFFS0f+yyf77OOR7+HENpo
        nNkzOdfuLnyBNpMvaQXp3e8=
X-Google-Smtp-Source: AMrXdXtcXj/CoCVbXdVH+MgdQm67oQMAHqK0KedNvXi1zhVc6k+s50ZPdBsRa5075TN1J4E1LxFEBg==
X-Received: by 2002:a17:907:8b09:b0:7c1:bb5:5704 with SMTP id sz9-20020a1709078b0900b007c10bb55704mr69946814ejc.26.1673538970523;
        Thu, 12 Jan 2023 07:56:10 -0800 (PST)
Received: from gvm01 (net-5-89-66-224.cust.vodafonedsl.it. [5.89.66.224])
        by smtp.gmail.com with ESMTPSA id n12-20020a1709062bcc00b007ae38d837c5sm7650059ejg.174.2023.01.12.07.56.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 07:56:09 -0800 (PST)
Date:   Thu, 12 Jan 2023 16:56:11 +0100
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
Subject: [PATCH v2 net-next 1/1] plca.c: fix obvious mistake in checking
 retval
Message-ID: <df38c69a85bf528f3e6e672f00be4dc9cdd6298e.1673538908.git.piergiorgio.beruto@gmail.com>
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
meet the code. After additional review, it seems like if(ret < 0) was
actually the right thing to do. So this patch reverts those changes.

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

