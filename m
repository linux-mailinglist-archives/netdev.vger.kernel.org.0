Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E4BAD1556
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 19:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731636AbfJIRRe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 13:17:34 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:33191 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731173AbfJIRRe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 13:17:34 -0400
Received: by mail-lj1-f193.google.com with SMTP id a22so3338924ljd.0;
        Wed, 09 Oct 2019 10:17:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vhiLtiukz2hVwqP7K2PZG/TJ72MYbyncaVQFbl8osGQ=;
        b=XGhfeNtWqI3ovHwSwglD4GksloCd1qXhuXBEEvb+eo6sqbtbxglOC/2GOidobIwg4e
         A7Efwcc4LWA7IfAOV3IIOMAV+hdJwLnaBnlXnFZ2jMggTeZVHPt6++n0BSx9JGm+JOpB
         U83BnMz7zNu8UBFQvcxRjP0gSIyi4XAx1oqwq1DTQStQ54LagvDqgxTTb7MpZsmYabR0
         TCt/BkVH5NwRteliO5akQrwymsPLf6z60nIaKIQVZWIPWqdgGwixJ5ubsFGIRIWKqcuc
         IGMgPDEGpZnHo5bqPwXzDuK6K7QqVNvWIYBhCSydzRgErs1OX95aEExHuSxywuZRmIIu
         0dtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vhiLtiukz2hVwqP7K2PZG/TJ72MYbyncaVQFbl8osGQ=;
        b=MMynM1I0hAUj9KDzUleZgPRj/mwgWYSDJT0jnpt5YLZYrmgT2YIOGqJRUtt0kGula+
         aN8D6E4QbNAZO4ipka5v+QOrlb23IdjHZeBTWRhJhqkh8xGeRo01+kN9+7gMzewxPnye
         yD+D7iTAlr5ExTfsyf53ADYhSXQ0X/cYnIot2lL3G3Bv0aber74RKWAf1tqBv/RBftar
         kyFOVOsORVrDqzROYw5lWyOyKV0mGZIP3xMB8p6Yfid355VT8un46tldMgv91gNvorlI
         tc6pyCb60id/TlHlQHwdRslMua6Wt1Al+/aMlGiCAf5R8tUpZVSZnDq8FMx2hmQW+nM5
         uerg==
X-Gm-Message-State: APjAAAXR2cbHjqfIo9DwL0mRBfeXeysEx81Wx7WEWbFBeZKtZeFe+qK0
        FxEx8a7tdR/v0ZacBTCetSZTmnMvEBe1E9OjWbgrQw==
X-Google-Smtp-Source: APXvYqzhSENkcnxwh1Kd2Bj7uvGmEOvU8JT77Zb/Xj5kbY+jrLI6MO3o+x+b41OsrXpRUuEMkvogdcgZGtR040L5mKQ=
X-Received: by 2002:a2e:9cc9:: with SMTP id g9mr2985658ljj.188.1570641451645;
 Wed, 09 Oct 2019 10:17:31 -0700 (PDT)
MIME-Version: 1.0
References: <1570515415-45593-1-git-send-email-sridhar.samudrala@intel.com>
 <1570515415-45593-3-git-send-email-sridhar.samudrala@intel.com>
 <CAADnVQ+XxmvY0cs8MYriMMd7=2TSEm4zCtB+fs2vkwdUY6UgAQ@mail.gmail.com>
 <3ED8E928C4210A4289A677D2FEB48235140134CE@fmsmsx111.amr.corp.intel.com> <2bc26acd-170d-634e-c066-71557b2b3e4f@intel.com>
In-Reply-To: <2bc26acd-170d-634e-c066-71557b2b3e4f@intel.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 9 Oct 2019 10:17:19 -0700
Message-ID: <CAADnVQ+qq6RLMjh5bB1ugXP5p7vYM2F1fLGFQ2pL=2vhCLiBdA@mail.gmail.com>
Subject: Re: FW: [PATCH bpf-next 2/4] xsk: allow AF_XDP sockets to receive
 packets directly from a queue
To:     "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Netdev <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "Herbert, Tom" <tom.herbert@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 9, 2019 at 9:53 AM Samudrala, Sridhar
<sridhar.samudrala@intel.com> wrote:
>
>
> >> +
> >> +u32 bpf_direct_xsk(const struct bpf_prog *prog, struct xdp_buff *xdp)
> >> +{
> >> +       struct xdp_sock *xsk;
> >> +
> >> +       xsk = xdp_get_xsk_from_qid(xdp->rxq->dev, xdp->rxq->queue_index);
> >> +       if (xsk) {
> >> +               struct bpf_redirect_info *ri =
> >> + this_cpu_ptr(&bpf_redirect_info);
> >> +
> >> +               ri->xsk = xsk;
> >> +               return XDP_REDIRECT;
> >> +       }
> >> +
> >> +       return XDP_PASS;
> >> +}
> >> +EXPORT_SYMBOL(bpf_direct_xsk);
> >
> > So you're saying there is a:
> > """
> > xdpsock rxdrop 1 core (both app and queue's irq pinned to the same core)
> >     default : taskset -c 1 ./xdpsock -i enp66s0f0 -r -q 1
> >     direct-xsk :taskset -c 1 ./xdpsock -i enp66s0f0 -r -q 1 6.1x improvement in drop rate """
> >
> > 6.1x gain running above C code vs exactly equivalent BPF code?
> > How is that possible?
>
> It seems to be due to the overhead of __bpf_prog_run on older processors
> (Ivybridge). The overhead is smaller on newer processors, but even on
> skylake i see around 1.5x improvement.
>
> perf report with default xdpsock
> ================================
> Samples: 2K of event 'cycles:ppp', Event count (approx.): 8437658090
> Overhead  Command          Shared Object     Symbol
>    34.57%  xdpsock          xdpsock           [.] main
>    17.19%  ksoftirqd/1      [kernel.vmlinux]  [k] ___bpf_prog_run
>    13.12%  xdpsock          [kernel.vmlinux]  [k] ___bpf_prog_run

That must be a bad joke.
The whole patch set is based on comparing native code to interpreter?!
It's pretty awesome that interpreter is only 1.5x slower than native x86.
Just turn the JIT on.

Obvious Nack to the patch set.
