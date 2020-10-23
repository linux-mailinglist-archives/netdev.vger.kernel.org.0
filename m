Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2F9329685D
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 03:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S374432AbgJWB4n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 21:56:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S374423AbgJWB4n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 21:56:43 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3673DC0613CE;
        Thu, 22 Oct 2020 18:56:43 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id l18so2244996pgg.0;
        Thu, 22 Oct 2020 18:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zFM+4nnaZSlo5O/R3wHkkAVf1oITOU2dmLjS5HTiwfI=;
        b=u2eAq2Uy4SxgauReuM7ywpvJiXrFC3EpuNi2YafibDxIRmWPRqzK4s1PDkVkLWIkdY
         kma1OyMd7p4dL1Rcn7By3GtK5VFwF+N3rl3NkjYbPk0IdDWjNs9CSl85Cnb46GrJGHze
         JVYnrgdffHAq6o4DruxZiZfJq5rOO0cAoMeZB4G91H+RkB41CabARPlkYhiQFTy4pMlz
         PgCZKKTQm1so5ivJWVk6Bd5OT8vyq2FrKBgDFW7e9h3aXZgB6vgMPoMaTYMzKe57Cdsw
         TchnDsEewHob8fNyqeiMPtyOhmqv0tUhYWkxgRng3ylxxjU6hX8GzGV9yescBAyqmJgQ
         lFwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zFM+4nnaZSlo5O/R3wHkkAVf1oITOU2dmLjS5HTiwfI=;
        b=Huw9HEpjtqnKkgNP9XSfh/bQ3zk2W1IkABI262/6I94iaAEL4dIgqompyr+I37P4sF
         XiL8ru27a5JnE9MercLTFumgzJCO38H5ujBG0YlgZ4ynsvL+0Kxh/hMltvkSBJkBouKT
         JCn3Tc1AgZx/3K4ODDNNPrJ6NREjxV2QxC2P5JcHamWtJks5n4ljb8Ig/eMViikjbGfZ
         tCQlW5wYtPe64sq7EQBpc+DfYZTVDLCWi5LMqKn0HiuZKyIqo3p7Pkazj5lTvf2/bF/g
         2LQyWGzDgatrxjH7EjgPiI/x0eNzpfpO9xVfrKnCqTMpSrzKvfhLVTzAeuq61+mkz8zM
         oMSg==
X-Gm-Message-State: AOAM530mpOQ2cy6XDjzgndIyuC+HFYlvyuNAKITazywpkEYO/MeUir7U
        RPM/bhW5e8M+wwBGVD8VnmVVYXxU6kc1ttBCRQA=
X-Google-Smtp-Source: ABdhPJxw0iI+NoSS472/pVx4oHa6zISlxtXIJ2Snejgo1pH5uPPNkUHeBqxXis/lqEDMaK0CD/wl/HRN3xCWALqN9+s=
X-Received: by 2002:a17:90a:f685:: with SMTP id cl5mr219358pjb.210.1603418202645;
 Thu, 22 Oct 2020 18:56:42 -0700 (PDT)
MIME-Version: 1.0
References: <20201022072814.91560-1-xie.he.0141@gmail.com> <CAJht_ENMQ3nZb1BOCyyVzJjBK87yk+E1p+Jv5UQuZ1+g1jK1cg@mail.gmail.com>
 <20201022082239.2ae23264@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CAJht_EM638CQDb5opnVxfQ81Z2U9hGZbnE581RFZrAQvenn+qQ@mail.gmail.com> <20201022174451.1cd858ae@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201022174451.1cd858ae@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Thu, 22 Oct 2020 18:56:31 -0700
Message-ID: <CAJht_EOo50TxEUJmQMBBnaH4FW_2Afpcrr0pStFEXH1Bg3vteg@mail.gmail.com>
Subject: Re: [PATCH net RFC] net: Clear IFF_TX_SKB_SHARING for all Ethernet
 devices using skb_padto
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 22, 2020 at 5:44 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 22 Oct 2020 12:59:45 -0700 Xie He wrote:
> >
> > But I also see some drivers that want to pad the skb to a strange
> > length, and don't set their special min_mtu to match this length. For
> > example:
> >
> > drivers/net/ethernet/packetengines/yellowfin.c wants to pad the skb to
> > a dynamically calculated value.
> >
> > drivers/net/ethernet/ti/cpsw.c, cpsw_new.c and tlan.c want to pad the
> > skb to macro defined values.
> >
> > drivers/net/ethernet/intel/iavf/iavf_txrx.c wants to pad the skb to
> > IAVF_MIN_TX_LEN (17).
> >
> > drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c wants to pad the skb to 17.
>
> Hm, I see, that would be a slight loss of functionality if we started
> requiring 64B, for example, while the driver could in practice xmit
> 17B frames (would matter only to VFs, but nonetheless).

I think requiring the length to be at least some value won't solve the
problem for all drivers. For example:

drivers/net/ethernet/packetengines/yellowfin.c pads the skb to 32-byte
boundaries in the memory (no matter how long the length is).

drivers/net/ethernet/adaptec/starfire.c pads the skb so that the
length is multiples of 4.

drivers/net/ethernet/sun/cassini.c pads the skb to cp->min_frame_size,
which may be 255, 60, or 97.

> > Another solution I can think of is to add a "skb_shared" check to
> > "__skb_pad", so that if __skb_pad encounters a shared skb, it just
> > returns an error. The driver would think this is a memory allocation
> > failure. This way we can ensure shared skbs are not modified.
>
> I'm not sure if we want to be adding checks to __skb_pad() to handle
> what's effectively a pktgen specific condition.
>
> We could create a new field in struct netdevice for min_frame_len, but I
> think your patch is the simplest solution. Let's see if anyone objects.
>
> BTW it seems like there is more drivers which will need the flag
> cleared, e.g. drivers/net/ethernet/broadcom/bnxt/bnxt.c?

My patch isn't complete. Because there are so many drivers with this
problem, I feel it's hard to solve them all at once. So I only grepped
"skb_padto" under "drivers/net/ethernet". There are other drivers
under "ethernet" using "skb_pad", "skb_put_padto" or "eth_skb_pad".
There are also (fake) Ethernet drivers under "drivers/net/wireless". I
feel it'd take a long time and also be error-prone to solve them all,
so I feel it'd be the best if there are other solutions.
