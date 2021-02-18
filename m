Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F090E31F05D
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 20:51:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233074AbhBRTrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 14:47:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232069AbhBRT1Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 14:27:24 -0500
Received: from ms.lwn.net (ms.lwn.net [IPv6:2600:3c01:e000:3a1::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B892C06178A;
        Thu, 18 Feb 2021 11:26:44 -0800 (PST)
Received: from localhost (unknown [IPv6:2601:281:8300:104d::5f6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id C7A3A2C4;
        Thu, 18 Feb 2021 19:26:43 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net C7A3A2C4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
        t=1613676403; bh=2mg9x0IxkWoM6pMebWd2P3H7sA/TWYSV68lPpE/xunc=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=eaEgMBY9s3KoP8DX/OVi7atfBqQoPSBl04gc7/zs+qaw+X56ua9hn5Vxw3dXNbUtU
         qX4cpO5qoaPTllica8Rrolf2AisllRAReo4a2r7P2uVeDDhFwaPHalLkvfP8LoZALk
         itTXfZKQ9c5T0URRT4CD0f42vaxq6arHU6fGF5LiqGHoffZF7zw71BmuHkaaoeKuCC
         iVJC+QGrIu7C2sW10ehDXVCf9AQfOAXKyiRKBFaa2y8eA4MrYegR5pshZVYFdr9C08
         fr6elj3vZVjN8WHqXxBMKjUI6odHlx52UJ79mZKli1qMYilEZIEwWCujNFY8F1ZUCR
         w6bI3/VpRRMUA==
From:   Jonathan Corbet <corbet@lwn.net>
To:     Joe Stringer <joe@cilium.io>
Cc:     bpf@vger.kernel.org, Joe Stringer <joe@cilium.io>,
        linux-man@vger.kernel.org, Networking <netdev@vger.kernel.org>,
        mtk.manpages@gmail.com, ast@kernel.org, brianvv@google.com,
        Daniel Borkmann <daniel@iogearbox.net>, daniel@zonque.org,
        john.fastabend@gmail.com, ppenkov@google.com,
        Quentin Monnet <quentin@isovalent.com>, sean@mess.org,
        yhs@fb.com, linux-doc@vger.kernel.org
Subject: Re: [PATCH bpf-next 00/17] Improve BPF syscall command documentation
In-Reply-To: <CADa=RyzDXeJeW7jAVce0zfGX2zN5ZcAv5nwYsX7EtAz=bgZYkg@mail.gmail.com>
References: <20210217010821.1810741-1-joe@wand.net.nz>
 <871rdewqf2.fsf@meer.lwn.net>
 <CADa=RyzDXeJeW7jAVce0zfGX2zN5ZcAv5nwYsX7EtAz=bgZYkg@mail.gmail.com>
Date:   Thu, 18 Feb 2021 12:26:43 -0700
Message-ID: <878s7lrxcc.fsf@meer.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Joe Stringer <joe@cilium.io> writes:

> Hey Jon, thanks for the feedback. Absolutely, what you say makes
> sense. The intent here wasn't to come up with something new. Based on
> your prompt from this email (and a quick look at your KR '19
> presentation), I'm hearing a few observations:
> * Storing the documentation in the code next to the things that
> contributors edit is a reasonable approach to documentation of this
> kind.

Yes.  At least, it's what we do for a lot of our other documentation in
the kernel.  The assumption is that it will encourage developers to keep
the docs current; in my experience that's somewhat optimistic, but
optimism is good...:)

> * This series currently proposes adding some new Makefile
> infrastructure. However, good use of the "kernel-doc" sphinx directive
> + "DOC: " incantations in the header should be able to achieve the
> same without adding such dedicated build system logic to the tree.

If it can, I would certainly prefer to see it used - or extended, if
need be, to meet your needs.

> * The changes in patch 16 here extended Documentation/bpf/index.rst,
> but to assist in improving the overall kernel documentation
> organisation / hierarchy, you would prefer to instead introduce a
> dedicated Documentation/userspace-api/bpf/ directory where the bpf
> uAPI portions can be documented.

An objective I've been working on for some years is reorienting the
documentation with a focus on who the readers are.  We've tended to
organize it by subsystem, requiring people to wade through a lot of
stuff that isn't useful to them.  So yes, my preference would be to
document the kernel's user-space API in the relevant manual.

That said, I do tend to get pushback here at times, and the BPF API is
arguably a bit different that much of the rest.  So while the above
preference exists and is reasonably strong, the higher priority is to
get good, current documentation in *somewhere* so that it's available to
users.  I don't want to make life too difficult for people working
toward that goal, even if I would paint it a different color.

> In addition to this, today the bpf helpers documentation is built
> through the bpftool build process as well as the runtime bpf
> selftests, mostly as a way to ensure that the API documentation
> conforms to a particular style, which then assists with the generation
> of ReStructured Text and troff output. I can probably simplify the
> make infrastructure involved in triggering the bpf docs build for bpf
> subsystem developers and maintainers. I think there's likely still
> interest from bpf folks to keep that particular dependency in the
> selftests like today and even extend it to include this new
> Documentation, so that we don't either introduce text that fails
> against the parser or in some other way break the parser. Whether that
> validation is done by scripts/kernel-doc or scripts/bpf_helpers_doc.py
> doesn't make a big difference to me, other than I have zero experience
> with Perl. My first impressions are that the bpf_helpers_doc.py is
> providing stricter formatting requirements than what "DOC: " +
> kernel-doc would provide, so my baseline inclination would be to keep
> those patches to enhance that script and use that for the validation
> side (help developers with stronger linting feedback), then use
> kernel-doc for the actual html docs generation side, which would help
> to satisfy your concern around duplication of the documentation build
> systems.

This doesn't sound entirely unreasonable.  I wonder if the BPF helper
could be built into an sphinx extension to make it easy to pull that
information into the docs build.  The advantage there is that it can be
done in Python :)

Looking forward to the next set.

Thanks,

jon
