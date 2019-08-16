Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBE0B8FF16
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 11:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726800AbfHPJev (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 05:34:51 -0400
Received: from mail-40133.protonmail.ch ([185.70.40.133]:52290 "EHLO
        mail-40133.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726828AbfHPJev (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 05:34:51 -0400
Date:   Fri, 16 Aug 2019 09:34:45 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.ch;
        s=default; t=1565948087;
        bh=UQU9idFpKWKIg5Wei4GEMXWmelwfj3kZ+jVlkme0WoM=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:
         Feedback-ID:From;
        b=XTQCbZpu+lnGorYMKuOitGcQNfz3h3bpF+mAW0ahs54d8y4UJHcExmbiAQ0LrmIIh
         bd/kSAy3wr/EpzLrOVWCFSSqtzwXXHaYIcSf+vmq8h4MRffcdopLPyp13jKtrTcNkR
         szbt1Zv2dyL3a51WXrM+2FVQeUbXuRhFvOw9zb0o=
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
From:   Jordan Glover <Golden_Miller83@protonmail.ch>
Cc:     Andy Lutomirski <luto@kernel.org>,
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
Message-ID: <fkD3fs46a1YnR4lh0tEG-g3tDnDcyZuzji7bAUR9wujPLLl75ZhI8Yk-H1jZpSugO7qChVeCwxAMmxLdeoF2QFS3ZzuYlh7zmeZOmhDJxww=@protonmail.ch>
In-Reply-To: <20190815230808.2o2qe7a72cwdce2m@ast-mbp.dhcp.thefacebook.com>
References: <20190806011134.p5baub5l3t5fkmou@ast-mbp>
 <CALCETrVT-dDXQGukGs5S1DkzvQv9_e=axzr_GyEd2c4T4z8Qng@mail.gmail.com>
 <20190814005737.4qg6wh4a53vmso2v@ast-mbp>
 <CALCETrUkqUprujww26VxHwkdXQ3DWJH8nnL2VBYpK2EU0oX_YA@mail.gmail.com>
 <20190814220545.co5pucyo5jk3weiv@ast-mbp.dhcp.thefacebook.com>
 <HG0x24u69mnaMFKuxHVAzHpyjwsD5-U6RpqFRua87wGWQCHg00Q8ZqPeA_5kJ9l-d6oe0cXa4HyYXMnOO0Aofp_LcPcQdG0WFV21z1MbgcE=@protonmail.ch>
 <20190815172856.yoqvgu2yfrgbkowu@ast-mbp.dhcp.thefacebook.com>
 <CALCETrUv+g+cb79FJ1S4XuV0K=kowFkPXpzoC99svoOfs4-Kvg@mail.gmail.com>
 <20190815230808.2o2qe7a72cwdce2m@ast-mbp.dhcp.thefacebook.com>
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

On Thursday, August 15, 2019 11:08 PM, Alexei Starovoitov <alexei.starovoit=
ov@gmail.com> wrote:

> On Thu, Aug 15, 2019 at 11:36:43AM -0700, Andy Lutomirski wrote:
>
> > On Thu, Aug 15, 2019 at 10:29 AM Alexei Starovoitov
> > alexei.starovoitov@gmail.com wrote:
> >
> > > On Thu, Aug 15, 2019 at 11:24:54AM +0000, Jordan Glover wrote:
> > >
> > > > systemd --user processes aren't "less privileged". The are COMPLETE=
LY unprivileged.
> > > > Granting them cap_bpf is the same as granting it to every other unp=
rivileged user
> > > > process. Also unprivileged user process can start systemd --user pr=
ocess with any
> > > > command they like.
> > >
> > > systemd itself is trusted. It's the same binary whether it runs as pi=
d=3D1
> > > or as pid=3D123. One of the use cases is to make IPAddressDeny=3D wor=
k with --user.
> > > Subset of that feature already works with AmbientCapabilities=3DCAP_N=
ET_ADMIN.
> > > CAP_BPF is a natural step in the same direction.
> >
> > I have the feeling that we're somehow speaking different languages.
> > What, precisely, do you mean when you say "systemd itself is trusted"?
> > Do you mean "the administrator trusts that the /lib/systemd/systemd
> > binary is not malicious"? Do you mean "the administrator trusts that
> > the running systemd process is not malicious"?
>
> please see
> https://github.com/systemd/systemd/commit/4c1567f29aeb60a6741874bca8a8e3a=
0bd69ed01
> I'm not advocating for or against this approach.
> Call it 'security hole' or 'better security'.
> There are two categories of people for any feature like this.
> My point that there is a demand to use bpf for non-root and CAP_NET_ADMIN
> level of privileges is acceptable.
> Another option is to relax all of bpf to CAP_NET_ADMIN instead of CAP_SYS=
_ADMIN.
> But CAP_BPF is clearly better way.
>

Do you realize it's not possible to grant CAP_NET_ADMIN or any other CAP in
"systemd --user" service? Trying to do so will fail with:
"Failed to apply ambient capabilities (before UID change): Operation not pe=
rmitted"

I think it's crucial to clear that point to avoid confusion in this discuss=
ion
where people are talking about different things.

On the other hand running "systemd --system" service with:

User=3Dnobody
AmbientCapabilities=3DCAP_NET_ADMIN

is perfectly legit and clears some security concerns as only privileged use=
r
can start such service.

Jordan
