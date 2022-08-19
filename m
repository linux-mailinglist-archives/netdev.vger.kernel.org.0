Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1176759A4D4
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 20:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352046AbiHSRpG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 13:45:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351245AbiHSRoj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 13:44:39 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E364E42C1;
        Fri, 19 Aug 2022 10:06:55 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id y4so4656418plb.2;
        Fri, 19 Aug 2022 10:06:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=UZnrLccuewBeUTHa7he/1pdbfRtAri2WoHO63fUtNRc=;
        b=XAW0y0n14GbbI93QKgU2Mko3gRIRMRbjNK8yh6f00kxV2u+FwfJBFOdIFc4ubGtXnZ
         96Q7W+i5mtTv/AvpxsVclO3S1wahAB9QAbiT33xETdG3I+uCk/1gLZGnE5/tLTsGvFFo
         0I1/8QoikeezFphqIzolui9+0fafgFMClIoRK29EKwdtKR/ArQz1f/PwmdqHMOlsUEsG
         dqop2MHzljQjY7dyyBDVAy6aQF6pfzlwuE2uTIsOz0RjIQnTjgUncRBAtxpzCdihOVK4
         J5eGefsDHsvQ+K+HppyuUs/yFRkhgEdyNd4tDdrkcRyyCjtSWG74pKB6qGa2PWRznqxB
         5AvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc;
        bh=UZnrLccuewBeUTHa7he/1pdbfRtAri2WoHO63fUtNRc=;
        b=D4e9lJfff+YGMKF8kwDx3gTP0JsrDLmf3N23eSr+k1OwtMLYHrDha2CB1Vo/PHmk03
         drKMZd3cKKEOSV8DZCGSXgcJyaJAsyrQcthxLMgYgXHdW8KeKR+U8C1U7tXrMi5hMdrn
         6n+0HR/IHZQrKh8N8+ivE/SS8HhpKsC/g+B7KTGUelqtebHvtEjTE5i3PXGiGletk3cI
         Bz1wW/RqVJ74Ce5gVzsy9b/E0jix1al3YtrUlhrVzCjKR1RiaHuVDf94BZwf4cH7fkhw
         DU4IZFhopIi1qUI+lKF5/iLHB3cqt6o2NzdzfFQx+tgCqFUxcMR2A8UHAwln9qOEZ99J
         Yq8w==
X-Gm-Message-State: ACgBeo0ZEVgu5O7pMhs3OYm93CF6Q/ZrkOhKLZk0EkVOw+SQyV4RxNcE
        F91/2DUxBP8H8bQtrePA3tfP+MkzQcE=
X-Google-Smtp-Source: AA6agR520zkVb1ab+1IFrWSRolYaFHIavEFl2N7Y7Y3JZORzp6bFg/A0aCnrdfpBhO9U8UXqp9Af9g==
X-Received: by 2002:a17:902:d4c7:b0:16e:d1fd:f212 with SMTP id o7-20020a170902d4c700b0016ed1fdf212mr8198729plg.79.1660928814306;
        Fri, 19 Aug 2022 10:06:54 -0700 (PDT)
Received: from localhost ([2620:10d:c090:400::5:db7d])
        by smtp.gmail.com with ESMTPSA id 201-20020a6214d2000000b0052dbad1ea2esm3657782pfu.6.2022.08.19.10.06.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Aug 2022 10:06:53 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Fri, 19 Aug 2022 07:06:51 -1000
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
Message-ID: <Yv/DK+AGlMeBGkF1@slm.duckdns.org>
References: <20220818143118.17733-1-laoar.shao@gmail.com>
 <Yv67MRQLPreR9GU5@slm.duckdns.org>
 <Yv6+HlEzpNy8y5kT@slm.duckdns.org>
 <CALOAHbDcrj1ifFsNMHBEih5-SXY2rWViig4rQHi9N07JY6CjXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALOAHbDcrj1ifFsNMHBEih5-SXY2rWViig4rQHi9N07JY6CjXA@mail.gmail.com>
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

On Fri, Aug 19, 2022 at 09:09:25AM +0800, Yafang Shao wrote:
> On Fri, Aug 19, 2022 at 6:33 AM Tejun Heo <tj@kernel.org> wrote:
> >
> > On Thu, Aug 18, 2022 at 12:20:33PM -1000, Tejun Heo wrote:
> > > We have the exact same problem for any resources which span multiple
> > > instances of a service including page cache, tmpfs instances and any other
> > > thing which can persist longer than procss life time. My current opinion is
> >
> > To expand a bit more on this point, once we start including page cache and
> > tmpfs, we now get entangled with memory reclaim which then brings in IO and
> > not-yet-but-eventually CPU usage.
> 
> Introduce-a-new-layer vs introduce-a-new-cgroup, which one is more overhead?

Introducing a new layer in cgroup2 doesn't mean that any specific resource
controller is enabled, so there is no runtime overhead difference. In terms
of logical complexity, introducing a localized layer seems a lot more
straightforward than building a whole separate tree.

Note that the same applies to cgroup1 where collapsed controller tree is
represented by simply not creating those layers in that particular
controller tree.

No matter how we cut the problem here, if we want to track these persistent
resources, we have to create a cgroup to host them somewhere. The discussion
we're having is mostly around where to put them. With your proposal, it can
be anywhere and you draw out an example where the persistent cgroups form
their own separate tree. What I'm saying is that the logical place to put it
is where the current resource consumption is and we just need to put the
persistent entity as the parent of the instances.

Flexibility, just like anything else, isn't free. Here, if we extrapolate
this approach, the cost is evidently hefty in that it doesn't generically
work with the basic resource control structure.

> > Once you start splitting the tree like
> > you're suggesting here, all those will break down and now we have to worry
> > about how to split resource accounting and control for the same entities
> > across two split branches of the tree, which doesn't really make any sense.
> 
> The k8s has already been broken thanks to the memcg accounting on  bpf memory.
> If you ignored it, I paste it below.
> [0]"1. The memory usage is not consistent between the first generation and
> new generations."
> 
> This issue will persist even if you introduce a new layer.

Please watch your tone.

Again, this isn't a problem specific to k8s. We have the same problem with
e.g. persistent tmpfs. One idea which I'm not against is allowing specific
resources to be charged to an ancestor. We gotta think carefully about how
such charges should be granted / denied but an approach like that jives well
with the existing hierarchical control structure and because introducing a
persistent layer does too, the combination of the two works well.

> > So, we *really* don't wanna paint ourselves into that kind of a corner. This
> > is a dead-end. Please ditch it.
> 
> It makes non-sensen to ditch it.
> Because, the hierarchy I described in the commit log is *one* use case
> of the selectable memcg, but not *the only one* use case of it. If you
> dislike that hierarchy, I will remove it to avoid misleading you.

But if you drop that, what'd be the rationale for adding what you're
proposing? Why would we want bpf memory charges to be attached any part of
the hierarchy?

> Even if you introduce a new layer, you still need the selectable memcg.
> For example, to avoid the issue I described in [0],  you still need to
> charge to the parent cgroup instead of the current cgroup.

As I wrote above, we've been discussing the above. Again, I'd be a lot more
amenable to such approach because it fits with how everything is structured.

> That's why I described in the commit log that the selectable memcg is flexible.

Hopefully, my point on this is clear by now.

Thanks.

-- 
tejun
