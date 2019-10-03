Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58866CAEE4
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 21:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732909AbfJCTJN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 15:09:13 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59918 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730529AbfJCTJK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Oct 2019 15:09:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=xpke1F9xXLvj/x9WDsqkKBjK5Xrrl7763bEdSHdX8Vo=; b=0R9mMRSZHXd+f2FfY359K8mx//
        SJ4QGkADs+xfdTbzQgvu5BrwUwot9ami62MeghNv8xxUSwEW+laYhitn/6QLnSdqeQkekqA1KDRpQ
        PypLVOSHVaS8DJj8DYCnqUIeZK3RGGiGWj29wGEl/sxDkjPeZktAsOy5Ennzb9oNcy2A=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iG6TL-00061p-Ja; Thu, 03 Oct 2019 21:09:07 +0200
Date:   Thu, 3 Oct 2019 21:09:07 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     olteanv@gmail.com, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: Allow port mirroring to the CPU port
Message-ID: <20191003190907.GC21875@lunn.ch>
References: <20191002233750.13566-1-olteanv@gmail.com>
 <20191003.120457.1626857609490915856.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191003.120457.1626857609490915856.davem@davemloft.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 03, 2019 at 12:04:57PM -0700, David Miller wrote:
> From: Vladimir Oltean <olteanv@gmail.com>
> Date: Thu,  3 Oct 2019 02:37:50 +0300
> 
> > On a regular netdev, putting it in promiscuous mode means receiving all
> > traffic passing through it, whether or not it was destined to its MAC
> > address. Then monitoring applications such as tcpdump can see all
> > traffic transiting it.
> > 
> > On Ethernet switches, clearly all ports are in promiscuous mode by
> > definition, since they accept frames destined to any MAC address.
> > However tcpdump does not capture all frames transiting switch ports,
> > only the ones destined to, or originating from the CPU port.
> > 
> > To be able to monitor frames with tcpdump on the CPU port, extend the tc
> > matchall classifier and mirred action to support the DSA master port as
> > a possible mirror target.
> > 
> > Tested with:
> > tc qdisc add dev swp2 clsact
> > tc filter add dev swp2 ingress matchall skip_sw \
> > 	action mirred egress mirror dev eth2
> > tcpdump -i swp2
> > 
> > Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> 
> Andrew and co., please review.

Yes, i thinking about this. Not reached a conclusion yet.

     Andrew
