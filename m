Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4871804C6
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 18:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbgCJR2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 13:28:44 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:45985 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726545AbgCJR2o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 13:28:44 -0400
Received: by mail-pf1-f195.google.com with SMTP id 2so6792439pfg.12
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 10:28:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=85mpITor3DBfZO34mZpSb2mMG7zPN3sobejB0UlFOfs=;
        b=IswQGGT5AU9t0xhUGG1dWBNaAKNuNwzBFWN8qbMZAPjfXf6TQvZBPb1PxqpHFcQKS3
         ZBr6wO7VXJaL5AfORuuGc05Z9nFf4CnbiocpBCtDk5OqZ3U3SEgRWbivLgKHNtackR1L
         sfAumzLMaSXTL+mGuI+20bxcbf7+ZAZ7UWO+VpFJHDs8SUC+iDm6wLjZRW1+UeeYgMz3
         NeGh0ehoIFG7kzQBIJO8ScupQ8AuSqSPcXi5fPSXnsDxY2s7jqbWlb4EaoHf/autZw+D
         xOmcsvG7MlwjOiuuIPuQN7Jv8Z5eVOSisnxwYIT1Po7WQafBU4/FVEIT2+qFcziCP5nn
         QpBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=85mpITor3DBfZO34mZpSb2mMG7zPN3sobejB0UlFOfs=;
        b=ZQxejr/SRqnJKOu2amIMQcWdxixd95m/LHfR2Xd4mSNKdSyyY9Qpyxn1HSIK4wvQW6
         X2G3NC8AdjX4AdiPcUVwRS0By696HaXq+nRGOeSX7eRXFbiPw9qlFv+NiUv84CxPhBVG
         4nG4vipLI5YkIk8VUwPK1rjneQKwjf0yJSqrXLqOo6ol0PJz4C6h6ghMBGBfEVXaauGf
         d3RCWJ6421gsWsSgnvTo+3lHz5J+vkhKmLoHXlsGR0qiDiP0Ff2b4V0IGXRwXKh+4Axp
         WpdX5uFn7eqERIkpDOlrARgjlHdaaUmFccUpQOrx1SEGLwOD47HnG6P5rH8nlrsQhCDL
         ojYQ==
X-Gm-Message-State: ANhLgQ1Z8R0f34Lc1S5ezc3b+Aoat2eF1uuzwgw2T+kUL2vYaJYBvaiE
        4BkFaW3E/TWDe+0yzlLc9RaI1VlU
X-Google-Smtp-Source: ADFU+vtWSkGfWNXKUvsx0m65nbJSUOhaE/P7ujEohKGteiqWhPsLBkRKh96dzr2VDx2tNQEKohqKJA==
X-Received: by 2002:a63:6907:: with SMTP id e7mr21999518pgc.445.1583861323027;
        Tue, 10 Mar 2020 10:28:43 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id k1sm44913752pgt.70.2020.03.10.10.28.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Mar 2020 10:28:42 -0700 (PDT)
Subject: Re: [PATCH net-next] bareudp: Fixed bareudp receive handling
To:     Martin Varghese <martinvarghesenokia@gmail.com>,
        netdev@vger.kernel.org, davem@davemloft.net,
        martin.varghese@nokia.com, Taehee Yoo <ap420073@gmail.com>
References: <1583859760-18364-1-git-send-email-martinvarghesenokia@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <89faace0-7c11-b338-282b-b9e409677ba4@gmail.com>
Date:   Tue, 10 Mar 2020 10:28:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <1583859760-18364-1-git-send-email-martinvarghesenokia@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/10/20 10:02 AM, Martin Varghese wrote:
> From: Martin Varghese <martin.varghese@nokia.com>
> 
> Reverted commit "2baecda bareudp: remove unnecessary udp_encap_enable() in
> bareudp_socket_create()"
> 
> An explicit call to udp_encap_enable is needed as the setup_udp_tunnel_sock
> does not call udp_encap_enable if the if the socket is of type v6.
> 
> Bareudp device uses v6 socket to receive v4 & v6 traffic
> 
> Signed-off-by: Martin Varghese <martin.varghese@nokia.com>
> Fixes: 2baecda37f4e ("bareudp: remove unnecessary udp_encap_enable() in bareudp_socket_create()")

Please CC the author of recent patches, do not hide,
and to be clear, it is not about blaming, just information.

> ---
>  drivers/net/bareudp.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
> index 71a2f48..c9d0d68 100644
> --- a/drivers/net/bareudp.c
> +++ b/drivers/net/bareudp.c
> @@ -250,6 +250,9 @@ static int bareudp_socket_create(struct bareudp_dev *bareudp, __be16 port)
>  	tunnel_cfg.encap_destroy = NULL;
>  	setup_udp_tunnel_sock(bareudp->net, sock, &tunnel_cfg);
>  

This might need a comment. 

Can this condition be false ?

According to your changelog, it seems not.

Give to reviewers more chance to avoid future mistakes.

Thanks.

> +	if (sock->sk->sk_family == AF_INET6)
> +		udp_encap_enable();
> +
>  	rcu_assign_pointer(bareudp->sock, sock);
>  	return 0;
>  }
> 
