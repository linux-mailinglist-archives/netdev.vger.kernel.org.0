Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FF22570057
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 13:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231313AbiGKLZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 07:25:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbiGKLZJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 07:25:09 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74D1F77A43;
        Mon, 11 Jul 2022 03:56:33 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id t3so5492699edd.0;
        Mon, 11 Jul 2022 03:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iMqIn8DONeCRuyNwWf4Kg7ANcVQQQZs13SNcKa6q92Q=;
        b=oA3VrB2ys9UGrJKpk+qnmiCqv+TF3R18mgz4TYXGJOnv7yAPx6Z/M1M5cBFqlCus4E
         PcytroyDjHNx7q/vmZQVdxzPh0WkTX1oPD29sFqY0sTy1yfK4J1vg6WJN6F2LepJwh9D
         ugA1N1KAjvNQ6O/RFTqpXUxG//wz6SnssCWz2NHAieWug0IRJ6cERMZlTXwW3cY4DiN7
         5pkxox6hEYodHlw6vl/YrD2rRcBB9ZFi42gIlM85OYRKWZUNkGJp6d+jNsryi3irilX/
         alEBFdapzJh4vHuxCk+oZDMgc44DMKzBfl54ZC8U78eCs6lq+EZDBx4c0BXbI8h8n6Rb
         Q0VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iMqIn8DONeCRuyNwWf4Kg7ANcVQQQZs13SNcKa6q92Q=;
        b=dSg1MYkvoU6fn8UOVmQBV633slmABDEeuTNN4wKOmL9hMIJPHzyMMU+OWZE7L2NN2+
         /Koz6IfxF8cUAassUh4YvvEVqpGKE0Jwm+69fs+sCi36yBNT4sJxqATnLv2ChksIXOZQ
         y5ORDWo9K1rhiD2x58nGfr5D0vee9hnEdsEWXJE/NZ4/qPnarQLlcS8v7Vz0jGJ9YPiR
         bK7jM09ILWSUzQhJPQZgTZp04XknjU+vyGyv9n4PwmGOULPqgxNWDlz5y93pEVTvZHmK
         8VuDwqP+oOcsJaKY3F+sLFp+oOq2iyHK4DIkrlMOVE/ocVx/X2vGncdxN1f1gTyncbTq
         hF2Q==
X-Gm-Message-State: AJIora/7eb2zDfmFzK0nO/lleq1VThSISqZKArhmVM2j/w8NmBbgF0bK
        elfIcBofTmsxugjhQK5hSYI=
X-Google-Smtp-Source: AGRyM1uSOA9xkrmk1S6YtinowVu2TsbwF7PZcBpaUAg91vvDXWNh5+Q66LYOALd6hCTn+AZ9tgycVA==
X-Received: by 2002:a05:6402:510c:b0:43a:e041:a371 with SMTP id m12-20020a056402510c00b0043ae041a371mr1570379edd.424.1657536991960;
        Mon, 11 Jul 2022 03:56:31 -0700 (PDT)
Received: from krava ([151.14.22.253])
        by smtp.gmail.com with ESMTPSA id fn15-20020a1709069d0f00b006fecf74395bsm2565875ejc.8.2022.07.11.03.56.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jul 2022 03:56:31 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Mon, 11 Jul 2022 12:56:28 +0200
To:     Artem Savkov <asavkov@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [RFC PATCH bpf-next 2/4] bpf: add BPF_F_DESTRUCTIVE flag for
 BPF_PROG_LOAD
Message-ID: <YswB3CebEK0ltAwt@krava>
References: <20220711083220.2175036-1-asavkov@redhat.com>
 <20220711083220.2175036-3-asavkov@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220711083220.2175036-3-asavkov@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 11, 2022 at 10:32:18AM +0200, Artem Savkov wrote:
> Add a BPF_F_DESTRUCTIVE will be required to be supplied to
> BPF_PROG_LOAD for programs to utilize destructive helpers such as
> bpf_panic().

I'd think that having kernel.destructive_bpf_enabled sysctl knob enabled
would be enough to enable that helper from any program, not sure having
extra load flag adds more security

jirka

> 
> Signed-off-by: Artem Savkov <asavkov@redhat.com>
> ---
>  include/linux/bpf.h            | 1 +
>  include/uapi/linux/bpf.h       | 6 ++++++
>  kernel/bpf/syscall.c           | 4 +++-
>  tools/include/uapi/linux/bpf.h | 6 ++++++
>  4 files changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 77972724bed7..43c008e3587a 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1041,6 +1041,7 @@ struct bpf_prog_aux {
>  	bool sleepable;
>  	bool tail_call_reachable;
>  	bool xdp_has_frags;
> +	bool destructive;
>  	bool use_bpf_prog_pack;
>  	/* BTF_KIND_FUNC_PROTO for valid attach_btf_id */
>  	const struct btf_type *attach_func_proto;
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index e81362891596..4423874b5da4 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -1121,6 +1121,12 @@ enum bpf_link_type {
>   */
>  #define BPF_F_XDP_HAS_FRAGS	(1U << 5)
>  
> +/* If BPF_F_DESTRUCTIVE is used in BPF_PROG_LOAD command, the loaded program
> + * will be able to perform destructive operations such as calling bpf_panic()
> + * helper.
> + */
> +#define BPF_F_DESTRUCTIVE	(1U << 6)
> +
>  /* link_create.kprobe_multi.flags used in LINK_CREATE command for
>   * BPF_TRACE_KPROBE_MULTI attach type to create return probe.
>   */
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 1ce6541d90e1..779feac2dc7d 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -2449,7 +2449,8 @@ static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
>  				 BPF_F_TEST_STATE_FREQ |
>  				 BPF_F_SLEEPABLE |
>  				 BPF_F_TEST_RND_HI32 |
> -				 BPF_F_XDP_HAS_FRAGS))
> +				 BPF_F_XDP_HAS_FRAGS |
> +				 BPF_F_DESTRUCTIVE))
>  		return -EINVAL;
>  
>  	if (!IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS) &&
> @@ -2536,6 +2537,7 @@ static int bpf_prog_load(union bpf_attr *attr, bpfptr_t uattr)
>  	prog->aux->offload_requested = !!attr->prog_ifindex;
>  	prog->aux->sleepable = attr->prog_flags & BPF_F_SLEEPABLE;
>  	prog->aux->xdp_has_frags = attr->prog_flags & BPF_F_XDP_HAS_FRAGS;
> +	prog->aux->destructive = attr->prog_flags & BPF_F_DESTRUCTIVE;
>  
>  	err = security_bpf_prog_alloc(prog->aux);
>  	if (err)
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index e81362891596..4423874b5da4 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -1121,6 +1121,12 @@ enum bpf_link_type {
>   */
>  #define BPF_F_XDP_HAS_FRAGS	(1U << 5)
>  
> +/* If BPF_F_DESTRUCTIVE is used in BPF_PROG_LOAD command, the loaded program
> + * will be able to perform destructive operations such as calling bpf_panic()
> + * helper.
> + */
> +#define BPF_F_DESTRUCTIVE	(1U << 6)
> +
>  /* link_create.kprobe_multi.flags used in LINK_CREATE command for
>   * BPF_TRACE_KPROBE_MULTI attach type to create return probe.
>   */
> -- 
> 2.35.3
> 
