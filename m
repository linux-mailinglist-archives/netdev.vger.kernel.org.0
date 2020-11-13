Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2A52B20A6
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 17:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbgKMQlU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 11:41:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726184AbgKMQlS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 11:41:18 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7C9FC0613D1
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 08:41:16 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id p10so9037643ile.3
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 08:41:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1maPmyaKCFrlMXOFhLDURnBAcI345ouYzgfxRYo9eoQ=;
        b=U8eEzWZ02FKczFKVVRB8H6piD7Vd7qJ13wStI0PanTNwmkvOzglP/gRwljWqRolefl
         rT72erMl7/0dAnAFmiEEcS1iSTWzSftW1898p7+ryBO5D8d8jk26zwBMfgoF7FQMY/y6
         ekJXXfR7KJSTvmFrQOwRN5o2pE+Wc4LXw5BrZxp/rx5KAyuOH1qQixfH0stIg1lok0QX
         TM5xy1vEmb5C8tMqrL974EB9dotRSgN8l+YWT5LyA5IZziiqTRGf7vLy1UnyVCZfs3+z
         /wZ7/QinhfHAtjss7Qr1mY2LqG5noRqLNtZ8l3nGv2BdrxsEjjRO5soPTFkT/wenz8ou
         +32w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1maPmyaKCFrlMXOFhLDURnBAcI345ouYzgfxRYo9eoQ=;
        b=Xclc7P1EvAXTYHgo0DRk2WcDUzje3E7t5UNXvS7kban06guXJPX92/YFZ2w36SbS0q
         yCPiJ7kpTtz6GQc7cNW+o+n2byBLxo2RP4fT6jtcFwMaw3h0o/6ySK1gKow1LACQ0zAw
         bx/nFv9Ms8JQ1GsK5jv5lGTUJT6vpnokPWL4IOkD1xJZZBUh3TzMnQbLOqYioArmO6tH
         87lF/6V92gM4JgD5o90CRiKiXibZWc8kNlthD7Gh9m+t2m7o6S4yBDLHsRMWyAK2/YPM
         9jrLE0BqXC0FY0ox/UFqe1OJzIFiTXKY92atz/wS7pYdfdW3G6C6mZADAJTp35W+XXHn
         6bDg==
X-Gm-Message-State: AOAM532iIXargkj/Sysz51IX5QoS/CPA8TohPKjTMLknX4lN40mfjsAA
        iZQQrGYEkUAxK0cLjHYNhG9IPXEhdHU=
X-Google-Smtp-Source: ABdhPJx+M/SbWQOXQesIu0G9Kx+W76onizG1TWXJiwWEMdXeSUMY2hAov0GTm/INjw4Wfol2r6ddQA==
X-Received: by 2002:a92:50b:: with SMTP id q11mr517980ile.49.1605285669792;
        Fri, 13 Nov 2020 08:41:09 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:99e7:10e8:ee93:9a3d])
        by smtp.googlemail.com with ESMTPSA id v26sm4624756iot.35.2020.11.13.08.41.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Nov 2020 08:41:08 -0800 (PST)
Subject: Re: MSG_ZEROCOPY_FIXED
To:     Victor Stewart <v@nametag.social>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org
References: <CAM1kxwjkJndycnWWbzBFyAap9=y13DynF=SMijL1=3SPpHbvdw@mail.gmail.com>
 <20201111000902.zs4zcxlq5ija7swe@bsd-mbp.dhcp.thefacebook.com>
 <CAM1kxwh9+fu1O=rG9=HuEnp8c0E2_xvyZpTq=ehX+r5pmNiMLg@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f02ab449-d450-3f49-fe85-e5bbbe4d9ae5@gmail.com>
Date:   Fri, 13 Nov 2020 09:41:07 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.2
MIME-Version: 1.0
In-Reply-To: <CAM1kxwh9+fu1O=rG9=HuEnp8c0E2_xvyZpTq=ehX+r5pmNiMLg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/10/20 5:20 PM, Victor Stewart wrote:
> On Wed, Nov 11, 2020 at 12:09 AM Jonathan Lemon
> <jonathan.lemon@gmail.com> wrote:
>>
>> On Sun, Nov 08, 2020 at 05:04:41PM +0000, Victor Stewart wrote:
>>> hi all,
>>>
>>> i'm seeking input / comment on the idea of implementing full fledged
>>> zerocopy UDP networking that uses persistent buffers allocated in
>>> userspace... before I go off on a solo tangent with my first patches
>>> lol.
>>>
>>> i'm sure there's been lots of thought/discussion on this before. of
>>> course Willem added MSG_ZEROCOPY on the send path (pin buffers on
>>> demand / per send). and something similar to what I speak of exists
>>> with TCP_ZEROCOPY_RECEIVE.
>>>
>>> i envision something like a new flag like MSG_ZEROCOPY_FIXED that
>>> "does the right thing" in the send vs recv paths.
>>
>> See the netgpu patches that I posted earlier; these will handle
>> protocol independent zerocopy sends/receives.  I do have a working
>> UDP receive implementation which will be posted with an updated
>> patchset.
> 
> amazing i'll check it out. thanks.
> 
> does your udp zerocopy receive use mmap-ed buffers then vm_insert_pfn
> / remap_pfn_range to remap the physical pages of the received payload
> into the memory submitted by recvmsg for reception?
> 
> https://lore.kernel.org/io-uring/acc66238-0d27-cd22-dac4-928777a8efbc@gmail.com/T/#t
> 
> ^^ and check the thread from today on the io_uring mailing list going
> into the mechanics of zerocopy sendmsg i have in mind.
> 
> (TLDR; i think it should be io_uring "only" so that we can collapse it
> into a single completion event, aka when the NIC ACKs the
> transmission. and exploiting the asynchrony of io_uring is the only
> way to do this? so you'd submit your sendmsg operation to io_uring and
> instead of receiving a completion event when the send gets enqueued,
> you'd only get it upon failure or NIC ACK).
> 

Do you have a working implementation? Right now, io_uring send / sendmsg
can return incomplete sends (only partial buffer is sent):

https://lore.kernel.org/io-uring/5324a8ca-bd5c-0599-d4d3-1e837338a7b5@gmail.com/

That will need to be solved. A simple solution is to track the offset
and resubmit:

https://lore.kernel.org/io-uring/fb72cffc-87f9-6072-3f3a-6648aacd310e@gmail.com/
