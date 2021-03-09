Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2D90332A71
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 16:30:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231688AbhCIP3l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 10:29:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231338AbhCIP3M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 10:29:12 -0500
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B190C06174A;
        Tue,  9 Mar 2021 07:29:12 -0800 (PST)
Received: by mail-lf1-x143.google.com with SMTP id v2so14701108lft.9;
        Tue, 09 Mar 2021 07:29:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=w5ZVq6qO8e5SzhIkBtoDJ2wfF3ZTvqMngw/5OUOs0/o=;
        b=uKG9tc9xKyNawNtTlpOYIX3VrofJ30zh28bvjP/iqDC+YVNFa5wt34q9Tq+MmvrJ+d
         uv5YgnYN9u1YrUYlZMGqsR0ZJ4FK0/LU1S0GhKDzr19uoNHbIxjXFmWA37858/aDk6pj
         7WVOmSOGuYcQXrsu1SpX30iVGq0RzpweSlcSQq46x9b9u5nkSNF0N3LIE0t76pV0BV7c
         zIHPgN4TJvhm2miuKxZReId8dsmKdk1VBlKpgX667Y2etUS6byiVhXkbkRfImGfOe5Ga
         lSBkz+Os/FRSorukrAHbNoBkk6JtNOXUWRbxni0lKwm5fi0ofWV1qJ6LDRJcKsu4/xGO
         cDVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w5ZVq6qO8e5SzhIkBtoDJ2wfF3ZTvqMngw/5OUOs0/o=;
        b=dFDZmOfsqNReBomoNY6WSVXoHKPDNhKlTkRwSMRb+ihiWpOFoYtxTSjxBfziIVs2Lu
         JfOcFzSdsL83i9CRrY6VHaDX3zq+9xzgQJj6iPWCxkH2y1TylPKmTHU53vSXexLr+xBu
         i3/2f6eWM+AKhA62o5ultKyO5fQz7X1yALaT1NNnhNnmIwEgYVqEFs0IGyRm3n8vhrqC
         7DSXqiBJKZgfAm3JOjrjbQGUGrj3Qu+l0BfRzv8c2BCxctgXnDoteUI43esq9FidFUCF
         N1McUKwlX2eW9PbT77TvDBBl+j4J1dq/P4iQ+f2Py4UcdWNiZmiEo2UwId2TWROw31Qh
         8MfA==
X-Gm-Message-State: AOAM532Y6Yd5tLXBI8K9NId/GqPJnbCrDXcOhJHlDVqMMuqNOPPVRjnS
        9V4IZB9Kg1ns4GJqKRZsXkVnhjOGDGfFokerJLw=
X-Google-Smtp-Source: ABdhPJxbJw6hyXnyYAaelc+qheOLwz/cFIz/Ax14rHl3XqVU9mBT4dBn3LS4jRehNX1Wjk3cWcAN76ebPlYgUZrCJEE=
X-Received: by 2002:a19:85c5:: with SMTP id h188mr17775973lfd.273.1615303751036;
 Tue, 09 Mar 2021 07:29:11 -0800 (PST)
MIME-Version: 1.0
References: <20210217065427.122943-1-dong.menglong@zte.com.cn> <20210223123052.1b27aad1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210223123052.1b27aad1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Tue, 9 Mar 2021 23:28:59 +0800
Message-ID: <CADxym3Zcxf05w2a0jis2ZyGewwmXpLzS4u54+GRwf_n2Ky7u0A@mail.gmail.com>
Subject: Re: [PATCH v4 net-next] net: socket: use BIT() for MSG_*
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jens Axboe <axboe@kernel.dk>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Menglong Dong <dong.menglong@zte.com.cn>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On Wed, Feb 24, 2021 at 4:30 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
...
> Please repost when net-next reopens after 5.12-rc1 is cut.
>
> Look out for the announcement on the mailing list or check:
> http://vger.kernel.org/~davem/net-next.html
>
> RFC patches sent for review only are obviously welcome at any time.

Is 'net-next' open? Can I resend this patch now? It seems that a long
time has passed.

Thanks~
Menglong Dong
