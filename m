Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8802F63D84F
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 15:36:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbiK3Of3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 09:35:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbiK3Oel (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 09:34:41 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEFA62A706
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 06:34:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=jf+6ElMC07B1X+dyU/GaRA8cEU8jwQkLG3EIjvOdDzw=; b=UGDjA88GfuDosMz3altRORgLU1
        hImKpHxCJx+UPwBb2inZaDv0Cpv/DAqRCZSCkiQ8/+pO96i2pzFAbfXCcckwgqgqkbPNpPvYYXUwb
        uVrHBy5+eeuP+K0qIMuPGWcw1VDt9ZsGz59ahyXvCzhyhAWAZin+GNGkMa05IMySP3uQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p0NUQ-003xYe-Nk; Wed, 30 Nov 2022 14:51:06 +0100
Date:   Wed, 30 Nov 2022 14:51:06 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Daniil Tatianin <d-tatianin@yandex-team.ru>,
        netdev@vger.kernel.org, Michal Kubecek <mkubecek@suse.cz>,
        yc-core@yandex-team.ru, lvc-project@linuxtesting.org
Subject: Re: [PATCH v2 3/3] net/ethtool/ioctl: split ethtool_get_phy_stats
 into multiple helpers
Message-ID: <Y4dfyp+az6WR6cqY@lunn.ch>
References: <20221129103801.498149-1-d-tatianin@yandex-team.ru>
 <20221129103801.498149-4-d-tatianin@yandex-team.ru>
 <Y4ai4tCT48r/ktbO@lunn.ch>
 <20221129183938.496850f7@kicinski-fedora-PC1C0HJN>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221129183938.496850f7@kicinski-fedora-PC1C0HJN>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 29, 2022 at 06:39:41PM -0800, Jakub Kicinski wrote:
> On Wed, 30 Nov 2022 01:25:06 +0100 Andrew Lunn wrote:
> > On Tue, Nov 29, 2022 at 01:38:01PM +0300, Daniil Tatianin wrote:
> > > So that it's easier to follow and make sense of the branching and
> > > various conditions.
> > > 
> > > Stats retrieval has been split into two separate functions
> > > ethtool_get_phy_stats_phydev & ethtool_get_phy_stats_ethtool.
> > > The former attempts to retrieve the stats using phydev & phy_ops, while
> > > the latter uses ethtool_ops.
> > > 
> > > Actual n_stats validation & array allocation has been moved into a new
> > > ethtool_vzalloc_stats_array helper.
> > > 
> > > This also fixes a potential NULL dereference of
> > > ops->get_ethtool_phy_stats where it was getting called in an else branch
> > > unconditionally without making sure it was actually present.
> > > 
> > > Found by Linux Verification Center (linuxtesting.org) with the SVACE
> > > static analysis tool.
> > > 
> > > Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>  
> > 
> > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> 
> FWIW the patches did not hit the list, once again :/

Daniil, how are you sending the patches? git send-email?

You might need to contact postmaster@vger.kernel.org and ask if they
have logs records of why it is discarding your emails.

     Andrew
