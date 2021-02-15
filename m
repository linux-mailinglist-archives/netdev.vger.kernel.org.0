Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB6A31BFC3
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 17:52:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231476AbhBOQvp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 11:51:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231233AbhBOQth (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 11:49:37 -0500
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04948C0613D6
        for <netdev@vger.kernel.org>; Mon, 15 Feb 2021 08:48:55 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id u66so8317660oig.9
        for <netdev@vger.kernel.org>; Mon, 15 Feb 2021 08:48:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9ISFS+CccWmzM5pSYt37+e5T5HHN4o+41v7SjZ01tAk=;
        b=h1X9R8OSQ9bwZSVm+AfOLZ5/iVrKWpnWHqeNhO2CGsCaaXgbY17w3QX/vbTTodzH7J
         CkoP5BBmQPgxYwmouz3ZPrVn4O9QpwURUwKYVm5dV0jL0lWZpYurkrjBHdmbrmHsv0bb
         dPJjWG7abbg0YqA1EsnpqtuKwwOsP3TiJim5KKjmAGt7A41/OKUavATIcbNITI13eH8Y
         J0R1TnFQdMbla+NQkiVOEZU2jzBAhUWR5xhNc0+YlW3cep8G5ebrzcrkxq0Ip/3enREN
         NYyNkoP9yNJ8KiEuk9iWUwfcfXNx72QWALPsWGumZv94JkZixB8XftPFjKBdXAU3+178
         pSuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9ISFS+CccWmzM5pSYt37+e5T5HHN4o+41v7SjZ01tAk=;
        b=YCulpQ3laC7TjBPSp5jd62JX51kMPK8WamAHv9se3iLitY+vUO6/tA+wX1QihrevEy
         St81+2cXjHPRx0DNxzEAMB3XmpIKJITQmBsxXNC5KqJMKb/1fAl9upHVdznDb7j8NKjp
         pugGfRTMdMiGeOsOGfeg/i4V4lLJCCmALGiz897wy0oP3f+so8zHh7Q+I4gc1dq5TyZ1
         BxknZGTRkHEHJjWYdQ56t8IDgZUMdMDlEaRbmfjRbNFjXkpfhcugenAthDgE45iXFvlN
         Y5v/trVrXutAipcWlctF2Fa2mGwyk4qlXiv/qmzzWowW3zD1izxoYM+3XcDxq3Hj6d58
         HELg==
X-Gm-Message-State: AOAM532HcW78nFoO4vXDfSxPtmqxZ53tLH/EDnWuFNIuAb277R0AC9Ty
        VX/4/ckbI1J7B5GnG2++G0SNLZqg7NXWEGBbSGDZjWbs+3tC
X-Google-Smtp-Source: ABdhPJzLTNSKBY4zQVd32V+iep3DPIxW3MQf2jGf8NrofjUZGVvKj1zFlSMts9Jh3JC0uaAQxuI8T8BeKkSS7OWnEwY=
X-Received: by 2002:a05:6808:f09:: with SMTP id m9mr9051508oiw.92.1613407734419;
 Mon, 15 Feb 2021 08:48:54 -0800 (PST)
MIME-Version: 1.0
References: <69ec2fd1a9a048e8b3305a4bc36aad01@EXCH-SVR2013.eberle.local>
 <CAFSKS=MTUD_h0RFQ7R80ef-jT=0Zp1w5Ptt6r8+GkaboX3L_TA@mail.gmail.com> <11291f9b05764307b660049e2290dd10@EXCH-SVR2013.eberle.local>
In-Reply-To: <11291f9b05764307b660049e2290dd10@EXCH-SVR2013.eberle.local>
From:   George McCollister <george.mccollister@gmail.com>
Date:   Mon, 15 Feb 2021 10:48:41 -0600
Message-ID: <CAFSKS=OiwGKqAvEZtxpOOabWbyN-dFA5YukAxBrtfk_fS+Lttg@mail.gmail.com>
Subject: Re: HSR/PRP sequence counter issue with Cisco Redbox
To:     "Wenzel, Marco" <Marco.Wenzel@a-eberle.de>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 15, 2021 at 6:30 AM Wenzel, Marco <Marco.Wenzel@a-eberle.de> wr=
ote:
>
> > On Wed, Jan 27, 2021 at 6:32 AM Wenzel, Marco <Marco.Wenzel@a-
> > eberle.de> wrote:
> > >
> > > Hi,
> > >
> > > we have figured out an issue with the current PRP driver when trying =
to
> > communicate with Cisco IE 2000 industrial Ethernet switches in Redbox
> > mode. The Cisco always resets the HSR/PRP sequence counter to "1" at lo=
w
> > traffic (<=3D 1 frame in 400 ms). It can be reproduced by a simple ICMP=
 echo
> > request with 1 s interval between a Linux box running with PRP and a VD=
AN
> > behind the Cisco Redbox. The Linux box then always receives frames with
> > sequence counter "1" and drops them. The behavior is not configurable a=
t
> > the Cisco Redbox.
> > >
> > > I fixed it by ignoring sequence counters with value "1" at the sequen=
ce
> > counter check in hsr_register_frame_out ():
> > >
> > > diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c index
> > > 5c97de459905..630c238e81f0 100644
> > > --- a/net/hsr/hsr_framereg.c
> > > +++ b/net/hsr/hsr_framereg.c
> > > @@ -411,7 +411,7 @@ void hsr_register_frame_in(struct hsr_node *node,
> > > struct hsr_port *port,  int hsr_register_frame_out(struct hsr_port *p=
ort,
> > struct hsr_node *node,
> > >                            u16 sequence_nr)  {
> > > -       if (seq_nr_before_or_eq(sequence_nr, node->seq_out[port->type=
]))
> > > +       if (seq_nr_before_or_eq(sequence_nr,
> > > + node->seq_out[port->type]) && (sequence_nr !=3D 1))
> > >                 return 1;
> > >
> > >         node->seq_out[port->type] =3D sequence_nr;
> > >
> > >
> > > Do you think this could be a solution? Should this patch be officiall=
y applied
> > in order to avoid other users running into these communication issues?
> >
> > This isn't the correct way to solve the problem. IEC 62439-3 defines
> > EntryForgetTime as "Time after which an entry is removed from the dupli=
cate
> > table" with a value of 400ms and states devices should usually be confi=
gured
> > to keep entries in the table for a much shorter time. hsr_framereg.c ne=
eds to
> > be reworked to handle this according to the specification.
>
> Sorry for the delay but I did not have the time to take a closer look at =
the problem until now.
>
> My suggestion for the EntryForgetTime feature would be the following: A t=
ime_out element will be added to the hsr_node structure, which always store=
s the current time when entering hsr_register_frame_out(). If the last stor=
ed time is older than EntryForgetTime (400 ms) the sequence number check wi=
ll be ignored.
>
> diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c
> index 5c97de459905..a97bffbd2581 100644
> --- a/net/hsr/hsr_framereg.c
> +++ b/net/hsr/hsr_framereg.c
> @@ -164,8 +164,10 @@ static struct hsr_node *hsr_add_node(struct hsr_priv=
 *hsr,
>          * as initialization. (0 could trigger an spurious ring error war=
ning).
>          */
>         now =3D jiffies;
> -       for (i =3D 0; i < HSR_PT_PORTS; i++)
> +       for (i =3D 0; i < HSR_PT_PORTS; i++) {
>                 new_node->time_in[i] =3D now;
> +               new_node->time_out[i] =3D now;
> +       }
>         for (i =3D 0; i < HSR_PT_PORTS; i++)
>                 new_node->seq_out[i] =3D seq_out;
>
> @@ -411,9 +413,12 @@ void hsr_register_frame_in(struct hsr_node *node, st=
ruct hsr_port *port,
>  int hsr_register_frame_out(struct hsr_port *port, struct hsr_node *node,
>                            u16 sequence_nr)
>  {
> -       if (seq_nr_before_or_eq(sequence_nr, node->seq_out[port->type]))
> +       if (seq_nr_before_or_eq(sequence_nr, node->seq_out[port->type]) &=
&
> +                time_is_after_jiffies(node->time_out[port->type] + msecs=
_to_jiffies(HSR_ENTRY_FORGET_TIME))) {
>                 return 1;
> +       }
>
> +       node->time_out[port->type] =3D jiffies;
>         node->seq_out[port->type] =3D sequence_nr;
>         return 0;
>  }
> diff --git a/net/hsr/hsr_framereg.h b/net/hsr/hsr_framereg.h
> index 86b43f539f2c..d9628e7a5f05 100644
> --- a/net/hsr/hsr_framereg.h
> +++ b/net/hsr/hsr_framereg.h
> @@ -75,6 +75,7 @@ struct hsr_node {
>         enum hsr_port_type      addr_B_port;
>         unsigned long           time_in[HSR_PT_PORTS];
>         bool                    time_in_stale[HSR_PT_PORTS];
> +       unsigned long           time_out[HSR_PT_PORTS];
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
>  /* By how much may slave1 and slave2 timestamps of latest received frame=
 from
>   * each node differ before we notify of communication problem?
>
>
> This approach works fine with the Cisco IE 2000 and I think it implements=
 the correct way to handle sequence numbers as defined in IEC 62439-3.

Looks good to me. Can you send an official patch? If so I'll try it
out. Even if I can't replicate the Cisco situation I can try it with
my setups and make sure it doesn't break anything.

Regards,
George McCollister

>
> Regards,
> Marco Wenzel
>
> > >
> > > Thanks
> > > Marco Wenzel
> >
> > Regards,
> > George McCollister
