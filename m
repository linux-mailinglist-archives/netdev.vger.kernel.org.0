Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37E7C5FEBD0
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 11:39:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbiJNJjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 05:39:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbiJNJi7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 05:38:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B13B16086B
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 02:38:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665740336;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SBiaK/S0Bk1BtoBMbirhrmT4dSvIqzdjqMg7h+NAlCc=;
        b=AvgwQe40oqUjQ548cFSvj1YhWQaBhYiJZBRQWSGHIuRUS0qt8+iGXm5Fu8Wbc/NlE/oJcr
        lWHYpdSeLu5qw0d/laMA8ZmUq7lFIVceKXRlprzBtT+NRdq1yHHx3XUY5nbQp1gXzEvMyP
        852o7J4dZKKPRa5SKdi0eHZ4motwBx8=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-650-X5VPvy2jNM6iRFxvBpp5gw-1; Fri, 14 Oct 2022 05:38:55 -0400
X-MC-Unique: X5VPvy2jNM6iRFxvBpp5gw-1
Received: by mail-wm1-f70.google.com with SMTP id fc12-20020a05600c524c00b003b5054c70d3so2654836wmb.5
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 02:38:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SBiaK/S0Bk1BtoBMbirhrmT4dSvIqzdjqMg7h+NAlCc=;
        b=2PwVJ36NidCJEZKMzsL7QzleN1FqJDgkZiXIhnVMmRQf54+v48lEqSGJvmUoP+/PO9
         5ER5aaz4XoA7FaMEVfuRlfaRenPp9384nOOU0VPuj039tGZUG8icDtMPFdTpJxd03+Uh
         LQiE1fL34osZgqkMktpA8Q9UbG/n9bgry35X0fDzVZc8TXqj79tKHf0ecZAO3tbGgDUx
         P0UqowTfXu1Eq8/ksOnwXy3+dHYRQRyvEi7G8b04acllmF84DZCRcJqMGMLDOsTLTLzv
         42Sr17856hrTAC7tvtvhPP4xwuneWXn1+4foQ9k8Q5OJsfVwghyQ2Zeyte0ORmG0I/uZ
         YiVQ==
X-Gm-Message-State: ACrzQf2KTAAq0lJjleDxPUMpSSEBwnO2sCAEVJ+nWwcPut3odBu+14ms
        OQzI8GY5YdObSXAXSUC1v/OkUjAjmDkUQgPeldz7N3XwxQ2W0m1iEzTyUqjviNueOvGu35B8H+u
        qrV85Ixgwdqn6eAoO
X-Received: by 2002:a1c:7906:0:b0:3c6:235f:5904 with SMTP id l6-20020a1c7906000000b003c6235f5904mr2904927wme.83.1665740333639;
        Fri, 14 Oct 2022 02:38:53 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6ugOCG7McERH0v64bIpOWIbqCZhrlY99EXjNUJy1g+D4caPXaFlwkU7ZzIDHiEE6pf0wqZMA==
X-Received: by 2002:a1c:7906:0:b0:3c6:235f:5904 with SMTP id l6-20020a1c7906000000b003c6235f5904mr2904898wme.83.1665740333230;
        Fri, 14 Oct 2022 02:38:53 -0700 (PDT)
Received: from redhat.com ([2.54.162.123])
        by smtp.gmail.com with ESMTPSA id c7-20020a05600c0ac700b003c6bd12ac27sm1680397wmr.37.2022.10.14.02.38.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 02:38:52 -0700 (PDT)
Date:   Fri, 14 Oct 2022 05:38:49 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Yury Norov <yury.norov@gmail.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Menglong Dong <imagedong@tencent.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Petr Machata <petrm@nvidia.com>,
        Guo Ren <guoren@linux.alibaba.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] net: fix opencoded for_each_and_bit() in
 __netif_set_xps_queue()
Message-ID: <20221014053814-mutt-send-email-mst@kernel.org>
References: <20221013234349.1165689-1-yury.norov@gmail.com>
 <20221013234349.1165689-5-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221013234349.1165689-5-yury.norov@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 13, 2022 at 04:43:48PM -0700, Yury Norov wrote:
> Replace opencoded bitmap traversing and drop unused
> netif_attrmask_next*() functions
> 
> Signed-off-by: Yury Norov <yury.norov@gmail.com>

I think you want to document, here, that this fixes a warning.
Additionally, add a Fixes: tag.


> ---
>  include/linux/netdevice.h | 46 ---------------------------------------
>  net/core/dev.c            |  3 +--
>  2 files changed, 1 insertion(+), 48 deletions(-)
> 
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 53d738f66159..5db2b6de7308 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -3648,52 +3648,6 @@ static inline bool netif_attr_test_online(unsigned long j,
>  
>  	return (j < nr_bits);
>  }
> -
> -/**
> - *	netif_attrmask_next - get the next CPU/Rx queue in a cpu/Rx queues mask
> - *	@n: CPU/Rx queue index
> - *	@srcp: the cpumask/Rx queue mask pointer
> - *	@nr_bits: number of bits in the bitmask
> - *
> - * Returns >= nr_bits if no further CPUs/Rx queues set.
> - */
> -static inline unsigned int netif_attrmask_next(int n, const unsigned long *srcp,
> -					       unsigned int nr_bits)
> -{
> -	/* n is a prior cpu */
> -	cpu_max_bits_warn(n + 1, nr_bits);
> -
> -	if (srcp)
> -		return find_next_bit(srcp, nr_bits, n + 1);
> -
> -	return n + 1;
> -}
> -
> -/**
> - *	netif_attrmask_next_and - get the next CPU/Rx queue in \*src1p & \*src2p
> - *	@n: CPU/Rx queue index
> - *	@src1p: the first CPUs/Rx queues mask pointer
> - *	@src2p: the second CPUs/Rx queues mask pointer
> - *	@nr_bits: number of bits in the bitmask
> - *
> - * Returns >= nr_bits if no further CPUs/Rx queues set in both.
> - */
> -static inline int netif_attrmask_next_and(int n, const unsigned long *src1p,
> -					  const unsigned long *src2p,
> -					  unsigned int nr_bits)
> -{
> -	/* n is a prior cpu */
> -	cpu_max_bits_warn(n + 1, nr_bits);
> -
> -	if (src1p && src2p)
> -		return find_next_and_bit(src1p, src2p, nr_bits, n + 1);
> -	else if (src1p)
> -		return find_next_bit(src1p, nr_bits, n + 1);
> -	else if (src2p)
> -		return find_next_bit(src2p, nr_bits, n + 1);
> -
> -	return n + 1;
> -}
>  #else
>  static inline int netif_set_xps_queue(struct net_device *dev,
>  				      const struct cpumask *mask,
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 8049e2ff11a5..b0fb592d51da 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -2592,8 +2592,7 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
>  		copy = true;
>  
>  	/* allocate memory for queue storage */
> -	for (j = -1; j = netif_attrmask_next_and(j, online_mask, mask, nr_ids),
> -	     j < nr_ids;) {
> +	for_each_and_bit(j, online_mask, mask ? : online_mask, nr_ids) {
>  		if (!new_dev_maps) {
>  			new_dev_maps = kzalloc(maps_sz, GFP_KERNEL);
>  			if (!new_dev_maps)
> -- 
> 2.34.1

