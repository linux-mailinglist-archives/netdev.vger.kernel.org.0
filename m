Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5DD2A1F45
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 16:48:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbgKAPsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 10:48:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726499AbgKAPsP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Nov 2020 10:48:15 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15F16C0617A6;
        Sun,  1 Nov 2020 07:48:15 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id x23so5551105plr.6;
        Sun, 01 Nov 2020 07:48:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MFqfoYF37r0SCDNbL3WFzSImlz9fo3l92Mt1S0RvLJ8=;
        b=ZAtPfAXU+ez6G3Sa36jiNuVtip9xuBJgSCR0eoVs0LXVlEPK3y3U1y5jGjhnOCzM3j
         eWNju6HB/54AK4dHhdTOagCy4vl27W9zS8wYVeMMDvBwmlR+mvNdwRsAPW/B7Fl+Y6Du
         MrexSdOy4IPya4mnY3m6ec0J3zCaaP/rps+siodyeNxfI0oikzV/wMkUwwZFAz6p+b78
         2HtfvsIYZW1/Szn0J2TiHndSBmstCX5igdVt3zIWxZUqtxRKfxQHmAA0l0VgoIiRKcYy
         6yjBrWwbcEXKCWf9uGpD5WSkBntEAh+mTSlQ0SmtL4HB4cLriFZyx7JbrOY6MMDQb04g
         vZUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MFqfoYF37r0SCDNbL3WFzSImlz9fo3l92Mt1S0RvLJ8=;
        b=Xiim99WTiPx99LsKCw1aFdOjqNx84s70BsdyP7QkzZz1Z03qVj4i+u8xBpJ+s/bUea
         AM+GWuz6zD0CBxc/jN75DLQ7vnC5sQ64ukc607mGH8Za/qA7ulc8I0ewcxCboY2eTbB4
         rdI9WBq9pARWW8/1IvLtAFqYrjkHAbm3U6pq5f1ZxXm61oNUfsB+U/32BjlWOelB8RQb
         05H4DKyiIrROAu3bFphgMr2n6/pMmKaKGbiECBjsTTvXl6Ay8jHpbu2seDdHb1E+mXgn
         ZrC/vqOdlr57tkaTkAWxvNZm63NMY/FfotEBSioFEM5fd5JKHpwylX6AnIUa0qt2alD4
         Qmfw==
X-Gm-Message-State: AOAM531GeK0xdTnU87VHPW4rKVWZqarq+R1W/Kyv23cAMqbK+iH/TAnB
        gkmWuPfB2L2Mx+iu0eys0aM=
X-Google-Smtp-Source: ABdhPJxr/Q4EjhU1j+7NucdANt0DklHJ7+90yeKV+x6ytGW9EZCS9YxpzmCS09o8aJ85J+qqZyTl5Q==
X-Received: by 2002:a17:90a:e20f:: with SMTP id a15mr12429354pjz.12.1604245694224;
        Sun, 01 Nov 2020 07:48:14 -0800 (PST)
Received: from Thinkpad ([45.118.167.197])
        by smtp.gmail.com with ESMTPSA id m12sm9191897pgl.90.2020.11.01.07.48.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2020 07:48:13 -0800 (PST)
Date:   Sun, 1 Nov 2020 21:18:06 +0530
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
Message-ID: <20201101154806.GB56088@Thinkpad>
References: <20201015001712.72976-1-anmol.karan123@gmail.com>
 <20201015051225.GA404970@kroah.com>
 <20201015141012.GB77038@Thinkpad>
 <20201015155051.GB66528@kroah.com>
 <20201030105413.GA32091@Thinkpad>
 <20201101110258.GA2925745@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201101110258.GA2925745@kroah.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 01, 2020 at 12:02:58PM +0100, Greg KH wrote:
> On Fri, Oct 30, 2020 at 04:24:13PM +0530, Anmol Karn wrote:
> > On Thu, Oct 15, 2020 at 05:50:51PM +0200, Greg KH wrote:
> > > On Thu, Oct 15, 2020 at 07:40:12PM +0530, Anmol Karn wrote:
> > > > On Thu, Oct 15, 2020 at 07:12:25AM +0200, Greg KH wrote:
> > > > > On Thu, Oct 15, 2020 at 05:47:12AM +0530, Anmol Karn wrote:
> > > > > > In rose_send_frame(), when comparing two ax.25 addresses, it assigns rose_call to 
> > > > > > either global ROSE callsign or default port, but when the former block triggers and 
> > > > > > rose_call is assigned by (ax25_address *)neigh->dev->dev_addr, a NULL pointer is 
> > > > > > dereferenced by 'neigh' when dereferencing 'dev'.
> > > > > > 
> > > > > > - net/rose/rose_link.c
> > > > > > This bug seems to get triggered in this line:
> > > > > > 
> > > > > > rose_call = (ax25_address *)neigh->dev->dev_addr;
> > > > > > 
> > > > > > Prevent it by checking NULL condition for neigh->dev before comparing addressed for 
> > > > > > rose_call initialization.
> > > > > > 
> > > > > > Reported-by: syzbot+a1c743815982d9496393@syzkaller.appspotmail.com 
> > > > > > Link: https://syzkaller.appspot.com/bug?id=9d2a7ca8c7f2e4b682c97578dfa3f236258300b3 
> > > > > > Signed-off-by: Anmol Karn <anmol.karan123@gmail.com>
> > > > > > ---
> > > > > > I am bit sceptical about the error return code, please suggest if anything else is 
> > > > > > appropriate in place of '-ENODEV'.
> > > > > > 
> > > > > >  net/rose/rose_link.c | 3 +++
> > > > > >  1 file changed, 3 insertions(+)
> > > > > > 
> > > > > > diff --git a/net/rose/rose_link.c b/net/rose/rose_link.c
> > > > > > index f6102e6f5161..92ea6a31d575 100644
> > > > > > --- a/net/rose/rose_link.c
> > > > > > +++ b/net/rose/rose_link.c
> > > > > > @@ -97,6 +97,9 @@ static int rose_send_frame(struct sk_buff *skb, struct rose_neigh *neigh)
> > > > > >  	ax25_address *rose_call;
> > > > > >  	ax25_cb *ax25s;
> > > > > >  
> > > > > > +	if (!neigh->dev)
> > > > > > +		return -ENODEV;
> > > > > 
> > > > > How can ->dev not be set at this point in time?  Shouldn't that be
> > > > > fixed, because it could change right after you check this, right?
> > > > > 
> > > > > thanks,
> > > > > 
> > > > > greg k-h
> > > > 
> > > > Hello Sir,
> > > > 
> > > > Thanks for the review,
> > > > After following the call trace i thought, if neigh->dev is NULL it should
> > > > be checked, but I will figure out what is going on with the crash reproducer,
> > > > and I think rose_loopback_timer() is the place where problem started. 
> > > > 
> > > > Also, I have created a diff for checking neigh->dev before assigning ROSE callsign
> > > > , please give your suggestions on this.
> > > > 
> > > > 
> > > > diff --git a/net/rose/rose_link.c b/net/rose/rose_link.c
> > > > index f6102e6f5161..2ddd5e559442 100644
> > > > --- a/net/rose/rose_link.c
> > > > +++ b/net/rose/rose_link.c
> > > > @@ -97,10 +97,14 @@ static int rose_send_frame(struct sk_buff *skb, struct rose_neigh *neigh)
> > > >         ax25_address *rose_call;
> > > >         ax25_cb *ax25s;
> > > >  
> > > > -       if (ax25cmp(&rose_callsign, &null_ax25_address) == 0)
> > > > -               rose_call = (ax25_address *)neigh->dev->dev_addr;
> > > > -       else
> > > > -               rose_call = &rose_callsign;
> > > > +       if (neigh->dev) {
> > > > +               if (ax25cmp(&rose_callsign, &null_ax25_address) == 0)
> > > > +                       rose_call = (ax25_address *)neigh->dev->dev_addr;
> > > > +               else
> > > > +                       rose_call = &rose_callsign;
> > > > +       } else {
> > > > +               return -ENODEV;
> > > > +       }
> > > 
> > > The point I am trying to make is that if someone else is setting ->dev
> > > to NULL in some other thread/context/whatever, while this is running,
> > > checking for it like this will not work.
> > > 
> > > What is the lifetime rules of that pointer?  Who initializes it, and who
> > > sets it to NULL.  Figure that out first please to determine how to check
> > > for this properly.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > 
> > Hello All,
> > 
> > I investigated further on this,
> > 
> > Here is some things i noticed:
> > 
> > When I followed the call trace,
> > 
> > [ 84.241331][ C3] Call Trace:
> > [ 84.241331][ C3] rose_transmit_clear_request ($SOURCE/net/rose/rose_link.c:255)
> > [ 84.241331][ C3] ? lockdep_hardirqs_on ($SOURCE/kernel/locking/lockdep.c:4161)
> > [ 84.241331][ C3] rose_rx_call_request ($SOURCE/net/rose/af_rose.c:999)
> > [ 84.241331][ C3] ? rose_release ($SOURCE/net/rose/af_rose.c:970)
> > [ 84.241331][ C3] rose_loopback_timer ($SOURCE/net/rose/rose_loopback.c:100)
> > [ 84.241331][ C3] ? rose_transmit_link ($SOURCE/net/rose/rose_loopback.c:60)
> > 
> > in the rose_send_frame() it dereferenced `neigh->dev` when called from 
> > rose_transmit_clear_request(), and the first occurance of the `neigh`
> > is in rose_loopback_timer() as `rose_loopback_neigh`, and it is initialized 
> > in rose_add_loopback_neighh() as NULL.
> > 
> > - net/rose/rose_route.c:381
> > 
> > void rose_add_loopback_neigh(void)
> > {
> > 	struct rose_neigh *sn;
> > 
> > 	rose_loopback_neigh = kmalloc(sizeof(struct rose_neigh), GFP_KERNEL);
> > 	if (!rose_loopback_neigh)
> > 		return;
> > 	sn = rose_loopback_neigh;
> > 
> > 	sn->callsign  = null_ax25_address;
> > 	sn->digipeat  = NULL;
> > 	sn->ax25      = NULL;
> > 	sn->dev       = NULL;
> > 	^^^^^^^^^^^^^^^^^^^^^
> > 
> > i.e when `rose_loopback_neigh` used in rose_loopback_timer() its `->dev` was
> > still NULL and rose_loopback_timer() was calling rose_rx_call_request() 
> > without checking for NULL.
> > 
> > 
> > I have created the following patch to check for NULL pointer.
> > 
> > diff --git a/net/rose/rose_loopback.c b/net/rose/rose_loopback.c
> > index 7b094275ea8b..cd7774cb1d07 100644
> > --- a/net/rose/rose_loopback.c
> > +++ b/net/rose/rose_loopback.c
> > @@ -96,7 +96,7 @@ static void rose_loopback_timer(struct timer_list *unused)
> >                 }
> >  
> >                 if (frametype == ROSE_CALL_REQUEST) {
> > -                       if ((dev = rose_dev_get(dest)) != NULL) {
> > +                       if (rose_loopback_neigh->dev && (dev = rose_dev_get(dest)) != NULL) {
> >                                 if (rose_rx_call_request(skb, dev, rose_loopback_neigh, lci_o) == 0)
> >                                         kfree_skb(skb);
> >                         } else {
> > 
> > 
> > 
> > Please, review it and give me suggestions whether i am going right or not.
> 
> That seems better, does it solve the syzbot test?
> 
> thanks,
> 
> greg k-h

Hello Sir,

yes this patch is tested by syzbot.

Below links triggers same bug:

Link 1: https://syzkaller.appspot.com/bug?id=f46c94afb217ab49c75350adbd467d86ae2b59a6

Link 2: https://syzkaller.appspot.com/bug?id=9d2a7ca8c7f2e4b682c97578dfa3f236258300b3

Also, can i now send a version 2 of this patch?


Thanks,
Anmol




