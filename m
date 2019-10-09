Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EEC4D04A0
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 02:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729880AbfJIALW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 20:11:22 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:35092 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727051AbfJIALW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 20:11:22 -0400
Received: by mail-ed1-f65.google.com with SMTP id v8so410353eds.2
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 17:11:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PqCjo4AXCh85f3D4Vh6kSEIykuRReekYwhkHFH6kX4M=;
        b=Lv38c+8BLUkUTusWXC1q9V6avhBZu74CTl8Tt5GjmAhIxHdIc+lHpTXpqi0IRBxi1x
         yOGnlk7c39OnO72nqoRi20s9a4b8Q91ja01IMgJdW7/POFc0w5tbFyE1I2mciVr8wS7i
         I4YddQEqOOeVPSUOY/HDBy23JORXyLGkGnngYidcPLXy5xp8rl9AsWG5qxJJK61GowP6
         S6ptnQY1tY7VQOV1WPPQSXdH0gz0UMuIvKqWTrp/xhk+lYuxKOHN0YTK2JfbfeUa34Ki
         lsmcXxvkN2Wu/s1zpF4HckpmsXeBX8U1UpjzR/NjTAs4LixW4ZpCQaivaw/Ix2kDSewL
         fcqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PqCjo4AXCh85f3D4Vh6kSEIykuRReekYwhkHFH6kX4M=;
        b=gObHe6KJmjiNTOm6D8cQQX10smhYoV+KfVoci9FOM5El9VDuMItjDDZh8eqMRNDu7V
         w2IJUf4uH7G+gp3DKpLVl8TFvCTEHWzyDuC5Q/0tR1evQeGUxJ9KAJjWpMPQu9ENBik/
         raSefCxhPdCVuW6ukB9iAvc94odQKPdQkixu29S1E/+7RLrfzSRH8c6hbuLx6c5rIWuB
         1NJGqo1OokxMNby5oLeUk9bzQh6IU6zbCxHC9EikpqlLW2uq8cDenvf2KjiCh6a9XVjM
         ahya7Bwk1jVu+waek348nCCIAMlipSzD0oh6EK2XB5OUCpodcAWZPgL86B+Q7PxvDeQZ
         WjHw==
X-Gm-Message-State: APjAAAUzoqoVpR11jzkFk8zZ6vkjiTjN8HvMGMU4561MuG/xnbQ7mKpC
        JghDNwuC0bL7IBnzSo2viORCbpfK4zXxOFuQMiM=
X-Google-Smtp-Source: APXvYqxv8W1wqpD+K5bbG/hoz5Ita+CcnGIZtLIM86hnwNN1YPcESFRKEif4JNDOCMXUYmverk0nnB90JIWVgQuLfkU=
X-Received: by 2002:aa7:c6d0:: with SMTP id b16mr646697eds.108.1570579881155;
 Tue, 08 Oct 2019 17:11:21 -0700 (PDT)
MIME-Version: 1.0
References: <20191008232007.16083-1-vinicius.gomes@intel.com> <CA+h21hoc=shDEHSN-SEyO3qS7sBW4GzswcVrHW-7Sud9aP7apA@mail.gmail.com>
In-Reply-To: <CA+h21hoc=shDEHSN-SEyO3qS7sBW4GzswcVrHW-7Sud9aP7apA@mail.gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 9 Oct 2019 03:11:10 +0300
Message-ID: <CA+h21hp6dFUEA5ALbqcEjVsXXOWG1Up_QtftKWKphjpJz6-JXA@mail.gmail.com>
Subject: Re: [PATCH net v1] net: taprio: Fix returning EINVAL when configuring
 without flags
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 9 Oct 2019 at 02:58, Vladimir Oltean <olteanv@gmail.com> wrote:
>
> Hi Vinicius,
>
> On Wed, 9 Oct 2019 at 02:19, Vinicius Costa Gomes
> <vinicius.gomes@intel.com> wrote:
> >
> > When configuring a taprio instance if "flags" is not specified (or
> > it's zero), taprio currently replies with an "Invalid argument" error.
> >
> > So, set the return value to zero after we are done with all the
> > checks.
> >
> > Fixes: 9c66d1564676 ("taprio: Add support for hardware offloading")
> > Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> > ---
>
> You mean clockid, not flags, right?
> Otherwise the patch looks correct, sorry for the bug.
> Once you fix the commit message:
>
> Acked-by: Vladimir Oltean <olteanv@gmail.com>
>

No, you are actually right to phrase it this way, but the description
is still confusing. When 'flags' is zero, the driver takes a code path
which is buggy and always returns a negative error code. Although I'm
not really sure how much better this can be phrased. I'm fine with the
description now too.

> >  net/sched/sch_taprio.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
> > index 68b543f85a96..6719a65169d4 100644
> > --- a/net/sched/sch_taprio.c
> > +++ b/net/sched/sch_taprio.c
> > @@ -1341,6 +1341,10 @@ static int taprio_parse_clockid(struct Qdisc *sch, struct nlattr **tb,
> >                 NL_SET_ERR_MSG(extack, "Specifying a 'clockid' is mandatory");
> >                 goto out;
> >         }
> > +
> > +       /* Everything went ok, return success. */
> > +       err = 0;
> > +
> >  out:
> >         return err;
> >  }
> > --
> > 2.23.0
> >
