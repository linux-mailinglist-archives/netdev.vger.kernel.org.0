Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9D42F0BEC
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 03:14:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730678AbfKFCOy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 21:14:54 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:33626 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730645AbfKFCOy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 21:14:54 -0500
Received: by mail-qt1-f195.google.com with SMTP id y39so32082477qty.0;
        Tue, 05 Nov 2019 18:14:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1n7rXJdBnEW4HDkgOsfFOH8oFowWrMyjmeHAX89n+5M=;
        b=ksqBZxy0dw5ezzrmYonzEN+23CwtkeUaJu5dy+GmfMqhSASjnrUpod0sNQOr1XgEFS
         c4ScRkdDghWBxNWxG1Lwj5ETLJapj9o/5vMP+vyERpMwKs6Qf8xD9kKGudttWXeSj64E
         ImrrNCQjX8Y6LIBVb9OBxyiyW0P+zE45z9qWMSAUbOS2t3n0pmlzCIhLzyxZ5+9JloVX
         WN73oRxDQo2MFIHiq3GkTvTgTQiuAsdibys/6xVlJCJ9AlJ0Tw5I6yzRweO1sXx5cyuS
         tna1BeZ6zmE35exWIMIg0Wnjm6YUcNa9xH5im++WKk20wbGgC8qfdiEhU+wwr4wdgVpS
         KP5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1n7rXJdBnEW4HDkgOsfFOH8oFowWrMyjmeHAX89n+5M=;
        b=r+6OBydEm++ApeHuwcwPqWu7WrGmiECYpldlJ4sGZxacMkwkZ2ZJvlprvhx5y7OJvx
         wohtPY+/GfOzy0jdoHMQxv9W0W0tKRHYfHNknhSDTmr/ph+6OVto6hcYbx0qOykRY5l4
         mKNox2dkE0kwW39RYHXOncQWmybjKim3FRZjtLB/+klg02E2kNLIlECVAdN1+HydyCMZ
         +YAx+VN61OCU4Q2B3nEv6iGeMZxbKnZDzg8qWovtxfT+97zBUAuy+on45hFm3fJpuTaS
         5HnVGkSvTLvS18Y4TNfVlMyw2Yv7AWiBhdH2mhOksUSxcpybAaIcdYKchFH49O98ql9+
         Bt7g==
X-Gm-Message-State: APjAAAWiCsYDn6D12o58nPRTWiZEsHbqUC9foWplXd1Gu+LJVQGutc8M
        pt3gVU8dbviPk1zr1zUVbIklarGa1RJRwP+cB/E=
X-Google-Smtp-Source: APXvYqzd5JiqTmGjG0/qXBdkgLNkyiGLoDI4Tu4cgnHmwpMA8wfV8fY+yTs3OJVBDdlE0dXAZBL05JNdP3kBQoL1cSE=
X-Received: by 2002:ac8:199d:: with SMTP id u29mr273428qtj.93.1573006490782;
 Tue, 05 Nov 2019 18:14:50 -0800 (PST)
MIME-Version: 1.0
References: <20191105225111.4940-1-danieltimlee@gmail.com> <20191105225111.4940-3-danieltimlee@gmail.com>
In-Reply-To: <20191105225111.4940-3-danieltimlee@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 5 Nov 2019 18:14:39 -0800
Message-ID: <CAEf4BzapG=xt57i2jEViydA=R2RpkS2bMB-u28-S2Kj7pxe2GA@mail.gmail.com>
Subject: Re: [PATCH,bpf-next 2/2] samples: bpf: update map definition to new
 syntax BTF-defined map
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 5, 2019 at 2:52 PM Daniel T. Lee <danieltimlee@gmail.com> wrote:
>
> Since, the new syntax of BTF-defined map has been introduced,
> the syntax for using maps under samples directory are mixed up.
> For example, some are already using the new syntax, and some are using
> existing syntax by calling them as 'legacy'.
>
> As stated at commit abd29c931459 ("libbpf: allow specifying map
> definitions using BTF"), the BTF-defined map has more compatablility
> with extending supported map definition features.
>
> The commit doesn't replace all of the map to new BTF-defined map,
> because some of the samples still use bpf_load instead of libbpf, which
> can't properly create BTF-defined map.
>
> This will only updates the samples which uses libbpf API for loading bpf
> program. (ex. bpf_prog_load_xattr)
>
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> ---


Please try to stick to __type() for key/value, where possible (all the
arrays, hashes, per-cpu arrays definitely work). Some of the special
CPUMAP, DEVMAP might not work. Not sure about TRIEs, please try.

>  samples/bpf/sockex1_kern.c          |  12 ++--
>  samples/bpf/sockex2_kern.c          |  12 ++--
>  samples/bpf/xdp1_kern.c             |  12 ++--
>  samples/bpf/xdp2_kern.c             |  12 ++--
>  samples/bpf/xdp_adjust_tail_kern.c  |  12 ++--
>  samples/bpf/xdp_fwd_kern.c          |  13 ++--
>  samples/bpf/xdp_redirect_cpu_kern.c | 108 ++++++++++++++--------------
>  samples/bpf/xdp_redirect_kern.c     |  24 +++----
>  samples/bpf/xdp_redirect_map_kern.c |  24 +++----
>  samples/bpf/xdp_router_ipv4_kern.c  |  64 ++++++++---------
>  samples/bpf/xdp_rxq_info_kern.c     |  36 +++++-----
>  samples/bpf/xdp_tx_iptunnel_kern.c  |  26 +++----
>  12 files changed, 177 insertions(+), 178 deletions(-)
>
> diff --git a/samples/bpf/sockex1_kern.c b/samples/bpf/sockex1_kern.c
> index f96943f443ab..493f102711c0 100644
> --- a/samples/bpf/sockex1_kern.c
> +++ b/samples/bpf/sockex1_kern.c
> @@ -5,12 +5,12 @@
>  #include "bpf_helpers.h"
>  #include "bpf_legacy.h"
>
> -struct bpf_map_def SEC("maps") my_map = {
> -       .type = BPF_MAP_TYPE_ARRAY,
> -       .key_size = sizeof(u32),
> -       .value_size = sizeof(long),
> -       .max_entries = 256,
> -};
> +struct {
> +       __uint(type, BPF_MAP_TYPE_ARRAY);
> +       __uint(key_size, sizeof(u32));
> +       __uint(value_size, sizeof(long));
> +       __uint(max_entries, 256);
> +} my_map SEC(".maps");
>
>  SEC("socket1")
>  int bpf_prog1(struct __sk_buff *skb)
> diff --git a/samples/bpf/sockex2_kern.c b/samples/bpf/sockex2_kern.c
> index 5566fa7d92fa..bd756494625b 100644
> --- a/samples/bpf/sockex2_kern.c
> +++ b/samples/bpf/sockex2_kern.c
> @@ -190,12 +190,12 @@ struct pair {
>         long bytes;
>  };
>
> -struct bpf_map_def SEC("maps") hash_map = {
> -       .type = BPF_MAP_TYPE_HASH,
> -       .key_size = sizeof(__be32),
> -       .value_size = sizeof(struct pair),
> -       .max_entries = 1024,
> -};
> +struct {
> +       __uint(type, BPF_MAP_TYPE_HASH);
> +       __uint(key_size, sizeof(__be32));
> +       __uint(value_size, sizeof(struct pair));

let's use __type(key, __be32) and __type(value, struct pair) here and
in most other places where we have maps supporting BTF

> +       __uint(max_entries, 1024);
> +} hash_map SEC(".maps");
>
>  SEC("socket2")
>  int bpf_prog2(struct __sk_buff *skb)
> diff --git a/samples/bpf/xdp1_kern.c b/samples/bpf/xdp1_kern.c
> index 219742106bfd..a0a181164087 100644
> --- a/samples/bpf/xdp1_kern.c
> +++ b/samples/bpf/xdp1_kern.c
> @@ -14,12 +14,12 @@
>  #include <linux/ipv6.h>
>  #include "bpf_helpers.h"
>
> -struct bpf_map_def SEC("maps") rxcnt = {
> -       .type = BPF_MAP_TYPE_PERCPU_ARRAY,
> -       .key_size = sizeof(u32),
> -       .value_size = sizeof(long),
> -       .max_entries = 256,
> -};
> +struct {
> +       __uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
> +       __uint(key_size, sizeof(u32));
> +       __uint(value_size, sizeof(long));
> +       __uint(max_entries, 256);
> +} rxcnt SEC(".maps");
>
>  static int parse_ipv4(void *data, u64 nh_off, void *data_end)
>  {
> diff --git a/samples/bpf/xdp2_kern.c b/samples/bpf/xdp2_kern.c
> index e01288867d15..21564a95561b 100644
> --- a/samples/bpf/xdp2_kern.c
> +++ b/samples/bpf/xdp2_kern.c
> @@ -14,12 +14,12 @@
>  #include <linux/ipv6.h>
>  #include "bpf_helpers.h"
>
> -struct bpf_map_def SEC("maps") rxcnt = {
> -       .type = BPF_MAP_TYPE_PERCPU_ARRAY,
> -       .key_size = sizeof(u32),
> -       .value_size = sizeof(long),
> -       .max_entries = 256,
> -};
> +struct {
> +       __uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
> +       __uint(key_size, sizeof(u32));
> +       __uint(value_size, sizeof(long));
> +       __uint(max_entries, 256);
> +} rxcnt SEC(".maps");
>
>  static void swap_src_dst_mac(void *data)
>  {
> diff --git a/samples/bpf/xdp_adjust_tail_kern.c b/samples/bpf/xdp_adjust_tail_kern.c
> index c616508befb9..6de45a4a2c3e 100644
> --- a/samples/bpf/xdp_adjust_tail_kern.c
> +++ b/samples/bpf/xdp_adjust_tail_kern.c
> @@ -28,12 +28,12 @@
>  /* volatile to prevent compiler optimizations */
>  static volatile __u32 max_pcktsz = MAX_PCKT_SIZE;
>
> -struct bpf_map_def SEC("maps") icmpcnt = {
> -       .type = BPF_MAP_TYPE_ARRAY,
> -       .key_size = sizeof(__u32),
> -       .value_size = sizeof(__u64),
> -       .max_entries = 1,
> -};
> +struct {
> +       __uint(type, BPF_MAP_TYPE_ARRAY);
> +       __uint(key_size, sizeof(__u32));
> +       __uint(value_size, sizeof(__u64));
> +       __uint(max_entries, 1);
> +} icmpcnt SEC(".maps");
>
>  static __always_inline void count_icmp(void)
>  {
> diff --git a/samples/bpf/xdp_fwd_kern.c b/samples/bpf/xdp_fwd_kern.c
> index 701a30f258b1..d013029aeaa2 100644
> --- a/samples/bpf/xdp_fwd_kern.c
> +++ b/samples/bpf/xdp_fwd_kern.c
> @@ -23,13 +23,12 @@
>
>  #define IPV6_FLOWINFO_MASK              cpu_to_be32(0x0FFFFFFF)
>
> -/* For TX-traffic redirect requires net_device ifindex to be in this devmap */
> -struct bpf_map_def SEC("maps") xdp_tx_ports = {
> -       .type = BPF_MAP_TYPE_DEVMAP,
> -       .key_size = sizeof(int),
> -       .value_size = sizeof(int),
> -       .max_entries = 64,
> -};
> +struct {
> +       __uint(type, BPF_MAP_TYPE_DEVMAP);
> +       __uint(key_size, sizeof(int));
> +       __uint(value_size, sizeof(int));
> +       __uint(max_entries, 64);
> +} xdp_tx_ports SEC(".maps");

DEVMAP might be special, I don't remember, so key_size/value_size
might be necessary

>
>  /* from include/net/ip.h */
>  static __always_inline int ip_decrease_ttl(struct iphdr *iph)
> diff --git a/samples/bpf/xdp_redirect_cpu_kern.c b/samples/bpf/xdp_redirect_cpu_kern.c
> index a306d1c75622..1f472506aa54 100644
> --- a/samples/bpf/xdp_redirect_cpu_kern.c
> +++ b/samples/bpf/xdp_redirect_cpu_kern.c
> @@ -18,12 +18,12 @@
>  #define MAX_CPUS 64 /* WARNING - sync with _user.c */
>
>  /* Special map type that can XDP_REDIRECT frames to another CPU */
> -struct bpf_map_def SEC("maps") cpu_map = {
> -       .type           = BPF_MAP_TYPE_CPUMAP,
> -       .key_size       = sizeof(u32),
> -       .value_size     = sizeof(u32),
> -       .max_entries    = MAX_CPUS,
> -};
> +struct {
> +       __uint(type, BPF_MAP_TYPE_CPUMAP);
> +       __uint(key_size, sizeof(u32));
> +       __uint(value_size, sizeof(u32));
> +       __uint(max_entries, MAX_CPUS);
> +} cpu_map SEC(".maps");
>

same for CPUMAP, but would be nice to double-check.

>  /* Common stats data record to keep userspace more simple */
>  struct datarec {
> @@ -35,67 +35,67 @@ struct datarec {
>  /* Count RX packets, as XDP bpf_prog doesn't get direct TX-success
>   * feedback.  Redirect TX errors can be caught via a tracepoint.
>   */
> -struct bpf_map_def SEC("maps") rx_cnt = {
> -       .type           = BPF_MAP_TYPE_PERCPU_ARRAY,
> -       .key_size       = sizeof(u32),
> -       .value_size     = sizeof(struct datarec),
> -       .max_entries    = 1,
> -};
> +struct {
> +       __uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
> +       __uint(key_size, sizeof(u32));
> +       __uint(value_size, sizeof(struct datarec));
> +       __uint(max_entries, 1);
> +} rx_cnt SEC(".maps");
>
>  /* Used by trace point */
> -struct bpf_map_def SEC("maps") redirect_err_cnt = {
> -       .type           = BPF_MAP_TYPE_PERCPU_ARRAY,
> -       .key_size       = sizeof(u32),
> -       .value_size     = sizeof(struct datarec),
> -       .max_entries    = 2,
> +struct {
> +       __uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
> +       __uint(key_size, sizeof(u32));
> +       __uint(value_size, sizeof(struct datarec));
> +       __uint(max_entries, 2);
>         /* TODO: have entries for all possible errno's */
> -};
> +} redirect_err_cnt SEC(".maps");
>
>  /* Used by trace point */
> -struct bpf_map_def SEC("maps") cpumap_enqueue_cnt = {
> -       .type           = BPF_MAP_TYPE_PERCPU_ARRAY,
> -       .key_size       = sizeof(u32),
> -       .value_size     = sizeof(struct datarec),
> -       .max_entries    = MAX_CPUS,
> -};
> +struct {
> +       __uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
> +       __uint(key_size, sizeof(u32));
> +       __uint(value_size, sizeof(struct datarec));
> +       __uint(max_entries, MAX_CPUS);
> +} cpumap_enqueue_cnt SEC(".maps");
>
>  /* Used by trace point */
> -struct bpf_map_def SEC("maps") cpumap_kthread_cnt = {
> -       .type           = BPF_MAP_TYPE_PERCPU_ARRAY,
> -       .key_size       = sizeof(u32),
> -       .value_size     = sizeof(struct datarec),
> -       .max_entries    = 1,
> -};
> +struct {
> +       __uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
> +       __uint(key_size, sizeof(u32));
> +       __uint(value_size, sizeof(struct datarec));
> +       __uint(max_entries, 1);
> +} cpumap_kthread_cnt SEC(".maps");
>
>  /* Set of maps controlling available CPU, and for iterating through
>   * selectable redirect CPUs.
>   */
> -struct bpf_map_def SEC("maps") cpus_available = {
> -       .type           = BPF_MAP_TYPE_ARRAY,
> -       .key_size       = sizeof(u32),
> -       .value_size     = sizeof(u32),
> -       .max_entries    = MAX_CPUS,
> -};
> -struct bpf_map_def SEC("maps") cpus_count = {
> -       .type           = BPF_MAP_TYPE_ARRAY,
> -       .key_size       = sizeof(u32),
> -       .value_size     = sizeof(u32),
> -       .max_entries    = 1,
> -};
> -struct bpf_map_def SEC("maps") cpus_iterator = {
> -       .type           = BPF_MAP_TYPE_PERCPU_ARRAY,
> -       .key_size       = sizeof(u32),
> -       .value_size     = sizeof(u32),
> -       .max_entries    = 1,
> -};
> +struct {
> +       __uint(type, BPF_MAP_TYPE_ARRAY);
> +       __uint(key_size, sizeof(u32));
> +       __uint(value_size, sizeof(u32));
> +       __uint(max_entries, MAX_CPUS);
> +} cpus_available SEC(".maps");
> +struct {
> +       __uint(type, BPF_MAP_TYPE_ARRAY);
> +       __uint(key_size, sizeof(u32));
> +       __uint(value_size, sizeof(u32));
> +       __uint(max_entries, 1);
> +} cpus_count SEC(".maps");
> +struct {
> +       __uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
> +       __uint(key_size, sizeof(u32));
> +       __uint(value_size, sizeof(u32));
> +       __uint(max_entries, 1);
> +} cpus_iterator SEC(".maps");
>
>  /* Used by trace point */
> -struct bpf_map_def SEC("maps") exception_cnt = {
> -       .type           = BPF_MAP_TYPE_PERCPU_ARRAY,
> -       .key_size       = sizeof(u32),
> -       .value_size     = sizeof(struct datarec),
> -       .max_entries    = 1,
> -};
> +struct {
> +       __uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
> +       __uint(key_size, sizeof(u32));
> +       __uint(value_size, sizeof(struct datarec));
> +       __uint(max_entries, 1);
> +} exception_cnt SEC(".maps");
>
>  /* Helper parse functions */
>
> diff --git a/samples/bpf/xdp_redirect_kern.c b/samples/bpf/xdp_redirect_kern.c
> index 8abb151e385f..205fa07eb135 100644
> --- a/samples/bpf/xdp_redirect_kern.c
> +++ b/samples/bpf/xdp_redirect_kern.c
> @@ -19,22 +19,22 @@
>  #include <linux/ipv6.h>
>  #include "bpf_helpers.h"
>
> -struct bpf_map_def SEC("maps") tx_port = {
> -       .type = BPF_MAP_TYPE_ARRAY,
> -       .key_size = sizeof(int),
> -       .value_size = sizeof(int),
> -       .max_entries = 1,
> -};
> +struct {
> +       __uint(type, BPF_MAP_TYPE_ARRAY);
> +       __uint(key_size, sizeof(int));
> +       __uint(value_size, sizeof(int));
> +       __uint(max_entries, 1);
> +} tx_port SEC(".maps");
>
>  /* Count RX packets, as XDP bpf_prog doesn't get direct TX-success
>   * feedback.  Redirect TX errors can be caught via a tracepoint.
>   */
> -struct bpf_map_def SEC("maps") rxcnt = {
> -       .type = BPF_MAP_TYPE_PERCPU_ARRAY,
> -       .key_size = sizeof(u32),
> -       .value_size = sizeof(long),
> -       .max_entries = 1,
> -};
> +struct {
> +       __uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
> +       __uint(key_size, sizeof(u32));
> +       __uint(value_size, sizeof(long));
> +       __uint(max_entries, 1);
> +} rxcnt SEC(".maps");
>
>  static void swap_src_dst_mac(void *data)
>  {
> diff --git a/samples/bpf/xdp_redirect_map_kern.c b/samples/bpf/xdp_redirect_map_kern.c
> index 740a529ba84f..ed5870e305a3 100644
> --- a/samples/bpf/xdp_redirect_map_kern.c
> +++ b/samples/bpf/xdp_redirect_map_kern.c
> @@ -19,22 +19,22 @@
>  #include <linux/ipv6.h>
>  #include "bpf_helpers.h"
>
> -struct bpf_map_def SEC("maps") tx_port = {
> -       .type = BPF_MAP_TYPE_DEVMAP,
> -       .key_size = sizeof(int),
> -       .value_size = sizeof(int),
> -       .max_entries = 100,
> -};
> +struct {
> +       __uint(type, BPF_MAP_TYPE_DEVMAP);
> +       __uint(key_size, sizeof(int));
> +       __uint(value_size, sizeof(int));
> +       __uint(max_entries, 100);
> +} tx_port SEC(".maps");
>
>  /* Count RX packets, as XDP bpf_prog doesn't get direct TX-success
>   * feedback.  Redirect TX errors can be caught via a tracepoint.
>   */
> -struct bpf_map_def SEC("maps") rxcnt = {
> -       .type = BPF_MAP_TYPE_PERCPU_ARRAY,
> -       .key_size = sizeof(u32),
> -       .value_size = sizeof(long),
> -       .max_entries = 1,
> -};
> +struct {
> +       __uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
> +       __uint(key_size, sizeof(u32));
> +       __uint(value_size, sizeof(long));
> +       __uint(max_entries, 1);
> +} rxcnt SEC(".maps");
>
>  static void swap_src_dst_mac(void *data)
>  {
> diff --git a/samples/bpf/xdp_router_ipv4_kern.c b/samples/bpf/xdp_router_ipv4_kern.c
> index 993f56bc7b9a..92809c5d8c63 100644
> --- a/samples/bpf/xdp_router_ipv4_kern.c
> +++ b/samples/bpf/xdp_router_ipv4_kern.c
> @@ -42,44 +42,44 @@ struct direct_map {
>  };
>
>  /* Map for trie implementation*/
> -struct bpf_map_def SEC("maps") lpm_map = {
> -       .type = BPF_MAP_TYPE_LPM_TRIE,
> -       .key_size = 8,
> -       .value_size = sizeof(struct trie_value),
> -       .max_entries = 50,
> -       .map_flags = BPF_F_NO_PREALLOC,
> -};
> +struct {
> +       __uint(type, BPF_MAP_TYPE_LPM_TRIE);
> +       __uint(key_size, 8);
> +       __uint(value_size, sizeof(struct trie_value));
> +       __uint(max_entries, 50);
> +       __uint(map_flags, BPF_F_NO_PREALLOC);
> +} lpm_map SEC(".maps");
>
>  /* Map for counter*/
> -struct bpf_map_def SEC("maps") rxcnt = {
> -       .type = BPF_MAP_TYPE_PERCPU_ARRAY,
> -       .key_size = sizeof(u32),
> -       .value_size = sizeof(u64),
> -       .max_entries = 256,
> -};
> +struct {
> +       __uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
> +       __uint(key_size, sizeof(u32));
> +       __uint(value_size, sizeof(u64));
> +       __uint(max_entries, 256);
> +} rxcnt SEC(".maps");
>
>  /* Map for ARP table*/
> -struct bpf_map_def SEC("maps") arp_table = {
> -       .type = BPF_MAP_TYPE_HASH,
> -       .key_size = sizeof(__be32),
> -       .value_size = sizeof(__be64),
> -       .max_entries = 50,
> -};
> +struct {
> +       __uint(type, BPF_MAP_TYPE_HASH);
> +       __uint(key_size, sizeof(__be32));
> +       __uint(value_size, sizeof(__be64));
> +       __uint(max_entries, 50);
> +} arp_table SEC(".maps");
>
>  /* Map to keep the exact match entries in the route table*/
> -struct bpf_map_def SEC("maps") exact_match = {
> -       .type = BPF_MAP_TYPE_HASH,
> -       .key_size = sizeof(__be32),
> -       .value_size = sizeof(struct direct_map),
> -       .max_entries = 50,
> -};
> -
> -struct bpf_map_def SEC("maps") tx_port = {
> -       .type = BPF_MAP_TYPE_DEVMAP,
> -       .key_size = sizeof(int),
> -       .value_size = sizeof(int),
> -       .max_entries = 100,
> -};
> +struct {
> +       __uint(type, BPF_MAP_TYPE_HASH);
> +       __uint(key_size, sizeof(__be32));
> +       __uint(value_size, sizeof(struct direct_map));
> +       __uint(max_entries, 50);
> +} exact_match SEC(".maps");
> +
> +struct {
> +       __uint(type, BPF_MAP_TYPE_DEVMAP);
> +       __uint(key_size, sizeof(int));
> +       __uint(value_size, sizeof(int));
> +       __uint(max_entries, 100);
> +} tx_port SEC(".maps");
>
>  /* Function to set source and destination mac of the packet */
>  static inline void set_src_dst_mac(void *data, void *src, void *dst)
> diff --git a/samples/bpf/xdp_rxq_info_kern.c b/samples/bpf/xdp_rxq_info_kern.c
> index 222a83eed1cb..6a78f399113d 100644
> --- a/samples/bpf/xdp_rxq_info_kern.c
> +++ b/samples/bpf/xdp_rxq_info_kern.c
> @@ -23,12 +23,13 @@ enum cfg_options_flags {
>         READ_MEM = 0x1U,
>         SWAP_MAC = 0x2U,
>  };
> -struct bpf_map_def SEC("maps") config_map = {
> -       .type           = BPF_MAP_TYPE_ARRAY,
> -       .key_size       = sizeof(int),
> -       .value_size     = sizeof(struct config),
> -       .max_entries    = 1,
> -};
> +
> +struct {
> +       __uint(type, BPF_MAP_TYPE_ARRAY);
> +       __uint(key_size, sizeof(int));
> +       __uint(value_size, sizeof(struct config));
> +       __uint(max_entries, 1);
> +} config_map SEC(".maps");
>
>  /* Common stats data record (shared with userspace) */
>  struct datarec {
> @@ -36,22 +37,22 @@ struct datarec {
>         __u64 issue;
>  };
>
> -struct bpf_map_def SEC("maps") stats_global_map = {
> -       .type           = BPF_MAP_TYPE_PERCPU_ARRAY,
> -       .key_size       = sizeof(u32),
> -       .value_size     = sizeof(struct datarec),
> -       .max_entries    = 1,
> -};
> +struct {
> +       __uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
> +       __uint(key_size, sizeof(u32));
> +       __uint(value_size, sizeof(struct datarec));
> +       __uint(max_entries, 1);
> +} stats_global_map SEC(".maps");
>
>  #define MAX_RXQs 64
>
>  /* Stats per rx_queue_index (per CPU) */
> -struct bpf_map_def SEC("maps") rx_queue_index_map = {
> -       .type           = BPF_MAP_TYPE_PERCPU_ARRAY,
> -       .key_size       = sizeof(u32),
> -       .value_size     = sizeof(struct datarec),
> -       .max_entries    = MAX_RXQs + 1,
> -};
> +struct {
> +       __uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
> +       __uint(key_size, sizeof(u32));
> +       __uint(value_size, sizeof(struct datarec));
> +       __uint(max_entries, MAX_RXQs + 1);
> +} rx_queue_index_map SEC(".maps");
>
>  static __always_inline
>  void swap_src_dst_mac(void *data)
> diff --git a/samples/bpf/xdp_tx_iptunnel_kern.c b/samples/bpf/xdp_tx_iptunnel_kern.c
> index 0f4f6e8c8611..044b6f3edfeb 100644
> --- a/samples/bpf/xdp_tx_iptunnel_kern.c
> +++ b/samples/bpf/xdp_tx_iptunnel_kern.c
> @@ -19,19 +19,19 @@
>  #include "bpf_helpers.h"
>  #include "xdp_tx_iptunnel_common.h"
>
> -struct bpf_map_def SEC("maps") rxcnt = {
> -       .type = BPF_MAP_TYPE_PERCPU_ARRAY,
> -       .key_size = sizeof(__u32),
> -       .value_size = sizeof(__u64),
> -       .max_entries = 256,
> -};
> -
> -struct bpf_map_def SEC("maps") vip2tnl = {
> -       .type = BPF_MAP_TYPE_HASH,
> -       .key_size = sizeof(struct vip),
> -       .value_size = sizeof(struct iptnl_info),
> -       .max_entries = MAX_IPTNL_ENTRIES,
> -};
> +struct {
> +       __uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
> +       __uint(key_size, sizeof(__u32));
> +       __uint(value_size, sizeof(__u64));
> +       __uint(max_entries, 256);
> +} rxcnt SEC(".maps");
> +
> +struct {
> +       __uint(type, BPF_MAP_TYPE_HASH);
> +       __uint(key_size, sizeof(struct vip));
> +       __uint(value_size, sizeof(struct iptnl_info));
> +       __uint(max_entries, MAX_IPTNL_ENTRIES);
> +} vip2tnl SEC(".maps");
>
>  static __always_inline void count_tx(u32 protocol)
>  {
> --
> 2.23.0
>
