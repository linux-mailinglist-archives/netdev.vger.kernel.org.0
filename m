Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D31130B5A0
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 04:05:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbhBBDFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 22:05:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231262AbhBBDE6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 22:04:58 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2337C061573
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 19:04:12 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id h14so18513301otr.4
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 19:04:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=G/8LuigCOcSzsNTzP+VLtRoRvLUJt0dw+QisHs4scbM=;
        b=D+mI8aqPmLBG823cvYlscjeihOShGN+6Z8S9JukfyIzodLrfxz7nq81/M+RoivZQaU
         dlgDX7zn/HQDkQ5MO4NL8JSq6VcTAJVzv2ZV+0E6cuiq4ImeqgO4NYtFByWBxcEsa9xX
         WINYC3kd4QEi2nw+3tTX/WG5hrg3+K/jDCfgWhvKtaKnhipN5yGlvILp5DkI9ALbDTxZ
         gfyzS/0bdNzwkYxMdy4IzHbr6GONxUJ5Wu/f5x/fyzRLJvSiaccOULNGL2rM1mLpIlkL
         /Y6UkqY+tedUE+yItNL5vFSbRrJTxpLXCLHHtUZdWWedjiqnxz5ld8bb9TnM/MyNR2Us
         KyNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=G/8LuigCOcSzsNTzP+VLtRoRvLUJt0dw+QisHs4scbM=;
        b=DSBuKptg5Djm2BkIxFNVPnju2E0ent1VivdQnvXqeY/zdnOhIAsuN8S5QRNq1VhS6g
         EoHPJzsVW6Zdv9STSoYfvt9fC4JQrqz25BA0Mz8vBq8eS4fku5Bam3AcIKvBrBNRMxN+
         LaLJKs8NKNArMV8qTV/EbFWj1e6SXNrj1DulDe/DIcGIdpjkcoYBovA44HHkrxhvIOtd
         fwTD3m3nAX+8/auEtIDoeTZCc4jY9XKeJkkndZRIdl8WanmgxTPN+8BzMuu3uEHcZZnu
         2wuaRiEP8l+RvDFD4IbwKKLUAxKmbYCc1iEqORmbAjg8h7V3ZjsHxw9XBUByRa3UXwXY
         5auA==
X-Gm-Message-State: AOAM533IyQ7s4UzQ3QMb55wIIg8Qq2T3iB9Ne/1MR9S3RMudpOMRq4De
        CFpRugzvm4ZsB1rr0cIcXVjclDJ2qZw=
X-Google-Smtp-Source: ABdhPJzFlz0wJRvlLtX1QL1cOHUvJ1BSjoJa+llkuwOGoetlBBI4CGA54tQ2162LXWJh8a764Ed80g==
X-Received: by 2002:a9d:12e9:: with SMTP id g96mr8418932otg.158.1612235052053;
        Mon, 01 Feb 2021 19:04:12 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.50])
        by smtp.googlemail.com with ESMTPSA id c18sm4615673oov.20.2021.02.01.19.04.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Feb 2021 19:04:11 -0800 (PST)
Subject: Re: [PATCH iproute2-next] ss: always prefer family as part of host
 condition to default family
To:     Thayne McCombs <astrothayne@gmail.com>, netdev@vger.kernel.org
References: <20210131081728.29476-1-astrothayne@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <6d0eff35-b982-7d8d-d3c7-742411e93046@gmail.com>
Date:   Mon, 1 Feb 2021 20:04:10 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210131081728.29476-1-astrothayne@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/31/21 1:17 AM, Thayne McCombs wrote:
> diff --git a/misc/ss.c b/misc/ss.c
> index 0593627b..2a5e056a 100644
> --- a/misc/ss.c
> +++ b/misc/ss.c
> @@ -2119,24 +2119,39 @@ void *parse_hostcond(char *addr, bool is_port)
>  	int fam = preferred_family;
>  	struct filter *f = &current_filter;
>  
> -	if (fam == AF_UNIX || strncmp(addr, "unix:", 5) == 0) {
> +    if (strncmp(addr, "unix:", 5) == 0) {
> +        fam = AF_UNIX;
> +        addr += 5;
> +    } else if (strncmp(addr, "link:", 5) == 0) {
> +        fam = AF_PACKET;
> +        addr += 5;
> +    } else if (strncmp(addr, "netlink:", 8) == 0) {
> +        fam = AF_NETLINK;
> +        addr += 8;
> +    } else if (strncmp(addr, "vsock:", 6) == 0) {
> +        fam = AF_VSOCK;
> +        addr += 6;
> +    } else if (strncmp(addr, "inet:", 5) == 0) {
> +        fam = AF_INET;
> +        addr += 5;
> +    } else if (strncmp(addr, "inet6:", 6) == 0) {
> +        fam = AF_INET6;
> +        addr += 6;
> +    }
> +
> +	if (fam == AF_UNIX) {
>  		char *p;
>  

Looks fine to me, but you need to fix the coding style -- tabs, not spaces.

