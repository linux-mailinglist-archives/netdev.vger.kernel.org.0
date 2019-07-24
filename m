Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 667E274214
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 01:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728752AbfGXX3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 19:29:55 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:44364 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726099AbfGXX3z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 19:29:55 -0400
Received: by mail-qt1-f194.google.com with SMTP id 44so16267653qtg.11;
        Wed, 24 Jul 2019 16:29:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R0CXUaqZkZtPh5uZZFJlrQkTv1zJWAk0qQVuJr4EOhM=;
        b=C89oG34Vqt6efrjwBHwkQZuHg8EjG8BGLU59CKPxIwsIqntS8jMaX7KLJkMPkhCMox
         aHOhgdz2JwEjDtfwPAdBY81GOPZzUdPral+crKCtUI2g8FbS1MPfWrwdDqFgAbo0kFI1
         iqc+2Rts4/1WusX3gtEvM5zx7iTqUvG8IJv9G0ZZe1mR0X7DxbkjGg6FLi0GCvWiQV2i
         6Uw5sElgYNRgKA92Cnl0Z5eaAIV/p8dvIdBD1ETyBiEBRJSs9w9eL+/vcmJXR27IJbO3
         j6Jyqnrl7+WOn6PB0d5lhnJ7ZHEZ/Sc8FW2XOUfjqTXz/LQ6NaSR/d2KZa8PBOtOm/hG
         vCCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R0CXUaqZkZtPh5uZZFJlrQkTv1zJWAk0qQVuJr4EOhM=;
        b=s5+UK75gak4Hfad0l7+dzjdhnPpB28eus79yTr4NDOoohYT8vG0cd6W1cLbiuG8T6H
         4DI5dCLkJaHXKa0JSWZ+xMVhGyHI5OX0WZ2eEV5VYFW70K2Lst79r6JfpUlEsVrH+h8C
         iBAemOLrVJIaITjA6QjAu2k9KPphcqE8Mr50bROnjrpuRYoX+5uqjKNwvQAoitlT/yBl
         mEt0YvUeuRRpAhcJhKse4dqqHMk6srjFmzjmbs2nT2OttBeYJibsaiJv8ZRiq/WIz7jn
         gNz0fPyc2EW7fpj3bT/4FYisUGU+aNck4LedA6Q9m5V5WWIP/k3cla7E1ljkDyfA3DeD
         HSUQ==
X-Gm-Message-State: APjAAAUHyvDSkxpVJ9I5e1c/Ym3w4NW6O5GwvDOIgME2S9SkssiGD7/Z
        wwKAYM7SHQa6HCo1HM4GP1/h/vr9yqTilKMlm2I=
X-Google-Smtp-Source: APXvYqwwWrVrnQ9cTNEjgM32saBOFJDARISK44BmuqWYp4zxbN/r6XlJVZihGmUqW05RsiU7IofMHDkxLmzuK4/aDIw=
X-Received: by 2002:ac8:6a17:: with SMTP id t23mr57950525qtr.183.1564010993975;
 Wed, 24 Jul 2019 16:29:53 -0700 (PDT)
MIME-Version: 1.0
References: <20190724170018.96659-1-sdf@google.com> <20190724170018.96659-8-sdf@google.com>
In-Reply-To: <20190724170018.96659-8-sdf@google.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Wed, 24 Jul 2019 16:29:42 -0700
Message-ID: <CAPhsuW4A_z+LxUZ8zDojNWaAWHTNi9w1nA1Bj2NBNzY+DJtyNQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 7/7] selftests/bpf: support FLOW_DISSECTOR_F_STOP_AT_ENCAP
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 10:11 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> Exit as soon as we found that packet is encapped when
> FLOW_DISSECTOR_F_STOP_AT_ENCAP is passed.
> Add appropriate selftest cases.
>
> Cc: Willem de Bruijn <willemb@google.com>
> Cc: Petar Penkov <ppenkov@google.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
>  .../selftests/bpf/prog_tests/flow_dissector.c | 60 +++++++++++++++++++
>  tools/testing/selftests/bpf/progs/bpf_flow.c  |  8 +++
>  2 files changed, 68 insertions(+)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/flow_dissector.c b/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
> index 1ea921c4cdc0..e382264fbc40 100644
> --- a/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
> +++ b/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
> @@ -41,6 +41,13 @@ struct ipv4_pkt {
>         struct tcphdr tcp;
>  } __packed;
>
> +struct ipip_pkt {
> +       struct ethhdr eth;
> +       struct iphdr iph;
> +       struct iphdr iph_inner;
> +       struct tcphdr tcp;
> +} __packed;
> +
>  struct svlan_ipv4_pkt {
>         struct ethhdr eth;
>         __u16 vlan_tci;
> @@ -82,6 +89,7 @@ struct test {
>         union {
>                 struct ipv4_pkt ipv4;
>                 struct svlan_ipv4_pkt svlan_ipv4;
> +               struct ipip_pkt ipip;
>                 struct ipv6_pkt ipv6;
>                 struct ipv6_frag_pkt ipv6_frag;
>                 struct dvlan_ipv6_pkt dvlan_ipv6;
> @@ -303,6 +311,58 @@ struct test tests[] = {
>                 },
>                 .flags = FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL,
>         },
> +       {
> +               .name = "ipip-encap",
> +               .pkt.ipip = {
> +                       .eth.h_proto = __bpf_constant_htons(ETH_P_IP),
> +                       .iph.ihl = 5,
> +                       .iph.protocol = IPPROTO_IPIP,
> +                       .iph.tot_len = __bpf_constant_htons(MAGIC_BYTES),
> +                       .iph_inner.ihl = 5,
> +                       .iph_inner.protocol = IPPROTO_TCP,
> +                       .iph_inner.tot_len = __bpf_constant_htons(MAGIC_BYTES),
> +                       .tcp.doff = 5,
> +                       .tcp.source = 80,
> +                       .tcp.dest = 8080,
> +               },
> +               .keys = {
> +                       .nhoff = 0,
> +                       .nhoff = ETH_HLEN,
> +                       .thoff = ETH_HLEN + sizeof(struct iphdr) +
> +                               sizeof(struct iphdr),
> +                       .addr_proto = ETH_P_IP,
> +                       .ip_proto = IPPROTO_TCP,
> +                       .n_proto = __bpf_constant_htons(ETH_P_IP),
> +                       .is_encap = true,
> +                       .sport = 80,
> +                       .dport = 8080,
> +               },
> +       },
> +       {
> +               .name = "ipip-no-encap",
> +               .pkt.ipip = {
> +                       .eth.h_proto = __bpf_constant_htons(ETH_P_IP),
> +                       .iph.ihl = 5,
> +                       .iph.protocol = IPPROTO_IPIP,
> +                       .iph.tot_len = __bpf_constant_htons(MAGIC_BYTES),
> +                       .iph_inner.ihl = 5,
> +                       .iph_inner.protocol = IPPROTO_TCP,
> +                       .iph_inner.tot_len = __bpf_constant_htons(MAGIC_BYTES),
> +                       .tcp.doff = 5,
> +                       .tcp.source = 80,
> +                       .tcp.dest = 8080,
> +               },
> +               .keys = {
> +                       .flags = FLOW_DISSECTOR_F_STOP_AT_ENCAP,
> +                       .nhoff = ETH_HLEN,
> +                       .thoff = ETH_HLEN + sizeof(struct iphdr),
> +                       .addr_proto = ETH_P_IP,
> +                       .ip_proto = IPPROTO_IPIP,
> +                       .n_proto = __bpf_constant_htons(ETH_P_IP),
> +                       .is_encap = true,
> +               },
> +               .flags = FLOW_DISSECTOR_F_STOP_AT_ENCAP,
> +       },
>  };
>
>  static int create_tap(const char *ifname)
> diff --git a/tools/testing/selftests/bpf/progs/bpf_flow.c b/tools/testing/selftests/bpf/progs/bpf_flow.c
> index 7d73b7bfe609..b6236cdf8564 100644
> --- a/tools/testing/selftests/bpf/progs/bpf_flow.c
> +++ b/tools/testing/selftests/bpf/progs/bpf_flow.c
> @@ -167,9 +167,15 @@ static __always_inline int parse_ip_proto(struct __sk_buff *skb, __u8 proto)
>                 return export_flow_keys(keys, BPF_OK);
>         case IPPROTO_IPIP:
>                 keys->is_encap = true;
> +               if (keys->flags & FLOW_DISSECTOR_F_STOP_AT_ENCAP)
> +                       return export_flow_keys(keys, BPF_OK);
> +
>                 return parse_eth_proto(skb, bpf_htons(ETH_P_IP));
>         case IPPROTO_IPV6:
>                 keys->is_encap = true;
> +               if (keys->flags & FLOW_DISSECTOR_F_STOP_AT_ENCAP)
> +                       return export_flow_keys(keys, BPF_OK);
> +
>                 return parse_eth_proto(skb, bpf_htons(ETH_P_IPV6));
>         case IPPROTO_GRE:
>                 gre = bpf_flow_dissect_get_header(skb, sizeof(*gre), &_gre);
> @@ -189,6 +195,8 @@ static __always_inline int parse_ip_proto(struct __sk_buff *skb, __u8 proto)
>                         keys->thoff += 4; /* Step over sequence number */
>
>                 keys->is_encap = true;
> +               if (keys->flags & FLOW_DISSECTOR_F_STOP_AT_ENCAP)
> +                       return export_flow_keys(keys, BPF_OK);
>
>                 if (gre->proto == bpf_htons(ETH_P_TEB)) {
>                         eth = bpf_flow_dissect_get_header(skb, sizeof(*eth),
> --
> 2.22.0.657.g960e92d24f-goog
>
