Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43DAA269E1
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 20:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729626AbfEVScT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 14:32:19 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:36073 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729538AbfEVScS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 14:32:18 -0400
Received: by mail-qt1-f194.google.com with SMTP id a17so3619848qth.3
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 11:32:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=wFeaHwzHOOjE/+JjNpQHfgZdne1cp9+Ug09Nq03Kz5o=;
        b=IEic7pzSJJ022kACjvzZ8vpiOg9J1L+3N2mYq8s966h5yvaUf87BuziSuMV1CecR5/
         UXMhJVPR1ApEnDFAUqWpHc7lOivPzBGnO9p0XWDZzmw3pNsbGnCg9g1l3rjvrNVPQmq0
         +cZP1tukRPpdMWq2txEBB/F/XPkV8k29jG+cio5et73ofS9sgoBaPz7dvdUF/Ggl3oN8
         8tx3/L/A7Aiv2NHztVAdRtPgYfw68YukcET6gbctLU6ba6GrTvaWLSZ1+rOWIPWOzkcm
         SWlu1cL5R6p2szz7DTZHQPdYeEm1ncWFM0QsMMfhsT5vPfYf67b5v3KLByfVAg05hKl0
         odgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=wFeaHwzHOOjE/+JjNpQHfgZdne1cp9+Ug09Nq03Kz5o=;
        b=GbID3tjY2f1p2hLaWHh6swzpegPpDD/ihLn1r2r+S4zNm04DZa1Yqk8PdQMNwFSJgl
         JABLtUqTuhGJP7UIbVobo6WyKF0lJbXv057oYlfsZLvClM19uwQUGA64Bisfu489W86s
         +bllMBtUMKS7WR2WMz9hOw1lVp63roJLtFeQljWgxija0ZlmisL/1TbTm6ryTFuurwww
         q2CprhBCD92SFVYaaSnh6YYf5fy3lEfuMfqUnX1RghZwzDvqbgDwoHWt0oWsyF4+PUas
         1/ed7YjsGNmapyKY46HhBoE1J0Z+i+t99hkn55Dla8H6j60YUaaEucvfRz/NR5crM5Bv
         nDPg==
X-Gm-Message-State: APjAAAUTiMvHJWk1R96aU4dHU+Q+VjcfYOXPnIqHRfAsDFQEVY6p1TTT
        fgWrAbCWGLvr1CphhLX/7DaNDg==
X-Google-Smtp-Source: APXvYqyq1Q6hectze4/JbUXooduK5ISp2JfEJLAuJC0Z6pGB9JgcEg6pO2QMf1kVNCHyloy4zveveg==
X-Received: by 2002:a0c:fe48:: with SMTP id u8mr71734548qvs.234.1558549936779;
        Wed, 22 May 2019 11:32:16 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id s12sm12175487qkm.38.2019.05.22.11.32.15
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 22 May 2019 11:32:16 -0700 (PDT)
Date:   Wed, 22 May 2019 11:32:12 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     toke@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, brouer@redhat.com, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next 1/2] net: xdp: refactor XDP_QUERY_PROG{,_HW} to
 netdev
Message-ID: <20190522113212.68aea474@cakuba.netronome.com>
In-Reply-To: <20190522125353.6106-2-bjorn.topel@gmail.com>
References: <20190522125353.6106-1-bjorn.topel@gmail.com>
        <20190522125353.6106-2-bjorn.topel@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 May 2019 14:53:51 +0200, Bj=C3=B6rn T=C3=B6pel wrote:
> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>=20
> All XDP capable drivers need to implement the XDP_QUERY_PROG{,_HW}
> command of ndo_bpf. The query code is fairly generic. This commit
> refactors the query code up from the drivers to the netdev level.
>=20
> The struct net_device has gained four new members tracking the XDP
> program, the corresponding program flags, and which programs
> (SKB_MODE, DRV_MODE or HW_MODE) that are activated.
>=20
> The xdp_prog member, previously only used for SKB_MODE, is shared with
> DRV_MODE, since they are mutually exclusive.
>=20
> The program query operations is all done under the rtnl lock. However,
> the xdp_prog member is __rcu annotated, and used in a lock-less manner
> for the SKB_MODE. This is because the xdp_prog member is shared from a
> query program perspective (again, SKB and DRV are mutual exclusive),
> RCU read and assignments functions are still used when altering
> xdp_prog, even when only for queries in DRV_MODE. This is for
> sparse/lockdep correctness.
>=20
> A minor behavioral change was done during this refactorization; When
> passing a negative file descriptor to a netdev to disable XDP, the
> same program flag as the running program is required. An example.
>=20
> The eth0 is DRV_DRV capable. Previously, this was OK, but confusing:
>=20
>   # ip link set dev eth0 xdp obj foo.o sec main
>   # ip link set dev eth0 xdpgeneric off
>=20
> Now, the same commands give:
>=20
>   # ip link set dev eth0 xdp obj foo.o sec main
>   # ip link set dev eth0 xdpgeneric off
>   Error: native and generic XDP can't be active at the same time.

I'm not clear why this change is necessary? It is a change in
behaviour, and if anything returning ENOENT would seem cleaner=20
in this case.

> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> ---
>  include/linux/netdevice.h |  13 +++--
>  net/core/dev.c            | 120 ++++++++++++++++++++------------------
>  net/core/rtnetlink.c      |  33 ++---------
>  3 files changed, 76 insertions(+), 90 deletions(-)
>=20
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 44b47e9df94a..bdcb20a3946c 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -1940,6 +1940,11 @@ struct net_device {
>  #endif
>  	struct hlist_node	index_hlist;
> =20
> +	struct bpf_prog		*xdp_prog_hw;
> +	unsigned int		xdp_flags;
> +	u32			xdp_prog_flags;
> +	u32			xdp_prog_hw_flags;

Do we really need 3 xdp flags variables?  Offloaded programs
realistically must have only the HW mode flag set (not sure if=20
netdevsim still pretends we can do offload of code after rewrites,
but if it does it can be changed :)).  Non-offloaded programs need
flags, but we don't need the "all ORed" flags either, AFAICT.  No?

> +
>  /*
>   * Cache lines mostly used on transmit path
>   */
> @@ -2045,9 +2050,8 @@ struct net_device {
> =20
>  static inline bool netif_elide_gro(const struct net_device *dev)
>  {
> -	if (!(dev->features & NETIF_F_GRO) || dev->xdp_prog)
> -		return true;
> -	return false;
> +	return !(dev->features & NETIF_F_GRO) ||
> +		dev->xdp_flags & XDP_FLAGS_SKB_MODE;
>  }
> =20
>  #define	NETDEV_ALIGN		32
> @@ -3684,8 +3688,7 @@ struct sk_buff *dev_hard_start_xmit(struct sk_buff =
*skb, struct net_device *dev,
>  typedef int (*bpf_op_t)(struct net_device *dev, struct netdev_bpf *bpf);
>  int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *ex=
tack,
>  		      int fd, u32 flags);
> -u32 __dev_xdp_query(struct net_device *dev, bpf_op_t xdp_op,
> -		    enum bpf_netdev_command cmd);
> +u32 dev_xdp_query(struct net_device *dev, unsigned int flags);
>  int xdp_umem_query(struct net_device *dev, u16 queue_id);
> =20
>  int __dev_forward_skb(struct net_device *dev, struct sk_buff *skb);
> diff --git a/net/core/dev.c b/net/core/dev.c
> index b6b8505cfb3e..ead16c3f955c 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -8005,31 +8005,31 @@ int dev_change_proto_down_generic(struct net_devi=
ce *dev, bool proto_down)
>  }
>  EXPORT_SYMBOL(dev_change_proto_down_generic);
> =20
> -u32 __dev_xdp_query(struct net_device *dev, bpf_op_t bpf_op,
> -		    enum bpf_netdev_command cmd)
> +u32 dev_xdp_query(struct net_device *dev, unsigned int flags)

You only pass the mode here, so perhaps rename the flags argument to
mode?

>  {
> -	struct netdev_bpf xdp;
> +	struct bpf_prog *prog =3D NULL;
> =20
> -	if (!bpf_op)
> +	if (hweight32(flags) !=3D 1)
>  		return 0;

This looks superfluous, given callers will always pass mode, right?

> -	memset(&xdp, 0, sizeof(xdp));
> -	xdp.command =3D cmd;
> -
> -	/* Query must always succeed. */
> -	WARN_ON(bpf_op(dev, &xdp) < 0 && cmd =3D=3D XDP_QUERY_PROG);
> +	if (flags & (XDP_FLAGS_SKB_MODE | XDP_FLAGS_DRV_MODE))
> +		prog =3D rtnl_dereference(dev->xdp_prog);
> +	else if (flags & XDP_FLAGS_HW_MODE)
> +		prog =3D dev->xdp_prog_hw;

Perhaps use a switch statement here?

> -	return xdp.prog_id;
> +	return prog ? prog->aux->id : 0;
>  }
> =20
> -static int dev_xdp_install(struct net_device *dev, bpf_op_t bpf_op,
> +static int dev_xdp_install(struct net_device *dev, unsigned int target,

Could you say mode instead of target everywhere?

>  			   struct netlink_ext_ack *extack, u32 flags,
>  			   struct bpf_prog *prog)
>  {
> +	bpf_op_t bpf_op =3D dev->netdev_ops->ndo_bpf;

The point of passing bpf_op around is to have the right one (generic or
driver) this is lost with the ternary statement below :S

>  	struct netdev_bpf xdp;
> +	int err;
> =20
>  	memset(&xdp, 0, sizeof(xdp));
> -	if (flags & XDP_FLAGS_HW_MODE)
> +	if (target =3D=3D XDP_FLAGS_HW_MODE)

Is this change necessary?

>  		xdp.command =3D XDP_SETUP_PROG_HW;
>  	else
>  		xdp.command =3D XDP_SETUP_PROG;
> @@ -8037,35 +8037,41 @@ static int dev_xdp_install(struct net_device *dev=
, bpf_op_t bpf_op,
>  	xdp.flags =3D flags;
>  	xdp.prog =3D prog;
> =20
> -	return bpf_op(dev, &xdp);
> +	err =3D (target =3D=3D XDP_FLAGS_SKB_MODE) ?

Brackets unnecessary.

> +	      generic_xdp_install(dev, &xdp) :
> +	      bpf_op(dev, &xdp);
> +	if (!err) {

Keep success path unindented, save indentation.

	if (err)
		return err;

	bla bla

	return 0;

> +		if (prog)
> +			dev->xdp_flags |=3D target;
> +		else
> +			dev->xdp_flags &=3D ~target;

These "all ORed" flags are not needed, AFAICT, as mentioned above.

> +		if (target =3D=3D XDP_FLAGS_HW_MODE) {
> +			dev->xdp_prog_hw =3D prog;
> +			dev->xdp_prog_hw_flags =3D flags;
> +		} else if (target =3D=3D XDP_FLAGS_DRV_MODE) {
> +			rcu_assign_pointer(dev->xdp_prog, prog);
> +			dev->xdp_prog_flags =3D flags;
> +		}
> +	}
> +
> +	return err;
>  }
> =20
>  static void dev_xdp_uninstall(struct net_device *dev)
>  {
> -	struct netdev_bpf xdp;
> -	bpf_op_t ndo_bpf;
> -
> -	/* Remove generic XDP */
> -	WARN_ON(dev_xdp_install(dev, generic_xdp_install, NULL, 0, NULL));
> -
> -	/* Remove from the driver */
> -	ndo_bpf =3D dev->netdev_ops->ndo_bpf;
> -	if (!ndo_bpf)
> -		return;
> -
> -	memset(&xdp, 0, sizeof(xdp));
> -	xdp.command =3D XDP_QUERY_PROG;
> -	WARN_ON(ndo_bpf(dev, &xdp));
> -	if (xdp.prog_id)
> -		WARN_ON(dev_xdp_install(dev, ndo_bpf, NULL, xdp.prog_flags,
> -					NULL));
> -
> -	/* Remove HW offload */
> -	memset(&xdp, 0, sizeof(xdp));
> -	xdp.command =3D XDP_QUERY_PROG_HW;
> -	if (!ndo_bpf(dev, &xdp) && xdp.prog_id)
> -		WARN_ON(dev_xdp_install(dev, ndo_bpf, NULL, xdp.prog_flags,
> -					NULL));
> +	if (dev->xdp_flags & XDP_FLAGS_SKB_MODE) {
> +		WARN_ON(dev_xdp_install(dev, XDP_FLAGS_SKB_MODE,
> +					NULL, 0, NULL));
> +	}

Brackets unnecessary.

> +	if (dev->xdp_flags & XDP_FLAGS_DRV_MODE) {
> +		WARN_ON(dev_xdp_install(dev, XDP_FLAGS_DRV_MODE,
> +					NULL, dev->xdp_prog_flags, NULL));
> +	}

You should be able to just call install with the original flags, and
install handler should do the right maths again to direct it either to
drv or generic, no?

> +	if (dev->xdp_flags & XDP_FLAGS_HW_MODE) {
> +		WARN_ON(dev_xdp_install(dev, XDP_FLAGS_HW_MODE,
> +					NULL, dev->xdp_prog_hw_flags, NULL));
> +	}
>  }
> =20
>  /**
> @@ -8080,41 +8086,41 @@ static void dev_xdp_uninstall(struct net_device *=
dev)
>  int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *ex=
tack,
>  		      int fd, u32 flags)
>  {
> -	const struct net_device_ops *ops =3D dev->netdev_ops;
> -	enum bpf_netdev_command query;
> +	bool offload, drv_supp =3D !!dev->netdev_ops->ndo_bpf;

Please avoid calculations in init.  If the function gets complicated
this just ends up as a weirdly indented code, which is hard to read.

>  	struct bpf_prog *prog =3D NULL;
> -	bpf_op_t bpf_op, bpf_chk;
> -	bool offload;
> +	unsigned int target;
>  	int err;
> =20
>  	ASSERT_RTNL();
> =20
>  	offload =3D flags & XDP_FLAGS_HW_MODE;
> -	query =3D offload ? XDP_QUERY_PROG_HW : XDP_QUERY_PROG;
> +	target =3D offload ? XDP_FLAGS_HW_MODE : XDP_FLAGS_DRV_MODE;
> =20
> -	bpf_op =3D bpf_chk =3D ops->ndo_bpf;
> -	if (!bpf_op && (flags & (XDP_FLAGS_DRV_MODE | XDP_FLAGS_HW_MODE))) {
> +	if (!drv_supp && (flags & (XDP_FLAGS_DRV_MODE | XDP_FLAGS_HW_MODE))) {

Here you have a bracket for & inside an &&..

>  		NL_SET_ERR_MSG(extack, "underlying driver does not support XDP in nati=
ve mode");
>  		return -EOPNOTSUPP;
>  	}
> -	if (!bpf_op || (flags & XDP_FLAGS_SKB_MODE))
> -		bpf_op =3D generic_xdp_install;
> -	if (bpf_op =3D=3D bpf_chk)
> -		bpf_chk =3D generic_xdp_install;
> +
> +	if (!drv_supp || (flags & XDP_FLAGS_SKB_MODE))
> +		target =3D XDP_FLAGS_SKB_MODE;
> +
> +	if ((mode =3D=3D XDP_FLAGS_SKB_MODE &&
> +	     dev->xdp_flags & XDP_FLAGS_DRV_MODE) ||

.. and here you don't :)

> +	    (target =3D=3D XDP_FLAGS_DRV_MODE &&
> +	     dev->xdp_flags & XDP_FLAGS_SKB_MODE)) {

I think this condition can be shortened.  You can't get a conflict if
the driver has no support.  So the only conflicting case is:

	rcu_access_pointer(dev->xdp_prog) && drv_supp &&
	(flags ^ dev->xdp_flags) & XDP_FLAGS_SKB_MODE

> +		NL_SET_ERR_MSG(extack, "native and generic XDP can't be active at the =
same time");
> +		return -EEXIST;
> +	}
> =20
>  	if (fd >=3D 0) {
> -		if (!offload && __dev_xdp_query(dev, bpf_chk, XDP_QUERY_PROG)) {
> -			NL_SET_ERR_MSG(extack, "native and generic XDP can't be active at the=
 same time");
> -			return -EEXIST;
> -		}
> -		if ((flags & XDP_FLAGS_UPDATE_IF_NOEXIST) &&
> -		    __dev_xdp_query(dev, bpf_op, query)) {
> +		if (flags & XDP_FLAGS_UPDATE_IF_NOEXIST &&
> +		    dev_xdp_query(dev, target)) {
>  			NL_SET_ERR_MSG(extack, "XDP program already attached");
>  			return -EBUSY;
>  		}
> =20
> -		prog =3D bpf_prog_get_type_dev(fd, BPF_PROG_TYPE_XDP,
> -					     bpf_op =3D=3D ops->ndo_bpf);
> +		prog =3D bpf_prog_get_type_dev(fd, BPF_PROG_TYPE_XDP, drv_supp);
> +

Extra new line.

>  		if (IS_ERR(prog))
>  			return PTR_ERR(prog);
> =20
> @@ -8125,7 +8131,7 @@ int dev_change_xdp_fd(struct net_device *dev, struc=
t netlink_ext_ack *extack,
>  		}
>  	}
> =20
> -	err =3D dev_xdp_install(dev, bpf_op, extack, flags, prog);
> +	err =3D dev_xdp_install(dev, target, extack, flags, prog);
>  	if (err < 0 && prog)
>  		bpf_prog_put(prog);
> =20

I think apart from returning the new error it looks functionally
correct :)
