Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49B40595FBC
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 17:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236343AbiHPP7G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 11:59:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235991AbiHPP6i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 11:58:38 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF392B7D4
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 08:55:54 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id gp7so10100109pjb.4
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 08:55:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=S0TjqgZ/cpwhvqIRclTaRgLLFqhzUsXjGRreU5l1Dao=;
        b=qTx7jEv4/nwmvCExtD6R89Dm1SBJ4SkhasuOIfOrwWZ6K1t2Zr0EaCkQWcJCS/uim+
         8X9WP8VRmTcp17JN0SF1dTFzd9Oh4JZoisOJYrLLcIy4MM3xb74oG5Mscfg6rwcrXhJI
         hQdCdNpKMiGt/+1SGkofKjc4IhOG8u/ztqpv2yctdU8Nuk2IMbHx6qI6TzuQQ0klWjGq
         aFceiAkHInK+h5iWx+IC90K1AiFSPR3Plz+cYfA1om82VYY1xFn9WCIj5pzWRvWr0cZB
         /NocanLC50/KXHrrK96ND8mMKm9IrEstRN/hRIk2ALjS9Xwx1q7bVX56kmoPPF2s2jMo
         tW3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=S0TjqgZ/cpwhvqIRclTaRgLLFqhzUsXjGRreU5l1Dao=;
        b=LlmjuzwC9AzRKqLEzKmBhBiulRukGDB1L6sgsy83HEF00UavInn+Z6FBH0/KdH6gsq
         NFJkfuQCTyePhXO2ut54qJ7c6gtONvIX6Yb0tKGGSWFJH4YBSfHp/l2CD8AGllzOdnvi
         9vt/n6oIjMoDQZUfaaEBosZ2xahLxtrnuoXb8FakWyCkEtIctBVrQD2HikkovKYmWP4U
         Xhx+kIs7dWFPzUaQcwhBm0wwfYGqifRnGHYgJWbhzbtj6ysy2FPu7ZPssK9t932/A4nU
         XUFznP+QMbPmAPofKm3cpm1UZP7hzzfGmZ60/qf8WZn9AIGyvlYsTL0nAm437zLuDSCg
         n8RQ==
X-Gm-Message-State: ACgBeo3wVQ1tdGDwnyPEYhGUvgdWGkIC0NmpmJ8G3zlCAYjrppqKj/Dl
        iMCGGOM1GBxyz7Gkeo8Uu4+UT8afMpUJVBGIIeJ6pQ==
X-Google-Smtp-Source: AA6agR7rNOEKD6nRN5Avv+ABuxkIhBYlnMLShbilL+t09HuhZ24Kqp5AE/3faQMwTl37shqIo4Nw0wBbJ21Udr/teco=
X-Received: by 2002:a17:902:8683:b0:171:3114:7678 with SMTP id
 g3-20020a170902868300b0017131147678mr22420060plo.172.1660665354218; Tue, 16
 Aug 2022 08:55:54 -0700 (PDT)
MIME-Version: 1.0
References: <CANn89i+6NPujMyiQxriZRt6vhv6hNrAntXxi1uOhJ0SSqnJ47w@mail.gmail.com>
 <20220627123415.GA32052@shbuild999.sh.intel.com> <CANn89iJAoYCebNbXpNMXRoDUkFMhg9QagetVU9NZUq+GnLMgqQ@mail.gmail.com>
 <20220627144822.GA20878@shbuild999.sh.intel.com> <CANn89iLSWm-c4XE79rUsxzOp3VwXVDhOEPTQnWgeQ48UwM=u7Q@mail.gmail.com>
 <20220628034926.GA69004@shbuild999.sh.intel.com> <CALvZod71Fti8yLC08mdpDk-TLYJVyfVVauWSj1zk=BhN1-GPdA@mail.gmail.com>
 <20220703104353.GB62281@shbuild999.sh.intel.com> <YsIeYzEuj95PWMWO@castle>
 <20220705050326.GF62281@shbuild999.sh.intel.com> <YvswusNaC5yr+HwT@xsang-OptiPlex-9020>
In-Reply-To: <YvswusNaC5yr+HwT@xsang-OptiPlex-9020>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Tue, 16 Aug 2022 08:55:43 -0700
Message-ID: <CALvZod66HFiBX2N07gmCYDk_iH0bf4U+O=0DqUDmcebpOSyvwA@mail.gmail.com>
Subject: Re: [net] 4890b686f4: netperf.Throughput_Mbps -69.4% regression
To:     Oliver Sang <oliver.sang@intel.com>
Cc:     Feng Tang <feng.tang@intel.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Eric Dumazet <edumazet@google.com>,
        Linux MM <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Muchun Song <songmuchun@bytedance.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Xin Long <lucien.xin@gmail.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        network dev <netdev@vger.kernel.org>,
        linux-s390@vger.kernel.org, MPTCP Upstream <mptcp@lists.linux.dev>,
        "linux-sctp @ vger . kernel . org" <linux-sctp@vger.kernel.org>,
        lkp@lists.01.org, kbuild test robot <lkp@intel.com>,
        Huang Ying <ying.huang@intel.com>,
        Xing Zhengjun <zhengjun.xing@linux.intel.com>,
        Yin Fengwei <fengwei.yin@intel.com>, Ying Xu <yinxu@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 15, 2022 at 10:53 PM Oliver Sang <oliver.sang@intel.com> wrote:
>
> Hi all,
>
> now we noticed this commit has already merged into mainline, and in our tests
> there is still similar regression. [1]
>
> not sure if there is a plan to merge some of the solutions that have been
> discussed in this thread? we'll very glad to test patches if there is a request
>
> Thanks a lot!

Hi Oliver, sorry for the delay. I will send out the patches in a day or two.

thanks,
Shakeel
