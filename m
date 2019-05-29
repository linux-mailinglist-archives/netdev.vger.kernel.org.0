Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD3962E637
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 22:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726192AbfE2Udp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 16:33:45 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:40864 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725990AbfE2Udo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 16:33:44 -0400
Received: by mail-ed1-f67.google.com with SMTP id r18so4611733edo.7;
        Wed, 29 May 2019 13:33:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S2fb3eOB2v37Ig/0VcUFboawuXP2h8U26aBhW6jgwSM=;
        b=pSOtfEZDFvuffJP4LTrkKxf3iCzvE7qPLy2aiYKLQwXx3ZzV8GnmpaQ3mPLRjV7szo
         3gyqGkrZZF94HFtChmQ9dQR5dFYLWEk1rRIq7bM29dsMEWUzEbI1MKVlvcSXHyUcUM4h
         B4lMLDpjsHCZ17nchpvMmoBhADdZIdRCyC1llO5//pHnLlIuQmdGQz2sCA7KugaHRvaz
         ui3lRLRX0nn2aIN3yN8dCSjB4aG/NR0I0QzOjXA3voVvkEqu/oo1OvXC98LSHAGBxx6o
         7V4ewQLNnucW3gtKaSwU9vu7xIHxk0vYiFKkQd5Z3j4AMON2zhLA8vrc0NGM4ZpurxrX
         IXDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S2fb3eOB2v37Ig/0VcUFboawuXP2h8U26aBhW6jgwSM=;
        b=Y2rrbp2bppiPq322gGI7Edh5o9W6YoDIujjh9ZmMknJXcJk65i5pZ9XVO4GaG7LIdT
         dq4xzb+LRinaKIy9pQjsI9PGdFd9x1c8jKYiiODV6BiomgJHm94Hu05ligKorX/FUlw/
         sh9lhelRgeSmctNzU1/dzAeSPHcbsDTtMV6icPCdIQO3aAZiqS4JCkv5wyv6Mbl2n2kz
         hQR6SAzGr3cOqEbws716PSYzKY5QuLtrpw2gp56ly/Zm5gvzgsq9A4T4Ih5Ff6ayccGI
         B0m3DU86L2XVbpdvI3oC1lrxs79AWW3D//tStiZ2XVR71Q3ga06xI5csEzEFp0lCNBWg
         nSLg==
X-Gm-Message-State: APjAAAWYTAE9MBGafE3IycJCLabU2xR4pOdVkyVFs/oP6YsrDG5imDXb
        /VNgl8EFcJJznmRUhTRjSiek+jhPPV5Rh5dFxiQ=
X-Google-Smtp-Source: APXvYqwkMHeR1MAaH87vh26R/pSrDfv84eLwPk3xyjxu2mGBLb89TfHWisnZ3uA9/hC1IBUGGS72/obS7C5gwuc5ZQo=
X-Received: by 2002:aa7:c402:: with SMTP id j2mr217119edq.165.1559162022656;
 Wed, 29 May 2019 13:33:42 -0700 (PDT)
MIME-Version: 1.0
References: <20190528235627.1315-1-olteanv@gmail.com> <20190528235627.1315-4-olteanv@gmail.com>
 <20190529044912.cyg44rqvdo73oeiu@localhost>
In-Reply-To: <20190529044912.cyg44rqvdo73oeiu@localhost>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 29 May 2019 23:33:31 +0300
Message-ID: <CA+h21hoNrhcpAONTvJra5Ekk+yJ6xP0VAaPSygaLOw31qsGPTg@mail.gmail.com>
Subject: Re: [PATCH net-next 3/5] net: dsa: mv88e6xxx: Let taggers specify a
 can_timestamp function
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 May 2019 at 07:49, Richard Cochran <richardcochran@gmail.com> wrote:
>
> On Wed, May 29, 2019 at 02:56:25AM +0300, Vladimir Oltean wrote:
> > The newly introduced function is called on both the RX and TX paths.
>
> NAK on this patch.
>
> > The boolean returned by port_txtstamp should only return false if the
> > driver tried to timestamp the skb but failed.
>
> So you say.
>
> > Currently there is some logic in the mv88e6xxx driver that determines
> > whether it should timestamp frames or not.
> >
> > This is wasteful, because if the decision is to not timestamp them, then
> > DSA will have cloned an skb and freed it immediately afterwards.
>
> No, it isn't wasteful.  Look at the tests in that driver to see why.
>
> > Additionally other drivers (sja1105) may have other hardware criteria
> > for timestamping frames on RX, and the default conditions for
> > timestamping a frame are too restrictive.
>
> I'm sorry, but we won't change the frame just for one device that has
> design issues.
>
> Please put device specific workarounds into its driver.
>
> Thanks,
> Richard

Hi Richard,

I removed this patch and my RX timestamping path still works, apparently.
It's just that now I'm not holding up in the RX timestamping queue
anything else except what the PTP classifier requested me to.
What I'm concerned about is that I'm using the skb->cb as a
communication space between the tagger waiting for the meta frame, and
the RX timestamping queue waiting to be notified that the meta frame
arrived.
If I'm not holding up all frames that I know will have a follow-up
come after them, then I'm letting them free up the stack, and who
knows whose skb->cb the tagger will overwrite.
By asking me to remove this patch you're basically asking the state
machine inside the tagger to guess whether the previous frame is one
that DSA cares about w.r.t. RX timestamping, and based on that info
write to its skb->cb or not.
I would like to avoid keeping meta frames in their own RX queue,
because then I'm complicating (or rather put, making impossible) the
association between a meta frame and the frame it holds a timestamp
of.

Regards,
-Vladimir
