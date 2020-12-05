Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC8D2CF9E9
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 06:51:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729044AbgLEFuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 00:50:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728524AbgLEFuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Dec 2020 00:50:11 -0500
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A92E7C0613D1
        for <netdev@vger.kernel.org>; Fri,  4 Dec 2020 21:49:31 -0800 (PST)
Received: by mail-ot1-x344.google.com with SMTP id h18so3470293otq.12
        for <netdev@vger.kernel.org>; Fri, 04 Dec 2020 21:49:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WM66GMMWtagFkbX1oRmt9QF2XS+W9f02i8b2YMtERO4=;
        b=IZlejxAtMW5TbydChEYLajsDivB4MdkaY/0SQxcdvKwInjeZL1q5/0u+FNVDyWDAHp
         w3L/u2SaIgsX446P2gHFmSKj6Y+TBp7DkQ62rhDikGgKWwUwq7DGMizBmVxiFgyWjmKT
         W7agx5mzLttyFdxgQd5Fqj/29O2uZ4HJPtMYoWYbGmab7cH2bxxuD/jQQpkZOhNGa8n7
         96sX5O4OPfZi2IX2gbLMd03Uzkxma1Eu5nn4CkPjJGIRD03yo7V9Wu8tbiqIRqWD30y+
         aOdiJE4BBbukVkmFdjj6OTufU6XQ/DwDUHSreewjNyaNaColwqsIbLdwoXCGi8hQENR6
         Lj8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WM66GMMWtagFkbX1oRmt9QF2XS+W9f02i8b2YMtERO4=;
        b=sDP8rlAn1+rBBTD6L94jxf7kPgyA+ynRT+9Jlh7q5qUbtPvYXnM/BMwZs8YhAGHbxn
         Mg0iqYpHARcmUr1gg1aF7m5ifDrMoqO+6U68sHcItSb8LDJ6pxxrTeLgwn6jVCGHC8cC
         b14byjwLjDGYW22Mm1Tx8YU2bR5uew1haBsC3ygL4EXlh+5Uv+J828ZQWtTMyvPaVC71
         pcn1Ezp1ODg20CKr5ip3ITIUxEIxT5gHYOK91tK6spAviEZLwt0COQJ6vl+FWWg8j4lL
         6l3h0ocCB9YH3x5AGa0S/xgivTUpKmkNg1rQl43PWSuPNaJ2uyTKnI9j5FBSUjwD/2y2
         QKsg==
X-Gm-Message-State: AOAM533RGP6O7yH9dKDi7AJbejDNnjdwrjt8d4OiZtClKkCyegWgX4w9
        4ZNb2N+OGTdLWwI1eDDYRf3kS+SnbJs=
X-Google-Smtp-Source: ABdhPJxF1MrgOVFD3mVETO4YCi1MXekZm9O9b5IJkLI9VSz+ZMrPnz87FJAIdw/s5o2+YKtb792JGw==
X-Received: by 2002:a9d:5381:: with SMTP id w1mr6134777otg.7.1607147370942;
        Fri, 04 Dec 2020 21:49:30 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.51])
        by smtp.googlemail.com with ESMTPSA id l72sm1192324oib.41.2020.12.04.21.49.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Dec 2020 21:49:30 -0800 (PST)
Subject: Re: [PATCH net-next 3/6] net: add sysctl for enabling RFC 8335 PROBE
 messages
To:     Andreas Roeseler <andreas.a.roeseler@gmail.com>,
        davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org
References: <cover.1607050388.git.andreas.a.roeseler@gmail.com>
 <1de8170c1b7dec795f8ca257fbd56c61c36ad5a2.1607050389.git.andreas.a.roeseler@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <322132d8-7971-da3a-0a9e-2df99c0ea5c4@gmail.com>
Date:   Fri, 4 Dec 2020 22:49:29 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <1de8170c1b7dec795f8ca257fbd56c61c36ad5a2.1607050389.git.andreas.a.roeseler@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/3/20 8:16 PM, Andreas Roeseler wrote:
> Section 8 of RFC 8335 specifies potential security concerns of
> responding to PROBE requests, and states that nodes that support PROBE
> functionality MUST be able to enable/disable responses and it is
> disabled by default. 
> 
> Add sysctl to enable responses to PROBE messages. 
> 
> Signed-off-by: Andreas Roeseler <andreas.a.roeseler@gmail.com>
> ---
>  include/net/netns/ipv4.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
> index 8e4fcac4df72..1d9b74228f3e 100644
> --- a/include/net/netns/ipv4.h
> +++ b/include/net/netns/ipv4.h
> @@ -85,6 +85,7 @@ struct netns_ipv4 {
>  #endif
>  
>  	int sysctl_icmp_echo_ignore_all;
> +	int sysctl_icmp_echo_enable_probe;
>  	int sysctl_icmp_echo_ignore_broadcasts;
>  	int sysctl_icmp_ignore_bogus_error_responses;
>  	int sysctl_icmp_ratelimit;
> 

this can be folded into patch 4; no need for a standalone patch here.
