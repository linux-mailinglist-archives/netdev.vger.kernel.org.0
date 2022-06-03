Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D70853D2FF
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 22:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348765AbiFCU7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 16:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347000AbiFCU7M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 16:59:12 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AE1531DC9;
        Fri,  3 Jun 2022 13:59:11 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id a2so8301810lfg.5;
        Fri, 03 Jun 2022 13:59:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IX+iMCliQnk5qmBtapwSE0VVJPm4P2CWRKK142TwuuI=;
        b=eN1y0OM89VHdmi/uPaz3CRJNkv1PEwRSxCtqtavf3GHv6A3EsBrl6WSSdVeq++yX54
         uCRPx7UxgsIsaERNw3rZhalMvLsiXapql5pflslT78MxFWr7NGQUm/u3IJDXROf9K49x
         O5b4cYOh1Sd8a7xg1g7SGnZfwaLIkMrgMiHfy82fVUZB8zJJheQJHcvSe+Dr6g5E4hc7
         rnMW88w5Q42AF8RBFQwSbHm1hm50dqoL8TWtAiboe73q1z2Bgc7XI1s6gRTNsFBlYyBE
         QFR1A1MRINjA/V0N/NkdWy2mv/nBo1NkrTGu36ONz0czMPzt1bV6Thg5zNpi7e0lOw34
         yyVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IX+iMCliQnk5qmBtapwSE0VVJPm4P2CWRKK142TwuuI=;
        b=sf/DUdxdL2dmRq+6ik+CTZI1xIPwEcec+7058x8md3iOQO/jEpMXC8OvDWDpGtajas
         2OhJFHyFIqXZT70RSfiRZOU4Sz+RdIHLouJLnRXY2JmNunTpJbIzZLV5IV4LUgcTsi5n
         IQsrFvfPYeLtqzeqW6/tI5bGR4WVqNxXmUaylH2mJKm/+PUlyoygwPHNEdWYxpGnhEIs
         nxohjjZhyl97Lv+og8u/kFVs5CCdikbo4YyW9ysl/4kHPJ1R/DsHtKXceLI/yPyKS54w
         1QJOCj+burUB1COfUZVxLGASmwsLWCPChd+IhyhVc8zgKNa4WKXSZuDx7dP1qE3WGycB
         mtBg==
X-Gm-Message-State: AOAM533d9mmBeWEVXyo/UNOD6Je4fkfGBeIxyCf2hTevT+3zoWAIszIb
        06GA9NjVWu1t7QZRN6EBpTq49u5USyuSakrMg5Q=
X-Google-Smtp-Source: ABdhPJwvRr5Ou8TGD6e2RCoj4q/K4rMhXcswsYcGcnDAEWMZJ9XKyYzmCNXPe6F7YPsAqkypVlwDs9C+PIeYjzaNXT0=
X-Received: by 2002:ac2:4e88:0:b0:477:c186:6e83 with SMTP id
 o8-20020ac24e88000000b00477c1866e83mr53530043lfr.663.1654289949710; Fri, 03
 Jun 2022 13:59:09 -0700 (PDT)
MIME-Version: 1.0
References: <20220602143748.673971-1-roberto.sassu@huawei.com> <20220602143748.673971-2-roberto.sassu@huawei.com>
In-Reply-To: <20220602143748.673971-2-roberto.sassu@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 3 Jun 2022 13:58:58 -0700
Message-ID: <CAEf4BzZ0f9K0CMVTD0xtCp0BhM984j3EV_FaDrXGzT6CmWwmcQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/9] libbpf: Introduce bpf_map_get_fd_by_id_flags()
To:     Roberto Sassu <roberto.sassu@huawei.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        KP Singh <kpsingh@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
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

On Thu, Jun 2, 2022 at 7:38 AM Roberto Sassu <roberto.sassu@huawei.com> wrote:
>
> Introduce bpf_map_get_fd_by_id_flags(), to let a caller specify the open
> flags needed for the operation. This could make an operation succeed, if
> access to a map is restricted (i.e. it allows only certain operations).
>
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> ---
>  tools/lib/bpf/bpf.c      | 8 +++++++-
>  tools/lib/bpf/bpf.h      | 1 +
>  tools/lib/bpf/libbpf.map | 1 +
>  3 files changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> index 240186aac8e6..33bac2006043 100644
> --- a/tools/lib/bpf/bpf.c
> +++ b/tools/lib/bpf/bpf.c
> @@ -1047,18 +1047,24 @@ int bpf_prog_get_fd_by_id(__u32 id)
>         return libbpf_err_errno(fd);
>  }
>
> -int bpf_map_get_fd_by_id(__u32 id)
> +int bpf_map_get_fd_by_id_flags(__u32 id, __u32 flags)

let's go the OPTS route instead so that we don't have to add any more
new variants? We can probably use common bpf_get_fd_by_id_opts for
map/prog/link/btf get_fd_by_id operations (and let's add all variants
for consistency)?


>  {
>         union bpf_attr attr;
>         int fd;
>
>         memset(&attr, 0, sizeof(attr));
>         attr.map_id = id;
> +       attr.open_flags = flags;
>
>         fd = sys_bpf_fd(BPF_MAP_GET_FD_BY_ID, &attr, sizeof(attr));
>         return libbpf_err_errno(fd);
>  }
>
> +int bpf_map_get_fd_by_id(__u32 id)
> +{
> +       return bpf_map_get_fd_by_id_flags(id, 0);
> +}
> +
>  int bpf_btf_get_fd_by_id(__u32 id)
>  {
>         union bpf_attr attr;
> diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
> index cabc03703e29..20e4c852362d 100644
> --- a/tools/lib/bpf/bpf.h
> +++ b/tools/lib/bpf/bpf.h
> @@ -438,6 +438,7 @@ LIBBPF_API int bpf_map_get_next_id(__u32 start_id, __u32 *next_id);
>  LIBBPF_API int bpf_btf_get_next_id(__u32 start_id, __u32 *next_id);
>  LIBBPF_API int bpf_link_get_next_id(__u32 start_id, __u32 *next_id);
>  LIBBPF_API int bpf_prog_get_fd_by_id(__u32 id);
> +LIBBPF_API int bpf_map_get_fd_by_id_flags(__u32 id, __u32 flags);
>  LIBBPF_API int bpf_map_get_fd_by_id(__u32 id);
>  LIBBPF_API int bpf_btf_get_fd_by_id(__u32 id);
>  LIBBPF_API int bpf_link_get_fd_by_id(__u32 id);
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index 38e284ff057d..019278e66836 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -466,6 +466,7 @@ LIBBPF_1.0.0 {
>                 libbpf_bpf_link_type_str;
>                 libbpf_bpf_map_type_str;
>                 libbpf_bpf_prog_type_str;
> +               bpf_map_get_fd_by_id_flags;
>
>         local: *;
>  };
> --
> 2.25.1
>
