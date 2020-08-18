Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9DF52481B8
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 11:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbgHRJQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 05:16:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbgHRJQf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 05:16:35 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FF31C061389;
        Tue, 18 Aug 2020 02:16:35 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id l204so17340888oib.3;
        Tue, 18 Aug 2020 02:16:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XZ5gSn6/zxDXq0JbeRnX/CK1QRoCv2dl+iqkeCW1pS8=;
        b=oAk9KLz4zf32ff8AWoLjc9RpJCU0tp2pqYqSeAskrK0ZuvgefHaPfMSjLFyZsdmGPe
         te4G+1pjgni1LPzEs8ACMIxIUvuyoHAcuLUM0MtETeGVCh8WdwKiKS7tJajtKiiKuEyx
         nSe+wjaCOjY/H+YXbeH9/w5O+j8asiWzGL7zUumlH8Xb/MaDp1vsFa9oDik3gP5W3Oy7
         HRujZb5rqlu9TSahSfcAn2YGlPMcHISk8UGHumVZMc/13KMA90JvU03ivC2rMRSghxXu
         ie9/eP5XbwHCE84n2rwd4SGlM0keNy0vyT0/ZYaZo7htPQZLV5eKfkX6krYhP46i5znY
         prXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XZ5gSn6/zxDXq0JbeRnX/CK1QRoCv2dl+iqkeCW1pS8=;
        b=UTo4EPj5RG9tHDXgrFu1W0vkTVu4J4Vy7O6sYuKU7Xv0hiEedXcmRcoCCLUYubO47u
         ObYdCcnQ+xCkM1JpdAXIg7+ptd0i9JHADwG39PDI10pEijukFyP8rgpJIoyju6RNd944
         rsC8te1Vs+1UU5YCqy7gq328Zrh7Txx7j8wLbjcuGcYF6JMUqLxQVn6cwP6j6udOYA0n
         zlOMf+5MKXYbmK0uxBB3GdIeAvilPt1ltNE2sdyWBk9mxWqBRp308+pCn+lx8/KrXA92
         ONV3oyargdVK7wINdwkkvzarGE90Zi4PfTDFTBLMfpcfVR6MEQkMlxOTikqYK9NbAGpO
         5azA==
X-Gm-Message-State: AOAM532YOKsaFrEUqbuDBbzpC7kSQ3AYra3Hru5xbAsjVKnUvW8h37EQ
        EcP0O8/YmLsVhKbjLtdjWmjGxNITrSPb2xesxmw=
X-Google-Smtp-Source: ABdhPJzoZrDFJA/sZSMB5eCKUKMwLIoW6MWAoom1GEFglhx9K88XCdrK0saLkhUm1iVXF7PVM6hI174/8O0mwAcreAA=
X-Received: by 2002:aca:6c6:: with SMTP id 189mr11628018oig.134.1597742194718;
 Tue, 18 Aug 2020 02:16:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200817091617.28119-1-allen.cryptic@gmail.com>
 <20200817091617.28119-3-allen.cryptic@gmail.com> <20200817121514.GE2865@minyard.net>
In-Reply-To: <20200817121514.GE2865@minyard.net>
From:   Allen <allen.lkml@gmail.com>
Date:   Tue, 18 Aug 2020 14:46:23 +0530
Message-ID: <CAOMdWSJXCn5KYHen4kynH1A5Oixo+yPzs3oathsfa8gtKZGkjg@mail.gmail.com>
Subject: Re: [PATCH] char: ipmi: convert tasklets to use new tasklet_setup() API
To:     minyard@acm.org
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
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >
> > Signed-off-by: Romain Perier <romain.perier@gmail.com>
> > Signed-off-by: Allen Pais <allen.lkml@gmail.com>
>
> This looks good to me.
>
> Reviewed-by: Corey Minyard <cminyard@mvista.com>
>
> Are you planning to push this, or do you want me to take it?  If you
> want me to take it, what is the urgency?

 Thanks. Well, not hurry, as long as it goes into 5.9 with all other
changes.


>
> -corey
>
> > ---
> >  drivers/char/ipmi/ipmi_msghandler.c | 13 ++++++-------
> >  1 file changed, 6 insertions(+), 7 deletions(-)
> >
> > diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
> > index 737c0b6b24ea..e1814b6a1225 100644
> > --- a/drivers/char/ipmi/ipmi_msghandler.c
> > +++ b/drivers/char/ipmi/ipmi_msghandler.c
> > @@ -39,7 +39,7 @@
> >
> >  static struct ipmi_recv_msg *ipmi_alloc_recv_msg(void);
> >  static int ipmi_init_msghandler(void);
> > -static void smi_recv_tasklet(unsigned long);
> > +static void smi_recv_tasklet(struct tasklet_struct *t);
> >  static void handle_new_recv_msgs(struct ipmi_smi *intf);
> >  static void need_waiter(struct ipmi_smi *intf);
> >  static int handle_one_recv_msg(struct ipmi_smi *intf,
> > @@ -3430,9 +3430,8 @@ int ipmi_add_smi(struct module         *owner,
> >       intf->curr_seq = 0;
> >       spin_lock_init(&intf->waiting_rcv_msgs_lock);
> >       INIT_LIST_HEAD(&intf->waiting_rcv_msgs);
> > -     tasklet_init(&intf->recv_tasklet,
> > -                  smi_recv_tasklet,
> > -                  (unsigned long) intf);
> > +     tasklet_setup(&intf->recv_tasklet,
> > +                  smi_recv_tasklet);
> >       atomic_set(&intf->watchdog_pretimeouts_to_deliver, 0);
> >       spin_lock_init(&intf->xmit_msgs_lock);
> >       INIT_LIST_HEAD(&intf->xmit_msgs);
> > @@ -4467,10 +4466,10 @@ static void handle_new_recv_msgs(struct ipmi_smi *intf)
> >       }
> >  }
> >
> > -static void smi_recv_tasklet(unsigned long val)
> > +static void smi_recv_tasklet(struct tasklet_struct *t)
> >  {
> >       unsigned long flags = 0; /* keep us warning-free. */
> > -     struct ipmi_smi *intf = (struct ipmi_smi *) val;
> > +     struct ipmi_smi *intf = from_tasklet(intf, t, recv_tasklet);
> >       int run_to_completion = intf->run_to_completion;
> >       struct ipmi_smi_msg *newmsg = NULL;
> >
> > @@ -4542,7 +4541,7 @@ void ipmi_smi_msg_received(struct ipmi_smi *intf,
> >               spin_unlock_irqrestore(&intf->xmit_msgs_lock, flags);
> >
> >       if (run_to_completion)
> > -             smi_recv_tasklet((unsigned long) intf);
> > +             smi_recv_tasklet(&intf->recv_tasklet);
> >       else
> >               tasklet_schedule(&intf->recv_tasklet);
> >  }
> > --
> > 2.17.1
> >



-- 
       - Allen
