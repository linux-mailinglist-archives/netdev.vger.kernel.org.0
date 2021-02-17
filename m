Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAEAA31DE81
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 18:43:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234609AbhBQRmY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 12:42:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234641AbhBQRmF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Feb 2021 12:42:05 -0500
Received: from mail-oo1-xc2d.google.com (mail-oo1-xc2d.google.com [IPv6:2607:f8b0:4864:20::c2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A91EFC061756
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 09:41:25 -0800 (PST)
Received: by mail-oo1-xc2d.google.com with SMTP id h38so3240892ooi.8
        for <netdev@vger.kernel.org>; Wed, 17 Feb 2021 09:41:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LuHZ2b9znD0iI6Q0Vdwp7LYl7S9TiqrB4lwi0GXzjDo=;
        b=fLcURoWZI4K5ynBbVH+O5uGDZUYJObHubCaS7XnvfjH8TKBjdi9P6rpUYWg1E+J8vN
         1NTIOWXSd8f5D46nS9gsSYpU35a8+jn7cmItPt520boIg8zZYXrl2PlV843c69F939Op
         fNrLdBZswuHS3HZH9l+7aiGLbHln4H/rbKh3wkZLE5gNC2LO5VUjHPLmlgAYux5S+m8u
         CGJOZApXUQxPtfhSiIIAPAXDNQ4YPERS8CZ1mjTHi8903CZOdd4FAd4RkWuRF60+bBYJ
         fTTBH02Trzp5grhHJypTe8g7JoNOHgnR6cuhvLbpT/8+l1RH0SFyyUGeYNpjojcso+Oz
         9wIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LuHZ2b9znD0iI6Q0Vdwp7LYl7S9TiqrB4lwi0GXzjDo=;
        b=j3PLIFbaWlNQudJKvLTB+2RVsSmWO/qypd3AN4+rUuO0gipuytTcTCe4LSj+2bDxUg
         OFXSoCFA8asoyHXuLidZFGmSsHyhsmyOsn7DKGZr2OPr7f7oBcbPQEKl2MXH0KWgExjb
         OaEJ63teaPnM0rP2cQJokOCtNUBHFsV6fqhH6ZHHrlYowfotN3QxBVv7mcT8+x2jjXJC
         aq6aeNV8et+i6VUeyjOGCgPPKO6FZeHv3Shh9OwAhIWDvDKpg3xdFE5+1QaOTfzG2Kad
         rfvv8M8RsbITxIg6JnGeJ/HKcNteCGDQatkKrPi/LmMkLKEIlTA6ezxgqY2Evzzrm0+e
         IvBw==
X-Gm-Message-State: AOAM531rL7nO0h36ar2enoGP/DNWsb9hA6PaEDf9OEoA638b0w7hzN3+
        sf0DARiIUvU7xPcR8xOW0lJsU/jYozrbbhu/fhHIiwahJeTY
X-Google-Smtp-Source: ABdhPJwiYdjcUg0l1DwNhRBqG52mADF9Qzck8PjvcU+NniQChkbnwCofpvvoleh34DPAqOf+0CDjfSWYvKNIVdAEvxE=
X-Received: by 2002:a4a:2515:: with SMTP id g21mr121443ooa.27.1613583685035;
 Wed, 17 Feb 2021 09:41:25 -0800 (PST)
MIME-Version: 1.0
References: <69ec2fd1a9a048e8b3305a4bc36aad01@EXCH-SVR2013.eberle.local>
 <CAFSKS=MTUD_h0RFQ7R80ef-jT=0Zp1w5Ptt6r8+GkaboX3L_TA@mail.gmail.com>
 <11291f9b05764307b660049e2290dd10@EXCH-SVR2013.eberle.local>
 <CAFSKS=OiwGKqAvEZtxpOOabWbyN-dFA5YukAxBrtfk_fS+Lttg@mail.gmail.com> <e20bb1bd30e9465ea36d26b274b8b2b6@EXCH-SVR2013.eberle.local>
In-Reply-To: <e20bb1bd30e9465ea36d26b274b8b2b6@EXCH-SVR2013.eberle.local>
From:   George McCollister <george.mccollister@gmail.com>
Date:   Wed, 17 Feb 2021 11:41:13 -0600
Message-ID: <CAFSKS=Ncr-9s1Oi0GTqQ74sUaDjoHR-1P-yM+rNqjF-Hb+cPCA@mail.gmail.com>
Subject: Re: HSR/PRP sequence counter issue with Cisco Redbox
To:     "Wenzel, Marco" <Marco.Wenzel@a-eberle.de>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 17, 2021 at 7:14 AM Wenzel, Marco <Marco.Wenzel@a-eberle.de> wrote:
>
> On Mon, Feb 15, 2021 at 5:49 PM George McCollister <george.mccollister@gmail.com> wrote:
> >
> > On Mon, Feb 15, 2021 at 6:30 AM Wenzel, Marco <Marco.Wenzel@a-
> > eberle.de> wrote:
[snip]
>
> I was not so familiar with kernel patching until now and hope that this patch is correct now:

This process is rather confusing and I had trouble with it initially
(I'm still certainly not an expert). Looks like you have most of it
correct but you need to send the patch directly instead of embedding
it in another email. Otherwise it will be lost.
I use the git send-email command to send patches to the mailing list
but I'm sure there are other ways to do it as well. You may want to
run scripts/get_maintainer.pl and CC everyone reported as well.

Here are some more resources:
https://www.kernel.org/doc/html/v5.11/process/submitting-patches.html
https://www.kernel.org/doc/html/latest/networking/netdev-FAQ.html

>
>
> From 8836f1df35a884327da37885ff3ad8bfc5eb933c Mon Sep 17 00:00:00 2001
> From: Marco Wenzel <marco.wenzel@a-eberle.de>
> Date: Wed, 17 Feb 2021 13:53:31 +0100
> Subject: [PATCH] net: hsr: add support for EntryForgetTime
>
> In IEC 62439-3 EntryForgetTime is defined with a value of 400 ms. When a
> node does not send any frame within this time, the sequence number check
> for can be ignored. This solves communication issues with Cisco IE 2000
> in Redbox mode.
>
> Signed-off-by: Marco Wenzel <marco.wenzel@a-eberle.de>
> ---
>  net/hsr/hsr_framereg.c | 9 +++++++--
>  net/hsr/hsr_framereg.h | 1 +
>  net/hsr/hsr_main.h     | 1 +
>  3 files changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c
> index 5c97de459905..805f974923b9 100644
> --- a/net/hsr/hsr_framereg.c
> +++ b/net/hsr/hsr_framereg.c
> @@ -164,8 +164,10 @@ static struct hsr_node *hsr_add_node(struct hsr_priv *hsr,
>          * as initialization. (0 could trigger an spurious ring error warning).
>          */
>         now = jiffies;
> -       for (i = 0; i < HSR_PT_PORTS; i++)
> +       for (i = 0; i < HSR_PT_PORTS; i++) {
>                 new_node->time_in[i] = now;
> +               new_node->time_out[i] = now;
> +       }
>         for (i = 0; i < HSR_PT_PORTS; i++)
>                 new_node->seq_out[i] = seq_out;
>
> @@ -411,9 +413,12 @@ void hsr_register_frame_in(struct hsr_node *node, struct hsr_port *port,
>  int hsr_register_frame_out(struct hsr_port *port, struct hsr_node *node,
>                            u16 sequence_nr)
>  {
> -       if (seq_nr_before_or_eq(sequence_nr, node->seq_out[port->type]))
> +       if (seq_nr_before_or_eq(sequence_nr, node->seq_out[port->type]) &&
> +           time_is_after_jiffies(node->time_out[port->type] +
> +           msecs_to_jiffies(HSR_ENTRY_FORGET_TIME)))
>                 return 1;
>
> +       node->time_out[port->type] = jiffies;
>         node->seq_out[port->type] = sequence_nr;
>         return 0;
>  }
> diff --git a/net/hsr/hsr_framereg.h b/net/hsr/hsr_framereg.h
> index 86b43f539f2c..7a120ce3e3db 100644
> --- a/net/hsr/hsr_framereg.h
> +++ b/net/hsr/hsr_framereg.h
> @@ -75,6 +75,7 @@ struct hsr_node {
>         enum hsr_port_type      addr_B_port;
>         unsigned long           time_in[HSR_PT_PORTS];
>         bool                    time_in_stale[HSR_PT_PORTS];
> +       unsigned long     time_out[HSR_PT_PORTS];
>         /* if the node is a SAN */
>         bool                    san_a;
>         bool                    san_b;
> diff --git a/net/hsr/hsr_main.h b/net/hsr/hsr_main.h
> index 7dc92ce5a134..f79ca55d6986 100644
> --- a/net/hsr/hsr_main.h
> +++ b/net/hsr/hsr_main.h
> @@ -21,6 +21,7 @@
>  #define HSR_LIFE_CHECK_INTERVAL                 2000 /* ms */
>  #define HSR_NODE_FORGET_TIME           60000 /* ms */
>  #define HSR_ANNOUNCE_INTERVAL            100 /* ms */
> +#define HSR_ENTRY_FORGET_TIME            400 /* ms */
>
>  /* By how much may slave1 and slave2 timestamps of latest received frame from
>   * each node differ before we notify of communication problem?
> --
> 2.29.2
>
>
> Regards,
> Marco Wenzel
>
> >
> > Regards,
> > George McCollister
> >
> > >
> > > Regards,
> > > Marco Wenzel
> > >
> > > > >
> > > > > Thanks
> > > > > Marco Wenzel
> > > >
> > > > Regards,
> > > > George McCollister
