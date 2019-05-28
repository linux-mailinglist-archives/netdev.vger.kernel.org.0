Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 779B92D190
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 00:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727463AbfE1W1G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 18:27:06 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:46045 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726706AbfE1W1B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 18:27:01 -0400
Received: by mail-lj1-f194.google.com with SMTP id r76so414612lja.12
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 15:26:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ktt9gYykDzHpqn8jF4Qn7x/F6J4TOsbrfkkqyFVpV5w=;
        b=n+HTPMYY03EsfqfMQMiANp2md/hDS/jlVuamukt0nOAU7xPknfYtDemk0kZgZuFTHv
         bRRyBB/UYNm0BKOmBOfzzowydINpzWcs+zehMLezF9i+fjo7UBomNhnCVNZY0EjYJ+5y
         LmKd1wAWg/jiTQEzLus3rLiA0eqqVE5BX5YSZA2T3ue0t+KGYzatINIK83DcRmdhPCJD
         VYpI6oVq4rK33VxUzojZ7YDWOJpYL64PE5qMqe7J+W/bnibjK9Pf7iJOmD0adHosNm20
         IPQPZcunlCxBbtuQ16uU5TccmfLXarLNDZojREYCYpTIyI/q+PK5X7zIKyD4V82AbhxR
         4d5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ktt9gYykDzHpqn8jF4Qn7x/F6J4TOsbrfkkqyFVpV5w=;
        b=fB9cv/SixiThycKCdhTRkvf8FiXc31Q56iR82X16k/ZwR7ZsvinseZEHJnURVmlD6b
         fxHdI7xogjMoX5qsG113ZH484iYblAbLMmDo9kC8R78XO4EFwf7u+cr8+A/cg9L6qUrD
         jeBwIXcDCFqkazHGO/uSRhWgvAr3qLbUoL5Wd+HOVEXP6iyEBFBOJiq4HOYGMcBKL1Wa
         UfwY4yUdSkqyNzFKZkVlMd87jNC+LrxpciED+wusgvWjHZw+qn6uupLzKklS1jUHODXv
         2lDbp8r8lZx3yHtOlNorGa6BJB6zT+WsLH3PeY+x0l3kyFFu5M4g/hrt2GVHpkVC0Ldz
         RcgQ==
X-Gm-Message-State: APjAAAVyhieBvm/nz79MI2MS/1EaP37T0Q2ivAAljR7eE1F23BIt9/0d
        rZk5z5f9ej29IhGkvZxhGo5tZR2p0M+eYoKDKAG4
X-Google-Smtp-Source: APXvYqxDbW1InkCBbmSLm8KlqXmvlXu3oe3jcdB9CqBRbawDuAW8nu9Cieu8BrGQMf+AwTidy9xNra96kS1tITFYFCY=
X-Received: by 2002:a2e:9106:: with SMTP id m6mr425785ljg.164.1559082418552;
 Tue, 28 May 2019 15:26:58 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1554732921.git.rgb@redhat.com> <20190422113810.GA27747@hmswarspite.think-freely.org>
 <CAHC9VhQYPF2ma_W+hySbQtfTztf=K1LTFnxnyVK0y9VYxj-K=w@mail.gmail.com> <509ea6b0-1ac8-b809-98c2-37c34dd98ca3@redhat.com>
In-Reply-To: <509ea6b0-1ac8-b809-98c2-37c34dd98ca3@redhat.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 28 May 2019 18:26:47 -0400
Message-ID: <CAHC9VhRW9f6GbhvvfifbOzd9p=PgdB2gq1E7tACcaqvfb85Y8A@mail.gmail.com>
Subject: Re: [PATCH ghak90 V6 00/10] audit: implement container identifier
To:     Dan Walsh <dwalsh@redhat.com>
Cc:     Neil Horman <nhorman@tuxdriver.com>,
        Richard Guy Briggs <rgb@redhat.com>,
        containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com,
        simo@redhat.com, Eric Paris <eparis@parisplace.org>,
        Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com,
        Mrunal Patel <mpatel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 28, 2019 at 5:54 PM Daniel Walsh <dwalsh@redhat.com> wrote:
>
> On 4/22/19 9:49 AM, Paul Moore wrote:
> > On Mon, Apr 22, 2019 at 7:38 AM Neil Horman <nhorman@tuxdriver.com> wrote:
> >> On Mon, Apr 08, 2019 at 11:39:07PM -0400, Richard Guy Briggs wrote:
> >>> Implement kernel audit container identifier.
> >> I'm sorry, I've lost track of this, where have we landed on it? Are we good for
> >> inclusion?
> > I haven't finished going through this latest revision, but unless
> > Richard made any significant changes outside of the feedback from the
> > v5 patchset I'm guessing we are "close".
> >
> > Based on discussions Richard and I had some time ago, I have always
> > envisioned the plan as being get the kernel patchset, tests, docs
> > ready (which Richard has been doing) and then run the actual
> > implemented API by the userland container folks, e.g. cri-o/lxc/etc.,
> > to make sure the actual implementation is sane from their perspective.
> > They've already seen the design, so I'm not expecting any real
> > surprises here, but sometimes opinions change when they have actual
> > code in front of them to play with and review.
> >
> > Beyond that, while the cri-o/lxc/etc. folks are looking it over,
> > whatever additional testing we can do would be a big win.  I'm
> > thinking I'll pull it into a separate branch in the audit tree
> > (audit/working-container ?) and include that in my secnext kernels
> > that I build/test on a regular basis; this is also a handy way to keep
> > it based against the current audit/next branch.  If any changes are
> > needed Richard can either chose to base those changes on audit/next or
> > the separate audit container ID branch; that's up to him.  I've done
> > this with other big changes in other trees, e.g. SELinux, and it has
> > worked well to get some extra testing in and keep the patchset "merge
> > ready" while others outside the subsystem look things over.
> >
> Mrunal Patel (maintainer of CRI-O) and I have reviewed the API, and
> believe this is something we can work on in the container runtimes team
> to implement the container auditing code in CRI-O and Podman.

Thanks Dan.  If I pulled this into a branch and built you some test
kernels to play with, any idea how long it might take to get a proof
of concept working on the cri-o side?

FWIW, I've also reached out to some of the LXC folks I know to get
their take on the API.  I think if we can get two different container
runtimes to give the API a thumbs-up then I think we are in good shape
with respect to the userspace interface.

I just finished looking over the last of the pending audit kernel
patches that were queued waiting for the merge window to open so this
is next on my list to look at.  I plan to start doing that
tonight/tomorrow, and as long as the changes between v5/v6 are not
that big, it shouldn't take too long.

-- 
paul moore
www.paul-moore.com
