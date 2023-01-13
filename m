Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A176E669D5C
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 17:14:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbjAMQOa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 11:14:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbjAMQN7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 11:13:59 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA4F284099
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 08:08:28 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id v6so31724633edd.6
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 08:08:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YEF7eXj3deew0ogA405Uccif1PCmAlxQbHICu3eWrL4=;
        b=bLK2CZQxfJhiQECYCWvXo/FmJiZ0OlkW/wrkBwRXrx8h8fc4IERAVQABu/6Zc9Vxy7
         bv0ydeALFD4v6APcOBDmZqTsl/gTTeJcXsw32BQ3Rw7x0QupkVMXZ/T1s1YadvkfKR0x
         faYcaHSuUzY5Y8lNptKaRA+m9dkv8kdcoBv0pKZrrSerPACh8W7ExJdPLudKcD++fPN+
         5JJGhAvM3Bem3YgOd+NhKciFsllgeh3j0Zm6ijsh2BjYDRWORVfSHzfOLjv4rqkSeJhD
         XI6xueF/vLt5eLX+lUgqLrr8C1prtquD0f/b/tyRhrGAUgeqiy+Bomw5qbJlYhgfXWxU
         kA4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YEF7eXj3deew0ogA405Uccif1PCmAlxQbHICu3eWrL4=;
        b=R17xYhpMbsoYoRTkLfPFOCfM1+4n563ZmcH3HgL2HK2v7Jw2VvIW55TASdfxC7P1ZJ
         tfIvhg3TJI33k+5IUVckFKaWcD9le56EAXbQD9lJD+lMksh/I6F2O/PbGygt6QqtRoME
         CYXY5VZyKI8PnfoGu9Qmd+/zNlV5ZFxaREMkDSWDnFsbveQpD1ur1UahR4hPQ7x636Dh
         KSHMmU/lvkkYsX8py3vueVCSEdyvyP3cF8F71AjKpfn6j4yAWMS9XvV2pRa4D6UeT0so
         9EaxqWh6wQqL3RM06mPe2hUA1RhX5Uen91906/YZyD4/pPKt+CmXJ8BFOfZGO97RUV7D
         e29g==
X-Gm-Message-State: AFqh2krR1bDxINzH/PCd9q6d6stPYuMLrUbTc4c3AvFKRZY04BuqYSZT
        li6HBlDBRPX8nw/XgTZdzV7i+qMXfkMeSUot0rI=
X-Google-Smtp-Source: AMrXdXvxN84qFp72Jg2vGKrkhdS7ojVf4BZdYvSggv7jrZhWMWhdt/yyp2OOR+GSRbrehu6Dv6vruQ==
X-Received: by 2002:a05:6402:4518:b0:45c:835c:eab7 with SMTP id ez24-20020a056402451800b0045c835ceab7mr66112238edb.37.1673626107318;
        Fri, 13 Jan 2023 08:08:27 -0800 (PST)
Received: from gvm01 ([91.199.164.40])
        by smtp.gmail.com with ESMTPSA id ez6-20020a056402450600b0048ebe118a46sm8279811edb.77.2023.01.13.08.08.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 08:08:26 -0800 (PST)
Date:   Fri, 13 Jan 2023 17:08:24 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Dan Carpenter <error27@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [bug report] net/ethtool: add netlink interface for the PLCA RS
Message-ID: <Y8GB+Fu6zvLCcUyr@gvm01>
References: <Y8F+9UmSubFpBsYo@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8F+9UmSubFpBsYo@kili>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Dan,
thank you very much for your review.

I have already submitted a patch to fix that. PLease, see
https://patchwork.kernel.org/project/netdevbpf/patch/f2277af8951a51cfee2fb905af8d7a812b7beaf4.1673616357.git.piergiorgio.beruto@gmail.com/

Thanks,
Piergiorgio

On Fri, Jan 13, 2023 at 06:55:33PM +0300, Dan Carpenter wrote:
> Hello Piergiorgio Beruto,
> 
> The patch 8580e16c28f3: "net/ethtool: add netlink interface for the
> PLCA RS" from Jan 9, 2023, leads to the following Smatch static
> checker warning:
> 
> 	net/ethtool/plca.c:155 ethnl_set_plca_cfg()
> 	info: return a literal instead of 'ret'
> 
> net/ethtool/plca.c
>     140 int ethnl_set_plca_cfg(struct sk_buff *skb, struct genl_info *info)
>     141 {
>     142         struct ethnl_req_info req_info = {};
>     143         struct nlattr **tb = info->attrs;
>     144         const struct ethtool_phy_ops *ops;
>     145         struct phy_plca_cfg plca_cfg;
>     146         struct net_device *dev;
>     147         bool mod = false;
>     148         int ret;
>     149 
>     150         ret = ethnl_parse_header_dev_get(&req_info,
>     151                                          tb[ETHTOOL_A_PLCA_HEADER],
>     152                                          genl_info_net(info), info->extack,
>     153                                          true);
>     154         if (!ret)
> --> 155                 return ret;
> 
> This looks like the if statement is reversed.  Otherwise if this is
> a short cut to success, please write it like so:
> 
> 	if (!ret)
> 		return 0;
> 
> 
> There are a bunch of if (!ret) if statements in this function but the
> rest look intentional in context.  It's pretty common to reverse
> the last if statement.  (Not a fan, myself though).
> 
>     156 
>     157         dev = req_info.dev;
>     158 
>     159         rtnl_lock();
>     160 
>     161         // check that the PHY device is available and connected
>     162         if (!dev->phydev) {
>     163                 ret = -EOPNOTSUPP;
>     164                 goto out_rtnl;
>     165         }
>     166 
>     167         ops = ethtool_phy_ops;
>     168         if (!ops || !ops->set_plca_cfg) {
>     169                 ret = -EOPNOTSUPP;
>     170                 goto out_rtnl;
>     171         }
>     172 
>     173         ret = ethnl_ops_begin(dev);
>     174         if (!ret)
>     175                 goto out_rtnl;
>     176 
>     177         memset(&plca_cfg, 0xff, sizeof(plca_cfg));
>     178         plca_update_sint(&plca_cfg.enabled, tb[ETHTOOL_A_PLCA_ENABLED], &mod);
>     179         plca_update_sint(&plca_cfg.node_id, tb[ETHTOOL_A_PLCA_NODE_ID], &mod);
>     180         plca_update_sint(&plca_cfg.node_cnt, tb[ETHTOOL_A_PLCA_NODE_CNT], &mod);
>     181         plca_update_sint(&plca_cfg.to_tmr, tb[ETHTOOL_A_PLCA_TO_TMR], &mod);
>     182         plca_update_sint(&plca_cfg.burst_cnt, tb[ETHTOOL_A_PLCA_BURST_CNT],
>     183                          &mod);
>     184         plca_update_sint(&plca_cfg.burst_tmr, tb[ETHTOOL_A_PLCA_BURST_TMR],
>     185                          &mod);
>     186 
>     187         ret = 0;
>     188         if (!mod)
>     189                 goto out_ops;
>     190 
>     191         ret = ops->set_plca_cfg(dev->phydev, &plca_cfg, info->extack);
>     192         if (!ret)
>     193                 goto out_ops;
>     194 
>     195         ethtool_notify(dev, ETHTOOL_MSG_PLCA_NTF, NULL);
>     196 
>     197 out_ops:
>     198         ethnl_ops_complete(dev);
>     199 out_rtnl:
>     200         rtnl_unlock();
>     201         ethnl_parse_header_dev_put(&req_info);
>     202 
>     203         return ret;
>     204 }
> 
> regards,
> dan carpenter
