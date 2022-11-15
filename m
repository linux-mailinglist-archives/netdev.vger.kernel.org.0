Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AEDF629DC7
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 16:40:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238246AbiKOPkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 10:40:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237952AbiKOPkl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 10:40:41 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97C6B29361;
        Tue, 15 Nov 2022 07:40:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=IVRozCvsAl0N4wyUApbsWG3nXgbptg/3aW0X1ZtUpNU=; b=hbYowYFDGyWEkJvrZPomeEH0C3
        4RwaDvc2XtrOCw7djpk3RnIsFEjmZQpjxJGsnLLm9Z/cjeWGXzH3ie4nRTl5J7GKzi1H39AU9Fc5s
        7Pca08Uiw+FwspSXAbusiGt5nHoQMXJMSwHhbpJJZ2zQg3d6vw+hnWSIGOMkwyXXAMt0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ouy2h-002TR0-OJ; Tue, 15 Nov 2022 16:40:07 +0100
Date:   Tue, 15 Nov 2022 16:40:07 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Daniil Tatianin <d-tatianin@yandex-team.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hao Chen <chenhao288@hisilicon.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Marco Bonelli <marco@mebeim.net>, Tom Rix <trix@redhat.com>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lvc-project@linuxtesting.org, yc-core@yandex-team.ru
Subject: Re: [PATCH v1] net/ethtool/ioctl: ensure that we have phy ops before
 using them
Message-ID: <Y3Oy14CNVEttEI7T@lunn.ch>
References: <20221114081532.3475625-1-d-tatianin@yandex-team.ru>
 <20221114210705.216996a9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221114210705.216996a9@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 14, 2022 at 09:07:05PM -0800, Jakub Kicinski wrote:
> On Mon, 14 Nov 2022 11:15:32 +0300 Daniil Tatianin wrote:
> > +	if (!(phydev && phy_ops && phy_ops->get_stats) &&
> > +	    !ops->get_ethtool_phy_stats)
> 
> This condition is still complicated.
> 
> > +		return -EOPNOTSUPP;
> 
> The only way this crash can happen is if driver incorrectly returns
> non-zero stats count but doesn't have a callback to read the stats.
> So WARN_ON() would be in order here.

Hi Daniil

I'm missing the patch itself, and b4 does not return it. Please
consider reposting. Since this appear to be to do with PHY statistics,
you should Cc: the PHY maintainers.

       Andrew
