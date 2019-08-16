Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E43A900CB
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 13:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727217AbfHPLeI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 07:34:08 -0400
Received: from mail-40135.protonmail.ch ([185.70.40.135]:20621 "EHLO
        mail-40135.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727007AbfHPLeI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 07:34:08 -0400
Date:   Fri, 16 Aug 2019 11:33:57 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.ch;
        s=default; t=1565955243;
        bh=Yt+i7vUoMC/7exz+6N1Qfx1ezQKcdB81VEBD2vgd94g=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:
         Feedback-ID:From;
        b=JmfR8i9mQ9pd0Isp+wfbro4gkLogIvJHS8cTAdzkbaV0V+HlbX6D6OpI/mFq6ZKRr
         BnYyvP++4dMxYJXBJ0BS4WyODhCoXNaDmmjS30Fk8oK9nfI2N0WtXgZwkPEFKhlRoa
         Iecmj9CBu2xx+2z/NT9Ktm2V5NKOGsR7u29tEdh8=
To:     Thomas Gleixner <tglx@linutronix.de>
From:   Jordan Glover <Golden_Miller83@protonmail.ch>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andy Lutomirski <luto@kernel.org>,
        Daniel Colascione <dancol@google.com>,
        Song Liu <songliubraving@fb.com>,
        Kees Cook <keescook@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jann Horn <jannh@google.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Reply-To: Jordan Glover <Golden_Miller83@protonmail.ch>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: unprivileged BPF access via /dev/bpf
Message-ID: <lGGTLXBsX3V6p1Z4TkdzAjxbNywaPS2HwX5WLleAkmXNcnKjTPpWnP6DnceSsy8NKt5NBRBbuoAb0woKTcDhJXVoFb7Ygk3Skfj8j6rVfMQ=@protonmail.ch>
In-Reply-To: <alpine.DEB.2.21.1908161158490.1873@nanos.tec.linutronix.de>
References: <20190806011134.p5baub5l3t5fkmou@ast-mbp>
 <CALCETrUkqUprujww26VxHwkdXQ3DWJH8nnL2VBYpK2EU0oX_YA@mail.gmail.com>
 <20190814220545.co5pucyo5jk3weiv@ast-mbp.dhcp.thefacebook.com>
 <HG0x24u69mnaMFKuxHVAzHpyjwsD5-U6RpqFRua87wGWQCHg00Q8ZqPeA_5kJ9l-d6oe0cXa4HyYXMnOO0Aofp_LcPcQdG0WFV21z1MbgcE=@protonmail.ch>
 <20190815172856.yoqvgu2yfrgbkowu@ast-mbp.dhcp.thefacebook.com>
 <CALCETrUv+g+cb79FJ1S4XuV0K=kowFkPXpzoC99svoOfs4-Kvg@mail.gmail.com>
 <20190815230808.2o2qe7a72cwdce2m@ast-mbp.dhcp.thefacebook.com>
 <fkD3fs46a1YnR4lh0tEG-g3tDnDcyZuzji7bAUR9wujPLLl75ZhI8Yk-H1jZpSugO7qChVeCwxAMmxLdeoF2QFS3ZzuYlh7zmeZOmhDJxww=@protonmail.ch>
 <alpine.DEB.2.21.1908161158490.1873@nanos.tec.linutronix.de>
Feedback-ID: QEdvdaLhFJaqnofhWA-dldGwsuoeDdDw7vz0UPs8r8sanA3bIt8zJdf4aDqYKSy4gJuZ0WvFYJtvq21y6ge_uQ==:Ext:ProtonMail
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.7 required=7.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO_END_DIGIT autolearn=no
        autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.protonmail.ch
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Friday, August 16, 2019 9:59 AM, Thomas Gleixner <tglx@linutronix.de> wr=
ote:

> On Fri, 16 Aug 2019, Jordan Glover wrote:
>
> > "systemd --user" service? Trying to do so will fail with:
> > "Failed to apply ambient capabilities (before UID change): Operation no=
t permitted"
> > I think it's crucial to clear that point to avoid confusion in this dis=
cussion
> > where people are talking about different things.
> > On the other hand running "systemd --system" service with:
> > User=3Dnobody
> > AmbientCapabilities=3DCAP_NET_ADMIN
> > is perfectly legit and clears some security concerns as only privileged=
 user
> > can start such service.
>
> While we are at it, can we please stop looking at this from a systemd onl=
y
> perspective. There is a world outside of systemd.
>
> Thanks,
>
> tglx

If you define:

"systemd --user" =3D=3D unprivileged process started by unprivileged user
"systemd --system" =3D=3D process started by privileged user but run as ano=
ther
user which keeps some of parent user privileges and drops others

you can get rid of "systemd" from the equation.

"systemd --user" was the example provided by Alexei when asked about the us=
ecase
but his description didn't match what it does so it's not obvious what the =
real
usecase is. I'm sure there can be many more examples and systemd isn't impo=
rtant
here in particular beside to understand this specific example.

Jordan
