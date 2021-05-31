Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B151F3966BD
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 19:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231722AbhEaRTz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 13:19:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233565AbhEaRTN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 13:19:13 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 970B5C043474;
        Mon, 31 May 2021 08:31:09 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id i5so8621667pgm.0;
        Mon, 31 May 2021 08:31:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=a0wbqAwVg5nm3epwFVJrv6sZ/e1eVDrfHAVlzb8ZgCY=;
        b=bmrdu6VhulS68pVreUiO85i8Hr6HmEiUCcdCebIzlAGB7ynHhvE1Ce6jiswRDyvs2/
         DwkBC5U4BByV2BxUAS2ozBaomBN/lPAqltOO/r+vLqn6y2xEtrolOAjg5eNBQl/NJc3F
         ZQuOaoafGhoG8Byabwfupeb3Dy/0Q0lcTw6gsy82APp4Npss6+tino7UK4wVsVPEhqel
         Qstmqg7VJ7QSXzvu22s9ikm8Fbk58n+AGa1rg94DWMEU2mMlRdD0l51z3jOhf/ebsCT8
         JkmHtJo0unQKUJuS7N8U5tsVz5shWBoyDJO0c01vL7ualRcj1qXhgr4qfKI710XfO2Xc
         e8xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=a0wbqAwVg5nm3epwFVJrv6sZ/e1eVDrfHAVlzb8ZgCY=;
        b=aEy1v+MgrVqZ3zQJcoZqc1jQbJiT6vtgUDV8GB1YhHk7HY5mJPF+OrXuz7D9/nZbCX
         myYfnUYQe9IBtnHvJQ8kYgXPkPvdg+ZccpX8lIMFMnJh2vPrWA4CSDVItCvyewxj+x44
         uisE9QF4iN1jQQm/uRLcZ4P2jmS03umSxawyrKgF+It04uegwH6/kIukV8s38xLkspBV
         2+DlZMMlPaYgNAffxsyAujZ3QSIy+y2lhpyOzS6Bv8PSj2VcCJZQtAFP3h55qpel/ExZ
         rpzdSJUCbETYUz2Q1/4RfW6pbqAPF5WzpssHyECCyn4Yk3CNZh2zaAuQy2IEivGNyOu9
         Nj0Q==
X-Gm-Message-State: AOAM531t77MioqKT8KFfHOUtBHXnqulxRXGmFeCHX6byYLoihpjMsWoa
        +wuAlbCVgX+wlrPqV3jGOmM=
X-Google-Smtp-Source: ABdhPJwc6y8XH5gMUlg33c5mjAYxp7Z31S26smo63/2m3ach+dZuwQqYo1pbMXG3ssNyK6/eetIPhQ==
X-Received: by 2002:a62:f947:0:b029:2e9:c502:7939 with SMTP id g7-20020a62f9470000b02902e9c5027939mr8021098pfm.34.1622475069168;
        Mon, 31 May 2021 08:31:09 -0700 (PDT)
Received: from mail.google.com ([141.164.41.4])
        by smtp.gmail.com with ESMTPSA id y24sm11284730pfn.81.2021.05.31.08.31.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 08:31:08 -0700 (PDT)
Date:   Mon, 31 May 2021 23:31:00 +0800
From:   Changbin Du <changbin.du@gmail.com>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     'Cong Wang' <xiyou.wangcong@gmail.com>,
        Changbin Du <changbin.du@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kici nski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] net: fix oops in socket ioctl cmd SIOCGSKNS when NET_NS
 is disabled
Message-ID: <20210531153100.pfwlrkrqdisp6heu@mail.google.com>
References: <20210529060526.422987-1-changbin.du@gmail.com>
 <CAM_iQpWwApLVg39rUkyXxnhsiP0SZf=0ft6vsq=VxFtJ2SumAQ@mail.gmail.com>
 <55effe20acc54ea4a96ea86015d99a5b@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55effe20acc54ea4a96ea86015d99a5b@AcuMS.aculab.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 31, 2021 at 08:30:58AM +0000, David Laight wrote:
> From: Cong Wang
> > Sent: 29 May 2021 20:15
> > 
> > On Fri, May 28, 2021 at 11:08 PM Changbin Du <changbin.du@gmail.com> wrote:
> > > diff --git a/net/socket.c b/net/socket.c
> > > index 27e3e7d53f8e..644b46112d35 100644
> > > --- a/net/socket.c
> > > +++ b/net/socket.c
> > > @@ -1149,11 +1149,15 @@ static long sock_ioctl(struct file *file, unsigned cmd, unsigned long arg)
> > >                         mutex_unlock(&vlan_ioctl_mutex);
> > >                         break;
> > >                 case SIOCGSKNS:
> > > +#ifdef CONFIG_NET_NS
> > >                         err = -EPERM;
> > >                         if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
> > >                                 break;
> > >
> > >                         err = open_related_ns(&net->ns, get_net_ns);
> > > +#else
> > > +                       err = -ENOTSUPP;
> > > +#endif
> > 
> > I wonder if it is easier if we just reject ns->ops==NULL case
> > in open_related_ns(). For 1) we can save an ugly #ifdef here;
> > 2) drivers/net/tun.c has the same bugs.
> 
> If CONFIG_NET_NS is unset then why not make both ns_capable()
> and open_related_ns() unconditionally return -ENOTSUPP?
>
Here is the new fix that reject creating indoe for disabled ns.
--- a/fs/nsfs.c
+++ b/fs/nsfs.c
@@ -62,6 +62,10 @@ static int __ns_get_path(struct path *path, struct ns_common *ns)
        struct inode *inode;
        unsigned long d;
 
+       /* In case the namespace is not actually enabled. */
+       if (!ns->ops)
+               return -EOPNOTSUPP;

> 	David
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)

-- 
Cheers,
Changbin Du
