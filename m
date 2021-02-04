Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4359230EEF6
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 09:50:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235056AbhBDIso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 03:48:44 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:41125 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235193AbhBDIsc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 03:48:32 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 8EE37C58;
        Thu,  4 Feb 2021 03:47:38 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 04 Feb 2021 03:47:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Ts8T98
        W64trsVpnCulK+xNs+WbirenxyU8wklTYVYBI=; b=FZdBxdJEFS7D+CzJ/J2EVs
        XoPwdmKaTuY3Q7xJkty5GWMz0rL9tNlRQNCyzuzoeLcGVzKb4cxYLeauIl8JD2LI
        0E1ZnWzb1LP3ftlONbeOGsHJRpYLoG9Vv6Xzqn5NAgJcoo+E+b+enuNx2CTWKIJi
        2KFra6mnY3Uz/Buo1DIln8STbK3QrrDWtBj8PooQJDfoUmKgsFSW28WcJigxp90E
        xs2jpUyELSM32LbB8S0aXCXsEXPf33YVjq1FfLqKi1GZDd/laAdixraZdUHZqBcC
        4gUifdjdk87qtdiDgtureWY24RVbxefU4uuLk34BwzFFn8O+SonlVX5sxWRMqn4Q
        ==
X-ME-Sender: <xms:qLQbYPXdsml15AveIwNuywxHgkikh4DRayN77O5l3TraVTeCLnDldQ>
    <xme:qLQbYHm7ZBCc8qyAk0ZXO6gmJhuTp-cX5mv43pKLhX55NLRinNw1hZX6PICIBbyNm
    DwMRKl_iSAqH7k>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrgeefgdduudelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepkeegrddvvdelrdduheefrdeggeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:qbQbYLbgPjTg4mC-_IPHqtsZjTnf3eoBxYiUrkAA2zM2wUmy4EQUdg>
    <xmx:qbQbYKWdVP255fK6kel1_EiZWgvpPzrvVEms7j3SZWXXE8QEQ72A5A>
    <xmx:qbQbYJkhCYmqoj1bA-L_lwela3yyMF3pZo_AvXg1ZFibDspNeq5k9Q>
    <xmx:qbQbYJvYAZVdcLc1VU0r18ZNiUAWMqO4_cq5MGhkYaMPi5v7degDKA>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8849B108005B;
        Thu,  4 Feb 2021 03:47:36 -0500 (EST)
Date:   Thu, 4 Feb 2021 10:47:32 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Chris Mi <cmi@nvidia.com>, netdev@vger.kernel.org,
        idosch@nvidia.com, Yotam Gigi <yotam.gi@gmail.com>
Subject: Re: [PATCH net] net: psample: Fix the netlink skb length
Message-ID: <20210204084732.GA3645495@shredder.lan>
References: <20210203031028.171318-1-cmi@nvidia.com>
 <20210203182103.0f8350a9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210203182103.0f8350a9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 03, 2021 at 06:21:03PM -0800, Jakub Kicinski wrote:
> On Wed,  3 Feb 2021 11:10:28 +0800 Chris Mi wrote:
> > Currently, the netlink skb length only includes metadata and data
> > length. It doesn't include the psample generic netlink header length.
> 
> But what's the bug? Did you see oversized messages on the socket? Did
> one of the nla_put() fail?

I didn't ask, but I assumed the problem was nla_put(). Agree it needs to
be noted in the commit message.

> 
> > Fixes: 6ae0a6286171 ("net: Introduce psample, a new genetlink channel for packet sampling")
> > CC: Yotam Gigi <yotam.gi@gmail.com>
> > Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> > Signed-off-by: Chris Mi <cmi@nvidia.com>
> > ---
> >  net/psample/psample.c | 10 ++++++----
> >  1 file changed, 6 insertions(+), 4 deletions(-)
> > 
> > diff --git a/net/psample/psample.c b/net/psample/psample.c
> > index 33e238c965bd..807d75f5a40f 100644
> > --- a/net/psample/psample.c
> > +++ b/net/psample/psample.c
> > @@ -363,6 +363,7 @@ void psample_sample_packet(struct psample_group *group, struct sk_buff *skb,
> >  	struct ip_tunnel_info *tun_info;
> >  #endif
> >  	struct sk_buff *nl_skb;
> > +	int header_len;
> >  	int data_len;
> >  	int meta_len;
> >  	void *data;
> > @@ -381,12 +382,13 @@ void psample_sample_packet(struct psample_group *group, struct sk_buff *skb,
> >  		meta_len += psample_tunnel_meta_len(tun_info);
> >  #endif
> >  
> > +	/* psample generic netlink header size */
> > +	header_len = nlmsg_total_size(GENL_HDRLEN + psample_nl_family.hdrsize);
> 
> GENL_HDRLEN is already included by genlmsg_new() and fam->hdrsize is 0
> / uninitialized for psample_nl_family. What am I missing? Ido?

Yea, I missed that genlmsg_new() eventually accounts for 'GENL_HDRLEN'.

Chris, assuming the problem is nla_put(), I think some other attribute
is not accounted for when calculating the size of the skb. Does it only
happen with packets that include tunnel metadata? Because I think I see
a few problems there:

diff --git a/net/psample/psample.c b/net/psample/psample.c
index 33e238c965bd..1a233cd128c7 100644
--- a/net/psample/psample.c
+++ b/net/psample/psample.c
@@ -311,8 +311,10 @@ static int psample_tunnel_meta_len(struct ip_tunnel_info *tun_info)
        int tun_opts_len = tun_info->options_len;
        int sum = 0;
 
+       sum += nla_total_size(0);       /* PSAMPLE_ATTR_TUNNEL */
+
        if (tun_key->tun_flags & TUNNEL_KEY)
-               sum += nla_total_size(sizeof(u64));
+               sum += nla_total_size_64bit(sizeof(u64));
 
        if (tun_info->mode & IP_TUNNEL_INFO_BRIDGE)
                sum += nla_total_size(0);

> 
> >  	data_len = min(skb->len, trunc_size);
> > -	if (meta_len + nla_total_size(data_len) > PSAMPLE_MAX_PACKET_SIZE)
> > -		data_len = PSAMPLE_MAX_PACKET_SIZE - meta_len - NLA_HDRLEN
> > +	if (header_len + meta_len + nla_total_size(data_len) > PSAMPLE_MAX_PACKET_SIZE)
> > +		data_len = PSAMPLE_MAX_PACKET_SIZE - header_len - meta_len - NLA_HDRLEN
> >  			    - NLA_ALIGNTO;
> > -
> > -	nl_skb = genlmsg_new(meta_len + nla_total_size(data_len), GFP_ATOMIC);
> > +	nl_skb = genlmsg_new(header_len + meta_len + nla_total_size(data_len), GFP_ATOMIC);
> >  	if (unlikely(!nl_skb))
> >  		return;
> >  
> 
