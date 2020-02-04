Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EAD215223F
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 23:12:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727607AbgBDWMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 17:12:33 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:38289 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727500AbgBDWMd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 17:12:33 -0500
Received: by mail-qk1-f196.google.com with SMTP id 21so2593331qki.5;
        Tue, 04 Feb 2020 14:12:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PnYOhO4Zym39uRCmqO1AVTVBG2Vt3JG9gKzPV8VD8ok=;
        b=hpN8xvulLMN2964VAGSOvgJuzcSlLF3S/N1vkspSBC1C4frAO0AIxOHCIOvS3AaABR
         FPMOVfELU0SZK++x7gQp7HG2bTw5ASBKprfAj0u9Ib3I09LQsNY33c47ziCfLE0JNJtR
         Cz/WQK8CRjkA8noSb5Z4Lw61gbpGPdJ2YnT0D9n4yab/BGd4zC+2hFZ6b8muOeo215Rd
         TCzdCEal91ZaaeyvFhAse3wzGbPbPxHIRA65VFFCd1JlbztuEC9t+B2IkN8XUg/rZMbq
         O6WR37m0yljwIw8HBieFdNSjO+bsT16uP0bwgUqiMiqrf9yXTNIn2MGT5RmZ7NsyPJ+b
         HbLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PnYOhO4Zym39uRCmqO1AVTVBG2Vt3JG9gKzPV8VD8ok=;
        b=JXkbth4L/7f45go8RGfWrRwoW/k1+sl1RuGdvZ8k+a4zKpIik+oCH3mcyPgzAAMD5J
         wDeTShdCtfvBoEIKforgPujAkwI8xf+XjL6x4mgbeaIimAmnJP/kfPbKmuRriXev3rlw
         tz6lW1xqh9F7Tn0X/AEDpqER2NjPdNteAEVK0pkVzShFIxcwXs61T6PFD2PNcp1iw113
         ruawgxN/HGvMfIL7xBbM302vYQhJM63fjtlqZh7RorCdkVGIcGFwkq/emCRmvVDebQu/
         gHocAc7yKu62CG2xW0flJGzYG8blLfBO1+x0yBAyQHqlVl1moFK4x4sRRBEN9WjeDJAg
         t+2g==
X-Gm-Message-State: APjAAAUR5I0lnhW4GdTQgzXlSp6n/k8xw5PSc4pAbh8Gl9cANoAOk4J0
        zFMtazP7UwxHN8lrdDUpsBxpekrwGq4=
X-Google-Smtp-Source: APXvYqyqhVYmb6f4LImd/K1nEttFJAE42UMosZOR2u4I6kO6dEY0z/Ig0QpManUXgzl1VajMOZcCjg==
X-Received: by 2002:a37:47c8:: with SMTP id u191mr31583267qka.438.1580854351847;
        Tue, 04 Feb 2020 14:12:31 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:3d10:e33:29a2:f093? ([2601:282:803:7700:3d10:e33:29a2:f093])
        by smtp.googlemail.com with ESMTPSA id i16sm11853837qkh.120.2020.02.04.14.12.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Feb 2020 14:12:31 -0800 (PST)
Subject: Re: [RFC bpf-next 0/5] Convert iproute2 to use libbpf (WIP)
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <20190820114706.18546-1-toke@redhat.com> <87blwiqlc8.fsf@toke.dk>
 <CAEf4BzYMKPbfOu4a4UDEfJVcNW1-KvRwJ7PVo+Mf_1YUJgE4Qw@mail.gmail.com>
 <43e8c177-cc9c-ca0b-1622-e30a7a1281b7@iogearbox.net>
 <CAEf4Bzab_w0AXy5P9mG14mcyJVgUCzuuNda5FpU5wSEwUciGfg@mail.gmail.com>
 <87tva8m85t.fsf@toke.dk>
 <CAEf4BzbzQwLn87G046ZbkLtTbY6WF6o8JkygcPLPGUSezgs9Tw@mail.gmail.com>
 <CAEf4BzZOAukJZzo4J5q3F2v4MswQ6nJh6G1_c0H0fOJCdc7t0A@mail.gmail.com>
 <87blqfcvnf.fsf@toke.dk>
 <CAEf4Bza4bSAzjFp2WDiPAM7hbKcKgAX4A8_TUN8V38gXV9GbTg@mail.gmail.com>
 <0bf50b22-a8e2-e3b3-aa53-7bd5dd5d4399@gmail.com>
 <CAEf4Bzbzz3s0bSF_CkP56NTDd+WBLAy0QrMvreShubetahuH0g@mail.gmail.com>
 <2cf136a4-7f0e-f4b7-1ecb-6cbf6cb6c8ff@gmail.com>
 <CAEf4Bzb1fXdGFz7BkrQF7uMhBD1F-K_kudhLR5wC-+kA7PMqnA@mail.gmail.com>
 <87h80669o6.fsf@toke.dk>
 <CAEf4BzYGp95MKjBxNay2w=9RhFAEUCrZ8_y1pqzdG-fUyY63=w@mail.gmail.com>
 <8736bqf9dw.fsf@toke.dk>
 <CAEf4BzbNZQmDD3Ob+m6yJK2CzNb9=3F2bYfxOUyn7uOp0bhXZA@mail.gmail.com>
 <87tv46dnj6.fsf@toke.dk>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <2ab65028-c200-f8f8-b57d-904cb8a7c00c@gmail.com>
Date:   Tue, 4 Feb 2020 15:12:29 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <87tv46dnj6.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/4/20 2:56 PM, Toke Høiland-Jørgensen wrote:
>> I'm confused, honestly. libbpf is either a dependency and thus can be
>> relied upon to be present in the target system, or it's not and this
>> whole dance with detecting libbpf presence needs to be performed.
> 
> Yes, and iproute2 is likely to be built in both sorts of environments,
> so we will have to support both :)
> 
>> If libbpf is optional, then I don't see how iproute2 BPF-related code
>> and complexity can be reduced at all, given it should still support
>> loading BPF programs even without libbpf. Furthermore, given libbpf
>> supports more features already and will probably be outpacing
>> iproute2's own BPF support in the future, some users will start
>> relying on BPF features supported only by libbpf "backend", so
>> iproute2's own BPF backend will just fail to load such programs,
>> bringing unpleasant surprises, potentially. So I still fail to see how
>> libbpf can be optional and what benefit does that bring.
> 
> I wasn't saying that libbpf itself should be optional; if we're porting
> things, we should rip out as much of the old code as we can. I just
> meant that we should support both modes of building, so distros that
> *do* build libbpf as a library can link iproute2 against that with as
> little friction as possible.
> 
> I'm dead set on a specific auto-detection semantic either; I guess it'll
> be up to the iproute2 maintainers whether they prefer defaulting to one
> or the other.
> 

A few concerns from my perspective:

1. Right now ip comes in around 650k unstripped; libbpf.a for 0.0.7 is
around 1.2M with the size of libbpf.o > than ip. Most likely, making
iproute2 use libbpf statically is going to be challenging and I am not
sure it is the right thing to do (unless the user is building a static
version of iproute2 commands).

2. git submodules can be a PITA to deal with (e.g., jumping between
branches and versions), so there needs to be a good reason for it.

3. iproute2 code needs to build for a wide range of OSes and not lose
functionality compared to what it has today.
