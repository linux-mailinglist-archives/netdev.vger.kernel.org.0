Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAF3D1292A1
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 09:11:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725926AbfLWILC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 03:11:02 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38262 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725855AbfLWILC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 03:11:02 -0500
Received: by mail-pf1-f193.google.com with SMTP id x185so8797751pfc.5
        for <netdev@vger.kernel.org>; Mon, 23 Dec 2019 00:11:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2bSqIAYVkUGw1FuYUHp3ClWTGIYLyIjue2aBTC7xtrA=;
        b=oPR8gtN4ZyTBb2mrlDbZ2vTUxpRoO1LW6G9nepQUNX6Hxwm9xpVV7CiDlS2x7EM/GD
         drf8/T2Zod3eO4J1+JGme9k8QKztsVr7RQee3TllowWSAchVSZqd00WrdWK/ECzWlNGe
         hci29Hv7UGlBi/qKisifNWKwyXMwyGrcXfrjmk1jEjiJ/qinvDXLbgQB7nUtQJUv8wTe
         JsXmuKDekMh+8/hnj19/WmFn0C0BF03AJT4WreY45u4fg0vkY6wAIKd65e7IfFIVY40k
         3bS0If0rwHW0zTijYB1X7uD+iTusc4NGxWmgsNABAaq6PO66Qu9Z6EYlRPFCLq/a7/Tk
         7ORg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2bSqIAYVkUGw1FuYUHp3ClWTGIYLyIjue2aBTC7xtrA=;
        b=h52wtwRbFf1/RcNVQGBKln9wqHi2C3YG2uZ3uO9V9LAsk4SnLgTRGIZuwNSjQoM2T4
         mspQR6GwTe2weesdxiYg1MUhl79WK9E2buU5cH6lt0GZEmP2GJQ8TqjWrPCz6MdhAWFo
         D9mKqU8qm/xGY7dfy81Y7ooYx7mKJO2KH3l42uZHjSfy3WYM2xOzHLPIA7nvvGq8wInG
         KxRDlNyHGRFzhzKzyjVVqtMwE8JKnIUydxpD7fEANDYUuBg41m5hI8UJgAwpal10ue2S
         cMqld4Y3B9ImEh+tmADaaFLYsz+nIN9X0GmtBIIw9SJ012wAK5mkDvbmUU+UReOTzZrM
         vrPQ==
X-Gm-Message-State: APjAAAXP1wJTm3VLl/Ts8rkCBzA2t2QiCB8NK2WCWRWZaLkjw9/N79Q+
        xsWlpt97YDB+uQOd1tJouhw=
X-Google-Smtp-Source: APXvYqyALmDEehpuESCXJ5hI899MgL9BlGb31P3WnlC5QRUczqZXBOgpOtjdKyLME4c3RAOz/8hhSQ==
X-Received: by 2002:a63:b64a:: with SMTP id v10mr30709908pgt.145.1577088661453;
        Mon, 23 Dec 2019 00:11:01 -0800 (PST)
Received: from [172.20.20.156] ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id m71sm21837672pje.0.2019.12.23.00.10.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Dec 2019 00:11:00 -0800 (PST)
Subject: Re: [RFC net-next 11/14] tun: run XDP program in tx path
To:     Jason Wang <jasowang@redhat.com>, David Ahern <dsahern@gmail.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
References: <20191218081050.10170-1-prashantbhole.linux@gmail.com>
 <20191218081050.10170-12-prashantbhole.linux@gmail.com>
 <20191218110732.33494957@carbon> <87fthh6ehg.fsf@toke.dk>
 <20191218181944.3ws2oy72hpyxshhb@ast-mbp.dhcp.thefacebook.com>
 <35a07230-3184-40bf-69ff-852bdfaf03c6@gmail.com> <874kxw4o4r.fsf@toke.dk>
 <5eb791bf-1876-0b4b-f721-cb3c607f846c@gmail.com>
 <75228f98-338e-453c-3ace-b6d36b26c51c@redhat.com>
 <3654a205-b3fd-b531-80ac-42823e089b39@gmail.com>
 <3e7bbc36-256f-757b-d4e0-aeaae7009d6c@gmail.com>
 <58e0f61d-cb17-f517-d76d-8a665af31618@gmail.com>
 <4d1847f1-73c2-7cf2-11e4-ce66c268b386@redhat.com>
From:   Prashant Bhole <prashantbhole.linux@gmail.com>
Message-ID: <09118670-b0c7-897c-961d-022ad4dfb093@gmail.com>
Date:   Mon, 23 Dec 2019 17:09:56 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <4d1847f1-73c2-7cf2-11e4-ce66c268b386@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/23/19 3:05 PM, Jason Wang wrote:
> 
> On 2019/12/21 上午6:17, Prashant Bhole wrote:
>>
>>
>> On 12/21/2019 1:11 AM, David Ahern wrote:
>>> On 12/19/19 9:46 PM, Prashant Bhole wrote:
>>>>
>>>> "It can improve container networking where veth pair links the host and
>>>> the container. Host can set ACL by setting tx path XDP to the veth
>>>> iface."
>>>
>>> Just to be clear, this is the use case of interest to me, not the
>>> offloading. I want programs managed by and viewable by the host OS and
>>> not necessarily viewable by the guest OS or container programs.
>>>
>>
>> Yes the plan is to implement this while having a provision to implement
>> offload feature on top of it.
> 
> 
> I wonder maybe it's easier to focus on the TX path first then consider 
> building offloading support on top.
Currently working on TX path. I will try make sure that we will be able
to implement offloading on top of it later.

Thanks.
