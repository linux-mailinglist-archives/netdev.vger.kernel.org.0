Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67F118F3C7
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 20:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731603AbfHOSnS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 14:43:18 -0400
Received: from mail-40136.protonmail.ch ([185.70.40.136]:53884 "EHLO
        mail-40136.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728818AbfHOSnR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 14:43:17 -0400
Date:   Thu, 15 Aug 2019 18:43:06 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.ch;
        s=default; t=1565894593;
        bh=ND7tBfcYJKAh1WsZTzGacbQjk9haGZQHPo35ShA56Nc=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:
         Feedback-ID:From;
        b=qwmMlhXr3hYgLqjAkYZd8zbseVL3j0wedk8zYIV497DuO/fvA+lHvT9x8MwqgvJ1V
         gzRm5eeJstu9+MkpLhXAVCCfrwtEME3lxyWjzqfCKal7uXI6luIg/wElPp1AkBena2
         h5UUxSttI4gyShf5i/qvjyBg1cTD0+Z5tLXi4gtc=
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
Message-ID: <eHOd0IhIGMCitkKOPHlXyhVUNtZQ7lj3A1dmxkDQ2ky2tbzfAv1Yp5ZoO3fNXr3GQ3HrEiMNy_n6dncrbVkvUjakh1VCx0vi0nUkNB_PE0Q=@protonmail.ch>
In-Reply-To: <20190815172856.yoqvgu2yfrgbkowu@ast-mbp.dhcp.thefacebook.com>
References: <EE7B7AE1-3D44-4561-94B9-E97A626A251D@fb.com>
 <CALCETrXEHL3+NAY6P6vUj7Pvd9ZpZsYC6VCLXOaNxb90a_POGw@mail.gmail.com>
 <20190813215823.3sfbakzzjjykyng2@ast-mbp>
 <CALCETrVT-dDXQGukGs5S1DkzvQv9_e=axzr_GyEd2c4T4z8Qng@mail.gmail.com>
 <20190814005737.4qg6wh4a53vmso2v@ast-mbp>
 <CALCETrUkqUprujww26VxHwkdXQ3DWJH8nnL2VBYpK2EU0oX_YA@mail.gmail.com>
 <20190814220545.co5pucyo5jk3weiv@ast-mbp.dhcp.thefacebook.com>
 <HG0x24u69mnaMFKuxHVAzHpyjwsD5-U6RpqFRua87wGWQCHg00Q8ZqPeA_5kJ9l-d6oe0cXa4HyYXMnOO0Aofp_LcPcQdG0WFV21z1MbgcE=@protonmail.ch>
 <20190815172856.yoqvgu2yfrgbkowu@ast-mbp.dhcp.thefacebook.com>
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

On Thursday, August 15, 2019 5:28 PM, Alexei Starovoitov <alexei.starovoito=
v@gmail.com> wrote:

> On Thu, Aug 15, 2019 at 11:24:54AM +0000, Jordan Glover wrote:
>
> > On Wednesday, August 14, 2019 10:05 PM, Alexei Starovoitov alexei.staro=
voitov@gmail.com wrote:
> >
> > > On Wed, Aug 14, 2019 at 10:51:23AM -0700, Andy Lutomirski wrote:
> > >
> > > > If eBPF is genuinely not usable by programs that are not fully trus=
ted
> > > > by the admin, then no kernel changes at all are needed. Programs th=
at
> > > > want to reduce their own privileges can easily fork() a privileged
> > > > subprocess or run a little helper to which they delegate BPF
> > > > operations. This is far more flexible than anything that will ever =
be
> > > > in the kernel because it allows the helper to verify that the rest =
of
> > > > the program is doing exactly what it's supposed to and restrict eBP=
F
> > > > operations to exactly the subset that is needed. So a container
> > > > manager or network manager that drops some provilege could have a
> > > > little bpf-helper that manages its BPF XDP, firewalling, etc
> > > > configuration. The two processes would talk over a socketpair.
> > >
> > > there were three projects that tried to delegate bpf operations.
> > > All of them failed.
> > > bpf operational workflow is much more complex than you're imagining.
> > > fork() also doesn't work for all cases.
> > > I gave this example before: consider multiple systemd-like deamons
> > > that need to do bpf operations that want to pass this 'bpf capability=
'
> > > to other deamons written by other teams. Some of them will start
> > > non-root, but still need to do bpf. They will be rpm installed
> > > and live upgraded while running.
> > > We considered to make systemd such centralized bpf delegation
> > > authority too. It didn't work. bpf in kernel grows quickly.
> > > libbpf part grows independently. llvm keeps evolving.
> > > All of them are being changed while system overall has to stay
> > > operational. Centralized approach breaks apart.
> > >
> > > > The interesting cases you're talking about really do involved
> > > > unprivileged or less privileged eBPF, though. Let's see:
> > > > systemd --user: systemd --user is not privileged at all. There's no
> > > > issue of reducing privilege, since systemd --user doesn't have any
> > > > privilege to begin with. But systemd supports some eBPF features, a=
nd
> > > > presumably it would like to support them in the systemd --user case=
.
> > > > This is unprivileged eBPF.
> > >
> > > Let's disambiguate the terminology.
> > > This /dev/bpf patch set started as describing the feature as 'unprivi=
leged bpf'.
> > > I think that was a mistake.
> > > Let's call systemd-like deamon usage of bpf 'less privileged bpf'.
> > > This is not unprivileged.
> > > 'unprivileged bpf' is what sysctl kernel.unprivileged_bpf_disabled co=
ntrols.
> > > There is a huge difference between the two.
> > > I'm against extending 'unprivileged bpf' even a bit more than what it=
 is
> > > today for many reasons mentioned earlier.
> > > The /dev/bpf is about 'less privileged'.
> > > Less privileged than root. We need to split part of full root capabil=
ity
> > > into bpf capability. So that most of the root can be dropped.
> > > This is very similar to what cap_net_admin does.
> > > cap_net_amdin can bring down eth0 which is just as bad as crashing th=
e box.
> > > cap_net_admin is very much privileged. Just 'less privileged' than ro=
ot.
> > > Same thing for cap_bpf.
> > > May be we should do both cap_bpf and /dev/bpf to make it clear that
> > > this is the same thing. Two interfaces to achieve the same result.
> >
> > systemd --user processes aren't "less privileged". The are COMPLETELY u=
nprivileged.
> > Granting them cap_bpf is the same as granting it to every other unprivi=
leged user
> > process. Also unprivileged user process can start systemd --user proces=
s with any
> > command they like.
>
> systemd itself is trusted. It's the same binary whether it runs as pid=3D=
1
> or as pid=3D123. One of the use cases is to make IPAddressDeny=3D work wi=
th --user.
> Subset of that feature already works with AmbientCapabilities=3DCAP_NET_A=
DMIN.
> CAP_BPF is a natural step in the same direction.

The point was that systemd will run any arbitrary command you'll throw at i=
t and you want
to automatically attach CAP_BPF to it. AmbientCapabilities is not valid opt=
ion for
systemd --user instance (otherwise it would be nuts).

I think we may have misunderstanding here. Did you mean systemd "system" se=
rvice with
"User=3Dxxx" option instead of "systemd --user" service? It would make sens=
e then.
