Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD7B0F5390
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 19:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727655AbfKHSdx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 13:33:53 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:39016 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726394AbfKHSdx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 13:33:53 -0500
Received: by mail-ot1-f65.google.com with SMTP id e17so6033756otk.6;
        Fri, 08 Nov 2019 10:33:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=66mbh+p74Oc1VZ4I1Ko+v1HQ54Rpx1W68/eeQIKjw/E=;
        b=r5JeXgSvwzhCJnHQ2cxS1uNSAhVrAmDHL3YXDohCn0yi5CiI/qe+oFR6gNli1CZ5ix
         +TRl7nl5vWgLOD9GF15rJXQR3X7DL9XfxkHSmcJFmdNaglyc1AN4ktm7IMxA5K+Lrjgq
         pbnLOesJnECdis4AN7RbLseTLM6601s04nvedGLGX7ArGjLpKF3EfCMkKInbnrIZ1XZE
         nlUzCNIHhvOg2YCJdfKRF62Eju7gBgyXsyaZj2TtTW70NLhb3bBp66RbMt0VS9o7pJ+u
         KLsR/XA29CvPnBeUDX1pfgYQ1qWWJpk/oRV5BBpRH8MoDpk8y5G1LYoB02jY8F7mwhR7
         qzqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=66mbh+p74Oc1VZ4I1Ko+v1HQ54Rpx1W68/eeQIKjw/E=;
        b=Im3V1jXYwtG87FnJ/PddP40HBOJFhEOeDoFlYNmFJgJbVyGaKC8Hhgpv5uzdtR1Vu6
         KpCZnKzMtLyttu86ICFhFyyusxqE1/yoZNUsYXCDeBM8Bau8ti2jet6Z8YkaX+mBfkTA
         0I2uf4HmOYgwlTmt82nXL5B/Eq38/cvrLl8ux4oPiTxdZ0b03bFZKPH6019UP9PrdkXi
         LkKehYL6f4cXQ3o3Hv52CnARW+1ipvPVccw79ZFcjah8ZJd5RlhD9OTfch8aXsr/CExY
         KAua1RJFrWFY0V/DR0zptbaM5vu8Wn9hfKe0+NSEjK6emY2mZCo6cyOS2lFj9pAZv/RM
         0oIA==
X-Gm-Message-State: APjAAAXMVeoMiXwyNCeXrfIN9QsZwB4YaCSg6a7cqLT/WJI/OYoxsL/K
        /5VOrO/pFFfLkBm3ZXKRuOK+Uhi4wYhj+Mj20CU=
X-Google-Smtp-Source: APXvYqwSvAxUI2yijUmM+9biVLXQeGx31N0cyiZSKJ3pndCzrZrARyMc49dfOqvb/8N1NKusmfRjXCWxHH/Ld8l0uDA=
X-Received: by 2002:a05:6830:2363:: with SMTP id r3mr10184507oth.39.1573238030918;
 Fri, 08 Nov 2019 10:33:50 -0800 (PST)
MIME-Version: 1.0
References: <1573148860-30254-1-git-send-email-magnus.karlsson@intel.com>
 <1573148860-30254-3-git-send-email-magnus.karlsson@intel.com> <20191108181330.GB30004@gmail.com>
In-Reply-To: <20191108181330.GB30004@gmail.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Fri, 8 Nov 2019 19:33:40 +0100
Message-ID: <CAJ8uoz1pvFCpBXFkdEVEfnNC_sc0UEGFaQOc+PeELiXNvEaQCg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/5] samples/bpf: add XDP_SHARED_UMEM support to xdpsock
To:     William Tu <u9012063@gmail.com>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 8, 2019 at 7:15 PM William Tu <u9012063@gmail.com> wrote:
>
> On Thu, Nov 07, 2019 at 06:47:37PM +0100, Magnus Karlsson wrote:
> > Add support for the XDP_SHARED_UMEM mode to the xdpsock sample
> > application. As libbpf does not have a built in XDP program for this
> > mode, we use an explicitly loaded XDP program. This also serves as an
> > example on how to write your own XDP program that can route to an
> > AF_XDP socket.
> >
> > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > ---
> >  samples/bpf/Makefile       |   1 +
> >  samples/bpf/xdpsock.h      |  11 ++++
> >  samples/bpf/xdpsock_kern.c |  24 ++++++++
> >  samples/bpf/xdpsock_user.c | 141 +++++++++++++++++++++++++++++++--------------
> >  4 files changed, 135 insertions(+), 42 deletions(-)
> >  create mode 100644 samples/bpf/xdpsock.h
> >  create mode 100644 samples/bpf/xdpsock_kern.c
> >
> > diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> > index 4df11dd..8a9af3a 100644
> > --- a/samples/bpf/Makefile
> > +++ b/samples/bpf/Makefile
> > @@ -167,6 +167,7 @@ always += xdp_sample_pkts_kern.o
> >  always += ibumad_kern.o
> >  always += hbm_out_kern.o
> >  always += hbm_edt_kern.o
> > +always += xdpsock_kern.o
> >
> >  ifeq ($(ARCH), arm)
> >  # Strip all except -D__LINUX_ARM_ARCH__ option needed to handle linux
> > diff --git a/samples/bpf/xdpsock.h b/samples/bpf/xdpsock.h
> > new file mode 100644
> > index 0000000..b7eca15
> > --- /dev/null
> > +++ b/samples/bpf/xdpsock.h
> > @@ -0,0 +1,11 @@
> > +/* SPDX-License-Identifier: GPL-2.0
> > + *
> > + * Copyright(c) 2019 Intel Corporation.
> > + */
> > +
> > +#ifndef XDPSOCK_H_
> > +#define XDPSOCK_H_
> > +
> > +#define MAX_SOCKS 4
> > +
> > +#endif /* XDPSOCK_H */
> > diff --git a/samples/bpf/xdpsock_kern.c b/samples/bpf/xdpsock_kern.c
> > new file mode 100644
> > index 0000000..a06177c
> > --- /dev/null
> > +++ b/samples/bpf/xdpsock_kern.c
> > @@ -0,0 +1,24 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +#include <linux/bpf.h>
> > +#include "bpf_helpers.h"
> > +#include "xdpsock.h"
> > +
> > +/* This XDP program is only needed for the XDP_SHARED_UMEM mode.
> > + * If you do not use this mode, libbpf can supply an XDP program for you.
> > + */
> > +
> > +struct {
> > +     __uint(type, BPF_MAP_TYPE_XSKMAP);
> > +     __uint(max_entries, MAX_SOCKS);
> > +     __uint(key_size, sizeof(int));
> > +     __uint(value_size, sizeof(int));
> > +} xsks_map SEC(".maps");
> > +
> > +static unsigned int rr;
> > +
> > +SEC("xdp_sock") int xdp_sock_prog(struct xdp_md *ctx)
> > +{
> > +     rr = (rr + 1) & (MAX_SOCKS - 1);
> > +
> > +     return bpf_redirect_map(&xsks_map, rr, XDP_DROP);
> > +}
> > diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
> > index 405c4e0..d3dba93 100644
> > --- a/samples/bpf/xdpsock_user.c
> > +++ b/samples/bpf/xdpsock_user.c
> > @@ -29,6 +29,7 @@
> >
> >  #include "libbpf.h"
> >  #include "xsk.h"
> > +#include "xdpsock.h"
> >  #include <bpf/bpf.h>
> >
> >  #ifndef SOL_XDP
> > @@ -47,7 +48,6 @@
> >  #define BATCH_SIZE 64
> >
> >  #define DEBUG_HEXDUMP 0
> > -#define MAX_SOCKS 8
> >
> >  typedef __u64 u64;
> >  typedef __u32 u32;
> > @@ -75,7 +75,8 @@ static u32 opt_xdp_bind_flags;
> >  static int opt_xsk_frame_size = XSK_UMEM__DEFAULT_FRAME_SIZE;
> >  static int opt_timeout = 1000;
> >  static bool opt_need_wakeup = true;
> > -static __u32 prog_id;
> > +static u32 opt_num_xsks = 1;
> > +static u32 prog_id;
> >
> >  struct xsk_umem_info {
> >       struct xsk_ring_prod fq;
> > @@ -179,7 +180,7 @@ static void *poller(void *arg)
> >
> >  static void remove_xdp_program(void)
> >  {
> > -     __u32 curr_prog_id = 0;
> > +     u32 curr_prog_id = 0;
> >
> >       if (bpf_get_link_xdp_id(opt_ifindex, &curr_prog_id, opt_xdp_flags)) {
> >               printf("bpf_get_link_xdp_id failed\n");
> > @@ -196,11 +197,11 @@ static void remove_xdp_program(void)
> >  static void int_exit(int sig)
> >  {
> >       struct xsk_umem *umem = xsks[0]->umem->umem;
> > -
> > -     (void)sig;
> > +     int i;
> >
> >       dump_stats();
> > -     xsk_socket__delete(xsks[0]->xsk);
> > +     for (i = 0; i < num_socks; i++)
> > +             xsk_socket__delete(xsks[i]->xsk);
> >       (void)xsk_umem__delete(umem);
> >       remove_xdp_program();
> >
> > @@ -290,8 +291,8 @@ static struct xsk_umem_info *xsk_configure_umem(void *buffer, u64 size)
> >               .frame_headroom = XSK_UMEM__DEFAULT_FRAME_HEADROOM,
> >               .flags = opt_umem_flags
> >       };
> > -
> > -     int ret;
> > +     int ret, i;
> > +     u32 idx;
> >
> >       umem = calloc(1, sizeof(*umem));
> >       if (!umem)
> > @@ -303,6 +304,15 @@ static struct xsk_umem_info *xsk_configure_umem(void *buffer, u64 size)
> >       if (ret)
> >               exit_with_error(-ret);
> >
> > +     ret = xsk_ring_prod__reserve(&umem->fq,
> > +                                  XSK_RING_PROD__DEFAULT_NUM_DESCS, &idx);
> > +     if (ret != XSK_RING_PROD__DEFAULT_NUM_DESCS)
> > +             exit_with_error(-ret);
> > +     for (i = 0; i < XSK_RING_PROD__DEFAULT_NUM_DESCS; i++)
> > +             *xsk_ring_prod__fill_addr(&umem->fq, idx++) =
> > +                     i * opt_xsk_frame_size;
> > +     xsk_ring_prod__submit(&umem->fq, XSK_RING_PROD__DEFAULT_NUM_DESCS);
> > +
> >       umem->buffer = buffer;
> >       return umem;
> >  }
> > @@ -312,8 +322,6 @@ static struct xsk_socket_info *xsk_configure_socket(struct xsk_umem_info *umem)
> >       struct xsk_socket_config cfg;
> >       struct xsk_socket_info *xsk;
> >       int ret;
> > -     u32 idx;
> > -     int i;
> >
> >       xsk = calloc(1, sizeof(*xsk));
> >       if (!xsk)
> > @@ -322,11 +330,15 @@ static struct xsk_socket_info *xsk_configure_socket(struct xsk_umem_info *umem)
> >       xsk->umem = umem;
> >       cfg.rx_size = XSK_RING_CONS__DEFAULT_NUM_DESCS;
> >       cfg.tx_size = XSK_RING_PROD__DEFAULT_NUM_DESCS;
> > -     cfg.libbpf_flags = 0;
> > +     if (opt_num_xsks > 1)
> > +             cfg.libbpf_flags = XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD;
>
> I think we can still load our own XDP program, and don't set
> XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD.
> So the xsk_setup_xdp_prog() will find the the loaded XDP program
> and sets the xsk map.

So what you are saying is that you would like libbpf to be smarter and
insert the sockets into the xskmap automatically? Doable in the simple
case, but what if the XDP program has multiple xskmaps, or an xskmap
with a different name? Seems complicated to do this in the general
case. Or maybe I am just chicken to say the user has to load and
manage his/her own XDP program when XDP_SHARED_UMEM is used :-).

> > +     else
> > +             cfg.libbpf_flags = 0;
> >       cfg.xdp_flags = opt_xdp_flags;
> >       cfg.bind_flags = opt_xdp_bind_flags;
>
> Do we need to
> cfg.bind_flags |= XDP_SHARED_UMEM?

It is set by libbpf automatically, so no need here.

> Thanks
> William
>
> > -     ret = xsk_socket__create(&xsk->xsk, opt_if, opt_queue, umem->umem,
> > -                              &xsk->rx, &xsk->tx, &cfg);
> > +
> > +     ret = xsk_socket__create(&xsk->xsk, opt_if, opt_queue,
> > +                              umem->umem, &xsk->rx, &xsk->tx, &cfg);
> >       if (ret)
> >               exit_with_error(-ret);
> >
> > @@ -334,17 +346,6 @@ static struct xsk_socket_info *xsk_configure_socket(struct xsk_umem_info *umem)
> >       if (ret)
> >               exit_with_error(-ret);
> >
> > -     ret = xsk_ring_prod__reserve(&xsk->umem->fq,
> > -                                  XSK_RING_PROD__DEFAULT_NUM_DESCS,
> > -                                  &idx);
> > -     if (ret != XSK_RING_PROD__DEFAULT_NUM_DESCS)
> > -             exit_with_error(-ret);
> > -     for (i = 0; i < XSK_RING_PROD__DEFAULT_NUM_DESCS; i++)
> > -             *xsk_ring_prod__fill_addr(&xsk->umem->fq, idx++) =
> > -                     i * opt_xsk_frame_size;
> > -     xsk_ring_prod__submit(&xsk->umem->fq,
> > -                           XSK_RING_PROD__DEFAULT_NUM_DESCS);
> > -
> >       return xsk;
> >  }
> >
> > @@ -363,6 +364,7 @@ static struct option long_options[] = {
> >       {"frame-size", required_argument, 0, 'f'},
> >       {"no-need-wakeup", no_argument, 0, 'm'},
> >       {"unaligned", no_argument, 0, 'u'},
> > +     {"shared-umem", no_argument, 0, 'M'},
> >       {0, 0, 0, 0}
> >  };
> >
> > @@ -386,6 +388,7 @@ static void usage(const char *prog)
> >               "  -m, --no-need-wakeup Turn off use of driver need wakeup flag.\n"
> >               "  -f, --frame-size=n   Set the frame size (must be a power of two in aligned mode, default is %d).\n"
> >               "  -u, --unaligned      Enable unaligned chunk placement\n"
> > +             "  -M, --shared-umem    Enable XDP_SHARED_UMEM\n"
> >               "\n";
> >       fprintf(stderr, str, prog, XSK_UMEM__DEFAULT_FRAME_SIZE);
> >       exit(EXIT_FAILURE);
> > @@ -398,7 +401,7 @@ static void parse_command_line(int argc, char **argv)
> >       opterr = 0;
> >
> >       for (;;) {
> > -             c = getopt_long(argc, argv, "Frtli:q:psSNn:czf:mu",
> > +             c = getopt_long(argc, argv, "Frtli:q:psSNn:czf:muM",
> >                               long_options, &option_index);
> >               if (c == -1)
> >                       break;
> > @@ -448,11 +451,14 @@ static void parse_command_line(int argc, char **argv)
> >                       break;
> >               case 'f':
> >                       opt_xsk_frame_size = atoi(optarg);
> > +                     break;
> >               case 'm':
> >                       opt_need_wakeup = false;
> >                       opt_xdp_bind_flags &= ~XDP_USE_NEED_WAKEUP;
> >                       break;
> > -
> > +             case 'M':
> > +                     opt_num_xsks = MAX_SOCKS;
> > +                     break;
> >               default:
> >                       usage(basename(argv[0]));
> >               }
> > @@ -586,11 +592,9 @@ static void rx_drop(struct xsk_socket_info *xsk, struct pollfd *fds)
> >
> >  static void rx_drop_all(void)
> >  {
> > -     struct pollfd fds[MAX_SOCKS + 1];
> > +     struct pollfd fds[MAX_SOCKS] = {};
> >       int i, ret;
> >
> > -     memset(fds, 0, sizeof(fds));
> > -
> >       for (i = 0; i < num_socks; i++) {
> >               fds[i].fd = xsk_socket__fd(xsks[i]->xsk);
> >               fds[i].events = POLLIN;
> > @@ -633,11 +637,10 @@ static void tx_only(struct xsk_socket_info *xsk, u32 frame_nb)
> >
> >  static void tx_only_all(void)
> >  {
> > -     struct pollfd fds[MAX_SOCKS];
> > +     struct pollfd fds[MAX_SOCKS] = {};
> >       u32 frame_nb[MAX_SOCKS] = {};
> >       int i, ret;
> >
> > -     memset(fds, 0, sizeof(fds));
> >       for (i = 0; i < num_socks; i++) {
> >               fds[0].fd = xsk_socket__fd(xsks[i]->xsk);
> >               fds[0].events = POLLOUT;
> > @@ -706,11 +709,9 @@ static void l2fwd(struct xsk_socket_info *xsk, struct pollfd *fds)
> >
> >  static void l2fwd_all(void)
> >  {
> > -     struct pollfd fds[MAX_SOCKS];
> > +     struct pollfd fds[MAX_SOCKS] = {};
> >       int i, ret;
> >
> > -     memset(fds, 0, sizeof(fds));
> > -
> >       for (i = 0; i < num_socks; i++) {
> >               fds[i].fd = xsk_socket__fd(xsks[i]->xsk);
> >               fds[i].events = POLLOUT | POLLIN;
> > @@ -728,13 +729,65 @@ static void l2fwd_all(void)
> >       }
> >  }
> >
> > +static void load_xdp_program(char **argv, struct bpf_object **obj)
> > +{
> > +     struct bpf_prog_load_attr prog_load_attr = {
> > +             .prog_type      = BPF_PROG_TYPE_XDP,
> > +     };
> > +     char xdp_filename[256];
> > +     int prog_fd;
> > +
> > +     snprintf(xdp_filename, sizeof(xdp_filename), "%s_kern.o", argv[0]);
> > +     prog_load_attr.file = xdp_filename;
> > +
> > +     if (bpf_prog_load_xattr(&prog_load_attr, obj, &prog_fd))
> > +             exit(EXIT_FAILURE);
> > +     if (prog_fd < 0) {
> > +             fprintf(stderr, "ERROR: no program found: %s\n",
> > +                     strerror(prog_fd));
> > +             exit(EXIT_FAILURE);
> > +     }
> > +
> > +     if (bpf_set_link_xdp_fd(opt_ifindex, prog_fd, opt_xdp_flags) < 0) {
> > +             fprintf(stderr, "ERROR: link set xdp fd failed\n");
> > +             exit(EXIT_FAILURE);
> > +     }
> > +}
> > +
> > +static void enter_xsks_into_map(struct bpf_object *obj)
> > +{
> > +     struct bpf_map *map;
> > +     int i, xsks_map;
> > +
> > +     map = bpf_object__find_map_by_name(obj, "xsks_map");
> > +     xsks_map = bpf_map__fd(map);
> > +     if (xsks_map < 0) {
> > +             fprintf(stderr, "ERROR: no xsks map found: %s\n",
> > +                     strerror(xsks_map));
> > +                     exit(EXIT_FAILURE);
> > +     }
> > +
> > +     for (i = 0; i < num_socks; i++) {
> > +             int fd = xsk_socket__fd(xsks[i]->xsk);
> > +             int key, ret;
> > +
> > +             key = i;
> > +             ret = bpf_map_update_elem(xsks_map, &key, &fd, 0);
> > +             if (ret) {
> > +                     fprintf(stderr, "ERROR: bpf_map_update_elem %d\n", i);
> > +                     exit(EXIT_FAILURE);
> > +             }
> > +     }
> > +}
> > +
> >  int main(int argc, char **argv)
> >  {
> >       struct rlimit r = {RLIM_INFINITY, RLIM_INFINITY};
> >       struct xsk_umem_info *umem;
> > +     struct bpf_object *obj;
> >       pthread_t pt;
> > +     int i, ret;
> >       void *bufs;
> > -     int ret;
> >
> >       parse_command_line(argc, argv);
> >
> > @@ -744,6 +797,9 @@ int main(int argc, char **argv)
> >               exit(EXIT_FAILURE);
> >       }
> >
> > +     if (opt_num_xsks > 1)
> > +             load_xdp_program(argv, &obj);
> > +
> >       /* Reserve memory for the umem. Use hugepages if unaligned chunk mode */
> >       bufs = mmap(NULL, NUM_FRAMES * opt_xsk_frame_size,
> >                   PROT_READ | PROT_WRITE,
> > @@ -752,16 +808,17 @@ int main(int argc, char **argv)
> >               printf("ERROR: mmap failed\n");
> >               exit(EXIT_FAILURE);
> >       }
> > -       /* Create sockets... */
> > +
> > +     /* Create sockets... */
> >       umem = xsk_configure_umem(bufs, NUM_FRAMES * opt_xsk_frame_size);
> > -     xsks[num_socks++] = xsk_configure_socket(umem);
> > +     for (i = 0; i < opt_num_xsks; i++)
> > +             xsks[num_socks++] = xsk_configure_socket(umem);
> >
> > -     if (opt_bench == BENCH_TXONLY) {
> > -             int i;
> > +     for (i = 0; i < NUM_FRAMES; i++)
> > +             gen_eth_frame(umem, i * opt_xsk_frame_size);
> >
> > -             for (i = 0; i < NUM_FRAMES; i++)
> > -                     (void)gen_eth_frame(umem, i * opt_xsk_frame_size);
> > -     }
> > +     if (opt_num_xsks > 1 && opt_bench != BENCH_TXONLY)
> > +             enter_xsks_into_map(obj);
> >
> >       signal(SIGINT, int_exit);
> >       signal(SIGTERM, int_exit);
> > --
> > 2.7.4
> >
