Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 256C920FDAD
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 22:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729486AbgF3Uar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 16:30:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726051AbgF3Uaq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 16:30:46 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E211EC03E979
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 13:30:45 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id m16so10744943ybf.4
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 13:30:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hbndbL/42Lj3+0S0TLvtcAj80v30sW3yhJRu17Ph6zg=;
        b=srxxOCIJovcrNRpTPb+vPoi7ULhN9VgUvdErE5TP3DfGhwyIFPB5X6g/ztxdOGr8Us
         cpjIkRDzkeH2jZw3D/wftckIEerLd5rUdvtUl/8LL7o4CvGcZbSKsdi+WaWM/qnxhKCd
         boIWgG2TNdAWNBWCHz2xUim+xon2BGB9X2PErs/zMBI/HKpUPXRX84z8HRxjpZoFyw7A
         GRglbCa0bCmzMh4akDcfXLnK7oVF8/P6yxO8QApOOeMLhhaF9eUr5Q3XjeEze4ATPnqG
         ikdD5qaYLJKTBX9M7QaAARpIER+Zh5xgTueSnTdX8NYLpWJN3CQq0kE8IPbrNVGNSHgn
         da3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hbndbL/42Lj3+0S0TLvtcAj80v30sW3yhJRu17Ph6zg=;
        b=BeIDtCjM9ipwLYfqVj8/AcxUzCAxC2NTKaDodd+MtKTodtorh61TVxgaSM0XjsDhWC
         a56xYS2XcSa3eZjDeZtJyAtGkqc5swjUzv7a1HpZsHamP+sjm39VvW+2IjMh0ixDROM8
         89laUzgwRcDNZZ7Suzfk3WemrswJgDkleuT2r+guaMou7fpsYB3DjG7gYZ/IEHKqAFFM
         43hdQLudJfzQXPfoNKOASjhtM9tWQS9ItFgMEqeQ7llWineSHlq+ToSZpGrkwbJSnOPY
         F23tbNDQIynRWmbEw+yc2VhjcZq6KIQ3yLqXf/0Y+rWLfidYKkm78DK4dI/8GGwdG8a5
         im7Q==
X-Gm-Message-State: AOAM530zvfdUH0vec0eHjSe7zrdUafEBWJ+evKjpzRoEXuN1N3g7T4wl
        brXI9cFvH63A++h0Xp4/aOrCgJJkrOWzXytsjvkeyI5Q
X-Google-Smtp-Source: ABdhPJxNvCwjAE5cOI2IQkuy3+eSCuJzg/Oj6+537Ld+qP6KKGMKhW1Nd2SL7YrZZVP+Kg19OaW36nzhlXVEm+D0/5s=
X-Received: by 2002:a25:81c2:: with SMTP id n2mr14190731ybm.520.1593549044541;
 Tue, 30 Jun 2020 13:30:44 -0700 (PDT)
MIME-Version: 1.0
References: <1132973300.15954.1593459836756.JavaMail.zimbra@efficios.com>
 <CANn89iJ4nh6VRsMt_rh_YwC-pn=hBqsP-LD9ykeRTnDC-P5iog@mail.gmail.com>
 <CAHk-=wh=CEzD+xevqpJnOJ9w72=bEMjDNmKdovoR5GnESJBdqA@mail.gmail.com> <20200630.132112.1161418939084868350.davem@davemloft.net>
In-Reply-To: <20200630.132112.1161418939084868350.davem@davemloft.net>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 30 Jun 2020 13:30:33 -0700
Message-ID: <CANn89iKUUJsEfwp2L0pwKdCP3Rx-o=6uM+1bUhT5Cc2p0p7XqA@mail.gmail.com>
Subject: Re: [regression] TCP_MD5SIG on established sockets
To:     David Miller <davem@davemloft.net>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Jonathan Rajotte-Julien <joraj@efficios.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 30, 2020 at 1:21 PM David Miller <davem@davemloft.net> wrote:
>
> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Tue, 30 Jun 2020 12:43:21 -0700
>
> > If you're not willing to do the work to fix it, I will revert that
> > commit.
>
> Please let me handle this situation instead of making threats, this
> just got reported.
>
> Thank you.
>

Also keep in mind the commit fixed a security issue, since we were
sending on the wire
garbage bytes from the kernel.

We can not simply revert it and hope for the best.

I find quite alarming vendors still use TCP MD5 "for security
reasons", but none of them have contributed to it in linux kernel
since 2018
(Time of the 'buggy patch')
