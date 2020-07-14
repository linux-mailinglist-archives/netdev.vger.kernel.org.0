Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88D4B21ECC4
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 11:27:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbgGNJ1p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 05:27:45 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:34690 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726928AbgGNJ1k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 05:27:40 -0400
Received: by mail-ot1-f66.google.com with SMTP id e90so12567039ote.1;
        Tue, 14 Jul 2020 02:27:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BcBgAiY71PDQb9AkYuorOFzEG6DsDrsVIbYaSy+JPpU=;
        b=pDU7cxAc/8nVkIufip2sEC2iLfXpU+AebYUtWaIjKn0H4iq0NLO7N6MB0OcR9+kSha
         KY2zU8joPjZ2EKi0eYLTmo3ZeenCLr+AYFDMjL65EvmWaREKe+qhfbLeWxl17vWIVPCM
         tGAnMmQn39DcvDBWNMzSkKb2dGk7JbmLMU5uS8ggmlrcAYjOg7CVTGFWJRcKn2EjcpIV
         FJhSulPblSS14bH2a6IXyWD7TDb8BL967V7GPJeCpZUdcRSy3MnJbtkX8KAUelPDJzdZ
         IDZrh2UlEtFH2Fo+FwBxPZvyiti5IGgBYPDCsCHPYHRV0vb/ysm5yL6RlI7e4USxHy8i
         ouqA==
X-Gm-Message-State: AOAM530wME3BivjMGco+shebmbV/DUUFaVg48ToLehLsX8d9EOapnRGu
        86wSIXgt4oz0ZST/gAnVE1l8mK7ZsWjXQ93m7lI=
X-Google-Smtp-Source: ABdhPJyrhaG/SeR+X/25sxkP2ucHSApSaY4senOI3s6UTaENULowX/uuQANaV67djcwX6YA422EQ4z2isefIpnp0WQk=
X-Received: by 2002:a05:6830:1451:: with SMTP id w17mr3264761otp.250.1594718859452;
 Tue, 14 Jul 2020 02:27:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200714121608.58962d66@canb.auug.org.au> <20200714090048.GG183694@krava>
In-Reply-To: <20200714090048.GG183694@krava>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 14 Jul 2020 11:27:28 +0200
Message-ID: <CAMuHMdWznwG3dSFDM=iGX7OU9o95ChdnhbdJBZ27zFNQip8C3w@mail.gmail.com>
Subject: Re: linux-next: build warning after merge of the bpf-next tree
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 14, 2020 at 11:02 AM Jiri Olsa <jolsa@redhat.com> wrote:
> On Tue, Jul 14, 2020 at 12:16:08PM +1000, Stephen Rothwell wrote:
> > After merging the bpf-next tree, today's linux-next build (powerpc
> > ppc64_defconfig) produced this warning:
> >
> > ld: warning: orphan section `.BTF_ids' from `kernel/trace/bpf_trace.o' being placed in section `.BTF_ids'
> > ld: warning: orphan section `.BTF_ids' from `kernel/bpf/btf.o' being placed in section `.BTF_ids'
> > ld: warning: orphan section `.BTF_ids' from `kernel/bpf/stackmap.o' being placed in section `.BTF_ids'
> > ld: warning: orphan section `.BTF_ids' from `net/core/filter.o' being placed in section `.BTF_ids'
> > ld: warning: orphan section `.BTF_ids' from `kernel/trace/bpf_trace.o' being placed in section `.BTF_ids'
> > ld: warning: orphan section `.BTF_ids' from `kernel/bpf/btf.o' being placed in section `.BTF_ids'
> > ld: warning: orphan section `.BTF_ids' from `kernel/bpf/stackmap.o' being placed in section `.BTF_ids'
> > ld: warning: orphan section `.BTF_ids' from `net/core/filter.o' being placed in section `.BTF_ids'
> > ld: warning: orphan section `.BTF_ids' from `kernel/trace/bpf_trace.o' being placed in section `.BTF_ids'
> > ld: warning: orphan section `.BTF_ids' from `kernel/bpf/btf.o' being placed in section `.BTF_ids'
> > ld: warning: orphan section `.BTF_ids' from `kernel/bpf/stackmap.o' being placed in section `.BTF_ids'
> > ld: warning: orphan section `.BTF_ids' from `net/core/filter.o' being placed in section `.BTF_ids'
> >
> > Presumably ntroduced by the merge of the resolve_btfids branch.
>
> missing one more #ifdef.. chage below fixes it for me,
> it's squashed with the fix for the arm build, I'll post
> both fixes today

This one works for me, too:
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
