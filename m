Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AD071B23A9
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 12:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728391AbgDUKU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 06:20:26 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:24993 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725920AbgDUKUX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 06:20:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587464421;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ti96mVPhwVXyba8/PZqHEUwK2yPEqUePdjh3uI6FeEo=;
        b=H7zRiZBxWOhThtk5XtkmE+aAujwE1C5KCZICAWEHoQVSDLyAjjC2W9VVJ/mA9Ljn3CkCU1
        ili/6p/ZvGxwG38HrACZOeKew3eMyXAtHoRppXO+l8WR8LIamqpNghqetFiNmdv/DneYSJ
        nfY8TTuQuIxcNq0K72xuodYx8pBwAdQ=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-216-2OXaY1SCOdCcx4axLDSMWw-1; Tue, 21 Apr 2020 06:20:19 -0400
X-MC-Unique: 2OXaY1SCOdCcx4axLDSMWw-1
Received: by mail-lf1-f72.google.com with SMTP id t194so5600778lff.20
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 03:20:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ti96mVPhwVXyba8/PZqHEUwK2yPEqUePdjh3uI6FeEo=;
        b=RGE/01A5lvjCYjoYxH5gRAmrlT2bdEyS9/0HS6uzRlBjVwDLpKxRnvPYgsJMPRt+mA
         YyanY0fxYZClclvgl9OWcwL8Dd3nOBM0974In3rdipwkEh3mH/0WyiJrATwoBVx0PC57
         bB+UzaBPKL5VB/NeDFNZIU2kOki/20O1wg07PqIh8JuyobtC7lUB/mepnN1g42V0TYfq
         m+LWT4JdgGOnBP3O9DZbfzFCmkFBGsXvUDyDfMaJ8HoVvKcXW4k/EIRE2IHJnoe/kfHB
         j6bwFNlmKyS9IwTG2VCQShUJPdiDCZo/TRhMcC4xMfZiUF85nkbxuZVG8o1DhdQ+btEO
         3C9g==
X-Gm-Message-State: AGi0Puad2i6uVv97E2swBNjRjXs6nLhzxmIlHIgXmXVJlj3vlWgYxa6P
        uZ6HdBaVluiSeI5o2uQz6KyWGhprmHi5E9Fcu/SdoF3kztpaf+1uaddMTHqb6C61LlG1I0aiDfJ
        YwMRwohDzUCvbze4I
X-Received: by 2002:a2e:9c8:: with SMTP id 191mr12411523ljj.259.1587464418214;
        Tue, 21 Apr 2020 03:20:18 -0700 (PDT)
X-Google-Smtp-Source: APiQypLY+CvvRegog2HHY9UkuoTkflu81obKBSXnpgf8L0l+MIrZx++vhcuOAPT0sLHOxm5BSU4dsg==
X-Received: by 2002:a2e:9c8:: with SMTP id 191mr12411486ljj.259.1587464417611;
        Tue, 21 Apr 2020 03:20:17 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id k2sm1569928ljg.7.2020.04.21.03.20.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 03:20:17 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 7077E18157F; Tue, 21 Apr 2020 12:20:16 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, David Ahern <dahern@digitalocean.com>
Subject: Re: [PATCH bpf-next 12/16] libbpf: Add egress XDP support
In-Reply-To: <20200420200055.49033-13-dsahern@kernel.org>
References: <20200420200055.49033-1-dsahern@kernel.org> <20200420200055.49033-13-dsahern@kernel.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 21 Apr 2020 12:20:16 +0200
Message-ID: <87a7359m3j.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@kernel.org> writes:

> From: David Ahern <dahern@digitalocean.com>
>
> Patch adds egress XDP support in libbpf.
>
> New section name hint, xdp_egress, is added to set expected attach
> type at program load. Programs can use xdp_egress as the prefix in
> the SEC statement to load the program with the BPF_XDP_EGRESS
> attach type set.
>
> egress is added to bpf_xdp_set_link_opts to specify egress type for
> use with bpf_set_link_xdp_fd_opts. Update library side to check
> for flag and set nla_type to IFLA_XDP_EGRESS.
>
> Add egress version of bpf_get_link_xdp* info and id apis with core
> code refactored to handle both rx and tx paths.
>
> Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
> Co-developed-by: David Ahern <dahern@digitalocean.com>
> Signed-off-by: David Ahern <dahern@digitalocean.com>
> ---
>  tools/lib/bpf/libbpf.c   |  2 ++
>  tools/lib/bpf/libbpf.h   |  9 +++++-
>  tools/lib/bpf/libbpf.map |  2 ++
>  tools/lib/bpf/netlink.c  | 63 +++++++++++++++++++++++++++++++++++-----
>  4 files changed, 67 insertions(+), 9 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 8f480e29a6b0..32fc970495d9 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -6366,6 +6366,8 @@ static const struct bpf_sec_def section_defs[] = {
>  		.is_attach_btf = true,
>  		.expected_attach_type = BPF_LSM_MAC,
>  		.attach_fn = attach_lsm),
> +	BPF_EAPROG_SEC("xdp_egress",		BPF_PROG_TYPE_XDP,
> +						BPF_XDP_EGRESS),
>  	BPF_PROG_SEC("xdp",			BPF_PROG_TYPE_XDP),
>  	BPF_PROG_SEC("perf_event",		BPF_PROG_TYPE_PERF_EVENT),
>  	BPF_PROG_SEC("lwt_in",			BPF_PROG_TYPE_LWT_IN),
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index f1dacecb1619..3feb1242f78e 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -453,14 +453,16 @@ struct xdp_link_info {
>  	__u32 drv_prog_id;
>  	__u32 hw_prog_id;
>  	__u32 skb_prog_id;
> +	__u32 egress_core_prog_id;
>  	__u8 attach_mode;
>  };
>  
>  struct bpf_xdp_set_link_opts {
>  	size_t sz;
>  	int old_fd;
> +	__u8  egress;
>  };
> -#define bpf_xdp_set_link_opts__last_field old_fd
> +#define bpf_xdp_set_link_opts__last_field egress
>  
>  LIBBPF_API int bpf_set_link_xdp_fd(int ifindex, int fd, __u32 flags);
>  LIBBPF_API int bpf_set_link_xdp_fd_opts(int ifindex, int fd, __u32 flags,
> @@ -468,6 +470,11 @@ LIBBPF_API int bpf_set_link_xdp_fd_opts(int ifindex, int fd, __u32 flags,
>  LIBBPF_API int bpf_get_link_xdp_id(int ifindex, __u32 *prog_id, __u32 flags);
>  LIBBPF_API int bpf_get_link_xdp_info(int ifindex, struct xdp_link_info *info,
>  				     size_t info_size, __u32 flags);
> +LIBBPF_API int bpf_get_link_xdp_egress_id(int ifindex, __u32 *prog_id,
> +					  __u32 flags);
> +LIBBPF_API int bpf_get_link_xdp_egress_info(int ifindex,
> +					    struct xdp_link_info *info,
> +					    size_t info_size, __u32 flags);

Isn't the kernel returning both program types in the same message when
dumping an interface? So do we really need a separate getter instead of
just populating xdp_link_info with the egress ID in the existing getter?

-Toke

