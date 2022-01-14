Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAA2A48EEB2
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 17:51:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243606AbiANQul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 11:50:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:41217 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243595AbiANQui (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 11:50:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642179038;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Aog+Xm4qfU3nqJAaFVSSDCOw9xaUbeG0yHB/PP3Bm0g=;
        b=eWalXGnA2nzwy1bkREv+UeYevFOmkyQAVGuFh8jnYoyj2L32cZxJfvbr9Z+JtbZtanEbAP
        cIuM8l+xhfD+YoQotoqyN9487SVKWWnhdm/KHeukU1NYLJy1PQFGhPUQWZLuzdxcIkD3f6
        je4KhN9Z60Oy/7F/OOJoRUaBXNKu+XE=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-125-UDUspUinMTeR3zJoJZGBpg-1; Fri, 14 Jan 2022 11:50:27 -0500
X-MC-Unique: UDUspUinMTeR3zJoJZGBpg-1
Received: by mail-ed1-f71.google.com with SMTP id y18-20020a056402271200b003fa16a5debcso8607009edd.14
        for <netdev@vger.kernel.org>; Fri, 14 Jan 2022 08:50:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent:cc
         :subject:content-language:to:references:in-reply-to
         :content-transfer-encoding;
        bh=Aog+Xm4qfU3nqJAaFVSSDCOw9xaUbeG0yHB/PP3Bm0g=;
        b=CQltSAYw7bpw/H/YIoIvXQPE1XQNXlTkhIPh+235r8UMOTHQLVjigCFAF3ZXvDdtdR
         9V/LDk7OC8Z87bFd30O/s2LzrWljwA0H711ZLd1SVJIe3peiVmc+dMHAx6Sh+8Xulutc
         OSKtqR2LbgPsi4y4dmA24mfZJa9wCeD/wE94ckdrlsaO9tIsWZ3roL2QCvMMfyJ7uD9+
         MZquEAefAaJLuGSx29mP9z16SVKo6LKeJv4pegvMMJ8zIR3+UvmQOdg8FylsfVMDT0dQ
         nY+PyRnouL4hTRDO7h8xjwPB2sq/ZOBawue9ZbN7gIWAKV7o5feFsccC0ya7Uq+kNGn0
         Vx4g==
X-Gm-Message-State: AOAM531afJZvg1qRZSnHDtiL0IPT6Nj+0i8grMNMvwF4Rr7SeoSqFHOq
        MQUiJ3NQs4AZw9etpMW3hV1Ion4alPgtXCiJaLjURo4i2FFDWy1m4TzerYE7zIBVC9S9WvQZfTG
        5wJ79NpaRqNrQvY3f
X-Received: by 2002:a17:907:6e89:: with SMTP id sh9mr7871931ejc.309.1642179026589;
        Fri, 14 Jan 2022 08:50:26 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx289mMFaskSpHlDQKd6krI58HMAi62MQ740w6gblEPsMNl6GOH2PzyU4F3wqziA3sWWpEG6g==
X-Received: by 2002:a17:907:6e89:: with SMTP id sh9mr7871918ejc.309.1642179026343;
        Fri, 14 Jan 2022 08:50:26 -0800 (PST)
Received: from [192.168.2.20] (3-14-107-185.static.kviknet.dk. [185.107.14.3])
        by smtp.gmail.com with ESMTPSA id s3sm1982831ejs.145.2022.01.14.08.50.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jan 2022 08:50:25 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <e86ccea8-af77-83bf-e90e-dce88b26f07c@redhat.com>
Date:   Fri, 14 Jan 2022 17:50:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Cc:     brouer@redhat.com, Jesper Dangaard Brouer <jbrouer@redhat.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Zvi Effron <zeffron@riotgames.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Shay Agroskin <shayagr@amazon.com>,
        john fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        tirthendu.sarkar@intel.com
Subject: Re: [PATCH v21 bpf-next 18/23] libbpf: Add SEC name for xdp_mb
 programs
Content-Language: en-US
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
References: <CAEf4Bza+WO5U+Kw=S+GvQBgu5VHfPL29u7eLSQq34jvYzGnbBA@mail.gmail.com>
 <CAADnVQLGxjvOO3Ae3mGTWTyd0aHnACxYoF8daNi+z56NQyYQug@mail.gmail.com>
 <CAEf4BzZ4c1VwPf9oBRRdN7jdBWrk4pg=mw_50LMjLr99Mb0yfw@mail.gmail.com>
 <CAADnVQ+BiMy4TZNocfFSvazh-QTFwMD-3uQ9LLiku7ePLDn=MQ@mail.gmail.com>
 <CAC1LvL0CeTw+YKjO6r0f68Ly3tK4qhDyjV0ak82e0PpHURVQOw@mail.gmail.com>
 <Yd82J8vxSAR9tvQt@lore-desk> <8735lshapk.fsf@toke.dk>
 <47a3863b-080c-3ac2-ff2d-466b74d82c1c@redhat.com>
 <Yd/9SPHAPH3CpSnN@lore-desk>
 <CAADnVQJaB8mmnD1Z4jxva0CqA2D0aQDmXggMEQPX2MRLZvoLzA@mail.gmail.com>
 <YeC8sOAeZjpc4j8+@lore-desk>
 <CAADnVQ+=0k1YBbkMmSKSBtkmiG8VCYZ5oKGjPPr4s9c53QF-mQ@mail.gmail.com>
In-Reply-To: <CAADnVQ+=0k1YBbkMmSKSBtkmiG8VCYZ5oKGjPPr4s9c53QF-mQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 14/01/2022 03.09, Alexei Starovoitov wrote:
> On Thu, Jan 13, 2022 at 3:58 PM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>>>
>>> Btw "xdp_cpumap" should be cleaned up.
>>> xdp_cpumap is an attach type. It's not prog type.
>>> Probably it should be "xdp/cpumap" to align with "cgroup/bind[46]" ?
>>
>> so for xdp "mb" or xdp "frags" it will be xdp/cpumap.mb (xdp/devmap.mb) or
>> xdp/cpumap.frags (xdp/devmap.frags), right?
> 
> xdp.frags/cpumap
> xdp.frags/devmap
> 
> The current de-facto standard for SEC("") in libbpf:
> prog_type.prog_flags/attach_place

Ups, did we make a mistake with SEC("xdp_devmap/")

and can we correct without breaking existing programs?

> "attach_place" is either function_name for fentry/, tp/, lsm/, etc.
> or attach_type/hook/target for cgroup/bind4, cgroup_skb/egress.
> 
> lsm.s/socket_bind -> prog_type = LSM, flags = SLEEPABLE
> lsm/socket_bind -> prog_type = LSM, non sleepable.
> 

