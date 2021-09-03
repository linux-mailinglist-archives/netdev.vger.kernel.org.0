Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69602400260
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 17:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235586AbhICPee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 11:34:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349957AbhICPe3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 11:34:29 -0400
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E467EC061575
        for <netdev@vger.kernel.org>; Fri,  3 Sep 2021 08:33:28 -0700 (PDT)
Received: by mail-qv1-xf32.google.com with SMTP id 93so2730409qva.7
        for <netdev@vger.kernel.org>; Fri, 03 Sep 2021 08:33:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5LIFlHyVvDkGF8a3JZWS1aY7iXtng1vYiBB9lPA6m9g=;
        b=tPOkMM9Sih11n6LDTAqxVhivFJ5Lv9zlCYbfZK1dUUAlaq2dGb2NjQS7CxTrxjMuXj
         eJG7OlsMpakC1gdxmmkHSbXJEHPch/Wy6n9iJerGCChmAwE89oa5aXBaKc95uI8hR8rD
         hqep19gn6wK32SSWNdVghNMiU8KZcVKYryxo/RxsdnOBZLtHncsZLoGLfuOYiOwog+l3
         AV73P9wlVbCmdGnJvpFM/VALgl71cshHgII7qR21WWSbkycnIsOOCsJ1mPK8yKRDwvZD
         KhClacAKV4nJA0p+6M9I0POP1S9sEQs3noz8Lf99aEPcDT121jVKqB5XrvDPMueLTmuy
         Grag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5LIFlHyVvDkGF8a3JZWS1aY7iXtng1vYiBB9lPA6m9g=;
        b=ixB+Ec8T06pkZDqL6NT+dMzJ+w+umatPSdWG92fWx3j9UDqLtssRFj+fcN/2QXT8bN
         /hQdMfySlLKr13QRfcaAxXVHEfz3F1RI7bUygUbwwen47UBRKlTOZE7bBv2AdKI3bYQM
         gcnfmmSb5bpcSK2FjmzkMjbXjsGO0mJuTlr0ZW0KVCmtmUmWfqkJAtVFlC/PzRBQB7uB
         5QtXwOwUTD+E0srW18lNPITOGzJBMv3eKDJrioc0vA6hOnj3J+106EKcvGWkKSlrm3sh
         7jjD8v1biF0lGdUbi77cUT1MIPf5atsU3ndwB7Sz+6AunO6TTXFj1C/8X4kqZf3cvdsI
         Sdag==
X-Gm-Message-State: AOAM531S3LizI0pPhSEOJl05sZ8kETzxfN3eTb8UEzVBgMklfSgZ0ZyE
        B7EBj3ZcRl8bAOU42Y9GETnjoA==
X-Google-Smtp-Source: ABdhPJwrFpeuTZR0dZ65llC0a5kZc0Winn4XlibHIE56DOfJYnAG1NIrAcfshejiQsi0qh1O4SPLeQ==
X-Received: by 2002:a0c:a995:: with SMTP id a21mr4401372qvb.35.1630683208154;
        Fri, 03 Sep 2021 08:33:28 -0700 (PDT)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-28-184-148-47-47.dsl.bell.ca. [184.148.47.47])
        by smtp.googlemail.com with ESMTPSA id k20sm4140441qko.117.2021.09.03.08.33.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Sep 2021 08:33:27 -0700 (PDT)
Subject: Re: [RFC Patch net-next] net_sched: introduce eBPF based Qdisc
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Martin KaFai Lau <kafai@fb.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>,
        Jiri Pirko <jiri@resnulli.us>
References: <20210821010240.10373-1-xiyou.wangcong@gmail.com>
 <20210824234700.qlteie6al3cldcu5@kafai-mbp>
 <CAM_iQpWP_kvE58Z+363n+miTQYPYLn6U4sxMKVaDvuRvjJo_Tg@mail.gmail.com>
 <612f137f4dc5c_152fe20891@john-XPS-13-9370.notmuch> <871r68vapw.fsf@toke.dk>
 <20210901174543.xukawl7ylkqzbuax@kafai-mbp.dhcp.thefacebook.com>
 <871r66ud8y.fsf@toke.dk> <613136d0cf411_2c56f2086@john-XPS-13-9370.notmuch>
 <87bl5asjdj.fsf@toke.dk>
 <20210902233510.gnimg2krwwkzv4f2@kafai-mbp.dhcp.thefacebook.com>
 <87zgstra6j.fsf@toke.dk>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <ea37c208-5192-4008-3f92-b12fd8a8ea1a@mojatatu.com>
Date:   Fri, 3 Sep 2021 11:33:26 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <87zgstra6j.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-09-03 10:44 a.m., Toke Høiland-Jørgensen wrote:
> Martin KaFai Lau <kafai@fb.com> writes:
> 
>> On Fri, Sep 03, 2021 at 12:27:52AM +0200, Toke Høiland-Jørgensen wrote:
>>>>> The question is if it's useful to provide the full struct_ops for
>>>>> qdiscs? Having it would allow a BPF program to implement that interface
>>>>> towards userspace (things like statistics, classes etc), but the
>>>>> question is if anyone is going to bother with that given the wealth of
>>>>> BPF-specific introspection tools already available?
>> Instead of bpftool can only introspect bpf qdisc and the existing tc
>> can only introspect kernel qdisc,  it will be nice to have bpf
>> qdisc work as other qdisc and showing details together with others
>> in tc.  e.g. a bpf qdisc export its data/stats with its btf-id
>> to tc and have tc print it out in a generic way?
> 
> I'm not opposed to the idea, certainly. I just wonder if people who go
> to the trouble of writing a custom qdisc in BPF will feel it's worth it
> to do the extra work to make this available via a second API. We could
> certainly encourage it, and some things are easy (drop and pkt counters,
> etc), but other things (like class stats) will depend on the semantics
> of the qdisc being implemented, so will require extra work from the BPF
> qdisc developer...

The idea of using btf to overcome the domain difference is _very_
appealing but sounds like a lot of work? Havent delved enough
into btf - but wondering if the same could be stated for filters
and actions...Note:
Aside from current existing tooling being well understood,
challenges  you will be faced with is reinventing all the
infrastructure that tc qdiscs have taken care of over the years,
example:
the proper integrations with softirqs and multiprocessor protections,
irqs, timers etc which take care of smooth triggering of
enqueue/dequeue, taking care of defering things when the target
device/hw is busy, hierarchies, etc, etc;
not saying it is the most perfect or performant but it is one of
those 'day 3' deployments i.e a lot of corner cases taken care of.
I noticed you mentioned some of those things in one of your emails.
For this reason - Cong's approach looks appealing because it
reuses said infra. Main thing that needs to have extensibility is
the de/enqueue ops as ebpf progs. Allowing enq/deq to be ebpf specific
sounds like will allow one scheme that works for both tc and XDP
(with enq/deq taking care of the buffer contextual differences).
I admit XDP is a little harder than plain tc....

cheers,
jamal


