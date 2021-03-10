Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B95B3348C3
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 21:20:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbhCJUUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 15:20:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbhCJUTg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 15:19:36 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04CFEC061574
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 12:19:36 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id mj10so41323906ejb.5
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 12:19:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dcu3RwuJsl+E7XDcfG6oC8CnurlBiVQ4NctbyEthGNg=;
        b=lLzLMMQd7LIjLQvIHpYZuFD60ayUUUlvApO6LSxXAkXWlrpJuanhymzWOXLMUCK4Hc
         X3f9OiLe4dafMvOXCx8DbsmxxHWWK7ORReQHwIv6R123fL6PRVBmliWjBXVNI0A9jAW7
         WRnfq1FEMZ3lVz1nqmqr2ec/NkVPxW9VJ7sThTdVcQdPTCTIx96DhrApTpjDJ86sG3IB
         Ds4ktUrNYhI4HV0eYSgJPO/xOiEW4OIdhKvCPLTivfeCyig2iU4a7RACwdPvg6U0ZaBZ
         53vWoh6ZZ2bTIgZJJTIYc8p7olUhXeKscgiQEVaqw5Kr3f+t7lHtl+XAfl6OfuOjqY13
         3pIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dcu3RwuJsl+E7XDcfG6oC8CnurlBiVQ4NctbyEthGNg=;
        b=twusYnBfQ9Mi2Qt/TjfZnxZaDwolXUXWsV9HsVy1zHQVWYx2i4NxP4i620pPUdtro6
         fiB+KlGTqFQ30hQwfB3I+cJoQ5APtAtJjAUQaeOlHvycdYj/N5bAhvqoShyLYcxywoTp
         0USnqUONn08nlLNyApRI2RlO491wa6I5F8zq3VNqO5y68Vp3XlOIgCOzFM+Hp2+zbBVG
         b9IXLDi4525YN6SLAIiCa+eUo15ejnnXwHfbic0EGzzlmJkod/GHnvgTJi7KUGT+yHfS
         /1qqVMtUMZyzRuKbH/NWDqBH5x6UE9v0BiMiuGHad+8VneAGOavzWpK0YZpr/NaZvT56
         HhLA==
X-Gm-Message-State: AOAM5324h0/eqDpbP4Z+aMUVTEW0xZJAUILVXl9MtAWjKHXG45Fq3h4h
        Dz6acUNyjkQH/bd/ATEno9/FJQWEn7Tw7ws12W9q6w==
X-Google-Smtp-Source: ABdhPJynCkRK09B0YaNmY0zxu1dIM3SSRyxIJLWfi1dROkDnZfwIJLk70cM65m+JaI7qAptXDr3la1nFuO8fECImHbQ=
X-Received: by 2002:a17:906:ef2:: with SMTP id x18mr175824eji.323.1615407574790;
 Wed, 10 Mar 2021 12:19:34 -0800 (PST)
MIME-Version: 1.0
References: <20210210175423.1873-1-mike.ximing.chen@intel.com>
 <20210210175423.1873-15-mike.ximing.chen@intel.com> <YEc/8RxroJzrN3xm@kroah.com>
 <BYAPR11MB3095CCF0E4931A4DB75AB3F7D9919@BYAPR11MB3095.namprd11.prod.outlook.com>
 <YEh/8kGCXx6VIweA@kroah.com>
In-Reply-To: <YEh/8kGCXx6VIweA@kroah.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Wed, 10 Mar 2021 12:19:23 -0800
Message-ID: <CAPcyv4hWbbowf-PfrCtV6ggGR_JPELVGnmmU68syBqnswwOJQA@mail.gmail.com>
Subject: Re: [PATCH v10 14/20] dlb: add start domain ioctl
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     "Chen, Mike Ximing" <mike.ximing.chen@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "pierre-louis.bossart@linux.intel.com" 
        <pierre-louis.bossart@linux.intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 10, 2021 at 12:14 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Wed, Mar 10, 2021 at 02:45:10AM +0000, Chen, Mike Ximing wrote:
> >
> >
> > > -----Original Message-----
> > > From: Greg KH <gregkh@linuxfoundation.org>
> > > On Wed, Feb 10, 2021 at 11:54:17AM -0600, Mike Ximing Chen wrote:
> > > >
> > > > diff --git a/drivers/misc/dlb/dlb_ioctl.c b/drivers/misc/dlb/dlb_ioctl.c
> > > > index 6a311b969643..9b05344f03c8 100644
> > > > --- a/drivers/misc/dlb/dlb_ioctl.c
> > > > +++ b/drivers/misc/dlb/dlb_ioctl.c
> > > > @@ -51,6 +51,7 @@
> > > DLB_DOMAIN_IOCTL_CALLBACK_TEMPLATE(create_ldb_queue)
> > > >  DLB_DOMAIN_IOCTL_CALLBACK_TEMPLATE(create_dir_queue)
> > > >  DLB_DOMAIN_IOCTL_CALLBACK_TEMPLATE(get_ldb_queue_depth)
> > > >  DLB_DOMAIN_IOCTL_CALLBACK_TEMPLATE(get_dir_queue_depth)
> > > > +DLB_DOMAIN_IOCTL_CALLBACK_TEMPLATE(start_domain)
> > > >
> > > > --- a/drivers/misc/dlb/dlb_pf_ops.c
> > > > +++ b/drivers/misc/dlb/dlb_pf_ops.c
> > > > @@ -160,6 +160,14 @@ dlb_pf_create_dir_port(struct dlb_hw *hw, u32 id,
> > > >                                  resp, false, 0);
> > > >  }
> > > >
> > > > +static int
> > > > +dlb_pf_start_domain(struct dlb_hw *hw, u32 id,
> > > > +             struct dlb_start_domain_args *args,
> > > > +             struct dlb_cmd_response *resp)
> > > > +{
> > > > + return dlb_hw_start_domain(hw, id, args, resp, false, 0);
> > > > +}
> > > > +
> > > >  static int dlb_pf_get_num_resources(struct dlb_hw *hw,
> > > >                               struct dlb_get_num_resources_args *args)
> > > >  {
> > > > @@ -232,6 +240,7 @@ struct dlb_device_ops dlb_pf_ops = {
> > > >   .create_dir_queue = dlb_pf_create_dir_queue,
> > > >   .create_ldb_port = dlb_pf_create_ldb_port,
> > > >   .create_dir_port = dlb_pf_create_dir_port,
> > > > + .start_domain = dlb_pf_start_domain,
> > >
> > > Why do you have a "callback" when you only ever call one function?  Why
> > > is that needed at all?
> > >
> > In our next submission, we are going to add virtual function (VF) support. The
> > callbacks for VFs are different from those for PF which is what we support in this
> > submission. We can defer the introduction of  the callback structure to when we
> > add the VF support. But since we have many callback functions, that approach
> > will generate many changes in then "existing" code. We thought that putting
> > the callback structure in place now would make the job of adding VF support easier.
> > Is it OK?
>
> No, do not add additional complexity when it is not needed.  It causes
> much more review work and I and no one else have any idea that
> "something might be coming in the future", so please do not make our
> lives harder.
>
> Make it simple, and work, now.  You can always add additional changes
> later, if it is ever needed.
>

Good points Greg, the internal reviews missed this, let me take
another once over before v11.
