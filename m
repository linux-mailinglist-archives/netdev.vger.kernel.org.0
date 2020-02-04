Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A4EF1518BC
	for <lists+netdev@lfdr.de>; Tue,  4 Feb 2020 11:23:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbgBDKXJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Feb 2020 05:23:09 -0500
Received: from mail-yw1-f68.google.com ([209.85.161.68]:40793 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbgBDKXI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Feb 2020 05:23:08 -0500
Received: by mail-yw1-f68.google.com with SMTP id i126so17082701ywe.7;
        Tue, 04 Feb 2020 02:23:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ame2St7R2ib9vif6sJlaCy1rx6/8/ldNpQWNjiVIi50=;
        b=D6Kq8UrQHA9xagiQ1dY7lEia6G5YE4Oa2Rg7UnFzMqK0vr+To1KarbfKNmKas50AuY
         4U+jHn2nlq0iPPlcMj0yMkTPIHroMNaGHOhC+blQQC0I0n7kP6YUKPl8VCtwbtohwkw+
         dieNBWWI7+tjHrYLWgjQytvyGoUVRVadIWVjP82VUAaNd8LWpykcMNQx5LIwR4LRYUB5
         aM5aPdXMua4b0ReuN2GOX+KJ4yEh10RGs10jIvZzD8CYGY3LCV8P8DolE3yEWhGnWBAx
         b0XN0m99VC2f7QPnSy4Nku3kkkeK9Bo+zm8jMuJe/a4nqeiX53L40gqtKQw9xRGw+/Bz
         RhYQ==
X-Gm-Message-State: APjAAAXyiPkE6vlAzv+IbHWrgjvD2YDwpmHg8kyQpJRpNozHDo8bMZcd
        yK/V9N4U3iBslO0m31qCNn1Hof3uGip3y5Je2NX6MKK1
X-Google-Smtp-Source: APXvYqxX+4U5wGvE7gvRLyu6Gq9/3IKnaNmNNqa/K8kJSrDSXw/RBAUlqwVwu7MwXh9+vKQRs2abA0zuomrHCb4KZY8=
X-Received: by 2002:a81:910e:: with SMTP id i14mr4526623ywg.84.1580811786475;
 Tue, 04 Feb 2020 02:23:06 -0800 (PST)
MIME-Version: 1.0
References: <1580735882-7429-1-git-send-email-harini.katakam@xilinx.com>
 <1580735882-7429-2-git-send-email-harini.katakam@xilinx.com>
 <20200204.103718.1343105885567379294.davem@davemloft.net> <BN7PR02MB5121912B4AE8633C50D6DE98C9030@BN7PR02MB5121.namprd02.prod.outlook.com>
In-Reply-To: <BN7PR02MB5121912B4AE8633C50D6DE98C9030@BN7PR02MB5121.namprd02.prod.outlook.com>
From:   Harini Katakam <harinik@xilinx.com>
Date:   Tue, 4 Feb 2020 15:52:55 +0530
Message-ID: <CAFcVECKXp-s-vteTzmqSDCR0ajugiDK_tnBmacea5NA+Fu02Ng@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] net: macb: Remove unnecessary alignment check for TSO
To:     David Miller <davem@davemloft.net>
Cc:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Simek <michal.simek@xilinx.com>,
        Harini Katakam <harini.katakam@xilinx.com>,
        Harini Katakam <harinikatakamlinux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

> > -----Original Message-----
> > From: David Miller [mailto:davem@davemloft.net]
> > Sent: Tuesday, February 4, 2020 3:07 PM
> > To: Harini Katakam <harinik@xilinx.com>
> > Cc: nicolas.ferre@microchip.com; claudiu.beznea@microchip.com;
> > kuba@kernel.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> > Michal Simek <michals@xilinx.com>; harinikatakamlinux@gmail.com
> > Subject: Re: [PATCH v2 1/2] net: macb: Remove unnecessary alignment check
> > for TSO
> >
> > From: Harini Katakam <harini.katakam@xilinx.com>
> > Date: Mon,  3 Feb 2020 18:48:01 +0530
> >
> > > The IP TSO implementation does NOT require the length to be a multiple
> > > of 8. That is only a requirement for UFO as per IP documentation.
> > >
> > > Fixes: 1629dd4f763c ("cadence: Add LSO support.")
> > > Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
> > > ---
> > > v2:
> > > Added Fixes tag
> >
> > Several problems with this.
> >
> > The subject talks about alignemnt check, but you are not changing the alignment
> > check.  Instead you are modifying the linear buffer
> > check:

Thanks for the review. Everything below that line becomes unused
when alignment check is removed. More details below.

> >
> > > @@ -1792,7 +1792,7 @@ static netdev_features_t
> > macb_features_check(struct sk_buff *skb,
> > >     /* Validate LSO compatibility */
> > >
> > >     /* there is only one buffer */
> > > -   if (!skb_is_nonlinear(skb))
> > > +   if (!skb_is_nonlinear(skb) || (ip_hdr(skb)->protocol !=
> > > +IPPROTO_UDP))
> > >             return features;
> >
> > So either your explanation is wrong or the code change is wrong.

Alignment check is not required for TSO and is ONLY required for UFO.
So, if NOT(UDP), just return.

macb_features_check()
{
If existing linear check (or) if !UDP
    no need to change features, just return

Alignment check implementation which is only necessary for UDP.
}

> >
> > Furthermore, if you add this condition then there is now dead code below this.
> > The code that checks for example:
> >
> >       /* length of header */
> >       hdrlen = skb_transport_offset(skb);
> >       if (ip_hdr(skb)->protocol == IPPROTO_TCP)
> >               hdrlen += tcp_hdrlen(skb);
> >
> > will never trigger this IPPROTO_TCP condition after your change.

Yes, this is dead code now. I'll remove it.

> >
> > A lot of things about this patch do not add up.

Please let me know if you have any further concerns.

Regards,
Harini
