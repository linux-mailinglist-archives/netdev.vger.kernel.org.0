Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7703E996C
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 22:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231759AbhHKUNJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 16:13:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbhHKUNI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 16:13:08 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FB46C061765;
        Wed, 11 Aug 2021 13:12:44 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id n32so1962815wms.2;
        Wed, 11 Aug 2021 13:12:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qtbH24sys0A+E+TreCMzv6nq61b8pVYX9klQznBRbB8=;
        b=HYQhInI2mDD9u/AjCPBMCdwFVimviA3NE3D3JSF80rJugdwzsE6lq0df+NfkWF7ymU
         Q79lulXSORu8Ju7M+Vl+5BC6lUitS/Q+TenH4YirRnAlFE47jWbExccqcVuBJ9IP4Qyw
         ZG6wnTvrEj/D3LHRein7jgFUbwqM6Z3GkEoXCEw8Gn79TNCkei7S8B40LU6IATtv8Up2
         qI4tb1Z59ftvNSynMzardm5k8Amyvi48Upv4j+tISO6K3QsRgp40LGxglLCtfcpfzRLJ
         hArJcfivS35drmmsDQfHiiVDZHYT35Uw84i+zpsVEsn4HO5OfzVHzE8abhJ7yVZEY3EF
         hGfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qtbH24sys0A+E+TreCMzv6nq61b8pVYX9klQznBRbB8=;
        b=OAq+AIZviMSH55/e2daOWR89VQoEfxsob6y9VHVscEL7EgOuT008NH1v2KCfxu2yTx
         GxJUvV4UFtr0+WEGa8g49Y9eihpYKZp/+ADcI4l5GGfUrb+QBhfLqq8VMJOz4UnI/4K1
         g8fvpIEKySsO0jUpW36upYI5GGUFjWjJpUuR1Xv7bUrtPHYPhhICcAH7esJaYGRSyarg
         UNb9Y/E5phl2CkQzrPd7sAd5fBcjFSbNqKqf6DwQPG30/udISS1K0MIGl4ZxasLQv0jH
         sly5jdI4EbpOhn9DgZJsSyjuhWlme7xJ1hojf/uuv7dqKsSxZm3RphgsS5pUFdn6z1/8
         elHw==
X-Gm-Message-State: AOAM533RuEV3kI/zhjEy4mxlfP2TOZ/LEwyzhQ2gk+y+EkTeD19v/DNd
        w/SvYZYtoUuafXPCSnRk2eY=
X-Google-Smtp-Source: ABdhPJy0lnP4+OJ/68HRlO5b+lZtYimvhGFmZartwqv30KJ6RNjGNFvMjYCS73wNAFax5o9eiNQjMw==
X-Received: by 2002:a05:600c:20f:: with SMTP id 15mr303065wmi.176.1628712762677;
        Wed, 11 Aug 2021 13:12:42 -0700 (PDT)
Received: from ?IPv6:2a02:8084:e84:2480:228:f8ff:fe6f:83a8? ([2a02:8084:e84:2480:228:f8ff:fe6f:83a8])
        by smtp.gmail.com with ESMTPSA id n30sm448596wra.1.2021.08.11.13.12.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Aug 2021 13:12:42 -0700 (PDT)
Subject: Re: [RFCv2 1/9] tcp: authopt: Initial support and key management
To:     David Ahern <dsahern@gmail.com>,
        Leonard Crestez <cdleonard@gmail.com>
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
 <68749e37-8e29-7a51-2186-7692f5fd6a79@gmail.com>
 <ac911d47-eef7-c97b-9a77-f386546b56e8@gmail.com>
From:   Dmitry Safonov <0x7f454c46@gmail.com>
Message-ID: <2c39e02b-1da5-7a62-512e-67f008fe15fc@gmail.com>
Date:   Wed, 11 Aug 2021 21:12:41 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <ac911d47-eef7-c97b-9a77-f386546b56e8@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On 8/11/21 6:15 PM, David Ahern wrote:
> On 8/11/21 8:31 AM, Dmitry Safonov wrote:
>> On 8/11/21 9:29 AM, Leonard Crestez wrote:
>>> On 8/10/21 11:41 PM, Dmitry Safonov wrote:
[..]
>>>> I'm pretty sure it's not a good choice to write partly tcp_authopt.
>>>> And a user has no way to check what's the correct len on this kernel.
>>>> Instead of len = min_t(unsigned int, len, sizeof(info)), it should be
>>>> if (len != sizeof(info))
>>>>      return -EINVAL;
>>>
>>> Purpose is to allow sockopts to grow as md5 has grown.
>>
>> md5 has not grown. See above.
> 
> MD5 uapi has - e.g., 8917a777be3ba and  6b102db50cdde. We want similar
> capabilities for growth with this API.

So, you mean adding a new setsockopt when the struct has to be extended?
Like TCP_AUTHOPT_EXT?

It can work, but sounds like adding a new syscall every time the old one
can't be extended. I can see that with current limitations on TCP-AO RFC
the ABI in these patches will have to be extended.

The second commit started using new cmd.tcpm_flags, where unknown flags
are still at this moment silently ignored by the kernel. So 6b102db50cdd
could have introduced a regression in userspace. By luck and by reason
that md5 isn't probably frequently used it didn't.
Not nice at all example for newer APIs.

>> Another issue with your approach
>>
>> +       /* If userspace optlen is too short fill the rest with zeros */
>> +       if (optlen > sizeof(opt))
>> +               return -EINVAL;
>> +       memset(&opt, 0, sizeof(opt));
>> +       if (copy_from_sockptr(&opt, optval, optlen))
>> +               return -EFAULT;
>>
>> is that userspace compiled with updated/grew structure will fail on
>> older kernel. So, no extension without breaking something is possible.
>> Which also reminds me that currently you don't validate (opt.flags) for
>> unknown by kernel flags.
>>
>> Extending syscalls is impossible without breaking userspace if ABI is
>> not designed with extensibility in mind. That was quite a big problem,
>> and still is. Please, read this carefully:
>> https://lwn.net/Articles/830666/
>>
>> That is why I'm suggesting you all those changes that will be harder to
>> fix when/if your patches get accepted.
>> As an example how it should work see in copy_clone_args_from_user().
>>
> 
> Look at how TCP_ZEROCOPY_RECEIVE has grown over releases as an example
> of how to properly handle this.

Exactly.

: switch (len) {
:		case offsetofend(...)
:		case offsetofend(...)

And than also:
:		if (unlikely(len > sizeof(zc))) {
:			err = check_zeroed_user(optval + sizeof(zc),
:						len - sizeof(zc));

Does it sound similar to what I've written in my ABI review?
And what the LWN article has in it.
Please, look again at the patch I replied to.

Thanks,
         Dmitry
