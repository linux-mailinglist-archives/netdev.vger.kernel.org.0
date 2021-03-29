Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5426034CE79
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 13:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231700AbhC2LGM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 07:06:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34736 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231695AbhC2LFu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 07:05:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617015949;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cIK6Uy/IpJMWTnmvxCyOF3ik68NwjXvdHg2BspOlc/o=;
        b=G1yIfKmHhT6Rl1naboLGtrypqDsJEUdmq35jcIx7IbGjM1FfBIfZfV2SoccX1AtJdr7HGK
        KMRwwFdhvA5bnZF1spY+LNTTap4UUp3tM7OxHNA7XYcC5H9VD9KhvK98XVAXn+DTjXIuqn
        BOnHw3FSKjBDaPieXS89Nw+lYJX+ikQ=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-288-OFqGBoxoMAa_P3yeQe4hBA-1; Mon, 29 Mar 2021 07:05:47 -0400
X-MC-Unique: OFqGBoxoMAa_P3yeQe4hBA-1
Received: by mail-ej1-f72.google.com with SMTP id p11so2212382eju.2
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 04:05:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=cIK6Uy/IpJMWTnmvxCyOF3ik68NwjXvdHg2BspOlc/o=;
        b=UaYQiah5aOSrWmzhoE+n02lz3W+lXpNACpsiPeFwIR8msZjymq9WnauGxuXYpsDqqk
         47ktiSlg4ODUsUjA9Kv/BR6b7+1noF17q06VN+iPjucHO0Z2m6GQP+YXC1Ak4DJ0NIYZ
         V0QaaYZXNhKmUAuyd5+3gjAvSlTcAyYGSYAExwKP/5iJmNO2HPOydaEtsScfQcmXOmVs
         bjfXnk3zp7kVcEU+A9ZUujshsPYgwuJJ3ZR6GIZGAuvuYh9IqBVMVIbMsYrf06GSFPUD
         1t5tSzFv9xWKZzvELZ3LSa3/YfM6RZaxaX5GbR3i4cB/aVLZc6VQqWAfJGvJUBVGbk0I
         IuAg==
X-Gm-Message-State: AOAM5335xhEr+hxgfK4Fxe0yvQbhZN/5mnjMv6Nu4oF0DQRdh1WsXqOt
        L3XEYTofXGRztyXMAFcPYJ4LPpntwUfNbB+z1FwvJ2HAPPLU8pdCWgQrYLqQ2Ez3HqB3asIneng
        qazLupDfkD2MIrlkR
X-Received: by 2002:a50:e607:: with SMTP id y7mr28324445edm.18.1617015946309;
        Mon, 29 Mar 2021 04:05:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxXGdO++fM5m5eP02946W1eVrae8OJgLqwG4ixlxcqZsxEQKFSYqUqdijC0LGb5mF/3/oz6FQ==
X-Received: by 2002:a50:e607:: with SMTP id y7mr28324407edm.18.1617015945891;
        Mon, 29 Mar 2021 04:05:45 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id r25sm8853652edv.78.2021.03.29.04.05.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 04:05:45 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 6DB2E180293; Mon, 29 Mar 2021 13:05:44 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org, andrii@kernel.org
Cc:     bjorn.topel@intel.com, magnus.karlsson@intel.com,
        ciara.loftus@intel.com, john.fastabend@gmail.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: Re: [PATCH v4 bpf-next 06/17] libbpf: xsk: use bpf_link
In-Reply-To: <20210326230938.49998-7-maciej.fijalkowski@intel.com>
References: <20210326230938.49998-1-maciej.fijalkowski@intel.com>
 <20210326230938.49998-7-maciej.fijalkowski@intel.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 29 Mar 2021 13:05:44 +0200
Message-ID: <87o8f2te2f.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maciej Fijalkowski <maciej.fijalkowski@intel.com> writes:

> Currently, if there are multiple xdpsock instances running on a single
> interface and in case one of the instances is terminated, the rest of
> them are left in an inoperable state due to the fact of unloaded XDP
> prog from interface.
>
> Consider the scenario below:
>
> // load xdp prog and xskmap and add entry to xskmap at idx 10
> $ sudo ./xdpsock -i ens801f0 -t -q 10
>
> // add entry to xskmap at idx 11
> $ sudo ./xdpsock -i ens801f0 -t -q 11
>
> terminate one of the processes and another one is unable to work due to
> the fact that the XDP prog was unloaded from interface.
>
> To address that, step away from setting bpf prog in favour of bpf_link.
> This means that refcounting of BPF resources will be done automatically
> by bpf_link itself.
>
> Provide backward compatibility by checking if underlying system is
> bpf_link capable. Do this by looking up/creating bpf_link on loopback
> device. If it failed in any way, stick with netlink-based XDP prog.
> therwise, use bpf_link-based logic.
>
> When setting up BPF resources during xsk socket creation, check whether
> bpf_link for a given ifindex already exists via set of calls to
> bpf_link_get_next_id -> bpf_link_get_fd_by_id -> bpf_obj_get_info_by_fd
> and comparing the ifindexes from bpf_link and xsk socket.
>
> For case where resources exist but they are not AF_XDP related, bail out
> and ask user to remove existing prog and then retry.
>
> Lastly, do a bit of refactoring within __xsk_setup_xdp_prog and pull out
> existing code branches based on prog_id value onto separate functions
> that are responsible for resource initialization if prog_id was 0 and
> for lookup existing resources for non-zero prog_id as that implies that
> XDP program is present on the underlying net device. This in turn makes
> it easier to follow, especially the teardown part of both branches.
>
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

The logic is much improved in this version! A few smallish issues below:

> ---
>  tools/lib/bpf/xsk.c | 259 ++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 214 insertions(+), 45 deletions(-)
>
> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> index 526fc35c0b23..c75067f0035f 100644
> --- a/tools/lib/bpf/xsk.c
> +++ b/tools/lib/bpf/xsk.c
> @@ -28,6 +28,7 @@
>  #include <sys/mman.h>
>  #include <sys/socket.h>
>  #include <sys/types.h>
> +#include <linux/if_link.h>
>  
>  #include "bpf.h"
>  #include "libbpf.h"
> @@ -70,8 +71,10 @@ struct xsk_ctx {
>  	int ifindex;
>  	struct list_head list;
>  	int prog_fd;
> +	int link_fd;
>  	int xsks_map_fd;
>  	char ifname[IFNAMSIZ];
> +	bool has_bpf_link;
>  };
>  
>  struct xsk_socket {
> @@ -409,7 +412,7 @@ static int xsk_load_xdp_prog(struct xsk_socket *xsk)
>  	static const int log_buf_size = 16 * 1024;
>  	struct xsk_ctx *ctx = xsk->ctx;
>  	char log_buf[log_buf_size];
> -	int err, prog_fd;
> +	int prog_fd;
>  
>  	/* This is the fallback C-program:
>  	 * SEC("xdp_sock") int xdp_sock_prog(struct xdp_md *ctx)
> @@ -499,14 +502,43 @@ static int xsk_load_xdp_prog(struct xsk_socket *xsk)
>  		return prog_fd;
>  	}
>  
> -	err = bpf_set_link_xdp_fd(xsk->ctx->ifindex, prog_fd,
> -				  xsk->config.xdp_flags);
> +	ctx->prog_fd = prog_fd;
> +	return 0;
> +}
> +
> +static int xsk_create_bpf_link(struct xsk_socket *xsk)
> +{
> +	/* bpf_link only accepts XDP_FLAGS_MODES, but xsk->config.xdp_flags
> +	 * might have set XDP_FLAGS_UPDATE_IF_NOEXIST
> +	 */
> +	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts,
> +			    .flags = (xsk->config.xdp_flags & XDP_FLAGS_MODES));

This will silently suppress any new flags as well; that's not a good
idea. Rather mask out the particular flag (UPDATE_IF_NOEXIST) and pass
everything else through so the kernel can reject invalid ones.

> +	struct xsk_ctx *ctx = xsk->ctx;
> +	__u32 prog_id = 0;
> +	int link_fd;
> +	int err;
> +
> +	err = bpf_get_link_xdp_id(ctx->ifindex, &prog_id, xsk->config.xdp_flags);
>  	if (err) {
> -		close(prog_fd);
> +		pr_warn("getting XDP prog id failed\n");
>  		return err;
>  	}
>  
> -	ctx->prog_fd = prog_fd;
> +	/* if there's a netlink-based XDP prog loaded on interface, bail out
> +	 * and ask user to do the removal by himself
> +	 */
> +	if (prog_id) {
> +		pr_warn("Netlink-based XDP prog detected, please unload it in order to launch AF_XDP prog\n");
> +		return -EINVAL;
> +	}
> +
> +	link_fd = bpf_link_create(ctx->prog_fd, ctx->ifindex, BPF_XDP, &opts);
> +	if (link_fd < 0) {
> +		pr_warn("bpf_link_create failed: %s\n", strerror(errno));
> +		return link_fd;
> +	}
> +
> +	ctx->link_fd = link_fd;
>  	return 0;
>  }
>  
> @@ -625,7 +657,6 @@ static int xsk_lookup_bpf_maps(struct xsk_socket *xsk)
>  		close(fd);
>  	}
>  
> -	err = 0;
>  	if (ctx->xsks_map_fd == -1)
>  		err = -ENOENT;
>  
> @@ -642,6 +673,97 @@ static int xsk_set_bpf_maps(struct xsk_socket *xsk)
>  				   &xsk->fd, 0);
>  }
>  
> +static int xsk_link_lookup(int ifindex, __u32 *prog_id, int *link_fd)
> +{
> +	struct bpf_link_info link_info;
> +	__u32 link_len;
> +	__u32 id = 0;
> +	int err;
> +	int fd;
> +
> +	while (true) {
> +		err = bpf_link_get_next_id(id, &id);
> +		if (err) {
> +			if (errno == ENOENT) {
> +				err = 0;
> +				break;
> +			}
> +			pr_warn("can't get next link: %s\n", strerror(errno));
> +			break;
> +		}
> +
> +		fd = bpf_link_get_fd_by_id(id);
> +		if (fd < 0) {
> +			if (errno == ENOENT)
> +				continue;
> +			pr_warn("can't get link by id (%u): %s\n", id, strerror(errno));
> +			err = -errno;
> +			break;
> +		}
> +
> +		link_len = sizeof(struct bpf_link_info);
> +		memset(&link_info, 0, link_len);
> +		err = bpf_obj_get_info_by_fd(fd, &link_info, &link_len);
> +		if (err) {
> +			pr_warn("can't get link info: %s\n", strerror(errno));
> +			close(fd);
> +			break;
> +		}
> +		if (link_info.type == BPF_LINK_TYPE_XDP) {
> +			if (link_info.xdp.ifindex == ifindex) {
> +				*link_fd = fd;
> +				if (prog_id)
> +					*prog_id = link_info.prog_id;
> +				break;
> +			}
> +		}
> +		close(fd);
> +	}
> +
> +	return err;
> +}
> +
> +static bool xsk_probe_bpf_link(void)
> +{
> +	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts,
> +			    .flags = XDP_FLAGS_SKB_MODE);
> +	struct bpf_load_program_attr prog_attr;
> +	struct bpf_insn insns[2] = {
> +		BPF_MOV64_IMM(BPF_REG_0, XDP_PASS),
> +		BPF_EXIT_INSN()
> +	};
> +	int prog_fd, link_fd = -1;
> +	int ifindex_lo = 1;
> +	bool ret = false;
> +	int err;
> +
> +	err = xsk_link_lookup(ifindex_lo, NULL, &link_fd);
> +	if (err)
> +		return ret;
> +
> +	if (link_fd >= 0)
> +		return true;
> +
> +	memset(&prog_attr, 0, sizeof(prog_attr));
> +	prog_attr.prog_type = BPF_PROG_TYPE_XDP;
> +	prog_attr.insns = insns;
> +	prog_attr.insns_cnt = ARRAY_SIZE(insns);
> +	prog_attr.license = "GPL";
> +
> +	prog_fd = bpf_load_program_xattr(&prog_attr, NULL, 0);
> +	if (prog_fd < 0)
> +		return ret;
> +
> +	link_fd = bpf_link_create(prog_fd, ifindex_lo, BPF_XDP, &opts);
> +	if (link_fd >= 0)
> +		ret = true;
> +
> +	close(prog_fd);
> +	close(link_fd);

This potentially calls close() on an invalid link_fd...

> +
> +	return ret;
> +}
> +
>  static int xsk_create_xsk_struct(int ifindex, struct xsk_socket *xsk)
>  {
>  	char ifname[IFNAMSIZ];
> @@ -663,64 +785,108 @@ static int xsk_create_xsk_struct(int ifindex, struct xsk_socket *xsk)
>  	ctx->ifname[IFNAMSIZ - 1] = 0;
>  
>  	xsk->ctx = ctx;
> +	xsk->ctx->has_bpf_link = xsk_probe_bpf_link();
>  
>  	return 0;
>  }
>  
> -static int __xsk_setup_xdp_prog(struct xsk_socket *_xdp,
> -				int *xsks_map_fd)
> +static int xsk_init_xdp_res(struct xsk_socket *xsk,
> +			    int *xsks_map_fd)
>  {
> -	struct xsk_socket *xsk = _xdp;
>  	struct xsk_ctx *ctx = xsk->ctx;
> -	__u32 prog_id = 0;
>  	int err;
>  
> -	err = bpf_get_link_xdp_id(ctx->ifindex, &prog_id,
> -				  xsk->config.xdp_flags);
> +	err = xsk_create_bpf_maps(xsk);
>  	if (err)
>  		return err;
>  
> -	if (!prog_id) {
> -		err = xsk_create_bpf_maps(xsk);
> -		if (err)
> -			return err;
> +	err = xsk_load_xdp_prog(xsk);
> +	if (err)
> +		goto err_load_xdp_prog;
>  
> -		err = xsk_load_xdp_prog(xsk);
> -		if (err) {
> -			goto err_load_xdp_prog;
> -		}
> -	} else {
> -		ctx->prog_fd = bpf_prog_get_fd_by_id(prog_id);
> -		if (ctx->prog_fd < 0)
> -			return -errno;
> -		err = xsk_lookup_bpf_maps(xsk);
> -		if (err) {
> -			close(ctx->prog_fd);
> -			return err;
> -		}
> -	}
> +	if (ctx->has_bpf_link)
> +		err = xsk_create_bpf_link(xsk);
> +	else
> +		err = bpf_set_link_xdp_fd(xsk->ctx->ifindex, ctx->prog_fd,
> +					  xsk->config.xdp_flags);
>  
> -	if (xsk->rx) {
> -		err = xsk_set_bpf_maps(xsk);
> -		if (err) {
> -			if (!prog_id) {
> -				goto err_set_bpf_maps;
> -			} else {
> -				close(ctx->prog_fd);
> -				return err;
> -			}
> -		}
> -	}
> -	if (xsks_map_fd)
> -		*xsks_map_fd = ctx->xsks_map_fd;
> +	if (err)
> +		goto err_atach_xdp_prog;

s/atach/attach/

-Toke

