Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 014AD59AAAD
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 04:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242335AbiHTC0m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 22:26:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235135AbiHTC0k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 22:26:40 -0400
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 795507A536;
        Fri, 19 Aug 2022 19:26:39 -0700 (PDT)
Received: by mail-vs1-xe34.google.com with SMTP id k10so1074714vsr.4;
        Fri, 19 Aug 2022 19:26:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=oh6Q6X5fu9r3g+mvH4/jQjUaJWygBx3MJ5JQBin8ub0=;
        b=jkvhqkc8tm4M+RR6BZs50gF7P3/UCtOxjjx1ig7yZY1X4PkwGTSnuAo7KN3DA+G38H
         h0rP55Py5h3qCfvw8j6f+I0Q/WmKn9l2aykoaPbu1Dsqyee4DhW5DbTggZMfyvg0kxTe
         Ovu8yHalWDXiCibV/VFmJxadK5g7LkbBFBz+mIFo+oQd9sqtEysjAxfz6X6OD3dDTM7B
         EDi7cORUHb1k0m3eesFCAxJI2MJt7dh63Ou0KXEifgnc9q/6FsJ4iCLA9B/QBPPpExn/
         pQxuxMUGOXKM3feKbSQrVbnLWoyn7rqWLfmtUwNuD367CtqkW/x6xQc/f5hoKXHd4ibf
         DxIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=oh6Q6X5fu9r3g+mvH4/jQjUaJWygBx3MJ5JQBin8ub0=;
        b=WHU3UOQyhMOdIqbcU8673lgTuDfYBtsTGERqMNxL/5GRq9axcaVPEeURXNtJeyL4IX
         abqGQxKEqoNaZO/Q95u3mhtE75P+83wzOQzbwaX4nKVk38Hb+uRQ+nH3i8tS0gE/f1Zt
         P1QZJe1cRPSWS0gd4s/uF1yg/Cx0SD1Qd741qJDdRB6Ki+xz5Ba4wj4EElv6Q6DEdONr
         U+7hUbeOd8HAXQBtQ3ZL1gc0wHUaV0+R24gSNxGTLA1DZSnO1ZFbYkmhMiI1ekqtc1RU
         P+xClJfxcZer09/ODnCUVIZdRfXC/wKIayG+IzEftnNhArYUjuhmRCZ6fODuw3QpvnFV
         dkVA==
X-Gm-Message-State: ACgBeo15pfSCEWtSg7gWBUsAZeYaRwa+AQKBd2b6rrhzH/bmakSNI085
        I2ShEkCqIFglm+5Ku+VbV/jBw3FtdbvFDKvcPAU=
X-Google-Smtp-Source: AA6agR77IBY+CPyDUhh5l/7XAT66exhQPCgU+XVLGCjmos38SCThQYSEex67Z26AjehATEySAdHIYv3wTX+fe1wwZHA=
X-Received: by 2002:a05:6102:570a:b0:38f:6031:412c with SMTP id
 dg10-20020a056102570a00b0038f6031412cmr3517866vsb.35.1660962398582; Fri, 19
 Aug 2022 19:26:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220818143118.17733-1-laoar.shao@gmail.com> <Yv67MRQLPreR9GU5@slm.duckdns.org>
 <Yv6+HlEzpNy8y5kT@slm.duckdns.org> <CALOAHbDcrj1ifFsNMHBEih5-SXY2rWViig4rQHi9N07JY6CjXA@mail.gmail.com>
 <Yv/DK+AGlMeBGkF1@slm.duckdns.org>
In-Reply-To: <Yv/DK+AGlMeBGkF1@slm.duckdns.org>
From:   Yafang Shao <laoar.shao@gmail.com>
Date:   Sat, 20 Aug 2022 10:25:59 +0800
Message-ID: <CALOAHbCvUxQn5Zkp2FJ+eL1VgjeRSq1xQhzdiY87C1Cbib-nig@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 00/12] bpf: Introduce selectable memcg for bpf map
To:     Tejun Heo <tj@kernel.org>
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
        Zefan Li <lizefan.x@bytedance.com>,
        Cgroups <cgroups@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>
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

On Sat, Aug 20, 2022 at 1:06 AM Tejun Heo <tj@kernel.org> wrote:
>
> Hello,
>
> On Fri, Aug 19, 2022 at 09:09:25AM +0800, Yafang Shao wrote:
> > On Fri, Aug 19, 2022 at 6:33 AM Tejun Heo <tj@kernel.org> wrote:
> > >
> > > On Thu, Aug 18, 2022 at 12:20:33PM -1000, Tejun Heo wrote:
> > > > We have the exact same problem for any resources which span multiple
> > > > instances of a service including page cache, tmpfs instances and any other
> > > > thing which can persist longer than procss life time. My current opinion is
> > >
> > > To expand a bit more on this point, once we start including page cache and
> > > tmpfs, we now get entangled with memory reclaim which then brings in IO and
> > > not-yet-but-eventually CPU usage.
> >
> > Introduce-a-new-layer vs introduce-a-new-cgroup, which one is more overhead?
>
> Introducing a new layer in cgroup2 doesn't mean that any specific resource
> controller is enabled, so there is no runtime overhead difference. In terms
> of logical complexity, introducing a localized layer seems a lot more
> straightforward than building a whole separate tree.
>
> Note that the same applies to cgroup1 where collapsed controller tree is
> represented by simply not creating those layers in that particular
> controller tree.
>

No, we have observed on our product env that multiple-layers cpuacct
would cause obvious performance hit due to cache miss.

> No matter how we cut the problem here, if we want to track these persistent
> resources, we have to create a cgroup to host them somewhere. The discussion
> we're having is mostly around where to put them. With your proposal, it can
> be anywhere and you draw out an example where the persistent cgroups form
> their own separate tree. What I'm saying is that the logical place to put it
> is where the current resource consumption is and we just need to put the
> persistent entity as the parent of the instances.
>
> Flexibility, just like anything else, isn't free. Here, if we extrapolate
> this approach, the cost is evidently hefty in that it doesn't generically
> work with the basic resource control structure.
>
> > > Once you start splitting the tree like
> > > you're suggesting here, all those will break down and now we have to worry
> > > about how to split resource accounting and control for the same entities
> > > across two split branches of the tree, which doesn't really make any sense.
> >
> > The k8s has already been broken thanks to the memcg accounting on  bpf memory.
> > If you ignored it, I paste it below.
> > [0]"1. The memory usage is not consistent between the first generation and
> > new generations."
> >
> > This issue will persist even if you introduce a new layer.
>
> Please watch your tone.
>

Hm? I apologize if my words offend you.
But, could you pls take a serious look at the patchset  before giving a NACK?
You didn't even want to know the background before you sent your NACK.

> Again, this isn't a problem specific to k8s. We have the same problem with
> e.g. persistent tmpfs. One idea which I'm not against is allowing specific
> resources to be charged to an ancestor. We gotta think carefully about how
> such charges should be granted / denied but an approach like that jives well
> with the existing hierarchical control structure and because introducing a
> persistent layer does too, the combination of the two works well.
>
> > > So, we *really* don't wanna paint ourselves into that kind of a corner. This
> > > is a dead-end. Please ditch it.
> >
> > It makes non-sensen to ditch it.
> > Because, the hierarchy I described in the commit log is *one* use case
> > of the selectable memcg, but not *the only one* use case of it. If you
> > dislike that hierarchy, I will remove it to avoid misleading you.
>
> But if you drop that, what'd be the rationale for adding what you're
> proposing? Why would we want bpf memory charges to be attached any part of
> the hierarchy?
>

I have explained it to you.
But unfortunately you ignored it again.
But I don't mind explaining to you again.

                 Parent-memcg
                     \
                   Child-memcg (k8s pod)

The user can charge the memory to the parent directly without charging
into the k8s pod.
Then the memory.stat is consistent between different generations.

> > Even if you introduce a new layer, you still need the selectable memcg.
> > For example, to avoid the issue I described in [0],  you still need to
> > charge to the parent cgroup instead of the current cgroup.
>
> As I wrote above, we've been discussing the above. Again, I'd be a lot more
> amenable to such approach because it fits with how everything is structured.
>
> > That's why I described in the commit log that the selectable memcg is flexible.
>
> Hopefully, my point on this is clear by now.
>

Unfortunately, you didn't want to get my point.


-- 
Regards
Yafang
