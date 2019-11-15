Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75BFDFD76F
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 08:57:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbfKOH5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 02:57:12 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:41957 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726182AbfKOH5L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 02:57:11 -0500
Received: by mail-qk1-f194.google.com with SMTP id m125so7403391qkd.8;
        Thu, 14 Nov 2019 23:57:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=F+aS45e+tp3qf3Ydob9f2pyeaLNqmi833pMJJ3DlQVk=;
        b=DAjX27o5q96qF83it+oHtsrQatRWEZg/Qv3scklzjxT4QRhfDPT9JYZhm9I6+5gCZC
         yCFqgq2SR2sFuMFzSyfgH7AxhdvpCgZbYruNgmiQ/AUitkwkwZNguD2fVaZS28Rg/vqQ
         LLhGugqK7wDLNKUrZ4rNme4PyTdAtAjU6cbmTweW14aaJ0ieL7yuxcZjjhwe+hi7Mvhm
         zqR2iFsyMh1DFbEppfO2GQitQ8FyT9T9pkVpP8CDhi2+Tg7v9GL77f6NUla2bePTykBJ
         UIQSTy5TD8UsOenYTpNWcgkc4oKw+Y+WSRr5WXRNHcWH9o8MUVI6IRn1MNHtL441xXG9
         qVvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=F+aS45e+tp3qf3Ydob9f2pyeaLNqmi833pMJJ3DlQVk=;
        b=KWfCijm8HsPp3pKotbScQXfBX4g4ci0+FkEkqmZ5pS5TWPBqYlEiOeu9HOJy4O4Oka
         4rYUBRoL+cvqcC0j2VrjTINts7frLTB2Evn9/oAfjhoW0HmsBBXzv5NFx7svELxgKCda
         NMzruI3L4yEV4sMRE+Dj6i/a9iyKttyBmRcqEHJRya6rvtXS9ET0cw61fLw0wJicZLX2
         gxTsKrDH44Qo0G3t6vNofti/9Rd2TAkPcceZhb7Jwwhyn1n2+Omz+eGeSHsT8ipmFeMV
         SOCX/pBrGiVlm4hqNObURLSDTVMXDhKBS3ZiVBI0dkyTTXbP4tkvSMFi/a1lQy9Mol+l
         NkTQ==
X-Gm-Message-State: APjAAAUjMMv59nl4CzY547hAG7224JHiJ4yQHInaaWrxop5p5JHQsNEF
        +UDlqL9JZWSg4lDA4+dmQesKkzCddci2xw1+G+s=
X-Google-Smtp-Source: APXvYqx2N5FsU1ezDf2HNNL2a1lzjMS2gkxoqVlUgcCHLWwEf+2QsbwNK84VzVRj74ygDDE7Nm+NkoUwWk5Oq8Pu+OY=
X-Received: by 2002:a05:620a:113b:: with SMTP id p27mr11492421qkk.333.1573804630673;
 Thu, 14 Nov 2019 23:57:10 -0800 (PST)
MIME-Version: 1.0
References: <20191113204737.31623-1-bjorn.topel@gmail.com> <20191113204737.31623-3-bjorn.topel@gmail.com>
 <20191115003024.h7eg2kbve23jmzqn@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20191115003024.h7eg2kbve23jmzqn@ast-mbp.dhcp.thefacebook.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Fri, 15 Nov 2019 08:56:59 +0100
Message-ID: <CAJ+HfNhKWND35Jnwe=99=8rWt81fhy9pRpXCVRYTu=C=aj13KQ@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 2/4] bpf: introduce BPF dispatcher
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Edward Cree <ecree@solarflare.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 Nov 2019 at 01:30, Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
[...]
>
> Could you try optimizing emit_mov_imm64() to recognize s32 ?
> iirc there was a single x86 insns that could move and sign extend.
> That should cut down on bytecode size and probably make things a bit fast=
er?
> Another alternative is compare lower 32-bit only, since on x86-64 upper 3=
2
> should be ~0 anyway for bpf prog pointers.

Good ideas, thanks! I'll do the optimization, extend it to >4 entries
(as Toke suggested), and do a non-RFC respin.

> Looking at bookkeeping code, I think I should be able to generalize bpf
> trampoline a bit and share the code for bpf dispatch.

Ok, good!

> Could you also try aligning jmp target a bit by inserting nops?
> Some x86 cpus are sensitive to jmp target alignment. Even without conside=
ring
> JCC bug it could be helpful. Especially since we're talking about XDP/AF_=
XDP
> here that will be pushing millions of calls through bpf dispatch.
>

Yeah, I need to address the Jcc bug anyway, so that makes sense.

Another thought; I'm using the fentry nop as patch point, so it wont
play nice with other users of fentry atm -- but the plan is to move to
Steve's *_ftrace_direct work at some point, correct?


Bj=C3=B6rn
