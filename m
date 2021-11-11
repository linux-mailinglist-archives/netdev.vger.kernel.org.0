Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF0A44D541
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 11:47:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232366AbhKKKuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 05:50:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42327 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229668AbhKKKuK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 05:50:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636627640;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pyDrGqmON/n/q6IU8IL9X7rt0yALNx7dIH8hPvqilzM=;
        b=e0xTTbf4C59HMO0zb3dOFGzbN12uJ8TpHavdp9qTA1rAZsKqrRmNQQyH2ShkamuGEKPYVV
        TAksQNJbfCouFo6lsaJh+W+O0G8aoHhraXgxlbA28G87BPbC35z3R48Q7iv2eNU9ke1reb
        VnZ6F28+UTD63wWOCy6RhCiKxscvdUU=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-100-uDKJsbFaM4usLLwXNepGxQ-1; Thu, 11 Nov 2021 05:47:18 -0500
X-MC-Unique: uDKJsbFaM4usLLwXNepGxQ-1
Received: by mail-ed1-f70.google.com with SMTP id h18-20020a056402281200b003e2e9ea00edso5041458ede.16
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 02:47:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pyDrGqmON/n/q6IU8IL9X7rt0yALNx7dIH8hPvqilzM=;
        b=0+wpf8+RN8h/dJSrkr/D6CgtncvmhXvu6Gou0YQsCu0Jz0uPGpD/j6JjPHRiSNQ8o/
         PCeXy/JRf6SPxZIJHMCIsMqOE5uLG5ZAyd/2pyO0+l6n9ggizTsB0jRRSWk5OlnR6Hq/
         coU+l1SrAUVZuIfnZy+ugMkNsn3J5nh1gKxFuBO4cocY6QLtmnt5lzzFHCyRlPQ2baj/
         SZUPQ69gfmSVPVB+z/Siy+KbUu3ui3fn6b69XEXs31hQzYVFO3BxW+h0uClOEshQ+W36
         7ZkmvkT/82pALU9NjjBgj/kSrq3So4oCW3fvAySsM2VdJoYfKHHsc579SnZe/AluyCOD
         /9qg==
X-Gm-Message-State: AOAM533I+2gtLjNb3kmliSOovLC6/YWiRyWqY6642GQSxRXUwhwpb8YN
        epVDT4SdujCWUwNGy1KRFCmAyCyabdVpxNe98wDTqZ50Lv/265I06e+UA9GPJ5LioxW8SvwM1PP
        LYVnsNnMPGcpdQXbU
X-Received: by 2002:a05:6402:430a:: with SMTP id m10mr8446954edc.273.1636627637434;
        Thu, 11 Nov 2021 02:47:17 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw4Xd5mCRay9fNbkcBgVJWtyhaymlErwg47lytmoxMdfs8miHHDV/gs0B7Drrjf+Z0l8nlZkA==
X-Received: by 2002:a05:6402:430a:: with SMTP id m10mr8446937edc.273.1636627637279;
        Thu, 11 Nov 2021 02:47:17 -0800 (PST)
Received: from localhost ([37.160.14.1])
        by smtp.gmail.com with ESMTPSA id g1sm1108013eje.105.2021.11.11.02.47.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 02:47:17 -0800 (PST)
Date:   Thu, 11 Nov 2021 11:47:12 +0100
From:   Andrea Claudi <aclaudi@redhat.com>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] mptcp: fix JSON output when dumping endpoints
 by id
Message-ID: <YYz0sKInYk2mQV81@renaissance-vector>
References: <474b741a13ba1058dd991c4f68f68b99610dda2b.1636623282.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <474b741a13ba1058dd991c4f68f68b99610dda2b.1636623282.git.dcaratti@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 11, 2021 at 10:52:13AM +0100, Davide Caratti wrote:
> iproute ignores '-j' command line argument when dumping endpoints by id:
> 
>  [dcaratti@dcaratti iproute2]$ ./ip/ip -j mptcp endpoint show
>  [{"address":"1.2.3.4","id":42,"signal":true,"backup":true}]
>  [dcaratti@dcaratti iproute2]$ ./ip/ip -j mptcp endpoint show id 42
>  1.2.3.4 id 42 signal backup
> 
> fix mptcp_addr_show() to use the proper JSON helpers.
> 
> Fixes: 7e0767cd862b ("add support for mptcp netlink interface")
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
> ---
>  ip/ipmptcp.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/ip/ipmptcp.c b/ip/ipmptcp.c
> index 0f5b6e2d08ba..857004446aa3 100644
> --- a/ip/ipmptcp.c
> +++ b/ip/ipmptcp.c
> @@ -305,7 +305,11 @@ static int mptcp_addr_show(int argc, char **argv)
>  	if (rtnl_talk(&genl_rth, &req.n, &answer) < 0)
>  		return -2;
>  
> -	return print_mptcp_addr(answer, stdout);
> +	new_json_obj(json);
> +	ret = print_mptcp_addr(answer, stdout);
> +	delete_json_obj();
> +	fflush(stdout);
> +	return ret;
>  }
>  
>  static int mptcp_addr_flush(int argc, char **argv)
> -- 
> 2.31.1

Looks good to me.
Acked-by: Andrea Claudi <aclaudi@redhat.com>

