Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04C7B4C9ABA
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 02:51:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237123AbiCBBw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 20:52:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbiCBBw3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 20:52:29 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1565DA2786
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 17:51:47 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id r20so290673ljj.1
        for <netdev@vger.kernel.org>; Tue, 01 Mar 2022 17:51:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nAhweZ+pg9E2HA3BdG1WLz9TgMZtCcFsz7mgDn6TWtU=;
        b=ReRX9Fz28f1TR66QP9PoPji/Mkj24URC0vxfMrGUYsbIUMT5H0mQY9eDw0UVOccbTQ
         B+JX4kfaWOZHC3dUgbA8eBTVJp79txfspQIo/SWphL+M3BykEqgXUrT25/+97Rm7yZJ9
         7c50aWxRAW/8A1mtUL46VM4jXkSBXWCcUJ8KQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nAhweZ+pg9E2HA3BdG1WLz9TgMZtCcFsz7mgDn6TWtU=;
        b=UbxXgTRXi2zpnNl0fDhgvNTvNpY0ot00CAlWkxaonZ6nrbYhn4QqfAj/3r/ZS64QDm
         eFmcrVk+w32YVDX/g1XJDBAuKF9mozsuy/KTc7NALxfgsEu9C02Gg50o8on4THMBNJ6k
         ehYZ6/8a7qnMVd999QzppnOY1XEBktePwtP9KcQE/YJprCXQtWzvYf9X/+Pt7cLnYbfF
         H37824GZDMzRRDMaL8c2AZLsf0dsLNRqpIKBdO+qfNRuwnvT9z2G7EUg09tWNTYltYCk
         pAS4+GVg5lwUZxbAtp3evB75Uid26SFs3eNsnlE222Wrg/+HUSW8oLOkAONOPPMbFFoR
         zMmQ==
X-Gm-Message-State: AOAM532vgKLYr+55BmXM++iNTTH1rJofQPhF4vydaHZjP8IeNvdmxiFp
        KiQeTNMsF+aulIybDAjg1zKB5QPcbOoNWscENArBgQ==
X-Google-Smtp-Source: ABdhPJxtlrPuPv7ooDSZBT4Rfj3jBOu3oM0QAOLQduI4fNucwnn7kd6YlH1aGZYIB+fktcK5pknxbeBa6I7nEnDuhfg=
X-Received: by 2002:a05:651c:1505:b0:246:8fe5:5293 with SMTP id
 e5-20020a05651c150500b002468fe55293mr6320922ljf.152.1646185905342; Tue, 01
 Mar 2022 17:51:45 -0800 (PST)
MIME-Version: 1.0
References: <1646172610-129397-1-git-send-email-jdamato@fastly.com>
 <1646172610-129397-2-git-send-email-jdamato@fastly.com> <20220301235031.ryy4trywlc3bmnpx@sx1>
In-Reply-To: <20220301235031.ryy4trywlc3bmnpx@sx1>
From:   Joe Damato <jdamato@fastly.com>
Date:   Tue, 1 Mar 2022 17:51:34 -0800
Message-ID: <CALALjgzWZLjLj1Qss9JQd3DEh-_SZcwCAEkgAE19Nsxf07EOOQ@mail.gmail.com>
Subject: Re: [net-next v8 1/4] page_pool: Add allocation stats
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, hawk@kernel.org,
        ttoukan.linux@gmail.com, brouer@redhat.com, leon@kernel.org,
        linux-rdma@vger.kernel.org, saeedm@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 1, 2022 at 3:50 PM Saeed Mahameed <saeed@kernel.org> wrote:
>
> On 01 Mar 14:10, Joe Damato wrote:
> >Add per-pool statistics counters for the allocation path of a page pool.
> >These stats are incremented in softirq context, so no locking or per-cpu
> >variables are needed.
> >
> >This code is disabled by default and a kernel config option is provided for
> >users who wish to enable them.
> >
>
> Sorry for the late review Joe,

No worries, thanks for taking a look.

> Why disabled by default ? if your benchmarks showed no diff.
>
> IMHO If we believe in this, we should have it enabled by default.

I think keeping it disabled by default makes sense for three reasons:
  - The benchmarks on my hardware don't show a difference, but less
powerful hardware may be more greatly impacted.
  - The new code uses more memory when enabled for storing the stats.
  - These stats are useful for debugging and performance
investigations, but generally speaking I think the vast majority of
everyday kernel users won't be looking at this data.

Advanced users who need this information (and are willing to pay the
cost in memory and potentially CPU) can enable the code relatively
easily, so I think keeping it defaulted to off makes sense.

> >The statistics added are:
> >       - fast: successful fast path allocations
> >       - slow: slow path order-0 allocations
> >       - slow_high_order: slow path high order allocations
> >       - empty: ptr ring is empty, so a slow path allocation was forced.
> >       - refill: an allocation which triggered a refill of the cache
> >       - waive: pages obtained from the ptr ring that cannot be added to
> >         the cache due to a NUMA mismatch.
> >
>
> Let's have this documented under kernel documentation.
> https://docs.kernel.org/networking/page_pool.html
>
> I would also mention the kconfig and any user knobs APIs introduced in
> this series

Sure, I can add a doc commit in the v9 that explains the kernel config
option, the API, and the fields of the stats structures.

Thanks,
Joe
