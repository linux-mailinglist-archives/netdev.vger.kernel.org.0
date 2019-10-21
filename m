Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78E04DE554
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 09:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727445AbfJUHbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 03:31:13 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:37073 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbfJUHbN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 03:31:13 -0400
Received: by mail-pl1-f195.google.com with SMTP id u20so6188575plq.4;
        Mon, 21 Oct 2019 00:31:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gl3AjtMuB3uVSOnNiELLGqLzZ5vndSK+Gkr0NStdpWo=;
        b=pyGiLl7GsYebi5Za0WsUiwuD2+QqAcf0rki4K5c2Vgn+vn3icHK76YIRZzeJW1YRgK
         pYnC7fOfSpUbWsHEdJ1eBqgNbu2M4HiAkZ3pDmThW3/C7Jhylxe1j2qRgD1mjKcXO345
         ZCdrlJjptk4sZxEvBrfGSPKq3NVNpB0T9SMR6LMzE3sAsoOXP0wgM+HYmiqwmGYXlouF
         2WWUy/ACXiwffzRSuQhS+jN5+noRlnkYJ5G3zaE3vRXWBfr+bmNoPhdA15MbofDeHquE
         SImZpVIVfk7BCr43u7knHP1sEC6DwibVTV3pTM3UZrX0eoX46mhBO2qWB3o9h+pDJ+RV
         R7yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gl3AjtMuB3uVSOnNiELLGqLzZ5vndSK+Gkr0NStdpWo=;
        b=A1Z9JZzVk/P7dACK2h2MTaw9myeK4vNs13n3j6HBTzYX7FyYeKUtp4hOzrBZ/oW3m8
         e9rmSH+lywplQPDMkGv/V+STdMIOgmFPFE8e1U05Nqu6TrHnnPe7mafIZAKPyKtQcCpj
         vmo2hjxUuyS4ujCr1czKITV31Lml0UDlNipFKm6pqd9GsfzHqH8Nyq/CVSQrnN8Ug4OD
         Li5xBIZyVHj2viMmEVTZUwo7Nkq/qdAgdzijI230kMuWMvl0/wB3kFeqioZQ8TmSIUmC
         JOWQCgocy3lXtKhzWxD5hIwoOn6lTePJYBUXw1lPlxzUCbS0OC/Wcphhuc/K/W3h3pA+
         Eidw==
X-Gm-Message-State: APjAAAVsbqfUHkBg9PBeiO9RfIAJ9+X3YSUSUbnuWsHP4kpfVbjKt3CT
        JYtt5qDdgDOkOIvWWJiL84U=
X-Google-Smtp-Source: APXvYqw6/VpFlXkvOZrSq0pwvx4MEJcCfnF8VTH+VPOsFb9Vkl0MV1ePCupSor6GACyfEpxvsBDRdA==
X-Received: by 2002:a17:902:561:: with SMTP id 88mr3915287plf.40.1571643070978;
        Mon, 21 Oct 2019 00:31:10 -0700 (PDT)
Received: from [172.20.20.103] ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id q76sm23416688pfc.86.2019.10.21.00.31.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Oct 2019 00:31:10 -0700 (PDT)
Subject: Re: [RFC PATCH v2 bpf-next 00/15] xdp_flow: Flow offload to XDP
To:     John Fastabend <john.fastabend@gmail.com>,
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
References: <20191018040748.30593-1-toshiaki.makita1@gmail.com>
 <5da9d8c125fd4_31cf2adc704105c456@john-XPS-13-9370.notmuch>
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
Message-ID: <22e6652c-e635-4349-c863-255d6c1c548b@gmail.com>
Date:   Mon, 21 Oct 2019 16:31:03 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <5da9d8c125fd4_31cf2adc704105c456@john-XPS-13-9370.notmuch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/10/19 0:22, John Fastabend wrote:
> Toshiaki Makita wrote:
>> This is a PoC for an idea to offload flow, i.e. TC flower and nftables,
>> to XDP.
>>
> 
> I've only read the cover letter so far but...

Thank you for reading this long cover letter.

> 
>> * Motivation
>>
>> The purpose is to speed up flow based network features like TC flower and
>> nftables by making use of XDP.
>>
>> I chose flow feature because my current interest is in OVS. OVS uses TC
>> flower to offload flow tables to hardware, so if TC can offload flows to
>> XDP, OVS also can be offloaded to XDP.
> 
> This adds a non-trivial amount of code and complexity so I'm
> critical of the usefulness of being able to offload TC flower to
> XDP when userspace can simply load an XDP program.
> 
> Why does OVS use tc flower at all if XDP is about 5x faster using
> your measurements below? Rather than spend energy adding code to
> a use case that as far as I can tell is narrowly focused on offload
> support can we enumerate what is missing on XDP side that blocks
> OVS from using it directly?

I think nothing is missing for direct XDP use, as long as XDP datapath
only partially supports OVS flow parser/actions like xdp_flow.
The point is to avoid duplicate effort when someone wants to use XDP
through TC flower or nftables transparently.

> Additionally for hardware that can
> do XDP/BPF offload you will get the hardware offload for free.

This is not necessary as OVS already uses TC flower to offload flows.

> Yes I know XDP is bytecode and you can't "offload" bytecode into
> a flow based interface likely backed by a tcam but IMO that doesn't
> mean we should leak complexity into the kernel network stack to
> fix this. Use the tc-flower for offload only (it has support for
> this) if you must and use the best (in terms of Mpps) software
> interface for your software bits. And if you want auto-magic
> offload support build hardware with BPF offload support.
> 
> In addition by using XDP natively any extra latency overhead from
> bouncing calls through multiple layers would be removed.

To some extent yes, but not completely. Flow insertion from userspace
triggered by datapath upcall is necessary regardless of whether we use
TC or not.

>> When TC flower filter is offloaded to XDP, the received packets are
>> handled by XDP first, and if their protocol or something is not
>> supported by the eBPF program, the program returns XDP_PASS and packets
>> are passed to upper layer TC.
>>
>> The packet processing flow will be like this when this mechanism,
>> xdp_flow, is used with OVS.
> 
> Same as obove just cross out the 'TC flower' box and add support
> for your missing features to 'XDP prog' box. Now you have less
> code to maintain and less bugs and aren't pushing packets through
> multiple hops in a call chain.

If we cross out TC then we would need similar code in OVS userspace.
In total I don't think it would be less code to maintain.

> 
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
>> Of course we can directly use TC flower without OVS to speed up TC.
> 
> huh? TC flower is part of TC so not sure what 'speed up TC' means. I
> guess this means using tc flower offload to xdp prog would speed up
> general tc flower usage as well?

Yes.

> 
> But again if we are concerned about Mpps metrics just write the XDP
> program directly.

I guess you mean any Linux users who want TC-like flow handling should develop
their own XDP programs? (sorry if I misunderstand you.)
I want to avoid such a situation. The flexibility of eBPF/XDP is nice and it's
good to have any program each user wants, but not every sysadmin can write low
level good performance programs like us. For typical use-cases like flow handling
easy use of XDP through existing kernel interface (here TC) is useful IMO.

> 
...
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
> 
> I argue to cut tc filter out entirely and then I think non of this
> is needed.

Not correct. Even with native XDP use, multiple map lookup/modification
from userspace is necessary for flow miss handling, which will lead to
some latency.

And there are other use-cases for direct TC use, like packet drop or
redirection for certain flows.

> 
>>
>> Also as written above nftables can be offloaded to XDP with this
>> mechanism as well.
> 
> Or same argument use XDP directly.

I'm thinking it's useful for sysadmins to be able to use XDP through
existing kernel interfaces.

> 
>>
>> Another way to achieve this from userland is to add notifications in
>> flow_offload kernel code to inform userspace of flow addition and
>> deletion events, and listen them by a deamon which in turn loads eBPF
>> programs, attach them to XDP, and modify eBPF maps. Although this may
>> open up more use cases, I'm not thinking this is the best solution
>> because it requires emulation of kernel behavior as an offload engine
>> but flow related code is heavily changing which is difficult to follow
>> from out of tree.
> 
> So if everything was already in XDP why would we need these
> notifications? I think a way to poll on a map from user space would
> be a great idea e.g. everytime my XDP program adds a flow to my
> hash map wake up my userspace agent with some ctx on what was added or
> deleted so I can do some control plane logic.

I was talking about TC emulation above, so map notification is not related
to this problem, although it may be a nice feature.

> 
> [...]
> 
> Lots of code churn...

Note that most of it is TC offload driver implementation. So it should add
little complexity to network/XDP/TC core.

> 
>>   24 files changed, 2864 insertions(+), 30 deletions(-)
> 
> Thanks,
> John
> 

Toshiaki Makita
