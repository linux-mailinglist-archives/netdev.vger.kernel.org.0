Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9743D19834B
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 20:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728000AbgC3SXN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 14:23:13 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39202 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726769AbgC3SXN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 14:23:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=tRXZWFACkrjWHbs9/7+DMImrP7M1Z/RgHuG2NjGyaT4=; b=cSzctKGDzktAnG6Fj+1tRqQO9D
        S5gajsHfeSC3HlkbfwwX5kf41usOvO1VBoj6haJdXnfViqQZECcxqHzyDs8/9VLEUaK+gf/IDJBgx
        MaisukI0Ktbm4LzpoF/z9vGvkvLZqWPkyQ/8IuDbVilJc3odSbY2TWjeBuA4DS8iQI0w=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jIz3z-00070l-Py; Mon, 30 Mar 2020 20:23:07 +0200
Date:   Mon, 30 Mar 2020 20:23:07 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Daniel Mack <daniel@zonque.org>
Cc:     vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH] net: dsa: mv88e6xxx: don't force settings on CPU port
Message-ID: <20200330182307.GG23477@lunn.ch>
References: <20200327195156.1728163-1-daniel@zonque.org>
 <20200327200153.GR3819@lunn.ch>
 <d101df30-5a9e-eac1-94b0-f171dbcd5b88@zonque.org>
 <20200327211821.GT3819@lunn.ch>
 <1bff1da3-8c9d-55c6-3408-3ae1c3943041@zonque.org>
 <20200327235220.GV3819@lunn.ch>
 <64462bcf-6c0c-af4f-19f4-d203daeabec3@zonque.org>
 <20200330134010.GA23477@lunn.ch>
 <7a777bc3-9109-153a-a735-e36718c06db5@zonque.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7a777bc3-9109-153a-a735-e36718c06db5@zonque.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 30, 2020 at 08:04:08PM +0200, Daniel Mack wrote:
> Hi Andrew,
> 
> Thanks for all your input.
> 
> On 3/30/20 3:40 PM, Andrew Lunn wrote:
> > On Mon, Mar 30, 2020 at 11:29:27AM +0200, Daniel Mack wrote:
> >> On 3/28/20 12:52 AM, Andrew Lunn wrote:
> 
> >>> By explicitly saying there is a PHY for the CPU node, phylink might
> >>> drive it.
> > 
> > You want to debug this. Although what you have is unusual, yours is
> > not the only board. It is something we want to work. And ideally,
> > there should be something controlling the PHY.
> 
> I agree, but what I believe is happening here is this. The PHY inside
> the switch negotiates a link to the 'external' PHY which is forced to
> 100M maximum speed. That link seems to work fine; the LEDs connected to
> that external PHY indicate that there is link. However, the internal PHY
> in the switch does not receive any packets as the MAC connected to it
> only wants to communicate with 1G.

Which is what phylink is all about. phylink will talk to the PHY,
figure out what it has negotiated, and then configure the MAC to
fit. So you need to debug why this is not happening.

       Andrew
