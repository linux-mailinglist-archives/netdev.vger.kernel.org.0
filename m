Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A90F44B734C
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 17:43:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238767AbiBOPrd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 10:47:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240983AbiBOPrO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 10:47:14 -0500
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74E17BBE04
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 07:46:03 -0800 (PST)
Received: by mail-vs1-xe2d.google.com with SMTP id w4so4566448vsq.1
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 07:46:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BedxqyA3+r1aQxFPn5bMgkj70sSLNh7OJO9s5zLmB+g=;
        b=pS9E5M7E21dgGsY388BFHVXaAKwO4RSi+3GNyKpePpG3i3/VSPOaDNIH5KE1pGiK+E
         EcpJrr127komE34aJPyorPnQj9zlij5HTo1kogQW6DHZRo+grYjzFweW1HK4Il3zblRa
         jYkudAN3kN/oIpqt0XZl+YHkA9oi2yMEMtOwBzLr4KWrkGsH6Ae6xdVF9JF8Sac19VVa
         6sNQZFBLTSOJ4TXZXc7uGA2NxcIfOMWSeQzwUdi9l8q6BUvqrKa99joJ7b0pFsJt2Vml
         JI3g+gYxn/2caKC8oZEXlCnkjuHC/kltUBaoD9BBJ2mrqyVGTNmYZEgFTuUTm9tbzz2R
         znVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BedxqyA3+r1aQxFPn5bMgkj70sSLNh7OJO9s5zLmB+g=;
        b=77vjM2DtgW3Cpa4D57BmnXzPZjA7XF3IfkVE8mdeLrHMFhGSOkIjyF9XJYbKL1Qhsd
         +jg3lptZMUq/QaCkcU78/UjHvfEgC1iiK66XB8OfVACy1rdC56OMGi2jxk3KREnngmcg
         vvpYOxWzZK2l/ISXnAB+pMw5Fjbk7bx6USgN6L6XDq2xjlENBO7kfZ/jyQFLx7E8M2ff
         jOoRh5CriYz0N/aHLC6iaDzAsy2jkFJ1SbaZ05kA6HonvAMPQ/MIo0CI4kvE5h+Z8J30
         1vuvhcjq/CMGqPwcOiaCNnomxp4fy4CKa+sQ9Qc4qEEwlZ/y8wqR4+lvImcOJNJ/jogo
         7yvA==
X-Gm-Message-State: AOAM532TofQKT4Wdfb1oQbBJMEY80ncrhk9qSgKn9Q1G1BWhR6KmcJUJ
        IiAd7DP3oCG8sZhyBhrOPjae2oV7WwA=
X-Google-Smtp-Source: ABdhPJyOZ7OtNoaVEOTv0Oyb44HDHYpePC1d8M/X0XUlt3Cf9NlCiOGYragQV3TPWvozbWcIuhbaAg==
X-Received: by 2002:a67:d517:: with SMTP id l23mr1636046vsj.72.1644939962237;
        Tue, 15 Feb 2022 07:46:02 -0800 (PST)
Received: from mail-ua1-f42.google.com (mail-ua1-f42.google.com. [209.85.222.42])
        by smtp.gmail.com with ESMTPSA id w188sm192819vka.35.2022.02.15.07.46.01
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Feb 2022 07:46:01 -0800 (PST)
Received: by mail-ua1-f42.google.com with SMTP id 6so7394226uaq.7
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 07:46:01 -0800 (PST)
X-Received: by 2002:ab0:384c:: with SMTP id h12mr1480520uaw.122.1644939961027;
 Tue, 15 Feb 2022 07:46:01 -0800 (PST)
MIME-Version: 1.0
References: <20220213150234.31602-1-thomas.liu@ucloud.cn> <CA+FuTSdODATw3hSAMv9aZUmJNM8ZE-YP58pr17bO9rGJUgfegw@mail.gmail.com>
 <CFD9B65A-6762-4D9B-ADEB-B4C0B1902E02@ucloud.cn> <CA+FuTSfQOUEyEDnOU8VVZ=STw_ii-hTwyg-cvpcViPkVK4pLUA@mail.gmail.com>
 <42554FCB-9180-4B32-B5CF-6D3236237D99@ucloud.cn> <CAF=yD-+1RSj_o8n5LDOLVyn_dvVQvmDQo5pacSoDFPOR3M2g5g@mail.gmail.com>
 <CANn89i+T=Ny7pfUomSsa1ub77u8LfYtRZPzmp_0-=oWKt0abLg@mail.gmail.com>
In-Reply-To: <CANn89i+T=Ny7pfUomSsa1ub77u8LfYtRZPzmp_0-=oWKt0abLg@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 15 Feb 2022 10:45:24 -0500
X-Gmail-Original-Message-ID: <CA+FuTSc9ZeuLE7tqNT-GnqHb27SE7UAtVRVsZHR+dV6ua=UKPA@mail.gmail.com>
Message-ID: <CA+FuTSc9ZeuLE7tqNT-GnqHb27SE7UAtVRVsZHR+dV6ua=UKPA@mail.gmail.com>
Subject: Re: [PATCH] gso: do not skip outer ip header in case of ipip and net_failover
To:     Eric Dumazet <edumazet@google.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Tao Liu <thomas.liu@ucloud.cn>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Got it. That is an uncommon combination. SKB_GSO_DODGY is set from
> > external virtio_net, which does not support tunnels. But a path with
> > an added tunnel might cause this combination.
> >
> > And inet_gso_segment resets the network header, both times, before
> > calling callbacks.gso_segment()
> >
> >         skb_reset_network_header(skb);
> >         nhoff = skb_network_header(skb) - skb_mac_header(skb);
> >
> >         [...]
> >
> >         if (likely(ops && ops->callbacks.gso_segment))
> >                 segs = ops->callbacks.gso_segment(skb, features);
> >
> > And resets that after for each skb in segs.
> >
> >         skb = segs;
> >         do {
> >                 [...]
> >                 skb->network_header = (u8 *)iph - skb->head;
> >
> > But does not do this if segs == NULL.
> >
> > The packet has to be restored before it is passed to the device. I
> > think we have to handle this case correctly in inet_gso_segment,
> > instead of patching it up in all the various tunnel devices.
> >
> > The same holds for ipv6_gso_segment.
>
> Back in the days, GRO was modified so that we passed a context (nhoff)
> in called functions,
> instead of changing skb offsets. The concept of outer/inner header
> only works with 1 encap.
>
> Perhaps it is time to do the same in GSO, to allow arbitrary levels of
> encapsulation.
> Then we no longer mess with these limited
> 'network_header/inner_network_header' fields
> in the skb.
>
> Stuffing state in the skb has been a mistake I think.

If we could unwind those skb inner_* fields (and reclaim the skbuff
space!) that would be fantastic.

Immediately for this bug: perhaps it can be fixed by resetting the
network_header on the gso skb if segs == NULL. As the offset is stored
on the stack.
