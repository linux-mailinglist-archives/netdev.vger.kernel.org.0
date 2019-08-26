Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4269A9D2E9
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 17:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732560AbfHZPic (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 11:38:32 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60042 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729289AbfHZPic (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Aug 2019 11:38:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=mDrN8NdOTnLJWML+1YxOgBhpbjjc6ApOtPOdDnQgF3Q=; b=g0+/FOslRyT3tGCK5xEMUg7ABM
        s4pRCbh+2Ckt09sdOcBoYDWuaGmXaXjwAWq5IBCOfdiLA/QcHxcZ/A1mgfsq53w897rmLube2EzOf
        R9CgVsruW2N5iF+ltGTcgbc7fgOPd9EEixDYoKWlTAJoCyst5UXrPbbwoThyP7SdG6yg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i2H4g-0004fR-At; Mon, 26 Aug 2019 17:38:30 +0200
Date:   Mon, 26 Aug 2019 17:38:30 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next v4 6/6] net: dsa: mv88e6xxx: fully support
 SERDES on Topaz family
Message-ID: <20190826153830.GE2168@lunn.ch>
References: <20190826122109.20660-1-marek.behun@nic.cz>
 <20190826122109.20660-7-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190826122109.20660-7-marek.behun@nic.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int mv88e6xxx_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
> +				    phy_interface_t mode, bool allow_over_2500,
> +				    bool make_cmode_writable)

I don't like these two parameters. The caller of this function can do
the check for allow_over_2500 and error out before calling this.

Is make_cmode_writable something that could be done once at probe and
then forgotten about? Or is it needed before every write? At least
move it into the specific port_set_cmode() that requires it.

Thanks
	Andrew
