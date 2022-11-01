Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F59C615641
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 00:49:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbiKAXtc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 19:49:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiKAXtb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 19:49:31 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 066DBFAEF;
        Tue,  1 Nov 2022 16:49:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=QN/OD3muXE8uAR67gmo9/ZIdaIkWCZhtWQw4kY4Pnyc=; b=Hr59XxH12KClkHuqFLCWnXIXtH
        pBDeUMwgqM8WfXjzvcQ2btO91R7VPJGezu13D41gEVWymsSkdn80zCy6irTF6epfZxodEJmzwJzQf
        MMbb83bw+SGhKsFytpAyKpqvrjH4AZ80XyUjnz7cTeDSpzi3A0EDTpCBQx9OLvDZDR9E=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oq0za-0019My-U1; Wed, 02 Nov 2022 00:48:26 +0100
Date:   Wed, 2 Nov 2022 00:48:26 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, Florian Fainelli <f.fainelli@gmail.com>,
        corbet@lwn.net, michael.chan@broadcom.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, huangguangbin2@huawei.com,
        chenhao288@hisilicon.com, moshet@nvidia.com,
        linux@rempel-privat.de, linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next v3] ethtool: linkstate: add a statistic for PHY
 down events
Message-ID: <Y2GwSq0EkFvgVWLb@lunn.ch>
References: <20221101052601.162708-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221101052601.162708-1-kuba@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +struct ethtool_link_ext_stats {
> +	/* Custom Linux statistic for PHY level link down events.
> +	 * In a simpler world it should be equal to netdev->carrier_down_count
> +	 * unfortunately netdev also counts local reconfigurations which don't
> +	 * actually take the physical link down, not to mention NC-SI which,
> +	 * if present, keeps the link up regardless of host state.
> +	 * This statistic counts when PHY _actually_ went down, or lost link.
> +	 */
> +	u64 link_down_events;

Might be worth a comment why this is a u64 even when the uAPI has a
u32.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
