Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C95AD1B617A
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 19:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729797AbgDWRAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 13:00:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729687AbgDWRAA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 13:00:00 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C2D3C09B042
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 09:59:59 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id h69so3180525pgc.8
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 09:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qPDyQbH2csrPjyijNb4DGQAnpNF+izTvcqYbBKf9PCc=;
        b=AA5vNJ8SRKmX/xN92MN5AbUdaFKYZWv890HhVt6JzAqwAdRrqaABAdbJwHLso75iBn
         5CMsxrp2VnEI5VhOaflriqL0sJhmsl/iIvqxrpGspEN0avgk24cmMrlSJRu3OF63XOVV
         CtbwE+Gs1KP3YTnGLLxav9VZjTc72CQASRSsfTD+aD9x8Mxv2otWkykC6sjUy+5OWciP
         zUj0tsu1bzZBevfo5aM2k5XN1SoVhT4xJniYNyTOW8sbar/Zp3zGEuDXylXMikqJgmZ7
         V6fpYrK9swp1LdEeBFo3aEgnsQjFJxGds57cY4Onalo1k+eSz7wfqsnGM7ryrg/6oYiy
         7PyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qPDyQbH2csrPjyijNb4DGQAnpNF+izTvcqYbBKf9PCc=;
        b=J9c2bR63vYd7CYltvq/bz75sfx5qAG7UAJulVUknhyTmHNWq+mZTbbngFeDMyC7ZK9
         NNys/KbpRRATNdlz2vFyrtC3k98+bq7qOIxBUA8SriB/VdZlQqHC9G/8sa8XjWa1S2/G
         c1VMnUsGXdt7aLI+kZ4shXcwWlEZw7KRCu+XDmIis5Odrfs38PzGNku0CcI2dysDsTOH
         5gssHULuJseqxEmC8J5uQ8+AYfDK2frD2GpW+YlRiJLhelv3wDN5bCqg9XWZofjFh3QG
         wGWmJ3MCfS4Wm9IXsKom9txYnOJ5Mvbr6aV0RQqCh+60Mdrtlk3kUEPqZaHuEj6rqFeF
         xi2w==
X-Gm-Message-State: AGi0PuZ1TCBEGntoLtjOUivDbNhtdltdAbvLDFgwcxf84EfU/nmidfy0
        G8lBVJTK6i/yXNC3cGKW51pxMUkW
X-Google-Smtp-Source: APiQypJR5KdS5PgtNeeUP7oQQ8SlvE9tG6HalwqsxSNcrZUTnodVOhJj1DSoWqIbIhbeLB+062tPpw==
X-Received: by 2002:a63:5511:: with SMTP id j17mr4741975pgb.4.1587661198759;
        Thu, 23 Apr 2020 09:59:58 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id v133sm3112815pfc.113.2020.04.23.09.59.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Apr 2020 09:59:58 -0700 (PDT)
Subject: Re: [PATCH net-next v2] net: Add TCP_FORCE_LINGER2 to TCP setsockopt
To:     Cambda Zhu <cambda@linux.alibaba.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Dust Li <dust.li@linux.alibaba.com>,
        Tony Lu <tonylu@linux.alibaba.com>
References: <eea2a2c3-79dc-131c-4ef5-ee027b30b701@gmail.com>
 <20200423073529.92152-1-cambda@linux.alibaba.com>
 <3e780f88-41df-413c-7a81-6a63fd750605@gmail.com>
 <256723ED-43E5-4123-B096-15AD417366CD@linux.alibaba.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <2df5f6de-ee68-8309-8b48-a139a4fb6b36@gmail.com>
Date:   Thu, 23 Apr 2020 09:59:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <256723ED-43E5-4123-B096-15AD417366CD@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/23/20 7:46 AM, Cambda Zhu wrote:
> 
> 
>> On Apr 23, 2020, at 21:40, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>
>>
>>
>> On 4/23/20 12:35 AM, Cambda Zhu wrote:
>>> This patch adds a new TCP socket option named TCP_FORCE_LINGER2. The
>>> option has same behavior as TCP_LINGER2, except the tp->linger2 value
>>> can be greater than sysctl_tcp_fin_timeout if the user_ns is capable
>>> with CAP_NET_ADMIN.
>>>
>>> As a server, different sockets may need different FIN-WAIT timeout and
>>> in most cases the system default value will be used. The timeout can
>>> be adjusted by setting TCP_LINGER2 but cannot be greater than the
>>> system default value. If one socket needs a timeout greater than the
>>> default, we have to adjust the sysctl which affects all sockets using
>>> the system default value. And if we want to adjust it for just one
>>> socket and keep the original value for others, all the other sockets
>>> have to set TCP_LINGER2. But with TCP_FORCE_LINGER2, the net admin can
>>> set greater tp->linger2 than the default for one socket and keep
>>> the sysctl_tcp_fin_timeout unchanged.
>>>
>>> Signed-off-by: Cambda Zhu <cambda@linux.alibaba.com>
>>> ---
>>> Changes in v2:
>>>   - Add int overflow check.
>>>
>>> include/uapi/linux/capability.h |  1 +
>>> include/uapi/linux/tcp.h        |  1 +
>>> net/ipv4/tcp.c                  | 11 +++++++++++
>>> 3 files changed, 13 insertions(+)
>>>
>>> diff --git a/include/uapi/linux/capability.h b/include/uapi/linux/capability.h
>>> index 272dc69fa080..0e30c9756a04 100644
>>> --- a/include/uapi/linux/capability.h
>>> +++ b/include/uapi/linux/capability.h
>>> @@ -199,6 +199,7 @@ struct vfs_ns_cap_data {
>>> /* Allow multicasting */
>>> /* Allow read/write of device-specific registers */
>>> /* Allow activation of ATM control sockets */
>>> +/* Allow setting TCP_LINGER2 regardless of sysctl_tcp_fin_timeout */
>>>
>>> #define CAP_NET_ADMIN        12
>>>
>>> diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
>>> index f2acb2566333..e21e0ce98ca1 100644
>>> --- a/include/uapi/linux/tcp.h
>>> +++ b/include/uapi/linux/tcp.h
>>> @@ -128,6 +128,7 @@ enum {
>>> #define TCP_CM_INQ		TCP_INQ
>>>
>>> #define TCP_TX_DELAY		37	/* delay outgoing packets by XX usec */
>>> +#define TCP_FORCE_LINGER2	38	/* Set TCP_LINGER2 regardless of sysctl_tcp_fin_timeout */
>>>
>>>
>>> #define TCP_REPAIR_ON		1
>>> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
>>> index 6d87de434377..d8cd1fd66bc1 100644
>>> --- a/net/ipv4/tcp.c
>>> +++ b/net/ipv4/tcp.c
>>> @@ -3149,6 +3149,17 @@ static int do_tcp_setsockopt(struct sock *sk, int level,
>>> 			tcp_enable_tx_delay();
>>> 		tp->tcp_tx_delay = val;
>>> 		break;
>>> +	case TCP_FORCE_LINGER2:
>>> +		if (val < 0)
>>> +			tp->linger2 = -1;
>>> +		else if (val > INT_MAX / HZ)
>>> +			err = -EINVAL;
>>> +		else if (val > net->ipv4.sysctl_tcp_fin_timeout / HZ &&
>>> +			 !ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN))
>>> +			tp->linger2 = 0;
>>> +		else
>>> +			tp->linger2 = val * HZ;
>>> +		break;
>>> 	default:
>>> 		err = -ENOPROTOOPT;
>>> 		break;
>>>
>>
>> INT_MAX looks quite 
>>
>> Anyway, I do not think we need a new socket option, since really it will need documentation and add more confusion.
>>
>> net->ipv4.sysctl_tcp_fin_timeout is the default value for sockets which have tp->linger2 cleared.
>>
>> Fact that it has been used to cap TCP_LINGER2 was probably a mistake.
>>
>> What about adding a new define and simply let TCP_LINGER2 use it ?
>>
>> Really there is no point trying to allow hours or even days for FIN timeout,
>> and no point limiting a socket from having a value between net->ipv4.sysctl_tcp_fin_timeout and 2 minutes,
>> at least from security perspective, these values seem legal as far as TCP specs are concerned.
>>
>>
> 
> I also think using sysctl_tcp_fin_timeout to cap TCP_LINGER2 is probably a mistake,
> and adding a new define for TCP_LINGER2 is a good idea. I have considered the solution
> and found it may have some compatibility issues. Whatever it’s a mistake or not, a
> system administrator may have used it to limit the max timeout for all sockets. And
> when I think about the behavior of TCP_LINGER2, I'm afraid the server may also rely on
> the behavior so the server can set any value greater than sysctl_tcp_fin_timeout and
> result in the same timeout.
> 
> Maybe my worry is unnecessary. If so, I think your suggestion is better.
>

Ṕlease send a v3 with a proper changelog then, thanks !

