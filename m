Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A53263F799
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 19:40:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbiLASkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 13:40:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbiLASkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 13:40:16 -0500
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BDFEBD424
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 10:40:15 -0800 (PST)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-3b48b139b46so26087557b3.12
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 10:40:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=l0s48YnBzqizD/NOUNAFmcwcrFhU8sJJzTPVQzYJmbs=;
        b=mYDxZz5/zmyya/ckPo1fHDwM398Dq7zS9tCF2YcWRdqcVVcLACnSAn9/hNI2wpl4CF
         /RRs2yE+XsKr0n6dyswNlQJPyx5P7eq8rwJqNdKMlKnmPOTnmsfg0RyvdJjTzTgu0GpK
         P92Ceyz0crP15HrWHK3KErqrbOykl77zwrDOGUNj4emqOS+wHtfgesrlrdQq4zsY9nv5
         U39cqeO/jQm8z5ZofD9evuur1dl7FuhFazI1FvsyV7x1k7YYF7Bu2ydbVtLfD0by5wT5
         zpXS8Tj42uxeQhVel3gyrlyJ19ftEdzBErcR/OU3q1XybPnYwTOdVv7ryU8XgEfXVdtl
         gzoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l0s48YnBzqizD/NOUNAFmcwcrFhU8sJJzTPVQzYJmbs=;
        b=QbdZX+OhuVKGKRLXa9lK5QR5MZ04G34kTW3kIil9wTUyKuV4vFDWJ3kBdDuhre4t3L
         xH4Dq58T61CghqswRiIzj1DC4mRC6PXEZKagB71n+m1bSvctuHde17dGG5pRI1OUaqVJ
         1BxZbIkEeebMjzNGXMV8//lmmNZMXSlv2z5Keoo3ihnbekPZ5zKGFPbsthk+WMYOI7hh
         4d2PQ1NwfH2W/6Y0Cxx8NDezZJkVkcw53lQAInUGk8AkDI/ASshg0bveoSpsf1STU/mv
         nCfnLaoTOFtGvTfcdHY5M/ZEZVh/qcL5zgqDBRawvEzVStGlM0XAdkjr2Uyq0u/3mv70
         fNyA==
X-Gm-Message-State: ANoB5plFBzFulnAP/6rcVlz5HZXe7CsCnN0fZnrfs3C7qgREzeYzmJrI
        vSVkB7//+45wr2UZTsm755sGhAegaUckpfGtLYUSJCehCzk=
X-Google-Smtp-Source: AA0mqf7mIXKKOylTK/VpKD6tQOmyuT9DeSmRtSoHiwf8d7ZguSqObtY9xmihT7RtLF8B4OaO4SVXwZLRKPulp5yTe7k=
X-Received: by 2002:a81:14c4:0:b0:3ac:3740:9452 with SMTP id
 187-20020a8114c4000000b003ac37409452mr42942221ywu.471.1669920014388; Thu, 01
 Dec 2022 10:40:14 -0800 (PST)
MIME-Version: 1.0
References: <20221030220203.31210-1-axboe@kernel.dk> <20221030220203.31210-7-axboe@kernel.dk>
 <Y2rUsi5yrhDZYpf/@google.com> <4764dcbf-c735-bbe2-b60e-b64c789ffbe6@kernel.dk>
 <8d195905-a93f-d342-abb0-dd0e0f5a5764@kernel.dk>
In-Reply-To: <8d195905-a93f-d342-abb0-dd0e0f5a5764@kernel.dk>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Thu, 1 Dec 2022 13:39:37 -0500
Message-ID: <CACSApvZU0o3MSp33G0Ld+1dr-k82UCcJqF=40AVL-F6UXHpGgg@mail.gmail.com>
Subject: Re: [PATCH 6/6] eventpoll: add support for min-wait
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>,
        Shakeel Butt <shakeelb@google.com>
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

On Thu, Dec 1, 2022 at 1:00 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> >>> @@ -1845,6 +1891,18 @@ static int ep_poll(struct eventpoll *ep, struct epoll_event __user *events,
> >>>             ewq.timed_out = true;
> >>>     }
> >>>
> >>> +   /*
> >>> +    * If min_wait is set for this epoll instance, note the min_wait
> >>> +    * time. Ensure the lowest bit is set in ewq.min_wait_ts, that's
> >>> +    * the state bit for whether or not min_wait is enabled.
> >>> +    */
> >>> +   if (ep->min_wait_ts) {
> >>
> >> Can we limit this block to "ewq.timed_out && ep->min_wait_ts"?
> >> AFAICT, the code we run here is completely wasted if timeout is 0.
> >
> > Yep certainly, I can gate it on both of those conditions.
> Looking at this for a respin, I think it should be gated on
> !ewq.timed_out? timed_out == true is the path that it's wasted on
> anyway.

Ah, yes, that's a good point. The check should be !ewq.timed_out.

Thanks,
Soheil

> --
> Jens Axboe
>
