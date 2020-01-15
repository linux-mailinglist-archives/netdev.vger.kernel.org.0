Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69B5A13B9C4
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 07:37:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729186AbgAOGhD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 01:37:03 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:39199 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726408AbgAOGhD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 01:37:03 -0500
Received: by mail-qt1-f195.google.com with SMTP id e5so14862331qtm.6;
        Tue, 14 Jan 2020 22:37:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uCV3OdMIlfxmQUB7b73DLTCy3NtPcS6hNnVmkkoXKEo=;
        b=W+UtXvuaDmEC/TwN+x0Ow7z7zmi/aZt/6h/paZ6Lr57qbQF3P963NCJCVcX3Aoagqa
         YZu6A7g1p4CQ2RYP7s7Au/edZzPfHWORiXahaFFfbGsIJvrHeOpK4NT+J2kTo8x5ZdBA
         Iu5m4fSdLaFPbCmj7MJJns6Acst7BMyFt0B9UlrTekUq7/zbBunPnmQsy5Z4jVS3oxgW
         XVk81iVPCYNj1MFxpOD36Mb80Iv9TuPJccTCfwZkzrbYhIDHAGKT1NspHVBe8TFXMkPg
         vNl+7w/n2VLrErbHMMMS02TyfpLCk2ExS/ObSBQ7jRXiYbnudMU9cMGhSgDYEIAPO3CV
         PrtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uCV3OdMIlfxmQUB7b73DLTCy3NtPcS6hNnVmkkoXKEo=;
        b=ia/WfTmFX7H2qoMgZaFzTy7P51m2l6Pf8YGADybKLuoBC6GIu+duCdtetjKHKjgFro
         S2jpD5TCN4vC2MpBdY2JrJbZ5qUq74mg1QhfOUl3KioEa6owidlEBm6V/+egK17CTDc2
         MCTbKeZCK/F+BDlal6xd/wWckZ3ImJ8GMRNJC+gJGTI4uKZLrqLOMWp3cLDnik6Wzr5a
         1E2RH/KGUHzQ6m4xZfo/zbejOqsBzrR+F6wjpjhRdeo29g/AQA4LXfzlHg2NlrIqULXe
         s2s2Tnzuij99O8RYZBNN7EazthRpahFPUnwIje9J2jiWOLm+L9GqqLX2QCKPOjKycooE
         sEYQ==
X-Gm-Message-State: APjAAAWgEgczM/n9k9fQ2m1bAclaws4Xzgzs4lqftw1piijr09Q5G6HF
        pN6oLcX6QOkCmSYTdlns2gFzfVtvbN/q2w72m7o=
X-Google-Smtp-Source: APXvYqw1GF3tEl8d4zG6FEiNHWXrrdaEuwikABOuJT+vsnSiRjK7AmG36OpxUaZ1AVqVrkwgUQulfr81KKD4BRkewU8=
X-Received: by 2002:ac8:1385:: with SMTP id h5mr2091837qtj.59.1579070221937;
 Tue, 14 Jan 2020 22:37:01 -0800 (PST)
MIME-Version: 1.0
References: <20200114224358.3027079-1-kafai@fb.com> <20200114224406.3027562-1-kafai@fb.com>
 <CAEf4BzbrcKLKvgKY+nSxV22T2nHgucmB2N01bEQiXS+g7npQfw@mail.gmail.com> <20200115055406.gsouajufdzussm6e@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200115055406.gsouajufdzussm6e@kafai-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 14 Jan 2020 22:36:51 -0800
Message-ID: <CAEf4BzZpvt+zNxMwAUjebNCQLpwHzX_Abj=efQXghjxjL6VKzg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/5] bpftool: Fix missing BTF output for json
 during map dump
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

On Tue, Jan 14, 2020 at 9:54 PM Martin Lau <kafai@fb.com> wrote:
>
> On Tue, Jan 14, 2020 at 05:34:33PM -0800, Andrii Nakryiko wrote:
> > On Tue, Jan 14, 2020 at 2:45 PM Martin KaFai Lau <kafai@fb.com> wrote:
> > >
> > > The btf availability check is only done for plain text output.
> > > It causes the whole BTF output went missing when json_output
> > > is used.
> > >
> > > This patch simplifies the logic a little by avoiding passing "int btf" to
> > > map_dump().
> > >
> > > For plain text output, the btf_wtr is only created when the map has
> > > BTF (i.e. info->btf_id != 0).  The nullness of "json_writer_t *wtr"
> > > in map_dump() alone can decide if dumping BTF output is needed.
> > > As long as wtr is not NULL, map_dump() will print out the BTF-described
> > > data whenever a map has BTF available (i.e. info->btf_id != 0)
> > > regardless of json or plain-text output.
> > >
> > > In do_dump(), the "int btf" is also renamed to "int do_plain_btf".
> > >
> > > Fixes: 99f9863a0c45 ("bpftool: Match maps by name")
> > > Cc: Paul Chaignon <paul.chaignon@orange.com>
> > > Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> > > ---
> >
> > just one nit below
> >
> > Acked-by: Andrii Nakryiko <andriin@fb.com>
> >
> > >  tools/bpf/bpftool/map.c | 42 ++++++++++++++++++++---------------------
> > >  1 file changed, 20 insertions(+), 22 deletions(-)
> > >
> > > diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
> > > index e00e9e19d6b7..45c1eda6512c 100644
> > > --- a/tools/bpf/bpftool/map.c
> > > +++ b/tools/bpf/bpftool/map.c
> > > @@ -933,7 +933,7 @@ static int maps_have_btf(int *fds, int nb_fds)
> > >
> > >  static int
> > >  map_dump(int fd, struct bpf_map_info *info, json_writer_t *wtr,
> > > -        bool enable_btf, bool show_header)
> > > +        bool show_header)
> > >  {
> > >         void *key, *value, *prev_key;
> > >         unsigned int num_elems = 0;
> > > @@ -950,18 +950,16 @@ map_dump(int fd, struct bpf_map_info *info, json_writer_t *wtr,
> > >
> > >         prev_key = NULL;
> > >
> > > -       if (enable_btf) {
> > > -               err = btf__get_from_id(info->btf_id, &btf);
> > > -               if (err || !btf) {
> > > -                       /* enable_btf is true only if we've already checked
> > > -                        * that all maps have BTF information.
> > > -                        */
> > > -                       p_err("failed to get btf");
> > > -                       goto exit_free;
> > > +       if (wtr) {
> > > +               if (info->btf_id) {
> >
> > combine into if (wtr && info->btf_id) and reduce nestedness?
> There is other logic under the same "if (wtr)".
> Thus, it is better to leave it as is.

My bad, missed those tiny minuses in diff :) Of course that would be incorrect.

> and this indentation will be gone in patch 5.
>
> >
> >
> > > +                       err = btf__get_from_id(info->btf_id, &btf);
> > > +                       if (err || !btf) {
> > > +                               err = err ? : -ESRCH;
> > > +                               p_err("failed to get btf");
> > > +                               goto exit_free;
> > > +                       }
> >
> > [...]
