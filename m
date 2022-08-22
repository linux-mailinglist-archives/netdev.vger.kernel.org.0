Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EDF159BE69
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 13:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbiHVL0d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 07:26:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiHVL0c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 07:26:32 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04A9227CE7;
        Mon, 22 Aug 2022 04:26:31 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id f17so3864199pfk.11;
        Mon, 22 Aug 2022 04:26:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:cc:to:from:date:sender
         :from:to:cc;
        bh=xYnThmFHoGKU/sNt4SS1hXDq6GYqnmSSTt1CpRvIL48=;
        b=nWxBmLtDylTawPLEuM/2MzvIWaoVY8d8VN5rzm3+Q0FGFiVgZNLmM+p3vaejpbL1KA
         NPgmYtrMfKM48JaFMB6Ke3Qg2L0TexbZGmCgTtVVq8dM6QKRNqxkc7mzADsEoMxJeaJw
         5oxebUX63OgqwuFYXqFBMZHpbhxh+Zxu9bT4gZNwd5p1Qjdh3viL6jy7OdXxRsx3DLe0
         5h71ej+cLYiPoleAvF8TEH5G0XmZuyaHCnDHRgeDuUHTOPQXwjwMjEmF969VGN+Kk9NA
         EZDrfl+54wVczIiVkkLCf/pCm22OFwD0kvLJWOWHJHwUtuA02L3cUMAuODmLr2rlicp3
         PVkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:cc:to:from:date:sender
         :x-gm-message-state:from:to:cc;
        bh=xYnThmFHoGKU/sNt4SS1hXDq6GYqnmSSTt1CpRvIL48=;
        b=oQdIhnYDhp7UQqvSpj8IWYVsoqeL/M/fBPC1aUvWsqUMqVXbcDyGv9V1iDn2CweQnD
         c0gjvSNaPOTc9kovY0yO5EKkqOeju+JO6HENmN49p1hR9nTJdcBBCLehrtRXEuOHW4rg
         r5DvlQ+DqDALniC9yzZdjHUFpb3ox13vwoEwtQjEX/IL67bYftVEHKIgVIJjWArgpW8P
         Gi3MMKw6H0YOYWhj3Bx+6KsQyZu8/MvNISkDrkpyGgxf+4KBbVuLwwE/mgrm4RfB4PU+
         A9Aj+DlU/V/FlRvQiuJQtqd8Yqauw8Ts4Vu2ybvRdpVHLxxCdAOjpOGQTWxFjsGScyYb
         Eb1g==
X-Gm-Message-State: ACgBeo1/1oNrRCmyX56YY49QxCa7O9+udQQrqwy/AyQca5EjUc/wsHOU
        odZBEi+Wv9+uQ3PPzB9pb7lt9C8diaE=
X-Google-Smtp-Source: AA6agR5ntUFOMw3NycEWdfz8YmaV4pQ2lfDuTFMz2/TqP/1ze9EYk+TwWhkZGVOpWL7qE/syg/tloA==
X-Received: by 2002:a63:eb49:0:b0:421:8c9b:4ab1 with SMTP id b9-20020a63eb49000000b004218c9b4ab1mr16740198pgk.339.1661167590122;
        Mon, 22 Aug 2022 04:26:30 -0700 (PDT)
Received: from localhost (2603-800c-1a02-1bae-a7fa-157f-969a-4cde.res6.spectrum.com. [2603:800c:1a02:1bae:a7fa:157f:969a:4cde])
        by smtp.gmail.com with ESMTPSA id f8-20020a170902ce8800b00172c298ba42sm226896plg.28.2022.08.22.04.26.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Aug 2022 04:26:29 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Mon, 22 Aug 2022 01:26:28 -1000
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
        Zefan Li <lizefan.x@bytedance.com>,
        Cgroups <cgroups@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        Mina Almasry <almasrymina@google.com>
Message-ID: <YwNn5FvAYMHKY9jH@slm.duckdns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=0.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,MISSING_SUBJECT,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

, Yosry Ahmed <yosryahmed@google.com>, Dan Schatzberg <schatzberg.dan@gmail.com>, Lennart Poettering <lennart@poettering.net>
Bcc: htejun@gmail.com
Subject: [RFD] cgroup: Persistent memory usage tracking
Reply-To: 
In-Reply-To: <CALOAHbCvUxQn5Zkp2FJ+eL1VgjeRSq1xQhzdiY87C1Cbib-nig@mail.gmail.com>

Hello,

This thread started on a bpf-specific memory tracking change proposal and
went south, but a lot of people who would be interested are already cc'd, so
I'm hijacking it to discuss what to do w/ persistent memory usage tracking.

Cc'ing Mina and Yosry who were involved in the discussions on the similar
problem re. tmpfs, Dan Schatzberg who has a lot more prod knowledge and
experience than me, and Lennart for his thoughts from systemd side.

The root problem is that there are resources (almost solely memory
currently) that outlive a given instance of a, to use systemd-lingo,
service. Page cache is the most common case.

Let's say there's system.slice/hello.service. When it runs for the first
time, page cache backing its binary will be charged to hello.service.
However, when it restarts after e.g. a config change, when the initial
hello.service cgroup gets destroyed, we reparent the page cache charges to
the parent system.slice and when the second instance starts, its binary will
stay charged to system.slice. Over time, some may get reclaimed and
refaulted into the new hello.service but that's not guaranteed and most hot
pages likely won't.

The same problem exists for any memory which is not freed synchronously when
the current instance exits. While this isn't a problem for many cases, it's
not difficult to imagine situations where the amount of memory which ends up
getting pushed to the parent is significant, even clear majority, with big
page cache footprint, persistent tmpfs instances and so on, creating issues
with accounting accuracy and thus control.

I think there are two broad issues to discuss here:

[1] Can this be solved by layering the instance cgroups under persistent
    entity cgroup?

So, instead of systemd.slice/hello.service, the application runs inside
something like systemd.slice/hello.service/hello.service.instance and the
service-level cgroup hello.service is not destroyed as long as it is
something worth tracking on the system.

The benefits are

a. While requiring changing how userland organizes cgroup hiearchy, it is a
   straight-forward extension of the current architecture and doesn't
   require any conceptual or structural changes. All the accounting and
   control schemes work exactly the same as before. The only difference is
   that we now have a persistent entity representing each service as we want
   to track their persistent resource usages.

b. Per-instance tracking and control is optional. To me, it seems that the
   persistent resource usages would be more meaningful than per-instance and
   tracking down to the persistent usages shouldn't add noticeable runtime
   overheads while keeping per-instance process management niceties and
   allowing use cases to opt-in for per-instance resource tracking and
   control as needed.

The complications are:

a. It requires changing cgroup hierarchy in a very visible way.

b. What should be the lifetime rules for persistent cgroups? Do we keep them
   around forever or maybe they can be created on the first use and kept
   around until the service is removed from the system? When the persistent
   cgroup is removed, do we need to make sure that the remaining resource
   usages are low enough? Note that this problem exists for any approach
   that tries to track persistent usages no matter how it's done.

c. Do we need to worry about nesting overhead? Given that there's no reason
   to enable controllers w/o persisten states for the instance level and the
   nesting overhead is pretty low for memcg, this doesn't seem like a
   problem to me. If this becomes a problem, we just need to fix it.

A couple alternatives discussed are:

a. Userspace keeps reusing the same cgroup for different instances of the
   same service. This simplifies some aspects while making others more
   complicated. e.g. Determining the current instance's CPU or IO usages now
   require the monitoring software remembering what they were when this
   instance started and calculating the deltas. Also, if some use cases want
   to distinguish persistent vs. instance usages (more on this later), this
   isn't gonna work. That said, this definitely is attractive in that it
   miminizes overt user visible changes.

b. Memory is disassociated rather than just reparented on cgroup destruction
   and get re-charged to the next first user. This is attractive in that it
   doesn't require any userspace changes; however, I'm not sure how this
   would work for non-pageable memory usages such as bpf maps. How would we
   detect the next first usage?


[2] Whether and how to solve first and second+ instance charge differences.

If we take the layering approach, the first instance will get charged for
all memory that it uses while the second+ instances likely won't get charged
for a lot of persistent usages. I don't think there is a consensus on
whether this needs to be solved and I don't have enough context to form a
strong opinion. memcg folks are a lot better equipped to make this decision.

Assuming this needs to be solved, here's a braindump to be taken with a big
pinch of salt:

I have a bit of difficult time imagining a perfect solution given that
whether a given page cache page is persistent or not would be really
difficult to know (or maybe all page cache is persistent by default while
anon is not). However, the problem still seems worthwhile to consider for
big ticket items such as persistent tmpfs mounts and huge bpf maps as they
can easily make the differences really big.

If we want to solve this problem, here are options that I can think of:

a. Let userspace put the charges where they belong using the current
   mechanisms. ie. Create persistent entities in the persistent parent
   cgroup while there's no current instance.

   Pro: It won't require any major kernel or interface changes. There still
   need to be some tweaking such as allowing tmpfs pages to be always
   charged to the cgroup which created the instance (maybe as long as it's
   an ancestor of the faulting cgroup?) but nothing too invasive.

   Con: It may not be flexible enough.

b. Let userspace specify which cgroup to charge for some of constructs like
   tmpfs and bpf maps. The key problems with this approach are

   1. How to grant/deny what can be charged where. We must ensure that a
      descendant can't move charges up or across the tree without the
      ancestors allowing it.

   2. How to specify the cgroup to charge. While specifying the target
      cgroup directly might seem like an obvious solution, it has a couple
      rather serious problems. First, if the descendant is inside a cgroup
      namespace, it might be able to see the target cgroup at all. Second,
      it's an interface which is likely to cause misunderstandings on how it
      can be used. It's too broad an interface.

   One solution that I can think of is leveraging the resource domain
   concept which is currently only used for threaded cgroups. All memory
   usages of threaded cgroups are charged to their resource domain cgroup
   which hosts the processes for those threads. The persistent usages have a
   similar pattern, so maybe the service level cgroup can declare that it's
   the encompassing resource domain and the instance cgroup can say whether
   it's gonna charge e.g. the tmpfs instance to its own or the encompassing
   resource domain.

   This has the benefit that the user only needs to indicate its intention
   without worrying about how cgroups are composed and what their IDs are.
   It just indicates whether the given resource is persistent and if the
   cgroup hierarchy is set up for that, it gets charged that way and if not
   it can be just charged to itself.

   This is a shower thought but, if we allow nesting such domains (and maybe
   name them), we can use it for shared resources too so that co-services
   are put inside a shared slice and shared resources are pushed to the
   slice level.

This became pretty long. I obviously have a pretty strong bias towards
solving this within the current basic architecture but other than that most
of these decisions are best made by memcg folks. We can hopefully build some
consensus on the issue.

Thanks.

-- 
tejun
