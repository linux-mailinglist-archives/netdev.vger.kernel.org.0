Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D178278D46
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 17:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729415AbgIYPyx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 11:54:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:41156 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727733AbgIYPyx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 11:54:53 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 5762AACB8;
        Fri, 25 Sep 2020 15:54:51 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id EE46960320; Fri, 25 Sep 2020 17:54:50 +0200 (CEST)
Date:   Fri, 25 Sep 2020 17:54:50 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH ethtool v2 2/2] Update link mode tables for fiber
Message-ID: <20200925155450.h3gvbba6b3qxqubi@lion.mk-sys.cz>
References: <20200924175610.22381-1-dmurphy@ti.com>
 <20200924175610.22381-2-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200924175610.22381-2-dmurphy@ti.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 24, 2020 at 12:56:10PM -0500, Dan Murphy wrote:
> Update the link mode tables to include 100base Fx Full and Half duplex
> modes.
> 
> Signed-off-by: Dan Murphy <dmurphy@ti.com>
> ---
>  ethtool.c          | 6 ++++++
>  netlink/settings.c | 2 ++
>  2 files changed, 8 insertions(+)
> 
> diff --git a/ethtool.c b/ethtool.c
> index ab9b4577cbce..2f71fa92bb09 100644
> --- a/ethtool.c
> +++ b/ethtool.c
> @@ -463,6 +463,8 @@ static void init_global_link_mode_masks(void)
>  		ETHTOOL_LINK_MODE_400000baseLR4_ER4_FR4_Full_BIT,
>  		ETHTOOL_LINK_MODE_400000baseDR4_Full_BIT,
>  		ETHTOOL_LINK_MODE_400000baseCR4_Full_BIT,
> +		ETHTOOL_LINK_MODE_100baseFX_Half_BIT,
> +		ETHTOOL_LINK_MODE_100baseFX_Full_BIT,
>  	};
>  	static const enum ethtool_link_mode_bit_indices
>  		additional_advertised_flags_bits[] = {
> @@ -659,6 +661,10 @@ static void dump_link_caps(const char *prefix, const char *an_prefix,
>  		  "200000baseDR4/Full" },
>  		{ 0, ETHTOOL_LINK_MODE_200000baseCR4_Full_BIT,
>  		  "200000baseCR4/Full" },
> +		{ 0, ETHTOOL_LINK_MODE_100baseFX_Half_BIT,
> +		  "100baseFx/Half" },
> +		{ 1, ETHTOOL_LINK_MODE_100baseFX_Full_BIT,
> +		  "100baseFx/Full" },
>  	};
>  	int indent;
>  	int did1, new_line_pend;

This table seems to be missing many other modes but I'll rather fix that
in a separate commit.

> diff --git a/netlink/settings.c b/netlink/settings.c
> index 3059d4d0d0b7..41a2e5af1945 100644
> --- a/netlink/settings.c
> +++ b/netlink/settings.c
> @@ -162,6 +162,8 @@ static const struct link_mode_info link_modes[] = {
>  	[ETHTOOL_LINK_MODE_400000baseLR4_ER4_FR4_Full_BIT] = __REAL(400000),
>  	[ETHTOOL_LINK_MODE_400000baseDR4_Full_BIT]	= __REAL(400000),
>  	[ETHTOOL_LINK_MODE_400000baseCR4_Full_BIT]	= __REAL(400000),
> +	[ETHTOOL_LINK_MODE_100baseFX_Half_BIT]		= __HALF_DUPLEX(100),
> +	[ETHTOOL_LINK_MODE_100baseFX_Full_BIT]		= __REAL(100),
>  };
>  const unsigned int link_modes_count = ARRAY_SIZE(link_modes);
>  

Please update also the table in ethtool.8.in

Michal

> -- 
> 2.28.0.585.ge1cfff676549
> 
