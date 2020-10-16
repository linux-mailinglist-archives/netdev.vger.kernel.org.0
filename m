Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA4A290B2E
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 20:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391412AbgJPSNX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 14:13:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391119AbgJPSNW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Oct 2020 14:13:22 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A5A1C061755;
        Fri, 16 Oct 2020 11:13:22 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id lw21so4476759ejb.6;
        Fri, 16 Oct 2020 11:13:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=r2eEcxl1WbDutzStMHLO7WBfLc44P1ACvdEkn6Gclqo=;
        b=OAZGYxjvShsN0SaIa37bFN40bbWNM1BVy1MO+kZ2ddGFtux1U5bzIpeNYVVWQcsAku
         2G97QbvhM5NZYYylyqeMd/RppSkH3i4ImKypScBNUfCBraR1XqIXPl/57C33WRo5acmL
         YV0P3ni+GG/q8KMOpK4x+PY8qP5mQeTvA4WMavBULsvPL4Hq9SltxQJoNFkdIqrYp7LY
         PVagSDicbZpwbLgF3zYmtyerRnfcLFUdj6xcJ31Z6COJuj1FBS8Xg/8bjJ5c3svqc6Pl
         1emFryxAGXifbYn1Iw/gfcODDmXPWFJDwvvLmi9cPvjXvzymmsSIU9uBoT8EpLO/cPik
         9aMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=r2eEcxl1WbDutzStMHLO7WBfLc44P1ACvdEkn6Gclqo=;
        b=idN6hlJG8AB0q4/QUpwZVFREGQleLMxd5BT9YxMFSfJRM69EhViBzd8FQGfN6crvcS
         qnM8Z1w1MvCFhAftKrdRWQtoY4UquYkApCr5U7GiGtDlt/jbmP5g36ywzL8fExROA3Et
         6Zb5PNb84D1I1EVsJ4S/OTOqEWwdG91hWeDKtknRLefMuhWZ8vAFO6oEM9RNfnylMEHF
         bNX24lj53a00FZRgoWYgPPu3ZRMBVMmaHNE/K3Szblix5uJ257+5Jre0G5yvRADLVCtn
         G89mFQF+VRRV4DGbtysdJNSQ5JNSAsmKF7nz7UIPGf/h/AqKHDrmkIYxxlaZgzVzYSh6
         bW5w==
X-Gm-Message-State: AOAM532h26OXHQagNwrgB9+xo1hgxKpBjqmQuWPe4fUte8RcgC0RuYiG
        61H8pagvOoMIvMyPK8svbEA=
X-Google-Smtp-Source: ABdhPJzRPtPhAFMmdanwt1/S+wCq39//qSiiqbqWFHxzKJlJtRrTYMe+jM3DGcv1RwztQzw6tyAZHw==
X-Received: by 2002:a17:906:93ef:: with SMTP id yl15mr4776630ejb.529.1602872001094;
        Fri, 16 Oct 2020 11:13:21 -0700 (PDT)
Received: from skbuf ([188.26.174.215])
        by smtp.gmail.com with ESMTPSA id f25sm2183322edy.52.2020.10.16.11.13.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 11:13:20 -0700 (PDT)
Date:   Fri, 16 Oct 2020 21:13:19 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: dsa: ksz: fix padding size of skb
Message-ID: <20201016181319.2jrbdp5h7avzjczj@skbuf>
References: <20201014161719.30289-1-ceggers@arri.de>
 <4467366.g9nP7YU7d8@n95hx1g2>
 <20201016090527.tbzmjkraok5k7pwb@skbuf>
 <1655621.YBUmbkoM4d@n95hx1g2>
 <20201016155645.kmlehweenqdue6q2@skbuf>
 <20201016110311.6a43e10d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201016110311.6a43e10d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 16, 2020 at 11:03:11AM -0700, Jakub Kicinski wrote:
> On Fri, 16 Oct 2020 18:56:45 +0300 Vladimir Oltean wrote:
> > > 3. "Manually" unsharing in dsa_slave_xmit(), reserving enough tailroom
> > > for the tail tag (and ETH_ZLEN?). Would moving the "else" clause from
> > > ksz_common_xmit()  to dsa_slave_xmit() do the job correctly?  
> > 
> > I was thinking about something like that, indeed. DSA knows everything
> > about the tagger: its overhead, whether it's a tail tag or not. The xmit
> > callback of the tagger should only be there to populate the tag where it
> > needs to be. But reallocation, padding, etc etc, should all be dealt
> > with by the common DSA xmit procedure. We want the taggers to be simple
> > and reuse as much logic as possible, not to be bloated.
> 
> FWIW if you want to avoid the reallocs you may want to set
> needed_tailroom on the netdev.

Tell me more about that, I've been meaning since forever to try it out.
I read about needed_headroom and needed_tailroom, and it's one of the
reasons why I added the .tail_tag option in the DSA tagger (to
distinguish whether a switch needs headroom or tailroom), but I can't
figure out, just from static analysis of the code, where exactly is the
needed tailroom being accounted for. For example, if I'm in Christian's
situation, e.g. I have a packet smaller than ETH_ZLEN, would the
tailroom be enough to hold just the dev->needed_tailroom, or would there
be enough space in the skb for the entire ETH_ZLEN + dev->needed_tailroom?
