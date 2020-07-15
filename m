Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 386ED220CF4
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 14:34:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730932AbgGOMb6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 08:31:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726396AbgGOMb6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 08:31:58 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D587FC061755
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 05:31:57 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id rk21so1987456ejb.2
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 05:31:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oNg8WJVhP7eMuh7b5Spr4r/QZ4LZTbZbEWV0GjY1zgM=;
        b=p8Sy69UWYlg3jQzUkK+Vr0GsZHAIQgLVz4Hd289bQWrKZMimWCMDUzRCfgLqlOGZFN
         D431aiqlbFQJMtbXasdcAiZRxamraYVDyhie1dmIiG9FHaFccNjUJa9V8GZPadOhDrA+
         vkKU0Fkw9l/qNc0PmKG9+q6+upXdMRh5IvE66H+Juisw3mjKoTsXj2ZxTFQyFbJwVB2O
         aRYVJ2Q100baY7hPrcvZLkv3krQ/HfWRvOYoYvpNLNdFx2W988V8FTjHZa5hh4XfMdTD
         K+5GcgKDxe0cIAcIwFZO7Jji2cB4l1c30mugvyg2Isz5srwL3h23XxihBy9MQGN6cahn
         ra0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oNg8WJVhP7eMuh7b5Spr4r/QZ4LZTbZbEWV0GjY1zgM=;
        b=Q/h74AIjmID+IlD6GhB5RQFohI//mjP9PIAoTPL5Nm7Yg/LJ/3aRquoLOtWaC/x+iS
         GXQAXMiXtXPlnnhZS18MLv3e3/7Nmr9meTNc3iko38jv3QK2ZAWLsU3PAw0K+Y1ydMbn
         QeGDMP0pcl/amhx6NCinkT6DlQSGPsJzrhRWvFYiwuux8e/3AwFW9ZFe8xaFagTJ24p7
         bcDxxcnt7nlz3QVthEV6ekR1/XRsHomzDdTbR27w1SN5jKK2ufBVyBzzUNAkyclNTVyj
         fc8SvEitZ20pKQhMKGZkQoGffd3mCh1nZ73rtYSJ6ZzxH7r0VWNMZILKdGnXI8XBw0qq
         6TQg==
X-Gm-Message-State: AOAM532I2SFkw8ytdKov4LqOavJws8LQi8n/Lk3du2XEPT0SK6Dk5FKY
        wnHJWk1Ep3Wt1RvIZMIJqwk=
X-Google-Smtp-Source: ABdhPJwzJkxgwG+G8xmjgLhAgCJuqesJWFMshhinymSP+y1AOCVYzJtuPNKqKFH6v77QjKpyZg3Y7A==
X-Received: by 2002:a17:906:6606:: with SMTP id b6mr9431376ejp.102.1594816316483;
        Wed, 15 Jul 2020 05:31:56 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id n9sm2119026edr.46.2020.07.15.05.31.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2020 05:31:55 -0700 (PDT)
Date:   Wed, 15 Jul 2020 15:31:53 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "michael@walle.cc" <michael@walle.cc>, netdev@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH RFC net-next 00/13] Phylink PCS updates
Message-ID: <20200715123153.vvvnx6rwgzl5ejuo@skbuf>
References: <20200630142754.GC1551@shell.armlinux.org.uk>
 <20200714084958.to4n52cnk32prn4v@skbuf>
 <20200714131832.GC1551@shell.armlinux.org.uk>
 <20200714234652.w2pw3osynbuqw3m4@skbuf>
 <20200715112100.GG1551@shell.armlinux.org.uk>
 <20200715113441.GR1605@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200715113441.GR1605@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 15, 2020 at 12:21:01PM +0100, Russell King - ARM Linux admin wrote:
> On Wed, Jul 15, 2020 at 02:46:52AM +0300, Vladimir Oltean wrote:
> > By this I think you are aiming squarely at "[PATCH net-next v3 0/9] net:
> > ethernet backplane support on DPAA1". If I understand you correctly, you
> > are saying that because of the non-phylink models used to represent that
> > system comprised of a clause 49 PCS + clause 72 PMD + clause 73 AN/LT,
> > it is not worth pursuing this phylink-based representation of a clause
> > 37 PCS.
> 
> Actually, that is not what I was aiming that comment at - that is not
> something that has been posted recently.  I'm not going to explicitly
> point at a patch set.
> 

You are making it unnecessarily difficult to have a meaningful
conversation. I'm not going to guess about what patch set you were
talking about. I don't know of anything else that is using the phylib
state machine to drive a PCS than the backplane series. For the PCS
support in Felix/Seville/ENETC (and
drivers/net/ethernet/fman/fman_memac.c by the way), the struct
phy_device is just being used as a container, it is not driven by
phylib.

On Wed, Jul 15, 2020 at 12:34:41PM +0100, Russell King - ARM Linux admin wrote:
> I'm sorry Vladimir, I can't cope with these replies that take hours to
> write to your emails; it just takes up way too much time and interferes
> way too much, I'm going to have to go back to the short sharp replies
> out of necessity or just not reply.
> 
> Sorry.
> 

You know what the problem is here, I'm not given the option to "just not
reply" to you, and you don't seem to like my "short sharp replies"
either.

I'll be frank and state that the big problem I see with phylink is that
there's only one person who can ever be right about it, and that is you,
by definition. I have no mental image about what phylink really is
about, where does it start, where does it end, why does it even exist
and it's not just integrated with phylib. I used to be clear about the
part with SFPs, I'd read the documentation from a few years back when I
was trying to see whether the Lynx PCS is a good fit into phylink, and
it was so centered around MAC ops and a pluggable SFP, that to me, it
was absolutely clear that managing a standalone PCS was not something of
its concern. I would have felt like making "unauthorized modifications"
to it. Managing a standalone PCS could be shoehorned into the existing
ops, and that's exactly what I ended up doing, due to lack of the
greater vision that you have.

Yet, now not only are we talking about adding a standalone PCS layer to
phylink, but also about integrating some functionality which goes deeply
into PMA/PMD territory. I don't necessarily oppose (nor would I have the
power to, as mentioned in my preface), but you can't expect people to
sign up to something that they have no clear idea of what its role is,
not to mention the very volatile API which may not be to everybody's
taste when we're talking about old, stable drivers which support not
only new ARM parts, but also very old PowerPC parts.

The best you came with is that phylink gives you flexibility and
options, and sure it does, when you add a lot of stuff to it to make it
do that. But I don't want to know why phylink is an option, I want to
know why phylib isn't. Phylink is your creation, which as far as I'm
concerned stems out of the need to support more setups than phylib did,
and you took the route of working around phylib rather than extending
it. So, I would have expected an answer from you why phylib is not a
valid place for this.

Regards,
-Vladimir
