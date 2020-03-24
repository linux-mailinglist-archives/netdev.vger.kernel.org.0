Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBA0A190323
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 02:01:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbgCXBBj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 21:01:39 -0400
Received: from mail-qv1-f66.google.com ([209.85.219.66]:42930 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727031AbgCXBBj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 21:01:39 -0400
Received: by mail-qv1-f66.google.com with SMTP id ca9so8402301qvb.9;
        Mon, 23 Mar 2020 18:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TW2jB9QMtDw8rM7J2WGbhFFxXgWFrEfp6IZyuoY8VXM=;
        b=RlQ5gzu3JCGrstWPMCfs6GQqLRZEyIIY9v5bfYSPyfGUZWxCDNj5nAGznzYcVdGFcp
         O8mQIJM9MCTeSDa+xeoNHBLBUdKIsfM7OdDrvGmJbdIAPNWKvltgI+whtwjIcCVyLPJY
         572bG5bLHBicyZuikqI0xMka/bCKJ8TmmDZ5wMxLL6D22Qkm9oRQ2z+6qpaji5Ote/DL
         wdquibPmq2ZP0JUuvW3J1s/JAJoRcmFwgvlS9Jya7aoRsYKlMgrcQCHMRA8WjmH/1J6n
         rwtu8j0Vej4WiRbK/jV0IfVRfvrLlVQ8VGxjgdmKrDRkBnlIk9Cqf+SPUR+Q91ba0yCY
         bWLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TW2jB9QMtDw8rM7J2WGbhFFxXgWFrEfp6IZyuoY8VXM=;
        b=Oe6mdE7AnezYXxdbAb7o271xb3Wf6cWENuAtFnzqx/FSZNnFgl03NTD4kBPrBJtWMm
         oxVDN7SFg14yfKZGde3B9U/RDirscgd3B5DlZQuqbNYxzXtw4IfKjfVDjbBTB94qTORh
         59eDpL/37mv71KVF2USP9C4pghwEn//0I6gVNwDXI7WMgg+o+cUG6/yZq745I/gUZso1
         4oVQh7gZtPX/Hb9+I68sKNv4P04vVjOdltnOlzICT7NJG0S0gVTCOjeHSADdjj/7Ts6m
         ApnHYhA+sjbd0AkV7C3MvPlidVHaUR7oLLB4ZpiJqlrwywdDVol4/ScWjTZHE2MGCOqJ
         oVzg==
X-Gm-Message-State: ANhLgQ3uUIo/AyNPjWLtL+xMJ6cs+4EPTsNwpur4JmHW9m3+jhXYU1Kl
        uwEJ48gVBoU7pEQZqmdATwd6WkWZ
X-Google-Smtp-Source: ADFU+vsaORhCP1+yZaDUM9Zx7HApp1Vp3mkR4I3AR1Vsy5LQER45AWRmnUpPynaDOu/Iwkj71HkcEg==
X-Received: by 2002:a05:6214:20c:: with SMTP id i12mr23658937qvt.48.1585011696266;
        Mon, 23 Mar 2020 18:01:36 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:ec36:91c:efc1:e971? ([2601:282:803:7700:ec36:91c:efc1:e971])
        by smtp.googlemail.com with ESMTPSA id f16sm13683783qtk.61.2020.03.23.18.01.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2020 18:01:35 -0700 (PDT)
Subject: Re: [PATCH bpf-next 1/4] xdp: Support specifying expected existing
 program when attaching XDP
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Andrey Ignatov <rdna@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
References: <158462359206.164779.15902346296781033076.stgit@toke.dk>
 <158462359315.164779.13931660750493121404.stgit@toke.dk>
 <20200319155236.3d8537c5@kicinski-fedora-PC1C0HJN> <875zez76ph.fsf@toke.dk>
 <20200320103530.2853c573@kicinski-fedora-PC1C0HJN>
 <5e750bd4ebf8d_233f2ab4c81425c4ce@john-XPS-13-9370.notmuch>
 <CAEf4BzbWa8vdyLuzr_nxFM3BtT+hhzjCe9UQF8Y5cN+sVqa72g@mail.gmail.com>
 <87tv2f48lp.fsf@toke.dk>
 <CAEf4BzYutqP0yAy-KyToUNHM6Z-6C-XaEwK25pK123gejG0s9Q@mail.gmail.com>
 <87h7ye3mf3.fsf@toke.dk>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <1dfae7b8-4f80-13b8-c67c-82fe0a34f42a@gmail.com>
Date:   Mon, 23 Mar 2020 19:01:33 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <87h7ye3mf3.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/23/20 1:23 PM, Toke Høiland-Jørgensen wrote:
>>>> I agree here. And yes, I've been working on extending bpf_link into
>>>> cgroup and then to XDP. We are still discussing some cgroup-specific
>>>> details, but the patch is ready. I'm going to post it as an RFC to get
>>>> the discussion started, before we do this for XDP.
>>>
>>> Well, my reason for being skeptic about bpf_link and proposing the
>>> netlink-based API is actually exactly this, but in reverse: With
>>> bpf_link we will be in the situation that everything related to a netdev
>>> is configured over netlink *except* XDP.

+1

>>
>> One can argue that everything related to use of BPF is going to be
>> uniform and done through BPF syscall? Given variety of possible BPF
>> hooks/targets, using custom ways to attach for all those many cases is
>> really bad as well, so having a unifying concept and single entry to
>> do this is good, no?
> 
> Well, it depends on how you view the BPF subsystem's relation to the
> rest of the kernel, I suppose. I tend to view it as a subsystem that
> provides a bunch of functionality, which you can setup (using "internal"
> BPF APIs), and then attach that object to a different subsystem
> (networking) using that subsystem's configuration APIs.
> 

again, +1.

bpf syscall is used for program related manipulations like load and
unload. Attaching that program to an object has a type unique solution -
e.g., netlink for XDP and ioctl for perf_events.
