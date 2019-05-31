Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 964BF31196
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 17:50:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbfEaPuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 11:50:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:48622 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726037AbfEaPuK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 11:50:10 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 46C2DAF79;
        Fri, 31 May 2019 15:50:09 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 9E8CAE00E3; Fri, 31 May 2019 17:50:07 +0200 (CEST)
Date:   Fri, 31 May 2019 17:50:07 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, linville@redhat.com
Subject: Re: [PATCH v2 2/2] ethtool: Add 100BaseT1 and 1000BaseT1 link modes
Message-ID: <20190531155007.GF15954@unicorn.suse.cz>
References: <20190531135748.23740-1-andrew@lunn.ch>
 <20190531135748.23740-3-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190531135748.23740-3-andrew@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 03:57:48PM +0200, Andrew Lunn wrote:
> The kernel can now indicate if the PHY supports operating over a
> single pair at 100Mbps or 1000Mbps.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---

Reviewed-by: Michal Kubecek <mkubecek@suse.cz>

>  ethtool.8.in | 2 ++
>  ethtool.c    | 6 ++++++
>  2 files changed, 8 insertions(+)
> 
> diff --git a/ethtool.8.in b/ethtool.8.in
> index 430d11b915af..6af63455c636 100644
> --- a/ethtool.8.in
> +++ b/ethtool.8.in
> @@ -639,8 +639,10 @@ lB	l	lB.
>  0x002	10baseT Full
>  0x004	100baseT Half
>  0x008	100baseT Full
> +0x80000000000000000	100baseT1 Full
>  0x010	1000baseT Half	(not supported by IEEE standards)
>  0x020	1000baseT Full
> +0x100000000000000000	1000baseT1 Full
>  0x20000	1000baseKX Full
>  0x20000000000	1000baseX Full
>  0x800000000000	2500baseT Full

This reminds me the earlier discussion about which syntax extension
would be more useful:

  ethtool -s <dev> advertise 100baseT1/Full 1000baseT1/Full

(listing modes to be advertised) or

  ethtool -s <dev> advertise 100baseT1/Full off 1000baseT1/Full on

(enabling/disabling selected modes). But maybe we could support both;
after all, it's unlikely there would ever be a link mode named "on" or
"off".

Michal
