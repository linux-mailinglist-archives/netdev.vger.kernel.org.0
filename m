Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCD708F854
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 03:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726183AbfHPBJg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 21:09:36 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:34896 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725440AbfHPBJg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 21:09:36 -0400
Received: by mail-pl1-f194.google.com with SMTP id gn20so1747626plb.2;
        Thu, 15 Aug 2019 18:09:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1YMHTogQxms124knKvOrhV4+uPKPBj4yRMMTsLFzfAQ=;
        b=Y73dfJIL8GcU9PVBfZcWVtpLsdjcGk4E87sykad4dWHU3Gme8BXOifDxxtcP06d+jA
         bYA80CWez7+Kc0BWTU9SL3F9KGkSsiCsL5rraN+uEDVpxiolHCQcSp/iwEJjXLTVG4at
         g7gsWvoT4adSsnKEt/sPy/6kZsv04E3w+Q0AjkKdp+BNz2Z1SkJ92s031vKENDGU0b1x
         SJcanuMc6dKL1qqJ0vVheAZqtpZpa5EcjJe84EXH0+RMm47cohfO7jTmieeJTxIO4kNj
         ccXFV1V8BdW9nMl03YwnKZK8yRzd8Yr20WSE9SL9v0sfBvu+C9wEMqP0PXVF5LOpquzV
         yUXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1YMHTogQxms124knKvOrhV4+uPKPBj4yRMMTsLFzfAQ=;
        b=kY4JS8EgNaLqDufRuMVmJpDreh1Q5ykdAhsfnHOO5RpQJlo3iEeDbv39WMO+GGZOqM
         ZlxdLTA7awh+CSytby+abUMT7iWInSlluNq695RLLO3QRrX/bgRkYkJuq0UXDS3xAl7T
         /JNOTVO4AL4qjUS9xQMuzsCMkBGq61zcdX4LUkput5NBy2j9DPWAl9HvYkfos/x75dOp
         E0w47cjnflMt0GJ1jQfxtwozukaTONe0vYlWPg5jR7HE9at07GpMkq4d2GlETdD045D+
         LRrNkqC1c/oPB1RAq5B2KjZwcBD2IqZ7Sq7bHlqnFFsbQHchVkCZVyR4Svgyu00V3Xo7
         GsMw==
X-Gm-Message-State: APjAAAVUlowXJcsHG49ZgvIFcB59F4qfaI3L+EWjXPhEnsm9eoWg2zV+
        4OA0F7skkip+wEUdRZiQT9rL6RVY
X-Google-Smtp-Source: APXvYqwIC5ILNmOPeqjn0HH+UMYJLq2biuhwUqT1z1RQLlgt8VJyiMRosZi9n5ET7n2ZU9gNg06s7A==
X-Received: by 2002:a17:902:7448:: with SMTP id e8mr6821694plt.85.1565917775588;
        Thu, 15 Aug 2019 18:09:35 -0700 (PDT)
Received: from [172.20.20.103] ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id x17sm4157030pff.62.2019.08.15.18.09.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Aug 2019 18:09:34 -0700 (PDT)
Subject: Re: [RFC PATCH bpf-next 00/14] xdp_flow: Flow offload to XDP
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
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
 <14c4a876-6f5d-4750-cbe4-19622f64975b@gmail.com>
 <20190815152100.GN2820@mini-arch>
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
Message-ID: <4614fefc-fc43-8cf7-d064-7dc1947acc6c@gmail.com>
Date:   Fri, 16 Aug 2019 10:09:28 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190815152100.GN2820@mini-arch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/08/16 0:21, Stanislav Fomichev wrote:
> On 08/15, Toshiaki Makita wrote:
>> On 2019/08/15 2:07, Stanislav Fomichev wrote:
>>> On 08/13, Toshiaki Makita wrote:
>>>> * Implementation
>>>>
>>>> xdp_flow makes use of UMH to load an eBPF program for XDP, similar to
>>>> bpfilter. The difference is that xdp_flow does not generate the eBPF
>>>> program dynamically but a prebuilt program is embedded in UMH. This is
>>>> mainly because flow insertion is considerably frequent. If we generate
>>>> and load an eBPF program on each insertion of a flow, the latency of the
>>>> first packet of ping in above test will incease, which I want to avoid.
>>> Can this be instead implemented with a new hook that will be called
>>> for TC events? This hook can write to perf event buffer and control
>>> plane will insert/remove/modify flow tables in the BPF maps (contol
>>> plane will also install xdp program).
>>>
>>> Why do we need UMH? What am I missing?
>>
>> So you suggest doing everything in xdp_flow kmod?
> You probably don't even need xdp_flow kmod. Add new tc "offload" mode
> (bypass) that dumps every command via netlink (or calls the BPF hook
> where you can dump it into perf event buffer) and then read that info
> from userspace and install xdp programs and modify flow tables.
> I don't think you need any kernel changes besides that stream
> of data from the kernel about qdisc/tc flow creation/removal/etc.

My intention is to make more people who want high speed network easily use XDP,
so making transparent XDP offload with current TC interface.

What userspace program would monitor TC events with your suggestion?
ovs-vswitchd? If so, it even does not need to monitor TC. It can
implement XDP offload directly.
(However I prefer kernel solution. Please refer to "About alternative
userland (ovs-vswitchd etc.) implementation" section in the cover letter.)

Also such a TC monitoring solution easily can be out-of-sync with real TC
behavior as TC filter/flower is being heavily developed and changed,
e.g. introduction of TC block, support multiple masks with the same pref, etc.
I'm not sure such an unreliable solution have much value.

> But, I haven't looked at the series deeply, so I might be missing
> something :-)
> 
>> I also thought about that. There are two phases so let's think about them separately.
>>
>> 1) TC block (qdisc) creation / eBPF load
>>
>> I saw eBPF maintainers repeatedly saying eBPF program loading needs to be
>> done from userland, not from kernel, to run the verifier for safety.
>> However xdp_flow eBPF program is prebuilt and embedded in kernel so we may
>> allow such programs to be loaded from kernel? I currently don't have the will
>> to make such an API as loading can be done with current UMH mechanism.
>>
>> 2) flow insertion / eBPF map update
>>
>> Not sure if this needs to be done from userland. One concern is that eBPF maps can
>> be modified by unrelated processes and we need to handle all unexpected state of maps.
>> Such handling tends to be difficult and may cause unexpected kernel behavior.
>> OTOH updating maps from kmod may reduces the latency of flow insertion drastically.
> Latency from the moment I type 'tc filter add ...' to the moment the rule
> is installed into the maps? Does it really matter?

Yes it matters. Flow insertion is kind of data path in OVS.
Please see how ping latency is affected in the cover letter.

> Do I understand correctly that both of those events (qdisc creation and
> flow insertion) are triggered from tcf_block_offload_cmd (or similar)?

Both of eBPF load and map update are triggered from tcf_block_offload_cmd.
I think you understand it correctly.

Toshiaki Makita
