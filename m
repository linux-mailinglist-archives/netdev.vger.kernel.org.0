Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB817C92DE
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 22:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbfJBUa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 16:30:27 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:44761 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726374AbfJBUa1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 16:30:27 -0400
Received: by mail-qk1-f193.google.com with SMTP id u22so26190qkk.11;
        Wed, 02 Oct 2019 13:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=H/l1Z6mqe+sew18UxIihneHwJjZNG3zHFInnW5dLs3Y=;
        b=gkVMntSdsPeklPKD+UqQ33URkWswRRQAsbO0bdUwGWUuswAnqJfCLsvfj/KSKV723K
         zlbgYL7cJs1m1Zvr6dTAWffEAH2gB/yAdLNeTmNNSMVahyOyTeUXHILKnj2c7xuSw/p3
         7BniCHczZQcd609FnnSsaZOc+TxBrLJdTHu0OxwNemggbAU2XMVNHoaYZwSKc+fyVuJL
         FsfqMj+zKX53eEBpgLRlDC6WIw5KkR5HxrAR5Uy3J55tRl5yJw+I9jWsp7EY74ifPddJ
         1kf02djXfyI8Xrg12EMR9M0/bTIGK5KQMxytQGEXCLO5DJZ8J1Pn9gM3Lag0jDxnnOTv
         o1WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=H/l1Z6mqe+sew18UxIihneHwJjZNG3zHFInnW5dLs3Y=;
        b=mD87W6nmIu3yIWMiiNa7TDZ/4B6wE2GN6F2XEZcwpYHrP47PicjnT1kgy2mpF2G26Y
         +BjrjnDCv1VPkMZ3MV+pCE3Yi1S1eekrBKekWsD3Y2FWynaCSYLQLvZRKspJRVWLZpX9
         zWgtsc83m7xYRT9Rbsw22Opyc6EJejse+QdDwqGE7S8smtCdXZjnMecihpanEmde5gpH
         GOzt5hMNyoHCLWyFZhsdjoXT4ri7/FGP6XqIAHZ/XSTvLW14EBoq1rie9T1Jj86SFCjI
         mnVnuqVlkl5QztbV7F+h3FBYDDv/W3xT+5n260ixo3XWD/cNvpJrdpXHL0s4Pixnv5Kw
         cyuw==
X-Gm-Message-State: APjAAAWMICQdOwlQlrd/74g5GPTmw3sFF/oZ1LioEMbzBKDlEkujVSUt
        AvDIAQJmplxI8NT4gYOQIkUgYpu052l/MankCeo=
X-Google-Smtp-Source: APXvYqyYUlULdUWEftFIOGiwzSS3v9o59oPmGXc7uRSh/abRXSUEn9PHsXKjygA8vcQSFo914oM9gzGYrp0DUL0sW9E=
X-Received: by 2002:a37:98f:: with SMTP id 137mr722298qkj.449.1570048225831;
 Wed, 02 Oct 2019 13:30:25 -0700 (PDT)
MIME-Version: 1.0
References: <20191001173728.149786-1-brianvv@google.com> <20191001173728.149786-3-brianvv@google.com>
 <CAEf4BzYxs6Ace8s64ML3pA9H4y0vgdWv_vDF57oy3i-O_G7c-g@mail.gmail.com>
 <CABCgpaWbPN+2vSNdynHtmDxrgGbyzHa_D-y4-X8hLrQYbhTx=A@mail.gmail.com> <20191002085553.GA6226@pc-66.home>
In-Reply-To: <20191002085553.GA6226@pc-66.home>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 2 Oct 2019 13:30:14 -0700
Message-ID: <CAEf4BzZAywR2g4bRu8Bs-YJxzf64GTrR7NvgOaXG2fqaKiJpSQ@mail.gmail.com>
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

On Wed, Oct 2, 2019 at 1:56 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On Tue, Oct 01, 2019 at 08:42:30PM -0700, Brian Vazquez wrote:
> > Thanks for reviewing the patches Andrii!
> >
> > Although Daniel fixed them and applied them correctly.
>
> After last kernel/maintainer summit at LPC, I reworked all my patchwork scripts [0]
> which I use for bpf trees in order to further reduce manual work and add more sanity
> checks at the same time. Therefore, the broken Fixes: tag was a good test-case. ;-)

Do you scripts also capitalize first word after libbpf: prefix? Is
that intentional? Is that a recommended subject casing:

"libbpf: Do awesome stuff" vs "libbpf: do awesome stuff"?

>
> Thanks,
> Daniel
>
>   [0] https://git.kernel.org/pub/scm/linux/kernel/git/dborkman/pw.git/
>
> > On Tue, Oct 1, 2019 at 8:20 PM Andrii Nakryiko
> > <andrii.nakryiko@gmail.com> wrote:
> > >
> > > On Tue, Oct 1, 2019 at 10:40 AM Brian Vazquez <brianvv@google.com> wrote:
> > > >
> > >
> > > I don't think there is a need to add "test_progs:" to subject, "
> > > test_sockopt_inherit" is specific enough ;)
> > >
> > > > server_fd needs to be close if pthread can't be created.
> > >
> > > typo: closed
> > >
> > > > Fixes: e3e02e1d9c24 ("selftests/bpf: test_progs: convert test_sockopt_inherit")
> > > > Cc: Stanislav Fomichev <sdf@google.com>
> > > > Signed-off-by: Brian Vazquez <brianvv@google.com>
> > > > ---
> > >
> > > Acked-by: Andrii Nakryiko <andriin@fb.com>
> > >
> > > >  tools/testing/selftests/bpf/prog_tests/sockopt_inherit.c | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
