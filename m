Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EEC59BEA8
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 17:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727827AbfHXPr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 11:47:29 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57138 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727786AbfHXPr3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 24 Aug 2019 11:47:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=pxz12XJSHffURhePZsbfyG55qOJtP4aCvx0f6HmEgfI=; b=rzUJ63vflDTPZA3eckQqOsx+oC
        A8siP/fyAbnUG4beT8pw1+uiHHrxv3E7E0hBNgDaPzb8u7ZLuW1E5G4Gl+4kcG3h8vRtjr9WRPcm4
        Yezh1o9lMGgtFOKBt6oBGDRKXY6QezvLRfqwmgsLT8rESiM9QvDQzBtCBvQ737E6Gr4o=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i1YGF-0002YH-4A; Sat, 24 Aug 2019 17:47:27 +0200
Date:   Sat, 24 Aug 2019 17:47:27 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH RFC net-next 3/3] net: dsa: implement ndo_set_netlink for
 chaning port's CPU port
Message-ID: <20190824154727.GC8251@lunn.ch>
References: <20190824024251.4542-1-marek.behun@nic.cz>
 <20190824024251.4542-4-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190824024251.4542-4-marek.behun@nic.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 24, 2019 at 04:42:50AM +0200, Marek Behún wrote:
> Implement ndo_set_iflink for DSA slave device. In multi-CPU port setup
> this should be used to change to which CPU destination port a given port
> should be connected.
> 
> This adds a new operation into the DSA switch operations structure,
> port_change_cpu_port. A driver implementing this function has the
> ability to change CPU destination port of a given port.
> 
> Signed-off-by: Marek Behún <marek.behun@nic.cz>
> ---
>  include/net/dsa.h |  6 ++++++
>  net/dsa/slave.c   | 35 +++++++++++++++++++++++++++++++++++
>  2 files changed, 41 insertions(+)
> 
> diff --git a/include/net/dsa.h b/include/net/dsa.h
> index 64bd70608f2f..4f3f0032b886 100644
> --- a/include/net/dsa.h
> +++ b/include/net/dsa.h
> @@ -545,6 +545,12 @@ struct dsa_switch_ops {
>  	 */
>  	netdev_tx_t (*port_deferred_xmit)(struct dsa_switch *ds, int port,
>  					  struct sk_buff *skb);
> +
> +	/*
> +	 * Multi-CPU port support
> +	 */
> +	int	(*port_change_cpu_port)(struct dsa_switch *ds, int port,
> +					struct dsa_port *new_cpu_dp);
>  };

Hi Marek

We need to see an actual implementation of this. We don't add new APIs
without having a user.

	Andrew
