Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76984303B91
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 12:26:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404934AbhAZLZ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 06:25:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392351AbhAZLZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 06:25:35 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55BC0C06174A
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 03:24:54 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id bl23so1807356ejb.5
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 03:24:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ehd8dKvshqv096MiiF/4A8h0oTzqB7VPo9idTPblfLk=;
        b=ukaf2mU19r2MLgtt/uK6CHnuXPt69grvD1TJofxIMCDqRoX7RGjO52L63lyIIfhS4M
         gJDWm0LQl4sTgZRrNPaVt/hcIFajPnUmpsumr1CPI6NB5jglpyRii/w8ejf/pT0M3fSP
         +1yPnnoSNeUNqA0GEFFqHBzjzUrTxPi2cwBv68t8MxBZ5WK8SAvD72TBBeiJEUTyB2I3
         LK+01jQwZdGtKT8pzGkvMoMdpXjApgiO4HSZNiO0eC31LgR2NCqdkgrLiJXsLkIVBw30
         7kHs/j5WomsxMMI3cMKC8LkZFCp89vzdufb/dSIHgNJoiRmvoK3aByHNnUuX7PYM0Sbk
         uAgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ehd8dKvshqv096MiiF/4A8h0oTzqB7VPo9idTPblfLk=;
        b=lgZVcW5RS1fXpF6YjxDSS1yjI/xs6zZ09gPJ+wRpmtTvlB6zfPWRtfRRB7iODDA5Il
         xzdeePiDhki/IwXyh4m/7sPsByeKhZZHFAb7orP7qBA+aOeHE8hO/MdrxfP+KqZ4uCq/
         ReJr2K6FoXC6q8xuiqCB2vGHPj/PCYdoH62oH15s9Nq/jjE9b3K46sUEjwGLRiqnDntb
         559sOY7H7dIqAu8bUhvGHRxwOMT8dNcka30bDd4XHLworSqtwmysOxu6NK3wykcEqqAN
         nACwM5O2U203r9G+3YPATZjwlLgDiK3S949SBt0AmKve6K5K6PcvXhQYvnhbdyiTROd+
         w5ng==
X-Gm-Message-State: AOAM533VKHVHVKwwprfHLfZ+PF33GceerT3fEpBTcY8Isjdm23qNtSun
        ZgxAZPMxSbOtnHZYp/ZuapEtSw==
X-Google-Smtp-Source: ABdhPJysQtODpS58Gb9O+DO0iyddvPZBOvOCTQklNEK4Aa6djh5ZgkjCqLHvmew57oTyHqq42NbQcA==
X-Received: by 2002:a17:906:890:: with SMTP id n16mr3044839eje.195.1611660293091;
        Tue, 26 Jan 2021 03:24:53 -0800 (PST)
Received: from [192.168.1.12] ([194.35.116.83])
        by smtp.gmail.com with ESMTPSA id r11sm12222226edt.58.2021.01.26.03.24.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 03:24:52 -0800 (PST)
Subject: Re: [PATCH] bpf: fix build for BPF preload when $(O) points to a
 relative path
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Brendan Higgins <brendanhiggins@google.com>,
        David Gow <davidgow@google.com>
References: <20210125154938.40504-1-quentin@isovalent.com>
 <CAEf4BzYKrmMM_9SRKyGA0LNv-DvThpr9cQsNLVtn5h0jEUYtWg@mail.gmail.com>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <6a15aa00-5649-42e5-1c97-2e2985891607@isovalent.com>
Date:   Tue, 26 Jan 2021 11:24:51 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <CAEf4BzYKrmMM_9SRKyGA0LNv-DvThpr9cQsNLVtn5h0jEUYtWg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2021-01-25 16:32 UTC-0800 ~ Andrii Nakryiko <andrii.nakryiko@gmail.com>
> On Mon, Jan 25, 2021 at 7:49 AM Quentin Monnet <quentin@isovalent.com> wrote:
>>
>> Building the kernel with CONFIG_BPF_PRELOAD, and by providing a relative
>> path for the output directory, may fail with the following error:
>>
>>   $ make O=build bindeb-pkg
>>   ...
>>   /.../linux/tools/scripts/Makefile.include:5: *** O=build does not exist.  Stop.
>>   make[7]: *** [/.../linux/kernel/bpf/preload/Makefile:9: kernel/bpf/preload/libbpf.a] Error 2
>>   make[6]: *** [/.../linux/scripts/Makefile.build:500: kernel/bpf/preload] Error 2
>>   make[5]: *** [/.../linux/scripts/Makefile.build:500: kernel/bpf] Error 2
>>   make[4]: *** [/.../linux/Makefile:1799: kernel] Error 2
>>   make[4]: *** Waiting for unfinished jobs....
>>
>> In the case above, for the "bindeb-pkg" target, the error is produced by
>> the "dummy" check in Makefile.include, called from libbpf's Makefile.
>> This check changes directory to $(PWD) before checking for the existence
>> of $(O). But at this step we have $(PWD) pointing to "/.../linux/build",
>> and $(O) pointing to "build". So the Makefile.include tries in fact to
>> assert the existence of a directory named "/.../linux/build/build",
>> which does not exist.
>>
>> By contrast, other tools called from the main Linux Makefile get the
>> variable set to $(abspath $(objtree)), where $(objtree) is ".". We can
>> update the Makefile for kernel/bpf/preload to set $(O) to the same
>> value, to permit compiling with a relative path for output. Note that
>> apart from the Makefile.include, the variable $(O) is not used in
>> libbpf's build system.
>>
>> Note that the error does not occur for all make targets and
>> architectures combinations.
>>
>> - On x86, "make O=build vmlinux" appears to work fine.
>>   $(PWD) points to "/.../linux/tools", but $(O) points to the absolute
>>   path "/.../linux/build" and the test succeeds.
>> - On UML, it has been reported to fail with a message similar to the
>>   above (see [0]).
>> - On x86, "make O=build bindeb-pkg" fails, as described above.
>>
>> It is unsure where the different values for $(O) and $(PWD) come from
>> (likely some recursive make with different arguments at some point), and
>> because several targets are broken, it feels safer to fix the $(O) value
>> passed to libbpf rather than to hunt down all changes to the variable.
>>
>> David Gow previously posted a slightly different version of this patch
>> as a RFC [0], two months ago or so.
>>
>> [0] https://lore.kernel.org/bpf/20201119085022.3606135-1-davidgow@google.com/t/#u
>>
>> Cc: Andrii Nakryiko <andrii.nakryiko@gmail.com>
>> Cc: Brendan Higgins <brendanhiggins@google.com>
>> Cc: David Gow <davidgow@google.com>
>> Reported-by: David Gow <davidgow@google.com>
>> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
>> ---
> 
> I still think it would benefit everyone to figure out where this is
> breaking (given Linux Makefile explicitly tries to handle such
> relative path situation for O=, I believe), but this is trivial
> enough, so:
> 
> Acked-by: Andrii Nakryiko <andrii@kernel.org>

Agreed, I'll try to spend a bit more time on this when I can. But it
would be nice to have the fix in the meantime. Thanks for the review and
ack.

> 
> BTW, you haven't specified which tree you intended it for.

Oops! I _knew_ I was missing something, sorry. This build issue is here
since eBPF preload was introduced, so I meant to send to the *bpf* tree.

Because it does not concern the major build targets, I was not sure if a
"Fixes:" tag would be appropriate. If we want one, it should be for
d71fa5c9763c ("bpf: Add kernel module with user mode driver that
populates bpffs.")

> 
>>  kernel/bpf/preload/Makefile | 5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/kernel/bpf/preload/Makefile b/kernel/bpf/preload/Makefile
>> index 23ee310b6eb4..11b9896424c0 100644
>> --- a/kernel/bpf/preload/Makefile
>> +++ b/kernel/bpf/preload/Makefile
>> @@ -4,8 +4,11 @@ LIBBPF_SRCS = $(srctree)/tools/lib/bpf/
>>  LIBBPF_A = $(obj)/libbpf.a
>>  LIBBPF_OUT = $(abspath $(obj))
>>
>> +# Set $(O) so that the "dummy" test in tools/scripts/Makefile.include, called
>> +# by libbpf's Makefile, succeeds when building the kernel with $(O) pointing to
>> +# a relative path, as in "make O=build bindeb-pkg".
>>  $(LIBBPF_A):
>> -       $(Q)$(MAKE) -C $(LIBBPF_SRCS) OUTPUT=$(LIBBPF_OUT)/ $(LIBBPF_OUT)/libbpf.a
>> +       $(Q)$(MAKE) -C $(LIBBPF_SRCS) O=$(abspath .) OUTPUT=$(LIBBPF_OUT)/ $(LIBBPF_OUT)/libbpf.a
> 
> why not O=$(LIBBPF_OUT), btw?

$(LIBBPF_OUT) points to /.../linux/ZZ_BUILD/build/kernel/bpf/preload.
This is an absolute path so the "dummy" check should work, too. I
preferred to align the value on the root Makefile, which has
"O=$(abspath $(objtree))" for target "tools/%", but no strong opinion
here. David would simply empty the variable in his patch. I'm fine with
any of the three versions. Would you prefer me to resend with $(LIBBPF_OUT)?

Thanks,
Quentin
