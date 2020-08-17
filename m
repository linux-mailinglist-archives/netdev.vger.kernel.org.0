Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67DD0246608
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 14:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbgHQMI7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 08:08:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbgHQMI6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 08:08:58 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A48FC061389
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 05:08:58 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id s1so4232364iot.10
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 05:08:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kie1ZPIcUSETnkWwDT71QuT+dnStcZrDR3cx1cfuTOE=;
        b=eWuZ8M8ueo2ePsRsALabzVxG/0Xh2fYlRRA+kEYRmzNrmI5I1Hqn+sOQDkMp4L94Vm
         Q4lSGz4soXqYF/MdGjSRQENMo01OwEXZ09jxmrjj2Zd3g54/XZwAfp1v/lL2ZKNram/8
         lodoLZ/IvGBShy/WbXihZBtnTOBoxywWVyVSYQlxOLpU8qgx+l7jbgSf33h4fmEmrdNP
         tU8UprOYwcngtYxsjSZtubn+D06i+gXM5eh/Gx8bdTZ3uIFY3kYpzCBy96v2bWC1y2Ia
         zjolXQYm2M5ndb+/ms09oHNZVGQC/pVRekk/P/VfAomVAKzvvKlUbiBCByHMhrwDMb0S
         kTng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kie1ZPIcUSETnkWwDT71QuT+dnStcZrDR3cx1cfuTOE=;
        b=RYwG2PsG2TKxzgdhDTxtU98UvqoO1qqaRhN6GjVPGadqB3AM0LtFOdCannbXRLjbO9
         soac0ppt3X8Db0CyKpGu0dt8i0vMQI4qouzII+WbRWNMriJvrHMv8DkdupMc2pTT22Bu
         xJAAMHjAmafZAqFQ5o7qzM7ZUdytv2LDzlXnpBxIp3JQT9y98ik6tseCvEhATPKq6/ow
         HTg0NsFaiaPavQ00YoSbaSVegCC8O2qSqtIrafAK/WomD+1nJT+aVKfM9bress/6QYpy
         fais6ouRlrQ8FkZT1vfwXjZbwnOmNLF7HBEponxizdjD7OfnbkTJ9fWn3WfqMqqzbrUg
         PaWQ==
X-Gm-Message-State: AOAM532ue2CiPap4a/mvs1uQObc0hJ4RbrBlD/pAE42CSWtTH92otEXp
        O1MD7S5kleTM8NFNnekBkSlGo5uWJFuTAB8Wv9qkVeQt1x/SmA==
X-Google-Smtp-Source: ABdhPJz3UrH9iMmhn30GkcgM+KMkHPpGzsEGASa/0Rw2EMwJtiRrBCyugrhTJjfDQ8gcYUKjeE3AF9SU3tDU8DaAk6Y=
X-Received: by 2002:a05:6638:1643:: with SMTP id a3mr14677512jat.104.1597666135445;
 Mon, 17 Aug 2020 05:08:55 -0700 (PDT)
MIME-Version: 1.0
References: <CAFbJv-4yACz4Zzj50JxeU-ovnKMQP_Lo-1tk2jRuOJEs0Up6MQ@mail.gmail.com>
 <CAM_iQpWhwQc4yHvfFh-UWtEU2caMzXFXs4JM4gwQaRf=B0JG5g@mail.gmail.com>
 <CAFbJv-5KYtxrXwiAJmyFuKx9zVn1NaOmt-EA7eM+_StS-+dbAA@mail.gmail.com> <CAM_iQpVSP=2Rd8WoOu3bJVVnt63pjLQWmj5TaG6J+KDh0Xghxw@mail.gmail.com>
In-Reply-To: <CAM_iQpVSP=2Rd8WoOu3bJVVnt63pjLQWmj5TaG6J+KDh0Xghxw@mail.gmail.com>
From:   satish dhote <sdhote926@gmail.com>
Date:   Mon, 17 Aug 2020 17:38:44 +0530
Message-ID: <CAFbJv-59gcsnqLox_HBz+EaordnubM0f79bBz7RghYztRnPLfQ@mail.gmail.com>
Subject: Re: Question about TC filter
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry for responding late. I got engaged with other work.
I didn't replace ingress with ffff

To do more experiments, I will have to recompile everything
from fresh as I lost that setup where I was experimenting with
tc utility.

But if we can get inputs from Daniel's about this change,
it will help us to figure out whether this was really a bug or
expected behavior.

Thanks.

On Fri, Aug 7, 2020 at 12:05 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Thu, Aug 6, 2020 at 10:21 AM satish dhote <sdhote926@gmail.com> wrote:
> >
> > Hi Cong,
> >
> > I tried adding below patch i.e. "return cl == 0 ? q->block : NULL;"
> > but after this I'm not able to see any output using "tc filter show... "
> > command. Looks like the filter is not getting configured.
>
> What exact command did you use? If you specify "ingress" rather
> than "ffff:", it is exactly _my_ goal, because prior to clsact, only
> "ffff:" could match ingress qdisc, the keyword "ingress" did not
> even exist.
>
> Of course, it may not be Daniel's intention, he might expect
> "ingress" to match ingress qdisc too for convenience.
>
> Thanks.
