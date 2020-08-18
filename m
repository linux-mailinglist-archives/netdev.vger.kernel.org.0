Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17FBC2483E6
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 13:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726696AbgHRLck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 07:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726786AbgHRLcV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 07:32:21 -0400
Received: from mail-oo1-xc41.google.com (mail-oo1-xc41.google.com [IPv6:2607:f8b0:4864:20::c41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB99FC061342;
        Tue, 18 Aug 2020 04:32:20 -0700 (PDT)
Received: by mail-oo1-xc41.google.com with SMTP id y30so4072423ooj.3;
        Tue, 18 Aug 2020 04:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:reply-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ExSCm02y3qpUSj/p3vHeizuT1G9r/WCp9sMwgc77Xhw=;
        b=lpcmiZRC0Itwnv8XEX0Gt0g4YzYZoFD+0cQTl/lgDNgLVzRe6IuCkiyAsMKmXxtzyS
         DF5PMESVBKjCzoZjEI411d9Iw1L3XxuPkPVdy8WD0iLU9FEOhQt0C+gxLXxG9FwuHlLM
         rhDESa4KirIUUOyZAMa3fGnotL1y1ZAkDn7wOqcdEugoXuPZ7SjANkcHlMg4NvyiNbht
         ty6pszTzwEC7d8yfKI/mGHwXfZomUw3KmQy9Bjfu0tTtXYliq18/FxRxu1WvUqVtTDdI
         K3vNrDjnKkdMwRXJXjv0FWKEbAC/2OegAiVjrrRDrIlbVqKEFhwQhGoW00TK4+pX8gAo
         GGSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :reply-to:references:mime-version:content-disposition:in-reply-to
         :user-agent;
        bh=ExSCm02y3qpUSj/p3vHeizuT1G9r/WCp9sMwgc77Xhw=;
        b=p0El+5oHOMmKmJczNTb3dMky9nFr5uMOoMs0POP74oey22EApUumHYTaL2oRazGoB/
         MjCGKLVKfc71tEqS+ogdXUFK5vuC0DevJWejKQgz04YIDJU1NlUETxMpLJdIRj2OkZhV
         L60QWwyO21LiNJCiq5pLmb405ibHA8+/h+/SyMTkHIdkP1dJ/KfrgRMccu8ew921kT59
         cjLTsw2NimglvldCUau9X23RTY5ixerpBi3uFZ5PAaslw93pHkLh9roM+rUCuRVhWukR
         6EukWQ4GBLWkYy4Znwi58XAQaPPrOe2MsBI6BZ9RC/FDkM2zW475Jeoqb9mGg5c9bgoa
         nfpA==
X-Gm-Message-State: AOAM533oxYlrnM51caMj7uyFiSwWM2s3vfm4KGY8nQVTN4TAq4IADE9/
        Nvjc2eI+v9PG2DSuX10kSw==
X-Google-Smtp-Source: ABdhPJywdLvN8lVgc2yDfHhvIZ4/3whUvULM6gOBhid0aKLlGB5miCWrsMhpAucNStAL2zXitNZckQ==
X-Received: by 2002:a4a:7241:: with SMTP id r1mr14426630ooe.48.1597750340029;
        Tue, 18 Aug 2020 04:32:20 -0700 (PDT)
Received: from serve.minyard.net (serve.minyard.net. [2001:470:b8f6:1b::1])
        by smtp.gmail.com with ESMTPSA id v35sm3862490otb.32.2020.08.18.04.32.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2020 04:32:18 -0700 (PDT)
Received: from minyard.net (unknown [IPv6:2001:470:b8f6:1b:8b39:c3f3:f502:5c4e])
        by serve.minyard.net (Postfix) with ESMTPSA id 4AF641800D4;
        Tue, 18 Aug 2020 11:32:17 +0000 (UTC)
Date:   Tue, 18 Aug 2020 06:32:16 -0500
From:   Corey Minyard <minyard@acm.org>
To:     Allen <allen.lkml@gmail.com>
Cc:     Allen Pais <allen.cryptic@gmail.com>, jdike@addtoit.com,
        richard@nod.at, anton.ivanov@cambridgegreys.com, 3chas3@gmail.com,
        axboe@kernel.dk, stefanr@s5r6.in-berlin.de, airlied@linux.ie,
        daniel@ffwll.ch, sre@kernel.org,
        James.Bottomley@hansenpartnership.com, kys@microsoft.com,
        deller@gmx.de, dmitry.torokhov@gmail.com, jassisinghbrar@gmail.com,
        shawnguo@kernel.org, s.hauer@pengutronix.de,
        maximlevitsky@gmail.com, oakad@yahoo.com,
        Ulf Hansson <ulf.hansson@linaro.org>,
        mporter@kernel.crashing.org, alex.bou9@gmail.com,
        broonie@kernel.org, martyn@welchs.me.uk, manohar.vanga@gmail.com,
        mitch@sfgoth.com, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        linux-um@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-block@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        openipmi-developer@lists.sourceforge.net,
        linux1394-devel@lists.sourceforge.net,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-hyperv@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-input@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-ntb@googlegroups.com, linux-s390@vger.kernel.org,
        linux-spi@vger.kernel.org, devel@driverdev.osuosl.org,
        Romain Perier <romain.perier@gmail.com>
Subject: Re: [PATCH] char: ipmi: convert tasklets to use new tasklet_setup()
 API
Message-ID: <20200818113216.GD2842@minyard.net>
Reply-To: minyard@acm.org
References: <20200817091617.28119-1-allen.cryptic@gmail.com>
 <20200817091617.28119-3-allen.cryptic@gmail.com>
 <20200817121514.GE2865@minyard.net>
 <CAOMdWSJXCn5KYHen4kynH1A5Oixo+yPzs3oathsfa8gtKZGkjg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMdWSJXCn5KYHen4kynH1A5Oixo+yPzs3oathsfa8gtKZGkjg@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 18, 2020 at 02:46:23PM +0530, Allen wrote:
> > >
> > > Signed-off-by: Romain Perier <romain.perier@gmail.com>
> > > Signed-off-by: Allen Pais <allen.lkml@gmail.com>
> >
> > This looks good to me.
> >
> > Reviewed-by: Corey Minyard <cminyard@mvista.com>
> >
> > Are you planning to push this, or do you want me to take it?  If you
> > want me to take it, what is the urgency?
> 
>  Thanks. Well, not hurry, as long as it goes into 5.9 with all other
> changes.

Ok, this is queued in my for-next branch.

-corey

> 
> 
> >
> > -corey
> >
> > > ---
> > >  drivers/char/ipmi/ipmi_msghandler.c | 13 ++++++-------
> > >  1 file changed, 6 insertions(+), 7 deletions(-)
> > >
> > > diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
> > > index 737c0b6b24ea..e1814b6a1225 100644
> > > --- a/drivers/char/ipmi/ipmi_msghandler.c
> > > +++ b/drivers/char/ipmi/ipmi_msghandler.c
> > > @@ -39,7 +39,7 @@
> > >
> > >  static struct ipmi_recv_msg *ipmi_alloc_recv_msg(void);
> > >  static int ipmi_init_msghandler(void);
> > > -static void smi_recv_tasklet(unsigned long);
> > > +static void smi_recv_tasklet(struct tasklet_struct *t);
> > >  static void handle_new_recv_msgs(struct ipmi_smi *intf);
> > >  static void need_waiter(struct ipmi_smi *intf);
> > >  static int handle_one_recv_msg(struct ipmi_smi *intf,
> > > @@ -3430,9 +3430,8 @@ int ipmi_add_smi(struct module         *owner,
> > >       intf->curr_seq = 0;
> > >       spin_lock_init(&intf->waiting_rcv_msgs_lock);
> > >       INIT_LIST_HEAD(&intf->waiting_rcv_msgs);
> > > -     tasklet_init(&intf->recv_tasklet,
> > > -                  smi_recv_tasklet,
> > > -                  (unsigned long) intf);
> > > +     tasklet_setup(&intf->recv_tasklet,
> > > +                  smi_recv_tasklet);
> > >       atomic_set(&intf->watchdog_pretimeouts_to_deliver, 0);
> > >       spin_lock_init(&intf->xmit_msgs_lock);
> > >       INIT_LIST_HEAD(&intf->xmit_msgs);
> > > @@ -4467,10 +4466,10 @@ static void handle_new_recv_msgs(struct ipmi_smi *intf)
> > >       }
> > >  }
> > >
> > > -static void smi_recv_tasklet(unsigned long val)
> > > +static void smi_recv_tasklet(struct tasklet_struct *t)
> > >  {
> > >       unsigned long flags = 0; /* keep us warning-free. */
> > > -     struct ipmi_smi *intf = (struct ipmi_smi *) val;
> > > +     struct ipmi_smi *intf = from_tasklet(intf, t, recv_tasklet);
> > >       int run_to_completion = intf->run_to_completion;
> > >       struct ipmi_smi_msg *newmsg = NULL;
> > >
> > > @@ -4542,7 +4541,7 @@ void ipmi_smi_msg_received(struct ipmi_smi *intf,
> > >               spin_unlock_irqrestore(&intf->xmit_msgs_lock, flags);
> > >
> > >       if (run_to_completion)
> > > -             smi_recv_tasklet((unsigned long) intf);
> > > +             smi_recv_tasklet(&intf->recv_tasklet);
> > >       else
> > >               tasklet_schedule(&intf->recv_tasklet);
> > >  }
> > > --
> > > 2.17.1
> > >
> 
> 
> 
> -- 
>        - Allen
