Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8654250F3
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 12:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240854AbhJGK0g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 06:26:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27879 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231825AbhJGK0f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 06:26:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633602281;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cMFfQ+9xEITse5BXUPzTbnpXm5D1/LuZG5EcUfPPLos=;
        b=IU9PAePXvw6qhAD5woYy/SuSAJ4/BnkcATKMGefo575OH3xQr/M1duWji2MRwBANwFb0YH
        pfrF7UvblAag/47Wxczopug4ZHJxOAGzkPk2C6Kvt5KPZD/XF0aTG++el3v+OawMijAwAD
        IYxUY0noiid6tjiLQQWG0hybg8R3AAA=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-536-9Ft6jELFOWG_cRNJrWdmJw-1; Thu, 07 Oct 2021 06:24:40 -0400
X-MC-Unique: 9Ft6jELFOWG_cRNJrWdmJw-1
Received: by mail-ed1-f72.google.com with SMTP id v2-20020a50f082000000b003db24e28d59so5463646edl.5
        for <netdev@vger.kernel.org>; Thu, 07 Oct 2021 03:24:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=cMFfQ+9xEITse5BXUPzTbnpXm5D1/LuZG5EcUfPPLos=;
        b=KGhYO2hdEHE+57dtBpQzcX0K1fpMJmqz0am3/maXynxAvFSEHJHrJqBMHO0jbzsaF+
         h9mRqAF5Bik2hce1mz6QICJvhmV+13EN1lT07/AcnaPZJXwOACOr32x8y3WqPpdfb2gz
         gI/+58J5ENQV7JoyzbFXq7lxm8hZK/LKoMyWgsGFxWQvl6oNSrqmTTKwgIygFv7C5cMe
         06JlKigIqPWs0PiHHbZ3k0LXhP09JIugg42LioZpHTicSV3z09skFL7wGDuKT73wPWFq
         +TAs5jKeWQE+Yt3/FReSOla1IuVoslgiWfKRvk+WK5W81qGTmRFymcRqKV+mKeHMjA85
         W1Mw==
X-Gm-Message-State: AOAM531ZXvjGBQMactbGaI7ce+i2fEPGzu/oA1SWuDegPxmhbnq8LWth
        34YG8y4D0nNOiEjhPvGdjyQzPCmsZBCn3I9iDNF1F7+c/AQxh041fAMNgvWlUAhYRHwxqqbgKIh
        QSJPqx/dHOF5WXknQ
X-Received: by 2002:a17:906:54c3:: with SMTP id c3mr4460392ejp.536.1633602278646;
        Thu, 07 Oct 2021 03:24:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxkbA2FeQaFcxjqObXvvP7gBIwnFE5jJRNgLpng1YYbCu8Mq8vjaimH9CLlnZecWGFJ5pxgew==
X-Received: by 2002:a17:906:54c3:: with SMTP id c3mr4460127ejp.536.1633602275797;
        Thu, 07 Oct 2021 03:24:35 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id bw25sm10033669ejb.20.2021.10.07.03.24.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 03:24:35 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 7F478180151; Thu,  7 Oct 2021 12:24:34 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v1 3/6] libbpf: Ensure that module BTF fd is
 never 0
In-Reply-To: <CAEf4Bza186k8BeRG8XrUGaUb4_6hf0dCB4a1A5czcS69aBMffw@mail.gmail.com>
References: <20211006002853.308945-1-memxor@gmail.com>
 <20211006002853.308945-4-memxor@gmail.com>
 <CAEf4BzZCK5L-yZHL=yhGir71t=kkhAn5yN07Vxs2+VizvwF3QQ@mail.gmail.com>
 <20211006052455.st3f7m3q5fb27bs7@apollo.localdomain>
 <CAEf4Bzai=3GK5L-tkZRTT_h8SYPFjike-LTS8GXK17Z1YFAQtw@mail.gmail.com>
 <CAADnVQKVKY8o_3aU8Gzke443+uHa-eGoM0h7W4srChMXU1S4Bg@mail.gmail.com>
 <CAEf4Bza186k8BeRG8XrUGaUb4_6hf0dCB4a1A5czcS69aBMffw@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 07 Oct 2021 12:24:34 +0200
Message-ID: <87zgrlm8t9.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Wed, Oct 6, 2021 at 12:09 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
>>
>> On Wed, Oct 6, 2021 at 9:43 AM Andrii Nakryiko
>> <andrii.nakryiko@gmail.com> wrote:
>> >
>> > On Tue, Oct 5, 2021 at 10:24 PM Kumar Kartikeya Dwivedi
>> > <memxor@gmail.com> wrote:
>> > >
>> > > On Wed, Oct 06, 2021 at 10:11:29AM IST, Andrii Nakryiko wrote:
>> > > > On Tue, Oct 5, 2021 at 5:29 PM Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
>> > > > >
>> > > > > Since the code assumes in various places that BTF fd for modules is
>> > > > > never 0, if we end up getting fd as 0, obtain a new fd > 0. Even though
>> > > > > fd 0 being free for allocation is usually an application error, it is
>> > > > > still possible that we end up getting fd 0 if the application explicitly
>> > > > > closes its stdin. Deal with this by getting a new fd using dup and
>> > > > > closing fd 0.
>> > > > >
>> > > > > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
>> > > > > ---
>> > > > >  tools/lib/bpf/libbpf.c | 14 ++++++++++++++
>> > > > >  1 file changed, 14 insertions(+)
>> > > > >
>> > > > > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
>> > > > > index d286dec73b5f..3e5e460fe63e 100644
>> > > > > --- a/tools/lib/bpf/libbpf.c
>> > > > > +++ b/tools/lib/bpf/libbpf.c
>> > > > > @@ -4975,6 +4975,20 @@ static int load_module_btfs(struct bpf_object *obj)
>> > > > >                         pr_warn("failed to get BTF object #%d FD: %d\n", id, err);
>> > > > >                         return err;
>> > > > >                 }
>> > > > > +               /* Make sure module BTF fd is never 0, as kernel depends on it
>> > > > > +                * being > 0 to distinguish between vmlinux and module BTFs,
>> > > > > +                * e.g. for BPF_PSEUDO_BTF_ID ld_imm64 insns (ksyms).
>> > > > > +                */
>> > > > > +               if (!fd) {
>> > > > > +                       fd = dup(0);
>> > > >
>> > > > This is not the only place where we make assumptions that fd > 0 but
>> > > > technically can get fd == 0. Instead of doing such a check in every
>> > > > such place, would it be possible to open (cheaply) some FD (/dev/null
>> > > > or whatever, don't know what's the best file to open), if we detect
>> > > > that FD == 0 is not allocated? Can we detect that fd 0 is not
>> > > > allocated?
>> > > >
>> > >
>> > > We can, e.g. using access("/proc/self/fd/0", F_OK), but I think just calling
>> > > open unconditonally and doing if (ret > 0) close(ret) is better. Also, do I
>> >
>> > yeah, I like this idea, let's go with it
>>
>> FYI some production environments may detect that FDs 0,1,2 are not
>> pointing to stdin, stdout, stderr and will force close whatever files are there
>> and open 0,1,2 with canonical files.
>>
>> libbpf doesn't have to resort to such measures, but it would be prudent to
>> make libbpf operate on FDs > 2 for all bpf objects to make sure other
>> frameworks don't ruin libbpf's view of FDs.
>
> oh well, even without those production complications this would be a
> bit fragile, e.g., if the application temporarily opened FD 0 and then
> closed it.
>
> Ok, Kumar, can you please do it as a simple helper that would
> dup()'ing until we have FD>2, and use it in as few places as possible
> to make sure that all FDs (not just module BTF) are covered. I'd
> suggest doing that only in low-level helpers in btf.c, I think
> libbpf's logic always goes through those anyways (but please
> double-check that we don't call bpf syscall directly anywhere else).

FYI, you can use fcntl() with F_DUPFD{,_CLOEXEC} and tell it the minimum
fd number you're interested in for the clone. We do that in libxdp to
protect against fd 0:

https://github.com/xdp-project/xdp-tools/blob/master/lib/libxdp/libxdp.c#L1184

Given Alexei's comments above, maybe we should be '3' for the last arg
instead of 1...

-Toke

