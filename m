Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4195961EFE7
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 11:04:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231643AbiKGKEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 05:04:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231226AbiKGKEm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 05:04:42 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D94A52BDD
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 02:03:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667815424;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WVPlGEN+jBge51QDdbzaYyCPALlfQ+WWPtMxuqvpef4=;
        b=Woy2xx5ZKaqqdnxdd9nJZSoAZjYnRSpOEjzJaG3LESXOXkI/GnZ5i8MivYQHddc/KMnZS3
        LWKYoXFG9l+tHCx5g7l7NQ52mM7F84BzFO2auW/QBOThCkfDWtHV/NQLNNeg+mK/us9plT
        a52lumYUAPbdcngFv7nIOc7+vCra1zc=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-482-3JJu2BpXOWK8lPLh8F11tQ-1; Mon, 07 Nov 2022 05:03:43 -0500
X-MC-Unique: 3JJu2BpXOWK8lPLh8F11tQ-1
Received: by mail-qk1-f200.google.com with SMTP id bp10-20020a05620a458a00b006fa29f253dcso9683408qkb.11
        for <netdev@vger.kernel.org>; Mon, 07 Nov 2022 02:03:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WVPlGEN+jBge51QDdbzaYyCPALlfQ+WWPtMxuqvpef4=;
        b=zQNxmJrVruzWLYNJqPeqb0nnXlMVyhBw1e1Jl1/QUSinW7oCy4/svOzZ7f3pcwp4Cy
         HpnsBNEptfV6LiGQanaljfjb19AcBwX1h9ntJC0qJritcvfhlP97cOjBAnyJKCDgSgPB
         Vp2SSnNZAg0r80ziC2tS3vyezfduBIdgwqk721z0Qm83xDo32fn4e58KWYGAcWHqePSl
         d1qgvt17t6rphyrI7VMrtB2k4nPMnKwlsA1DS9Vo05ChDyZbBa5VfiOG9q8vSatfMjPI
         yMlivwvf9GStXYreKM6dBt9IMe7z6UgqVXks1TMVGDiI+IoBbYnfMDBD5FRqUoFA7ROm
         iYBA==
X-Gm-Message-State: ACrzQf028k+3oUwzWvDxU0729hoj0uhEhXnIDK6/fuyB+g5NE1eyT8rD
        64Ma/i9WllSG7E/HmTqgc1isq25VWbeqmEuODc7ZxEE2sJK+cTYuIaXbe2ejcLXQjhl/AAsTepQ
        Q/DJ3pnSyLaILRfLW
X-Received: by 2002:a05:622a:4ccc:b0:3a5:26e0:f60a with SMTP id fa12-20020a05622a4ccc00b003a526e0f60amr674969qtb.372.1667815422482;
        Mon, 07 Nov 2022 02:03:42 -0800 (PST)
X-Google-Smtp-Source: AMsMyM62PPWp2Uq9IoITo3d8iLLiIlCa/zn3XXOskKLpd9PLhY01pkbQGZNM39qdXoj1iOf+c84DqQ==
X-Received: by 2002:a05:622a:4ccc:b0:3a5:26e0:f60a with SMTP id fa12-20020a05622a4ccc00b003a526e0f60amr674968qtb.372.1667815422153;
        Mon, 07 Nov 2022 02:03:42 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-124-216.dyn.eolo.it. [146.241.124.216])
        by smtp.gmail.com with ESMTPSA id t19-20020a05620a451300b006ce2c3c48ebsm6615197qkp.77.2022.11.07.02.03.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Nov 2022 02:03:41 -0800 (PST)
Message-ID: <77aa882a0ac72cf434ecb44590f83ab9ece3b2f8.camel@redhat.com>
Subject: Re: [PATCH v1 net-next 6/6] udp: Introduce optional per-netns hash
 table.
From:   Paolo Abeni <pabeni@redhat.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org
Date:   Mon, 07 Nov 2022 11:03:38 +0100
In-Reply-To: <20221104190612.24206-7-kuniyu@amazon.com>
References: <20221104190612.24206-1-kuniyu@amazon.com>
         <20221104190612.24206-7-kuniyu@amazon.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-11-04 at 12:06 -0700, Kuniyuki Iwashima wrote:
> The maximum hash table size is 64K due to the nature of the protocol. [0]
> It's smaller than TCP, and fewer sockets can cause a performance drop.
> 
> On an EC2 c5.24xlarge instance (192 GiB memory), after running iperf3 in
> different netns, creating 32Mi sockets without data transfer in the root
> netns causes regression for the iperf3's connection.
> 
>   uhash_entries		sockets		length		Gbps
> 	    64K		      1		     1		5.69
> 			    1Mi		    16		5.27
> 			    2Mi		    32		4.90
> 			    4Mi		    64		4.09
> 			    8Mi		   128		2.96
> 			   16Mi		   256		2.06
> 			   32Mi		   512		1.12
> 
> The per-netns hash table breaks the lengthy lists into shorter ones.  It is
> useful on a multi-tenant system with thousands of netns.  With smaller hash
> tables, we can look up sockets faster, isolate noisy neighbours, and reduce
> lock contention.
> 
> The max size of the per-netns table is 64K as well.  This is because the
> possible hash range by udp_hashfn() always fits in 64K within the same
> netns and we cannot make full use of the whole buckets larger than 64K.
> 
>   /* 0 < num < 64K  ->  X < hash < X + 64K */
>   (num + net_hash_mix(net)) & mask;
> 
> The sysctl usage is the same with TCP:
> 
>   $ dmesg | cut -d ' ' -f 6- | grep "UDP hash"
>   UDP hash table entries: 65536 (order: 9, 2097152 bytes, vmalloc)
> 
>   # sysctl net.ipv4.udp_hash_entries
>   net.ipv4.udp_hash_entries = 65536  # can be changed by uhash_entries
> 
>   # sysctl net.ipv4.udp_child_hash_entries
>   net.ipv4.udp_child_hash_entries = 0  # disabled by default
> 
>   # ip netns add test1
>   # ip netns exec test1 sysctl net.ipv4.udp_hash_entries
>   net.ipv4.udp_hash_entries = -65536  # share the global table
> 
>   # sysctl -w net.ipv4.udp_child_hash_entries=100
>   net.ipv4.udp_child_hash_entries = 100
> 
>   # ip netns add test2
>   # ip netns exec test2 sysctl net.ipv4.udp_hash_entries
>   net.ipv4.udp_hash_entries = 128  # own a per-netns table with 2^n buckets
> 
> We could optimise the hash table lookup/iteration further by removing
> the netns comparison for the per-netns one in the future.  Also, we
> could optimise the sparse udp_hslot layout by putting it in udp_table.
> 
> [0]: https://lore.kernel.org/netdev/4ACC2815.7010101@gmail.com/
> 
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
>  Documentation/networking/ip-sysctl.rst |  27 ++++++
>  include/linux/udp.h                    |   2 +
>  include/net/netns/ipv4.h               |   2 +
>  net/ipv4/sysctl_net_ipv4.c             |  38 ++++++++
>  net/ipv4/udp.c                         | 119 ++++++++++++++++++++++---
>  5 files changed, 178 insertions(+), 10 deletions(-)
> 
> diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
> index 815efc89ad73..ea788ef4def0 100644
> --- a/Documentation/networking/ip-sysctl.rst
> +++ b/Documentation/networking/ip-sysctl.rst
> @@ -1177,6 +1177,33 @@ udp_rmem_min - INTEGER
>  udp_wmem_min - INTEGER
>  	UDP does not have tx memory accounting and this tunable has no effect.
>  
> +udp_hash_entries - INTEGER
> +	Show the number of hash buckets for UDP sockets in the current
> +	networking namespace.
> +
> +	A negative value means the networking namespace does not own its
> +	hash buckets and shares the initial networking namespace's one.
> +
> +udp_child_ehash_entries - INTEGER
> +	Control the number of hash buckets for UDP sockets in the child
> +	networking namespace, which must be set before clone() or unshare().
> +
> +	If the value is not 0, the kernel uses a value rounded up to 2^n
> +	as the actual hash bucket size.  0 is a special value, meaning
> +	the child networking namespace will share the initial networking
> +	namespace's hash buckets.
> +
> +	Note that the child will use the global one in case the kernel
> +	fails to allocate enough memory.  In addition, the global hash
> +	buckets are spread over available NUMA nodes, but the allocation
> +	of the child hash table depends on the current process's NUMA
> +	policy, which could result in performance differences.
> +
> +	Possible values: 0, 2^n (n: 0 - 16 (64K))

If you constraint the non-zero minum size to UDP_HTABLE_SIZE_MIN - not
sure if that makes sense - than you could avoid dynamically allocating
the bitmap in udp_lib_get_port(). 

Cheers,

Paolo

