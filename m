Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B735FC539
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 12:21:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbfKNLVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 06:21:39 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:37346 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbfKNLVj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 06:21:39 -0500
Received: by mail-qk1-f195.google.com with SMTP id e187so4621170qkf.4;
        Thu, 14 Nov 2019 03:21:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qnir/943HdjW4FYs5LyFt4N8B6VgzgwDFUTMjClycUs=;
        b=mPnTQwcILp1UQ+qTwM0nZmxDfOd8srLvhdr15BNoD4gJVp8BxcUSq+wrjeQTIzQyFr
         I0eZwrKH+ezmgiPD8dxaL3gHf4fuzi+SwB+aaWlD9oz7p0XvaKdHYtnQWkc/Y785OozZ
         ZTkRwSk7jSTMm9fq0Bn/W8apRet+Q7Uv3ca33+nNOVhj8J6P9VZCv4sf+vUdOBYiKsKS
         EtSTJH+QjSAmxNQzKDSohYUofzGPmKJXDvOuqerGnEjq5223xeDTTXGe8xStYoiY6ktM
         GNKmxIOpKXf/qnhK9H7CKJ9I3AAa+6wwqJu4PRVSq+32LJPmzzO7uKovYsqs0jk1Pfnv
         dd0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qnir/943HdjW4FYs5LyFt4N8B6VgzgwDFUTMjClycUs=;
        b=uGQhJT4lr+HARGsrrOvlR9PkgmhmVatlsMh6UzVLgkH2dCzgeMJPGUM6iy7I/msoRr
         I7JOs8Vmhs3AIRbGuJFSIr9Ym4TpK8aiPyV0ApmM1qzEysZXQaa7plGdvonAoyWGWgHr
         U8krkyRRvO3Vjdu6FIxRSenE+HpAjod52XjTBHa499k1CcK0121b3WCt8z6HVfPtYC7+
         iWdWvAXF+0aJUkYYlg3KUy0VATGiJvJPeRnLZXakItlvfghHeh9I8ktDXtjMXOPxj7jh
         hPnT9D+NDHNy1ytQP2R8ykM6kAugI5ndc4b9N2YikPUzcQM+BmBBxchggWLqiKqpNNAK
         RvqQ==
X-Gm-Message-State: APjAAAXDa5+Uvd8Zzlo3GDze8JEQ1tVqgRuYy24nMUIpUGYnY+81s3UB
        xbZ99IbBesG3gSvvmU7YweQTiSfr+QqloxylsX0=
X-Google-Smtp-Source: APXvYqx3d3lBIGaVbPyR7iAQKABWY7/L0q8mcsVuss+UMgEUkM7BteiKN4N4BVzHZzJ13qaniCgvmVewkF29c/CpCpU=
X-Received: by 2002:a37:4146:: with SMTP id o67mr6849359qka.232.1573730498219;
 Thu, 14 Nov 2019 03:21:38 -0800 (PST)
MIME-Version: 1.0
References: <20191113204737.31623-1-bjorn.topel@gmail.com> <20191113204737.31623-3-bjorn.topel@gmail.com>
 <fa188bb2-6223-5aef-98e4-b5f7976ed485@solarflare.com> <CAJ+HfNiDa912Uwt41_KMv+Z-sGr8fU7s4ncBPiUSx4PPAMQQqQ@mail.gmail.com>
 <96811723-ab08-b987-78c7-2c9f2a0a972c@solarflare.com>
In-Reply-To: <96811723-ab08-b987-78c7-2c9f2a0a972c@solarflare.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Thu, 14 Nov 2019 12:21:27 +0100
Message-ID: <CAJ+HfNhaOj+V7JuLb-SCAMf=7BudcE-C4EZAQrzT6P_NGpwvsw@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 2/4] bpf: introduce BPF dispatcher
To:     Edward Cree <ecree@solarflare.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Nov 2019 at 11:19, Edward Cree <ecree@solarflare.com> wrote:
>
> On 14/11/2019 06:29, Bj=C3=B6rn T=C3=B6pel wrote:
[...]
> > My rationale was that this mechanism would almost exclusively be used
> > by physical HW NICs using XDP. My hunch was that the number of netdevs
> > would be ~4, and typically less using XDP, so a more sophisticated
> > mechanism didn't really make sense IMO.
> That seems reasonable in most cases, although I can imagine systems with
>  a couple of four-port boards being a thing.  I suppose the netdevs are
>  likely to all have the same XDP prog, though, and if I'm reading your
>  code right it seems they'd share a slot in that case.
>

Yup, correct!

> > However, your approach is more
> > generic and doesn't require any arch specific work. What was the push
> > back for your work?
> Mainly that I couldn't demonstrate a performance benefit from the few
>  call sites I annotated, and others working in the area felt that
>  manual annotation wouldn't scale =E2=80=94 Nadav Amit had a different ap=
proach
>  [2] that used a GCC plugin to apply a dispatcher on an opt-out basis
>  to all the indirect calls in the kernel; the discussion on that got
>  bogged down in interactions between text patching and perf tracing
>  which all went *waaaay* over my head.  AFAICT the static_call series I
>  was depending on never got merged, and I'm not sure if anyone's still
>  working on it.
>

Again, thanks for the pointers. PeterZ is (hopefully) still working on
the static_call stuff [3]. The static_call_inline would be a good fit
here, and maybe even using static_call as a patchpad/dispatcher like
you did is a better route. I will checkout Nadav's work!


Bj=C3=B6rn

[3] https://lore.kernel.org/lkml/20191007090225.44108711.6@infradead.org/#r

> -Ed
>
> [2] https://lkml.org/lkml/2018/12/31/19
