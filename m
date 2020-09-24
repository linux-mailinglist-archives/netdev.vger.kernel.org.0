Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFE78277B05
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 23:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgIXVYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 17:24:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56422 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726239AbgIXVYs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 17:24:48 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600982686;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/24kjoQ/Bjx4xRwwYbCaHv77a28OhUHxxuJfybtFHzo=;
        b=BNMWfS1uiGGiqR+9t9qvbloUUGetInSxDLsRWlY+umw92sWWS84vXbCZNug0OHwh1nmnkz
        gnKH5pbHYah0zL+CHFRI61ApU5xUxU/S7v3BEGjYbRbJkx8Xp1O4SDF7yHRTuoCWY4MWCk
        oyEFt/YKPvyBajxFtn+hirAqYe5cBZw=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-126-1Dmz-8B6MI-lIKN5HoDReA-1; Thu, 24 Sep 2020 17:24:43 -0400
X-MC-Unique: 1Dmz-8B6MI-lIKN5HoDReA-1
Received: by mail-pg1-f199.google.com with SMTP id n24so519524pgl.3
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 14:24:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=/24kjoQ/Bjx4xRwwYbCaHv77a28OhUHxxuJfybtFHzo=;
        b=OKPBqw8PlUN7arKtMEkQ0PYE/ZPS4hUrSFG6H7LsV2tZxQOn09c/z+ZHlRTnE7XHiV
         mGue1Ncfo9oCcUS+8QQLhgQw41K36FozOzilnuu/wc13DBLdEWeJnM2i+ae7QWBO3Kik
         o3TKj4RVRQ58kev/EKFoUHTiN98tps2hICHbWNfABzO4iI9wsBHa6qI7OBRr3R8yq2pC
         fOqrtfuPMTywaxYnhzUrPNMSR4icEy7tBdbbvSR7mt3HbiZsUXmzuP8vyDWuEJk72quC
         kZDJJQhJxoeiSOoJbjlB0p0r/2h+E7nz9xZ+BVq9jLDG+QFx4QWS6cSWqxu+9huCX/ek
         YCsQ==
X-Gm-Message-State: AOAM531jbbPUnpMtrm6q2Y/W2fEAUjyDtRbPR+uJzH/9y4Nr7R/JBL/5
        EwspFNfN/Aq/x3fK+UDS++DHYbQuKzchpIhxy2T/r+2lDVDaoDbCJT8EO/68019zzzwaAYmfa7b
        oRxLd91FdH7/B4PTr
X-Received: by 2002:a62:3547:0:b029:142:2501:35d4 with SMTP id c68-20020a6235470000b0290142250135d4mr984636pfa.52.1600982682354;
        Thu, 24 Sep 2020 14:24:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw34M63oCQrylVcA36C+3yOWw4i+mf8TdGkoGu7DYjwCeD70FD1KoJvBhFS6J86py6KDv4q2g==
X-Received: by 2002:a62:3547:0:b029:142:2501:35d4 with SMTP id c68-20020a6235470000b0290142250135d4mr984614pfa.52.1600982681981;
        Thu, 24 Sep 2020 14:24:41 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id 134sm389036pfa.93.2020.09.24.14.24.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2020 14:24:40 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 04038183A90; Thu, 24 Sep 2020 23:24:35 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v8 04/11] bpf: move prog->aux->linked_prog and
 trampoline into bpf_link on attach
In-Reply-To: <CAEf4BzaBvvZdgekg13T3e4uj5Q9Rf1RTFP__ZPsU-NMp2fVXxw@mail.gmail.com>
References: <160079991372.8301.10648588027560707258.stgit@toke.dk>
 <160079991808.8301.6462172487971110332.stgit@toke.dk>
 <20200924001439.qitbu5tmzz55ck4z@ast-mbp.dhcp.thefacebook.com>
 <874knn1bw4.fsf@toke.dk>
 <CAEf4BzaBvvZdgekg13T3e4uj5Q9Rf1RTFP__ZPsU-NMp2fVXxw@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 24 Sep 2020 23:24:35 +0200
Message-ID: <87zh5ec1gs.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Thu, Sep 24, 2020 at 7:36 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>>
>> > On Tue, Sep 22, 2020 at 08:38:38PM +0200, Toke H=C3=83=C6=92=C3=82=C2=
=B8iland-J=C3=83=C6=92=C3=82=C2=B8rgensen wrote:
>> >> @@ -746,7 +748,9 @@ struct bpf_prog_aux {
>> >>      u32 max_rdonly_access;
>> >>      u32 max_rdwr_access;
>> >>      const struct bpf_ctx_arg_aux *ctx_arg_info;
>> >> -    struct bpf_prog *linked_prog;
>> >
>> > This change breaks bpf_preload and selftests test_bpffs.
>> > There is really no excuse not to run the selftests.
>>
>> I did run the tests, and saw no more breakages after applying my patches
>> than before. Which didn't catch this, because this is the current state
>> of bpf-next selftests:
>>
>> # ./test_progs  | grep FAIL
>> test_lookup_update:FAIL:map1_leak inner_map1 leaked!
>> #10/1 lookup_update:FAIL
>> #10 btf_map_in_map:FAIL
>
> this failure suggests you are not running the latest kernel, btw

I did see that discussion (about the reverted patch), and figured that
was the case. So I did a 'git pull' just before testing, and still got
this.

$ git describe HEAD
v5.9-rc3-2681-g182bf3f3ddb6

so any other ideas? :)

>> configure_stack:FAIL:BPF load failed; run with -vv for more info
>> #72 sk_assign:FAIL

(and what about this one, now that I'm asking?)

>> test_test_bpffs:FAIL:bpffs test  failed 255
>> #96 test_bpffs:FAIL
>> Summary: 113/844 PASSED, 14 SKIPPED, 4 FAILED
>>
>> The test_bpffs failure happens because the umh is missing from the
>> .config; and when I tried to fix this I ended up with:
>
> yeah, seems like selftests/bpf/config needs to be updated to mention
> UMH-related config values:
>
> CONFIG_BPF_PRELOAD=3Dy
> CONFIG_BPF_PRELOAD_UMD=3Dm|y
>
> with that test_bpffs shouldn't fail on master

Yup, did get that far, and got the below...

>>
>> [..]
>>   CC [M]  kernel/bpf/preload/bpf_preload_kern.o
>>
>> Auto-detecting system features:
>> ...                        libelf: [ OFF ]
>> ...                          zlib: [ OFF ]
>> ...                           bpf: [ OFF ]
>>
>> No libelf found
>
> might be worthwhile to look into why detection fails, might be
> something with Makefiles or your environment

I think it's actually another instance of the bug I fixed with this
commit:

1eb832ac2dee ("tools/bpf: build: Make sure resolve_btfids cleans up after i=
tself")

which I finally remembered after being tickled by the error message
seeming familiar. And indeed, manually removing the 'feature' directory
in kernel/bpf/preload seems to fix the issue, so I'm planning to go fix
that Makefile as well...

>> ...which I just put down to random breakage, turned off the umh and
>> continued on my way (ignoring the failed test). Until you wrote this I
>> did not suspect this would be something I needed to pay attention to.
>> Now that you did mention it, I'll obviously go investigate some more, my
>> point is just that in this instance it's not accurate to assume I just
>> didn't run the tests... :)
>
> Don't just assume some tests are always broken. Either ask or
> investigate on your own. Such cases do happen from time to time while
> we wait for a fix in bpf to get merged into bpf-next or vice versa,
> but it's rare. We now have two different CI systems running selftests
> all the time, in addition to running them locally as well, so any
> permanent test failure is very apparent and annoying, so we fix them
> quickly. So, when in doubt - ask or fix.

That's good to know; and I do think the situation has improved
immensely. There was a time when the selftests broke every other week
(or so it felt, at least), and I guess I'm still a bit scarred from
that.

One thing that would be really useful would be to have a 'reference
config' or something like that. Missing config options are a common
reason for test failures (as we have just seen above), and it's not
always obvious which option is missing for each test. Even something
like grepping .config for BPF doesn't catch everything. If you already
have a CI running, just pointing to that config would be a good start
(especially if it has history). In an ideal world I think it would be
great if each test could detect whether the kernel has the right config
set for its features and abort with a clear error message if it isn't...

>> > I think I will just start marking patches as changes-requested when I =
see that
>> > they break tests without replying and without reviewing.
>> > Please respect reviewer's time.
>>
>> That is completely fine if the tests are working in the first place. And
>
> They are and hopefully moving forward that would be your assumption.

Sure, with the exception of the two tests still failing that I mentioned
above. Which I'm hoping you can help figure out the reason for :)

-Toke

