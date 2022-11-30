Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3966063CC7C
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 01:25:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbiK3AZJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 19:25:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbiK3AZI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 19:25:08 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 918BF2BB0D
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 16:25:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=MpfgdhT/yIIlmnXbNjCaQ7O5AZZiDkpQ12TpTx4hbis=; b=CD7YojFTbhbtyxPYRAKvXlz5Ma
        veceim4pwSWxC2Dx+24znJ5U6+xEybN6uki62OT1n2GP6TkrlJ8GAYxu83jkdnScaojJH005nZA8y
        +rwP8eBqOgvPtGkrkITrJTVeUQvQ9pb0Zn58+bfqbaUhIkvpGjHbzTvX2Q8fFX87tRAs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p0AuQ-003vDZ-0l; Wed, 30 Nov 2022 01:25:06 +0100
Date:   Wed, 30 Nov 2022 01:25:06 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Daniil Tatianin <d-tatianin@yandex-team.ru>
Cc:     netdev@vger.kernel.org, Michal Kubecek <mkubecek@suse.cz>,
        yc-core@yandex-team.ru, lvc-project@linuxtesting.org
Subject: Re: [PATCH v2 3/3] net/ethtool/ioctl: split ethtool_get_phy_stats
 into multiple helpers
Message-ID: <Y4ai4tCT48r/ktbO@lunn.ch>
References: <20221129103801.498149-1-d-tatianin@yandex-team.ru>
 <20221129103801.498149-4-d-tatianin@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221129103801.498149-4-d-tatianin@yandex-team.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 29, 2022 at 01:38:01PM +0300, Daniil Tatianin wrote:
> So that it's easier to follow and make sense of the branching and
> various conditions.
> 
> Stats retrieval has been split into two separate functions
> ethtool_get_phy_stats_phydev & ethtool_get_phy_stats_ethtool.
> The former attempts to retrieve the stats using phydev & phy_ops, while
> the latter uses ethtool_ops.
> 
> Actual n_stats validation & array allocation has been moved into a new
> ethtool_vzalloc_stats_array helper.
> 
> This also fixes a potential NULL dereference of
> ops->get_ethtool_phy_stats where it was getting called in an else branch
> unconditionally without making sure it was actually present.
> 
> Found by Linux Verification Center (linuxtesting.org) with the SVACE
> static analysis tool.
> 
> Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
