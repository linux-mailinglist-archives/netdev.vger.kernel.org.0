Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD35815F574
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 19:39:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729790AbgBNShc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 13:37:32 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:46517 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728239AbgBNShb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Feb 2020 13:37:31 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 0bb1088c
        for <netdev@vger.kernel.org>;
        Fri, 14 Feb 2020 18:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :in-reply-to:references:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=0sFyxxR4A39qHjDmq76rlWlV6qA=; b=YLyHgQ
        vN9IM1kREnmUWV1odAct1+UTuF3uAzIa1PClwfq7BxX1+78ZZrR/Xg6Tc+dw2Hyc
        oy6EVtsaBEDr5R5fCujh3sZmSrXg5xzzIpBumu28BvF+LsinoGjSm+Mc6R2HLQYU
        pKGB0iwEIKIWqAWaGzytIyoDtQ86wAUbGSN3gLcmvL9yu35i4W4DmhRbIyFjiern
        43vkgOGEEVbW6MH/R2xJqIXAIKBBrdkbtww6X1AQc72LbpbTUxxuPQoVdTk2T0oj
        nTJ9tDZP1ushaN6DDhe1hGWRnLT+emWFXt9APsay+v+hnEW/2IC3P1MBUBbhQyr8
        AokXMAjPq0n6gtPg==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 9af8967d (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Fri, 14 Feb 2020 18:35:21 +0000 (UTC)
Received: by mail-ot1-f44.google.com with SMTP id z9so10073530oth.5
        for <netdev@vger.kernel.org>; Fri, 14 Feb 2020 10:37:29 -0800 (PST)
X-Gm-Message-State: APjAAAVyeJNXFwu60NF9c56nu+gSE95fqyjJg45xffKwkZN4v+LBhflb
        GwVDRmjQQVPzW3S07iVrpTyDr/KZyv/W1vYUCgs=
X-Google-Smtp-Source: APXvYqyYJrXIJj7PX8xj0uin5vinquDwegzbkfpuNOBXanp/mk8tTqvH4ADlbvDJJzwQf19RDy4W1xOw787k0HrPAVM=
X-Received: by 2002:a9d:674f:: with SMTP id w15mr3372207otm.243.1581705449206;
 Fri, 14 Feb 2020 10:37:29 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a4a:dd10:0:0:0:0:0 with HTTP; Fri, 14 Feb 2020 10:37:28
 -0800 (PST)
In-Reply-To: <e20d0c52-cb83-224d-7507-b53c5c4a5b69@gmail.com>
References: <20200214173407.52521-1-Jason@zx2c4.com> <20200214173407.52521-4-Jason@zx2c4.com>
 <135ffa7a-f06a-80e3-4412-17457b202c77@gmail.com> <CAHmME9pjLfscZ-b0YFsOoKMcENRh4Ld1rfiTTzzHmt+OxOzdjA@mail.gmail.com>
 <e20d0c52-cb83-224d-7507-b53c5c4a5b69@gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 14 Feb 2020 19:37:28 +0100
X-Gmail-Original-Message-ID: <CAHmME9oXfDCGmsCJJEuaPmgj7_U4yfrBoqi0wRZrOD9SdWny_w@mail.gmail.com>
Message-ID: <CAHmME9oXfDCGmsCJJEuaPmgj7_U4yfrBoqi0wRZrOD9SdWny_w@mail.gmail.com>
Subject: Re: [PATCH v2 net 3/3] wireguard: send: account for mtu=0 devices
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/14/20, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
> On 2/14/20 10:15 AM, Jason A. Donenfeld wrote:
>> On Fri, Feb 14, 2020 at 6:56 PM Eric Dumazet <eric.dumazet@gmail.com>
>> wrote:
>>> Oh dear, can you describe what do you expect of a wireguard device with
>>> mtu == 0 or mtu == 1
>>>
>>> Why simply not allowing silly configurations, instead of convoluted tests
>>> in fast path ?
>>>
>>> We are speaking of tunnels adding quite a lot of headers, so we better
>>> not try to make them
>>> work on networks with tiny mtu. Just say no to syzbot.
>>
>> The idea was that wireguard might still be useful for the persistent
>> keepalive stuff. This branch becomes very cold very fast, so I don't
>> think it makes a difference performance wise, but if you feel strongly
>> about it, I can get rid of it and set a non-zero min_mtu that's the
>> smallest thing wireguard's xmit semantics will accept. It sounds like
>> you'd prefer that?
>>
> Well, if you believe that wireguard in persistent keepalive
> has some value on its own, I guess that we will have to support this mode.

Alright.

>
> Some legacy devices can have arbitrary mtu, and this has caused headaches.
> I was hoping that for brand new devices, we could have saner limits.
>
> About setting max_mtu to ~MAX_INT, does it mean wireguard will attempt
> to send UDP datagrams bigger than 64K ? Where is the segmentation done ?

The before passings off to the udp tunnel api, we indicate that we
support ip segmentation, and then it gets handled and fragmented
deeper down. Check out socket.c. This winds up being sometimes useful
for some odd people when it's faster to encrypt longer packets on
networks with no loss. I can't say I generally recommend people go
that route, but some report benefitting from it.


>


-- 
Jason A. Donenfeld
Deep Space Explorer
fr: +33 6 51 90 82 66
us: +1 513 476 1200
www.jasondonenfeld.com
www.zx2c4.com
zx2c4.com/keys/AB9942E6D4A4CFC3412620A749FC7012A5DE03AE.asc
