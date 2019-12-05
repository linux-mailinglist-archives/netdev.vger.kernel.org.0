Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC091138CF
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 01:29:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728540AbfLEA3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 19:29:33 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38100 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728121AbfLEA3d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 19:29:33 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8BF3C14F0E35A;
        Wed,  4 Dec 2019 16:29:31 -0800 (PST)
Date:   Wed, 04 Dec 2019 16:29:29 -0800 (PST)
Message-Id: <20191204.162929.2216543178968689201.davem@davemloft.net>
nTo:    jakub.kicinski@netronome.com
Cc:     alexei.starovoitov@gmail.com, andrii.nakryiko@gmail.com,
        toke@redhat.com, jolsa@kernel.org, acme@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, mingo@kernel.org, namhyung@kernel.org,
        alexander.shishkin@linux.intel.com, a.p.zijlstra@chello.nl,
        mpetlan@redhat.com, brouer@redhat.com, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        quentin.monnet@netronome.com
Subject: Re: [PATCHv4 0/6] perf/bpftool: Allow to link libbpf dynamically
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191204162348.49be5f1b@cakuba.netronome.com>
References: <20191204135405.3ffb9ad6@cakuba.netronome.com>
        <20191204233948.opvlopjkxe5o66lr@ast-mbp.dhcp.thefacebook.com>
        <20191204162348.49be5f1b@cakuba.netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 04 Dec 2019 16:29:32 -0800 (PST)
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Wed, 4 Dec 2019 16:23:48 -0800

> Jokes aside, you may need to provide some reasoning on this one..
> The recommendation for packaging libbpf from GitHub never had any 
> clear justification either AFAICR.
> 
> I honestly don't see why location matters. bpftool started out on GitHub
> but we moved it into the tree for... ease of packaging/distribution(?!)
> Now it's handy to have it in the tree to reuse the uapi headers.
> 
> As much as I don't care if we move it (back) out of the tree - having
> two copies makes no sense to me. As does having it in the libbpf repo.
> The sync effort is not warranted. User confusion is not warranted.

Part of this story has to do with how bug fixes propagate via bpf-next
instead of the bpf tree, as I understand it.

But yeah it would be nice to have a clear documentation on all of the
reasoning.

On the distro side, people seem to not want to use the separate repo.
If you're supporting enterprise customers you don't just sync with
upstream, you cherry pick.  When cherry picking gets too painful, you
sync with upstream possibly eliding upstream new features you don't
want to appear in your supported product yet.

I agree with tying bpftool and libbpf into the _resulting_ binary
distro package, but I'm not totally convinced about separating them
out of the kernel source tree.
