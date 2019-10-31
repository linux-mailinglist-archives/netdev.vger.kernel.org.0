Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 680EAEAFE9
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 13:12:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbfJaMMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 08:12:14 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:24782 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726462AbfJaMMO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 08:12:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572523932;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sg2kihRjjgIQkH/w1dLyFs7FBPG7gi2l8czoqmJwrAo=;
        b=EnI9tLyhXvLvZebve8Vkb1ng4N9fISSPg2KR/EyZVg+5i+t2yn9Ixr/gp0lHtdB0yzTTeC
        UBaZ226uk+NF6Rzk2/SJKKQD+5FFhaoqlhJWC6Sqw5I48lyVKLca+dKFSJY8Qwd1t9s5rp
        +s8mvs/ViZuxP83WLM7MV5RHwWAGCiU=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-217-MhHFd3OONMGPVqqRGJem7g-1; Thu, 31 Oct 2019 08:12:10 -0400
Received: by mail-lf1-f71.google.com with SMTP id c13so1306036lfk.23
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 05:12:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=WFDBGr9Ywa4IUDdAKK/ciZtmngvMAKi5lQDjdYRC0uM=;
        b=af6T4tAFP8blS53m7ZhGx2uqYfX+1FmCh2SYXmLVC7DmgsUenqdjh66PxFUwjylfgc
         5MDxpvXms0ujYqhiJ3GzDsVJpaH2F0zvizZ6z7xnEf3pHI89rwmNtHh++RotCAlJ4K+S
         Pe9ld3Mj1hwH+O6c6kHOQiKow97FI+UZb2EGqPALFb4O/oJNw951Y1swyBGkOGcHbrGC
         abj5+eAdSbgtAWGOVlOqUlHP+79qdZjNZ/TkSwgx+e2SM6d5pSKm3XWh+IPyq+jAgnzw
         1/WUaoyFTOsp7DK7B1ENJMZWKzfOvvxAD0Spo8GvddPaincHygd0aEgNmRqyJdgzK7G9
         IAGw==
X-Gm-Message-State: APjAAAVYE/KS7Np6yBISo5dT+CcIEXBjEkVji2HzchPzPnb2BttQLvCF
        BQLA6YhjD1RLxXeNJbVc6JyjqBiHK0pba48o5IMDTTXuXw46GA3pVPdtqEUcnv+MMaNXL0CE1EC
        +CFHrr7daA1iEGCzK
X-Received: by 2002:a2e:82cd:: with SMTP id n13mr3899690ljh.2.1572523929546;
        Thu, 31 Oct 2019 05:12:09 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzutWi8V1kbCaY6gZfirhl0dF87096w5grmFMNrO2/Eane2hIEhWDBIPpyTRok9dMDGs3ir/w==
X-Received: by 2002:a2e:82cd:: with SMTP id n13mr3899658ljh.2.1572523929255;
        Thu, 31 Oct 2019 05:12:09 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id g26sm1548451lfh.1.2019.10.31.05.12.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Oct 2019 05:12:08 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 139331818B5; Thu, 31 Oct 2019 13:12:07 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Toshiaki Makita <toshiaki.makita1@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Pravin B Shelar <pshelar@ovn.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        William Tu <u9012063@gmail.com>,
        Stanislav Fomichev <sdf@fomichev.me>
Subject: Re: [RFC PATCH v2 bpf-next 00/15] xdp_flow: Flow offload to XDP
In-Reply-To: <b2ecf3e6-a8f1-cfd9-0dd3-e5f4d5360c0b@gmail.com>
References: <20191018040748.30593-1-toshiaki.makita1@gmail.com> <5da9d8c125fd4_31cf2adc704105c456@john-XPS-13-9370.notmuch> <22e6652c-e635-4349-c863-255d6c1c548b@gmail.com> <5daf34614a4af_30ac2b1cb5d205bce4@john-XPS-13-9370.notmuch> <87h840oese.fsf@toke.dk> <5db128153c75_549d2affde7825b85e@john-XPS-13-9370.notmuch> <87sgniladm.fsf@toke.dk> <a7f3d86b-c83c-7b0d-c426-684b8dfe4344@gmail.com> <87zhhmrz7w.fsf@toke.dk> <b2ecf3e6-a8f1-cfd9-0dd3-e5f4d5360c0b@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 31 Oct 2019 13:12:07 +0100
Message-ID: <87zhhhnmg8.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: MhHFd3OONMGPVqqRGJem7g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toshiaki Makita <toshiaki.makita1@gmail.com> writes:

> On 2019/10/28 0:21, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Toshiaki Makita <toshiaki.makita1@gmail.com> writes:
>>>> Yeah, you are right that it's something we're thinking about. I'm not
>>>> sure we'll actually have the bandwidth to implement a complete solutio=
n
>>>> ourselves, but we are very much interested in helping others do this,
>>>> including smoothing out any rough edges (or adding missing features) i=
n
>>>> the core XDP feature set that is needed to achieve this :)
>>>
>>> I'm very interested in general usability solutions.
>>> I'd appreciate if you could join the discussion.
>>>
>>> Here the basic idea of my approach is to reuse HW-offload infrastructur=
e
>>> in kernel.
>>> Typical networking features in kernel have offload mechanism (TC flower=
,
>>> nftables, bridge, routing, and so on).
>>> In general these are what users want to accelerate, so easy XDP use als=
o
>>> should support these features IMO. With this idea, reusing existing
>>> HW-offload mechanism is a natural way to me. OVS uses TC to offload
>>> flows, then use TC for XDP as well...
>>=20
>> I agree that XDP should be able to accelerate existing kernel
>> functionality. However, this does not necessarily mean that the kernel
>> has to generate an XDP program and install it, like your patch does.
>> Rather, what we should be doing is exposing the functionality through
>> helpers so XDP can hook into the data structures already present in the
>> kernel and make decisions based on what is contained there. We already
>> have that for routing; L2 bridging, and some kind of connection
>> tracking, are obvious contenders for similar additions.
>
> Thanks, adding helpers itself should be good, but how does this let users
> start using XDP without having them write their own BPF code?

It wouldn't in itself. But it would make it possible to write XDP
programs that could provide the same functionality; people would then
need to run those programs to actually opt-in to this.

For some cases this would be a simple "on/off switch", e.g.,
"xdp-route-accel --load <dev>", which would install an XDP program that
uses the regular kernel routing table (and the same with bridging). We
are planning to collect such utilities in the xdp-tools repo - I am
currently working on a simple packet filter:
https://github.com/xdp-project/xdp-tools/tree/xdp-filter

For more advanced use cases (such as OVS), the application packages will
need to integrate and load their own XDP support. We should encourage
that, and help smooth out any rough edges (such as missing features)
needed for this to happen.

-Toke

