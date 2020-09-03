Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE35725C7F6
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 19:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbgICRSw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 13:18:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726327AbgICRSv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 13:18:51 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 480ABC061244;
        Thu,  3 Sep 2020 10:18:51 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id 19so1010926qtp.1;
        Thu, 03 Sep 2020 10:18:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OC6IAwyfPw1L9yvFikovbkI6XXtokUDw7EIRshZgX6c=;
        b=aVZHk5TSTqqpGJDhQdYLjQcBa2e4NXVNattZqnz2SvzWlJHD03ZT7cI/Bo+wdxP+pI
         zRFyajZG1A5NBk5SLtcKdCtaFyJ1msmXwP2VWZHYbB1hG7ucaaW1NCz4oHgz0D/Q2aUD
         7iggJkiZicLtBTzwxhNywDJpUaupTt5yWeXtjD7+jYo6uIJq37Mg6lGst0TExHUY9EUN
         8i7SkA8bVkJL9H2Rc5NtM7D2IpFJ4ZN1OPre5g7oBpWPgvKsOO9uL9DwvCbcm8GsgNod
         XuCowO6b+kU7iPuaX3ykvNzg6Xd+VLbskLkRkhigCkkRIEaVtOriWlHGgIW+eDD3SqhF
         6ZkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OC6IAwyfPw1L9yvFikovbkI6XXtokUDw7EIRshZgX6c=;
        b=tNyEvTT4MTPQE5i1EIDvPg/owgVATGICPLgqniQ9dQUOz0ZgUs9j5IQtSJSORsnsre
         vhQ8+del7U9YgYhfpvqiyXcHxeose1usZJiLWXLY0YC66n+6VlKMoiEQBmMiMuUyn2mM
         LpIaNshBc8+8PCOU5ZtK1tR7CdnfGIswFGTNrD8/U5pkHpo7UZgycAwno0/WZE8XnrO9
         Bto80Nh1+UoC8A0iyUDnX320YFUAS/aYlVeeRacewoTjY9o6P4eyTjIAz910uCJ5y94D
         mZ8OSHMw171QrQFSSJLdETzJDBrmnwxJ9NCW2DLPDfal63TDqaj4sEGmQVIKbBOycQXc
         Bcyg==
X-Gm-Message-State: AOAM533Tjw4heLgm6bgE/3fG3pgpKUI6JOAHAHgvsH3hkTfQaX2BrJjM
        CWu8qg4+I6hh8YZ1IXOVFxI=
X-Google-Smtp-Source: ABdhPJzGDvwiwRO3GDSmewCA9oibFMfRestqjYGRIvw/pH2aqqzdwZH4mdsFPmKWYreMPkKadfWC6A==
X-Received: by 2002:ac8:fb3:: with SMTP id b48mr4706359qtk.16.1599153530393;
        Thu, 03 Sep 2020 10:18:50 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f016:5ccb:a3f8:9d8c:beb:7674])
        by smtp.gmail.com with ESMTPSA id j31sm2545455qta.6.2020.09.03.10.18.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2020 10:18:49 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 61780C5F36; Thu,  3 Sep 2020 14:18:47 -0300 (-03)
Date:   Thu, 3 Sep 2020 14:18:47 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Petr Malat <oss@malat.biz>
Cc:     linux-sctp@vger.kernel.org, vyasevich@gmail.com,
        nhorman@tuxdriver.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] sctp: Honour SCTP_PARTIAL_DELIVERY_POINT even under
 memory pressure
Message-ID: <20200903171847.GD2444@localhost.localdomain>
References: <20200901090007.31061-1-oss@malat.biz>
 <20200902145835.GC2444@localhost.localdomain>
 <20200903112147.GA17627@bordel.klfree.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200903112147.GA17627@bordel.klfree.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

On Thu, Sep 03, 2020 at 01:21:48PM +0200, Petr Malat wrote:
> Hi!
> On Wed, Sep 02, 2020 at 11:58:35AM -0300, Marcelo Ricardo Leitner wrote:
> > On Tue, Sep 01, 2020 at 11:00:07AM +0200, Petr Malat wrote:
> > > Command SCTP_CMD_PART_DELIVER issued under memory pressure calls
> > > sctp_ulpq_partial_delivery(), which tries to fetch and partially deliver
> > > the first message it finds without checking if the message is longer than
> > > SCTP_PARTIAL_DELIVERY_POINT. According to the RFC 6458 paragraph 8.1.21.
> > > such a behavior is invalid. Fix it by returning the first message only if
> > > its part currently available is longer than SCTP_PARTIAL_DELIVERY_POINT.
> > 
> > Okay but AFAICT this patch then violates the basic idea behind partial
> > delivery. It will cause such small message to just not be delivered
> > anymore, and keep using the receive buffer which it is trying to free
> > some bits at this moment.
> By default the pd_point is set to 0, so there will not be a change in the
> behavior, but if the user changes it to some other value, it should be
> respected by the stack - for example when the largest message the user
> exchanges is 1kB and the user sets it to 1kB, his application is not
> prepared to handle fragmented messages at all and it's not a good idea to
> pass such a message to the app.

Then, if it doesn't support fragmented messages at all, the app just
shouldn't be setting pd_point at all. :-) Anyhow, I see how the patch
works now.

The fix is also needed on sctp_intl_retrieve_first() and
sctp_intl_retrieve_first_uo(). Same issue is in there, but for stream
interleaving.

Thanks.
