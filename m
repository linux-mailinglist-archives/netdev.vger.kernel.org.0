Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD874656F5
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 21:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352934AbhLAUU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 15:20:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239508AbhLAUS7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 15:18:59 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15B65C061748;
        Wed,  1 Dec 2021 12:15:36 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id o13so54743032wrs.12;
        Wed, 01 Dec 2021 12:15:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=y2ou2loVuUAqTFRrcmUldgZpHhhd49WhK2i6oFOiRYg=;
        b=c/sl4gXkqY+Scm9abe//cpBB8N0BZSbR1jYzwq9TQ6GH0yyyGn7zC3hB07NceYOSCp
         iD782u1p7/IYh9IeYkATLv4p4H4oG3DzdHCZYScF0DcYWk80lJsn2mPpEi6p3qmSvmTy
         xsRM+wuGJr6Mp+SiXHxU/GwqVCkrhaK9N5gI78Gv+OTEMq35tHMmzRcOHjmJx64ilEwZ
         qQ9+V/M26c3fzIawMO6AKYVfIFgwFA8mljxI6OEkQ8A47wN2NRelWHjtCOfwmhvAhaaf
         KwTMdcBQ86cxvaokcsZhc3k4ZMFi2GknWh8pIJqHKb9JYIJUKidQphlRT4MZHVcSbYO9
         PTnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=y2ou2loVuUAqTFRrcmUldgZpHhhd49WhK2i6oFOiRYg=;
        b=iV7hjsm4uqU/Uf5rfeRa2VHIXTd9eEuMElYX1WuHVMqf2RD2th1CJP660QmJYcOSo0
         5YeQTRCilLD4iA9DZUb08MfYJu5daQbcCcWDIHI0DUeXr5jLdi9YQronbYrxAYInWvTT
         ZgWGcQubNmqL4Pr3IPVrU2RquQ9vF0Oz6wpibFlixQjWlMoNCPp9+useV9dLlMNSKw8I
         GcdzuxgZqQbj8uzDwYxxgVUpwMOKpEsQdEj14CosL2jtpQvVasTkWSdTtZkaC0dHupsZ
         hXJ5Lq1SsAon4y+mhFIBiBOQOgKtrqoh/HlNi17O27O+SKCdZwzvVNPHHgy7AIAX5HkI
         nZBw==
X-Gm-Message-State: AOAM530FaTUiwH7BjAL0gYmGRfEAKPBh0wIll6TKf79sYQ3QbVWvHHNw
        cdgOQdgcvw881cNng/JHp6wh0KdTfYM=
X-Google-Smtp-Source: ABdhPJwCwlAhadM/OXW/0yhHMeZfNEMZdw3cI8WOOIMT+UKT7Wma+pZBDtRfcPQwalh2iNoTwhegHQ==
X-Received: by 2002:a5d:4d8b:: with SMTP id b11mr9050264wru.393.1638389734759;
        Wed, 01 Dec 2021 12:15:34 -0800 (PST)
Received: from [192.168.8.198] ([185.69.144.129])
        by smtp.gmail.com with ESMTPSA id g13sm1049555wrd.57.2021.12.01.12.15.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Dec 2021 12:15:34 -0800 (PST)
Message-ID: <974b266e-d224-97da-708f-c4a7e7050190@gmail.com>
Date:   Wed, 1 Dec 2021 20:15:28 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [RFC 00/12] io_uring zerocopy send
Content-Language: en-US
To:     David Ahern <dsahern@gmail.com>, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, Jens Axboe <axboe@kernel.dk>
References: <cover.1638282789.git.asml.silence@gmail.com>
 <ae2d2dab-6f42-403a-f167-1ba3db3fd07f@gmail.com>
 <994e315b-fdb7-1467-553e-290d4434d853@gmail.com>
 <c4424a7a-2ef1-6524-9b10-1e7d1f1e1fe4@gmail.com>
 <889c0306-afed-62cd-d95b-a20b8e798979@gmail.com>
 <0b92f046-5ac3-7138-2775-59fadee6e17a@gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <0b92f046-5ac3-7138-2775-59fadee6e17a@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/1/21 19:20, David Ahern wrote:
> On 12/1/21 12:11 PM, Pavel Begunkov wrote:
>> btw, why a dummy device would ever go through loopback? It doesn't
>> seem to make sense, though may be missing something.
> 
> You are sending to a local ip address, so the fib_lookup returns
> RTN_LOCAL. The code makes dev_out the loopback:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/net/ipv4/route.c#n2773

I see, thanks. I still don't use the skb_orphan_frags_rx() hack
and it doesn't go through the loopback (for my dummy tests), just
dummy_xmit() and no mention of loopback in perf data, see the
flamegraph. Don't know what is the catch.

I'm illiterate of the routing paths. Can it be related to
the "ip route add"? How do you get an ipv4 address for the device?

> 
> (you are not using vrf so ignore the l3mdev reference). loopback device
> has the logic to put the skb back in the stack for Rx processing:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/drivers/net/loopback.c#n68
> 

-- 
Pavel Begunkov
