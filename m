Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A94B056BF6B
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 20:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238600AbiGHQtP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 12:49:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238099AbiGHQtO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 12:49:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C5081E3FB;
        Fri,  8 Jul 2022 09:49:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A358622EC;
        Fri,  8 Jul 2022 16:49:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86E27C341C6;
        Fri,  8 Jul 2022 16:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657298952;
        bh=71/D2igWE3HfEGRsBW79k6KVzfnzn8KlVshYAOVpp1w=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Ztldf7MyyImuaRJkuyhBY7RCgf6a0gUniJPZtDeZSVJB6nHiDXdbj1m7gGNEJm+FD
         +YZLZ8XAHXJe73vhTCVSaze43bsB8jXNngMugYK9bcm+MOWViJ8HQAAS5ZI192GILR
         dvdBKq/LM384ph00D4XA7YYDmlP2KJjbCrvJpMPls3qwkNJzUrZ3zA3kKMsVvAq9sI
         abgIMp3G1B83GNEyLUrmTEGi675m1B2yAMLCo1PQydeeQGsIi9LjIHOuWJAxJ3++zC
         IJ9SOM7yj0VQxRp89dUd7HDHEfB+UP9N8NOzrRAz+65s8CRX/ENikUVHSIDUu4yfX2
         ipxVhRzOHfULQ==
Received: by mail-yb1-f173.google.com with SMTP id 64so29469815ybt.12;
        Fri, 08 Jul 2022 09:49:12 -0700 (PDT)
X-Gm-Message-State: AJIora/j2FeecnO9g8e72v4amg2EHIV5POyP8NB0clUnqUXrR7c3EPDH
        V35WGwhx3Fs9UB/CggHSUn5+zZ5m3Jd2lF6/++Q=
X-Google-Smtp-Source: AGRyM1uyUE+qmmEK1J9qDHRLaz+EGwSfNDas5Z7iUChEpqzrBvnAUE6FyULJzuP3QLwEhcyMqym9Zo48wGF1Rq2aGa8=
X-Received: by 2002:a25:9c09:0:b0:66e:4d5c:8cbc with SMTP id
 c9-20020a259c09000000b0066e4d5c8cbcmr4356435ybo.449.1657298951592; Fri, 08
 Jul 2022 09:49:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220708130319.1016294-1-maximmi@nvidia.com>
In-Reply-To: <20220708130319.1016294-1-maximmi@nvidia.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 8 Jul 2022 09:49:00 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5oGiXy27wyYXkzXCgYo+PD50paOvT1qKDwNjGsxGuWzQ@mail.gmail.com>
Message-ID: <CAPhsuW5oGiXy27wyYXkzXCgYo+PD50paOvT1qKDwNjGsxGuWzQ@mail.gmail.com>
Subject: Re: [PATCH bpf] selftests/bpf: Fix xdp_synproxy build failure if CONFIG_NF_CONNTRACK=m/n
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     Shuah Khan <shuah@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        Yauheni Kaliuta <ykaliuta@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 8, 2022 at 6:03 AM Maxim Mikityanskiy <maximmi@nvidia.com> wrote:
>
> When CONFIG_NF_CONNTRACK=m, struct bpf_ct_opts and enum member
> BPF_F_CURRENT_NETNS are not exposed. This commit allows building the
> xdp_synproxy selftest in such cases. Note that nf_conntrack must be
> loaded before running the test if it's compiled as a module.
>
> This commit also allows this selftest to be successfully compiled when
> CONFIG_NF_CONNTRACK is disabled.
>
> One unused local variable of type struct bpf_ct_opts is also removed.
>
> Reported-by: Yauheni Kaliuta <ykaliuta@redhat.com>
> Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
> Fixes: fb5cd0ce70d4 ("selftests/bpf: Add selftests for raw syncookie helpers")

Given tools/testing/selftests/bpf/config specifies CONFIG_NF_CONNTRACK=y,
I don't think this is really necessary.

Thanks,
Song


> ---
>  .../selftests/bpf/progs/xdp_synproxy_kern.c   | 24 +++++++++++++------
>  1 file changed, 17 insertions(+), 7 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/progs/xdp_synproxy_kern.c b/tools/testing/selftests/bpf/progs/xdp_synproxy_kern.c
> index 9fd62e94b5e6..736686e903f6 100644
> --- a/tools/testing/selftests/bpf/progs/xdp_synproxy_kern.c
> +++ b/tools/testing/selftests/bpf/progs/xdp_synproxy_kern.c
> @@ -77,16 +77,30 @@ struct {
>         __uint(max_entries, MAX_ALLOWED_PORTS);
>  } allowed_ports SEC(".maps");
>
> +/* Some symbols defined in net/netfilter/nf_conntrack_bpf.c are unavailable in
> + * vmlinux.h if CONFIG_NF_CONNTRACK=m, so they are redefined locally.
> + */
> +
> +struct bpf_ct_opts___local {
> +       s32 netns_id;
> +       s32 error;
> +       u8 l4proto;
> +       u8 dir;
> +       u8 reserved[2];
> +} __attribute__((preserve_access_index));
> +
> +#define BPF_F_CURRENT_NETNS (-1)
> +
>  extern struct nf_conn *bpf_xdp_ct_lookup(struct xdp_md *xdp_ctx,
>                                          struct bpf_sock_tuple *bpf_tuple,
>                                          __u32 len_tuple,
> -                                        struct bpf_ct_opts *opts,
> +                                        struct bpf_ct_opts___local *opts,
>                                          __u32 len_opts) __ksym;
>
>  extern struct nf_conn *bpf_skb_ct_lookup(struct __sk_buff *skb_ctx,
>                                          struct bpf_sock_tuple *bpf_tuple,
>                                          u32 len_tuple,
> -                                        struct bpf_ct_opts *opts,
> +                                        struct bpf_ct_opts___local *opts,
>                                          u32 len_opts) __ksym;
>
>  extern void bpf_ct_release(struct nf_conn *ct) __ksym;
> @@ -393,7 +407,7 @@ static __always_inline int tcp_dissect(void *data, void *data_end,
>
>  static __always_inline int tcp_lookup(void *ctx, struct header_pointers *hdr, bool xdp)
>  {
> -       struct bpf_ct_opts ct_lookup_opts = {
> +       struct bpf_ct_opts___local ct_lookup_opts = {
>                 .netns_id = BPF_F_CURRENT_NETNS,
>                 .l4proto = IPPROTO_TCP,
>         };
> @@ -714,10 +728,6 @@ static __always_inline int syncookie_handle_ack(struct header_pointers *hdr)
>  static __always_inline int syncookie_part1(void *ctx, void *data, void *data_end,
>                                            struct header_pointers *hdr, bool xdp)
>  {
> -       struct bpf_ct_opts ct_lookup_opts = {
> -               .netns_id = BPF_F_CURRENT_NETNS,
> -               .l4proto = IPPROTO_TCP,
> -       };
>         int ret;
>
>         ret = tcp_dissect(data, data_end, hdr);
> --
> 2.30.2
>
