Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7B729D4E9
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 19:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732515AbfHZR1T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 13:27:19 -0400
Received: from mail.nic.cz ([217.31.204.67]:33802 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729245AbfHZR1T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Aug 2019 13:27:19 -0400
Received: from localhost (unknown [172.20.6.135])
        by mail.nic.cz (Postfix) with ESMTPSA id 7DC5813FC6D;
        Mon, 26 Aug 2019 19:27:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1566840437; bh=tNC/XveRGJ4jFecscCL+GhPlRAEtTVsIssGimmdRZ9w=;
        h=Date:From:To;
        b=tps5KhgBM8L1fAs1bV0018Be20XuInbS7ZAilFWS0D82ptKF2e86ngNnndgwSH2xV
         neTAJl+6bg4Lgbtcu4i5naLF0Mq1fZnviHFcKlsUpLOni7/N+aTn9teCs5sFczVDDE
         X2m8aKVH105vvwv2K+FJzlefTkX5XJbqwrcHgASw=
Date:   Mon, 26 Aug 2019 19:27:17 +0200
From:   Marek Behun <marek.behun@nic.cz>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next v4 6/6] net: dsa: mv88e6xxx: fully support
 SERDES on Topaz family
Message-ID: <20190826192717.50738e37@nic.cz>
In-Reply-To: <20190826153830.GE2168@lunn.ch>
References: <20190826122109.20660-1-marek.behun@nic.cz>
        <20190826122109.20660-7-marek.behun@nic.cz>
        <20190826153830.GE2168@lunn.ch>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.100.3 at mail.nic.cz
X-Virus-Status: Clean
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,SHORTCIRCUIT
        shortcircuit=ham autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Aug 2019 17:38:30 +0200
Andrew Lunn <andrew@lunn.ch> wrote:

> > +static int mv88e6xxx_port_set_cmode(struct mv88e6xxx_chip *chip, int port,
> > +				    phy_interface_t mode, bool allow_over_2500,
> > +				    bool make_cmode_writable)  
> 
> I don't like these two parameters. The caller of this function can do
> the check for allow_over_2500 and error out before calling this.
> 
> Is make_cmode_writable something that could be done once at probe and
> then forgotten about? Or is it needed before every write? At least
> move it into the specific port_set_cmode() that requires it.

It can be done once at probe. At first I thought about doing this in
setup_errata, but this is not an erratum. So shall I create a new
method for this in chip operations structure? Something like
port_additional_setup() ?

Marek
