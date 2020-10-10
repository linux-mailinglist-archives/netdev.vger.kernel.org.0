Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B81A828A3FD
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 01:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389355AbgJJWzd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:55:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732032AbgJJTj0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 15:39:26 -0400
Received: from mail-vk1-xa44.google.com (mail-vk1-xa44.google.com [IPv6:2607:f8b0:4864:20::a44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 012FEC08E89B
        for <netdev@vger.kernel.org>; Sat, 10 Oct 2020 09:52:09 -0700 (PDT)
Received: by mail-vk1-xa44.google.com with SMTP id n141so2859627vke.9
        for <netdev@vger.kernel.org>; Sat, 10 Oct 2020 09:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hdVxxm1zaSTMjre3qLL3XvCh4NLSOrtAUFykKyRWkUc=;
        b=A6drfJ/GSUCDboatp6G9NZ+NJpUZLuA+/uHB5y22Oht5nhWUjhbcPzMR+sXNePggJO
         /ownyJeuSpUQGi7/RorSaJ7tuRuBzdYm0FPaeT8ZhtD+H1yVp8HlO37rfLm9Qv9XGngC
         5ay1tPN3OF5tXFRn/O3k/2pMGFNNUnU1qb2bs60Y6LfxZQK86qUux03YakYzHXivQZja
         p3iS96RRPIONFfgPWb05qgArm8nxl0CxGkKzPrAo4bxjBl8Hpg3c+5E5ch0TVFWKtloK
         8+lY/KC1autZ/w4OSovpbPttJfttcv23Nsx10LkJFLCtsqpACWFsajxPVmNoX10YEAyr
         krUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hdVxxm1zaSTMjre3qLL3XvCh4NLSOrtAUFykKyRWkUc=;
        b=T1jCGWNa+EDsRg4rmbVntEymfKYdCzJGc6dkKiPdVO5mat8jYHyeuZX+Kq3TzlRq+w
         2woLkl0ayw8zFznQdYM2fTdW/LEAMm4Fch93PMbxAEi8n8Vj6XiMsReUP6AQroSHK4/g
         CsAWomzWwMJVXS+zG/pQIQca8ie35GDNASZjSfIf57p0+EhuINxSwDUbo6HF7pikGbWb
         JkkwhDSmS+gyC4sJ70axZidYWAkbpoxGsFsInGz1JrpiQuFpBE4e8qlUT/I3asLdtYkL
         cFKb/gtL5EjlnawnJrmVEr1Vx1NWNB0EghiLU5JY+67lqdoQL5Rl8FbsuwdJzDWytcYc
         +Yxw==
X-Gm-Message-State: AOAM530Hh5ZiZ5ze5Mz5U1ysPAjeuAIwOBrJnnrnRG4n6BNO3vMZ3Ion
        UigDjDAKwaZLMyEU3hplExmpPodq5Vw=
X-Google-Smtp-Source: ABdhPJyhv3QErKWYuU3qxB9AhntL9C5mtmO9nMSXsmZTn3eOa1jtihtx21oX0JTrqf5/K85cTaEBBw==
X-Received: by 2002:a1f:e905:: with SMTP id g5mr10246820vkh.17.1602348727508;
        Sat, 10 Oct 2020 09:52:07 -0700 (PDT)
Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com. [209.85.222.46])
        by smtp.gmail.com with ESMTPSA id q97sm1561513uaq.15.2020.10.10.09.52.06
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 10 Oct 2020 09:52:06 -0700 (PDT)
Received: by mail-ua1-f46.google.com with SMTP id f15so4105049uaq.9
        for <netdev@vger.kernel.org>; Sat, 10 Oct 2020 09:52:06 -0700 (PDT)
X-Received: by 2002:ab0:c11:: with SMTP id a17mr10246417uak.141.1602348725684;
 Sat, 10 Oct 2020 09:52:05 -0700 (PDT)
MIME-Version: 1.0
References: <20201008190538.6223-1-dwilder@us.ibm.com> <20201008190538.6223-3-dwilder@us.ibm.com>
 <CA+FuTSc8qw_U=nKR0tM06z99Es8JVKR0P6rQpR=Bkwj1eOtXCw@mail.gmail.com>
In-Reply-To: <CA+FuTSc8qw_U=nKR0tM06z99Es8JVKR0P6rQpR=Bkwj1eOtXCw@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sat, 10 Oct 2020 12:51:30 -0400
X-Gmail-Original-Message-ID: <CA+FuTSejypj6fvU3-b8V-kU6Xcwg7m4R3OO3Ry4kQK=87hNwvw@mail.gmail.com>
Message-ID: <CA+FuTSejypj6fvU3-b8V-kU6Xcwg7m4R3OO3Ry4kQK=87hNwvw@mail.gmail.com>
Subject: Re: [ PATCH v1 2/2] ibmveth: Identify ingress large send packets.
To:     David Wilder <dwilder@us.ibm.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        tlfalcon@linux.ibm.com, cris.forno@ibm.com,
        pradeeps@linux.vnet.ibm.com, wilder@us.ibm.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 10, 2020 at 12:40 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Thu, Oct 8, 2020 at 3:06 PM David Wilder <dwilder@us.ibm.com> wrote:
> >
> > Ingress large send packets are identified by either:
> > The IBMVETH_RXQ_LRG_PKT flag in the receive buffer
> > or with a -1 placed in the ip header checksum.
> > The method used depends on firmware version.
> >
> > Signed-off-by: David Wilder <dwilder@us.ibm.com>
> > Reviewed-by: Thomas Falcon <tlfalcon@linux.ibm.com>
> > Reviewed-by: Cristobal Forno <cris.forno@ibm.com>
> > Reviewed-by: Pradeep Satyanarayana <pradeeps@linux.vnet.ibm.com>
> > ---
> >  drivers/net/ethernet/ibm/ibmveth.c | 13 ++++++++++++-
> >  1 file changed, 12 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
> > index 3935a7e..e357cbe 100644
> > --- a/drivers/net/ethernet/ibm/ibmveth.c
> > +++ b/drivers/net/ethernet/ibm/ibmveth.c
> > @@ -1349,6 +1349,7 @@ static int ibmveth_poll(struct napi_struct *napi, int budget)
> >                         int offset = ibmveth_rxq_frame_offset(adapter);
> >                         int csum_good = ibmveth_rxq_csum_good(adapter);
> >                         int lrg_pkt = ibmveth_rxq_large_packet(adapter);
> > +                       __sum16 iph_check = 0;
> >
> >                         skb = ibmveth_rxq_get_buffer(adapter);
> >
> > @@ -1385,7 +1386,17 @@ static int ibmveth_poll(struct napi_struct *napi, int budget)
> >                         skb_put(skb, length);
> >                         skb->protocol = eth_type_trans(skb, netdev);
> >
> > -                       if (length > netdev->mtu + ETH_HLEN) {
> > +                       /* PHYP without PLSO support places a -1 in the ip
> > +                        * checksum for large send frames.
> > +                        */
> > +                       if (be16_to_cpu(skb->protocol) == ETH_P_IP) {
> > +                               struct iphdr *iph = (struct iphdr *)skb->data;
> > +
> > +                               iph_check = iph->check;
>
> Check against truncated/bad packets.

.. unless I missed context. Other code in this driver seems to peek in
the network and transport layer headers without additional geometry
and integrity checks, too.
