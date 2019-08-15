Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 751558EF39
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 17:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728781AbfHOPVD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 11:21:03 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:32796 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728728AbfHOPVD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 11:21:03 -0400
Received: by mail-pg1-f196.google.com with SMTP id n190so1446735pgn.0
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 08:21:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=gWCpJv0MdsDcCjYfH3QHT9RFuWsfjx5IZK9e9mVsAXA=;
        b=YoynTap7BbTEYNR98yeMXMzDCfOXQqvgHIvw9T4f5smrgxjtf6N2/WreLJ60l+vU8n
         sQRM31Vvc9uMxiWvB7x0jIAhk3t5WryONIJ8hhIjS3dLDVABCIZzRE+TXCzCiZjfaGuG
         f1jJN3z+bCNepyPs3HAWSeBLbaPAolhXY+2s/SjPXh3pZmoAX7dKANCwBtAQ3iQ2sDKb
         ltS7eqL83EnQjGI7hoUZx+ELNE9WJZT48PAtQx+EQRhCdrwPvkO/1LYmAayjIzWxCk15
         4gi+1qPX5o4KCrVHoRblzeR0s13OMlq9rqGOKoUHeTH6R88neSEhC2M8lFhg4fMh0CXI
         x/Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=gWCpJv0MdsDcCjYfH3QHT9RFuWsfjx5IZK9e9mVsAXA=;
        b=KCAmmddoqgAYA1Snh8Iq73QVeNg2s014OOU2/MoCACCehz3I6nojGRD5GruK9lfMZ0
         hB2nahe/2dkP/bfvrHf5mAtiR6MmYQTbfyjDbhxmxn+OzJxx2ZPEeZk/wCYxBQjx2ffN
         /Ns7LlI/wTofwCwRm7Ex1I3x23wcfW/iOER2fhUrr99hIQ0k18JRoVHdHKNDltSLU1hc
         KdckEugBECS/okv0CBc8DozlsTadq8P8+76SP+XjM5NpEpZwNevBp3r3/+PF2RpLUad0
         0Fl/Me1Y5tvEoXEhqo4DRFc4k6qra/LRFrfuQ+vFL0t/6Uh0KQrQoV5riL9zkGnbEDts
         4mlA==
X-Gm-Message-State: APjAAAUN78A9ePYGxe18LNBZWeT0spKz+LlcPPRwCvEjtzV/TF/XcGyg
        pr8vQ19w/REJcvDD81P2rLP26w==
X-Google-Smtp-Source: APXvYqw55yeAxnoRONyct3JREtm0sRJmsrCOOytkTUf8aXAzcDNBNx85nZ3TKKmLqMaScwLjx2UGkg==
X-Received: by 2002:aa7:8f2e:: with SMTP id y14mr5970297pfr.113.1565882462524;
        Thu, 15 Aug 2019 08:21:02 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id r75sm3268036pfc.18.2019.08.15.08.21.01
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 15 Aug 2019 08:21:01 -0700 (PDT)
Date:   Thu, 15 Aug 2019 08:21:00 -0700
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
Message-ID: <20190815152100.GN2820@mini-arch>
References: <20190813120558.6151-1-toshiaki.makita1@gmail.com>
 <20190814170715.GJ2820@mini-arch>
 <14c4a876-6f5d-4750-cbe4-19622f64975b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14c4a876-6f5d-4750-cbe4-19622f64975b@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/15, Toshiaki Makita wrote:
> On 2019/08/15 2:07, Stanislav Fomichev wrote:
> > On 08/13, Toshiaki Makita wrote:
> > > * Implementation
> > > 
> > > xdp_flow makes use of UMH to load an eBPF program for XDP, similar to
> > > bpfilter. The difference is that xdp_flow does not generate the eBPF
> > > program dynamically but a prebuilt program is embedded in UMH. This is
> > > mainly because flow insertion is considerably frequent. If we generate
> > > and load an eBPF program on each insertion of a flow, the latency of the
> > > first packet of ping in above test will incease, which I want to avoid.
> > Can this be instead implemented with a new hook that will be called
> > for TC events? This hook can write to perf event buffer and control
> > plane will insert/remove/modify flow tables in the BPF maps (contol
> > plane will also install xdp program).
> > 
> > Why do we need UMH? What am I missing?
> 
> So you suggest doing everything in xdp_flow kmod?
You probably don't even need xdp_flow kmod. Add new tc "offload" mode
(bypass) that dumps every command via netlink (or calls the BPF hook
where you can dump it into perf event buffer) and then read that info
from userspace and install xdp programs and modify flow tables.
I don't think you need any kernel changes besides that stream
of data from the kernel about qdisc/tc flow creation/removal/etc.

But, I haven't looked at the series deeply, so I might be missing
something :-)

> I also thought about that. There are two phases so let's think about them separately.
> 
> 1) TC block (qdisc) creation / eBPF load
> 
> I saw eBPF maintainers repeatedly saying eBPF program loading needs to be
> done from userland, not from kernel, to run the verifier for safety.
> However xdp_flow eBPF program is prebuilt and embedded in kernel so we may
> allow such programs to be loaded from kernel? I currently don't have the will
> to make such an API as loading can be done with current UMH mechanism.
> 
> 2) flow insertion / eBPF map update
> 
> Not sure if this needs to be done from userland. One concern is that eBPF maps can
> be modified by unrelated processes and we need to handle all unexpected state of maps.
> Such handling tends to be difficult and may cause unexpected kernel behavior.
> OTOH updating maps from kmod may reduces the latency of flow insertion drastically.
Latency from the moment I type 'tc filter add ...' to the moment the rule
is installed into the maps? Does it really matter?

Do I understand correctly that both of those events (qdisc creation and
flow insertion) are triggered from tcf_block_offload_cmd (or similar)?

> Alexei, Daniel, what do you think?
> 
> Toshiaki Makita
