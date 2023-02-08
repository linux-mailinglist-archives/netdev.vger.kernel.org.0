Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DDBD68F079
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 15:13:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230351AbjBHONW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 09:13:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231436AbjBHONJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 09:13:09 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08EFA49011
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 06:13:07 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id f6so582987pln.12
        for <netdev@vger.kernel.org>; Wed, 08 Feb 2023 06:13:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Aef6bWXseXNyKUxB70l+v+4E0JEFa6CEMVz/HF7sn6E=;
        b=ZG4PfuCYzhr9e5VecxEtFOld1vD2TJ0a2AoJfHvvLJnX3Y0GtKfdQru7qmU7OM2Ns/
         wTHY7ameCcA0mdx4Kp8JQYOxSQwe5koQ7ol2gLw9M5rHbcgPHClAFji6lydxRqe1DyUH
         EIrUE5mD+A4dTXJZXD9DTjg0yRY1WDHIRW2hkgLtMJkH38lqslq905hW+mesmBaW9JQ4
         J3dbyKgfN/rnBIGA7xs6QFCk+E9F9tjO7rz8WHPmH9m5tAY4+4UY8ksQWELqCH0lH7D9
         fZzlQtAHBsX92MIzjg7f5wH+BvQ+46uaS0cks5++rG/5E1P2+B6CayiwCs3+UfPB9KJA
         9NsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Aef6bWXseXNyKUxB70l+v+4E0JEFa6CEMVz/HF7sn6E=;
        b=8GghLHJJoRuK2Lf+y3esOM8BRKa0xJY6La0GMVUCcdkzbOLYyB4rnFqMZPxmBkc7yt
         XGTvipo0JrB4yWFuf4p1d5afi5WVeK2olN2WzZaDmmJcAgnhaYj803gBDdD28EyuTH+r
         KDogeql3Wm5T/jw34T5Z/DJgjwwfv2KFYXrtgoRhlJb9ISK3oynk0jsVAf51Djmwqydn
         XROcFF9/gF/e+ty3zhknIEv09GSkK7tNrp94yVXHuQPRZmpD5sqfzRYrCSmljO7ehlRB
         HptFQXj2Z75huUQ9PcHi/FZeWilPKpDkKcGLQTsiwYg58dZVzi4WUPyGp1pVaPvTRvnC
         qxgw==
X-Gm-Message-State: AO0yUKVUq7PUNGYObWmgFdEvm9fHUYidXgQlBzHGtJODOHKBNiUqIm7T
        JXi8Xn7IRmS2vSl7h6IDZrJGR/4MlS7Rq3Ocr72SFg==
X-Google-Smtp-Source: AK7set9dvVXNlNqzj8UkH2d3FFgTZMIFbQ0jclcoNVl0HAvkU/yeZD//5D6Hf4pZcslw4V3bD70r1X6SrrRQRqU5jwE=
X-Received: by 2002:a17:90a:4e06:b0:22c:4d5:38be with SMTP id
 n6-20020a17090a4e0600b0022c04d538bemr730862pjh.42.1675865586402; Wed, 08 Feb
 2023 06:13:06 -0800 (PST)
MIME-Version: 1.0
References: <113e81f6-b349-97c0-4cec-d90087e7e13b@nvidia.com>
In-Reply-To: <113e81f6-b349-97c0-4cec-d90087e7e13b@nvidia.com>
From:   Vincent Guittot <vincent.guittot@linaro.org>
Date:   Wed, 8 Feb 2023 15:12:55 +0100
Message-ID: <CAKfTPtCO=GFm6nKU0DVa-aa3f1pTQ5vBEF+9hJeTR9C_RRRZ9A@mail.gmail.com>
Subject: Re: Bug report: UDP ~20% degradation
To:     Tariq Toukan <tariqt@nvidia.com>
Cc:     David Chen <david.chen@nutanix.com>,
        Zhang Qiao <zhangqiao22@huawei.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Valentin Schneider <vschneid@redhat.com>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Network Development <netdev@vger.kernel.org>,
        Gal Pressman <gal@nvidia.com>, Malek Imam <mimam@nvidia.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Tariq Toukan <ttoukan.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tariq,

On Wed, 8 Feb 2023 at 12:09, Tariq Toukan <tariqt@nvidia.com> wrote:
>
> Hi all,
>
> Our performance verification team spotted a degradation of up to ~20% in
> UDP performance, for a specific combination of parameters.
>
> Our matrix covers several parameters values, like:
> IP version: 4/6
> MTU: 1500/9000
> Msg size: 64/1452/8952 (only when applicable while avoiding ip
> fragmentation).
> Num of streams: 1/8/16/24.
> Num of directions: unidir/bidir.
>
> Surprisingly, the issue exists only with this specific combination:
> 8 streams,
> MTU 9000,
> Msg size 8952,
> both ipv4/6,
> bidir.
> (in unidir it repros only with ipv4)
>
> The reproduction is consistent on all the different setups we tested with.
>
> Bisect [2] was done between these two points, v5.19 (Good), and v6.0-rc1
> (Bad), with ConnectX-6DX NIC.
>
> c82a69629c53eda5233f13fc11c3c01585ef48a2 is the first bad commit [1].
>
> We couldn't come up with a good explanation how this patch causes this
> issue. We also looked for related changes in the networking/UDP stack,
> but nothing looked suspicious.
>
> Maybe someone here can help with this.
> We can provide more details or do further tests/experiments to progress
> with the debug.

Could you share more details about your system and the cpu topology ?

The commit  c82a69629c53 migrates a task on an idle cpu when the task
is the only one running on local cpu but the time spent by this local
cpu under interrupt or RT context becomes significant (10%-17%)
I can imagine that 16/24 stream overload your system so load_balance
doesn't end up in this case and the cpus are busy with several
threads. On the other hand, 1 stream is small enough to keep your
system lightly loaded but 8 streams make your system significantly
loaded to trigger the reduced capacity case but still not overloaded.

Vincent

>
> Thanks,
> Tariq
>
> [1]
> commit c82a69629c53eda5233f13fc11c3c01585ef48a2
> Author: Vincent Guittot <vincent.guittot@linaro.org>
> Date:   Fri Jul 8 17:44:01 2022 +0200
>
>      sched/fair: fix case with reduced capacity CPU
>
>      The capacity of the CPU available for CFS tasks can be reduced
> because of
>      other activities running on the latter. In such case, it's worth
> trying to
>      move CFS tasks on a CPU with more available capacity.
>
>
>
>
>      The rework of the load balance has filtered the case when the CPU
> is
>
>
>      classified to be fully busy but its capacity is reduced.
>
>
>
>
>
>
>
>      Check if CPU's capacity is reduced while gathering load balance
> statistic
>
>
>      and classify it group_misfit_task instead of group_fully_busy so we
> can
>
>
>      try to move the load on another CPU.
>
>
>
>
>
>
>
>      Reported-by: David Chen <david.chen@nutanix.com>
>
>
>
>      Reported-by: Zhang Qiao <zhangqiao22@huawei.com>
>
>
>
>      Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
>
>
>
>      Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
>
>
>
>      Tested-by: David Chen <david.chen@nutanix.com>
>
>
>
>      Tested-by: Zhang Qiao <zhangqiao22@huawei.com>
>
>
>
>      Link:
> https://lkml.kernel.org/r/20220708154401.21411-1-vincent.guittot@linaro.org
>
>
>
>
> [2]
>
> Detailed bisec steps:
>
> +--------------+--------+-----------+-----------+
> | Commit       | Status | BW (Gbps) | BW (Gbps) |
> |              |        | run1      | run2      |
> +--------------+--------+-----------+-----------+
> | 526942b8134c | Bad    | ---       | ---       |
> +--------------+--------+-----------+-----------+
> | 2e7a95156d64 | Bad    | ---       | ---       |
> +--------------+--------+-----------+-----------+
> | 26c350fe7ae0 | Good   | 279.8     | 281.9     |
> +--------------+--------+-----------+-----------+
> | 9de1f9c8ca51 | Bad    | 257.243   | ---       |
> +--------------+--------+-----------+-----------+
> | 892f7237b3ff | Good   | 285       | 300.7     |
> +--------------+--------+-----------+-----------+
> | 0dd1cabe8a4a | Good   | 305.599   | 290.3     |
> +--------------+--------+-----------+-----------+
> | dfea84827f7e | Bad    | 250.2     | 258.899   |
> +--------------+--------+-----------+-----------+
> | 22a39c3d8693 | Bad    | 236.8     | 245.399   |
> +--------------+--------+-----------+-----------+
> | e2f3e35f1f5a | Good   | 277.599   | 287       |
> +--------------+--------+-----------+-----------+
> | 401e4963bf45 | Bad    | 250.149   | 248.899   |
> +--------------+--------+-----------+-----------+
> | 3e8c6c9aac42 | Good   | 299.09    | 294.9     |
> +--------------+--------+-----------+-----------+
> | 1fcf54deb767 | Good   | 292.719   | 301.299   |
> +--------------+--------+-----------+-----------+
> | c82a69629c53 | Bad    | 254.7     | 246.1     |
> +--------------+--------+-----------+-----------+
> | c02d5546ea34 | Good   | 276.4     | 294       |
> +--------------+--------+-----------+-----------+
