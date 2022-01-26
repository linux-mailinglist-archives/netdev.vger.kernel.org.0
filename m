Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7A4649C8A6
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 12:27:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240723AbiAZL1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 06:27:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240735AbiAZL1s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 06:27:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A16AC06161C;
        Wed, 26 Jan 2022 03:27:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B015618E2;
        Wed, 26 Jan 2022 11:27:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC941C340E3;
        Wed, 26 Jan 2022 11:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643196467;
        bh=oOQ46taH7uDd4Y9NEaWdPxVFw3iwwqhlMTUYTU1IU7Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Jgw8qT3Hy1pByMnFylWzseXG1z/+Pxz6foaf+S2yBcvzOmNpl+tRQBSOKrlLtejq5
         BSRSC2AhSjiyKPIewwbFblt8xHfqK9Ui5WxNHOFH04BtCgdowgPzeLQmWtAZ3O2Zwp
         1uk5AKNRzURnb9tmr9W783YjxotX4jvJaxJ4UoHBZTmQMMP94RBN5W2rGvCj/2bF0x
         xbIlNCXM21qMngmmwnTYxNuZjHKCAd6+r1lKD9Av8a+1HUq5XaLxgfABNEP49C659Y
         yc5buyY+X4h+ydN70t29ebLpwe0xFfeLE14LKbgGAvlvmSM+2o7DRs7kYtxXUX4ZAd
         bZQCeF8vdfNyQ==
Date:   Wed, 26 Jan 2022 12:27:42 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, dsahern@kernel.org,
        komachi.yoshiki@gmail.com, brouer@redhat.com, toke@redhat.com,
        memxor@gmail.com, andrii.nakryiko@gmail.com,
        Roopa Prabhu <roopa@nvidia.com>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        Ido Schimmel <idosch@idosch.org>
Subject: Re: [RFC bpf-next 1/2] net: bridge: add unstable
 br_fdb_find_port_from_ifindex helper
Message-ID: <YfEwLrB6JqNpdUc0@lore-desk>
References: <cover.1643044381.git.lorenzo@kernel.org>
 <720907692575488526f06edc2cf5c8f783777d4f.1643044381.git.lorenzo@kernel.org>
 <61553c87-a3d3-07ae-8c2f-93cf0cb52263@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="KpnKG0itNKS5zFBf"
Content-Disposition: inline
In-Reply-To: <61553c87-a3d3-07ae-8c2f-93cf0cb52263@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--KpnKG0itNKS5zFBf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On 24/01/2022 19:20, Lorenzo Bianconi wrote:
> > Similar to bpf_xdp_ct_lookup routine, introduce
> > br_fdb_find_port_from_ifindex unstable helper in order to accelerate
> > linux bridge with XDP. br_fdb_find_port_from_ifindex will perform a
> > lookup in the associated bridge fdb table and it will return the
> > output ifindex if the destination address is associated to a bridge
> > port or -ENODEV for BOM traffic or if lookup fails.
> >=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  net/bridge/br.c         | 21 +++++++++++++
> >  net/bridge/br_fdb.c     | 67 +++++++++++++++++++++++++++++++++++------
> >  net/bridge/br_private.h | 12 ++++++++
> >  3 files changed, 91 insertions(+), 9 deletions(-)
> >=20
>=20
> Hi Lorenzo,

Hi Nikolay,

thx for the review.

> Please CC bridge maintainers for bridge-related patches, I've added Roopa=
 and the
> bridge mailing list as well. Aside from that, the change is certainly int=
eresting, I've been
> thinking about a similar helper for some time now, few comments below.

yes, sorry for that. I figured it out after sending the series out.

>=20
> Have you thought about the egress path and if by the current bridge state=
 the packet would
> be allowed to egress through the found port from the lookup? I'd guess yo=
u have to keep updating
> the active ports list based on netlink events, but there's a lot of egres=
s bridge logic that
> either have to be duplicated or somehow synced. Check should_deliver() (b=
r_forward.c) and later
> egress stages, but I see how this is a good first step and perhaps we can=
 build upon it.
> There are a few possible solutions, but I haven't tried anything yet, mos=
t obvious being
> yet another helper. :)

ack, right but I am bit worried about adding too much logic and slow down x=
dp
performances. I guess we can investigate first the approach proposed by Ale=
xei
and then revaluate. Agree?

>=20
> > diff --git a/net/bridge/br.c b/net/bridge/br.c
> > index 1fac72cc617f..d2d1c2341d9c 100644
> > --- a/net/bridge/br.c
> > +++ b/net/bridge/br.c
> > @@ -16,6 +16,8 @@
> >  #include <net/llc.h>
> >  #include <net/stp.h>
> >  #include <net/switchdev.h>
> > +#include <linux/btf.h>
> > +#include <linux/btf_ids.h>
> > =20
> >  #include "br_private.h"
> > =20
> > @@ -365,6 +367,17 @@ static const struct stp_proto br_stp_proto =3D {
> >  	.rcv	=3D br_stp_rcv,
> >  };
> > =20
> > +#if (IS_ENABLED(CONFIG_DEBUG_INFO_BTF) || IS_ENABLED(CONFIG_DEBUG_INFO=
_BTF_MODULES))
> > +BTF_SET_START(br_xdp_fdb_check_kfunc_ids)
> > +BTF_ID(func, br_fdb_find_port_from_ifindex)
> > +BTF_SET_END(br_xdp_fdb_check_kfunc_ids)
> > +
> > +static const struct btf_kfunc_id_set br_xdp_fdb_kfunc_set =3D {
> > +	.owner     =3D THIS_MODULE,
> > +	.check_set =3D &br_xdp_fdb_check_kfunc_ids,
> > +};
> > +#endif
> > +
> >  static int __init br_init(void)
> >  {
> >  	int err;
> > @@ -417,6 +430,14 @@ static int __init br_init(void)
> >  		"need this.\n");
> >  #endif
> > =20
> > +#if (IS_ENABLED(CONFIG_DEBUG_INFO_BTF) || IS_ENABLED(CONFIG_DEBUG_INFO=
_BTF_MODULES))
> > +	err =3D register_btf_kfunc_id_set(BPF_PROG_TYPE_XDP, &br_xdp_fdb_kfun=
c_set);
> > +	if (err < 0) {
> > +		br_netlink_fini();
> > +		goto err_out6;
>=20
> Add err_out7 and handle it there please. Let's keep it consistent.
> Also I cannot find register_btf_kfunc_id_set() in net-next or Linus' mast=
er, but
> should it be paired with an unregister on unload (br_deinit) ?

I guess at the time I sent the series it was just in bpf-next but now it sh=
ould
be in net-next too.
I do not think we need a unregister here.
@Kumar: agree?

>=20
> > +	}
> > +#endif
> > +
> >  	return 0;
> > =20
> >  err_out6:
> > diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
> > index 6ccda68bd473..cd3afa240298 100644
> > --- a/net/bridge/br_fdb.c
> > +++ b/net/bridge/br_fdb.c
> > @@ -235,30 +235,79 @@ static struct net_bridge_fdb_entry *br_fdb_find(s=
truct net_bridge *br,
> >  	return fdb;
> >  }
> > =20
> > -struct net_device *br_fdb_find_port(const struct net_device *br_dev,
> > -				    const unsigned char *addr,
> > -				    __u16 vid)
> > +static struct net_device *
> > +__br_fdb_find_port(const struct net_device *br_dev,
> > +		   const unsigned char *addr,
> > +		   __u16 vid, bool ts_update)
> >  {
> >  	struct net_bridge_fdb_entry *f;
> > -	struct net_device *dev =3D NULL;
> >  	struct net_bridge *br;
> > =20
> > -	ASSERT_RTNL();
> > -
> >  	if (!netif_is_bridge_master(br_dev))
> >  		return NULL;
> > =20
> >  	br =3D netdev_priv(br_dev);
> > -	rcu_read_lock();
> >  	f =3D br_fdb_find_rcu(br, addr, vid);
> > -	if (f && f->dst)
> > -		dev =3D f->dst->dev;
> > +
> > +	if (f && f->dst) {
> > +		f->updated =3D jiffies;
> > +		f->used =3D f->updated;
>=20
> This is wrong, f->updated should be set only if anything changed for the =
fdb.
> Also you can optimize f->used a little bit if you check if jiffies !=3D c=
urrent value
> before setting, you can have millions of packets per sec dirtying that ca=
che line.

ack, right. I will fix it.

>=20
> Aside from the above, it will change expected behaviour for br_fdb_find_p=
ort users
> (mlxsw, added Ido to CC as well) because it will mark the fdb as active a=
nd refresh it
> which should be done only for the ebpf helper, or might be exported throu=
gh another helper
> so ebpf users can decide if they want it updated. There are 2 different u=
se cases and it is
> not ok for both as we'll start refreshing fdbs that have been inactive fo=
r a while
> and would've expired otherwise.

This is a bug actually. I forgot to check ts_update in the if condition,
something like:

if (f && f->dst && ts_update) {
 ...
 }

>=20
> > +		return f->dst->dev;
>=20
> This is wrong as well, f->dst can become NULL (fdb switched to point to t=
he bridge itself).
> You should make sure to read f->dst only once and work with the result. I=
 know it's
> been like that, but it was ok when accessed with rtnl held.

uhm, right. I will fix it.

>=20
> > +	}
> > +	return NULL;
> > +}
> > +
> > +struct net_device *br_fdb_find_port(const struct net_device *br_dev,
> > +				    const unsigned char *addr,
> > +				    __u16 vid)
> > +{
> > +	struct net_device *dev;
> > +
> > +	ASSERT_RTNL();
> > +
> > +	rcu_read_lock();
> > +	dev =3D __br_fdb_find_port(br_dev, addr, vid, false);
> >  	rcu_read_unlock();
> > =20
> >  	return dev;
> >  }
> >  EXPORT_SYMBOL_GPL(br_fdb_find_port);
> > =20
> > +int br_fdb_find_port_from_ifindex(struct xdp_md *xdp_ctx,
> > +				  struct bpf_fdb_lookup *opt,
> > +				  u32 opt__sz)
> > +{
> > +	struct xdp_buff *ctx =3D (struct xdp_buff *)xdp_ctx;
> > +	struct net_bridge_port *port;
> > +	struct net_device *dev;
> > +	int ret =3D -ENODEV;
> > +
> > +	BUILD_BUG_ON(sizeof(struct bpf_fdb_lookup) !=3D NF_BPF_FDB_OPTS_SZ);
> > +	if (!opt || opt__sz !=3D sizeof(struct bpf_fdb_lookup))
> > +		return -ENODEV;
> > +
> > +	rcu_read_lock();
> > +
> > +	dev =3D dev_get_by_index_rcu(dev_net(ctx->rxq->dev), opt->ifindex);
> > +	if (!dev)
> > +		goto out;
> > +
> > +	if (unlikely(!netif_is_bridge_port(dev)))
> > +		goto out;
>=20
> This check shouldn't be needed if the port checks below succeed.

ack, I will fix it.

Regards,
Lorenzo

>=20
> > +
> > +	port =3D br_port_get_check_rcu(dev);
> > +	if (unlikely(!port || !port->br))
> > +		goto out;
> > +
> > +	dev =3D __br_fdb_find_port(port->br->dev, opt->addr, opt->vid, true);
> > +	if (dev)
> > +		ret =3D dev->ifindex;
> > +out:
> > +	rcu_read_unlock();
> > +
> > +	return ret;
> > +}
> > +
> >  struct net_bridge_fdb_entry *br_fdb_find_rcu(struct net_bridge *br,
> >  					     const unsigned char *addr,
> >  					     __u16 vid)
> > diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> > index 2661dda1a92b..64d4f1727da2 100644
> > --- a/net/bridge/br_private.h
> > +++ b/net/bridge/br_private.h
> > @@ -18,6 +18,7 @@
> >  #include <linux/if_vlan.h>
> >  #include <linux/rhashtable.h>
> >  #include <linux/refcount.h>
> > +#include <linux/bpf.h>
> > =20
> >  #define BR_HASH_BITS 8
> >  #define BR_HASH_SIZE (1 << BR_HASH_BITS)
> > @@ -2094,4 +2095,15 @@ void br_do_proxy_suppress_arp(struct sk_buff *sk=
b, struct net_bridge *br,
> >  void br_do_suppress_nd(struct sk_buff *skb, struct net_bridge *br,
> >  		       u16 vid, struct net_bridge_port *p, struct nd_msg *msg);
> >  struct nd_msg *br_is_nd_neigh_msg(struct sk_buff *skb, struct nd_msg *=
m);
> > +
> > +#define NF_BPF_FDB_OPTS_SZ	12
> > +struct bpf_fdb_lookup {
> > +	u8	addr[ETH_ALEN]; /* ETH_ALEN */
> > +	u16	vid;
> > +	u32	ifindex;
> > +};
> > +
> > +int br_fdb_find_port_from_ifindex(struct xdp_md *xdp_ctx,
> > +				  struct bpf_fdb_lookup *opt,
> > +				  u32 opt__sz);
> >  #endif
>=20
> Thanks,
>  Nik

--KpnKG0itNKS5zFBf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYfEwLgAKCRA6cBh0uS2t
rBAUAQCChH/Fy1/K0jRK+JFyEUUPZV7PVCMWSjIL72PdvVm1uwD/SbyK+I2LUF3O
bZbzacP1RDtnDkl263iPTPc6+8YRzwQ=
=V1Ay
-----END PGP SIGNATURE-----

--KpnKG0itNKS5zFBf--
