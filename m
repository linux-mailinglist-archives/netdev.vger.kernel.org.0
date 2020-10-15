Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09C6028F88D
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 20:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729716AbgJOS2i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 14:28:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728042AbgJOS2h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 14:28:37 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3635C061755;
        Thu, 15 Oct 2020 11:28:37 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id q21so2406164pgi.13;
        Thu, 15 Oct 2020 11:28:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QWq4RR483RrQf9qvcEwbqi4k6qhvE4kHX8NyfjGVvXA=;
        b=suM0shAoEviw0J4mahfECH0DeTWgf4dZTp6LGEsWQzK/KSgZ+NC+40mf1I2SqIihzQ
         r2xIiorWXvWrfrEpNp4gafT+LzAe9eFox9X9UPnP4GmZNw/7qQFtJYvBn+8fcs9BVKmn
         7txz0gzyIWSDMZyhUwb9BAJQIRN4wZU1NVPoam1TMVygI/i5yc1uJsnFqcD7h2LNqUoc
         IWqyf1YBx27sZmbwkCkX9ObUCK3Fx0OO5S+vfuUUP5CJuQbME3p+YQVlKJM3NYlUKW2b
         W+vTovoe16ySBTvDkFdnu+oQnIsQOrAhYsiwQww9z+N5bBo+h7VNTWoBlvT57GsRVqpg
         3Erw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QWq4RR483RrQf9qvcEwbqi4k6qhvE4kHX8NyfjGVvXA=;
        b=SnSVIvTVzgGVwbX7bKLBD1kuz9mLc/F1pECpY845BWJw/X2C3sgQ+98dfGh55uy7aV
         UVxc/fPNthwDCIdlJkExr0UPTpUiseQCeDFf5x+TbtYIy42gWSML5ItyaDT1lqoHBxUL
         XfIyOZABHubhkWxUxBubS4AEfEXLTPjDkg5f6AjjGDI1jRxptLA6GE9w7T7i3ZcTfbYj
         l/pmhGX60XyY412M0k6f7vP/MHuDCgUqvpIBVEkyuSmOO3h+BeU4FYUjB5x60FtP6eWh
         wUft2Vr4sBAeKJRhvRrOP/dNgsw5vKu9BAu1+7M//wELb4RUe9DNgKXrG3HCMDahnuQx
         kb3g==
X-Gm-Message-State: AOAM531Dy75EpthgWw1WSbFdT2sfNhN8qYhY59vxKl2j8uRzpVocj5GB
        dydLbrqyMvAL8v8ijm0MIAM=
X-Google-Smtp-Source: ABdhPJwFgpj4yIvxdmNTRiStaRKsdkNCWiJ/L9B0sorGluXbb637Lm/bVOysyCqSimWb8YSk1QziHg==
X-Received: by 2002:a63:f80c:: with SMTP id n12mr140183pgh.94.1602786516974;
        Thu, 15 Oct 2020 11:28:36 -0700 (PDT)
Received: from Thinkpad ([45.118.167.207])
        by smtp.gmail.com with ESMTPSA id s66sm4070973pfb.25.2020.10.15.11.28.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2020 11:28:36 -0700 (PDT)
Date:   Thu, 15 Oct 2020 23:58:27 +0530
From:   Anmol Karn <anmol.karan123@gmail.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     ralf@linux-mips.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        linux-kernel@vger.kernel.org,
        syzbot+a1c743815982d9496393@syzkaller.appspotmail.com,
        linux-hams@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [Linux-kernel-mentees] [PATCH] net: rose: Fix Null pointer
 dereference in rose_send_frame()
Message-ID: <20201015182827.GA84192@Thinkpad>
References: <20201015001712.72976-1-anmol.karan123@gmail.com>
 <20201015051225.GA404970@kroah.com>
 <20201015141012.GB77038@Thinkpad>
 <20201015155051.GB66528@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201015155051.GB66528@kroah.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 15, 2020 at 05:50:51PM +0200, Greg KH wrote:
> On Thu, Oct 15, 2020 at 07:40:12PM +0530, Anmol Karn wrote:
> > On Thu, Oct 15, 2020 at 07:12:25AM +0200, Greg KH wrote:
> > > On Thu, Oct 15, 2020 at 05:47:12AM +0530, Anmol Karn wrote:
> > > > In rose_send_frame(), when comparing two ax.25 addresses, it assigns rose_call to 
> > > > either global ROSE callsign or default port, but when the former block triggers and 
> > > > rose_call is assigned by (ax25_address *)neigh->dev->dev_addr, a NULL pointer is 
> > > > dereferenced by 'neigh' when dereferencing 'dev'.
> > > > 
> > > > - net/rose/rose_link.c
> > > > This bug seems to get triggered in this line:
> > > > 
> > > > rose_call = (ax25_address *)neigh->dev->dev_addr;
> > > > 
> > > > Prevent it by checking NULL condition for neigh->dev before comparing addressed for 
> > > > rose_call initialization.
> > > > 
> > > > Reported-by: syzbot+a1c743815982d9496393@syzkaller.appspotmail.com 
> > > > Link: https://syzkaller.appspot.com/bug?id=9d2a7ca8c7f2e4b682c97578dfa3f236258300b3 
> > > > Signed-off-by: Anmol Karn <anmol.karan123@gmail.com>
> > > > ---
> > > > I am bit sceptical about the error return code, please suggest if anything else is 
> > > > appropriate in place of '-ENODEV'.
> > > > 
> > > >  net/rose/rose_link.c | 3 +++
> > > >  1 file changed, 3 insertions(+)
> > > > 
> > > > diff --git a/net/rose/rose_link.c b/net/rose/rose_link.c
> > > > index f6102e6f5161..92ea6a31d575 100644
> > > > --- a/net/rose/rose_link.c
> > > > +++ b/net/rose/rose_link.c
> > > > @@ -97,6 +97,9 @@ static int rose_send_frame(struct sk_buff *skb, struct rose_neigh *neigh)
> > > >  	ax25_address *rose_call;
> > > >  	ax25_cb *ax25s;
> > > >  
> > > > +	if (!neigh->dev)
> > > > +		return -ENODEV;
> > > 
> > > How can ->dev not be set at this point in time?  Shouldn't that be
> > > fixed, because it could change right after you check this, right?
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > 
> > Hello Sir,
> > 
> > Thanks for the review,
> > After following the call trace i thought, if neigh->dev is NULL it should
> > be checked, but I will figure out what is going on with the crash reproducer,
> > and I think rose_loopback_timer() is the place where problem started. 
> > 
> > Also, I have created a diff for checking neigh->dev before assigning ROSE callsign
> > , please give your suggestions on this.
> > 
> > 
> > diff --git a/net/rose/rose_link.c b/net/rose/rose_link.c
> > index f6102e6f5161..2ddd5e559442 100644
> > --- a/net/rose/rose_link.c
> > +++ b/net/rose/rose_link.c
> > @@ -97,10 +97,14 @@ static int rose_send_frame(struct sk_buff *skb, struct rose_neigh *neigh)
> >         ax25_address *rose_call;
> >         ax25_cb *ax25s;
> >  
> > -       if (ax25cmp(&rose_callsign, &null_ax25_address) == 0)
> > -               rose_call = (ax25_address *)neigh->dev->dev_addr;
> > -       else
> > -               rose_call = &rose_callsign;
> > +       if (neigh->dev) {
> > +               if (ax25cmp(&rose_callsign, &null_ax25_address) == 0)
> > +                       rose_call = (ax25_address *)neigh->dev->dev_addr;
> > +               else
> > +                       rose_call = &rose_callsign;
> > +       } else {
> > +               return -ENODEV;
> > +       }
> 
> The point I am trying to make is that if someone else is setting ->dev
> to NULL in some other thread/context/whatever, while this is running,
> checking for it like this will not work.
> 
> What is the lifetime rules of that pointer?  Who initializes it, and who
> sets it to NULL.  Figure that out first please to determine how to check
> for this properly.
> 
> thanks,
> 
> greg k-h

Sure sir, understood.


Thanks,
Anmol
