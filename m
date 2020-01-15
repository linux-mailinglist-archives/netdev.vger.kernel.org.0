Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B887A13B9DA
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 07:43:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729140AbgAOGlL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 01:41:11 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:45338 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbgAOGlK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 01:41:10 -0500
Received: by mail-qk1-f194.google.com with SMTP id x1so14669914qkl.12;
        Tue, 14 Jan 2020 22:41:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g10iVwTLydyduQitYL7dAnpOhmhB3UwIsOF+ltahW8s=;
        b=irjpI7/3lFCE2vbVDydcIjl9rBZ3RIi7PhdklEk3PblddLSw/4xvcfzu2VzuSMHbh4
         0sQODjJHIWrUEopI6aGH9jBloApchJNsrd4Wh8c+Z+NxYBa2RPYxo3xeRlJZXENBmh/X
         5ht10TlKqjavQhjXFeK7cunBHQKM1wGE4ccyycFXLDGS0z5Lfkjzzveb7BKa+dtKBWaI
         P+UjZAmTrkfP5bILEeIumNiTQg0QCXrtM1nVTu7450H+QXwUfKFrwxDBuApg7/ONsjFf
         oLhLWWpLwVGG/v6y5qr1Lrjqqp7zX7K47e7HHY2gkATm3jvFtvSxuMY7o+bwTJuOo2ae
         e0Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g10iVwTLydyduQitYL7dAnpOhmhB3UwIsOF+ltahW8s=;
        b=FL5iZLDkTeEak2PDLPhqY1gjZzoAH94QbVpA1GtUspUNkOQMsHRMXGbi8phqaCJC6p
         NmjgrxsNTdokCp/pS4P/lBHVBJwFKJVg9O+0F0asesPRxg+CxQ3rnd2c6sjdA3Li24pd
         4Pulok7f/jWNxjFa5i4VKlhkESdq3z+u0n+IL6RUnRBdGIeVQJaV3Lk52qPGQ43Xeosf
         42eSF50w2m0J1xKbAfeAybhCFeS7WHBMw4IForHQka93IWtf/wUtelYTYT0pLW6mMA2Q
         7YLWrL/mRqiThPj/R+9i/iZN/48k+CtsJPb7zPOBzTe9tvzDF1lWZTbV01dXhtPmxsdY
         glKQ==
X-Gm-Message-State: APjAAAWP75QsTurh/fctd6sSBc+WZYclrGJp6cjDgG1vzRZURweD5A58
        JIMJGo8T2UY0bFh/sgoAVxjdljhi67QtPE1Qcfr0lQ==
X-Google-Smtp-Source: APXvYqxr2OTohEiP7kY+Tsz9VwaVVW0FUZ829XgoGfAzb9juD4uZsS/9PXh4DaQDHmvbuTl6KuA0BsCGcIbe54k7OWU=
X-Received: by 2002:a37:a685:: with SMTP id p127mr22091084qke.449.1579070469532;
 Tue, 14 Jan 2020 22:41:09 -0800 (PST)
MIME-Version: 1.0
References: <20200114224358.3027079-1-kafai@fb.com> <20200114224400.3027140-1-kafai@fb.com>
 <CAEf4BzZd-NmpJqYStpDTSAFmN=EDCLftqoYBaSAKECOY8ooR_w@mail.gmail.com> <20200115054554.sb4nrpmvaulnqya3@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200115054554.sb4nrpmvaulnqya3@kafai-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 14 Jan 2020 22:40:58 -0800
Message-ID: <CAEf4BzY5U+yuTaRUoCRvUzxWz13HTi=-c1X58W3kGWzjM3Zf1w@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/5] bpftool: Fix a leak of btf object
To:     Martin Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Paul Chaignon <paul.chaignon@orange.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 14, 2020 at 9:46 PM Martin Lau <kafai@fb.com> wrote:
>
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
> > this is clearly a simplification, but isn't do_dump still buggy? see below
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
> > >                         p_err("can't get map info: %s", strerror(errno));
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
>
> Can the output format for with and without BTF somehow merged for
> plain text?  May be if it is still common to have no-BTF map
> going forward but how this may look like will need another
> discussion.

I see, ok, seems like that behavior was intentional, I didn't mean to
start a new discussion about format :)

Acked-by: Andrii Nakryiko <andriin@fb.com>

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
