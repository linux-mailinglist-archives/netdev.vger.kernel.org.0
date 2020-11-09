Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE812AC616
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 21:43:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730056AbgKIUny (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 15:43:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbgKIUnx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 15:43:53 -0500
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A7E4C0613CF;
        Mon,  9 Nov 2020 12:43:53 -0800 (PST)
Received: by mail-ot1-x342.google.com with SMTP id l36so10327862ota.4;
        Mon, 09 Nov 2020 12:43:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=ATlrc71eVmMN7dt7E+P5qZNg9suPptLNbqRD/l6+6aY=;
        b=plXr8QvaQSlpxzLlNSm4+pzsXkkyAtKZPCwYM1aC0PJbEZilntIxAgGEhXWqcn6vLa
         3Nqg/F9WarxyZrWos3e9JTl04CPbvzJ9FD5RJUNy7wPIdKbeRoEQOhZLBwyxcsbgm4iU
         5iMNIOLsZWyJijwkwFJY7/h6Jbx+V7XNhISDK2BCeYSL+m5hBXatXdb60px3Yyv5ykx2
         2+0dKIQZXbnfVAgLYWlDE1O+tjrX7dktDrDOSZ2O3bia7oakzgoD9cIhQy4enryWNy2d
         9XocgYlNGh3KdWanoMFigemtxu6qRXdUBJdgmK+xI/6CRAXDbDJhIE2wcxptAKa8OEKL
         lZIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=ATlrc71eVmMN7dt7E+P5qZNg9suPptLNbqRD/l6+6aY=;
        b=MbOi94odkSuTVqU07cgbMJUNpx5qbxqb98IZXtxypDqu3ZzAq458Nab7nHh5imE8lL
         pjfQg64TalHHOB3VAoYFte39eiI0aR350ismerl6xiUoXAIPZDUSqDNMjE366Dos6j0c
         8R3jHIk4OpD683baWMzkNoxqpUnEui5iFqln/aNVgTB59zE+IL5jgwnvFZFanuMk5pCh
         Thj/LnsGMFFFLr98HDF0SJMPqC8jDTC5ZF98Tcy4GIv/AKuwHi5LUTxd4R87tTrFoy4C
         +/Ag41ByG7xrJJwnKclQ7N5J/NEjiZfVEdvNvrNWYZrPkcc/ezQDSxqTW0jEXv9PLuTw
         nfjQ==
X-Gm-Message-State: AOAM530RA5pVSCVHwuYKSqXqYJPDdU4SbL1Fn8UCEbVAwcRhw3kKslFH
        dlBxS2nWPBGpyqMfq5Tgi+I=
X-Google-Smtp-Source: ABdhPJz/wqdJcgTVIkfvCa6luKlYzRUqzWrUKz0KdQ0nLjlP9/+xq7vt01xn7VVeytUYno4ZOqkZxQ==
X-Received: by 2002:a05:6830:22c9:: with SMTP id q9mr12509129otc.48.1604954632560;
        Mon, 09 Nov 2020 12:43:52 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id r24sm2748068otq.77.2020.11.09.12.43.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 12:43:51 -0800 (PST)
Date:   Mon, 09 Nov 2020 12:43:43 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com
Cc:     maciejromanfijalkowski@gmail.com, intel-wired-lan@lists.osuosl.org,
        bpf@vger.kernel.org
Message-ID: <5fa9a9ffc2ea3_8c0e208a2@john-XPS-13-9370.notmuch>
In-Reply-To: <1604498942-24274-5-git-send-email-magnus.karlsson@gmail.com>
References: <1604498942-24274-1-git-send-email-magnus.karlsson@gmail.com>
 <1604498942-24274-5-git-send-email-magnus.karlsson@gmail.com>
Subject: RE: [Intel-wired-lan] [PATCH bpf-next 4/6] xsk: introduce padding
 between more ring pointers
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Magnus Karlsson wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Introduce one cache line worth of padding between the consumer pointer
> and the flags field as well as between the flags field and the start
> of the descriptors in all the lockless rings. This so that the x86 HW
> adjacency prefetcher will not prefetch the adjacent pointer/field when
> only one pointer/field is going to be used. This improves throughput
> performance for the l2fwd sample app with 1% on my machine with HW
> prefetching turned on in the BIOS.
> 
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>

>  net/xdp/xsk_queue.h | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
> index cdb9cf3..74fac80 100644
> --- a/net/xdp/xsk_queue.h
> +++ b/net/xdp/xsk_queue.h
> @@ -18,9 +18,11 @@ struct xdp_ring {
>  	/* Hinder the adjacent cache prefetcher to prefetch the consumer
>  	 * pointer if the producer pointer is touched and vice versa.
>  	 */
> -	u32 pad ____cacheline_aligned_in_smp;
> +	u32 pad1 ____cacheline_aligned_in_smp;
>  	u32 consumer ____cacheline_aligned_in_smp;
> +	u32 pad2 ____cacheline_aligned_in_smp;
>  	u32 flags;
> +	u32 pad3 ____cacheline_aligned_in_smp;
>  };
>  
>  /* Used for the RX and TX queues for packets */
> -- 
> 2.7.4
> 
> _______________________________________________
> Intel-wired-lan mailing list
> Intel-wired-lan@osuosl.org
> https://lists.osuosl.org/mailman/listinfo/intel-wired-lan


