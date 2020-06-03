Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9205C1ECDAB
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 12:37:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725934AbgFCKhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 06:37:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbgFCKhD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 06:37:03 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9939FC08C5C0;
        Wed,  3 Jun 2020 03:37:03 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id b5so1333720pfp.9;
        Wed, 03 Jun 2020 03:37:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nVD95UqH77JMAWDNsd0PmgMJkNd8f0kxry6BDs2oz4E=;
        b=G8yRAz6Anu24jKjhLCcyWcAHoXa7Kb8tJkH2E8wuENj9S4jdN33ltae2Ok5J23MxIK
         8t3+fqbsYr8IX6hDoSB+EaDz/ZhEKTG5zczojKocgAi+ufJyUAM6ffey9/zWT/KvVLiz
         nrEwj+gziOtYhgdzeGbUHJ21cc0gdfHQuvdAAO/wlgMAj3jpSBKjbvDLJNl6/rTlfrzC
         qPhSrY3Jus3HsVn2mpyGPWXJHNmpDODN4nIb4FD9hSNjkViAGVYHe7Q7UmKw4ggJHQXL
         gIPZHExMy6HA3HVx5D7XlB87JCjW33QhsWJ6c23zitUsfGWd17/ZtyFImtqWHOjIrPG3
         SQAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nVD95UqH77JMAWDNsd0PmgMJkNd8f0kxry6BDs2oz4E=;
        b=pkeqjSN/pLJnINcZdbQIBjAo0zeMmHOFoQhrlY4sA/XQqlEYnUxQWP1j8tJ02MgS4H
         WmTz1xdHBMvDct89Zo0b99nOAvKrx3QAWzWrC6W9eYgTJCeOU0pgk1KfAtPBKxrtu0HG
         fOvI/xi04nnJwrKx34g7sThlGVey7jBi5Wswp105aDziOq1pz1iAlsjnEOur9MLR4bDN
         O0D9tAR65lBwPjNsbq/vW+zfvpeslsQshI9wM2VuqE9qtD94dOMOB2kaGKkDbY8JoYk9
         AI0Xq3Q0/aTlV3aTYoz5hReqG5A8jdX9h6t6YuoJumj1vHJro8MdIuVclxIMOcLz4aXI
         7BKA==
X-Gm-Message-State: AOAM5306tA6CMR7l/4tNx/y2ukcgtYdpOMY4Zbb19fEcb/HmzEbUk9k1
        APHiO6Vibe8YJLglynS2IgWSrF7BhIExpbPk5hk=
X-Google-Smtp-Source: ABdhPJxVeySC5xkIJDLVVD1Z0A6TnKDtg3SyLYNUw2j09vjKGAyAlKEQckD0tHeWTW/G9Ebbr/Mz/kUCRa/5d2lrhmU=
X-Received: by 2002:a17:90a:1704:: with SMTP id z4mr4865792pjd.181.1591180623108;
 Wed, 03 Jun 2020 03:37:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200602092118.32283-1-piotr.stankiewicz@intel.com>
 <CAHp75VfEcm-Mmo7=i40sJ0RqpOgFRpJHxQ9ePWvvqsyRp+=9GA@mail.gmail.com> <CY4PR11MB15287ACFF4C55F84D43433E9F9880@CY4PR11MB1528.namprd11.prod.outlook.com>
In-Reply-To: <CY4PR11MB15287ACFF4C55F84D43433E9F9880@CY4PR11MB1528.namprd11.prod.outlook.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Wed, 3 Jun 2020 13:36:51 +0300
Message-ID: <CAHp75Vd7k--sDBXOBNPkBhC1fAOL25D3Q9N=tesi0mLxzXRA0A@mail.gmail.com>
Subject: Re: [PATCH 14/15] net: hns3: use PCI_IRQ_MSI_TYPES where appropriate
To:     "Stankiewicz, Piotr" <piotr.stankiewicz@intel.com>
Cc:     Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 3, 2020 at 11:50 AM Stankiewicz, Piotr
<piotr.stankiewicz@intel.com> wrote:
> > -----Original Message-----
> > From: Andy Shevchenko <andy.shevchenko@gmail.com>
> > Sent: Tuesday, June 2, 2020 5:39 PM
> > On Tue, Jun 2, 2020 at 12:26 PM Piotr Stankiewicz
> > <piotr.stankiewicz@intel.com> wrote:

...

> > >                                                 hdev->num_msi,
> > > -                                               PCI_IRQ_MSI | PCI_IRQ_MSIX);
> > > +                                               PCI_IRQ_MSI_TYPES);
> >
> > One line as above?
> >
>
> It would push the line above 80 characters.

It's now relaxed limit, but if it is only few characters, I wouldn't care.

-- 
With Best Regards,
Andy Shevchenko
