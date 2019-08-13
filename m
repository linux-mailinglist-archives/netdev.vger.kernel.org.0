Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2BCB8C21E
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 22:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726143AbfHMUch (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 16:32:37 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58230 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726074AbfHMUch (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 16:32:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Wg2bfctEu9fBiOnrhmUEr8DBCB+BQ828eSLCdbeU+kE=; b=GDm+wgM5tBy7cVE/tNOqnSySkO
        Qe/i0GT6srLQnbBm28+qqhaOgzpR+3fUU7JVCjguNUtMmnS4cOW4LeXWbOfWqHA9y907WooHont54
        3s0DQUrxW/tOmLW36YN+XGJAd2z7XHgSMvmu+57sNoTzOuGKtTUHT+qIy2JQH7Kyo/fg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hxdT8-0004Xq-7d; Tue, 13 Aug 2019 22:32:34 +0200
Date:   Tue, 13 Aug 2019 22:32:34 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: check for mode change in
 port_setup_mac
Message-ID: <20190813203234.GO15047@lunn.ch>
References: <20190813171243.27898-1-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190813171243.27898-1-marek.behun@nic.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 13, 2019 at 07:12:43PM +0200, Marek Behún wrote:
> @@ -598,12 +599,49 @@ int mv88e6352_port_link_state(struct mv88e6xxx_chip *chip, int port,
>  			      struct phylink_link_state *state)
>  {
>  	int err;
> -	u16 reg;
> +	u16 reg, mac;
>  
>  	err = mv88e6xxx_port_read(chip, port, MV88E6XXX_PORT_STS, &reg);
>  	if (err)
>  		return err;

Hi Marek

It seems a bit off putting this block of code here, after reading
MV88E6XXX_PORT_STS but before using the value. You don't need STS to
determine the interface mode.

If you keep the code together, you can then reuse reg, rather than add
mac.

Apart from that, this looks O.K.

      Andrew
