Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 178E78F87D
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 03:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbfHPBiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 21:38:52 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:42029 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725440AbfHPBiw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 21:38:52 -0400
Received: by mail-pf1-f196.google.com with SMTP id i30so2247694pfk.9;
        Thu, 15 Aug 2019 18:38:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MmnS9ZKb8ksXTMQ9AUqNCldx9xFK1GdI6bBqkAoNaco=;
        b=DyMWGoGRd2JjJniKWT49nXY3ZGd4ZYkKRSzQ966KJCPMWxujLuZSJ4i8XMpEBFiBu9
         CE2CKGq/pw4pXPYXortoI6bgSvppqM3kFpx7/gothjzzUJJ+YoN5j1auEIqMJc5a91m9
         ejnXtaEjjE3xqp/wLwOam24tLwppbGcFS8YeS/ZU+Rji0/magySuXe5KmmxMV6C2jaPz
         mR6sRD71d5nsxtQ62WdYlRc2Xa5SaLcvWV+kuoUIxDdDEfyqcZo+gvTXr0+bsDmLHRZt
         Beexe1idghyWobt/qjFlAYtaLKrZcjZH26g4nZpWHPNhQnGr0hgTiBeqxYueObEtikjM
         r2PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MmnS9ZKb8ksXTMQ9AUqNCldx9xFK1GdI6bBqkAoNaco=;
        b=pSL8OLbQPNQFjEEu/Z3pegrBr5OLtFCQ9GpIVDQklN6GXGAF3T10wbpzK8tQyPswxY
         eekWGMPnl+wzRSUcdkFm2BTqUIqeNQgnDHCKXGeoVSBtP/6AE1KSdpZqQYd4IqUMJzJx
         A5UTxp71yB5yTOxABJo0OUY1n2aoSO5acietWGThYdFYwE/G2yIq76cDlbSyfK2OgWmM
         AYpIrOFdwvU8b31mpz9WeUCZMPYPBbhMZ93XDtd1P303sAq1wxbDIfzfqjPVESOtt2JR
         6h5w3YlrEqB4B5v0li2+Mt2Pq/7u1NlXTWIMzLxLYw4RB0mE28bT9oIMAnrD54TkU86k
         uSmw==
X-Gm-Message-State: APjAAAWROGLG1O5GnkkC1IBSbzVrMIzInCh4ruLAhdAiW0iqG1vK7d31
        Y8sAsRjRn8K1ENKODlqu//mdXIKe
X-Google-Smtp-Source: APXvYqw9ugzQ/LozB+HaZB4fi1LeRm62AkU+oSbiIlHAptR7O2fCIiNxo+WOxM9C/qe2kCIfmDSHEQ==
X-Received: by 2002:a63:a66:: with SMTP id z38mr5855990pgk.247.1565919531394;
        Thu, 15 Aug 2019 18:38:51 -0700 (PDT)
Received: from [172.20.20.103] ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id 1sm4357931pfx.56.2019.08.15.18.38.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Aug 2019 18:38:50 -0700 (PDT)
Subject: Re: [RFC PATCH bpf-next 00/14] xdp_flow: Flow offload to XDP
To:     William Tu <u9012063@gmail.com>
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
        Jiri Pirko <jiri@resnulli.us>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
References: <20190813120558.6151-1-toshiaki.makita1@gmail.com>
 <CALDO+SYC4sPw-7iDkFMCD=kf2UnTW2qc0m6Kgz41zLmNNxQ+Ww@mail.gmail.com>
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
Message-ID: <fbbfa7da-1a14-5edc-cc0d-7f6e5d97384a@gmail.com>
Date:   Fri, 16 Aug 2019 10:38:45 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CALDO+SYC4sPw-7iDkFMCD=kf2UnTW2qc0m6Kgz41zLmNNxQ+Ww@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/08/16 0:46, William Tu wrote:
> On Tue, Aug 13, 2019 at 5:07 AM Toshiaki Makita
> <toshiaki.makita1@gmail.com> wrote:
>>
>> This is a rough PoC for an idea to offload TC flower to XDP.
>>
>>
>> * Motivation
>>
>> The purpose is to speed up software TC flower by using XDP.
>>
>> I chose TC flower because my current interest is in OVS. OVS uses TC to
>> offload flow tables to hardware, so if TC can offload flows to XDP, OVS
>> also can be offloaded to XDP.
>>
>> When TC flower filter is offloaded to XDP, the received packets are
>> handled by XDP first, and if their protocol or something is not
>> supported by the eBPF program, the program returns XDP_PASS and packets
>> are passed to upper layer TC.
>>
>> The packet processing flow will be like this when this mechanism,
>> xdp_flow, is used with OVS.
>>
>>   +-------------+
>>   | openvswitch |
>>   |    kmod     |
>>   +-------------+
>>          ^
>>          | if not match in filters (flow key or action not supported by TC)
>>   +-------------+
>>   |  TC flower  |
>>   +-------------+
>>          ^
>>          | if not match in flow tables (flow key or action not supported by XDP)
>>   +-------------+
>>   |  XDP prog   |
>>   +-------------+
>>          ^
>>          | incoming packets
>>
> I like this idea, some comments about the OVS AF_XDP work.
> 
> Another way when using OVS AF_XDP is to serve as slow path of TC flow
> HW offload.
> For example:
> 
>   Userspace OVS datapath (The one used by OVS-DPDK)
>       ^
>        |
>    +------------------------------+
>    |  OVS AF_XDP netdev |
>    +------------------------------+
>           ^
>           | if not supported or not match in flow tables
>    +---------------------+
>    |  TC HW flower  |
>    +---------------------+
>           ^
>           | incoming packets
> 
> So in this case it's either TC HW flower offload, or the userspace PMD OVS.
> Both cases should be pretty fast.
> 
> I think xdp_flow can also be used by OVS AF_XDP netdev, sitting between
> TC HW flower and OVS AF_XDP netdev.
> Before the XDP program sending packet to AF_XDP socket, the
> xdp_flow can execute first, and if not match, then send to AF_XDP.
> So in your patch set, implement s.t like
>    bpf_redirect_map(&xsks_map, index, 0);

Thanks, the concept sounds good but this is probably difficult as long as
this is a TC offload, which is emulating TC.
If I changed the direction and implement offload in ovs-vswitchd, it would
be possible. I'll remember this optimization.

> Another thing is that at each layer we are doing its own packet parsing.
>  From your graph, first parse at XDP program, then at TC flow, then at
> openvswitch kmod.
> I wonder if we can reuse some parsing result.

That would be nice if possible...
Currently I don't have any ideas to do that. Someday XDP may support more
metadata for this or HW-offload like checksum. Then we can store the information
and upper layers may be able to use that.

Toshiaki Makita
