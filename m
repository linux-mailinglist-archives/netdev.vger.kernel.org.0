Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA90549322D
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 02:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238668AbiASBL2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 20:11:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238605AbiASBL1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 20:11:27 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4192C061574;
        Tue, 18 Jan 2022 17:11:26 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id w7so890121ioj.5;
        Tue, 18 Jan 2022 17:11:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mQSN5k2eDDqTEwfTIGzY5jEC8wGtlkT4pwoeZbHL3Co=;
        b=BEZpJCXgayqHfFCureqh/KBgNMm3yk1oYLoCnzUDrr6mxVb9s6DREYwqnNtmAQMYKi
         EW+82GhR76eHi8lb5QxCAPQv80Iv4WgFgTLJb27w/DRGDZX5ehukE4zzCgSyi8m+9U09
         8mnQQwoIZasTx1cneQRyfG1Muc+MMdS1eoy8Nh9abaFzLAHa6jrLW+d+uNc20RaTfhOP
         532waiKi19d/bKB4kyYmF3xP0aWZ71hKVbFJuOtiO6uLKQdxm1Ap+ndJVd9haQcJEHkV
         pUBJY7FScrsUad6UnPhaDL2ljSO+Y4aToqVPZaFYqKoMAocDYuLD/ZCR9wO42t8v/KD1
         Pw5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mQSN5k2eDDqTEwfTIGzY5jEC8wGtlkT4pwoeZbHL3Co=;
        b=12I2mFXIePGrzcXGy97jUEwRC5Xzc84DrXlpD/FedoSI/gekfp7HkqqPfigkZf3sUh
         mmhhCto5wjNvtKMMhW3plghQbAkp+745ISRt3xzWKReEA7Iox9ofZGvSEk+8ZybThhZ1
         CFQsmveLyM+fzb9EJSqU9QQ+LxOcW9EK4OsSDryPXtalIujls3xxTR5o8fzox298BxVH
         dCI40f0Yz4h6aQhnAKYEGXRQy4Xc+nBxPJteBQeZSl2gV9J4jIP9LqchmxXzWXLK2nW6
         fl0kHuY+2Rs+L9wJ1Dz/sSM1zhyfL469TJ3yyVXDYfD5s7Xwx+dUXsxvNKEmKE+Xl/bA
         rEtQ==
X-Gm-Message-State: AOAM531zswjydXagvzjeeMRTJG7ShADhW5ijR1VZQart8fimq3EPVgo2
        iUZzY4D4VblWML8hjBUGbR77GmNW6+uB9xvaWhs=
X-Google-Smtp-Source: ABdhPJzu+IWovXCUcRzc9DMrER1kz+hf3HTjtcgA1Y3CdgJ9XxxWl7ME43inLvAwKLGXPXF42vSsDZz72rG87r7Dsns=
X-Received: by 2002:a6b:c891:: with SMTP id y139mr13866464iof.63.1642554686293;
 Tue, 18 Jan 2022 17:11:26 -0800 (PST)
MIME-Version: 1.0
References: <cover.1642439548.git.lorenzo@kernel.org> <c2bdc436abe8e27a46aa8ba13f75d24f119e18a4.1642439548.git.lorenzo@kernel.org>
 <20220118201449.sjqzif5qkpbu5tqx@ast-mbp.dhcp.thefacebook.com>
 <Yec/qu7idEImzqxc@lore-desk> <CAADnVQJgKVQ8vNfiazTcNbZVFTb2x=7G1WUda7O+LHM8Hs=KCw@mail.gmail.com>
In-Reply-To: <CAADnVQJgKVQ8vNfiazTcNbZVFTb2x=7G1WUda7O+LHM8Hs=KCw@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 18 Jan 2022 17:11:15 -0800
Message-ID: <CAEf4BzYHyCz5QNwuuKnRRrqCTcP0c0Q6fdi0N5_Yp8yNXvxReQ@mail.gmail.com>
Subject: Re: [PATCH v22 bpf-next 18/23] libbpf: Add SEC name for xdp
 multi-frags programs
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Shay Agroskin <shayagr@amazon.com>,
        John Fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        tirthendu.sarkar@intel.com,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 18, 2022 at 2:33 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Jan 18, 2022 at 2:31 PM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> >
> > > On Mon, Jan 17, 2022 at 06:28:30PM +0100, Lorenzo Bianconi wrote:
> > > > Introduce support for the following SEC entries for XDP multi-frags
> > > > property:
> > > > - SEC("xdp.frags")
> > > > - SEC("xdp.frags/devmap")
> > > > - SEC("xdp.frags/cpumap")
> > > >
> > > > Acked-by: Toke Hoiland-Jorgensen <toke@redhat.com>
> > > > Acked-by: John Fastabend <john.fastabend@gmail.com>
> > > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > > ---
> > > >  tools/lib/bpf/libbpf.c | 6 ++++++
> > > >  1 file changed, 6 insertions(+)
> > > >
> > > > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > > > index fdb3536afa7d..611e81357fb6 100644
> > > > --- a/tools/lib/bpf/libbpf.c
> > > > +++ b/tools/lib/bpf/libbpf.c
> > > > @@ -6562,6 +6562,9 @@ static int libbpf_preload_prog(struct bpf_program *prog,
> > > >     if (def & SEC_SLEEPABLE)
> > > >             opts->prog_flags |= BPF_F_SLEEPABLE;
> > > >
> > > > +   if (prog->type == BPF_PROG_TYPE_XDP && strstr(prog->sec_name, ".frags"))
> > > > +           opts->prog_flags |= BPF_F_XDP_HAS_FRAGS;
> > >
> > > That's a bit sloppy.
> > > Could you handle it similar to SEC_SLEEPABLE?
> > >
> > > > +
> > > >     if ((prog->type == BPF_PROG_TYPE_TRACING ||
> > > >          prog->type == BPF_PROG_TYPE_LSM ||
> > > >          prog->type == BPF_PROG_TYPE_EXT) && !prog->attach_btf_id) {
> > > > @@ -8600,8 +8603,11 @@ static const struct bpf_sec_def section_defs[] = {
> > > >     SEC_DEF("lsm.s/",               LSM, BPF_LSM_MAC, SEC_ATTACH_BTF | SEC_SLEEPABLE, attach_lsm),
> > > >     SEC_DEF("iter/",                TRACING, BPF_TRACE_ITER, SEC_ATTACH_BTF, attach_iter),
> > > >     SEC_DEF("syscall",              SYSCALL, 0, SEC_SLEEPABLE),
> > > > +   SEC_DEF("xdp.frags/devmap",     XDP, BPF_XDP_DEVMAP, SEC_NONE),
> > > >     SEC_DEF("xdp_devmap/",          XDP, BPF_XDP_DEVMAP, SEC_ATTACHABLE),
> > > > +   SEC_DEF("xdp.frags/cpumap",     XDP, BPF_XDP_CPUMAP, SEC_NONE),
> > > >     SEC_DEF("xdp_cpumap/",          XDP, BPF_XDP_CPUMAP, SEC_ATTACHABLE),
> > > > +   SEC_DEF("xdp.frags",            XDP, BPF_XDP, SEC_NONE),
> > >
> > > It would be SEC_FRAGS here instead of SEC_NONE.
> >
> > ack, I dropped SEC_FRAGS (SEC_XDP_MB before) from sec_def_flags because Andrii asked to remove
> > it but I am fine to add it back. Agree?
>
> Andrii,
> what was the motivation?
> imo that's cleaner than strstr.

Given it was XDP-specific (as opposed to sleepable flag that applies
more widely), it felt cleaner ([0]) to handle that as a special case
in libbpf_preload_prog. But I didn't feel that strongly about that
back then and still don't, so if you think SEC_FRAGS is better, I'm
fine with it. I'd make it SEC_XDP_FRAGS to make it more obvious it's
still XDP-specific (there are no plans to extend it to non-XDP,
right?).

But whichever way, it's internal implementation detail and pretty
small one at that, so I don't care much.

  [0] https://lore.kernel.org/bpf/CAEf4BzbfDvH5CYNsWg9Dx7JcFEp4jNmNRR6H-6sJEUxDSy1zZw@mail.gmail.com/
