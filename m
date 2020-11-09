Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA2872AC2BA
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 18:44:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732134AbgKIRoU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 12:44:20 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:43752 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730115AbgKIRoU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 12:44:20 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kcBDD-0067T5-Hn; Mon, 09 Nov 2020 18:44:15 +0100
Date:   Mon, 9 Nov 2020 18:44:15 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, vivien.didelot@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: Export VTU as devlink
 region
Message-ID: <20201109174415.GD1456319@lunn.ch>
References: <20201109082927.8684-1-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201109082927.8684-1-tobias@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>  static void
> @@ -574,9 +670,16 @@ static int mv88e6xxx_setup_devlink_regions_global(struct dsa_switch *ds,
>  		ops = mv88e6xxx_regions[i].ops;
>  		size = mv88e6xxx_regions[i].size;
>  
> -		if (i == MV88E6XXX_REGION_ATU)
> +		switch (i) {
> +		case MV88E6XXX_REGION_ATU:
>  			size = mv88e6xxx_num_databases(chip) *
>  				sizeof(struct mv88e6xxx_devlink_atu_entry);
> +			break;
> +		case MV88E6XXX_REGION_VTU:
> +			size = chip->info->max_vid *
> +				sizeof(struct mv88e6xxx_devlink_vtu_entry);
> +			break;
> +		}

Hi Tobias

Maybe as a follow up patch, add a helper to get
chip->info->max_vid. It seems like many of the other members have a
helper, so it would help keep things consistent.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
