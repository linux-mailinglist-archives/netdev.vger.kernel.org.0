Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2252C7928
	for <lists+netdev@lfdr.de>; Sun, 29 Nov 2020 13:59:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387425AbgK2Mzv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 07:55:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33534 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387411AbgK2Mzu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Nov 2020 07:55:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606654463;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OAs0QprAi5upVS4LT4g9p8PMHWkpx1Iz7UfKX3Wfsi8=;
        b=BvEvnk2WQf38kS3rP7oCCss1Zwd9xhjeYVO4BlRzrm2GFch0FZpIoYXtCF5N+SBN6RZgQs
        m0v5Sjdz/xyqSX3lCEnRO8SH32/8B9oSuYzceeJljPVMip/D9zIcRw/7zwwJPhrXlCeqyl
        Dq+LsGChXURO+ssSO28r/vhoY904MUg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-99-v7tygVY7OgO_u2d1fTsfkQ-1; Sun, 29 Nov 2020 07:54:21 -0500
X-MC-Unique: v7tygVY7OgO_u2d1fTsfkQ-1
Received: by mail-wm1-f70.google.com with SMTP id o17so5739614wmd.9
        for <netdev@vger.kernel.org>; Sun, 29 Nov 2020 04:54:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OAs0QprAi5upVS4LT4g9p8PMHWkpx1Iz7UfKX3Wfsi8=;
        b=jDbCFhUHArC5M+TzTaheOBXVmIEC7HtkRC1iGQV1GopHUu+C9Rr/SsucGUeBOP9U+l
         eLxa5Nolbz0SedqV7QyjCg/3K80ovDxwczUAXBkhAUadTbAwGxR26W5xUTNwJl3MBZZu
         ZhuqB7DMOOOhsB0SVfpc0n2MTMtmmJIZbtqfwQwvM+4+1amtUmTWcEuBCooDFvsZKoMN
         S6UNx6yk8W6fzDQMAu7wZHMEntj+7f7HoQ4RvE/DZNQMuqqaE0onRSG+T/rk7LWbuV7R
         xBq2AjeEAyHBVTuPfl5nMjtlD6Z231p5GUahVpMqiBOODI+ic71ec6nMentrURZq9xme
         fK/g==
X-Gm-Message-State: AOAM533L/n859iulS7O5zvDRjdc3qytKqby916Kfkv+EydrBkCRUE8kW
        lra4GPmjwKaGgrkn/Z+TGPhKSstlhLp+N3MdKvnpNkr+/0kE3ZazYmiTylxgsKeuQtXXIWsRTnL
        GeZ6JeDTvzE9o8Nho
X-Received: by 2002:a1c:7dd8:: with SMTP id y207mr11652119wmc.181.1606654460069;
        Sun, 29 Nov 2020 04:54:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyz3pGYkOtdMzePzpaqT8QABpNgtDPDIDA38lV7TnWLBOqjWxoUueQFU20VYYjWcsLzDcHc4A==
X-Received: by 2002:a1c:7dd8:: with SMTP id y207mr11652110wmc.181.1606654459884;
        Sun, 29 Nov 2020 04:54:19 -0800 (PST)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id b73sm37428939wmb.0.2020.11.29.04.54.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Nov 2020 04:54:18 -0800 (PST)
Date:   Sun, 29 Nov 2020 13:54:16 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@gmail.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Russell Strong <russell@strong.id.au>
Subject: Re: [PATCH net] ipv4: Fix tos mask in inet_rtm_getroute()
Message-ID: <20201129125416.GA28479@linux.home>
References: <b2d237d08317ca55926add9654a48409ac1b8f5b.1606412894.git.gnault@redhat.com>
 <ace2daed-7d88-7364-5395-80b63f59ffc1@gmail.com>
 <20201128131716.783ff3dd@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201128131716.783ff3dd@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 28, 2020 at 01:17:16PM -0800, Jakub Kicinski wrote:
> On Sat, 28 Nov 2020 10:03:42 -0700 David Ahern wrote:
> > On 11/26/20 11:09 AM, Guillaume Nault wrote:
> > > When inet_rtm_getroute() was converted to use the RCU variants of
> > > ip_route_input() and ip_route_output_key(), the TOS parameters
> > > stopped being masked with IPTOS_RT_MASK before doing the route lookup.
> > > 
> > > As a result, "ip route get" can return a different route than what
> > > would be used when sending real packets.
> > > 
> > > For example:
> > > 
> > >     $ ip route add 192.0.2.11/32 dev eth0
> > >     $ ip route add unreachable 192.0.2.11/32 tos 2
> > >     $ ip route get 192.0.2.11 tos 2
> > >     RTNETLINK answers: No route to host
> > > 
> > > But, packets with TOS 2 (ECT(0) if interpreted as an ECN bit) would
> > > actually be routed using the first route:
> > > 
> > >     $ ping -c 1 -Q 2 192.0.2.11
> > >     PING 192.0.2.11 (192.0.2.11) 56(84) bytes of data.
> > >     64 bytes from 192.0.2.11: icmp_seq=1 ttl=64 time=0.173 ms
> > > 
> > >     --- 192.0.2.11 ping statistics ---
> > >     1 packets transmitted, 1 received, 0% packet loss, time 0ms
> > >     rtt min/avg/max/mdev = 0.173/0.173/0.173/0.000 ms
> > > 
> > > This patch re-applies IPTOS_RT_MASK in inet_rtm_getroute(), to
> > > return results consistent with real route lookups.
> > > 
> > > Fixes: 3765d35ed8b9 ("net: ipv4: Convert inet_rtm_getroute to rcu versions of route lookup")
> > > Signed-off-by: Guillaume Nault <gnault@redhat.com>
> > 
> > Reviewed-by: David Ahern <dsahern@kernel.org>
> 
> Applied, thanks!
> 
> Should the discrepancy between the behavior of ip_route_input_rcu() and
> ip_route_input() be addressed, possibly?

Do you mean masking TOS with IPTOS_RT_MASK directly in
ip_route_input_rcu(), instead of in the callers?

After this patch, all callers apply IPTOS_RT_MASK before calling
ip_route_input_rcu(). So, yes, that could be easily consolidated there,
and I'll do that after net merges into net-next.

More generally, my long term plan is indeed to do mask the TOS in
central places, to get consistent behaviour across the networking
stack. However, generally speaking, I need to be careful not to break
any established behaviour.

I'm mostly worried about the ECN bits. I guess that any caller that
doesn't mask these bits has a bug (as that may break ECN, which is
there since a long time). However, there are many code paths to audit
before we can be sure.

The end goal is to fully support DSCP. Once we'll be sure that no
code path can possibly intreprete an ECN bit as TOS, we'll can safely
drop all those obsolete TOS* masks and macros from the kernel code and
simply mask out the ECN bits (thus preserving the whole DSCP space).

Please note that this is background work for me. Expect slow (but
hopefully regular) progress from me.

