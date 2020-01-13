Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C366A13917D
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 13:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728670AbgAMM7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 07:59:52 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:58001 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728643AbgAMM7w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 07:59:52 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id E126922091;
        Mon, 13 Jan 2020 07:59:51 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 13 Jan 2020 07:59:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=YsHyfK
        dfpZOaKIZL/4KdRoBZnATQgxCuILpjE4eKZYU=; b=pbVny28JppSQMjVQLO/de/
        WPVqhjset6AN20Rip8KV5zjDzSr1b6aJ/gOnL1Xdmh5j/4VN7WSqKp2WO00m4OsO
        ph5892sFNIHsDXzhDfCVaJ5S++0gTnuONGMg3KT3HiuLX0UrwY4NI1H3i/dmc7GK
        am1LTVTpHTVg/6FqPNClDDVfR76ujwxyTNqFLKt4ds2zzahwR9Bwh7cKEAyKdNDy
        vxIxwUdh7Oj6lKz4vLuqHI21w3yjGqa1VUKcKqZ804BNjNQD/Z1IQFHCQq9OBB0q
        owVDytTmPv94nExiQyUOYxKelKQlN1MgucPocqOwK+3UMPFMR1G40FEH84NlI49Q
        ==
X-ME-Sender: <xms:x2kcXtXZA8w971DzXcHdHfb4djz8AgbDZJ_4yu4YyZU6ogBjlMSG_w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdejtddggeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucfkphepudelfe
    drgeejrdduieehrddvhedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhes
    ihguohhstghhrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:x2kcXiShZfmnBZBT4iKqYiq0haILUruu_ojBxTg7GYBnOsK12YJQ6w>
    <xmx:x2kcXppcKqeD_zQ-QUNJffcoI4pcxmq2Om1kYDjkQSCSfBwJrS2u9w>
    <xmx:x2kcXkcG9DCHJxTAb24T5QNdbXQI1UF1i9F_MDGx-8tFVbpoD_78-Q>
    <xmx:x2kcXtQjl37sGqEcoh4lQ96euAHJuz7j5eewEc2UDbCqWqO_pcUZjA>
Received: from localhost (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3B75C80062;
        Mon, 13 Jan 2020 07:59:51 -0500 (EST)
Date:   Mon, 13 Jan 2020 14:59:49 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        mlxsw@mellanox.com, Shalom Toledo <shalomt@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net 2/4] mlxsw: switchx2: Do not modify cloned SKBs
 during xmit
Message-ID: <20200113125949.GA613635@splinter>
References: <20200112160641.282108-1-idosch@idosch.org>
 <20200112160641.282108-3-idosch@idosch.org>
 <20200112161017.43b728c8@cakuba>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200112161017.43b728c8@cakuba>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 12, 2020 at 04:10:17PM -0800, Jakub Kicinski wrote:
> On Sun, 12 Jan 2020 18:06:39 +0200, Ido Schimmel wrote:
> > From: Shalom Toledo <shalomt@mellanox.com>
> > 
> > The driver needs to prepend a Tx header to each packet it is transmitting.
> > The header includes information such as the egress port and traffic class.
> > 
> > The addition of the header requires the driver to modify the SKB's data
> > buffer and therefore the SKB must be unshared first. Otherwise, we risk
> > hitting various race conditions with cloned SKBs.
> > 
> > For example, when a packet is flooded (cloned) by the bridge driver to two
> > switch ports swp1 and swp2:
> > 
> > t0 - mlxsw_sp_port_xmit() is called for swp1. Tx header is prepended with
> >      swp1's port number
> > t1 - mlxsw_sp_port_xmit() is called for swp2. Tx header is prepended with
> >      swp2's port number, overwriting swp1's port number
> > t2 - The device processes data buffer from t0. Packet is transmitted via
> >      swp2
> > t3 - The device processes data buffer from t1. Packet is transmitted via
> >      swp2
> > 
> > Usually, the device is fast enough and transmits the packet before its
> > Tx header is overwritten, but this is not the case in emulated
> > environments.
> > 
> > Fix this by unsharing the SKB.
> 
> Isn't this what skb_cow_head() is for?

Yes, this does look better. If you look further in the code, we have
this check for the headroom:

if (unlikely(skb_headroom(skb) < MLXSW_TXHDR_LEN)) {
...
}

We can remove it by replacing skb_unshare() with skb_cow_head().

> 
> > diff --git a/drivers/net/ethernet/mellanox/mlxsw/switchx2.c b/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
> > index de6cb22f68b1..47826e905e5c 100644
> > --- a/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
> > +++ b/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
> > @@ -299,6 +299,10 @@ static netdev_tx_t mlxsw_sx_port_xmit(struct sk_buff *skb,
> >  	u64 len;
> >  	int err;
> >  
> > +	skb = skb_unshare(skb, GFP_ATOMIC);
> > +	if (unlikely(!skb))
> > +		return NETDEV_TX_BUSY;
> > +
> >  	memset(skb->cb, 0, sizeof(struct mlxsw_skb_cb));
> >  
> >  	if (mlxsw_core_skb_transmit_busy(mlxsw_sx->core, &tx_info))
> 
> the next line here is:
> 
> 		return NETDEV_TX_BUSY;
> 
> Is it okay to return BUSY after copying an skb? The reference to the
> original skb may already be gone at this point, while the copy is going
> to be leaked, right?

Yes, you're correct, but if we convert to skb_cow_head() like you
suggested, then the skb shell is not changed and only its header is
(potentially) expanded, so I believe we can keep this check as-is.

Thanks, Jakub!

P.S. I'll take care of v2 as Shalom is OOO until next week.
