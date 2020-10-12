Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E74CD28ABFB
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 04:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728446AbgJLCKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 22:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729701AbgJLCJZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 22:09:25 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 428E0C0613D5
        for <netdev@vger.kernel.org>; Sun, 11 Oct 2020 19:09:24 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id t25so20951311ejd.13
        for <netdev@vger.kernel.org>; Sun, 11 Oct 2020 19:09:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AK2bWzHz5KjOV6B+R5X2SLhKXSVJscVhCITZfEKF1hY=;
        b=uFrh1lzryALn96VPKRBduZb3Uw2dS7GwoDmDor/yq4sltdj4FZMEe0Kz7zWWYkgsvZ
         Bhk0XJiKrLAD9vM9R6Rp6oGNiAmOEBkfW2FHbS9htw4ttGMgoNiPjHbV82SaJQOh72n1
         KOn0XHZV3yhQ5ML83+/WRHEK5fGEH2My0vKHk0vWBZcvp/We8Mi77DTEs0R36Uy8AS/q
         j6qvKFbzpZ0Q5slqBpraYrzgMnWaci+4n4rLKl+4qMGdM1msS0I9pJxg6ZHb7zpBNGAx
         fFoUIMSVQeSle6ceuXri4Gebr/dVtNHjJ5L0A+m6O9ky0R0lJJWu82TvgfOsprzdtiDv
         1FRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AK2bWzHz5KjOV6B+R5X2SLhKXSVJscVhCITZfEKF1hY=;
        b=jGNgasH1YSb24gGrQbDjGU1/xFYY08lSup+Azv+Py217VB3dv2nPRJzyCNd8LXnjik
         l6HJB2/a1ldXztKfATHgJKY1ODrUypllYg1vucuqSb9xaj/Rxz4lRyqz3QzicorPLTab
         vpD8pjX+D7rVVuvuCmuP1sTn/2R/IZeXbCClxM04qTRo+uSWdFrwzF9UXqe1onXmgaZO
         V0UMFOdXSFYaBRCaxrJ2PzRFdK0s/Q8Cbsnjcm3XpWARRisPcXFBM4fQmebi6UlvHC1g
         IfnvRXVEqmopSoEVUctqFWSTLgFln4wVlAPfEVwcto0u6/NWYrYWnqoQXOor1++dt+mE
         X1Qw==
X-Gm-Message-State: AOAM532WTTznKaLNjZ/WiqMYDKTzIuYHwEFXQ6xJubkY6HtCDRyxuITy
        tWnWltEbgFNfo5IorraJ63r9dONF0ZTMoZa31YeLJuLfVA==
X-Google-Smtp-Source: ABdhPJxvp+jOMwz02L056HcUjWpx3NzOVbT79WBzEmzyJsbpZ9wPiEuXnLr6OVSinkWqQieYV8eSaJPP3ELMwP9kJIg=
X-Received: by 2002:a17:906:ce5a:: with SMTP id se26mr25334590ejb.106.1602468562791;
 Sun, 11 Oct 2020 19:09:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200930094934.32144-1-richard_c_haines@btinternet.com>
 <20200930094934.32144-4-richard_c_haines@btinternet.com> <20200930110153.GT3871@nataraja>
 <33cf57c9599842247c45c92aa22468ec89f7ba64.camel@btinternet.com> <20200930133847.GD238904@nataraja>
In-Reply-To: <20200930133847.GD238904@nataraja>
From:   Paul Moore <paul@paul-moore.com>
Date:   Sun, 11 Oct 2020 22:09:11 -0400
Message-ID: <CAHC9VhT5HahBhow0RzWHs1yAh5qQw2dZ-3vgJv5GuyFWrXau1A@mail.gmail.com>
Subject: Re: [PATCH 3/3] selinux: Add SELinux GTP support
To:     Harald Welte <laforge@gnumonks.org>, pablo@netfilter.org,
        Richard Haines <richard_c_haines@btinternet.com>
Cc:     selinux@vger.kernel.org, linux-security-module@vger.kernel.org,
        osmocom-net-gprs@lists.osmocom.org, netdev@vger.kernel.org,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        James Morris <jmorris@namei.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 30, 2020 at 9:39 AM Harald Welte <laforge@gnumonks.org> wrote:
> Hi Richard,
>
> On Wed, Sep 30, 2020 at 01:25:27PM +0100, Richard Haines wrote:
>
> > As in the reply to Pablo, I did it for no particular reason other than
> > idle curiosity, and given the attempted move to Open 5G I thought
> > adding MAC support might be useful somewhere along the line.
>
> ...
>
> I think it would not be the best idea to merge SELinux support patches for the
> GTP kernel driver without thoroughly understanding the use case, and/or having
> some actual userspace implementations that make use of them.  In the end, we may
> be introducing code that nobody uses, and which only turns out to be insufficient
> for what later actual users may want.
>
> So like Pablo suggested, it would probably be best to focus on
> submitting / merging features for things that are either well-defined (e.g.
> specified in a standerd), and/or have existing userspace implementations.

Having a solid use case or two is also helpful for those of us who
don't have a GTP/GPRS background.  I did spend some time reading a few
things on GTP, but I don't feel like I've made much of a dent on
understanding how it is actually used.

Harald, Pablo - I know you both suggested taking a slow iterative
approach to merging functionality, perhaps you could also help those
of us on the SELinux side better understand some of the common GTP use
cases?

-- 
paul moore
www.paul-moore.com
