Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D49E403BC3
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 16:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348854AbhIHOvf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 10:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235726AbhIHOve (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Sep 2021 10:51:34 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 908BDC061575
        for <netdev@vger.kernel.org>; Wed,  8 Sep 2021 07:50:26 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id c6so4762701ybm.10
        for <netdev@vger.kernel.org>; Wed, 08 Sep 2021 07:50:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YXEDz7oYZ9GVUcmsFxgUXf/+gVqKX8tYxel25XnFhQk=;
        b=pbjCyzFTALXr0BXl5ZqQtgWQqC6a1sLiadtnhsMIPnXGTyhzgH5kpweFWU7G6SfwO2
         PKPGmPvHs/dIEXV/HSvW73bdIn3P0hovqzS/K2acGseK0vRVcBbsKNl/L7XiTKHawWwA
         PesH7J1hMvPSSfrXN5Q8DbaxO7JtlmJwEnR84mEdKy3jdcLG+7fpvIGw0INc8nKVi0uL
         awjKo5K7nYwIlHXDfBzXaqKeTjdP4xznndi20EBb91myipuqd2nUuQ96ZOiPnon6SJU4
         Dgm9iB+A0JM4WMK0WhV75KDb+BFZuTGz73TNUufVrrnzN8otT+pUWAW1BKcLl0MF/nte
         R5GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YXEDz7oYZ9GVUcmsFxgUXf/+gVqKX8tYxel25XnFhQk=;
        b=aVO4X6hREHp5Cug/5hZaiR7iNaohkb4O7npJFtT05tvkQ23H192skRyTDzz4v5CSCG
         1AKsZKQxmE0pVT5j6wNqA7FYmcf2KeQdYuuZxBiRW/n7z/cB1ZxQTavrxqgAEhtxtrA7
         uVask8YyECsEEFXsAW8Ky2I2sXMFcJkH6HFogoY88d3ViuhHbOmYQ6O4QKrwJAyz7W6O
         8+lSR1uCRSHdptAtc4QZPe+ee78WCe5Pp/F7oO3oZMeQjkRHQtYFYjiTcGUCrCrLNsIX
         Ue3e1JvNlzAgywBNsJ4RQtqTBu8WDDOJRd9jZcts4BnlyT2wFOvkvnF2peB3Igtru3mp
         rlAg==
X-Gm-Message-State: AOAM530uU2N7A9yQWwpCe/PGeTiX2fPWTnZ0f8cXiu67pyRa0w95FX7+
        bi0Fqh8wFzCYNmPenwiqRy4dYaG1sRIHnB1ybekT9g==
X-Google-Smtp-Source: ABdhPJz/s/V+QKAdSxOV2bcgwhoA1WXIhjED/O6lwg6Bbxfk8TTcLpRhkZ3HeC7f0kNS2MSsTUihgZ41vrb77ROMIHM=
X-Received: by 2002:a25:dd46:: with SMTP id u67mr5486909ybg.295.1631112625292;
 Wed, 08 Sep 2021 07:50:25 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYtFvJdtBknaDKR54HHMf4XsXKD4UD3qXkQ1KhgY19n3tw@mail.gmail.com>
 <CAHk-=wisUqoX5Njrnnpp0pDx+bxSAJdPxfgEUv82tZkvUqoN1w@mail.gmail.com>
 <CAHk-=whF9F89vsfH8E9TGc0tZA-yhzi2Di8wOtquNB5vRkFX5w@mail.gmail.com> <53ce8db-3372-b5e2-cee7-c0ebe9c45a9@tarent.de>
In-Reply-To: <53ce8db-3372-b5e2-cee7-c0ebe9c45a9@tarent.de>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 8 Sep 2021 07:50:13 -0700
Message-ID: <CANn89iJzyPbR-fS8S_oAMSJzUGTHAfx49CXVc6ZSckUk91Opvg@mail.gmail.com>
Subject: Re: ipv4/tcp.c:4234:1: error: the frame size of 1152 bytes is larger
 than 1024 bytes [-Werror=frame-larger-than=]
To:     Thorsten Glaser <t.glaser@tarent.de>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Brendan Higgins <brendanhiggins@google.com>,
        Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2@marvell.com, Wei Liu <wei.liu@kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, lkft-triage@lists.linaro.org,
        Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 8, 2021 at 6:48 AM Thorsten Glaser <t.glaser@tarent.de> wrote:
>
> On Tue, 7 Sep 2021, Linus Torvalds wrote:
>
> > The do_tcp_getsockopt() one in tpc.c is a classic case of "lots of
> > different case statements, many of them with their own struct
> > allocations on stack, and all of them disjoint".
>
> Any compiler developers here? AFAIK the compiler knows the lifetime
> of function-local variables, so why not alias the actual memory
> locations and ranges to minimise stack usage?
>

At least on my builds,  do_tcp_getsockopt() uses less than 512 bytes of stack.

Probably because tcp_zerocopy_receive() is _not_ inlined, by pure luck
I suppose.

Perhaps we should use noinline_for_stack here.

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index e8b48df73c852a48e51754ea98b1e08bf024bb9e..437910c096b202420518c9e5e5cd26b2194d8aa2
100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2054,9 +2054,10 @@ static void tcp_zc_finalize_rx_tstamp(struct sock *sk,
 }

 #define TCP_ZEROCOPY_PAGE_BATCH_SIZE 32
-static int tcp_zerocopy_receive(struct sock *sk,
-                               struct tcp_zerocopy_receive *zc,
-                               struct scm_timestamping_internal *tss)
+static noinline_for_stack int
+tcp_zerocopy_receive(struct sock *sk,
+                    struct tcp_zerocopy_receive *zc,
+                    struct scm_timestamping_internal *tss)
 {
        u32 length = 0, offset, vma_len, avail_len, copylen = 0;
        unsigned long address = (unsigned long)zc->address;
