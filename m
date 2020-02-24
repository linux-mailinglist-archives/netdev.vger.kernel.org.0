Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5F2F16A657
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 13:46:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727310AbgBXMqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 07:46:36 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:58050 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727183AbgBXMqf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 07:46:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582548395;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=N1w/bpq1E0DR8ffozDoEv3Gfr6ireSQ41Zmo6iO9ZL4=;
        b=Y1ocdN3UtTLrrSnj0Sl6covafFgxUNL/y/1B5Muce3KTCVpV+fSyfr8rbvx1l3qzYMjWsg
        LAtDApWJvJ5F1erEV2zNvOTX3WFtWCF4O216eapg0OuEfR1FQkvmx50Vm9XFJ8gEZcmI4d
        3AIkj6xAFUvDI0/fcAu1PTVpU60LChs=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-13-_sdXwMoIM_ySIKzVggvNag-1; Mon, 24 Feb 2020 07:46:33 -0500
X-MC-Unique: _sdXwMoIM_ySIKzVggvNag-1
Received: by mail-qk1-f200.google.com with SMTP id o22so10523836qko.2
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 04:46:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=N1w/bpq1E0DR8ffozDoEv3Gfr6ireSQ41Zmo6iO9ZL4=;
        b=e/PnAiUhSkFrM2C0d6gu+H1MHljSVp9G9alroHty0iypW2DHxNGBwqq3cMi2rysc3k
         qvIYPNXkAkn5CyiVxqif2fChSs3fvi7sYzEBcDnLPBv5Ktef5ZaURlJ0zKLJr3hyFIuM
         dny2TyQgBAxye66B3dS4OFH14+U4y9tLDGb5RbZIbYAh4uoB29YIOu0P0MaRiqEiZjNc
         CRclUiBR0lwgSdI6EBdYJqWAL0KAmUCTWQmJDx958TmZTqxkBC86oaXzyEWIDbGisovh
         SC9wqv3CNIXcQZdmywm8Uft3swTZzuX/mWTGgfIBP/T8jkzsn3LkQTthkb2IgkxjOWU7
         TuSw==
X-Gm-Message-State: APjAAAXIck7vbnHYUEtRCwkT1eccmrLj8K5It3kIjigzxq72nlepAzza
        PFwcx4TeLDtybUCqLzbd+sOn45f5I+vZiUcXYLMbK4igHM/5jT2BADnJPPRZe30R+ps773T/7it
        yGeD8NfrOSmTD4kvj
X-Received: by 2002:a05:6214:1090:: with SMTP id o16mr44417576qvr.105.1582548393305;
        Mon, 24 Feb 2020 04:46:33 -0800 (PST)
X-Google-Smtp-Source: APXvYqywnGbl/kPjS/h+s1WqKt4dmZfLt2m7GCCSOkmteYbtnbiK/9cmHGbGiMVk/z3Scpi+g6NOrg==
X-Received: by 2002:a05:6214:1090:: with SMTP id o16mr44417557qvr.105.1582548393075;
        Mon, 24 Feb 2020 04:46:33 -0800 (PST)
Received: from redhat.com (bzq-79-178-2-214.red.bezeqint.net. [79.178.2.214])
        by smtp.gmail.com with ESMTPSA id 202sm3046131qkg.132.2020.02.24.04.46.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 04:46:32 -0800 (PST)
Date:   Mon, 24 Feb 2020 07:46:27 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     anton.ivanov@cambridgegreys.com
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-um@lists.infradead.org, jasowang@redhat.com,
        eric.dumazet@gmail.com
Subject: Re: [PATCH v2] virtio: Work around frames incorrectly marked as gso
Message-ID: <20200224074516-mutt-send-email-mst@kernel.org>
References: <20200224101912.14074-1-anton.ivanov@cambridgegreys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200224101912.14074-1-anton.ivanov@cambridgegreys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 24, 2020 at 10:19:12AM +0000, anton.ivanov@cambridgegreys.com wrote:
> From: Anton Ivanov <anton.ivanov@cambridgegreys.com>
> 
> Some of the locally generated frames marked as GSO which
> arrive at virtio_net_hdr_from_skb() have no GSO_TYPE, no
> fragments (data_len = 0) and length significantly shorter
> than the MTU (752 in my experiments).
> 
> This is observed on raw sockets reading off vEth interfaces
> in all 4.x and 5.x kernels I tested.

A bit more info on how to reproduce couldn't hurt here.

> 
> These frames are reported as invalid while they are in fact
> gso-less frames.
> 
> This patch marks the vnet header as no-GSO for them instead
> of reporting it as invalid.
> 
> Signed-off-by: Anton Ivanov <anton.ivanov@cambridgegreys.com>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

Eric - as you looked at this in the past, would you mind acking please?

> ---
>  include/linux/virtio_net.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
> index 0d1fe9297ac6..94fb78c3a2ab 100644
> --- a/include/linux/virtio_net.h
> +++ b/include/linux/virtio_net.h
> @@ -100,8 +100,8 @@ static inline int virtio_net_hdr_from_skb(const struct sk_buff *skb,
>  {
>  	memset(hdr, 0, sizeof(*hdr));   /* no info leak */
>  
> -	if (skb_is_gso(skb)) {
> -		struct skb_shared_info *sinfo = skb_shinfo(skb);
> +	struct skb_shared_info *sinfo = skb_shinfo(skb);
> +	if (skb_is_gso(skb) && sinfo->gso_type) {
>  
>  		/* This is a hint as to how much should be linear. */
>  		hdr->hdr_len = __cpu_to_virtio16(little_endian,
> -- 
> 2.20.1

