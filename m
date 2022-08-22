Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE92959B707
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 02:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232079AbiHVAZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Aug 2022 20:25:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232054AbiHVAZP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Aug 2022 20:25:15 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ECCB205C5
        for <netdev@vger.kernel.org>; Sun, 21 Aug 2022 17:25:14 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id ce26so2552095ejb.11
        for <netdev@vger.kernel.org>; Sun, 21 Aug 2022 17:25:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=vOM6Qk7H6503nwlxurWDnApj6tGcPYJKuggwnA4Q7DI=;
        b=d18GG+Bt516p+zMinyCQn18btHPsTUkM8kPzrVj0qRlWdy2iXgPx5SdfNKsgRcQ5+t
         OtpT4LYrHOqGSPN6EtuMYhEn51cgY1lIg1cVM4bqJBczwtMS70sLDPg356P2VE3PM9Dh
         mgRZekRTLn1Ac3RMfhbmkkN+PXDbsIU/PgXaHy/nHlK1uWtZJVQNzXTxZ/9TdY4yv7E7
         6YRljr0tzGJfVO75aEh2zLCwUUaQb+K9LDB+6+a6DUjZevqZX+VoHbDggFmctnlqzlJc
         uJuGiXe1qObFP1Y+nN/gYcpwbAf8zmYaSbZfrL1rUOPvdz8Vng8leg9pLCE7NFHmnv79
         eBNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=vOM6Qk7H6503nwlxurWDnApj6tGcPYJKuggwnA4Q7DI=;
        b=ABizdVY/B1i3sow53aKBfC5sfA+cOsk8EiAhrcWN9P5GupeJwGwt4MA55BshKEtppo
         GXVc0VYHiNCujmv2+s/2sZqinJGOVQSIH9SraR6t9BZWafguowx7yaxllYsCk+aYtKl8
         z7wIRqt7JFi0h8rq+loViUAgAH4CSNTOhV1XUlns5RyTNhxXNHN+TBcJ5dp6XQuKy5I6
         6XX+0/psg4nA+u6n0pyo2VgaPcz1nf/UFp75CdfNnQ8HFENp5Ulcc+UYk+UCwS+ydUSc
         SEAiS+KhxX5C2NotvFUaZuSrPrvc4B5eztLfFBEH/kaOd9Ahs9hJTFsxiQ2qi5KD/vtP
         CJjA==
X-Gm-Message-State: ACgBeo1o7sXVKG5OSVo100+aalEE+gV8rN4FHRR5i4/rbOzpOB3SPVr/
        SbbXZJzrWK7MV8nOK6ng1IEdYnmnCECZ22rbdSFlyQ==
X-Google-Smtp-Source: AA6agR4puzJX0PrJauJDGDb6lfb25cap5PHs14UeMXH8C4YJFfUFZ1L+OkYEALZgFj/wkeiWFQR2zpRpgYIcHjsWDeE=
X-Received: by 2002:a17:907:608b:b0:731:8a9d:5a2d with SMTP id
 ht11-20020a170907608b00b007318a9d5a2dmr11502290ejc.443.1661127912457; Sun, 21
 Aug 2022 17:25:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220822001737.4120417-1-shakeelb@google.com> <20220822001737.4120417-4-shakeelb@google.com>
In-Reply-To: <20220822001737.4120417-4-shakeelb@google.com>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Sun, 21 Aug 2022 20:24:36 -0400
Message-ID: <CACSApvYOfFtn9TvRk2W5Xxv4Z90MZHqbffuB6XQXXxiG+F6WrA@mail.gmail.com>
Subject: Re: [PATCH 3/3] memcg: increase MEMCG_CHARGE_BATCH to 64
To:     Shakeel Butt <shakeelb@google.com>
Cc:     Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Muchun Song <songmuchun@bytedance.com>,
        =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
        Eric Dumazet <edumazet@google.com>,
        Feng Tang <feng.tang@intel.com>,
        Oliver Sang <oliver.sang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, lkp@lists.01.org,
        cgroups@vger.kernel.org, linux-mm <linux-mm@kvack.org>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 21, 2022 at 8:18 PM Shakeel Butt <shakeelb@google.com> wrote:
>
> For several years, MEMCG_CHARGE_BATCH was kept at 32 but with bigger
> machines and the network intensive workloads requiring througput in
> Gbps, 32 is too small and makes the memcg charging path a bottleneck.
> For now, increase it to 64 for easy acceptance to 6.0. We will need to
> revisit this in future for ever increasing demand of higher performance.
>
> Please note that the memcg charge path drain the per-cpu memcg charge
> stock, so there should not be any oom behavior change.
>
> To evaluate the impact of this optimization, on a 72 CPUs machine, we
> ran the following workload in a three level of cgroup hierarchy with top
> level having min and low setup appropriately. More specifically
> memory.min equal to size of netperf binary and memory.low double of
> that.
>
>  $ netserver -6
>  # 36 instances of netperf with following params
>  $ netperf -6 -H ::1 -l 60 -t TCP_SENDFILE -- -m 10K
>
> Results (average throughput of netperf):
> Without (6.0-rc1)       10482.7 Mbps
> With patch              17064.7 Mbps (62.7% improvement)
>
> With the patch, the throughput improved by 62.7%.
>
> Signed-off-by: Shakeel Butt <shakeelb@google.com>
> Reported-by: kernel test robot <oliver.sang@intel.com>

Nice!

Acked-by: Soheil Hassas Yeganeh <soheil@google.com>

> ---
>  include/linux/memcontrol.h | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 4d31ce55b1c0..70ae91188e16 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -354,10 +354,11 @@ struct mem_cgroup {
>  };
>
>  /*
> - * size of first charge trial. "32" comes from vmscan.c's magic value.
> - * TODO: maybe necessary to use big numbers in big irons.
> + * size of first charge trial.
> + * TODO: maybe necessary to use big numbers in big irons or dynamic based of the
> + * workload.
>   */
> -#define MEMCG_CHARGE_BATCH 32U
> +#define MEMCG_CHARGE_BATCH 64U
>
>  extern struct mem_cgroup *root_mem_cgroup;
>
> --
> 2.37.1.595.g718a3a8f04-goog
>
