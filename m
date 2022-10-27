Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25AF961025A
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 22:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236736AbiJ0UFy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 16:05:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235578AbiJ0UFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 16:05:52 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3297495EC;
        Thu, 27 Oct 2022 13:05:50 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id bj12so7726561ejb.13;
        Thu, 27 Oct 2022 13:05:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/YD2QYJpySAIoPiLoDb5zCS/pnGBeAeTfq4t8+VFNY4=;
        b=CX/54vzaQ2uX5sLKJoCdzNh13Ky9s+epPtojrrcphlkJZ3VU1xNbZL8Up1Xk4+NzCs
         APn5kPCCOTwLJ/VDvvKt0bl8Ku7HCQOS4j/K/kWq0V/xDZ6hOzWMUnVWSn1QuzUX1uIW
         nZ3nTHseZRbxPOaAtIw5sdHLOeCUBGb5VVqZAmcj8zA0Tszz8XPTvT2BhEpOnqs16k+s
         QXgGs0wEK+47a8rl98sE1p9ZMglOnwp2bKhB2zpYYlR9BL9hK8YofwU6ab+bds0m+M3t
         oGGCYS0KICAabexHzICBGKyWCJ7g39QcNiPcu8GhJvezdn0tJJ95ldmZAJD3KsfxE+90
         R5AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/YD2QYJpySAIoPiLoDb5zCS/pnGBeAeTfq4t8+VFNY4=;
        b=QOLuCY4JR4P1Koi3GJ2Yx+RriN21YbnZly++ZKn8X3HCrnBnWLfO8N5zKlMhtfaPpt
         f7sATs7m4hL8wMu4acKPeR/iBw7XrZt5JH81SapKenYQqwLdw7LtF2eAQhb/f+HgzOIo
         zyRLwS/kz3i0DMkk1gVqW0IBG96A70sXamw6QAqsWMj9IID1fFHni+ZQoIt5T4n9XX72
         VO9X57GLt5f8Pg6orX6BozNagwZhXAeeQHHb6uG3G+Q7j6vcpvSH3cGjHGofkz0m6I76
         If+8OgmZCWDLxqo+9I6efVqPNj0GD/fs03J2CrpIysVapxbyADFCOXybccrLHdyMgT05
         V+DA==
X-Gm-Message-State: ACrzQf1pfGyiZYO0yhx4U4yX42ogVHJeN0imajZv+zeD9lELuhgZi7IS
        vgnbCShWGMGCqvyYW3Kr/SCmalHwZjNGgBTawgs=
X-Google-Smtp-Source: AMsMyM6LqaomoQM1pYg81YdxKGY3vyTHwx1Ou1Ga7ygkvHfJg8B1QShrldJhL877qNSyWkHFTRmHzexD+GzuIU5kIdE=
X-Received: by 2002:a17:906:99c5:b0:73d:70c5:1a4f with SMTP id
 s5-20020a17090699c500b0073d70c51a4fmr42209764ejn.302.1666901149421; Thu, 27
 Oct 2022 13:05:49 -0700 (PDT)
MIME-Version: 1.0
References: <20221027200019.4106375-1-sdf@google.com> <20221027200019.4106375-4-sdf@google.com>
In-Reply-To: <20221027200019.4106375-4-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 27 Oct 2022 13:05:36 -0700
Message-ID: <CAEf4BzbgjOaxVFAfnrRyPP0_1Rh-gC3er4tKLkfr=OPb_x-ueA@mail.gmail.com>
Subject: Re: [RFC bpf-next 3/5] libbpf: Pass prog_ifindex via bpf_object_open_opts
To:     Stanislav Fomichev <sdf@google.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        haoluo@google.com, jolsa@kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
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

On Thu, Oct 27, 2022 at 1:00 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> Allow passing prog_ifindex to BPF_PROG_LOAD. This patch is
> not XDP metadata specific but it's here because we (ab)use
> prog_ifindex as "target metadata" device during loading.
> We can figure out proper UAPI story if we decide to go forward
> with the kfunc approach.
>
> Cc: Martin KaFai Lau <martin.lau@linux.dev>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Willem de Bruijn <willemb@google.com>
> Cc: Jesper Dangaard Brouer <brouer@redhat.com>
> Cc: Anatoly Burakov <anatoly.burakov@intel.com>
> Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
> Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
> Cc: Maryam Tahhan <mtahhan@redhat.com>
> Cc: xdp-hints@xdp-project.net
> Cc: netdev@vger.kernel.org
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  tools/lib/bpf/libbpf.c | 1 +
>  tools/lib/bpf/libbpf.h | 6 +++++-
>  2 files changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 5d7819edf074..61bc37006fe4 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -7190,6 +7190,7 @@ static int bpf_object_init_progs(struct bpf_object *obj, const struct bpf_object
>
>                 prog->type = prog->sec_def->prog_type;
>                 prog->expected_attach_type = prog->sec_def->expected_attach_type;
> +               prog->prog_ifindex = opts->prog_ifindex;
>
>                 /* sec_def can have custom callback which should be called
>                  * after bpf_program is initialized to adjust its properties
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index eee883f007f9..4a40b7623099 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -170,9 +170,13 @@ struct bpf_object_open_opts {
>          */
>         __u32 kernel_log_level;
>
> +       /* Optional ifindex of netdev for offload purposes.
> +        */
> +       int prog_ifindex;
> +

nope, don't do that, open_opts are for entire object, while this is
per-program thing

So bpf_program__set_ifindex() setter would be more appropriate


>         size_t :0;
>  };
> -#define bpf_object_open_opts__last_field kernel_log_level
> +#define bpf_object_open_opts__last_field prog_ifindex
>
>  LIBBPF_API struct bpf_object *bpf_object__open(const char *path);
>
> --
> 2.38.1.273.g43a17bfeac-goog
>
