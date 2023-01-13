Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B26CF669D25
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 17:05:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbjAMQF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 11:05:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230086AbjAMQE6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 11:04:58 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECC299585
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 07:55:46 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id co23so21494342wrb.4
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 07:55:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Q6s3i9xYEu7505XmEvoDk0FqPSST3yVzVEjBx2QqwYQ=;
        b=cLFwTw6gwkelboXwJ3cgGdikUJrlJVPp8EUVUoRQwrptGBvFoHnADS0B9iKAA2Co83
         pFX1qfxTHU/pFTT9fdwoU/+lvQYDCofcIz+tfpXdQJY0eVE3e0op9bfqKZu71xe3Ik6I
         HSPiEosD1AhT7T/4Fvi5SgIWLKOhyqmpmTvQtYYNkBrSYS2OM+M4XilhK/zNKnMA3U6N
         EMquQ5BEhLZIcNOoGoyTlYuEXJ+CLn13DtWYq3M6S7A2xId8EsgLrX3ybSFwAQti/m78
         ygI3ff/gdyUWnYlorm4pghRF3ZDHokn87mrUnt4xxwtqNPg4dQQlXDom0rj9rdWYIUse
         zarQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q6s3i9xYEu7505XmEvoDk0FqPSST3yVzVEjBx2QqwYQ=;
        b=s8CcK9riGNfML2KVWHY46ph5MMT1xRMO2TJaSn6pJE3WAKDWDNyK6jFUePd72tbG9p
         8MvqLcNO8TwleM3wNC2RsATIYUdJfbfggi+rX5Orx4yoh/HLajQrjdg8mJAd+kuzDO9B
         4V+5eYMUeaP9TCd8EW1sNGsbtXk+uRrzqRkKu9E4FKXmxWw8ksLSmniJOHyTe7L+xKVB
         tfnQKM+x7mz5VE5BxT8EjrGwbQ9ANARVFI5Cmn2lllf2O1F1nxoLJSlCng2C519QK/d2
         68LjRrJJBsTc6iJCfcok/NmcZI+RFk/7WuKK4Owiu5W5FjqADgM8OZtBu4qzvBzoAfIC
         6XJg==
X-Gm-Message-State: AFqh2krMNvVJ6vFIvJjDFz5UisWiY+BbAC1o/nkKcntSUTz8nXlKhZD7
        l3kd0TGrnLMvaW5cYru/Qk5LaFRYw9beeQ==
X-Google-Smtp-Source: AMrXdXsihPp5TuB2zXqpQY5dCn8hXH9KyoYq72vQoGXqvBoAoEp3a2FxpSc8ECTgydyWb/YhS0+x3g==
X-Received: by 2002:a5d:664e:0:b0:2bc:7ec3:8a8 with SMTP id f14-20020a5d664e000000b002bc7ec308a8mr12250047wrw.44.1673625345319;
        Fri, 13 Jan 2023 07:55:45 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id q15-20020adfab0f000000b002bde7999cd6sm759370wrc.61.2023.01.13.07.55.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 07:55:44 -0800 (PST)
Date:   Fri, 13 Jan 2023 18:55:33 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     piergiorgio.beruto@gmail.com
Cc:     netdev@vger.kernel.org
Subject: [bug report] net/ethtool: add netlink interface for the PLCA RS
Message-ID: <Y8F+9UmSubFpBsYo@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Piergiorgio Beruto,

The patch 8580e16c28f3: "net/ethtool: add netlink interface for the
PLCA RS" from Jan 9, 2023, leads to the following Smatch static
checker warning:

	net/ethtool/plca.c:155 ethnl_set_plca_cfg()
	info: return a literal instead of 'ret'

net/ethtool/plca.c
    140 int ethnl_set_plca_cfg(struct sk_buff *skb, struct genl_info *info)
    141 {
    142         struct ethnl_req_info req_info = {};
    143         struct nlattr **tb = info->attrs;
    144         const struct ethtool_phy_ops *ops;
    145         struct phy_plca_cfg plca_cfg;
    146         struct net_device *dev;
    147         bool mod = false;
    148         int ret;
    149 
    150         ret = ethnl_parse_header_dev_get(&req_info,
    151                                          tb[ETHTOOL_A_PLCA_HEADER],
    152                                          genl_info_net(info), info->extack,
    153                                          true);
    154         if (!ret)
--> 155                 return ret;

This looks like the if statement is reversed.  Otherwise if this is
a short cut to success, please write it like so:

	if (!ret)
		return 0;


There are a bunch of if (!ret) if statements in this function but the
rest look intentional in context.  It's pretty common to reverse
the last if statement.  (Not a fan, myself though).

    156 
    157         dev = req_info.dev;
    158 
    159         rtnl_lock();
    160 
    161         // check that the PHY device is available and connected
    162         if (!dev->phydev) {
    163                 ret = -EOPNOTSUPP;
    164                 goto out_rtnl;
    165         }
    166 
    167         ops = ethtool_phy_ops;
    168         if (!ops || !ops->set_plca_cfg) {
    169                 ret = -EOPNOTSUPP;
    170                 goto out_rtnl;
    171         }
    172 
    173         ret = ethnl_ops_begin(dev);
    174         if (!ret)
    175                 goto out_rtnl;
    176 
    177         memset(&plca_cfg, 0xff, sizeof(plca_cfg));
    178         plca_update_sint(&plca_cfg.enabled, tb[ETHTOOL_A_PLCA_ENABLED], &mod);
    179         plca_update_sint(&plca_cfg.node_id, tb[ETHTOOL_A_PLCA_NODE_ID], &mod);
    180         plca_update_sint(&plca_cfg.node_cnt, tb[ETHTOOL_A_PLCA_NODE_CNT], &mod);
    181         plca_update_sint(&plca_cfg.to_tmr, tb[ETHTOOL_A_PLCA_TO_TMR], &mod);
    182         plca_update_sint(&plca_cfg.burst_cnt, tb[ETHTOOL_A_PLCA_BURST_CNT],
    183                          &mod);
    184         plca_update_sint(&plca_cfg.burst_tmr, tb[ETHTOOL_A_PLCA_BURST_TMR],
    185                          &mod);
    186 
    187         ret = 0;
    188         if (!mod)
    189                 goto out_ops;
    190 
    191         ret = ops->set_plca_cfg(dev->phydev, &plca_cfg, info->extack);
    192         if (!ret)
    193                 goto out_ops;
    194 
    195         ethtool_notify(dev, ETHTOOL_MSG_PLCA_NTF, NULL);
    196 
    197 out_ops:
    198         ethnl_ops_complete(dev);
    199 out_rtnl:
    200         rtnl_unlock();
    201         ethnl_parse_header_dev_put(&req_info);
    202 
    203         return ret;
    204 }

regards,
dan carpenter
