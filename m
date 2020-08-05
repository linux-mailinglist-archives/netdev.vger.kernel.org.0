Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E30823C2D9
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 03:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbgHEBCj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 21:02:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726584AbgHEBCi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 21:02:38 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A4B6C06174A
        for <netdev@vger.kernel.org>; Tue,  4 Aug 2020 18:02:38 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id i10so10947972ljn.2
        for <netdev@vger.kernel.org>; Tue, 04 Aug 2020 18:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hs9W9L5qpq2R+TvR0kUnYEwJzpiFvPtYd1/wFxmYVBk=;
        b=Kx953I5bRL4bVidV0oKIvBtGTnSGPKxsodb54W6hxL4/CYqPdJIljl56vxXkep72Xw
         P4OD/p48jGd/W5M33jhVmYcuxxZzj6WiWMVm0LupsFNF3jz6B9bRa1+GqGb/FOKNdNoz
         61DOhhRiURE/XsRaMXMf4VljeWPfXRfMzqvNU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hs9W9L5qpq2R+TvR0kUnYEwJzpiFvPtYd1/wFxmYVBk=;
        b=Iwbf7BdMuvKOwxDIIBEBbzXdP/fX1yK3RFLcCruu8oSBLY4aFy9RfpKw5eFZkUve+o
         1uZgEXEqDULk8xfRV80/p+MaM3NcZZUuJDULH0mN5vPK80ZVeBkB5BTtJhcj97aLlItJ
         pxjLnvD4nc2+8F3ay23zboOGsBoG/OSXsgEuHJ8pnBINTwdCqLH1K1RWQS/YerhY3WvF
         Mo6CU3hlnFx5G8zDFEGDaKh4+MJNtIgr1RtfO+xIXubA4oZhv4eEcV3rLdMfBcprgBYX
         1rrYH/zv6GEJew9n0u8xwYYe2vx3djweQBtFufr2vkBHx/BqURcli9P0we2rtq/BmPXz
         QOpg==
X-Gm-Message-State: AOAM530BAhZZ9WTuBekam2NkhE7I/ge5skz/xFjopuFnOtDN45qOILk9
        gQ2YnleIMhUlIDa/DuQ+zWJC5nUo10E=
X-Google-Smtp-Source: ABdhPJw/sdn1gt8TjM+1V8kV9F5tZdgwsF9ktI+oSOMfSxZt1AzbHZnyPK1DEmfBII5b4SKDMyR8iQ==
X-Received: by 2002:a2e:8e9a:: with SMTP id z26mr188877ljk.271.1596589356014;
        Tue, 04 Aug 2020 18:02:36 -0700 (PDT)
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com. [209.85.208.169])
        by smtp.gmail.com with ESMTPSA id e69sm311894lfd.21.2020.08.04.18.02.34
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Aug 2020 18:02:35 -0700 (PDT)
Received: by mail-lj1-f169.google.com with SMTP id v12so15389495ljc.10
        for <netdev@vger.kernel.org>; Tue, 04 Aug 2020 18:02:34 -0700 (PDT)
X-Received: by 2002:a2e:545:: with SMTP id 66mr210542ljf.285.1596589354467;
 Tue, 04 Aug 2020 18:02:34 -0700 (PDT)
MIME-Version: 1.0
References: <9f74230f-ba4d-2e19-5751-79dc2ab59877@gmail.com>
In-Reply-To: <9f74230f-ba4d-2e19-5751-79dc2ab59877@gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 4 Aug 2020 18:02:18 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiKiE1RvJ9mRYg5y94eC5RVmw+GHmy9B9zHZkZo0w0sNA@mail.gmail.com>
Message-ID: <CAHk-=wiKiE1RvJ9mRYg5y94eC5RVmw+GHmy9B9zHZkZo0w0sNA@mail.gmail.com>
Subject: Re: Flaw in "random32: update the net random state on interrupt and activity"
To:     Marc Plumb <lkml.mplumb@gmail.com>
Cc:     "Theodore Ts'o" <tytso@mit.edu>, Willy Tarreau <w@1wt.eu>,
        Netdev <netdev@vger.kernel.org>,
        Amit Klein <aksecurity@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andrew Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 4, 2020 at 5:52 PM Marc Plumb <lkml.mplumb@gmail.com> wrote:
>
> TL;DR This change takes the seed data from get_random_bytes and broadcasts it to the network, thereby destroying the security of dev/random. This change needs to be reverted and redesigned.

This was discussed.,

It's theoretical, not practical.

The patch improves real security, and the fake "but in theory" kind is
meaningless and people should stop that kind of behavior.

                Linus
