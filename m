Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E90F59CF47
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 05:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239938AbiHWDOG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 23:14:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239926AbiHWDOF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 23:14:05 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70DC82AE2B;
        Mon, 22 Aug 2022 20:14:04 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id x63-20020a17090a6c4500b001fabbf8debfso13302989pjj.4;
        Mon, 22 Aug 2022 20:14:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=ZUaQTOVIdh5xBvCaBb3Q2PJKSpNuIPnigKSbwq//BA0=;
        b=p5JQXzLW/Xthbd5wOYzW8Og2lJZLToL31V32MXDUH2rPEqdvOxbJTtsbehjMq6zYCt
         cxAUeoTbsLnGFCfbetELQkeKGb5rxIISeN9exB0GiOwG4QE4buEPzqKloTmr7wXdtnhW
         gbFAyh7AiYAKZ91PUX37nfVYZZDxMLMRNZtZ6irnJ26OIYzDHheCtc8CCt1DEnAXPMR/
         1P6E4qet6Z4aQEQJgrnK0ZkTrk+dskLvnHtbJV+a3z5jt+OGZXu3RFRozQph0zEuyDRx
         KY/R7uV3lwCFhAjHvikgjzYPO3Ak6Q9o9UOUr4Vjse3NXoWL8y++Vo1Ew5rrDwHXcCWu
         IqdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc;
        bh=ZUaQTOVIdh5xBvCaBb3Q2PJKSpNuIPnigKSbwq//BA0=;
        b=xzYV/LP4eAE3pIy2rUKoNMQkMQiv3O+JZAAz0jJC4A7Qx3bmeC2bfdfWozSPIeFi90
         5C4iG3RbNjl0ZFmxtqEtEZAilHeGV8ItHyRBiNm/UffdrdmX0gC++WjNIfTx4T3f6BLt
         EekaHS/yDDYneLgfOR04C3qnSMJEUqzZPx0WGs6C0a38fIkzjKda2XKO3xEqAdd+/ZOA
         h1ovDVLct52LbZMM56uaSa9UMCXibiR39623rrUcAdp+dPfJYdN9LDBBbyirv19QHGRJ
         vAI+Q/uzBDoPjz0mVuDmauDhldXVMT8XuCaUZSuSnNQhxpK6sdjhgr5AbUn4o+cZamNx
         a9/w==
X-Gm-Message-State: ACgBeo3FvwxvOXSScKOldylB9yDtr160DnXMZoJ9xzXJQVng8cdj++nL
        eGkXNMKNIk10E0H6+kO/Eio=
X-Google-Smtp-Source: AA6agR4+ePw/12qEsZM/rFDM66EA8Tes3EWn+M6lZiTRJSnxm4m3BnnK4X9iR+UiLdozpMIAolz+9g==
X-Received: by 2002:a17:90b:17c8:b0:1f5:4724:981f with SMTP id me8-20020a17090b17c800b001f54724981fmr1307469pjb.205.1661224443551;
        Mon, 22 Aug 2022 20:14:03 -0700 (PDT)
Received: from localhost ([2620:10d:c090:400::5:2dc2])
        by smtp.gmail.com with ESMTPSA id g7-20020a625207000000b00535ef76a602sm8288524pfb.74.2022.08.22.20.14.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 20:14:02 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Mon, 22 Aug 2022 17:14:01 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Roman Gushchin <roman.gushchin@linux.dev>
Cc:     Johannes Weiner <hannes@cmpxchg.org>,
        Mina Almasry <almasrymina@google.com>,
        Yafang Shao <laoar.shao@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, jolsa@kernel.org,
        Michal Hocko <mhocko@kernel.org>,
        Shakeel Butt <shakeelb@google.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Zefan Li <lizefan.x@bytedance.com>,
        Cgroups <cgroups@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        Yosry Ahmed <yosryahmed@google.com>,
        Dan Schatzberg <schatzberg.dan@gmail.com>,
        Lennart Poettering <lennart@poettering.net>
Subject: Re: [RFD RESEND] cgroup: Persistent memory usage tracking
Message-ID: <YwRF+df9P2TPu7Zw@slm.duckdns.org>
References: <20220818143118.17733-1-laoar.shao@gmail.com>
 <Yv67MRQLPreR9GU5@slm.duckdns.org>
 <Yv6+HlEzpNy8y5kT@slm.duckdns.org>
 <CALOAHbDcrj1ifFsNMHBEih5-SXY2rWViig4rQHi9N07JY6CjXA@mail.gmail.com>
 <Yv/DK+AGlMeBGkF1@slm.duckdns.org>
 <CALOAHbCvUxQn5Zkp2FJ+eL1VgjeRSq1xQhzdiY87C1Cbib-nig@mail.gmail.com>
 <YwNold0GMOappUxc@slm.duckdns.org>
 <CAHS8izNvEpX3Lv7eFn-vu=4ZT96Djk2dU-VU+zOueZaZZbnWNw@mail.gmail.com>
 <YwPy9hervVxfuuYE@cmpxchg.org>
 <YwRDFe+K837tKGED@P9FQF9L96D>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YwRDFe+K837tKGED@P9FQF9L96D>
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

On Mon, Aug 22, 2022 at 08:01:41PM -0700, Roman Gushchin wrote:
> > > >    One solution that I can think of is leveraging the resource domain
> > > >    concept which is currently only used for threaded cgroups. All memory
> > > >    usages of threaded cgroups are charged to their resource domain cgroup
> > > >    which hosts the processes for those threads. The persistent usages have a
> > > >    similar pattern, so maybe the service level cgroup can declare that it's
> > > >    the encompassing resource domain and the instance cgroup can say whether
> > > >    it's gonna charge e.g. the tmpfs instance to its own or the encompassing
> > > >    resource domain.
> > > >
> > > 
> > > I think this sounds excellent and addresses our use cases. Basically
> > > the tmpfs/bpf memory would get charged to the encompassing resource
> > > domain cgroup rather than the instance cgroup, making the memory usage
> > > of the first and second+ instances consistent and predictable.
> > > 
> > > Would love to hear from other memcg folks what they would think of
> > > such an approach. I would also love to hear what kind of interface you
> > > have in mind. Perhaps a cgroup tunable that says whether it's going to
> > > charge the tmpfs/bpf instance to itself or to the encompassing
> > > resource domain?
> > 
> > I like this too. It makes shared charging predictable, with a coherent
> > resource hierarchy (congruent OOM, CPU, IO domains), and without the
> > need for cgroup paths in tmpfs mounts or similar.
> > 
> > As far as who is declaring what goes, though: if the instance groups
> > can declare arbitrary files/objects persistent or shared, they'd be
> > able to abuse this and sneak private memory past local limits and
> > burden the wider persistent/shared domain with it.

My thought was that the persistent cgroup and instance cgroups should belong
to the same trust domain and system level control should be applied at the
resource domain level. The application may decide to shift between
persistent and per-instance however it wants to and may even configure
resource control at that level but all that's for its own accounting
accuracy and benefit.

> > I'm thinking it might make more sense for the service level to declare
> > which objects are persistent and shared across instances.
> 
> I like this idea.
> 
> > If that's the case, we may not need a two-component interface. Just
> > the ability for an intermediate cgroup to say: "This object's future
> > memory is to be charged to me, not the instantiating cgroup."
> > 
> > Can we require a process in the intermediate cgroup to set up the file
> > or object, and use madvise/fadvise to say "charge me", before any
> > instances are launched?
> 
> We need to think how to make this interface convenient to use.
> First, these persistent resources are likely created by some agent software,
> not the main workload. So the requirement to call madvise() from the
> actual cgroup might be not easily achievable.

So one worry that I have for this is that it requires the application itself
to be aware of cgroup topolgies and restructure itself so that allocation of
those resources are factored out into something else. Maybe that's not a
huge problem but it may limit its applicability quite a bit.

If we can express all the resource contraints and structures in the cgroup
side and configured by the management agent, the application can simply e.g.
madvise whatever memory region or flag bpf maps as "these are persistent"
and the rest can be handled by the system. If the agent set up the
environment for that, it gets accounted accordingly; otherwise, it'd behave
as if those tagging didn't exist. Asking the application to set up all its
resources in separate steps, that might require significant restructuring
and knowledge of how the hierarchy is setup in many cases.

> So _maybe_ something like writing a fd into cgroup.memory.resources.
> 
> Second, it would be really useful to export the current configuration
> to userspace. E.g. a user should be able to query to which cgroup the given
> bpf map "belongs" and which bpf maps belong to the given cgroups. Otherwise
> it will create a problem for userspace programs which manage cgroups
> (e.g. systemd): they should be able to restore the current configuration
> from the kernel state, without "remembering" what has been configured
> before.

This too can be achieved by separating out cgroup setup and tagging specific
resources. Agent and cgroup know what each cgroup is supposed to do as they
already do now and each resource is tagged whether they're persistent or
not, so everything is always known without the agent and the application
having to explicitly share the information.

Thanks.

-- 
tejun
