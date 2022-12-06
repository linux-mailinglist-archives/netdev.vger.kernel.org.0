Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7E98643BC2
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 04:18:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233673AbiLFDS2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 22:18:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233619AbiLFDSV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 22:18:21 -0500
Received: from mail-yw1-x112e.google.com (mail-yw1-x112e.google.com [IPv6:2607:f8b0:4864:20::112e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAC3725C40
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 19:18:19 -0800 (PST)
Received: by mail-yw1-x112e.google.com with SMTP id 00721157ae682-3b56782b3f6so138566427b3.13
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 19:18:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YqqT24Nqraytn2LOsrycTIcntZ7F2ktH5EjwHmBvNlU=;
        b=f+X2wMIVqjOCM2pvzHPFEQnlrwDChpuK1e//9A/nqpwNm4/ibClEfmz0chRI3MEAr/
         puudyO91CXQY+k4AvVN/n5/WdqlX6H+rNcoWrSs62NW1+xg3YsEeR4Mos+uymbw8B6FO
         TLkghVyoa+KIy2t93LqnYzz3Jiqj6bb7OC5rt9A0oeAjIUTEcqTIvzlHq/qpxh0j7YG+
         cHTc3auKyTWvO4HJJ3lqBxC7r89KueGKzQ0wlWtS9KF+FKGHqKzlbWJpkwXNO8biG3N5
         F1x0wrPQcw1ls7R5Wlf4b8rAMnOa120IurcFpsi5VJg/ze2jSrRnlUathgqAzCszHAGQ
         4rGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YqqT24Nqraytn2LOsrycTIcntZ7F2ktH5EjwHmBvNlU=;
        b=h7BJIj1juTpa5VaSFMzPies7hgzGth9HnEWNGzpmrH91/WsMQHcXu1TM0eaa3bkw4n
         HlO8FplevadPiThkvbKjw51OOoyUyY5RVM9Lq1mjAOolblIuWFN4+vcJJmi3vkR0jBhp
         aAmIG7J3PdcSD8JvYWZ/rsBMqoroDXnZa4Pye/G1sX/GFTuZocb5wSzOrqBeBMiXvtW1
         XN/L8D8u8/lMdL9EH1B38tEB2PptDbkYBplfL6RcOmqVTWg28QBs5nzxKF+zFF/Dnk9a
         iJX6yh2bKlMtQofdK0+joOqbDsqPvn9dJF7vhnA2TK95o6+wvYVYiMRKqoVu76ifUGA6
         ybkg==
X-Gm-Message-State: ANoB5pmzgd7zrkBY9IflsIfFIrXFXybiIBI3PCSdpDE5rdc4im9mHO1D
        Kh8wvT07GaF10V3WASOHCn4w8GHe73sxiU96WY7Q0w==
X-Google-Smtp-Source: AA0mqf74j0N0U2MSZf44kh+gBRqfj83d8aCzfMMwco3VZErVzavml/PjpFSrMePpXJeHhEpszNYW8BOGLiIEybl2dJ8=
X-Received: by 2002:a81:d87:0:b0:393:ab0b:5a31 with SMTP id
 129-20020a810d87000000b00393ab0b5a31mr13277936ywn.55.1670296698705; Mon, 05
 Dec 2022 19:18:18 -0800 (PST)
MIME-Version: 1.0
References: <202212050936120314474@zte.com.cn> <20221205175354.3949c6bb@kernel.org>
In-Reply-To: <20221205175354.3949c6bb@kernel.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 6 Dec 2022 04:18:07 +0100
Message-ID: <CANn89iK4Cn-+BgJEuGSWF=PTfDPWuCy8ci75664+98ajt_+3Xw@mail.gmail.com>
Subject: Re: [PATCH linux-next v2] net: record times of netdev_budget exhausted
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     yang.yang29@zte.com.cn, davem@davemloft.net, pabeni@redhat.com,
        bigeasy@linutronix.de, imagedong@tencent.com, kuniyu@amazon.com,
        petrm@nvidia.com, liu3101@purdue.edu, wujianguo@chinatelecom.cn,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Tue, Dec 6, 2022 at 2:53 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 5 Dec 2022 09:36:12 +0800 (CST) yang.yang29@zte.com.cn wrote:
> > A long time ago time_squeeze was used to only record netdev_budget
> > exhausted[1]. Then we added netdev_budget_usecs to enable softirq
> > tuning[2]. And when polling elapsed netdev_budget_usecs, it's also
> > record by time_squeeze.
> > For tuning netdev_budget and netdev_budget_usecs respectively, we'd
> > better distinguish from netdev_budget exhausted and netdev_budget_usecs
> > elapsed, so add budget_exhaust to record netdev_budget exhausted.
> >
> > [1] commit 1da177e4c3f4("Linux-2.6.12-rc2")
> > [2] commit 7acf8a1e8a28("Replace 2 jiffies with sysctl netdev_budget_usecs to enable softirq tuning")
>
> Same comments as on v1.

Yes, and if we really want to track all these kinds of events the
break caused by need_resched() in do_softirq would
also need some monitoring.

I feel that more granular tracing (did I say tracepoints) would be more useful.
