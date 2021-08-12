Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A73493EAB41
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 21:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235681AbhHLTrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 15:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235552AbhHLTrS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 15:47:18 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50888C061756;
        Thu, 12 Aug 2021 12:46:52 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id o23so13757381ejc.3;
        Thu, 12 Aug 2021 12:46:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6XdIleat91/MzDpJVOaU1YmXdU4k0zkjMEY+D2f+xKw=;
        b=dahg+GkWwhEV28eqPZ3i2PFQsLbWgFaJdtqZjD2IGS0L+hxOi48mD6O8LrKZ4fveXk
         P0olEAvOB8dyDFW5cQ//s5ei9wn/SATCD9RP3/bmnjI/4YnBnjV4jkKuoBHVg7iX4ghw
         lbdkP2JUVT2P4FanbFg7f8oeySrP1jJ5gC+D9N34z4l7350VvZWn018q1s5bdHYm3WkD
         v5AqJwYVJKsK8IWjZmhScMQJAOd7zQQLeo2ZwDy9dG/87bvflKNO8V3dlcObb7Dv89er
         lqHlKBkiQoqijhT0RLs17rDrCqsWsIYT8vM1hAa5FuaLKHfHbjRIENer+4qTPTrYv92J
         /8Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6XdIleat91/MzDpJVOaU1YmXdU4k0zkjMEY+D2f+xKw=;
        b=diSFbtlfg+4y8lynNCXrhHLhoSNrqMqPHYoSPLomaxJ/BUZ1A/Z8Y1G+i7ck3KSkqj
         CofE7o4Zc32hrJAmRO3W4n1nggr4dFR7OepBGZLkan3dKteDWIIANHWXsGm8fzATeKx6
         YRyfmWUQ9Efyf5hAnXoAEB/pR/RkMD6zkm8MpB/8TiHsCp2h30EfyxO76trJ8x+zvrHE
         5BbG0zGzEASIicnt1OkbhZeCjR1PhVedn2ih8PnQ++I0s+ZzPII1+tPeXYqnIJvnO5Ku
         s2lpFLhl69OOBMTHTQ1TvF5kBEN4/Ve+XVMTycE+wyP+fH++zLqkPCTloGk0lfKR3do9
         9x7g==
X-Gm-Message-State: AOAM532nP0ynfaqPj8MbX9qqCo+bgLyE0Bg8zsKQPWasZCXhLLY0DBGH
        6H+cABXgJL2E2MZdPe8ulqQ=
X-Google-Smtp-Source: ABdhPJwxasy2FDyr6WDV2CLwLaZmO8zjwsGax0+745qwOTIAVFsE566ZPIVNbpJZ5fiX7nnZSaAh8A==
X-Received: by 2002:a17:907:9602:: with SMTP id gb2mr5335995ejc.119.1628797610905;
        Thu, 12 Aug 2021 12:46:50 -0700 (PDT)
Received: from ?IPv6:2a04:241e:502:1d80:f865:21f3:80af:d6db? ([2a04:241e:502:1d80:f865:21f3:80af:d6db])
        by smtp.gmail.com with ESMTPSA id b11sm1174848eja.104.2021.08.12.12.46.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Aug 2021 12:46:50 -0700 (PDT)
Subject: Re: [RFCv2 1/9] tcp: authopt: Initial support and key management
From:   Leonard Crestez <cdleonard@gmail.com>
To:     Dmitry Safonov <0x7f454c46@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        David Ahern <dsahern@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        Menglong Dong <dong.menglong@zte.com.cn>,
        open list <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>,
        Dmitry Safonov <dima@arista.com>
References: <cover.1628544649.git.cdleonard@gmail.com>
 <67c1471683200188b96a3f712dd2e8def7978462.1628544649.git.cdleonard@gmail.com>
 <CAJwJo6aicw_KGQSM5U1=0X11QfuNf2dMATErSymytmpf75W=tA@mail.gmail.com>
 <1e2848fb-1538-94aa-0431-636fa314a36d@gmail.com>
Message-ID: <785d945e-c0d2-fee5-39d8-99dc06a074f1@gmail.com>
Date:   Thu, 12 Aug 2021 22:46:48 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1e2848fb-1538-94aa-0431-636fa314a36d@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/11/21 11:29 AM, Leonard Crestez wrote:
> On 8/10/21 11:41 PM, Dmitry Safonov wrote:
>> On Tue, 10 Aug 2021 at 02:50, Leonard Crestez <cdleonard@gmail.com> 
>>> +       /* If an old value exists for same local_id it is deleted */
>>> +       key_info = __tcp_authopt_key_info_lookup(sk, info, 
>>> opt.local_id);
>>> +       if (key_info)
>>> +               tcp_authopt_key_del(sk, info, key_info);
>>> +       key_info = sock_kmalloc(sk, sizeof(*key_info), GFP_KERNEL | 
>>> __GFP_ZERO);
>>> +       if (!key_info)
>>> +               return -ENOMEM;
>>
>> 1. You don't need sock_kmalloc() together with tcp_authopt_key_del().
>>      It just frees the memory and allocates it back straight away - no
>> sense in doing that.
> 
> The list is scanned in multiple places in later commits using nothing 
> but an rcu_read_lock, this means that keys can't be updated in-place.
> 
>> 2. I think RFC says you must not allow a user to change an existing key:
>>> MKT parameters are not changed. Instead, new MKTs can be installed, 
>>> and a connection
>>> can change which MKT it uses.
>>
>> IIUC, it means that one can't just change an existing MKT, but one can
>> remove and later
>> add MKT with the same (send_id, recv_id, src_addr/port, dst_addr/port).
>>
>> So, a reasonable thing to do:
>> if (key_info)
>>      return -EEXIST.
> 
> You're right, making the user delete keys explicitly is better.

On a second thought this might be required to mark keys as "send-only" 
and "recv-only" atomically.

Separately from RFC5925 some vendors implement a "keychain" model based 
on RFC8177 where each key has a distinct "accept-lifetime" and a 
"send-lifetime". This could be implemented by adding flags 
"expired_for_send" and "expired_for_recv" but requires the ability to 
set an expiration mark without the key ever being deleted.

--
Regards,
Leonard
