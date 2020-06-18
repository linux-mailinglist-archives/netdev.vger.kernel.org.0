Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 789F81FF366
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 15:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730282AbgFRNmp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 09:42:45 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46734 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727101AbgFRNmn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 09:42:43 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jluoR-0017Sl-Au; Thu, 18 Jun 2020 15:42:39 +0200
Date:   Thu, 18 Jun 2020 15:42:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [RFC PATCH 1/9] net: dsa: Add tag handling for Hirschmann
 Hellcreek switches
Message-ID: <20200618134239.GP249144@lunn.ch>
References: <20200618064029.32168-1-kurt@linutronix.de>
 <20200618064029.32168-2-kurt@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200618064029.32168-2-kurt@linutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 08:40:21AM +0200, Kurt Kanzenbach wrote:
> The Hirschmann Hellcreek TSN switches have a special tagging protocol for frames
> exchanged between the CPU port and the master interface. The format is a one
> byte trailer indicating the destination or origin port.
> 
> It's quite similar to the Micrel KSZ tagging. That's why the implementation is
> based on that code.
> 
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> ---
>  include/net/dsa.h       |   2 +
>  net/dsa/Kconfig         |   6 +++
>  net/dsa/Makefile        |   1 +
>  net/dsa/tag_hellcreek.c | 101 ++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 110 insertions(+)
>  create mode 100644 net/dsa/tag_hellcreek.c
> 
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index 50389772c597..2784c4851d92 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -44,6 +44,7 @@ struct phylink_link_state;
>  #define DSA_TAG_PROTO_KSZ8795_VALUE		14
>  #define DSA_TAG_PROTO_OCELOT_VALUE		15
>  #define DSA_TAG_PROTO_AR9331_VALUE		16
> +#define DSA_TAG_PROTO_HELLCREEK_VALUE		17
>  
>  enum dsa_tag_protocol {
>  	DSA_TAG_PROTO_NONE		= DSA_TAG_PROTO_NONE_VALUE,
> @@ -63,6 +64,7 @@ enum dsa_tag_protocol {
>  	DSA_TAG_PROTO_KSZ8795		= DSA_TAG_PROTO_KSZ8795_VALUE,
>  	DSA_TAG_PROTO_OCELOT		= DSA_TAG_PROTO_OCELOT_VALUE,
>  	DSA_TAG_PROTO_AR9331		= DSA_TAG_PROTO_AR9331_VALUE,
> +	DSA_TAG_PROTO_HELLCREEK		= DSA_TAG_PROTO_HELLCREEK_VALUE,
>  };
>  
>  struct packet_type;
> diff --git a/net/dsa/Kconfig b/net/dsa/Kconfig
> index d5bc6ac599ef..edc0c3ab6a4e 100644
> --- a/net/dsa/Kconfig
> +++ b/net/dsa/Kconfig
> @@ -121,4 +121,10 @@ config NET_DSA_TAG_TRAILER
>  	  Say Y or M if you want to enable support for tagging frames at
>  	  with a trailed. e.g. Marvell 88E6060.
>  
> +config NET_DSA_TAG_HELLCREEK
> +	tristate "Tag driver for Hirschmann Hellcreek TSN switches"
> +	help
> +	  Say Y or M if you want to enable support for tagging frames
> +	  for the Hirschmann Hellcreek TSN switches.
> +

Hi Kurt

This file is roughly in alphabetic order based on the tristate
string. Please move this before "Tag driver for Lantiq / Intel GSWIP
switches" to keep with the sorting.

Otherwise this looks good.

	  Andrew
