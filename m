Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A32AF6BEE0C
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 17:25:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbjCQQZl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 12:25:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbjCQQZj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 12:25:39 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E096C794D;
        Fri, 17 Mar 2023 09:25:28 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id z83so6316742ybb.2;
        Fri, 17 Mar 2023 09:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679070328;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SrAOQPZoEB7zEpVd9cN2c1fSd+YidaZOoEAYNT9VB8I=;
        b=XSTNA4LZrgv45+gegASKf02hJBVZ1j0ElxJiZhoSwtTjGArgIslIOvYFT6etik9IcK
         JO5h2VxkZmuz2LrhxnpOMGpaTXR+hZVv/XfHRT3Be3n/HYjE5rkAsEii4zY++kMNAIdK
         +2SeiWp/PXqDkeWiI7k6GFsa+Fe97YnySuiuhWxGIx7/Ivy8IUSIbiXkJanfK9I7ADvj
         8gyHcvKnmtI3LEUAjH9YHKFVybisHdYwf9s5uNlu6XdujREEkLJc9fZ5YaFUkQwU6uac
         Mk+/831Zd0iEVg4lkia+JmKEqtnvSz5KQ11OuH8iwapPvGa79kQu1jaCtLpt0nDkKhil
         wtUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679070328;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SrAOQPZoEB7zEpVd9cN2c1fSd+YidaZOoEAYNT9VB8I=;
        b=XB7XL0yRY6mncmi+NBagobN6BHf2W38tNU5SoXEmcwT5Dmdsltwh4KU4Hq5g7yMvLm
         4zng7YautlZJtGSRDRPwZ1MOyrEQ0j4JAWITbxqL6jsQRWMbCu5i2Wq+50hKJv91qFXK
         38TGlaYNaqdjdqzURsu2jedrG3T8v2YIkW5kZnPTRnUTH/PIqSzI82sMDy5Ik3w7sGMy
         oFDucAkz4O8jEeGwbSAd0DfklVMNxFLZvaFiZZVcRy3LzCewJeqJGgs5+eN6LPJtmvj6
         xjzo6MkqWGFpmrBiwYJ23L2uBU4E/E5vzm7KTAB8o2jBghmGNlmSmNhNZtzd5OAUt1vK
         SGug==
X-Gm-Message-State: AO0yUKV66jigRY4PbkPWLaW58cwRwKVgBXyWdsRCJGeedYVU5+7UHwM5
        Pga0SxeAuo7cHEhyAOloiyrpVe13wPTK62DAUZ0=
X-Google-Smtp-Source: AK7set/jYs4HtWzOGFCy4Jtl4FhgmzzPjzc0hunDz2zEjxwz58ZFRb+FIy1k7vbSGR4dtUgTXNwak9Too7AKCg+mo14=
X-Received: by 2002:a05:6902:1101:b0:b47:5f4a:d5fc with SMTP id
 o1-20020a056902110100b00b475f4ad5fcmr116837ybu.9.1679070327576; Fri, 17 Mar
 2023 09:25:27 -0700 (PDT)
MIME-Version: 1.0
References: <20230317120815.321871-1-noltari@gmail.com> <ZBRcWLngOPY51qPc@localhost.localdomain>
In-Reply-To: <ZBRcWLngOPY51qPc@localhost.localdomain>
From:   =?UTF-8?B?w4FsdmFybyBGZXJuw6FuZGV6IFJvamFz?= <noltari@gmail.com>
Date:   Fri, 17 Mar 2023 17:25:16 +0100
Message-ID: <CAKR-sGdCD3i9_XpOAsc-uFXXy23FK1+UHj78KK5z99yUfD-V8A@mail.gmail.com>
Subject: Re: [PATCH] net: dsa: tag_brcm: legacy: fix daisy-chained switches
To:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, jonas.gorski@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

El vie, 17 mar 2023 a las 13:26, Michal Swiatkowski
(<michal.swiatkowski@linux.intel.com>) escribi=C3=B3:
>
> On Fri, Mar 17, 2023 at 01:08:15PM +0100, =C3=81lvaro Fern=C3=A1ndez Roja=
s wrote:
> > When BCM63xx internal switches are connected to switches with a 4-byte
> > Broadcom tag, it does not identify the packet as VLAN tagged, so it add=
s one
> > based on its PVID (which is likely 0).
> > Right now, the packet is received by the BCM63xx internal switch and th=
e 6-byte
> > tag is properly processed. The next step would to decode the correspond=
ing
> > 4-byte tag. However, the internal switch adds an invalid VLAN tag after=
 the
> > 6-byte tag and the 4-byte tag handling fails.
> > In order to fix this we need to remove the invalid VLAN tag after the 6=
-byte
> > tag before passing it to the 4-byte tag decoding.
> >
> > Signed-off-by: =C3=81lvaro Fern=C3=A1ndez Rojas <noltari@gmail.com>
> > ---
> >  net/dsa/tag_brcm.c | 10 ++++++++--
> >  1 file changed, 8 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/dsa/tag_brcm.c b/net/dsa/tag_brcm.c
> > index 10239daa5745..cacdafb41200 100644
> > --- a/net/dsa/tag_brcm.c
> > +++ b/net/dsa/tag_brcm.c
> > @@ -7,6 +7,7 @@
> >
> >  #include <linux/dsa/brcm.h>
> >  #include <linux/etherdevice.h>
> > +#include <linux/if_vlan.h>
> >  #include <linux/list.h>
> >  #include <linux/slab.h>
> >
> > @@ -252,6 +253,7 @@ static struct sk_buff *brcm_leg_tag_xmit(struct sk_=
buff *skb,
> >  static struct sk_buff *brcm_leg_tag_rcv(struct sk_buff *skb,
> >                                       struct net_device *dev)
> >  {
> > +     int len =3D BRCM_LEG_TAG_LEN;
> >       int source_port;
> >       u8 *brcm_tag;
> >
> > @@ -266,12 +268,16 @@ static struct sk_buff *brcm_leg_tag_rcv(struct sk=
_buff *skb,
> >       if (!skb->dev)
> >               return NULL;
> >
> > +     /* VLAN tag is added by BCM63xx internal switch */
> > +     if (netdev_uses_dsa(skb->dev))
> > +             len +=3D VLAN_HLEN;
> > +
> >       /* Remove Broadcom tag and update checksum */
> > -     skb_pull_rcsum(skb, BRCM_LEG_TAG_LEN);
> > +     skb_pull_rcsum(skb, len);
> >
> >       dsa_default_offload_fwd_mark(skb);
> >
> > -     dsa_strip_etype_header(skb, BRCM_LEG_TAG_LEN);
> > +     dsa_strip_etype_header(skb, len);
> >
> >       return skb;
> >  }
> LGTM, but You can add fixes tag.
> Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>

Thanks Michal, I will give time for others to review this before
sending v2 with the fixes tag.

>
> > --
> > 2.30.2
> >

--
=C3=81lvaro
