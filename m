Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A33885616EE
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 11:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234668AbiF3J5v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 05:57:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234670AbiF3J5t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 05:57:49 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABF7D43AFB;
        Thu, 30 Jun 2022 02:57:48 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id i64so17645957pfc.8;
        Thu, 30 Jun 2022 02:57:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ncsyqHcViJJ4xNGmWodTdODg7NgMYoxOAe0vPdW5K18=;
        b=pFiyyWCPgnEaKgm2kdXIGgChNq2vFIGamHlBAKxyopo5nkQZvaC0MHq9QvmyLPvMgu
         wLDYmY9Cy7MT3Q3mpi65XOWX0LE6gJni3U0+GQIRC0y9NOUJDyyCdaXko0bMeBRo3yS6
         0Z89fpQgX1nWZm1E8aWyDUEGk6PTOX/Z1yIEFxoGKPirBj+tb6aPZaAIVooDg+dfTaVY
         58cKElHOWKjlcqE9wcahteTyE1N8+5AlYGy5W66R5GstHZsD7m34b3YYb7gkfIErEvNM
         f1UDgEOWK2ISWLABlyTHGkav1xkLcg8rA5GDQC1qtaMZTfU9L0bJPU7oD8K0Dx2NEUOC
         9L9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ncsyqHcViJJ4xNGmWodTdODg7NgMYoxOAe0vPdW5K18=;
        b=4M55SFcs8DBS7er/GQfXnlmb72yPy8aXgnYDDmMbestbEflDxo7J9B+FVeQe0Gf4O0
         V8YZa0fPNvSM3HryTUfDyxSYAsHm/oikAYvFziWWPhR3r5O13lrHkpZr64Cnv/8837ZD
         ft2zXiU0Lu+27MMlCMZMz+L17TQeQdjLZXcy2JWBlwueaaPwE/2SR5cFufr8u/GHon75
         l7XtvUamLHEXJq7pnG84tRNWuT+6ROSREWtvRltX6h3t7IHSEXKuvr1I11zQ6eBK7sB3
         f2L3NrztHk2+nGxbI5wJcjDsO8qz16vRJ4Ww9kTgw2qx3YMTYfQ37BA0ydhHeVvUskO6
         qqdQ==
X-Gm-Message-State: AJIora+hNAibxfoqD7da0XTxcKc8/cGXyrrFv/q9+PvPQt0VlAqqGsOz
        Ak5wqXAMNoBSSdFRVX9WuPmASXVtMvPj8yrBO1x6vxCgC452Aatf
X-Google-Smtp-Source: AGRyM1utt5/iEtZsSWmrKvP7ceRD86RJESast4Pg4pWM6AtDLhoHG4Lz1uDGnqJuNF+5K073nr3HKdet+b/e+QjMxUg=
X-Received: by 2002:a05:6a00:225a:b0:525:4d37:6b30 with SMTP id
 i26-20020a056a00225a00b005254d376b30mr14943061pfu.83.1656583068221; Thu, 30
 Jun 2022 02:57:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220629143458.934337-1-maciej.fijalkowski@intel.com> <20220629143458.934337-4-maciej.fijalkowski@intel.com>
In-Reply-To: <20220629143458.934337-4-maciej.fijalkowski@intel.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Thu, 30 Jun 2022 11:57:37 +0200
Message-ID: <CAJ8uoz1CqxcirC-Fhfp3-dpf2U6E8PnnTTULdPqTnazQXGayQw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/4] selftests: xsk: verify correctness of XDP
 prog attach point
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
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

On Wed, Jun 29, 2022 at 4:39 PM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> To prevent the case we had previously where for TEST_MODE_SKB, XDP prog
> was attached in native mode, call bpf_xdp_query() after loading prog and
> make sure that attach_mode is as expected.

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  tools/testing/selftests/bpf/xdpxceiver.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
>
> diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
> index c024aa91ea02..4c425a43e5b0 100644
> --- a/tools/testing/selftests/bpf/xdpxceiver.c
> +++ b/tools/testing/selftests/bpf/xdpxceiver.c
> @@ -1085,6 +1085,7 @@ static void thread_common_ops(struct test_spec *test, struct ifobject *ifobject)
>  {
>         u64 umem_sz = ifobject->umem->num_frames * ifobject->umem->frame_size;
>         int mmap_flags = MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE;
> +       LIBBPF_OPTS(bpf_xdp_query_opts, opts);
>         int ret, ifindex;
>         void *bufs;
>         u32 i;
> @@ -1134,6 +1135,22 @@ static void thread_common_ops(struct test_spec *test, struct ifobject *ifobject)
>         if (ret)
>                 exit_with_error(-ret);
>
> +       ret = bpf_xdp_query(ifindex, ifobject->xdp_flags, &opts);
> +       if (ret)
> +               exit_with_error(-ret);
> +
> +       if (ifobject->xdp_flags & XDP_FLAGS_SKB_MODE) {
> +               if (opts.attach_mode != XDP_ATTACHED_SKB) {
> +                       ksft_print_msg("ERROR: [%s] XDP prog not in SKB mode\n");
> +                       exit_with_error(-EINVAL);
> +               }
> +       } else if (ifobject->xdp_flags & XDP_FLAGS_DRV_MODE) {
> +               if (opts.attach_mode != XDP_ATTACHED_DRV) {
> +                       ksft_print_msg("ERROR: [%s] XDP prog not in DRV mode\n");
> +                       exit_with_error(-EINVAL);
> +               }
> +       }
> +
>         ret = xsk_socket__update_xskmap(ifobject->xsk->xsk, ifobject->xsk_map_fd);
>         if (ret)
>                 exit_with_error(-ret);
> --
> 2.27.0
>
