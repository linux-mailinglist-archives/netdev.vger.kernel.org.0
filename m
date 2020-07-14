Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8960220086
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 00:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727839AbgGNWTM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 18:19:12 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:22679 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726361AbgGNWTL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 18:19:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594765149;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2rNzl7aXLrSt0VzMlcxXnUwSx+t1sTldacGTkBqjCFo=;
        b=bOtOHC4fqM78OjLeTrYbAm/GE1L4X1mP6NhHSSUZibvvopfTSNvGdlDH+YEkCgBwxHmYjR
        DYegQ3iP6Sk5t+mJBssFCCoKVvdvA9AN8gQzmUFfdXjcYyxpECGb9hGQE6tDeheEx5ogWN
        OGnEq47T/hUVqFL0IihIvjrPjIn4pK0=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-175-pb2T1QmpMeG-N-cdVMX49Q-1; Tue, 14 Jul 2020 18:19:07 -0400
X-MC-Unique: pb2T1QmpMeG-N-cdVMX49Q-1
Received: by mail-qv1-f70.google.com with SMTP id m8so98435qvv.10
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 15:19:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=2rNzl7aXLrSt0VzMlcxXnUwSx+t1sTldacGTkBqjCFo=;
        b=eY6gyjjISXEDwoJzWvKPApxXo7bqoVewQVIDBQ2/PuZ6Tcl85glSANZWhc4OcJjvei
         N1VOLHsDABT//g0fPPWuUb4IScCSBfCrFkZQs0KpTz5MJwE06cf1lF5uL1Ul90phprgG
         DpNxrloazgYjt0W2TMNyBLFVsPqvZPAjVjMJhVoL/3U3AnXCeqQCO3kqI1IpPCL0hdbY
         3vokA9RkN7Eda90ubsLM184Y1SdfoKgQ4DKyxfrM3Shh0gUyZpLGI9mvpNM/1LKpVkoJ
         D7QIhGFRvXO89lGdFStumqRmR69ahKRECMFRl9LvhORTeu1ko2jIvnwestJhag1z/GjU
         PTkw==
X-Gm-Message-State: AOAM533D7bH4+IKeGSQ6dhrUd6Rh+HcYgca4a2pOPh4JMpldIUZv2g/z
        3Q0Tunm3bwOUCt0ysgXe2/7ObCqYasuR0x3Ev0q6jTq81QEMvcemH1UbjJ0jJ36v5jU0F6PydQU
        Z9VgsJx1UCDJ9g/N3
X-Received: by 2002:a0c:e048:: with SMTP id y8mr6899906qvk.11.1594765147419;
        Tue, 14 Jul 2020 15:19:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx1+5mdJCxaDjkUOskDBf5Bcn6VXEyPyYnHzVaFOH4ihmAxu0HWtMxTCN6W2Fo1tHdiMvFCag==
X-Received: by 2002:a0c:e048:: with SMTP id y8mr6899872qvk.11.1594765147108;
        Tue, 14 Jul 2020 15:19:07 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id t65sm79057qkf.119.2020.07.14.15.19.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 15:19:06 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B88E61804F0; Wed, 15 Jul 2020 00:19:03 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: BPF logging infrastructure. Was: [PATCH bpf-next 4/6] tools: add new members to bpf_attr.raw_tracepoint in bpf.h
In-Reply-To: <CAEf4BzYAoetyfyofTX45RQjtz3M-c9=YNeH1uRDbYgK4Ae0TwA@mail.gmail.com>
References: <159467113970.370286.17656404860101110795.stgit@toke.dk> <159467114405.370286.1690821122507970067.stgit@toke.dk> <CAEf4BzZ_-vXP_3hSEjuceW10VX_H+EeuXMiV=_meBPZn7izK8A@mail.gmail.com> <87r1tegusj.fsf@toke.dk> <CAEf4Bzbu1wnwWFOWYA3e6KFeSmfg8oANPWD9LsUMRy2E_zrQ0w@mail.gmail.com> <87pn8xg6x7.fsf@toke.dk> <CAEf4BzYAoetyfyofTX45RQjtz3M-c9=YNeH1uRDbYgK4Ae0TwA@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 15 Jul 2020 00:19:03 +0200
Message-ID: <87d04xg2p4.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

>> However, assuming it *is* possible, my larger point was that we
>> shouldn't add just a 'logging struct', but rather a 'common options
>> struct' which can be extended further as needed. And if it is *not*
>> possible to add new arguments to a syscall like you're proposing, my
>> suggestion above would be a different way to achieve basically the same
>> (at the cost of having to specify the maximum reserved space in advance).
>>
>
> yeah-yeah, I agree, it's less a "logging attr", more of "common attr
> across all commands".

Right, great. I think we are broadly in agreement with where we want to
go with this, actually :)

Let's see if anyone else chimes in; otherwise I guess I can incorporate
something along these lines in the next version of this series. I'm
going on vacation at the end of this week, though, so I will most likely
not be able to carry it to completion before then; but at least I can
post something for someone else to pick up (or if no one does it can
wait until I get back).

[...]

> Yeah, ignore my initial rambling. One can do that (detecting
> truncationg) without any extra "feedback" from bpf syscall, but I
> think returning filled length is probably a better approach and
> doesn't hamper any other aspects.

OK, sure, makes sense.

[...]

>> > Also adopting these packet-like messages is not as straightforward
>> > through BPF code, as now you can't just construct a single log line
>> > with few calls to bpf_log().
>>
>> Why not? bpf_log() could just transparently write the four bytes of
>> header (TYPE_STRING, followed by strlen(msg)) into the buffer before the
>> string? And in the future, an enhanced version could take (say) an error
>> ID as another parameter and transparently add that as a separate message.
>
> I mean when you construct one error message with few printf-like
> functions. We do have that in libbpf, but I haven't checked the
> verifier code. Basically, assuming one bpf_log() call is a complete
> "message" might not be true.

Ah, I see what you mean. I guess that could be worked around with a flag
or something, but I'll concede that in that case it's less of an obvious
drop-in replacement :)

-Toke

