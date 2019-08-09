Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83C5C88329
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 21:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbfHITNl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 15:13:41 -0400
Received: from mail-yw1-f68.google.com ([209.85.161.68]:40077 "EHLO
        mail-yw1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbfHITNl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 15:13:41 -0400
Received: by mail-yw1-f68.google.com with SMTP id b143so35940216ywb.7
        for <netdev@vger.kernel.org>; Fri, 09 Aug 2019 12:13:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JLtPEt3+bHkNMHbxaVgw+947t1+NJoqZYgN6iU5uxu8=;
        b=cElzG1cWdob26lhW5sM+YGkDGP/6coSvO9SZOmMthi0giEJZVGHdD3eTTlU2YmOTHX
         4SmJLrHdgGjsioN4BnSwk/MWnY3rVXx6a6ZMWTmdYhdwMd/InhF1g6g0dtIJfxB7UQc/
         ffKz3XeNlhIVkQo9wlpPmq2VQNfSZ0x/Jase82x3AWQ8VajNxvtDaGG2ElfyK4YScDrF
         92nuqJI81Tq8PpF6bjwXy0vnlMteyPYWfYmhc6Bj83/UmpZypBVhM8dimcBXWFlruXzE
         qIEPOmCE1DVriB9EBpKzfQ7/UZ+3Mmo1lqO/WYJkQMYZhc9wSdsNEpc/gYz1trDga5xR
         39jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JLtPEt3+bHkNMHbxaVgw+947t1+NJoqZYgN6iU5uxu8=;
        b=kW4kyX6Osj/sPPocklyfunCu5ZZCsiwKYqNPqk8B/FiMnGYwTO/C918YNtSVzz0BtV
         GtUEn/wL285sk9wKj3CXLTKhM+A8O4OcG7R9xRH0/K1pxlVL0fLd4WjAaYqqpoNHM0Wq
         e5X/WedrE9/ZSbHk7nBulmS7f2TX3QBB7NqwoOt5F7SNM11TOU8p5VGdg1jG8jZK/nkb
         m0srxnVUqzUN2LCWsrWhgvemIbnKcHKgTSfOLtg4mNOz7/3ekEqzUrlVnsjuHSstHNXq
         cVLMZk4MudqtuoiquUIyP2+3sYE3CXd2xot+L2LtUaHFx8oUmJbWT6iA8OsO8OTanFX5
         GJxQ==
X-Gm-Message-State: APjAAAUT2QgUPMYHhd0tNHYFFHpTYABTOHkd+5/BrIBqvdQ2Clmz17W9
        lsbvtiKkUasSbrOXTEgcPUAKim3o
X-Google-Smtp-Source: APXvYqyhM8eKCPdo6Osmhvkwplvzz0fRhpwBYTcNU37P83Xc2ERJbp+f9rAr79W7sTwctJ4uP9g8EQ==
X-Received: by 2002:a81:3d93:: with SMTP id k141mr5648143ywa.82.1565378019399;
        Fri, 09 Aug 2019 12:13:39 -0700 (PDT)
Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com. [209.85.219.170])
        by smtp.gmail.com with ESMTPSA id k18sm22198491ywh.37.2019.08.09.12.13.37
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Aug 2019 12:13:38 -0700 (PDT)
Received: by mail-yb1-f170.google.com with SMTP id q203so4914713ybg.11
        for <netdev@vger.kernel.org>; Fri, 09 Aug 2019 12:13:37 -0700 (PDT)
X-Received: by 2002:a25:7805:: with SMTP id t5mr7096396ybc.391.1565378017468;
 Fri, 09 Aug 2019 12:13:37 -0700 (PDT)
MIME-Version: 1.0
References: <1560381160-19584-1-git-send-email-jbaron@akamai.com>
 <CAKgT0Uej5CkBJpqsBnB61ozo2kAFKyAH8WY9KVbFQ67ZxPiDag@mail.gmail.com>
 <3af1e0da-8eb4-8462-3107-27917fec9286@akamai.com> <CAF=yD-+BMvToWvRwayTrxQBQ-Lgq7QVA6E+rGe3e5ic7rQ_gSg@mail.gmail.com>
 <f91fb37a-379a-4a59-7e04-cf8a6d161efa@akamai.com> <d5dea281-67c0-1385-95c1-b476825e6afa@akamai.com>
 <CAF=yD-+zYGzTTYC-oYr392qugWiYpbgykMh1p8UrrgZ2ciR=aw@mail.gmail.com> <314b4ae8-ef99-e7a4-cb95-87b7ea74427f@akamai.com>
In-Reply-To: <314b4ae8-ef99-e7a4-cb95-87b7ea74427f@akamai.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 9 Aug 2019 15:13:01 -0400
X-Gmail-Original-Message-ID: <CA+FuTSeSYBRJQKRSQB4SzOf8N_a-+DOiyoSUEvp4QR3-2mBvrA@mail.gmail.com>
Message-ID: <CA+FuTSeSYBRJQKRSQB4SzOf8N_a-+DOiyoSUEvp4QR3-2mBvrA@mail.gmail.com>
Subject: Re: [PATCH net-next] gso: enable udp gso for virtual devices
To:     Josh Hunt <johunt@akamai.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Jason Baron <jbaron@akamai.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 9, 2019 at 2:58 PM Josh Hunt <johunt@akamai.com> wrote:
>
> On 6/26/19 4:41 PM, Willem de Bruijn wrote:
> > On Wed, Jun 26, 2019 at 3:17 PM Jason Baron <jbaron@akamai.com> wrote:
> >>
> >>
> >>
> >> On 6/14/19 4:53 PM, Jason Baron wrote:
> >>>
> >>>
> >>> On 6/13/19 5:20 PM, Willem de Bruijn wrote:
> >>>>>>> @@ -237,6 +237,7 @@ static inline int find_next_netdev_feature(u64 feature, unsigned long start)
> >>>>>>>                                   NETIF_F_GSO_GRE_CSUM |                 \
> >>>>>>>                                   NETIF_F_GSO_IPXIP4 |                   \
> >>>>>>>                                   NETIF_F_GSO_IPXIP6 |                   \
> >>>>>>> +                                NETIF_F_GSO_UDP_L4 |                   \
> >>>>>>>                                   NETIF_F_GSO_UDP_TUNNEL |               \
> >>>>>>>                                   NETIF_F_GSO_UDP_TUNNEL_CSUM)
> >>>>>>
> >>>>>> Are you adding this to NETIF_F_GSO_ENCAP_ALL? Wouldn't it make more
> >>>>>> sense to add it to NETIF_F_GSO_SOFTWARE?
> >>>>>>
> >>>>>
> >>>>> Yes, I'm adding to NETIF_F_GSO_ENCAP_ALL (not very clear from the
> >>>>> context). I will fix the commit log.
> >>>>>
> >>>>> In: 83aa025 udp: add gso support to virtual devices, the support was
> >>>>> also added to NETIF_F_GSO_ENCAP_ALL (although subsequently reverted due
> >>>>> to UDP GRO not being in place), so I wonder what the reason was for that?
> >>>>
> >>>> That was probably just a bad choice on my part.
> >>>>
> >>>> It worked in practice, but if NETIF_F_GSO_SOFTWARE works the same
> >>>> without unexpected side effects, then I agree that it is the better choice.
> >>>>
> >>>> That choice does appear to change behavior when sending over tunnel
> >>>> devices. Might it send tunneled GSO packets over loopback?
> >>>>
> >>>>
> >>>
> >>> I set up a test case using fou tunneling through a bridge device using
> >>> the udpgso_bench_tx test where packets are not received correctly if
> >>> NETIF_F_GSO_UDP_L4 is added to NETIF_F_GSO_SOFTWARE. If I have it added
> >>> to NETIF_F_GSO_ENCAP_ALL, it does work correctly. So there are more
> >>> fixes required to include it in NETIF_F_GSO_SOFTWARE.
> >>>
> >>> The use-case I have only requires it to be in NETIF_F_GSO_ENCAP_ALL, but
> >>> if it needs to go in NETIF_F_GSO_SOFTWARE, I can look at what's required
> >>> more next week.
> >>>
> >>
> >> Hi,
> >>
> >> I haven't had a chance to investigate what goes wrong with including
> >> NETIF_F_GSO_UDP_L4 in NETIF_F_GSO_SOFTWARE - but I was just wondering if
> >> people are ok with NETIF_F_GSO_UDP_L4 being added to
> >> NETIF_F_GSO_ENCAP_ALL and not NETIF_F_GSO_SOFTWARE (ie the original
> >> patch as posted)?
> >>
> >> As I mentioned that is sufficient for my use-case, and its how Willem
> >> originally proposed this.
> >
> > Indeed, based on the previous discussion this sounds fine to me.
> >
>
> Willem
>
> Are you OK to ACK this? If not, is there something else you'd rather see
> here?

Sure. Unless Alex still has objections, feel free to resubmit with my Acked-by.
