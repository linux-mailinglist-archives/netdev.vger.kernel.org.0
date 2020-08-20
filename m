Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2521224C4A7
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 19:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730620AbgHTRi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 13:38:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730616AbgHTRiK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 13:38:10 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5724DC061385
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 10:38:10 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id 3so2402731wmi.1
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 10:38:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=doI3XfaX+9V/uepR/x4ipWm730OyG7KRakzBs/1UgkI=;
        b=GoAB/7D9C20IzSHwMtonWI/NjmNJ4EjNrFA49CBAG0LkSh0DXXxmeL7bnZ4atHnlNG
         qI0A7ykXebdc6FQTyLuySAcp7M3qxse15A4yAf4/MeLCUrvMY4Ykw/iZRJrXHy6SGZqa
         g582BvOwdszeZne0Z3YkHmXFhfTkb7C5tGMAe7zjrhwGF2nquMVmoHp8buV5tDz/dBp3
         P6hxc1rkJoOGcarYkgIdp2rPFU8f02g4lGrTPGWrEn+ZOryAvSfQI3eI/PqxYBTT89iJ
         CYEak1dxZCe0wDfoBtmIw6gbvsLqhUEdjGudaeBtE9Vc8gPwiccK0WjpF6xwQgddqOcJ
         GGBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=doI3XfaX+9V/uepR/x4ipWm730OyG7KRakzBs/1UgkI=;
        b=VUjk9fl02UpqDPYc5JFRE7hJHmAJkWN/mTgghPVqiieLB/Oh42oTV7r48mEuIgq5TY
         vKPhKUlUYaHy+QO6BoCBovsNodKOTbI+WQCdDUowSWvzklTlc8BBZnPepXbGhyqnbqHM
         tt0bqG0659d5M8PpL1zOWMlGatJNR+zD5E+LcH/RfECMxWvKOg0lCMzEZq5ucnDDxr5b
         7YwQw9EcA+oEnNJ3JbAt71NCu78SPJCA5DtB/f+S0CTclMB3oyJHA4aPol17kAarY6BT
         XJomUb7dJz2lEJVHXg00SpBprj5R78g+Ef2o6U6EGvfgDFonY/fug1g0qiY0g9j3RpZ6
         hpJQ==
X-Gm-Message-State: AOAM532gktsZD5L92u2ok5wBfAlnqFCB/Me6iiFcth4A7SCljxHzWJmQ
        xiAQG59mVIyELSNdi8nJ8rLyYbJh6cn5kEZYzwX59g==
X-Google-Smtp-Source: ABdhPJwyw6qE44nFOkT0sOanR2aurVFqa3JweWtS6G2rJmHinuFlgRrN14qcfF30EA8jwvhQEcsbeCHFA0t2OGIhnxo=
X-Received: by 2002:a7b:cd97:: with SMTP id y23mr4541192wmj.4.1597945088827;
 Thu, 20 Aug 2020 10:38:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200820171118.1822853-1-edumazet@google.com> <CACSApvYYnrBT=HKeFdwvWzPaDxpYsusA4TQ5OubkgDGqiENMBw@mail.gmail.com>
In-Reply-To: <CACSApvYYnrBT=HKeFdwvWzPaDxpYsusA4TQ5OubkgDGqiENMBw@mail.gmail.com>
From:   Arjun Roy <arjunroy@google.com>
Date:   Thu, 20 Aug 2020 10:37:57 -0700
Message-ID: <CAOFY-A1OX1tLBrGZudZBnANc0Sa-PV9HKitoQazvycQAL2Jpxw@mail.gmail.com>
Subject: Re: [PATCH net-next 0/3] tcp_mmap: optmizations
To:     Soheil Hassas Yeganeh <soheil@google.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 20, 2020 at 10:32 AM Soheil Hassas Yeganeh
<soheil@google.com> wrote:
>
> On Thu, Aug 20, 2020 at 1:11 PM Eric Dumazet <edumazet@google.com> wrote:
> >
> > This series updates tcp_mmap reference tool to use best pratices.
> >
> > First patch is using madvise(MADV_DONTNEED) to decrease pressure
> > on the socket lock.
> >
> > Last patches try to use huge pages when available.
> >
> > Eric Dumazet (3):
> >   selftests: net: tcp_mmap: use madvise(MADV_DONTNEED)
> >   selftests: net: tcp_mmap: Use huge pages in send path
> >   selftests: net: tcp_mmap: Use huge pages in receive path
>
> Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
>
> Thank you for the patches!
>

Acked-by: Arjun Roy <arjunroy@google.com>

-Arjun

> >  tools/testing/selftests/net/tcp_mmap.c | 42 +++++++++++++++++++++-----
> >  1 file changed, 35 insertions(+), 7 deletions(-)
> >
> > --
> > 2.28.0.297.g1956fa8f8d-goog
> >
