Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97C1D128347
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 21:30:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727510AbfLTUav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 15:30:51 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45381 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726525AbfLTUav (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 15:30:51 -0500
Received: by mail-pg1-f194.google.com with SMTP id b9so5480639pgk.12;
        Fri, 20 Dec 2019 12:30:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=9eNRVdUpLISQN+Dkpw/DpfxstaMnOQ1oUQnuZRi/qnQ=;
        b=fvKGAq3hyW9oR+yyzMIfWKDaoyJW9+hfVWmLUlV2io6JMuv2l6+X9hAi7MMzaXAJMm
         waV1i4wKUqE9ucG5oLCWnATjKQELXYByab/snj49vNtadayoZotcVTVNV3VEA5zb945C
         hp6z1Cn/PKgP9x9lYDKO3aBI8l8tydWEgie459ypSuJ8LkgEl2geWU1LXqPFdLMV34Ou
         ZmurN08a0O60fcqYbf6Kavy8/INig+tOb/qKaVtHtAv5iJ2pqu9X4x+URm+GEfZe7w1n
         ETmuwG857PaEelnU+H9GDIj2ZE/CaknHcNvZw3RtV9oWoqLLsDa82G845jghA6faTUe4
         3F+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=9eNRVdUpLISQN+Dkpw/DpfxstaMnOQ1oUQnuZRi/qnQ=;
        b=pxYtxcjsXSuiE1myCDQyMegvAERQOXMMUn1KIMC6y1h+IlrJLKPwF1vPXrxa39235+
         f7yXRfUcUQh3SBWidRjL+UD/QkXWkZQFyCUziYTOwDhlzfXJQTcI8QateIeDum/ewzGb
         XGTfvaJiHx0HuMIzrnwT0v4bPDsO1RImONmtW1Kyt62m7ykL3dSKaM0RSiyVJ1Lc0nLb
         3qmxWs34kddAlSi541jims1JIzHShVaUY8N0Ou2C8wgiwhj1DoPZ+YwDOGXehMpKT8Gj
         rXAOxIYps3LI03fketp68fIrgagHrBZ7yA8TBgu3rmvYDkE04AB1OBQiEQ3q2p8VNUfu
         KBZw==
X-Gm-Message-State: APjAAAW53uvw47X1YBqBlkXYFNCXrb63FAJ5PptSeb3Sy1sOHqC4pUB6
        KZ2KBm2ZuJEDZMEM4xxWAjs=
X-Google-Smtp-Source: APXvYqxI3oY6o9wyY0whh8gPmdGsdFGK4Q2Lg9bfW6Aa/31TBqLjaMI6jz7q7e15d1gkFigdSPeDXw==
X-Received: by 2002:a63:5056:: with SMTP id q22mr16658034pgl.20.1576873849805;
        Fri, 20 Dec 2019 12:30:49 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::2:827d])
        by smtp.gmail.com with ESMTPSA id d65sm14089997pfa.159.2019.12.20.12.30.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 20 Dec 2019 12:30:48 -0800 (PST)
Date:   Fri, 20 Dec 2019 12:30:47 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH RFC bpf-next 0/3] libbpf: Add support for extern function
 calls
Message-ID: <20191220203045.hmeoum5l4uw7gy5g@ast-mbp.dhcp.thefacebook.com>
References: <157676577049.957277.3346427306600998172.stgit@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <157676577049.957277.3346427306600998172.stgit@toke.dk>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 19, 2019 at 03:29:30PM +0100, Toke Høiland-Jørgensen wrote:
> This series adds support for resolving function calls to functions marked as
> 'extern' in eBPF source files, by resolving the function call targets at load
> time. For now, this only works by static linking (i.e., copying over the
> instructions from the function target. Once the kernel support for dynamic
> linking lands, support can be added for having a function target be an already
> loaded program fd instead of a bpf object.
> 
> The API I'm proposing for this is that the caller specifies an explicit mapping
> between extern function names and function names in the target object file.
> This is to support the XDP multi-prog case, where the dispatcher program may not
> necessarily have control over function names in the target programs, so simple
> function name resolution can't be used.

I think simple name resolution should be the default behavior for both static
and dynamic linking. That's the part where I think we must not reinvent the wheel.
When one .c has
extern int prog1(struct xdp_md *ctx);
another .c should have:
int prog1(struct xdp_md *ctx) {...}
Both static and dynamic linking should link these two .c together without any
extra steps from the user. It's expected behavior that any C user assumes and
it should 'just work'.

Where we need to be creative is how plug two xdp firewalls with arbitrary
program names (including the same names) into common roolet.

One firewall can be:
noinline int foo(struct xdp_md *ctx)
{ // some logic
}
SEC("xdp")
int xdp_prog1(struct xdp_md *ctx)
{
       return foo(ctx);
}

And another firewall:
noinline int foo(struct xdp_md *ctx)
{ // some other logic
}
SEC("xdp")
int xdp_prog2(struct xdp_md *ctx)
{
       return foo(ctx);
}

Both xdp programs (with multiple functions) need to be connected into:

__weak noinline int dummy1(struct xdp_md *ctx) { return XDP_PASS; }
__weak noinline int dummy2(struct xdp_md *ctx) { return XDP_PASS; }

SEC("xdp")
int rootlet(struct xdp_md *ctx)
{
        int ret;

        ret = dummy1(ctx);
        if (ret != XDP_PASS)
                goto out;

        ret = dummy2(ctx);
        if (ret != XDP_DROP)
                goto out;
out:
        return ret;
}

where xdp_prog1() from 1st firewall needs to replace dummy1()
and xdp_prog2() from 2nd firewall needs to replaced dummy2().
Or the other way around depending on the order of installation.

At the kernel level the API is actually simple. It's the pair of
target_prog_fd + btf_id I described earlier in "static/dynamic linking" thread.
Where target_prog_fd is FD of loaded into kernel rootlet and
btf_id is BTF id of dummy1 or dummy2.

When 1st firewall is being loaded libbpf needs to pass target_prog_fd+btf_id
along with xdp_prog1() into the kernel, so that the verifier can do
appropriate checking and refcnting.

Note that the kernel and every program have their own BTF id space.
Their own BTF ids == their own names.
Loading two programs with exactly the same name is ok today and in the future.
Linking into other program name space is where we need to agree on naming first.

The static linking of two .o should follow familiar user space linker logic.
Proposed bpf_linker__..("first.o") and bpf_linker__..("second.o") should work.
Meaning that "extern int foo()" in "second.o" will get resolved with "int foo()"
from "first.o".
Dynamic linking is when "first.o" with "int foo()" was already loaded into
the kernel and "second.o" is loaded after. In such case its "extern int foo()"
will be resolved dynamically from previously loaded program.
The user space analogy of this behavior is glibc.
"first.o" is glibc.so that supplies memcpy() and friends.
"second.o" is some a.out that used "extern int memcpy()".

For XDP rootlet case already loaded weak function dummy[12]() need to
be replaced later by xdp_prog[12](). It's like replacing memcpy() in glibc.so.
I think the user space doesn't have such concepts. I was simply calling it
dynamic linking too, but it's not quite accurate. It's dynamically replacing
already loaded functions. Let's call it "dynamic re-linking" ?

As far as libbpf api for dynamic linking, so far I didn't need to add new stuff.
I'm trying to piggy back on fexit/fentry approach.

I think to prototype re-linking without kernel support. We can do static re-linking.
I think the best approach is to stick with name based resolution. libxdp can do:
- add alias("dummy1") to xdp_prog1() in first_firewall.o
- rename foo() in first_firewall.o into unique_foo().
- add alias("dummy2") to xdp_prog2() in second_firewall.o
- rename foo() in second_firewall.o into very_unique_foo().
- use standard static linking of first_firewall.o + second_firewall.o + rootlet.o

The static re-linking is more work than dynamic re-linking because it needs to
operate in a single name space of final .o. Whereas dynamic re-linking has
individual name space for every loaded into kernel program.
I'm hoping to share a prototype of dynamic re-linking soon.
