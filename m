Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B54B359FB2
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 15:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233481AbhDINU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 09:20:28 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:56731 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231599AbhDINU1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 09:20:27 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id E1F3915FE;
        Fri,  9 Apr 2021 09:20:11 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Fri, 09 Apr 2021 09:20:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=nzp5Pd
        h/0ynkTRT1VPOlAEHLzGzff0yir9USSOK1q4I=; b=TRopwb6QhHZz299KF+/pfF
        YR0szWCim9TZDn3GWiBCKSz0HRlN7TzBmlkhdy+VMnXxU6UwD4eMqhtc4RtchuFH
        qokX3AyzPJtjPi4KUyF3qL5nze7wN65agqXxPdugsM1OhMyibQ+SAj9bMkRN95vn
        h3xjNprlGn4B80sKpiZAxbiUNcnj+H2O0Sb9yYv0HRndKwpMhzOQld098bjZvdQi
        tqguYFJwdE8CNhqPHe5J8vlbTftAvgRkrJ3SdBnwcYuKR0bQ/BdndxJv61EFhYCf
        pnjWfn+sHd2jeOFQtCb+nTXNvlBJVyt2TbQyfdOx+Xn1Oe0w17aYljRDwT9p3b2g
        ==
X-ME-Sender: <xms:i1RwYMJiZ3UYgW9ThwcQutIU5ZB_VxUuTQrCjz9q_dBlDNX0JOJtYQ>
    <xme:i1RwYD7cYQ9l4bx_qDxfSIYS9S4cjCKu2syfs-0NkkBwAPjsJqPlbs-PLBLr7_gGG
    lQUdBWYvGed82E>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudekuddgieegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepkeegrddvvdelrdduheefrddukeejnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:i1RwYPz1E7Dy4wCzbWramXc7Q70YbYI9T5Iu7sz2pO32D5IlVXIQLQ>
    <xmx:i1RwYHalYT7_ORBbnreaWW4O21giYNjEdqk7-nPKlkZp9SbGXtHehA>
    <xmx:i1RwYBSB1pRB4wY_2sNsLO7KlnQROYcQGpDDc-r3xAWB1Gbi2BpN5Q>
    <xmx:i1RwYN7KFbEoWKwFVx4mhdDN_cbTrtAbONHQonYExzbell9SIaXXcw>
Received: from localhost (igld-84-229-153-187.inter.net.il [84.229.153.187])
        by mail.messagingengine.com (Postfix) with ESMTPA id AC901240054;
        Fri,  9 Apr 2021 09:20:10 -0400 (EDT)
Date:   Fri, 9 Apr 2021 16:20:06 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Michal Soltys <msoltyspl@yandex.pl>,
        Linux Netdev List <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: [BUG / question] in routing rules, some options (e.g. ipproto,
 sport) cause rules to be ignored in presence of packet marks
Message-ID: <YHBUhq8M7hr3lVLA@shredder.lan>
References: <babb2ebf-862a-d05f-305a-e894e88f601e@yandex.pl>
 <YGI99fyA6MYKixuB@shredder.lan>
 <24ebb842-cb3a-e1a2-c83d-44b4a5757200@yandex.pl>
 <20210409130241.GB22648@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210409130241.GB22648@breakpoint.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 09, 2021 at 03:02:41PM +0200, Florian Westphal wrote:
> Michal Soltys <msoltyspl@yandex.pl> wrote:
> > On 3/29/21 10:52 PM, Ido Schimmel wrote:
> > > 
> > > ip_route_me_harder() does not set source / destination port in the
> > > flow key, so it explains why fib rules that use them are not hit after
> > > mangling the packet. These keys were added in 4.17, but I
> > > don't think this use case every worked. You have a different experience?
> > > 
> > 
> > So all the more recent additions to routing rules - src port, dst port, uid
> > range and ipproto - are not functioning correctly with the second routing
> > check.
> >
> > Are there plans to eventually fix that ?
> > 
> > While I just adjusted/rearranged my stuff to not rely on those, it should
> > probably be at least documented otherwise (presumably in ip-rule manpage and
> > perhaps in `ip rule help` as well).
> 
> Fixing this would be better.

Yep.

> As Ido implies it should be enough to fully populate the flow keys in
> ip(6)_route_me_harder.

Will try to patch this.
