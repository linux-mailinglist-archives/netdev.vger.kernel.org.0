Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5BA71C17
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 17:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731538AbfGWPsB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 11:48:01 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:37163 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726347AbfGWPsB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 11:48:01 -0400
Received: by mail-pg1-f196.google.com with SMTP id i70so8888287pgd.4
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 08:48:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6JpIZpTEEn5XqrAvJXnij0X0Wf7RNzowYpFsy8xM2NQ=;
        b=TsSf2K9ulXcCmW/aW64NBsKOw9CUy5MeLYPe2zU/3s9mJ5oA/+iIfdXOlHIO+WkfXM
         TTPw7LcXVgOUQld3BejJ7TfRpqlWN+T7eMWdCWy8qrSHA+AlNAqkFB082FaZGea9HhQ/
         sxRODW030q7WeF3GMXfLGabvRG8QLLktGefuiEY6vn+ll3QzBeN+qOoAU+r0Ku7ouLZV
         rXTsE5ZbCiKzG/S8/Vwo0oPP5SvEWyNih1BUOdyuzEf5mgO7SkWcbAGN72KCW+tRNxU8
         uwyBcvtb4deXt72w7WC4gG/UmN8n7Yj19PajDwfkQGBnp01Po3d+GaPS6hsMNzzOjenC
         /pww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6JpIZpTEEn5XqrAvJXnij0X0Wf7RNzowYpFsy8xM2NQ=;
        b=q/Pf6lpGxvWCflIJKsBkQkAr1KRB58Z60HH+1A0d+oYFoAsU/VB8rJRnMAzrjYaipY
         FvvinSgTRH2q6MlVnC63cXtQp0YEGTxA6t2oAKjg1LQdja6XVQggA/BMfLxrT9Wty9nR
         QAo3p7xXVPTPtcBDPniCo0k8DtzmA0QzqEHLPYl6yQ8KqwkO3HI+sDmRe7ZozYO33nnG
         eGnC1KH65NZO2C1YFtdgAjLSZePSB+zZqORgo7zsQkzJ3G898xHyv6DEI3lrGJ7ie1nG
         5UuOVMQEHqZUVcsAQz8XHINnRpUfUzoCr6A1zTIH9anpHW/iqtlEunB0BGXOTspW7jU2
         B3tw==
X-Gm-Message-State: APjAAAVdAWQwxGopGnPVzOHV7FQqadykQWMUiO+S37mC38H5eEWP55Rz
        jyAVk334tqv55nLBm1qBVLo=
X-Google-Smtp-Source: APXvYqwH3ZBF6PgLIxOhKFa/UPysnVQG0Ah3JFegywjHGleclpund9xg4SMbw3dcTAuUAkCHfqsXqw==
X-Received: by 2002:a17:90a:1904:: with SMTP id 4mr85188363pjg.116.1563896880393;
        Tue, 23 Jul 2019 08:48:00 -0700 (PDT)
Received: from [172.20.0.114] (67-207-120-245.static.wiline.com. [67.207.120.245])
        by smtp.googlemail.com with ESMTPSA id h13sm5093016pfn.13.2019.07.23.08.47.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Jul 2019 08:47:59 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 00/12] drop_monitor: Capture dropped packets
 and metadata
To:     Ido Schimmel <idosch@idosch.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vu?= =?UTF-8?Q?sen?= 
        <toke@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, nhorman@tuxdriver.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        jakub.kicinski@netronome.com, andy@greyhouse.net,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
References: <20190722183134.14516-1-idosch@idosch.org>
 <87imrt4zzg.fsf@toke.dk> <20190723064659.GA16069@splinter>
 <875znt3pxu.fsf@toke.dk> <20190723151423.GA10342@splinter>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c02f9b6a-f343-89ee-1047-79c1fb4e3436@gmail.com>
Date:   Tue, 23 Jul 2019 08:47:57 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190723151423.GA10342@splinter>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ido:

Thanks for taking this on. Looks like a good direction to me.

On 7/23/19 8:14 AM, Ido Schimmel wrote:
> On Tue, Jul 23, 2019 at 02:17:49PM +0200, Toke Høiland-Jørgensen wrote:
>> Ido Schimmel <idosch@idosch.org> writes:
>>
>>> On Mon, Jul 22, 2019 at 09:43:15PM +0200, Toke Høiland-Jørgensen wrote:
>>>> Is there a mechanism for the user to filter the packets before they are
>>>> sent to userspace? A bpf filter would be the obvious choice I guess...
>>>
>>> Hi Toke,
>>>
>>> Yes, it's on my TODO list to write an eBPF program that only lets
>>> "unique" packets to be enqueued on the netlink socket. Where "unique" is
>>> defined as {5-tuple, PC}. The rest of the copies will be counted in an
>>> eBPF map, which is just a hash table keyed by {5-tuple, PC}.
>>
>> Yeah, that's a good idea. Or even something simpler like tcpdump-style
>> filters for the packets returned by drop monitor (say if I'm just trying
>> to figure out what happens to my HTTP requests).
> 
> Yep, that's a good idea. I guess different users will use different
> programs. Will look into both options.

Perhaps I am missing something, but the dropmon code only allows a
single user at the moment (in my attempts to run 2 instances the second
one failed). If that part stays with the design it afford better options
for the design. e.g., attributes that control the enqueued packets when
the event occurs as opposed to bpf filters which run much later when the
message is enqueued to the socket.

> 
>>> I think it would be good to have the program as part of the bcc
>>> repository [1]. What do you think?
>>
>> Sure. We could also add it to the XDP tutorial[2]; it could go into a
>> section on introspection and debugging (just added a TODO about that[3]).
> 
> Great!
> 
>>>> For integrating with XDP the trick would be to find a way to do it that
>>>> doesn't incur any overhead when it's not enabled. Are you envisioning
>>>> that this would be enabled separately for the different "modes" (kernel,
>>>> hardware, XDP, etc)?
>>>
>>> Yes. Drop monitor have commands to enable and disable tracing, but they
>>> don't carry any attributes at the moment. My plan is to add an attribute
>>> (e.g., 'NET_DM_ATTR_DROP_TYPE') that will specify the type of drops
>>> you're interested in - SW/HW/XDP. If the attribute is not specified,
>>> then current behavior is maintained and all the drop types are traced.
>>> But if you're only interested in SW drops, then overhead for the rest
>>> should be zero.
>>
>> Makes sense (although "should be" is the key here ;)).

static_key is used in other parts of the packet fast path.

Toke/Jesper: Any reason to believe it is too much overhead for this path?

>>
>> I'm also worried about the drop monitor getting overwhelmed; if you turn
>> it on for XDP and you're running a filtering program there, you'll
>> suddenly get *a lot* of drops.
>>
>> As I read your patch, the current code can basically queue up an
>> unbounded number of packets waiting to go out over netlink, can't it?
> 
> That's a very good point. Each CPU holds a drop list. It probably makes
> sense to limit it by default (to 1000?) and allow user to change it
> later, if needed. I can expose a counter that shows how many packets
> were dropped because of this limit. It can be used as an indication to
> adjust the queue length (or flip to 'summary' mode).
> 

And then with a single user limit, you can have an attribute that
controls the backlog.

