Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D69831653BF
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 01:48:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbgBTAr0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 19:47:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:37434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726962AbgBTAr0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 19:47:26 -0500
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 793792465D;
        Thu, 20 Feb 2020 00:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582159645;
        bh=IoyCu3Rfg36TnWgV/FX467X5fODdY0uZIig5iWzvj2Y=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=dk0aWK516QpktQDynoQnd5IU3diktxkycW0Dz2cwfjo3LG73XXp9yPtJol9GJVjBE
         mpyTvwkvUQD1H+YXNjkl9x5u6vrrnrEdrVHo6o6gKRjL732msJctzi9ekPggT78WRt
         eGR9BGUQfx2yzpuFdPqTeoYIAkn68YZU+BfYT720=
Subject: Re: Kernel 5.5.4 build fail for BPF-selftests with latest LLVM
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        =?UTF-8?Q?Daniel_D=c3=adaz?= <daniel.diaz@linaro.org>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        BPF-dev-list <bpf@vger.kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        shuah <shuah@kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
References: <20200219133012.7cb6ac9e@carbon>
 <CAADnVQKQRKtDz0Boy=-cudc4eKGXB-yParGZv6qvYcQR4uMUQQ@mail.gmail.com>
 <20200219180348.40393e28@carbon>
 <CAEf4Bza9imKymHfv_LpSFE=kNB5=ZapTS3SCdeZsDdtrUrUGcg@mail.gmail.com>
 <20200219192854.6b05b807@carbon>
 <CAEf4BzaRAK6-7aCCVOA6hjTevKuxgvZZnHeVgdj_ZWNn8wibYQ@mail.gmail.com>
 <20200219210609.20a097fb@carbon>
 <CAEUSe79Vn8wr=BOh0RzccYij_snZDY=2XGmHmR494wsQBBoo5Q@mail.gmail.com>
 <20200220002748.kpwvlz5xfmjm5fd5@ast-mbp>
From:   shuah <shuah@kernel.org>
Message-ID: <4a26e6c6-500e-7b92-1e26-16e1e0233889@kernel.org>
Date:   Wed, 19 Feb 2020 17:47:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200220002748.kpwvlz5xfmjm5fd5@ast-mbp>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/19/20 5:27 PM, Alexei Starovoitov wrote:
> On Wed, Feb 19, 2020 at 03:59:41PM -0600, Daniel Díaz wrote:
>>>
>>> When I download a specific kernel release, how can I know what LLVM
>>> git-hash or version I need (to use BPF-selftests)?
> 
> as discussed we're going to add documentation-like file that will
> list required commits in tools.
> This will be enforced for future llvm/pahole commits.
> 
>>> Do you think it is reasonable to require end-users to compile their own
>>> bleeding edge version of LLVM, to use BPF-selftests?
> 
> absolutely.

+ linux-kselftest@vger.kernel.org

End-users in this context are users and not necessarily developers.

> If a developer wants to send a patch they must run all selftests and
> all of them must pass in their environment.
> "but I'm adding a tracing feature and don't care about networking tests
> failing"... is not acceptable.

This is a reasonable expectation when a developers sends bpf patches.

> 
>>> I do hope that some end-users of BPF-selftests will be CI-systems.
>>> That also implies that CI-system maintainers need to constantly do
>>> "latest built from sources" of LLVM git-tree to keep up.  Is that a
>>> reasonable requirement when buying a CI-system in the cloud?
> 
> "buying CI-system in the cloud" ?
> If I could buy such system I would pay for it out of my own pocket to save
> maintainer's and developer's time.
> 
>> We [1] are end users of kselftests and many other test suites [2]. We
>> run all of our testing on every git-push on linux-stable-rc, mainline,
>> and linux-next -- approximately 1 million tests per week. We have a
>> dedicated engineering team looking after this CI infrastructure and
>> test results, and as such, I can wholeheartedly echo Jesper's
>> sentiment here: We would really like to help kernel maintainers and
>> developers by automatically testing their code in real hardware, but
>> the BPF kselftests are difficult to work with from a CI perspective.
>> We have caught and reported [3] many [4] build [5] failures [6] in the
>> past for libbpf/Perf, but building is just one of the pieces. We are
>> unable to run the entire BPF kselftests because only a part of the
>> code builds, so our testing is very limited there.
>>
>> We hope that this situation can be improved and that our and everyone
>> else's automated testing can help you guys too. For this to work out,
>> we need some help.
> 

It would be helpful understand what "help" is in this context.

> I don't understand what kind of help you need. Just install the latest tools.

What would be helpful is to write bpf tests such that older tests that
worked on older llvm versions continue to work and with some indication
on which tests require new bleeding edge tools.

> Both the latest llvm and the latest pahole are required.

It would be helpful if you can elaborate why latest tools are a
requirement.

> If by 'help' you mean to tweak selftests to skip tests then it's a nack.
> We have human driven CI. Every developer must run selftests/bpf before
> emailing the patches. Myself and Daniel run them as well before applying.
> These manual runs is the only thing that keeps bpf tree going.
> If selftests get to skip tests humans will miss those errors.
> When I don't see '0 SKIPPED, 0 FAILED' I go and investigate.
> Anything but zero is a path to broken kernels.
> 
> Imagine the tests would get skipped when pahole is too old.
> That would mean all of the kernel features from year 2019
> would get skipped. Is there a point of running such selftests?
> I think the value is not just zero. The value is negative.
> Such selftests that run old stuff would give false believe
> that they do something meaningful.
> "but CI can do build only tests"... If 'helping' such CI means hurting the
> key developer/maintainer workflow such CI is on its own.
> 

Skipping tests will be useless. I am with you on that. However,
figuring out how to maintain some level of backward compatibility
to run at least older tests and warn users to upgrade would be
helpful.

I suspect currently users are ignoring bpf failures because they
are unable to keep up with the requirement to install newer tools
to run the tests. This isn't great either.

Users that care are sharing their pain to see if they can get some
help or explanation on why new tools are required every so often.
I don't think everybody understands why. :)

thanks,
-- Shuah
