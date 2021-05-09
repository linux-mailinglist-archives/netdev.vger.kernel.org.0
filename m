Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB2D3778F5
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 00:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbhEIWMT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 May 2021 18:12:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbhEIWMS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 May 2021 18:12:18 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63796C061573
        for <netdev@vger.kernel.org>; Sun,  9 May 2021 15:11:14 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id c3so14061851oic.8
        for <netdev@vger.kernel.org>; Sun, 09 May 2021 15:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=myQVw89np4+hZbHk+MUQbcs29nedLhEONbPUxMmU6h0=;
        b=mhWf5PI6B+wGCtmdKX6k3ri5YdAgv4DEn47B89Z3lsXNaTjKQ1XamuSQhT0FoQF+mG
         31CgVJe89MZDs0E02eWYrtO9iBlYKnpeh/YVT+C19nR2I1UhFSjMo0LBvGcjeVbRDcj+
         KKlOzB/km24BOohPUXWTGjbi/nem9tiv29gRND7z/vA0azmKtJ5cl91z6gt2GZfdp1Ko
         C55X7ZXZUrfWGA+ZB5v2FWG1pnsJYVIYRbx7SvWdYMaNL6k4A83+JHVg8NryDvoQdSeX
         MdxG2xf1kyIKroOuQbSj+KEspdC53/KluK33g+rxEvfx8dDoxMnR4Tl5LNGnnfOj2/7s
         0WMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=myQVw89np4+hZbHk+MUQbcs29nedLhEONbPUxMmU6h0=;
        b=Rjx+95qfcZzf9ebxArIHGX39Xb9RVoDScr+pMz6QBMX3BZ9vWyWZvA70Z/LLaLHAYI
         xTndf684OYhBCVp04CtWH+O/8z+4sOjHRimFcPaRD6uYACHxjSs1NgfZ1rBgjPIRxb5Y
         Ae7RtpSMGsvmqoTP0KvTnM6nS2fLFov5HjfsrNNst/pk4QP6TGHILlk6pAnIEZD4vPLf
         9v6bUNm98VzUeT8fXFuMt5Km5IHguwbsN9jyGTQXGYli6E1oYgnW41yZ931UggB8gS6y
         nRsgNtpsFuwoy6/zYLjco7BqBIAVrPoyXz18UcLT5vR+63K36wihU/wDgMODMZ772Mnq
         JzlQ==
X-Gm-Message-State: AOAM531GPJJXdHua+rP9amiEIRy927DAouV+MQNQheZAi5zDdrqQnKQ2
        7Ed95VSHP6l87Yi19j7/HNX/57EKIIs=
X-Google-Smtp-Source: ABdhPJxljzoDMSOoJtkwI0bCsccsBUc7tfCGfFCmD3+WGQSJaTGT0Fp5d3bQKtn3DEQnHGPYLbRSFA==
X-Received: by 2002:aca:4f4a:: with SMTP id d71mr7550893oib.128.1620598273790;
        Sun, 09 May 2021 15:11:13 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:5d79:6512:fce6:88aa])
        by smtp.googlemail.com with ESMTPSA id w10sm2315345oou.35.2021.05.09.15.11.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 May 2021 15:11:13 -0700 (PDT)
Subject: Re: [PATCH iproute2] mptcp: avoid uninitialised errno usage
To:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org
References: <20210503103631.30694-1-fw@strlen.de>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b8d9cc70-7667-d2b3-50b6-0ef0ce041735@gmail.com>
Date:   Sun, 9 May 2021 16:11:11 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210503103631.30694-1-fw@strlen.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/3/21 4:36 AM, Florian Westphal wrote:
> The function called *might* set errno based on errno value in NLMSG_ERROR
> message, but in case no such message exists errno is left alone.
> 
> This may cause ip to fail with
>     "can't subscribe to mptcp events: Success"
> 
> on kernels that support mptcp but lack event support (all kernels <= 5.11).
> 
> Set errno to a meaningful value.  This will then still exit with the
> more specific 'permission denied' or some such when called by process
> that lacks CAP_NET_ADMIN on 5.12 and later.
> 
> Fixes: ff619e4fd370 ("mptcp: add support for event monitoring")
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  ip/ipmptcp.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/ip/ipmptcp.c b/ip/ipmptcp.c
> index 5f490f0026d9..504b5b2f5329 100644
> --- a/ip/ipmptcp.c
> +++ b/ip/ipmptcp.c
> @@ -491,6 +491,9 @@ out:
>  
>  static int mptcp_monitor(void)
>  {
> +	/* genl_add_mcast_grp may or may not set errno */
> +	errno = EOPNOTSUPP;
> +
>  	if (genl_add_mcast_grp(&genl_rth, genl_family, MPTCP_PM_EV_GRP_NAME) < 0) {
>  		perror("can't subscribe to mptcp events");
>  		return 1;
> 

Seems like this should be set in genl_add_mcast_grp vs its caller.
