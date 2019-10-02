Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44AADC93D8
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 23:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727452AbfJBVyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 17:54:02 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:33722 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725928AbfJBVyB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 17:54:01 -0400
Received: by mail-qk1-f195.google.com with SMTP id x134so328939qkb.0;
        Wed, 02 Oct 2019 14:53:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rzOcwXLPCPxOer2OQybfy1++8uKi5OM6q5fIBGrbztg=;
        b=Bt3VWZmADHxaTGyi0q/esRUsSbOo55sfH7wTfotYnV+6N73XFIXvn3VSvg7sPPBXyV
         LB8j5V7u3aKyMKTLhyW7LqfSUoAqrFuS4caTEqMFe7rvD6cM0T91cwqW7aDCu3LB/VBp
         GiIiM7AmZk1sdo4jFj+5OXhW8e72L3QKg0uYhJN5gKH5w5QY/klGOKpAjEIEwZfJWS2D
         wdiCqYZWUt45PQULbfvpI9uFVioZORPVi0sv/9b/jiFZK+vCgypwBOIK1Hql+WDLRatx
         /8YRVZ4A3ExpLU1KzXwLNYFee0dRPQIIam09qzqcyC3Uep3hLnEULmhZA0wDlVStOEZW
         b6SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rzOcwXLPCPxOer2OQybfy1++8uKi5OM6q5fIBGrbztg=;
        b=PN815pF20f92v3h9rEIkshbFX1jHhx0Q52xHQSN5N4547nnMxHcY3jWsRNH8GsYGCL
         nY/Mn0WExDVKBVTL1KYR/2icoKiafH/Lz3oO3oaVYr9uu3UdggA3KMIKzwxoQZWC+nnc
         lVMoE++WjdTWNOxyvX55Ar2qciq8Aku6xW4qO2FSPBwEQhCgD0intF29dLCLEWDIK1xj
         IKxb3bzpijTRlcl++DENH5cPHddJHAz6TxUx0t9qJWGayY02CrY9r9JkmtgSiOBBMwvg
         f7t0vowQp9z/zPzc2P5gXPnnuqZKqkNA6xzZPonPlM1x/czLUCx7K77Wk2fou51OD14O
         /8LQ==
X-Gm-Message-State: APjAAAVop0aw8bvcSJwniCdAtu7p7r+l/a1OTVRKEBWFAomDzlWvy29s
        GMSKXTEnIxNkvtFymTr0vo5/f+oVaNu6Z0UrmH8=
X-Google-Smtp-Source: APXvYqyOF3z/DzRmunXZYetxTarAMDAqZvSiQ4zdVcvUxuWIyXYpouY4xADzvDjznsZXL/rHW1cH62TG+AVddAUteU4=
X-Received: by 2002:a37:9fcd:: with SMTP id i196mr1165959qke.92.1570053238615;
 Wed, 02 Oct 2019 14:53:58 -0700 (PDT)
MIME-Version: 1.0
References: <20191001173728.149786-1-brianvv@google.com> <20191001173728.149786-3-brianvv@google.com>
 <CAEf4BzYxs6Ace8s64ML3pA9H4y0vgdWv_vDF57oy3i-O_G7c-g@mail.gmail.com>
 <CABCgpaWbPN+2vSNdynHtmDxrgGbyzHa_D-y4-X8hLrQYbhTx=A@mail.gmail.com>
 <20191002085553.GA6226@pc-66.home> <CAEf4BzZAywR2g4bRu8Bs-YJxzf64GTrR7NvgOaXG2fqaKiJpSQ@mail.gmail.com>
 <20191002215051.GB9196@pc-66.home>
In-Reply-To: <20191002215051.GB9196@pc-66.home>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 2 Oct 2019 14:53:47 -0700
Message-ID: <CAEf4BzaftLAc1xv5yiRE2J6MLy_FF4g6_dqExTiPjs6ZDX6e=w@mail.gmail.com>
Subject: Re: [PATCH bpf 2/2] selftests/bpf: test_progs: don't leak server_fd
 in test_sockopt_inherit
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Brian Vazquez <brianvv@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Stanislav Fomichev <sdf@google.com>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 2, 2019 at 2:51 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On Wed, Oct 02, 2019 at 01:30:14PM -0700, Andrii Nakryiko wrote:
> > On Wed, Oct 2, 2019 at 1:56 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
> > > On Tue, Oct 01, 2019 at 08:42:30PM -0700, Brian Vazquez wrote:
> > > > Thanks for reviewing the patches Andrii!
> > > >
> > > > Although Daniel fixed them and applied them correctly.
> > >
> > > After last kernel/maintainer summit at LPC, I reworked all my patchwork scripts [0]
> > > which I use for bpf trees in order to further reduce manual work and add more sanity
> > > checks at the same time. Therefore, the broken Fixes: tag was a good test-case. ;-)
> >
> > Do you scripts also capitalize first word after libbpf: prefix? Is
> > that intentional? Is that a recommended subject casing:
> >
> > "libbpf: Do awesome stuff" vs "libbpf: do awesome stuff"?
>
> Right now we have a bit of a mix on that regard, and basically what the
> pw-apply script from [0] is doing, is the following to provide some more
> context:
>
> - Pulls the series mbox specified by series id from patchwork, dumps all
>   necessary information about the series, e.g. whether it's complete and
>   all patches are present, etc.
> - Pushes the mbox through mb2q which is a script that x86 maintainers and
>   few others use for their patch management and spills out a new mbox.
>   This is effectively 'normalizing' the patches from the mbox to bring in
>   some more consistency, meaning it adds Link: tags to every patch based
>   on the message id and checks whether the necessary mailing list aka
>   bpf was in Cc, so we always have lore BPF archive links, sorts tags so
>   they all have a consistent order, it allows to propagate Acked-by,
>   Reviewed-by, Tested-by tags from cover letter into the individual
>   patches, it also capitalizes the first word after the subsystem prefix.
> - It applies and merges the resulting mbox, and performs additional checks
>   for the newly added commit range, that is, it checks whether Fixes tags
>   are correctly formatted, whether the commit exists at all in the tree or
>   whether subject / sha is wrong, and throws warnings to me so I can fix
>   them up if needed or toss out the series again worst case, as well as
>   checks whether SOB from the patch authors is present and matches their
>   name.
> - It allows to set the patches from the series into accepted state in
>   patchwork.
>
> So overall less manual work / checks than what used to be before while
> improving / ensuring more consistency in the commits at the same time.
> If you have further suggestions / improvements / patches to pw.git,
> happy to hear. :)
>

"libbpf: Captilized subj" looks weird, but I can live with that. I'll
post subsequent patches with that casing. I'm glad a lot of that stuff
is semi-automated, it's terrible to have to always check all that
manually :)

> Thanks,
> Daniel
>
> > >   [0] https://git.kernel.org/pub/scm/linux/kernel/git/dborkman/pw.git/
> > >
> > > > On Tue, Oct 1, 2019 at 8:20 PM Andrii Nakryiko
> > > > <andrii.nakryiko@gmail.com> wrote:
> > > > >
> > > > > On Tue, Oct 1, 2019 at 10:40 AM Brian Vazquez <brianvv@google.com> wrote:
> > > > > >
> > > > >
> > > > > I don't think there is a need to add "test_progs:" to subject, "
> > > > > test_sockopt_inherit" is specific enough ;)
> > > > >
> > > > > > server_fd needs to be close if pthread can't be created.
> > > > >
> > > > > typo: closed
> > > > >
> > > > > > Fixes: e3e02e1d9c24 ("selftests/bpf: test_progs: convert test_sockopt_inherit")
> > > > > > Cc: Stanislav Fomichev <sdf@google.com>
> > > > > > Signed-off-by: Brian Vazquez <brianvv@google.com>
> > > > > > ---
> > > > >
> > > > > Acked-by: Andrii Nakryiko <andriin@fb.com>
> > > > >
> > > > > >  tools/testing/selftests/bpf/prog_tests/sockopt_inherit.c | 2 +-
> > > > > >  1 file changed, 1 insertion(+), 1 deletion(-)
