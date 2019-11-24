Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC365108266
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 07:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbfKXG5D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Nov 2019 01:57:03 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:40072 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725813AbfKXG5D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Nov 2019 01:57:03 -0500
Received: by mail-qt1-f193.google.com with SMTP id o49so13304426qta.7;
        Sat, 23 Nov 2019 22:57:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=m0ZMIuqsDxvWocBmmDPoQioMNJyQZ4OBEUXhBq5TD8o=;
        b=mz8iDvzSf/SUyzfT2jKaRFQwPu02KcGh13WD18Z2t3PrbXegq53KHpBFkPozEs3xVl
         31O48HdacOMXlCKjviktc0YfaSYIuOd987tKh6Yq8NiUxyFKBFp4p1yEYAqztSHNIDK5
         Mu7DLIoEgLEkqq7awEM+hszacANg4ePsKQVCtsQnuBqaN3VhCEdf57J2qc1bp7e9VydO
         uOPdGnX3E/8BomAkndDCNvIU0XT+mK4BjEwBfCRz6wAm1oc+9EuWmCMn5dX5vhN3BgRw
         zye6PA9X26rLZOsfHsWNNio/PxfYxNmgA1U9U2rdj1DHTIjPxO/lIb+rWKSKfHDDnfhu
         aeAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=m0ZMIuqsDxvWocBmmDPoQioMNJyQZ4OBEUXhBq5TD8o=;
        b=P/mjhmO8UJBVPVo2vSqGAYu4KPTAApD9wwDy1V7ac5cUB6ggkAhiBOkEwAXATFfmQI
         ZDkqdIGf9ZNYvOaWAe4q/V0Vtmvq9ggtpnKYnmT0IEz8fDbMAZmmnjr7Pgp1S1TyZFCN
         1Fgqpgf0ycnbf1VreuFOOAEe8kmOYeIAiQV6xWIZZJMekbh3rg/MCAYSlf8buHez2lO4
         UjLku1F8bmcbM96kd0vz2Hl4PlO5AXdc3Ilv/sIJgMDfqujZprEzQvJiDbEaO/samVA2
         Ezr3dRvFiGEs8rCkoOou+BOrae3YC+iiYdMaC75p/hd1yq56I84EbdW223zZsWUrZ1bH
         L+Ew==
X-Gm-Message-State: APjAAAUfsh5TmVhXgjENJrmGEGCmfOppEGhohyfrR1qmjANSHmoGp+uZ
        053MseCVs3HeIviv0NamQoWRmP/eHoxLsc6Mt3s=
X-Google-Smtp-Source: APXvYqyZ8d88+o9broKjsgOLO1tKAiyebzF3PdSd0ysiHAL2B3mpqaunzltZ/NY8GODEVLZjgN9g3hklTHGzwsfLZWg=
X-Received: by 2002:ac8:1bed:: with SMTP id m42mr6365074qtk.359.1574578620470;
 Sat, 23 Nov 2019 22:57:00 -0800 (PST)
MIME-Version: 1.0
References: <20191123071226.6501-1-bjorn.topel@gmail.com> <20191123071226.6501-3-bjorn.topel@gmail.com>
 <20191124015907.fdqr2v2jymewjesd@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20191124015907.fdqr2v2jymewjesd@ast-mbp.dhcp.thefacebook.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Sun, 24 Nov 2019 07:56:49 +0100
Message-ID: <CAJ+HfNjQpzdubbZL+4Yty6oQ+or9rHK_BAuc=CFMD-j3taEznQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 2/6] xdp: introduce xdp_call
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
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
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 24 Nov 2019 at 02:59, Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Sat, Nov 23, 2019 at 08:12:21AM +0100, Bj=C3=B6rn T=C3=B6pel wrote:
> > From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> >
> > The xdp_call.h header wraps a more user-friendly API around the BPF
> > dispatcher. A user adds a trampoline/XDP caller using the
> > DEFINE_XDP_CALL macro, and updates the BPF dispatcher via
> > xdp_call_update(). The actual dispatch is done via xdp_call().
> >
> > Note that xdp_call() is only supported for builtin drivers. Module
> > builds will fallback to bpf_prog_run_xdp().
> >
> > The next patch will show-case how the i40e driver uses xdp_call.
> >
> > Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> > ---
> >  include/linux/xdp_call.h | 66 ++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 66 insertions(+)
> >  create mode 100644 include/linux/xdp_call.h
> >
> > diff --git a/include/linux/xdp_call.h b/include/linux/xdp_call.h
> > new file mode 100644
> > index 000000000000..69b2d325a787
> > --- /dev/null
> > +++ b/include/linux/xdp_call.h
> > @@ -0,0 +1,66 @@
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +/* Copyright(c) 2019 Intel Corporation. */
> > +#ifndef _LINUX_XDP_CALL_H
> > +#define _LINUX_XDP_CALL_H
> > +
> > +#include <linux/filter.h>
> > +
> > +#if defined(CONFIG_BPF_JIT) && defined(CONFIG_RETPOLINE) && !defined(M=
ODULE)
> > +
> > +void bpf_dispatcher_change_prog(void *func, struct bpf_prog *from,
> > +                             struct bpf_prog *to);
> > +
> > +#define XDP_CALL_TRAMP(name) ____xdp_call_##name##_tramp
> > +
> > +#define DEFINE_XDP_CALL(name)                                         =
       \
> > +     unsigned int XDP_CALL_TRAMP(name)(                              \
> > +             const void *xdp_ctx,                                    \
> > +             const struct bpf_insn *insnsi,                          \
> > +             unsigned int (*bpf_func)(const void *,                  \
> > +                                      const struct bpf_insn *))      \
> > +     {                                                               \
> > +             return bpf_func(xdp_ctx, insnsi);                       \
> > +     }
> > +
> > +#define DECLARE_XDP_CALL(name)                                        =
       \
> > +     unsigned int XDP_CALL_TRAMP(name)(                              \
> > +             const void *xdp_ctx,                                    \
> > +             const struct bpf_insn *insnsi,                          \
> > +             unsigned int (*bpf_func)(const void *,                  \
> > +                                      const struct bpf_insn *))
> > +
> > +#define xdp_call_run(name, prog, ctx) ({                             \
> > +     u32 ret;                                                        \
> > +     cant_sleep();                                                   \
> > +     if (static_branch_unlikely(&bpf_stats_enabled_key)) {           \
> > +             struct bpf_prog_stats *stats;                           \
> > +             u64 start =3D sched_clock();                             =
 \
> > +             ret =3D XDP_CALL_TRAMP(name)(ctx,                        =
 \
> > +                                        (prog)->insnsi,              \
> > +                                        (prog)->bpf_func);           \
> > +             stats =3D this_cpu_ptr((prog)->aux->stats);              =
 \
> > +             u64_stats_update_begin(&stats->syncp);                  \
> > +             stats->cnt++;                                           \
> > +             stats->nsecs +=3D sched_clock() - start;                 =
 \
> > +             u64_stats_update_end(&stats->syncp);                    \
> > +     } else {                                                        \
> > +             ret =3D XDP_CALL_TRAMP(name)(ctx,                        =
 \
> > +                                        (prog)->insnsi,              \
> > +                                        (prog)->bpf_func);           \
> > +     }                                                               \
> > +     ret; })
>
> I cannot help but wonder whether it's possible to avoid copy-paste from
> BPF_PROG_RUN().
> At least could you place this new macro right next to BPF_PROG_RUN?
> If it's in a different file eventually they may diverge.
>

Yeah, I'll take a stab at that!


Thanks,
Bj=C3=B6rn
