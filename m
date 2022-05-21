Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D44752F8C4
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 06:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350876AbiEUExp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 00:53:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241907AbiEUExn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 00:53:43 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03CE36C578;
        Fri, 20 May 2022 21:53:42 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id m1so8863023plx.3;
        Fri, 20 May 2022 21:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=102aBn0JR3M/WwS/swzSPfkILVklTAZC91XPQIvJBTg=;
        b=PWGRyF2fNaOh4KaYB/zeiEKUH4gVVH4H7/ifcFFhuRWNsHCrDxe8YmmVCugYL2ge9K
         zejnWxqg72zkAp6mdOfbgk1JYA8QaLe+5ci+P6t3IhXcw6uEjCOsGtRFT9guS4M3lMlp
         8hQZX+oEqT2++YZAZOpGw6ZYfCsXmlin7UO1ccUEzS15hfEQuG/9ir0nBZpYFgwd9uUe
         iyWJlGzS8v047mIOfI13H2TS+nNFXUNqB9/aimVaQG7r1j4+cEfcoE06h4FmGaNRC0xx
         ktOjxgUqAfaAK+m1pHith2BbIi28SgkRUtd/OEYblqICMdjcyzdCDP2f7mVsDhktTthj
         NiBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=102aBn0JR3M/WwS/swzSPfkILVklTAZC91XPQIvJBTg=;
        b=FFmF/wsgCBf1GsFDlR21VnXclHAx1oNK+M4FJkXQIjpOr+Voxe2WaVS1UoPLCXa3zh
         sjn8umY3Z1ffIg3vuYJjNe9ZgAOOAQmebGtfsA3XKPDMQ7a+LY6Th5S+ugDRG/mlZICR
         jsDMvEnCFALh96H6d1GbfGeV8kve/pPVJ/FPAOwv2temW57HX8rwUow4cCHX4miAVyS6
         tPPrO22RfBKrJJ4YGhGbbvz9w6Oazk02l4MrqBY3UAWEjnVBgdZDERuaRQ/pZV/8fuLD
         IGwKnCPKUWAne7wjbYnGt86rOO8JEs8XQZGLCg7Mv1KPDd6T1zP6eJFol7H1Bg/pVPCJ
         xX0A==
X-Gm-Message-State: AOAM530O5xbw3ypJdVVk29wtrDTk3Xj1f/garBwJczGLDNGDTQlX8ylW
        8pFZ3EFrgMt0YrYxVWleX7A=
X-Google-Smtp-Source: ABdhPJxGWLcIsxxWiaFuW05UMzEnjVRkxtEq2PY/ATf6JYn0SNEr4cHDZtaH6ocUXUQB5PsuBpv7Pg==
X-Received: by 2002:a17:90b:384d:b0:1df:f014:54e1 with SMTP id nl13-20020a17090b384d00b001dff01454e1mr9137026pjb.107.1653108821246;
        Fri, 20 May 2022 21:53:41 -0700 (PDT)
Received: from localhost ([2620:10d:c090:400::4:1761])
        by smtp.gmail.com with ESMTPSA id fh6-20020a17090b034600b001cd4989ff53sm2727449pjb.26.2022.05.20.21.53.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 May 2022 21:53:40 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Fri, 20 May 2022 18:53:39 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Hao Luo <haoluo@google.com>
Cc:     Yonghong Song <yhs@fb.com>, Yosry Ahmed <yosryahmed@google.com>,
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
Message-ID: <YohwU2sXYbKvvcWS@slm.duckdns.org>
References: <20220520012133.1217211-4-yosryahmed@google.com>
 <YodGI73xq8aIBrNM@slm.duckdns.org>
 <CAJD7tkbvMcMWESMcWi6TtdCKLr6keBNGgZTnqcHZvBrPa1qWPw@mail.gmail.com>
 <YodNLpxut+Zddnre@slm.duckdns.org>
 <73fd9853-5dab-8b59-24a0-74c0a6cae88e@fb.com>
 <YofFli6UCX4J5YnU@slm.duckdns.org>
 <CA+khW7gjWVKrwCgDD-4ZdCf5CMcA4-YL0bLm6aWM74+qNQ4c0A@mail.gmail.com>
 <CA+khW7iDDkO3h5WQixEA=nUL-tBmCTh7fMAf3iwNy98UfM-k9g@mail.gmail.com>
 <4cbdd3e9-c6fe-d796-5560-cd09c9220868@fb.com>
 <CA+khW7hGcrvihbb1CV4c4o6yO_3Ju3oU4_04G_A+TKh0vLHY3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+khW7hGcrvihbb1CV4c4o6yO_3Ju3oU4_04G_A+TKh0vLHY3w@mail.gmail.com>
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

On Fri, May 20, 2022 at 07:43:12PM -0700, Hao Luo wrote:
> Yes, passing a cgroup_id as the seek() syscall parameter was what I meant.
> 
> Tejun previously requested us to support seek() for a proper iterator.
> Since Alexei has a nice solution that all of us have ack'ed, I am not
> sure whether we still want to add seek() for bpf_iter as Tejun asked.
> I guess not.

Yeah, I meant seeking with the ID but it's better to follow the same
convention as other iterators.

Thanks.

-- 
tejun
