Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 111E32AF0D
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 08:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbfE0G7E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 02:59:04 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:40363 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726322AbfE0G7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 02:59:04 -0400
Received: by mail-oi1-f196.google.com with SMTP id r136so11170616oie.7;
        Sun, 26 May 2019 23:59:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kwmBauF3Liy9lrjbb0RAy2g2XFtZDHoyAbQcS7xg+RU=;
        b=fpMKEywnDNP4KpGdmnHQxKVGvyqXf7uJP01AZwdHvO6P39Ji5eLgZeLApYWZsnBBx1
         itfadeRY4UAVqiLaTdgNqsHfmkTZXLDPV4MI7voUHVjiqDgoYHAgzOiicFuoobNvrOr1
         Nz7yOmEE5+3uWcniw14HXHsiXiVRHUPlV7n87ZYhlB5n/E6eCZvRc+6UmxSEXh1GG/xO
         rHmPe86CoDl9uRs+q0SZm4XGG2BFIBrAWMgMCqwZ56akQgbLLhzJbvxOZ80D2GPI+qlK
         Rg8iJ7nsRTe/LRElq7aB2aanROZG+heFl9G2pMW8VqI7sQwIhUzpQ1Rhs03zN9toaH6P
         a6Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kwmBauF3Liy9lrjbb0RAy2g2XFtZDHoyAbQcS7xg+RU=;
        b=e+5ZBiCTTsmFV3bXvyd3WEpUFBSzaIjjA0+lKg7dxmHvKG/Y6X6HNJU8+h01w0+jK7
         7MuYO6WDdxm5GD79NloO8ZoNXtJcMt9QvwtWRhOB14cIGLFfjaS5feBXw84yZj3R1atC
         xXGGOU4CrrabfL05LKPFx5cJtM+rpDvRY5VYz2PAazifysewYXMHNvlATLLe2y0aN+/8
         owKfW3DD9KORFtXDRe1chSqjjKwGozWcse0AAbfhO3CulXvI5q0rU5Jt7vMSrJhScdiT
         vOoirvUUUOh7FJIWCIMH4AAQM5oh22i6plzSm8ol+2dSp+2eSxAdEWZr9lopYmxJqOaM
         v1aw==
X-Gm-Message-State: APjAAAVQGeOxCeTR1Z717dDMOQ+S+8bv2Xjgo/qBKullJeENtpy6bKij
        FSeVNTHmP74MgZo6kyadnu3G1TDaBq5H0pvcfKw=
X-Google-Smtp-Source: APXvYqzzuXL+wiApg9ywUJW1/TdC6MKmMIfio6uAczrLUBqX3cemPAHqLrqtWj2TvcM6XdwOhx4eBnxHIX4yfYVsWQw=
X-Received: by 2002:aca:ed0a:: with SMTP id l10mr14481855oih.39.1558940343029;
 Sun, 26 May 2019 23:59:03 -0700 (PDT)
MIME-Version: 1.0
References: <1556786363-28743-1-git-send-email-magnus.karlsson@intel.com>
 <1556786363-28743-8-git-send-email-magnus.karlsson@intel.com> <20190524025111.GB6321@intel.com>
In-Reply-To: <20190524025111.GB6321@intel.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 27 May 2019 08:58:52 +0200
Message-ID: <CAJ8uoz3MNrz_f7dy6+U=zj7GeywUda9E9pP2s9uU1jVW5O2zHw@mail.gmail.com>
Subject: Re: [RFC bpf-next 7/7] samples/bpf: add busy-poll support to xdpsock sample
To:     Ye Xiaolong <xiaolong.ye@intel.com>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        bpf@vger.kernel.org, bruce.richardson@intel.com,
        ciara.loftus@intel.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        "Zhang, Qi Z" <qi.z.zhang@intel.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        kevin.laatz@intel.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 24, 2019 at 4:59 AM Ye Xiaolong <xiaolong.ye@intel.com> wrote:
>
> Hi, Magnus
>
> On 05/02, Magnus Karlsson wrote:
> >This patch adds busy-poll support to the xdpsock sample
> >application. It is enabled by the "-b" or the "--busy-poll" command
> >line options.
> >
> >Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> >---
> > samples/bpf/xdpsock_user.c | 203 ++++++++++++++++++++++++++++-----------------
> > 1 file changed, 125 insertions(+), 78 deletions(-)
> >
> >diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
> >index d08ee1a..1272edf 100644
> >--- a/samples/bpf/xdpsock_user.c
> >+++ b/samples/bpf/xdpsock_user.c
> >@@ -66,6 +66,7 @@ static const char *opt_if = "";
> > static int opt_ifindex;
> > static int opt_queue;
> > static int opt_poll;
> >+static int opt_busy_poll;
> > static int opt_interval = 1;
> > static u32 opt_xdp_bind_flags;
> > static __u32 prog_id;
> >@@ -119,8 +120,11 @@ static void print_benchmark(bool running)
> >       else
> >               printf("        ");
> >
> >-      if (opt_poll)
> >+      if (opt_poll) {
> >+              if (opt_busy_poll)
> >+                      printf("busy-");
> >               printf("poll() ");
> >+      }
> >
> >       if (running) {
> >               printf("running...");
> >@@ -306,7 +310,7 @@ static struct xsk_socket_info *xsk_configure_socket(struct xsk_umem_info *umem)
> >       xsk->umem = umem;
> >       cfg.rx_size = XSK_RING_CONS__DEFAULT_NUM_DESCS;
> >       cfg.tx_size = XSK_RING_PROD__DEFAULT_NUM_DESCS;
> >-      cfg.libbpf_flags = 0;
>
> Any purpose for removing this line, as cfg here is a local variable, cfg.libbpf_flags
> can be random and may lead to xdpsock failure as `Invalid no_argument`.

No, that was a mistake. Thanks for catching.

I will produce a new patch set with the improvements needed to make
execution of application and softirq/ksoftirqd on the same core
efficient, make a v2 of the busy poll patch set (with all your
suggested improvements) on top of that, and then see what performance
we have.

Thanks: Magnus

> Thanks,
> Xiaolong
>
> >+      cfg.busy_poll = (opt_busy_poll ? BATCH_SIZE : 0);
> >       cfg.xdp_flags = opt_xdp_flags;
> >       cfg.bind_flags = opt_xdp_bind_flags;
> >       ret = xsk_socket__create(&xsk->xsk, opt_if, opt_queue, umem->umem,
> >@@ -319,17 +323,17 @@ static struct xsk_socket_info *xsk_configure_socket(struct xsk_umem_info *umem)
> >               exit_with_error(-ret);
> >
> >       ret = xsk_ring_prod__reserve(&xsk->umem->fq,
> >-                                   XSK_RING_PROD__DEFAULT_NUM_DESCS,
> >+                                   1024,
> >                                    &idx);
> >-      if (ret != XSK_RING_PROD__DEFAULT_NUM_DESCS)
> >+      if (ret != 1024)
> >               exit_with_error(-ret);
> >       for (i = 0;
> >-           i < XSK_RING_PROD__DEFAULT_NUM_DESCS *
> >+           i < 1024 *
> >                    XSK_UMEM__DEFAULT_FRAME_SIZE;
> >            i += XSK_UMEM__DEFAULT_FRAME_SIZE)
> >               *xsk_ring_prod__fill_addr(&xsk->umem->fq, idx++) = i;
> >       xsk_ring_prod__submit(&xsk->umem->fq,
> >-                            XSK_RING_PROD__DEFAULT_NUM_DESCS);
> >+                            1024);
> >
> >       return xsk;
> > }
> >@@ -341,6 +345,7 @@ static struct option long_options[] = {
> >       {"interface", required_argument, 0, 'i'},
> >       {"queue", required_argument, 0, 'q'},
> >       {"poll", no_argument, 0, 'p'},
> >+      {"busy-poll", no_argument, 0, 'b'},
> >       {"xdp-skb", no_argument, 0, 'S'},
> >       {"xdp-native", no_argument, 0, 'N'},
> >       {"interval", required_argument, 0, 'n'},
> >@@ -360,6 +365,7 @@ static void usage(const char *prog)
> >               "  -i, --interface=n    Run on interface n\n"
> >               "  -q, --queue=n        Use queue n (default 0)\n"
> >               "  -p, --poll           Use poll syscall\n"
> >+              "  -b, --busy-poll      Use poll syscall with busy poll\n"
> >               "  -S, --xdp-skb=n      Use XDP skb-mod\n"
> >               "  -N, --xdp-native=n   Enfore XDP native mode\n"
> >               "  -n, --interval=n     Specify statistics update interval (default 1 sec).\n"
> >@@ -377,7 +383,7 @@ static void parse_command_line(int argc, char **argv)
> >       opterr = 0;
> >
> >       for (;;) {
> >-              c = getopt_long(argc, argv, "Frtli:q:psSNn:cz", long_options,
> >+              c = getopt_long(argc, argv, "Frtli:q:pbsSNn:cz", long_options,
> >                               &option_index);
> >               if (c == -1)
> >                       break;
> >@@ -401,6 +407,10 @@ static void parse_command_line(int argc, char **argv)
> >               case 'p':
> >                       opt_poll = 1;
> >                       break;
> >+              case 'b':
> >+                      opt_busy_poll = 1;
> >+                      opt_poll = 1;
> >+                      break;
> >               case 'S':
> >                       opt_xdp_flags |= XDP_FLAGS_SKB_MODE;
> >                       opt_xdp_bind_flags |= XDP_COPY;
> >@@ -444,7 +454,8 @@ static void kick_tx(struct xsk_socket_info *xsk)
> >       exit_with_error(errno);
> > }
> >
> >-static inline void complete_tx_l2fwd(struct xsk_socket_info *xsk)
> >+static inline void complete_tx_l2fwd(struct xsk_socket_info *xsk,
> >+                                   struct pollfd *fds)
> > {
> >       u32 idx_cq = 0, idx_fq = 0;
> >       unsigned int rcvd;
> >@@ -453,7 +464,8 @@ static inline void complete_tx_l2fwd(struct xsk_socket_info *xsk)
> >       if (!xsk->outstanding_tx)
> >               return;
> >
> >-      kick_tx(xsk);
> >+      if (!opt_poll)
> >+              kick_tx(xsk);
> >       ndescs = (xsk->outstanding_tx > BATCH_SIZE) ? BATCH_SIZE :
> >               xsk->outstanding_tx;
> >
> >@@ -467,6 +479,8 @@ static inline void complete_tx_l2fwd(struct xsk_socket_info *xsk)
> >               while (ret != rcvd) {
> >                       if (ret < 0)
> >                               exit_with_error(-ret);
> >+                      if (opt_busy_poll)
> >+                              ret = poll(fds, num_socks, 0);
> >                       ret = xsk_ring_prod__reserve(&xsk->umem->fq, rcvd,
> >                                                    &idx_fq);
> >               }
> >@@ -490,7 +504,8 @@ static inline void complete_tx_only(struct xsk_socket_info *xsk)
> >       if (!xsk->outstanding_tx)
> >               return;
> >
> >-      kick_tx(xsk);
> >+      if (!opt_busy_poll)
> >+              kick_tx(xsk);
> >
> >       rcvd = xsk_ring_cons__peek(&xsk->umem->cq, BATCH_SIZE, &idx);
> >       if (rcvd > 0) {
> >@@ -500,10 +515,10 @@ static inline void complete_tx_only(struct xsk_socket_info *xsk)
> >       }
> > }
> >
> >-static void rx_drop(struct xsk_socket_info *xsk)
> >+static void rx_drop(struct xsk_socket_info *xsk, struct pollfd *fds)
> > {
> >-      unsigned int rcvd, i;
> >       u32 idx_rx = 0, idx_fq = 0;
> >+      unsigned int rcvd, i;
> >       int ret;
> >
> >       rcvd = xsk_ring_cons__peek(&xsk->rx, BATCH_SIZE, &idx_rx);
> >@@ -514,6 +529,8 @@ static void rx_drop(struct xsk_socket_info *xsk)
> >       while (ret != rcvd) {
> >               if (ret < 0)
> >                       exit_with_error(-ret);
> >+              if (opt_busy_poll)
> >+                      ret = poll(fds, num_socks, 0);
> >               ret = xsk_ring_prod__reserve(&xsk->umem->fq, rcvd, &idx_fq);
> >       }
> >
> >@@ -533,43 +550,68 @@ static void rx_drop(struct xsk_socket_info *xsk)
> >
> > static void rx_drop_all(void)
> > {
> >-      struct pollfd fds[MAX_SOCKS + 1];
> >-      int i, ret, timeout, nfds = 1;
> >+      struct pollfd fds[MAX_SOCKS];
> >+      int i, ret;
> >
> >       memset(fds, 0, sizeof(fds));
> >
> >       for (i = 0; i < num_socks; i++) {
> >               fds[i].fd = xsk_socket__fd(xsks[i]->xsk);
> >               fds[i].events = POLLIN;
> >-              timeout = 1000; /* 1sn */
> >       }
> >
> >       for (;;) {
> >               if (opt_poll) {
> >-                      ret = poll(fds, nfds, timeout);
> >+                      ret = poll(fds, num_socks, 0);
> >                       if (ret <= 0)
> >                               continue;
> >               }
> >
> >               for (i = 0; i < num_socks; i++)
> >-                      rx_drop(xsks[i]);
> >+                      rx_drop(xsks[i], fds);
> >+      }
> >+}
> >+
> >+static void tx_only(struct xsk_socket_info *xsk, u32 frame_nb)
> >+{
> >+      u32 idx;
> >+
> >+      if (xsk_ring_prod__reserve(&xsk->tx, BATCH_SIZE, &idx) ==
> >+          BATCH_SIZE) {
> >+              unsigned int i;
> >+
> >+              for (i = 0; i < BATCH_SIZE; i++) {
> >+                      xsk_ring_prod__tx_desc(&xsk->tx, idx + i)->addr
> >+                              = (frame_nb + i) <<
> >+                              XSK_UMEM__DEFAULT_FRAME_SHIFT;
> >+                      xsk_ring_prod__tx_desc(&xsk->tx, idx + i)->len =
> >+                              sizeof(pkt_data) - 1;
> >+              }
> >+
> >+              xsk_ring_prod__submit(&xsk->tx, BATCH_SIZE);
> >+              xsk->outstanding_tx += BATCH_SIZE;
> >+              frame_nb += BATCH_SIZE;
> >+              frame_nb %= NUM_FRAMES;
> >       }
> >+
> >+      complete_tx_only(xsk);
> > }
> >
> >-static void tx_only(struct xsk_socket_info *xsk)
> >+static void tx_only_all(void)
> > {
> >-      int timeout, ret, nfds = 1;
> >-      struct pollfd fds[nfds + 1];
> >-      u32 idx, frame_nb = 0;
> >+      struct pollfd fds[MAX_SOCKS];
> >+      u32 frame_nb[MAX_SOCKS] = {};
> >+      int i, ret;
> >
> >       memset(fds, 0, sizeof(fds));
> >-      fds[0].fd = xsk_socket__fd(xsk->xsk);
> >-      fds[0].events = POLLOUT;
> >-      timeout = 1000; /* 1sn */
> >+      for (i = 0; i < num_socks; i++) {
> >+              fds[0].fd = xsk_socket__fd(xsks[i]->xsk);
> >+              fds[0].events = POLLOUT;
> >+      }
> >
> >       for (;;) {
> >               if (opt_poll) {
> >-                      ret = poll(fds, nfds, timeout);
> >+                      ret = poll(fds, num_socks, 0);
> >                       if (ret <= 0)
> >                               continue;
> >
> >@@ -577,70 +619,75 @@ static void tx_only(struct xsk_socket_info *xsk)
> >                               continue;
> >               }
> >
> >-              if (xsk_ring_prod__reserve(&xsk->tx, BATCH_SIZE, &idx) ==
> >-                  BATCH_SIZE) {
> >-                      unsigned int i;
> >-
> >-                      for (i = 0; i < BATCH_SIZE; i++) {
> >-                              xsk_ring_prod__tx_desc(&xsk->tx, idx + i)->addr
> >-                                      = (frame_nb + i) <<
> >-                                      XSK_UMEM__DEFAULT_FRAME_SHIFT;
> >-                              xsk_ring_prod__tx_desc(&xsk->tx, idx + i)->len =
> >-                                      sizeof(pkt_data) - 1;
> >-                      }
> >-
> >-                      xsk_ring_prod__submit(&xsk->tx, BATCH_SIZE);
> >-                      xsk->outstanding_tx += BATCH_SIZE;
> >-                      frame_nb += BATCH_SIZE;
> >-                      frame_nb %= NUM_FRAMES;
> >-              }
> >-
> >-              complete_tx_only(xsk);
> >+              for (i = 0; i < num_socks; i++)
> >+                      tx_only(xsks[i], frame_nb[i]);
> >       }
> > }
> >
> >-static void l2fwd(struct xsk_socket_info *xsk)
> >+static void l2fwd(struct xsk_socket_info *xsk, struct pollfd *fds)
> > {
> >-      for (;;) {
> >-              unsigned int rcvd, i;
> >-              u32 idx_rx = 0, idx_tx = 0;
> >-              int ret;
> >+      unsigned int rcvd, i;
> >+      u32 idx_rx = 0, idx_tx = 0;
> >+      int ret;
> >
> >-              for (;;) {
> >-                      complete_tx_l2fwd(xsk);
> >+      complete_tx_l2fwd(xsk, fds);
> >
> >-                      rcvd = xsk_ring_cons__peek(&xsk->rx, BATCH_SIZE,
> >-                                                 &idx_rx);
> >-                      if (rcvd > 0)
> >-                              break;
> >-              }
> >+      rcvd = xsk_ring_cons__peek(&xsk->rx, BATCH_SIZE,
> >+                                 &idx_rx);
> >+      if (!rcvd)
> >+              return;
> >
> >+      ret = xsk_ring_prod__reserve(&xsk->tx, rcvd, &idx_tx);
> >+      while (ret != rcvd) {
> >+              if (ret < 0)
> >+                      exit_with_error(-ret);
> >+              if (opt_busy_poll)
> >+                      ret = poll(fds, num_socks, 0);
> >               ret = xsk_ring_prod__reserve(&xsk->tx, rcvd, &idx_tx);
> >-              while (ret != rcvd) {
> >-                      if (ret < 0)
> >-                              exit_with_error(-ret);
> >-                      ret = xsk_ring_prod__reserve(&xsk->tx, rcvd, &idx_tx);
> >-              }
> >+      }
> >+
> >+      for (i = 0; i < rcvd; i++) {
> >+              u64 addr = xsk_ring_cons__rx_desc(&xsk->rx,
> >+                                                idx_rx)->addr;
> >+              u32 len = xsk_ring_cons__rx_desc(&xsk->rx,
> >+                                               idx_rx++)->len;
> >+              char *pkt = xsk_umem__get_data(xsk->umem->buffer, addr);
> >
> >-              for (i = 0; i < rcvd; i++) {
> >-                      u64 addr = xsk_ring_cons__rx_desc(&xsk->rx,
> >-                                                        idx_rx)->addr;
> >-                      u32 len = xsk_ring_cons__rx_desc(&xsk->rx,
> >-                                                       idx_rx++)->len;
> >-                      char *pkt = xsk_umem__get_data(xsk->umem->buffer, addr);
> >+              swap_mac_addresses(pkt);
> >
> >-                      swap_mac_addresses(pkt);
> >+              hex_dump(pkt, len, addr);
> >+              xsk_ring_prod__tx_desc(&xsk->tx, idx_tx)->addr = addr;
> >+              xsk_ring_prod__tx_desc(&xsk->tx, idx_tx++)->len = len;
> >+      }
> >
> >-                      hex_dump(pkt, len, addr);
> >-                      xsk_ring_prod__tx_desc(&xsk->tx, idx_tx)->addr = addr;
> >-                      xsk_ring_prod__tx_desc(&xsk->tx, idx_tx++)->len = len;
> >-              }
> >+      xsk_ring_prod__submit(&xsk->tx, rcvd);
> >+      xsk_ring_cons__release(&xsk->rx, rcvd);
> >
> >-              xsk_ring_prod__submit(&xsk->tx, rcvd);
> >-              xsk_ring_cons__release(&xsk->rx, rcvd);
> >+      xsk->rx_npkts += rcvd;
> >+      xsk->outstanding_tx += rcvd;
> >+}
> >
> >-              xsk->rx_npkts += rcvd;
> >-              xsk->outstanding_tx += rcvd;
> >+static void l2fwd_all(void)
> >+{
> >+      struct pollfd fds[MAX_SOCKS];
> >+      int i, ret;
> >+
> >+      memset(fds, 0, sizeof(fds));
> >+
> >+      for (i = 0; i < num_socks; i++) {
> >+              fds[i].fd = xsk_socket__fd(xsks[i]->xsk);
> >+              fds[i].events = POLLOUT | POLLIN;
> >+      }
> >+
> >+      for (;;) {
> >+              if (opt_poll) {
> >+                      ret = poll(fds, num_socks, 0);
> >+                      if (ret <= 0)
> >+                              continue;
> >+              }
> >+
> >+              for (i = 0; i < num_socks; i++)
> >+                      l2fwd(xsks[i], fds);
> >       }
> > }
> >
> >@@ -693,9 +740,9 @@ int main(int argc, char **argv)
> >       if (opt_bench == BENCH_RXDROP)
> >               rx_drop_all();
> >       else if (opt_bench == BENCH_TXONLY)
> >-              tx_only(xsks[0]);
> >+              tx_only_all();
> >       else
> >-              l2fwd(xsks[0]);
> >+              l2fwd_all();
> >
> >       return 0;
> > }
> >--
> >2.7.4
> >
