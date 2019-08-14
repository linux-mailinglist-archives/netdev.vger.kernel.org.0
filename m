Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55E2C8D52C
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 15:42:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727654AbfHNNm2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 09:42:28 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60304 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726722AbfHNNm2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Aug 2019 09:42:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=8HT0JtmkVnzZlMshiz9GqWKaGG3K3WazbCjjINxj7aE=; b=YXYYa1Dg8+lSEoBd1xzYn58EdK
        2+r+L+GkbYZyPkpyiGgs82c5BTOHigkdb3aNCy/ckLi/YZBPn+fkULs0rW6dvzgN9amRbesWVWExi
        x3YahwUHslKZzLGyjljc0nqg/D/YgT8K6XM8zBnVJK5IdXA47NJScZxC9CezVbN7MBjY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hxtXl-0001Z1-1e; Wed, 14 Aug 2019 15:42:25 +0200
Date:   Wed, 14 Aug 2019 15:42:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Y.b. Lu" <yangbo.lu@nxp.com>
Cc:     "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH 3/3] ocelot_ace: fix action of trap
Message-ID: <20190814134225.GB5265@lunn.ch>
References: <20190812104827.5935-1-yangbo.lu@nxp.com>
 <20190812104827.5935-4-yangbo.lu@nxp.com>
 <20190812123147.6jjd3kocityxbvcg@lx-anielsen.microsemi.net>
 <VI1PR0401MB223773EB5884D65890BD68C0F8D20@VI1PR0401MB2237.eurprd04.prod.outlook.com>
 <20190813134236.GG15047@lunn.ch>
 <VI1PR0401MB2237D9358AA17400E72A776EF8AD0@VI1PR0401MB2237.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR0401MB2237D9358AA17400E72A776EF8AD0@VI1PR0401MB2237.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> [Y.b. Lu] PTP messages over Ethernet will use two multicast addresses.
> 01-80-C2-00-00-0E for peer delay messages.
> 01-1B-19-00-00-00 for other messages.
> 
> But only 01-80-C2-00-00-0E could be handled by hardware filter for BPDU frames (01-80-C2-00-00-0x).
> For PTP messages handling, trapping them to CPU through VCAP IS2 is the suggested way by Ocelot/Felix.
> 
> I have a question since you are experts.

There real expert is Richard Cochran <richardcochran@gmail.com>. He
implemented PTP support for the mv88e6xxx devices, maintains to core
code, and the linuxptp daemon. Any ptp support your post will be
reviewed by him.

> For other switches, whether they are always trapping PTP messages to CPU?

For the mv88e6xxx family, there is a per port bit which enabled
PTP. When enabled, PTP frames are recognised by the hardware and
forwarded to the CPU.

> Is there any common method in linux to configure switch to select
> trapping or just forwarding PTP messages?

The best answer to that is to look at other switch driver which
implement ptp. The ptp core expects a ptp_clock_info structure, and
one of its members is 'enable'.

    Andrew
