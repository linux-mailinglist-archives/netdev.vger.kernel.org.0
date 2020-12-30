Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F7372E79EF
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 15:20:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbgL3OT7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 09:19:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:36888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725814AbgL3OT7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Dec 2020 09:19:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 53330221F8;
        Wed, 30 Dec 2020 14:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609337958;
        bh=KBi2W58R6qvqkkg5K1iO6NP9wQHrKZv2rkO1csO1FZg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XI3JmhfxexRfEQJbHLRTB4nAgkncyR1nFnE3HTSUPRxh3C3JhOXq4Bh94d3zQHj3I
         EvYH5I0U2+0GHznCMrhSPG/ANXbjAVG5Kc1BIikj+O6G46fVT7OZVYbwHtx6/uh8xV
         2oLU0/TJGzLxQF/qijSCAVzXi9Cmieb42d3h6tAP87pWfMLtmQDU8/Jad7qMzxaIEP
         Fe5NvEfd2cHdvobgIl2XxViIeQeE0pmAX8/5XtZFCCGzbekwlxwIz4IM+cEweddapl
         dOKeRzqE3WE1Sem6BcY8Pizplrq9Kep2vfhJMPW73q/SBDb7LqNkG0qcodsBEfknqi
         t0qnBUyw3pZzQ==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id D2BB0411E9; Wed, 30 Dec 2020 11:19:36 -0300 (-03)
Date:   Wed, 30 Dec 2020 11:19:36 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Qais Yousef <qais.yousef@arm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: BTFIDS: FAILED unresolved symbol udp6_sock
Message-ID: <20201230141936.GA3922432@kernel.org>
References: <20201229151352.6hzmjvu3qh6p2qgg@e107158-lin>
 <20201229173401.GH450923@krava>
 <20201229232835.cbyfmja3bu3lx7we@e107158-lin>
 <20201230090333.GA577428@krava>
 <20201230132759.GB577428@krava>
 <20201230132852.GC577428@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201230132852.GC577428@krava>
X-Url:  http://acmel.wordpress.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Wed, Dec 30, 2020 at 02:28:52PM +0100, Jiri Olsa escreveu:
> On Wed, Dec 30, 2020 at 02:28:02PM +0100, Jiri Olsa wrote:
> > On Wed, Dec 30, 2020 at 10:03:37AM +0100, Jiri Olsa wrote:
> > > On Tue, Dec 29, 2020 at 11:28:35PM +0000, Qais Yousef wrote:
> > > > Hi Jiri
> > > > 
> > > > On 12/29/20 18:34, Jiri Olsa wrote:
> > > > > On Tue, Dec 29, 2020 at 03:13:52PM +0000, Qais Yousef wrote:
> > > > > > Hi
> > > > > > 
> > > > > > When I enable CONFIG_DEBUG_INFO_BTF I get the following error in the BTFIDS
> > > > > > stage
> > > > > > 
> > > > > > 	FAILED unresolved symbol udp6_sock
> > > > > > 
> > > > > > I cross compile for arm64. My .config is attached.
> > > > > > 
> > > > > > I managed to reproduce the problem on v5.9 and v5.10. Plus 5.11-rc1.
> > > > > > 
> > > > > > Have you seen this before? I couldn't find a specific report about this
> > > > > > problem.
> > > > > > 
> > > > > > Let me know if you need more info.
> > > > > 
> > > > > hi,
> > > > > this looks like symptom of the gcc DWARF bug we were
> > > > > dealing with recently:
> > > > > 
> > > > >   https://gcc.gnu.org/bugzilla/show_bug.cgi?id=97060
> > > > >   https://lore.kernel.org/lkml/CAE1WUT75gu9G62Q9uAALGN6vLX=o7vZ9uhqtVWnbUV81DgmFPw@mail.gmail.com/#r
> > > > > 
> > > > > what pahole/gcc version are you using?
> > > > 
> > > > I'm on gcc 9.3.0
> > > > 
> > > > 	aarch64-linux-gnu-gcc (Ubuntu 9.3.0-17ubuntu1~20.04) 9.3.0
> > > > 
> > > > I was on pahole v1.17. I moved to v1.19 but I still see the same problem.

There are some changes post v1.19 in the git repo:

[acme@five pahole]$ git log --oneline v1.19..
b688e35970600c15 (HEAD -> master) btf_encoder: fix skipping per-CPU variables at offset 0
8c009d6ce762dfc9 btf_encoder: fix BTF variable generation for kernel modules
b94e97e015a94e6b dwarves: Fix compilation on 32-bit architectures
17df51c700248f02 btf_encoder: Detect kernel module ftrace addresses
06ca639505fc56c6 btf_encoder: Use address size based on ELF's class
aff60970d16b909e btf_encoder: Factor filter_functions function
1e6a3fed6e52d365 (quaco/master) rpm: Fix changelog date
[acme@five pahole]$

But I think these won't matter in this case :-\

- Arnaldo

> > > I can reproduce with your .config, but make 'defconfig' works,
> > > so I guess it's some config option issue, I'll check later today
> > 
> > so your .config has
> >   CONFIG_CRYPTO_DEV_BCM_SPU=y
> > 
> > and that defines 'struct device_private' which
> > clashes with the same struct defined in drivers/base/base.h
> > 
> > so several networking structs will be doubled, like net_device:
> > 
> > 	$ bpftool btf dump file ../vmlinux.config | grep net_device\' | grep STRUCT
> > 	[2731] STRUCT 'net_device' size=2240 vlen=133
> > 	[113981] STRUCT 'net_device' size=2240 vlen=133
> > 
> > each is using different 'struct device_private' when it's unwinded
> > 
> > and that will confuse BTFIDS logic, becase we have multiple structs
> > with the same name, and we can't be sure which one to pick
> > 
> > perhaps we should check on this in pahole and warn earlier with
> > better error message.. I'll check, but I'm not sure if pahole can
> > survive another hastab ;-)
> > 
> > Andrii, any ideas on this? ;-)
> > 
> > easy fix is the patch below that renames the bcm's structs,
> > it makes the kernel to compile.. but of course the new name
> > is probably wrong and we should push this through that code
> > authors
> 
> also another quick fix is to switch it to module
> 
> jirka
> 

-- 

- Arnaldo
