Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE918E8FE
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 12:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731402AbfHOK0o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 06:26:44 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:32896 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728500AbfHOK0n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 06:26:43 -0400
Received: by mail-pf1-f195.google.com with SMTP id g2so1164128pfq.0;
        Thu, 15 Aug 2019 03:26:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ivq6bPNC4Odf4YX0dM+xQIJIuVtnKxhLJ9VEaA8nd38=;
        b=BTIAMjenPCDqNriRn7WiFHq67MSB1eVlhF/dWPpSZyYZXOs/Hgks0vN34JHL/V31a6
         lUlH33BHytqjnSe0DfRPuoI4NkeeVPbABmu1UqxhqqjwwfJrqP6WQRypZ62eZzvnqRHG
         MKNf7rTEQGTdwaGlb1Fh7YMqcPJ1weIthHDczxrXw+mhLdEh5Yazqswr46dGsl25LJUd
         wAmz6gjEUIGWdUZiDFYggrgkJV6wykpkkH0WD3ZddXqZ7IAtjoz2jMzYNKUNWKjPNesG
         hhzJPGkY/dkVEcOErUuWcH8ueJGrq2cz/1xcked9NP1QQfdRAU8yWIsWy7pTuG+VJMsb
         0nrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ivq6bPNC4Odf4YX0dM+xQIJIuVtnKxhLJ9VEaA8nd38=;
        b=gKDbevlmWMS2ms+V7CttSQhIWyr9z4Srf0dq+TKl5Z5ftAtJB+261wFp16f9GHBCyh
         XEnfa6ms+D6lz9bXL9cNvSZDLYMv7GRr4WGOBmPFwfPpkoXwNX7uNeNqnTMhjEUBbQBT
         xyOd72BYi+iBswFxM1/bPJeyg1wCom/32YJhQE64SK0/pzAMzAj2uU2DNGDPHLiUOQTm
         GpogP2dsY9i3kP48W60/H5K9yotJwcfi3u2ZixbIrPDmZNu0UNju20TgtVKoOURvEk45
         iBLaqsLQD/SWdFMLcoFsuE/aW6aEwxN6rTlO2Ta5QLTDFold0li81LwM+YXxP0gAIEd0
         IZjg==
X-Gm-Message-State: APjAAAUFJ4BZqed9RN542+r4wu3ikpohKrGlSKrPcb6iGjhN7c4czphM
        K8rJ4RFO7NtK6bspMqsNF7w=
X-Google-Smtp-Source: APXvYqz4i9kR8vwZAmA62oQGsICrPUUvJAalWXZAvxTPIdkVioKPgFXOYaQC/Mmj18p7sqhh6JOa8w==
X-Received: by 2002:a63:6146:: with SMTP id v67mr3064063pgb.271.1565864802609;
        Thu, 15 Aug 2019 03:26:42 -0700 (PDT)
Received: from [172.20.20.103] ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id e188sm2296505pfa.76.2019.08.15.03.26.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Aug 2019 03:26:42 -0700 (PDT)
Subject: Re: [RFC PATCH bpf-next 00/14] xdp_flow: Flow offload to XDP
To:     Stanislav Fomichev <sdf@fomichev.me>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, William Tu <u9012063@gmail.com>
References: <20190813120558.6151-1-toshiaki.makita1@gmail.com>
 <20190814170715.GJ2820@mini-arch>
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
Message-ID: <14c4a876-6f5d-4750-cbe4-19622f64975b@gmail.com>
Date:   Thu, 15 Aug 2019 19:26:36 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190814170715.GJ2820@mini-arch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/08/15 2:07, Stanislav Fomichev wrote:
> On 08/13, Toshiaki Makita wrote:
>> * Implementation
>>
>> xdp_flow makes use of UMH to load an eBPF program for XDP, similar to
>> bpfilter. The difference is that xdp_flow does not generate the eBPF
>> program dynamically but a prebuilt program is embedded in UMH. This is
>> mainly because flow insertion is considerably frequent. If we generate
>> and load an eBPF program on each insertion of a flow, the latency of the
>> first packet of ping in above test will incease, which I want to avoid.
> Can this be instead implemented with a new hook that will be called
> for TC events? This hook can write to perf event buffer and control
> plane will insert/remove/modify flow tables in the BPF maps (contol
> plane will also install xdp program).
> 
> Why do we need UMH? What am I missing?

So you suggest doing everything in xdp_flow kmod?
I also thought about that. There are two phases so let's think about them separately.

1) TC block (qdisc) creation / eBPF load

I saw eBPF maintainers repeatedly saying eBPF program loading needs to be
done from userland, not from kernel, to run the verifier for safety.
However xdp_flow eBPF program is prebuilt and embedded in kernel so we may
allow such programs to be loaded from kernel? I currently don't have the will
to make such an API as loading can be done with current UMH mechanism.

2) flow insertion / eBPF map update

Not sure if this needs to be done from userland. One concern is that eBPF maps can
be modified by unrelated processes and we need to handle all unexpected state of maps.
Such handling tends to be difficult and may cause unexpected kernel behavior.
OTOH updating maps from kmod may reduces the latency of flow insertion drastically.

Alexei, Daniel, what do you think?

Toshiaki Makita
