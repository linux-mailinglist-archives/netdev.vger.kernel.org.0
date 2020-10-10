Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B097289E10
	for <lists+netdev@lfdr.de>; Sat, 10 Oct 2020 05:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731073AbgJJDtv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 23:49:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730912AbgJJDkH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 23:40:07 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99041C0613D0;
        Fri,  9 Oct 2020 20:39:10 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id a15so11470261ljk.2;
        Fri, 09 Oct 2020 20:39:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EZd9Q06+dSMoBHzxeY2ZyAUJPEB+WJs9tsTRJtSARk0=;
        b=VbAfevhe3LA9ZJuzkDSKIzGWrJ1BtpVKilCU4WRsOSYqGgt2uh71lwNTD9OpzYUNdb
         gyQ96oL9oH1SB+6byXcpLibWFAoTbOaXIhgJPSNSnXsIjuumZAkbRRDfRt4PcAH8HNiv
         yG8m8TYQBZznBLHt7+IJlgdmaToRVykzPvvnbIYlxGi/y88sLhco/Lf0SNeWtBWgp69g
         epTRZc42Bhtpe52do/qik+7aAr125FebFwjKUeYluGcJeYD30OsuuDUFAZ8KrTGkHxVQ
         c3rNBuPh4B+A86K85ovQwXZpVONUWnj0HMqFoJ0/7N3SZurykEzF0t67sBBZsLbLfgO6
         MC8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EZd9Q06+dSMoBHzxeY2ZyAUJPEB+WJs9tsTRJtSARk0=;
        b=cut3FTwj386q7M5qiQ99Agf6I1cXiBEEXs1iU0u2JtQzAfG3Dw4my3+00Z8FzKnzxD
         TzhiowXqRavBl1EJqGNBU1vNpmnyxEqDiiHHGL13b5f+BZBFnnc5LKY/zkucFsW0PQJ+
         SyVOjMtYcZnkeL8ZfgNqD6kuiN5L38Msu0BNzuTZydnm9cu+lGKc9+4nLDuLrhReeEWo
         BOktJpcimOwSkEED+iCxTSk+wntx5rgZesLK3QKFuviPwMqw8plj2Ltu1mzr8L4QAfvJ
         3JTsZm2SxvYlBu01Y1XVl4S8PvblGq3703HmivXNjBwnRa12qaueTZF6mdm7DuVFbva5
         UuGQ==
X-Gm-Message-State: AOAM532cP6HXDMLwQxbaoTlSQzGdD1cVdUJaN5UL4FfnpBlQYKkzEGMD
        OeL2Bd1VLRkCXxK+kOj+uGl521X7+qhK9Yo092PG9Q0S9Ik=
X-Google-Smtp-Source: ABdhPJwvy8ZDsWIbFPdbaKHWnFPlUqO8LSOlAex+5NvF9Bzynz01t8iBrBJgd+Jt4Nm2O7N3IhCQVbU4UO1cnLYr/9M=
X-Received: by 2002:a2e:82c7:: with SMTP id n7mr4587146ljh.59.1602301148859;
 Fri, 09 Oct 2020 20:39:08 -0700 (PDT)
MIME-Version: 1.0
References: <20201009103121.1004-1-ceggers@arri.de> <20201009103121.1004-2-ceggers@arri.de>
 <CA+FuTSfjZL-AMQy5PvVs6f3K8SEkWzdUrXz_4LniWFezVdfL8A@mail.gmail.com>
In-Reply-To: <CA+FuTSfjZL-AMQy5PvVs6f3K8SEkWzdUrXz_4LniWFezVdfL8A@mail.gmail.com>
From:   Deepa Dinamani <deepa.kernel@gmail.com>
Date:   Fri, 9 Oct 2020 20:38:56 -0700
Message-ID: <CABeXuvpZvMcnU0rczYyVWwQY2YW=GehJSNFsy2oBOuVH2kwasw@mail.gmail.com>
Subject: Re: [PATCH net 2/2] socket: don't clear SOCK_TSTAMP_NEW when
 SO_TIMESTAMPNS is disabled
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Christian Eggers <ceggers@arri.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 9, 2020 at 5:35 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Fri, Oct 9, 2020 at 6:32 AM Christian Eggers <ceggers@arri.de> wrote:
> >
> > SOCK_TSTAMP_NEW (timespec64 instead of timespec) is also used for
> > hardware time stamps (configured via SO_TIMESTAMPING_NEW).
> >
> > User space (ptp4l) first configures hardware time stamping via
> > SO_TIMESTAMPING_NEW which sets SOCK_TSTAMP_NEW. In the next step, ptp4l
> > disables SO_TIMESTAMPNS(_NEW) (software time stamps), but this must not
> > switch hardware time stamps back to "32 bit mode".
> >
> > This problem happens on 32 bit platforms were the libc has already
> > switched to struct timespec64 (from SO_TIMExxx_OLD to SO_TIMExxx_NEW
> > socket options). ptp4l complains with "missing timestamp on transmitted
> > peer delay request" because the wrong format is received (and
> > discarded).
> >
> > Fixes: 887feae36aee ("socket: Add SO_TIMESTAMP[NS]_NEW")
> > Fixes: 783da70e8396 ("net: add sock_enable_timestamps")
> > Signed-off-by: Christian Eggers <ceggers@arri.de>
>
> Acked-by: Willem de Bruijn <willemb@google.com>
>
> Yes, we should just select SOCK_TSTAMP_NEW based on which of the two
> syscall variants the process uses.
>
> There is no need to reset on timestamp disable: in the common case the
> selection is immaterial as timestamping is disabled.
>
> As this commit message shows, with SO_TIMESTAMP(NS) and
> SO_TIMESTAMPING that can be independently turned on and off, disabling
> one can incorrectly switch modes while the other is still active.

This will not help the case when a child process that inherits the fd
and then sets SO_TIMESTAMP*_OLD/NEW on it, while the parent uses the
other version.
One of the two processes might still be surprised. But, child and
parent actively using the same socket fd might be expecting trouble
already.

Acked-by: Deepa Dinamani <deepa.kernel@gmail.com>

-Deepa
