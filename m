Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AEBC3F598C
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 09:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235225AbhHXH7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 03:59:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235086AbhHXH70 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 03:59:26 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72FB8C061575;
        Tue, 24 Aug 2021 00:58:42 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id l7-20020a0568302b0700b0051c0181deebso11969274otv.12;
        Tue, 24 Aug 2021 00:58:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qrGUvUS/KIDwQcIGab309fFc7Hn4+1ct5OaaYFM/29w=;
        b=VK2uY5st1jpFwxGElDlSwRqwvHMQWk3FvqpkK+obuEI5jXsKB+8SdgVwl+6bPv/58v
         l2yoQXoEmtAu06J372yv6LljhKdLHPQANcOadK505xe6S59BQ/0b+IKQ/oZOqQtHgk+G
         xue21I2+r/Qok0h88jMeNibWgnya+7g6qCa4JOCkNZEXgYNgCKAhCtzNQHH3OU1IHbTu
         nphEHtgUo213c8JuO0xxANIiM4zeJ4l7Zz58TLtvbknc9hmW2hkBPjX33/K8nYcLJ8c7
         X/9t6CXKbYbggTmyHk5f/tNCnje+5QHEdtPHPGxlC2o3pObuUZAIAbOa+X5cp/7bYTAy
         aofw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qrGUvUS/KIDwQcIGab309fFc7Hn4+1ct5OaaYFM/29w=;
        b=GwkGNafIZ5FkuEfOtZvcQRi+tKlSozpgId9IQY8s3AVFhZ57xYQvbKvwUQWIulAhzs
         g7/y3zFM7lLix/BqxI67BHQCJsU2jorbFMFUFv2SyZJfQbIOhWV2tuk8YzXHulnQrnwl
         I+nTud35Qv0gTPIJ9lJCuyngK6h4eclAduGPjPH/2DGNoWPT31sl2FDa7hlcQRjD51HI
         pb1YbUrG4dkyea62N5RPWgjBKUqaSCwMqxX7v4p2ON8LioMWrb7RqfhLPtn4S6sDkg8b
         PokiEfims0RJKxEOyjBmbtTb+uWS2zGAgCxXMeIdVo6DSlZ1T6U3WQXrEMZXr4HN2Ri7
         VfxA==
X-Gm-Message-State: AOAM530qkYSO5KLmY0qST27pFZUzDIbtfU0RDtV9wmZ7w4lyvhbjRs8K
        4iLHal1j1IYbJ0OPHA7JVxH2XRtucLcGaFb7RYY=
X-Google-Smtp-Source: ABdhPJz8Zixz9iOHRSHarGwc/mp2eUt5b8i28s21bK4CCcwVBiBuR+M3l80bTbzEGALKyz9y8jy/msoSHLG5FJM0r1w=
X-Received: by 2002:a9d:36d:: with SMTP id 100mr30558391otv.237.1629791921865;
 Tue, 24 Aug 2021 00:58:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210824071926.68019-1-benbjiang@gmail.com> <fe512c8b-6f5a-0210-3f23-2c1fc75cd6e5@tessares.net>
In-Reply-To: <fe512c8b-6f5a-0210-3f23-2c1fc75cd6e5@tessares.net>
From:   Jiang Biao <benbjiang@gmail.com>
Date:   Tue, 24 Aug 2021 15:58:31 +0800
Message-ID: <CAPJCdBmTPW5gcO6DO5i=T+R2TNypzbaA666krk=7Duf2mt1yBw@mail.gmail.com>
Subject: Re: [PATCH] ipv4/mptcp: fix divide error
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     mathew.j.martineau@linux.intel.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org, mptcp@lists.linux.dev,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Jiang Biao <benbjiang@tencent.com>,
        Jiang Biao <tcs_robot@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, 24 Aug 2021 at 15:36, Matthieu Baerts
<matthieu.baerts@tessares.net> wrote:
>
> Hi Jiang,
>
> On 24/08/2021 09:19, Jiang Biao wrote:
>
> (...)
>
> > There is a fix divide error reported,
> > divide error: 0000 [#1] PREEMPT SMP KASAN
> > RIP: 0010:tcp_tso_autosize build/../net/ipv4/tcp_output.c:1975 [inline]
> > RIP: 0010:tcp_tso_segs+0x14f/0x250 build/../net/ipv4/tcp_output.c:1992
>
> Thank you for this patch and validating MPTCP on your side!
>
> This issue is actively tracked on our Github project [1] and a patch is
> already in our tree [2] but still under validation.
> > It's introduced by non-initialized info->mss_now in __mptcp_push_pending.
> > Fix it by adding protection in mptcp_push_release.
>
> Indeed, you are right, info->mss_now can be set to 0 in some cases but
> that's not normal.
>
> Instead of adding a protection here, we preferred fixing the root cause,
> see [2]. Do not hesitate to have a look at the other patch and comment
> there if you don't agree with this version.
> Except if [2] is difficult to backport, I think we don't need your extra
> protection. WDYT?
>
Agreed, fixing the root cause is much better.
Thanks for the reply.

Regards,
Jiang
