Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4C5F46C96B
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 01:40:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232038AbhLHAo1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 19:44:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231938AbhLHAo0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 19:44:26 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 423D0C061574;
        Tue,  7 Dec 2021 16:40:55 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id e3so2643342edu.4;
        Tue, 07 Dec 2021 16:40:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=31Aoj3CFgC05sFiwjVAL/h210njoeMnIKov2fNCBz6U=;
        b=RMsc+uTYk4yYNmQeeiSVquMjWJr3N/8Lb+mPD3k1BQIgarar0EkPWa8icK8IGIgq9d
         M3TNqrqPJkRIVlypvwu1lenbuhpiWy8hAEAyPt9egKwwL6ZNC6FSGH1hfclf5hNzKTgo
         O7WqGVzxLlWl+uVB0A7eUugJPOFbWf06aqiYHk2TFoWtnM0DSuxRcxKb4O3Jd22Ww0Pe
         acasBcANkbajGp9ulVQ+kzkU+GXhzYx9TPsXMd9pKC2+8MiMdbkplOXQhsewTOHO/Rtz
         et0MtpL0nQLDVzJHIOa4Ntiy0EMpSQyBGw0Cz1I8GKppVWFc1JGjHENF+qGv2wkP6U3s
         jCWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=31Aoj3CFgC05sFiwjVAL/h210njoeMnIKov2fNCBz6U=;
        b=eA611rzAwt6vwUuy+UjRSAOgAQZlWsorbGxOC1UT3rOtVjZulQfg6cJfGl3nEmciZN
         +e0gCm09gRDPv23pTNWG/D6P1V+bKOJoovNa5AuVfKdJp4XB7k1gEG05b+/CQydgncE6
         LyMdtt4cioa4FefWWG6VWBZEeNJt27aifpxnNpllQqXRbRc7sSIQYnhms0kKe+DV5LBN
         7ygr9TDs6n05FzjMBPoLkhfekoO+kthcwYxLWTn+XW3957gTbdLalE06duhk15n0R59a
         zKMtUbTCRNKfa0OGOloPzoD+ea7VTRnt0IyNJqr1+mMNdP42vGFu3TUnsj815uZ+364n
         QeVw==
X-Gm-Message-State: AOAM5304/hxO8Feq3E+uzF/h0i79EkBxUh9u51TLjN1atYkAuCoFSdk4
        q3bni1CL0I8M/yb9p99bfU1o4UzN64k=
X-Google-Smtp-Source: ABdhPJx6AKiKXv9+1E1M+useROVMyvRp/LjF3jxb5ecOX+Yvb0HuIKwGgJknPiEU+k1IfeY3rC++Lw==
X-Received: by 2002:a05:6402:2551:: with SMTP id l17mr14544241edb.142.1638924053788;
        Tue, 07 Dec 2021 16:40:53 -0800 (PST)
Received: from skbuf ([188.25.173.50])
        by smtp.gmail.com with ESMTPSA id t7sm842790edi.90.2021.12.07.16.40.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 16:40:53 -0800 (PST)
Date:   Wed, 8 Dec 2021 02:40:51 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [net-next RFC PATCH 0/6] Add support for qca8k mdio rw in
 Ethernet packet
Message-ID: <20211208004051.bx5u7rnpxxt2yqwc@skbuf>
References: <20211207145942.7444-1-ansuelsmth@gmail.com>
 <Ya+q02HlWsHMYyAe@lunn.ch>
 <61afadb9.1c69fb81.7dfad.19b1@mx.google.com>
 <Ya+yzNDMorw4X9CT@lunn.ch>
 <61afb452.1c69fb81.18c6f.242e@mx.google.com>
 <20211207205219.4eoygea6gey4iurp@skbuf>
 <61afd6a1.1c69fb81.3281e.5fff@mx.google.com>
 <Ya/esX+GTet9PM+D@lunn.ch>
 <20211207234736.vpqurmattqx4a76h@skbuf>
 <20211208000432.5nq47bjz3aqjvilp@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211208000432.5nq47bjz3aqjvilp@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 08, 2021 at 02:04:32AM +0200, Vladimir Oltean wrote:
> On Wed, Dec 08, 2021 at 01:47:36AM +0200, Vladimir Oltean wrote:
> > > 2) is harder. But as far as i know, we have an 1:N setup.  One switch
> > > driver can use N tag drivers. So we need the switch driver to be sure
> > > the tag driver is what it expects. We keep the shared state in the tag
> > > driver, so it always has valid data, but when the switch driver wants
> > > to get a pointer to it, it needs to pass a enum dsa_tag_protocol and
> > > if it does not match, the core should return -EINVAL or similar.
> > 
> > In my proposal, the tagger will allocate the memory from its side of the
> > ->connect() call. So regardless of whether the switch driver side
> > connects or not, the memory inside dp->priv is there for the tagger to
> > use. The switch can access it or it can ignore it.
> 
> I don't think I actually said something useful here.
> 
> The goal would be to minimize use of dp->priv inside the switch driver,
> outside of the actual ->connect() / ->disconnect() calls.
> For example, in the felix driver which supports two tagging protocol
> drivers, I think these two methods would be enough, and they would
> replace the current felix_port_setup_tagger_data() and
> felix_port_teardown_tagger_data() calls.
> 
> An additional benefit would be that in ->connect() and ->disconnect() we
> get the actual tagging protocol in use. Currently the felix driver lacks
> there, because felix_port_setup_tagger_data() just sets dp->priv up
> unconditionally for the ocelot-8021q tagging protocol (luckily the
> normal ocelot tagger doesn't need dp->priv).
> 
> In sja1105 the story is a bit longer, but I believe that can also be
> cleaned up to stay within the confines of ->connect()/->disconnect().
> 
> So I guess we just need to be careful and push back against dubious use
> during review.

I've started working on a prototype for converting sja1105 to this model.
It should be clearer to me by tomorrow whether there is anything missing
from this proposal.
