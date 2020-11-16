Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 305FE2B5070
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 19:59:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728238AbgKPS7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 13:59:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725879AbgKPS7X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 13:59:23 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 338B9C0613CF;
        Mon, 16 Nov 2020 10:59:23 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id oq3so25920048ejb.7;
        Mon, 16 Nov 2020 10:59:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PQX0+/2jm2WPhyg/O+Sa2ph8IDUqkD+pF2wWi8FvKXg=;
        b=KG7JwzbjZcLfmysFvhJ6fUNI3p+2zk0k08DnQjsh422vklux1ATXCm1TALWOIL4Tsd
         R8eJsNCmxBHk6LNx95WF6Z7mDKmrsB2rguF0CO89s88/rhx/nk8Ow/cjuDeu8gldbl27
         jACYC6Gg2ITzvrE4py9OHz2TE+Op9cq9rtGAakSXu466QthwzXUfIcsyCieL6xTZWrdE
         ZzIIGuXzYCDjh5FDjAvmDNkSPceqndZzu+CCeW60aKcmQNF6sNFxl2x+cAie3TL/N/uo
         OfQ9jf/fWH2CSJBDnd68N+AycP7PxBCoRR4qpEQyPUnNhhqNJ0yJsTztBQrcGcirMU+L
         r5XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PQX0+/2jm2WPhyg/O+Sa2ph8IDUqkD+pF2wWi8FvKXg=;
        b=D5EWt7uY5VgUKI8B+EU4anPC839QRgavUrrBARBX//8Z513gBstds92Hzq7jDJSar4
         shDqfDGGmW/gW0MFqLSr8qRnAIL+UWMyhpJ+Z5Hxcf+kpWUYmLPCe87MDYdqnWD2Y7mU
         OEB+5JGzoLusJrL+/ZUKxLF7clURjgRSpED0FgAY0V5NnlkC+OeMAeA7iLxOXqPfoCkP
         Io+hnPwBT/Yz2BlVa/2P91Xb0uLLMjs3gIJYNlOlIBBDj2pEIVUu+7Hipu73wF0RYSoj
         +y7Yhfko4Wq/AlmpV1i9PqMkWZQkYlCfZS/DAHDFCoS6uwlhBsLLn8l33DcNtzkC6JED
         ikgQ==
X-Gm-Message-State: AOAM530dn4v83Y9CSE2B3JD1M/LVfKwqhmp+XQ7ZreTTkCfUeDBwVY3d
        dL2xI+kpgXdm90hxA5IMrqE=
X-Google-Smtp-Source: ABdhPJxS20smAlBBvg2X22JFkyvGXLbP6DnAIQmnhLFBphRtKXBZdW1A1FhIIkTg6eZfn4meOlxONg==
X-Received: by 2002:a17:906:3daa:: with SMTP id y10mr15539426ejh.23.1605553161870;
        Mon, 16 Nov 2020 10:59:21 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id z18sm10825331ejf.41.2020.11.16.10.59.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 10:59:21 -0800 (PST)
Date:   Mon, 16 Nov 2020 20:59:19 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Sekhar Nori <nsekhar@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH net-next 3/3] net: ethernet: ti: am65-cpsw: enable
 broadcast/multicast rate limit support
Message-ID: <20201116185919.qwaklquxhhhtqttg@skbuf>
References: <20201114035654.32658-1-grygorii.strashko@ti.com>
 <20201114035654.32658-4-grygorii.strashko@ti.com>
 <20201114191723.rvmhyrqinkhdjtpr@skbuf>
 <e9f2b153-d467-15fd-bd4a-601211601fca@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9f2b153-d467-15fd-bd4a-601211601fca@ti.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 16, 2020 at 08:39:54PM +0200, Grygorii Strashko wrote:
> 
> 
> On 14/11/2020 21:17, Vladimir Oltean wrote:
> > On Sat, Nov 14, 2020 at 05:56:54AM +0200, Grygorii Strashko wrote:
> > > This patch enables support for ingress broadcast(BC)/multicast(MC) rate limiting
> > > in TI AM65x CPSW driver (the corresponding ALE support was added in previous
> > > patch) by implementing HW offload for simple tc-flower policer with matches
> > > on dst_mac:
> > >   - ff:ff:ff:ff:ff:ff has to be used for BC rate limiting
> > >   - 01:00:00:00:00:00 fixed value has to be used for MC rate limiting
> > > 
> > > Hence tc policer defines rate limit in terms of bits per second, but the
> > > ALE supports limiting in terms of packets per second - the rate limit
> > > bits/sec is converted to number of packets per second assuming minimum
> > > Ethernet packet size ETH_ZLEN=60 bytes.
> > > 
> > > Examples:
> > > - BC rate limit to 1000pps:
> > >    tc qdisc add dev eth0 clsact
> > >    tc filter add dev eth0 ingress flower skip_sw dst_mac ff:ff:ff:ff:ff:ff \
> > >    action police rate 480kbit burst 64k
> > > 
> > >    rate 480kbit - 1000pps * 60 bytes * 8, burst - not used.
> > > 
> > > - MC rate limit to 20000pps:
> > >    tc qdisc add dev eth0 clsact
> > >    tc filter add dev eth0 ingress flower skip_sw dst_mac 01:00:00:00:00:00 \
> > >    action police rate 9600kbit burst 64k
> > > 
> > >    rate 9600kbit - 20000pps * 60 bytes * 8, burst - not used.
> > > 
> > > Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> > > ---
> > 
> > I understand this is unpleasant feedback, but don't you want to extend
> > tc-police to have an option to rate-limit based on packet count and not
> > based on byte count?
> 
> Huh.
> I'd be appreciated if you could provide more detailed opinion of how it can look like?
> Sry, it's my first experience with tc.

Same as above, just in packets per second.

tc qdisc add dev eth0 clsact
tc filter add dev eth0 ingress flower skip_sw \
	dst_mac 01:00:00:00:00:00/01:00:00:00:00:00 \
	action police rate 20kpps

> > The assumption you make in the driver that the
> > packets are all going to be minimum-sized is not a great one.
> > I can
> > imagine that the user's policer budget is vastly exceeded if they enable
> > jumbo frames and they put a policer at 9.6 Mbps, and this is not at all
> > according to their expectation. 20Kpps assuming 60 bytes per packet
> > might be 9.6 Mbps, and the user will assume this bandwidth profile is
> > not exceeded, that's the whole point. But 20Kpps assuming 9KB per packet
> > is 1.44Gbps. Weird.
> 
> Sry, not sure I completely understood above. This is specific HW feature, which can
> imit packet rate only. And it is expected to be applied by admin who know what he is doing.

Yes but you're not helping the admin to "know what he's doing" if you're
asking them to translate apples into oranges. A policer that counts
packets is not equivalent to a policer that counts bytes, unless all
packets are guaranteed to be of equal length, something which you cannot
ensure.

> The main purpose is to preserve CPU resource, which first of all affected by packet rate.
> So, I see it as not "assumption", but requirement/agreement which will be reflected
> in docs and works for a specific use case which is determined by presence of:
>  - skip_sw flag
>  - specific dst_mac/dst_mac_mask pair
> in which case rate determines pps and not K/Mbps.
> 
> 
> Also some ref on previous discussion [1] [2]
> [1] https://www.spinics.net/lists/netdev/msg494630.html
> [2] https://lore.kernel.org/patchwork/patch/481285/

ethtool coalescing as a tool to configure a policer makes zero sense.

You are definitely on the right path with the tc-police action. This was
just trying to be constructive feedback that the software implementation
of tc-police needs more work before your hardware could offload its job
in a way that would not violate its semantics.
