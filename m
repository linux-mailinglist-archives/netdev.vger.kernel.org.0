Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E33A8424680
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 21:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239305AbhJFTLc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 15:11:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbhJFTL2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 15:11:28 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3DB0C061746;
        Wed,  6 Oct 2021 12:09:35 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id h3so3339346pgb.7;
        Wed, 06 Oct 2021 12:09:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ztAEE6yw026+DrQWHZbS93o0AsbKl8sbmAO9omaGUvc=;
        b=nVZu70haWF8+nNWBUaskrElygkxk+cgugrhwaXz3eVf7IANWQIqC/WHN0QAmMFox3r
         RGmQ26XqanEWOH+09IwC0ZCFZL1RgkIiLXo7cL2V2MEKZmrlpc/1ge/Fn1GcGw2NbDVD
         ajrBGPoWCQNN/6FfVYlh7UW/SVpsUfiWIpWDXayefCE1w/Mb7R+np7qxnt07YdFli2Yy
         +X0b8E6KQXyyi0ejjLKZtxRPpNlPiPGXk6HupJj/WNGOTvwi7p2QNyR/IIhAHgpU+c6g
         Z/Kgp+CpRpH12ZnoMsqBZx2jNHGhnmRE6eq8knXkw/MQ24xZPhrQM8gF2gZO6dc5elyI
         DUXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ztAEE6yw026+DrQWHZbS93o0AsbKl8sbmAO9omaGUvc=;
        b=bfrFNs1CBYBMMe8lknKn37eTPGqhZXWthmQCAdqBc68JP0lloxzfftSCNdmtU1WLy5
         s9hbQ1Q6/5laij9UTNPzVmsu0eicvj6MbpZYlbUQEkuXTy0lwPCK76u30gw3CTkDkCSr
         +dRpbnB1R0ctHKTqMVhrl266k7cV9BkQgxqJzJOS96qJkLKGxgV3LRZ3RGsR8XjMzmRO
         eIQMyPuHtSzTPbjzjiId3LkO9vhGvcfzH8cn4CEHoGnyKfUSuYf4OzeLD4mf/Bp21bT9
         wuiK6TUM4UPtrCCFs3FPYqku2kTPy8arQo3vqMiUHjwKRQW6M5nbfldzn+ewc7nnrGgT
         UylA==
X-Gm-Message-State: AOAM531xB2V2DYcB3lEV5etvE5EEQx+c3mNMbjjVb0fyz9S/8TzHYIMu
        +JCDhh0YrGRTjcxhNC5g5bbK86uPnoFbRQgGTGM=
X-Google-Smtp-Source: ABdhPJyDl3h4Aoqp+4jMHSVQG8TgWs7p9yLOrAkHe+JnY3qol2OEA//5TYc+4nBL3h4WkJ/T/UMAxGi0cF0zOqpSX6s=
X-Received: by 2002:a65:4008:: with SMTP id f8mr345998pgp.310.1633547375201;
 Wed, 06 Oct 2021 12:09:35 -0700 (PDT)
MIME-Version: 1.0
References: <20211006002853.308945-1-memxor@gmail.com> <20211006002853.308945-4-memxor@gmail.com>
 <CAEf4BzZCK5L-yZHL=yhGir71t=kkhAn5yN07Vxs2+VizvwF3QQ@mail.gmail.com>
 <20211006052455.st3f7m3q5fb27bs7@apollo.localdomain> <CAEf4Bzai=3GK5L-tkZRTT_h8SYPFjike-LTS8GXK17Z1YFAQtw@mail.gmail.com>
In-Reply-To: <CAEf4Bzai=3GK5L-tkZRTT_h8SYPFjike-LTS8GXK17Z1YFAQtw@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 6 Oct 2021 12:09:23 -0700
Message-ID: <CAADnVQKVKY8o_3aU8Gzke443+uHa-eGoM0h7W4srChMXU1S4Bg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 3/6] libbpf: Ensure that module BTF fd is
 never 0
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 6, 2021 at 9:43 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Tue, Oct 5, 2021 at 10:24 PM Kumar Kartikeya Dwivedi
> <memxor@gmail.com> wrote:
> >
> > On Wed, Oct 06, 2021 at 10:11:29AM IST, Andrii Nakryiko wrote:
> > > On Tue, Oct 5, 2021 at 5:29 PM Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
> > > >
> > > > Since the code assumes in various places that BTF fd for modules is
> > > > never 0, if we end up getting fd as 0, obtain a new fd > 0. Even though
> > > > fd 0 being free for allocation is usually an application error, it is
> > > > still possible that we end up getting fd 0 if the application explicitly
> > > > closes its stdin. Deal with this by getting a new fd using dup and
> > > > closing fd 0.
> > > >
> > > > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > > > ---
> > > >  tools/lib/bpf/libbpf.c | 14 ++++++++++++++
> > > >  1 file changed, 14 insertions(+)
> > > >
> > > > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > > > index d286dec73b5f..3e5e460fe63e 100644
> > > > --- a/tools/lib/bpf/libbpf.c
> > > > +++ b/tools/lib/bpf/libbpf.c
> > > > @@ -4975,6 +4975,20 @@ static int load_module_btfs(struct bpf_object *obj)
> > > >                         pr_warn("failed to get BTF object #%d FD: %d\n", id, err);
> > > >                         return err;
> > > >                 }
> > > > +               /* Make sure module BTF fd is never 0, as kernel depends on it
> > > > +                * being > 0 to distinguish between vmlinux and module BTFs,
> > > > +                * e.g. for BPF_PSEUDO_BTF_ID ld_imm64 insns (ksyms).
> > > > +                */
> > > > +               if (!fd) {
> > > > +                       fd = dup(0);
> > >
> > > This is not the only place where we make assumptions that fd > 0 but
> > > technically can get fd == 0. Instead of doing such a check in every
> > > such place, would it be possible to open (cheaply) some FD (/dev/null
> > > or whatever, don't know what's the best file to open), if we detect
> > > that FD == 0 is not allocated? Can we detect that fd 0 is not
> > > allocated?
> > >
> >
> > We can, e.g. using access("/proc/self/fd/0", F_OK), but I think just calling
> > open unconditonally and doing if (ret > 0) close(ret) is better. Also, do I
>
> yeah, I like this idea, let's go with it

FYI some production environments may detect that FDs 0,1,2 are not
pointing to stdin, stdout, stderr and will force close whatever files are there
and open 0,1,2 with canonical files.

libbpf doesn't have to resort to such measures, but it would be prudent to
make libbpf operate on FDs > 2 for all bpf objects to make sure other
frameworks don't ruin libbpf's view of FDs.
