Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 299DC296592
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 22:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S370500AbgJVUAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 16:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2895997AbgJVT76 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 15:59:58 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58148C0613CE;
        Thu, 22 Oct 2020 12:59:57 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id n9so1613543pgt.8;
        Thu, 22 Oct 2020 12:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NVYq2lxM8Jy8MOdpSgTfvMFC8iKFhaG2uSMStbk3rOM=;
        b=Ho5+J2YZQpzQybBSezYK/SjOO6x0QGV1hrD0ATojFVVP8FF2ZpnaaEM2CF6sbePY0w
         0d0Nu8qt2rAWEp80HKBqaBlRcUoCh6wRDuUh2UMX08txKc6a1xNTozKKBwMLgMCjHXy7
         C4QzhWngh7dcMyJ0xJ2dhwieq5jZrAh5gnDpqpRZwqQUBJdsJOA4JJ2Xp3UpVeX0deAg
         8wRZSAQHCaF+ryPr6tf9HRtcKNXS4RAQJhY8sD6S3W74NuPiol7IBykqNC7xIzFwNtDG
         LjgjcabC0q6Yy2M5jeo0Cixw14T9lvi7cjBTs57q8vZ615i2lcQ7UjRlEjaKSkPpuAeK
         mBiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NVYq2lxM8Jy8MOdpSgTfvMFC8iKFhaG2uSMStbk3rOM=;
        b=Rbc9m2CmOYpX23HyIJE2//G0cDni8ncPYRFtZ8NTa0//C3o+hZ2iq6QLzqQ1j/MgyQ
         VVlbWqwpP36yLicZIAIw10EPShyOthgeeqYe/qbfDSPOxUNMzuXp99qKlNONCQHxs76c
         oCO1M4gLpdyzjy9e4BRrTWY18PClu3euGndl9DHwS+NlTwezR2zEsYR/5Nl15iyerfHY
         WnCy9CAPty6mfpFNAd0foNQae2PunVH1nWvrMrHsyGmsqI3xHLl4t0fdqJq1MVO+t9mf
         J0cebeqL3mtj9W1+MCZR+NjsZNuouFL0WiHbgdgjwjhOi/vxDHERuXWqzy0wud3f02e5
         9OcA==
X-Gm-Message-State: AOAM530HbB5pezrQtVWLRPFdqa0lBmU68y8dQIwW4FdCM/+3YfIr01H1
        3XQVqYk5fBpxwwrVgogLKArS+tw0/6q7eEhIHMM=
X-Google-Smtp-Source: ABdhPJw8piBAPYmytYLQl19g1SSKv9sWzxuXax0G0rGPBeTLjPLOyTseYwLxr00lL4FORkf+Hc1/B6LSYS3kC1Efdmg=
X-Received: by 2002:a17:90a:17ad:: with SMTP id q42mr4015604pja.36.1603396796881;
 Thu, 22 Oct 2020 12:59:56 -0700 (PDT)
MIME-Version: 1.0
References: <20201022072814.91560-1-xie.he.0141@gmail.com> <CAJht_ENMQ3nZb1BOCyyVzJjBK87yk+E1p+Jv5UQuZ1+g1jK1cg@mail.gmail.com>
 <20201022082239.2ae23264@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201022082239.2ae23264@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Thu, 22 Oct 2020 12:59:45 -0700
Message-ID: <CAJht_EM638CQDb5opnVxfQ81Z2U9hGZbnE581RFZrAQvenn+qQ@mail.gmail.com>
Subject: Re: [PATCH net RFC] net: Clear IFF_TX_SKB_SHARING for all Ethernet
 devices using skb_padto
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Neil Horman <nhorman@tuxdriver.com>,
        John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 22, 2020 at 8:22 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Are most of these drivers using skb_padto()? Is that the reason they
> can't be sharing the SKB?

Yes, I think if a driver calls skb_pad / skb_padto / skb_put_padto /
eth_skb_pad, the driver can't accept shared skbs because it may modify
the skbs.

> I think the IFF_TX_SKB_SHARING flag is only used by pktgen, so perhaps
> we can make sure pktgen doesn't generate skbs < dev->min_mtu, and then
> the drivers won't pad?

Yes, I see a lot of drivers just want to pad the skb to ETH_ZLEN, or
just call eth_skb_pad. In this case, requiring the shared skb to be at
least dev->min_mtu long can solve the problem for these drivers.

But I also see some drivers that want to pad the skb to a strange
length, and don't set their special min_mtu to match this length. For
example:

drivers/net/ethernet/packetengines/yellowfin.c wants to pad the skb to
a dynamically calculated value.

drivers/net/ethernet/ti/cpsw.c, cpsw_new.c and tlan.c want to pad the
skb to macro defined values.

drivers/net/ethernet/intel/iavf/iavf_txrx.c wants to pad the skb to
IAVF_MIN_TX_LEN (17).

drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c wants to pad the skb to 17.

Another solution I can think of is to add a "skb_shared" check to
"__skb_pad", so that if __skb_pad encounters a shared skb, it just
returns an error. The driver would think this is a memory allocation
failure. This way we can ensure shared skbs are not modified.
