Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B804649F67D
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 10:38:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347658AbiA1JiF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 04:38:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39732 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243726AbiA1JiE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 04:38:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643362683;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Bm7yntnZphNntlIzJBi7dLNf0/Xc6WFVcDglxuX1l/s=;
        b=aFTWP+WHhD7wEd7pzcmPON/wed9pvTsnpBLYhEZo0FyfuZE6lfS/QQkpKwBU6F+RmGh9vN
        6oPjdfEGRTz/zo/2+LdgoC2FHZo5tG0vUOlGcPtIJ2yHIUuJWctenctvSDFR+Umfa/ulWg
        YxZ2GjFPgS7HP130HQn0FAZ8oZgsPFA=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-548-3VmaSSbJMV-UwBGFAFCe9Q-1; Fri, 28 Jan 2022 04:38:01 -0500
X-MC-Unique: 3VmaSSbJMV-UwBGFAFCe9Q-1
Received: by mail-ej1-f72.google.com with SMTP id rl11-20020a170907216b00b006b73a611c1aso2597903ejb.22
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 01:38:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Bm7yntnZphNntlIzJBi7dLNf0/Xc6WFVcDglxuX1l/s=;
        b=YlIrgeGIp6TjJWpncLa39EC/XrCu88DTxtpVtFwUr/FHVBDKaBWoiWb0ds9pO03Qw9
         IyzqLHH2LbnHn3CQ4q5QH4ge3pLwkpi/+JBw8ZUtsycqPUcMzdRE6isi12ZVq7w3uir6
         KRQyMKcpPU+pqOOZQIorUZYo6aikDc1+kyskyQvj5yoTO4XGPl6gk30kb9PXYv8LUJSy
         e26Khfym0DvjO/JmjjdfTGAmFxwksekGZBKr2vWiSoxMm0UoyWV34PI2yGWcW27hRlgk
         avjYW9LJncCdzAlmKdVB0mp0rfjzX+rjZayxNVfMCxSfmgZz54U+AuGSYVXBFRztLlym
         M/dg==
X-Gm-Message-State: AOAM532D8J2kCDP9oAJCBV+YI7JoSYR3GU3VpIivTruUQl48uefmRQVv
        HvGtOfM+6a4nm6MjU1qnDvwG2UaS5qqeD2trqxgARZVigb7pLBsZVU6OXeHk20npom2XxFSGI+D
        oc+S0khlIVX8qIJVt
X-Received: by 2002:a05:6402:1d56:: with SMTP id dz22mr7685155edb.82.1643362679803;
        Fri, 28 Jan 2022 01:37:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxKe5ZRNHAS83VQrBS/4wBXr4dcTtl5PfFvJSOQogMXJPMGg8ZrekzVaiQ6a5cLAX7JhbRYjQ==
X-Received: by 2002:a05:6402:1d56:: with SMTP id dz22mr7685135edb.82.1643362679610;
        Fri, 28 Jan 2022 01:37:59 -0800 (PST)
Received: from krava ([83.240.63.12])
        by smtp.gmail.com with ESMTPSA id v14sm9782631ejy.77.2022.01.28.01.37.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 01:37:58 -0800 (PST)
Date:   Fri, 28 Jan 2022 10:37:56 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Masami Hiramatsu <mhiramat@kernel.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH v5 1/9] ftrace: Add ftrace_set_filter_ips function
Message-ID: <YfO5dLsrdRlN7D62@krava>
References: <164311269435.1933078.6963769885544050138.stgit@devnote2>
 <164311270629.1933078.4596694198103138848.stgit@devnote2>
 <20220125110659.2cc8df29@gandalf.local.home>
 <YfApT8uAoCODPAGu@krava>
 <20220128110523.de0e36317a34d48b793a7f6b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220128110523.de0e36317a34d48b793a7f6b@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 28, 2022 at 11:05:23AM +0900, Masami Hiramatsu wrote:

SNIP

> 
> So, I wrote a below change for the next version. Is that OK for you?
> 
> Thank you,
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index f305e18f699f..a28b1bdb234a 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -4985,8 +4985,13 @@ ftrace_match_addr(struct ftrace_hash *hash, unsigned long *ips,
>  
>  	for (i = 0; i < cnt; i++) {
>  		err = __ftrace_match_addr(hash, ips[i], remove);
> -		if (err)
> +		if (err) {
> +			/*
> +			 * This expects the @hash is a temporary hash and if this
> +			 * fails the caller must free the @hash.
> +			 */
>  			return err;
> +		}
>  	}
>  	return 0;
>  }
> @@ -5649,7 +5654,7 @@ int ftrace_set_filter_ip(struct ftrace_ops *ops, unsigned long ip,
>  EXPORT_SYMBOL_GPL(ftrace_set_filter_ip);
>  
>  /**
> - * ftrace_set_filter_ips - set a functions to filter on in ftrace by addresses
> + * ftrace_set_filter_ips - set functions to filter on in ftrace by addresses
>   * @ops - the ops to set the filter with
>   * @ips - the array of addresses to add to or remove from the filter.
>   * @cnt - the number of addresses in @ips

looks good, thanks

jirka

