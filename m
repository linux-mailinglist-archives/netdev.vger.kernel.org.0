Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72CDE661B31
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 00:48:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233704AbjAHXsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 18:48:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233690AbjAHXsO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 18:48:14 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19865E0FE;
        Sun,  8 Jan 2023 15:48:13 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id p1-20020a05600c1d8100b003d8c9b191e0so5365943wms.4;
        Sun, 08 Jan 2023 15:48:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bvIkcnN7jqI1qIrkfG25yW+dEOQUB74c9FPX0mQZDAY=;
        b=DoZZQMydak3s2tsQ2JCcyiwFNQoDK/6V9+aWtelBaCufrAtNbJlIdjG2lqYYu/Q3N+
         fBROteW7yESOBMCt7luznZ5howIhErsFHD0Q8oU108gS53lLBV7xPuCKaqGj6EhEyh1m
         yuRZXX3UAeeG5V8jsqiCMjBCsVFbDTY8f5YrSDJGE28SUD+fvviv9BaXGTUSW9bGLPAX
         TRk5vqT9AAJXeW7PNYLv7xHXpGsZ/EUJxzkin2R0poP4ItXree7+MUJU9FJy54SBvFwz
         4vmNVSejgNYOQbGuftNQybJ+ZqTdZQaoWGFP3jyaG9AQ5RmDnoEWIYXEpbXuFATrKx/D
         ye4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bvIkcnN7jqI1qIrkfG25yW+dEOQUB74c9FPX0mQZDAY=;
        b=We4oQeFjv3LFB0DFw95l99jJmETifojZH36qqrGcUb3f/bAbxhlh64HY0RHYpQk/lh
         LhkTQyJXsXjOOLntTlXrBZw191DbAGUQ5Pxt1NllBUQM/QqSgloViIxKmrH5ybBMb73A
         mH8oapaOZ9D4QZzt7jpFflhTMp8iqT7WnmYjmw6DXc0b1VfYkuBO/IAV0emzyYrKM06x
         PpEmfek7dqqePkngfPTzoKGWKucPmOjkUYAh8X6XgZ1iu+v9Sp0X5uROIp1mgDhn+7HW
         HLHprakb/wCWZueNZgrmOueNY8DmQ1O35JbAAF+KZxudFQE5FbxNrvDGe3SMdB2lv+7r
         EUCA==
X-Gm-Message-State: AFqh2kq5cuXp9fyljaw+r2KEm26ZDz4PyR39q5vUub+vHeBLF47QO0jc
        tgoaCg8PAkAQ4h0k+no5lDY=
X-Google-Smtp-Source: AMrXdXstidVps+mowGTsqN9HY4o23vxRSMb1FX3fQeRRwSdGNnEh0w8H9iaPB7kL8iMObseeeEViMA==
X-Received: by 2002:a05:600c:3509:b0:3cf:ae53:9193 with SMTP id h9-20020a05600c350900b003cfae539193mr44836977wmq.39.1673221691556;
        Sun, 08 Jan 2023 15:48:11 -0800 (PST)
Received: from gvm01 (net-5-89-66-224.cust.vodafonedsl.it. [5.89.66.224])
        by smtp.gmail.com with ESMTPSA id bg23-20020a05600c3c9700b003d1de805de5sm10597727wmb.16.2023.01.08.15.48.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Jan 2023 15:48:10 -0800 (PST)
Date:   Mon, 9 Jan 2023 00:48:09 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>,
        mailhol.vincent@wanadoo.fr, sudheer.mogilappagari@intel.com,
        sbhatta@marvell.com, linux-doc@vger.kernel.org,
        wangjie125@huawei.com, corbet@lwn.net, lkp@intel.com,
        gal@nvidia.com, gustavoars@kernel.org
Subject: Re: [PATCH v2 net-next 3/5] drivers/net/phy: add connection between
 ethtool and phylib for PLCA
Message-ID: <Y7tWOd35UQVkXoK2@gvm01>
References: <cover.1673030528.git.piergiorgio.beruto@gmail.com>
 <9a25328bcf2c0d963e34d33ff0968f83755905f4.1673030528.git.piergiorgio.beruto@gmail.com>
 <Y7mt8IUUbMv6bt5v@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7mt8IUUbMv6bt5v@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Andrew,
thank you very much for your review.
I have fixed this issue.

Piergiorgio

On Sat, Jan 07, 2023 at 06:37:52PM +0100, Andrew Lunn wrote:
> > +	// if not enabling PLCA, skip a few sanity checks
> > +	if (plca_cfg->enabled <= 0)
> > +		goto apply_cfg;
> > +
> > +	if (!linkmode_test_bit(ETHTOOL_LINK_MODE_10baseT1S_P2MP_Half_BIT,
> > +			       phydev->advertising)) {
> > +		ret = -EOPNOTSUPP;
> > +		NL_SET_ERR_MSG(extack,
> > +			       "Point to Multi-Point mode is not enabled");
> > +	}
> > +
> > +	// allow setting node_id concurrently with enabled
> > +	if (plca_cfg->node_id >= 0)
> > +		curr_plca_cfg->node_id = plca_cfg->node_id;
> > +
> > +	if (curr_plca_cfg->node_id >= 255) {
> > +		NL_SET_ERR_MSG(extack, "PLCA node ID is not set");
> > +		ret = -EINVAL;
> > +		goto out_drv;
> > +	}
> > +
> > +apply_cfg:
> > +	ret = phydev->drv->set_plca_cfg(phydev, plca_cfg);
> 
> Goto which don't jump to the end of the function is generally frowned
> upon. I suggest you put these sanity checks into a little helper, so
> you can avoid the goto.
> 
> With that change make, feel free to add my reviewed-by.
> 
>      Andrew
