Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D75C589538
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 02:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240103AbiHDASn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 20:18:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236876AbiHDASi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 20:18:38 -0400
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC3C717E33
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 17:18:36 -0700 (PDT)
Received: by mail-qv1-xf2b.google.com with SMTP id y11so14114269qvn.3
        for <netdev@vger.kernel.org>; Wed, 03 Aug 2022 17:18:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3To6LMVxoqoKzRmQbA8Jez/sB+9ti+KFrFIpcpqC5DU=;
        b=jaFMYrAr15hi7try/jB5s91PiWR8kMLB484AM76aPEsChXhIBD+lTzzNWQs7YTYffC
         63bFlVKk/ZG9whwY4EzkRsgp56VkFoRTAi46PNFdqCIVS5abYmdTkqyYEfi6IXTHpx52
         NzZEmvnFruMTy2bQtwEpsrjGHOS+HJw3v24rafEiQbLO2WCtUWMg1dTnDoa/wPK7bpPA
         ZDpkYHp29JtKjxj0PdUJYC1hknjlPP/1LBYX8EFh+xET+Qa4YK4rmKgX3RZdhGdwntmC
         Dog0Dn1Z1X7nq0Ponu0M/n1lUbjjAv/lXEId6u+zqwop41RL4jilX4EHM1/wUWqYwks2
         lHug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3To6LMVxoqoKzRmQbA8Jez/sB+9ti+KFrFIpcpqC5DU=;
        b=MOczeXervnPvJrvDbWPEz1+hT1aYSOzBLzHKnG/XUrxEgu7Mq1BJsc9kaGl34T+fde
         sAxt6jwIUE4XgLL7T589oYG3lDaZsAA2TFcbF8A/dzAUKZhXRLBoVXpkBHkKiFZnfC42
         hPrFXbVmXgbqrV2B0uV/b1t7wEjHHzNubv0Z996fD/D62KH+iDtClfhdnpFlpWDLnnXO
         HkSDnpaMFzfSTQ+xRzDQ4mPJIUzItRKPKkeNxrNVY6XbsCpF3Gt4axvUTX8o4s05Ook8
         ETarxik+FZROd5UYDMHpZ+76K3TlUg03K/9Juxb338daQMRbiCIj1PFvHlwr21a/vkdx
         oC8w==
X-Gm-Message-State: ACgBeo07ui4iKbc2Tle/gTybAzmK+bjkmVErg/nqD64eoPc3E/N+Q5Ps
        U7sIPqi0nbCzwa4AZuw1fmZzmR5OagO5FROE2gSXOQ==
X-Google-Smtp-Source: AA6agR56HJ7ItpZidaVhaD1cOoLc3NenmgaBxnC/k/Z1/A7MiHOP5q4pPn9CxMTyXfYtA5LvUWRUAOIlNT8Nb5+rfuU=
X-Received: by 2002:a0c:9101:0:b0:473:9b:d92a with SMTP id q1-20020a0c9101000000b00473009bd92amr24057537qvq.17.1659572315631;
 Wed, 03 Aug 2022 17:18:35 -0700 (PDT)
MIME-Version: 1.0
References: <20220801175407.2647869-1-haoluo@google.com> <20220801175407.2647869-5-haoluo@google.com>
 <c018a834-e834-270c-24b1-2c726b38b729@fb.com>
In-Reply-To: <c018a834-e834-270c-24b1-2c726b38b729@fb.com>
From:   Hao Luo <haoluo@google.com>
Date:   Wed, 3 Aug 2022 17:18:25 -0700
Message-ID: <CA+khW7hSFU2YL+jNw2F2qsuYEW0E6r8kJkg1BoBukAqR_sk+6Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v6 4/8] bpf: Introduce cgroup iter
To:     Yonghong Song <yhs@fb.com>
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        cgroups@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Tejun Heo <tj@kernel.org>,
        Zefan Li <lizefan.x@bytedance.com>,
        KP Singh <kpsingh@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Michal Koutny <mkoutny@suse.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        David Rientjes <rientjes@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Yosry Ahmed <yosryahmed@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 3, 2022 at 12:44 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 8/1/22 10:54 AM, Hao Luo wrote:
> > Cgroup_iter is a type of bpf_iter. It walks over cgroups in three modes:
> >
> >   - walking a cgroup's descendants in pre-order.
> >   - walking a cgroup's descendants in post-order.
> >   - walking a cgroup's ancestors.
> >
> > When attaching cgroup_iter, one can set a cgroup to the iter_link
> > created from attaching. This cgroup is passed as a file descriptor and
> > serves as the starting point of the walk. If no cgroup is specified,
> > the starting point will be the root cgroup.
> >
> > For walking descendants, one can specify the order: either pre-order or
> > post-order. For walking ancestors, the walk starts at the specified
> > cgroup and ends at the root.
> >
> > One can also terminate the walk early by returning 1 from the iter
> > program.
> >
> > Note that because walking cgroup hierarchy holds cgroup_mutex, the iter
> > program is called with cgroup_mutex held.
> >
> > Currently only one session is supported, which means, depending on the
> > volume of data bpf program intends to send to user space, the number
> > of cgroups that can be walked is limited. For example, given the current
> > buffer size is 8 * PAGE_SIZE, if the program sends 64B data for each
> > cgroup, assuming PAGE_SIZE is 4kb, the total number of cgroups that can
> > be walked is 512. This is a limitation of cgroup_iter. If the output
> > data is larger than the buffer size, the second read() will signal
> > EOPNOTSUPP. In order to work around, the user may have to update their
>
> 'the second read() will signal EOPNOTSUPP' is not true. for bpf_iter,
> we have user buffer from read() syscall and kernel buffer. The above
> buffer size like 8 * PAGE_SIZE refers to the kernel buffer size.
>
> If read() syscall buffer size is less than kernel buffer size,
> the second read() will not signal EOPNOTSUPP. So to make it precise,
> we can say
>    If the output data is larger than the kernel buffer size, after
>    all data in the kernel buffer is consumed by user space, the
>    subsequent read() syscall will signal EOPNOTSUPP.
>

Thanks Yonghong. Will update.

> > program to reduce the volume of data sent to output. For example, skip
> > some uninteresting cgroups. In future, we may extend bpf_iter flags to
> > allow customizing buffer size.
> >
> > Acked-by: Yonghong Song <yhs@fb.com>
> > Acked-by: Tejun Heo <tj@kernel.org>
> > Signed-off-by: Hao Luo <haoluo@google.com>
> > ---
[...]
> > + *
> > + * Currently only one session is supported, which means, depending on the
> > + * volume of data bpf program intends to send to user space, the number
> > + * of cgroups that can be walked is limited. For example, given the current
> > + * buffer size is 8 * PAGE_SIZE, if the program sends 64B data for each
> > + * cgroup, assuming PAGE_SIZE is 4kb, the total number of cgroups that can
> > + * be walked is 512. This is a limitation of cgroup_iter. If the output data
> > + * is larger than the buffer size, the second read() will signal EOPNOTSUPP.
> > + * In order to work around, the user may have to update their program to
>
> same here as above for better description.
>

SG. Will update.

> > + * reduce the volume of data sent to output. For example, skip some
> > + * uninteresting cgroups.
> > + */
> > +
> > +struct bpf_iter__cgroup {
> > +     __bpf_md_ptr(struct bpf_iter_meta *, meta);
> > +     __bpf_md_ptr(struct cgroup *, cgroup);
> > +};
> > +
> > +struct cgroup_iter_priv {
> > +     struct cgroup_subsys_state *start_css;
> > +     bool visited_all;
> > +     bool terminate;
> > +     int order;
> > +};
> > +
> > +static void *cgroup_iter_seq_start(struct seq_file *seq, loff_t *pos)
> > +{
> > +     struct cgroup_iter_priv *p = seq->private;
> > +
> > +     mutex_lock(&cgroup_mutex);
> > +
> > +     /* cgroup_iter doesn't support read across multiple sessions. */
> > +     if (*pos > 0) {
> > +             if (p->visited_all)
> > +                     return NULL;
>
> This looks good. thanks!
>
> > +
> > +             /* Haven't visited all, but because cgroup_mutex has dropped,
> > +              * return -EOPNOTSUPP to indicate incomplete iteration.
> > +              */
> > +             return ERR_PTR(-EOPNOTSUPP);
> > +     }
> > +
> > +     ++*pos;
> > +     p->terminate = false;
> > +     p->visited_all = false;
> > +     if (p->order == BPF_ITER_CGROUP_PRE)
> > +             return css_next_descendant_pre(NULL, p->start_css);
> > +     else if (p->order == BPF_ITER_CGROUP_POST)
> > +             return css_next_descendant_post(NULL, p->start_css);
> > +     else /* BPF_ITER_CGROUP_PARENT_UP */
> > +             return p->start_css;
> > +}
> > +
> [...]
