Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 163B122D6F7
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 13:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbgGYLFn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 07:05:43 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:42091 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726651AbgGYLFn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jul 2020 07:05:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595675141;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LWB2709msljQucnBBqm1rM2bavmji2piZ9+wSongLc0=;
        b=M+xBZ+zj3vbF7Tf28JRS5n9msj4ccTt7Dcx5jaNg3ZwfryiU7pvxy21Py3AR2kMEvt2LpY
        kEQiLX0qRMaudUKZFj3VEHZDuEXFmpG7cFdKd031oNMLHxQ1YdLy0PS+BzlYTidR7DBp6N
        wnjinay6dyjglasDdeFPpitWsaDVFD4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-430-zLZALKudNhGTGwhWnCnGtA-1; Sat, 25 Jul 2020 07:05:40 -0400
X-MC-Unique: zLZALKudNhGTGwhWnCnGtA-1
Received: by mail-wm1-f72.google.com with SMTP id e15so5203456wme.8
        for <netdev@vger.kernel.org>; Sat, 25 Jul 2020 04:05:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LWB2709msljQucnBBqm1rM2bavmji2piZ9+wSongLc0=;
        b=Nj8Y1mGD/pfwFzLzZzQzIx3+uz40SsgR0mnpsrvOMAowAbSoLnECOk9kdrCChSRbXk
         RJOaSyP3H9YSwFGcFxcgcXaj3WB2aBhZVTUx3diKsKhHpjRTQvGu9ykZ5CszRHOuV6Uj
         I0jWohHY6tLSWGj9/ZypIm94wfHTOuuW55OAv5JVVjOPTrRPRn9thesFQ7vOitXym2to
         pjvyNZoHf1o/2ZBC7+6XVodGYM+PgMIIfnETlwBir1iBERbMrlyfTzkSOwRBe8CoTKk2
         mrqhl2zi8g6yXVNXddonTsBICAyiMOfrVBAEmAGnbhQ5tD7rzNmzVsCUKHg/4I3czPWw
         b1ow==
X-Gm-Message-State: AOAM530jwDrwMprh+2i3KVGXI0iejXrZff6yhDsk+Jupd3T6E7l0bG4D
        xhnIDCbERji7sfvWSOoDwzVSF2fKzFdVG6Q6F4wPBJmMXn5f9LyblKg5ZJQdXN+soOkZpFDhYbF
        tdUuDNLakmNs6ZSN3
X-Received: by 2002:a1c:354:: with SMTP id 81mr5346774wmd.9.1595675138450;
        Sat, 25 Jul 2020 04:05:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxEEPuhSdPQnsSL6KLrrdFIoHCrCr0Kkke4EcULzM+LISBGsERirapNC8In95ygvgR/e3+PpQ==
X-Received: by 2002:a1c:354:: with SMTP id 81mr5346753wmd.9.1595675138143;
        Sat, 25 Jul 2020 04:05:38 -0700 (PDT)
Received: from pc-2.home (2a01cb058529bf0075b0798a7f5975cb.ipv6.abo.wanadoo.fr. [2a01:cb05:8529:bf00:75b0:798a:7f59:75cb])
        by smtp.gmail.com with ESMTPSA id s205sm4750952wme.7.2020.07.25.04.05.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jul 2020 04:05:37 -0700 (PDT)
Date:   Sat, 25 Jul 2020 13:05:35 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Martin Varghese <martin.varghese@nokia.com>,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH net] bareudp: forbid mixing IP and MPLS in multiproto mode
Message-ID: <20200725110535.GA4152@pc-2.home>
References: <f6e832e7632acf28b1d2b35dddb08769c7ce4fab.1595624517.git.gnault@redhat.com>
 <20200724162134.7b0c8aaa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200724162134.7b0c8aaa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 24, 2020 at 04:21:34PM -0700, Jakub Kicinski wrote:
> On Fri, 24 Jul 2020 23:03:26 +0200 Guillaume Nault wrote:
> > In multiproto mode, bareudp_xmit() accepts sending multicast MPLS and
> > IPv6 packets regardless of the bareudp ethertype. In practice, this
> > let an IP tunnel send multicast MPLS packets, or an MPLS tunnel send
> > IPv6 packets.
> > 
> > We need to restrict the test further, so that the multiproto mode only
> > enables
> >   * IPv6 for IPv4 tunnels,
> >   * or multicast MPLS for unicast MPLS tunnels.
> > 
> > To improve clarity, the protocol validation is moved to its own
> > function, where each logical test has its own condition.
> > 
> > Fixes: 4b5f67232d95 ("net: Special handling for IP & MPLS.")
> > Signed-off-by: Guillaume Nault <gnault@redhat.com>
> 
> Hi! this adds 10 sparse warnings:
> 
> drivers/net/bareudp.c:419:22: warning: cast to restricted __be16
> drivers/net/bareudp.c:419:22: warning: cast to restricted __be16
> drivers/net/bareudp.c:419:22: warning: cast to restricted __be16
> drivers/net/bareudp.c:419:22: warning: cast to restricted __be16
> drivers/net/bareudp.c:419:13: warning: restricted __be16 degrades to integer
> drivers/net/bareudp.c:423:22: warning: cast to restricted __be16
> drivers/net/bareudp.c:423:22: warning: cast to restricted __be16
> drivers/net/bareudp.c:423:22: warning: cast to restricted __be16
> drivers/net/bareudp.c:423:22: warning: cast to restricted __be16
> 
> I think this:
> 
> 	    proto == ntohs(ETH_P_MPLS_MC))
> 
> has to say htons() not ntohs(). For v6 as well.
> 
Ouch, sorry. I'll respin.

