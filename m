Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 319363BD3C3
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 14:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239511AbhGFL7i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 07:59:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49394 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238407AbhGFLye (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 07:54:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625572315;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DiTI9c6T5l9HgqGMHwic7EfszJBjFE6dl2V5J6/ONnM=;
        b=ihnzg1nUtVOt9HXUGqx5EVFBwrImaYqSH97YNgOqGHcm3uMKU/ip5J8VrDT4HJKzxH2+vM
        DLh2k6uqzgmaDbWm/ebtxuxIll/BpkiSqSTGtkW/9dh56qRpVIHqdll+bOKPauAYFmg/1+
        TCKvXBqPm23aVzAzT5lfy4RQGM3zBng=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-148-VU5quT2uOd6q6lfNq_0hfw-1; Tue, 06 Jul 2021 07:51:54 -0400
X-MC-Unique: VU5quT2uOd6q6lfNq_0hfw-1
Received: by mail-ed1-f70.google.com with SMTP id w15-20020a05640234cfb02903951279f8f3so10681401edc.11
        for <netdev@vger.kernel.org>; Tue, 06 Jul 2021 04:51:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=DiTI9c6T5l9HgqGMHwic7EfszJBjFE6dl2V5J6/ONnM=;
        b=OoNxNu7kfB8XMIvZoUQN5QoBpEifhth3tzVhPiKqZ9BzgDU15kS56VdFZjZT234hYK
         PvCycD4iw1B4V4xECY4A0tmClR3cmRT04dRzafXjbnEwDKQjhiRHFGqfd0BcKOgxRWEc
         1dZDEbveip8jxOXrvCzAVf4ELA2BIKVVt+TuKFheefIt449+Oiqwn7hSovhmF5udyiC/
         K1jbp1JhBpC6AE90Yg5K8CK84r3s2rQ710t/qhC0LjKyBxvZj76eYTR87aZEyncY25Qp
         AlhU1YQUYTYMa/iUARiwvrWceQ2HJBWF1v8gxO8C2mDpO/NPEcJAeTPQkiWbF/4agRFm
         LhXg==
X-Gm-Message-State: AOAM531d8ONoVu4h1rx8z7WuRzXDlYeo4FKcks9w21hzSQzCGmBc1cO7
        PHLzk7EqQui9LuWdLltwCe6IEH4/qwAl6KV+uQacL03m/eTGWmuDDs3TTVMcwdVV8Ininm1DNO1
        gOSuWJYX4J/98bixR
X-Received: by 2002:a17:906:8149:: with SMTP id z9mr18060917ejw.547.1625572312750;
        Tue, 06 Jul 2021 04:51:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzu8opq+E4dS5G9On8xvZNBMIv3W9wkdoI9GmptYcaDf1n7hRZjWvUW4mUeKLoMlcB7wl/IOw==
X-Received: by 2002:a17:906:8149:: with SMTP id z9mr18060880ejw.547.1625572312336;
        Tue, 06 Jul 2021 04:51:52 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id d13sm7190658eds.56.2021.07.06.04.51.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jul 2021 04:51:51 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id C5D7518072E; Tue,  6 Jul 2021 13:51:50 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, yhs@fb.com
Subject: Re: [PATCH bpf-next] libbpf: ignore .eh_frame sections when parsing
 elf files
In-Reply-To: <e8385d06-ac0a-de99-de92-c91d5970b7e8@iogearbox.net>
References: <20210629110923.580029-1-toke@redhat.com>
 <ac14ef3c-ccd5-5f74-dda5-1d9366883813@iogearbox.net>
 <87czrxyrru.fsf@toke.dk>
 <e8385d06-ac0a-de99-de92-c91d5970b7e8@iogearbox.net>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 06 Jul 2021 13:51:50 +0200
Message-ID: <87k0m3y815.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Daniel Borkmann <daniel@iogearbox.net> writes:

> On 7/5/21 12:33 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Daniel Borkmann <daniel@iogearbox.net> writes:
>>> On 6/29/21 1:09 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>>> The .eh_frame and .rel.eh_frame sections will be present in BPF object
>>>> files when compiled using a multi-stage compile pipe like in samples/b=
pf.
>>>> This produces errors when loading such a file with libbpf. While the e=
rrors
>>>> are technically harmless, they look odd and confuse users. So add .eh_=
frame
>>>> sections to is_sec_name_dwarf() so they will also be ignored by libbpf
>>>> processing. This gets rid of output like this from samples/bpf:
>>>>
>>>> libbpf: elf: skipping unrecognized data section(32) .eh_frame
>>>> libbpf: elf: skipping relo section(33) .rel.eh_frame for section(32) .=
eh_frame
>>>>
>>>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>>>
>>> For the samples/bpf case, could we instead just add a -fno-asynchronous=
-unwind-tables
>>> to clang as cflags to avoid .eh_frame generation in the first place?
>>=20
>> Ah, great suggestion! Was trying, but failed, to figure out how to do
>> that. Just tested it, and yeah, that does fix samples; will send a
>> separate patch to add that.
>
> Sounds good, just applied.

Awesome, thanks!

>> I still think filtering this section name in libbpf is worthwhile,
>> though, as the error message is really just noise... WDYT?
>
> No strong opinion from my side, I can also see the argument that
> Andrii made some time ago [0] in that normally you should never see
> these in a BPF object file. But then ... there's BPF samples giving a
> wrong sample. ;( And I bet some users might have copied from there,
> and it's generally confusing from a user experience in libbpf on
> whether it's harmless or not.

Yeah, they "shouldn't" be there, but they clearly can be. So given that
it's pretty trivial to filter it, IMO, that would be the friendly thing
to do. Let's see what Andrii thinks.

> Side-question: Did you check if it is still necessary in general to
> have this multi-stage compile pipe in samples with the native clang
> frontend invocation (instead of bpf target one)? (Maybe it's time to
> get rid of it in general.)

I started looking into this, but chickened out of actually changing it.
The comment above the rule mentions LLVM 12, so it seems like it has
been updated fairly recently, specifically in:
9618bde489b2 ("samples/bpf: Change Makefile to cope with latest llvm")

OTOH, that change does seem to be a fix to the native-compilation mode;
so maybe it would be viable to just change it to straight bpf-target
clang compilation? Yonghong, any opinion?

> Anyway, would be nice to add further context/description about it to
> the commit message at least for future reference on what the .eh_frame
> sections contain exactly and why it's harmless. (Right now it only
> states that it is but without more concrete rationale, would be good
> to still add.)

Sure, can add that and send a v2 :)

-Toke

