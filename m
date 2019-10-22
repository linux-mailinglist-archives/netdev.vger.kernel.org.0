Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDA67DFD85
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 08:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730915AbfJVGKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 02:10:19 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:56752 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726082AbfJVGKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 02:10:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=MSNIzng4nZjoen/gGP0LdSUMf4eCPzZjuITGVgK5D9I=; b=fF9b0o6AO10nFtKnR3aRJd3oA
        9Z3UQjUdnZERWwZABBUPDfpaHk+mD7z/bWkcu/VErV6H9wnlQtz7yo3ZENII/FO+HLdPkpEOeoJyZ
        xyWAJ16B80/IZiC8No/LqpFhPSdyKfGtaIcDnUUUDxI//MgojP27AAABFQSFU5AP87oJQSAQIw28N
        eVLu6UTXEOo5bJTcVp/VmGhZmubZf/Sz7AmQC/mh14gvWpcjjFIBSdU1NYGFoiR7N0hE0VL/QFI9h
        jqcryOfEckHyaCEe2OYAgOPuN3xMO/urKsrXbR56lvZKjeFJoXWpN9dm1+IaE126FOPoA2cv/pXco
        X8RUUPvTw==;
Received: from [2601:1c0:6280:3f0::9ef4]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iMnN2-0008ER-So; Tue, 22 Oct 2019 06:10:16 +0000
Subject: Re: [PATCH v4 4/5] net: dsa: add support for Atheros AR9331 TAG
 format
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Chris Snook <chris.snook@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        James Hogan <jhogan@kernel.org>,
        Jay Cliburn <jcliburn@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Paul Burton <paul.burton@mips.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Rob Herring <robh+dt@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Pengutronix Kernel Team <kernel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-mips@vger.kernel.org, Russell King <linux@armlinux.org.uk>
References: <20191022055743.6832-1-o.rempel@pengutronix.de>
 <20191022055743.6832-5-o.rempel@pengutronix.de>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <50ceeb18-3187-8a9d-4114-6d85a4ded955@infradead.org>
Date:   Mon, 21 Oct 2019 23:10:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191022055743.6832-5-o.rempel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/21/19 10:57 PM, Oleksij Rempel wrote:
> Add support for tag format used in Atheros AR9331 build-in switch.

                                                    built-in

> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  include/net/dsa.h    |  2 +
>  net/dsa/Kconfig      |  6 +++
>  net/dsa/Makefile     |  1 +
>  net/dsa/tag_ar9331.c | 96 ++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 105 insertions(+)
>  create mode 100644 net/dsa/tag_ar9331.c
> 

> diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
> index 29e2bd5cc5af..617c9607df5f 100644
> --- a/net/dsa/Kconfig
> +++ b/net/dsa/Kconfig
> @@ -29,6 +29,12 @@ config NET_DSA_TAG_8021Q
>  
>  	  Drivers which use these helpers should select this as dependency.
>  
> +config NET_DSA_TAG_AR9331
> +	tristate "Tag driver for Atheros AR9331 SoC with build-in switch"

	                                                 built-in

> +	help
> +	  Say Y or M if you want to enable support for tagging frames for
> +	  the Atheros AR9331 SoC with build-in switch.

	                              built-in

> +
>  config NET_DSA_TAG_BRCM_COMMON
>  	tristate
>  	default n


thanks.
-- 
~Randy

