Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA6A741EB
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 01:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729157AbfGXXVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 19:21:37 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:36509 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726770AbfGXXVg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 19:21:36 -0400
Received: by mail-qt1-f193.google.com with SMTP id z4so47319420qtc.3;
        Wed, 24 Jul 2019 16:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HHzevg38Glkii+JDnKvOxD/95f0KY584UCBXjEnE0mo=;
        b=P4JE///Eq8NOJegY0vhuARI4l5i+x1QHmw0zxDlPO2IUfRBw+/+1LqM9jksgi5F9+v
         i2eDvulELvgcwAsUdWeOUIZ3B2xGKqbqpl5eQ9Byutt5iR7ChE0k0fiNXYryxm1Sx4j7
         5ICNUesvzaB1sRS/oT74d8ufJPgk/7LqyyB1/lEI3p0rHa6po//b2M5Se/YYg0PbZTR+
         Qg43gxix0Mb4TyVH+eYyPEMighu8dXOwpbVPUoOQwrISG5FQIeXhXFldiqrk2XHQ2DH2
         f9x++Wfl/jCEIZa3YV21N8H39dbRZioqJfN8b+4joSZbKnOhTdQOWwvGoP7lwvPwHPF7
         Pfrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HHzevg38Glkii+JDnKvOxD/95f0KY584UCBXjEnE0mo=;
        b=pU+f8/S4vWao1aAtnsix0cm1FqcrLbiG3aILT4ilgCVzaXldvKz+Q80v2/PFbwueAm
         59nmnLpSESK51WrUWg4anrHlqD+aVmdgBlrvQ568Xa/7Sk2l0UCP6rjZYgFcl3yR2wk6
         yqLRi4jNzhBCyLCDklb1UR2PWtT5hFY+gNWUmjxajCRUhWMkInWsKM7MoJwIcuIT9iHP
         dn5zDb0kkMV/faGgRu5UBWUMEPkWmY3ZfNfBzzxlwsQBHnTe0wHbB0StujCk2kM/mdQA
         oIL8b2JjqSvUYkjp+JsqxLGg3ohpypoCIFCelkNpy/qPskeLzjD7OL6tI1DGl37W1n3G
         10Sg==
X-Gm-Message-State: APjAAAW9dm3BmuCoCkJDUOL+ntj7GDa35Upa4JYwHOvu/Uka/GClE7vh
        MNu3TCmSMuZPtfowPr+IL0peIzY4G/EUw4yp2qY=
X-Google-Smtp-Source: APXvYqzDabuL9lJcqotQOzuZG7rui+KVP7ga/MdSlCQzxxreqAd94QmwWrw/des5fMbifk+3IY2RnusVdnw9tXXDw9U=
X-Received: by 2002:ac8:25e7:: with SMTP id f36mr59918832qtf.139.1564010495769;
 Wed, 24 Jul 2019 16:21:35 -0700 (PDT)
MIME-Version: 1.0
References: <20190724170018.96659-1-sdf@google.com> <20190724170018.96659-6-sdf@google.com>
In-Reply-To: <20190724170018.96659-6-sdf@google.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Wed, 24 Jul 2019 16:21:24 -0700
Message-ID: <CAPhsuW6Z2Bx66ZDOV-9jW+hsxKbZJxY-YFgP0rL_4QipAuptQA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 5/7] sefltests/bpf: support FLOW_DISSECTOR_F_PARSE_1ST_FRAG
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
> bpf_flow.c: exit early unless FLOW_DISSECTOR_F_PARSE_1ST_FRAG is passed
> in flags. Also, set ip_proto earlier, this makes sure we have correct
> value with fragmented packets.
>
> Add selftest cases to test ipv4/ipv6 fragments and skip eth_get_headlen
> tests that don't have FLOW_DISSECTOR_F_PARSE_1ST_FRAG flag.
>
> eth_get_headlen calls flow dissector with
> FLOW_DISSECTOR_F_PARSE_1ST_FRAG flag so we can't run tests that
> have different set of input flags against it.
>
> Cc: Willem de Bruijn <willemb@google.com>
> Cc: Petar Penkov <ppenkov@google.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  .../selftests/bpf/prog_tests/flow_dissector.c | 129 ++++++++++++++++++
>  tools/testing/selftests/bpf/progs/bpf_flow.c  |  28 +++-
>  2 files changed, 151 insertions(+), 6 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/flow_dissector.c b/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
> index c938283ac232..966cb3b06870 100644
> --- a/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
> +++ b/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
> @@ -5,6 +5,10 @@
>  #include <linux/if_tun.h>
>  #include <sys/uio.h>
>
> +#ifndef IP_MF
> +#define IP_MF 0x2000
> +#endif
> +
>  #define CHECK_FLOW_KEYS(desc, got, expected)                           \
>         CHECK_ATTR(memcmp(&got, &expected, sizeof(got)) != 0,           \
>               desc,                                                     \
> @@ -49,6 +53,18 @@ struct ipv6_pkt {
>         struct tcphdr tcp;
>  } __packed;
>
> +struct ipv6_frag_pkt {
> +       struct ethhdr eth;
> +       struct ipv6hdr iph;
> +       struct frag_hdr {
> +               __u8 nexthdr;
> +               __u8 reserved;
> +               __be16 frag_off;
> +               __be32 identification;
> +       } ipf;
> +       struct tcphdr tcp;
> +} __packed;
> +
>  struct dvlan_ipv6_pkt {
>         struct ethhdr eth;
>         __u16 vlan_tci;
> @@ -65,9 +81,11 @@ struct test {
>                 struct ipv4_pkt ipv4;
>                 struct svlan_ipv4_pkt svlan_ipv4;
>                 struct ipv6_pkt ipv6;
> +               struct ipv6_frag_pkt ipv6_frag;
>                 struct dvlan_ipv6_pkt dvlan_ipv6;
>         } pkt;
>         struct bpf_flow_keys keys;
> +       __u32 flags;
>  };
>
>  #define VLAN_HLEN      4
> @@ -143,6 +161,102 @@ struct test tests[] = {
>                         .n_proto = __bpf_constant_htons(ETH_P_IPV6),
>                 },
>         },
> +       {
> +               .name = "ipv4-frag",
> +               .pkt.ipv4 = {
> +                       .eth.h_proto = __bpf_constant_htons(ETH_P_IP),
> +                       .iph.ihl = 5,
> +                       .iph.protocol = IPPROTO_TCP,
> +                       .iph.tot_len = __bpf_constant_htons(MAGIC_BYTES),
> +                       .iph.frag_off = __bpf_constant_htons(IP_MF),
> +                       .tcp.doff = 5,
> +                       .tcp.source = 80,
> +                       .tcp.dest = 8080,
> +               },
> +               .keys = {
> +                       .flags = FLOW_DISSECTOR_F_PARSE_1ST_FRAG,
> +                       .nhoff = ETH_HLEN,
> +                       .thoff = ETH_HLEN + sizeof(struct iphdr),
> +                       .addr_proto = ETH_P_IP,
> +                       .ip_proto = IPPROTO_TCP,
> +                       .n_proto = __bpf_constant_htons(ETH_P_IP),
> +                       .is_frag = true,
> +                       .is_first_frag = true,
> +                       .sport = 80,
> +                       .dport = 8080,
> +               },
> +               .flags = FLOW_DISSECTOR_F_PARSE_1ST_FRAG,
> +       },
> +       {
> +               .name = "ipv4-no-frag",
> +               .pkt.ipv4 = {
> +                       .eth.h_proto = __bpf_constant_htons(ETH_P_IP),
> +                       .iph.ihl = 5,
> +                       .iph.protocol = IPPROTO_TCP,
> +                       .iph.tot_len = __bpf_constant_htons(MAGIC_BYTES),
> +                       .iph.frag_off = __bpf_constant_htons(IP_MF),
> +                       .tcp.doff = 5,
> +                       .tcp.source = 80,
> +                       .tcp.dest = 8080,
> +               },
> +               .keys = {
> +                       .nhoff = ETH_HLEN,
> +                       .thoff = ETH_HLEN + sizeof(struct iphdr),
> +                       .addr_proto = ETH_P_IP,
> +                       .ip_proto = IPPROTO_TCP,
> +                       .n_proto = __bpf_constant_htons(ETH_P_IP),
> +                       .is_frag = true,
> +                       .is_first_frag = true,
> +               },
> +       },
> +       {
> +               .name = "ipv6-frag",
> +               .pkt.ipv6_frag = {
> +                       .eth.h_proto = __bpf_constant_htons(ETH_P_IPV6),
> +                       .iph.nexthdr = IPPROTO_FRAGMENT,
> +                       .iph.payload_len = __bpf_constant_htons(MAGIC_BYTES),
> +                       .ipf.nexthdr = IPPROTO_TCP,
> +                       .tcp.doff = 5,
> +                       .tcp.source = 80,
> +                       .tcp.dest = 8080,
> +               },
> +               .keys = {
> +                       .flags = FLOW_DISSECTOR_F_PARSE_1ST_FRAG,
> +                       .nhoff = ETH_HLEN,
> +                       .thoff = ETH_HLEN + sizeof(struct ipv6hdr) +
> +                               sizeof(struct frag_hdr),
> +                       .addr_proto = ETH_P_IPV6,
> +                       .ip_proto = IPPROTO_TCP,
> +                       .n_proto = __bpf_constant_htons(ETH_P_IPV6),
> +                       .is_frag = true,
> +                       .is_first_frag = true,
> +                       .sport = 80,
> +                       .dport = 8080,
> +               },
> +               .flags = FLOW_DISSECTOR_F_PARSE_1ST_FRAG,
> +       },
> +       {
> +               .name = "ipv6-no-frag",
> +               .pkt.ipv6_frag = {
> +                       .eth.h_proto = __bpf_constant_htons(ETH_P_IPV6),
> +                       .iph.nexthdr = IPPROTO_FRAGMENT,
> +                       .iph.payload_len = __bpf_constant_htons(MAGIC_BYTES),
> +                       .ipf.nexthdr = IPPROTO_TCP,
> +                       .tcp.doff = 5,
> +                       .tcp.source = 80,
> +                       .tcp.dest = 8080,
> +               },
> +               .keys = {
> +                       .nhoff = ETH_HLEN,
> +                       .thoff = ETH_HLEN + sizeof(struct ipv6hdr) +
> +                               sizeof(struct frag_hdr),
> +                       .addr_proto = ETH_P_IPV6,
> +                       .ip_proto = IPPROTO_TCP,
> +                       .n_proto = __bpf_constant_htons(ETH_P_IPV6),
> +                       .is_frag = true,
> +                       .is_first_frag = true,
> +               },
> +       },
>  };
>
>  static int create_tap(const char *ifname)
> @@ -225,6 +339,13 @@ void test_flow_dissector(void)
>                         .data_size_in = sizeof(tests[i].pkt),
>                         .data_out = &flow_keys,
>                 };
> +               static struct bpf_flow_keys ctx = {};
> +
> +               if (tests[i].flags) {
> +                       tattr.ctx_in = &ctx;
> +                       tattr.ctx_size_in = sizeof(ctx);
> +                       ctx.flags = tests[i].flags;
> +               }
>
>                 err = bpf_prog_test_run_xattr(&tattr);
>                 CHECK_ATTR(tattr.data_size_out != sizeof(flow_keys) ||
> @@ -255,6 +376,14 @@ void test_flow_dissector(void)
>                 struct bpf_prog_test_run_attr tattr = {};
>                 __u32 key = 0;
>
> +               /* Don't run tests that are not marked as
> +                * FLOW_DISSECTOR_F_PARSE_1ST_FRAG; eth_get_headlen
> +                * sets this flag.
> +                */
> +
> +               if (tests[i].flags != FLOW_DISSECTOR_F_PARSE_1ST_FRAG)
> +                       continue;

Maybe test flags & FLOW_DISSECTOR_F_PARSE_1ST_FRAG == 0 instead?
It is not necessary now, but might be useful in the future.

Thanks,
Song
