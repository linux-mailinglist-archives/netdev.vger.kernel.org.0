Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13E5A1F1F01
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 20:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726186AbgFHSaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 14:30:19 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36236 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726181AbgFHSaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 14:30:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591641014;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7hiih3ovxJ9COLmjK6bpSQguuiJY19w1v9ZkE8vq+pg=;
        b=BHPtX/ObbtlN3Wifj0RHDDC0aXB4WQ3tEIGJCzrhYcteS7lUPC8J9yPIsnW9tMHB9BlYnc
        kbvt+V1zDHV/z/TyWeludQr6/ABei6ycKwgjiRs1tB9Vl0uoIQwHpB27zW8RjTwM784oUy
        E85Lo6vJ+RhX1TnxeQeyB4fuMELV4iE=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-287-anWF27cBOwGuVHoZAvRe5g-1; Mon, 08 Jun 2020 14:30:11 -0400
X-MC-Unique: anWF27cBOwGuVHoZAvRe5g-1
Received: by mail-ed1-f69.google.com with SMTP id f13so7220507edv.11
        for <netdev@vger.kernel.org>; Mon, 08 Jun 2020 11:30:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=7hiih3ovxJ9COLmjK6bpSQguuiJY19w1v9ZkE8vq+pg=;
        b=mDXEM2zEobTMnk/ePfTzu9BcjpNuCnBXxgkgtxdzSGraiTSqub//HJEFZJ3xWXJqti
         /H/BhQGiVBHmSEab4m4VFNBDe2DU8ltyUAe/rh+e38F4u9rmOftzWJ40rLhj7Uig6AxW
         bPufysqPFZkmdJCjKtD925IfCa/OSg+uxBqBnFET+UYadx0LDkWaiUjwDwhgyYOyjSE5
         b3+Rq1jmnE/cZudQVLi9OqtcQ4JKrBEsFcWw/18y5oQkdXn5P9gBYV3Un3zg2+yJ2zb6
         YgwxHHAyBKBtgBkEYyd67tfoanN9K+ustxDT4BsnGn9Kk0eayb7OKyt4W643YO0znOiO
         4d9A==
X-Gm-Message-State: AOAM532txacFI5nTeOjt+eM1wpaUT+ImFyUS4/epnCesMm7QWr5EBStV
        QNcANYb0Abg6zeK0FW/yQjFps+/4q7rVVEwxUcLlfVaDCia/GEfCFPJzC82LsFJRGg3t8Ffm+eZ
        BfrMrltlsCDcoebiu
X-Received: by 2002:a17:906:19c3:: with SMTP id h3mr6506403ejd.314.1591641009738;
        Mon, 08 Jun 2020 11:30:09 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx9uWHqcThS3MG8KIw5vBqnJG7K8sZ2RZc0OwtdH9iWbPF04pORFpkx/wQtfmiOVeyGgrehbQ==
X-Received: by 2002:a17:906:19c3:: with SMTP id h3mr6506388ejd.314.1591641009508;
        Mon, 08 Jun 2020 11:30:09 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id j3sm13303785edr.87.2020.06.08.11.30.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2020 11:30:08 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 6352D18200D; Mon,  8 Jun 2020 20:30:08 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        David Ahern <dsahern@gmail.com>, bpf@vger.kernel.org,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Subject: Re: [PATCH bpf 2/3] bpf: devmap adjust uapi for attach bpf program
In-Reply-To: <159163508261.1967373.10375683361894729822.stgit@firesoul>
References: <159163498340.1967373.5048584263152085317.stgit@firesoul> <159163508261.1967373.10375683361894729822.stgit@firesoul>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 08 Jun 2020 20:30:08 +0200
Message-ID: <873675cswf.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer <brouer@redhat.com> writes:

> The recent commit fbee97feed9b ("bpf: Add support to attach bpf program to a
> devmap entry"), introduced ability to attach (and run) a separate XDP
> bpf_prog for each devmap entry. A bpf_prog is added via a file-descriptor.
> As zero were a valid FD, not using the feature requires using value minus-1.
> The UAPI is extended via tail-extending struct bpf_devmap_val and using
> map->value_size to determine the feature set.
>
> This will break older userspace applications not using the bpf_prog feature.
> Consider an old userspace app that is compiled against newer kernel
> uapi/bpf.h, it will not know that it need to initialise the member
> bpf_prog.fd to minus-1. Thus, users will be forced to update source code to
> get program running on newer kernels.
>
> As previous patch changed BPF-syscall to avoid returning file descriptor
> value zero, we can remove the minus-1 checks, and have zero mean feature
> isn't used.
>
> Fixes: fbee97feed9b ("bpf: Add support to attach bpf program to a devmap entry")
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>  include/uapi/linux/bpf.h       |   13 +++++++++++++
>  kernel/bpf/devmap.c            |   17 ++++-------------
>  tools/include/uapi/linux/bpf.h |    5 -----
>  3 files changed, 17 insertions(+), 18 deletions(-)
>
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index c65b374a5090..19684813faae 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -3761,6 +3761,19 @@ struct xdp_md {
>  	__u32 egress_ifindex;  /* txq->dev->ifindex */
>  };
>  
> +/* DEVMAP map-value layout
> + *
> + * The struct data-layout of map-value is a configuration interface.
> + * New members can only be added to the end of this structure.
> + */
> +struct bpf_devmap_val {
> +	__u32 ifindex;   /* device index */
> +	union {
> +		int   fd;  /* prog fd on map write */
> +		__u32 id;  /* prog id on map read */
> +	} bpf_prog;
> +};
> +
>  enum sk_action {
>  	SK_DROP = 0,
>  	SK_PASS,
> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> index 854b09beb16b..d268a8e693cb 100644
> --- a/kernel/bpf/devmap.c
> +++ b/kernel/bpf/devmap.c
> @@ -60,15 +60,6 @@ struct xdp_dev_bulk_queue {
>  	unsigned int count;
>  };
>  
> -/* DEVMAP values */
> -struct bpf_devmap_val {
> -	u32 ifindex;   /* device index */
> -	union {
> -		int fd;  /* prog fd on map write */
> -		u32 id;  /* prog id on map read */
> -	} bpf_prog;
> -};
> -
>  struct bpf_dtab_netdev {
>  	struct net_device *dev; /* must be first member, due to tracepoint */
>  	struct hlist_node index_hlist;
> @@ -618,7 +609,7 @@ static struct bpf_dtab_netdev *__dev_map_alloc_node(struct net *net,
>  	if (!dev->dev)
>  		goto err_out;
>  
> -	if (val->bpf_prog.fd >= 0) {
> +	if (val->bpf_prog.fd > 0) {
>  		prog = bpf_prog_get_type_dev(val->bpf_prog.fd,
>  					     BPF_PROG_TYPE_XDP, false);
>  		if (IS_ERR(prog))
> @@ -652,8 +643,8 @@ static int __dev_map_update_elem(struct net *net, struct bpf_map *map,
>  				 void *key, void *value, u64 map_flags)
>  {
>  	struct bpf_dtab *dtab = container_of(map, struct bpf_dtab, map);
> -	struct bpf_devmap_val val = { .bpf_prog.fd = -1 };
>  	struct bpf_dtab_netdev *dev, *old_dev;
> +	struct bpf_devmap_val val = {0};

nit: I prefer {} to {0} - 'git grep' indicates that {} is also the most
commonly used in kernel/bpf/


>  	u32 i = *(u32 *)key;
>  
>  	if (unlikely(map_flags > BPF_EXIST))
> @@ -669,7 +660,7 @@ static int __dev_map_update_elem(struct net *net, struct bpf_map *map,
>  	if (!val.ifindex) {
>  		dev = NULL;
>  		/* can not specify fd if ifindex is 0 */
> -		if (val.bpf_prog.fd != -1)
> +		if (val.bpf_prog.fd > 0)
>  			return -EINVAL;
>  	} else {
>  		dev = __dev_map_alloc_node(net, dtab, &val, i);
> @@ -699,8 +690,8 @@ static int __dev_map_hash_update_elem(struct net *net, struct bpf_map *map,
>  				     void *key, void *value, u64 map_flags)
>  {
>  	struct bpf_dtab *dtab = container_of(map, struct bpf_dtab, map);
> -	struct bpf_devmap_val val = { .bpf_prog.fd = -1 };
>  	struct bpf_dtab_netdev *dev, *old_dev;
> +	struct bpf_devmap_val val = {0};

Same here.

>  	u32 idx = *(u32 *)key;
>  	unsigned long flags;
>  	int err = -EEXIST;
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index c65b374a5090..868e9efe9c09 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -3761,11 +3761,6 @@ struct xdp_md {
>  	__u32 egress_ifindex;  /* txq->dev->ifindex */
>  };
>  
> -enum sk_action {
> -	SK_DROP = 0,
> -	SK_PASS,
> -};
> -
>  /* user accessible metadata for SK_MSG packet hook, new fields must
>   * be added to the end of this structure
>   */

