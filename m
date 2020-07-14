Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EEE021F06C
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 14:12:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728766AbgGNMMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 08:12:25 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25100 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728769AbgGNMMV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 08:12:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594728739;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T/Uhd8kUIGVaFKfJlqqrQidFsSiRXLcUNXdQ5T/zyIQ=;
        b=B8mZRGUV6KzMfti0uxHILljcP/nwb4ML6w9gm5ObH258tZr9AgiLDcU5/nyvJkmBwYI8Ow
        6GolTYdJuotnRCobL0B1KSxg1zjv8FZwale88Pqx+DyoNM9BbgMPclQvg0uFLtUhAHOhsh
        Dgih2OJ3Xxfuv9qLbCgKm3PSF42FNWE=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-450-Xpwzwvh2M129YqVicbbzCw-1; Tue, 14 Jul 2020 08:12:17 -0400
X-MC-Unique: Xpwzwvh2M129YqVicbbzCw-1
Received: by mail-qv1-f72.google.com with SMTP id m18so9486331qvt.8
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 05:12:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=T/Uhd8kUIGVaFKfJlqqrQidFsSiRXLcUNXdQ5T/zyIQ=;
        b=bTUZuF8m6THYRZOKNONV0ShW9sWI0rDTyvp1DLbQqK8Uex1TKkoDQMf1jUFvcrLAJM
         HXX955olL4M/xsWZJDFahp9ECp59CK+462V1Nd7r8H4TjLpMWV7uUDuts2Wift+zsOQc
         jIXlPPEjPM8hIpJ/h4uZjNkq2F21jwnp6nCFv+HUTkyp2WcsYPT7LuJt9hTUmWne25bQ
         u28idMXTbs4/yYpSuOL90kirIZA8zi+U2fVYEQ/uC0f1g/fgK9PaRDnea1pRbV54018U
         ZGGL20ttZfdOfOP1eQO3AGp/u4FdEP5NL7TB2UHLaCA0KgU1OZpo8D8LqlMgB14ARE6U
         9gXw==
X-Gm-Message-State: AOAM5336QBGRTwjSTMFC2Do6oW57EIgAeHjmYIYedsc6goV6BjHbHewe
        YulTpsxFfh6vfi8Z2ObaMP/esFrymGfl1YFlihYH9qW7664GOx/MYrN7hDhPtI9DvVv+n8EI/hb
        yLx2HBt1FdFLu9Ku1
X-Received: by 2002:ac8:1017:: with SMTP id z23mr4211704qti.147.1594728736972;
        Tue, 14 Jul 2020 05:12:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxSPGpZKO/MnucK03sbLp81g53VnsyNgLsmQQ0Xv+L+2+VWswllr93CSBw6ZziPBPVFsu75Mw==
X-Received: by 2002:ac8:1017:: with SMTP id z23mr4211678qti.147.1594728736597;
        Tue, 14 Jul 2020 05:12:16 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id 19sm22323331qke.44.2020.07.14.05.12.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 05:12:15 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id CB7EC180653; Tue, 14 Jul 2020 14:12:12 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: BPF logging infrastructure. Was: [PATCH bpf-next 4/6] tools: add new members to bpf_attr.raw_tracepoint in bpf.h
In-Reply-To: <CAEf4BzZ_-vXP_3hSEjuceW10VX_H+EeuXMiV=_meBPZn7izK8A@mail.gmail.com>
References: <159467113970.370286.17656404860101110795.stgit@toke.dk> <159467114405.370286.1690821122507970067.stgit@toke.dk> <CAEf4BzZ_-vXP_3hSEjuceW10VX_H+EeuXMiV=_meBPZn7izK8A@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 14 Jul 2020 14:12:12 +0200
Message-ID: <87r1tegusj.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Mon, Jul 13, 2020 at 1:13 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>>
>> Sync addition of new members from main kernel tree.
>>
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> ---
>>  tools/include/uapi/linux/bpf.h |    9 +++++++--
>>  1 file changed, 7 insertions(+), 2 deletions(-)
>>
>> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/b=
pf.h
>> index da9bf35a26f8..662a15e4a1a1 100644
>> --- a/tools/include/uapi/linux/bpf.h
>> +++ b/tools/include/uapi/linux/bpf.h
>> @@ -573,8 +573,13 @@ union bpf_attr {
>>         } query;
>>
>>         struct { /* anonymous struct used by BPF_RAW_TRACEPOINT_OPEN com=
mand */
>> -               __u64 name;
>> -               __u32 prog_fd;
>> +               __u64           name;
>> +               __u32           prog_fd;
>> +               __u32           log_level;      /* verbosity level of lo=
g */
>> +               __u32           log_size;       /* size of user buffer */
>> +               __aligned_u64   log_buf;        /* user supplied buffer =
*/
>> +               __u32           tgt_prog_fd;
>> +               __u32           tgt_btf_id;
>>         } raw_tracepoint;
>>
>>         struct { /* anonymous struct for BPF_BTF_LOAD */
>>
>
> I think BPF syscall would benefit from common/generalized log support
> across all commands, given how powerful/complex it already is.
> Sometimes it's literally impossible to understand why one gets -EINVAL
> without adding printk()s in the kernel.

Yes, I agree! This is horrible UI!

> But it feels wrong to add log_level/log_size/log_buf fields to every
> section of bpf_attr and require the user to specify it differently for
> each command. So before we go and start adding per-command fields,
> let's discuss how we can do this more generically. I wonder if we can
> come up with a good way to do it in one common way and then gradually
> support that way throughout all BPF commands.
>
> Unfortunately it's too late to just add a few common fields to
> bpf_attr in front of all other per-command fields, but here's two more
> ideas just to start discussion. I hope someone can come up with
> something nicer.
>
> 1. Currently bpf syscall accepts 3 input arguments (cmd, uattr, size).
> We can extend it with two more optional arguments: one for pointer to
> log-defining attr (for log_buf pointer, log_size, log_level, maybe
> something more later) and another for the size of that log attr.
> Beyond that we'd need some way to specify that the user actually meant
> to provide those 2 optional args. The most straightforward way would
> be to use the highest bit of cmd argument. So instead of calling bpf()
> with BPF_MAP_CREATE command, you'd call it with BPF_MAP_CREATE |
> BPF_LOGGED, where BPF_LOGGED =3D 1<<31.

Well, if only we'd had a 'flags' argument to the syscall... I don't
suppose we want a bpf2()? :)

I like your idea of just using the top bits of the 'cmd' field as flag
bits, but in that case we should just define this explicitly, say
'#define BPF_CMD_FLAGS_MASK 0xFFFF0000'?

And instead of adding new arguments, why not just change the meaning of
the 'attr' argument? Say we define:

struct bpf_extended_attr {
       __u32 log_level;
       __u32 log_size;
       __aligned_u64 log_buf;
       __u8 reserved[48];
       union bpf_attr attr;
};

And then define a new flag BPF_USES_EXTENDED_ATTR which will cause the
kernel to interpret the second argument of the syscall as a pointer to
that struct instead of to the bpf_attr union?

> 2. A more "stateful" approach, would be to have an extra BPF command
> to set log buffer (and level) per thread. And if such a log is set, it
> would be overwritten with content on each bpf() syscall invocation
> (i.e., log position would be reset to 0 on each BPF syscall).

I don't think adding something stateful is a good idea; that's bound to
lead to weird issues when someone messes up the state management in
userspace.

> Of course, the existing BPF_LOAD_PROG command would keep working with
> existing log, but could fall back to the "common one", if
> BPF_LOAD_PROG-specific one is not set.
>
> It also doesn't seem to be all that critical to signal when the log
> buffer is overflown. It's pretty easy to detect from user-space:
> - either last byte would be non-zero, if we don't care about
> guaranteeing zero-termination for truncated log;
> - of second-to-last byte would be non-zero, if BPF syscall will always
> zero-terminate the log.

I think if we're doing this we should think about making the contents of
the log machine-readable, so applications can figure out what's going on
without having to parse the text strings. The simplest would be to make
this new log buffer use TLV-style messaging, say we define the log
buffer output to be a series of messages like these:

struct bpf_log_msg {
       __u16 type;
       __u32 len;
       __u8 contents[]; /* of size 'len' */
} __attribute__((packed));

To begin with we could define two types:

struct bpf_log_msg_string {
       __u16 type; /* BPF_LOG_MSG_TYPE_STRING */
       __u32 len;
       char message[];
}  __attribute__((packed));

struct bpf_log_msg_end {
       __u16 type; /* BPF_LOG_MSG_TYPE_END */
       __u32 len;
       __u16 num_truncations;
}  __attribute__((packed));

The TYPE_STRING would just be a wrapper for the existing text-based
messages, but delimited so userspace can pick them apart. And the second
one would solve your 'has the log been truncated' issue above; the
kernel simply always reserves eight bytes at the end of the buffer and
ends with writing a TYPE_END message with the number of messages that
were dropped due to lack of space. That would make it trivial for
userspace to detect truncation.

We could then add new message types later for machine-consumption. Say,
and extended error code, or offsets into the BTF information, or
whatever we end up needing. But just wrapping the existing log messages
in TLVs like the ones above could be fairly straight-forwardly
implemented with the existing bpf_log() infrastructure in the kernel,
without having to settle on which machine-readable information is useful
ahead of time... And the TLV format makes it easy for userspace to just
skip message types it doesn't understand.

WDYT?

> Of course, if user code cares about such detection of log truncation,
> it will need to set last/second-to-last bytes to zero before each
> syscall.
>
> Both approaches have their pros/cons, we can dig into those later, but
> I'd like to start this discussion and see what other people think. I
> also wonder if there are other syscalls with similarly advanced input
> arguments (like bpf_attr) and common logging, we could learn from
> those.

The first one that comes to mind is netlink extacks. Of course it's not
quite comparable since netlink already has message-based semantics, but
it does do sorta-kinda the same thing from a user PoV. The TLV format is
obviously inspired by netlink (or, well, binary networking protocols in
general).

-Toke

