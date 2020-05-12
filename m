Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A83B1CF4D2
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 14:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729595AbgELMuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 08:50:17 -0400
Received: from mail-40132.protonmail.ch ([185.70.40.132]:64926 "EHLO
        mail-40132.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729519AbgELMuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 08:50:16 -0400
Date:   Tue, 12 May 2020 12:50:05 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.ch;
        s=protonmail; t=1589287814;
        bh=Ld4AfSh+DgbNYfTa4km0zAH2heXRaC9744zQhOSEfVA=;
        h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
        b=g7X3HR6LjSKU408SSycP5+qZ7bsrExg9BB9V21BFxGsOsmiCHhQjL14by8nlA0Yxh
         SRIrMUZ5yNPvyd5BEoAqszvBT4UeNdAo8fvPg3nZ425mf4uPriQuuVpFHEOSSg/XHR
         oTMt5G4BvmC2I8GO4Zj9MpdlWoWQkSbcQJwUlNBQ=
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
From:   Jordan Glover <Golden_Miller83@protonmail.ch>
Cc:     "sdf@google.com" <sdf@google.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "kernel-team@fb.com" <kernel-team@fb.com>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "acme@redhat.com" <acme@redhat.com>,
        "jamorris@linux.microsoft.com" <jamorris@linux.microsoft.com>,
        "jannh@google.com" <jannh@google.com>,
        "kpsingh@google.com" <kpsingh@google.com>
Reply-To: Jordan Glover <Golden_Miller83@protonmail.ch>
Subject: Re: [PATCH v5 bpf-next 2/3] bpf: implement CAP_BPF
Message-ID: <ZHW2pvJicBV52gi3gjsDNXDF6t7BteEoHKvEGeVueRPPDrEKGR0OMJjTlulOoOrDNNwcK2c7HE1lNEQw8F2G6SEGCCIAekGoY0T_cnJ-oSc=@protonmail.ch>
In-Reply-To: <20200512023641.jupgmhpliblkli4t@ast-mbp.dhcp.thefacebook.com>
References: <20200508215340.41921-1-alexei.starovoitov@gmail.com>
 <20200508215340.41921-3-alexei.starovoitov@gmail.com>
 <20200512001210.GA235661@google.com>
 <20200512023641.jupgmhpliblkli4t@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.7 required=7.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO_END_DIGIT shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on mail.protonmail.ch
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tuesday, May 12, 2020 2:36 AM, Alexei Starovoitov <alexei.starovoitov@gm=
ail.com> wrote:

> On Mon, May 11, 2020 at 05:12:10PM -0700, sdf@google.com wrote:
>
> > On 05/08, Alexei Starovoitov wrote:
> >
> > > From: Alexei Starovoitov ast@kernel.org
> > > [..]
> > > @@ -3932,7 +3977,7 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr
> > > __user *, uattr, unsigned int, siz
> > > union bpf_attr attr;
> > > int err;
> >
> > > -   if (sysctl_unprivileged_bpf_disabled && !capable(CAP_SYS_ADMIN))
> > >
> > > -   if (sysctl_unprivileged_bpf_disabled && !bpf_capable())
> > >     return -EPERM;
> > >     This is awesome, thanks for reviving the effort!
> > >
> >
> > One question I have about this particular snippet:
> > Does it make sense to drop bpf_capable checks for the operations
> > that work on a provided fd?
>
> Above snippet is for the case when sysctl switches unpriv off.
> It was a big hammer and stays big hammer.
> I certainly would like to improve the situation, but I suspect
> the folks who turn that sysctl knob on are simply paranoid about bpf
> and no amount of reasoning would turn them around.
>

Without CAP_BPF, sysctl was the only option to keep you safe from flow
of bpf vulns. You didn't had to be paranoid about that.

Jordan
