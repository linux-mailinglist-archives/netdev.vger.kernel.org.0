Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E964318B0
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 02:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbfFAAJx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 20:09:53 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:46151 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726842AbfFAAJx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 20:09:53 -0400
Received: by mail-lf1-f65.google.com with SMTP id l26so9241369lfh.13;
        Fri, 31 May 2019 17:09:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0O5y3zxJLjO+OFcgaKEEvfFc20FWAOhAiAEXszX5msk=;
        b=f5/IYJMd1LneyL+J8KijD7RhbM6Yv+/UjfPlJ+IyfR71JYrZTBHIcgcWhxj0ZuSFlf
         OauU4xnS3yObYtej+TYeCNAHUc0owB/GmIiqSBLtmyHob8WcFJCYzY0hQfgSN9BL2n5p
         v+lnk7bSk7FN1Qb9sPdaunp6cSpccBktCTJkRJAS+SIbDC2qXdTWi9waHRWvw2ygwVNq
         CKpkGopD9kC46BNoVHj3CrsEf3iMh6sLgkVk7DiFXGWSSRyMXnySyghedmX95SQ9bH/Y
         lIFXXm+3cSwEUKsCaPH4ApA8BwjqYp95fkGqEw0Rh4PuTj/3apztACv2b7RDKJyBN9xQ
         vt4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0O5y3zxJLjO+OFcgaKEEvfFc20FWAOhAiAEXszX5msk=;
        b=RZDXEXNaz4ZCZNcgwakqbQ7r4jDKY6QA0dm/eDU+N+s9ckP85l695CjhnAL9PicSPU
         L8hSUQf5cZ+kVh4ileXLd9KAM1x7LzVsI02X2brJyOsprqSL+jqiIiuNyfvQSUm6etzc
         ZqEHIeYYAY0iQQTUh6Gd1783KcOnuTfFHyD8QS55mbBG3Qo/kiR+etcoLyXKl+VWnMmG
         ngpuAU+9YtYw/UYgGL1Xgdpvg/HnOWkfum0Us0nlS2122zPqDGjcGvERRzXLy3kNbQdw
         qZUEBJmfsULZbwbJyEhQ3V6ZokjAL6naYymvDb4cPXXFJ/vMKqzY5EJXRAfH1SuU8a4+
         DAXA==
X-Gm-Message-State: APjAAAUSr7JgF+I0cPYpRhVrVQAEDaAIJBg1i65sF1VMHK4ISFZS7LuR
        KqzZaVHFzmDbeUAK5llIU4qDRTATNT+JPqGuQUY=
X-Google-Smtp-Source: APXvYqyU0iW+NSklLJf3qHZtRLKPHQxuDtnO3IWUd1+SsBVtZYgctk9VnfK45znYVuqr6WdQ3tVVp0jlNS88Khwb+FQ=
X-Received: by 2002:ac2:5337:: with SMTP id f23mr7428221lfh.15.1559347790765;
 Fri, 31 May 2019 17:09:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190530222922.4269-1-luke.r.nels@gmail.com> <mhng-b4ce883e-9ec7-4098-9acc-18eb140f93e0@palmer-si-x1c4>
In-Reply-To: <mhng-b4ce883e-9ec7-4098-9acc-18eb140f93e0@palmer-si-x1c4>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 31 May 2019 17:09:39 -0700
Message-ID: <CAADnVQJspryT=Dvkh3vyyPv1air+Gfk61=uwWwgtD1sZb5PdnA@mail.gmail.com>
Subject: Re: [PATCH bpf v2] bpf, riscv: clear high 32 bits for ALU32 add/sub/neg/lsh/rsh/arsh
To:     Palmer Dabbelt <palmer@sifive.com>
Cc:     luke.r.nels@gmail.com, Xi Wang <xi.wang@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        aou@eecs.berkeley.edu, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-riscv@lists.infradead.org, bpf <bpf@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 1:40 PM Palmer Dabbelt <palmer@sifive.com> wrote:
>
> On Thu, 30 May 2019 15:29:22 PDT (-0700), luke.r.nels@gmail.com wrote:
> > In BPF, 32-bit ALU operations should zero-extend their results into
> > the 64-bit registers.
> >
> > The current BPF JIT on RISC-V emits incorrect instructions that perform
> > sign extension only (e.g., addw, subw) on 32-bit add, sub, lsh, rsh,
> > arsh, and neg. This behavior diverges from the interpreter and JITs
> > for other architectures.
> >
> > This patch fixes the bugs by performing zero extension on the destination
> > register of 32-bit ALU operations.
> >
> > Fixes: 2353ecc6f91f ("bpf, riscv: add BPF JIT for RV64G")
> > Cc: Xi Wang <xi.wang@gmail.com>
> > Signed-off-by: Luke Nelson <luke.r.nels@gmail.com>
>
> Reviewed-by: Palmer Dabbelt <palmer@sifive.com>
>
> Thanks!  I'm assuming this is going in through a BPF tree and not the RISC-V
> tree, but LMK if that's not the case.

Applied to bpf tree. Thanks
