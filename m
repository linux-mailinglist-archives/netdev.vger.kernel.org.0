Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB8659C277
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 17:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236504AbiHVPOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 11:14:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236452AbiHVPNv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 11:13:51 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 382123D595
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 08:09:14 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id f21so11296752pjt.2
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 08:09:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=DL+gliCYJUBpfOq1j0gfe9XybjmiohhXfC5HxYReYKQ=;
        b=Wy9VrLR+iXIOs02vfJHYtL6p0NbydFm1yZdXSv/BbjuFOkMtSTPP5CovxJ8349YqKj
         G3MVhdA4OpFY8unEsaSt6zl96K01EATVtDmzrpuZf7ttwrRaJShdhZDkiI3ve+qZNaMO
         LaMlsEqTM0HnQfbQJ+Ybp1cnhMyLAgbc8INMpkq7KkujbvLbZ3V3a+NkCsxtQtac3dFk
         vdsSPaw69M8DRRGlUlj8oR/cctPuyyB4P3GQXi7AhcJrZf2VSCnqZnoHSJmlaPfCsIHj
         Joq2WkpjnyjHGnaNIuUdQt4Q0lg3lljWYfXsxd0kZCxPo/shZ5oEicOIck6uwGYGrqs4
         U2ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=DL+gliCYJUBpfOq1j0gfe9XybjmiohhXfC5HxYReYKQ=;
        b=W1T98xbmfi497naG43IX8/Qn9MCaGrBmQGQ+WWTEBAETXlDMuOAqeZaQYCuSibRU69
         aDzayxODYEpuyIfjvnWmOk2e+K/AYcQmX3QEd/Di9rpElQaIHdhA+AXaWZ2JnT/tZJ/L
         TBD25UF5xXPy9ypmfuEItL+aituanchlT0eNxIud7Tnk7s1lJVzqC7WpnVPJPoTlz+EB
         Mgt+GUb5e1dFn6uCpCUgmtOBZT4P54IY0qNswkNMVnttpkduEeSJsN5x5vVQu9/AeZAb
         Bb2sMNymbrkRdNDupXiIg4c9kgVuDaBY0HfWoXK/rsuhHS8EH7Mxd0nKOcGvcH5Od6II
         Rbiw==
X-Gm-Message-State: ACgBeo0L6xtusxKMyPOie/JTujaZ4XmCXO9bm+Vj/MUskC+agW3huCmp
        45A2GwcYTwG+Fwhrdfb5gGiinJu9lh5kWEWaaJ/JBQ==
X-Google-Smtp-Source: AA6agR7w4i5ZWIz9KjwU7gDt0d0aOILixwzjhdCoo+s9f8xFDqJTQ54c28l9lpA7rWoP1mDiZfxWuiTVUH8q+viQk0c=
X-Received: by 2002:a17:90b:3881:b0:1f5:81e:8ceb with SMTP id
 mu1-20020a17090b388100b001f5081e8cebmr28140119pjb.207.1661180952809; Mon, 22
 Aug 2022 08:09:12 -0700 (PDT)
MIME-Version: 1.0
References: <20220822001737.4120417-1-shakeelb@google.com> <20220822001737.4120417-4-shakeelb@google.com>
 <YwNe3HBxzF+fWb2n@dhcp22.suse.cz>
In-Reply-To: <YwNe3HBxzF+fWb2n@dhcp22.suse.cz>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Mon, 22 Aug 2022 08:09:01 -0700
Message-ID: <CALvZod5YGVSTvsg25P6goqyGEY21eVnahsXcs2BGsp6OXxLwsg@mail.gmail.com>
Subject: Re: [PATCH 3/3] memcg: increase MEMCG_CHARGE_BATCH to 64
To:     Michal Hocko <mhocko@suse.com>
Cc:     Johannes Weiner <hannes@cmpxchg.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Muchun Song <songmuchun@bytedance.com>,
        =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
        Eric Dumazet <edumazet@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Feng Tang <feng.tang@intel.com>,
        Oliver Sang <oliver.sang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, lkp@lists.01.org,
        Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
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

On Mon, Aug 22, 2022 at 3:47 AM Michal Hocko <mhocko@suse.com> wrote:
>
[...]
>
> > To evaluate the impact of this optimization, on a 72 CPUs machine, we
> > ran the following workload in a three level of cgroup hierarchy with top
> > level having min and low setup appropriately. More specifically
> > memory.min equal to size of netperf binary and memory.low double of
> > that.
>
> a similar feedback to the test case description as with other patches.

What more info should I add to the description? Why did I set up min
and low or something else?

> >
> >  $ netserver -6
> >  # 36 instances of netperf with following params
> >  $ netperf -6 -H ::1 -l 60 -t TCP_SENDFILE -- -m 10K
> >
> > Results (average throughput of netperf):
> > Without (6.0-rc1)       10482.7 Mbps
> > With patch              17064.7 Mbps (62.7% improvement)
> >
> > With the patch, the throughput improved by 62.7%.
> >
> > Signed-off-by: Shakeel Butt <shakeelb@google.com>
> > Reported-by: kernel test robot <oliver.sang@intel.com>
>
> Anyway
> Acked-by: Michal Hocko <mhocko@suse.com>

Thanks
