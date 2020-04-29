Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72D701BD4AB
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 08:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbgD2Gc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 02:32:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726158AbgD2Gc0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 02:32:26 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B25D9C03C1AD;
        Tue, 28 Apr 2020 23:32:26 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id di6so627113qvb.10;
        Tue, 28 Apr 2020 23:32:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SJInXxZP1iCQBUZ3t7XS7HwLjVSN+Nh+pwJNHGOIzgo=;
        b=co6POFyrEIMd6WjzifsKJ4Betxy0U459bVZzpD48PzyHJK7wPX3vZMurRgdnHeu7Hz
         m2XxwpZ1ztwSMSGq5PmjncttbXKxfbcVdyr4zqp8VPJrWMvgyLMWQE9V3c82pS5l4rRN
         ekc7JTUgkq0hB85Clb8qr+vNNJRxDkQIEdwVflP4TemxmjIS2+8lVwLAEAXZijOyT+XC
         /WFlHF2lMFNY4mgouji93xhkpE8uuOyOZrWrWWZqulhNkaSaDHMcl+pwgFzZomWXNjPP
         RjLYTVidvQxu4bujXU9ZquMh46wOFqv186WzTsWr8xiC2sGvYFAKKWlCbHIgm34fhtwy
         lF1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SJInXxZP1iCQBUZ3t7XS7HwLjVSN+Nh+pwJNHGOIzgo=;
        b=jarP36rYEOjMAL8v2kqKqJAqibl8eSWnza/fmDJR6bwF38AFeN9nH7zanSylwal145
         HRnfbWte16a2HH7hMta2jhmW+LhKUvPxpCNqfqD2zJzTFaffyKNVOF9fC1y6FZciSprw
         u5o+L6d81mzb5mE7mm+rPDInoi3wItqsZIscpxX3Wbxeq3udICFdOQcpEVndA+w9SNYW
         DjsIa4/1+boOhOkUI65qAFT/N4NatFeW6EKD7SFsMnoeyJi4OWznZWC2m1ruqI3HK+of
         h6hg98Ywi+P6YEQCXm20q2Qy0641uqaYjA1WC9caoYIup0h0LNAYTcmGRiK9wVrM7rGb
         t2Wg==
X-Gm-Message-State: AGi0PuZ3IGsuXFVQDYW8i543E77+Bq8KQ/D8Izyukq4bu5n2PcKKeo5u
        cAtQ94UpxaQVqStS38NPcEM7lnwuATHzTW4HGr4=
X-Google-Smtp-Source: APiQypI7IrNmuO4GskYudCjWtbzNsSr3sXuq48hcdZNrRqtKcC6i4XDxrOBdm1X3XJhuuKUeOWr9XbmmUut+biIt8R8=
X-Received: by 2002:a0c:fd8c:: with SMTP id p12mr32142827qvr.163.1588141945916;
 Tue, 28 Apr 2020 23:32:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200427201235.2994549-1-yhs@fb.com> <20200427201241.2995075-1-yhs@fb.com>
 <20200429013239.apxevcpdc3kpqlrq@kafai-mbp> <f63cd9f5-a39e-1fc8-bba3-53ebffef9cc5@fb.com>
 <20200429055838.feupa5leawbduciy@kafai-mbp>
In-Reply-To: <20200429055838.feupa5leawbduciy@kafai-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 28 Apr 2020 23:32:15 -0700
Message-ID: <CAEf4BzabE6FHDMqHRMtf20O1FEv-4x_PiRHdavU7uN_ox_3=rA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 06/19] bpf: support bpf tracing/iter programs
 for BPF_LINK_UPDATE
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 28, 2020 at 10:59 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Tue, Apr 28, 2020 at 10:04:54PM -0700, Yonghong Song wrote:
> >
> >
> > On 4/28/20 6:32 PM, Martin KaFai Lau wrote:
> > > On Mon, Apr 27, 2020 at 01:12:41PM -0700, Yonghong Song wrote:
> > > > Added BPF_LINK_UPDATE support for tracing/iter programs.
> > > > This way, a file based bpf iterator, which holds a reference
> > > > to the link, can have its bpf program updated without
> > > > creating new files.
> > > >
>
> [ ... ]
>
> > > > --- a/kernel/bpf/bpf_iter.c
> > > > +++ b/kernel/bpf/bpf_iter.c
>
> [ ... ]
>
> > > > @@ -121,3 +125,28 @@ int bpf_iter_link_attach(const union bpf_attr *attr, struct bpf_prog *prog)
> > > >                   kfree(link);
> > > >           return err;
> > > >   }
> > > > +
> > > > +int bpf_iter_link_replace(struct bpf_link *link, struct bpf_prog *old_prog,
> > > > +                   struct bpf_prog *new_prog)
> > > > +{
> > > > + int ret = 0;
> > > > +
> > > > + mutex_lock(&bpf_iter_mutex);
> > > > + if (old_prog && link->prog != old_prog) {
> hmm....
>
> If I read this function correctly,
> old_prog could be NULL here and it is only needed during BPF_F_REPLACE
> to ensure it is replacing a particular old_prog, no?

Yes, do you see any problem with the above logic?

>
>
> > > > +         ret = -EPERM;
> > > > +         goto out_unlock;
> > > > + }
> > > > +
> > > > + if (link->prog->type != new_prog->type ||
> > > > +     link->prog->expected_attach_type != new_prog->expected_attach_type ||
> > > > +     strcmp(link->prog->aux->attach_func_name, new_prog->aux->attach_func_name)) {
> > > Can attach_btf_id be compared instead of strcmp()?
> >
> > Yes, we can do it.
> >
> > >
> > > > +         ret = -EINVAL;
> > > > +         goto out_unlock;
> > > > + }
> > > > +
> > > > + link->prog = new_prog;
> > > Does the old link->prog need a bpf_prog_put()?
> >
> > The old_prog is replaced in caller link_update (syscall.c):
>
> > static int link_update(union bpf_attr *attr)
> > {
> >         struct bpf_prog *old_prog = NULL, *new_prog;
> >         struct bpf_link *link;
> >         u32 flags;
> >         int ret;
> > ...
> >         if (link->ops == &bpf_iter_link_lops) {
> >                 ret = bpf_iter_link_replace(link, old_prog, new_prog);
> >                 goto out_put_progs;
> >         }
> >         ret = -EINVAL;
> >
> > out_put_progs:
> >         if (old_prog)
> >                 bpf_prog_put(old_prog);
> The old_prog in link_update() took a separate refcnt from bpf_prog_get().
> I don't see how it is related to the existing refcnt held in the link->prog.
>
> or I am missing something in BPF_F_REPLACE?

Martin is right, bpf_iter_link_replace() needs to drop its own refcnt
on old_prog, in addition to what generic link_update logic does here,
because bpf_link_iter bumped old_prog's refcnt when it was created or
updated last time.
