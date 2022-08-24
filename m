Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 383365A018E
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 20:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239423AbiHXSrW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 14:47:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231400AbiHXSrU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 14:47:20 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FD067AC3D;
        Wed, 24 Aug 2022 11:47:19 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id gt3so22806976ejb.12;
        Wed, 24 Aug 2022 11:47:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=71zclsJgvSoxJEFegzokttijXTGmFgxYJBGMn1UIyuY=;
        b=Bc5I89BWNncttLIzUpu/uUHMjGg2UDmX1WDjAFqKLZswTSfqIwFF5hFDbejpYm74mk
         E2PpQZ9MbY4ZAkuImcMfVa/jqBEM55HLKCzD2F4ZI9LlrlOmFE5k8yL1xrjQgLl/u1+5
         inuWcOzIAA1AS53uAVg0T9LHVHb3ye4EXew8v524CUmjE9HetbENGGAOqXCQfzTAM4mj
         cdGqv74YbPUu5htbzDNpMU3TQpDZbQ+ZDEwHfmqo4+nrW/NpJPfFjVX7oq6ZmH8H8N1/
         aYFzJrGy0zq4MRVfkkn5ygusXOAUDfIYVH2ZFYa8aqsyrMj3kpqq3ShnJoI6keiHdJuR
         7Y/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=71zclsJgvSoxJEFegzokttijXTGmFgxYJBGMn1UIyuY=;
        b=okr7Dc3YYcOaGWDP/zcvF1z8I7uUnBLi408wbS8mp4bQe1Qad0z8WshlQi2vdZUFKw
         NmWyuNYKmGSn9+SUlIyw7I/WUYFAJmfZRJtI70nTghjyMY7oHcYEp4tgRaDV1wg5MAsZ
         L4c2qMsEeauFOLqAuLEnqL7Z617IrR5J/3KpIu1XIOBna3GxRGL/wLX7NUKc01knsCY+
         quo5mC1k7MpRO1DQUPWAY6j2SdoiFN/XyPC0cF5FCHSqtRLZ0bz/ra0R3N5geKXK86a1
         Ik0ez4ca0Y89wfnu9tR4TGfHlOCGzabZjaIxBjiM9HEjMxbdDyA2eFhr+ysVlYaVR93v
         VFLg==
X-Gm-Message-State: ACgBeo2eOW5/cNvVn7/lhC4ER8BTxDSsBfSdX0mH8D0C5C0/0ohyEZwE
        d5789SXcYsTuDpe2MAiGu5TW6y89uvPzZCNVAYY=
X-Google-Smtp-Source: AA6agR7TrqXyWrGjdKXUw5dWjoLXxaOqpHOPGPxa+rFOk6CZKCfH+JbBwPv+TMQszgLuITGrY+bqbeEeXtkrlHSn8XE=
X-Received: by 2002:a17:907:6096:b0:73d:9d12:4b04 with SMTP id
 ht22-20020a170907609600b0073d9d124b04mr171281ejc.745.1661366837640; Wed, 24
 Aug 2022 11:47:17 -0700 (PDT)
MIME-Version: 1.0
References: <20220822235649.2218031-1-joannelkoong@gmail.com> <20220822235649.2218031-4-joannelkoong@gmail.com>
In-Reply-To: <20220822235649.2218031-4-joannelkoong@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 24 Aug 2022 11:47:06 -0700
Message-ID: <CAEf4BzY049DX_Y1eF-gPpS3hyc6ymSAnSvS6hOK3TKFx-kf6_Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 3/3] selftests/bpf: tests for using dynptrs to
 parse skb and xdp buffers
To:     Joanne Koong <joannelkoong@gmail.com>
Cc:     bpf@vger.kernel.org, andrii@kernel.org, daniel@iogearbox.net,
        ast@kernel.org, kafai@fb.com, kuba@kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 22, 2022 at 4:57 PM Joanne Koong <joannelkoong@gmail.com> wrote:
>
> Test skb and xdp dynptr functionality in the following ways:
>
> 1) progs/test_cls_redirect_dynptr.c
>    * Rewrite "progs/test_cls_redirect.c" test to use dynptrs to parse
>      skb data
>
>    * This is a great example of how dynptrs can be used to simplify a
>      lot of the parsing logic for non-statically known values, and speed
>      up execution times.
>
>      When measuring the user + system time between the original version
>      vs. using dynptrs, and averaging the time for 10 runs (using
>      "time ./test_progs -t cls_redirect"), there was a 2x speed-up:
>          original version: 0.053 sec
>          with dynptrs: 0.025 sec
>
> 2) progs/test_xdp_dynptr.c
>    * Rewrite "progs/test_xdp.c" test to use dynptrs to parse xdp data
>
>      There were no noticeable diferences in user + system time between
>      the original version vs. using dynptrs. Averaging the time for 10
>      runs (run using "time ./test_progs -t xdp_bpf2bpf"):
>          original version: 0.0449 sec
>          with dynptrs: 0.0429 sec
>
> 3) progs/test_l4lb_noinline_dynptr.c
>    * Rewrite "progs/test_l4lb_noinline.c" test to use dynptrs to parse
>      skb data
>
>      There were no noticeable diferences in user + system time between
>      the original version vs. using dynptrs. Averaging the time for 10
>      runs (run using "time ./test_progs -t l4lb_all"):
>          original version: 0.0502 sec
>          with dynptrs: 0.055 sec
>
>      For number of processed verifier instructions:
>          original version: 6284 insns
>          with dynptrs: 2538 insns
>
> 4) progs/test_parse_tcp_hdr_opt_dynptr.c
>    * Add sample code for parsing tcp hdr opt lookup using dynptrs.
>      This logic is lifted from a real-world use case of packet parsing in
>      katran [0], a layer 4 load balancer. The original version
>      "progs/test_parse_tcp_hdr_opt.c" (not using dynptrs) is included
>      here as well, for comparison.
>
> 5) progs/dynptr_success.c
>    * Add test case "test_skb_readonly" for testing attempts at writes /
>      data slices on a prog type with read-only skb ctx.
>
> 6) progs/dynptr_fail.c
>    * Add test cases "skb_invalid_data_slice{1,2}" and
>      "xdp_invalid_data_slice" for testing that helpers that modify the
>      underlying packet buffer automatically invalidate the associated
>      data slice.
>    * Add test cases "skb_invalid_ctx" and "xdp_invalid_ctx" for testing
>      that prog types that do not support bpf_dynptr_from_skb/xdp don't
>      have access to the API.
>    * Add test case "skb_invalid_write" for testing that read-only skb
>      dynptrs can't be written to through data slices.
>
> [0] https://github.com/facebookincubator/katran/blob/main/katran/lib/bpf/pckt_parsing.h
>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
>  .../selftests/bpf/prog_tests/cls_redirect.c   |  25 +
>  .../testing/selftests/bpf/prog_tests/dynptr.c | 132 ++-
>  .../selftests/bpf/prog_tests/l4lb_all.c       |   2 +
>  .../bpf/prog_tests/parse_tcp_hdr_opt.c        |  85 ++
>  .../selftests/bpf/prog_tests/xdp_attach.c     |   9 +-
>  .../testing/selftests/bpf/progs/dynptr_fail.c | 111 ++
>  .../selftests/bpf/progs/dynptr_success.c      |  29 +
>  .../bpf/progs/test_cls_redirect_dynptr.c      | 968 ++++++++++++++++++
>  .../bpf/progs/test_l4lb_noinline_dynptr.c     | 468 +++++++++
>  .../bpf/progs/test_parse_tcp_hdr_opt.c        | 119 +++
>  .../bpf/progs/test_parse_tcp_hdr_opt_dynptr.c | 110 ++
>  .../selftests/bpf/progs/test_xdp_dynptr.c     | 240 +++++
>  .../selftests/bpf/test_tcp_hdr_options.h      |   1 +
>  13 files changed, 2255 insertions(+), 44 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/parse_tcp_hdr_opt.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_cls_redirect_dynptr.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_l4lb_noinline_dynptr.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_parse_tcp_hdr_opt.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_parse_tcp_hdr_opt_dynptr.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_xdp_dynptr.c
>

Massive work on adding lots of selftests, thanks! Left few nits, but
looks good anyways:

Acked-by: Andrii Nakryiko <andrii@kernel.org>


[...]

> -       /* success cases */
> -       {"test_read_write", NULL},
> -       {"test_data_slice", NULL},
> -       {"test_ringbuf", NULL},
> +               "Unsupported reg type fp for bpf_dynptr_from_mem data", SETUP_NONE},
> +       {"skb_invalid_data_slice1", "invalid mem access 'scalar'", SETUP_NONE},
> +       {"skb_invalid_data_slice2", "invalid mem access 'scalar'", SETUP_NONE},
> +       {"xdp_invalid_data_slice", "invalid mem access 'scalar'", SETUP_NONE},
> +       {"skb_invalid_ctx", "unknown func bpf_dynptr_from_skb", SETUP_NONE},
> +       {"xdp_invalid_ctx", "unknown func bpf_dynptr_from_xdp", SETUP_NONE},
> +       {"skb_invalid_write", "cannot write into packet", SETUP_NONE},

nit: given SETUP_NONE is zero, you can just leave it out to make this
table a bit cleaner; bit no big deal having it explicitly as well

> +
> +       /* these tests should be run and should succeed */
> +       {"test_read_write", NULL, SETUP_SYSCALL_SLEEP},
> +       {"test_data_slice", NULL, SETUP_SYSCALL_SLEEP},
> +       {"test_ringbuf", NULL, SETUP_SYSCALL_SLEEP},
> +       {"test_skb_readonly", NULL, SETUP_SKB_PROG},
>  };
>

[...]

> +static void test_parsing(bool use_dynptr)
> +{
> +       char buf[128];
> +       struct bpf_program *prog;
> +       void *skel_ptr;
> +       int err;
> +
> +       LIBBPF_OPTS(bpf_test_run_opts, topts,
> +                   .data_in = &pkt,
> +                   .data_size_in = sizeof(pkt),
> +                   .data_out = buf,
> +                   .data_size_out = sizeof(buf),
> +                   .repeat = 3,
> +       );
> +
> +       if (use_dynptr) {
> +               struct test_parse_tcp_hdr_opt_dynptr *skel;
> +
> +               skel = test_parse_tcp_hdr_opt_dynptr__open_and_load();
> +               if (!ASSERT_OK_PTR(skel, "skel_open_and_load"))
> +                       return;
> +
> +               pkt.options[6] = skel->rodata->tcp_hdr_opt_kind_tpr;
> +               prog = skel->progs.xdp_ingress_v6;
> +               skel_ptr = skel;
> +       } else {
> +               struct test_parse_tcp_hdr_opt *skel;
> +
> +               skel = test_parse_tcp_hdr_opt__open_and_load();
> +               if (!ASSERT_OK_PTR(skel, "skel_open_and_load"))
> +                       return;
> +
> +               pkt.options[6] = skel->rodata->tcp_hdr_opt_kind_tpr;
> +               prog = skel->progs.xdp_ingress_v6;
> +               skel_ptr = skel;
> +       }
> +
> +       err = bpf_prog_test_run_opts(bpf_program__fd(prog), &topts);
> +       ASSERT_OK(err, "ipv6 test_run");
> +       ASSERT_EQ(topts.retval, XDP_PASS, "ipv6 test_run retval");
> +
> +       if (use_dynptr) {
> +               struct test_parse_tcp_hdr_opt_dynptr *skel = skel_ptr;
> +
> +               ASSERT_EQ(skel->bss->server_id, 0x9000000, "server id");
> +               test_parse_tcp_hdr_opt_dynptr__destroy(skel);
> +       } else {
> +               struct test_parse_tcp_hdr_opt *skel = skel_ptr;
> +
> +               ASSERT_EQ(skel->bss->server_id, 0x9000000, "server id");
> +               test_parse_tcp_hdr_opt__destroy(skel);
> +       }
> +}
> +
> +void test_parse_tcp_hdr_opt(void)
> +{
> +       test_parsing(false);
> +       test_parsing(true);

given this false/true argument is very non-descriptive and you
basically only share few lines of code inside test_parsing, why not
have two dedicated test_parsing_wo_dynptr and
test_parsing_with_dynptr? And probably makes sense to make those two
as two subtests?

> +}
> diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_attach.c b/tools/testing/selftests/bpf/prog_tests/xdp_attach.c
> index 62aa3edda5e6..40d0d61af9e6 100644
> --- a/tools/testing/selftests/bpf/prog_tests/xdp_attach.c
> +++ b/tools/testing/selftests/bpf/prog_tests/xdp_attach.c
> @@ -4,11 +4,10 @@
>  #define IFINDEX_LO 1
>  #define XDP_FLAGS_REPLACE              (1U << 4)
>
> -void serial_test_xdp_attach(void)
> +static void serial_test_xdp_attach(const char *file)
>  {
>         __u32 duration = 0, id1, id2, id0 = 0, len;
>         struct bpf_object *obj1, *obj2, *obj3;
> -       const char *file = "./test_xdp.o";
>         struct bpf_prog_info info = {};
>         int err, fd1, fd2, fd3;
>         LIBBPF_OPTS(bpf_xdp_attach_opts, opts);
> @@ -85,3 +84,9 @@ void serial_test_xdp_attach(void)
>  out_1:
>         bpf_object__close(obj1);
>  }
> +
> +void test_xdp_attach(void)
> +{
> +       serial_test_xdp_attach("./test_xdp.o");
> +       serial_test_xdp_attach("./test_xdp_dynptr.o");

nit: make into subtests?

> +}

[...]

> +/* The data slice is invalidated whenever a helper changes packet data */
> +SEC("?xdp")
> +int xdp_invalid_data_slice(struct xdp_md *xdp)
> +{
> +       struct bpf_dynptr ptr;
> +       struct ethhdr *hdr;
> +
> +       bpf_dynptr_from_xdp(xdp, 0, &ptr);
> +       hdr = bpf_dynptr_data(&ptr, 0, sizeof(*hdr));
> +       if (!hdr)
> +               return SK_DROP;
> +
> +       hdr->h_proto = 9;
> +
> +       if (bpf_xdp_adjust_head(xdp, 0 - (int)sizeof(*hdr)))
> +               return XDP_DROP;
> +
> +       /* this should fail */
> +       hdr->h_proto = 1;
> +
> +       return XDP_PASS;
> +}
> +
> +/* Only supported prog type can create skb-type dynptrs */
> +SEC("?raw_tp/sys_nanosleep")

nit: there is no sys_nanosleep raw tracepoint, is there? Just
SEC("?raw_tp") maybe, like you did in recent refactoring?

> +int skb_invalid_ctx(void *ctx)
> +{
> +       struct bpf_dynptr ptr;
> +
> +       /* this should fail */
> +       bpf_dynptr_from_skb(ctx, 0, &ptr);
> +
> +       return 0;
> +}
> +
> +/* Only supported prog type can create xdp-type dynptrs */
> +SEC("?raw_tp/sys_nanosleep")
> +int xdp_invalid_ctx(void *ctx)
> +{
> +       struct bpf_dynptr ptr;
> +
> +       /* this should fail */
> +       bpf_dynptr_from_xdp(ctx, 0, &ptr);
> +
> +       return 0;
> +}
> +

[...]

> +
> +/* Global metrics, per CPU
> + */
> +struct {
> +       __uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
> +       __uint(max_entries, 1);
> +       __type(key, unsigned int);
> +       __type(value, metrics_t);
> +} metrics_map SEC(".maps");
> +
> +static metrics_t *get_global_metrics(void)
> +{
> +       uint64_t key = 0;
> +       return bpf_map_lookup_elem(&metrics_map, &key);
> +}
> +
> +static ret_t accept_locally(struct __sk_buff *skb, encap_headers_t *encap)
> +{
> +       const int payload_off =
> +               sizeof(*encap) +
> +               sizeof(struct in_addr) * encap->unigue.hop_count;
> +       int32_t encap_overhead = payload_off - sizeof(struct ethhdr);
> +
> +       // Changing the ethertype if the encapsulated packet is ipv6

nit: could be copy/paste from original, but let's not add C++ comments?

> +       if (encap->gue.proto_ctype == IPPROTO_IPV6)
> +               encap->eth.h_proto = bpf_htons(ETH_P_IPV6);
> +
> +       if (bpf_skb_adjust_room(skb, -encap_overhead, BPF_ADJ_ROOM_MAC,
> +                               BPF_F_ADJ_ROOM_FIXED_GSO |
> +                               BPF_F_ADJ_ROOM_NO_CSUM_RESET) ||
> +           bpf_csum_level(skb, BPF_CSUM_LEVEL_DEC))
> +               return TC_ACT_SHOT;
> +
> +       return bpf_redirect(skb->ifindex, BPF_F_INGRESS);
> +}
> +

[...]

> +       iph->version = 4;
> +       iph->ihl = iphdr_sz >> 2;
> +       iph->frag_off = 0;
> +       iph->protocol = IPPROTO_IPIP;
> +       iph->check = 0;
> +       iph->tos = 0;
> +       iph->tot_len = bpf_htons(payload_len + iphdr_sz);
> +       iph->daddr = tnl->daddr.v4;
> +       iph->saddr = tnl->saddr.v4;
> +       iph->ttl = 8;
> +
> +       next_iph = (__u16 *)iph;
> +#pragma clang loop unroll(full)

nit: probably don't need unroll?

> +       for (i = 0; i < iphdr_sz >> 1; i++)
> +               csum += *next_iph++;
> +
> +       iph->check = ~((csum & 0xffff) + (csum >> 16));
> +
> +       count_tx(vip.protocol);
> +
> +       return XDP_TX;
> +}

[...]
