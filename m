Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09B5F1046B4
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 23:48:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbfKTWsL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 17:48:11 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:41954 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbfKTWsL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 17:48:11 -0500
Received: by mail-qk1-f195.google.com with SMTP id m125so1372066qkd.8;
        Wed, 20 Nov 2019 14:48:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=w9WI+PUWQq6CTWNA+EM/Jbzt6c+QaI3NFYcktBaPxcM=;
        b=MYe6LO5AjxAcNJh1b4WhOrMuTj3Fyqq1/VMdnEVLDVUlWdRbdRs3Jh5IidItJOR83F
         mHexj2N3BUZT07mcoFFumO8nweYljb6RNGwdOKyhvEEDZlKWBE5FrlT0ekSIymG8n/aR
         S0ArwdTJ2iQkzE61/11hYa+YLVi0vJnYksWj/MYvi5wHlNCMH+DD/hRZZPiogDhOo0ab
         yZEzFIZXYSkgX2dUnvIHJxk8JUrj123Dy0pshBRvv/sNWonM/xNzlDTSWe3T0pFWCMCl
         B99pnKnGMtu84Iqk4PXl6G+ymQSXc9lgZKF5qNrtDjzohqhCBF+PhuYj4mV02iVdDX07
         7cRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w9WI+PUWQq6CTWNA+EM/Jbzt6c+QaI3NFYcktBaPxcM=;
        b=QnwB3N9cLDvnsbWMVc6ZKq5GTcLuUfqfWNsMSvhDRI0dgr3+pxLZi4cnYuNJlZblcP
         ixBYZ9FGAvYpt2hQtd++ZfJJ1beUCYBueWJENUgrZpQ1f+WlGwGBU24jVRelwHPCpQqc
         KD4NlSxpObPkV6EJTEYSqGhhXbvPmB0ikTgNldmMBRdp5hzwWpUhC2BaqfGKGZ9d85D6
         zl574cBZEMgA+TCZNcBXgmEr3VsTF1qjU1kNsQ/jHiHhs6TLrQShQIl+A1iziA8dckku
         oAuX7slvYBvwgOfvJrryDSrwsVEWAJshh7qjHeyUvgzk2lbn9D7TbxKszYU+9sRtdcGY
         zpxg==
X-Gm-Message-State: APjAAAVSo9otuDr8bpGXij8iHXZM0A6tMQFwSS6XFXPj9ZD8vTAKy+Gu
        hWwwOicsaV7bAUPqtq84e1ep9BVAZCp/CeGEs/Q=
X-Google-Smtp-Source: APXvYqyiishlb6CelH9ChmRNJu3hjjvdzxROOSrS8vvsQ4/qnCxCImFQZXGpCvVSvyDwGAAhae0GSZggfhCRDB8nGRI=
X-Received: by 2002:a37:b3c4:: with SMTP id c187mr5008220qkf.36.1574290089677;
 Wed, 20 Nov 2019 14:48:09 -0800 (PST)
MIME-Version: 1.0
References: <20191117070807.251360-1-andriin@fb.com> <20191117070807.251360-6-andriin@fb.com>
 <20191119032127.hixvyhvjjhx6mmzk@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzaNEU_vpa98QF1Ko_AFVX=3ncykEtWy0kiTNW9agsO+xg@mail.gmail.com>
 <CAEf4Bza1T6h+MWadVjuCrPCY7pkyK9kw-fPdaRx2v3yzSsmcbg@mail.gmail.com>
 <7012feeb-c1e8-1228-c8ce-464ea252799c@fb.com> <CAEf4BzaW4-XTxZTt2ZLvzuc2UsmmPa3Bkoej7B0pUJWcM--eVQ@mail.gmail.com>
 <11d4fde2-6cf5-72eb-9c04-b424f7314672@fb.com>
In-Reply-To: <11d4fde2-6cf5-72eb-9c04-b424f7314672@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 20 Nov 2019 14:47:58 -0800
Message-ID: <CAEf4BzakAJ5dEF35+g7RBgieXfVzjKQHm_Dej-9f_K_qXNuG2Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next 5/6] libbpf: support libbpf-provided extern variables
To:     Alexei Starovoitov <ast@fb.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 20, 2019 at 1:39 PM Alexei Starovoitov <ast@fb.com> wrote:
>
> On 11/19/19 7:44 PM, Andrii Nakryiko wrote:
> > So, to summarize, we proceed with uint64_t for everything, with added
> > bits of weak vs strong handling. Then in parallel we'll work on adding
> > BTF for externs and __builtin_extern_resolved (and corresponding new
> > kind of BTF relocation) and will keep making this whole API even
> > better, while already having something useful and extensible.
>
> I didn't know extern can be weak. That was a good find.
> Indeed undefined config_* can be represented as uint64 zero value.
> But I still have an issue with 'proceed uint64_t for everything',
> since strings and tri-state don't fit into uint64.

well, great that we are at least aligned w.r.t. int/hex :)

not clear about bool, though. They are subset of tristate, so should
they be 'y'/'n' (which is certainly weird, isn't it?) raw characters
(with zero byte termination? Or just plain single char?) or C's 0 and
1?

>
> How about strtol be applied by libbpf only for things that parse
> successfully (like decimal and hex) and everything else will be
> represented raw ?
> Like CONFIG=y will be 121.
> CONFIG=m will be 109

Again, conceptually, bool is subset of tristate. So if we go with real
bools, then 0 and 1 should match to tristate's y/n as well.

For tristate we also can have 8-byte enum, if you think that's better
than short 0/1/2 (or whatever, -1, if you don't like 2):

enum kconfig_tristate {
        NO = 0,
        YES = 1,
        MODULE = 2,
        __KCONFIG_TRISTATE_INVALID = 0xFFFFFFFFFFFFFFFF
};

> CONFIG="abc" will be 0x636261
> In other words CONFIG_A is an address and
> 'extern weak uint64_t CONFIG_A' reads raw bytes from that location.
> When that CONFIG_A is undefined in /boot/config.gz the u64 read
> from that address will return zero.
> u8 read from that address will return zero too.

I'm puzzled on why strings should be represented as "extern int64_t"?
What about strings longer than 7 bytes (+1 zero terminator)? IMO,
strings should be strings, i.e., const char []. Or const char *, if we
had a support (see my previous email). Cramming arbitrary strings into
uint64_t seems weird and I fail to see the reason.


So just to summarize how I understand situation right now. Please let
me know if that's not true.

1. We proceed with extern uint64_t for what's detected as integer/hex
(at runtime).
2. Weak/strong externs determine how we handle unresolved config
values. Weak - default to 0, strong - ensure it can't be read. But
this might be complicated by our further choices below.

Things that I'd like to clarify. And I'll list options we've discussed.

1. For bools:
  a) parse them as 0/1, for now use them as uint64_t. Once BTF for
externs available, users will be able to pick bool instead.
  b) parse them as 0/1 (false, true), represent as single byte bool.
  c) leave them as raw single character: 'y' or 'n'
    c1) represent as single byte?
    c2) represent as 8 bytes to match uint64_t?
  d) leave them as a raw string (zero-terminated)
    d1) represent as fixed 8-byte string?..
    d2) represent as variable-sized raw string?

2. For tristate, pretty much the same set of questions, except there
is one more state 'm'. One extra option: represent as 8-byte enum,
maybe? We can do 4-byte enum as well, but that has all the downsides
of variable sized externs without yet having BTF type info.

3. For strings:
  a) don't add them yet, if string is detected in runtime, return
error (my original proposal);
  b) add them as up to 7 characters fixed strings you proposed? What
do we do with longer strings?
  c) add them as variable-sized zero-terminated strings (libbpf will
determine size at runtime). See below for consequences.

If we pick any combination where fields are not uniform (so, if we add
strings right now, or have bool as 1 byte, or whatever), we'll have to
specify what size value we fall back to if weakly-defined extern is
not resolved. Is it going to be zero uint64_t? This is wasteful for
what's expected to be a string (and dirty). On the other hand,
specifying it as empty single-byte string is not going to work for
CONFIG_XXX that is undefined integer. Generally speaking, having
variable sized representation is very confusing until we have expected
type information or at least expected byte size.

Given all this, I think realistically we can pick few combinations:

1. Only support int/hex as uint64_t. Anything y/n/m or a string will
fail in runtime.
Pros:
  - we get at least something to use in practice (LINUX_KERNEL_VERSION
and int CONFIG_XXXs).
Cons:
  - undefined weak extern will have to be assumed either uint64_t 0
(and succeed) or undefined string (and fail). No clearly best behavior
here.
  - no ability to do "feature detection" logic in BPF program.
2. Stick to uint64_t for bool/tristate/int/hex. Don't support strings
yet. Improve in backwards compatible way once we get BTF type info for
externs (adding strings at that time).
Pros:
  - well-defined and logical behavior
  - easily extensible once we get BTF for externs. No new flags, no
changes in behavior.
Cons:
  - no strings yet
  - Alexei doesn't like y/n/m as 0/1/2
3. Mix of the options for bool/tristate/string I layed out above.
Pros:
  - we can get reasonable strings (or up to 7-byte ones, but not sure why);
  - bool/tristate can be accessed, though, IMO, in an ugly
character-based fashion.
Cons:
  - some arbitrary choices need to be made, that couldn't be changed
even when we have BTF for externs.
  - needs further discussion and specification to narrow down all the downsides.

My preferences would be 2, if not, then 1.
