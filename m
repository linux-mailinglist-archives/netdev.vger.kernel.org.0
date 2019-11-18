Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44CBF10071B
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 15:12:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbfKROMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 09:12:44 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37901 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726627AbfKROMn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 09:12:43 -0500
Received: by mail-wm1-f65.google.com with SMTP id z19so19057110wmk.3
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 06:12:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ncentric-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=atJ1umGvrpLfXuQb7dPFes5EP58a+5LHS17qMvyaRW0=;
        b=wQNAwikc6r3JkjT1z7maTVWC2ub6ApTpZBaRHBPwXMyoDpMVFIv/RcuDix0W961g78
         pqImXBLdVgLN0LNprSDFADaGqqhnhSpqbI6qPWAuSL+KNof3QQq34ncxh5zhzFRH1VmF
         Ok3+VAECWEppA+J4BAqrpSUI5VjzCA/1n0vauWCpKIPUkRQu2KKMKqj7jGguKerOoXrU
         58r+55iYio4UO5QoUVCH9hBa8kSPpwI1AmvcGZOqQh/8e1pxViF7C3vJBtFGtjJAW9tl
         1z+1IwhnvOMuS6CH3Zoaq2n3aKRS/5fVdAqXHJ4fr/iYS7xHhSVFxcWjaQNDP36kb1il
         KeXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=atJ1umGvrpLfXuQb7dPFes5EP58a+5LHS17qMvyaRW0=;
        b=KaKjlw+MOCMzHHvGUhN5IKZNXgZY8uuEm6bxC2uySRuEa3KTBAnT81UMNkWB96XDjm
         UcYU33xchDkMEIfFeeu+h70HKI78fjARynNcLjuTtc3Wmyus8mm8cHZzj0Kb0+45Ibvp
         ULzmccDGNBdCBp0rN2hPf7d/hGDukAgpxAYpPzeJBj8oNw19cavkN62KWAkrNnbZjZqX
         TTRNVIY1MIAhXJwV8L0mEaOyeKMHDubk+LyD0WbnLkqipoXKpCKNksT7byrR5miBGle4
         AsxBGJ51jClw0nuAAdwV9f4gxeGGMpMMZ0FYMdaEJcYcEl/bHv9j9IaeY2bXl5AFQcPB
         +dFw==
X-Gm-Message-State: APjAAAUxTzUZPo8tX5oJbM/wIDz7+3y79ze96+Ex59wplbEGKo/Gt14X
        lWtI6jE7UuPn5xwz/T8dOvuINQ==
X-Google-Smtp-Source: APXvYqyfHyiCIbngGLUGrRmg59QrJlgnAaDq/KdTBOovbokDVNc+N7WCARsMQHJf1kmwjianjIbHpA==
X-Received: by 2002:a1c:48c1:: with SMTP id v184mr29437184wma.120.1574086361020;
        Mon, 18 Nov 2019 06:12:41 -0800 (PST)
Received: from [192.168.3.176] (d515300d8.static.telenet.be. [81.83.0.216])
        by smtp.gmail.com with ESMTPSA id m16sm20393018wml.47.2019.11.18.06.12.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Nov 2019 06:12:40 -0800 (PST)
Subject: Re: crash since commit "net/flow_dissector: switch to siphash"
To:     Hauke Mehrtens <hauke@hauke-m.de>,
        Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>, Greg KH <greg@kroah.com>
References: <cc0add2f-4ae7-70cb-2c98-242d0f0aede9@ncentric.com>
 <CANn89iJxhte1yH6-dhvRpwWsOm-=P0PtzpAzsLgYtzOQSoqA9w@mail.gmail.com>
 <43e827b5-15af-96c5-b633-d8355d1c6c0b@ncentric.com>
 <CANn89iJ6OOQG8PZ1qDXP-EsOLKip44rcQhn+LNTUM1HezRwvNA@mail.gmail.com>
 <a020f6bf-e0d1-22af-46f7-34f44e417fef@hauke-m.de>
From:   Koen Vandeputte <koen.vandeputte@ncentric.com>
Message-ID: <ef16acf8-0143-9e42-9d65-2cedbd331bcc@ncentric.com>
Date:   Mon, 18 Nov 2019 15:12:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <a020f6bf-e0d1-22af-46f7-34f44e417fef@hauke-m.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 18.11.19 01:11, Hauke Mehrtens wrote:
> On 11/15/19 6:09 PM, Eric Dumazet wrote:
>> On Fri, Nov 15, 2019 at 3:30 AM Koen Vandeputte
>> <koen.vandeputte@ncentric.com> wrote:
>>>
>>> On 13.11.19 15:50, Eric Dumazet wrote:
>>>> On Wed, Nov 13, 2019 at 3:52 AM Koen Vandeputte
>>>> <koen.vandeputte@ncentric.com> wrote:
>>>>> Hi Eric,
>>>>>
>>>>> I'm currently testing kernel 4.14.153 bump for OpenWrt and noticed splat
>>>>> below on my testing boards.
>>>>> They all reboot continuously nearly immediately when linked.
>>>>>
>>>>> It feels like it's tied to a commit of yours [1]
>>>> Have you tried current upstream kernels ?
>>> No.
>>>
>>> This board is only supported on OpenWrt currently using 4.14 and it's
>>> not natively supported by upstream.
>>>
>>>> Is is a backport issue, or a bug in original commit ?
>>> No idea .. and I'm not profound enough on that part of the code to judge
>>> this,
>>>
>>> which is why I'm consulting your expert opinion.
>>>
>>>> Can you give us gcc version ?
>>> 7.4.0
>>>> Can you check what SIPHASH_ALIGNMENT value is at compile time ?
>>> 8 (exposed it in dmesg on boot)
>> Please ask OpenWrt specialists for support.
>>
>> The code is probably mishandled by the compiler.
>>
>> siphash() is supposed to handle misaligned data just fine, and
>> net/core/flow_dissector.c tries hard to align the keys anyway.
> Hi Koen,
>
> This is probably related to backports for the wireless driver which uses
> its own fq.h and fq_impl.h implementation and this is now conflicting
> with Eric's patch which got backported.
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=v4.14.154&id=a9de6f42e945cdb24b59c7ab7ebad1eba6cb5875
>
> I saw this as a compile warning when creating a new backports version
> and created this patch:
> https://www.spinics.net/lists/backports/msg04930.html
> This is for the other way around.
>
> I will try to create a patch for OpenWrt backports tomorrow to fix this
> problem and I am also planning to create a new backports release in the
> next few days.
>
> Hauke

Hi Hauke,

This indeed fixes the issue.

Thank you!


Sorry for the noise here. ;-)

Koen

