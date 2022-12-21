Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4CD652A65
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 01:18:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbiLUAS0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 19:18:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiLUASY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 19:18:24 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D318AD85;
        Tue, 20 Dec 2022 16:18:23 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id a1so4866352edf.5;
        Tue, 20 Dec 2022 16:18:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=naZ0oUxMFWyFMkbBQHoBeUSSPqcubeS5ksQDUm2Hg1k=;
        b=ma/Y3lM2RaFmYK4F9I1TdBDSWj3qNGAs4tTdugWoBBWgCb6LjcypbiZHYttKSbP6WQ
         HLENwnvznUQ4czFvDaPNGGc892LvpM+uLpAz/sM1Y3FVaI9N33h+Pmww4jrltpwmsoJq
         gBWpwiaVuXE7E4/NEusH+iY0IDvY/yIcpQ2/dXoNILIzjK0KhpL6mZ7F9czl6zQ4Xeps
         lj26+pTaq7MajKF1/UZctJxqhmMMroOsh1XAhLxwAAc/NQckaq3uoS0deWZHmwrwCfYN
         Bja3hTS/lr3cpQ1xOuezQuZkTgyRH1P7uMNxLBO1I90OKMzWjx+glzFq2bBe//SVBZ5y
         BM3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=naZ0oUxMFWyFMkbBQHoBeUSSPqcubeS5ksQDUm2Hg1k=;
        b=1q1HG1pjaMY8QcuPNSgiGdQYikjjmDdgMCw9/+BMlvH3j2jtsJUm1qzqbJvKPWjCwS
         HMPoYfeeLH5HX42CcGzKqN6Dc2YyIs5qIGQDtqMmB2dZVVJAyT9wq9QYMHuITbInbenZ
         0anSGdpgyIhkU80wakOjvSw+TFywQZi06ygrXvV3yD0Hs8Q5owQ3+/M2eM+xegbVKn20
         lJbtSDDQHYmdZwcF96xIji5ezDdbUa3O4Khme+IM9kOaPuI9buPmKWeyl7WLpjSLTB0F
         futO2j8ex2yiV0I93/q/U+7D0+54NlGPM3XdAUrG+gpFlSJ1OxObbUUDY7a3VazzyDZk
         UvIg==
X-Gm-Message-State: ANoB5pm9ZlqAfFpKPkEtzftBPOuAU2NdVLcHEVYKdehVzvCb7u7nRc6Z
        IZjGGEmtJNh8XUDtDqTR5jq5nilOsy5Cm1wQGyg=
X-Google-Smtp-Source: AA0mqf4hyD7lU1M1NTC1FjEOfFlrHznslaVNRoCVa93P50LoSG8hnoYNDpxM7q6fHr5s63GkykAy7hWMehIMT/kBrVM=
X-Received: by 2002:a50:ed90:0:b0:46a:e6e3:b3cf with SMTP id
 h16-20020a50ed90000000b0046ae6e3b3cfmr52119503edr.333.1671581902316; Tue, 20
 Dec 2022 16:18:22 -0800 (PST)
MIME-Version: 1.0
References: <cover.1671462950.git.lorenzo@kernel.org> <6cce9b15a57345402bb94366434a5ac5609583b8.1671462951.git.lorenzo@kernel.org>
In-Reply-To: <6cce9b15a57345402bb94366434a5ac5609583b8.1671462951.git.lorenzo@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 20 Dec 2022 16:18:10 -0800
Message-ID: <CAEf4BzbOF-S3kjbNVXCZR-K=TGarfi06ZwG1cbNF=HSSodwEfg@mail.gmail.com>
Subject: Re: [RFC bpf-next 6/8] libbpf: add API to get XDP/XSK supported features
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, pabeni@redhat.com,
        edumazet@google.com, toke@redhat.com, memxor@gmail.com,
        alardam@gmail.com, saeedm@nvidia.com, anthony.l.nguyen@intel.com,
        gospo@broadcom.com, vladimir.oltean@nxp.com, nbd@nbd.name,
        john@phrozen.org, leon@kernel.org, simon.horman@corigine.com,
        aelior@marvell.com, christophe.jaillet@wanadoo.fr,
        ecree.xilinx@gmail.com, grygorii.strashko@ti.com, mst@redhat.com,
        bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, intel-wired-lan@lists.osuosl.org,
        lorenzo.bianconi@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 19, 2022 at 7:42 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>
> From: Kumar Kartikeya Dwivedi <memxor@gmail.com>
>
> Add functions to get XDP/XSK supported function of netdev over route
> netlink interface. These functions provide functionalities that are
> going to be used in upcoming change.
>
> The newly added bpf_xdp_query_features takes a fflags_cnt parameter,
> which denotes the number of elements in the output fflags array. This
> must be at least 1 and maybe greater than XDP_FEATURES_WORDS. The
> function only writes to words which is min of fflags_cnt and
> XDP_FEATURES_WORDS.
>
> Co-developed-by: Lorenzo Bianconi <lorenzo@kernel.org>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> Co-developed-by: Marek Majtyka <alardam@gmail.com>
> Signed-off-by: Marek Majtyka <alardam@gmail.com>
> Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> ---
>  tools/lib/bpf/libbpf.h   |  1 +
>  tools/lib/bpf/libbpf.map |  1 +
>  tools/lib/bpf/netlink.c  | 62 ++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 64 insertions(+)
>
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index eee883f007f9..9d102eb5007e 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -967,6 +967,7 @@ LIBBPF_API int bpf_xdp_detach(int ifindex, __u32 flags,
>                               const struct bpf_xdp_attach_opts *opts);
>  LIBBPF_API int bpf_xdp_query(int ifindex, int flags, struct bpf_xdp_query_opts *opts);
>  LIBBPF_API int bpf_xdp_query_id(int ifindex, int flags, __u32 *prog_id);
> +LIBBPF_API int bpf_xdp_query_features(int ifindex, __u32 *fflags, __u32 *fflags_cnt);

no need to add new API, just extend bpf_xdp_query()?

>
>  /* TC related API */
>  enum bpf_tc_attach_point {
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index 71bf5691a689..9c2abb58fa4b 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -362,6 +362,7 @@ LIBBPF_1.0.0 {
>                 bpf_program__set_autoattach;
>                 btf__add_enum64;
>                 btf__add_enum64_value;
> +               bpf_xdp_query_features;
>                 libbpf_bpf_attach_type_str;
>                 libbpf_bpf_link_type_str;
>                 libbpf_bpf_map_type_str;

[...]
