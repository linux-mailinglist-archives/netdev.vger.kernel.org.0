Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BFB652251B
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 21:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232310AbiEJT7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 15:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230208AbiEJT7N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 15:59:13 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D71D229839B;
        Tue, 10 May 2022 12:59:11 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id y41so59463pfw.12;
        Tue, 10 May 2022 12:59:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ifWnOEmdxbqq+pQ/jtBb+5/wpjcSm5B451TRcuFaBz4=;
        b=XZ/MltcLn2qF6IyLMV0/mPQJt8rZIy78P4eJuB0QU2eaBVpsrZlP7tUoqmdrWS2yj+
         vWYqqnbf3lOc7b4Alt2qhyJUaB+lZ/zk+EnBC4TvVhuIhj34HNt5QemVHi1KSsjqRzFe
         P0ITuUVCOI+wGJdUKoLj4oBezceqxaYdMrEh/IHF63rcY106hyuIU8JMxTIbV6jyc9A2
         lHvnq+3XaMgyVMgK8rl+XNxLU1gWuiGjqS9c8zoMwwSdcGQ71842MoL5FoFtP/d+DM7f
         rGwMJU0Czi+8FTsBMFrke532nzjuPCm1UByIgY5efNQ/9kJVomOP6Lqfmoldu3AKaPmK
         AxzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=ifWnOEmdxbqq+pQ/jtBb+5/wpjcSm5B451TRcuFaBz4=;
        b=lcUu12rkO5KCLoIP3rIjpJBZcXM0lfSr7NvcefhHQZ0o9Gb7hAKDDtoXSyLWcLzjd2
         ck142571FxFyD5ow08h/HRyVIjif5U+iDSfWinB8Rqd7PdHL2DRhpiBiz5SjDH22S0J4
         KMmkyPbxHjyRWegYQigxm5+hVv9v8kAzIV3sascTIrif9ATaczDlPlbelGXysuA9Blk5
         /0YqHtNoFrl8+pZKzsmkLVkc0ryYK62KfkJwlCJAlv6ZUfUy8elb1n0lqVOkOY2QJMAn
         haEQo3MeN6Ga7B8q83qfyNLF0rATQSUHyi0dB9obAYdrf/kvlFHJMwEEZo2rqAt4Hraq
         a9yw==
X-Gm-Message-State: AOAM533hlL07H6XEMW8iklOFyuvN0l7TrRPkwNViQA0aynM0Maugz4bz
        UQT0e+haAV8m9Vw/rvIVX/M=
X-Google-Smtp-Source: ABdhPJx+kjkfNen9eAHABJXFqiLgQPEK+uLinBRZxUU1x3gqToqRbYFf8Ign5Q5HHQiFOdd7/jAnrg==
X-Received: by 2002:a63:455e:0:b0:3c6:270f:cec4 with SMTP id u30-20020a63455e000000b003c6270fcec4mr17901865pgk.417.1652212751256;
        Tue, 10 May 2022 12:59:11 -0700 (PDT)
Received: from localhost ([2620:10d:c090:400::4:6c64])
        by smtp.gmail.com with ESMTPSA id u17-20020a170903125100b0015e8d4eb21asm20305plh.100.2022.05.10.12.59.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 12:59:10 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Tue, 10 May 2022 09:59:09 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Yosry Ahmed <yosryahmed@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shuah Khan <shuah@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Michal Hocko <mhocko@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        David Rientjes <rientjes@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        cgroups@vger.kernel.org
Subject: Re: [RFC PATCH bpf-next 1/9] bpf: introduce CGROUP_SUBSYS_RSTAT
 program type
Message-ID: <YnrEDfZs1kuB1gu5@slm.duckdns.org>
References: <20220510001807.4132027-1-yosryahmed@google.com>
 <20220510001807.4132027-2-yosryahmed@google.com>
 <Ynqyh+K1tMyNCTUW@slm.duckdns.org>
 <CAJD7tkZVXJY3s2k8M4pcq+eJVD+aX=iMDiDKtdE=j0_q+UWQzA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJD7tkZVXJY3s2k8M4pcq+eJVD+aX=iMDiDKtdE=j0_q+UWQzA@mail.gmail.com>
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

On Tue, May 10, 2022 at 12:34:42PM -0700, Yosry Ahmed wrote:
> The rationale behind associating this work with cgroup_subsys is that
> usually the stats are associated with a resource (e.g. memory, cpu,
> etc). For example, if the memory controller is only enabled for a
> subtree in a big hierarchy, it would be more efficient to only run BPF
> rstat programs for those cgroups, not the entire hierarchy. It
> provides a way to control what part of the hierarchy you want to
> collect stats for. This is also semantically similar to the
> css_rstat_flush() callback.

Hmm... one major point of rstat is not having to worry about these things
because we iterate what's been active rather than what exists. Now, this
isn't entirely true because we share the same updated list for all sources.
This is a trade-off which makes sense because 1. the number of cgroups to
iterate each cycle is generally really low anyway 2. different controllers
often get enabled together. If the balance tilts towards "we're walking too
many due to the sharing of updated list across different sources", the
solution would be splitting the updated list so that we make the walk finer
grained.

Note that the above doesn't really affect the conceptual model. It's purely
an optimization decision. Tying these things to a cgroup_subsys does affect
the conceptual model and, in this case, the userland API for a performance
consideration which can be solved otherwise.

So, let's please keep this simple and in the (unlikely) case that the
overhead becomes an issue, solve it from rstat operation side.

Thanks.

-- 
tejun
