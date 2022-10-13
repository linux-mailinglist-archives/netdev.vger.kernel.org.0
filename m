Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4939D5FDD93
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 17:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiJMPxE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 11:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbiJMPxC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 11:53:02 -0400
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CD9A100BD5
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 08:53:01 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-35ad0584879so21450267b3.7
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 08:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Rw+y4Zuzzr57wPyEG3SG0/48K4QIwQm9BpzIw2606Kc=;
        b=IzHj2PC1KPrhv5dnkg9GYf7VFyLh1sJHTVTu8LLX6WaZ28AdpsD34oC07m+P9zTsml
         EZfWjz3dsKS/R0gOT3BVIfkYdGnUtxLmMvwj/AJp1zJ46aqzrAO+ZnUnAQaX7R7NZfib
         dCRRBO7w0HdMrcpU6UCESENg/0EQ+yOxjm6Jq1M5oO+oIrawhGEk2rCV4eHpoHUnq/u8
         hDQfbg/W0C85BsxlWnQ3ayX07jwJzUViOXEazHsaoUpRTCI6FZc/mw/iBDWYN64OUVvs
         uBP4Mh0moKyur8WyJF3Yy2pl1wZ5Poi6aQjjmFqlkgNWXW3zVHs4Ig2r+HMRvWejbmO8
         XliQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Rw+y4Zuzzr57wPyEG3SG0/48K4QIwQm9BpzIw2606Kc=;
        b=sj58oU/tc4zA1FND4Yajci+mO3R3fMR8ceaiGmwPhdbPltn4X3B7/GNlC/QWznI1NZ
         GVxlWjXGiHL6SKWXf3Jiyd3cHPsFl9rPVK3aViSm3kcm7S/yAR7ODdcbUrqXsEkBkiXt
         YytTekL6PCfNUy/3g7stoPcQAMH3n5sOkYpjq6RPUbSpHmQtoc+duytqnlKz4O9+d8v+
         BBc9mGbZX9FoPzRAiP9sLls/2ZDEgGU62pGg0qATSYCLhlTbh2OkJr1emNtwRxXDSBvD
         XtrY/f2PIdwK49ze7Gm+pdIUtVdLJfnMVxvrx0hOZ/xpfdLiuQXsF4dxBgT8S+0BW88F
         LJQg==
X-Gm-Message-State: ACrzQf0NH4CyWeEd47H6CtHP7jpqbDJZr0PQgfrQVPiTx7O/XVd3M6iK
        QDxphHpC5+Xl4CUls37w5qmve64urFCAgoEkZnJkAQ==
X-Google-Smtp-Source: AMsMyM71FgxgF8dnn8bnRaHsQrFYK2PENWdqWDYFeoIEDTsJtxObOFw2uCTB71vQ1TahO5uhmOHAFkNBe4hHXcbDJJ4=
X-Received: by 2002:a81:4e57:0:b0:360:db33:f020 with SMTP id
 c84-20020a814e57000000b00360db33f020mr589883ywb.93.1665676381082; Thu, 13 Oct
 2022 08:53:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220609063412.2205738-1-eric.dumazet@gmail.com>
 <20220609063412.2205738-7-eric.dumazet@gmail.com> <684c6220-9288-3838-a938-0792b57c5968@amd.com>
 <CANn89iKpaJsqeMDQYySmUr2=n8D+dyXKtK0u7hF_8kW10mMm1A@mail.gmail.com>
In-Reply-To: <CANn89iKpaJsqeMDQYySmUr2=n8D+dyXKtK0u7hF_8kW10mMm1A@mail.gmail.com>
From:   Shakeel Butt <shakeelb@google.com>
Date:   Thu, 13 Oct 2022 08:52:49 -0700
Message-ID: <CALvZod7Bprb_Vt_6OqhtBCpgJc_EykK49emvpnfrpyX0RX5dGg@mail.gmail.com>
Subject: Re: [PATCH net-next 6/7] net: keep sk->sk_forward_alloc as small as possible
To:     Eric Dumazet <edumazet@google.com>
Cc:     K Prateek Nayak <kprateek.nayak@amd.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Wei Wang <weiwan@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Gautham Shenoy <gautham.shenoy@amd.com>,
        Mel Gorman <mgorman@techsingularity.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Chen Yu <yu.c.chen@intel.com>,
        Abel Wu <wuyun.abel@bytedance.com>,
        Yicong Yang <yangyicong@hisilicon.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 13, 2022 at 7:35 AM Eric Dumazet <edumazet@google.com> wrote:
>
[...]
> The only regression that has been noticed was when memcg was in the picture.
> Shakeel Butt sent patches to address this specific mm issue.
> Not sure what happened to the series (
> https://patchwork.kernel.org/project/linux-mm/list/?series=669584 )
>

That series has been merged into Linus tree for 6.1-rc1.

Prateek, are you running the benchmarks in memory cgroups? Can you
also test the latest Linus tree (or 6.1-rc1 when available) and see if
the regression is still there?

thanks,
Shakeel
