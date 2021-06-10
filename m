Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 236BD3A2DDF
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 16:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231318AbhFJOS7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 10:18:59 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:53862 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231311AbhFJOS7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 10:18:59 -0400
Received: by mail-pj1-f68.google.com with SMTP id ei4so3735189pjb.3;
        Thu, 10 Jun 2021 07:16:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=uxU1sRPy82qzM8PGEc1AnIUO/jJwqnOq6u90vPG+4es=;
        b=nBlqMFvxaVnlF+PRlqyZwvNGXJTFFOGCIKZ/ABzQpILyh9eYZsgu9Y36Kyq8iEU+kI
         G9oSW8q9f+AftNe+vc5WZIwlg66vOtigZymuTA1kbSCrfaYTSW2Ce/5U0dDjjK5Up5+F
         lOmbg4MPR51TR/Gp4KmpHLR6K2O862gmZ99zISJEzJeg5gbpZajmRwxeR40S6GhfX4WM
         4sgo/K5nI1kJu+BJnBC3Ipaw5wxx+QPHeQtH6bXgA9lZNKSdk5r9xiDCXAv00aJNnjY4
         FadCI9PdoUdP/KFhQsx/2eF3UxBFl/a6kDwXaxP1bVjpwv8r/5GVcPeFwP+YBuhY3FsL
         96xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=uxU1sRPy82qzM8PGEc1AnIUO/jJwqnOq6u90vPG+4es=;
        b=dd5jY8wgg5lQBG6bXpM4pXey5+mzEugkJsml9Oo/5nEwwYFzeN2jBF6BhmYPOVRLeo
         3Wui4yMSLincyWho14pzcDugP+QCwhg9OYOwwlxgMue32vOaS2vk1HBiepHd4GVUdwkj
         ZetjGPp7SA+YkYPwVTjc+/8QHEPxjqnX3TWIbzCtylOeNyiYcovSzWl6RqcHdM/S4Ejh
         rdbp6iiFXThtIYfvhWHKgKnRiGYlgJyzi9tRZGzA20oTme6lvJUexRH7b+n4MhOElcnO
         R8eewlYkPJ7wn+yjfP8Qse3ssl+ZxHBcg7aZ568RKjTbmQVnB0fb3B2MPPaER9L+1O/f
         aR9Q==
X-Gm-Message-State: AOAM533qddgjJd8e/RXZCl1rwyzCTVh0KgkbWZy/TiM2S6TjsElpwMF2
        j2FULxLj8lk5rpqqU81a6Nc=
X-Google-Smtp-Source: ABdhPJxNDOYZzf4QZsKM/8W5jFEq3wBslN5U5wJk/s0xHnVi9CadPEQyKmwWnAZt69t7V7r0uVvGgA==
X-Received: by 2002:a17:902:d305:b029:10d:c8a3:657f with SMTP id b5-20020a170902d305b029010dc8a3657fmr5153753plc.0.1623334550508;
        Thu, 10 Jun 2021 07:15:50 -0700 (PDT)
Received: from localhost ([2402:3a80:11f3:7d86:b9c5:b354:a41:265f])
        by smtp.gmail.com with ESMTPSA id q91sm2830999pja.50.2021.06.10.07.15.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 07:15:50 -0700 (PDT)
Date:   Thu, 10 Jun 2021 19:44:34 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 4/7] net: sched: add lightweight update path
 for cls_bpf
Message-ID: <20210610141434.r335rdrouz7jr3ha@apollo>
References: <20210604063116.234316-1-memxor@gmail.com>
 <20210604063116.234316-5-memxor@gmail.com>
 <CAEf4BzaLdLgwnjajPu=ZtzH+HB=eKKCWMrs3P+uUmQKBuANPew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEf4BzaLdLgwnjajPu=ZtzH+HB=eKKCWMrs3P+uUmQKBuANPew@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 08, 2021 at 05:02:04AM IST, Andrii Nakryiko wrote:
> On Thu, Jun 3, 2021 at 11:32 PM Kumar Kartikeya Dwivedi
> <memxor@gmail.com> wrote:
> >
> > This is used by BPF_LINK_UPDATE to replace the attach SCHED_CLS bpf prog
> > effectively changing the classifier implementation for a given filter
> > owned by a bpf_link.
> >
> > Note that READ_ONCE suffices in this case as the ordering for loads from
> > the filter are implicitly provided by the data dependency on BPF prog
> > pointer.
> >
> > On the writer side we can just use a relaxed WRITE_ONCE store to make
> > sure one or the other value is visible to a reader in cls_bpf_classify.
> > Lifetime is managed using RCU so bpf_prog_put path should wait until
> > readers are done for old_prog.
> >
> > All other parties accessing the BPF prog are under RTNL protection, so
> > need no changes.
> >
> > Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>.
> > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > ---
> >  net/sched/cls_bpf.c | 55 +++++++++++++++++++++++++++++++++++++++++++--
> >  1 file changed, 53 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/sched/cls_bpf.c b/net/sched/cls_bpf.c
> > index bf61ffbb7fd0..f23304685c48 100644
> > --- a/net/sched/cls_bpf.c
> > +++ b/net/sched/cls_bpf.c
> > @@ -9,6 +9,7 @@
> >   * (C) 2013 Daniel Borkmann <dborkman@redhat.com>
> >   */
> >
> > +#include <linux/atomic.h>
> >  #include <linux/module.h>
> >  #include <linux/types.h>
> >  #include <linux/skbuff.h>
> > @@ -104,11 +105,11 @@ static int cls_bpf_classify(struct sk_buff *skb, const struct tcf_proto *tp,
> >                         /* It is safe to push/pull even if skb_shared() */
> >                         __skb_push(skb, skb->mac_len);
> >                         bpf_compute_data_pointers(skb);
> > -                       filter_res = BPF_PROG_RUN(prog->filter, skb);
> > +                       filter_res = BPF_PROG_RUN(READ_ONCE(prog->filter), skb);
> >                         __skb_pull(skb, skb->mac_len);
> >                 } else {
> >                         bpf_compute_data_pointers(skb);
> > -                       filter_res = BPF_PROG_RUN(prog->filter, skb);
> > +                       filter_res = BPF_PROG_RUN(READ_ONCE(prog->filter), skb);
> >                 }
> >
> >                 if (prog->exts_integrated) {
> > @@ -775,6 +776,55 @@ static int cls_bpf_link_detach(struct bpf_link *link)
> >         return 0;
> >  }
> >
> > +static int cls_bpf_link_update(struct bpf_link *link, struct bpf_prog *new_prog,
> > +                              struct bpf_prog *old_prog)
> > +{
> > +       struct cls_bpf_link *cls_link;
> > +       struct cls_bpf_prog cls_prog;
> > +       struct cls_bpf_prog *prog;
> > +       int ret;
> > +
> > +       rtnl_lock();
> > +
> > +       cls_link = container_of(link, struct cls_bpf_link, link);
> > +       if (!cls_link->prog) {
> > +               ret = -ENOLINK;
> > +               goto out;
> > +       }
> > +
> > +       prog = cls_link->prog;
> > +
> > +       /* BPF_F_REPLACEing? */
> > +       if (old_prog && prog->filter != old_prog) {
> > +               ret = -EINVAL;
> > +               goto out;
> > +       }
> > +
> > +       old_prog = prog->filter;
> > +
> > +       if (new_prog == old_prog) {
> > +               ret = 0;
>
> So the contract is that if update is successful, new_prog's refcount
> taken by link_update() in kernel/bpf/syscall.c is transferred here. On
> error, it will be bpf_prog_put() by link_update(). So here you don't
> need extra refcnt, but it's also not an error, so you need to
> bpf_prog_put(new_prog) explicitly to balance out refcnt. See how it's
> done for XDP, for example.
>

Yes, thanks for spotting this.

>
> > +               goto out;
> > +       }
> > +
> > +       cls_prog = *prog;
> > +       cls_prog.filter = new_prog;
> > +
> > +       ret = cls_bpf_offload(prog->tp, &cls_prog, prog, NULL);
> > +       if (ret < 0)
> > +               goto out;
> > +
> > +       WRITE_ONCE(prog->filter, new_prog);
> > +
> > +       bpf_prog_inc(new_prog);
>
> and you don't need this, you already got the reference from link_update()
>

So the reason I still keep an extra refcount is because the existing code on the
netlink side assumes that. Even though the link itself holds a refcount for us,
the actual freeing of cls_bpf_prog may happen independent of bpf_link.

I'll add a comment for this.

> > +       /* release our reference */
> > +       bpf_prog_put(old_prog);
> > +
> > +out:
> > +       rtnl_unlock();
> > +       return ret;
> > +}
> > +
> >  static void __bpf_fill_link_info(struct cls_bpf_link *link,
> >                                  struct bpf_link_info *info)
> >  {
> > @@ -859,6 +909,7 @@ static const struct bpf_link_ops cls_bpf_link_ops = {
> >         .show_fdinfo = cls_bpf_link_show_fdinfo,
> >  #endif
> >         .fill_link_info = cls_bpf_link_fill_link_info,
> > +       .update_prog = cls_bpf_link_update,
> >  };
> >
> >  static inline char *cls_bpf_link_name(u32 prog_id, const char *name)
> > --
> > 2.31.1
> >

--
Kartikeya
