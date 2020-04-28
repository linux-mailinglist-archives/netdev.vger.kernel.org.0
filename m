Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3B871BBA39
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 11:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbgD1Jql (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 05:46:41 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:57313 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726486AbgD1Jql (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 05:46:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588067200;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=64n1j3rWsF4WkqK6IXqvlsGi78U1IQ4tBELo+vHTvKI=;
        b=IwmNNFxY/gYnuqvj5jMZP1gsIu+AW+uviNj3GCXblqLAzIL0VVTKCh7uJRQAgaHQDm0w5K
        CblQjoeVi/wfsUe/DSqVPXbzkjyWnBWgfKSUJstzyKwH3E7rsoKprO/cCZrlElMfkx5izM
        jAzJGSl1F9Ld8g+8DzzWZF+Uwfc64cE=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-213-kE2MASIPNSSZkR9hjw-j5A-1; Tue, 28 Apr 2020 05:46:38 -0400
X-MC-Unique: kE2MASIPNSSZkR9hjw-j5A-1
Received: by mail-lj1-f198.google.com with SMTP id c2so3557071ljj.2
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 02:46:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=64n1j3rWsF4WkqK6IXqvlsGi78U1IQ4tBELo+vHTvKI=;
        b=VHcrWpIJuHl9yTiaODNx4SCvz+Ji1T1/3DjQw38GjQIUIHMMQDnE4f+pU/63WXDI5F
         Vz/sqZLXM55dOomhxXPgrWdQXdtLowCmT+CmqYbvLGve48XxinsiII/mA7DXgVWPL4gI
         Qtjj1AAu+45GGHN5IaQS2AKEjvra3BdDbLrtKmrBnjZgTzyK7kAwoT1F7jn7MYofeGZS
         iQw51IZBYF2pdFs4yPWiSXC5z1iPOodNG6Q8WkdPcq1a3wI/QfJPSXz/SI3b/BnTCa93
         AgSyQaKviVzqEMvbVOU2xbdKUuS2fpcXoB7oye4Xpe8ARFVQ/rQ/HQr1qmTOAqlrTNpw
         lOjQ==
X-Gm-Message-State: AGi0PuaCf0Ur+5VEXZp/zjSt8tKgqc+7+ys7jRjAalWhhO60wG2S0E8B
        DWmwvb994N5M4A+4iWejB6CiUGLSz876LD3zdbE1cbACcbK+Ua2CJTKMT7zgYBI6GYhrA4HnoJt
        doKBLz1hDHCJMq5fJ
X-Received: by 2002:a19:700b:: with SMTP id h11mr18664582lfc.89.1588067196775;
        Tue, 28 Apr 2020 02:46:36 -0700 (PDT)
X-Google-Smtp-Source: APiQypKpJRn7z2yXpp90YVQ5naRTBxefp0E2vM9LtOoBkf9A7Ba7/dqf6TqMTU8uhX/BAmXhXObuAQ==
X-Received: by 2002:a19:700b:: with SMTP id h11mr18664571lfc.89.1588067196480;
        Tue, 28 Apr 2020 02:46:36 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id x24sm13614858lfc.6.2020.04.28.02.46.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2020 02:46:35 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 02D551814FF; Tue, 28 Apr 2020 11:46:34 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH v2 bpf-next 04/10] bpf: add support for BPF_OBJ_GET_INFO_BY_FD for bpf_link
In-Reply-To: <20200428054944.4015462-5-andriin@fb.com>
References: <20200428054944.4015462-1-andriin@fb.com> <20200428054944.4015462-5-andriin@fb.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 28 Apr 2020 11:46:34 +0200
Message-ID: <87mu6wvt6t.fsf@toke.dk>
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
> index 875d1f0af803..701c4387c711 100644
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
> index 7e6541fceade..0eccafae55bb 100644
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
> @@ -3612,6 +3621,25 @@ struct bpf_btf_info {
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

On the RFC I asked whether we could get the attach target here as well.
You said you'd look into it; what happened to that? :)

-Toke

