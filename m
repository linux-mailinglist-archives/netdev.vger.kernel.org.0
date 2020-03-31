Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7913C1993D8
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 12:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730439AbgCaKtL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 06:49:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:38248 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730432AbgCaKtL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 06:49:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585651749;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Up3X1AozLf8bVN3lRJXXO6ZgDRuroUjOIN3FnjivnjQ=;
        b=GwQmoVo3WRg0CIlkTFAgOkDuJgueOsF7qVORsaPCG9NYZvD5tdWZm84M6i0ONHWk8EdLle
        QdsbeQiToji+UqVP8PIVeAa244rXw6DqN0jpjf9r67TnGs3ds0AqpEik3vzruSaonG4oUz
        txVBkf/Dlc9o9LhBn6BZucCoxnTyEWY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-471-I9JTNfeBN9-KY5WbnGQfVQ-1; Tue, 31 Mar 2020 06:49:06 -0400
X-MC-Unique: I9JTNfeBN9-KY5WbnGQfVQ-1
Received: by mail-wr1-f71.google.com with SMTP id c8so10905291wru.20
        for <netdev@vger.kernel.org>; Tue, 31 Mar 2020 03:49:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Up3X1AozLf8bVN3lRJXXO6ZgDRuroUjOIN3FnjivnjQ=;
        b=kjP7cQ19nUKpxLqLUnD0zPAjoyzF63WvzP0P0Erh72RjAGirJornWR16qxiOVTLty6
         UdxvOZpCGfc3HAcFOs83+WZnk675pBlsNXB214Dk3wVPpiDb5zV2DfDkgNAWVCP+fuPs
         Tr+vHobi6rjNYRPXqmtQmPmompRL5e2E89EdooA3PJxFfygQ3Udi/WKLOwOEjj0Gfgmz
         K2hsLdR8a+jJLRg+1nj2gfb6JCJKftIh/zqvm4HPHcV6syqJRTQGn6HrXV5j8yjzpePL
         Ozb7Dkdqi0tRjgi30ux4ByHbI89T0ueRUK0X+PKVi5Ic53R8JPHtwpgJpsYUh/TAecEF
         bKRw==
X-Gm-Message-State: ANhLgQ0qFpFwaxKxyndQJ0KBuQNLDsmRwSJsmU6kbUkOa2OVBd4q8rih
        NAaR8OxG7+eb5mjScq5X7gdofO3e4bPDQBKyBObd6KVh35jgYpAEUdrGn7ui1T5YvsMNw3UX7hh
        BKm5LXEASQyytVqFs
X-Received: by 2002:a5d:550a:: with SMTP id b10mr19761602wrv.163.1585651744416;
        Tue, 31 Mar 2020 03:49:04 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtwR9U6Vp2ZisCXDKIKCZjCfc40X3JKJ1jHtqlvZ0lEtXviGkeVijdaLZ82cJZUETtn32MKZA==
X-Received: by 2002:a5d:550a:: with SMTP id b10mr19761564wrv.163.1585651744097;
        Tue, 31 Mar 2020 03:49:04 -0700 (PDT)
Received: from pc-3.home (2a01cb0585138800b113760e11343d15.ipv6.abo.wanadoo.fr. [2a01:cb05:8513:8800:b113:760e:1134:3d15])
        by smtp.gmail.com with ESMTPSA id c85sm3174602wmd.48.2020.03.31.03.49.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2020 03:49:03 -0700 (PDT)
Date:   Tue, 31 Mar 2020 12:49:01 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Simon Chopin <s.chopin@alphalink.fr>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH net-next] pppoe: new ioctl to extract per-channel stats
Message-ID: <20200331104901.GA24576@pc-3.home>
References: <20200326103230.121447-1-s.chopin@alphalink.fr>
 <20200326143806.GA31979@pc-3.home>
 <629de420-b433-0868-eccc-6feb9b43da7c@alphalink.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <629de420-b433-0868-eccc-6feb9b43da7c@alphalink.fr>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 31, 2020 at 11:27:23AM +0200, Simon Chopin wrote:
> Hello Guillaume,
> 
> Le 26/03/2020 à 15:38, Guillaume Nault a écrit :
> > On Thu, Mar 26, 2020 at 11:32:30AM +0100, Simon Chopin wrote:
> >> The PPP subsystem uses the abstractions of channels and units, the
> >> latter being an aggregate of the former, exported to userspace as a
> >> single network interface.  As such, it keeps traffic statistics at the
> >> unit level, but there are no statistics on the individual channels,
> >> partly because most PPP units only have one channel.
> >>
> >> However, it is sometimes useful to have statistics at the channel level,
> >> for instance to monitor multilink PPP connections. Such statistics
> >> already exist for PPPoL2TP via the PPPIOCGL2TPSTATS ioctl, this patch
> >> introduces a very similar mechanism for PPPoE via a new
> >> PPPIOCGPPPOESTATS ioctl.
> >>
> > I'd rather recomment _not_ using multilink PPP over PPPoE (or L2TP, or
> > any form of overlay network). But apart from that, I find the
> > description misleading. PPPoE is not a PPP channel, it _transports_ a
> > channel. PPPoE might not even be associated with a channel at all,
> > like in the PPPOX_RELAY case. In short PPPoE stats aren't channel's
> > stats. If the objective it to get channels stats, then this needs to be
> > implemented in ppp_generic.c. If what you really want is PPPoE stats,
> > then see my comments below.
> 
> Thank you for your feedback
> I indeed want some statistics over PPP channels, notably over L2TP and
> PPPoE. Since a mechanism already existed for the former, I thought
> it simpler to implement the same for the latter, but your point makes sense:
> those subsystems operate below the PPP layer, with extra control packets
> and header overhead.
> 
Then I guess getting statistics of the PPP channel is more appropriate.
It might be possible to move the ppp_link_stats structure from
struct ppp to struct ppp_file, so that it could be used for channels
and for units. If necessary, the structure can probably be extended to
record more statistics.

> >> @@ -549,6 +563,8 @@ static int pppoe_create(struct net *net, struct socket *sock, int kern)
> >>  	sk->sk_family		= PF_PPPOX;
> >>  	sk->sk_protocol		= PX_PROTO_OE;
> >>  
> >> +	sk->sk_user_data = kzalloc(sizeof(struct pppoe_stats), GFP_KERNEL);
> >> +
> > Missing error check.
> > 
> > But please don't use ->sk_user_data for that. We have enough problems
> > with this pointer, let's not add users that don't actually need it.
> > See https://lore.kernel.org/netdev/20180117.142538.1972806008716856078.davem@davemloft.net/
> > for some details.
> > You can store the counters inside the socket instead.
> 
> Thank you for the pointers. I'll pay attention to error paths in any further
> version, and in any case will drop the sk_user_data use.
> 
> Would it be allright to post new patches as RFC before net-next opens in
> order to get further feedback, or is that frowned upon ?
> 
It should be fine, as long as it's clearly indicated in the subject.

