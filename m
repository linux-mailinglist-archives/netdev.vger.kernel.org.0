Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB3B6367BCF
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 10:12:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235317AbhDVIMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 04:12:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235305AbhDVIMG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 04:12:06 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D6C4C06174A;
        Thu, 22 Apr 2021 01:11:30 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id k73so44078562ybf.3;
        Thu, 22 Apr 2021 01:11:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZrVYM7lQBGs3R7hQ2ZGY213TaJIwxgrLXRygZ4v+z0U=;
        b=jIR23OjUT14MSwjYVPMTJWiptWi9XvyJBdUyblk4rG7zoX/mEXLyVdEk6QRBAjVt7q
         7pFy4Wbzv6SaQ5L31jtxjzokgFWNiVfBgpGNy6Nb49s7YYIYqqvwPOEI8pGMurM+8nQG
         zAyC6MkzVYqN3hm2UaPZCG9afppKHw5C7hin9S+QJAwYepvxy66KYjJ8qHSmqH7pg/cY
         mXiFhI4dyNbzkeinDAItaiZvUMktVsESDDpqZqFdkeV5bP8iOmjmwF1h9umQCHG6mx9z
         tnuWnKnl3BVzD5qS0pRa1+lenIXo49pvYvp/BquikGJvnS+8wzhF9DU4bMDbQ5229JC7
         Mafw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZrVYM7lQBGs3R7hQ2ZGY213TaJIwxgrLXRygZ4v+z0U=;
        b=VN642rTv3VQLhrGg1H/yCrNKJsyQxuCJ0Gse1KT9Q7Uff7oQQDMB3mbe2iKlWqqwCq
         0DEzUoySpy9CRRsJYfVNL47pFF4m6doQSi67bixCDSnF5qOe8sS9W785q6IDU480GWX+
         BY653/Hp24NTvw/DMq8i8ywbL5mKX+UUAYjIqOLQz7XVnoK2f2uij1fm7L718X7RBDz6
         TA6ui/OmilL9eOtVWk0h2eEHN/17DEgIBN15zkUWHILUDCaR3SeAkXjNllF2skWlS7v7
         YuT4Y4q52Z6n6NOzfem2SD22KkKzv42B3eIAWJGBFVbN2IL3klKsIUzae0RJ/Ut+GdOf
         TPgw==
X-Gm-Message-State: AOAM532Za4n8jLHPncrW0Fhlm1Re7tBtfQzaAwItgmTK92Jk/fvsco7P
        VOM8NyxubpUR3sNSwDKpmW2VR75hwEbz+dhI3LA=
X-Google-Smtp-Source: ABdhPJz5X/E6nFJxcNntdBxPY0DTX1/xz+1VZ+whImx63TD2+eoYZPRzh6/pirV/Levh3n0MNLI1UWoyRJsMshXKZfA=
X-Received: by 2002:a25:d195:: with SMTP id i143mr3118696ybg.331.1619079089583;
 Thu, 22 Apr 2021 01:11:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210407001658.2208535-1-pakki001@umn.edu> <YH5/i7OvsjSmqADv@kroah.com>
 <20210420171008.GB4017@fieldses.org> <YH+zwQgBBGUJdiVK@unreal>
 <YH+7ZydHv4+Y1hlx@kroah.com> <CADVatmNgU7t-Co84tSS6VW=3NcPu=17qyVyEEtVMVR_g51Ma6Q@mail.gmail.com>
 <YH/8jcoC1ffuksrf@kroah.com>
In-Reply-To: <YH/8jcoC1ffuksrf@kroah.com>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Thu, 22 Apr 2021 09:10:53 +0100
Message-ID: <CADVatmORofURmrLiV7GRW2ZchzL6zdQopwxAh2YSVT0y69KuHA@mail.gmail.com>
Subject: Re: [PATCH] SUNRPC: Add a check for gss_release_msg
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Aditya Pakki <pakki001@umn.edu>,
        Chuck Lever <chuck.lever@oracle.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dave Wysochanski <dwysocha@redhat.com>,
        linux-nfs@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Greg,

On Wed, Apr 21, 2021 at 11:21 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Wed, Apr 21, 2021 at 11:07:11AM +0100, Sudip Mukherjee wrote:
> > Hi Greg,
> >
> > On Wed, Apr 21, 2021 at 6:44 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> > >
> > > On Wed, Apr 21, 2021 at 08:10:25AM +0300, Leon Romanovsky wrote:
> > > > On Tue, Apr 20, 2021 at 01:10:08PM -0400, J. Bruce Fields wrote:
> > > > > On Tue, Apr 20, 2021 at 09:15:23AM +0200, Greg KH wrote:
> > > > > > If you look at the code, this is impossible to have happen.
> > > > > >
> >
> > <snip>
> >
> > > > They introduce kernel bugs on purpose. Yesterday, I took a look on 4
> > > > accepted patches from Aditya and 3 of them added various severity security
> > > > "holes".
> > >
> > > All contributions by this group of people need to be reverted, if they
> > > have not been done so already, as what they are doing is intentional
> > > malicious behavior and is not acceptable and totally unethical.  I'll
> > > look at it after lunch unless someone else wants to do it...
> >
> > A lot of these have already reached the stable trees. I can send you
> > revert patches for stable by the end of today (if your scripts have
> > not already done it).
>
> Yes, if you have a list of these that are already in the stable trees,
> that would be great to have revert patches, it would save me the extra
> effort these mess is causing us to have to do...

The patch series for all the stable branches should be with you now.

But for others:
https://lore.kernel.org/stable/YIEVGXEoeizx6O1p@debian/  for v5.11.y
and other branches are sent as a reply to that mail.


-- 
Regards
Sudip
