Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80E1A11DF60
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 09:23:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbfLMIXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 03:23:19 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:41032 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725468AbfLMIXT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 03:23:19 -0500
Received: by mail-qk1-f196.google.com with SMTP id l124so1061899qkf.8;
        Fri, 13 Dec 2019 00:23:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Vdv7yq4/4gppqbQW+Pz5XTJCN0SOeSsSHlkojBBgHEc=;
        b=U2T/liBmif3CpF4oH7BlJzAA8xYiYVr/Jk37Xp+c7Mi29LAGoE9hbceiqRv2BxRz2Q
         6kF81/g6lFjLzwJCVWCDhxY+WuBfo/w6VC8sMtRwCj2Vgu8/tfXMFxNJ+7EqMRlRfxSZ
         sDb4EgULNGg3uz4VKUuumEugOlky6bHVVYWLMAD8PxHz0/yx3pPtZRqtnW79Z3in1tTJ
         hvlQAG07zAJLAax+00nYng9ZF3TjLpVYvBB79PebwXCeLTwjxppTg4DLvrKgkaV//1NJ
         nvB74pUfsM03ljyaqdxrMrhrjkx77g6CoSUHEeSQLrvnoa24akGSDml5vv8sWiFYZont
         L9Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Vdv7yq4/4gppqbQW+Pz5XTJCN0SOeSsSHlkojBBgHEc=;
        b=e8PxVTkLYhinkK4WIE/LjToq6wH864iXdHpsE0QvGo1A/BRfVTIj6XwotBH+6jhw45
         b/MfAQ5+Mb8uM2JN1bd2hoSA2DEZy7knUfpAOX+nacXg0vKE6pLAEYx7YycXz6WSEYsE
         w6KsLyfytH3ZqFBG6JhFZPx7LLl64EOS1A/s5vImOtzIbTY17CULXNistNXqtv6VzVxy
         d+ZZskr7QBHlM0BdqQPhAT7ZpOC/Vs6X5/FX1AbDCxdkBQI/f3apd/c8lQOGrbJncsOB
         DooBVjrbRtksIsQu2/oqJoQWHS7XTFwcvGDOoPk9GqTfUEtwB4bba7VF7ggrPqRs560P
         Q3tA==
X-Gm-Message-State: APjAAAVbA8rxrLJ1vQAAVjGAprvZ3QLT6f8pokHQKwmclu9I2dSh54g4
        736B2nswOcwXcT7/AO57NJCI7oanKP2Zm/vg9mA=
X-Google-Smtp-Source: APXvYqwsd/+uCs2VNSn316jr74JkB8IcOcfWDGLmdlZvAG7/8q8R+vXnxn04wGvyujhZRGSVxEdT31w/Z9gC4Phi0xc=
X-Received: by 2002:ae9:ee11:: with SMTP id i17mr12319728qkg.333.1576225397800;
 Fri, 13 Dec 2019 00:23:17 -0800 (PST)
MIME-Version: 1.0
References: <20191211123017.13212-1-bjorn.topel@gmail.com> <20191211123017.13212-3-bjorn.topel@gmail.com>
 <87wob3f0xd.fsf@toke.dk>
In-Reply-To: <87wob3f0xd.fsf@toke.dk>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Fri, 13 Dec 2019 09:23:06 +0100
Message-ID: <CAJ+HfNjZL9CAEOqoUX5E1Os_gNw7DcGg=TXou93d3aVovEffcA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 2/6] bpf: introduce BPF dispatcher
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Edward Cree <ecree@solarflare.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <thoiland@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Dec 2019 at 14:26, Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat=
.com> wrote:
>
> [...]
> > +/* The BPF dispatcher is a multiway branch code generator. The
> > + * dispatcher is a mechanism to avoid the performance penalty of an
> > + * indirect call, which is expensive when retpolines are enabled. A
> > + * dispatch client registers a BPF program into the dispatcher, and if
> > + * there is available room in the dispatcher a direct call to the BPF
> > + * program will be generated. All calls to the BPF programs called via
> > + * the dispatcher will then be a direct call, instead of an
> > + * indirect. The dispatcher hijacks a trampoline function it via the
> > + * __fentry__ of the trampoline. The trampoline function has the
> > + * following signature:
> > + *
> > + * unsigned int trampoline(const void *xdp_ctx,
> > + *                         const struct bpf_insn *insnsi,
> > + *                         unsigned int (*bpf_func)(const void *,
> > + *                                                  const struct bpf_i=
nsn *));
> > + */
>
> Nit: s/xdp_ctx/ctx/
>

Thanks! Same type-o in the DEFINE/DECLARE macros. Will fix in v5.


Bj=C3=B6rn


> -Toke
>
