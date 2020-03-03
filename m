Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B258617702A
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 08:34:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727531AbgCCHeH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 02:34:07 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:37152 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725440AbgCCHeG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 02:34:06 -0500
Received: by mail-pj1-f65.google.com with SMTP id o2so953129pjp.2
        for <netdev@vger.kernel.org>; Mon, 02 Mar 2020 23:34:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rWGkVzfNq4Riqmna6CVPp//6p5hLx/K1WoWmeuoIzOk=;
        b=s9N+8RCoJ0Ci5zG0hQznqV2olBCwASJKVzIPVHIVzLrdUyZ2y/lnuudRdV4Ap/66Wv
         Q9KUbIQ2HqRg6cnVf7fT+vHBXiJ466QYqzCyDcSpI5WZa1fmTztoE8F+2ZykPNiJ7elO
         0nWbyW91DHs1d2vMqHjzKwR9bOV6KK91JIcwZhOCvogwJXx2aY8pyjnN4/TnN9MGBwfj
         Xw1TvUEViQth7W2kMervXb/CeBhKETYyiK5KuhkQRz4fWgzctNOzJj0U4OmX0pAZsdDj
         TLVvJRn3240L9e2md9hNVVtSIvvlBUpgHlGrJ2Xtu7+Turg6qZC2yqUVudN34JfnBu0c
         XFAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rWGkVzfNq4Riqmna6CVPp//6p5hLx/K1WoWmeuoIzOk=;
        b=XT5wRziKrAIPbE0CD0zDWbAvsOE+PxnU6cDTaJ6asULg67iaV8j8xw5p4+BSMFBTVn
         +u8KX9JcXs99axu23E/itXEFl2k9Z82lX44bJuwqfAubTveE3+08KRarsDdYK70W52Nr
         pCD3BdfrMFectWiA2FXy0wGmdnk3pr0NDHKXIJsuv2DUr06VjO3DG1Dtiq9GrKs4CJx+
         wYnkftj8VfeKGrsI0+hx88jyFfbRDij5CwbF/Nl6oNS95n9FjqlUbj9Yhid6fvPFpss2
         6ClM1nzPOZ/sODbZdu60bGiUR+mGztgFVo7sxyai4Mi1QBzy6zlQbnBqvd60JPy+pAam
         n4tA==
X-Gm-Message-State: ANhLgQ3nqt9lVYygwgD5XOXMuiLaBVlQeRdI+N9lYD/pFV4suLjMF5Dd
        uGXDT30loc7y3W6Zf+xeKiKLxekL
X-Google-Smtp-Source: ADFU+vtoRqa3BX5bYodcEOid7qGvZbgUoohHmMe7Jc4wN8idKDFOSHC0hfLSRDV+JQf9cTwIclq4ew==
X-Received: by 2002:a17:90a:20cf:: with SMTP id f73mr2663839pjg.42.1583220844317;
        Mon, 02 Mar 2020 23:34:04 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id q21sm24259495pff.105.2020.03.02.23.34.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2020 23:34:03 -0800 (PST)
Subject: Re: [PATCH] ipv6: Use math to point per net sysctls into the
 appropriate struct net
To:     Cambda Zhu <cambda@linux.alibaba.com>,
        netdev <netdev@vger.kernel.org>
Cc:     Dust Li <dust.li@linux.alibaba.com>,
        Tony Lu <tonylu@linux.alibaba.com>
References: <20200303065434.81842-1-cambda@linux.alibaba.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <50eaac61-2ae1-bd6e-bb07-d574f137e581@gmail.com>
Date:   Mon, 2 Mar 2020 23:34:01 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200303065434.81842-1-cambda@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/2/20 10:54 PM, Cambda Zhu wrote:
> The data pointers of ipv6 sysctl are set one by one which is hard to
> maintain, especially with kconfig. This patch simplifies it by using
> math to point the per net sysctls into the appropriate struct net,
> just like what we did for ipv4.
> 
> Signed-off-by: Cambda Zhu <cambda@linux.alibaba.com>
> ---
>  net/ipv6/sysctl_net_ipv6.c | 20 ++++----------------
>  1 file changed, 4 insertions(+), 16 deletions(-)
>


Reviewed-by: Eric Dumazet <edumazet@google.com>

Please add the intended tree (net-next in this case) for your next patches.

Documentation/networking/netdev-FAQ.rst

