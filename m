Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 909CF59A303
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 20:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354567AbiHSR2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 13:28:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354565AbiHSR1l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 13:27:41 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71CC0153E35;
        Fri, 19 Aug 2022 09:46:03 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id x23so4596347pll.7;
        Fri, 19 Aug 2022 09:46:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=43IB1l85zFZx2xfIvsACnvdd0hD/Sqi80j0FvnZgz+w=;
        b=JQy2QfMvU993ELBmz2m2IaJHojQluWlc2EN1XG0ztr6V8OaUTHOJN6euMR6ZmYAlbl
         v0gDSEyBQCndO31qlao27Cg9HJjzj49/CDBem77UVSFkGSlC71Kw1brKSCMjzxi5Hfnj
         st8s2amoKpXOB2XplmnOm2Sony8Fk5a8Q21/jD4R+Vl1Ku3mG0/4G4ifVq6qmy0a8fuj
         apyv5fnK9IzqKogBCTmEjTQ3i6v3yXfFFJztAVKLeoGNEaP1vWx4w+k0o9AK2gZNiN+S
         kxlNRXmxImlpHp1cYsPdNZW3sHdtC2KjL+HkwJgEXQ7oaY97sWNrcStYnF/hITQJBwUo
         B13Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc;
        bh=43IB1l85zFZx2xfIvsACnvdd0hD/Sqi80j0FvnZgz+w=;
        b=WkghK2aTx8hWDzwW+lm6fwI16rVLYO0+q9WtbknRV9905ZPgGt0dTfhS/C5rfTNQHp
         PfMHoz43vpC2zBZ8zhxIxkxqgS1sZXIllitsr9phLXDUj3I01ayn/j/+tHX2eZqvwxa5
         5yApVu6GRBxjryYWUxpWKn4dihj2Bw6kZesquMTFVUTMhAvTi/f+IwR/22VMYd1g6Og6
         SEvn3YS07nvkZNLQbyGSJEAsQVvdLpaQqHhpW5FTvOmpEqhD5eTd7Ky+uYEcrxuSXmaT
         r0Aj9Y6nwXau2o7wVHnDvsdPDHS8Ih9Xxc49RZMocYBfdokDF8iYXKcn3zElZ3DE6Vg3
         SmPA==
X-Gm-Message-State: ACgBeo2yJn4ufS8OFf2NGMcrXfUHjtZ2BXEGzlb7agbDihTyPc5R/GP2
        yv/4YnfMttrOHvgpOzhwhw0=
X-Google-Smtp-Source: AA6agR7/XdV145+Mma974ZWG9OzesPe18qlL2A2CqA2hmJsnMTcginuIa1kkrjcH2PeZz70ips7QyA==
X-Received: by 2002:a17:90b:1bce:b0:1fa:ecc3:9068 with SMTP id oa14-20020a17090b1bce00b001faecc39068mr2850604pjb.116.1660927546012;
        Fri, 19 Aug 2022 09:45:46 -0700 (PDT)
Received: from localhost ([2620:10d:c090:400::5:db7d])
        by smtp.gmail.com with ESMTPSA id k1-20020a170902c40100b00172a670607asm3442468plk.300.2022.08.19.09.45.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Aug 2022 09:45:45 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Fri, 19 Aug 2022 06:45:43 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, jolsa@kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeelb@google.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        lizefan.x@bytedance.com, Cgroups <cgroups@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>
Subject: Re: [PATCH bpf-next v2 00/12] bpf: Introduce selectable memcg for
 bpf map
Message-ID: <Yv++N6OFEe6I9uEQ@slm.duckdns.org>
References: <20220818143118.17733-1-laoar.shao@gmail.com>
 <Yv67MRQLPreR9GU5@slm.duckdns.org>
 <CALOAHbDt9NUv9qK_J1_9CU0tmW9kiJ+nig_0NfzGJgJmrSk2fw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALOAHbDt9NUv9qK_J1_9CU0tmW9kiJ+nig_0NfzGJgJmrSk2fw@mail.gmail.com>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Fri, Aug 19, 2022 at 08:59:20AM +0800, Yafang Shao wrote:
> On Fri, Aug 19, 2022 at 6:20 AM Tejun Heo <tj@kernel.org> wrote:
> > memcg folks would have better informed opinions but from generic cgroup pov
> > I don't think this is a good direction to take. This isn't a problem limited
> > to bpf progs and it doesn't make whole lot of sense to solve this for bpf.
> 
> This change is bpf specific. It doesn't refactor a whole lot of things.

I'm not sure what point the above sentence is making. It may not change a
lot of code but it does introduce significantly new mode of operation which
affects memcg and cgroup in general.

> > We have the exact same problem for any resources which span multiple
> > instances of a service including page cache, tmpfs instances and any other
> > thing which can persist longer than procss life time. My current opinion is
> > that this is best solved by introducing an extra cgroup layer to represent
> > the persistent entity and put the per-instance cgroup under it.
> 
> It is not practical on k8s.
> Because, before the persistent entity, the cgroup dir is stateless.
> After, it is stateful.
> Pls, don't continue keeping blind eyes on k8s.

Can you please elaborate why it isn't practical for k8s? I don't know the
details of k8s and what you wrote above is not a detailed enough technical
argument.

> > It does require reorganizing how things are organized from userspace POV but
> > the end result is really desirable. We get entities accurately representing
> > what needs to be tracked and control over the granularity of accounting and
> > control (e.g. folks who don't care about telling apart the current
> > instance's usage can simply not enable controllers at the persistent entity
> > level).
> 
> Pls.s also think about why k8s refuse to use cgroup2.

This attitude really bothers me. You aren't spelling it out fully but
instead of engaging in the technical argument at the hand, you're putting
forth conforming upstream to the current k8s's assumptions and behaviors as
a requirement and then insisting that it's upstream's fault that k8s is
staying with cgroup1.

This is not an acceptable form of argument and it would be irresponsible to
grant any kind weight to this line of reasoning. k8s may seem like the world
to you but it is one of many use cases of the upstream kernel. We all should
pay attention to the use cases and technical arguments to determine how we
chart our way forward, but being k8s or whoever else clearly isn't a waiver
to claim this kind of unilateral demand.

It's okay to emphasize the gravity of the specific use case at hand but
please realize that it's one of the many factors that should be considered
and sometimes one which can and should get trumped by others.

Thanks.

-- 
tejun
