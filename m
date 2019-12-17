Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E94A1226A6
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 09:26:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbfLQI0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 03:26:35 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:35574 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbfLQI0f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 03:26:35 -0500
Received: by mail-lj1-f195.google.com with SMTP id j6so9922567lja.2
        for <netdev@vger.kernel.org>; Tue, 17 Dec 2019 00:26:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=S2HWEnfNx14SXY1HnKJhWOptQA0SVJJU0TqB07h1faM=;
        b=Bug4Nf08piVyLoD3c99gL62iecZ2ijJjbIHj/9AaI3XtVt1JKuhH92l5fTTCFfTSDz
         it/tX3FCFNjr7VL1QWmsOi1FQp1RHYLVihSCf14IygVY6QL0f/IHXMwqvRX+kjxwS1P9
         S+LQYy4yXlI/uoZuI26yJwiMNwmj4LNaUmNqg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=S2HWEnfNx14SXY1HnKJhWOptQA0SVJJU0TqB07h1faM=;
        b=PNMIeZn5nQsw2Z+/UdivuWWI60jqiNiRIq5acTrsFGduo/JNgWridVup9Sdc7q9Es2
         oqlxjQuV2/vlyC5RKvjISZFhNuE4bs1k2PT7Pr1cM4PfP5UVt56zobHhQQBaLIhwQ8XO
         lZoJ8KahDNRPIR1syBbDOUHq+Do/DKmeyI7dPEN3P+rK6ghPRDT2HxA9PhAukZ5J8T0D
         LG9XBdfb9BiV43JbgxxJGBYqzPrq9tEWwy/S1DJ02bTAQhMVgoDhyIRLx5tJaIkLC/qw
         MGCjTKkioaP1OoMonRhFwQv4LZfQvsTO2bnW0iLHYyUzOJXacnEVk4lagB5MfiA7bzo6
         J6zQ==
X-Gm-Message-State: APjAAAXZko8yBAiNbS6XzBidCi0IewEEFXZ6BClRWgGfPWss8lIKXqZL
        hjgUIkmw4Sa6asZLwqyVwJag4A==
X-Google-Smtp-Source: APXvYqwOaZ3V0e7e1ht3nZykyxicFylkfmNXt0Yj5dWyZOWLC21Bqvng7/Ce2BPdmBascUTrFbvtZw==
X-Received: by 2002:a2e:6e03:: with SMTP id j3mr2372004ljc.27.1576571193476;
        Tue, 17 Dec 2019 00:26:33 -0800 (PST)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id a12sm12063052ljk.48.2019.12.17.00.26.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 00:26:32 -0800 (PST)
References: <20191214004737.1652076-1-kafai@fb.com> <20191214004758.1653342-1-kafai@fb.com> <b321412c-1b42-45a9-4dc6-cc268b55cd0d@gmail.com> <CADVnQy=soQ8KhuUWEQj0n2ge3a43OSgAKS95bmBtp090jqbM_w@mail.gmail.com>
User-agent: mu4e 1.1.0; emacs 26.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Neal Cardwell <ncardwell@google.com>, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <kernel-team@fb.com>,
        Netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next 09/13] bpf: Add BPF_FUNC_jiffies
In-reply-to: <CADVnQy=soQ8KhuUWEQj0n2ge3a43OSgAKS95bmBtp090jqbM_w@mail.gmail.com>
Date:   Tue, 17 Dec 2019 09:26:31 +0100
Message-ID: <87o8w7fjd4.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 14, 2019 at 08:25 PM CET, Neal Cardwell wrote:
> On Fri, Dec 13, 2019 at 9:00 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>
>>
>>
>> On 12/13/19 4:47 PM, Martin KaFai Lau wrote:
>> > This patch adds a helper to handle jiffies.  Some of the
>> > tcp_sock's timing is stored in jiffies.  Although things
>> > could be deduced by CONFIG_HZ, having an easy way to get
>> > jiffies will make the later bpf-tcp-cc implementation easier.
>> >
>>
>> ...
>>
>> > +
>> > +BPF_CALL_2(bpf_jiffies, u64, in, u64, flags)
>> > +{
>> > +     if (!flags)
>> > +             return get_jiffies_64();
>> > +
>> > +     if (flags & BPF_F_NS_TO_JIFFIES) {
>> > +             return nsecs_to_jiffies(in);
>> > +     } else if (flags & BPF_F_JIFFIES_TO_NS) {
>> > +             if (!in)
>> > +                     in = get_jiffies_64();
>> > +             return jiffies_to_nsecs(in);
>> > +     }
>> > +
>> > +     return 0;
>> > +}
>>
>> This looks a bit convoluted :)
>>
>> Note that we could possibly change net/ipv4/tcp_cubic.c to no longer use jiffies at all.
>>
>> We have in tp->tcp_mstamp an accurate timestamp (in usec) that can be converted to ms.
>
> If the jiffies functionality stays, how about 3 simple functions that
> correspond to the underlying C functions, perhaps something like:
>
>   bpf_nsecs_to_jiffies(nsecs)
>   bpf_jiffies_to_nsecs(jiffies)
>   bpf_get_jiffies_64()
>
> Separate functions might be easier to read/maintain (and may even be
> faster, given the corresponding reduction in branches).

Having bpf_nsecs_to_jiffies() would be also handy for BPF sockops progs
that configure SYN-RTO timeout (BPF_SOCK_OPS_TIMEOUT_INIT).

Right now user-space needs to go look for CONFIG_HZ in /proc/config.gz
or /boot/config-`uname -r`, or derive it from clock resolution [0]

        clock_getres(CLOCK_REALTIME_COARSE, &res);
        jiffy = res.tv_nsec / 1000000;

to pass timeout in jiffies to the BPF prog.

-jkbs

[0] https://www.mail-archive.com/kernelnewbies@nl.linux.org/msg08850.html

