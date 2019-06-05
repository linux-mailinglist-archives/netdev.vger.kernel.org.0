Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD65C359A1
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 11:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727038AbfFEJ0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 05:26:30 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:43805 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726949AbfFEJ0a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 05:26:30 -0400
Received: by mail-qt1-f196.google.com with SMTP id z24so10001169qtj.10;
        Wed, 05 Jun 2019 02:26:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=F++nel7lS9eoNVPQMlQhx5ZGrGcpLMY+3HulJqYgktE=;
        b=H5zEp1yRS7Jc5ICSMfzMVRBci+y6SRN8C27qBTOumkY6tQy4QHa7mZYcfwUVCOsgEB
         +Nc0GkIDyqZbyEWP3WLM1pxAI2bMl6VgxgUEQ/U93FrdoiZoZMqGnxOmKxYYIwVaJfGZ
         B/+7QaG4cW+xtXXmq1MxaXQRI7fykoMl1yN8xAL547BWUkHUDydsdLiYhQG9uq10/uY2
         zgp4bqc0phDyVcRy5jTwBY1tzUbZYF+u423axt/ZzFfvhYFSjtJ1xlm8nCKJGbTKU1jf
         lkgg8yLkHMTVVZ9kQch/x3j/SorNslBIpbGK8zWAaM8T1UdGq0Hsi9cAOsDntrTxdek7
         mBDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=F++nel7lS9eoNVPQMlQhx5ZGrGcpLMY+3HulJqYgktE=;
        b=OPSrn3pLPyd5+5rCZGQha6pNbMBaw7ASqFvfPtnF3xfcWWbIHizVnNeciCQMMt62wJ
         Z8mB+oxEnJ0DVwknHeVtE2KmKKBLB3Hc+Z117QPZnvxKHj/NZt2vywZF5sekJRCfJ68U
         vDMCG+GBRBDKs0XTc3XM5Jo0lrxVMxqO2HuolkRecLgpGPBiHQ6VbMyE8nbZ4J5SrZLe
         /P5Cs/kxPZYtcIKfhQ+L+4PrtgTsVys3lML5bsDN5ZxNcoFKeC/eiZ+cUmDUmULP45db
         y5Hpd9PzteaRwkMxD0on4cx1GrkGl3KqCQ0td5YsPcPKI1QUaqxU3fe5yj5Xi+Bz09IQ
         MU6Q==
X-Gm-Message-State: APjAAAWxagkHWpidpOEGYFXVT11kV1o5/hFpuJLCaop0ggwwe/mA3dMm
        d1puAzDOqlg5s4xVIwbDt9++jTPYxO+lvWbi3E4=
X-Google-Smtp-Source: APXvYqwYzJSfqWiAMH0D9gaoGNEUqxK7R1vJ9XE7ukGsWttz7IBqFX9oAZqhi0ATa96HkGO6qgIj36TGXzE44AlE60A=
X-Received: by 2002:a0c:adef:: with SMTP id x44mr11641682qvc.153.1559726788651;
 Wed, 05 Jun 2019 02:26:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190603131907.13395-1-maciej.fijalkowski@intel.com>
 <20190603131907.13395-5-maciej.fijalkowski@intel.com> <470fba94-a47f-83bd-d2c4-83d424dafb38@intel.com>
 <20190604170722.000021b5@gmail.com>
In-Reply-To: <20190604170722.000021b5@gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Wed, 5 Jun 2019 11:26:17 +0200
Message-ID: <CAJ+HfNh9+LpzDRNdL-zjNKcnj-arbYN62rqPgoYko2D+zTHd3g@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 4/4] libbpf: don't remove eBPF resources when
 other xsks are present
To:     Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Song Liu <songliubraving@fb.com>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 4 Jun 2019 at 17:07, Maciej Fijalkowski
<maciejromanfijalkowski@gmail.com> wrote:
>
> On Tue, 4 Jun 2019 10:08:03 +0200
> Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com> wrote:
>
> > On 2019-06-03 15:19, Maciej Fijalkowski wrote:
> > > In case where multiple xsk sockets are attached to a single interface
> > > and one of them gets detached, the eBPF maps and program are removed.
> > > This should not happen as the rest of xsksocks are still using these
> > > resources.
> > >
> > > In order to fix that, let's have an additional eBPF map with a single
> > > entry that will be used as a xsks count. During the xsk_socket__delet=
e,
> > > remove the resources only when this count is equal to 0.  This map is
> > > not being accessed from eBPF program, so the verifier is not associat=
ing
> > > it with the prog, which in turn makes bpf_obj_get_info_by_fd not
> > > reporting this map in nr_map_ids field of struct bpf_prog_info. The
> > > described behaviour brings the need to have this map pinned, so in
> > > case when socket is being created and the libbpf detects the presence=
 of
> > > bpf resources, it will be able to access that map.
> > >
> >
> > This commit is only needed after #3 is applied, right? So, this is a wa=
y
> > of refcounting XDP socks?
>
> Yes, but as you pointed out it needs synchronization.
>
> >
> >
> > > Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > > ---
> > >   tools/lib/bpf/xsk.c | 59 ++++++++++++++++++++++++++++++++++++++++++=
+++--------
> > >   1 file changed, 51 insertions(+), 8 deletions(-)
> > >
> > > diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> > > index e28bedb0b078..88d2c931ad14 100644
> > > --- a/tools/lib/bpf/xsk.c
> > > +++ b/tools/lib/bpf/xsk.c
> > > @@ -44,6 +44,8 @@
> > >    #define PF_XDP AF_XDP
> > >   #endif
> > >
> > > +#define XSKS_CNT_MAP_PATH "/sys/fs/bpf/xsks_cnt_map"
> > > +
> > >   struct xsk_umem {
> > >     struct xsk_ring_prod *fill;
> > >     struct xsk_ring_cons *comp;
> > > @@ -65,6 +67,7 @@ struct xsk_socket {
> > >     int prog_fd;
> > >     int qidconf_map_fd;
> > >     int xsks_map_fd;
> > > +   int xsks_cnt_map_fd;
> > >     __u32 queue_id;
> > >     char ifname[IFNAMSIZ];
> > >   };
> > > @@ -372,7 +375,7 @@ static int xsk_get_max_queues(struct xsk_socket *=
xsk)
> > >   static int xsk_create_bpf_maps(struct xsk_socket *xsk)
> > >   {
> > >     int max_queues;
> > > -   int fd;
> > > +   int fd, ret;
> > >
> > >     max_queues =3D xsk_get_max_queues(xsk);
> > >     if (max_queues < 0)
> > > @@ -392,6 +395,24 @@ static int xsk_create_bpf_maps(struct xsk_socket=
 *xsk)
> > >     }
> > >     xsk->xsks_map_fd =3D fd;
> > >
> > > +   fd =3D bpf_create_map_name(BPF_MAP_TYPE_ARRAY, "xsks_cnt_map",
> > > +                            sizeof(int), sizeof(int), 1, 0);
> > > +   if (fd < 0) {
> > > +           close(xsk->qidconf_map_fd);
> > > +           close(xsk->xsks_map_fd);
> > > +           return fd;
> > > +   }
> > > +
> > > +   ret =3D bpf_obj_pin(fd, XSKS_CNT_MAP_PATH);
> > > +   if (ret < 0) {
> > > +           pr_warning("pinning map failed; is bpffs mounted?\n");
> > > +           close(xsk->qidconf_map_fd);
> > > +           close(xsk->xsks_map_fd);
> > > +           close(fd);
> > > +           return ret;
> > > +   }
> > > +   xsk->xsks_cnt_map_fd =3D fd;
> > > +
> > >     return 0;
> > >   }
> > >
> > > @@ -456,8 +477,10 @@ static int xsk_lookup_bpf_maps(struct xsk_socket=
 *xsk)
> > >             close(fd);
> > >     }
> > >
> > > +   xsk->xsks_cnt_map_fd =3D bpf_obj_get(XSKS_CNT_MAP_PATH);
> > >     err =3D 0;
> > > -   if (xsk->qidconf_map_fd < 0 || xsk->xsks_map_fd < 0) {
> > > +   if (xsk->qidconf_map_fd < 0 || xsk->xsks_map_fd < 0 ||
> > > +       xsk->xsks_cnt_map_fd < 0) {
> > >             err =3D -ENOENT;
> > >             xsk_delete_bpf_maps(xsk);
> > >     }
> > > @@ -467,17 +490,25 @@ static int xsk_lookup_bpf_maps(struct xsk_socke=
t *xsk)
> > >     return err;
> > >   }
> > >
> > > -static void xsk_clear_bpf_maps(struct xsk_socket *xsk)
> > > +static void xsk_clear_bpf_maps(struct xsk_socket *xsk, long *xsks_cn=
t_ptr)
> > >   {
> > > +   long xsks_cnt, key =3D 0;
> > >     int qid =3D false;
> > >
> > >     bpf_map_update_elem(xsk->qidconf_map_fd, &xsk->queue_id, &qid, 0)=
;
> > >     bpf_map_delete_elem(xsk->xsks_map_fd, &xsk->queue_id);
> > > +   bpf_map_lookup_elem(xsk->xsks_cnt_map_fd, &key, &xsks_cnt);
> > > +   if (xsks_cnt)
> > > +           xsks_cnt--;
> > > +   bpf_map_update_elem(xsk->xsks_cnt_map_fd, &key, &xsks_cnt, 0);
> > > +   if (xsks_cnt_ptr)
> > > +           *xsks_cnt_ptr =3D xsks_cnt;
> >
> > This refcount scheme will not work; There's no synchronization between
> > the updates (cross process)!
>
> Ugh, shame. Let me fix this in v2 :(
>

Ok!

Hmm, there's no way of doing lock_xadds from bpf syscall, right? Any
thoughts how to do this? Maybe there's a need for a sock_ops prog for
XDP sockets...


Bj=C3=B6rn



> >
> > >   }
> > >
> > >   static int xsk_set_bpf_maps(struct xsk_socket *xsk)
> > >   {
> > >     int qid =3D true, fd =3D xsk->fd, err;
> > > +   long xsks_cnt, key =3D 0;
> > >
> > >     err =3D bpf_map_update_elem(xsk->qidconf_map_fd, &xsk->queue_id, =
&qid, 0);
> > >     if (err)
> > > @@ -487,9 +518,18 @@ static int xsk_set_bpf_maps(struct xsk_socket *x=
sk)
> > >     if (err)
> > >             goto out;
> > >
> > > +   err =3D bpf_map_lookup_elem(xsk->xsks_cnt_map_fd, &key, &xsks_cnt=
);
> > > +   if (err)
> > > +           goto out;
> > > +
> > > +   xsks_cnt++;
> > > +   err =3D bpf_map_update_elem(xsk->xsks_cnt_map_fd, &key, &xsks_cnt=
, 0);
> > > +   if (err)
> > > +           goto out;
> > > +
> >
> > Dito.
> >
> > >     return 0;
> > >   out:
> > > -   xsk_clear_bpf_maps(xsk);
> > > +   xsk_clear_bpf_maps(xsk, NULL);
> > >     return err;
> > >   }
> > >
> > > @@ -752,13 +792,18 @@ void xsk_socket__delete(struct xsk_socket *xsk)
> > >     size_t desc_sz =3D sizeof(struct xdp_desc);
> > >     struct xdp_mmap_offsets off;
> > >     socklen_t optlen;
> > > +   long xsks_cnt;
> > >     int err;
> > >
> > >     if (!xsk)
> > >             return;
> > >
> > > -   xsk_clear_bpf_maps(xsk);
> > > -   xsk_delete_bpf_maps(xsk);
> > > +   xsk_clear_bpf_maps(xsk, &xsks_cnt);
> > > +   unlink(XSKS_CNT_MAP_PATH);
> > > +   if (!xsks_cnt) {
> > > +           xsk_delete_bpf_maps(xsk);
> > > +           xsk_remove_xdp_prog(xsk);
> > > +   }
> > >
> > >     optlen =3D sizeof(off);
> > >     err =3D getsockopt(xsk->fd, SOL_XDP, XDP_MMAP_OFFSETS, &off, &opt=
len);
> > > @@ -774,8 +819,6 @@ void xsk_socket__delete(struct xsk_socket *xsk)
> > >
> > >     }
> > >
> > > -   xsk_remove_xdp_prog(xsk);
> > > -
> > >     xsk->umem->refcount--;
> > >     /* Do not close an fd that also has an associated umem connected
> > >      * to it.
> > >
>
