Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69562313341
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 14:29:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230080AbhBHN2w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 08:28:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbhBHN0m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 08:26:42 -0500
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E420C061786
        for <netdev@vger.kernel.org>; Mon,  8 Feb 2021 05:26:01 -0800 (PST)
Received: by mail-qt1-x82b.google.com with SMTP id h16so10206570qth.11
        for <netdev@vger.kernel.org>; Mon, 08 Feb 2021 05:26:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=S39i0FZOFQsc+cAhgm3xjI55JVBVfDAfy/d19m/tquM=;
        b=uJwf5U3FHDoBznDeWqi9jtBOY5bkPMoMlMt+O9yT3zYyej/h1NjRcToKJPmK3BFBmV
         dCVG6i25Ob5RPc0Bfr4TXobM5SJIvOjPDBvj8tbU/dFGbYp9Cpqc+i5Ca0kWGTE/fBEd
         rjUQbYGxs7tfOKqFkoabo7WDC8ZDGq5UeOj48pLOKXuwXfVnBQIzg6lhB1vCGPHJPZvH
         nZYj8dbIKGV7X+JB2/wVYUQQ6WLURijMvKElgA/tuN/SlARx5fRNqY7ecu75s6RZefE7
         ukvu9Ww7C3AwBJxNFeOi12BqnJPVEB/SXy/QShSDBUMcFcn0lbOcTK4NRgbG7Ac9G57w
         p6Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=S39i0FZOFQsc+cAhgm3xjI55JVBVfDAfy/d19m/tquM=;
        b=ZvkOlIaVtqmBShM6iT/rD5cGlhJr2WpGWnJAAcdbWxDV54REygOLqfMIeuoGpTvica
         +22VttrCV95G1tCobMzOQO5lax8EZUBd1X1j3dKK4KpK+skk01A4Mbhl9Cen/ghjx2gj
         IdpRHjopIwjYioWWEblMCcazegcZ9EBkEb5mkW3RLxO6EjIO5f29KNrUb36xyrd87fcz
         QZLl6aOJHvUXoXqhH2aKu2ZbomEWWDHXHpmSzvdhrm78b8m98y81QLbGt3LnHgOEcXwy
         6Z53/nP6KLNW2LC2bUkyzxNmZ+OJbbZqXPQKTRItA9c4f6GvMaUCSAIfkk1zB65qxgCz
         D9kA==
X-Gm-Message-State: AOAM5306SKf3tIhk9ztbHKaaJdQDk2sGmjtvtI6ovOGRbOMb+Vmkd2NS
        47bFKvvUBd7k34elyLinl58gK8ndNQ2CeQ==
X-Google-Smtp-Source: ABdhPJwL/794Tp4KCIGlcuG3n8w9ygGYDGjD4NWshziQiXxU423hBGzbACRlt9s5/sAT+8z5/90+zg==
X-Received: by 2002:ac8:1094:: with SMTP id a20mr15073775qtj.248.1612790760574;
        Mon, 08 Feb 2021 05:26:00 -0800 (PST)
Received: from horizon.localdomain ([177.220.174.167])
        by smtp.gmail.com with ESMTPSA id h8sm14210527qtm.5.2021.02.08.05.25.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 05:25:59 -0800 (PST)
Received: by horizon.localdomain (Postfix, from userid 1000)
        id 1DD45C13A6; Mon,  8 Feb 2021 10:25:57 -0300 (-03)
Date:   Mon, 8 Feb 2021 10:25:57 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [net-next V2 01/17] net/mlx5: E-Switch, Refactor setting source
 port
Message-ID: <20210208132557.GB2959@horizon.localdomain>
References: <20210206050240.48410-1-saeed@kernel.org>
 <20210206050240.48410-2-saeed@kernel.org>
 <20210206181335.GA2959@horizon.localdomain>
 <ygnhtuqngebi.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ygnhtuqngebi.fsf@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 08, 2021 at 10:21:21AM +0200, Vlad Buslov wrote:
> 
> On Sat 06 Feb 2021 at 20:13, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com> wrote:
> > Hi,
> >
> > I didn't receive the cover letter, so I'm replying on this one. :-)
> >
> > This is nice. One thing is not clear to me yet. From the samples on
> > the cover letter:
> >
> > $ tc -s filter show dev enp8s0f0_1 ingress
> > filter protocol ip pref 4 flower chain 0
> > filter protocol ip pref 4 flower chain 0 handle 0x1
> >   dst_mac 0a:40:bd:30:89:99
> >   src_mac ca:2e:a7:3f:f5:0f
> >   eth_type ipv4
> >   ip_tos 0/0x3
> >   ip_flags nofrag
> >   in_hw in_hw_count 1
> >         action order 1: tunnel_key  set
> >         src_ip 7.7.7.5
> >         dst_ip 7.7.7.1
> >         ...
> >
> > $ tc -s filter show dev vxlan_sys_4789 ingress
> > filter protocol ip pref 4 flower chain 0
> > filter protocol ip pref 4 flower chain 0 handle 0x1
> >   dst_mac ca:2e:a7:3f:f5:0f
> >   src_mac 0a:40:bd:30:89:99
> >   eth_type ipv4
> >   enc_dst_ip 7.7.7.5
> >   enc_src_ip 7.7.7.1
> >   enc_key_id 98
> >   enc_dst_port 4789
> >   enc_tos 0
> >   ...
> >
> > These operations imply that 7.7.7.5 is configured on some interface on
> > the host. Most likely the VF representor itself, as that aids with ARP
> > resolution. Is that so?
> >
> > Thanks,
> > Marcelo
> 
> Hi Marcelo,
> 
> The tunnel endpoint IP address is configured on VF that is represented
> by enp8s0f0_0 representor in example rules. The VF is on host.

That's interesting and odd. The VF would be isolated by a netns and
not be visible by whoever is administrating the VF representor. Some
cooperation between the two entities (host and container, say) is
needed then, right? Because the host needs to know the endpoint IP
address that the container will be using, and vice-versa. If so, why
not offload the tunnel actions via the VF itself and avoid this need
for cooperation? Container privileges maybe?

Thx,
Marcelo
