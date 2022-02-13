Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 775364B3B1F
	for <lists+netdev@lfdr.de>; Sun, 13 Feb 2022 12:27:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235346AbiBML1p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 06:27:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235333AbiBML1o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 06:27:44 -0500
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFB6A5B3FD;
        Sun, 13 Feb 2022 03:27:38 -0800 (PST)
Received: by mail-qt1-x82f.google.com with SMTP id j12so13210835qtr.2;
        Sun, 13 Feb 2022 03:27:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xaIEMzpw0OPlZf2umWu2/drQJOP/e2S4KwugUjFZF68=;
        b=Yhja+7r4JD/ChbDzbijerP10d2KWtMMr6yusiK7jrgrwlN2p0SfQmqp2SHCPslvx3L
         RvEw5Os1LpJLNE43osp3TBJDjbqRuZLssyBIvjoOCMzEnvjsRpMpKUev1r/YIegH/1rf
         yGV3gPXz2UANWqazstiBneB+gBfs395qq2CBykfSr+5DR6M/LqIsSyg+wQHP2D/wyb+x
         CUkDRedocb5b3pZ/Ag/k5v74Uj/Ip5CHmWn94F2CKtdyeUSiLDVTlQZGxa2PHXRgtDjf
         XLqQ29sTj+Sia7BHX6pQoSDIY/QZhpTkKXzNFir6xQio1D/qU9VEsw+WXE2zkMNR6SeQ
         mNVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xaIEMzpw0OPlZf2umWu2/drQJOP/e2S4KwugUjFZF68=;
        b=HnaXT1dwcTBl4YOy1H/mBfuIuggsqNhbgosTW/azMPerUbzy/j5N3K4CbwtOQLHO4N
         djXyTxRGculDdWZYfr56IHIWRvdqbadEfPoqRWEbybxQS7+8arBGyweDcAe578ioiAUy
         idfhrJN057FOB4L8TSPAJlwZmZhIi/gMwwtnwMHX/9DRAnQwALct6Xdz9YBmiE36aWg/
         1FzMNzDYNmIUebPJ+uYLgpx3hmwZH3h6lK17vKTRL9/Grq/fmrld3gBYw9VmIy3q3NCg
         F/jQg5m5JUVx0eRA3UKw8u+I0br3ShKPFd3SnMRC2lmOY4ejgySpsbFg4ey2n0IG0IKm
         GGmw==
X-Gm-Message-State: AOAM530Tp4naY+LAk8WHkFl7fouQPh4eNpFy+iE/LNJyEYRxqRC/mJxh
        xb3+PpqcTKjn0UeVxN5XOiAlRJkU+r1QIIqbo1BC46BVPTk=
X-Google-Smtp-Source: ABdhPJwI83w7NYT63BhdpazEQStvC987uecObAy7ql/Az9nxEaLNb6nFPLJBn/mJpkIopMtSfy1Uj2KvSlGGSkH5aOE=
X-Received: by 2002:a05:622a:1649:: with SMTP id y9mr6290453qtj.685.1644751657474;
 Sun, 13 Feb 2022 03:27:37 -0800 (PST)
MIME-Version: 1.0
References: <20220211121145.35237-1-laoar.shao@gmail.com> <20220211121145.35237-2-laoar.shao@gmail.com>
 <9db9fcb9-69de-5fb5-c80a-ade5f36ea039@iogearbox.net>
In-Reply-To: <9db9fcb9-69de-5fb5-c80a-ade5f36ea039@iogearbox.net>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Sun, 13 Feb 2022 19:27:01 +0800
Message-ID: <CALOAHbAeuE+zc4z4P4t=boDk25_CZ9fgMosVn5eDt6uVYofyfw@mail.gmail.com>
Subject: Re: [PATCH 1/4] bpf: Add pin_name into struct bpf_prog_aux
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 11, 2022 at 8:43 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 2/11/22 1:11 PM, Yafang Shao wrote:
> > A new member pin_name is added into struct bpf_prog_aux, which will be
> > set when the prog is set and cleared when the pinned file is removed.
> >
> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > ---
> >   include/linux/bpf.h      |  2 ++
> >   include/uapi/linux/bpf.h |  1 +
> >   kernel/bpf/inode.c       | 20 +++++++++++++++++++-
> >   3 files changed, 22 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > index 0ceb25b..9cf8055 100644
> > --- a/include/linux/bpf.h
> > +++ b/include/linux/bpf.h
> > @@ -933,6 +933,8 @@ struct bpf_prog_aux {
> >               struct work_struct work;
> >               struct rcu_head rcu;
> >       };
> > +
> > +     char pin_name[BPF_PIN_NAME_LEN];
> >   };
>
> I'm afraid this is not possible. You are assuming a 1:1 relationship between prog
> and pin location, but it's really a 1:n (prog can be pinned in multiple locations
> and also across multiple mount instances).

Thanks for the explanation!
I didn't notice the 1:n relationship before. I will read the code more
to try to find if there's a good way to implement it.

> Also, you can create hard links of pins
> which are not handled via bpf_obj_do_pin().
>

Yes, it seems we should introduce bpf_{link, unlink, rename} first
instead of the simple_* one.

> >   struct bpf_array_aux {
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index c14fed8..bada5cc 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -1217,6 +1217,7 @@ struct bpf_stack_build_id {
> >   };
> >
> >   #define BPF_OBJ_NAME_LEN 16U
> > +#define BPF_PIN_NAME_LEN 64U
> >
> >   union bpf_attr {
> >       struct { /* anonymous struct used by BPF_MAP_CREATE command */
> > diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
> > index 4477ca8..f1a8811 100644
> > --- a/kernel/bpf/inode.c
> > +++ b/kernel/bpf/inode.c
> > @@ -437,6 +437,8 @@ static int bpf_iter_link_pin_kernel(struct dentry *parent,
> >   static int bpf_obj_do_pin(const char __user *pathname, void *raw,
> >                         enum bpf_type type)
> >   {
> > +     struct bpf_prog_aux *aux;
> > +     struct bpf_prog *prog;
> >       struct dentry *dentry;
> >       struct inode *dir;
> >       struct path path;
> > @@ -461,6 +463,10 @@ static int bpf_obj_do_pin(const char __user *pathname, void *raw,
> >
> >       switch (type) {
> >       case BPF_TYPE_PROG:
> > +             prog = raw;
> > +             aux = prog->aux;
> > +             (void) strncpy_from_user(aux->pin_name, pathname, BPF_PIN_NAME_LEN);
> > +             aux->pin_name[BPF_PIN_NAME_LEN - 1] = '\0';
> >               ret = vfs_mkobj(dentry, mode, bpf_mkprog, raw);
> >               break;
> >       case BPF_TYPE_MAP:
> > @@ -611,12 +617,24 @@ static int bpf_show_options(struct seq_file *m, struct dentry *root)
> >
> >   static void bpf_free_inode(struct inode *inode)
> >   {
> > +     struct bpf_prog_aux *aux;
> > +     struct bpf_prog *prog;
> >       enum bpf_type type;
> >
> >       if (S_ISLNK(inode->i_mode))
> >               kfree(inode->i_link);
> > -     if (!bpf_inode_type(inode, &type))
> > +     if (!bpf_inode_type(inode, &type)) {
> > +             switch (type) {
> > +             case BPF_TYPE_PROG:
> > +                     prog = inode->i_private;
> > +                     aux = prog->aux;
> > +                     aux->pin_name[0] = '\0';
> > +                     break;
> > +             default:
> > +                     break;
> > +             }
> >               bpf_any_put(inode->i_private, type);
> > +     }
> >       free_inode_nonrcu(inode);
> >   }
> >
> >
>


-- 
Thanks
Yafang
