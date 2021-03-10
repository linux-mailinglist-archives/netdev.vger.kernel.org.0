Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29B3B3348AD
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 21:11:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbhCJUK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 15:10:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbhCJUKg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 15:10:36 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55F07C061574
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 12:10:36 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id e19so41338335ejt.3
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 12:10:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hTbCJHtwtuolz+tOq3o62RiWHGJjrBuIZnsgWAGcF8A=;
        b=nmOdArVArmZulQ2idWnG/l9dcCTGNPeLoj9kZ/aLB6RP2cQNRQNqB4a15QyoVNIh9Q
         4TXDFHXkhf6M8TzzcS49E8KBFVS9FSxGg+ESwUaYHGXNHMqxmH9jMdUtZsLdO2ztLQ08
         yHgDEeJLmJpAfBq9Pih0yzBvCOvOH/H6woTNFmCxaaeLj89gLi30bJrEwAYeFJNXUuc1
         SzpCar8Dpd+nXETu+rvkJd8FJlrJQL8QB70LEx8jXBckWOTgVXt/mtZt8H/m3tKyZ6mV
         xYjfyP9Vxl/qDIwvyn6axBigNozmleVkVSAgyf2cGHkx2jJsavW0VXeoov3A8adBoF32
         2qGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hTbCJHtwtuolz+tOq3o62RiWHGJjrBuIZnsgWAGcF8A=;
        b=MOuqAyLYpEOtanKGilaJm5GpZDAE4m9KVGYxyNg3aniUkLu6GGqIbOK7601yJwG7Sy
         fAimvvIyXIcIjqJa+10hHvrgXEWQWl/B9awLm6aenrJFAzBlO4kTelf+3LkPSKuRHlAY
         M9F2ljQbXQu2iTDv/ERTwSOvhrGBERyUh+aIqu8HTX51wKIggzcHL4y88sf5S610XH1E
         L7oliLgdNa2UYrSeP69VW93JzfR95okwVegBlF/v/hbvhPPOAaDEQxytGfVOYq4wpz+p
         a9o7zncVjHCC1VUkAzEKvPG9IrtH8/yS8bHsBEJQ6dfF1VUmqXzjiqsdwmByVNUj9FJo
         sPvg==
X-Gm-Message-State: AOAM532QJeTQxXBT0yanb0kC6u5lSk4Piae9ZfZCkshXDGl+NI5YQQRn
        Q7xgA30w79/Eo3knzXSyFipMJfmzFgrz/CJqGiqJMw==
X-Google-Smtp-Source: ABdhPJyNJJUC5nAbkdRGmuN4zGKXMP/Hv9SfaNPgYNPLCxBPN/K1OnZi3Txh2La3o7pFxsPgj8GyP8wOeRi0Y2gXFcA=
X-Received: by 2002:a17:906:1bf2:: with SMTP id t18mr166546ejg.418.1615407035090;
 Wed, 10 Mar 2021 12:10:35 -0800 (PST)
MIME-Version: 1.0
References: <20210127225641.1342-1-mike.ximing.chen@intel.com>
 <20210127225641.1342-2-mike.ximing.chen@intel.com> <YCKP5ZUL1/wMzmf4@kroah.com>
 <CAPcyv4hC2dJGAXbG2ogO=2THuDUHjgYekkNy4K_zwEmQcXLcjA@mail.gmail.com>
 <BYAPR11MB3095C54BA878D8A5502CA891D9939@BYAPR11MB3095.namprd11.prod.outlook.com>
 <YEaFbyUM0Fu763vm@kroah.com> <BYAPR11MB3095534A3B62757F5AD63063D9929@BYAPR11MB3095.namprd11.prod.outlook.com>
In-Reply-To: <BYAPR11MB3095534A3B62757F5AD63063D9929@BYAPR11MB3095.namprd11.prod.outlook.com>
From:   Dan Williams <dan.j.williams@intel.com>
Date:   Wed, 10 Mar 2021 12:10:23 -0800
Message-ID: <CAPcyv4jHV1fF+P3H6qiK3JGRZ1k+=QSymt1ZFg1RN4wAcEoUqg@mail.gmail.com>
Subject: Re: [PATCH v10 01/20] dlb: add skeleton for DLB driver
To:     "Chen, Mike Ximing" <mike.ximing.chen@intel.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "Laatz, Kevin" <kevin.laatz@intel.com>,
        "maximmi@mellanox.com" <maximmi@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 8, 2021 at 8:53 PM Chen, Mike Ximing
<mike.ximing.chen@intel.com> wrote:
>
>
> > -----Original Message-----
> > From: Greg KH <gregkh@linuxfoundation.org>
> > On Mon, Mar 08, 2021 at 08:00:00PM +0000, Chen, Mike Ximing wrote:
> > >
> > > Hi Greg,
> > >
> > > While waiting for the feedback from the networking maintainers, I am
> > > wondering if you have any other comments/suggestions that I  should address
> > > in parallel.
> >
> > It's in my "to-review" queue, which is huge at the moment.  But the
> > networking developers review will determine how this should go forward,
> > so I'll just wait for them to get to it.
> >
>
> I see the status of the submission (to netdev)  is now marked as "Not Applicable"
> at netdev's patchwork site
> https://patchwork.kernel.org/project/netdevbpf/list/?series=&submitter=197673&state=*&q=&archive=both&delegate=
>
> Looks like that the patch set is considered as not being networking related. (?)

That's just to clean up their queue of things that need to be pulled
into the net tree. This driver is being requested to just be acked-by
netdev before Greg considers it for drivers/misc/.
