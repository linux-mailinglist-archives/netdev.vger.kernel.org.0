Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60729416A0
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 23:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407465AbfFKVJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 17:09:09 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40595 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406793AbfFKVJJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 17:09:09 -0400
Received: by mail-pg1-f195.google.com with SMTP id d30so7637601pgm.7
        for <netdev@vger.kernel.org>; Tue, 11 Jun 2019 14:09:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uED7J3lKedIyzESAC/9YUIXNaBqTZXdB+UJJLBkB9p0=;
        b=QMfjCX8h83N9YQvpKn0oXyzWv37gSObF83CxPwA5n1mOVeZb/bysbNkJ7N2QV+wNMh
         IqMIhrpa1HURvZ1igmN6Te1CR6/QUtKTgAq4gYg0bvZ89KlUt93nUGU8Jk+n8fL/KDtX
         9Kva/VS+Vlg9/Nk0UTbXBsGKPyejdCLGwbeb6Q76C0BpEeK1TWqfAL4NKYd2aY2jaQo3
         GXqhAseZFssx1JIp4a48PSS2IsEUCRv0ydvfB+86WI81/05KDjEdp9mj/wQ4h7Ufb3hA
         H0/B25WlsmHldeyfLcYKm5URSAcnwnv5ZUgvWV5tOJ2uYpftUdUBOXDKor7Atx9Edr1d
         7z0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uED7J3lKedIyzESAC/9YUIXNaBqTZXdB+UJJLBkB9p0=;
        b=iAJjzsB919I/VLIrE/2Ct8JvnXY5MOwviSu7/ePtMxYHgQ1LwPKB3m67kPbsgZmeeR
         ElPJvdUOM/kn1sULjzWSvHZBLERdOlWY+7CzCADQ+zYABUkpC76LkWTHtyCDt5MzRlko
         IBFOdIpcvcb8EQHXHQdSkHtcPYZsbTaFX8lIwkclGYCrORXLMQaA5eNtK7VOkq9OvcWI
         xtvd4uYdV6kxbhxuFE5CeHBxbrxFh4BsQ2oSee6U3EzUrCgnhygIaeAjkI1dvApQw5pB
         H7YM6RTWl0EGRNBaDPbWheZtuxi3PPu+NlrMBAYR+J+H2X5CoXhYoM7MwwLTp7EGsocY
         zAxQ==
X-Gm-Message-State: APjAAAWYUyimYzFttWU7Tl8dC3AJ6WqoGRInLCj/ea31wgQd0s6j4OBg
        15S7iMHQR+hceDes/Qp9vLAuzgPuceI=
X-Google-Smtp-Source: APXvYqyCRsUJo8WhjtN8tk3eG2UHMFpH4cCDhvvvDMSLyK9WK1en0eG7zcs2DtnMqFIA+XY1/MOfxA==
X-Received: by 2002:a17:90a:ba93:: with SMTP id t19mr19557304pjr.139.1560287348230;
        Tue, 11 Jun 2019 14:09:08 -0700 (PDT)
Received: from [172.27.227.165] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id d7sm17565441pfn.89.2019.06.11.14.09.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Jun 2019 14:09:07 -0700 (PDT)
Subject: Re: [PATCH net v3 0/2] ipv6: Fix listing and flushing of cached route
 exceptions
To:     Martin Lau <kafai@fb.com>, Stefano Brivio <sbrivio@redhat.com>
Cc:     David Miller <davem@davemloft.net>, Jianlin Shi <jishi@redhat.com>,
        Wei Wang <weiwan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <cover.1560016091.git.sbrivio@redhat.com>
 <37a62d04-0285-f6de-84b5-e1592c31a913@gmail.com>
 <20190610235315.46faca79@redhat.com> <20190611004758.1e302288@redhat.com>
 <20190611201946.tokf7su5hlxyrlhs@kafai-mbp.dhcp.thefacebook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <956e4bc4-c916-c069-cd5d-b8f4b309a437@gmail.com>
Date:   Tue, 11 Jun 2019 15:09:05 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190611201946.tokf7su5hlxyrlhs@kafai-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/11/19 2:19 PM, Martin Lau wrote:
> On Tue, Jun 11, 2019 at 12:47:58AM +0200, Stefano Brivio wrote:
>> On Mon, 10 Jun 2019 23:53:15 +0200
>> Stefano Brivio <sbrivio@redhat.com> wrote:
>>
>>> On Mon, 10 Jun 2019 15:38:06 -0600
>>> David Ahern <dsahern@gmail.com> wrote:
>>>
>>>> in dot releases of stable trees, I think it would be better to converge
>>>> on consistent behavior between v4 and v6. By that I mean without the
>>>> CLONED flag, no exceptions are returned (default FIB dump). With the
>>>> CLONED flag only exceptions are returned.  
>>>
>>> Again, this needs a change in iproute2, because RTM_F_CLONED is *not*
>>> passed on 'flush'. And sure, let's *also* do that, but not everybody
>>> runs recent versions of iproute2.
>>
>> One thing that sounds a bit more acceptable to me is:
>>
>> - dump (in IPv4 and IPv6):
>>   - regular routes only, if !RTM_F_CLONED and NLM_F_MATCH
>>   - exceptions only, if RTM_F_CLONED and NLM_F_MATCH
> That seems reasonable since DavidAhern pointed out iproute2 already has
> #define NLM_F_DUMP      (NLM_F_ROOT|NLM_F_MATCH)
> 
>>   - everything if !NLM_F_MATCH
> I am not sure how may the kernel change looks like.  At least I don't
> see the current ipv6/route.c or ipv6/ip6_fib.c is handling
> nlmsg_flags.  I would defer to DavidAhern for comment.

We might be battling change histories in 2 different code bases. We
should compare behaviors of kernel and iproute2 for 4.14 (pre-change),
4.15 (change), 4.19 (LTS), 5.0 (strict checking) and 5.2 and then look
at what the proposed kernel change does with the various iproute2 versions.

