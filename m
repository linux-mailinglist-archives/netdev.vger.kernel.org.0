Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EAF93C5CF4
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 15:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231509AbhGLNKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 09:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230324AbhGLNKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 09:10:16 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DD27C0613DD
        for <netdev@vger.kernel.org>; Mon, 12 Jul 2021 06:07:27 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id d9-20020a17090ae289b0290172f971883bso12122038pjz.1
        for <netdev@vger.kernel.org>; Mon, 12 Jul 2021 06:07:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VmLMRAdZy3hQP9GGNlz2nQouOvsxH/a/0sPti3S3q8E=;
        b=ZLn+XfK/tPeRtrrC+NvOXnucaWSXoY3eG/0ajArZpqMccIBCxxUaJ/6/qi+1kawYat
         nEZwNar5WZFmc8o8Qg5+2VLeTb8hICZOXwLZVFZa86b4GIoYL3zf6uJaW5Ka28XFEc53
         VwWTYrO8d0VFeDl39L/I9yjsOzK4DhI07VTH09XX5eUqXxMlXjZ/MRfBm/GXWNq7ngR2
         gFy664aE3FI/jYtb7obUNf3chv/SStban/ANeS2jg/U/dugPM+MlTfp/EG57JFEVgPMv
         AI8b9jlvqP3YhWmu7OPz0+knwngjPRGekBDa9HvuJbM3wddpKN2HnP9IaqVPFLhkpwhV
         dShQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VmLMRAdZy3hQP9GGNlz2nQouOvsxH/a/0sPti3S3q8E=;
        b=kAsI189Qszr1C9Hso6PRcnabbCsDwASu5g6KMk6JjGig0qh5C4kiHvvISXXPdq1sNQ
         v+62E9P8AFaPW236dedtPfoqrBBYA9ykgLf/AcNol/Z9aorbucnUF+FN20PpQEJxJMN9
         4Ns1rYZiGgdS8LMG+qAgu9KLcn1VxwwYpRMLfYb5Jv541mzEprU6HAZHrwg/pZgBK7WC
         EY5ATmeNn+m3+RYb6uCPEKEuYuF3KCvUTWhqw817VVIPlyPbi6l9LUsTBzeeJObF4/Q3
         lPZQWMDqjP4z0/VUalUuvX9lmZ5Eul0x/6OHaciKK5dw4A+ZuEuFMTbg3bERxeQGiWUi
         E95Q==
X-Gm-Message-State: AOAM531wKz6VJcP0Ar+dJVFTUApFjuypj2ivPLwRxp74F+uXlEvExpV6
        wW/WTOsftm6Q4N9bo00z7so=
X-Google-Smtp-Source: ABdhPJwaX6sVWyTSCoXuQjWQhe2wxF12pEyspDyI0hsVPfLtqfLE6GB7OJCWVwOBPduDcZK/SZ7Idw==
X-Received: by 2002:a17:902:e00e:b029:ef:5f1c:18a8 with SMTP id o14-20020a170902e00eb02900ef5f1c18a8mr43770964plo.38.1626095247141;
        Mon, 12 Jul 2021 06:07:27 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t2sm15676731pfg.73.2021.07.12.06.07.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 06:07:26 -0700 (PDT)
Date:   Mon, 12 Jul 2021 21:07:21 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Roi Dayan <roid@nvidia.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Paul Blakey <paulb@nvidia.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Roman Mashak <mrv@mojatatu.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH iproute2 1/1] police: Fix normal output back to what it
 was
Message-ID: <YOw+idokpmoLYI59@Laptop-X1>
References: <20210712122653.100652-1-roid@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210712122653.100652-1-roid@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Roi,

Thanks for the fix up.

Regards
Hangbin

On Mon, Jul 12, 2021 at 03:26:53PM +0300, Roi Dayan wrote:
> With the json support fix the normal output was
> changed. set it back to what it was.
> Print overhead with print_size().
> Print newline before ref.
> 
> Fixes: 0d5cf51e0d6c ("police: Add support for json output")
> Signed-off-by: Roi Dayan <roid@nvidia.com>
> ---
>  tc/m_police.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/tc/m_police.c b/tc/m_police.c
> index 2594c08979e0..f38ab90a3039 100644
> --- a/tc/m_police.c
> +++ b/tc/m_police.c
> @@ -278,7 +278,7 @@ static int print_police(struct action_util *a, FILE *f, struct rtattr *arg)
>  	__u64 rate64, prate64;
>  	__u64 pps64, ppsburst64;
>  
> -	print_string(PRINT_ANY, "kind", "%s", "police");
> +	print_string(PRINT_JSON, "kind", "%s", "police");
>  	if (arg == NULL)
>  		return 0;
>  
> @@ -301,7 +301,8 @@ static int print_police(struct action_util *a, FILE *f, struct rtattr *arg)
>  	    RTA_PAYLOAD(tb[TCA_POLICE_RATE64]) >= sizeof(rate64))
>  		rate64 = rta_getattr_u64(tb[TCA_POLICE_RATE64]);
>  
> -	print_uint(PRINT_ANY, "index", "\t index %u ", p->index);
> +	print_hex(PRINT_FP, NULL, " police 0x%x ", p->index);
> +	print_uint(PRINT_JSON, "index", NULL, p->index);
>  	tc_print_rate(PRINT_FP, NULL, "rate %s ", rate64);
>  	buffer = tc_calc_xmitsize(rate64, p->burst);
>  	print_size(PRINT_FP, NULL, "burst %s ", buffer);
> @@ -342,12 +343,13 @@ static int print_police(struct action_util *a, FILE *f, struct rtattr *arg)
>  		print_string(PRINT_FP, NULL, " ", NULL);
>  	}
>  
> -	print_uint(PRINT_ANY, "overhead", "overhead %u ", p->rate.overhead);
> +	print_size(PRINT_ANY, "overhead", "overhead %s ", p->rate.overhead);
>  	linklayer = (p->rate.linklayer & TC_LINKLAYER_MASK);
>  	if (linklayer > TC_LINKLAYER_ETHERNET || show_details)
>  		print_string(PRINT_ANY, "linklayer", "linklayer %s ",
>  			     sprint_linklayer(linklayer, b2));
> -	print_int(PRINT_ANY, "ref", "ref %d ", p->refcnt);
> +	print_nl();
> +	print_int(PRINT_ANY, "ref", "\tref %d ", p->refcnt);
>  	print_int(PRINT_ANY, "bind", "bind %d ", p->bindcnt);
>  	if (show_stats) {
>  		if (tb[TCA_POLICE_TM]) {
> -- 
> 2.26.2
> 
