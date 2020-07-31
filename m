Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD4C1233FB7
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 09:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731523AbgGaHFW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 03:05:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731367AbgGaHFV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 03:05:21 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD44AC061574;
        Fri, 31 Jul 2020 00:05:21 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id kr4so4601885pjb.2;
        Fri, 31 Jul 2020 00:05:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qogj519tDPhVlnDqSFd2ylWvoTNUxXYt6MySeSAH02Y=;
        b=ezV+1aQEE0vLmyIrgfs9Ek7f9T/rdKwJX3gvyxvcHlPhb55VqDcZriBnN0dwMUezvv
         rAPivnjvWGXESDbmG1LVXge38S1Gyb8JnR6EDyZ3ySbyxSDVMAXhx19pp10cuFf8yoso
         smE1Tc6s40ZDl8L3VpsYdkc22N/ngBltadWX5chTgSExJYNzUw7vT7c2JV9CeXrfaPbs
         zyImDtHW002NC5bxRI3bfS7UXYmS1rK+BecEBKe+oTq6FTKeu56a4CJnaTzMPm943ydU
         8gJ2S8yC4L/JWoMYdlDiTnk870FTDVcTKairNMMxAkbqT/5wqbWaIX42xfGnAuoo57Kq
         H6ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qogj519tDPhVlnDqSFd2ylWvoTNUxXYt6MySeSAH02Y=;
        b=ZEOhrQ5tKLAOj+jOYFZqh9ApCrhfk5T4ng1APL4EjEDjpm08d4keNEmbYYFd+nxkoY
         XoiOEYbs4FIgHGuW1S4o5/yXQU2Y1UOo4McdVHUqtbr14PzYsoKGK6Nc06hpfZhI0vKG
         JHB7S5NTt6YtnEaf0cBd55eT4Nlq49mF0z3BAbRZBsGC4q40ZL0foly3yn344vM1jLBa
         LFlcb4osgGXED0w66zB0mPALEisuUbPYufFB2abCOnJL0UEddv3mq4lwkXoszBAgTDT5
         PnYDoRlNiFp//TlrP29IJF6RbdpB6qz9nHaWNMIjEhPhav+2AAs72SvfeY2oEIoJcIoP
         29hQ==
X-Gm-Message-State: AOAM531Yua79+sVgtt7j689Dmo7BCXUv5VmbIDsw5mX/KRxEbYGwCO54
        QcrGYhWboEVgiBIRAXMkEB8FuH0zsnfABsYsYOs=
X-Google-Smtp-Source: ABdhPJw1K163hzWxoBsht0vngIzFQCrYy5PEp+QmbL3aRf0LXPKrg5RaismRTGmWXn2tmXlJSpxv02caa/DIGUcnu+o=
X-Received: by 2002:a62:158e:: with SMTP id 136mr2542352pfv.36.1596179121242;
 Fri, 31 Jul 2020 00:05:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200730192026.110246-1-yepeilin.cs@gmail.com>
 <20200731045301.GI75549@unreal> <20200731053306.GA466103@kroah.com>
 <20200731053333.GB466103@kroah.com> <CAHp75Vdr2HC_ogNhBCxxGut9=Z6pQMFiA0w-268OQv+5unYOTg@mail.gmail.com>
 <20200731070030.GJ75549@unreal>
In-Reply-To: <20200731070030.GJ75549@unreal>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Fri, 31 Jul 2020 10:05:04 +0300
Message-ID: <CAHp75VfZj4L6PJBbWi6wwMF2nucaxGjRLVvi-fTPSWxWvFE0TA@mail.gmail.com>
Subject: Re: [Linux-kernel-mentees] [PATCH net] rds: Prevent kernel-infoleak
 in rds_notify_queue_get()
To:     Leon Romanovsky <leon@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peilin Ye <yepeilin.cs@gmail.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel-mentees@lists.linuxfoundation.org" 
        <linux-kernel-mentees@lists.linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sakari, JFYI. I remember during some reviews we have a discussion
about {0} vs {} and surprisingly they are not an equivalent.

On Fri, Jul 31, 2020 at 10:00 AM Leon Romanovsky <leon@kernel.org> wrote:
> On Fri, Jul 31, 2020 at 09:29:27AM +0300, Andy Shevchenko wrote:
> > On Friday, July 31, 2020, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > wrote:
> > > On Fri, Jul 31, 2020 at 07:33:06AM +0200, Greg Kroah-Hartman wrote:
> > > > On Fri, Jul 31, 2020 at 07:53:01AM +0300, Leon Romanovsky wrote:
> > > > > On Thu, Jul 30, 2020 at 03:20:26PM -0400, Peilin Ye wrote:

...

> > > > > Of course, this is the difference between "{ 0 }" and "{}"
> > > initializations.
> > > >
> > > > Really?  Neither will handle structures with holes in it, try it and
> > > > see.
> >
> >
> > {} is a GCC extension, but I never thought it works differently.
>
> Yes, this is GCC extension and kernel relies on them very heavily.

I guess simple people who contribute to the kernel just haven't
realized (yet) that it's an extension and that's why we have plenty of
{} and {0} in the kernel.

> > > And if true, where in the C spec does it say that?


-- 
With Best Regards,
Andy Shevchenko
