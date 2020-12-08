Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 461932D23CA
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 07:46:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726601AbgLHGqQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 01:46:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:57286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726104AbgLHGqQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 01:46:16 -0500
Message-ID: <5a86df89822ba7e4d944867916423c46ad4b7434.camel@kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607409935;
        bh=sfTEMM/Uu5YXCbVKTpCwRm+LHiCCLcV4ZrIT1p40/sM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=cKK4LgTxZKnzpVGX4nbcaIt6yYHU20YSXSUGqa45tHq6+RgY4rIJ5oA7cNItC/Je+
         G+unZPihFaE0YIkl8GUM4VzYkNCzlTWrl819cq/hyR5nOAb9kanzjZrmymbfwjbUzD
         bpkdD0H3mkyVPJ6TKpDO/yalfkKNPvw+dPP/TzHRf5HUf7Ezhjc3MFM29+zUTnIs77
         xI6Uv1mx5NND49VlXDy8M0S+RYoqA8nvcY3CTHm8d+jVi816q7PU5DtvBTlY/8LzzL
         HLUkWxEq11rSx7c+D1H6mL7tz2obHBUmR9REsuY4IfgmUkMPFo2Lr4S+dtPU26Mmcx
         6qaIWDghzx3PA==
Subject: Re: [PATCH bpf] tools/bpftool: Add/Fix support for modules btf dump
From:   Saeed Mahameed <saeed@kernel.org>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>
Date:   Mon, 07 Dec 2020 22:45:34 -0800
In-Reply-To: <CAEf4BzYzJuPt8Fct2pOTPjHLiiyGPQw05rFNK4d+MAJTC_itkw@mail.gmail.com>
References: <20201207052057.397223-1-saeed@kernel.org>
         <CAEf4BzZe2162nMsamMKkGRpR_9hUnaATWocE=XjgZd+2cJk5Jw@mail.gmail.com>
         <76aa0d16e3d03cf12496184c848f60069bf71872.camel@kernel.org>
         <CAEf4BzYzJuPt8Fct2pOTPjHLiiyGPQw05rFNK4d+MAJTC_itkw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2020-12-07 at 22:38 -0800, Andrii Nakryiko wrote:
> On Mon, Dec 7, 2020 at 10:26 PM Saeed Mahameed <saeed@kernel.org>
> wrote:
> > On Mon, 2020-12-07 at 19:14 -0800, Andrii Nakryiko wrote:
> > > On Sun, Dec 6, 2020 at 9:21 PM <saeed@kernel.org> wrote:
> > > > From: Saeed Mahameed <saeedm@nvidia.com>
> > > > 
[...]
> > > > 
> > > > I am not sure why this hasn't been added by the original
> > > > patchset
> > > 
> > > because I never though of dumping module BTF by id, given there
> > > is
> > > nicely named /sys/kernel/btf/<module> :)
> > > 
> > 
> > What if i didn't compile my kernel with SYSFS ? a user experience
> > is a
> > user experience, there is no reason to not support dump a module
> > btf by
> > id or to have different behavior for different BTF sources.
> 
> Hm... I didn't claim otherwise and didn't oppose the feature, why the
> lecture about user experience?
> 

Sorry wasn't a lecture, just wanted to emphasize the motivation.

> Not having sysfs is a valid point. In such cases, if BTF dumping is
> from ID and we see that it's a module BTF, finding vmlinux BTF from
> ID
> makes sense.
> 
> > I can revise this patch to support -B option and lookup vmlinux
> > file if
> > not provided for module btf dump by ids.
> 
> yep
> 
> > but we  still need to pass base_btf to btf__get_from_id() in order
> > to
> > support that, as was done for btf__parse_split() ... :/
> 
> btf__get_from_id_split() might be needed, yes.
> 
> > Are you sure you don't like the current patch/libbpf API ? it is
> > pretty
> > straight forward and correct.
> 
> I definitely don't like adding btf_get_kernel_id() API to libbpf.
> There is nothing special about it to warrant adding it as a public
> API. Everything we discussed can be done by bpftool.
> 

What about the case where sysfs isn't available ?
we still need to find vmlinux's btf id..



