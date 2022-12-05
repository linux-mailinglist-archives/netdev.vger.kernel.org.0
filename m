Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3CE6425E4
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 10:37:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbiLEJhW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 04:37:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbiLEJhV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 04:37:21 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D47B11143;
        Mon,  5 Dec 2022 01:37:20 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id f7so14917230edc.6;
        Mon, 05 Dec 2022 01:37:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xoLfzXVkjo8xAm6ZoyhPEG35GhkaRRBgemIJLYp+/88=;
        b=at/2Q0D1obdj6fS8XI2naRo6awU7eHZGEWqXOPYMdiqm/57m6I4dCLR4lDQgud15Pz
         U0z5ByppO1SWj8t/Hs/vTne54kXZ1lj4eufTYHCXVHeJKD8Qk1MpNQ+yTOTRQ0ETWs7z
         kpHvAPbAn6to7RVtzTyQAN0r0JPL+2Y4c77gZPDMpO4w8jKCcHKUZrhhKvtQYNT+i2Zj
         YhUrY70Hsuqm6j7ykLSvj35Rhecx0cjGBA3bRVXpGgV/wPg8NsO8ObTj6S8vdznANRPQ
         28K9D4ihK0Qa561S26ZOKBPPPSMYkWhatoUFL47qFdWVs8aGDOy3+XXwiAPR+bhp2O/m
         5A/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xoLfzXVkjo8xAm6ZoyhPEG35GhkaRRBgemIJLYp+/88=;
        b=uufjK1DOWmyv2SbdqJ5ixlU6SptxFB40F3FgGjxIggPytml1RfKyOH6Q5YzXwXxFF0
         yvD5gSNdJ7TYskxz5sBfqlLERC5o+0gInwFQiesknT46dG4c3VmITKCxS5y8SVhM452r
         YBvq/2SiSSLL/EQTSqomGEVu1XwEyGJjulERt5q+/EUdRcn643102fIenN9OGY7x3Ogr
         UXe1GH3bJ7O/b19M4HKDDbnW8jPmYCDwS0om2/ij5YCskbPNDqSGHeQUICxIqIgHf/VK
         A7GT2q6zNBXJYuhbX4D0TIcwl4743BGdKoVjaGpajxPoZpVVR79jp4+GXRk6EOc3ZfET
         9f2Q==
X-Gm-Message-State: ANoB5pnHS1K/mAeIWPZsyySfvrRdhJxQjB+I32f+yfDhplh4182mU06M
        C63TgdC47La6+uFYUs67aVI=
X-Google-Smtp-Source: AA0mqf4fUQ3NHRpbK75rvYp1ggcfz2u/V59ZyPPyJB7GBmjQw1CnuM1UGpJU+Mg1st12qJjnUrJK6Q==
X-Received: by 2002:a05:6402:d6:b0:458:b42e:46e6 with SMTP id i22-20020a05640200d600b00458b42e46e6mr73681443edu.375.1670233038822;
        Mon, 05 Dec 2022 01:37:18 -0800 (PST)
Received: from gvm01 (net-2-45-26-236.cust.vodafonedsl.it. [2.45.26.236])
        by smtp.gmail.com with ESMTPSA id x3-20020a05640226c300b004677b1b1a70sm5960294edd.61.2022.12.05.01.37.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 01:37:17 -0800 (PST)
Date:   Mon, 5 Dec 2022 10:37:25 +0100
From:   Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH v2 net-next 1/4] net/ethtool: add netlink interface for
 the PLCA RS
Message-ID: <Y4271Y9TtdiEgjn2@gvm01>
References: <fc3ac4f2d0c28d9c24b909e97791d1f784502a4a.1670204277.git.piergiorgio.beruto@gmail.com>
 <Y42509XkIN1S73Er@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y42509XkIN1S73Er@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 05, 2022 at 09:28:51AM +0000, Russell King (Oracle) wrote:
> On Mon, Dec 05, 2022 at 02:41:35AM +0100, Piergiorgio Beruto wrote:
> > +int ethnl_set_plca_cfg(struct sk_buff *skb, struct genl_info *info)
> > +{
> > +	struct ethnl_req_info req_info = {};
> > +	struct nlattr **tb = info->attrs;
> > +	const struct ethtool_phy_ops *ops;
> > +	struct phy_plca_cfg plca_cfg;
> > +	struct net_device *dev;
> > +
> > +	bool mod = false;
> > +	int ret;
> > +
> > +	ret = ethnl_parse_header_dev_get(&req_info,
> > +					 tb[ETHTOOL_A_PLCA_HEADER],
> > +					 genl_info_net(info), info->extack,
> > +					 true);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	dev = req_info.dev;
> > +
> > +	// check that the PHY device is available and connected
> > +	if (!dev->phydev) {
> > +		ret = -EOPNOTSUPP;
> > +		goto out;
> > +	}
> 
> This check should really be done under the RTNL lock. phydevs can come
> and go with SFP cages.
> 
> > +
> > +	rtnl_lock();
Good point Russell, I'll fix that. And I wish to seize the opportunity
to remark that the same problem may be present in cabletest.c
(see below).

Maybe we should post a patch to fix that?

Thanks,
Piergiorgio

int ethnl_act_cable_test(struct sk_buff *skb, struct genl_info *info)
{
	struct ethnl_req_info req_info = {};
	const struct ethtool_phy_ops *ops;
	struct nlattr **tb = info->attrs;
	struct net_device *dev;
	int ret;

	ret = ethnl_parse_header_dev_get(&req_info,
					 tb[ETHTOOL_A_CABLE_TEST_HEADER],
					 genl_info_net(info), info->extack,
					 true);
	if (ret < 0)
		return ret;

	dev = req_info.dev;
	if (!dev->phydev) {
		ret = -EOPNOTSUPP;
		goto out_dev_put;
	}

	rtnl_lock();

