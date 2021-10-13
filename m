Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A17E042C5F5
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 18:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbhJMQQA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 12:16:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbhJMQP4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 12:15:56 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8FC2C061570
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 09:13:52 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id w14so12285431edv.11
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 09:13:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=+20wfNOs9hOT6qCz/aLseu9YYd8NAzqyZOFBmmz4X0M=;
        b=gHtPPrWff0Wftkh5q3PAWOxlVb2dSZRP47Dx9oGH5Wd/Mu3Hz1JMZsw3dhu7i5UWGI
         Xd/hl2CHNytVfYJIPNOwwAHgxCxjtWyA22UVkWyP5AkD75KDjv/T1KMGxal9Qr9zd5ro
         nLq5nISHMvNUMZ2UCviIfx52ve56gGjz8X/IGqys6YOV9tvUchHaOL/UAypNrKpHSRor
         g4z2NHN5WL2Qro9DcUgjYzxlesQy+O2xJ5uzPVW7ChKHe/upq0n4YDUY79d0cY7A5yx6
         4kKzX7qlyAJZRywQLXxf70+upZKAwwM5p/PKwSW00dmp+03vL0+/27/7XAoSVbejgyLu
         ug1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=+20wfNOs9hOT6qCz/aLseu9YYd8NAzqyZOFBmmz4X0M=;
        b=Bknx6jGmbQbSdSe6orMnyZ+7NH+pinPHQ171opEJugroqp4W/gKR33TZ4Mu+GI0dCV
         9tMseDEqvEfUYm60NzZlgft8wMcPGu76lNpIdA9vqSXOVa+UVeRDLcULFNX226XxarlH
         XzkdINaonOHJABxYEQtz8kAXuI0bIQyGrZq6yW3wP+X4nQwtaJOyeFQwREhDZiB5isXa
         Q28kTu+rHDXpoz433WGFzQ3V6G2qfY4UKncl09KXg34iU1fl0rfrS/4Axm6bTZHNCrcs
         xWap0vMtA50UmD3fwhLbXkgs2nrHtPgCc8Ac8NL1J8E/Ylasyll7n7wJDVhhfjU7niJ6
         kfcg==
X-Gm-Message-State: AOAM533385qBRGIKLZHhgC7kybvYZUBI+bfiSup/98Gbds7sHFnwL4RH
        9NTpipEpFVQtBpw+CZLO98E=
X-Google-Smtp-Source: ABdhPJy85pMmPQlZuGKqSWTDq3Eb6zC0Vl1dBy83S82AZoC9ygAbA1kzH+SHHmGbWPYR3VCHKGvrFw==
X-Received: by 2002:a05:6402:5209:: with SMTP id s9mr388858edd.250.1634141630197;
        Wed, 13 Oct 2021 09:13:50 -0700 (PDT)
Received: from ?IPv6:2a02:810d:9040:4c1f:e0b6:d0e7:64d2:f3a0? ([2a02:810d:9040:4c1f:e0b6:d0e7:64d2:f3a0])
        by smtp.gmail.com with ESMTPSA id y21sm24348ejk.30.2021.10.13.09.13.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 09:13:49 -0700 (PDT)
Message-ID: <2c7eb569aa7058cd8c0251c0e0894368f69cad62.camel@gmail.com>
Subject: Re: [PATCH] net: hsr: Add support for redbox supervision frames
From:   Andreas Oetken <ennoerlangen@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Murali Karicheri <m-karicheri2@ti.com>
Date:   Wed, 13 Oct 2021 18:13:48 +0200
In-Reply-To: <20211013085014.4beb11e4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20211013072951.1697003-1-andreas.oetken@siemens-energy.com>
         <20211013085014.4beb11e4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thank you Jakub for your notes.

Am Mittwoch, dem 13.10.2021 um 08:50 -0700 schrieb Jakub Kicinski:
> On Wed, 13 Oct 2021 09:29:51 +0200 Andreas Oetken wrote:
> > added support for the redbox supervision frames
> > as defined in the IEC-62439-3:2018.
> > 
> > Signed-off-by: Andreas Oetken <andreas.oetken@siemens-energy.com>
> 
> This does not apply to netdev/net-next.
Sorry, I will not include it next time.
> 
> > diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
> > index fdd9c00082a8..b1677b0a9202 100644
> > --- a/net/hsr/hsr_device.c
> > +++ b/net/hsr/hsr_device.c
> > @@ -511,9 +511,9 @@ static void send_hsr_supervision_frame(struct
> > hsr_port *master,
> >         }
> >         spin_unlock_irqrestore(&hsr->seqnr_lock, irqflags);
> >  
> > -       hsr_stag->HSR_TLV_type = type;
> > +       hsr_stag->tlv.HSR_TLV_type = type;
> >         /* TODO: Why 12 in HSRv0? */
> > -       hsr_stag->HSR_TLV_length = hsr->prot_version ?
> > +       hsr_stag->tlv.HSR_TLV_length = hsr->prot_version ?
> >                                 sizeof(struct hsr_sup_payload) :
> > 12;
> >  
> >         /* Payload: MacAddressA */
> > @@ -560,8 +560,8 @@ static void send_prp_supervision_frame(struct
> > hsr_port *master,
> >         spin_lock_irqsave(&master->hsr->seqnr_lock, irqflags);
> >         hsr_stag->sequence_nr = htons(hsr->sup_sequence_nr);
> >         hsr->sup_sequence_nr++;
> > -       hsr_stag->HSR_TLV_type = PRP_TLV_LIFE_CHECK_DD;
> > -       hsr_stag->HSR_TLV_length = sizeof(struct hsr_sup_payload);
> > +       hsr_stag->tlv.HSR_TLV_type = PRP_TLV_LIFE_CHECK_DD;
> > +       hsr_stag->tlv.HSR_TLV_length = sizeof(struct
> > hsr_sup_payload);
> >  
> >         /* Payload: MacAddressA */
> >         hsr_sp = skb_put(skb, sizeof(struct hsr_sup_payload));
> > diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
> > index d4d434b9f598..312d6a86c124 100644
> > --- a/net/hsr/hsr_forward.c
> > +++ b/net/hsr/hsr_forward.c
> > @@ -95,13 +95,13 @@ static bool is_supervision_frame(struct
> > hsr_priv *hsr, struct sk_buff *skb)
> >                         &((struct hsrv0_ethhdr_vlan_sp *)eth_hdr)-
> > >hsr_sup;
> >         }
> >  
> > -       if (hsr_sup_tag->HSR_TLV_type != HSR_TLV_ANNOUNCE &&
> > -           hsr_sup_tag->HSR_TLV_type != HSR_TLV_LIFE_CHECK &&
> > -           hsr_sup_tag->HSR_TLV_type != PRP_TLV_LIFE_CHECK_DD &&
> > -           hsr_sup_tag->HSR_TLV_type != PRP_TLV_LIFE_CHECK_DA)
> > +       if (hsr_sup_tag->tlv.HSR_TLV_type != HSR_TLV_ANNOUNCE &&
> > +           hsr_sup_tag->tlv.HSR_TLV_type != HSR_TLV_LIFE_CHECK &&
> > +           hsr_sup_tag->tlv.HSR_TLV_type != PRP_TLV_LIFE_CHECK_DD
> > &&
> > +           hsr_sup_tag->tlv.HSR_TLV_type != PRP_TLV_LIFE_CHECK_DA)
> >                 return false;
> > -       if (hsr_sup_tag->HSR_TLV_length != 12 &&
> > -           hsr_sup_tag->HSR_TLV_length != sizeof(struct
> > hsr_sup_payload))
> > +       if (hsr_sup_tag->tlv.HSR_TLV_length != 12 &&
> > +           hsr_sup_tag->tlv.HSR_TLV_length != sizeof(struct
> > hsr_sup_payload))
> >                 return false;
> >  
> >         return true;
> > diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c
> > index bb1351c38397..e7c6efbc41af 100644
> > --- a/net/hsr/hsr_framereg.c
> > +++ b/net/hsr/hsr_framereg.c
> > @@ -265,6 +265,7 @@ void hsr_handle_sup_frame(struct hsr_frame_info
> > *frame)
> >         struct hsr_port *port_rcv = frame->port_rcv;
> >         struct hsr_priv *hsr = port_rcv->hsr;
> >         struct hsr_sup_payload *hsr_sp;
> > +       struct hsr_sup_tlv *hsr_sup_tlv;
> >         struct hsr_node *node_real;
> >         struct sk_buff *skb = NULL;
> >         struct list_head *node_db;
> > @@ -312,6 +313,40 @@ void hsr_handle_sup_frame(struct
> > hsr_frame_info *frame)
> >                 /* Node has already been merged */
> >                 goto done;
> >  
> > +       /* Leave the first HSR sup payload. */
> > +       skb_pull(skb, sizeof(struct hsr_sup_payload));
> > +
> > +       /* Get second supervision tlv */
> > +       hsr_sup_tlv = (struct hsr_sup_tlv *)skb->data;
> > +       /* And check if it is a redbox mac TLV */
> > +       if (hsr_sup_tlv->HSR_TLV_type == PRP_TLV_REDBOX_MAC) {
> > +               /* We could stop here after pushing
> > hsr_sup_payload,
> > +                * or proceed and allow macaddress_B and for
> > redboxes.
> > +                */
> > +               /* Sanity check length */
> > +               if (hsr_sup_tlv->HSR_TLV_length != 6) {
> > +                       skb_push(skb, sizeof(struct
> > hsr_sup_payload));
> > +                       goto done;
> > +               }
> > +               /* Leave the second HSR sup tlv. */
> > +               skb_pull(skb, sizeof(struct hsr_sup_tlv));
> > +
> > +               /* Get redbox mac address. */
> > +               hsr_sp = (struct hsr_sup_payload *)skb->data;
> > +
> > +               /* Check if redbox mac and node mac are equal. */
> > +               if (!ether_addr_equal(node_real->macaddress_A,
> > hsr_sp->macaddress_A)) {
> > +                       /* This is a redbox supervision frame for a
> > VDAN! */
> > +                       /* Push second TLV and payload here */
> > +                       skb_push(skb, sizeof(struct
> > hsr_sup_payload) + sizeof(struct hsr_sup_tlv));
> > +                       goto done;
> > +               }
> > +               /* Push second TLV here */
> > +               skb_push(skb, sizeof(struct hsr_sup_tlv));
> > +       }
> > +       /* Push payload here */
> > +       skb_push(skb, sizeof(struct hsr_sup_payload));
> 
> Is this code path handling frames from the network or user space? 
> Does it need input checking?
This code path is handling frames from the network. The supervision
frames are broadcasted by each device. What type of additional input
checking are you thinking of? I think I should check skb->len before
pulling/accessing right?
> 
> >         ether_addr_copy(node_real->macaddress_B, ethhdr->h_source);
> >         for (i = 0; i < HSR_PT_PORTS; i++) {
> >                 if (!node_curr->time_in_stale[i] &&
> > diff --git a/net/hsr/hsr_main.h b/net/hsr/hsr_main.h
> > index bbaef001d55d..fc3bed792ba7 100644
> > --- a/net/hsr/hsr_main.h
> > +++ b/net/hsr/hsr_main.h
> > @@ -43,6 +43,8 @@
> >  #define PRP_TLV_LIFE_CHECK_DD             20
> >  /* PRP V1 life check for Duplicate Accept */
> >  #define PRP_TLV_LIFE_CHECK_DA             21
> > +/* PRP V1 life redundancy box MAC address */
> > +#define PRP_TLV_REDBOX_MAC                30
> >  
> >  /* HSR Tag.
> >   * As defined in IEC-62439-3:2010, the HSR tag is really {
> > ethertype = 0x88FB,
> > @@ -95,14 +97,18 @@ struct hsr_vlan_ethhdr {
> >         struct hsr_tag  hsr_tag;
> >  } __packed;
> >  
> > +struct hsr_sup_tlv {
> > +       __u8            HSR_TLV_type;
> > +       __u8            HSR_TLV_length;
> 
> u8, __u8 is for uAPI headers, which this is not.
Changed it.
> 
> > +} __packed;
> 
> There's no need to pack structs which only have members of size 1.
> 
Changed it too.

