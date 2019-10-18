Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1AC3DC85A
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 17:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404706AbfJRPWw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 11:22:52 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:43612 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388554AbfJRPWv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 11:22:51 -0400
Received: by mail-io1-f67.google.com with SMTP id v2so7864623iob.10;
        Fri, 18 Oct 2019 08:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=VUJcc8mPkPKlpwQbrOcG6xgazIhd82kJ/GsvwXJlcC4=;
        b=okstuMZtrNTAQRf8+BLN7nSv9OmhhcsvTqs2MuqV+VHwVUdp522RbUrDUNcbSIltvL
         6QAg9RHrwq5qbSPUOGdxVcvBjl4pJLxHuklMOBCTDG4zF9252IRUDQP86xa955xS9Q8c
         wZLPG5CLEIbqY68OIUi/+3lqyh+95whGk4ydTwv0ySzil6z6q5Iuo/aYOP9zj1NQQAWP
         BZTcsBde0NSiYSUsqDAbciLkMz29wTa35ICgC5G8x7kJr7bbARiOR2pWPTsrufmqcqcb
         L6RanSJjM3Wxiyg5mMn72dyvI4aWMyGqHC8+UtgbWqx91QuaYO3G7dCIsbwYZVzi5w+r
         WSfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=VUJcc8mPkPKlpwQbrOcG6xgazIhd82kJ/GsvwXJlcC4=;
        b=YSyR1mrpK4H4y62Fo6y/YthmDrEXyY7NKLDzIxBAI6FS11CH23IaXUJLizz52AcR2Q
         ftBRSFeYJmFgh6zVDZBeRI0wi/CU3IGXfCns7sFPDpVqXkYjHx/LCPlb/PgWxrdAduTF
         EiZzKwU7MLF3b+LES23LF8FVPM/z6N/jqwBz9yJiIa3PWNkx/uULaK2Xe5FkU1M0xnh5
         xwV/7IdpeH7gUGUINRTURsiD7eQnc2PQcjkwz0KXjfZ77/Ipr799FgUC8YcVS56lZyPq
         2yxwdcFHas4o1q5lC9x30h/960z+r7oaBz50ri4PJXAA8igZi4eT4ISDzFZh6jZHRlRs
         Lcjw==
X-Gm-Message-State: APjAAAVwJexf4IGBBthxymd3669BhB+QlDenCxAlzjhmbAsy7MWkqZR3
        jQ7OjExrFnQ7ax9bvuykycI=
X-Google-Smtp-Source: APXvYqzleWIrItv5nS0Ag6K+NYkgL1zjGlDoSN5kwZz4Yx5dAFRjOZj2KeL4H1g3LqbkF8c9hm/IlA==
X-Received: by 2002:a5d:8f17:: with SMTP id f23mr8899782iof.56.1571412170608;
        Fri, 18 Oct 2019 08:22:50 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id r2sm2204803ilm.17.2019.10.18.08.22.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2019 08:22:50 -0700 (PDT)
Date:   Fri, 18 Oct 2019 08:22:41 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
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
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Pravin B Shelar <pshelar@ovn.org>
Cc:     Toshiaki Makita <toshiaki.makita1@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        William Tu <u9012063@gmail.com>,
        Stanislav Fomichev <sdf@fomichev.me>
Message-ID: <5da9d8c125fd4_31cf2adc704105c456@john-XPS-13-9370.notmuch>
In-Reply-To: <20191018040748.30593-1-toshiaki.makita1@gmail.com>
References: <20191018040748.30593-1-toshiaki.makita1@gmail.com>
Subject: RE: [RFC PATCH v2 bpf-next 00/15] xdp_flow: Flow offload to XDP
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toshiaki Makita wrote:
> This is a PoC for an idea to offload flow, i.e. TC flower and nftables,
> to XDP.
> 

I've only read the cover letter so far but...

> * Motivation
> 
> The purpose is to speed up flow based network features like TC flower and
> nftables by making use of XDP.
> 
> I chose flow feature because my current interest is in OVS. OVS uses TC
> flower to offload flow tables to hardware, so if TC can offload flows to
> XDP, OVS also can be offloaded to XDP.

This adds a non-trivial amount of code and complexity so I'm
critical of the usefulness of being able to offload TC flower to
XDP when userspace can simply load an XDP program.

Why does OVS use tc flower at all if XDP is about 5x faster using
your measurements below? Rather than spend energy adding code to
a use case that as far as I can tell is narrowly focused on offload
support can we enumerate what is missing on XDP side that blocks
OVS from using it directly? Additionally for hardware that can
do XDP/BPF offload you will get the hardware offload for free.

Yes I know XDP is bytecode and you can't "offload" bytecode into
a flow based interface likely backed by a tcam but IMO that doesn't
mean we should leak complexity into the kernel network stack to
fix this. Use the tc-flower for offload only (it has support for
this) if you must and use the best (in terms of Mpps) software
interface for your software bits. And if you want auto-magic
offload support build hardware with BPF offload support.

In addition by using XDP natively any extra latency overhead from
bouncing calls through multiple layers would be removed.

> 
> When TC flower filter is offloaded to XDP, the received packets are
> handled by XDP first, and if their protocol or something is not
> supported by the eBPF program, the program returns XDP_PASS and packets
> are passed to upper layer TC.
> 
> The packet processing flow will be like this when this mechanism,
> xdp_flow, is used with OVS.

Same as obove just cross out the 'TC flower' box and add support
for your missing features to 'XDP prog' box. Now you have less
code to maintain and less bugs and aren't pushing packets through
multiple hops in a call chain.

> 
>  +-------------+
>  | openvswitch |
>  |    kmod     |
>  +-------------+
>         ^
>         | if not match in filters (flow key or action not supported by TC)
>  +-------------+
>  |  TC flower  |
>  +-------------+
>         ^
>         | if not match in flow tables (flow key or action not supported by XDP)
>  +-------------+
>  |  XDP prog   |
>  +-------------+
>         ^
>         | incoming packets
> 
> Of course we can directly use TC flower without OVS to speed up TC.

huh? TC flower is part of TC so not sure what 'speed up TC' means. I
guess this means using tc flower offload to xdp prog would speed up
general tc flower usage as well?

But again if we are concerned about Mpps metrics just write the XDP
program directly.

> 
> This is useful especially when the device does not support HW-offload.
> Such interfaces include virtual interfaces like veth.

I disagree, use XDP directly.

> 
> 
> * How to use

[...]

> * Performance

[...]

> Tested single core/single flow with 3 kinds of configurations.
> (spectre_v2 disabled)
> - xdp_flow: hw-offload=true, flow-offload-xdp on
> - TC:       hw-offload=true, flow-offload-xdp off (software TC)
> - ovs kmod: hw-offload=false
> 
>  xdp_flow  TC        ovs kmod
>  --------  --------  --------
>  5.2 Mpps  1.2 Mpps  1.1 Mpps
> 
> So xdp_flow drop rate is roughly 4x-5x faster than software TC or ovs kmod.

+1 yep the main point of using XDP ;)

> 
> OTOH the time to add a flow increases with xdp_flow.
> 
> ping latency of first packet when veth1 does XDP_PASS instead of DROP:
> 
>  xdp_flow  TC        ovs kmod
>  --------  --------  --------
>  22ms      6ms       0.6ms
> 
> xdp_flow does a lot of work to emulate TC behavior including UMH
> transaction and multiple bpf map update from UMH which I think increases
> the latency.

And this is IMO sinks why we would adopt this. A native XDP solution would
as far as I can tell not suffer this latency. So in short, we add lots
of code that needs to be maintained, in my opinion it adds complexity,
and finally I can't see what XDP is missing today (with the code we
already have upstream!) to block doing an implementation without any
changes.

> 
> 
> * Implementation
> 
 
[...]

> 
> * About OVS AF_XDP netdev

[...]
 
> * About alternative userland (ovs-vswitchd etc.) implementation
> 
> Maybe a similar logic can be implemented in ovs-vswitchd offload
> mechanism, instead of adding code to kernel. I just thought offloading
> TC is more generic and allows wider usage with direct TC command.
> 
> For example, considering that OVS inserts a flow to kernel only when
> flow miss happens in kernel, we can in advance add offloaded flows via
> tc filter to avoid flow insertion latency for certain sensitive flows.
> TC flower usage without using OVS is also possible.

I argue to cut tc filter out entirely and then I think non of this
is needed.

> 
> Also as written above nftables can be offloaded to XDP with this
> mechanism as well.

Or same argument use XDP directly.

> 
> Another way to achieve this from userland is to add notifications in
> flow_offload kernel code to inform userspace of flow addition and
> deletion events, and listen them by a deamon which in turn loads eBPF
> programs, attach them to XDP, and modify eBPF maps. Although this may
> open up more use cases, I'm not thinking this is the best solution
> because it requires emulation of kernel behavior as an offload engine
> but flow related code is heavily changing which is difficult to follow
> from out of tree.

So if everything was already in XDP why would we need these
notifications? I think a way to poll on a map from user space would
be a great idea e.g. everytime my XDP program adds a flow to my
hash map wake up my userspace agent with some ctx on what was added or
deleted so I can do some control plane logic.

[...]

Lots of code churn...

>  24 files changed, 2864 insertions(+), 30 deletions(-)

Thanks,
John
