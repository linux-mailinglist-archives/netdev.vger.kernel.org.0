Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FEC45B0C31
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 20:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230402AbiIGSJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 14:09:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbiIGSJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 14:09:13 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70BB677EBD;
        Wed,  7 Sep 2022 11:09:12 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id dv25so2928429ejb.12;
        Wed, 07 Sep 2022 11:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=rfVlZdFyNY+a+CZnW8eNIktxjS2pSLRvf4SoDS42ZEc=;
        b=bMEyL8mq7Frspx3FJg260Ba4BWd19uqOoD/nl5ulR9z+lTnnc2YC53xJfsUI/uK1/l
         TrY2zDx37B3jKux2NbvrwmHAwOqaOOt/D7L+40q+kiCAOS8lNPsEMS0ec7ige9dCtwNr
         SB9UtfHvzhybNaInW5ArDAx6n9AweaozyocNT8Vm4HXk1ZHWvbcTUuMirnVLQgmWU/mC
         Bo8S7t485KRsivVHFAHndhBtk/NJbpfVZUTSUSVAvYRz40oYbeM8LyGYOAu42sc6n3kR
         IuRU203RemodgiVdicbh1crBILTU8JmVrhjfwtjPxzqmKdzRwF8LeUFmUSipnYbWWEMz
         1tnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=rfVlZdFyNY+a+CZnW8eNIktxjS2pSLRvf4SoDS42ZEc=;
        b=nyt6xyEqdOSq3bxEBj6xRyyRpUu1vjWySk8o+srXIUzw+862fo+kVXViL13D7kVWOs
         Jw4y+TOsHIGx1gJ3/RkvIAcC8avXI5er70sp4ZIl5SRiXITvdvPiEqp03enoz8vw4DG4
         F71F4YIsYRcNI+FUmmIo00j6Vl10vL9v17+pyMzohf240U/K4WCSp3TEPdEW5m43+x0l
         LJHZ2+FsLzuSoTSXrDMidcgnwcXIv8Hpl3zX4CF4uDgp4d4Hhfyq7WwapjbQVr35SK9O
         SFLHYOZFpolfjyWwZbenTtbrDgnVJPPCXAWblPiKdmb4W1K5vBqMHdAGIQpHlcn1SGoK
         t+WA==
X-Gm-Message-State: ACgBeo0Ml8bqYNjjaxw1FtmSqV+TBeuH21ubQlKuFenNsnRM9B0RGBK1
        sm0puQAAGO3Rw9r5IB0syeg=
X-Google-Smtp-Source: AA6agR6EDqXZnqWcF2uXSuqxhTN1096/KgtqMjEOzBcDFk4E4aFEIcXJLT8dg2gFZlKWSjDZ6z4B1g==
X-Received: by 2002:a17:907:1b12:b0:72f:9b44:f9e with SMTP id mp18-20020a1709071b1200b0072f9b440f9emr3216808ejc.653.1662574150847;
        Wed, 07 Sep 2022 11:09:10 -0700 (PDT)
Received: from ?IPV6:2a04:241e:502:a09c:cbe0:7b37:373:7410? ([2a04:241e:502:a09c:cbe0:7b37:373:7410])
        by smtp.gmail.com with ESMTPSA id kz3-20020a17090777c300b0073d68d2fc29sm28375ejc.218.2022.09.07.11.09.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Sep 2022 11:09:10 -0700 (PDT)
Message-ID: <9d26bcb4-b55f-29d5-9790-2a800b22a3a5@gmail.com>
Date:   Wed, 7 Sep 2022 21:09:08 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v8 01/26] tcp: authopt: Initial support and key management
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Ahern <dsahern@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Salam Noureddine <noureddine@arista.com>,
        Philip Paeps <philip@trouble.is>,
        Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Caowangbao <caowangbao@huawei.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        netdev <netdev@vger.kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <cover.1662361354.git.cdleonard@gmail.com>
 <0e4c0a98509b907e33c2f80b95cc6cfe713ac2b2.1662361354.git.cdleonard@gmail.com>
 <CANn89i+a0mMUMhUhTPoshifNzzuR_gfThPKptB8cuBiw6Bs5jw@mail.gmail.com>
 <4a47b4ea-750c-a569-5754-4aa0cd5218fc@gmail.com>
 <CANn89i+028SO1q6Hz8E3X7mrzkGSW5mQSLaMj70qka7amsPZ3w@mail.gmail.com>
From:   Leonard Crestez <cdleonard@gmail.com>
In-Reply-To: <CANn89i+028SO1q6Hz8E3X7mrzkGSW5mQSLaMj70qka7amsPZ3w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/7/22 19:28, Eric Dumazet wrote:
> On Wed, Sep 7, 2022 at 9:19 AM Leonard Crestez <cdleonard@gmail.com> wrote:
>>
>> On 9/7/22 01:57, Eric Dumazet wrote:
>>> On Mon, Sep 5, 2022 at 12:06 AM Leonard Crestez <cdleonard@gmail.com> wrote:
>>>>
>>>> This commit adds support to add and remove keys but does not use them
>>>> further.
>>>>
>>>> Similar to tcp md5 a single pointer to a struct tcp_authopt_info* struct
>>>> is added to struct tcp_sock, this avoids increasing memory usage. The
>>>> data structures related to tcp_authopt are initialized on setsockopt and
>>>> only freed on socket close.
>>>>
>>>
>>> Thanks Leonard.
>>>
>>> Small points from my side, please find them attached.
>>
>> ...
>>
>>>> +/* Free info and keys.
>>>> + * Don't touch tp->authopt_info, it might not even be assigned yes.
>>>> + */
>>>> +void tcp_authopt_free(struct sock *sk, struct tcp_authopt_info *info)
>>>> +{
>>>> +       kfree_rcu(info, rcu);
>>>> +}
>>>> +
>>>> +/* Free everything and clear tcp_sock.authopt_info to NULL */
>>>> +void tcp_authopt_clear(struct sock *sk)
>>>> +{
>>>> +       struct tcp_authopt_info *info;
>>>> +
>>>> +       info = rcu_dereference_protected(tcp_sk(sk)->authopt_info, lockdep_sock_is_held(sk));
>>>> +       if (info) {
>>>> +               tcp_authopt_free(sk, info);
>>>> +               tcp_sk(sk)->authopt_info = NULL;
>>>
>>> RCU rules at deletion mandate that the pointer must be cleared before
>>> the call_rcu()/kfree_rcu() call.
>>>
>>> It is possible that current MD5 code has an issue here, let's not copy/paste it.
>>
>> OK. Is there a need for some special form of assignment or is current
>> plain form enough?
> 
> It is the right way (when clearing the pointer), no need for another form.

OK

>>>> +/* checks that ipv4 or ipv6 addr matches. */
>>>> +static bool ipvx_addr_match(struct sockaddr_storage *a1,
>>>> +                           struct sockaddr_storage *a2)
>>>> +{
>>>> +       if (a1->ss_family != a2->ss_family)
>>>> +               return false;
>>>> +       if (a1->ss_family == AF_INET &&
>>>> +           (((struct sockaddr_in *)a1)->sin_addr.s_addr !=
>>>> +            ((struct sockaddr_in *)a2)->sin_addr.s_addr))
>>>> +               return false;
>>>> +       if (a1->ss_family == AF_INET6 &&
>>>> +           !ipv6_addr_equal(&((struct sockaddr_in6 *)a1)->sin6_addr,
>>>> +                            &((struct sockaddr_in6 *)a2)->sin6_addr))
>>>> +               return false;
>>>> +       return true;
>>>> +}
>>>
>>> Always surprising to see this kind of generic helper being added in a patch.
>>
>> I remember looking for an equivalent and not finding it. Many places
>> have distinct code paths for ipv4 and ipv6 and my use of
>> "sockaddr_storage" as ipv4/ipv6 union is uncommon.
> 
> inetpeer_addr_cmp() might do it (and we also could fix a bug in it it
> seems, at least for __tcp_get_metrics() usage :/

That uses a different `struct inetpeer_addr` which also has some extra 
"vif" fields for ipv4 that I don't know about.

Everybody seems to be rolling their own ipv4/v6 union, other examples 
are `struct tcp_md5_addr` and `xfrm_address_t`. struct sockaddr_storage 
is "more standard" but also larger so maybe that's why others don't use it.

>>>> +int tcp_get_authopt_val(struct sock *sk, struct tcp_authopt *opt)
>>>> +{
>>>> +       struct tcp_sock *tp = tcp_sk(sk);
>>>> +       struct tcp_authopt_info *info;
>>>> +
>>>> +       memset(opt, 0, sizeof(*opt));
>>>> +       sock_owned_by_me(sk);
>>>> +
>>>> +       info = rcu_dereference_check(tp->authopt_info, lockdep_sock_is_held(sk));
>>>
>>> Probably not a big deal, but it seems the prior sock_owned_by_me()
>>> might be redundant.
>>
>> The sock_owned_by_me call checks checks lockdep_sock_is_held
>>
>> The rcu_dereference_check call checks lockdep_sock_is_held ||
>> rcu_read_lock_held()
> 
> Then if you own the socket lock, no need for rcu_dereference_check()
> 
> It could be instead an rcu_dereference_protected(). This is stronger, because
> if your thread no longer owns the socket lock, but is inside
> rcu_read_lock(), we would
> still get a proper lockdep splat.

Ok, I think there are several places where rcu_dereference_check is 
incorrectly used instead of rcu_dereference_protected.
