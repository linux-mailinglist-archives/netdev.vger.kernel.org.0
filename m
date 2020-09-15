Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBBE926A43F
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 13:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726137AbgIOLhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 07:37:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31859 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726189AbgIOLff (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 07:35:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600169734;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3rr8VaiyxE099qjL7tO/ARj7fFPfUXxauef1g0727VU=;
        b=B3yvO8bdk9CThlrSWekKtHuiY4I9D0hFEqjflSztXNjnIR6PkSpv2PJqJLRy537rhy1BMn
        mzAzePY6nfKtC4+ubQPQDbsHTDpJ++hnXk/9iLGLN1vxmgNJ+j3CbzNSQ/Fxv/AiVDejTw
        msKHCNtl71vAsFJul4iS3EmGaR3QWlA=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-504-gfQsaZRJO5adz4KXcpsjCg-1; Tue, 15 Sep 2020 07:35:32 -0400
X-MC-Unique: gfQsaZRJO5adz4KXcpsjCg-1
Received: by mail-wr1-f69.google.com with SMTP id d9so1108578wrv.16
        for <netdev@vger.kernel.org>; Tue, 15 Sep 2020 04:35:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=3rr8VaiyxE099qjL7tO/ARj7fFPfUXxauef1g0727VU=;
        b=S7NI8+vwRHX6tIFycU0QCcZP2/NyciacacSnk+ZI6TsmHzEW4it4dpOObR8I9lu+Db
         5bB6dhfdLsPQu99ttUNBgtRhv7sWd6Sll2Y3sjO5+s+lZJZy66M45rNDRKDuytE2b3M8
         TF7iuIQLwc0CtX89gIpxT5LYz1/pmIep6Ng8BHa/7SW+owbEuYFryujbxn/XuFsFfm26
         LwfwlFYPxn4AVkvQazi4Zar99aOn6BhVcF5rnqERhsHktDA4PjErzF3B9eySYmcH4rxk
         bqpCX24VTDahKt2VzpoFK4hQbQyVCSCILdtT01pFPpCYpapce29K02l0la2+W4zIrdA5
         HP/g==
X-Gm-Message-State: AOAM532XcuiEuOwP1tjzLJkf6rOZCclbv4e2nX9Wrmcu7mzOLbdG5nZ4
        aQAjbpEb5m2kc7adq8oYJIK1zqg8UfZ4blv6dp+2M7kob+GVEso/sJcy/uhEXW50HW/exU5XFuu
        wpA02Lpyj/fOmRvxP
X-Received: by 2002:adf:9b8b:: with SMTP id d11mr13493130wrc.71.1600169730552;
        Tue, 15 Sep 2020 04:35:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxrxnZV0v/APUuWUQyglUlEpBpUNY4U1W+sX6RLU4556c09WO8YcebevS2Oiya7fGleP6KdmQ==
X-Received: by 2002:adf:9b8b:: with SMTP id d11mr13493094wrc.71.1600169730164;
        Tue, 15 Sep 2020 04:35:30 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id t6sm29252973wre.30.2020.09.15.04.35.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2020 04:35:29 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 74C711829CB; Tue, 15 Sep 2020 13:35:28 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH RESEND bpf-next v3 4/9] bpf: support attaching freplace
 programs to multiple attach points
In-Reply-To: <CAEf4Bzb9Xw65jL1UxVjOz5HdwgMckEkFHWrYdEPbnj01a7X1hQ@mail.gmail.com>
References: <159981835466.134722.8652987144251743467.stgit@toke.dk>
 <159981835908.134722.4550898174324943652.stgit@toke.dk>
 <CAEf4BzZMj0sPisgUZ+3qKvqaAxfzzRNHZTpoR-zuDXvKcY3URQ@mail.gmail.com>
 <87imcgz6gk.fsf@toke.dk>
 <CAEf4Bzb9Xw65jL1UxVjOz5HdwgMckEkFHWrYdEPbnj01a7X1hQ@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 15 Sep 2020 13:35:28 +0200
Message-ID: <87zh5rxofz.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Mon, Sep 14, 2020 at 9:08 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>>
>> > On Fri, Sep 11, 2020 at 3:01 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke=
@redhat.com> wrote:
>> >>
>> >> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> >>
>> >> This enables support for attaching freplace programs to multiple atta=
ch
>> >> points. It does this by amending UAPI for bpf_raw_tracepoint_open wit=
h a
>> >> target prog fd and btf ID pair that can be used to supply the new
>> >> attachment point. The target must be compatible with the target that =
was
>> >> supplied at program load time.
>> >>
>> >> The implementation reuses the checks that were factored out of
>> >> check_attach_btf_id() to ensure compatibility between the BTF types o=
f the
>> >> old and new attachment. If these match, a new bpf_tracing_link will be
>> >> created for the new attach target, allowing multiple attachments to
>> >> co-exist simultaneously.
>> >>
>> >> The code could theoretically support multiple-attach of other types of
>> >> tracing programs as well, but since I don't have a use case for any of
>> >> those, the bpf_tracing_prog_attach() function will reject new targets=
 for
>> >> anything other than PROG_TYPE_EXT programs.
>> >>
>> >> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> >> ---
>> >
>> > It feels like using a semi-constructed bpf_tracing_link inside
>> > prog->aux->tgt_link is just an unnecessary complication, after reading
>> > this and previous patches. Seems more straightforward and simpler to
>> > store tgt_attach_type/tgt_prog_type (permanently) and
>> > tgt_prog/tgt_trampoline (until first attachment) in prog->aux and then
>> > properly create bpf_link on attach.
>>
>> I updated v4 with your comments, but kept the link in prog->aux; the
>> reason being that having a container for the two pointers makes it
>> possible to atomically swap it out with xchg() as you suggested
>> previously. Could you please take a look at v4? If you still think it's
>> better to just keep two separate pointers (and add a lock) in prog->aux,
>> I can change it to that. But I'd rather avoid the lock if possible...
>
> I took a very quick look at this specific bit, planning to do another
> pass tomorrow.
>
> What's the problem with adding a mutex to bpf_prog_aux? In your case,
> now you introduced (unlikely, but still) extra state transition for
> tgt_link from non-NULL to NULL and then back to non-NULL? And why?
> Just to use atomic xchg, while using atomic operation is not an
> absolute necessity because it's not a performance-critical path at
> all. We are not optimizing for millions of freplace attachments a
> second, right? On the other hand, having a mutex there won't require
> restoration logic, it will be dead simple, obvious and
> straightforward. So yeah, I still think mutex is better there.

So I went ahead and implemented a mutex-based version of this. I'm not
sure I agree with "dead simple", I'd say it's on par with the previous
version; and that is only if I explicitly limit the scope of the mutex
to *writing* of the tgt_* pointers (i.e., I haven't gone through and
protected all the reads from within the verifier).

The mutex version does have the benefit of still making it possible to
retry a bpf_raw_tracepoint_open() if it fails, so I guess that is a
benefit; I'll post it as v5 and you can have a look :)

> BTW, check Stanislav's latest patch set. He's adding used_maps_mutex
> to bpf_prog_aux with no problems at all. It seems to me that we might
> want to generalize that used_maps_mutex to be just bpf_prog_aux's
> mutex ('prog_aux_mutex' or whatever we'd call it) and use it for such
> kinds of low-frequency bpf_prog metadata manipulations/checks.

I'm not sure I like the idea of widening the scope of the mutex. Or at
least I think that should be done as a follow-up patch that does a
proper analysis of all the different fields it is supposed to protect
and makes sure no deadlocks creep in.

-Toke

