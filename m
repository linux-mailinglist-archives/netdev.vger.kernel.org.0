Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F22E01C4625
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 20:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbgEDSmA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 14:42:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727100AbgEDSl7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 14:41:59 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B39CEC061A10
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 11:41:59 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id f7so5960970pfa.9
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 11:41:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=W2tJ5b2t7hczpaAxFKlCfGf3HMAY03e+dltiT1wWRtw=;
        b=ZeNPUEFJK3Vzqz+6/aS6puuqVk/a8cosOmqzD7wITSt0oXSXn2EHXgOrzGqV7NeV1U
         tpNtoJ8OFz+o7A+cLKtE7CTdGQP15Cv/jR2PAAT/RkIvE7i4pWJs/yQJ9GoGzWr77iYi
         GoWITCOXJw3bA0fVyTcdTrgnW0VyEa9wuf8no=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=W2tJ5b2t7hczpaAxFKlCfGf3HMAY03e+dltiT1wWRtw=;
        b=jOS1XM8GRcCNCds5IRzq9RzPnCRF/i+1tx6c1KZ7wRjQyO/+ncx1A+ZAozLt3nEHiB
         MfgJGNUBO/YUgqfIbawiW8MEZFhBZzQdqCperFgkU5ID2NTfS3L8JK9wurJgrU/dBgr9
         d3dnAA4n8TN9541QwGb4FgqWwPib005+IXHT/UvlLWEKfBAQvMhbz4tGse4Pr1GKp4iD
         64xsnDdHM2SeXl//ElPuQjE14ZBp41PmySbtPFI61g736j1mDMGzNJ9qZc5Xa8oZ0WUx
         S+5Q8h6FtwKomAm+ETacFOMdS/+G9Wdw+dLylEmfmJm5bVASIFhWq34Y12CWp0As80ov
         6cLQ==
X-Gm-Message-State: AGi0PuY+DTZahyVOTaGSDNCTuMXcdQhHoJNWf0Iwp6uvck+jB/isUGqe
        X1Fj9bM0e2A0+U34CmqqsJzu7Q==
X-Google-Smtp-Source: APiQypIZef/BfkRBu20SORWfQDfii5L/7CKWSh4JL4l2QaSNhCzuiGlsdosd5WC0raG1OkKCcKBJ1A==
X-Received: by 2002:a62:4ec6:: with SMTP id c189mr19147132pfb.299.1588617719212;
        Mon, 04 May 2020 11:41:59 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id q6sm9253995pfh.193.2020.05.04.11.41.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 11:41:58 -0700 (PDT)
Date:   Mon, 4 May 2020 11:41:57 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Iurii Zaikin <yzaikin@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 2/5] mm: remove watermark_boost_factor_sysctl_handler
Message-ID: <202005041141.DA134ED931@keescook>
References: <20200424064338.538313-1-hch@lst.de>
 <20200424064338.538313-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200424064338.538313-3-hch@lst.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 24, 2020 at 08:43:35AM +0200, Christoph Hellwig wrote:
> watermark_boost_factor_sysctl_handler is just a pointless wrapper for
> proc_dointvec_minmax, so remove it and use proc_dointvec_minmax
> directly.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> Acked-by: David Rientjes <rientjes@google.com>
> ---
>  include/linux/mmzone.h |  2 --
>  kernel/sysctl.c        |  2 +-
>  mm/page_alloc.c        | 12 ------------
>  3 files changed, 1 insertion(+), 15 deletions(-)
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 1b9de7d220fb7..f37bb8f187fc7 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -911,8 +911,6 @@ static inline int is_highmem(struct zone *zone)
>  struct ctl_table;
>  int min_free_kbytes_sysctl_handler(struct ctl_table *, int,
>  					void __user *, size_t *, loff_t *);
> -int watermark_boost_factor_sysctl_handler(struct ctl_table *, int,
> -					void __user *, size_t *, loff_t *);
>  int watermark_scale_factor_sysctl_handler(struct ctl_table *, int,
>  					void __user *, size_t *, loff_t *);
>  extern int sysctl_lowmem_reserve_ratio[MAX_NR_ZONES];
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index 8a176d8727a3a..99d27acf46465 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -1491,7 +1491,7 @@ static struct ctl_table vm_table[] = {
>  		.data		= &watermark_boost_factor,
>  		.maxlen		= sizeof(watermark_boost_factor),
>  		.mode		= 0644,
> -		.proc_handler	= watermark_boost_factor_sysctl_handler,
> +		.proc_handler	= proc_dointvec_minmax,
>  		.extra1		= SYSCTL_ZERO,
>  	},
>  	{
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 69827d4fa0527..62c1550cd43ec 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -7978,18 +7978,6 @@ int min_free_kbytes_sysctl_handler(struct ctl_table *table, int write,
>  	return 0;
>  }
>  
> -int watermark_boost_factor_sysctl_handler(struct ctl_table *table, int write,
> -	void __user *buffer, size_t *length, loff_t *ppos)
> -{
> -	int rc;
> -
> -	rc = proc_dointvec_minmax(table, write, buffer, length, ppos);
> -	if (rc)
> -		return rc;
> -
> -	return 0;
> -}
> -
>  int watermark_scale_factor_sysctl_handler(struct ctl_table *table, int write,
>  	void __user *buffer, size_t *length, loff_t *ppos)
>  {
> -- 
> 2.26.1
> 

-- 
Kees Cook
