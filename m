Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CABC2DC286
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 15:54:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726216AbgLPOyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 09:54:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726162AbgLPOyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 09:54:01 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CC80C0617A6
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 06:53:21 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id c133so2617759wme.4
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 06:53:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Q1ar70vGkkLzayQby8Ky4/ZiYUgs+a+/N1nwlY1uaSA=;
        b=XQYgBJDPkyW9GfmZxNHramdqTXdW2ybIxQq/IXhUO2kbsPXsYecgJXy1X6tAZlSXrB
         Vj2o36LpCOYXRvK29egEJKxdQSntZWe2betPjLuC7/GaUrH0BWrCbOvJICKbThTzm2EC
         a2cjsaGeo9JHIjxPj64xfai3TSc43qJvAmNHVel+icSN1kpeCmvIPOYJznd/CebA/q8G
         MjIY7E4WCZkgCiZx2f8pbq2kaEheFUETLQkLvcfxVRMgUMEgRrLwKoz9AkRYD/EAOgkl
         pkuYDJTtZwqbnGepZCXa1QS4v6NTwhM+dLf27aDqLa2M15a9A09VzPkLtuWovspAcCPJ
         14wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Q1ar70vGkkLzayQby8Ky4/ZiYUgs+a+/N1nwlY1uaSA=;
        b=P/QE/9iLrW7otVHLi2yztIiazHD+7FUVG66YHmgfPRnJckSvgJJ8L2ZHekFeJi2u4P
         I+VRfyxcmlawDBry7Sxq6Gwf+QWHX4dwo3BG4hUn8h1Jnv5C3ysVzs/y25Q4I7hSH90x
         VzdPYuksC7fFqZzxqzLLMgt88RTeyn7sMEmx79uIFRDZbbliosnOtwzB9UGI6P7rkYOE
         zVlyqjygT9R075abtwAD8JBY8j51mmM0lymxxaiiFD8fuSrX0vkK425Ar8nSiZLCrlDg
         3waqsXVbhjv+E8ADcMG9cbqPImK1QER1szxvysr0zmQ+mtPm0oUPKufWdsxA4mENENpF
         JiOg==
X-Gm-Message-State: AOAM53058VJF56DJpDhnTyDmA0uRR7FOJ+VFsu94I1Ogn67CUIYgOeol
        hj2Tz1eFPQ83esq8rHrxzvmtsg==
X-Google-Smtp-Source: ABdhPJx5RpfA+2qeVCZsU03uX+aDaGDWwP1Tw7kA9r+84654NcKA1goqoJsLoxUkT7Wu/PpEypdnPg==
X-Received: by 2002:a05:600c:258:: with SMTP id 24mr3864547wmj.16.1608130399833;
        Wed, 16 Dec 2020 06:53:19 -0800 (PST)
Received: from [192.168.1.13] ([194.35.118.46])
        by smtp.gmail.com with ESMTPSA id l1sm2904401wmi.15.2020.12.16.06.53.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Dec 2020 06:53:19 -0800 (PST)
Subject: Re: [RFC PATCH] bpf: preload: Fix build error when O= is set
To:     David Gow <davidgow@google.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Brendan Higgins <brendanhiggins@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        linux-um <linux-um@lists.infradead.org>
References: <20201119085022.3606135-1-davidgow@google.com>
 <CAEf4BzY4i0fH34eO=-4WOzVpifgPmJ0ER5ipBJWB0_4Zdv0AQg@mail.gmail.com>
 <CABVgOSn10kCaD7EQCMJTgD8udNx6fOExqUL1gXHzEViemiq3LA@mail.gmail.com>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <3678c6eb-3815-a360-f495-fc246513f0f5@isovalent.com>
Date:   Wed, 16 Dec 2020 14:53:13 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <CABVgOSn10kCaD7EQCMJTgD8udNx6fOExqUL1gXHzEViemiq3LA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-11-21 17:48 UTC+0800 ~ David Gow <davidgow@google.com>
> On Sat, Nov 21, 2020 at 3:38 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
>>
>> On Thu, Nov 19, 2020 at 12:51 AM David Gow <davidgow@google.com> wrote:
>>>
>>> If BPF_PRELOAD is enabled, and an out-of-tree build is requested with
>>> make O=<path>, compilation seems to fail with:
>>>
>>> tools/scripts/Makefile.include:4: *** O=.kunit does not exist.  Stop.
>>> make[4]: *** [../kernel/bpf/preload/Makefile:8: kernel/bpf/preload/libbpf.a] Error 2
>>> make[3]: *** [../scripts/Makefile.build:500: kernel/bpf/preload] Error 2
>>> make[2]: *** [../scripts/Makefile.build:500: kernel/bpf] Error 2
>>> make[2]: *** Waiting for unfinished jobs....
>>> make[1]: *** [.../Makefile:1799: kernel] Error 2
>>> make[1]: *** Waiting for unfinished jobs....
>>> make: *** [Makefile:185: __sub-make] Error 2
>>>
>>> By the looks of things, this is because the (relative path) O= passed on
>>> the command line is being passed to the libbpf Makefile, which then
>>> can't find the directory. Given OUTPUT= is being passed anyway, we can
>>> work around this by explicitly setting an empty O=, which will be
>>> ignored in favour of OUTPUT= in tools/scripts/Makefile.include.
>>
>> Strange, but I can't repro it. I use make O=<absolute path> all the
>> time with no issues. I just tried specifically with a make O=.build,
>> where .build is inside Linux repo, and it still worked fine. See also
>> be40920fbf10 ("tools: Let O= makes handle a relative path with -C
>> option") which was supposed to address such an issue. So I'm wondering
>> what exactly is causing this problem.
>>
> [+ linux-um list]
> 
> Hmm... From a quick check, I can't reproduce this on x86, so it's
> possibly a UML-specific issue.
> 
> The problem here seems to be that $PWD is, for whatever reason, equal
> to the srcdir on x86, but not on UML. In general, $PWD behaves pretty
> weirdly -- I don't fully understand it -- but if I add a tactical "PWD
> := $(shell pwd)" or use $(CURDIR) instead, the issue shows up on x86
> as well. I guess this is because PWD only gets updated when set by a
> shell or something, and UML does this somewhere?
> 
> Thoughts?
> 
> Cheers,
> -- David

Hi David, Andrii,

David, did you use a different command for building for UML and x86? I'm
asking because I reproduce on x86, but only for some targets, in
particular when I tried bindeb-pkg.

With "make O=.build vmlinux", I have:
- $(O) for "dummy" check in tools/scripts/Makefile.include set to
/linux/.build
- $(PWD) for same check set to /linux/tools
- Since $(O) is an absolute path, the "dummy" check passes

With "make O=.build bindeb-pkg", I have instead:
- $(O) set to .build (relative path)
- $(PWD) set to /linux/.build
- "dummy" check changes to /linux/.build and searches for .build in it,
which fails and aborts the build

(tools/scripts/Makefile.include is included from libbpf's Makefile,
called from kernel/bpf/preload/Makefile.)

I'm not sure how exactly the bindeb-pkg target ends up passing these values.

For what it's worth, I have been solving this (before finding this
thread) with a fix close to yours, I pass "O=$(abspath .)" on the
command line for building libbpf in kernel/bpf/preload/Makefile. It
looked consistent to me with the "tools/:" target from the main
Makefile, where "O=$(abspath $(objtree))" is passed (and $(objtree) is ".").

I hope this helps,
Quentin
