Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA244104897
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 03:39:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726132AbfKUCjC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 21:39:02 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:43492 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbfKUCjB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 21:39:01 -0500
Received: by mail-io1-f65.google.com with SMTP id r2so1573743iot.10;
        Wed, 20 Nov 2019 18:39:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WkSbaVZ9yT0p92IBq0MK9x8HXpBQIURkL1iRbEEZhV4=;
        b=ecLbgZOxbDHdXFwuntjEWJ4Obgrjf5w/aj+A3PPs44/d9TwPiN162SM18VM0NR/A8O
         Cteoiv1Xf7pxpBZoU3ZI8AQyG8GNHzysXXV31i256jdzODODJuVWQM+YrGRSRMHhhr++
         Coio/5TLrFP4vOku3OtC94/NNRVs/nuerlEey0JS4I1ZxyKZWjK7+CRVLpil1ABELARu
         z7AeUVpZO146aZ4QenEpTuDPmE51Nkn93kpME03qI7DD8uyETQ6YbwtSL9N/v128o+QB
         m4SlCdcqBngTI1ss3PrhFjewiWVr1rgGmLjK7iFAIfXtiTM0tbcpJwMP9HlCFZZE9Zje
         kdtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WkSbaVZ9yT0p92IBq0MK9x8HXpBQIURkL1iRbEEZhV4=;
        b=dSWOreS7WRvaqD164goy30UEi3Vz9NYXR0vsULMV+JTNMWk8Fa0CPXWZvos4j9pHzU
         o207FT5vRXYghKBhU22EI4IVjovREDU2VpAe/7j7jziGJPNmvcNMDlJbLdoKpMNJFh2L
         OyN1jeUXt/hSxmy/5MNqCzsrkAps4Xfj4Uwnt6iMHXZTjG1FPtItVpCh4FnQdzH2SBOt
         FlTn6LwoKTJgZeEzeWtshIP4h5/MV0Bs6AgOB6i9/neTP2cJ9hD3UBC/09aZQm1yAI1w
         zb+rlT41PcplAVpEnTH2oFolwSm7rgPLJ7hLEog2iXQogrAPl5zqbRUQBR3uJOGi0G0c
         bYPA==
X-Gm-Message-State: APjAAAU0sfifyfrCI41dRlwEOYAkNYVbfsOa93/HXf6OGXtuJEqrFc5I
        uGiGQfQDXSzWiHN1sKhjnheZMeUeeAt9cljDwfq7xRmG
X-Google-Smtp-Source: APXvYqys9oUs84UeY2AX4aKooLbTddAPNKIYYDaTQ6vAzB7MqO9iazY6L5PHsoDXpMQ7pFPhEnLobcNvflRUgRJBBqg=
X-Received: by 2002:a05:620a:12b2:: with SMTP id x18mr5739231qki.437.1574302449082;
 Wed, 20 Nov 2019 18:14:09 -0800 (PST)
MIME-Version: 1.0
References: <20191117070807.251360-1-andriin@fb.com> <20191117070807.251360-6-andriin@fb.com>
 <20191119032127.hixvyhvjjhx6mmzk@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzaNEU_vpa98QF1Ko_AFVX=3ncykEtWy0kiTNW9agsO+xg@mail.gmail.com>
 <CAEf4Bza1T6h+MWadVjuCrPCY7pkyK9kw-fPdaRx2v3yzSsmcbg@mail.gmail.com>
 <7012feeb-c1e8-1228-c8ce-464ea252799c@fb.com> <CAEf4BzaW4-XTxZTt2ZLvzuc2UsmmPa3Bkoej7B0pUJWcM--eVQ@mail.gmail.com>
 <11d4fde2-6cf5-72eb-9c04-b424f7314672@fb.com> <CAEf4BzakAJ5dEF35+g7RBgieXfVzjKQHm_Dej-9f_K_qXNuG2Q@mail.gmail.com>
 <20191121001811.eyksi2acyhvy4skr@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20191121001811.eyksi2acyhvy4skr@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 20 Nov 2019 18:13:57 -0800
Message-ID: <CAEf4BzaT=UhR0yDOTa_Q8KcZ0G0i9fYWTfdoW8qZCkcTNjxDRg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 5/6] libbpf: support libbpf-provided extern variables
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Alexei Starovoitov <ast@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 20, 2019 at 4:18 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Nov 20, 2019 at 02:47:58PM -0800, Andrii Nakryiko wrote:
> >
> > Given all this, I think realistically we can pick few combinations:
> >
> > 1. Only support int/hex as uint64_t. Anything y/n/m or a string will
> > fail in runtime.
> > Pros:
> >   - we get at least something to use in practice (LINUX_KERNEL_VERSION
> > and int CONFIG_XXXs).
> > Cons:
> >   - undefined weak extern will have to be assumed either uint64_t 0
> > (and succeed) or undefined string (and fail). No clearly best behavior
> > here.
>
> what that uint64 going to be when config_ is defined?
> If your answer is 1 than it's not extensible.

Let's say we have

extern __attribute__((weak)) uint64_t CONFIG_VALUE;

Now let's see how different possible configs will behave:

.config                         uint64_t value
CONFIG_VALUE=123            =>  123
CONFIG_VALUE=y              =>  1
CONFIG_VALUE="abc"          =>  libbpf error (assuming no string support)
# CONFIG_VALUE not defined  =>  0

>
> >   - no ability to do "feature detection" logic in BPF program.
> > 2. Stick to uint64_t for bool/tristate/int/hex. Don't support strings
> > yet. Improve in backwards compatible way once we get BTF type info for
> > externs (adding strings at that time).
> > Pros:
> >   - well-defined and logical behavior
> >   - easily extensible once we get BTF for externs. No new flags, no
> > changes in behavior.
>
> extensible with new flag == not extensible.

please re-read two lines you just quoted: **"No new flags, no changes
in behavior"**.
So extensible by your definition.

> The choices for bpf program that we pick for extern must keep working
> when llvm starts generating BTF for externs.

Agree and that's what I'm claiming: they are going to work.

>
> > My preferences would be 2, if not, then 1.
>
> I'm proposing something else.
> I see libbpf as a tool to pass /boot/config.gz into bpf program. From program
> pov CONFIG_FOO is a label. It's not a variable of type u8 or type u64.

This is not true for usage of CONFIG_XXX values in kernel code. Why
would we have a completely different semantics for BPF programs? When
kernel code does:

int sec = jiffies * CONFIG_HZ;

CONFIG_HZ is not just a label pointing to raw string representation of
100 or 1000, it **IS** a number 1000. You cannot multiply strings in
C, yet you can multiply CONFIG_HZ.

> Example:
> CONFIG_A=100
> CONFIG_B=y
> CONFIG_C="abcd"
> will be a map of one element with value:
> char ar[]= { 0x64, 0, 0, 0, 'y', 'a', 'b', 'c', 'd', 0};
>
> CONFIG_A = &ar[0];
> CONFIG_B = &ar[4];
> CONFIG_C = &ar[5];
>
> libbpf parses config.gz and converts all int/hex into 4 byte or 8 byte
> integers depending on number of text digits it sees in config.gz
> with alignment. All other strings and characters are passed as-is.
> If program says
> extern u8 CONFIG_A, CONFIG_B, CONFIG_C;
> It will read 1st byte from these three labels.
> Later when llvm emits BTF those u8 swill stay as-is and will read the same
> things. With BTF if program says 'extern _Bool CONFIG_B;' then it will be an
> explicit direction for libbpf to convert that CONFIG_B value into _Bool at
> program load time and represent it as sizeof(_Bool) in map element. If program
> says 'extern uint32_t CONFIG_C;' the libbpf will keep first 4 bytes of that
> string in there. If program says 'extern uint64_t CONFIG_C;' the libbpf will
> keep first 4 character plus one byte for zero plus 3 bytes of padding in map
> element.

This set of rules is not consistent, if I interpret what you are
saying correctly.

.config            extern definition              w/o BTF             w/ BTF

CONFIG_VALUE=y     extern bool CONFIG_VALUE;      {'y'}
true             -- change in behavior
CONFIG_VALUE=100   extern uint32_t CONFIG_VALUE;  {0x64, 0, 0, 0}
{0x64, 0, 0, 0}  -- no change, because we parse ints
CONFIG_VALUE="abc" extern uint32_t CONFIG_VALUE;  {'a', 'b', 'c', 0}
??? still {'a', 'b', 'c', 0}? or error?

So for bools we'll start interpreting 'y' as 1 (true), but only when
we get BTF. Even though we can clearly parse y/n today as 1 (true) or
0 (false).

For integers, nothing changes and uint32_t means "I want parsed
integer and at most 4 lower bytes on little-endian or 4 upper bytes on
big-endian". Though we might want to reject it with BTF info, if it
doesn't fit into 32 bits (because now we can?).

For strings, uint32_t suddenly means "give me first 4 raw bytes". I'm
not even clear what we will do with BTF in that case.

This logic also breaks when user declares "extern uint64_t", but real
value fits in just 4 bytes. According to your rules, libbpf will
allocate just 4 bytes, and user will read extra 4 bytes of garbage. In
either low or high 4 bytes, depending on machine endianness.

This strikes me as unnecessarily convoluted behavior.

> 'extern char CONFIG_C[5];' is also ok. Either with or without BTF.
> In both cases it will be 5 bytes in map element.
> Without BTF doing 'extern char *CONFIG_C;' will read garbage 8 bytes from that
> label. With BTF 'extern char *CONFIG_C;' will be converted to pointer to inner
> bytes of map element.

Again, I don't even know how many bytes user expected, so when it's
defined - I don't know how many zeros I should substitute. Or if user
define uint64_T, but value fits just 4 bytes, how do I know user
didn't expect all 8. For strings, it's even more interesting. "a" vs
"abracadabra" will require different amount of storage, so if user
will try to read it as extern uint32_t, he will either read 'a' +
garbage, or 'abra'.

I really struggle to see how what I'm proposing is not more consistent
and logical behavior. I'm saying that before we have BTF, all uses
should be `extern uint64_t CONFIG_BLA`. There is nothing preventing
user to do `extern int CONFIG_BLA`, but we don't have abilities to
enforce that, so we are saying "don't do it because it's not
supported, it might or might not work, with random probability". Now,
assuming people follow documentation and examples, we know that it's
always 8 bytes that people are expecting. So all integers are parsed
and allocated as uint64_t, which makes it consistent for big- and
litte-endian machines. For bools, it's just natural to interpret them
as 0 and 1, I fail to see why this is controversial. y/n is just
Kconfig text representation **in text file** of true/false (bool
type). By extension, y/n/m can be mapped into 0/1/2. Sure 2 is sort of
arbitrary, but it follows y, it keeps bool a strict subset of
tristate. For strings I'd hold off until we have BTF, because then
declaring `extern const char CONFIG_BLA[]` is a clear indication you
expect string. While `extern uint32_t CONFIG_BLA;` is a clear
indication that you expect integer, so if the config value is not
parsable to integer -- that's an error. No need to arbitrarily map
first 4 character and pretend they are integer. If you want that
behavior, just declare `extern u8 CONFIG_BLA[]`.

Now, everything is currently defined as uint64_t. BTF info for extern
arrives. People go fancy and say: "screw it, I don't want to waste 8
bytes for bool". They go and change it to "extern bool CONFIG_BLA;".
Good, libbpf sees BTF, validates it's only y or n in config. If it's m
- fail, if it's 1, 0, 123, "a", "abc", "y" - fail. It's not a bool.
Just strictly better behavior.

Once we have BTF, bam, strings just works, because libbpf knows that
user expects 'const char[]'. All this type information is available to
tooling at that point as well, so BPF object auto-generated skeleton
can take all that into account, because it had guarantees that libbpf
will always allocate that amount of bytes for primitive types.

Before we have BTF type info, it's either 8 bytes for supported types,
or pain for users. I don't know why I'd pick the latter.

> In other words BTF types will be directives of how libbpf should convert
> strings in text file to be consumed by bpf program. Since we don't have types
> now int/hex are the only ones that libbpf will convert unconditionally. The
> logic of parsing config.gz is generic. It can parse any file with 'var=value'
> lines this way. All names will be preserved.
> In that sense LINUX_KERNEL_VERSION is a text file that has one line:
> LINUX_KERNEL_VESRION=1234
> If digits fit into u32 it should be u32.

See above. Libbpf doesn't know that user expects u32, so choosing 4 vs
8 bytes at runtime is, while super easy for libbpf, would be super
frustrating for users. We should just say no until we have types.

> This way users can feed any configuration.txt file into libbpf and into their
> programs. Without BTF the map element is a collection of raw bytes and the
> program needs to be smart about reading them with correct sizes. With BTF
> libbpf will be converting .txt into requested types and failing to load
> if libbpf cannot convert string from text into requested type.

This was never intended as a generic application-provided config
parser, I'm sorry if I made that impression. This is specifically
driven towards kernel config, taking into account kernel config
semantics with its explicitly supported types of values and how it's
exposed to kernel code. This is intended to provide an illusion to BPF
program of having as close environment, as we can get, to just
programming inside the kernel. Example 'var=value' will never happen
with Kconfig. It's invalid config and libbpf should reject that.

If application needs to pass custom config, application will have to
parse it on its own and pass it as global data: either mutable or
read-only. If we deem this necessary, we can provide custom libbpf
helpers to automate that, but I'd refrain from that. There are way too
many different ways to define application configs to reasonably
support anything generic. It's just not the problem that libbpf should
try to solve. Libbpf should make using of global data simpler and more
user-friendly.
