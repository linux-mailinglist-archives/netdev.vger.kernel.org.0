Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BACEC904BD
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 17:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727374AbfHPPfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 11:35:53 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:37109 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727356AbfHPPfx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 11:35:53 -0400
Received: by mail-pg1-f196.google.com with SMTP id d1so2530851pgp.4
        for <netdev@vger.kernel.org>; Fri, 16 Aug 2019 08:35:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=XQIzOBso48Pzh1FOep45B4+fwsPYtrX0lxpgDEYlJW8=;
        b=lTYSLz9ozZIN42zTg1guqXq7HSF1+t9QOT4fuRmmlIMc6Z4Bg+Y3k+lzr+8leMeClr
         akgfK17ZvzhVDRhiRXulNkVOicxMJ+j8AA9jOt0OJwQXMVzG44+gy7bqkUKGDsNE8bLF
         27bG53RVmXeMFRHLpD1ra514Y5IU6FGc9F1IVb5QR+tLFTgMnLiNToSQw8ePXZ7WzWOP
         nSDogt3fZl5l8Q2EH0FD6JZDrh3t3vXm9JX1gfOl6p/AIPw41x5jCgflj1Iap/aicI8E
         MpLD3FbkSkXggRkeodcICODVqwKGFajtlCO/xnvt3xtYsAKQL+9P8JQd/8e+KfWMhh4B
         gmEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=XQIzOBso48Pzh1FOep45B4+fwsPYtrX0lxpgDEYlJW8=;
        b=U3SONSplTpf+5DqVOCrCatd5PpqKigkibyJjr/MIdPp50hHQDNXjk/ncK11+6r97My
         G3c67VlELtlrfZifZk1dYWGL6N2ubmfDEGBitXVDi9+sC4I2Y8/D4Zq7d4gZFJPWiMzO
         k1WSTeNiToYiHZ7H7q+s5mLtNJ8bFNrFikzsjXHVZgFqmTrPUnZncT5A41BmNuEKIu/U
         enZGPAVbZ4F4bKmK6uzbUX1yk3DbjxtXsCnV4RdZJk7WDZqtiZCE3tgF7c6nfIf+Pd7c
         s37FpbaHmwB3b22L2Xfk38aYKrr6x29zv2gjGqF1bXS1+e043HKiTWnNqjhU6FOPgdJP
         proA==
X-Gm-Message-State: APjAAAXlDw4MDOMLN4KeuqdakDz8jvj5fYmO1ot9R3ecBSCLui/laqAj
        CiFXvoHuFjLJBxCHm0dTKTWVhw==
X-Google-Smtp-Source: APXvYqxIxiTICk9IyROeHNqYuq2Vgrkxax09Iz0xdAzSPMVOYqqP6i8UYoOdsUsQ3pEpP/fD5COnUQ==
X-Received: by 2002:a17:90a:9ea:: with SMTP id 97mr7614636pjo.68.1565969752177;
        Fri, 16 Aug 2019 08:35:52 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id e17sm5897143pjt.6.2019.08.16.08.35.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2019 08:35:51 -0700 (PDT)
Date:   Fri, 16 Aug 2019 08:35:50 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Toshiaki Makita <toshiaki.makita1@gmail.com>
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
Subject: Re: [RFC PATCH bpf-next 00/14] xdp_flow: Flow offload to XDP
Message-ID: <20190816153550.GO2820@mini-arch>
References: <20190813120558.6151-1-toshiaki.makita1@gmail.com>
 <20190814170715.GJ2820@mini-arch>
 <14c4a876-6f5d-4750-cbe4-19622f64975b@gmail.com>
 <20190815152100.GN2820@mini-arch>
 <4614fefc-fc43-8cf7-d064-7dc1947acc6c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4614fefc-fc43-8cf7-d064-7dc1947acc6c@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/16, Toshiaki Makita wrote:
> On 2019/08/16 0:21, Stanislav Fomichev wrote:
> > On 08/15, Toshiaki Makita wrote:
> > > On 2019/08/15 2:07, Stanislav Fomichev wrote:
> > > > On 08/13, Toshiaki Makita wrote:
> > > > > * Implementation
> > > > > 
> > > > > xdp_flow makes use of UMH to load an eBPF program for XDP, similar to
> > > > > bpfilter. The difference is that xdp_flow does not generate the eBPF
> > > > > program dynamically but a prebuilt program is embedded in UMH. This is
> > > > > mainly because flow insertion is considerably frequent. If we generate
> > > > > and load an eBPF program on each insertion of a flow, the latency of the
> > > > > first packet of ping in above test will incease, which I want to avoid.
> > > > Can this be instead implemented with a new hook that will be called
> > > > for TC events? This hook can write to perf event buffer and control
> > > > plane will insert/remove/modify flow tables in the BPF maps (contol
> > > > plane will also install xdp program).
> > > > 
> > > > Why do we need UMH? What am I missing?
> > > 
> > > So you suggest doing everything in xdp_flow kmod?
> > You probably don't even need xdp_flow kmod. Add new tc "offload" mode
> > (bypass) that dumps every command via netlink (or calls the BPF hook
> > where you can dump it into perf event buffer) and then read that info
> > from userspace and install xdp programs and modify flow tables.
> > I don't think you need any kernel changes besides that stream
> > of data from the kernel about qdisc/tc flow creation/removal/etc.
> 
> My intention is to make more people who want high speed network easily use XDP,
> so making transparent XDP offload with current TC interface.
> 
> What userspace program would monitor TC events with your suggestion?
Have a new system daemon (xdpflowerd) that is independently
packaged/shipped/installed. Anybody who wants accelerated TC can
download/install it. OVS can be completely unaware of this.

> ovs-vswitchd? If so, it even does not need to monitor TC. It can
> implement XDP offload directly.
> (However I prefer kernel solution. Please refer to "About alternative
> userland (ovs-vswitchd etc.) implementation" section in the cover letter.)
> 
> Also such a TC monitoring solution easily can be out-of-sync with real TC
> behavior as TC filter/flower is being heavily developed and changed,
> e.g. introduction of TC block, support multiple masks with the same pref, etc.
> I'm not sure such an unreliable solution have much value.
This same issue applies to the in-kernel implementation, isn't it?
What happens if somebody sends patches for a new flower feature but
doesn't add appropriate xdp support? Do we reject them?

That's why I'm suggesting to move this problem to the userspace :-)

> > But, I haven't looked at the series deeply, so I might be missing
> > something :-)
> > 
> > > I also thought about that. There are two phases so let's think about them separately.
> > > 
> > > 1) TC block (qdisc) creation / eBPF load
> > > 
> > > I saw eBPF maintainers repeatedly saying eBPF program loading needs to be
> > > done from userland, not from kernel, to run the verifier for safety.
> > > However xdp_flow eBPF program is prebuilt and embedded in kernel so we may
> > > allow such programs to be loaded from kernel? I currently don't have the will
> > > to make such an API as loading can be done with current UMH mechanism.
> > > 
> > > 2) flow insertion / eBPF map update
> > > 
> > > Not sure if this needs to be done from userland. One concern is that eBPF maps can
> > > be modified by unrelated processes and we need to handle all unexpected state of maps.
> > > Such handling tends to be difficult and may cause unexpected kernel behavior.
> > > OTOH updating maps from kmod may reduces the latency of flow insertion drastically.
> > Latency from the moment I type 'tc filter add ...' to the moment the rule
> > is installed into the maps? Does it really matter?
> 
> Yes it matters. Flow insertion is kind of data path in OVS.
> Please see how ping latency is affected in the cover letter.
Ok, but what I'm suggesting shouldn't be less performant.
We are talking about UMH writing into a pipe vs writing TC events into
a netlink.

> > Do I understand correctly that both of those events (qdisc creation and
> > flow insertion) are triggered from tcf_block_offload_cmd (or similar)?
> 
> Both of eBPF load and map update are triggered from tcf_block_offload_cmd.
> I think you understand it correctly.
> 
> Toshiaki Makita
