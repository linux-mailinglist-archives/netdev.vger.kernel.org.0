Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6854263442F
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 20:00:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbiKVS77 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 13:59:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232341AbiKVS75 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 13:59:57 -0500
Received: from mail-vs1-xe2c.google.com (mail-vs1-xe2c.google.com [IPv6:2607:f8b0:4864:20::e2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CBDDFD18
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 10:59:56 -0800 (PST)
Received: by mail-vs1-xe2c.google.com with SMTP id t5so15383682vsh.8
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 10:59:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9DTsq3fTwNbT6i34craZmfTRExedmDHXASu4ap4JQWc=;
        b=euKH/+vJIk4jb5GYcwTIndpZtGrvZkOBeSQRk87xMjmZTH+RQ1pCNwnXJLB8r/oQO0
         x4NbvARykKT5UQRTYNFqc4c4y2HLtlQ0gwBrOUmgIYxYGKBvSsLiYFxxHey3fT3w/9Vj
         HOQ7Qj5hpRKUloDQyonDJ8F2dOblLZMmhxyUfbRFBcyPMZ2uFWy1Izg4UvFn7gsqx2n1
         ym1wloPvHbcVO13o21Vg+S93Kbo51YjBNfIYA2HBOkKEPJ/Z6SJ4/BP/QvHgGdHCxwvD
         QGOm47FEhjAWZAXMx2WhoKZKfiBjRMtZfj9QV6t+NhIB5xXw6qp1E8JC0TJGvherHUzh
         c4Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9DTsq3fTwNbT6i34craZmfTRExedmDHXASu4ap4JQWc=;
        b=iiQXJInPmBq20pZhJidolIB0oRItDf2uFVu8D/UorZXML6oEsfZ/0t5cl4F9SuWRdV
         BR7HUZz6JKSp7q37AsL6CfCV9FX28vFFPXxp+RCVkwypPpJK50IxQYGUl7MrNfZSkbqX
         uH4FXkuOwCMT9hAYBfwk4mIsZUSil84P9VGOIpIIamuZzBpjOvDmDkVqbfmmmDCgA5gt
         cD/ns7m1zybBj+WZfCJB/eBWSorHq3kkMG4QYCbDrpCgx30vYbjqS+3YzRV1Xqx9A85a
         DjAanWVVfMHOesMSpcenCIIbgSIdX6ge6WWfQqqsqDi/HQdMp5sCBPUhqswgfFbwKauF
         TUVQ==
X-Gm-Message-State: ANoB5pnjz4lfJ+iQEu6qKL+0YzNJgD12HAUcelT6R5Ao2xvafpOEdP72
        snGzy/179l4xrKIsiHSZQG6Ph7q1jo+w3IuaFkbwDg==
X-Google-Smtp-Source: AA0mqf7Uzxc/Jj31rG85oI1E9wRDLbPWhLS/I4nmAkG7IG1izVik37RCH407Iffcv4TAVFRK9egw/NuOlJWDujTFTMo=
X-Received: by 2002:a67:f8d4:0:b0:3aa:1a3a:6447 with SMTP id
 c20-20020a67f8d4000000b003aa1a3a6447mr4323889vsp.50.1669143595264; Tue, 22
 Nov 2022 10:59:55 -0800 (PST)
MIME-Version: 1.0
References: <CABWYdi0G7cyNFbndM-ELTDAR3x4Ngm0AehEp5aP0tfNkXUE+Uw@mail.gmail.com>
In-Reply-To: <CABWYdi0G7cyNFbndM-ELTDAR3x4Ngm0AehEp5aP0tfNkXUE+Uw@mail.gmail.com>
From:   Yu Zhao <yuzhao@google.com>
Date:   Tue, 22 Nov 2022 11:59:18 -0700
Message-ID: <CAOUHufbQ_JjW=zXEi10+=LQOREOPHrK66Rqayr=sFUH_tQbW1w@mail.gmail.com>
Subject: Re: Low TCP throughput due to vmpressure with swap enabled
To:     Ivan Babrou <ivan@cloudflare.com>
Cc:     Linux MM <linux-mm@kvack.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeelb@google.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, cgroups@vger.kernel.org,
        kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 21, 2022 at 5:53 PM Ivan Babrou <ivan@cloudflare.com> wrote:
>
> Hello,
>
> We have observed a negative TCP throughput behavior from the following commit:
>
> * 8e8ae645249b mm: memcontrol: hook up vmpressure to socket pressure
>
> It landed back in 2016 in v4.5, so it's not exactly a new issue.
>
> The crux of the issue is that in some cases with swap present the
> workload can be unfairly throttled in terms of TCP throughput.
>
> I am able to reproduce this issue in a VM locally on v6.1-rc6 with 8
> GiB of RAM with zram enabled.

Hi Ivan,

If it's not too much trouble, could you try again with the following?
  CONFIG_LRU_GEN=y
  CONFIG_LRU_GEN_ENABLED=y

I haven't tried it myself. But I'll fix whatever doesn't work for you,
since your team is on the top of my customer list :)

Thanks.
