Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E0324A983
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 20:09:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730228AbfFRSJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 14:09:48 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:34571 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729715AbfFRSJr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 14:09:47 -0400
Received: by mail-pl1-f193.google.com with SMTP id i2so6041425plt.1
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 11:09:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=fvxKZLkDyWo/aNsi22zggPm46z9e4rZQxbujluiKOwg=;
        b=aXHGix3F2IIfJ/dx6eSNIdYmeN+xdibkpMoPPAgOkIdenCktkI62AvtX3OjM/3Y4kc
         N/zM1N4NY7faTZBo8BrccvUSrENnAsL+bia4FyzBeGMp4dKLtNA2Gd8guhb7FoR5ecUU
         qASdRf26RklQp4G5EK4ebNEAquWqR8LcGEPLX08lYNzWlv0hyjZAh9H6AAlG3i5nS7yb
         sFc2lCWQrjNhhIKv9G1gPmZByYmvBDRQkNQPvOCJY23fReAu4gW2S6j4AnJvxgaeOIJ3
         p2P/umYCidSdVlj0V/t0b2QbJOdjucScoFjMiSG+6NQeFfUeof0RqISO2x4+N/gdzWQu
         JK/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=fvxKZLkDyWo/aNsi22zggPm46z9e4rZQxbujluiKOwg=;
        b=mTCbBncbIsLRCTxrMpnVz+zTOtdnKcHeCzNX0lXahq5IDs9yOvFZMTJVCphl9rfJy8
         Bez+f0IHy5/6cp+Aq6jalB0mAd3QhAM/ydVe+Nh/NxKIIkT3qw0WXBpamYVY2nvIzXf1
         xJ89P9ABiXEN0a3nqdLI/zSY2JnNF82RYP0bS6qrFR9x1MpoUGP0jTvueGebg1nGliuu
         /VffuUSrqtZNsVlFZGJyWi8np+BjKpHuzZAsEOTGndhkTkSaYUtZ0tAHO9c7aI8iLdss
         lDbdnzZokdnQWGYfavYM70+asgrMhxdF2v8aVDi2iV1NorRzwZClTdSrwoEZjgkSlaxK
         cqbw==
X-Gm-Message-State: APjAAAUfi5De7FyevQsY8Cau/NqYJgMVoho1TsOxQ68jca6ez2XcohKO
        y9o9CCP6OwrLigZ6pVyFjJk5YA==
X-Google-Smtp-Source: APXvYqyJZlRwSJYhuDmGcVJ8g5/DM2lOQlwY4H7W4EI85fikwMqZJiDXpbtJP2IO7X4jizmYpFsl4g==
X-Received: by 2002:a17:902:8d89:: with SMTP id v9mr90997548plo.99.1560881386989;
        Tue, 18 Jun 2019 11:09:46 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id g9sm13266202pgq.88.2019.06.18.11.09.45
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 18 Jun 2019 11:09:46 -0700 (PDT)
Date:   Tue, 18 Jun 2019 11:09:44 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, ast@kernel.org,
        daniel@iogearbox.net, Martin Lau <kafai@fb.com>
Subject: Re: [PATCH bpf-next v6 1/9] bpf: implement getsockopt and setsockopt
 hooks
Message-ID: <20190618180944.GJ9636@mini-arch>
References: <20190617180109.34950-1-sdf@google.com>
 <20190617180109.34950-2-sdf@google.com>
 <20190618163117.yuw44b24lo6prsrz@ast-mbp.dhcp.thefacebook.com>
 <20190618164913.GI9636@mini-arch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190618164913.GI9636@mini-arch>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/18, Stanislav Fomichev wrote:
> On 06/18, Alexei Starovoitov wrote:
> > On Mon, Jun 17, 2019 at 11:01:01AM -0700, Stanislav Fomichev wrote:
> > > Implement new BPF_PROG_TYPE_CGROUP_SOCKOPT program type and
> > > BPF_CGROUP_{G,S}ETSOCKOPT cgroup hooks.
> > > 
> > > BPF_CGROUP_SETSOCKOPT get a read-only view of the setsockopt arguments.
> > > BPF_CGROUP_GETSOCKOPT can modify the supplied buffer.
> > > Both of them reuse existing PTR_TO_PACKET{,_END} infrastructure.
> > > 
> > > The buffer memory is pre-allocated (because I don't think there is
> > > a precedent for working with __user memory from bpf). This might be
> > > slow to do for each {s,g}etsockopt call, that's why I've added
> > > __cgroup_bpf_prog_array_is_empty that exits early if there is nothing
> > > attached to a cgroup. Note, however, that there is a race between
> > > __cgroup_bpf_prog_array_is_empty and BPF_PROG_RUN_ARRAY where cgroup
> > > program layout might have changed; this should not be a problem
> > > because in general there is a race between multiple calls to
> > > {s,g}etsocktop and user adding/removing bpf progs from a cgroup.
> > > 
> > > The return code of the BPF program is handled as follows:
> > > * 0: EPERM
> > > * 1: success, execute kernel {s,g}etsockopt path after BPF prog exits
> > > * 2: success, do _not_ execute kernel {s,g}etsockopt path after BPF
> > >      prog exits
> > > 
> > > Note that if 0 or 2 is returned from BPF program, no further BPF program
> > > in the cgroup hierarchy is executed. This is in contrast with any existing
> > > per-cgroup BPF attach_type.
> > 
> > This is drastically different from all other cgroup-bpf progs.
> > I think all programs should be executed regardless of return code.
> > It seems to me that 1 vs 2 difference can be expressed via bpf program logic
> > instead of return code.
> > 
> > How about we do what all other cgroup-bpf progs do:
> > "any no is no. all yes is yes"
> > Meaning any ret=0 - EPERM back to user.
> > If all are ret=1 - kernel handles get/set.
> > 
> > I think the desire to differentiate 1 vs 2 came from ordering issue
> > on getsockopt.
> > How about for setsockopt all progs run first and then kernel.
> > For getsockopt kernel runs first and then all progs.
> > Then progs will have an ability to overwrite anything the kernel returns.
> Good idea, makes sense. For getsockopt we'd also need to pass the return
> value of the kernel getsockopt to let bpf programs override it, but seems
> doable. Let me play with it a bit; I'll send another version if nothing
> major comes up.
> 
> Thanks for another round of review!
One clarification: we'd still probably need to have 3 return codes for
setsockopt:
* any 0 - EPERM
* all 1 - continue with the kernel path (i.e. apply this sockopt as is)
* any 2 - return after all BPF hooks are executed (bypass kernel)
          (any 0 trumps any 2 -> EPERM)

The context is readonly for setsockopt, so it shouldn't be an issue.
Let me know if you have better idea how to handle that.
