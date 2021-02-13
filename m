Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0654C31ADEE
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 21:24:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbhBMUVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 15:21:38 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:47709 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229647AbhBMUVc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 15:21:32 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 03E58861;
        Sat, 13 Feb 2021 15:20:45 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sat, 13 Feb 2021 15:20:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=U/wNCY
        Y4gpjYy3HhOhHvq9GWD2lNQA40WnnSEne7ZY8=; b=v+wiXkKMPtd0ZMlvL9ICvQ
        hJDC6BZ5vC4GxwB57rizrSBtJyjwUq0Oa2d9g4PBna5BGUxVrBOaRH0L8EuyfGvw
        FpGzuIFLcKM9qwenhIc1B0hUtBLXuwvW7X1DZ1fXUu5imTmy2l+rLjqEamYzYQ/x
        RBa7epMnOZ5AtW0oK7bTmhgkCuDEZGQbjs46HEN9qGkNefnatcNHOqmDiuqCHY2c
        nwN9rZYw/mavseR1RoIcB4zds4hJVYYu1McIJgqRwTH5suaECepaFQ9xRwN3PJ4Y
        twskMdvAH8yHowQBSlON/pFGJo61yLRGVFr9CYTuSA1+QC8Z9JzeFLfMXHmJivvA
        ==
X-ME-Sender: <xms:nTQoYDdt3dYew6tijMupaHOCI2Z2AtYTca2V1hpAWNcOrWIdrWpo2Q>
    <xme:nTQoYJMGERUCszo07G1F9lsrmGk_nJGCoyio52rz3UUGUmxUP0crXJ52m82pE5Mlt
    LjvTyPe8O1KRRs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrieefgddufeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepkeegrddvvdelrdduheefrdeggeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:nTQoYMg2DMV_3O_il1GoPRs0JnBRpby1p0ZYFAlT8Vfr8bxVG190bw>
    <xmx:nTQoYE9vrhReitbV-yNxyiXwpEv9eRIzVJUzKzPD8LJO9C1drJ_Hvw>
    <xmx:nTQoYPsiXuEH3cVlG51qOfgCaC1CwK2vi4YNzdrtE-BOL5BlbXpf0w>
    <xmx:nTQoYPI9Jmx8hstZ0xk_fWLidHG1ydJ1phCILNzvWqMbGuP7i9A_zA>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id D95ED24005C;
        Sat, 13 Feb 2021 15:20:44 -0500 (EST)
Date:   Sat, 13 Feb 2021 22:20:39 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Petr Machata <petrm@nvidia.com>, netdev@vger.kernel.org,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH 04/13] nexthop: Add implementation of resilient
 next-hop groups
Message-ID: <20210213202039.GC401513@shredder.lan>
References: <cover.1612815057.git.petrm@nvidia.com>
 <dec388d80b682213ed2897d9f4ae40c2c2dd9eb8.1612815058.git.petrm@nvidia.com>
 <b9a8fc9e-4e0c-7e7c-0b8a-da520c9dd837@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9a8fc9e-4e0c-7e7c-0b8a-da520c9dd837@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 13, 2021 at 12:38:47PM -0700, David Ahern wrote:
> On 2/8/21 1:42 PM, Petr Machata wrote:
> > diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
> > index 5d560d381070..4ce282b0a65f 100644
> > --- a/net/ipv4/nexthop.c
> > +++ b/net/ipv4/nexthop.c> @@ -734,6 +834,22 @@ static struct nexthop
> *nexthop_select_path_mp(struct nh_group *nhg, int hash)
> >  	return rc;
> >  }
> >  
> > +static struct nexthop *nexthop_select_path_res(struct nh_group *nhg, int hash)
> > +{
> > +	struct nh_res_table *res_table = rcu_dereference(nhg->res_table);
> > +	u32 bucket_index = hash % res_table->num_nh_buckets;
> 
> Have you considered requiring the number of buckets to be a power of 2
> to avoid the modulo in the hot path? Seems like those are the more
> likely size options.

We thought about it, but I think it is overly limiting. Even in Spectrum
(for some sizes) it does not have to be a power of 2.
