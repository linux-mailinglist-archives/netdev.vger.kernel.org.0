Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D773C1BA62A
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 16:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727898AbgD0OSt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 10:18:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbgD0OSs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 10:18:48 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1852CC03C1A7
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 07:18:48 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id b1so10678702qtt.1
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 07:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/wH38SyJE8X+b5Fc7B6ftjt7vffFevW9vdZDKvUCUvc=;
        b=T/4g8xBlkpFO9QJPdvizBCsp1k3NSW1lAct+7df5lGQJU8zkygCYf6EFCuCo2eafTT
         pKGEDY69NQQOJoT6TtqG7xQLCA6JDeF1s+fzwLt5lGjTP4BQ0Zg5JVk8R9QraApcjcAs
         wbMVlpRyTBg/MOVnEVfK/be6oJvcCQpJTlGCs8tkOHvmVSbsFGErZkrul+aKgdoIpPgF
         sYxXIC9ngQVL9gLvjz/uegXjc7ceHeBtVun4vYyfLZoGAUYtHYQYFC+M7O8PfrEsZRJo
         sUPuWtHEGAJWbLbjBDN4/a+4WWioCErcKdKUJBfTZFvHVz7lPD4ONfd1wC5alDmi8/DF
         WJcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/wH38SyJE8X+b5Fc7B6ftjt7vffFevW9vdZDKvUCUvc=;
        b=sVbyDWeLP3jmbYvprAw9KaQvFxh6Dctyj55bOdzq3cniGMZKKi9pBjTqL2EakDsaoG
         xCI/DlWh416Kd+FZA9Js6F7TqkmgC5Wiwi3C3r6ipAiHSOMrGPix/XQY5zUtM59gkTtu
         cvE5e6IgHixDBqOg2WpIwQZT7xPmVL2F/hA+qW/q9t+x3c1/n/7cQ/2+srm8nclBjnGs
         YoaQBjUUK7vOiU0yjUBTaxqPDh1zQSqEN0qjHay0aGDKhXbFn3N5Dg0CBQ+iWF5QzW4c
         wY2Y38Eacp9UUsiui6V6+pkfQiucWFP+bIVPop96Yrz4bHP6dauJjvYTdmGebE2uGCAZ
         sW7Q==
X-Gm-Message-State: AGi0PuaLeox3OYaD7fbDG8XWAmAOI16ymY75Dhave9F7VlfKioVq76RM
        zX66yZT6eU+MsCcJT4Q9Boo=
X-Google-Smtp-Source: APiQypId8gYOmDmrZeQ5e8JIdrGe4PLZZZx/ZgO8CXRbtVB7jz2bMi1YZa90WOmXmUVaptU4Lql4zQ==
X-Received: by 2002:ac8:17c9:: with SMTP id r9mr23250443qtk.392.1587997127181;
        Mon, 27 Apr 2020 07:18:47 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f016:78a5:546c:6ba8:9d61:9f46])
        by smtp.gmail.com with ESMTPSA id c69sm10220948qkg.104.2020.04.27.07.18.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2020 07:18:45 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 741FDC311F; Mon, 27 Apr 2020 11:18:43 -0300 (-03)
Date:   Mon, 27 Apr 2020 11:18:43 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        ruxandra.radulescu@nxp.com, ioana.ciornei@nxp.com,
        nipun.gupta@nxp.com, shawnguo@kernel.org
Subject: Re: [PATCH net-next 2/2] dpaa2-eth: fix return codes used in
 ndo_setup_tc
Message-ID: <20200427141843.GB2469@localhost.localdomain>
References: <158765382862.1613879.11444486146802159959.stgit@firesoul>
 <158765387082.1613879.14971732890635443222.stgit@firesoul>
 <20200423082804.6235b084@hermes.lan>
 <20200423173804.004fd0f6@carbon>
 <20200423123356.523264b4@hermes.lan>
 <20200423125600.16956cc9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200424090426.1f9505e9@carbon>
 <20200424172859.78245218@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200424172859.78245218@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 24, 2020 at 05:28:59PM -0700, Jakub Kicinski wrote:
> On Fri, 24 Apr 2020 09:04:26 +0200 Jesper Dangaard Brouer wrote:
> > (Side-note: First I placed an extack in qdisc_create_dflt() but I
> > realized it was wrong, because it could potentially override messages
> > from the lower layers.)
> >
> > > > but doing that would require a change
> > > > to the ndo_setup_tc hook to allow driver to return its own error message
> > > > as to why the setup failed.    
> > > 
> > > Yeah :S The block offload command contains extack, but this driver
> > > doesn't understand block offload, so it won't interpret it...
> > > 
> > > That brings me to an important point - doesn't the extack in patch 1
> > > override any extack driver may have set?  
> > 
> > Nope, see above side-note.  I set the extack at the "lowest level",
> > e.g. closest to the error that cause the err back-propagation, when I
> > detect that this will cause a failure at higher level.
> 
> Still, the driver is lower:
> 
> diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
> index 2908e0a0d6e1..ffed75453c14 100644
> --- a/drivers/net/netdevsim/netdev.c
> +++ b/drivers/net/netdevsim/netdev.c
> @@ -209,9 +209,12 @@ static int
>  nsim_setup_tc(struct net_device *dev, enum tc_setup_type type, void *type_data)
>  {
>         struct netdevsim *ns = netdev_priv(dev);
> +       struct flow_block_offload *f;
> 
>         switch (type) {
>         case TC_SETUP_BLOCK:
> +               f = type_data;
> +               NL_SET_ERR_MSG_MOD(f->extack, "bla bla bla bla bla");
> +               return -EINVAL;
> -               return flow_block_cb_setup_simple(type_data,
> -                                                 &nsim_block_cb_list,
> -                                                 nsim_setup_tc_block_cb,
>  	default:
>  		return -EOPNOTSUPP;
>  	}
> 
> # tc qdisc add dev netdevsim0 ingress
> Error: Driver ndo_setup_tc failed.
> 
> 
> > > I remember we discussed this when adding extacks to the TC core, but 
> > > I don't remember the conclusion now, ugh.  
> > 
> > When adding the extack code, I as puzzled that during debugging I
> > managed to override other extack messages.  Have anyone though about a
> > better way to handle if extack messages gets overridden?
> 
> I think there was more discussion, but this is all I can find now:
> 
> https://lore.kernel.org/netdev/20180918131212.20266-4-johannes@sipsolutions.net/#t
> 
> Maybe Marcelo will remeber.

There was also this other one, on supporting multiple messages:
https://lore.kernel.org/netdev/673abaddb26351826ca454f46d1271f1f4814c56.1521226621.git.marcelo.leitner%40gmail.com/T/

What I remember is what we have now is enough because of 3 main
reasons:
- Anything logged before the actual error is potentially just noise
- Anything logged after the actual error is just noise,
- The user is probably not prepared to handle warnings from ip/tc/etc
  commands.

For this last, one example using the context here:
"Warning: failed to create the qdisc."
Ok, but what does that mean? Should the sysadmin, potentially unaware
of what a qdisc is, retry or ignore the warning? If retry, then it
probably should have just failed itself in the first place.
