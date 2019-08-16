Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 161B5905A4
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 18:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbfHPQUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 12:20:32 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:44742 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726261AbfHPQUc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 12:20:32 -0400
Received: by mail-pf1-f194.google.com with SMTP id c81so3342570pfc.11
        for <netdev@vger.kernel.org>; Fri, 16 Aug 2019 09:20:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=Z+jwXCn4Nrf4ggKgpv88PtHdT/59MEwcFoA29WZ+sWM=;
        b=dq+JJrDDK/vTTtdT4WHD4v4RDL9h/yIunZwnbmuOuqunmGJdQyUzUsTj/lD/mZhylI
         0Uqult2Bt5JSQ8EaQEl0bQaQsm2t2f/WXie0vLHISDR3AS696sifXQxIkqsPiOYfxt6T
         R7LMe8Wz5CRbsbcLqB09MGC3Bi1GbY6i6g9iDntWdhEKUpfdL2tZTKo+Nwyl2SCpBcCY
         ds7JZsTVICFO8Y1Yx6+Ejm3Q9uxVPZqKGRQJ91KQBaXnvn6wf11r8I02A/7piKe2KSPo
         iOLLHtC1eRnT/kKxXk2rViALmSR+4cCShj8sBO+lOeL2+U1JSLSCTVfsGqVEBaB88rNu
         xtNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=Z+jwXCn4Nrf4ggKgpv88PtHdT/59MEwcFoA29WZ+sWM=;
        b=K/QzeCWG4nL7xLQvvj0oHx3eD0ca+c7aWHZSsTvkrNqMHfs/q/m7WmEmry+C/t/grM
         I/cyaBixC9/vKyrLVLJy/VwLpUSucja6pyN+u6uc3pl10UVeUcKoN0iVvuckeJgAtEP9
         LYwLCcL8Q2q5eJYjz6p9DkksMv/E5UIbjIbPR2uEJ7WkVIbTS+TBAirFXmtxZqXZSMvA
         LvdtNVF//bb3/bqPNuh3ItTqscqljeuplF3J2ZxrSbS9F7ZiV1aa9PIUC+z3i1P5nt7C
         QaiZl9zszNbO9T9BtuoXA/XSBvLtt1OjhI5NNKAv77MZ+zHZIuf2JoPCMIRUeP8VBqQI
         NOzw==
X-Gm-Message-State: APjAAAXP2CSsPcUvuseNCtHwIOs/L3KrNCApDPNfyYb30UDxlPPLk1fT
        sx+vbQ3K9AMBkf/MThxMr2/Xuw==
X-Google-Smtp-Source: APXvYqy7xbf0oeZMLxRIKCMpxiZxJiFL+gKjY3snNZxR195IKv4ZDKrh4MMrMH5ydsuFGEAgnd3WNA==
X-Received: by 2002:a63:ff0c:: with SMTP id k12mr8156108pgi.186.1565972431208;
        Fri, 16 Aug 2019 09:20:31 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id o11sm7318906pfh.114.2019.08.16.09.20.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2019 09:20:30 -0700 (PDT)
Date:   Fri, 16 Aug 2019 09:20:29 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, William Tu <u9012063@gmail.com>
Subject: Re: [RFC PATCH bpf-next 00/14] xdp_flow: Flow offload to XDP
Message-ID: <20190816162029.GR2820@mini-arch>
References: <20190813120558.6151-1-toshiaki.makita1@gmail.com>
 <20190814170715.GJ2820@mini-arch>
 <14c4a876-6f5d-4750-cbe4-19622f64975b@gmail.com>
 <20190815152100.GN2820@mini-arch>
 <20190815122232.4b1fa01c@cakuba.netronome.com>
 <20190816155911.GP2820@mini-arch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190816155911.GP2820@mini-arch>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/16, Stanislav Fomichev wrote:
> On 08/15, Jakub Kicinski wrote:
> > On Thu, 15 Aug 2019 08:21:00 -0700, Stanislav Fomichev wrote:
> > > On 08/15, Toshiaki Makita wrote:
> > > > On 2019/08/15 2:07, Stanislav Fomichev wrote:  
> > > > > On 08/13, Toshiaki Makita wrote:  
> > > > > > * Implementation
> > > > > > 
> > > > > > xdp_flow makes use of UMH to load an eBPF program for XDP, similar to
> > > > > > bpfilter. The difference is that xdp_flow does not generate the eBPF
> > > > > > program dynamically but a prebuilt program is embedded in UMH. This is
> > > > > > mainly because flow insertion is considerably frequent. If we generate
> > > > > > and load an eBPF program on each insertion of a flow, the latency of the
> > > > > > first packet of ping in above test will incease, which I want to avoid.  
> > > > > Can this be instead implemented with a new hook that will be called
> > > > > for TC events? This hook can write to perf event buffer and control
> > > > > plane will insert/remove/modify flow tables in the BPF maps (contol
> > > > > plane will also install xdp program).
> > > > > 
> > > > > Why do we need UMH? What am I missing?  
> > > > 
> > > > So you suggest doing everything in xdp_flow kmod?  
> > > You probably don't even need xdp_flow kmod. Add new tc "offload" mode
> > > (bypass) that dumps every command via netlink (or calls the BPF hook
> > > where you can dump it into perf event buffer) and then read that info
> > > from userspace and install xdp programs and modify flow tables.
> > > I don't think you need any kernel changes besides that stream
> > > of data from the kernel about qdisc/tc flow creation/removal/etc.
> > 
> > There's a certain allure in bringing the in-kernel BPF translation
> > infrastructure forward. OTOH from system architecture perspective IMHO
> > it does seem like a task best handed in user space. bpfilter can replace
> > iptables completely, here we're looking at an acceleration relatively
> > loosely coupled with flower.
> Even for bpfilter I would've solved it using something similar:
> iptables bypass + redirect iptables netlink requests to some
> userspace helper that was registered to be iptables compatibility
> manager. And then, again, it becomes a purely userspace problem.
Oh, wait, isn't iptables kernel api is setsockopt/getsockopt?
With the new cgroup hooks you can now try to do bpfilter completely
in BPF 🤯

> The issue with UMH is that the helper has to be statically compiled
> from the kernel tree, which means we can't bring in any dependencies
> (stuff like libkefir you mentioned below).
> 
> But I digress :-)
> 
> > FWIW Quentin spent some time working on a universal flow rule to BPF
> > translation library:
> > 
> > https://github.com/Netronome/libkefir
> > 
> > A lot remains to be done there, but flower front end is one of the
> > targets. A library can be tuned for any application, without a
> > dependency on flower uAPI.
> > 
> > > But, I haven't looked at the series deeply, so I might be missing
> > > something :-)
> > 
> > I don't think you are :)
