Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92E1919F4AA
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 13:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727387AbgDFLeo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 07:34:44 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:27711 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727356AbgDFLen (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 07:34:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586172882;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=clYO5lZnP0UyHoFp9zmJLM0Hru8EVd9gDmU8smyRsp4=;
        b=QOTbxdQtOcxe+S4fWX64SGVz/1/B/Zd1Fa2mDjmLgE80SvEZPMwSJtL4GHJNckQbnTxFot
        4jVcRCrE2kxMUOO1DYFUCCokaWzuF5mXZsvbx7+C8bbfPklrTDiRdNLF65yHhq7mI3IpQi
        7KLtfEuJG67sLK5Hs9gX+yspTuHRaMc=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-279-0R-yhUmzNtWrn5SlZHYwDQ-1; Mon, 06 Apr 2020 07:34:40 -0400
X-MC-Unique: 0R-yhUmzNtWrn5SlZHYwDQ-1
Received: by mail-lf1-f69.google.com with SMTP id b24so5123319lff.12
        for <netdev@vger.kernel.org>; Mon, 06 Apr 2020 04:34:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=clYO5lZnP0UyHoFp9zmJLM0Hru8EVd9gDmU8smyRsp4=;
        b=dPx5fH7pS1Sea/m4It7iyZIFj8qTqn4A42LZfud49HfQA2XYIRtZGDiKEI0gXZ7tjh
         /1VVArCFE/jcedRO2XV0OMp7i959ZgkjtJCzJPpTeiDe99Jps8Uq8XRO1Tk4aBaZB+dx
         wdMaXTtyQ2/9ZcHoTowLXZ9+Q8+l9CXUXu8A6Vro6rfxgagNqdg/Mm6Wpu/7vlwW3V9L
         jzqSs/cqqKH3sczpe9lWZgCPL+qIyqdUEzLk24cyDoqwtrgJDVE36P2yB5wRr/DLBvI/
         88muzquwtjAzgCeEbZuPs5yr9QynPv4IPdOyPrIz5KgbN6ryX52NhK1sqBZ6Lg0r3D9K
         Xugg==
X-Gm-Message-State: AGi0PuYL3/PsYOm5Rx0S9nGf7r2FX0sHBmFkZoNWQpdCgmtyeHSCBZaj
        /739adeEU3vFKVoFB1FcGGGYZrAg42LrFV1AGRW/dYYe43jdmA72R+/ogGv6tHqNYB2rmuTYd+X
        vpuwNok5W+se1q1IY
X-Received: by 2002:a2e:9798:: with SMTP id y24mr12331787lji.267.1586172879109;
        Mon, 06 Apr 2020 04:34:39 -0700 (PDT)
X-Google-Smtp-Source: APiQypJbK5FN2HRT+nh/53N44WDU7KpdCCQBMSszqhIE4c/D/AMdiir9UaM2udhBBLkAzbWKmBotRA==
X-Received: by 2002:a2e:9798:: with SMTP id y24mr12331774lji.267.1586172878901;
        Mon, 06 Apr 2020 04:34:38 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id x28sm11405892lfq.46.2020.04.06.04.34.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2020 04:34:38 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 653ED1804E7; Mon,  6 Apr 2020 13:34:35 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [RFC PATCH bpf-next 5/8] bpf: add support for BPF_OBJ_GET_INFO_BY_FD for bpf_link
In-Reply-To: <20200404000948.3980903-6-andriin@fb.com>
References: <20200404000948.3980903-1-andriin@fb.com> <20200404000948.3980903-6-andriin@fb.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 06 Apr 2020 13:34:35 +0200
Message-ID: <87o8s4c0fo.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andriin@fb.com> writes:

> Add ability to fetch bpf_link details through BPF_OBJ_GET_INFO_BY_FD command.
> Also enhance show_fdinfo to potentially include bpf_link type-specific
> information (similarly to obj_info).
>
> Also introduce enum bpf_link_type stored in bpf_link itself and expose it in
> UAPI. bpf_link_tracing also now will store and return bpf_attach_type.
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  include/linux/bpf-cgroup.h     |   2 -
>  include/linux/bpf.h            |  10 +-
>  include/linux/bpf_types.h      |   6 ++
>  include/uapi/linux/bpf.h       |  28 ++++++
>  kernel/bpf/btf.c               |   2 +
>  kernel/bpf/cgroup.c            |  45 ++++++++-
>  kernel/bpf/syscall.c           | 164 +++++++++++++++++++++++++++++----
>  kernel/bpf/verifier.c          |   2 +
>  tools/include/uapi/linux/bpf.h |  31 +++++++
>  9 files changed, 266 insertions(+), 24 deletions(-)
>
> diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
> index d2d969669564..ab95824a1d99 100644
> --- a/include/linux/bpf-cgroup.h
> +++ b/include/linux/bpf-cgroup.h
> @@ -57,8 +57,6 @@ struct bpf_cgroup_link {
>  	enum bpf_attach_type type;
>  };
>  
> -extern const struct bpf_link_ops bpf_cgroup_link_lops;
> -
>  struct bpf_prog_list {
>  	struct list_head node;
>  	struct bpf_prog *prog;
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index 67ce74890911..8cf182d256d4 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -1026,9 +1026,11 @@ extern const struct file_operations bpf_prog_fops;
>  	extern const struct bpf_verifier_ops _name ## _verifier_ops;
>  #define BPF_MAP_TYPE(_id, _ops) \
>  	extern const struct bpf_map_ops _ops;
> +#define BPF_LINK_TYPE(_id, _name)
>  #include <linux/bpf_types.h>
>  #undef BPF_PROG_TYPE
>  #undef BPF_MAP_TYPE
> +#undef BPF_LINK_TYPE
>  
>  extern const struct bpf_prog_ops bpf_offload_prog_ops;
>  extern const struct bpf_verifier_ops tc_cls_act_analyzer_ops;
> @@ -1086,6 +1088,7 @@ int bpf_prog_new_fd(struct bpf_prog *prog);
>  struct bpf_link {
>  	atomic64_t refcnt;
>  	u32 id;
> +	enum bpf_link_type type;
>  	const struct bpf_link_ops *ops;
>  	struct bpf_prog *prog;
>  	struct work_struct work;
> @@ -1103,9 +1106,14 @@ struct bpf_link_ops {
>  	void (*dealloc)(struct bpf_link *link);
>  	int (*update_prog)(struct bpf_link *link, struct bpf_prog *new_prog,
>  			   struct bpf_prog *old_prog);
> +	void (*show_fdinfo)(const struct bpf_link *link, struct seq_file *seq);
> +	int (*fill_link_info)(const struct bpf_link *link,
> +			      struct bpf_link_info *info,
> +			      const struct bpf_link_info *uinfo,
> +			      u32 info_len);
>  };
>  
> -void bpf_link_init(struct bpf_link *link,
> +void bpf_link_init(struct bpf_link *link, enum bpf_link_type type,
>  		   const struct bpf_link_ops *ops, struct bpf_prog *prog);
>  int bpf_link_prime(struct bpf_link *link, struct bpf_link_primer *primer);
>  int bpf_link_settle(struct bpf_link_primer *primer);
> diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
> index ba0c2d56f8a3..8345cdf553b8 100644
> --- a/include/linux/bpf_types.h
> +++ b/include/linux/bpf_types.h
> @@ -118,3 +118,9 @@ BPF_MAP_TYPE(BPF_MAP_TYPE_STACK, stack_map_ops)
>  #if defined(CONFIG_BPF_JIT)
>  BPF_MAP_TYPE(BPF_MAP_TYPE_STRUCT_OPS, bpf_struct_ops_map_ops)
>  #endif
> +
> +BPF_LINK_TYPE(BPF_LINK_TYPE_RAW_TRACEPOINT, raw_tracepoint)
> +BPF_LINK_TYPE(BPF_LINK_TYPE_TRACING, tracing)
> +#ifdef CONFIG_CGROUP_BPF
> +BPF_LINK_TYPE(BPF_LINK_TYPE_CGROUP, cgroup)
> +#endif
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 407c086bc9e4..d2f269082a33 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -222,6 +222,15 @@ enum bpf_attach_type {
>  
>  #define MAX_BPF_ATTACH_TYPE __MAX_BPF_ATTACH_TYPE
>  
> +enum bpf_link_type {
> +	BPF_LINK_TYPE_UNSPEC = 0,
> +	BPF_LINK_TYPE_RAW_TRACEPOINT = 1,
> +	BPF_LINK_TYPE_TRACING = 2,
> +	BPF_LINK_TYPE_CGROUP = 3,
> +
> +	MAX_BPF_LINK_TYPE,
> +};
> +
>  /* cgroup-bpf attach flags used in BPF_PROG_ATTACH command
>   *
>   * NONE(default): No further bpf programs allowed in the subtree.
> @@ -3601,6 +3610,25 @@ struct bpf_btf_info {
>  	__u32 id;
>  } __attribute__((aligned(8)));
>  
> +struct bpf_link_info {
> +	__u32 type;
> +	__u32 id;
> +	__u32 prog_id;
> +	union {
> +		struct {
> +			__aligned_u64 tp_name; /* in/out: tp_name buffer ptr */
> +			__u32 tp_name_len;     /* in/out: tp_name buffer len */
> +		} raw_tracepoint;
> +		struct {
> +			__u32 attach_type;
> +		} tracing;

Shouldn't this also include the attach target?

-Toke

