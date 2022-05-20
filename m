Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42AC752F59C
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 00:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353878AbiETWTa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 18:19:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353875AbiETWT0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 18:19:26 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED4EB1A076B;
        Fri, 20 May 2022 15:19:24 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id 202so1824916pfu.0;
        Fri, 20 May 2022 15:19:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=b7Vm31N1KmiKaz7SbohqBjKzTjmGJnpUAVkpKWUThMY=;
        b=H3ZjIy79fwHtkOfYF1Ill/fMPUjrPR7E2pkOa/YhCb1jGsvLLxRr6uOQICQCl8yq2h
         KzSERIApbRFXR9lmG4Uk3nHZvFVq8Uue1kE4LnmFLR/v/rN9npvSJts7f+iytk8LCo9a
         fpRMMlwIruvdNJLVHaMg5qOJAgX4M5Fc/F1tt0tD6yZZrIAOeapE9xs6S16JiuWCsju2
         Asxl3i8dLiXmCXxEAOBresM3uaNtP212C8mONg3FwmL4Z7oqEaT+taMPqifRHmMmn/nx
         2IQLI+zcVqY30ca/PvxFcTrMC7DqzhHrftAfzpFMlIUEPLJgJV9MGm5xgioYQqWSeEHB
         nm+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=b7Vm31N1KmiKaz7SbohqBjKzTjmGJnpUAVkpKWUThMY=;
        b=CMWLtJPDj7rM4ifpTEJnVv7hK+1MX4Egzl1yiDoI66yNBAcCKJYr1dn3idm9L1rrh2
         YPqr7D+iKQA8kDh2ysmWJAZbvqXkRVboaxGI/F6wxP5iCzWGHKSYLVlPJVkUg137/AhG
         /hG4oCcr+v1ofdxWwogIiBiN6E0ZMH1UI9gsH5WPbB2J3ol+RJB6j3yu42yP2xQDWtY3
         qljKbMz7OtsJHmbNYOQwTS8TWtxEywLRMCk48KN2Myrd3ylNm1GGHr71ZjXMTUnM7Mut
         SY13+WmIEInbHD0Xhdl0s4RgGx2xk4jY2Cn6K7N9ZLQB997W60mWwhSWTh4LSbej77JD
         K/Xw==
X-Gm-Message-State: AOAM533PD2bbh9lT193sVem6ulWXOY6Q5nPrUAHnGf15JsN/bMOk3FV/
        qR2PHZg3uOpeYf8kt5NHnQk=
X-Google-Smtp-Source: ABdhPJyPatIaMfb0cUQB/du9LTA4vnmzNEjYiWrANLt3pPuau5sPW8xt9dH/j17WoeJK1uo/EDZDAg==
X-Received: by 2002:a63:dc42:0:b0:3c5:e187:572 with SMTP id f2-20020a63dc42000000b003c5e1870572mr10364737pgj.82.1653085164314;
        Fri, 20 May 2022 15:19:24 -0700 (PDT)
Received: from MBP-98dd607d3435.dhcp.thefacebook.com ([2620:10d:c090:500::1:c6aa])
        by smtp.gmail.com with ESMTPSA id 7-20020a17090a098700b001d25dfb9d39sm2356730pjo.14.2022.05.20.15.19.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 May 2022 15:19:23 -0700 (PDT)
Date:   Fri, 20 May 2022 15:19:19 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Yosry Ahmed <yosryahmed@google.com>
Cc:     Hao Luo <haoluo@google.com>, Tejun Heo <tj@kernel.org>,
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
Message-ID: <20220520221919.jnqgv52k4ajlgzcl@MBP-98dd607d3435.dhcp.thefacebook.com>
References: <20220520012133.1217211-1-yosryahmed@google.com>
 <20220520012133.1217211-4-yosryahmed@google.com>
 <YodGI73xq8aIBrNM@slm.duckdns.org>
 <CAJD7tkbvMcMWESMcWi6TtdCKLr6keBNGgZTnqcHZvBrPa1qWPw@mail.gmail.com>
 <YodNLpxut+Zddnre@slm.duckdns.org>
 <73fd9853-5dab-8b59-24a0-74c0a6cae88e@fb.com>
 <YofFli6UCX4J5YnU@slm.duckdns.org>
 <CA+khW7gjWVKrwCgDD-4ZdCf5CMcA4-YL0bLm6aWM74+qNQ4c0A@mail.gmail.com>
 <CAJD7tkaJQjfSy+YARFRkqQ8m7OGJHO9v91mSk-cFeo9Z5UVJKg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJD7tkaJQjfSy+YARFRkqQ8m7OGJHO9v91mSk-cFeo9Z5UVJKg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 20, 2022 at 02:18:42PM -0700, Yosry Ahmed wrote:
> >
> > The userspace needs to specify the identity of the cgroup, when
> > creating bpf_iter. This identity could be cgroup id or fd. This
> > identity needs to be converted to cgroup object somewhere before
> > passing into bpf program to use.
> 
> 
> Let's sum up the discussion here, I feel like we are losing track of
> the main problem. IIUC the main concern is that cgroup_iter is not
> effectively an iterator, it rather dumps information for one cgroup. I
> like the suggestion to make it iterate cgroups by default, and an
> optional cgroup_id parameter to make it only "iterate" this one
> cgroup.

We have bpf_map iterator that walks all bpf maps.
When map iterator is parametrized with map_fd the iterator walks
all elements of that map.
cgroup iterator should have similar semantics.
When non-parameterized it will walk all cgroups and their descendent
depth first way. I believe that's what Yonghong is proposing.
When parametrized it will start from that particular cgroup and
walk all descendant of that cgroup only.
The bpf prog can stop the iteration right away with ret 1.
Maybe we can add two parameters. One -> cgroup_fd to use and another ->
the order of iteration css_for_each_descendant_pre vs _post.
wdyt?
