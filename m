Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80F6126178B
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 19:37:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730136AbgIHRhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 13:37:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731730AbgIHRfi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 13:35:38 -0400
Received: from mail-ua1-x942.google.com (mail-ua1-x942.google.com [IPv6:2607:f8b0:4864:20::942])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3671FC061755
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 10:35:38 -0700 (PDT)
Received: by mail-ua1-x942.google.com with SMTP id u14so5416uaq.1
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 10:35:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jGxIFib/r1AIVUzF+ck89MPfdIoxyJ1DlRxuo3IZNeQ=;
        b=NFJ5yExL7/3iQk83uUdYEh0bCvRb1MSngEDrzPI56Q9R9TU5wB44JoXh0X93C/OBPF
         +G6RTxSI6s4NdshRb0TQfbOnAMNtqbyhgCkNMtPY81TUvxP380mkbh7S3EcM44rzP+LC
         Oli4l27QuVi0RBnEg5H9F1NXjfK4SlQvmPzLKbYHwbnnHsaTl96d4q+7rg1HT2jLpKgL
         ZVeNNk5uron6dcUdmrg5YPJxIiuZz/6yba0xlDbdEJMlJJjonQsvlvkgUOoKAfajpOHU
         HMiH/IgF1BUM0h9bVsnKOdhtA5DiA+ivfpABT6AnhNgD8E9qEs+Iu4Mx0cIUDpEq6gT2
         cmug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jGxIFib/r1AIVUzF+ck89MPfdIoxyJ1DlRxuo3IZNeQ=;
        b=cPBcAMro5sUB1/mVUT3TXEDH3/nPTGdidvW5OsJuU5SwVDBmBLa16LysIOezyFpqvM
         oIRPT8zsE7Jnh6dWnoPIRFPdLQfXUBA7RneqINPV3eeyHUpaIy/vYOWUYAYnqdTNypjV
         1oFHamnpBPjY1+2izl/JHVL2iGf4SKX4p9++SXdu7AOtZr6PcUlOPI7oMdzUoFYagePT
         AXMNtSIzVr7PxHPSCR+97caULcdI5vSNFfnVDobte3lQnACI4NSjMR/va7ulHN39PjsR
         jI260tbSqRQTNqWeoyGeSzL6dHAEuBH4/UH5EuMz+LPRLVPDOspo+BHXb5oAvJoKgVyg
         R4hg==
X-Gm-Message-State: AOAM532hxdHned44FFYa1ssQcx+iAb2mLPfkALtWXX9zcxtvctTwMGsB
        UeN5GXZe1zYwYGIKmA6JNM9h6BBlvq/7sQ==
X-Google-Smtp-Source: ABdhPJwDooTw5KaAxETsKg1bS6Vnrqxys/DJO5Fcb3z9YEGzvclYn0Q7iCi85F96LF292licxaIfjQ==
X-Received: by 2002:ab0:2741:: with SMTP id c1mr165081uap.98.1599586536449;
        Tue, 08 Sep 2020 10:35:36 -0700 (PDT)
Received: from mail-vs1-f47.google.com (mail-vs1-f47.google.com. [209.85.217.47])
        by smtp.gmail.com with ESMTPSA id g138sm3059268vke.21.2020.09.08.10.35.35
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 10:35:35 -0700 (PDT)
Received: by mail-vs1-f47.google.com with SMTP id e23so3463909vsk.2
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 10:35:35 -0700 (PDT)
X-Received: by 2002:a67:f5d4:: with SMTP id t20mr176891vso.1.1599586534810;
 Tue, 08 Sep 2020 10:35:34 -0700 (PDT)
MIME-Version: 1.0
References: <20200901195415.4840-1-m-karicheri2@ti.com> <20200901195415.4840-2-m-karicheri2@ti.com>
 <CA+FuTScPZ5sfHBwbFKQza6w4G1UcO8DaqrcpFuSvr9svgMEepw@mail.gmail.com> <581a90d0-243e-f62e-1c2e-a9683807805c@ti.com>
In-Reply-To: <581a90d0-243e-f62e-1c2e-a9683807805c@ti.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 8 Sep 2020 19:34:56 +0200
X-Gmail-Original-Message-ID: <CA+FuTSdDqx8ZwmvLceygpxTDC9=S8=jqFRCTWFoW-6YwihXTUQ@mail.gmail.com>
Message-ID: <CA+FuTSdDqx8ZwmvLceygpxTDC9=S8=jqFRCTWFoW-6YwihXTUQ@mail.gmail.com>
Subject: Re: [PATCH net-next 1/1] net: hsr/prp: add vlan support
To:     Murali Karicheri <m-karicheri2@ti.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, nsekhar@ti.com,
        Grygorii Strashko <grygorii.strashko@ti.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 8, 2020 at 6:39 PM Murali Karicheri <m-karicheri2@ti.com> wrote:
>
> Hi Willem,
>
> Thanks for the response!
> On 9/4/20 11:45 AM, Willem de Bruijn wrote:
> > On Tue, Sep 1, 2020 at 9:54 PM Murali Karicheri <m-karicheri2@ti.com> wrote:
> >>
> >> This patch add support for creating vlan interfaces
> >> over hsr/prp interface.
> >>
> >> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
> >> ---
> >>   net/hsr/hsr_device.c  |  4 ----
> >>   net/hsr/hsr_forward.c | 16 +++++++++++++---
> >>   2 files changed, 13 insertions(+), 7 deletions(-)
> >>
> >> diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
> >> index ab953a1a0d6c..e1951579a3ad 100644
> >> --- a/net/hsr/hsr_device.c
> >> +++ b/net/hsr/hsr_device.c
> >> @@ -477,10 +477,6 @@ void hsr_dev_setup(struct net_device *dev)
> >>
> >>          /* Prevent recursive tx locking */
> >>          dev->features |= NETIF_F_LLTX;
> >> -       /* VLAN on top of HSR needs testing and probably some work on
> >> -        * hsr_header_create() etc.
> >> -        */
> >> -       dev->features |= NETIF_F_VLAN_CHALLENGED;
> >>          /* Not sure about this. Taken from bridge code. netdev_features.h says
> >>           * it means "Does not change network namespaces".
> >>           */
> >> diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
> >> index cadfccd7876e..de21df30b0d9 100644
> >> --- a/net/hsr/hsr_forward.c
> >> +++ b/net/hsr/hsr_forward.c
> >> @@ -208,6 +208,7 @@ static struct sk_buff *hsr_fill_tag(struct sk_buff *skb,
> >>                                      struct hsr_port *port, u8 proto_version)
> >>   {
> >>          struct hsr_ethhdr *hsr_ethhdr;
> >> +       unsigned char *pc;
> >>          int lsdu_size;
> >>
> >>          /* pad to minimum packet size which is 60 + 6 (HSR tag) */
> >> @@ -218,7 +219,18 @@ static struct sk_buff *hsr_fill_tag(struct sk_buff *skb,
> >>          if (frame->is_vlan)
> >>                  lsdu_size -= 4;
> >>
> >> -       hsr_ethhdr = (struct hsr_ethhdr *)skb_mac_header(skb);
> >> +       pc = skb_mac_header(skb);
> >> +       if (frame->is_vlan)
> >> +               /* This 4-byte shift (size of a vlan tag) does not
> >> +                * mean that the ethhdr starts there. But rather it
> >> +                * provides the proper environment for accessing
> >> +                * the fields, such as hsr_tag etc., just like
> >> +                * when the vlan tag is not there. This is because
> >> +                * the hsr tag is after the vlan tag.
> >> +                */
> >> +               hsr_ethhdr = (struct hsr_ethhdr *)(pc + VLAN_HLEN);
> >> +       else
> >> +               hsr_ethhdr = (struct hsr_ethhdr *)pc;
> >
> > Instead, I would pass the header from the caller, which knows the
> > offset because it moves the previous headers to make space.
> >
> So if I understood you correctly a diff for the above would like this
> where pass dst + movelen as  struct hsr_ethhdr *hsr_ethhdr
> pointer to hsr_fill_tag(), right?
>
> a0868495local@uda0868495:~/Projects/upstream-kernel$ git diff
> diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
> index de21df30b0d9..4d9192c8bcf8 100644
> --- a/net/hsr/hsr_forward.c
> +++ b/net/hsr/hsr_forward.c
> @@ -204,11 +204,10 @@ static void hsr_set_path_id(struct hsr_ethhdr
> *hsr_ethhdr,
>   }
>
>   static struct sk_buff *hsr_fill_tag(struct sk_buff *skb,
> +                                   struct hsr_ethhdr *hsr_ethhdr,
>                                      struct hsr_frame_info *frame,
>                                      struct hsr_port *port, u8
> proto_version)
>   {
> -       struct hsr_ethhdr *hsr_ethhdr;
> -       unsigned char *pc;
>          int lsdu_size;
>
>          /* pad to minimum packet size which is 60 + 6 (HSR tag) */
> @@ -219,19 +218,6 @@ static struct sk_buff *hsr_fill_tag(struct sk_buff
> *skb,
>          if (frame->is_vlan)
>                  lsdu_size -= 4;
>
> -       pc = skb_mac_header(skb);
> -       if (frame->is_vlan)
> -               /* This 4-byte shift (size of a vlan tag) does not
> -                * mean that the ethhdr starts there. But rather it
> -                * provides the proper environment for accessing
> -                * the fields, such as hsr_tag etc., just like
> -                * when the vlan tag is not there. This is because
> -                * the hsr tag is after the vlan tag.
> -                */
> -               hsr_ethhdr = (struct hsr_ethhdr *)(pc + VLAN_HLEN);
> -       else
> -               hsr_ethhdr = (struct hsr_ethhdr *)pc;
> -
>          hsr_set_path_id(hsr_ethhdr, port);
>          set_hsr_tag_LSDU_size(&hsr_ethhdr->hsr_tag, lsdu_size);
>          hsr_ethhdr->hsr_tag.sequence_nr = htons(frame->sequence_nr);
> @@ -280,10 +266,12 @@ struct sk_buff *hsr_create_tagged_frame(struct
> hsr_frame_info *frame,
>          memmove(dst, src, movelen);
>          skb_reset_mac_header(skb);
>
> -       /* skb_put_padto free skb on error and hsr_fill_tag returns NULL in
> -        * that case
> +       /* dst point to the start of hsr tag. So pass it to fill the
> +        * hsr info. Also skb_put_padto free skb on error and hsr_fill_tag
> +        * returns NULL in that case.
>           */
> -       return hsr_fill_tag(skb, frame, port, port->hsr->prot_version);
> +       return hsr_fill_tag(skb, (struct hsr_ethhdr *)(dst + movelen),
> +                           frame, port, port->hsr->prot_version);

It's a bit hard to see, since this is a draft patch on top of the
existing patch. But I think so.

Only, instead of dst + movelen, you can use src.

>   }
>
>
> > Also, supporting VLAN probably also requires supporting 802.1ad QinQ,
> > which means code should parse the headers instead of hardcoding
> > VLAN_HLEN.
> >
>
> iec-62439-3 standard only talks about VLAN (TPID 0x8100), not about
> QinQ. So what I could do is to check and bail out if 802.1ad frame is
> received at the interface from upper layer. Something like below and
> frame will get dropped.
>
> @@ -519,6 +507,8 @@ static int fill_frame_info(struct hsr_frame_info *frame,
>
>          if (proto == htons(ETH_P_8021Q))
>                  frame->is_vlan = true;
> +       else if (proto == htons(ETH_P_8021AD))
> +               return -1; /* Don't support 802.1ad */
>
>          if (frame->is_vlan) {
>                  vlan_hdr = (struct hsr_vlan_ethhdr *)ethhdr;
>
> What do you think?

It's good to err on the safe side. That should probably be a separate patch.
