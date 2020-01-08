Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D7B5134CC0
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 21:07:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727146AbgAHUHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 15:07:08 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:44576 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726445AbgAHUHB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 15:07:01 -0500
Received: by mail-pg1-f196.google.com with SMTP id x7so2061476pgl.11;
        Wed, 08 Jan 2020 12:07:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=YJoxGhpLW7J/4mYd9QsM4KrmhrJ1SO89mq6/x30EQ3Y=;
        b=K4CJl8Vmvjpyxf/AHOfY/HNtyLhh1i3XcAUu8kKg+Z3q+/z/p+DjvBZT6S+EfWhzkH
         TaN1fXxGPq4ljfI9PhzjdB8V19KgB5dLyyqhf+bR2JKlLQEB0EovIGSMYkyJwR0qc+Ij
         WL61ZUzblE77FpxYg3+dI5wz/iqv1dqFQHkllbLvDEp1p5Zt9CM3tOwP7hIsUBqlizvA
         eP0FRms6SvrcrApefzh4J7tTI5AgBpHjAVZCpyYZBPKT/shPmS7/T5mzOVeqGWlz1QP0
         qNvrs36zzFvam/4MEGcxecbORI45KXarSVWPOz1+fpPSzyYRdbizcd9QRuDODW9+JNsr
         HKlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=YJoxGhpLW7J/4mYd9QsM4KrmhrJ1SO89mq6/x30EQ3Y=;
        b=IoKXKSd8AP4tYYwRYBL2gsCz3HMgpcpd3JCgSn6fnBjTiZSQjo0dVGRMkA6QckVABE
         7jOZQm+zfbp9NkPneQtn8fvQbIbld4cmUhnXqYfFU5pNFvA+abTeR93ZnaJXUdEU5dnW
         3fSIFnpPHkecll7tNXsKBsuwe3dX9dBFyd4TOWe7acxtn0Ns54GWm14kLYmL7Jnq5hL4
         T2sQdkrTMYuBSsCaeFq42yIceLXGMChjmETS2GZ2Hv3w41wNTL0akLF4hlhnfb56H0Su
         kuhqPRymlPItu5fRGNDbzJ3qWq7mEWu38CVTxylycoAb/cD8qtbm4Q5nEzXZlIc/Oa6p
         H2wQ==
X-Gm-Message-State: APjAAAUFLaiVaQhcBbASGq/g49BZBLYJrQ/TxYe4xjrA5JbyQ8xYuws4
        z/o2QhA4AMMUWbInisz52K0=
X-Google-Smtp-Source: APXvYqyLGNHsMlB61XAyRq8+VnBeA7qBtwIsLfuOMbzdi1+9jKOKot7v7/DjzWN+RV510G5iNXqXOw==
X-Received: by 2002:a63:e4b:: with SMTP id 11mr7104079pgo.5.1578514019686;
        Wed, 08 Jan 2020 12:06:59 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:200::3:1e54])
        by smtp.gmail.com with ESMTPSA id d129sm4851284pfd.115.2020.01.08.12.06.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 Jan 2020 12:06:58 -0800 (PST)
Date:   Wed, 8 Jan 2020 12:06:56 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>, davem@davemloft.net,
        daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH bpf-next 3/6] bpf: Introduce function-by-function
 verification
Message-ID: <20200108200655.vfjqa7pq65f7evkq@ast-mbp>
References: <20200108072538.3359838-1-ast@kernel.org>
 <20200108072538.3359838-4-ast@kernel.org>
 <87y2uigs3e.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87y2uigs3e.fsf@toke.dk>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 08, 2020 at 11:28:21AM +0100, Toke Høiland-Jørgensen wrote:
> Alexei Starovoitov <ast@kernel.org> writes:
> 
> > New llvm and old llvm with libbpf help produce BTF that distinguish global and
> > static functions. Unlike arguments of static function the arguments of global
> > functions cannot be removed or optimized away by llvm. The compiler has to use
> > exactly the arguments specified in a function prototype. The argument type
> > information allows the verifier validate each global function independently.
> > For now only supported argument types are pointer to context and scalars. In
> > the future pointers to structures, sizes, pointer to packet data can be
> > supported as well. Consider the following example:
> >
> > static int f1(int ...)
> > {
> >   ...
> > }
> >
> > int f3(int b);
> >
> > int f2(int a)
> > {
> >   f1(a) + f3(a);
> > }
> >
> > int f3(int b)
> > {
> >   ...
> > }
> >
> > int main(...)
> > {
> >   f1(...) + f2(...) + f3(...);
> > }
> >
> > The verifier will start its safety checks from the first global function f2().
> > It will recursively descend into f1() because it's static. Then it will check
> > that arguments match for the f3() invocation inside f2(). It will not descend
> > into f3(). It will finish f2() that has to be successfully verified for all
> > possible values of 'a'. Then it will proceed with f3(). That function also has
> > to be safe for all possible values of 'b'. Then it will start subprog 0 (which
> > is main() function). It will recursively descend into f1() and will skip full
> > check of f2() and f3(), since they are global. The order of processing global
> > functions doesn't affect safety, since all global functions must be proven safe
> > based on their arguments only.
> >
> > Such function by function verification can drastically improve speed of the
> > verification and reduce complexity.
> >
> > Note that the stack limit of 512 still applies to the call chain regardless whether
> > functions were static or global. The nested level of 8 also still applies. The
> > same recursion prevention checks are in place as well.
> >
> > The type information and static/global kind is preserved after the verification
> > hence in the above example global function f2() and f3() can be replaced later
> > by equivalent functions with the same types that are loaded and verified later
> > without affecting safety of this main() program. Such replacement (re-linking)
> > of global functions is a subject of future patches.
> >
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> 
> Great to see this progressing; and thanks for breaking things up, makes
> it much easier to follow along!
> 
> One question:
> 
> > +enum btf_func_linkage {
> > +	BTF_FUNC_STATIC = 0,
> > +	BTF_FUNC_GLOBAL = 1,
> > +	BTF_FUNC_EXTERN = 2,
> > +};
> 
> What's supposed to happen with FUNC_EXTERN? That is specifically for the
> re-linking follow-up?

I was thinking to complete the whole thing with re-linking and then send it,
but llvm 10 feature cut off date is end of this week, so we have to land llvm
bits asap. I'd like to land patch 1 with libbpf sanitization first before
landing llvm. llvm release cadence is ~4 month and it would be sad to miss it.
Note we will be able to tweak encoding if really necessary after next week.
(BTF encoding gets fixed in ABI only after full kernel release).
It's unlikely though. I think the encoding is good. I've played with few
different variants and this one fits the best. FUNC_EXTERN encoding as 2 is
kinda obvious when encoding for global vs static is selected. The kernel and
libbpf will not be using FUNC_EXTERN yet, but llvm is tested to do the right
thing already, so I think it's fine to add it to btf.h now.

As far as future plans when libbpf sees FUNC_EXTERN it will do the linking the
way we discussed in the other thread. The kernel will support FUNC_EXTERN when
we introduce dynamic libraries. A collection of bpf functions will be loaded
into the kernel first (like libc.so) and later programs will have FUNC_EXTERN
as part of their BTF to be resolved while loading. The func name to btf_id
resolution will be done by libbpf. The kernel verifier will do the type
checking on BTFs. So the kernel side of FUNC_EXTERN support will be minimal,
but to your point below...

> This doesn't reject linkage==BTF_FUNC_EXTERN; so for this patch
> FUNC_EXTERN will be treated the same as FUNC_STATIC (it'll fail the
> is_global check below)? Or did I miss somewhere else where
> BTF_FUNC_EXTERN is rejected?

... is absolutely correct. My bad. Added this bit too soon.
Will remove. The kernel should accept FUNC_GLOBAL only in this patch set.
