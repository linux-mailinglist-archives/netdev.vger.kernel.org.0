Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 375EC1266D6
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 17:29:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726818AbfLSQ3P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 11:29:15 -0500
Received: from mail-yb1-f194.google.com ([209.85.219.194]:36003 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726760AbfLSQ3P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 11:29:15 -0500
Received: by mail-yb1-f194.google.com with SMTP id w126so505540yba.3
        for <netdev@vger.kernel.org>; Thu, 19 Dec 2019 08:29:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vr42BB59XnCA8JXvubJU+a50MC4tt0ZdyQh504CEAKM=;
        b=jEjJLXFy1y21pT7awjS2Bnbgr72mB0jV7VGvFfVoV/Ktdjd1o2fBj28mwAuIPmgPMh
         msQhRrSIFPmXLdC6eeABiCazJ2xRxdzv2vF6urKdKJRrxpHvhoJ8KKwVgkhfr6u+cGli
         MiISaRJqcKR32rqte5HjUhNTSccrBcF8jNCbNb4comFbv6OjO0/Fc+KDcVK6/m0kP0bZ
         tEM8UfX2OMYmFrjYumpzaYpkvyZQ9zwj1f4wCecD7UKk75vUgIglFBRmxHhmN70IWID2
         ZcS8oYKHwRtyzSgRzxM/xWMhdtWr2MIU1BIkVP57UIPJ8sw4eRncvGh0vqS3HaSiPR3g
         H5lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vr42BB59XnCA8JXvubJU+a50MC4tt0ZdyQh504CEAKM=;
        b=lW5pc8y+NpHVihutTFFPTDOS2RGRQiGoluZPDTR4W5hkhagdqn53MwZi3myeTiXBQA
         QOLaqytWiHH5ycSDN68rHD/jpbHAzVxq+wHqTButXPQrYLbsh+MPlgj+bbV3t4P+I1+5
         S36CyiS4lwJjcyY2Ck89X/n3J3vz1iuvYJhMPU3aUb7Jsiu1ldWHPEYjMeUUUp13AoVK
         Wfxq8FOLdpNAPIWaScspXMoV3OQXINvqPVM9ZYRq7mOO9JhlEkpHuWHSNwpT+eTqvhoi
         6oxS+VNIuA69ZSfFwu/xETNXM6LskGZ2zpNsF/k3rY1CIMqUEahjB2bsAI5s2dpWYygC
         buoA==
X-Gm-Message-State: APjAAAUvVTWM7a1aXq7uzTUYmDBugKsh4hx85kKS+idgzvdQmCF+TvP2
        w6W2HSBzI1q+/izxKtPxIOLp1bli
X-Google-Smtp-Source: APXvYqwuTQX4itmrwLDVyDav0qLPbLNU7IIPZaxE068rykETL/YBcVDgEH6PJxb0Ae8eFfFzuQ+UOw==
X-Received: by 2002:a25:6c86:: with SMTP id h128mr7153139ybc.305.1576772953098;
        Thu, 19 Dec 2019 08:29:13 -0800 (PST)
Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com. [209.85.219.173])
        by smtp.gmail.com with ESMTPSA id z12sm2676017ywl.27.2019.12.19.08.29.11
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Dec 2019 08:29:12 -0800 (PST)
Received: by mail-yb1-f173.google.com with SMTP id a2so2396318ybr.7
        for <netdev@vger.kernel.org>; Thu, 19 Dec 2019 08:29:11 -0800 (PST)
X-Received: by 2002:a25:c444:: with SMTP id u65mr6802975ybf.443.1576772951233;
 Thu, 19 Dec 2019 08:29:11 -0800 (PST)
MIME-Version: 1.0
References: <20191218133458.14533-1-steffen.klassert@secunet.com>
 <20191218133458.14533-4-steffen.klassert@secunet.com> <CA+FuTScnux23Gj1WTEXHmZkiFG3RQsgmSz19TOWdWByM4Rd15Q@mail.gmail.com>
 <20191219082246.GS8621@gauss3.secunet.de>
In-Reply-To: <20191219082246.GS8621@gauss3.secunet.de>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 19 Dec 2019 11:28:34 -0500
X-Gmail-Original-Message-ID: <CA+FuTScKcwyh7rZdDNQsujndrA+ZnYMmtA7Uh7-ji+RM+t6-hQ@mail.gmail.com>
Message-ID: <CA+FuTScKcwyh7rZdDNQsujndrA+ZnYMmtA7Uh7-ji+RM+t6-hQ@mail.gmail.com>
Subject: Re: [PATCH net-next 3/4] net: Support GRO/GSO fraglist chaining.
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 19, 2019 at 3:22 AM Steffen Klassert
<steffen.klassert@secunet.com> wrote:
>
> On Wed, Dec 18, 2019 at 11:02:39AM -0500, Willem de Bruijn wrote:
> > On Wed, Dec 18, 2019 at 8:35 AM Steffen Klassert
> > <steffen.klassert@secunet.com> wrote:
> >
> > > +struct sk_buff *skb_segment_list(struct sk_buff *skb,
> > > +                                netdev_features_t features,
> > > +                                unsigned int offset)
> > > +{
> > > +       struct sk_buff *list_skb = skb_shinfo(skb)->frag_list;
> > > +       unsigned int tnl_hlen = skb_tnl_header_len(skb);
> > > +       unsigned int delta_truesize = 0;
> > > +       unsigned int delta_len = 0;
> > > +       struct sk_buff *tail = NULL;
> > > +       struct sk_buff *nskb;
> > > +
> > > +       skb_push(skb, -skb_network_offset(skb) + offset);
> > > +
> > > +       skb_shinfo(skb)->frag_list = NULL;
> > > +
> > > +       do {
> > > +               nskb = list_skb;
> > > +               list_skb = list_skb->next;
> > > +
> > > +               if (!tail)
> > > +                       skb->next = nskb;
> > > +               else
> > > +                       tail->next = nskb;
> > > +
> > > +               tail = nskb;
> > > +
> > > +               delta_len += nskb->len;
> > > +               delta_truesize += nskb->truesize;
> > > +
> > > +               skb_push(nskb, -skb_network_offset(nskb) + offset);
> > > +
> > > +               if (!secpath_exists(nskb))
> > > +                       __skb_ext_copy(nskb, skb);
> >
> > Of all the possible extensions, why is this only relevant to secpath?
>
> I wrote this before we had these extensions and adjusted it
> when the extensions where introduced to make it compile again.
> I think we can just copy the extensions unconditionally.
>
> >
> > More in general, this function open codes a variety of skb fields that
> > carry over from skb to nskb. How did you select this subset of fields?
>
> I tried to find the subset of __copy_skb_header() that is needed to copy.
> Some fields of nskb are still valid, and some (csum related) fields
> should not be copied from skb to nskb.

Duplicating that code is kind of fragile wrt new fields being added to
skbs later (such as the recent skb_ext example).

Perhaps we can split __copy_skb_header further and call the
inner part directly.

Or, at least follow the order of operations exactly and add a comment
that this code was taken verbatim from __copy_skb_header.

> > > +
> > > +               memcpy(nskb->cb, skb->cb, sizeof(skb->cb));
> > > +
> > > +               nskb->tstamp = skb->tstamp;
> > > +               nskb->dev = skb->dev;
> > > +               nskb->queue_mapping = skb->queue_mapping;
> > > +
> > > +               nskb->mac_len = skb->mac_len;
> > > +               nskb->mac_header = skb->mac_header;
> > > +               nskb->transport_header = skb->transport_header;
> > > +               nskb->network_header = skb->network_header;
> > > +               skb_dst_copy(nskb, skb);
> > > +
> > > +               skb_headers_offset_update(nskb, skb_headroom(nskb) - skb_headroom(skb));
> > > +               skb_copy_from_linear_data_offset(skb, -tnl_hlen,
> > > +                                                nskb->data - tnl_hlen,
> > > +                                                offset + tnl_hlen);
> > > +
> > > +               if (skb_needs_linearize(nskb, features) &&
> > > +                   __skb_linearize(nskb))
> > > +                       goto err_linearize;
> > > +
> > > +       } while (list_skb);
> > > +
> > > +       skb->truesize = skb->truesize - delta_truesize;
> > > +       skb->data_len = skb->data_len - delta_len;
> > > +       skb->len = skb->len - delta_len;
> > > +       skb->ip_summed = nskb->ip_summed;
> > > +       skb->csum_level = nskb->csum_level;
> >
> > This changed from the previous version, where nskb inherited ip_summed
> > and csum_level from skb. Why is that?
>
> I had to set ip_summed to CHECKSUM_UNNECESSARY on GRO to
> make sure the noone touches the checksum of the head
> skb. Otherise netfilter etc. tries to touch the csum.
>
> Before chaining I make sure that ip_summed and csum_level is
> the same for all chained skbs and here I restore the original
> value from nskb.

This is safe because the skb_gro_checksum_validate will have validated
already on CHECKSUM_PARTIAL? What happens if there is decap or encap
in the path? We cannot revert to CHECKSUM_PARTIAL after that, I
imagine.

Either way, would you mind briefly documenting the checksum behavior
in the commit message? It's not trivial and I doubt I'll recall the
details in six months.

Really about patch 4: that squashed in a lot of non-trivial scaffolding
from previous patch 'UDP: enable GRO by default'. Does it make sense
to keep that in a separate patch? That should be a noop, which we can
verify. And it makes patch 4 easier to reason about on its own, too.
