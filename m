Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCE463042CE
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 16:43:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391884AbhAZPna (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 10:43:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391590AbhAZPmj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 10:42:39 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2377CC061D73
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 07:41:54 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id a12so15169875lfb.1
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 07:41:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oVsiXGmwYKFhF927hVNGspQE67VMa+U4wm+0vmxhnyY=;
        b=X5it9///r1vV/exadVHwNvpu7mOpHv4yZt0Uq3tirgwqAkTrS0aQgBWlWKaYlrxbgl
         dQkQ6LYDSTp2ByP6jLROn3MlERBn9xmF/rG2YoCKd5kupBjYnBZhlM6H3MzFMtgDdIxf
         LF6QCHNbCkZSpBZ0/oaGeO1WRVyw4CtP6IeeVrmuoZlCrgEABnBZx69FiNNE4FHgjLIB
         4OxoXISYOc752U3HmqsIzqZTz7BNXFGvFUiVT7GHvh9WDiMfWbyMZCPjqlwzzdDms8PM
         4n2PhiCGw5fN63XAdS093C2t9Um+MFS60ZXcCtRm02TTP8x/DZeOZBLDwaGD+1Bt8iS5
         4wHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oVsiXGmwYKFhF927hVNGspQE67VMa+U4wm+0vmxhnyY=;
        b=g9YjJTRnQ1bz+jhsqMeB9I91FLyPy5uenOwVh6TTbmpWBxVwQqF8OeJeD1iS9lkTcH
         t/87E4xhaVa5jShWM5Ze8t7Spatb+Bb6woPPvo3yvX8zaRbBzFfb5qEa3X9GFY07WOjx
         lpj0yiKhsmOmnyeBqvocogP08YzhRHkVE8eRs8dqq/8jzK6oJY4C/prrKjvS+hJvL7Qm
         ZFcwbpIBzroV3/i6zGSWT0dHdM4XKgSbTZRmoVJM2ZL8CBMV7zDV6H8+mTbZ7ofs/3wb
         vVejILZe96MfSwZ6DBr6R97tbN83yLzFFvt10jRbW3rlQkRnjBxQTPfnwG8LQWVS3iBK
         GmEg==
X-Gm-Message-State: AOAM532yjAcmOK65nPYc/xm7aGUWixa1T/2X+4oHVHTwVIf00raPRGVD
        Gzb6/9KUcZycuBQJtSKNvtQ3kg0JKOTBVQ==
X-Google-Smtp-Source: ABdhPJz0WhtDQRhOSGAoJ63f0sRZvSlAkVmnw0I8s0JatMcuQRm88W9kPwUINbplPxc6Yov5GM+caQ==
X-Received: by 2002:ac2:551e:: with SMTP id j30mr3021271lfk.595.1611675712626;
        Tue, 26 Jan 2021 07:41:52 -0800 (PST)
Received: from [192.168.1.12] ([194.35.116.83])
        by smtp.gmail.com with ESMTPSA id l17sm1521480lfe.100.2021.01.26.07.41.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 07:41:51 -0800 (PST)
Subject: Re: [PATCH] bpf: fix build for BPF preload when $(O) points to a
 relative path
From:   Quentin Monnet <quentin@isovalent.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Brendan Higgins <brendanhiggins@google.com>,
        David Gow <davidgow@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>
References: <20210125154938.40504-1-quentin@isovalent.com>
 <CAEf4BzYKrmMM_9SRKyGA0LNv-DvThpr9cQsNLVtn5h0jEUYtWg@mail.gmail.com>
 <6a15aa00-5649-42e5-1c97-2e2985891607@isovalent.com>
Message-ID: <c94b7005-70d3-a5ae-fc5b-a7cf5b2ea35d@isovalent.com>
Date:   Tue, 26 Jan 2021 15:41:50 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <6a15aa00-5649-42e5-1c97-2e2985891607@isovalent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2021-01-26 11:24 UTC+0000 ~ Quentin Monnet <quentin@isovalent.com>
> 2021-01-25 16:32 UTC-0800 ~ Andrii Nakryiko <andrii.nakryiko@gmail.com>
>> On Mon, Jan 25, 2021 at 7:49 AM Quentin Monnet <quentin@isovalent.com> wrote:
>>>
>>> Building the kernel with CONFIG_BPF_PRELOAD, and by providing a relative
>>> path for the output directory, may fail with the following error:
>>>
>>>   $ make O=build bindeb-pkg
>>>   ...
>>>   /.../linux/tools/scripts/Makefile.include:5: *** O=build does not exist.  Stop.
>>>   make[7]: *** [/.../linux/kernel/bpf/preload/Makefile:9: kernel/bpf/preload/libbpf.a] Error 2
>>>   make[6]: *** [/.../linux/scripts/Makefile.build:500: kernel/bpf/preload] Error 2
>>>   make[5]: *** [/.../linux/scripts/Makefile.build:500: kernel/bpf] Error 2
>>>   make[4]: *** [/.../linux/Makefile:1799: kernel] Error 2
>>>   make[4]: *** Waiting for unfinished jobs....
>>>
>>> In the case above, for the "bindeb-pkg" target, the error is produced by
>>> the "dummy" check in Makefile.include, called from libbpf's Makefile.
>>> This check changes directory to $(PWD) before checking for the existence
>>> of $(O). But at this step we have $(PWD) pointing to "/.../linux/build",
>>> and $(O) pointing to "build". So the Makefile.include tries in fact to
>>> assert the existence of a directory named "/.../linux/build/build",
>>> which does not exist.
>>>
>>> By contrast, other tools called from the main Linux Makefile get the
>>> variable set to $(abspath $(objtree)), where $(objtree) is ".". We can
>>> update the Makefile for kernel/bpf/preload to set $(O) to the same
>>> value, to permit compiling with a relative path for output. Note that
>>> apart from the Makefile.include, the variable $(O) is not used in
>>> libbpf's build system.
>>>
>>> Note that the error does not occur for all make targets and
>>> architectures combinations.
>>>
>>> - On x86, "make O=build vmlinux" appears to work fine.
>>>   $(PWD) points to "/.../linux/tools", but $(O) points to the absolute
>>>   path "/.../linux/build" and the test succeeds.
>>> - On UML, it has been reported to fail with a message similar to the
>>>   above (see [0]).
>>> - On x86, "make O=build bindeb-pkg" fails, as described above.
>>>
>>> It is unsure where the different values for $(O) and $(PWD) come from
>>> (likely some recursive make with different arguments at some point), and
>>> because several targets are broken, it feels safer to fix the $(O) value
>>> passed to libbpf rather than to hunt down all changes to the variable.
>>>
>>> David Gow previously posted a slightly different version of this patch
>>> as a RFC [0], two months ago or so.
>>>
>>> [0] https://lore.kernel.org/bpf/20201119085022.3606135-1-davidgow@google.com/t/#u
>>>
>>> Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
>>> Cc: Brendan Higgins <brendanhiggins@google.com>
>>> Cc: David Gow <davidgow@google.com>
>>> Reported-by: David Gow <davidgow@google.com>
>>> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
>>> ---
>>
>> I still think it would benefit everyone to figure out where this is
>> breaking (given Linux Makefile explicitly tries to handle such
>> relative path situation for O=, I believe), but this is trivial
>> enough, so:
>>
>> Acked-by: Andrii Nakryiko <andrii@kernel.org>
> 
> Agreed, I'll try to spend a bit more time on this when I can. But it
> would be nice to have the fix in the meantime. Thanks for the review and
> ack.

+Cc Masahiro Yamada

Looking further into this, my understanding is the following.

tools/scripts/Makefile.include contains this check:

	dummy := $(if $(shell cd $(PWD); test -d $(O) || \
		echo $(O)),$(error O=$(O) does not exist),)
	ABSOLUTE_O := $(shell cd $(PWD); cd $(O) ; pwd)

Note the use of $(PWD). As I understand, it is the shell environment
variable, as it was set when the initial "make" command was run. This
seems to be passed down to recursive calls to make. So if I type

	$ cd /linux
	$ make O=build vmlinux

Then I get $(PWD) set to "/linux" and $(O) set to "build". The Makefile
executes a submake from the output directory:

	# Invoke a second make in the output directory, passing relevant
	# variables
	__sub-make:
		$(Q)$(MAKE) -C $(abs_objtree) \
			-f $(abs_srctree)/Makefile $(MAKECMDGOALS)

But the variables are preserved. So far, so good.

When I try to build "bindeb-pkg" instead:

	$ cd /linux
	$ make O=build bindeb-pkg

Then I initially set $(PWD) and $(O) to the same values. They are
preserved after the call to the submake, after we have changed to the
output directory. But if I understand correctly, the "bindeb-pkg" target
writes a new Makefile as build/debian/rules in scripts/package/mkdebian,
and calls it _indirectly_ through dpkg-buildpackage, which does _not_
preserve $(PWD) (instead, it is reset to /linux/build, the current
directory when calling the script). I end up with $(O) set to "build",
and $(PWD) set to "/linux/build". The "dummy" check called for libbpf
fails to find "/linux/build/build".

Can we avoid using $(PWD) in the first place? I'm not sure how. It was
added in commit be40920fbf10 ("tools: Let O= makes handle a relative
path with -C option") to accommodate building perf with "-C", so we
could not replace $(PWD) with $$PWD (shell value at the time the
directive is executed) for example, the values will be different.

Can we unset $(O) so that, when we call dpkg-buildpackage, it reflects
the output directory relatively to /linux/build/? Or pass a value for
$(PWD), so it is preserved? Maybe, I don't know. It could be done in
scripts/package/mkdebian for example, by passing "O=''" to the make
call. It seems that the packages build well with this change. But then
we might need to check and update the other packages too (RPM, snap,
perf archives), and identify if something similar might be happening for
UML. I'm not sure this is worth the trouble at this point, if all we
want is to fix the eBPF preloads? But I'm open to discussion if this is
really the path we want to go.

Fixing $(O) to pass the dummy check is easier. However, when reading the
commits I noticed that my patch is incorrect. It would break on
something like "make O=~/build bindeb-pkg", because abspath does not
resolve special shell characters like "~". See also commit 028568d84da3
("kbuild: revert $(realpath ...) to $(shell cd ... && /bin/pwd)"): this
is why tools/scripts/Makefile.include still has an "ABSOLUTE_O"
variable. So instead of setting "O=$(abspath .)", I'll send a v2 with
Andrii's suggestion to use $(LIBBPF_OUT).

Quentin
