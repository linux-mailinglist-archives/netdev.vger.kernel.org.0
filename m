Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87EB92B8C38
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 08:23:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726314AbgKSHWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 02:22:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726107AbgKSHWf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 02:22:35 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 511D5C0613CF;
        Wed, 18 Nov 2020 23:22:35 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id t8so3591602pfg.8;
        Wed, 18 Nov 2020 23:22:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1RR09oXTHNj5D+VKWnXusC3Un6VRBPlQtmYv6ZSUsVI=;
        b=SykaFT23R/hVbaREPLzvW2AP15wUqLT+sWT6x4PeBzYCErRpZXTA1blPK8ZCNOSxv9
         z/GwsF9uEXlQR2OLiRYvAzouSE8DSpnE24YnQkxJFQONJa7luOgYcXwZfdJkrPRxT0Gu
         kAX5lmyGFh/3df3LBvVhI0+6/LIPvbIGmYYzvt4o3biOa5rKpVjRcdwg7aaiduza9Zn3
         MWwUrm3AVbMFTJQ+S/Gqgn/bvoan5rIB3N8hHg5cEdFqJck0lIQdUHrcn9fM33vEMfKj
         oyTr57Bz8FN2o1sYa+eyj3Rv2XZ7eh5TCuPjJRLUHeX+M+SCVAu8CDYTYdIZOvwfUr0P
         UfFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1RR09oXTHNj5D+VKWnXusC3Un6VRBPlQtmYv6ZSUsVI=;
        b=Z6+1QJDmvtgTvkwfz3hdv7wIIKH9ec2a+LAFH4/zMADv8giAnJ6KGHvzcMmz2x8tAU
         wTiQSZqcs9CTft6po5WIiwOPv/US8nHl4wa97c1W7YqUf/39rh8EwCQzkZ2Tii4lLtAt
         iAIqnF6kvepN/TcueR9RQl8kg9eLETOUGNHNDD9Yg+/e8tSyvTu6QkizzX2+RDEjFcGX
         /D/6Gcaslz1go0gL49MnWViUzUh+blWmv5a8MjH20oAp3rKuXsj6RG9wZon8sqGmhzRc
         1ZvfDAXKmFaEcJpJL+AgJodCF6I/RAFnAXnUsDEqb3E/Tdo7RB0INcOcI0YjPRJGOZk3
         O67Q==
X-Gm-Message-State: AOAM5308NFDH5ua9OWuRC5WCJZJNFKArwV5ltmyusUOWNZI/i1K6bnwp
        C1Cby87MbBMPCPpWn7NtJaw=
X-Google-Smtp-Source: ABdhPJwSM7bcPvfkrjRN4rBPjOShGGjdnAqFCLalTUBjlOLyt6Pi2bllffDYwvcM9ExJ8zAEz39WSQ==
X-Received: by 2002:a17:90a:8d03:: with SMTP id c3mr3172717pjo.100.1605770554821;
        Wed, 18 Nov 2020 23:22:34 -0800 (PST)
Received: from taoren-ubuntu-R90MNF91 (c-73-252-146-110.hsd1.ca.comcast.net. [73.252.146.110])
        by smtp.gmail.com with ESMTPSA id v191sm27585931pfc.19.2020.11.18.23.22.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 18 Nov 2020 23:22:34 -0800 (PST)
Date:   Wed, 18 Nov 2020 23:22:26 -0800
From:   Tao Ren <rentao.bupt@gmail.com>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Andrew Lunn <andrew@lunn.ch>, Jean Delvare <jdelvare@suse.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-hwmon@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, openbmc@lists.ozlabs.org, taoren@fb.com,
        mikechoi@fb.com
Subject: Re: [PATCH v2 0/2] hwmon: (max127) Add Maxim MAX127 hardware
 monitoring
Message-ID: <20201119072225.GA19877@taoren-ubuntu-R90MNF91>
References: <20201118230929.18147-1-rentao.bupt@gmail.com>
 <20201118232719.GI1853236@lunn.ch>
 <20201118234252.GA18681@taoren-ubuntu-R90MNF91>
 <20201119010119.GA248686@roeck-us.net>
 <20201119012653.GA249502@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201119012653.GA249502@roeck-us.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 18, 2020 at 05:26:53PM -0800, Guenter Roeck wrote:
> On Wed, Nov 18, 2020 at 05:01:19PM -0800, Guenter Roeck wrote:
> > On Wed, Nov 18, 2020 at 03:42:53PM -0800, Tao Ren wrote:
> > > On Thu, Nov 19, 2020 at 12:27:19AM +0100, Andrew Lunn wrote:
> > > > On Wed, Nov 18, 2020 at 03:09:27PM -0800, rentao.bupt@gmail.com wrote:
> > > > > From: Tao Ren <rentao.bupt@gmail.com>
> > > > > 
> > > > > The patch series adds hardware monitoring driver for the Maxim MAX127
> > > > > chip.
> > > > 
> > > > Hi Tao
> > > > 
> > > > Why are using sending a hwmon driver to the networking mailing list?
> > > > 
> > > >     Andrew
> > > 
> > > Hi Andrew,
> > > 
> > > I added netdev because the mailing list is included in "get_maintainer.pl
> > > Documentation/hwmon/index.rst" output. Is it the right command to find
> > > reviewers? Could you please suggest? Thank you.
> > 
> > I have no idea why running get_maintainer.pl on
> > Documentation/hwmon/index.rst returns such a large list of mailing
> > lists and people. For some reason it includes everyone in the XDP
> > maintainer list. If anyone has an idea how that happens, please
> > let me know - we'll want to get this fixed to avoid the same problem
> > in the future.
> > 
> 
> I found it. The XDP maintainer entry has:
> 
> K:    xdp
> 
> This matches Documentation/hwmon/index.rst.
> 
> $ grep xdp Documentation/hwmon/index.rst
>    xdpe12284
> 
> It seems to me that a context match such as "xdp" in MAINTAINERS isn't
> really appropriate. "xdp" matches a total of 348 files in the kernel.
> The large majority of those is not XDP related. The maintainers
> of XDP (and all the listed mailing lists) should not be surprised
> to get a large number of odd review requests if they want to review
> every single patch on files which include the term "xdp".
> 
> Guenter

Thanks Guenter and Andrew. Given xdp maintainers were included by
mistake, I will remove them from the future discussions of this hwmon
patch series.


Cheers,

Tao
