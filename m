Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF2A63A0AD2
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 05:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236559AbhFIDqC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 23:46:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39019 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233525AbhFIDqB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 23:46:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623210247;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OGeHcfpGB2J4iosdVTMmZq2wvP1+el8Py0z0pfMwv04=;
        b=Oreaby8I78h8ZhEBbjAWYipvqg7dW3bVB2YuEHf52uH3hnL4VaXv5Drn1hw4FUeCQRupBW
        5pREtXSqx8AtnzwU8iImHawWUVSJEXO9UDQPsmUZpK+T6ybVC1xMaCSYHcVXN08arFeiCX
        YOHYAlChsf+tb2HA9l8KelKAuZdF4L0=
Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com
 [209.85.161.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-7-2hdIVjdrP2-LPq8qrrdWYg-1; Tue, 08 Jun 2021 23:44:06 -0400
X-MC-Unique: 2hdIVjdrP2-LPq8qrrdWYg-1
Received: by mail-oo1-f72.google.com with SMTP id r4-20020a4ab5040000b02902446eb55473so14595188ooo.20
        for <netdev@vger.kernel.org>; Tue, 08 Jun 2021 20:44:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OGeHcfpGB2J4iosdVTMmZq2wvP1+el8Py0z0pfMwv04=;
        b=gPfXvs6CLeCgqbFFkJyxk40vBmn6x/Rk+GZKS3E8av9u+FqjUpaH8y47IKon2Yoict
         RmX3t7/WmyYzC7h0eGtWZm0Qj670C7vjwn6CC2hwZt5S59XYTGTrff0q1I29i8Ooy2Ry
         tz8q10GTh69cBRWcmkfw0gnHiHu/d6li7yOqShz2UI68bGyRb9ntoUh0Jnhvt0GyqRJq
         DXqaZnEFLejXTHf5lG6tcU1XdojUo7wS+XjHX/7vE9gImGGl+XfVKmY8wR3hGR1N2e/Z
         ijxTpNWIwpGNev7U29dNy8P/F7Z7QDI87R10198Pb2SCY6WfJNBTH3ERTrx4DItI532C
         pMBg==
X-Gm-Message-State: AOAM531KfJBql5CQqMMcLs/cMCjt/JKK0z7FGUtNU9OtI85tA515SOBO
        JsnyyEGjf6zVYxx06//4JKOEMOB+oMgEKBpAiR/PdIcRnzPgsqJ7z1Y5V5ciMjcdX/PowzIWsZL
        8c/e6+n8/9iG5dl2aTAAMYVLWEBoQTjx3txGDE6H+tu458o/7sd7gEbdwPB2d0ZUh2tFI
X-Received: by 2002:aca:914:: with SMTP id 20mr5020389oij.127.1623210244858;
        Tue, 08 Jun 2021 20:44:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxiOhrEMyVtgLQBo67EDf2/4stemIf+VMSzBVFmnpTYPhQHv8SfxhuFyAnQ6mfPW5gU1WLg4w==
X-Received: by 2002:aca:914:: with SMTP id 20mr5020367oij.127.1623210244569;
        Tue, 08 Jun 2021 20:44:04 -0700 (PDT)
Received: from tstellar.remote.csb (97-120-191-69.ptld.qwest.net. [97.120.191.69])
        by smtp.gmail.com with ESMTPSA id v22sm3203492oic.37.2021.06.08.20.44.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Jun 2021 20:44:04 -0700 (PDT)
Subject: Re: [PATCH v2 bpf-next 06/11] libbpf: add BPF static linker APIs
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@fb.com>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
References: <20210313193537.1548766-7-andrii@kernel.org>
 <20210607231146.1077-1-tstellar@redhat.com>
 <CAEf4Bzad7OQj9JS7GVmBjAXyxKcc-nd77gxPQfFB8_hy_Xo+_g@mail.gmail.com>
 <b1bdf1df-e3a8-1ce8-fc33-4ab40b39fb06@redhat.com>
 <84b3cb2c-2dff-4cd8-724c-a1b56316816b@redhat.com>
 <CAEf4BzbCiMkQazSe2hky=Jx6QXZiZ2jyf+AuzMJEyAv+_B7vug@mail.gmail.com>
From:   Tom Stellard <tstellar@redhat.com>
Message-ID: <b322da84-95f3-2800-f2c8-556e9855d517@redhat.com>
Date:   Tue, 8 Jun 2021 20:44:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <CAEf4BzbCiMkQazSe2hky=Jx6QXZiZ2jyf+AuzMJEyAv+_B7vug@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/7/21 9:08 PM, Andrii Nakryiko wrote:
> On Mon, Jun 7, 2021 at 7:41 PM Tom Stellard <tstellar@redhat.com> wrote:
>>
>> On 6/7/21 5:25 PM, Andrii Nakryiko wrote:
>>> On Mon, Jun 7, 2021 at 4:12 PM Tom Stellard <tstellar@redhat.com> wrote:
>>>>
>>>>
>>>> Hi,
>>>>
>>>>> +                               } else {
>>>>> +                                       pr_warn("relocation against STT_SECTION in non-exec section is not supported!\n");
>>>>> +                                       return -EINVAL;
>>>>> +                               }
>>>>
>>>> Kernel build of commit 324c92e5e0ee are failing for me with this error
>>>> message:
>>>>
>>>> /builddir/build/BUILD/kernel-5.13-rc4-61-g324c92e5e0ee/linux-5.13.0-0.rc4.20210603git324c92e5e0ee.35.fc35.x86_64/tools/bpf/bpftool/bpftool gen object /builddir/build/BUILD/kernel-5.13-rc4-61-g324c92e5e0ee/linux-5.13.0-0.rc4.20210603git324c92e5e0ee.35.fc35.x86_64/tools/testing/selftests/bpf/bind_perm.linked1.o /builddir/build/BUILD/kernel-5.13-rc4-61-g324c92e5e0ee/linux-5.13.0-0.rc4.20210603git324c92e5e0ee.35.fc35.x86_64/tools/testing/selftests/bpf/bind_perm.o
>>>> libbpf: relocation against STT_SECTION in non-exec section is not supported!
>>>>
>>>> What information can I provide to help debug this failure?
>>>
>>> Can you please send that bind_perm.o file? Also what's your `clang
>>> --version` output?
>>>
>>
>> clang version 12.0.0 (Fedora 12.0.0-2.fc35)
>>
>>>> I suspect this might be due to Clang commit 6a2ea84600ba ("BPF: Add
>>>> more relocation kinds"), but I get a different error on 324c92e5e0ee.
>>>> So meanwhile you might try applying 9f0c317f6aa1 ("libbpf: Add support
>>>> for new llvm bpf relocations") from bpf-next/master and check if that
>>>> helps. But please do share bind_perm.o, just to double-check what's
>>>> going on.
>>>>
>>
>> Here is bind_perm.o: https://fedorapeople.org/~tstellar/bind_perm.o
>>
> 
> So somehow you end up with .eh_frame section in BPF object file, which
> shouldn't ever happen. So there must be something that you are doing
> differently (compiler flags or something else) that makes Clang
> produce .eh_frame. So we need to figure out why .eh_frame gets
> generated. Not sure how, but maybe you have some ideas of what might
> be different about your build.
> 

Thanks for the pointer.  The problem was that in the Fedora kernel builds,
we enable -funwind-tables by default on all architectures, which is why the
.eh_frame section was there.  I fixed our clang builds, but I'm now getting
a new error when I run: CC=clang make -C tools/testing/selftests/bpf  V=1


/builddir/build/BUILD/kernel-5.13-rc4-61-g324c92e5e0ee/linux-5.13.0-0.rc4.20210603git324c92e5e0ee.35.fc35.x86_64/tools/testing/selftests/bpf/tools/sbin/bpftool gen skeleton /builddir/build/BUILD/kernel-5.13-rc4-61-g324c92e5e0ee/linux-5.13.0-0.rc4.20210603git324c92e5e0ee.35.fc35.x86_64/tools/testing/selftests/bpf/bpf_cubic.linked3.o name bpf_cubic > /builddir/build/BUILD/kernel-5.13-rc4-61-g324c92e5e0ee/linux-5.13.0-0.rc4.20210603git324c92e5e0ee.35.fc35.x86_64/tools/testing/selftests/bpf/bpf_cubic.skel.h
libbpf: failed to find BTF for extern 'tcp_cong_avoid_ai' [27] section: -2

Here is the bpf_cubic.lined3.o object file: https://fedorapeople.org/~tstellar/bpf_cubic.linked3.o

-Tom



>> Thanks,
>> Tom
>>
>>>>
>>>>>
>>>>> Thanks,
>>>>> Tom
>>>>>
>>>>
>>>
>>
> 

