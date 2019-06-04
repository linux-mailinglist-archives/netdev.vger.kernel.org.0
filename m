Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA78634B92
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 17:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727896AbfFDPHG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 11:07:06 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:43752 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727822AbfFDPHG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 11:07:06 -0400
Received: by mail-pg1-f195.google.com with SMTP id f25so10522415pgv.10;
        Tue, 04 Jun 2019 08:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lZ0bGZQE6yIs043Fz+OmF3eyijlcj946m6YOpkV+drI=;
        b=l+jYuyW4AXb7FBGEwAQ+5PDzxD4iVedlwOux/nUKLDNW+XNwzR34dfp1JxN2pgUWYp
         oJuURHUG3N2b1naw7xFNWOWWzMS1Kj9wUsgus534funBXu65+o4FsuTZ/kKy6PbmRPiA
         hFDxWrSmbJplFO6cMu8I2lt441QH8hn1sIkfMwl3Bjebjgxv9F4bOOL5PAeL44x6T1fI
         BW9TXRt0wZDei0HPa7s7n6bfbnmo6V5EXMJytXb8F+ZNI2vcQmWNVKEskhaZOXwh8yJw
         nOqNlBvA49dix5EJZtj3l/Tl0nE3T6PAn53zIr1oD1YWEC/AnmH1nN3q8EIwPcKN2LVV
         kynw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lZ0bGZQE6yIs043Fz+OmF3eyijlcj946m6YOpkV+drI=;
        b=SoPEo1I2v4rLfg1OHnxe2BdDf7UdBydpn5kTCJnJlcEYaUagTOcBaGCuScecISKXX0
         TpN0PK8J3aWf9yofktAaB+XrkXd48pHv9l5SrUmHduKZseeFLZtHRVFOjMT0IvT8tHQV
         OsB3eVzHzHJCVTg5vbFsT+yxbgBXDAonWtaGi6V1TAYmbTeupmXoi7msQkkTMfn5mUmv
         Ncp8Al7O3QbxSDU99T2XE5wjMC5IfHLqkgYJyL8z2OY80N0+PPUelsJVVLCLboul4/Wb
         viUI4YaR0CFptyrRnTrAQJeAdulr3hy5ZlAoMn3kHdT2y1GlsUEaSl2eQhRGYCbusNUv
         8T4g==
X-Gm-Message-State: APjAAAW2U3KXAlQVtvB2dwbJulAyS7m/7FmD2S3mOCRb3l8w+2ySyy4J
        SB6yXfZQGaly4sXGgV1fxXqeYmjfTQc=
X-Google-Smtp-Source: APXvYqxKfn2khtVg6b5vR8Dnap9ttjxAu/6vR15sUDBlQjU38lJhn2Vl47eapDHpPHYHDzXkDwZpDg==
X-Received: by 2002:a62:5581:: with SMTP id j123mr39373064pfb.102.1559660825111;
        Tue, 04 Jun 2019 08:07:05 -0700 (PDT)
Received: from localhost ([192.55.54.40])
        by smtp.gmail.com with ESMTPSA id u4sm17828257pfu.26.2019.06.04.08.07.02
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Jun 2019 08:07:04 -0700 (PDT)
Date:   Tue, 4 Jun 2019 17:06:57 +0200
From:   Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
To:     =?ISO-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>
Cc:     magnus.karlsson@intel.com, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, jakub.kicinski@netronome.com,
        jonathan.lemon@gmail.com, songliubraving@fb.com,
        bpf <bpf@vger.kernel.org>
Subject: Re: [RFC PATCH bpf-next 3/4] libbpf: move xdp program removal to
 libbpf
Message-ID: <20190604170657.000060ac@gmail.com>
In-Reply-To: <cf7cf390-39b4-7430-107e-97f068f9c3d9@intel.com>
References: <20190603131907.13395-1-maciej.fijalkowski@intel.com>
        <20190603131907.13395-4-maciej.fijalkowski@intel.com>
        <cf7cf390-39b4-7430-107e-97f068f9c3d9@intel.com>
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.32; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 4 Jun 2019 10:07:25 +0200
Bj=F6rn T=F6pel <bjorn.topel@intel.com> wrote:

>=20
> On 2019-06-03 15:19, Maciej Fijalkowski wrote:
> > Since xsk support in libbpf loads the xdp program interface, make it
> > also responsible for its removal. Store the prog id in xsk_socket_config
> > so when removing the program we are still able to compare the current
> > program id with the id from the attachment time and make a decision
> > onward.
> >=20
> > While at it, remove the socket/umem in xdpsock's error path.
> >
>=20
> We're loading a new, or reusing an existing XDP program at socket
> creation, but tearing it down at *socket delete* is explicitly left to
> the application.

Are you describing here the old behavior?

>=20
> For a per-queue XDP program (tied to the socket), this kind cleanup would
> make sense.
>=20
> The intention with the libbpf AF_XDP support was to leave the XDP
> handling to whatever XDP orchestration process availble. It's not part
> of libbpf. For convenience, *loading/lookup of the XDP program* was
> added even though this was an asymmetry.

Hmmm ok and I tried to make it symmetric :p=20

>=20
> For the sample application, this makes sense, but for larger/real
> applications?
>

Tough questions on those real apps!


> OTOH I like the idea of a scoped cleanup "when all sockets are gone",
> the XDP program + maps are removed.

That's happening with patch 4 included from this set (in case it gets fixed=
 :))

>=20
> > Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > ---
> >   samples/bpf/xdpsock_user.c | 33 ++++++++++-----------------------
> >   tools/lib/bpf/xsk.c        | 32 ++++++++++++++++++++++++++++++++
> >   tools/lib/bpf/xsk.h        |  1 +
> >   3 files changed, 43 insertions(+), 23 deletions(-)
> >=20
> > diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
> > index e9dceb09b6d1..123862b16dd4 100644
> > --- a/samples/bpf/xdpsock_user.c
> > +++ b/samples/bpf/xdpsock_user.c
> > @@ -68,7 +68,6 @@ static int opt_queue;
> >   static int opt_poll;
> >   static int opt_interval =3D 1;
> >   static u32 opt_xdp_bind_flags;
> > -static __u32 prog_id;
> >  =20
> >   struct xsk_umem_info {
> >   	struct xsk_ring_prod fq;
> > @@ -170,22 +169,6 @@ static void *poller(void *arg)
> >   	return NULL;
> >   }
> >  =20
> > -static void remove_xdp_program(void)
> > -{
> > -	__u32 curr_prog_id =3D 0;
> > -
> > -	if (bpf_get_link_xdp_id(opt_ifindex, &curr_prog_id, opt_xdp_flags)) {
> > -		printf("bpf_get_link_xdp_id failed\n");
> > -		exit(EXIT_FAILURE);
> > -	}
> > -	if (prog_id =3D=3D curr_prog_id)
> > -		bpf_set_link_xdp_fd(opt_ifindex, -1, opt_xdp_flags);
> > -	else if (!curr_prog_id)
> > -		printf("couldn't find a prog id on a given interface\n");
> > -	else
> > -		printf("program on interface changed, not removing\n");
> > -}
> > -
> >   static void int_exit(int sig)
> >   {
> >   	struct xsk_umem *umem =3D xsks[0]->umem->umem;
> > @@ -195,7 +178,6 @@ static void int_exit(int sig)
> >   	dump_stats();
> >   	xsk_socket__delete(xsks[0]->xsk);
> >   	(void)xsk_umem__delete(umem);
> > -	remove_xdp_program();
> >  =20
> >   	exit(EXIT_SUCCESS);
> >   }
> > @@ -206,7 +188,16 @@ static void __exit_with_error(int error, const cha=
r *file, const char *func,
> >   	fprintf(stderr, "%s:%s:%i: errno: %d/\"%s\"\n", file, func,
> >   		line, error, strerror(error));
> >   	dump_stats();
> > -	remove_xdp_program();
> > +
> > +	if (xsks[0]->xsk)
> > +		xsk_socket__delete(xsks[0]->xsk);
> > +
> > +	if (xsks[0]->umem) {
> > +		struct xsk_umem *umem =3D xsks[0]->umem->umem;
> > +
> > +		(void)xsk_umem__delete(umem);
> > +	}
> > +
> >   	exit(EXIT_FAILURE);
> >   }
> >  =20
> > @@ -312,10 +303,6 @@ static struct xsk_socket_info *xsk_configure_socke=
t(struct xsk_umem_info *umem)
> >   	if (ret)
> >   		exit_with_error(-ret);
> >  =20
> > -	ret =3D bpf_get_link_xdp_id(opt_ifindex, &prog_id, opt_xdp_flags);
> > -	if (ret)
> > -		exit_with_error(-ret);
> > -
> >   	return xsk;
> >   }
> >  =20
> > diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> > index 514ab3fb06f4..e28bedb0b078 100644
> > --- a/tools/lib/bpf/xsk.c
> > +++ b/tools/lib/bpf/xsk.c
> > @@ -259,6 +259,8 @@ int xsk_umem__create(struct xsk_umem **umem_ptr, vo=
id *umem_area, __u64 size,
> >   static int xsk_load_xdp_prog(struct xsk_socket *xsk)
> >   {
> >   	static const int log_buf_size =3D 16 * 1024;
> > +	struct bpf_prog_info info =3D {};
> > +	__u32 info_len =3D sizeof(info);
> >   	char log_buf[log_buf_size];
> >   	int err, prog_fd;
> >  =20
> > @@ -321,6 +323,14 @@ static int xsk_load_xdp_prog(struct xsk_socket *xs=
k)
> >   		return err;
> >   	}
> >  =20
> > +	err =3D bpf_obj_get_info_by_fd(prog_fd, &info, &info_len);
> > +	if (err) {
> > +		pr_warning("can't get prog info - %s\n", strerror(errno));
> > +		close(prog_fd);
> > +		return err;
> > +	}
> > +	xsk->config.prog_id =3D info.id;
> > +
> >   	xsk->prog_fd =3D prog_fd;
> >   	return 0;
> >   }
> > @@ -483,6 +493,25 @@ static int xsk_set_bpf_maps(struct xsk_socket *xsk)
> >   	return err;
> >   }
> >  =20
> > +static void xsk_remove_xdp_prog(struct xsk_socket *xsk)
> > +{
> > +	__u32 prog_id =3D xsk->config.prog_id;
> > +	__u32 curr_prog_id =3D 0;
> > +	int err;
> > +
> > +	err =3D bpf_get_link_xdp_id(xsk->ifindex, &curr_prog_id,
> > +				  xsk->config.xdp_flags);
> > +	if (err)
> > +		return;
> > +
> > +	if (prog_id =3D=3D curr_prog_id)
> > +		bpf_set_link_xdp_fd(xsk->ifindex, -1, xsk->config.xdp_flags);
> > +	else if (!curr_prog_id)
> > +		pr_warning("couldn't find a prog id on a given interface\n");
> > +	else
> > +		pr_warning("program on interface changed, not removing\n");
> > +}
> > +
> >   static int xsk_setup_xdp_prog(struct xsk_socket *xsk)
> >   {
> >   	__u32 prog_id =3D 0;
> > @@ -506,6 +535,7 @@ static int xsk_setup_xdp_prog(struct xsk_socket *xs=
k)
> >   		err =3D xsk_lookup_bpf_maps(xsk);
> >   		if (err)
> >   			goto out_load;
> > +		xsk->config.prog_id =3D prog_id;
> >   	}
> >  =20
> >   	err =3D xsk_set_bpf_maps(xsk);
> > @@ -744,6 +774,8 @@ void xsk_socket__delete(struct xsk_socket *xsk)
> >  =20
> >   	}
> >  =20
> > +	xsk_remove_xdp_prog(xsk);
> > +
> >   	xsk->umem->refcount--;
> >   	/* Do not close an fd that also has an associated umem connected
> >   	 * to it.
> > diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
> > index 82ea71a0f3ec..e1b23e9432c9 100644
> > --- a/tools/lib/bpf/xsk.h
> > +++ b/tools/lib/bpf/xsk.h
> > @@ -186,6 +186,7 @@ struct xsk_socket_config {
> >   	__u32 tx_size;
> >   	__u32 libbpf_flags;
> >   	__u32 xdp_flags;
> > +	__u32 prog_id;
> >   	__u16 bind_flags;
> >   };
> >  =20
> >=20

