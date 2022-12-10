Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C208648F96
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 16:58:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbiLJP6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Dec 2022 10:58:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbiLJP6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Dec 2022 10:58:16 -0500
Received: from 1wt.eu (wtarreau.pck.nerim.net [62.212.114.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F2F6A12091;
        Sat, 10 Dec 2022 07:58:14 -0800 (PST)
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 2BAFwBwK022555;
        Sat, 10 Dec 2022 16:58:11 +0100
Date:   Sat, 10 Dec 2022 16:58:11 +0100
From:   Willy Tarreau <w@1wt.eu>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        netdev <netdev@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [GIT PULL] Add support for epoll min wait time
Message-ID: <20221210155811.GA22540@1wt.eu>
References: <b0901cba-3cb8-a309-701e-7b8cb13f0e8a@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b0901cba-3cb8-a309-701e-7b8cb13f0e8a@kernel.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jens,

On Sat, Dec 10, 2022 at 08:36:11AM -0700, Jens Axboe wrote:
> Hi Linus,
> 
> I've had this done for months and posted a few times, but little
> attention has been received.

I personally think this is particularly cool, for having faced the
same needs in the past. I'm just wondering how long we'll avoid the
need for marking certain FDs as urgent (i.e. for inter-thread wakeup)
which would bypass the min delay.

I'm just seeing something a bit odd in this series:

> ----------------------------------------------------------------
> epoll-min_ts-2022-12-08
> 
> ----------------------------------------------------------------
> Jens Axboe (8):
>       eventpoll: cleanup branches around sleeping for events
>       eventpoll: don't pass in 'timed_out' to ep_busy_loop()
>       eventpoll: split out wait handling
>       eventpoll: move expires to epoll_wq
>       eventpoll: move file checking earlier for epoll_ctl()
>       eventpoll: add support for min-wait
>       eventpoll: add method for configuring minimum wait on epoll context
>       eventpoll: ensure we pass back -EBADF for a bad file descriptor

This last patch fixes a bug introduced by the 5th one. Why not squash it
instead of purposely introducing a bug then its fix ? Or maybe it was
just overlooked when you sent the PR ?

Thanks,
Willy
