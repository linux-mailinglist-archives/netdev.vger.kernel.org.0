Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75DDD8A771
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 21:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726856AbfHLTot (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 15:44:49 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:37171 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726200AbfHLTos (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 15:44:48 -0400
Received: by mail-pf1-f194.google.com with SMTP id 129so3299819pfa.4
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 12:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Mc+ooOriZxrn+zVpdJrGmoqNMJwCMvUNyGKlJFjL7O0=;
        b=NVPrDBo2heIDC8AOLzTppEFDareWCpTcsdl2sYOf6R0o49V++GmlQwdqjqDWBdTYU7
         VdYAuhFRTQOm/zrquLgNgzAtnCDmdO8w4rOwYN32bx4tbImZLfvR5ECZmnNw8Y1+XBKj
         IExnvPh9Ax1YZrfBF/RAp1z09jquYc0FfADFFZoiDZAVMmYQxspy6E8jf9KbkXniOUh1
         6n4r0cXAilp9j+ueGydI+dyyZHLUU0sP+wbw3aqD1dH/gd7VAylBfMWl9goid5qR1q/4
         NgvI9dq91ShjXR52JYVFK9y7VIuRbZpp08lRof1OPPEUHDpPm1NxCv9XwXj3ZorvhvuX
         kOGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Mc+ooOriZxrn+zVpdJrGmoqNMJwCMvUNyGKlJFjL7O0=;
        b=cfju8FSyNn8ddO7i1eEcrbdFwYCkbSymC+GzwBKe8CZ/QdZI4jV+uNvTbutBvnntIl
         e3c04WGomYspX6dfE0vJmtPc1aeH1aT5D6RPN/IXGnr9dAbLzpG9lKq4FawFGIaHgvHi
         EK4jloZOnKgHVEAu3nm0IH3WaU36q5nnmBpnspRo83xq8B4U9ULy92O1Q2fnNFGrYf4P
         VKyQM6oruifsFgilj+/eTu5B2kg2BQyb8SN6kwODsxWl2wQuPOvGcNKW1wRT2lsAnDf7
         AAUQqWQU4erDb6WV32rQBI1BVZ+1pHU9T3Q0ZHV1Z+EFy0umtn70Gp/ggEcSgbxhxXfs
         ILWw==
X-Gm-Message-State: APjAAAV5lCH7/vqjDtwb2qnPKSa1IuQmRfVte/u/Jkp/0EObiSp8Xxmx
        G/85PW29T82GSzJNLmYHCcAYdJZxFMOn+02mjnTV78i/NPg=
X-Google-Smtp-Source: APXvYqz8QYl/ip+KVWNTz8Ikyi6QTXdurqTN/lY0Z5pNDGa7dj4PV45OTXxRIqbKA9MyduNHSeJMZRVxC3xuX0pGoTg=
X-Received: by 2002:a17:90a:bf02:: with SMTP id c2mr829733pjs.73.1565639087670;
 Mon, 12 Aug 2019 12:44:47 -0700 (PDT)
MIME-Version: 1.0
References: <20190810101732.26612-1-gregkh@linuxfoundation.org>
 <20190810101732.26612-14-gregkh@linuxfoundation.org> <CAKwvOdnP4OU9g_ebjnT=r1WcGRvsFsgv3NbguhFKOtt8RWNHwA@mail.gmail.com>
 <20190812190128.GB14905@kroah.com>
In-Reply-To: <20190812190128.GB14905@kroah.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 12 Aug 2019 12:44:36 -0700
Message-ID: <CAKwvOdkWzr5fu3v0KR2XXj0dqCZki=JOoMft9SMjs+XmZ8HpUg@mail.gmail.com>
Subject: Re: [PATCH v3 13/17] mvpp2: no need to check return value of
 debugfs_create functions
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Nathan Huckleberry <nhuck@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 12, 2019 at 12:01 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Mon, Aug 12, 2019 at 10:55:51AM -0700, Nick Desaulniers wrote:
> > On Sat, Aug 10, 2019 at 3:17 AM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > When calling debugfs functions, there is no need to ever check the
> > > return value.  The function can work or not, but the code logic should
> > > never do something different based on this.
> >
> > Maybe adding this recommendation to the comment block above the
> > definition of debugfs_create_dir() in fs/debugfs/inode.c would help
> > prevent this issue in the future?  What failure means, and how to
> > proceed can be tricky; more documentation can only help in this
> > regard.
>
> If it was there, would you have read it?  :)

Absolutely; I went looking for it, which is why I haven't added my
reviewed by tag, because it's not clear from the existing comment
block how callers should handle the return value, particularly as you
describe in this commit's commit message.

>
> I'll add it to the list for when I revamp the debugfs documentation that
> is already in the kernel, that very few people actually read...
>
> thanks,
>
> greg k-h



-- 
Thanks,
~Nick Desaulniers
