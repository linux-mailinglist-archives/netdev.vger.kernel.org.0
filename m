Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D14B025D309
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 09:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729863AbgIDHyP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 03:54:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729628AbgIDHyO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 03:54:14 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B211C061244
        for <netdev@vger.kernel.org>; Fri,  4 Sep 2020 00:54:13 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id y6so5733481oie.5
        for <netdev@vger.kernel.org>; Fri, 04 Sep 2020 00:54:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S0zstZUIqLihjhsqsOfrGFrz5w7eLlJxIhSY8JdRyRE=;
        b=VEBOOKSEgMT6tO3qhecrSi6kOHLH5Pjx3YJYDSwe73NulFkeosfjEwx4u8ORar0s7J
         IUea6q6RoE2tg1ofqa/9l3+vUninXEB413b+HoP/cb6DvBGwkWWNJidATSY2hTFJHCkV
         8fjDk/+aZcaD54DHxDuQ1Yd3HpPrqfjlkE1jI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S0zstZUIqLihjhsqsOfrGFrz5w7eLlJxIhSY8JdRyRE=;
        b=Nb9AlWqTHtUXkhOVZIGE4R7vD3FQUfyeisH8o7TJQpuO+1E6FQh2QdpYKRlc9W1GGI
         J94f1EkMghR2dsVTPfwETDs/NJQEUmEzI46UYUi6RFBh5D1E7KtxB//EeKAV5KwchAl6
         qDjiAUgzFsYKCXE5GGw9DzVYBjLWXInxkqaNlKOoU3zTwJZDSJ9aOgWEErAi+qzCmzLM
         g+V/gMVSSKsFsP3XGKzlqFnmWPabnQOq+OTIacwZVchFnhRbKFhQpo5MIoEaHrl06cmL
         pjWVTKJCT4OB9RTYLoUxLT/VF2oj+COy1u4BXcvEHsQylfgKPUUfU2emZgnF1u2yTnLQ
         WtAg==
X-Gm-Message-State: AOAM533kQBonRZTzl7rF5Kd5OYSpYMDE1U5KMrUFRFi2LcoXTf/2xKYW
        Tj0a+oF3SN2m3lWA3LgV1mXwPciO9LbfI2LjySbB4g==
X-Google-Smtp-Source: ABdhPJxy16kn2bVFs9zhM16X+ypFsYqFcR4qQR88AhajpgOjnuPckLw4g3Ams+2QqL1W8fMBz9qls2IWfg2Arll/1Pw=
X-Received: by 2002:aca:3e8b:: with SMTP id l133mr4706012oia.110.1599206050233;
 Fri, 04 Sep 2020 00:54:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200903203542.15944-1-andriin@fb.com> <20200903203542.15944-15-andriin@fb.com>
In-Reply-To: <20200903203542.15944-15-andriin@fb.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Fri, 4 Sep 2020 08:53:59 +0100
Message-ID: <CACAyw99QcWYBb=Dj=jqQDLq6bLGokHzUfJHxWi3RR6uHRZ6EVg@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 14/14] selftests/bpf: add __noinline variant
 of cls_redirect selftest
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Sep 2020 at 21:36, Andrii Nakryiko <andriin@fb.com> wrote:
>
> As one of the most complicated and close-to-real-world programs, cls_redirect
> is a good candidate to exercise libbpf's logic of handling bpf2bpf calls. So
> add variant with using explicit __noinline for majority of functions except
> few most basic ones. If those few functions are inlined, verifier starts to
> complain about program instruction limit of 1mln instructions being exceeded,
> most probably due to instruction overhead of doing a sub-program call.
> Convert user-space part of selftest to have to sub-tests: with and without
> inlining.

Acked-by: Lorenz Bauer <lmb@cloudflare.com>

>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  .../selftests/bpf/prog_tests/cls_redirect.c   |  72 +++++++++---
>  .../selftests/bpf/progs/test_cls_redirect.c   | 105 ++++++++++--------
>  .../bpf/progs/test_cls_redirect_subprogs.c    |   2 +
>  3 files changed, 115 insertions(+), 64 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/progs/test_cls_redirect_subprogs.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/cls_redirect.c b/tools/testing/selftests/bpf/prog_tests/cls_redirect.c
> index f259085cca6a..9781d85cb223 100644
> --- a/tools/testing/selftests/bpf/prog_tests/cls_redirect.c
> +++ b/tools/testing/selftests/bpf/prog_tests/cls_redirect.c
> @@ -12,10 +12,13 @@
>
>  #include "progs/test_cls_redirect.h"
>  #include "test_cls_redirect.skel.h"
> +#include "test_cls_redirect_subprogs.skel.h"
>
>  #define ENCAP_IP INADDR_LOOPBACK
>  #define ENCAP_PORT (1234)
>
> +static int duration = 0;
> +
>  struct addr_port {
>         in_port_t port;
>         union {
> @@ -361,30 +364,18 @@ static void close_fds(int *fds, int n)
>                         close(fds[i]);
>  }
>
> -void test_cls_redirect(void)
> +static void test_cls_redirect_common(struct bpf_program *prog)
>  {
> -       struct test_cls_redirect *skel = NULL;
>         struct bpf_prog_test_run_attr tattr = {};
>         int families[] = { AF_INET, AF_INET6 };
>         struct sockaddr_storage ss;
>         struct sockaddr *addr;
>         socklen_t slen;
>         int i, j, err;
> -
>         int servers[__NR_KIND][ARRAY_SIZE(families)] = {};
>         int conns[__NR_KIND][ARRAY_SIZE(families)] = {};
>         struct tuple tuples[__NR_KIND][ARRAY_SIZE(families)];
>
> -       skel = test_cls_redirect__open();
> -       if (CHECK_FAIL(!skel))
> -               return;
> -
> -       skel->rodata->ENCAPSULATION_IP = htonl(ENCAP_IP);
> -       skel->rodata->ENCAPSULATION_PORT = htons(ENCAP_PORT);
> -
> -       if (CHECK_FAIL(test_cls_redirect__load(skel)))
> -               goto cleanup;
> -
>         addr = (struct sockaddr *)&ss;
>         for (i = 0; i < ARRAY_SIZE(families); i++) {
>                 slen = prepare_addr(&ss, families[i]);
> @@ -402,7 +393,7 @@ void test_cls_redirect(void)
>                         goto cleanup;
>         }
>
> -       tattr.prog_fd = bpf_program__fd(skel->progs.cls_redirect);
> +       tattr.prog_fd = bpf_program__fd(prog);
>         for (i = 0; i < ARRAY_SIZE(tests); i++) {
>                 struct test_cfg *test = &tests[i];
>
> @@ -450,7 +441,58 @@ void test_cls_redirect(void)
>         }
>
>  cleanup:
> -       test_cls_redirect__destroy(skel);
>         close_fds((int *)servers, sizeof(servers) / sizeof(servers[0][0]));
>         close_fds((int *)conns, sizeof(conns) / sizeof(conns[0][0]));
>  }
> +
> +static void test_cls_redirect_inlined(void)
> +{
> +       struct test_cls_redirect *skel;
> +       int err;
> +
> +       skel = test_cls_redirect__open();
> +       if (CHECK(!skel, "skel_open", "failed\n"))
> +               return;
> +
> +       skel->rodata->ENCAPSULATION_IP = htonl(ENCAP_IP);
> +       skel->rodata->ENCAPSULATION_PORT = htons(ENCAP_PORT);
> +
> +       err = test_cls_redirect__load(skel);
> +       if (CHECK(err, "skel_load", "failed: %d\n", err))
> +               goto cleanup;
> +
> +       test_cls_redirect_common(skel->progs.cls_redirect);
> +
> +cleanup:
> +       test_cls_redirect__destroy(skel);
> +}
> +
> +static void test_cls_redirect_subprogs(void)
> +{
> +       struct test_cls_redirect_subprogs *skel;
> +       int err;
> +
> +       skel = test_cls_redirect_subprogs__open();
> +       if (CHECK(!skel, "skel_open", "failed\n"))
> +               return;
> +
> +       skel->rodata->ENCAPSULATION_IP = htonl(ENCAP_IP);
> +       skel->rodata->ENCAPSULATION_PORT = htons(ENCAP_PORT);
> +
> +       err = test_cls_redirect_subprogs__load(skel);
> +       if (CHECK(err, "skel_load", "failed: %d\n", err))
> +               goto cleanup;
> +
> +       test_cls_redirect_common(skel->progs.cls_redirect);
> +
> +cleanup:
> +       test_cls_redirect_subprogs__destroy(skel);
> +}
> +
> +void test_cls_redirect(void)
> +{
> +       if (test__start_subtest("cls_redirect_inlined"))
> +               test_cls_redirect_inlined();
> +       if (test__start_subtest("cls_redirect_subprogs"))
> +               test_cls_redirect_subprogs();
> +}
> diff --git a/tools/testing/selftests/bpf/progs/test_cls_redirect.c b/tools/testing/selftests/bpf/progs/test_cls_redirect.c
> index f0b72e86bee5..c9f8464996ea 100644
> --- a/tools/testing/selftests/bpf/progs/test_cls_redirect.c
> +++ b/tools/testing/selftests/bpf/progs/test_cls_redirect.c
> @@ -22,6 +22,12 @@
>
>  #include "test_cls_redirect.h"
>
> +#ifdef SUBPROGS
> +#define INLINING __noinline
> +#else
> +#define INLINING __always_inline
> +#endif
> +
>  #define offsetofend(TYPE, MEMBER) \
>         (offsetof(TYPE, MEMBER) + sizeof((((TYPE *)0)->MEMBER)))
>
> @@ -125,7 +131,7 @@ typedef struct buf {
>         uint8_t *const tail;
>  } buf_t;
>
> -static size_t buf_off(const buf_t *buf)
> +static __always_inline size_t buf_off(const buf_t *buf)
>  {
>         /* Clang seems to optimize constructs like
>          *    a - b + c
> @@ -145,7 +151,7 @@ static size_t buf_off(const buf_t *buf)
>         return off;
>  }
>
> -static bool buf_copy(buf_t *buf, void *dst, size_t len)
> +static __always_inline bool buf_copy(buf_t *buf, void *dst, size_t len)
>  {
>         if (bpf_skb_load_bytes(buf->skb, buf_off(buf), dst, len)) {
>                 return false;
> @@ -155,7 +161,7 @@ static bool buf_copy(buf_t *buf, void *dst, size_t len)
>         return true;
>  }
>
> -static bool buf_skip(buf_t *buf, const size_t len)
> +static __always_inline bool buf_skip(buf_t *buf, const size_t len)
>  {
>         /* Check whether off + len is valid in the non-linear part. */
>         if (buf_off(buf) + len > buf->skb->len) {
> @@ -173,7 +179,7 @@ static bool buf_skip(buf_t *buf, const size_t len)
>   * If scratch is not NULL, the function will attempt to load non-linear
>   * data via bpf_skb_load_bytes. On success, scratch is returned.
>   */
> -static void *buf_assign(buf_t *buf, const size_t len, void *scratch)
> +static __always_inline void *buf_assign(buf_t *buf, const size_t len, void *scratch)
>  {
>         if (buf->head + len > buf->tail) {
>                 if (scratch == NULL) {
> @@ -188,7 +194,7 @@ static void *buf_assign(buf_t *buf, const size_t len, void *scratch)
>         return ptr;
>  }
>
> -static bool pkt_skip_ipv4_options(buf_t *buf, const struct iphdr *ipv4)
> +static INLINING bool pkt_skip_ipv4_options(buf_t *buf, const struct iphdr *ipv4)
>  {
>         if (ipv4->ihl <= 5) {
>                 return true;
> @@ -197,13 +203,13 @@ static bool pkt_skip_ipv4_options(buf_t *buf, const struct iphdr *ipv4)
>         return buf_skip(buf, (ipv4->ihl - 5) * 4);
>  }
>
> -static bool ipv4_is_fragment(const struct iphdr *ip)
> +static INLINING bool ipv4_is_fragment(const struct iphdr *ip)
>  {
>         uint16_t frag_off = ip->frag_off & bpf_htons(IP_OFFSET_MASK);
>         return (ip->frag_off & bpf_htons(IP_MF)) != 0 || frag_off > 0;
>  }
>
> -static struct iphdr *pkt_parse_ipv4(buf_t *pkt, struct iphdr *scratch)
> +static __always_inline struct iphdr *pkt_parse_ipv4(buf_t *pkt, struct iphdr *scratch)
>  {
>         struct iphdr *ipv4 = buf_assign(pkt, sizeof(*ipv4), scratch);
>         if (ipv4 == NULL) {
> @@ -222,7 +228,7 @@ static struct iphdr *pkt_parse_ipv4(buf_t *pkt, struct iphdr *scratch)
>  }
>
>  /* Parse the L4 ports from a packet, assuming a layout like TCP or UDP. */
> -static bool pkt_parse_icmp_l4_ports(buf_t *pkt, flow_ports_t *ports)
> +static INLINING bool pkt_parse_icmp_l4_ports(buf_t *pkt, flow_ports_t *ports)
>  {
>         if (!buf_copy(pkt, ports, sizeof(*ports))) {
>                 return false;
> @@ -237,7 +243,7 @@ static bool pkt_parse_icmp_l4_ports(buf_t *pkt, flow_ports_t *ports)
>         return true;
>  }
>
> -static uint16_t pkt_checksum_fold(uint32_t csum)
> +static INLINING uint16_t pkt_checksum_fold(uint32_t csum)
>  {
>         /* The highest reasonable value for an IPv4 header
>          * checksum requires two folds, so we just do that always.
> @@ -247,7 +253,7 @@ static uint16_t pkt_checksum_fold(uint32_t csum)
>         return (uint16_t)~csum;
>  }
>
> -static void pkt_ipv4_checksum(struct iphdr *iph)
> +static INLINING void pkt_ipv4_checksum(struct iphdr *iph)
>  {
>         iph->check = 0;
>
> @@ -268,10 +274,11 @@ static void pkt_ipv4_checksum(struct iphdr *iph)
>         iph->check = pkt_checksum_fold(acc);
>  }
>
> -static bool pkt_skip_ipv6_extension_headers(buf_t *pkt,
> -                                           const struct ipv6hdr *ipv6,
> -                                           uint8_t *upper_proto,
> -                                           bool *is_fragment)
> +static INLINING
> +bool pkt_skip_ipv6_extension_headers(buf_t *pkt,
> +                                    const struct ipv6hdr *ipv6,
> +                                    uint8_t *upper_proto,
> +                                    bool *is_fragment)
>  {
>         /* We understand five extension headers.
>          * https://tools.ietf.org/html/rfc8200#section-4.1 states that all
> @@ -336,7 +343,7 @@ static bool pkt_skip_ipv6_extension_headers(buf_t *pkt,
>   * scratch is allocated on the stack. However, this usage should be safe since
>   * it's the callers stack after all.
>   */
> -static inline __attribute__((__always_inline__)) struct ipv6hdr *
> +static __always_inline struct ipv6hdr *
>  pkt_parse_ipv6(buf_t *pkt, struct ipv6hdr *scratch, uint8_t *proto,
>                bool *is_fragment)
>  {
> @@ -354,20 +361,20 @@ pkt_parse_ipv6(buf_t *pkt, struct ipv6hdr *scratch, uint8_t *proto,
>
>  /* Global metrics, per CPU
>   */
> -struct bpf_map_def metrics_map SEC("maps") = {
> -       .type = BPF_MAP_TYPE_PERCPU_ARRAY,
> -       .key_size = sizeof(unsigned int),
> -       .value_size = sizeof(metrics_t),
> -       .max_entries = 1,
> -};
> -
> -static metrics_t *get_global_metrics(void)
> +struct {
> +       __uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
> +       __uint(max_entries, 1);
> +       __type(key, unsigned int);
> +       __type(value, metrics_t);
> +} metrics_map SEC(".maps");
> +
> +static INLINING metrics_t *get_global_metrics(void)
>  {
>         uint64_t key = 0;
>         return bpf_map_lookup_elem(&metrics_map, &key);
>  }
>
> -static ret_t accept_locally(struct __sk_buff *skb, encap_headers_t *encap)
> +static INLINING ret_t accept_locally(struct __sk_buff *skb, encap_headers_t *encap)
>  {
>         const int payload_off =
>                 sizeof(*encap) +
> @@ -388,8 +395,8 @@ static ret_t accept_locally(struct __sk_buff *skb, encap_headers_t *encap)
>         return bpf_redirect(skb->ifindex, BPF_F_INGRESS);
>  }
>
> -static ret_t forward_with_gre(struct __sk_buff *skb, encap_headers_t *encap,
> -                             struct in_addr *next_hop, metrics_t *metrics)
> +static INLINING ret_t forward_with_gre(struct __sk_buff *skb, encap_headers_t *encap,
> +                                      struct in_addr *next_hop, metrics_t *metrics)
>  {
>         metrics->forwarded_packets_total_gre++;
>
> @@ -509,8 +516,8 @@ static ret_t forward_with_gre(struct __sk_buff *skb, encap_headers_t *encap,
>         return bpf_redirect(skb->ifindex, 0);
>  }
>
> -static ret_t forward_to_next_hop(struct __sk_buff *skb, encap_headers_t *encap,
> -                                struct in_addr *next_hop, metrics_t *metrics)
> +static INLINING ret_t forward_to_next_hop(struct __sk_buff *skb, encap_headers_t *encap,
> +                                         struct in_addr *next_hop, metrics_t *metrics)
>  {
>         /* swap L2 addresses */
>         /* This assumes that packets are received from a router.
> @@ -546,7 +553,7 @@ static ret_t forward_to_next_hop(struct __sk_buff *skb, encap_headers_t *encap,
>         return bpf_redirect(skb->ifindex, 0);
>  }
>
> -static ret_t skip_next_hops(buf_t *pkt, int n)
> +static INLINING ret_t skip_next_hops(buf_t *pkt, int n)
>  {
>         switch (n) {
>         case 1:
> @@ -566,8 +573,8 @@ static ret_t skip_next_hops(buf_t *pkt, int n)
>   * pkt is positioned just after the variable length GLB header
>   * iff the call is successful.
>   */
> -static ret_t get_next_hop(buf_t *pkt, encap_headers_t *encap,
> -                         struct in_addr *next_hop)
> +static INLINING ret_t get_next_hop(buf_t *pkt, encap_headers_t *encap,
> +                                  struct in_addr *next_hop)
>  {
>         if (encap->unigue.next_hop > encap->unigue.hop_count) {
>                 return TC_ACT_SHOT;
> @@ -601,8 +608,8 @@ static ret_t get_next_hop(buf_t *pkt, encap_headers_t *encap,
>   * return value, and calling code works while still being "generic" to
>   * IPv4 and IPv6.
>   */
> -static uint64_t fill_tuple(struct bpf_sock_tuple *tuple, void *iph,
> -                          uint64_t iphlen, uint16_t sport, uint16_t dport)
> +static INLINING uint64_t fill_tuple(struct bpf_sock_tuple *tuple, void *iph,
> +                                   uint64_t iphlen, uint16_t sport, uint16_t dport)
>  {
>         switch (iphlen) {
>         case sizeof(struct iphdr): {
> @@ -630,9 +637,9 @@ static uint64_t fill_tuple(struct bpf_sock_tuple *tuple, void *iph,
>         }
>  }
>
> -static verdict_t classify_tcp(struct __sk_buff *skb,
> -                             struct bpf_sock_tuple *tuple, uint64_t tuplen,
> -                             void *iph, struct tcphdr *tcp)
> +static INLINING verdict_t classify_tcp(struct __sk_buff *skb,
> +                                      struct bpf_sock_tuple *tuple, uint64_t tuplen,
> +                                      void *iph, struct tcphdr *tcp)
>  {
>         struct bpf_sock *sk =
>                 bpf_skc_lookup_tcp(skb, tuple, tuplen, BPF_F_CURRENT_NETNS, 0);
> @@ -663,8 +670,8 @@ static verdict_t classify_tcp(struct __sk_buff *skb,
>         return UNKNOWN;
>  }
>
> -static verdict_t classify_udp(struct __sk_buff *skb,
> -                             struct bpf_sock_tuple *tuple, uint64_t tuplen)
> +static INLINING verdict_t classify_udp(struct __sk_buff *skb,
> +                                      struct bpf_sock_tuple *tuple, uint64_t tuplen)
>  {
>         struct bpf_sock *sk =
>                 bpf_sk_lookup_udp(skb, tuple, tuplen, BPF_F_CURRENT_NETNS, 0);
> @@ -681,9 +688,9 @@ static verdict_t classify_udp(struct __sk_buff *skb,
>         return UNKNOWN;
>  }
>
> -static verdict_t classify_icmp(struct __sk_buff *skb, uint8_t proto,
> -                              struct bpf_sock_tuple *tuple, uint64_t tuplen,
> -                              metrics_t *metrics)
> +static INLINING verdict_t classify_icmp(struct __sk_buff *skb, uint8_t proto,
> +                                       struct bpf_sock_tuple *tuple, uint64_t tuplen,
> +                                       metrics_t *metrics)
>  {
>         switch (proto) {
>         case IPPROTO_TCP:
> @@ -698,7 +705,7 @@ static verdict_t classify_icmp(struct __sk_buff *skb, uint8_t proto,
>         }
>  }
>
> -static verdict_t process_icmpv4(buf_t *pkt, metrics_t *metrics)
> +static INLINING verdict_t process_icmpv4(buf_t *pkt, metrics_t *metrics)
>  {
>         struct icmphdr icmp;
>         if (!buf_copy(pkt, &icmp, sizeof(icmp))) {
> @@ -745,7 +752,7 @@ static verdict_t process_icmpv4(buf_t *pkt, metrics_t *metrics)
>                              sizeof(tuple.ipv4), metrics);
>  }
>
> -static verdict_t process_icmpv6(buf_t *pkt, metrics_t *metrics)
> +static INLINING verdict_t process_icmpv6(buf_t *pkt, metrics_t *metrics)
>  {
>         struct icmp6hdr icmp6;
>         if (!buf_copy(pkt, &icmp6, sizeof(icmp6))) {
> @@ -797,8 +804,8 @@ static verdict_t process_icmpv6(buf_t *pkt, metrics_t *metrics)
>                              metrics);
>  }
>
> -static verdict_t process_tcp(buf_t *pkt, void *iph, uint64_t iphlen,
> -                            metrics_t *metrics)
> +static INLINING verdict_t process_tcp(buf_t *pkt, void *iph, uint64_t iphlen,
> +                                     metrics_t *metrics)
>  {
>         metrics->l4_protocol_packets_total_tcp++;
>
> @@ -819,8 +826,8 @@ static verdict_t process_tcp(buf_t *pkt, void *iph, uint64_t iphlen,
>         return classify_tcp(pkt->skb, &tuple, tuplen, iph, tcp);
>  }
>
> -static verdict_t process_udp(buf_t *pkt, void *iph, uint64_t iphlen,
> -                            metrics_t *metrics)
> +static INLINING verdict_t process_udp(buf_t *pkt, void *iph, uint64_t iphlen,
> +                                     metrics_t *metrics)
>  {
>         metrics->l4_protocol_packets_total_udp++;
>
> @@ -837,7 +844,7 @@ static verdict_t process_udp(buf_t *pkt, void *iph, uint64_t iphlen,
>         return classify_udp(pkt->skb, &tuple, tuplen);
>  }
>
> -static verdict_t process_ipv4(buf_t *pkt, metrics_t *metrics)
> +static INLINING verdict_t process_ipv4(buf_t *pkt, metrics_t *metrics)
>  {
>         metrics->l3_protocol_packets_total_ipv4++;
>
> @@ -874,7 +881,7 @@ static verdict_t process_ipv4(buf_t *pkt, metrics_t *metrics)
>         }
>  }
>
> -static verdict_t process_ipv6(buf_t *pkt, metrics_t *metrics)
> +static INLINING verdict_t process_ipv6(buf_t *pkt, metrics_t *metrics)
>  {
>         metrics->l3_protocol_packets_total_ipv6++;
>
> diff --git a/tools/testing/selftests/bpf/progs/test_cls_redirect_subprogs.c b/tools/testing/selftests/bpf/progs/test_cls_redirect_subprogs.c
> new file mode 100644
> index 000000000000..eed26b70e3a2
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_cls_redirect_subprogs.c
> @@ -0,0 +1,2 @@
> +#define SUBPROGS
> +#include "test_cls_redirect.c"
> --
> 2.24.1
>


-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
