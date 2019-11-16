Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD3C7FF338
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 17:24:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728944AbfKPQY1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 11:24:27 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:43106 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728009AbfKPQY1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Nov 2019 11:24:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=SFhyujloYCxcxQxRnMBUe/bTruRZVqjzA/M++joUXC4=; b=iv4ketUMrG7UzhwZnjWqA58Edo
        8iPgcHYwr/72OrtCHcDczVQjtLItdHRN05K2JoG9Sol3gzOW5UirI5sQCbax2wIPdU3nu+e6FSbaD
        8ap2JNvMmkQVacuRCmUMfXXH22l1WwHD5vktST7nqgY1knyLKMSEPEwD5loS7iwHGZNQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iW0s4-00064z-I4; Sat, 16 Nov 2019 17:24:24 +0100
Date:   Sat, 16 Nov 2019 17:24:24 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: tag_8021q: Fix dsa_8021q_restore_pvid
 for an absent pvid
Message-ID: <20191116162424.GG5653@lunn.ch>
References: <20191116160842.29511-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191116160842.29511-1-olteanv@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 16, 2019 at 06:08:42PM +0200, Vladimir Oltean wrote:
> This sequence of operations:
> ip link set dev br0 type bridge vlan_filtering 1
> bridge vlan del dev swp2 vid 1
> ip link set dev br0 type bridge vlan_filtering 1
> ip link set dev br0 type bridge vlan_filtering 0

> --- a/net/dsa/tag_8021q.c
> +++ b/net/dsa/tag_8021q.c
> @@ -105,7 +105,7 @@ static int dsa_8021q_restore_pvid(struct dsa_switch *ds, int port)
>  	slave = dsa_to_port(ds, port)->slave;
>  
>  	err = br_vlan_get_pvid(slave, &pvid);
> -	if (err < 0)
> +	if (!pvid || err < 0)
>  		/* There is no pvid on the bridge for this port, which is
>  		 * perfectly valid. Nothing to restore, bye-bye!
>  		 */

This looks very similar to the previous patch. Some explanation would
be good. Did you send it for the wrong tree? Or are there really
different fixes for different trees?

Thanks
	Andrew
