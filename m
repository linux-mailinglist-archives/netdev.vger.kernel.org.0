Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D58224C494
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 19:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730503AbgHTRc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 13:32:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729448AbgHTRcL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 13:32:11 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB6B7C061385
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 10:32:09 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id k8so2375072wma.2
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 10:32:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Mu1U255Wdfws6RAN0pd3/AnXRvP43Yfynhy7fFri7d8=;
        b=NvUL8IOyy1hF1YqsyxIqRt9qSoJligBL9UT1hyFGmb9Jhk4w+dvnQGCERvVPs86DZh
         tezgPeldnKfJa4rKTWXXr84e6fQm6SvqAIVbZBhE1jpKEYfYshbOj8ptJSOU128ixPoQ
         S4wb7syocFypIJ2t3NIEN5aWz3apA77eSdujqMD7TVOvKtgkEqbk3w3BLO7UMWUbaDYP
         OpwShhbrVtH93mc9Q9hI5tQTB/RkJwkXQcJ/5WAplZ6J5NDBsNPCvik9gYphGHsq7Am1
         Ve17TtA4rQG1MUJajlqjt1zoYvPU7mVExcfyhm08h5Q8u67wY9awgB9jh/jxmfDF6M3d
         k5qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Mu1U255Wdfws6RAN0pd3/AnXRvP43Yfynhy7fFri7d8=;
        b=ME/xwNbWkJI4cP1EUlCK1ZE/XTZyOzkLzIPsmR7h2pjUTySNewOaqrcdGU4Bdj5SpZ
         AhZPhQBAJCaHeawD4UNP8O29yuZDDRW0SJagLR6gwJT/3PXmUoPmSofXffoxpCJW76lM
         +UHqxE5C8+GAT9106uTHuIX1BquBQTiu4D1Ue2eAoK+p1p3ztEwiyhOpvbaEGw/Q8W3T
         GsTOX/DVmet4DKzfq+51ESC45O00BdD5opWJtwn26tJ5NJjSAPh/eYdZCX6Wt+t5oIxF
         s2rxqWVnG9pzoe4CcN+ue/PJ76cgjwzNvwjjSXjYBLWT/MpRp5RMoZpgnwvVEY6GivEi
         CONA==
X-Gm-Message-State: AOAM530eSCtg2MGmmiV9idh504szCWTPF2U1aQ5o5y/KN6ZckdDoylPT
        Rrcgg9Ov1Mqe/4FWKWWyw//FJBBB7QP/ClLXNqrtiA==
X-Google-Smtp-Source: ABdhPJz1Mk87XmyRDWblDdYiJnjZ+b0Y2EFQNzNB7QkPnXB5lNqhsvY33LzUEmOuk8KDTkzE13nCwOcJMzhOvtohbEM=
X-Received: by 2002:a05:600c:24cc:: with SMTP id 12mr3039755wmu.117.1597944728243;
 Thu, 20 Aug 2020 10:32:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200820171118.1822853-1-edumazet@google.com>
In-Reply-To: <20200820171118.1822853-1-edumazet@google.com>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Thu, 20 Aug 2020 13:31:31 -0400
Message-ID: <CACSApvYYnrBT=HKeFdwvWzPaDxpYsusA4TQ5OubkgDGqiENMBw@mail.gmail.com>
Subject: Re: [PATCH net-next 0/3] tcp_mmap: optmizations
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Arjun Roy <arjunroy@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 20, 2020 at 1:11 PM Eric Dumazet <edumazet@google.com> wrote:
>
> This series updates tcp_mmap reference tool to use best pratices.
>
> First patch is using madvise(MADV_DONTNEED) to decrease pressure
> on the socket lock.
>
> Last patches try to use huge pages when available.
>
> Eric Dumazet (3):
>   selftests: net: tcp_mmap: use madvise(MADV_DONTNEED)
>   selftests: net: tcp_mmap: Use huge pages in send path
>   selftests: net: tcp_mmap: Use huge pages in receive path

Acked-by: Soheil Hassas Yeganeh <soheil@google.com>

Thank you for the patches!

>  tools/testing/selftests/net/tcp_mmap.c | 42 +++++++++++++++++++++-----
>  1 file changed, 35 insertions(+), 7 deletions(-)
>
> --
> 2.28.0.297.g1956fa8f8d-goog
>
