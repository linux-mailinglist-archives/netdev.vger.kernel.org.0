Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34567214D89
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 17:12:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728069AbgGEPLz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 11:11:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727079AbgGEPLx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 11:11:53 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85E6CC08C5DF
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 08:11:53 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id a8so31155044edy.1
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 08:11:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KEtBGKGu7+F7kv2SoCb+jcPQSY3d8v9OKOQZlWY0FOw=;
        b=cUFTmXA/DyAnDDYLg8ipvtwwYTnqfzvAaNvgPrFtpf0WHTtlMgF1J8JEYu+SztZCcN
         qY0T0sITN67xTjXr2olj+hlGjYD+kDPa9BvIYID3C9aUNWjKEKkN1WotcjaiAIwhfYVg
         dpsRVCmvS0LuYgCK01Gcp1Uc1xbXmFY6rn0oWYoTS686cxKm+hoFAZHkzriABSN8H0NR
         aEYHPPkebf+QX7omBXu2KcHuG27AfCpbD60BsfJhSGgFTdBW3ZqyXo4aqTT0mW1nXMsq
         USc3rqqqb7llr4PRpkZ3cnHVIMkicmS1ADVjxqC3y7wHUC2/1785plYpSFtkctgFbDur
         yOeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KEtBGKGu7+F7kv2SoCb+jcPQSY3d8v9OKOQZlWY0FOw=;
        b=Wxgssk7D/iCNb9WHWi1OhjjywwB4SwChFPrPM5wiWsT4t/eW0H+XNNsQkNgnWB3M3p
         6o7ZHYuA9jMLCw8ffXQqgmEhitAH5y1uMHXuLzvSSiuJETmUG2sRgzT8Hnv1UUc9VMBG
         NMzvI/JOptnXyvYxTKa0d6veliMe7EeUp7pbZVIkJJQeO8MjP/l3+cMv6BTWGfXMMzlC
         6MT1vmsY50Sh+AuX4g90d793w7wwmzCZaGSns4Jrooz6sdzowxTn2ngYaEb4zgInGLxH
         LBQFM15VHZUVB7pA10tWWEFOuIGEzuUHq1ByN5qRTiThddyNst0kQzcVWlgyaAJ9CO7b
         SV7A==
X-Gm-Message-State: AOAM533K/UzC9+u12wpGkPQtg6ZMgWNFLNmi+34C/WJMP/9Je+VleQh+
        i9aqm8Ztzamn0VGmt+jLXMEfQf3iHWH+3L/8YgGh
X-Google-Smtp-Source: ABdhPJyxEw+kqzFSwys8tQ8mezUCXkLSxfhtpjmtIc6SHLfqNuWzPVC+Pu8lGM/GQauxfK+ZBDG3aPYWtwY05QusqCU=
X-Received: by 2002:a05:6402:742:: with SMTP id p2mr31354555edy.135.1593961912251;
 Sun, 05 Jul 2020 08:11:52 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1593198710.git.rgb@redhat.com> <1d793e2fc60650de4bbc9f4bde3c736c94efe9a1.1593198710.git.rgb@redhat.com>
In-Reply-To: <1d793e2fc60650de4bbc9f4bde3c736c94efe9a1.1593198710.git.rgb@redhat.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Sun, 5 Jul 2020 11:11:40 -0400
Message-ID: <CAHC9VhRU9+h-hXKJTuMnZfyOgiktOPMRzzgAP7+VSXV7COjJuw@mail.gmail.com>
Subject: Re: [PATCH ghak90 V9 12/13] audit: track container nesting
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        sgrubb@redhat.com, Ondrej Mosnacek <omosnace@redhat.com>,
        dhowells@redhat.com, simo@redhat.com,
        Eric Paris <eparis@parisplace.org>,
        Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com,
        nhorman@tuxdriver.com, Dan Walsh <dwalsh@redhat.com>,
        mpatel@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 27, 2020 at 9:23 AM Richard Guy Briggs <rgb@redhat.com> wrote:
>
> Track the parent container of a container to be able to filter and
> report nesting.
>
> Now that we have a way to track and check the parent container of a
> container, modify the contid field format to be able to report that
> nesting using a carrat ("^") modifier to indicate nesting.  The
> original field format was "contid=<contid>" for task-associated records
> and "contid=<contid>[,<contid>[...]]" for network-namespace-associated
> records.  The new field format is
> "contid=<contid>[,^<contid>[...]][,<contid>[...]]".

I feel like this is a case which could really benefit from an example
in the commit description showing multiple levels of nesting, with
some leaf audit container IDs at each level.  This way we have a
canonical example for people who want to understand how to parse the
list and properly sort out the inheritance.


> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  include/linux/audit.h |  1 +
>  kernel/audit.c        | 60 ++++++++++++++++++++++++++++++++++++++++++---------
>  kernel/audit.h        |  2 ++
>  kernel/auditfilter.c  | 17 ++++++++++++++-
>  kernel/auditsc.c      |  2 +-
>  5 files changed, 70 insertions(+), 12 deletions(-)

--
paul moore
www.paul-moore.com
