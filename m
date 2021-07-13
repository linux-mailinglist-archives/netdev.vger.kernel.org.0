Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC2963C6EC4
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 12:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235729AbhGMKoR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 06:44:17 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:42689 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235408AbhGMKoQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 06:44:16 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 759BA580AA5;
        Tue, 13 Jul 2021 06:41:26 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 13 Jul 2021 06:41:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=0ld3gGk2gOLemZpCiTYaFnpWl3D
        uUP1r1OodiqyM0kE=; b=bdlURKK0SpCEnCHd+MwZg2/yETX7d/EqzVvlku3yPSM
        UWAIb3BQiQSJpRfuxVP+1pcR4/7WP5yS9F5zcTWjc9xzpUdKgS/zx0r+mr6R6jMT
        6TLUOTrU8IDdW/e9tDZKY91yEoC49qBrKRQRvSwBgpePa7axRSod0tjvbL8YiMS/
        6zVOCbhls36RAlcYA/9UBp551btahEU5nLk2tdXfx/WcB1SXrU2likpNjQDe44nI
        UNxTD5zrJ9dQXEWdLOGf/h2FA8ItqwiEgyjtUnbw5cIIRxHkYrMjjbmw8yOyetOC
        0RwoNcxnfWtIv2l+O6j18libL1Ca19uKQN9S2rTrwnw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=0ld3gG
        k2gOLemZpCiTYaFnpWl3DuUP1r1OodiqyM0kE=; b=USOjJ5YiR/x/hjMSmJBgUr
        ERHLg3R2Izs0jArfewhVoJ62nEuv3TxorETAgis6+dw8RKD4GUZEJKKjXEdA0EPk
        quZ6w1uYGsLGiIINT8v31VXXKNqMZ+B8fjXyuCn3ElVveciU4T/jDQ47aqPiQ3Hm
        2+qny9Mv/f2bujeXsrFYO+OLH8+GgGTiJAunVrbD7K8ngkJzByJToAbqwGGYYiJp
        GznKGSMVbiCtOtYHX40h2nSL4FDzY+dcUUS6ynLW6hC8K+ve0h8/WOQs+o6yDmgP
        TtPySORxi1o2inm7DxbqdYmXjq2lVxK5/0rFxO9M6ClT0iaUBrwXzCY4JXTMcZLw
        ==
X-ME-Sender: <xms:1W3tYLS8fzscBIssjTPfThdiDuFBFpjmUFZuUrywtrQRaVAIgDjJNw>
    <xme:1W3tYMws0262fHnPbUjiX6EjRGvYNubc12EokPgly_pqME9GUiRuONydNGbj721Ml
    9YDx3AsTV-H1w>
X-ME-Received: <xmr:1W3tYA2zmRUn103eWSVDQtD5PR6Df_4SYqOVz9jXhvp-t-0Q2VH_hUWJTFUGnmXmHbIEq_YBX0ruQITs040u5Slstw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudehgddvvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepudetieegte
    ehkeefueeggfehgeekvddvkeeugefhkeffhfeivddtueetvdeigfejnecuffhomhgrihhn
    pegsohhothhlihhnrdgtohhmpdhpvghnghhuthhrohhnihigrdguvgenucevlhhushhtvg
    hrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdr
    tghomh
X-ME-Proxy: <xmx:1W3tYLBWLuSOir9e02wPSFLp46X65-TCMKR2uXTs53mf0lRYrKxOWA>
    <xmx:1W3tYEjNIJCJ6odQVAvXPLaTypeHkPozDzkxGPzmj3JSeIlNLul6gw>
    <xmx:1W3tYPqzrAUJhdtdE4vfobo8TKUllb0AGFe_ePrTulNSYAMkdvJckg>
    <xmx:1m3tYJZB9W5DhS_Ii-9Z5IYEdIZ3R-Jy2NCEFDJ0B2IiPcRJc879zQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 13 Jul 2021 06:41:25 -0400 (EDT)
Date:   Tue, 13 Jul 2021 12:41:22 +0200
From:   Greg KH <greg@kroah.com>
To:     Xiaochen Zou <xzou017@ucr.edu>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>, netdev@vger.kernel.org,
        stable@vger.kernel.org, kernel@pengutronix.de,
        linux-can@vger.kernel.org
Subject: Re: Use-after-free access in j1939_session_deactivate
Message-ID: <YO1t0nB10tlnfEtK@kroah.com>
References: <CAE1SXrtrg4CrWg_rZLUHqWWFHkGnK5Ez0PExJq8-A9d5NjE_-w@mail.gmail.com>
 <YO0Z7s8p7CoetxdW@kroah.com>
 <CAE1SXrv2Et9icDf2NesjWmrwbjXL8067Y=D3RnwqpEeZT4OgTg@mail.gmail.com>
 <e1f71c33-a5dd-82b1-2dce-be4f052d6aa6@pengutronix.de>
 <CAE1SXrv3Ouwt4Y9NEWGi0WO701w1YP1ruMSxraZr4PZTGsUZgg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE1SXrv3Ouwt4Y9NEWGi0WO701w1YP1ruMSxraZr4PZTGsUZgg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 13, 2021 at 12:46:07AM -0700, Xiaochen Zou wrote:
> j1939_session_destroy() will free both session and session->priv. It
> leads to multiple use-after-free read and write in
> j1939_session_deactivate() when session was freed in
> j1939_session_deactivate_locked(). The free chain is
> j1939_session_deactivate_locked()->j1939_session_put()->__j1939_session_release()->j1939_session_destroy().
> To fix this bug, I moved j1939_session_put() behind
> j1939_session_deactivate_locked() and guarded it with a check of
> active since the session would be freed only if active is true.
> 
> Signed-off-by: Xiaochen Zou <xzou017@ucr.edu>
> 
> diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
> index e5f1a56994c6..b6448f29a4bd 100644
> --- a/net/can/j1939/transport.c
> +++ b/net/can/j1939/transport.c
> @@ -1018,7 +1018,6 @@ static bool
> j1939_session_deactivate_locked(struct j1939_session *session)
> 
>         list_del_init(&session->active_session_list_entry);
>         session->state = J1939_SESSION_DONE;
> -       j1939_session_put(session);
>     }
> 
>     return active;
> @@ -1031,6 +1030,9 @@ static bool j1939_session_deactivate(struct
> j1939_session *session)
>     j1939_session_list_lock(session->priv);
>     active = j1939_session_deactivate_locked(session);
>     j1939_session_list_unlock(session->priv);
> +   if (active) {
> +       j1939_session_put(session);
> +   }
> 
>     return active;
>  }
> @@ -2021,6 +2023,7 @@ void j1939_simple_recv(struct j1939_priv *priv,
> struct sk_buff *skb)
>  int j1939_cancel_active_session(struct j1939_priv *priv, struct sock *sk)
>  {
>     struct j1939_session *session, *saved;
> +   bool active;
> 
>     netdev_dbg(priv->ndev, "%s, sk: %p\n", __func__, sk);
>     j1939_session_list_lock(priv);
> @@ -2030,7 +2033,10 @@ int j1939_cancel_active_session(struct
> j1939_priv *priv, struct sock *sk)
>         if (!sk || sk == session->sk) {
>             j1939_session_timers_cancel(session);
>             session->err = ESHUTDOWN;
> -           j1939_session_deactivate_locked(session);
> +           active = j1939_session_deactivate_locked(session);
> +           if (active) {
> +               j1939_session_put(session);
> +           }
>         }
>     }
>     j1939_session_list_unlock(priv);
> 
> On Tue, Jul 13, 2021 at 12:35 AM Marc Kleine-Budde <mkl@pengutronix.de> wrote:
> >
> > On 7/13/21 9:30 AM, Xiaochen Zou wrote:
> > > j1939_session_destroy() will free both session and session->priv. It
> > > leads to multiple use-after-free read and write in
> > > j1939_session_deactivate() when session was freed in
> > > j1939_session_deactivate_locked(). The free chain is
> > > j1939_session_deactivate_locked()->
> > > j1939_session_put()->__j1939_session_release()->j1939_session_destroy().
> > > To fix this bug, I moved j1939_session_put() behind
> > > j1939_session_deactivate_locked() and guarded it with a check of
> > > active since the session would be freed only if active is true.
> >
> > Please include your Signed-off-by.
> > See
> > https://elixir.bootlin.com/linux/v5.12/source/Documentation/process/submitting-patches.rst#L356
> >
> > Marc
> >
> > --
> > Pengutronix e.K.                 | Marc Kleine-Budde           |
> > Embedded Linux                   | https://www.pengutronix.de  |
> > Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
> > Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |
> >
> 
> 

Hi,

This is the friendly patch-bot of Greg Kroah-Hartman.  You have sent him
a patch that has triggered this response.  He used to manually respond
to these common problems, but in order to save his sanity (he kept
writing the same thing over and over, yet to different people), I was
created.  Hopefully you will not take offence and will fix the problem
in your patch and resubmit it so that it can be accepted into the Linux
kernel tree.

You are receiving this message because of the following common error(s)
as indicated below:

- Your patch contains warnings and/or errors noticed by the
  scripts/checkpatch.pl tool.

- Your patch is malformed (tabs converted to spaces, linewrapped, etc.)
  and can not be applied.  Please read the file,
  Documentation/email-clients.txt in order to fix this.

- You did not specify a description of why the patch is needed, or
  possibly, any description at all, in the email body.  Please read the
  section entitled "The canonical patch format" in the kernel file,
  Documentation/SubmittingPatches for what is needed in order to
  properly describe the change.

- You did not write a descriptive Subject: for the patch, allowing Greg,
  and everyone else, to know what this patch is all about.  Please read
  the section entitled "The canonical patch format" in the kernel file,
  Documentation/SubmittingPatches for what a proper Subject: line should
  look like.

- This looks like a new version of a previously submitted patch, but you
  did not list below the --- line any changes from the previous version.
  Please read the section entitled "The canonical patch format" in the
  kernel file, Documentation/SubmittingPatches for what needs to be done
  here to properly describe this.

If you wish to discuss this problem further, or you have questions about
how to resolve this issue, please feel free to respond to this email and
Greg will reply once he has dug out from the pending patches received
from other developers.

thanks,

greg k-h's patch email bot
