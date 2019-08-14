Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D39888CCEC
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 09:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727309AbfHNHeD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 03:34:03 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:40594 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726373AbfHNHeD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 03:34:03 -0400
Received: by mail-pg1-f194.google.com with SMTP id w10so52644234pgj.7;
        Wed, 14 Aug 2019 00:34:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qj5NILBPQh83BqkK6h+f4owNb7XWASz2eTmp6F/uJQ8=;
        b=U3aervMuhZRPBiAbRA7MZaiEejdwE17EU1cNUFF89p1mndJcYy9Us5cIQnCPhqYBbr
         /Tb7kNFHUen0Uay9owGgWm9TawgJXc45ZVnUyMnu8QO+0ulO+7zsptkmMIJ1OP0F1UOH
         2+cUW7P6IIgkXnws3M1KZ/RmoNCSTDoN15+5aa845N7X0XtNFo1dbn/C+b+Drv4q7M7u
         QV2WAzGk5y/TYXznKbw33OXDBiVgI3m95tldpddxptJWPF9haMzgYihjQLS+rUHeQsSE
         VP4tVtAb2RtRLQCFYss8L/brLm7k4Vyh3QXQmcenwyyA7r8+T9ku1jU8dRH6s/OrAPzu
         FGXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qj5NILBPQh83BqkK6h+f4owNb7XWASz2eTmp6F/uJQ8=;
        b=qIz2z2vP8p2BFliIXmOLNsyKfjYf2Gw1tY+hvB0l7Gg7sUE8QHoY0oHsxLI3xxh+MN
         D/EOeQtiUSTwDKDGf8o8i8FEjDHhLGBaq7mBFiwRN9TBYg/mk+0vVOvwSBIquFrG3xJG
         R+GfsBHWnt284RSJsmpi6Ray8ejwWmKcRgY5qmQWlX/VjCc1rvdvI3NT7lk1M7VB1dWB
         Ei+H/RJWuZf7EWZvq6Dyp/4YMg6SMm18IgW9/5VlzpwUsZQR+Q/OJMfZSK766sdolGam
         jYXOk8GIuJ6OxE9o8wHFswgx3NTjW5FUTVJrdMXn315eVtz+RrDqDpgLv0jZUHgs5rYD
         PLYw==
X-Gm-Message-State: APjAAAVqeTPQBlYQsuDsfcmst4uFRiPGM8E/ElThdSNObxVQ8ydOkcY9
        SaE5YHlUkIyLAoDWHk8Fd10=
X-Google-Smtp-Source: APXvYqwUMQ5RskXWhEzNCQJucQGnSFaIJogIkSamtFEOdbfCbfls9UxnnvURXeEH2y+HKD6ZPwLRcg==
X-Received: by 2002:aa7:914e:: with SMTP id 14mr44853503pfi.136.1565768042412;
        Wed, 14 Aug 2019 00:34:02 -0700 (PDT)
Received: from [172.20.20.103] ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id l1sm158014289pfl.9.2019.08.14.00.33.58
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Aug 2019 00:34:01 -0700 (PDT)
Subject: Re: [RFC PATCH bpf-next 00/14] xdp_flow: Flow offload to XDP
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
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
 <20190814014445.3dnduyrass5jycr5@ast-mbp>
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
Message-ID: <f6160572-8fa8-0199-8d81-6159dd4cd5ff@gmail.com>
Date:   Wed, 14 Aug 2019 16:33:56 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190814014445.3dnduyrass5jycr5@ast-mbp>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexei, thank you for taking a look!

On 2019/08/14 10:44, Alexei Starovoitov wrote:
> On Tue, Aug 13, 2019 at 09:05:44PM +0900, Toshiaki Makita wrote:
>> This is a rough PoC for an idea to offload TC flower to XDP.
> ...
>>   xdp_flow  TC        ovs kmod
>>   --------  --------  --------
>>   4.0 Mpps  1.1 Mpps  1.1 Mpps
> 
> Is xdp_flow limited to 4 Mpps due to veth or something else?

Looking at perf, accumulation of each layer's overhead resulted in the number.
With XDP prog which only redirects packets and does not touch the data,
the drop rate is 10 Mpps. In this case the main overhead is XDP's redirect processing
and handling of 2 XDP progs (in veth and i40e).
In the xdp_flow test the overhead additionally includes flow key parse in XDP prog
and hash table lookup (including jhash calculation) which resulted in 4 Mpps.

>> So xdp_flow drop rate is roughly 4x faster than software TC or ovs kmod.
>>
>> OTOH the time to add a flow increases with xdp_flow.
>>
>> ping latency of first packet when veth1 does XDP_PASS instead of DROP:
>>
>>   xdp_flow  TC        ovs kmod
>>   --------  --------  --------
>>   25ms      12ms      0.6ms
>>
>> xdp_flow does a lot of work to emulate TC behavior including UMH
>> transaction and multiple bpf map update from UMH which I think increases
>> the latency.
> 
> make sense, but why vanilla TC is so slow ?

No ideas. At least TC requires additional syscall to insert a flow compared to ovs kmod,
but 12 ms looks too long for that.

>> * Implementation
>>
>> xdp_flow makes use of UMH to load an eBPF program for XDP, similar to
>> bpfilter. The difference is that xdp_flow does not generate the eBPF
>> program dynamically but a prebuilt program is embedded in UMH. This is
>> mainly because flow insertion is considerably frequent. If we generate
>> and load an eBPF program on each insertion of a flow, the latency of the
>> first packet of ping in above test will incease, which I want to avoid.
> 
> I think UMH approach is a good fit for this.
> Clearly the same algorithm can be done as kernel code or kernel module, but
> bpfilter-like UMH is a safer approach.
> 
>> - patch 9
>>   Add tc-offload-xdp netdev feature and hooks to call xdp_flow kmod in
>>   TC flower offload code.
> 
> The hook into UMH from TC looks simple. Do you expect the same interface to be
> reused from OVS ?

Do you mean openvswitch kernel module by OVS?
If so, no, at this point. TC hook is simple because I reused flow offload mechanism.
OVS kmod does not have offload interface and ovs-vswitchd is using TC for offload.
I wanted to reuse this mechanism for offloading to XDP, so using TC.

>> * About alternative userland (ovs-vswitchd etc.) implementation
>>
>> Maybe a similar logic can be implemented in ovs-vswitchd offload
>> mechanism, instead of adding code to kernel. I just thought offloading
>> TC is more generic and allows wider usage with direct TC command.
>>
>> For example, considering that OVS inserts a flow to kernel only when
>> flow miss happens in kernel, we can in advance add offloaded flows via
>> tc filter to avoid flow insertion latency for certain sensitive flows.
>> TC flower usage without using OVS is also possible.
>>
>> Also as written above nftables can be offloaded to XDP with this
>> mechanism as well.
> 
> Makes sense to me.
> 
>>    bpf, hashtab: Compare keys in long
> 
> 3Mpps vs 4Mpps just from this patch ?
> or combined with i40 prefech patch ?

Combined.

>>   drivers/net/ethernet/intel/i40e/i40e_txrx.c  |    1 +
> 
> Could you share "perf report" for just hash tab optimization
> and for i40 ?

Sure, I'll get some more data and post them.

> I haven't seen memcmp to be bottle neck in hash tab.
> What is the the of the key?

typo of "size of the key"? IIRC 64 bytes.

Toshiaki Makita
