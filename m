Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 626BAB7B6A
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 16:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732283AbfISOBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 10:01:13 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:41714 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732085AbfISOBN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 10:01:13 -0400
Received: by mail-yw1-f67.google.com with SMTP id 129so1252989ywb.8
        for <netdev@vger.kernel.org>; Thu, 19 Sep 2019 07:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TfOfZxjCjN6kZ5xk5Slh33llSv4LFwzSXiIYdtXV/GM=;
        b=TynmgXVEcqHHexOrxMEt4TpCQAPBZkbcqYcdBYZuar7BP5uWu6o23kcB8On2zweH4L
         O/KwnFc58b0hNNT/lBGQGa0oDj8N4SFDlNCoonP+j47WsefI2bBxDvC4pKaa854bBOSu
         JbbZBUl9M74H2Xdh+HYhbZYKd5Vs1q97Q2YnO55zaILEZpbHypKe7i5x7jD7a5a8ikHn
         lZ8xoNqfBb7IJ1YT2m/P2qKpNGo5bF98+oOCT+bUY1iPS18V2sLZdXmopcSJIM577C97
         kiG7+bcVEIlQwO0gnHQ03pMcrCzLpzq6vTvaju0fs/oKt54JTEYdor9GYFfWAfNEyMGg
         3mRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TfOfZxjCjN6kZ5xk5Slh33llSv4LFwzSXiIYdtXV/GM=;
        b=s0Oqa23sF92aR3/i5A/AucPAsDCdzu0LzDxLYq/O8j61xaJBegLS1qfwJUvLC1dHUH
         25J8BTQOrNMPldZFqwlcl3a5/FvMWGgpS3HC7/jOY5oO7sMI8GQeM9LcqKB6AvLxLVco
         7+BAtiwd78hdmbCvrQzjvmNNy5cf6zbP8Yflr6F8s7TNHsNqKp8l1Nqn/kUjarGQ9sA4
         10DjFANYtIqk4+sWfGc3pyBQ9UR3PqpKDwPCexODuorIEQnmGGrLxufC4MOxH9TI1iKt
         rFPe5I7FEX5KGGlbQLSYAJvneEQ4FQ4rYLRt2E8CZeVaozYurPy17WEiVH/eb+wkuliI
         Qy3g==
X-Gm-Message-State: APjAAAWcYo4MHYkFg7PS+Jyo0XVwa6iC3qM6gheyZ+lq3SebU7QjGB+Q
        rL88yFeVE7qTGbL+u8+VSmUoFdeAvAYbOG2EBheUJCoa
X-Google-Smtp-Source: APXvYqwqi1UZzGAXVUtH0cI5P4o5iptt7BKirKEAxxxJ00aiJ17erdm8YE26DSdRErcSLMrPeBHmJ3BXpuQqLkGDzyE=
X-Received: by 2002:a0d:db92:: with SMTP id d140mr8463040ywe.73.1568901670731;
 Thu, 19 Sep 2019 07:01:10 -0700 (PDT)
MIME-Version: 1.0
References: <20190910214928.220727-1-edumazet@google.com> <CAJ3xEMhh=Ow-fZqnPtxUyZsCN89dRmy=NcaO+iK+iZZYBdZbqA@mail.gmail.com>
 <cd1cce3d-faf5-d35b-7fd4-a831561eea14@gmail.com>
In-Reply-To: <cd1cce3d-faf5-d35b-7fd4-a831561eea14@gmail.com>
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Thu, 19 Sep 2019 17:00:59 +0300
Message-ID: <CAJ3xEMgqvFEF1YvL4cV7UEpijki1QXGf+ZqVT5EO8SvYwkHaqA@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: force a PSH flag on TSO packets
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Tariq Toukan <tariqt@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 19, 2019 at 4:46 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> On 9/19/19 5:17 AM, Or Gerlitz wrote:
> > On Wed, Sep 11, 2019 at 12:54 AM Eric Dumazet <edumazet@google.com> wrote:
> >> When tcp sends a TSO packet, adding a PSH flag on it
> >> reduces the sojourn time of GRO packet in GRO receivers.
> >>
> >> This is particularly the case under pressure, since RX queues
> >> receive packets for many concurrent flows.
> >>
> >> A sender can give a hint to GRO engines when it is
> >> appropriate to flush a super-packet, especially when pacing

> > Is this correct that we add here the push flag for the tcp header template
> > from which all the tcp headers for SW GSO packets will be generated?
> > Wouldn't that cause a too early flush on GRO engines at the receiver side?

> If a TSO engine is buggy enough to add the PSH on all the segments, it needs
> to be fixed urgently :)

yeah, but I guess you were not able to test this over all the TSO HWs
out there..
so I guess if someone complains we will have to add a quirk to disable
that, lets see..
