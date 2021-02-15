Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1084231C337
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 21:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbhBOUuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 15:50:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbhBOUuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 15:50:16 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 861AEC061756;
        Mon, 15 Feb 2021 12:49:36 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id s24so8055083iob.6;
        Mon, 15 Feb 2021 12:49:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=YyypyEJ3ccU02KP95llr7s4/01dfMfvBGOccF1Y+hpc=;
        b=DQAFRaVYv3oNEIvOpvJazi7Mt2O++AEOsL4QfxBt8zS6rJpb9OOPgDi9FibTuTyMZF
         8cM/WKImGO4KiUibkh3ucHx2lSG88zXEHpfYOa9XL2vJCOeTufWnaDDDHHTIroz3jsfC
         bgk8bxYtDyQKKH1uq+mZde4lhqBo1n6DiFmKBudhot19Q8LtQH2XjK2ex3iusbPO5BD+
         XthiL6cwSosI0hJdTiTDillE7p3ioMK+By/uiOvBopRuzebtYxfL+Wu959rCg0jsIah9
         5mXmw2s1U/lks8BsLT5uaBdxBE4vk8A7XmMoNjuUWbtljlBc5DY+BZBTwVsdvb1ZfNWx
         mcaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=YyypyEJ3ccU02KP95llr7s4/01dfMfvBGOccF1Y+hpc=;
        b=rLxRTLLCpqOTL99K43QNfczrfIFjiv0iTT06TMvR73Ih5HVwFkNTXmBHfLxyVRTFy8
         +A18u0MK6lu6Z/98YVzCH/tMhNJnPLxW1iLiMaSy4WgTNjKFDHDBAfEhtgmn/JfyzPvz
         vxjGCSrUCX+0zpXnyOt0pCaedpkKk3ll4/zbUOZ2jj8m5YK1I1ku7Ksit+aUaturw61a
         xBn+QcO9UqQNbVSQvyUAhrrTOhfsR3ML/GMvHy8PlJ20pdvsq+O57itufh711xQ6WBG2
         VbweNFQ5JoNP015IqynrlQIzuGFoJLtP2GDqaQUjOtKSYT6VcVOqAGtnBbg+9PFyQ2Ev
         e4/w==
X-Gm-Message-State: AOAM531MZ8WihxpmNsskOVBiB3goHxTYMVGXWQTD6Axic6TCh4wOGLNx
        QntzPs0lq/1agNjtwOm51iM=
X-Google-Smtp-Source: ABdhPJwYm5HdjsHipEqFewCzpW2Rf9CFyr6j4PYyjn19XzxWf+Gv5s3mUk5fKXriwxqzFxozURHNpA==
X-Received: by 2002:a05:6638:3bc:: with SMTP id z28mr16480141jap.118.1613422176054;
        Mon, 15 Feb 2021 12:49:36 -0800 (PST)
Received: from localhost ([172.243.146.206])
        by smtp.gmail.com with ESMTPSA id y11sm9695569ilv.64.2021.02.15.12.49.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Feb 2021 12:49:35 -0800 (PST)
Date:   Mon, 15 Feb 2021 12:49:27 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        daniel@iogearbox.net, ast@kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     andrii@kernel.org, toke@redhat.com, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, ciara.loftus@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Message-ID: <602ade57ddb9c_3ed41208a1@john-XPS-13-9370.notmuch>
In-Reply-To: <20210215154638.4627-2-maciej.fijalkowski@intel.com>
References: <20210215154638.4627-1-maciej.fijalkowski@intel.com>
 <20210215154638.4627-2-maciej.fijalkowski@intel.com>
Subject: RE: [PATCH bpf-next 1/3] libbpf: xsk: use bpf_link
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maciej Fijalkowski wrote:
> Currently, if there are multiple xdpsock instances running on a single
> interface and in case one of the instances is terminated, the rest of
> them are left in an inoperable state due to the fact of unloaded XDP
> prog from interface.
> 
> To address that, step away from setting bpf prog in favour of bpf_link.
> This means that refcounting of BPF resources will be done automatically
> by bpf_link itself.
> 
> When setting up BPF resources during xsk socket creation, check whether
> bpf_link for a given ifindex already exists via set of calls to
> bpf_link_get_next_id -> bpf_link_get_fd_by_id -> bpf_obj_get_info_by_fd
> and comparing the ifindexes from bpf_link and xsk socket.
> 
> If there's no bpf_link yet, create one for a given XDP prog and unload
> explicitly existing prog if XDP_FLAGS_UPDATE_IF_NOEXIST is not set.
> 
> If bpf_link is already at a given ifindex and underlying program is not
> AF-XDP one, bail out or update the bpf_link's prog given the presence of
> XDP_FLAGS_UPDATE_IF_NOEXIST.
> 
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  tools/lib/bpf/xsk.c | 143 +++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 122 insertions(+), 21 deletions(-)

[...]

> +static int xsk_create_bpf_link(struct xsk_socket *xsk)
> +{
> +	/* bpf_link only accepts XDP_FLAGS_MODES, but xsk->config.xdp_flags
> +	 * might have set XDP_FLAGS_UPDATE_IF_NOEXIST
> +	 */
> +	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts,
> +			    .flags = (xsk->config.xdp_flags & XDP_FLAGS_MODES));
> +	struct xsk_ctx *ctx = xsk->ctx;
> +	__u32 prog_id;
> +	int link_fd;
> +	int err;
> +
> +	/* for !XDP_FLAGS_UPDATE_IF_NOEXIST, unload the program first, if any,
> +	 * so that bpf_link can be attached
> +	 */
> +	if (!(xsk->config.xdp_flags & XDP_FLAGS_UPDATE_IF_NOEXIST)) {
> +		err = bpf_get_link_xdp_id(ctx->ifindex, &prog_id, xsk->config.xdp_flags);
> +		if (err) {
> +			pr_warn("getting XDP prog id failed\n");
> +			return err;
> +		}
> +		if (prog_id) {
> +			err = bpf_set_link_xdp_fd(ctx->ifindex, -1, 0);
> +			if (err < 0) {
> +				pr_warn("detaching XDP prog failed\n");
> +				return err;
> +			}
> +		}
>  	}
>  
> -	ctx->prog_fd = prog_fd;
> +	link_fd = bpf_link_create(ctx->prog_fd, xsk->ctx->ifindex, BPF_XDP, &opts);
> +	if (link_fd < 0) {
> +		pr_warn("bpf_link_create failed: %s\n", strerror(errno));
> +		return link_fd;
> +	}
> +

This can leave the system in a bad state where it unloaded the XDP program
above, but then failed to create the link. So we should somehow fix that
if possible or at minimum put a note somewhere so users can't claim they
shouldn't know this.

Also related, its not good for real systems to let XDP program go missing
for some period of time. I didn't check but we should make
XDP_FLAGS_UPDATE_IF_NOEXIST the default if its not already.

> +	ctx->link_fd = link_fd;
>  	return 0;
>  }
>  

[...]

> +static int xsk_link_lookup(struct xsk_ctx *ctx, __u32 *prog_id)
> +{
> +	__u32 link_len = sizeof(struct bpf_link_info);
> +	struct bpf_link_info link_info;
> +	__u32 id = 0;
> +	int err;
> +	int fd;
> +
> +	while (true) {
> +		err = bpf_link_get_next_id(id, &id);
> +		if (err) {
> +			if (errno == ENOENT)
> +				break;
> +			pr_warn("can't get next link: %s\n", strerror(errno));
> +			break;
> +		}
> +
> +		fd = bpf_link_get_fd_by_id(id);
> +		if (fd < 0) {
> +			if (errno == ENOENT)
> +				continue;
> +			pr_warn("can't get link by id (%u): %s\n", id, strerror(errno));
> +			break;
> +		}
> +
> +		memset(&link_info, 0, link_len);
> +		err = bpf_obj_get_info_by_fd(fd, &link_info, &link_len);
> +		if (err) {
> +			pr_warn("can't get link info: %s\n", strerror(errno));
> +			close(fd);
> +			break;
> +		}
> +		if (link_info.xdp.ifindex == ctx->ifindex) {
> +			ctx->link_fd = fd;
> +			*prog_id = link_info.prog_id;
> +			break;
> +		}
> +		close(fd);
> +	}
> +
> +	return errno == ENOENT ? 0 : err;

But, err wont be set in fd < 0 case? I guess we don't want to return 0 if
bpf_link_get_fd_by_id fails. Although I really don't like the construct
here that much. I think just `return err` and ensuring err is set correctly
would be more clear. At least the fd error case needs to be handled
though.

> +}
> +
