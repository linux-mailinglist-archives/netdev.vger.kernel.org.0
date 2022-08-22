Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32AF959B895
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 06:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232489AbiHVEzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 00:55:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232102AbiHVEzm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 00:55:42 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D2B3220F2
        for <netdev@vger.kernel.org>; Sun, 21 Aug 2022 21:55:40 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id w29so3691087pfj.3
        for <netdev@vger.kernel.org>; Sun, 21 Aug 2022 21:55:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=UQyYzuIqErSYNpXSPcyyYCDze0E5q1hH3djW+ifHVA0=;
        b=sQogaDyt/YhpygyRGgMyaHCv0VOamZixo/4B/ibABXtfYnQfnh2zY0PJ9hcXiuWrwc
         V7pZWCjvjMAhQ491/pnuGeBUUob3BVAPIMq/UWvptHivoFEinydielWpJZ6z/8ZBRi4g
         XXqzXmysjNpz0hcoAzui5KmdedanBMXjjxZ7VLG4hKRRlp60VXFFTApNlYaepatOociJ
         XNaou/BWfXRcEG4pA915J3VIvSGIScoB8vTFABeGU7U4lEaKyPexlf7eHNiEhLoudZ15
         SUaQU0pEZcUyPg6f1y9pvpdNqao8WSeAfTRz1HCkEfaaxvAvmd0AvlTziqGVJDO9P90X
         S+7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=UQyYzuIqErSYNpXSPcyyYCDze0E5q1hH3djW+ifHVA0=;
        b=sRHBm7UNDT091zwaGx+GEWxwjl3UTbim5HVyV6Pqdmn862M0vL9zV7Kwgy9G77R0+y
         UTAUcwXD84Hsay8ISI+NyJs8b6vMP6f/Ofo7kb/IYUCgpyYTWhFXk8iLbnBQdi1MX3cB
         NlcnfcVrFo+iXpGJnuelGEAVV1v6yI9uVGuZVHAgEnETgv4+VqK5G/09gzeBwz9cIlq8
         c7eWvCb6l4iT+kSsxr/W5+U0qUFosNaxNAmrxBy8v35L/xB9ygiQeoBmXXYfTCNYeu4e
         cJgPJIyIvKbgPnWHrIzbnCQbH0KFKu621MCxtFGrAARxvfrW2pKIzzRScQqlri0EyfqU
         OAfA==
X-Gm-Message-State: ACgBeo1AQQWqxwG2DBEbXRFkI4EL6P9CP76JoeuB2i0ZGY16S7p0CbGO
        5A0LhRqeTRF6R/PZCh42Zc0mkTeN7lIKWlpfth0iGA==
X-Google-Smtp-Source: AA6agR5y0tHusAMEHXfmy5LutVbqZrCG18Mro9TnGQ195voKdkgYlo42c49TFtOr5o6zXt1Sl6Y3GwbzsCZTNj+dQGc=
X-Received: by 2002:a62:6497:0:b0:52e:e0cd:1963 with SMTP id
 y145-20020a626497000000b0052ee0cd1963mr19184795pfb.58.1661144139828; Sun, 21
 Aug 2022 21:55:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220822001737.4120417-1-shakeelb@google.com> <20220822001737.4120417-3-shakeelb@google.com>
 <CACSApvYU5gfbDv9dyaypu1oOPB58eT1inX9EX6gV5b2q3+qr6Q@mail.gmail.com>
In-Reply-To: <CACSApvYU5gfbDv9dyaypu1oOPB58eT1inX9EX6gV5b2q3+qr6Q@mail.gmail.com>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Sun, 21 Aug 2022 21:55:28 -0700
Message-ID: <CALvZod4r5_vcL4ZcSpR_DdLc_2sppnPTv1DXmFchCULWLu3Riw@mail.gmail.com>
Subject: Re: [PATCH 2/3] mm: page_counter: rearrange struct page_counter fields
To:     Soheil Hassas Yeganeh <soheil@google.com>
Cc:     Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Muchun Song <songmuchun@bytedance.com>,
        =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
        Eric Dumazet <edumazet@google.com>,
        Feng Tang <feng.tang@intel.com>,
        Oliver Sang <oliver.sang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>, lkp@lists.01.org,
        Cgroups <cgroups@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
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

On Sun, Aug 21, 2022 at 5:24 PM Soheil Hassas Yeganeh <soheil@google.com> wrote:
>
> On Sun, Aug 21, 2022 at 8:18 PM Shakeel Butt <shakeelb@google.com> wrote:
> >
> > With memcg v2 enabled, memcg->memory.usage is a very hot member for
> > the workloads doing memcg charging on multiple CPUs concurrently.
> > Particularly the network intensive workloads. In addition, there is a
> > false cache sharing between memory.usage and memory.high on the charge
> > path. This patch moves the usage into a separate cacheline and move all
> > the read most fields into separate cacheline.
> >
> > To evaluate the impact of this optimization, on a 72 CPUs machine, we
> > ran the following workload in a three level of cgroup hierarchy with top
> > level having min and low setup appropriately. More specifically
> > memory.min equal to size of netperf binary and memory.low double of
> > that.
> >
> >  $ netserver -6
> >  # 36 instances of netperf with following params
> >  $ netperf -6 -H ::1 -l 60 -t TCP_SENDFILE -- -m 10K
> >
> > Results (average throughput of netperf):
> > Without (6.0-rc1)       10482.7 Mbps
> > With patch              12413.7 Mbps (18.4% improvement)
> >
> > With the patch, the throughput improved by 18.4%.
>
> Shakeel, for my understanding: is this on top of the gains from the
> previous patch?
>

No, this is independent of the previous patch. The cover letter has
the numbers for all three optimizations applied together.
