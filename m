Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF56F31C310
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 21:35:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbhBOUeb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 15:34:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbhBOUeZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 15:34:25 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD758C061756;
        Mon, 15 Feb 2021 12:33:45 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id o7so6542198ils.2;
        Mon, 15 Feb 2021 12:33:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=CFPPKldSdRUGIk7jdmsHnHCmpu38jR4ZDeuMDX4Xz1w=;
        b=ZHIqDC8cyxqx2NeGiFY//NZyvpBshXmsA+HVe05QFqtSgY79ZSdFftcN5B44Hhhdgo
         TnZaFgSFSUL68ZwP6w09zagla+sy2Y2cXb/nSL8BSVQ9EL6ZRJCgE2mcajk6EmMXGgXF
         JBtaljsnYoQs7tQf1FMJ1jK56sdZb4FTaqde4dX/wvE30CHXlweqra4gGsPUONcfSzgE
         K3tGqxxxrKepzsHxCIlfksyBqjuYHNs78m8ODR/tJdIpH1YdUdoKOPoYWsZb4WmdbocM
         xjZzzXz8jisFJF/525W15VuW3rOmFs/elmZ0UOkMb1Q4ZagKhCfqzCdUVCvnNm3n6u3l
         8XUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=CFPPKldSdRUGIk7jdmsHnHCmpu38jR4ZDeuMDX4Xz1w=;
        b=C5m//P8lRjbC7kMN25jNaV1zFRpj2fb8aVS4rDXdOJCCrbNmwduq47RwdhLmv+9Oz7
         aalQ+KPhcNlJaoTsZBHcahcnzoHsqAj1rF4ncdl9FViOJa/NCIwN3tG+E17UhiSZ1QvE
         Jb8YJf1KwKvf4TV5waNXSesZR9dk9PGCPU/tuNUwgvafETsudtsCMhATpZocZwXfctU5
         BxvrDmpghvVS7JMWbWhOkwEGsa19PlatByl25q/gMWNqHW29iB1GWameQNbJriNYWZ7V
         jm4a/7slF9oJpoWLmJHJF0ZxWSP31+EOuMEPoMCintkDswyKCY68uNPkF/dLCPwvDqqY
         3trw==
X-Gm-Message-State: AOAM5335OeNb2CQrIr8yfaZmY+DCEYlNQmFZCdkd+TKrwFEIDkicbtJq
        MolKvtLRCNvgYA3RsiMqEK4=
X-Google-Smtp-Source: ABdhPJwE/xyZ1KzApr/6+pglrpnhwq0qTSPXcWZOGplzutnGCyxEEJQqKCYsQXSMvCKRGTCZpbfD1A==
X-Received: by 2002:a92:d249:: with SMTP id v9mr13832371ilg.305.1613421225337;
        Mon, 15 Feb 2021 12:33:45 -0800 (PST)
Received: from localhost ([172.243.146.206])
        by smtp.gmail.com with ESMTPSA id g3sm8871646ile.10.2021.02.15.12.33.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Feb 2021 12:33:44 -0800 (PST)
Date:   Mon, 15 Feb 2021 12:33:37 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        daniel@iogearbox.net, ast@kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     andrii@kernel.org, toke@redhat.com, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, ciara.loftus@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Message-ID: <602adaa11468c_3ed41208c5@john-XPS-13-9370.notmuch>
In-Reply-To: <20210215154638.4627-3-maciej.fijalkowski@intel.com>
References: <20210215154638.4627-1-maciej.fijalkowski@intel.com>
 <20210215154638.4627-3-maciej.fijalkowski@intel.com>
Subject: RE: [PATCH bpf-next 2/3] libbpf: clear map_info before each
 bpf_obj_get_info_by_fd
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maciej Fijalkowski wrote:
> xsk_lookup_bpf_maps, based on prog_fd, looks whether current prog has a
> reference to XSKMAP. BPF prog can include insns that work on various BPF
> maps and this is covered by iterating through map_ids.
> 
> The bpf_map_info that is passed to bpf_obj_get_info_by_fd for filling
> needs to be cleared at each iteration, so that it doesn't any outdated
> fields and that is currently missing in the function of interest.
> 
> To fix that, zero-init map_info via memset before each
> bpf_obj_get_info_by_fd call.
> 
> Also, since the area of this code is touched, in general strcmp is
> considered harmful, so let's convert it to strncmp and provide the
> length of the array name that we're looking for.
> 
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---

This is a bugfix independent of the link bits correct? Would be best
to send to bpf then. 

>  tools/lib/bpf/xsk.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> index 5911868efa43..fb259c0bba93 100644
> --- a/tools/lib/bpf/xsk.c
> +++ b/tools/lib/bpf/xsk.c
> @@ -616,6 +616,7 @@ static int xsk_lookup_bpf_maps(struct xsk_socket *xsk)
>  	__u32 i, *map_ids, num_maps, prog_len = sizeof(struct bpf_prog_info);
>  	__u32 map_len = sizeof(struct bpf_map_info);
>  	struct bpf_prog_info prog_info = {};
> +	const char *map_name = "xsks_map";
>  	struct xsk_ctx *ctx = xsk->ctx;
>  	struct bpf_map_info map_info;
>  	int fd, err;
> @@ -645,13 +646,14 @@ static int xsk_lookup_bpf_maps(struct xsk_socket *xsk)
>  		if (fd < 0)
>  			continue;
>  
> +		memset(&map_info, 0, map_len);
>  		err = bpf_obj_get_info_by_fd(fd, &map_info, &map_len);
>  		if (err) {
>  			close(fd);
>  			continue;
>  		}
>  
> -		if (!strcmp(map_info.name, "xsks_map")) {
> +		if (!strncmp(map_info.name, map_name, strlen(map_name))) {
>  			ctx->xsks_map_fd = fd;
>  			continue;

Also just looking at this how is above not buggy? Should be a break instead
of continue? If we match another "xsks_map" here won't we stomp on xsks_map_fd
and leak a file descriptor?

>  		}
> -- 
> 2.20.1
> 


