Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D14F52B8396
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 19:06:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbgKRSFD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 13:05:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726158AbgKRSFD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 13:05:03 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20A3CC0613D4
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 10:05:00 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id dk16so3995056ejb.12
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 10:05:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Es+KCsKr631O+jEboOS1r1tXnQkI6kGev2cNUD1mU9o=;
        b=Xe+jlqvwJ5yFwXrh1PIbHVDY3fXIpqHP5R/iDXxygVhWB2LkCxNNmy6Vigk348oxPc
         kY0nxh1d90+UTrP0LxeChQdVfHq99S3PNF3kiO3u/dTlvixbXLkeHVFCBgKA8GaX/ubv
         BEe09znKmj4JaOD64JxtzOnGie8HrnV2v/W1A7cREq5qj3teteRyXluobC4ipp8nfBVQ
         94u4jow2x1jjGhofYN+ZrBQTU4KsYJy8EXZYqCAVrxG8spRRtmSfhGdvQH6J36pHR3/I
         uQhDI1pWbhbovFK0AT3rx+erHhbICIORUWPLW4evtm3fb/1xKANVj0NL9p9j8t5SVjSY
         MYzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Es+KCsKr631O+jEboOS1r1tXnQkI6kGev2cNUD1mU9o=;
        b=JW/A3vgkhONGyaIJGbM0rWZO9n+LJgxpXvgt4Z0J3NhTSWVYRzOVOTHMsXf+Ri3XK/
         FyVoy1PpjKQTGMXdf77mSrmd8Tw9KX+Z6VkXHmxMNtv4JF/B329FJ8W6lLc9+ozpn0kn
         My5dP9X+wz6TXlXPbjFX9PkPeCeD+iZKKgN3lfNncFkDyr6+PUqUuqqumyz/1u3KjFCe
         zUFmlvq3xwmPfal9nsD9qkHM2VHQBoqh2IJSxXcVJfngO8ffsFJb8WIpEzlbSG85VJ8y
         etb0zBjKLSJvIerm8p2i0FPeeVLckh6LgsmqAdo9lQX2Am96KyQUDtamL3SahaaQOryx
         enWw==
X-Gm-Message-State: AOAM530khB2deQdtBI/otcjad56QwO1EG6xJ2UpCGv3yFegpSQCCArOb
        A0GRbGakp8kqsjG0JsJD46TKOB9BNRs=
X-Google-Smtp-Source: ABdhPJww7yKrR/wkrgmS5jhh2Q+mNJayo2gg4I7lnhD60aRLxGEF5q8ZHR3VyJlSMN7EAFohAWNhlg==
X-Received: by 2002:a17:906:e082:: with SMTP id gh2mr13077556ejb.406.1605722698604;
        Wed, 18 Nov 2020 10:04:58 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id fy4sm2127932ejb.91.2020.11.18.10.04.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2020 10:04:57 -0800 (PST)
Date:   Wed, 18 Nov 2020 20:04:54 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net] enetc: Workaround for MDIO register access issue
Message-ID: <20201118180454.b3cxrkc4zqvwquln@skbuf>
References: <20201112182608.26177-1-claudiu.manoil@nxp.com>
 <20201117024450.GH1752213@lunn.ch>
 <AM0PR04MB6754D77454B6DA79FB59917896E20@AM0PR04MB6754.eurprd04.prod.outlook.com>
 <20201118133856.GC1804098@lunn.ch>
 <20201118170044.57jlk42gjht3gd74@skbuf>
 <20201118090343.7bbf0047@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201118090343.7bbf0047@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 18, 2020 at 09:03:43AM -0800, Jakub Kicinski wrote:
> On Wed, 18 Nov 2020 19:00:44 +0200 Vladimir Oltean wrote:
> > On Wed, Nov 18, 2020 at 02:38:56PM +0100, Andrew Lunn wrote:
> > > Thanks for the explanation. I don't think i've every reviewed a driver
> > > using read/write locks like this. But thinking it through, it does
> > > seem O.K.
> >
> > Thanks for reviewing and getting this merged. It sure is helpful to not
> > have the link flap while running iperf3 or other intensive network
> > activity.
> >
> > Even if this use of rwlocks may seem unconventional, I think it is the
> > right tool for working around the hardware bug.
>
> Out of curiosity - did you measure the performance hit?

It's not something that is noticeable, at least on 1Gbps where I'm
testing now. I'm not even sure what a valid metric would be. The CPU
utilization is about the same, the throughput across a 100 second iperf3
TCP test is the same (942 Mbits/sec at sender), and when I look at the
perf events for CPU cycles I get the feeling that any variation there is
mostly noise. There doesn't seem to be any outlier.

I might come back to this when I submit some hardware bug workarounds of
my own, for the 2.5Gbps ENETC that acts as a DSA master for the Ocelot
switch. There, I have a chance of testing at 2.5Gbps. But I don't have
that set up right now.
