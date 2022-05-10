Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 732765226A0
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 00:08:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234207AbiEJWHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 18:07:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231318AbiEJWHs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 18:07:48 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BF625EBFE;
        Tue, 10 May 2022 15:07:47 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id c11so45557plg.13;
        Tue, 10 May 2022 15:07:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/D0OGw2on3AvUmlzv6/hmtVTR0FwAvCOjEZGHeN3148=;
        b=D+gxb7yJZ8m9WsThtL1BuBBOK9yZLCBXHYCPmiuC3APueeYrvaQ54LuI6lVJ9KDkGH
         bq8GCDiooCm7ohQyIPpk/Kemojg6ouW6d3J42fNcrTqpgF5QKN4NAP95JpFbeuv6tpy8
         eydzSFu4lyZgZrhRoHv/IdwFTGtzmVWzOiM/azxGTFxwwaR8UBZ8EFSiEh9bdNBHdb0B
         pxZ0jZeBQbGHGF+LgD5PRcmJm4mDJ/Ajquo0bduwqzhPfvj2IYFI0EwegKDL3MFvKjDU
         4Hi5BLDA2H/KhFY4EuEhj+wqb2D5jVc74T94LZr/+9gDTT4iItLQjiB9E6fH5zaQNaPy
         bEeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=/D0OGw2on3AvUmlzv6/hmtVTR0FwAvCOjEZGHeN3148=;
        b=pOJc0qRibX8J429WnIaQNxldeI9edZ2YZtkc854huV8xtvQiCrRHBqqB8SmQHjpxqk
         lKaRn6/lbyGOkrkbMLOCVzwJdxnmS9p62pOUD2/UcJJQ5c6c9WwTiZ7QqcEp0TBsHI/j
         JPRBa/RM6U4OmKposzkWRK/PXQyO5Dzuz26+QJyXaZFB/hv+RKI/I0b6wEuDfC1ZuvTl
         m/DZo9l8uueThrmBDk0rQ6itYd7pdRqneX1G98PxXbC/h0tAmq6Dz001q4Ot5LXzzAHg
         mLFxD8uZFx34GwI7D5eIyQamttHxFyQrA2s6mbRaeLNo6bLoYS1mRX1nrTXCUKXt+yhx
         /Z3A==
X-Gm-Message-State: AOAM530qBNUu96ForQBo7sk0TmTZB+pzG/sEqTO2OFMN0qeqRDxX4BH/
        YPgOVM9dNvsL0xcv4wGzMfI=
X-Google-Smtp-Source: ABdhPJzxtINQ2mxuzNFYfiTFTPIUxv7J7/LYgiXNkci9t3/kBm0Ez1sdfLL3KriCyw+dsZt6P8aeSA==
X-Received: by 2002:a17:902:ec8a:b0:15e:967b:f928 with SMTP id x10-20020a170902ec8a00b0015e967bf928mr23020423plg.133.1652220466953;
        Tue, 10 May 2022 15:07:46 -0700 (PDT)
Received: from localhost ([2620:10d:c090:400::4:6c64])
        by smtp.gmail.com with ESMTPSA id q7-20020a63d607000000b003c14af5062asm200577pgg.66.2022.05.10.15.07.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 15:07:46 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Tue, 10 May 2022 12:07:44 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Hao Luo <haoluo@google.com>
Cc:     Yosry Ahmed <yosryahmed@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
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
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [RFC PATCH bpf-next 8/9] bpf: Introduce cgroup iter
Message-ID: <YnriMPYyOP9ibskc@slm.duckdns.org>
References: <20220510001807.4132027-1-yosryahmed@google.com>
 <20220510001807.4132027-9-yosryahmed@google.com>
 <Ynq04gC1l7C2tx6o@slm.duckdns.org>
 <CA+khW7girnNwap1ABN1a4XuvkEEnmkztTV+fsuC3MsxNeB08Yg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+khW7girnNwap1ABN1a4XuvkEEnmkztTV+fsuC3MsxNeB08Yg@mail.gmail.com>
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

On Tue, May 10, 2022 at 02:12:16PM -0700, Hao Luo wrote:
> > Is there a reason why this can't be a proper iterator which supports
> > lseek64() to locate a specific cgroup?
> >
> 
> There are two reasons:
> 
> - Bpf_iter assumes no_llseek. I haven't looked closely on why this is
> so and whether we can add its support.
> 
> - Second, the name 'iter' in this patch is misleading. What this patch
> really does is reusing the functionality of dumping in bpf_iter.
> 'Dumper' is a better name. We want to create one file in bpffs for
> each cgroup. We are essentially just iterating a set of one single
> element.

I see. I'm just shooting in the dark without context but at least in
principle there's no reason why cgroups wouldn't be iterable, so it might be
something worth at least thinking about before baking in the interface.

Thanks.

-- 
tejun
