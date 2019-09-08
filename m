Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C320ACBB4
	for <lists+netdev@lfdr.de>; Sun,  8 Sep 2019 10:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727624AbfIHIzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Sep 2019 04:55:31 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34388 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727312AbfIHIzb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 8 Sep 2019 04:55:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=v8Al7Rh+JEBj821XAEzr1QcokAUcIrDBHR5gcw+vstw=; b=Mg1SDvaB2V2R+EJITASABHDNDX
        lzg1vsW1e+ucZ43gKnbNazwmWrgDeECw8HrFsiMxAseot6j6iXJdYtYZF2zv3oNSXBvUVTKId+HW8
        JZkqXLCmMJDNp2Boc/r/HGrdBZwzGPQMifGU3Vo12kOLmiqX7zLYDy6TEqC3p+0JWyyE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1i6syn-0007Uj-Dg; Sun, 08 Sep 2019 10:55:29 +0200
Date:   Sun, 8 Sep 2019 10:55:29 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vivien Didelot <vivien.didelot@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, f.fainelli@gmail.com
Subject: Re: [PATCH net-next 3/3] net: dsa: mv88e6xxx: add RXNFC support
Message-ID: <20190908085529.GB28580@lunn.ch>
References: <20190907200049.25273-1-vivien.didelot@gmail.com>
 <20190907200049.25273-4-vivien.didelot@gmail.com>
 <20190907203256.GA18741@lunn.ch>
 <20190907172510.GB27514@t480s.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190907172510.GB27514@t480s.localdomain>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 07, 2019 at 05:25:10PM -0400, Vivien Didelot wrote:
> Hi Andrew,
> 
> On Sat, 7 Sep 2019 22:32:56 +0200, Andrew Lunn <andrew@lunn.ch> wrote:
> > > +	policy = devm_kzalloc(chip->dev, sizeof(*policy), GFP_KERNEL);
> > > +	if (!policy)
> > > +		return -ENOMEM;
> > 
> > I think this might be the first time we have done dynamic memory
> > allocation in the mv88e6xxx driver. It might even be a first for a DSA
> > driver?
> > 
> > I'm not saying it is wrong, but maybe we should discuss it. 
> > 
> > I assume you are doing this because the ATU entry itself is not
> > sufficient?
> > 
> > How much memory is involved here, worst case? I assume one struct
> > mv88e6xxx_policy per ATU entry? Which you think is too much to
> > allocate as part of chip? I guess most users will never use this
> > feature, so for most users it would be wasted memory. So i do see the
> > point for dynamically allocating it.
> 
> A layer 2 policy is not limited to the ATU. It can also be based on a VTU
> entry, on the port's Etype, or frame's Etype. We can have 0, 1 or literally
> thousands of policies programmed by the user.

O.K, then it has to by dynamic memory.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
