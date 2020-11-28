Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0879C2C6E83
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 03:35:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731171AbgK1CdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 21:33:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731071AbgK1CcE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 21:32:04 -0500
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7F4AC0613D1
        for <netdev@vger.kernel.org>; Fri, 27 Nov 2020 18:31:48 -0800 (PST)
Received: by mail-qt1-x841.google.com with SMTP id z3so4479839qtw.9
        for <netdev@vger.kernel.org>; Fri, 27 Nov 2020 18:31:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Dv9zFDwZVQyaPsnjaL6YNrutmg6TYHGHl/mwwJD6W3g=;
        b=A8Ghl5AiHc7afg+fWd5rCCc1bv7VckTKjZeihvfBW4W3ACaEpPVzy+AqsmogeHZ5Bg
         gfS25r5BM+qfCMsMEHKIeqk2C6kJ9RROzj4MfHHdtRmHLsGBrV6OIWc09HJrbamNXmuW
         rcgXMj0h6wcF8rRbw8S+63sZQFi+9xUEZBPZvzDvuyvnz6j3jZ568Gvhgr0Ae0K7TDv9
         VdTcjSvsL0yNJZPaPKmpPLmkjDqGHmE8A6q2zPOvzGQVIVOkL7jLzeaHDXf8R8PKiEKS
         la5/awHX1wiV4qLCDAXjsWEhm7Sbndn3eRyG2o3c0vz4RTCbDUuptN1sq9O+jaWM2cgV
         puBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Dv9zFDwZVQyaPsnjaL6YNrutmg6TYHGHl/mwwJD6W3g=;
        b=jwwysa8EBcStUUH1RnaVKtns/WbFMvABWbULxtfqY9jLpu7AmetPCqddOIQH2euAHZ
         UTE0jg0YvwtVuwaC/btjZbZhF2+g6p1CGmDfHTS2Fe6tM2TGVkP0QXq7CGydEVUggvWV
         uH/cbGUpsyCej9UaioL1P07hVqk2emKcP1qRA+vWilzS9PlUvLqJHj6mSq0Mgdv3LXaI
         FRiSJ6JXXcGXbTfu5/IGuRn8D+eCie0CPKfZuY07ROBJeKVvHA96D0/aDaMHnB+Tszh/
         CxR6QhEhbWTxAtqIgIrm8iV1YH/rK60yy3JzfZvcCCk3QQaX8a3hTMNkNrZs86aSpEVK
         Sx0Q==
X-Gm-Message-State: AOAM530j4VirT7kSM4FlhCoZolvCKwgEHzxht0+1v6jc1WFi61nNM2LK
        tfjdRhKYUpM1lJggBwazRXA=
X-Google-Smtp-Source: ABdhPJzqc+aYQbIZoG/vEWwFUQg7OnledVi1v7R/FoL3LKk8C4nMsaAe6yks4P+fcaUHSLspmNXjdQ==
X-Received: by 2002:aed:31c5:: with SMTP id 63mr11184332qth.84.1606530707382;
        Fri, 27 Nov 2020 18:31:47 -0800 (PST)
Received: from localhost.localdomain ([177.220.172.93])
        by smtp.gmail.com with ESMTPSA id h125sm7877652qkc.36.2020.11.27.18.31.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2020 18:31:46 -0800 (PST)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 1DB29C3B6C; Fri, 27 Nov 2020 23:31:44 -0300 (-03)
Date:   Fri, 27 Nov 2020 23:31:44 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, wenxu@ucloud.cn, paulb@nvidia.com,
        ozsh@nvidia.com, ahleihel@nvidia.com,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net-next] net/sched: act_ct: enable stats for HW
 offloaded entries
Message-ID: <20201128023144.GC449907@localhost.localdomain>
References: <481a65741261fd81b0a0813e698af163477467ec.1606415787.git.marcelo.leitner@gmail.com>
 <20201127180032.52b320a5@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201127180032.52b320a5@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 27, 2020 at 06:00:32PM -0800, Jakub Kicinski wrote:
> On Thu, 26 Nov 2020 15:40:49 -0300 Marcelo Ricardo Leitner wrote:
> > By setting NF_FLOWTABLE_COUNTER. Otherwise, the updates added by
> > commit ef803b3cf96a ("netfilter: flowtable: add counter support in HW
> > offload") are not effective when using act_ct.
> > 
> > While at it, now that we have the flag set, protect the call to
> > nf_ct_acct_update() by commit beb97d3a3192 ("net/sched: act_ct: update
> > nf_conn_acct for act_ct SW offload in flowtable") with the check on
> > NF_FLOWTABLE_COUNTER, as also done on other places.
> > 
> > Note that this shouldn't impact performance as these stats are only
> > enabled when net.netfilter.nf_conntrack_acct is enabled.
> > 
> > Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> 
> Why no Fixes tag and not targeting net here?

Well, I don't know if it was left out on purpose or not/missed.
What I know is that act_ct initially had no support for stats of
offloaded entries. ef803b3cf96a wasn't specific to act_ct (and didn't
have to update it), while some support on act_ct was introduced with
beb97d3a3192, but only for sw offload. So it seems to me that it's
just a new piece(/incremental development) that nobody had cared so
far.

If you see it otherwise, I'm happy to change. I'll just need a hint on
which commit I should use for the Fixes tag (as it's not clear to me,
per above).
