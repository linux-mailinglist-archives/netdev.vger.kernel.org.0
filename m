Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3CE73E99A4
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 22:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231785AbhHKUYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 16:24:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbhHKUYT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 16:24:19 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA9CFC061765;
        Wed, 11 Aug 2021 13:23:55 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id bj40so6477393oib.6;
        Wed, 11 Aug 2021 13:23:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=s+f+4MX2HmyiNsKxDkCt5V/RaI2cWZb37FwnlbVo/jE=;
        b=eUxw0T9IKgcPXbhrsmyjy4aDmWDoefgFWeeZD4RDrjTUuqw+/gWNg8Yu/aAvbMxwff
         1h2TS2Oljy/vpW4RVfkmjqIhm6poXAcDQJi2gA4v9zX7JpHL5+u1AsHFkv29hY4R0S4u
         Cr1rFalTQSDwjKruWYmU8cCZ5Po3V9a0n+M+qTYsjP5yp1M/CqRcOkN4+yCe4eJV5Ydb
         my1XlMknuobvZpg64bQ7OZcXbosvKy0ECno/jrcdF8yvKaWrWnKUiKUiS/huBlMgmDoR
         FnNXtM26m4X6go0ybI3/D5vCPAz1zoRcVs8JiPVRo5dARry4xu/ziwtRl5bKzRWdh9jt
         S6OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s+f+4MX2HmyiNsKxDkCt5V/RaI2cWZb37FwnlbVo/jE=;
        b=RDUZ3HNDMNsvAkUTXu6FOpS+cwlpyQL/C76fQCygiy08OMfAlBOwhTt7nMKGj+LJjf
         a31GWZt1A8Y1d9FinzDpF8mVfginpfK5Mfa5DvL0EV3t80kS9OnptSZkCwsVU7Ud/xYS
         WfJGkrcN8P8cjyIs1XdwPsjnXKw16JNLluDZ5NgJUwiYrnGPW+xaodoggFd0NikBiy+c
         2RzWZKz8ajqQ3RAlEiwEkNHR0kmSRg6lLstZLyDzyOWEoMCnpnGX4zWgOAwtDRiXsMGf
         OzvAOCY9whWZxdxEeInSzvLy/SVRoXgJdDZM4gAE2nrHA+072AD0Kiu8LnQRPH4BIWdh
         1FKw==
X-Gm-Message-State: AOAM532Oku8g/uGpjK11DNQlMwj9SQCqanh51NtzIZz3xnj293AcTzrG
        wrW6dfe4Da3hxrAWsrMezAU=
X-Google-Smtp-Source: ABdhPJxOT093VGyIM/8I+Qq+/qtGwKgnC2OTFGMDVkJAYqzIJx6SQ9HjCHZ5uCVZojJiBX+OgrcfJA==
X-Received: by 2002:a05:6808:181a:: with SMTP id bh26mr9075974oib.113.1628713435132;
        Wed, 11 Aug 2021 13:23:55 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.45])
        by smtp.googlemail.com with ESMTPSA id t3sm125779otm.28.2021.08.11.13.23.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Aug 2021 13:23:54 -0700 (PDT)
Subject: Re: [RFCv2 1/9] tcp: authopt: Initial support and key management
To:     Dmitry Safonov <0x7f454c46@gmail.com>,
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
 <2c39e02b-1da5-7a62-512e-67f008fe15fc@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <89dae60c-7310-40a9-0ddb-566068799a58@gmail.com>
Date:   Wed, 11 Aug 2021 14:23:52 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <2c39e02b-1da5-7a62-512e-67f008fe15fc@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/11/21 2:12 PM, Dmitry Safonov wrote:
> Hi David,
> 
> On 8/11/21 6:15 PM, David Ahern wrote:
>> On 8/11/21 8:31 AM, Dmitry Safonov wrote:
>>> On 8/11/21 9:29 AM, Leonard Crestez wrote:
>>>> On 8/10/21 11:41 PM, Dmitry Safonov wrote:
> [..]
>>>>> I'm pretty sure it's not a good choice to write partly tcp_authopt.
>>>>> And a user has no way to check what's the correct len on this kernel.
>>>>> Instead of len = min_t(unsigned int, len, sizeof(info)), it should be
>>>>> if (len != sizeof(info))
>>>>>      return -EINVAL;
>>>>
>>>> Purpose is to allow sockopts to grow as md5 has grown.
>>>
>>> md5 has not grown. See above.
>>
>> MD5 uapi has - e.g., 8917a777be3ba and  6b102db50cdde. We want similar
>> capabilities for growth with this API.
> 
> So, you mean adding a new setsockopt when the struct has to be extended?
> Like TCP_AUTHOPT_EXT?

uh, no. That was needed because of failures with the original
implementation wrt checking that all unused bits are 0. If checking is
not done from day 1, that field can never be used in the future.

My point here was only that MD5 uapi was extended.

My second point is more relevant to Leonard as a very recent example of
how to build an extendable struct.


>>
>> Look at how TCP_ZEROCOPY_RECEIVE has grown over releases as an example
>> of how to properly handle this.
> 
> Exactly.
> 
> : switch (len) {
> :		case offsetofend(...)
> :		case offsetofend(...)
> 
> And than also:
> :		if (unlikely(len > sizeof(zc))) {
> :			err = check_zeroed_user(optval + sizeof(zc),
> :						len - sizeof(zc));
> 
> Does it sound similar to what I've written in my ABI review?
> And what the LWN article has in it.
> Please, look again at the patch I replied to.
> 
> Thanks,
>          Dmitry
> 

