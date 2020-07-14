Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98CA121FEDB
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 22:49:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727851AbgGNUr6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 16:47:58 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:29564 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726898AbgGNUr6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 16:47:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594759675;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0MaXgRjPugCbTyz5Iy3UwDJY6zPZsf/bR3z6EVEFfZM=;
        b=AqntVCpwJYoyPnaViHdy1DgE83HwAEMhSCuBOGX7WDjUXORMU1ZEm28NeVSRCwWtLft66K
        pcTw5L9SZ2k0F85uq5JpxUsM1XsYpj8CSmguenJLGgnqbTRvaSXTU7fTq5J1Ri1bDkNcPe
        YePHmnQLRS3O+2OsfDkSF0ycBcNl/28=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-313-trGmxnlfNBemIZjpl3mjqw-1; Tue, 14 Jul 2020 16:47:53 -0400
X-MC-Unique: trGmxnlfNBemIZjpl3mjqw-1
Received: by mail-qk1-f198.google.com with SMTP id k16so13902180qkh.12
        for <netdev@vger.kernel.org>; Tue, 14 Jul 2020 13:47:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=0MaXgRjPugCbTyz5Iy3UwDJY6zPZsf/bR3z6EVEFfZM=;
        b=C0Sej7j76yRO51uczOLP4X088zeE+J/rdzU9PVC4JRmgyDEP4QmQbG4+Q/WXSpYt1M
         h0Xe48k/A8aTXNLulWPGaKqscgi23hlqLcgOahQPNb0t3gWfNfxcbLVYEF4kqwIOkqJH
         qZVHVN8XFnRdIcILv85GaIj07nkY8EWJDazZ7vBhAWN6e/ACUnqsVClGwo1Z600x9rgh
         HA+nKNixZnbBLM4SAfRjBxXQnBiQldnF3k9BIyhFYFuIZqrSPW3BQvP2Jxf3Z/M2DY0o
         IFKVKRbNZIe60COKGShoXo11DhK/H2TPdTVfSkuDjE7JAojo4OB4Pe0S2vkW/nAQeV0z
         n1xQ==
X-Gm-Message-State: AOAM530fJweFtY8cZ7yc+ZIIr5aSxQAo55kkw3nSueKCT5P+3JRJaI0x
        BigM+xJ1zQO7igwGVL+LWajXMbGF5Yfoq6yH0rl0BQsh4vyRSYw2okzqzXAmpcIa6igRx4M4bWk
        bG9BUEMjvZ9lKq1In
X-Received: by 2002:ac8:ac3:: with SMTP id g3mr6789475qti.178.1594759672602;
        Tue, 14 Jul 2020 13:47:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy6nR2xXy0jRiZMLGRj0TzghbtfvfbIEqz7vomQo5C8fD8NnQrKy39FQyz0IWfKbXO5iFSe+A==
X-Received: by 2002:ac8:ac3:: with SMTP id g3mr6789461qti.178.1594759672187;
        Tue, 14 Jul 2020 13:47:52 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id 79sm24071619qkd.134.2020.07.14.13.47.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2020 13:47:51 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 86BD71804F0; Tue, 14 Jul 2020 22:47:48 +0200 (CEST)
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
In-Reply-To: <CAEf4Bzbu1wnwWFOWYA3e6KFeSmfg8oANPWD9LsUMRy2E_zrQ0w@mail.gmail.com>
References: <159467113970.370286.17656404860101110795.stgit@toke.dk> <159467114405.370286.1690821122507970067.stgit@toke.dk> <CAEf4BzZ_-vXP_3hSEjuceW10VX_H+EeuXMiV=_meBPZn7izK8A@mail.gmail.com> <87r1tegusj.fsf@toke.dk> <CAEf4Bzbu1wnwWFOWYA3e6KFeSmfg8oANPWD9LsUMRy2E_zrQ0w@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 14 Jul 2020 22:47:48 +0200
Message-ID: <87pn8xg6x7.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:

> On Tue, Jul 14, 2020 at 5:12 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>>
>> > On Mon, Jul 13, 2020 at 1:13 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke=
@redhat.com> wrote:
>> >>
>> >> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> >>
>> >> Sync addition of new members from main kernel tree.
>> >>
>> >> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> >> ---
>> >>  tools/include/uapi/linux/bpf.h |    9 +++++++--
>> >>  1 file changed, 7 insertions(+), 2 deletions(-)
>> >>
>> >> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linu=
x/bpf.h
>> >> index da9bf35a26f8..662a15e4a1a1 100644
>> >> --- a/tools/include/uapi/linux/bpf.h
>> >> +++ b/tools/include/uapi/linux/bpf.h
>> >> @@ -573,8 +573,13 @@ union bpf_attr {
>> >>         } query;
>> >>
>> >>         struct { /* anonymous struct used by BPF_RAW_TRACEPOINT_OPEN =
command */
>> >> -               __u64 name;
>> >> -               __u32 prog_fd;
>> >> +               __u64           name;
>> >> +               __u32           prog_fd;
>> >> +               __u32           log_level;      /* verbosity level of=
 log */
>> >> +               __u32           log_size;       /* size of user buffe=
r */
>> >> +               __aligned_u64   log_buf;        /* user supplied buff=
er */
>> >> +               __u32           tgt_prog_fd;
>> >> +               __u32           tgt_btf_id;
>> >>         } raw_tracepoint;
>> >>
>> >>         struct { /* anonymous struct for BPF_BTF_LOAD */
>> >>
>> >
>> > I think BPF syscall would benefit from common/generalized log support
>> > across all commands, given how powerful/complex it already is.
>> > Sometimes it's literally impossible to understand why one gets -EINVAL
>> > without adding printk()s in the kernel.
>>
>> Yes, I agree! This is horrible UI!
>
> UI?.. It's a perfectly fine and extensible API for all functionality
> it provides, it just needs a better human-readable feedback mechanism,
> which is what I'm proposing. Error codes are not working when you have
> so many different situations that can result in error.

Yes. I was agreeing with you: the lack of understandable error messages
means you have to play "guess where this EINVAL came from", which is a
terrible user experience (should have been UX instead of UI, I guess,
sorry about that).=20

>> > But it feels wrong to add log_level/log_size/log_buf fields to every
>> > section of bpf_attr and require the user to specify it differently for
>> > each command. So before we go and start adding per-command fields,
>> > let's discuss how we can do this more generically. I wonder if we can
>> > come up with a good way to do it in one common way and then gradually
>> > support that way throughout all BPF commands.
>> >
>> > Unfortunately it's too late to just add a few common fields to
>> > bpf_attr in front of all other per-command fields, but here's two more
>> > ideas just to start discussion. I hope someone can come up with
>> > something nicer.
>> >
>> > 1. Currently bpf syscall accepts 3 input arguments (cmd, uattr, size).
>> > We can extend it with two more optional arguments: one for pointer to
>> > log-defining attr (for log_buf pointer, log_size, log_level, maybe
>> > something more later) and another for the size of that log attr.
>> > Beyond that we'd need some way to specify that the user actually meant
>> > to provide those 2 optional args. The most straightforward way would
>> > be to use the highest bit of cmd argument. So instead of calling bpf()
>> > with BPF_MAP_CREATE command, you'd call it with BPF_MAP_CREATE |
>> > BPF_LOGGED, where BPF_LOGGED =3D 1<<31.
>>
>> Well, if only we'd had a 'flags' argument to the syscall... I don't
>> suppose we want a bpf2()? :)
>>
>> I like your idea of just using the top bits of the 'cmd' field as flag
>> bits, but in that case we should just define this explicitly, say
>> '#define BPF_CMD_FLAGS_MASK 0xFFFF0000'?
>
> sure
>
>>
>> And instead of adding new arguments, why not just change the meaning of
>> the 'attr' argument? Say we define:
>>
>> struct bpf_extended_attr {
>>        __u32 log_level;
>>        __u32 log_size;
>>        __aligned_u64 log_buf;
>>        __u8 reserved[48];
>>        union bpf_attr attr;
>> };
>
> because this is a major PITA for libraries, plus it's not very
> extensible, once you run out of 48 bytes? And when you don't need
> those 48 bytes, you still need to zero them out, the kernel still
> needs to copy them, etc. It just feels unclean to me.
>
> But before we argue that, is there a problem adding 2 more arguments
> which are never used/read unless we have an extra bit set in cmd?
> Honest question, are there any implications to user-space with such an
> approach? Backwards-compatibility issues or anything?

No idea; I don't know enough about how the lower-level details of the
syscall interface works to tell either way. Is it even *possible* to add
arguments like that in a backwards-compatible way?

However, assuming it *is* possible, my larger point was that we
shouldn't add just a 'logging struct', but rather a 'common options
struct' which can be extended further as needed. And if it is *not*
possible to add new arguments to a syscall like you're proposing, my
suggestion above would be a different way to achieve basically the same
(at the cost of having to specify the maximum reserved space in advance).

>> And then define a new flag BPF_USES_EXTENDED_ATTR which will cause the
>> kernel to interpret the second argument of the syscall as a pointer to
>> that struct instead of to the bpf_attr union?
>>
>> > 2. A more "stateful" approach, would be to have an extra BPF command
>> > to set log buffer (and level) per thread. And if such a log is set, it
>> > would be overwritten with content on each bpf() syscall invocation
>> > (i.e., log position would be reset to 0 on each BPF syscall).
>>
>> I don't think adding something stateful is a good idea; that's bound to
>> lead to weird issues when someone messes up the state management in
>> userspace.
>
> I agree, I'd prefer a stateless approach, but wanted to lay out a
> stateful one for completeness as well.

OK, cool.

>>
>> > Of course, the existing BPF_LOAD_PROG command would keep working with
>> > existing log, but could fall back to the "common one", if
>> > BPF_LOAD_PROG-specific one is not set.
>> >
>> > It also doesn't seem to be all that critical to signal when the log
>> > buffer is overflown. It's pretty easy to detect from user-space:
>> > - either last byte would be non-zero, if we don't care about
>> > guaranteeing zero-termination for truncated log;
>> > - of second-to-last byte would be non-zero, if BPF syscall will always
>> > zero-terminate the log.
>>
>> I think if we're doing this we should think about making the contents of
>> the log machine-readable, so applications can figure out what's going on
>> without having to parse the text strings. The simplest would be to make
>> this new log buffer use TLV-style messaging, say we define the log
>> buffer output to be a series of messages like these:
>>
>> struct bpf_log_msg {
>>        __u16 type;
>>        __u32 len;
>>        __u8 contents[]; /* of size 'len' */
>> } __attribute__((packed));
>>
>> To begin with we could define two types:
>>
>> struct bpf_log_msg_string {
>>        __u16 type; /* BPF_LOG_MSG_TYPE_STRING */
>>        __u32 len;
>>        char message[];
>> }  __attribute__((packed));
>>
>> struct bpf_log_msg_end {
>>        __u16 type; /* BPF_LOG_MSG_TYPE_END */
>>        __u32 len;
>>        __u16 num_truncations;
>> }  __attribute__((packed));
>>
>> The TYPE_STRING would just be a wrapper for the existing text-based
>> messages, but delimited so userspace can pick them apart. And the second
>> one would solve your 'has the log been truncated' issue above; the
>> kernel simply always reserves eight bytes at the end of the buffer and
>> ends with writing a TYPE_END message with the number of messages that
>> were dropped due to lack of space. That would make it trivial for
>> userspace to detect truncation.
>>
>
> Log truncation is not an issue, we can make bpf syscall to write back
> the actual size of emitted log (and optionally extra bool to mean
> "truncated") into the original log_size field.

So what was all that you were talking about with "check the
second-to-last byte" in your previous email? I understood that to be
about detecting truncation?

>> We could then add new message types later for machine-consumption. Say,
>> and extended error code, or offsets into the BTF information, or
>> whatever we end up needing. But just wrapping the existing log messages
>> in TLVs like the ones above could be fairly straight-forwardly
>> implemented with the existing bpf_log() infrastructure in the kernel,
>> without having to settle on which machine-readable information is useful
>> ahead of time... And the TLV format makes it easy for userspace to just
>> skip message types it doesn't understand.
>>
>> WDYT?
>
> I think it's taking it a bit too far and adds more API on top of
> existing API. Now all those types become a fixed API, messages become
> an API, etc. Just more backwards compatibility stuff we need to
> support forever, for, what I believe, very little gain.
>
> In practice, using human-readable strings works just fine. If there is
> any kind of real issue, usually it involves humans reading debug logs
> and understanding what's going on.

Let me give an example of what I want to be able to do. Just today I
helped someone debug getting xdp-filter to run, and they were getting
output like this:

      libbpf: -- BEGIN DUMP LOG ---
      libbpf:
      xdpfilt_alw_all() is not a global function
      processed 0 insns (limit 1000000) max_states_per_insn 0 total_states 0
      peak_states 0 mark_read 0

      libbpf: -- END LOG --

I would like to have xdp-filter catch that, and turn it into a
friendlier "your compiler is too old" message. Having to effectively
grep through the free-form log output to pick out that message feels
brittle and error prone, as opposed to just having the kernel add a
machine-readable id ("err_func_linkage_not_global" or somesuch) and
stick it in a machine-parsable TLV.

> Also adopting these packet-like messages is not as straightforward
> through BPF code, as now you can't just construct a single log line
> with few calls to bpf_log().

Why not? bpf_log() could just transparently write the four bytes of
header (TYPE_STRING, followed by strlen(msg)) into the buffer before the
string? And in the future, an enhanced version could take (say) an error
ID as another parameter and transparently add that as a separate message.

>> > Of course, if user code cares about such detection of log truncation,
>> > it will need to set last/second-to-last bytes to zero before each
>> > syscall.
>> >
>> > Both approaches have their pros/cons, we can dig into those later, but
>> > I'd like to start this discussion and see what other people think. I
>> > also wonder if there are other syscalls with similarly advanced input
>> > arguments (like bpf_attr) and common logging, we could learn from
>> > those.
>>
>> The first one that comes to mind is netlink extacks. Of course it's not
>> quite comparable since netlink already has message-based semantics, but
>> it does do sorta-kinda the same thing from a user PoV. The TLV format is
>> obviously inspired by netlink (or, well, binary networking protocols in
>> general).
>>
>
> Yeah, I'm aware of extack, but as you said, TLV is more of a netlink
> format, extack messages themselves are just strings. But my question
> was more of how this log could be done for complicated API calls using
> similar extendable attrs, like perf_event_open, clone3, openat2, etc.

Ah, right, no idea :)

-Toke

