Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7A02D88B5
	for <lists+netdev@lfdr.de>; Sat, 12 Dec 2020 18:43:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406595AbgLLRky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 12:40:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393718AbgLLRky (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Dec 2020 12:40:54 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 347A6C0613D3
        for <netdev@vger.kernel.org>; Sat, 12 Dec 2020 09:40:14 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id w5so8756063pgj.3
        for <netdev@vger.kernel.org>; Sat, 12 Dec 2020 09:40:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WWML1PSJLcf6MkRp0X+stinBaJ09ip4IkyLqML27Uwo=;
        b=bDFO1IPjxtgw5y04lv/TvngC/Uipv6qikte6f3u7yLK92lZJWfCg/1Aze9CsUlGqpk
         LuvXsl5PSrG5mwUbcje+/a5OgAtcGjMmcURHCk0HC7NiglcQqq4BgaF0TWwZ2lTUKLdc
         yeCvnbetGY32B6LU1HlAlqfvUsquYpmvPaPUmR3EAzv1FOoDb/B82mWkrOY82UqEdk7C
         81PinXu/XfonzHp2AIQSC4F2y2WRFEJvKcFXHgmVa6Z7vpdZtgStzTDqzWXfWIkeQQHg
         7oGqOFk0725FTeIleryCmXr3j1For3/PyH+OthH2QNDNlI3g37fpHNhfEeNJaLMJJSxl
         glKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WWML1PSJLcf6MkRp0X+stinBaJ09ip4IkyLqML27Uwo=;
        b=boC0X92s+mEGFU6/vv7cE/+yHvL/w/ogUo0bn0HyXqKjxy+NC+KISzCC6MI3eN39WX
         v3rsnQwEnKlWxzEQj7dhRpxFZfBg5+Ow0YCRlEIGSVL9E0IdMeD/h6wUgyvWyj/NRyTS
         hmNv0q48PLZdUeMfBPnDTgJ9Y94JX+g+gNixU4+63GLANhQBsKGhnnFl0cbJSmeZ3aDX
         jo9r4oq8sX5xUCRAgra4XIePlsJHRw/NBEQj8+EDX8aVwZnBfByw0k75ntyYzTF2hNRJ
         O1riTtvk2++sw3UB1ptAIxDQUdfp3PD3uAr6RU9LBfZl+9+1hCt5hdTZo/29BBCTlY9C
         y3yQ==
X-Gm-Message-State: AOAM530hPhKBuDW5y8hsBVSjGZBTH3nLXM2BExM2M+8fMx0vZlC1/lKy
        vXeFXTZcqyPHXVL/ijR/ZFocdA==
X-Google-Smtp-Source: ABdhPJx4gVsRtcLF4m5lMN3DWJ4DPIVmN7LCQ6lN3arQtljVvo6hY/5nM9ZNOGDTFjKOHkjPPMdLyw==
X-Received: by 2002:a63:494f:: with SMTP id y15mr17080646pgk.364.1607794813595;
        Sat, 12 Dec 2020 09:40:13 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id y3sm14988472pjb.18.2020.12.12.09.40.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Dec 2020 09:40:12 -0800 (PST)
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
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e618d93a-e3c6-8fb6-c559-32c0b854e321@kernel.dk>
Date:   Sat, 12 Dec 2020 10:40:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAM1kxwjm9YFJCvqt4Bm0DKQuKz2Qg975YWSnx6RO_Jam=gkQyg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/12/20 10:25 AM, Victor Stewart wrote:
> On Sat, Dec 12, 2020 at 5:07 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 12/12/20 8:31 AM, Victor Stewart wrote:
>>> RE our conversation on the "[RFC 0/1] whitelisting UDP GSO and GRO
>>> cmsgs" thread...
>>>
>>> https://lore.kernel.org/io-uring/CAM1kxwi5m6i8hrtkw7nZYoziPTD-Wp03+fcsUwh3CuSc=81kUQ@mail.gmail.com/
>>>
>>> here are the patches we discussed.
>>>
>>> Victor Stewart (3):
>>>    net/socket.c: add PROTO_CMSG_DATA_ONLY to __sys_sendmsg_sock
>>>    net/ipv4/af_inet.c: add PROTO_CMSG_DATA_ONLY to inet_dgram_ops
>>>    net/ipv6/af_inet6.c: add PROTO_CMSG_DATA_ONLY to inet6_dgram_ops
>>>
>>>    net/ipv4/af_inet.c
>>>      |   1 +
>>>    net/ipv6/af_inet6.c
>>>     |   1 +
>>>    net/socket.c
>>>        |   8 +-
>>>    3 files changed, 7 insertions(+), 3 deletions(-)
>>
>> Changes look fine to me, but a few comments:
>>
>> - I'd order 1/3 as 3/3, that ordering makes more sense as at that point it
>>   could actually be used.
> 
> right that makes sense.
> 
>>
>> - For adding it to af_inet/af_inet6, you should write a better commit message
>>   on the reasoning for the change. Right now it just describes what the
>>   patch does (which is obvious from the change), not WHY it's done. Really
>>   goes for current 1/3 as well, commit messages need to be better in
>>   general.
>>
> 
> okay thanks Jens. i would have reiterated the intention but assumed it
> were implicit given I linked the initial conversation about enabling
> UDP_SEGMENT (GSO) and UDP_GRO through io_uring.
> 
>> I'd also CC Jann Horn on the series, he's the one that found an issue there
>> in the past and also acked the previous change on doing PROTO_CMSG_DATA_ONLY.
> 
> I CCed him on this reply. Soheil at the end of the first exchange
> thread said he audited the UDP paths and believed this to be safe.
> 
> how/should I resubmit the patch with a proper intention explanation in
> the meta and reorder the patches? my first patch and all lol.

Just post is as a v2 with the change noted in the cover letter. I'd also
ensure that it threads properly, right now it's just coming through as 4
separate emails at my end. If you're using git send-email, make sure you
add --thread to the arguments.

-- 
Jens Axboe

