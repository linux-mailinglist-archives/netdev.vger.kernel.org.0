Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E11D13D57F
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 09:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730499AbgAPIAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 03:00:31 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39421 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbgAPIAb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 03:00:31 -0500
Received: by mail-wm1-f65.google.com with SMTP id 20so2686074wmj.4;
        Thu, 16 Jan 2020 00:00:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kIWLrEPqoZsEwTtPYVEXfDWENndJVyWp7Nht3dPvSHY=;
        b=Lze4sC2cO6oqhLRAI1LcYWFfW+p1IdCFq8IQ52OFC0iM+8SHL+XC0U1nBpRLta5Jcg
         guYwqHpCx2SwZZJiNMPrSo+1Y+btt83OHHcCvztHpfAVFPYO/8pbDPHUsqLvKOMi9sgl
         lAxEFKYZMnqixH9rC6PTLSoheDlNbs1/mwhZaXmQ3qlqJLaQNOsqjvALkRhq4oNPkkY1
         RyAsKTHNprsbucuk7sx+fWKffavgqaMjUxj+8pohwsFIOat6cNigGMkaAro/LYb9/Bt3
         KVC22TawoaVZbwTI+bJ/LU0wsIGYKtkIB9RjQUvMKqlPNTCDphvNz6Kst2SIFkfiqPNH
         jI3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kIWLrEPqoZsEwTtPYVEXfDWENndJVyWp7Nht3dPvSHY=;
        b=FBc7cc3/XMoRm23udAkdgcbZqsErSGUgZ8PaoRDR5ZRwJE5qobONSRwhGt3xgqY6Kb
         8bJkfBCKo9WrtrKKsAX8NNb6nHvF1ws3FGID3BPMmfrCpXlv3X2HBE4jYxS4Gv2DwpDH
         Cy9a/7QyBtScPomYrJW/x6TmNcPQsJ4xji++pPV36KT2cl4uJXbre1lO4G3zmfudHoLb
         mr8RxMWfOpP04nE9rY3vsKfEO03W3COpfgNsK9dzSY1BG7sFcbFtGRyiY/YSTwRAXsqS
         pt4RclIt7BVKREwd8xL8BhDLAON0LY8XzPE4/caJKmX65C3Fw7chsj3MJI8UgaxhwafB
         yskA==
X-Gm-Message-State: APjAAAV6p4vlPO59X/ppueZCaQzDHUlHwqYSRSPhni+Tm/IZiqac+ViQ
        Fk5CLatn6Befb7WhMKSVO1A=
X-Google-Smtp-Source: APXvYqyKZDSuz0Sse+KI3T28GA/7jLcxgB3T5E47WvsT3jjsS4LuD3/aywMIArPRVJwV5wafnUzHlg==
X-Received: by 2002:a7b:c450:: with SMTP id l16mr4732084wmi.31.1579161627767;
        Thu, 16 Jan 2020 00:00:27 -0800 (PST)
Received: from Omicron ([145.136.49.157])
        by smtp.gmail.com with ESMTPSA id u24sm3320189wml.10.2020.01.16.00.00.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 00:00:24 -0800 (PST)
Date:   Thu, 16 Jan 2020 09:00:23 +0100
From:   Paul Chaignon <paul.chaignon@gmail.com>
To:     Martin Lau <kafai@fb.com>
Cc:     Paul Chaignon <paul.chaignon@orange.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Subject: Re: [PATCH bpf-next 1/5] bpftool: Fix a leak of btf object
Message-ID: <CAO5pjwQ2rAnjvrUOqHyfu31bYjhwVz4bub=rA=N7zkabO+nFgA@mail.gmail.com>
References: <20200114224358.3027079-1-kafai@fb.com>
 <20200114224400.3027140-1-kafai@fb.com>
 <CAEf4BzZd-NmpJqYStpDTSAFmN=EDCLftqoYBaSAKECOY8ooR_w@mail.gmail.com>
 <20200115054554.sb4nrpmvaulnqya3@kafai-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200115054554.sb4nrpmvaulnqya3@kafai-mbp.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 15, 2020 at 6:46 AM Martin Lau <kafai@fb.com> wrote:
> On Tue, Jan 14, 2020 at 05:10:03PM -0800, Andrii Nakryiko wrote:
> > On Tue, Jan 14, 2020 at 2:44 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > >
> > > When testing a map has btf or not, maps_have_btf() tests it by actually
> > > getting a btf_fd from sys_bpf(BPF_BTF_GET_FD_BY_ID). However, it
> > > forgot to btf__free() it.
> > >
> > > In maps_have_btf() stage, there is no need to test it by really
> > > calling sys_bpf(BPF_BTF_GET_FD_BY_ID). Testing non zero
> > > info.btf_id is good enough.
> > >
> > > Also, the err_close case is unnecessary, and also causes double
> > > close() because the calling func do_dump() will close() all fds again.
> > >
> > > Fixes: 99f9863a0c45 ("bpftool: Match maps by name")
> > > Cc: Paul Chaignon <paul.chaignon@orange.com>
> > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > ---
> >
> > this is clearly a simplification, but isn't do_dump still buggy? see
> below
> >
> > >  tools/bpf/bpftool/map.c | 16 ++--------------
> > >  1 file changed, 2 insertions(+), 14 deletions(-)
> > >
> > > diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
> > > index c01f76fa6876..e00e9e19d6b7 100644
> > > --- a/tools/bpf/bpftool/map.c
> > > +++ b/tools/bpf/bpftool/map.c
> > > @@ -915,32 +915,20 @@ static int maps_have_btf(int *fds, int nb_fds)
> > >  {
> > >         struct bpf_map_info info = {};
> > >         __u32 len = sizeof(info);
> > > -       struct btf *btf = NULL;
> > >         int err, i;
> > >
> > >         for (i = 0; i < nb_fds; i++) {
> > >                 err = bpf_obj_get_info_by_fd(fds[i], &info, &len);
> > >                 if (err) {
> > >                         p_err("can't get map info: %s",
> strerror(errno));
> > > -                       goto err_close;
> > > -               }
> > > -
> > > -               err = btf__get_from_id(info.btf_id, &btf);
> > > -               if (err) {
> > > -                       p_err("failed to get btf");
> > > -                       goto err_close;
> > > +                       return -1;
> > >                 }
> > >
> > > -               if (!btf)
> > > +               if (!info.btf_id)
> > >                         return 0;
> >
> > if info.btf_id is non-zero, shouldn't we immediately return 1 and be
> > done with it?
> No.  maps_have_btf() returns 1 only if all the maps have btf.
>
> >
> > I'm also worried about do_dump logic. What's the behavior when some
> > maps do have BTF and some don't? Should we use btf_writer for all,
> > some or none maps for that case?
> For plain_text, btf output is either for all or for none.
> It is the intention of the "Fixes" patch if I read it correctly,
> and it is kept as is in this bug fix.
> It will become clear by doing a plain text dump on maps with and
> without btf.  They are very different.

Yes, that was the intent of my patch.  As you said, I wasn't sure mixes
of BTF/non-BTF maps were common, especially in a batch sharing the same
name.

Thanks for the fixes Martin!


>
> Can the output format for with and without BTF somehow merged for
> plain text?  May be if it is still common to have no-BTF map
> going forward but how this may look like will need another
> discussion.
>
> > I'd expect we'd use BTF info for
> > those maps that have BTF and fall back to raw output for those that
> > don't, but I'm not sure that how code behaves right now.
> The json_output is doing what you described, print BTF info
> whenever available.
>
> >
> > Maybe Paul can clarify...
> >
> >
> > >         }
> > >
> > >         return 1;
> > > -
> > > -err_close:
> > > -       for (; i < nb_fds; i++)
> > > -               close(fds[i]);
> > > -       return -1;
> > >  }
> > >
> > >  static int
> > > --
> > > 2.17.1
> > >
>
