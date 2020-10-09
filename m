Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07CA0288018
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 03:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730654AbgJIBs6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 21:48:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726499AbgJIBs6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 21:48:58 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CC9AC0613D2;
        Thu,  8 Oct 2020 18:48:58 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id n18so8567953wrs.5;
        Thu, 08 Oct 2020 18:48:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gnblYWXua1Ayl8hm3qLdli+NxT5jP4ZUCUbzVymdaII=;
        b=pFZrwF1JWdftRgWormmba7MTSCkHZ58OFAEhMU5+y/iojOBwkQSGpbZCgt2Kymg8av
         JudT02jPB1EBeUcEgXO7veO+U+AmtJNCpjb8gfwSYXHeuzKY7ktXASnFVXX+vyY9afXB
         WYN4RtytPp5z9s6YlcvCM+0ixoEbMoIbFzQZmRz08SsPfsW/EQs2kQVBjrBdR4hP5Kuj
         G2QEgDY64FmKaVs2bSIxNtem8ZLQrSh2h54LEDKlQhpjKAIoyZne2RIVamXlDgeTwZZ+
         uoJ0tQgM3f7NT1f1HhqD+0DUabXHJmc384IMouNdU0Hjo/74oppdck2O+jB/ht8t6d5i
         O+Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gnblYWXua1Ayl8hm3qLdli+NxT5jP4ZUCUbzVymdaII=;
        b=Cb3CvxNCCHSBKTpbg84cVf2upXqN78V0mN+W1BYoHxhGsxy05o8ZwZvSZZvE63ah+5
         UXarzigwR6BNaQbILZYeONQeYApj+vNKBwGJrOcbQKF8mQo4sFtcmKgmkmKHSO7ThpKJ
         n4E0/WrNGU6L5P3oloBR89CwinG0FA70/HQZ/ce5EX+h/iYC6b+5QuPt2KxUSbWE+xtz
         BssFNy+LUS49fr68WUPsx5naHJvt6hS7eEfxvYlxYX0Z4NL2Sp+xxxAj0nwEAEp0XTgx
         DWk0PCZ8D4+7Mg2i4wXRH5NoC0BV4a2WACfASfouf7IKbC0u5FQ57nU1DfUlzRob1+5H
         ysMQ==
X-Gm-Message-State: AOAM533VAA8FOOHwJqUroPw5eDa1Jjb9Gs4CMHk6XlQXRvOQbVq3HdBp
        9k64mYiZ1sg2S1Ue7ezmCcTZrM/+jwRCURud7Mo=
X-Google-Smtp-Source: ABdhPJzZqs0LQVMLqAx5zy/pMgkHs+q4mWKLirLAbXyVC7Y/U/APi4naOLPRQuLmfVu7brdh+kuBfW84Jgn8nXLH88M=
X-Received: by 2002:adf:ec06:: with SMTP id x6mr12003385wrn.404.1602208136803;
 Thu, 08 Oct 2020 18:48:56 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1602150362.git.lucien.xin@gmail.com> <052acb63198c44df41c5db17f8397eeb7c8bacfe.1602150362.git.lucien.xin@gmail.com>
 <c36b016ee429980b9585144f4f9af31bcda467ee.1602150362.git.lucien.xin@gmail.com>
 <CA+FuTScNHkYu2F2xPBjLj9ivfLRXVbTPypgjvtEZrebatpJJfQ@mail.gmail.com>
In-Reply-To: <CA+FuTScNHkYu2F2xPBjLj9ivfLRXVbTPypgjvtEZrebatpJJfQ@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Fri, 9 Oct 2020 09:48:45 +0800
Message-ID: <CADvbK_en7mePKdmMaLr9V8hTdmjf2bSVpSrid2CjharJtvD6YQ@mail.gmail.com>
Subject: Re: [PATCHv2 net-next 02/17] udp6: move the mss check after udp gso
 tunnel processing
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 8, 2020 at 8:45 PM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Thu, Oct 8, 2020 at 5:48 AM Xin Long <lucien.xin@gmail.com> wrote:
> >
> > For some protocol's gso, like SCTP, it's using GSO_BY_FRAGS for
> > gso_size. When using UDP to encapsulate its packet, it will
> > return error in udp6_ufo_fragment() as skb->len < gso_size,
> > and it will never go to the gso tunnel processing.
> >
> > So we should move this check after udp gso tunnel processing,
> > the same as udp4_ufo_fragment() does. While at it, also tidy
> > the variables up.
>
> Please don't mix a new feature and code cleanup.
Hi, Willem,

Tidying up variables are not worth a single patch, that's what I was
thinking. I can leave the variables as it is if you wish in this patch.

>
> This patch changes almost every line of the function due to
> indentation changes. But the only relevant part is
>
> "
>         mss = skb_shinfo(skb)->gso_size;
>         if (unlikely(skb->len <= mss))
>                 goto out;
>
>         if (skb->encapsulation && skb_shinfo(skb)->gso_type &
>             (SKB_GSO_UDP_TUNNEL|SKB_GSO_UDP_TUNNEL_CSUM))
>                 segs = skb_udp_tunnel_segment(skb, features, true);
>         else {
>                 /* irrelevant here */
>         }
>
> out:
>         return segs;
> }
> "
>
> Is it a sufficient change to just skip the mss check if mss == GSO_BY_FRAGS?
It is sufficient.

But I think we'd better keep the code here consistent with ipv4's if
there's no other reason to do 'skb->len <= mss' check at the first.

We can go with if-else as you showed above now, then do a cleanup in
the future. What do you think?
