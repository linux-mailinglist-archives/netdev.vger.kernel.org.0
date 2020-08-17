Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A61C2246626
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 14:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728186AbgHQMPq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 08:15:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbgHQMPX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 08:15:23 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C06BC061389;
        Mon, 17 Aug 2020 05:15:19 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id r21so13178875ota.10;
        Mon, 17 Aug 2020 05:15:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:reply-to:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=HJ0m+miDorhqglJ9JrK44iTq3d9R15TmbjC29old1f8=;
        b=KQ04CZsRLDiNek1Hq6BgWjnM11s2YmAiDjqEVGZ1TB6F4rCxf78rX4jbJ0CzT3vabY
         xrX4JEoDeIRQkHsLGU1+gcp8w5QWNQcEyBm3wuShwRxBfydODrCE4cRQV+E7WBzKB44r
         nItPN0459qY5GQ/vDZ0NyzENyHv44GovdpKFSl4hiVWaOB2zEjXEpxHT00gUoMHFf0Aj
         T3icpJ/3pjaEvvW0UMNkSAFYHa1jbJwCP0vrwjpIL/uytt4RzckTqwRdvf5FUeTb7MGh
         bx2bsLCHbfEXkOD8bVoKRj4Mx5bjsmewyyPYaN17ohutCV8HXhFZHeJnJ+WLeKJ12UV0
         gebw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :reply-to:references:mime-version:content-disposition:in-reply-to
         :user-agent;
        bh=HJ0m+miDorhqglJ9JrK44iTq3d9R15TmbjC29old1f8=;
        b=BawvITJey5PsSV7BXEpOue7EpVtQi3+iXHJsYZVKZdYiRA8/kRwQVI5HIeWV0bGPCu
         m7uKL8v/oxpZXa7oAG42WalIdyUGIo+hgzhyu1BlvnrsD8cBz+Qi1PgcuCVTqKp5gExj
         n9gHDMs+YAnobzWERS+YqmPVtanpS0Gsai2PXBQ5QImH3KJ6UDQzt26FdgsC78CF9AQ5
         IiwWUelAatYpJy9uoRVIGMkTmvnd+xQj8SEg0QA2KxPBOI8JnUdNJ3ngpudUBrvA2eeS
         B3Vi0nHMmtRJI/Jf0UgIFJCgyF+f69gcB6NIGErA5/XM49Kgi4Ati139o/Aa2Fxu1NXy
         ITcA==
X-Gm-Message-State: AOAM5327ljAHL33LdiA/TdNXAe/Xj7bYjmNYoDHPD3p9evAH8W98UjgW
        g+zlgilyVfAGx9dcqW9ASA==
X-Google-Smtp-Source: ABdhPJy4QfXEUBbWmVDtAzyWm157/pCVwSVPWhR0mJ058Fnm0lC/IAUOoEeTjBc9itF58Cw5xKVyqA==
X-Received: by 2002:a05:6830:1346:: with SMTP id r6mr11152982otq.325.1597666517323;
        Mon, 17 Aug 2020 05:15:17 -0700 (PDT)
Received: from serve.minyard.net ([47.184.146.204])
        by smtp.gmail.com with ESMTPSA id l17sm3384049otn.2.2020.08.17.05.15.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 05:15:16 -0700 (PDT)
Received: from minyard.net (unknown [IPv6:2001:470:b8f6:1b:8b39:c3f3:f502:5c4e])
        by serve.minyard.net (Postfix) with ESMTPSA id 846E11800D4;
        Mon, 17 Aug 2020 12:15:15 +0000 (UTC)
Date:   Mon, 17 Aug 2020 07:15:14 -0500
From:   Corey Minyard <minyard@acm.org>
To:     Allen Pais <allen.cryptic@gmail.com>
Cc:     jdike@addtoit.com, richard@nod.at, anton.ivanov@cambridgegreys.com,
        3chas3@gmail.com, axboe@kernel.dk, stefanr@s5r6.in-berlin.de,
        airlied@linux.ie, daniel@ffwll.ch, sre@kernel.org,
        James.Bottomley@HansenPartnership.com, kys@microsoft.com,
        deller@gmx.de, dmitry.torokhov@gmail.com, jassisinghbrar@gmail.com,
        shawnguo@kernel.org, s.hauer@pengutronix.de,
        maximlevitsky@gmail.com, oakad@yahoo.com, ulf.hansson@linaro.org,
        mporter@kernel.crashing.org, alex.bou9@gmail.com,
        broonie@kernel.org, martyn@welchs.me.uk, manohar.vanga@gmail.com,
        mitch@sfgoth.com, davem@davemloft.net, kuba@kernel.org,
        keescook@chromium.org, linux-um@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-block@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        openipmi-developer@lists.sourceforge.net,
        linux1394-devel@lists.sourceforge.net,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-hyperv@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-input@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-ntb@googlegroups.com, linux-s390@vger.kernel.org,
        linux-spi@vger.kernel.org, devel@driverdev.osuosl.org,
        Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: Re: [PATCH] char: ipmi: convert tasklets to use new tasklet_setup()
 API
Message-ID: <20200817121514.GE2865@minyard.net>
Reply-To: minyard@acm.org
References: <20200817091617.28119-1-allen.cryptic@gmail.com>
 <20200817091617.28119-3-allen.cryptic@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200817091617.28119-3-allen.cryptic@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 17, 2020 at 02:45:57PM +0530, Allen Pais wrote:
> From: Allen Pais <allen.lkml@gmail.com>
> 
> In preparation for unconditionally passing the
> struct tasklet_struct pointer to all tasklet
> callbacks, switch to using the new tasklet_setup()
> and from_tasklet() to pass the tasklet pointer explicitly.
> 
> Signed-off-by: Romain Perier <romain.perier@gmail.com>
> Signed-off-by: Allen Pais <allen.lkml@gmail.com>

This looks good to me.

Reviewed-by: Corey Minyard <cminyard@mvista.com>

Are you planning to push this, or do you want me to take it?  If you
want me to take it, what is the urgency?

-corey

> ---
>  drivers/char/ipmi/ipmi_msghandler.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
> index 737c0b6b24ea..e1814b6a1225 100644
> --- a/drivers/char/ipmi/ipmi_msghandler.c
> +++ b/drivers/char/ipmi/ipmi_msghandler.c
> @@ -39,7 +39,7 @@
>  
>  static struct ipmi_recv_msg *ipmi_alloc_recv_msg(void);
>  static int ipmi_init_msghandler(void);
> -static void smi_recv_tasklet(unsigned long);
> +static void smi_recv_tasklet(struct tasklet_struct *t);
>  static void handle_new_recv_msgs(struct ipmi_smi *intf);
>  static void need_waiter(struct ipmi_smi *intf);
>  static int handle_one_recv_msg(struct ipmi_smi *intf,
> @@ -3430,9 +3430,8 @@ int ipmi_add_smi(struct module         *owner,
>  	intf->curr_seq = 0;
>  	spin_lock_init(&intf->waiting_rcv_msgs_lock);
>  	INIT_LIST_HEAD(&intf->waiting_rcv_msgs);
> -	tasklet_init(&intf->recv_tasklet,
> -		     smi_recv_tasklet,
> -		     (unsigned long) intf);
> +	tasklet_setup(&intf->recv_tasklet,
> +		     smi_recv_tasklet);
>  	atomic_set(&intf->watchdog_pretimeouts_to_deliver, 0);
>  	spin_lock_init(&intf->xmit_msgs_lock);
>  	INIT_LIST_HEAD(&intf->xmit_msgs);
> @@ -4467,10 +4466,10 @@ static void handle_new_recv_msgs(struct ipmi_smi *intf)
>  	}
>  }
>  
> -static void smi_recv_tasklet(unsigned long val)
> +static void smi_recv_tasklet(struct tasklet_struct *t)
>  {
>  	unsigned long flags = 0; /* keep us warning-free. */
> -	struct ipmi_smi *intf = (struct ipmi_smi *) val;
> +	struct ipmi_smi *intf = from_tasklet(intf, t, recv_tasklet);
>  	int run_to_completion = intf->run_to_completion;
>  	struct ipmi_smi_msg *newmsg = NULL;
>  
> @@ -4542,7 +4541,7 @@ void ipmi_smi_msg_received(struct ipmi_smi *intf,
>  		spin_unlock_irqrestore(&intf->xmit_msgs_lock, flags);
>  
>  	if (run_to_completion)
> -		smi_recv_tasklet((unsigned long) intf);
> +		smi_recv_tasklet(&intf->recv_tasklet);
>  	else
>  		tasklet_schedule(&intf->recv_tasklet);
>  }
> -- 
> 2.17.1
> 
