Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1FA4460E2
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 09:50:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232804AbhKEIwp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 04:52:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232788AbhKEIwo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 04:52:44 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CFADC061203;
        Fri,  5 Nov 2021 01:50:05 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id v11so28044703edc.9;
        Fri, 05 Nov 2021 01:50:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=miJ0rDj8jMHnmzBCgBZcLItm2609iMUpxmfr/aGoC+4=;
        b=T0vvh3k6Fzd+A1OCPPxaQy6lxJQov68G5vCdJfRHGu++rPUoyTkXzI/me20ALqTrgZ
         MLjj3v3kqH3HlfdN5yJnQrrZfUnlzs/r8Or99ExWO7nkNR8NkthaSJOCrwysX2kRBrDG
         8/RfMVLFdId7tRb7ckR5Qj0xmYv/yL9Hd8Uajl3x/5K2co88Rb5hwAL+1eLy96k2Bg9k
         BWpvsnmIPN46U9PKrX18NKgw7SS5Gz6cKJUp8ATfN4fJUngJA8cd10agPnavKg2wJeUF
         5XqzHAzGhPWNx9E3X2Dzu9x5BQy//71WawqDJ/p3vEb41mMOpVvqZcfe+P+wIczkvfmq
         udXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=miJ0rDj8jMHnmzBCgBZcLItm2609iMUpxmfr/aGoC+4=;
        b=x/VpVuToMGVRllf+Ca2DdYHL+ml94YxxgB/gon7dlXVXlDC9XAjl4xD27JCC5eU1jr
         vjWxZRiBSWk5s+g26Qx1HxM6AFC3c+ItqZyHurI2VbbLz31d8PkOeb06cXGEeXkKSNbz
         A76wlmjUdYPLrPUJXEE+2lWdzTM4slCSziEt3O6lVXYAEcHNVhP/wW0mC31BnMLi3AgX
         BThh8/ofSvuiwpEAiwdP4dgVnw2/VzGN/qA99UrUMS7d4of12eFBkC/P3D74KF2/iESE
         eYAfTfu9Z3bm32X0aPJOH0bRAdH73Mye0W0t0J5NEmV+imkpjfWAkmc3eFcUk4FbpGsJ
         cmcQ==
X-Gm-Message-State: AOAM532AFvRysDnWloTFCBhA0gbyl4HJdHBF1X9irkVTK9qQqpeVcuEY
        0il7+zFBywAzAK6UAQKgMCU=
X-Google-Smtp-Source: ABdhPJzOY8tBte4OH8QND7AEGQPZGuKOomNig5ble4VFDS5k/fLpnydxpOE4cMrBLOvE22mF9VPriA==
X-Received: by 2002:a50:fd0d:: with SMTP id i13mr56131907eds.309.1636102204050;
        Fri, 05 Nov 2021 01:50:04 -0700 (PDT)
Received: from ?IPv6:2a04:241e:501:3870:9439:4202:183c:5296? ([2a04:241e:501:3870:9439:4202:183c:5296])
        by smtp.gmail.com with ESMTPSA id bw25sm3808303ejb.20.2021.11.05.01.50.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Nov 2021 01:50:03 -0700 (PDT)
Subject: Re: [PATCH v2 09/25] tcp: authopt: Disable via sysctl by default
To:     David Ahern <dsahern@gmail.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
        linux-hardening@vger.kernel.org, Kees Cook <keescook@chromium.org>
References: <cover.1635784253.git.cdleonard@gmail.com>
 <137399b962131c278acbfa5446a3b6d59aa0547b.1635784253.git.cdleonard@gmail.com>
 <019e96b5-4047-6458-0cfa-c9ef8f0d0470@gmail.com>
From:   Leonard Crestez <cdleonard@gmail.com>
Message-ID: <de6030e6-7280-4835-3864-3595e267fcdd@gmail.com>
Date:   Fri, 5 Nov 2021 10:50:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <019e96b5-4047-6458-0cfa-c9ef8f0d0470@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/3/21 4:39 AM, David Ahern wrote:
> On 11/1/21 10:34 AM, Leonard Crestez wrote:
>> diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
>> index 97eb54774924..cc34de6e4817 100644
>> --- a/net/ipv4/sysctl_net_ipv4.c
>> +++ b/net/ipv4/sysctl_net_ipv4.c
>> @@ -17,10 +17,11 @@
>>   #include <net/udp.h>
>>   #include <net/cipso_ipv4.h>
>>   #include <net/ping.h>
>>   #include <net/protocol.h>
>>   #include <net/netevent.h>
>> +#include <net/tcp_authopt.h>
>>   
>>   static int two = 2;
>>   static int three __maybe_unused = 3;
>>   static int four = 4;
>>   static int thousand = 1000;
>> @@ -583,10 +584,19 @@ static struct ctl_table ipv4_table[] = {
>>   		.mode		= 0644,
>>   		.proc_handler	= proc_douintvec_minmax,
>>   		.extra1		= &sysctl_fib_sync_mem_min,
>>   		.extra2		= &sysctl_fib_sync_mem_max,
>>   	},
>> +#ifdef CONFIG_TCP_AUTHOPT
>> +	{
>> +		.procname	= "tcp_authopt",
>> +		.data		= &sysctl_tcp_authopt,
>> +		.maxlen		= sizeof(int),
>> +		.mode		= 0644,
>> +		.proc_handler	= proc_dointvec,
> 
> Just add it to the namespace set, and this could be a u8 (try to plug a
> hole if possible) with min/max specified:
> 
>                  .maxlen         = sizeof(u8),
>                  .mode           = 0644,
>                  .extra1         = SYSCTL_ZERO,
>                  .extra2         = SYSCTL_ONE
> 
> 
> see icmp_echo_enable_probe as an example. And if you are not going to
> clean up when toggled off, you need a handler that tells the user it can
> not be disabled by erroring out on attempts to disable it.

This is deliberately per-system because the goal is to avoid possible 
local privilege escalations by reducing the attack surface. Even the 
smallest flaw could be exploited by a malicious application establishing 
an authenticated connection on loopback.

Applications running in containers frequently have full access to 
sysctls so making this per-namespace would defeat the original purpose. 
I can't think of any reason to prevent using this feature at the 
namespace level, it has no interesting effects outside TCP connections 
for which it is enabled.

I also believe that as similar sysctl would be useful for TCP-MD5.

You're right about adding additional prints.

--
Regards,
Leonard
