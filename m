Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF6801C06A3
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 21:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbgD3Tls (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 15:41:48 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34842 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726272AbgD3Tlr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 15:41:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=/yKT0kEu0twZ55Af42Shn8uTiSBnYYF/fmHd0lOTNu8=; b=20TN8wWq68SkMxcx43cLgoBSqs
        NMkSQUz6/2gFa2gCfR+AzLjdDJm0KZoACfixK1X1pn65gutZEHfHSgj+IrlahTNUvtR8Iku0DRqWF
        odLlJb8q3C+hg0ym5qDGUOOxSC2TOjP8fuKwMuuzXZhlae70MpVSNlNOZ1gDWm1Eh2Ns=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jUF43-000SJk-VA; Thu, 30 Apr 2020 21:41:43 +0200
Date:   Thu, 30 Apr 2020 21:41:43 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, cphealy@gmail.com,
        davem@davemloft.net, hkallweit1@gmail.com, mkubecek@suse.cz,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 0/9] Ethernet Cable test support
Message-ID: <20200430194143.GF107658@lunn.ch>
References: <20200425180621.1140452-1-andrew@lunn.ch>
 <20200429160213.21777-1-michael@walle.cc>
 <20200429163247.GC66424@lunn.ch>
 <c4363f2888192efc692e08cc1a4a9a57@walle.cc>
 <61eb35f8-3264-117d-59c2-22f0fdc36e96@gmail.com>
 <9caef9bbfaed5c75e72e083db8a552fd@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9caef9bbfaed5c75e72e083db8a552fd@walle.cc>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> ECD. The registers looks exactly like the one from the Marvell PHYs,
> which makes me wonder if both have the same building block or if one
> imitated the registers of the other. There are subtle differences
> like one bit in the broadcom PHY is "break link" and is self-clearing,
> while the bit on the Marvell PHY is described as "perform diagnostics
> on link break".

Should we be sharing code between the two drivers?

> What do you mean by calibrate it?

Some of the Marvell documentation talks about calibrating for losses
on the PCB. Run a diagnostics with no cable plugged in, and get the
cable length to the 'fault'. This gives you the distance to the RJ45
socket. You should then subtract that from all subsequent results.
But since this is board design specific, i decided to ignore it. I
suppose it could be stuffed into a DT property, but i got the feeling
it is not worth it, given the measurement granularity of 80cm.

   Andrew
