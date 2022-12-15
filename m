Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C2F264E1F7
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 20:49:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbiLOTtA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 14:49:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiLOTs7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 14:48:59 -0500
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A794537E4;
        Thu, 15 Dec 2022 11:48:57 -0800 (PST)
Received: by mail-pl1-f179.google.com with SMTP id a9so72246pld.7;
        Thu, 15 Dec 2022 11:48:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9eOU6MEweambJWhLMx1ZdTlxZcA9EV5qgVGex/uzwT4=;
        b=UyeZh5iyF4B/yFV2rvW7Y8EzJKtL9J3gQXVWDq+miHCRl5CqSnH5Q9SB2qvSIfycAc
         BQVv6mhmUJREO5FEkdwCLlYKCQt7brmPKwRsxIc0rAvyQAVPssxHbykngz9MC7BnroKL
         Zuj080KYj/dY9mvlw7BH/YbIlKZFoU53e9MgOcxz0Ctl9ky4dTJ314PZufz8EApUdJr2
         Gj5nHy+kj8AT0vH3Mvo8Cixc6eXUAHpD0NQ/K9Kflhi9ARlrxO05+PY1/Gap/tFNmjOG
         XLmoBhkWjzM4pE3fyJ7OEk2iUOhoKXaI9+FBempVTlHSKXFvjp4RpzdBfRKMMkOVFEy7
         kh0w==
X-Gm-Message-State: ANoB5pnf9r/5SMWLtMrUEyKJGEyNW4jHBLpYNg1omKFofuxtS3+gsZJD
        Dsfr3D69XxpgtpP8Qp3yM/XTvNCGKYmJZw==
X-Google-Smtp-Source: AA0mqf4SbXV08kjq8kI0fvTb30YBd9e1QWqK9gmAPr9RmJw04k4J9c+RoSjfm3JAGOzvtBOa/YhI8Q==
X-Received: by 2002:a17:902:7104:b0:189:bf5d:c951 with SMTP id a4-20020a170902710400b00189bf5dc951mr28087126pll.26.1671133736617;
        Thu, 15 Dec 2022 11:48:56 -0800 (PST)
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com. [209.85.215.176])
        by smtp.gmail.com with ESMTPSA id w15-20020a1709026f0f00b00172b87d9770sm36080plk.81.2022.12.15.11.48.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Dec 2022 11:48:56 -0800 (PST)
Received: by mail-pg1-f176.google.com with SMTP id 36so308411pgp.10;
        Thu, 15 Dec 2022 11:48:55 -0800 (PST)
X-Received: by 2002:a05:6a00:16c6:b0:573:65d4:a104 with SMTP id
 l6-20020a056a0016c600b0057365d4a104mr89534235pfc.85.1671133735598; Thu, 15
 Dec 2022 11:48:55 -0800 (PST)
MIME-Version: 1.0
References: <167112117887.152641.6194213035340041732.stgit@warthog.procyon.org.uk>
In-Reply-To: <167112117887.152641.6194213035340041732.stgit@warthog.procyon.org.uk>
From:   Marc Dionne <marc.dionne@auristor.com>
Date:   Thu, 15 Dec 2022 15:48:44 -0400
X-Gmail-Original-Message-ID: <CAB9dFdvY496bK=ZrvG6cjmo0hLgWSm_VGPwXjeG6ZSf-0ut75w@mail.gmail.com>
Message-ID: <CAB9dFdvY496bK=ZrvG6cjmo0hLgWSm_VGPwXjeG6ZSf-0ut75w@mail.gmail.com>
Subject: Re: [PATCH net 0/9] rxrpc: Fixes for I/O thread conversion/SACK table expansion
To:     David Howells <dhowells@redhat.com>
Cc:     netdev@vger.kernel.org, Dan Carpenter <error27@gmail.com>,
        linux-afs@lists.infradead.org, Hillf Danton <hdanton@sina.com>,
        syzbot+3538a6a72efa8b059c38@syzkaller.appspotmail.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 15, 2022 at 12:20 PM David Howells <dhowells@redhat.com> wrote:
>
>
> Here are some fixes for AF_RXRPC:
>
>  (1) Fix missing unlock in rxrpc's sendmsg.
>
>  (2) Fix (lack of) propagation of security settings to rxrpc_call.
>
>  (3) Fix NULL ptr deref in rxrpc_unuse_local().
>
>  (4) Fix problem with kthread_run() not invoking the I/O thread function if
>      the kthread gets stopped first.  Possibly this should actually be
>      fixed in the kthread code.
>
>  (5) Fix locking problem as putting a peer (which may be done from RCU) may
>      now invoke kthread_stop().
>
>  (6) Fix switched parameters in a couple of trace calls.
>
>  (7) Fix I/O thread's checking for kthread stop to make sure it completes
>      all outstanding work before returning so that calls are cleaned up.
>
>  (8) Fix an uninitialised var in the new rxperf test server.
>
>  (9) Fix the return value of rxrpc_new_incoming_call() so that the checks
>      on it work correctly.
>
> The patches fix at least one syzbot bug[1] and probably some others that
> don't have reproducers[2][3][4].  I think it also fixes another[5], but
> that showed another failure during testing that was different to the
> original.
>
> There's also an outstanding bug in rxrpc_put_peer()[6] that is fixed by a
> combination of several patches in my rxrpc-next branch, but I haven't
> included that here.
>
> The patches are tagged here:
>
>         git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git
>         rxrpc-fixes-20221215
>
> and can also be found on the following branch:
>
>         https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log/?h=rxrpc-fixes
>
> David
>
> Link: https://syzkaller.appspot.com/bug?extid=3538a6a72efa8b059c38 [1]
> Link: https://syzkaller.appspot.com/bug?extid=2a99eae8dc7c754bc16b [2]
> Link: https://syzkaller.appspot.com/bug?extid=e1391a5bf3f779e31237 [3]
> Link: https://syzkaller.appspot.com/bug?extid=2aea8e1c8e20cb27a01f [4]
> Link: https://syzkaller.appspot.com/bug?extid=1eb4232fca28c0a6d1c2 [5]
> Link: https://syzkaller.appspot.com/bug?extid=c22650d2844392afdcfd [6]
>
> ---
> David Howells (9):
>       rxrpc: Fix missing unlock in rxrpc_do_sendmsg()
>       rxrpc: Fix security setting propagation
>       rxrpc: Fix NULL deref in rxrpc_unuse_local()
>       rxrpc: Fix I/O thread startup getting skipped
>       rxrpc: Fix locking issues in rxrpc_put_peer_locked()
>       rxrpc: Fix switched parameters in peer tracing
>       rxrpc: Fix I/O thread stop
>       rxrpc: rxperf: Fix uninitialised variable
>       rxrpc: Fix the return value of rxrpc_new_incoming_call()
>
>
>  include/trace/events/rxrpc.h |  2 +-
>  net/rxrpc/ar-internal.h      |  8 ++++----
>  net/rxrpc/call_accept.c      | 18 +++++++++---------
>  net/rxrpc/call_object.c      |  1 +
>  net/rxrpc/conn_client.c      |  2 --
>  net/rxrpc/io_thread.c        | 10 +++++++---
>  net/rxrpc/local_object.c     |  5 ++++-
>  net/rxrpc/peer_event.c       | 10 +++++++---
>  net/rxrpc/peer_object.c      | 23 ++---------------------
>  net/rxrpc/rxperf.c           |  2 +-
>  net/rxrpc/security.c         |  6 +++---
>  net/rxrpc/sendmsg.c          |  2 +-
>  12 files changed, 40 insertions(+), 49 deletions(-)

For the series:

Tested-by: Marc Dionne <marc.dionne@auristor.com>
Tested-by: kafs-testing+fedora36_64checkkafs-build-164@auristor.com

Marc
