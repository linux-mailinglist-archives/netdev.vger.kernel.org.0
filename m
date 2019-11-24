Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8707810855E
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 23:43:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbfKXWn3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Nov 2019 17:43:29 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:54512 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726855AbfKXWn3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Nov 2019 17:43:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=A8kwyHEGiVOkYsRdP6Ypx4eZ4P3YO4AbBmVTN2SauVA=; b=WzcNPQr9kvOxudKKBwoTFS59cf
        SLwUe0Rr+84mghQM1JzgF/XxcgrOMlarxLpzlKMV7cH6Fj1n+LZwYiNidyQopL+jJX6NREf11VOLZ
        kvkR0uIEM9l69Gy9LFsmRyt2iRdlE4HuerEpwkc2Frrfx5OmbHEZaEhsEnIM51/KJaR4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iZ0bB-0005DR-CI; Sun, 24 Nov 2019 23:43:21 +0100
Date:   Sun, 24 Nov 2019 23:43:21 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 1/3] net: dsa: Configure the MTU for switch ports
Message-ID: <20191124224321.GC6009@lunn.ch>
References: <20191123194844.9508-1-olteanv@gmail.com>
 <20191123194844.9508-2-olteanv@gmail.com>
 <329f394b-9e6c-d3b0-dc3d-5e3707fa8dd7@gmail.com>
 <CA+h21hpcvGZavmSZK3KEjfKVDt6ySw2Fv42EVfp5HxbZoesSqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hpcvGZavmSZK3KEjfKVDt6ySw2Fv42EVfp5HxbZoesSqg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Correct. I was actually held back a bit while looking at Andrew's
> patch dc0fe7d47f9f ("net: dsa: Set the master device's MTU to account
> for DSA overheads") where he basically discarded errors, so that's the
> approach I took too (thinking that some DSA masters would not have ops
> for changing or reporting the MTU).

Ignoring errors is deliberate because some master interfaces just
worked without having to set the MTU. I was worried that some that
just worked did not implement MTU changes, so i could not error out.

And my experience when things did not work was mostly the MTU did not
matter, but MRU did. The MAC would send frames with a header, but not
receive them with the header. Setting the MTU actually seems to set
the MRU on most MACs.

But when you are thinking about jumbo frames, i would not ignore the
error. We do need to be sure the master interface can support jumbo,
and big enough jumbo to support the header.

    Andrew
