Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52FAD9BEAE
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 17:56:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727638AbfHXP4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Aug 2019 11:56:39 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57156 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726769AbfHXP4i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 24 Aug 2019 11:56:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=hTxP15quK0Fsei9TgN96TYGXtzGI9FKeO/CZALB5PvE=; b=J8RGZH42qEaKK8NyAP4iV0wvRO
        KO5GnOoQAg1oOmyKQJAEVzPOLo0h4eBE+R/EUKXhHbO/Fk9JX47kBxaUEzpnkm/+HKZLktuNYiRx9
        hkFWSa4CROdlTeBh6qVylT3jji1pCwKilYwQCl2bCtzaQY43oZtZm8MtDUiHovwswZNQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i1YP6-0002aZ-JH; Sat, 24 Aug 2019 17:56:36 +0200
Date:   Sat, 24 Aug 2019 17:56:36 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <marek.behun@nic.cz>,
        netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH RFC net-next 0/3] Multi-CPU DSA support
Message-ID: <20190824155636.GD8251@lunn.ch>
References: <20190824024251.4542-1-marek.behun@nic.cz>
 <CA+h21hpBKnueT0QrVDL=Hhcp9X0rnaPW8omxiegq4TkcQ18EVQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hpBKnueT0QrVDL=Hhcp9X0rnaPW8omxiegq4TkcQ18EVQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Will DSA assume that all CPU ports are equal in terms of tagging
> protocol abilities? There are switches where one of the CPU ports can
> do tagging and the other can't.

Hi Vladimir

Given the current definition of what a CPU port is, we have to assume
the port is using tags. Frames have to be directed out a specific
egress port, otherwise things like BPDU, PTP will break. You cannot
rely on MAC address learning.

> Is the static assignment between slave and CPU ports going to be the
> only use case? What about link aggregation? Flow steering perhaps?
> And like Andrew pointed out, how do you handle the receive case? What
> happens to flooded frames, will the switch send them to both CPU
> interfaces, and get received twice in Linux? How do you prevent that?

I expect bad things will happen if frames are flooded to multiple CPU
ports. For this to work, the whole switch design needs to support
multiple CPU ports. I doubt this will work on any old switch.

Having a host interface connected to a user port of the switch is a
completely different uses case, and not what this patchset is about.

	   Andrew
