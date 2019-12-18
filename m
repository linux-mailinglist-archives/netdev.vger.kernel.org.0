Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E35C123B59
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 01:08:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbfLRAIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 19:08:55 -0500
Received: from mail-qv1-f65.google.com ([209.85.219.65]:46510 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726072AbfLRAIy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 19:08:54 -0500
Received: by mail-qv1-f65.google.com with SMTP id t9so16594qvh.13;
        Tue, 17 Dec 2019 16:08:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oK4nV+3VPMZcYLPAG8D2X7eS3apOnuJLGFzeKqqC1Lg=;
        b=Ua8HqqZuApHD4UiYR0o/cHGxjgMpEMsDplERFp1pDkBHHlzBM8p5lOwbVGJwSB2gli
         A+Gn3lV7xTTuxqbceG4VX/6CGnsqZ10yvkXtYad5UFKls7txm1aa7nHYAFQfSE0ovbnt
         UKpo5x84j50JZnSnLMV720p98JDcbldhiB55ufNzvePVILucvQk4BTtSXjtO8j+82ujw
         MWJ9kDKmlCrNG6zDZz1wMp5m3qFJwm4R4IuPfJ/5smDO84ui6JCizHfsdBYquzYtPieM
         j2VRw/vfO04V8jGyGYnYaWMOOxSug8tbtTbl9cnIDBWPCyvTDKpNLe+pUUXnuXYexQ1V
         JmOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oK4nV+3VPMZcYLPAG8D2X7eS3apOnuJLGFzeKqqC1Lg=;
        b=TXhuiHMGZmkJ1yfDPC9hQfCPd9j0BTU/y5u2Mbl2ypZswodq2SNXjJT/p5C1qDjttF
         bosjeZFebfSJC6+emKUiz/Weum9Vij6SU58+CXF/bZl+YM42sVNQsk75nDu8zfc6L9sl
         SsDNwSTdXiMfcpEKWQyMYvkmPiPO8r4zcBbCWWBs0qWdj1olJfjRqCeXeioLXn4D9+9+
         8GSBZ/hLDg220SHa9S+dWs0bc02IWbwNcKDCdHNOyumqN1GGOd2pvdn5MOKHpT9mZEEG
         fVBG2M05gDFaes2yBxs5wVs6HPmVKsoe1vAqIS3KfK/8ttLZ/56lWa9XYFpSWW0uofI0
         eaMQ==
X-Gm-Message-State: APjAAAV7RlpIKbrY9FEKm5l4MGQGk3QG8XFBAJTFNs6+/EYQd71moVo+
        rQVcj+LrqOW8NvqLt4V9llvapPchMX0ng9eJA7g=
X-Google-Smtp-Source: APXvYqyh9ao9RrcrumMwY3aliImlVyJ0dXaeaU23xpDr7IaKwC61B7tpiMAWX7w4RgRRUYMXkG9Xsf/kGQ7HQwHaukQ=
X-Received: by 2002:ad4:4e34:: with SMTP id dm20mr400160qvb.163.1576627733679;
 Tue, 17 Dec 2019 16:08:53 -0800 (PST)
MIME-Version: 1.0
References: <20191214014710.3449601-1-andriin@fb.com> <20191214014710.3449601-3-andriin@fb.com>
 <20191216111736.GA14887@linux.fritz.box> <CAEf4Bzbx+2Fot9NYzGJS-pUF5x5zvcfBnb7fcO_s9_gCQQVuLg@mail.gmail.com>
 <7bf339cf-c746-a780-3117-3348fb5997f1@iogearbox.net> <CAEf4BzYAWknN1HGHd0vREtQLHU-z3iTLJWBteRK6q7zkhySBBg@mail.gmail.com>
 <e569134e-68a9-9c69-e894-b21640334bb0@iogearbox.net> <20191217201613.iccqsqwuhitsyqyl@ast-mbp.dhcp.thefacebook.com>
 <6be56761-5e4c-2922-bd93-761c0dbd773f@iogearbox.net>
In-Reply-To: <6be56761-5e4c-2922-bd93-761c0dbd773f@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 17 Dec 2019 16:08:42 -0800
Message-ID: <CAEf4BzZFbMUd_xHQZD00a3cDyf_B6HgYrSm7Ww+ZZnPGjtOsxg@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 2/4] libbpf: support libbpf-provided extern variables
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 17, 2019 at 3:37 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 12/17/19 9:16 PM, Alexei Starovoitov wrote:
> > On Tue, Dec 17, 2019 at 08:50:31PM +0100, Daniel Borkmann wrote:
> >>>
> >>> Yes, name collision is a possibility, which means users should
> >>> restrain from using LINUX_KERNEL_VERSION and CONFIG_XXX names for
> >>> their variables. But if that is ever actually the problem, the way to
> >>> resolve this collision/ambiguity would be to put externs in a separate
> >>> sections. It's possible to annotate extern variable with custom
> >>> section.
> >>>
> >>> But I guess putting Kconfig-provided externs into ".extern.kconfig"
> >>> might be a good idea, actually. That will make it possible to have
> >>> writable externs in the future.
> >>
> >> Yep, and as mentioned it will make it more clear that these get special
> >> loader treatment as opposed to regular externs we need to deal with in
> >> future. A '.extern.kconfig' section sounds good to me and the BPF helper
> >> header could provide a __kconfig annotation for that as well.
> >
> > I think annotating all extern vars into special section name will be quite
> > cumbersome from bpf program writer pov.
> > imo capital case extern variables LINUX_KERNEL_VERSION and CONFIG_XXX are
> > distinct enough and make it clear they should come from something other than
> > normal C. Traditional C coding style uses all capital letters for macroses. So
> > all capital extern variables are unlikely to conflict with any normal extern
> > vars. Like vars in vmlinux and vars in other bpf elf files.
>
> But still, how many of the LINUX_KERNEL_VERSION or CONFIG_XXX vars are actually
> used per program. I bet just a handful. And I don't think adding a __kconfig is
> cumbersome, it would make it more self-documenting in fact, denoting that this
> var is not treated the usual way once prog linking is in place. Even if all
> capital letters. Tomorrow, we'd be adding 'extern unsigned long jiffies' as
> another potential example, and then it gets even more confusing on the 'collision'
> side with regular BPF ELF. Same here, instead of __kconfig, this could have a
> __vmlinux or __kernel annotation in order to document its source for the loader
> (and developer) more clearly and also gives flexibility wrt ".extern.xyz"
> subsections on how we want to map them.

Sounds reasonable and clean enough. Let me play a bit with this and
see how this all plays together.
