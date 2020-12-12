Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD792D88E8
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 19:04:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732232AbgLLSDi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 13:03:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727128AbgLLSDi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Dec 2020 13:03:38 -0500
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E486C0613CF
        for <netdev@vger.kernel.org>; Sat, 12 Dec 2020 10:02:58 -0800 (PST)
Received: by mail-pj1-x1042.google.com with SMTP id b5so4215702pjl.0
        for <netdev@vger.kernel.org>; Sat, 12 Dec 2020 10:02:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cGkuFd8SUVnMWuKr3+vpUbyePfeVaBNdRCV7PZLx6e8=;
        b=VYqVontRJXbCiWW+cvzaMRp79vf1ClNy744AInfUi8dgHRopmFCfQ7asrYxHAJPUlJ
         KAKBV8nh6gWqp+71oHPLIqGhTkAo9xsXrPJqUgS8vRX6131FEE/HD2ZVtD+0TOThADMp
         2BhZGvQHOSjo/UJOuevNDih9VlvDm+9INRL0qUkPgDDD4i5J+DpICJ8g/hYwPmg1TZWJ
         DDYySCQua5pjHhGzY9Vf5uYFG1jfe/H7myDObp9Oq/Tjp0jqPQP8sR/PXeZOhO6DrhRR
         R8PZseExuvNKGL6zlo/mIA6ZmSiWsGprTtn+7Z7WCV6Y7qgH3uR935kJ7t0zLL8sa0l0
         H3Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cGkuFd8SUVnMWuKr3+vpUbyePfeVaBNdRCV7PZLx6e8=;
        b=m4QC+oVcrOc4vYAQjkCfkBOYNRl3fSwXVhpDPs7UDeQHy8uOiaXvaZL27h9IWdHOlV
         bvRZM2C6T2Bgsz9vCQFA3TerVn37l7fL+GVN6b78YtszYNn4634peuTatXAKB3iqj1zp
         87nmHJ7M3ICSPouvoTIkJy+HL5shhGeYlnxl6bK3Ls9BmQ+0nrT4cB8XEffuORUTx/Lp
         M3SUG1MoZGGmKheffTq2iN354WwOWf5xz0GPA00kgCmrTzEZE8GRpQ4Q2JwERL98ekQ7
         nCKgQXnUD4Yw1cL4LGgMttNf7mY6NqEWsU7YAgGhq8W0EBSycZhA20mI2xuT1iuAkCma
         Qg3Q==
X-Gm-Message-State: AOAM532Bob1QAOpOicJa3mBeKo8FP1H9yrMNxgIjeZF8rmPTavzR20aa
        rb18TY1ygFTBXv5CQi857T3lmQ==
X-Google-Smtp-Source: ABdhPJyu0jeg7+pf/+yQLEpsD3UvOfBvg0wEwQCwAOhcATSF9EowSBl9Wozmhu2sR357q+U+cDovhw==
X-Received: by 2002:a17:90a:a2e:: with SMTP id o43mr17791024pjo.59.1607796177782;
        Sat, 12 Dec 2020 10:02:57 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id h16sm15233304pgd.62.2020.12.12.10.02.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Dec 2020 10:02:57 -0800 (PST)
Subject: Re: [PATCH 0/3] PROTO_CMSG_DATA_ONLY for Datagram (UDP)
To:     Victor Stewart <v@nametag.social>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        netdev <netdev@vger.kernel.org>,
        Stefan Metzmacher <metze@samba.org>,
        Jann Horn <jannh@google.com>
References: <CAM1kxwgjCJwSvOtESxWwTC_qcXZEjbOSreXUQrG+bOOrPWdbqA@mail.gmail.com>
 <750bc4e7-c2ce-e33d-dc98-483af96ff330@kernel.dk>
 <CAM1kxwjm9YFJCvqt4Bm0DKQuKz2Qg975YWSnx6RO_Jam=gkQyg@mail.gmail.com>
 <e618d93a-e3c6-8fb6-c559-32c0b854e321@kernel.dk>
 <CAM1kxwgX5MsOoJfnCFMnkAqCJr8m34XC2Pw1bpGmrdnUFPhY9Q@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <bfc41aef-d09b-7e94-ed50-34ec3de6163d@kernel.dk>
Date:   Sat, 12 Dec 2020 11:02:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAM1kxwgX5MsOoJfnCFMnkAqCJr8m34XC2Pw1bpGmrdnUFPhY9Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/12/20 10:58 AM, Victor Stewart wrote:
> On Sat, Dec 12, 2020 at 5:40 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 12/12/20 10:25 AM, Victor Stewart wrote:
>>> On Sat, Dec 12, 2020 at 5:07 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>
>>>> On 12/12/20 8:31 AM, Victor Stewart wrote:
>>>>> RE our conversation on the "[RFC 0/1] whitelisting UDP GSO and GRO
>>>>> cmsgs" thread...
>>>>>
>>>>> https://lore.kernel.org/io-uring/CAM1kxwi5m6i8hrtkw7nZYoziPTD-Wp03+fcsUwh3CuSc=81kUQ@mail.gmail.com/
>>>>>
>>>>> here are the patches we discussed.
>>>>>
>>>>> Victor Stewart (3):
>>>>>    net/socket.c: add PROTO_CMSG_DATA_ONLY to __sys_sendmsg_sock
>>>>>    net/ipv4/af_inet.c: add PROTO_CMSG_DATA_ONLY to inet_dgram_ops
>>>>>    net/ipv6/af_inet6.c: add PROTO_CMSG_DATA_ONLY to inet6_dgram_ops
>>>>>
>>>>>    net/ipv4/af_inet.c
>>>>>      |   1 +
>>>>>    net/ipv6/af_inet6.c
>>>>>     |   1 +
>>>>>    net/socket.c
>>>>>        |   8 +-
>>>>>    3 files changed, 7 insertions(+), 3 deletions(-)
>>>>
>>>> Changes look fine to me, but a few comments:
>>>>
>>>> - I'd order 1/3 as 3/3, that ordering makes more sense as at that point it
>>>>   could actually be used.
>>>
>>> right that makes sense.
>>>
>>>>
>>>> - For adding it to af_inet/af_inet6, you should write a better commit message
>>>>   on the reasoning for the change. Right now it just describes what the
>>>>   patch does (which is obvious from the change), not WHY it's done. Really
>>>>   goes for current 1/3 as well, commit messages need to be better in
>>>>   general.
>>>>
>>>
>>> okay thanks Jens. i would have reiterated the intention but assumed it
>>> were implicit given I linked the initial conversation about enabling
>>> UDP_SEGMENT (GSO) and UDP_GRO through io_uring.
>>>
>>>> I'd also CC Jann Horn on the series, he's the one that found an issue there
>>>> in the past and also acked the previous change on doing PROTO_CMSG_DATA_ONLY.
>>>
>>> I CCed him on this reply. Soheil at the end of the first exchange
>>> thread said he audited the UDP paths and believed this to be safe.
>>>
>>> how/should I resubmit the patch with a proper intention explanation in
>>> the meta and reorder the patches? my first patch and all lol.
>>
>> Just post is as a v2 with the change noted in the cover letter. I'd also
>> ensure that it threads properly, right now it's just coming through as 4
>> separate emails at my end. If you're using git send-email, make sure you
>> add --thread to the arguments.
> 
> oh i didn't know about git send-email. i was manually constructing /
> sending them lol. thanks!

I'd recommend it, makes sure your mailer doesn't mangle anything either. FWIW,
this is what I do:

git format-patch sha1..sha2
mv 00*.patch /tmp/x

git send-email --no-signed-off-by-cc --thread --compose  --to linux-fsdevel@vger.kernel.org --cc torvalds@linux-foundation.org --cc viro@zeniv.linux.org.uk /tmp/x

(from a series I just sent out). And then I have the following section in
~/.gitconfig:

[sendemail]
from = Jens Axboe <axboe@kernel.dk>
smtpserver = smtp.gmail.com
smtpuser = axboe@kernel.dk
smtpencryption = tls
smtppass = hunter2
smtpserverport = 587

for using gmail to send them out.

--compose will fire up your editor to construct the cover letter, and
when you're happy with it, save+exit and git send-email will ask whether
to proceed or abort.

That's about all there is to it, and provides a consistent way to send out
patch series.

-- 
Jens Axboe

