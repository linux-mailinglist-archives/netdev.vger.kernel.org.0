Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7FEB143C4E
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 12:50:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729159AbgAULug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 06:50:36 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:37649 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726052AbgAULuf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 06:50:35 -0500
Received: by mail-qt1-f196.google.com with SMTP id w47so2330673qtk.4;
        Tue, 21 Jan 2020 03:50:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=EykHDyTMZ2RRTxjQnla0rNRTWuTEDOFAlnAnxCmjW0g=;
        b=MByAES9ivUVT1Ta+W3hzl0S11R/cGn36zYGQxj2Cl8VPGV4hEl4ai5Nxrd84Vqc+cB
         jRLtTG6W2kjlvLkS0cgOzirenm1I5xVPbHM18WlLsrfZ0scTeVFmXC8fzCk98LsLVBzs
         PjJIeanBEe1zjqAa+nvEapEJZdqIQspP37nbDJA1L0rSniW5TIb/gqdVDpEyygnTAGVq
         9mnzvGI7iaIRTdZPiV/QVGmGjdODTFCIGvA+0KwVwLlWCsQp2tTVyoEi0gJVPDKVHpLQ
         vhzC5GnLHugHkeO5rTq2AOW0A9oAHd4aTh/ORya5L+t4Nn/usjCKEJ+h2uNpICRkjH8/
         yzNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=EykHDyTMZ2RRTxjQnla0rNRTWuTEDOFAlnAnxCmjW0g=;
        b=M0MgJmv5iHg9xM5bVSmnzfDa519+hsXrtIdpxfTVJN33WmQcDLF2hxen2zo5OGjaef
         16w7LqGME90w9mACQCLNmqEDXkexjMc9/+Wy6IjYKwtBtHePe2LILJkchE4mCcembb6+
         Zv7IhSaSndFXjcNOkpiMkV0Ul3L6urnkDB/LIbDB1sj1E/iT6MUo+jkjsDgw5Sl5IlWD
         mSVbOXyQmEK6NG3I1QFbfBq2Bu7h57a3+HTBU5dzm7QRTTVsM1h58hpAr1dzk8ErTi2W
         RK631reVLL4cOFrWyZzPC2qmnO/mzasCgqAbTV77L8xahhBCyJUJXIY+S2T21Yy9OsRv
         8kVQ==
X-Gm-Message-State: APjAAAXma916hnNYvQx1fS3nXLq04xrL5LXcTugVPcSMoOk8pno7cnhZ
        PjH31fzTOEWe6VtXmmS2juwcjQpNzugSl/HSJvY=
X-Google-Smtp-Source: APXvYqwVdXAYWaERzBlYLX/n/QG79vTGd8ZFu5hS6YGaEpm+ljnpLu7940DZXEDPdxB6wxVp7Jn8b8mFmYhMPeDyV2k=
X-Received: by 2002:ac8:33a5:: with SMTP id c34mr4017257qtb.359.1579607434836;
 Tue, 21 Jan 2020 03:50:34 -0800 (PST)
MIME-Version: 1.0
References: <20200120092149.13775-1-bjorn.topel@gmail.com> <28b2b6ba-7f43-6cab-9b3a-174fc71d5a62@iogearbox.net>
In-Reply-To: <28b2b6ba-7f43-6cab-9b3a-174fc71d5a62@iogearbox.net>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Tue, 21 Jan 2020 12:50:23 +0100
Message-ID: <CAJ+HfNj6dWLgODuHN82H5pXZgzYjx3cLi5WvGSoMg57TgYuRbg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] xsk: update rings for load-acquire/store-release semantics
To:     Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        mark.rutland@arm.com, will@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Jan 2020 at 00:51, Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 1/20/20 10:21 AM, Bj=C3=B6rn T=C3=B6pel wrote:
> > From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
> >
> > Currently, the AF_XDP rings uses fences for the kernel-side
> > produce/consume functions. By updating rings for
> > load-acquire/store-release semantics, the full barrier (smp_mb()) on
> > the consumer side can be replaced.
> >
> > Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>
> If I'm not missing something from the ring update scheme, don't you also =
need
> to adapt to STORE.rel ->producer with matching barrier in tools/lib/bpf/x=
sk.h ?
>

Daniel/John,

Hmm, I was under the impression that *wasn't* the case. Quoting
memory-barriers.txt:

--8<--
When dealing with CPU-CPU interactions, certain types of memory
barrier should always be paired.  A lack of appropriate pairing is
almost certainly an error.

General barriers pair with each other, though they also pair with most
other types of barriers, albeit without multicopy atomicity.  An
acquire barrier pairs with a release barrier, but both may also pair
with other barriers, including of course general barriers.  A write
barrier pairs with a data dependency barrier, a control dependency, an
acquire barrier, a release barrier, a read barrier, or a general
barrier.  Similarly a read barrier, control dependency, or a data
dependency barrier pairs with a write barrier, an acquire barrier, a
release barrier, or a general barrier:
-->8--

(The usual "I'm not an expert, just quoting memory-barriers.txt"
disclaimer applies...)

In libbpf, we already have a "weaker" barrier (libbpf_smp_rwmb()). See
commit 2c5935f1b2b6 ("libbpf: optimize barrier for XDP socket rings")
for more information.

I agree that at some point ld.acq/st.rel barriers should be adopted in
libbpf at some point, but not that it's broken now. Then again,
reading Will's (Cc'd) perf-ring comment here [1], makes me a bit
uneasy even though he says "theoretical". ;-)

> Btw, alternative model could also be 09d62154f613 ("tools, perf: add and =
use
> optimized ring_buffer_{read_head, write_tail} helpers") for the kernel si=
de
> in order to get rid of the smp_mb() on x86.
>

Interesting! I'll have a look!

[1] https://lore.kernel.org/lkml/20180523164234.GJ2983@arm.com/
