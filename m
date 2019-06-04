Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 637C234B9A
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 17:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728031AbfFDPHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 11:07:31 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:34766 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728015AbfFDPHa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 11:07:30 -0400
Received: by mail-pf1-f193.google.com with SMTP id c85so4080256pfc.1;
        Tue, 04 Jun 2019 08:07:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Qzju9wFmQ5g3zHGi4eCtzodcjdwr3u6xaLUhLqQ1hag=;
        b=MHVObJYEgx3x0KdZQyrPq1SdhFhe+oR+jC80itpNujeSIX69FP29atOKiylh17h46w
         TmRquSTh/WrfAyPT8Qdk9PZbRwFDyT9WtDrinVCJOk/8j07ONVA6P5m1xMt1yJry+4TB
         schUKE9awcgYZRS5YyrX1MDBeBKkJcQdgetpjcXxZK7fyJZDqdOme+tTC7aaJJoUGMLm
         d0mbN956d3y3QALYE/Wf7Z2zTssugNaIjvtPGIDxzR2PjS/KmTuR8EIzqTk4NjE/R8ic
         8WzII3GzyLo4lJWoSxla0BMI1n1ynrTMDt2/u04h+V2oB5bBWuXkgnihHEhugT5gO9Sp
         VKEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Qzju9wFmQ5g3zHGi4eCtzodcjdwr3u6xaLUhLqQ1hag=;
        b=EFSUrjyJ7cZihY9ZM/rIXBUcsGLf2qX3s8C0MgYOrR/GqTJ2rg/0t1E0/Syjarc2cO
         dHcFr8Uk6O/qcZBt6oV9BqNzUKXQ1seeSSciyZsFPf+oNXer3fr5LQow/DgJbX4rl0no
         GatMasLtIVDhgGkWclxwRSsjGrBSF3yyhm2WYZEoyJFtwFcbPBJNdWN5KxLjszkURdWS
         TqsdoSOXlv/k+2wN64qAFF/p1FfhhUuCFxXIlXQKj0oxnZPSaxmQN6F1gi/CEoS7w6+9
         +w1LhLll/j9xwVX5u8lkDuEqMBEJUJnJZ5RfUvPMuMauW8dt4bNsKDG2LX1TdAd5dq0H
         KhzA==
X-Gm-Message-State: APjAAAVo8rbd/IHsZc7BEyfDKB4B/dXVYYoabVgbydfsx91ZvmiZfuOg
        uUhd1BjaQVD5q1Dbgf9+nHA=
X-Google-Smtp-Source: APXvYqzNQN6U1Jymzr1sqNwD8uuLgIcslXHTYpRa7EpXekn2hj0cc4awAMXoUP6R6uA1PDi5bNaIrg==
X-Received: by 2002:a17:90a:2ec9:: with SMTP id h9mr38875289pjs.130.1559660849899;
        Tue, 04 Jun 2019 08:07:29 -0700 (PDT)
Received: from localhost ([192.55.54.40])
        by smtp.gmail.com with ESMTPSA id k1sm2458433pjp.2.2019.06.04.08.07.27
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 04 Jun 2019 08:07:29 -0700 (PDT)
Date:   Tue, 4 Jun 2019 17:07:22 +0200
From:   Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
To:     =?ISO-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>
Cc:     magnus.karlsson@intel.com, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, jakub.kicinski@netronome.com,
        jonathan.lemon@gmail.com, songliubraving@fb.com,
        bpf <bpf@vger.kernel.org>
Subject: Re: [RFC PATCH bpf-next 4/4] libbpf: don't remove eBPF resources
 when other xsks are present
Message-ID: <20190604170722.000021b5@gmail.com>
In-Reply-To: <470fba94-a47f-83bd-d2c4-83d424dafb38@intel.com>
References: <20190603131907.13395-1-maciej.fijalkowski@intel.com>
        <20190603131907.13395-5-maciej.fijalkowski@intel.com>
        <470fba94-a47f-83bd-d2c4-83d424dafb38@intel.com>
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.32; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 4 Jun 2019 10:08:03 +0200
Bj=F6rn T=F6pel <bjorn.topel@intel.com> wrote:

> On 2019-06-03 15:19, Maciej Fijalkowski wrote:
> > In case where multiple xsk sockets are attached to a single interface
> > and one of them gets detached, the eBPF maps and program are removed.
> > This should not happen as the rest of xsksocks are still using these
> > resources.
> >=20
> > In order to fix that, let's have an additional eBPF map with a single
> > entry that will be used as a xsks count. During the xsk_socket__delete,
> > remove the resources only when this count is equal to 0.  This map is
> > not being accessed from eBPF program, so the verifier is not associating
> > it with the prog, which in turn makes bpf_obj_get_info_by_fd not
> > reporting this map in nr_map_ids field of struct bpf_prog_info. The
> > described behaviour brings the need to have this map pinned, so in
> > case when socket is being created and the libbpf detects the presence of
> > bpf resources, it will be able to access that map.
> >
>=20
> This commit is only needed after #3 is applied, right? So, this is a way=
=20
> of refcounting XDP socks?

Yes, but as you pointed out it needs synchronization.

>=20
>=20
> > Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > ---
> >   tools/lib/bpf/xsk.c | 59 ++++++++++++++++++++++++++++++++++++++++++++=
+--------
> >   1 file changed, 51 insertions(+), 8 deletions(-)
> >=20
> > diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> > index e28bedb0b078..88d2c931ad14 100644
> > --- a/tools/lib/bpf/xsk.c
> > +++ b/tools/lib/bpf/xsk.c
> > @@ -44,6 +44,8 @@
> >    #define PF_XDP AF_XDP
> >   #endif
> >  =20
> > +#define XSKS_CNT_MAP_PATH "/sys/fs/bpf/xsks_cnt_map"
> > +
> >   struct xsk_umem {
> >   	struct xsk_ring_prod *fill;
> >   	struct xsk_ring_cons *comp;
> > @@ -65,6 +67,7 @@ struct xsk_socket {
> >   	int prog_fd;
> >   	int qidconf_map_fd;
> >   	int xsks_map_fd;
> > +	int xsks_cnt_map_fd;
> >   	__u32 queue_id;
> >   	char ifname[IFNAMSIZ];
> >   };
> > @@ -372,7 +375,7 @@ static int xsk_get_max_queues(struct xsk_socket *xs=
k)
> >   static int xsk_create_bpf_maps(struct xsk_socket *xsk)
> >   {
> >   	int max_queues;
> > -	int fd;
> > +	int fd, ret;
> >  =20
> >   	max_queues =3D xsk_get_max_queues(xsk);
> >   	if (max_queues < 0)
> > @@ -392,6 +395,24 @@ static int xsk_create_bpf_maps(struct xsk_socket *=
xsk)
> >   	}
> >   	xsk->xsks_map_fd =3D fd;
> >  =20
> > +	fd =3D bpf_create_map_name(BPF_MAP_TYPE_ARRAY, "xsks_cnt_map",
> > +				 sizeof(int), sizeof(int), 1, 0);
> > +	if (fd < 0) {
> > +		close(xsk->qidconf_map_fd);
> > +		close(xsk->xsks_map_fd);
> > +		return fd;
> > +	}
> > +
> > +	ret =3D bpf_obj_pin(fd, XSKS_CNT_MAP_PATH);
> > +	if (ret < 0) {
> > +		pr_warning("pinning map failed; is bpffs mounted?\n");
> > +		close(xsk->qidconf_map_fd);
> > +		close(xsk->xsks_map_fd);
> > +		close(fd);
> > +		return ret;
> > +	}
> > +	xsk->xsks_cnt_map_fd =3D fd;
> > +
> >   	return 0;
> >   }
> >  =20
> > @@ -456,8 +477,10 @@ static int xsk_lookup_bpf_maps(struct xsk_socket *=
xsk)
> >   		close(fd);
> >   	}
> >  =20
> > +	xsk->xsks_cnt_map_fd =3D bpf_obj_get(XSKS_CNT_MAP_PATH);
> >   	err =3D 0;
> > -	if (xsk->qidconf_map_fd < 0 || xsk->xsks_map_fd < 0) {
> > +	if (xsk->qidconf_map_fd < 0 || xsk->xsks_map_fd < 0 ||
> > +	    xsk->xsks_cnt_map_fd < 0) {
> >   		err =3D -ENOENT;
> >   		xsk_delete_bpf_maps(xsk);
> >   	}
> > @@ -467,17 +490,25 @@ static int xsk_lookup_bpf_maps(struct xsk_socket =
*xsk)
> >   	return err;
> >   }
> >  =20
> > -static void xsk_clear_bpf_maps(struct xsk_socket *xsk)
> > +static void xsk_clear_bpf_maps(struct xsk_socket *xsk, long *xsks_cnt_=
ptr)
> >   {
> > +	long xsks_cnt, key =3D 0;
> >   	int qid =3D false;
> >  =20
> >   	bpf_map_update_elem(xsk->qidconf_map_fd, &xsk->queue_id, &qid, 0);
> >   	bpf_map_delete_elem(xsk->xsks_map_fd, &xsk->queue_id);
> > +	bpf_map_lookup_elem(xsk->xsks_cnt_map_fd, &key, &xsks_cnt);
> > +	if (xsks_cnt)
> > +		xsks_cnt--;
> > +	bpf_map_update_elem(xsk->xsks_cnt_map_fd, &key, &xsks_cnt, 0);
> > +	if (xsks_cnt_ptr)
> > +		*xsks_cnt_ptr =3D xsks_cnt;
>=20
> This refcount scheme will not work; There's no synchronization between=20
> the updates (cross process)!

Ugh, shame. Let me fix this in v2 :(

>=20
> >   }
> >  =20
> >   static int xsk_set_bpf_maps(struct xsk_socket *xsk)
> >   {
> >   	int qid =3D true, fd =3D xsk->fd, err;
> > +	long xsks_cnt, key =3D 0;
> >  =20
> >   	err =3D bpf_map_update_elem(xsk->qidconf_map_fd, &xsk->queue_id, &qi=
d, 0);
> >   	if (err)
> > @@ -487,9 +518,18 @@ static int xsk_set_bpf_maps(struct xsk_socket *xsk)
> >   	if (err)
> >   		goto out;
> >  =20
> > +	err =3D bpf_map_lookup_elem(xsk->xsks_cnt_map_fd, &key, &xsks_cnt);
> > +	if (err)
> > +		goto out;
> > +
> > +	xsks_cnt++;
> > +	err =3D bpf_map_update_elem(xsk->xsks_cnt_map_fd, &key, &xsks_cnt, 0);
> > +	if (err)
> > +		goto out;
> > +
>=20
> Dito.
>=20
> >   	return 0;
> >   out:
> > -	xsk_clear_bpf_maps(xsk);
> > +	xsk_clear_bpf_maps(xsk, NULL);
> >   	return err;
> >   }
> >  =20
> > @@ -752,13 +792,18 @@ void xsk_socket__delete(struct xsk_socket *xsk)
> >   	size_t desc_sz =3D sizeof(struct xdp_desc);
> >   	struct xdp_mmap_offsets off;
> >   	socklen_t optlen;
> > +	long xsks_cnt;
> >   	int err;
> >  =20
> >   	if (!xsk)
> >   		return;
> >  =20
> > -	xsk_clear_bpf_maps(xsk);
> > -	xsk_delete_bpf_maps(xsk);
> > +	xsk_clear_bpf_maps(xsk, &xsks_cnt);
> > +	unlink(XSKS_CNT_MAP_PATH);
> > +	if (!xsks_cnt) {
> > +		xsk_delete_bpf_maps(xsk);
> > +		xsk_remove_xdp_prog(xsk);
> > +	}
> >  =20
> >   	optlen =3D sizeof(off);
> >   	err =3D getsockopt(xsk->fd, SOL_XDP, XDP_MMAP_OFFSETS, &off, &optlen=
);
> > @@ -774,8 +819,6 @@ void xsk_socket__delete(struct xsk_socket *xsk)
> >  =20
> >   	}
> >  =20
> > -	xsk_remove_xdp_prog(xsk);
> > -
> >   	xsk->umem->refcount--;
> >   	/* Do not close an fd that also has an associated umem connected
> >   	 * to it.
> >=20

