Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9D812425A
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 10:03:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbfLRJDa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 04:03:30 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43809 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbfLRJDa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 04:03:30 -0500
Received: by mail-wr1-f68.google.com with SMTP id d16so1347354wre.10
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 01:03:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=cs9psSZDFsvJWPM8fhGastj+FaAmA+j3qYLmR+w6Po8=;
        b=TCtu3cRxGwR7MauzVnqFxKgmVWrb+Vx+mgLit1UtmJqKGakMvHDuH75/ZBquZ+T2Ix
         RO53zAyA4RE554vVc8W5GWKEh8W13TaxwbNDV/+wDKQlFmo13K5TiIRGVTWj57nTVMHG
         5ZC+ru3PFj2+oTxieq4ERcD5tNK/cSqhQcOrk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=cs9psSZDFsvJWPM8fhGastj+FaAmA+j3qYLmR+w6Po8=;
        b=NOd0pZACslUFMpMDkxa7t1g9Oy2qM5XbINgqvS+zaNyG4GY7T434Zx+RhLMaGkN1MH
         BPzOco0023WPZ0PTTa7B/RGFZqM+LZuXXsLnsKSCxKTsSjf8dd2Ky20VrSJ2+fr1DFqN
         87/mNMkZl9Fhwf5sHLEU13tIsZI5s3WzAR+BuZiNv+D58/40AWszOVIwkDZdOIL7jzYG
         LqnKdkkzY/bttKwu8Se6BCNkNsHeDVOq+IdoDzolxwhStR1s2me4Z+CP7S2n+M0a7jlR
         E6Ccn2YJvGyageIPZbSKDOhB02+mGRxCMRvanuBqmwxWJFsDOvdilGBCO1E32xkvXWuS
         5z5A==
X-Gm-Message-State: APjAAAXUYJHKzswfiDUbKDePsHtrnZD6MA/AzCfE0pW4EoSEwZ22Hxj9
        7cQULvLcXaSKoy0Dyjn0PzklTw==
X-Google-Smtp-Source: APXvYqzEagSk/iQCF5+XWWrMzd08Wnc6HIKO/HnoSgTbdRaAk6GuCxvXuMpcw3lmRHmAMcGwihFjKg==
X-Received: by 2002:adf:ea88:: with SMTP id s8mr1487699wrm.293.1576659807426;
        Wed, 18 Dec 2019 01:03:27 -0800 (PST)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id g18sm1658013wmh.48.2019.12.18.01.03.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 01:03:26 -0800 (PST)
References: <20191214004737.1652076-1-kafai@fb.com> <20191214004758.1653342-1-kafai@fb.com> <b321412c-1b42-45a9-4dc6-cc268b55cd0d@gmail.com> <CADVnQy=soQ8KhuUWEQj0n2ge3a43OSgAKS95bmBtp090jqbM_w@mail.gmail.com> <87o8w7fjd4.fsf@cloudflare.com> <20191217182228.icbttiozdcmveutq@kafai-mbp.dhcp.thefacebook.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Martin Lau <kafai@fb.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Neal Cardwell <ncardwell@google.com>,
        "bpf\@vger.kernel.org" <bpf@vger.kernel.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David Miller" <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>,
        Netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next 09/13] bpf: Add BPF_FUNC_jiffies
In-reply-to: <20191217182228.icbttiozdcmveutq@kafai-mbp.dhcp.thefacebook.com>
Date:   Wed, 18 Dec 2019 10:03:25 +0100
Message-ID: <87o8w63t0i.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 17, 2019 at 07:22 PM CET, Martin Lau wrote:
> On Tue, Dec 17, 2019 at 09:26:31AM +0100, Jakub Sitnicki wrote:
>> On Sat, Dec 14, 2019 at 08:25 PM CET, Neal Cardwell wrote:
>> > On Fri, Dec 13, 2019 at 9:00 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>> >>
>> >>
>> >>
>> >> On 12/13/19 4:47 PM, Martin KaFai Lau wrote:
>> >> > This patch adds a helper to handle jiffies.  Some of the
>> >> > tcp_sock's timing is stored in jiffies.  Although things
>> >> > could be deduced by CONFIG_HZ, having an easy way to get
>> >> > jiffies will make the later bpf-tcp-cc implementation easier.
>> >> >
>> >>
>> >> ...
>> >>
>> >> > +
>> >> > +BPF_CALL_2(bpf_jiffies, u64, in, u64, flags)
>> >> > +{
>> >> > +     if (!flags)
>> >> > +             return get_jiffies_64();
>> >> > +
>> >> > +     if (flags & BPF_F_NS_TO_JIFFIES) {
>> >> > +             return nsecs_to_jiffies(in);
>> >> > +     } else if (flags & BPF_F_JIFFIES_TO_NS) {
>> >> > +             if (!in)
>> >> > +                     in = get_jiffies_64();
>> >> > +             return jiffies_to_nsecs(in);
>> >> > +     }
>> >> > +
>> >> > +     return 0;
>> >> > +}
>> >>
>> >> This looks a bit convoluted :)
>> >>
>> >> Note that we could possibly change net/ipv4/tcp_cubic.c to no longer use jiffies at all.
>> >>
>> >> We have in tp->tcp_mstamp an accurate timestamp (in usec) that can be converted to ms.
>> >
>> > If the jiffies functionality stays, how about 3 simple functions that
>> > correspond to the underlying C functions, perhaps something like:
>> >
>> >   bpf_nsecs_to_jiffies(nsecs)
>> >   bpf_jiffies_to_nsecs(jiffies)
>> >   bpf_get_jiffies_64()
>> >
>> > Separate functions might be easier to read/maintain (and may even be
>> > faster, given the corresponding reduction in branches).
>>
>> Having bpf_nsecs_to_jiffies() would be also handy for BPF sockops progs
>> that configure SYN-RTO timeout (BPF_SOCK_OPS_TIMEOUT_INIT).
>>
>> Right now user-space needs to go look for CONFIG_HZ in /proc/config.gz
> Andrii's extern variable work (already landed) allows a bpf_prog
> to read CONFIG_HZ as a global variable.  It is the path that I am
> pursuing now for jiffies/nsecs conversion without relying on
> a helper.

Thank yor for the pointer, and Andrii for implementing it.
Selftest [0] from extern-var-support series demonstrates it nicely.

[0] https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/commit/?id=330a73a7b6ca93a415de1b7da68d7a0698fe4937
