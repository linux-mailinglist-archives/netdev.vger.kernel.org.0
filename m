Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ADB352F5E7
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 00:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353979AbiETW5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 18:57:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230504AbiETW5Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 18:57:24 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DC6417B866;
        Fri, 20 May 2022 15:57:23 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id ev18so9201696pjb.4;
        Fri, 20 May 2022 15:57:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=r7Opvf9nRKqDGanqTkuAv5bdGKe48qHrMle6WOzLLy4=;
        b=iXgcDMaOaeCEyfvPGiDLf+JCC1kzNqqtGmkx+d+d6UQJ076JtKpP6CF7i2x5rzP5Aw
         UIPYy2I3NpQN5LvyUZB7XvDI65W0Fu29aXupm9j0Zk1h2ZjmGr6WCXjlfh9PTPNzzalM
         gOt+D5nzzQci6Xgm5jUaL0idRC96bgpY9f4aO4wWr4MHP9eX6ozcVTwTQDkSMhTHcFfE
         I6Bfxg6//tmrDvAGeYgnbQtmjvdGldw9LgjSE1kuwJOwm5KQN2YaH7qKNueHRPBUGHz4
         ZE1otEiFCGKKdXivVJI0fWpjry+B1CzGY3DLdHD5+YWNf1DE+Z3JCtVunAuebaZGUfvF
         smHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=r7Opvf9nRKqDGanqTkuAv5bdGKe48qHrMle6WOzLLy4=;
        b=cqyEcO9l//WULdNsE9Ue835i30DnWoS2jHAJ3crPs2mPKA/U9htvh1rXiqoP/W8M0X
         w0xq/KsAzxNVBp0+O0lPfr5iARxl+ZJGmKN5b+6n6z6whliQrvRbCkelnXaSEliMKgQc
         o4kVj96dQeUxIsl7Pas31MDICRmIxCOWTKHyg/Ma9AazhzZowsbbsRpGL/Ru8QxhtFy2
         RjZNfLrHraQCQNciBsQDwwmuCVZ2dqYoN+fks4rUKJuNZfRVMGG6nozzOrQ9pK2mv0pT
         V2w03pGt8nvtJJyAE8MPFBKmxhRekf9Xqq8y8s9x+4mCl5bl8wk4cZDNZLsoPZlHaZ4E
         zDiA==
X-Gm-Message-State: AOAM530nS37JSXhSnqEhqvJnlsco4IbEudGET4CDTeGYSvGj7JNiIOY4
        bCenPQO+Rfue1FCfBrAcPe8=
X-Google-Smtp-Source: ABdhPJyxyz9DwdYuaHUdtJYa+cVoL1WkA8BxzWBc2azrmHsKkdlng+6yVdYqfaZOig0tzug0Q6+YYA==
X-Received: by 2002:a17:90b:1808:b0:1dc:8904:76a1 with SMTP id lw8-20020a17090b180800b001dc890476a1mr13466621pjb.202.1653087442583;
        Fri, 20 May 2022 15:57:22 -0700 (PDT)
Received: from localhost ([2620:10d:c090:400::4:1761])
        by smtp.gmail.com with ESMTPSA id h11-20020a170902f2cb00b0015f33717794sm264975plc.42.2022.05.20.15.57.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 May 2022 15:57:21 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Fri, 20 May 2022 12:57:20 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Yosry Ahmed <yosryahmed@google.com>, Hao Luo <haoluo@google.com>,
        Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
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
        Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH bpf-next v1 3/5] bpf: Introduce cgroup iter
Message-ID: <Yogc0Kb5ZVDaQ0oU@slm.duckdns.org>
References: <20220520012133.1217211-1-yosryahmed@google.com>
 <20220520012133.1217211-4-yosryahmed@google.com>
 <YodGI73xq8aIBrNM@slm.duckdns.org>
 <CAJD7tkbvMcMWESMcWi6TtdCKLr6keBNGgZTnqcHZvBrPa1qWPw@mail.gmail.com>
 <YodNLpxut+Zddnre@slm.duckdns.org>
 <73fd9853-5dab-8b59-24a0-74c0a6cae88e@fb.com>
 <YofFli6UCX4J5YnU@slm.duckdns.org>
 <CA+khW7gjWVKrwCgDD-4ZdCf5CMcA4-YL0bLm6aWM74+qNQ4c0A@mail.gmail.com>
 <CAJD7tkaJQjfSy+YARFRkqQ8m7OGJHO9v91mSk-cFeo9Z5UVJKg@mail.gmail.com>
 <20220520221919.jnqgv52k4ajlgzcl@MBP-98dd607d3435.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220520221919.jnqgv52k4ajlgzcl@MBP-98dd607d3435.dhcp.thefacebook.com>
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

On Fri, May 20, 2022 at 03:19:19PM -0700, Alexei Starovoitov wrote:
> We have bpf_map iterator that walks all bpf maps.
> When map iterator is parametrized with map_fd the iterator walks
> all elements of that map.
> cgroup iterator should have similar semantics.
> When non-parameterized it will walk all cgroups and their descendent
> depth first way. I believe that's what Yonghong is proposing.
> When parametrized it will start from that particular cgroup and
> walk all descendant of that cgroup only.
> The bpf prog can stop the iteration right away with ret 1.
> Maybe we can add two parameters. One -> cgroup_fd to use and another ->
> the order of iteration css_for_each_descendant_pre vs _post.
> wdyt?

Sounds perfectly reasonable to me.

Thanks.

-- 
tejun
