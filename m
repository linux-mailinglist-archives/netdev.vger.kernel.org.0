Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F24F8125074
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 19:20:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727327AbfLRSUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 13:20:15 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:33454 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726939AbfLRSUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 13:20:15 -0500
Received: by mail-pg1-f193.google.com with SMTP id 6so1710563pgk.0
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 10:20:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1PpeyUcZW0PqeysBL99cFkKZxH/dHnut5ee1mR5HniE=;
        b=Owm2nGoztLdvtEaEk2vQY58K3ulzNbxvwLqun7r6cMBiIZiOhRPA2AMVnwIogrqVUk
         pEAuGZzU9KoNVlLRHxjD+UAe509giIVS11Sk7/J8LhNhrAHLdXzgNsnC0iceeVUPUfUU
         2eBzqFvuyKScTDhMvE+J7iW0bsUju/jm2uF/+yIptSdtXWSNq72OqJt6nx2DWupXwIcF
         qhzErcBM2m//MA23Hy8y/b2+ZfDkL/Ddg6PR8wUNvQkJHovLdVCOE4rk1u+iUlgQd4ql
         sCj7kYEVK2ALy+KBSpSsgR0q9tLXLSm+5aOmEVpzaGAIxfWgurEelAP8sgIuviRN97m9
         NIgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1PpeyUcZW0PqeysBL99cFkKZxH/dHnut5ee1mR5HniE=;
        b=WlrkJBeni2cVR7wt5YJ0OXwzRBr+fQNS4alEU4cIrkOchubsgrJiId/jvwyolZLQOY
         +sF7JpP2G+WosqZXMUS5QiLQRU+yaKO4P9A5clLPcQIHQfC1w82stweyjF2cxlNa5hpz
         0X1nddCL4mD002V6IsxTXEIjLi2cEUkk7GyKOLeW+GFslzjj/WUw+dWtonr+8CTPl+hO
         b6Xl+a9gouy0b7OR/aQLyRIZ8NpA+Vh8qzd9DV7s8Ll9VMwiLiWy/Bn8AcDvRsxUGr3t
         ZPXlcvO4aaaPjZuGVszf7uppOlySlqyyL3uUzRPqf8dVg0dtmmXiF/4mAzD+vAjDbrYv
         RlHg==
X-Gm-Message-State: APjAAAVh1t/JJRkv5PTbGy+iJEUvDBHvXN4MEt8F9M/5vq8HJghbKTP2
        9eYTXo8+nEp9mJ29O6VXFWk=
X-Google-Smtp-Source: APXvYqxrnvjdID6P1MAw1ttpMIzQowbRL7X8nDcTZgM9DPGQc8aQ37f9MXtA/CKnpOyRhfTSkPWLVA==
X-Received: by 2002:aa7:9355:: with SMTP id 21mr4596697pfn.61.1576693214389;
        Wed, 18 Dec 2019 10:20:14 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::4108])
        by smtp.gmail.com with ESMTPSA id m101sm3733692pje.13.2019.12.18.10.20.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Dec 2019 10:20:13 -0800 (PST)
Date:   Wed, 18 Dec 2019 10:20:12 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Prashant Bhole <prashantbhole.linux@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        David Ahern <dahern@digitalocean.com>
Subject: Re: [RFC net-next 03/14] libbpf: API for tx path XDP support
Message-ID: <20191218182011.oatv5zermnkdspie@ast-mbp.dhcp.thefacebook.com>
References: <20191218081050.10170-1-prashantbhole.linux@gmail.com>
 <20191218081050.10170-4-prashantbhole.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191218081050.10170-4-prashantbhole.linux@gmail.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 18, 2019 at 05:10:39PM +0900, Prashant Bhole wrote:
> Adds new APIs for tx path XDP:
>  - bpf_set_link_xdp_tx_fd
>  - bpf_get_link_xdp_tx_id
>  - bpf_get_link_xdp_tx_info
> 
> Co-developed-by: David Ahern <dahern@digitalocean.com>
> Signed-off-by: David Ahern <dahern@digitalocean.com>
> Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
> ---
>  tools/lib/bpf/libbpf.h   |  4 +++
>  tools/lib/bpf/libbpf.map |  3 ++
>  tools/lib/bpf/netlink.c  | 77 +++++++++++++++++++++++++++++++++++-----
>  3 files changed, 75 insertions(+), 9 deletions(-)
> 
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index 0dbf4bfba0c4..741e5fee61f6 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -447,6 +447,10 @@ LIBBPF_API int bpf_set_link_xdp_fd(int ifindex, int fd, __u32 flags);
>  LIBBPF_API int bpf_get_link_xdp_id(int ifindex, __u32 *prog_id, __u32 flags);
>  LIBBPF_API int bpf_get_link_xdp_info(int ifindex, struct xdp_link_info *info,
>  				     size_t info_size, __u32 flags);
> +LIBBPF_API int bpf_set_link_xdp_tx_fd(int ifindex, int fd, __u32 flags);
> +LIBBPF_API int bpf_get_link_xdp_tx_id(int ifindex, __u32 *prog_id, __u32 flags);
> +LIBBPF_API int bpf_get_link_xdp_tx_info(int ifindex, struct xdp_link_info *info,
> +				     size_t info_size, __u32 flags);

please use _opts() style of api extensions.

