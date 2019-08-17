Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E75FA910B2
	for <lists+netdev@lfdr.de>; Sat, 17 Aug 2019 16:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726002AbfHQOKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Aug 2019 10:10:21 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:34063 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725929AbfHQOKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Aug 2019 10:10:20 -0400
Received: by mail-pf1-f193.google.com with SMTP id b24so4634046pfp.1;
        Sat, 17 Aug 2019 07:10:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=D08stjvpro3pBQEkt/xg9U3d/spYVftHRq2OktyQcuU=;
        b=FRtG4p4AM9MWI141V860dpTT0z7Hgt1NoJ8ZoEstcyLZ/eue5duUtUagyGVNAMwvkn
         Lxv5ieYoF2iWxrEE3ky0iQWKctg4A1k5nzqYrbZkwZJmJCy5Bt2bVb3Yrdz3D2PYI9LA
         eT33YHXrg4et/NPDY3Zz/Oato+mVbWsPgDvFQ4lDzldUFEM6in4IsFVY+CaBUK7JGBqJ
         Yq1FpqyyHJU+X+vD6FAETxpWPRlwhBz76sAt3n8cv8l+LmYW1E23zN2kxdtszpiAuRuF
         jrxXtfuC785akFKnkYeha35TUaJUT1RX56iQb5hSym/YlPCKCEnXFUcmk5g3hWxbHmRz
         oktw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=D08stjvpro3pBQEkt/xg9U3d/spYVftHRq2OktyQcuU=;
        b=uIqJb/LZ+Dfb5o6u8bhkV1AZVU5BTu0JwrQS/OexvvqbyNuJgAH0FCZ2I4ncS2Dfd7
         1qyo3zaOtO8lGwiBc2AQ8nk5KslcApKskN2yBysoFBHoUZVuaPCy6rCbskPHO8CHik17
         FlgkVphUh6QuyRpuEnzRkf2oxDW8/0MCS8dkL166D2y4bz0l8/30EaUANIzXpzIt8HH1
         LTkPBFE5E/daCsiz1Q3eYAsdmK0jPuz4WDrCKa5SG4xqh5MlEWWBpRn49UWQ9ejuiMoZ
         KMhOILIs1oGREm4CvkR5sg24IFIycC6fxudFfzXfwpuP/1rVzdnC9UYJBNRSpeSBP8ox
         Pqiw==
X-Gm-Message-State: APjAAAVNx3334NMC9axEum8pOCBva/gWxW/9lnCqaF90rXtSXE6jhUP8
        f58F4lWPVaZiDxMRyz4r95A=
X-Google-Smtp-Source: APXvYqyS+7YNkkIu6rZVfGSTFv26iTDSwMZG/k/xZGjh7JDy6pFF4OcDGt4qdo0y2Op2TQUyyrCvwA==
X-Received: by 2002:a63:ea50:: with SMTP id l16mr12409339pgk.160.1566051020011;
        Sat, 17 Aug 2019 07:10:20 -0700 (PDT)
Received: from ?IPv6:240d:2:6b22:5500:b8ce:7113:7b93:9494? ([240d:2:6b22:5500:b8ce:7113:7b93:9494])
        by smtp.googlemail.com with ESMTPSA id p1sm9943632pff.44.2019.08.17.07.10.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 17 Aug 2019 07:10:19 -0700 (PDT)
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
 <4614fefc-fc43-8cf7-d064-7dc1947acc6c@gmail.com>
 <20190816153550.GO2820@mini-arch>
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
Message-ID: <11ab8890-f876-250e-1a52-eab0bf057640@gmail.com>
Date:   Sat, 17 Aug 2019 23:10:10 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190816153550.GO2820@mini-arch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/08/17 (土) 0:35:50, Stanislav Fomichev wrote:
> On 08/16, Toshiaki Makita wrote:
>> On 2019/08/16 0:21, Stanislav Fomichev wrote:
>>> On 08/15, Toshiaki Makita wrote:
>>>> On 2019/08/15 2:07, Stanislav Fomichev wrote:
>>>>> On 08/13, Toshiaki Makita wrote:
>>>>>> * Implementation
>>>>>>
>>>>>> xdp_flow makes use of UMH to load an eBPF program for XDP, similar to
>>>>>> bpfilter. The difference is that xdp_flow does not generate the eBPF
>>>>>> program dynamically but a prebuilt program is embedded in UMH. This is
>>>>>> mainly because flow insertion is considerably frequent. If we generate
>>>>>> and load an eBPF program on each insertion of a flow, the latency of the
>>>>>> first packet of ping in above test will incease, which I want to avoid.
>>>>> Can this be instead implemented with a new hook that will be called
>>>>> for TC events? This hook can write to perf event buffer and control
>>>>> plane will insert/remove/modify flow tables in the BPF maps (contol
>>>>> plane will also install xdp program).
>>>>>
>>>>> Why do we need UMH? What am I missing?
>>>>
>>>> So you suggest doing everything in xdp_flow kmod?
>>> You probably don't even need xdp_flow kmod. Add new tc "offload" mode
>>> (bypass) that dumps every command via netlink (or calls the BPF hook
>>> where you can dump it into perf event buffer) and then read that info
>>> from userspace and install xdp programs and modify flow tables.
>>> I don't think you need any kernel changes besides that stream
>>> of data from the kernel about qdisc/tc flow creation/removal/etc.
>>
>> My intention is to make more people who want high speed network easily use XDP,
>> so making transparent XDP offload with current TC interface.
>>
>> What userspace program would monitor TC events with your suggestion?
> Have a new system daemon (xdpflowerd) that is independently
> packaged/shipped/installed. Anybody who wants accelerated TC can
> download/install it. OVS can be completely unaware of this.

Thanks, but that's what I called an unreliable solution...

>> ovs-vswitchd? If so, it even does not need to monitor TC. It can
>> implement XDP offload directly.
>> (However I prefer kernel solution. Please refer to "About alternative
>> userland (ovs-vswitchd etc.) implementation" section in the cover letter.)
>>
>> Also such a TC monitoring solution easily can be out-of-sync with real TC
>> behavior as TC filter/flower is being heavily developed and changed,
>> e.g. introduction of TC block, support multiple masks with the same pref, etc.
>> I'm not sure such an unreliable solution have much value.
> This same issue applies to the in-kernel implementation, isn't it?
> What happens if somebody sends patches for a new flower feature but
> doesn't add appropriate xdp support? Do we reject them?

Why can we accept a patch which breaks other in-kernel subsystem...
Such patches can be applied accidentally but we are supposed to fix such 
problems in -rc phase, aren't we?

Toshiaki Makita
