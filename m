Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCABA34B3D6
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 03:28:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbhC0C1o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 22:27:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbhC0C1c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 22:27:32 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D028C0613AA;
        Fri, 26 Mar 2021 19:27:32 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id v186so5804169pgv.7;
        Fri, 26 Mar 2021 19:27:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=r2OJKDkIYvUvVxY/33WQ/juxWSmStOBn1IcK9dzFtG0=;
        b=JLcjAGpV5DbktOyhhRjHw2CcVnV0Cc7k0Eik42NB8HZwMkNH/4ViUSvJ9q5vx7DwBI
         odPZLj2XDGVxWTV6PwhYZxcwUo0hA4E8nH31Clgt/uXUKEI2rrCyMXeVNa8LsBMgjknF
         +KOJB2FzObqmAIREgJMFI6tWZQEl/mopSxoMtfs8EphI8cTpNwkHdRDhfPBB/UP9NXln
         S0S4T1JsheR74cFZxdngy/CkWxy0HYyLEXO3SicuqDF2Lx0iYzIPswrnGXwSVFwDtXFE
         9LB3+EixEUdi4uEf6tJNdUBl2GGW2VLi+lyGqISEuIZO2p24WSp3vHWEUPDuA8dFYFrx
         6eUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=r2OJKDkIYvUvVxY/33WQ/juxWSmStOBn1IcK9dzFtG0=;
        b=EddtfEFhS+EKj8+m26Qhhcc2aldPlJWck3feZD/IGxyYA0k43vq1sgzPYn4legzld3
         GmwCvgisjyYh9kCbGuV8er9qvo/yHFTtZMoQyCYmyp6tHXPnZnZnuLl0uUmQcUk/9jz7
         nGoXjzFji1pveNgu+QDI8gU+vkXWKFwe7mJEIgJVj4YFHgnT6p9BVfz8mQqIF1mDf9l0
         0fZ9afpeHJNbVsmRxtQc1h5azAwgUZisXnw8guBKPcbqNAv+5VYXvk9uK8OFoOMrJRm8
         m6o3VsEynyDSyo6RdGa9a/DoRgQIgG9tM7T1NY8LA5p8JCvf7M82ylbK3BOMyb0rqaFB
         vcDw==
X-Gm-Message-State: AOAM533YRGsViMBsDDNXUoQBG0Z4BIN3KhSZ+fPf25+a1TS4pskCtI+7
        ovW96l8tQMS/oi96k0FUlOs=
X-Google-Smtp-Source: ABdhPJzzWjVLwEKa5hFZvrXiO+DrXEv6LJmUHT3QmLMFqNWO3QvfhpemdFmfumpXNwzCjKY3KFBMTw==
X-Received: by 2002:a05:6a00:13a3:b029:203:5c4d:7a22 with SMTP id t35-20020a056a0013a3b02902035c4d7a22mr15287473pfg.22.1616812051531;
        Fri, 26 Mar 2021 19:27:31 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:15b8])
        by smtp.gmail.com with ESMTPSA id j3sm9144915pjf.36.2021.03.26.19.27.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 19:27:30 -0700 (PDT)
Date:   Fri, 26 Mar 2021 19:27:29 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Ciara Loftus <ciara.loftus@intel.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, bjorn@kernel.org,
        magnus.karlsson@gmail.com
Subject: Re: [PATCH v2 bpf 3/3] libbpf: ignore return values of setsockopt
 for XDP rings.
Message-ID: <20210327022729.cgizt5xnhkerbrmy@ast-mbp>
References: <20210326142946.5263-1-ciara.loftus@intel.com>
 <20210326142946.5263-4-ciara.loftus@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210326142946.5263-4-ciara.loftus@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 26, 2021 at 02:29:46PM +0000, Ciara Loftus wrote:
> During xsk_socket__create the XDP_RX_RING and XDP_TX_RING setsockopts
> are called to create the rx and tx rings for the AF_XDP socket. If the ring
> has already been set up, the setsockopt will return an error. However,
> in the event of a failure during xsk_socket__create(_shared) after the
> rings have been set up, the user may wish to retry the socket creation
> using these pre-existing rings. In this case we can ignore the error
> returned by the setsockopts. If there is a true error, the subsequent
> call to mmap() will catch it.
> 
> Fixes: 1cad07884239 ("libbpf: add support for using AF_XDP sockets")
> 
> Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
> Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
> ---
>  tools/lib/bpf/xsk.c | 34 ++++++++++++++++------------------
>  1 file changed, 16 insertions(+), 18 deletions(-)
> 
> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> index d4991ddff05a..cfc4abf505c3 100644
> --- a/tools/lib/bpf/xsk.c
> +++ b/tools/lib/bpf/xsk.c
> @@ -900,24 +900,22 @@ int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
>  	}
>  	xsk->ctx = ctx;
>  
> -	if (rx) {
> -		err = setsockopt(xsk->fd, SOL_XDP, XDP_RX_RING,
> -				 &xsk->config.rx_size,
> -				 sizeof(xsk->config.rx_size));
> -		if (err) {
> -			err = -errno;
> -			goto out_put_ctx;
> -		}
> -	}
> -	if (tx) {
> -		err = setsockopt(xsk->fd, SOL_XDP, XDP_TX_RING,
> -				 &xsk->config.tx_size,
> -				 sizeof(xsk->config.tx_size));
> -		if (err) {
> -			err = -errno;
> -			goto out_put_ctx;
> -		}
> -	}
> +	/* The return values of these setsockopt calls are intentionally not checked.
> +	 * If the ring has already been set up setsockopt will return an error. However,
> +	 * this scenario is acceptable as the user may be retrying the socket creation
> +	 * with rings which were set up in a previous but ultimately unsuccessful call
> +	 * to xsk_socket__create(_shared). The call later to mmap() will fail if there
> +	 * is a real issue and we handle that return value appropriately there.
> +	 */
> +	if (rx)
> +		setsockopt(xsk->fd, SOL_XDP, XDP_RX_RING,
> +			   &xsk->config.rx_size,
> +			   sizeof(xsk->config.rx_size));
> +
> +	if (tx)
> +		setsockopt(xsk->fd, SOL_XDP, XDP_TX_RING,
> +			   &xsk->config.tx_size,
> +			   sizeof(xsk->config.tx_size));

Instead of ignoring the error can you remember that setsockopt was done
in struct xsk_socket and don't do it the second time?
