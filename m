Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFF2818F350
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 12:02:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728087AbgCWLCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 07:02:30 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:42550 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727987AbgCWLCa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 07:02:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584961348;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JFWZtCE0geh8vzmxiEFtkBHNKyKQR3wg3fSUobGXe5Y=;
        b=J2iOVdogoVei0930QzosW1QyvFF2a5WtUBiXueEKWhDbu+YEjeUSd6W5beS59PtJowem4C
        pd4+3op3ZS3RwGuWVm0QbDczPmdZwoZhOY0oH0yYasUaO7WoRsE9GS/x0F74HlE0wQmw6e
        LCu6katgDfhMvk3tDN7n26fWLrQvhKI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-405-lbY6DAVKPZK5BqP2cluGMA-1; Mon, 23 Mar 2020 07:02:27 -0400
X-MC-Unique: lbY6DAVKPZK5BqP2cluGMA-1
Received: by mail-wm1-f72.google.com with SMTP id f8so3417205wmh.4
        for <netdev@vger.kernel.org>; Mon, 23 Mar 2020 04:02:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=JFWZtCE0geh8vzmxiEFtkBHNKyKQR3wg3fSUobGXe5Y=;
        b=tels3fhIcvJVoCGAn+k04tURp8451iNFB6xVSoSIgnSzmJR7D01x3nAbhGYxNc7Oaq
         J3gqANEVUF1FedMnWMxCOGN8bYULGnV52BNUzIbvzzt0aXmh1EcZoaaawpVbdmuMH3oD
         Rkz2WNpI4OnqdAhAf8JBcVUC9yVqXBPE/3KVH7/hUwybAdytqP6A7soHnji8uGGP8wjK
         OTzp5pvNXktsF1dglK6uFM48UCYYyyP9HN0KOqgipqoj+OdV2J4M8tbUtlFV/POHgZlJ
         digmm40mLdiaR/kBcWC2/ICIZQtRC8z4IKSaHlMCB9aDWctdcdw6++KTHxdkDu+4kJXv
         pX0Q==
X-Gm-Message-State: ANhLgQ0ltIq70xQqL7U9LlnBBsY8BSnKE3G5Xih+bhaRWJ/I5GKtLrl9
        lNC+iJc+vS2+Lp41u8K4HzlFSZ1sowk6eSmLFjjzKjFETsjoXmNqAdbTfMcU1YPoFbcj6Pzis5Y
        LTYKMeTKUm+4UtsGQ
X-Received: by 2002:adf:f812:: with SMTP id s18mr15379603wrp.380.1584961346111;
        Mon, 23 Mar 2020 04:02:26 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvGv10RSyGqDuwfYfq+OFgJc0cOvbFVxy7ZkdYU5xePikU2fVsNx/7REQJ1RZBuf5BDWKzjzg==
X-Received: by 2002:adf:f812:: with SMTP id s18mr15379565wrp.380.1584961345811;
        Mon, 23 Mar 2020 04:02:25 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id s7sm22412914wri.61.2020.03.23.04.02.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 04:02:25 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 954D2180371; Mon, 23 Mar 2020 12:02:24 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH bpf-next 5/6] libbpf: add support for bpf_link-based cgroup attachment
In-Reply-To: <20200320203615.1519013-6-andriin@fb.com>
References: <20200320203615.1519013-1-andriin@fb.com> <20200320203615.1519013-6-andriin@fb.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 23 Mar 2020 12:02:24 +0100
Message-ID: <87wo7b49mn.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andriin@fb.com> writes:

> Add bpf_program__attach_cgroup(), which uses BPF_LINK_CREATE subcommand to
> create an FD-based kernel bpf_link. Also add low-level bpf_link_create() API.
>
> If expected_attach_type is not specified explicitly with
> bpf_program__set_expected_attach_type(), libbpf will try to determine proper
> attach type from BPF program's section definition.
>
> Also add support for bpf_link's underlying BPF program replacement:
>   - unconditional through high-level bpf_link__update_program() API;
>   - cmpxchg-like with specifying expected current BPF program through
>     low-level bpf_link_update() API.
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  tools/include/uapi/linux/bpf.h | 12 +++++++++
>  tools/lib/bpf/bpf.c            | 34 +++++++++++++++++++++++++
>  tools/lib/bpf/bpf.h            | 19 ++++++++++++++
>  tools/lib/bpf/libbpf.c         | 46 ++++++++++++++++++++++++++++++++++
>  tools/lib/bpf/libbpf.h         |  8 +++++-
>  tools/lib/bpf/libbpf.map       |  4 +++
>  6 files changed, 122 insertions(+), 1 deletion(-)
>
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index fad9f79bb8f1..fa944093f9fc 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -112,6 +112,7 @@ enum bpf_cmd {
>  	BPF_MAP_UPDATE_BATCH,
>  	BPF_MAP_DELETE_BATCH,
>  	BPF_LINK_CREATE,
> +	BPF_LINK_UPDATE,
>  };
>  
>  enum bpf_map_type {
> @@ -574,6 +575,17 @@ union bpf_attr {
>  		__u32		target_fd;	/* object to attach to */
>  		__u32		attach_type;	/* attach type */
>  	} link_create;
> +
> +	struct { /* struct used by BPF_LINK_UPDATE command */
> +		__u32		link_fd;	/* link fd */
> +		/* new program fd to update link with */
> +		__u32		new_prog_fd;
> +		__u32		flags;		/* extra flags */
> +		/* expected link's program fd; is specified only if
> +		 * BPF_F_REPLACE flag is set in flags */
> +		__u32		old_prog_fd;
> +	} link_update;
> +
>  } __attribute__((aligned(8)));
>  
>  /* The description below is an attempt at providing documentation to eBPF
> diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> index c6dafe563176..35c34fc81bd0 100644
> --- a/tools/lib/bpf/bpf.c
> +++ b/tools/lib/bpf/bpf.c
> @@ -584,6 +584,40 @@ int bpf_prog_detach2(int prog_fd, int target_fd, enum bpf_attach_type type)
>  	return sys_bpf(BPF_PROG_DETACH, &attr, sizeof(attr));
>  }
>  
> +int bpf_link_create(int prog_fd, int target_fd,
> +		    enum bpf_attach_type attach_type,
> +		    const struct bpf_link_create_opts *opts)
> +{
> +	union bpf_attr attr;
> +
> +	if (!OPTS_VALID(opts, bpf_link_create_opts))
> +		return -EINVAL;
> +
> +	memset(&attr, 0, sizeof(attr));
> +	attr.link_create.prog_fd = prog_fd;
> +	attr.link_create.target_fd = target_fd;
> +	attr.link_create.attach_type = attach_type;
> +
> +	return sys_bpf(BPF_LINK_CREATE, &attr, sizeof(attr));
> +}
> +
> +int bpf_link_update(int link_fd, int new_prog_fd,
> +		    const struct bpf_link_update_opts *opts)
> +{
> +	union bpf_attr attr;
> +
> +	if (!OPTS_VALID(opts, bpf_link_update_opts))
> +		return -EINVAL;
> +
> +	memset(&attr, 0, sizeof(attr));
> +	attr.link_update.link_fd = link_fd;
> +	attr.link_update.new_prog_fd = new_prog_fd;
> +	attr.link_update.flags = OPTS_GET(opts, flags, 0);
> +	attr.link_update.old_prog_fd = OPTS_GET(opts, old_prog_fd, 0);
> +
> +	return sys_bpf(BPF_LINK_UPDATE, &attr, sizeof(attr));
> +}
> +
>  int bpf_prog_query(int target_fd, enum bpf_attach_type type, __u32 query_flags,
>  		   __u32 *attach_flags, __u32 *prog_ids, __u32 *prog_cnt)
>  {
> diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
> index b976e77316cc..46d47afdd887 100644
> --- a/tools/lib/bpf/bpf.h
> +++ b/tools/lib/bpf/bpf.h
> @@ -168,6 +168,25 @@ LIBBPF_API int bpf_prog_detach(int attachable_fd, enum bpf_attach_type type);
>  LIBBPF_API int bpf_prog_detach2(int prog_fd, int attachable_fd,
>  				enum bpf_attach_type type);
>  
> +struct bpf_link_create_opts {
> +	size_t sz; /* size of this struct for forward/backward compatibility */
> +};
> +#define bpf_link_create_opts__last_field sz
> +
> +LIBBPF_API int bpf_link_create(int prog_fd, int target_fd,
> +			       enum bpf_attach_type attach_type,
> +			       const struct bpf_link_create_opts *opts);
> +
> +struct bpf_link_update_opts {
> +	size_t sz; /* size of this struct for forward/backward compatibility */
> +	__u32 flags;	   /* extra flags */
> +	__u32 old_prog_fd; /* expected old program FD */
> +};
> +#define bpf_link_update_opts__last_field old_prog_fd
> +
> +LIBBPF_API int bpf_link_update(int link_fd, int new_prog_fd,
> +			       const struct bpf_link_update_opts *opts);
> +
>  struct bpf_prog_test_run_attr {
>  	int prog_fd;
>  	int repeat;
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 085e41f9b68e..8b23c70033d3 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -6951,6 +6951,12 @@ struct bpf_link {
>  	bool disconnected;
>  };
>  
> +/* Replace link's underlying BPF program with the new one */
> +int bpf_link__update_program(struct bpf_link *link, struct bpf_program *prog)
> +{
> +	return bpf_link_update(bpf_link__fd(link), bpf_program__fd(prog), NULL);
> +}

I would expect bpf_link to keep track of the previous program and
automatically fill it in with this operation. I.e., it should be
possible to do something like:

link = bpf_link__open("/sys/fs/bpf/my_link");
prog = bpf_link__get_prog(link);
new_prog = enhance_prog(prog);
err = bpf_link__update_program(link, new_prog);

and have atomic replacement "just work". This obviously implies that
bpf_link__open() should use that BPF_LINK_QUERY operation I was
requesting in my comment to the previous patch :)

-Toke

