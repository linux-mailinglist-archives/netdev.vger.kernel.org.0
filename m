Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44A044CE2A0
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 06:00:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbiCEE5y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 23:57:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiCEE5x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 23:57:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B34BE23F3A5
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 20:57:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4CCBFB820EC
        for <netdev@vger.kernel.org>; Sat,  5 Mar 2022 04:57:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A137C004E1;
        Sat,  5 Mar 2022 04:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646456220;
        bh=Fb40IfRyDB+3X+bMsSowyDiyPWjM7ErCDbHvOVTF9ls=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nehvGdIAxPnaEhzD8AQe0SO+qHr8CCESETjAy+5E1d/IjvzhepqXIWdLHrPBWgxfh
         qviwLDX2G0/jpeShEWBL5XUllBPZjLyhqt2zeECjXcgflp4c81mvE4LFPJ5JTuVUro
         kBtxfujssu2bkghEj2so0ekjaQOXeg5GomzV67oVnyu30Ouc2dBUxjJSEs9rM+rWVS
         qTk15ZlVANKTlQsu5EOoUoz0eorjVEWDu6Yq609lGODEG6650DxxsOqgcA0WqLpX3n
         xfTWTsyLudJp9k7rDuaBOn4rkra4CczBEqaiYLQCPoI2wGutxLrAokvlfRBSpz+qOf
         gUGnYW2g2X3OQ==
Date:   Fri, 4 Mar 2022 20:56:59 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH v2 net-next] net: dsa: unlock the rtnl_mutex when
 dsa_master_setup() fails
Message-ID: <20220304205659.5e0c6997@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220303140840.1818952-1-vladimir.oltean@nxp.com>
References: <20220303140840.1818952-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  3 Mar 2022 16:08:40 +0200 Vladimir Oltean wrote:
> Subject: [PATCH v2 net-next] net: dsa: unlock the rtnl_mutex when dsa_master_setup() fails

Did you mean s/-next//?

> After the blamed commit, dsa_tree_setup_master() may exit without
> calling rtnl_unlock(), fix that.
> 
> Fixes: c146f9bc195a ("net: dsa: hold rtnl_mutex when calling dsa_master_{setup,teardown}")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> v1->v2: actually propagate the error code instead of always returning 0
