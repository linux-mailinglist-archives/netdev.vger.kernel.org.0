Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F60F346F1A
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 02:55:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234670AbhCXBzI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 21:55:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231622AbhCXBzH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 21:55:07 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1487AC061763
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 18:55:07 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id u5so30257408ejn.8
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 18:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yFjH0eAyPR/kTBYsoqhWlZOOxSkrWBD+pPSqMnWTM2w=;
        b=DXrJbE/6WN2Zam1u0CJ4dxSlnDJklc47SufY+O9cqrl3HNdOYYDH25gH5ObenINAH1
         PJoRvD5dyIGt9JsoB84tJaq36qYH14+hIMBdQIlcu2MEZfQFXu5+7vUjG1QM8HlQhBRk
         TB6l4kJwOchRx82BQXadV3fqKg8N372HLF7/Zei6n2YQ84z23zt6H/SEs6hWB7GdneZt
         wfFe6fKuG0c4WBw1smOlZre0dWy41hg06cLBDDMaY4Cmnn0dm1CtiaeTTTLbNC84HvcX
         mULhIBUR2F+rXWUTBPeMWqKvDf9NckV6WiYsve7meqtUtEkoGWmrdM4AEMB0eWvlUOgA
         Nvag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yFjH0eAyPR/kTBYsoqhWlZOOxSkrWBD+pPSqMnWTM2w=;
        b=dQRadLPKBe4Ov2gex7eDx9ubhxXybgtmM8UJ0h16Jf6qTu0L1Ty150KYn4nGuk+9On
         N/AixUGn8yQFrH82Mk4r5HDWxKP9R1GP4vnMWnjIxTPL42jsdurRscMINgMmWPmxymou
         lPVnLI+b7xrfnbrS1JHC1qqwOh+YmN/AlnBIM9AjB9ewPZQCArf2Zv1bgWcVo5+/eptS
         Egb5UbtJLGMh+KGxjbKaSc6d2ag6NEefRoZ72v0YMPW/HlzDIq470dA6AOLMJyFcF2qM
         PpeIqVbBCKYREYby1Ql6N6oT5Gyk5X/I+VQidcT3gmi0bw9XUsFblQK0ZpjvpwC75X9L
         fOMA==
X-Gm-Message-State: AOAM533YQjfpuC84xgILkcJBBPPpHF1L+URM8u5XvvTwicIsgI7xOGg6
        xlooYCjqNynWpmVueuv/zK3j/y1e0qM=
X-Google-Smtp-Source: ABdhPJwugYECK5Fum+wdiHx3Nh04IPAxcph9clVvfGAM02s7aVOJBVGK1KvLLE3AdsqALevKV5niHw==
X-Received: by 2002:a17:906:2dda:: with SMTP id h26mr1080553eji.163.1616550905137;
        Tue, 23 Mar 2021 18:55:05 -0700 (PDT)
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com. [209.85.128.48])
        by smtp.gmail.com with ESMTPSA id lu26sm216472ejb.33.2021.03.23.18.55.04
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Mar 2021 18:55:04 -0700 (PDT)
Received: by mail-wm1-f48.google.com with SMTP id j20-20020a05600c1914b029010f31e15a7fso307293wmq.1
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 18:55:04 -0700 (PDT)
X-Received: by 2002:a05:600c:4150:: with SMTP id h16mr601021wmm.120.1616550903872;
 Tue, 23 Mar 2021 18:55:03 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1616345643.git.pabeni@redhat.com> <661b8bc7571c4619226fad9a00ca49352f43de45.1616345643.git.pabeni@redhat.com>
 <CA+FuTSc=V_=behQ0MKX3oYdDzZN=V7_CdeNOFXUAa-4TuU5ztA@mail.gmail.com> <efa5f117ad63064f7984655d46eb5140d23b0585.camel@redhat.com>
In-Reply-To: <efa5f117ad63064f7984655d46eb5140d23b0585.camel@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 23 Mar 2021 21:54:26 -0400
X-Gmail-Original-Message-ID: <CA+FuTScT9W5V-ak=Wq_7zswyDRo9rzjOK1SQNRxESBCL93BOVQ@mail.gmail.com>
Message-ID: <CA+FuTScT9W5V-ak=Wq_7zswyDRo9rzjOK1SQNRxESBCL93BOVQ@mail.gmail.com>
Subject: Re: [PATCH net-next 2/8] udp: skip fwd/list GRO for tunnel packets
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Alexander Lobakin <alobakin@pm.me>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > and there are
> > > udp tunnel available in the system, we could end-up doing L4
> > > aggregation for packets targeting the UDP tunnel.
> >
> > Is this specific to UDP tunnels, or can this also occur with others,
> > such as GRE? (not implying that this patchset needs to address those
> > at the same time)

I suppose GRE tunnels do not advertise GSO_UDP_L4 support, so GSO
packets would get segmented before entering the tunnel device.

Forwarded datagrams exceeding egress device MTU (whether tunnel or
not) is a wholly separate problem.

> I did not look at that before your suggestion. Thanks for pointing out.
>
> I think the problem is specific to UDP: when processing the outer UDP
> header that is potentially eligible for both NETIF_F_GSO_UDP_L4 and
> gro_receive aggregation and that is the root cause of the problem
> addressed here.

Can you elaborate on the exact problem? The commit mentions "inner
protocol corruption, as no overaly network parameters is taken in
account at aggregation time."

My understanding is that these are udp gro aggregated GSO_UDP_L4
packets forwarded to a udp tunnel device. They are not encapsulated
yet. Which overlay network parameters are not, but should have been,
taken account at aggregation time?

>
>
> > > Just skip the fwd GRO if this packet could land in an UDP
> > > tunnel.
> >
> > Could you make more clear that this does not skip UDP GRO, only
> > switches from fraglist-based to pure SKB_GSO_UDP_L4.
>
> Sure, I'll try to rewrite the commit message.
>
> Thanks!
>
> Paolo
>
