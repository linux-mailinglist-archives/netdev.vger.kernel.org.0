Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEF2E661B34
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 00:50:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233504AbjAHXua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 18:50:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbjAHXu3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 18:50:29 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76A69E0FE;
        Sun,  8 Jan 2023 15:50:27 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id r2so6593686wrv.7;
        Sun, 08 Jan 2023 15:50:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Mt/zZvc/5aqxkv4m9uaSDACOoMMjqUVXw2nlfqLFXCw=;
        b=gdMiz4lSJkRSyiYFLsATRdv0dOjWwRZE+w6c7TZC4NbAqQj4w/nlVDe5rdOG/ZfL4b
         qKebsrXLYt6iqPXNESuvlRS4ixaRGIGbWUnysjMnGtVOolbwaByaO+5JHNqDEEt7S7az
         EJfmRpEjhBa10coMW9/zBVsoplzYqOtqZlE9GxZb7nywiHgipJRG/3TtFgEFi3AavNl2
         OObwICf7/4IteRJjbxWl1pUh+WSLAHowQQOEZFQenr3+qT9fRaPc6okpMBcdAbfLahjJ
         +fW45oD4wdHf13hPfyrc5ODKDiZLJsW7NXJO04Sxgk8lZ49FNM9SR7CBDwxrdbJ6ON20
         ILAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mt/zZvc/5aqxkv4m9uaSDACOoMMjqUVXw2nlfqLFXCw=;
        b=ClG5fNRQW0N89wW2V4KMzJznI7uA5Ytlon1Mv1v/2Flreuq5w3esFBEhUHIozCQnZV
         eXGsknNPrWq0wTnnp9xxzjDISLyy3G2oEdFvAMQWU9jsTc1biuceu80r8krxFt4vpC7E
         5iuChsjvotYlYu6ZHd2BVhNs/7+dXHlNB98Xu/i7+ojCUbbu1cWjxTyH3JnN0Q45ttF3
         +f43amn7vw3BCiTOPrgspIkLlhUl+N4dlKONp9/T/FW2SoP8S6CGcMad7E5S1ujzCiFb
         QkeGYBVoOYfWo+7XgBwOxOg8CnQuXY0/ERdx2ArVuPBAM7f+L7q13C22PhiBwZzdk04v
         nbiA==
X-Gm-Message-State: AFqh2kqSPMYffphMnKbRU9aStO5DWTu4i+NsbEmxsjrU1mjKLUdJUczY
        8RGxBbTx2eKSAMt+QGvVwBk=
X-Google-Smtp-Source: AMrXdXvt8Eslahkd3ss4C5gEvPB79vo4kSTKFymfRoWdt/AEvGLbAZirMW/V6DwYvBxhX7/t5r92sA==
X-Received: by 2002:adf:dcc4:0:b0:2b5:8ba4:3b12 with SMTP id x4-20020adfdcc4000000b002b58ba43b12mr8763542wrm.23.1673221825953;
        Sun, 08 Jan 2023 15:50:25 -0800 (PST)
Received: from gvm01 (net-5-89-66-224.cust.vodafonedsl.it. [5.89.66.224])
        by smtp.gmail.com with ESMTPSA id d20-20020adfa354000000b002bc50ba3d06sm829071wrb.9.2023.01.08.15.50.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Jan 2023 15:50:25 -0800 (PST)
Date:   Mon, 9 Jan 2023 00:50:23 +0100
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
Subject: Re: [PATCH v2 net-next 4/5] drivers/net/phy: add helpers to get/set
 PLCA configuration
Message-ID: <Y7tWvws+5kLzDzX1@gvm01>
References: <cover.1673030528.git.piergiorgio.beruto@gmail.com>
 <35720efb893ac9ae2667110d4c2dc2828e9d4222.1673030528.git.piergiorgio.beruto@gmail.com>
 <Y7m0+MQggJrxfYju@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7m0+MQggJrxfYju@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 07, 2023 at 07:07:52PM +0100, Andrew Lunn wrote:
> > +/**
> > + * genphy_c45_plca_set_cfg - set PLCA configuration using standard registers
> > + * @phydev: target phy_device struct
> > + * @plca_cfg: structure containing the PLCA configuration. Fields set to -1 are
> > + * not to be changed.
> > + *
> > + * Description: if the PHY complies to the Open Alliance TC14 10BASE-T1S PLCA
> > + *   Management Registers specifications, this function can be used to modify
> > + *   the PLCA configuration using the standard registers in MMD 31.
> > + */
> > +int genphy_c45_plca_set_cfg(struct phy_device *phydev,
> > +			    const struct phy_plca_cfg *plca_cfg)
> > +{
> > +	int ret;
> > +	u16 val;
> > +
> > +	// PLCA IDVER is read-only
> > +	if (plca_cfg->version >= 0)
> > +		return -EINVAL;
> > +
> > +	// first of all, disable PLCA if required
> > +	if (plca_cfg->enabled == 0) {
> > +		ret = phy_clear_bits_mmd(phydev, MDIO_MMD_VEND2,
> > +					 MDIO_OATC14_PLCA_CTRL0,
> > +					 MDIO_OATC14_PLCA_EN);
> > +
> > +		if (ret < 0)
> > +			return ret;
> > +	}
> > +
> > +	if (plca_cfg->node_cnt >= 0 || plca_cfg->node_id >= 0) {
> > +		if (plca_cfg->node_cnt < 0 || plca_cfg->node_id < 0) {
> 
> I think it would be good to add some comments since this code is not
> immediately obvious to me. I had to think about it for a while.
Yes, I realize it is not very intuitive at furst glance :-)
I have added a comment explaining that we need to read back the register
to perform merge/pure of the configuration IFF we need to set one among
node ID / node count but not both.

> 
> > +	if (plca_cfg->burst_cnt >= 0 || plca_cfg->burst_tmr >= 0) {
> > +		if (plca_cfg->burst_cnt < 0 || plca_cfg->burst_tmr < 0) {
> > +			ret = phy_read_mmd(phydev, MDIO_MMD_VEND2,
> > +					   MDIO_OATC14_PLCA_BURST);
> > +
> 
> This follows the same patterns, so maybe comments here as well?
Yup, added the same comment.
> 
> With that, you can add my Reviewed-by.
Thanks!
> 
>      Andrew
