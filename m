Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97D4530808C
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 22:31:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231235AbhA1VaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 16:30:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbhA1VaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 16:30:16 -0500
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3160C061574
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 13:29:35 -0800 (PST)
Received: by mail-qv1-xf2d.google.com with SMTP id a1so3519820qvd.13
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 13:29:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zQGgkwhpITcjrOqTn/vx4bnPXtkJ1EjbDOZV0tUD93Q=;
        b=KJLZMkAp+o7UpFsKa0/38JB/Q9yGNVba0ydDwYrHmo5v2dhgT+nKCsGh9/7C5Skzol
         vQ4KI/WmTWecGG3fTxBidElNxrXqPHbhELZ0AdtyVfLq4K04dtz2wnFuo/rf/sSKc3by
         c0il6jmnQ6zcsA8egsOjRsVjQqR4v+Wct8NUjinvApYQKS3OBE0DioR2NV19CNBZECnT
         BVLhGwtYrkJZ5bsi0gmQvOWhZIF9ov0kvkygHFN6GS5nk9PHZMQHdt46aR883u3dwPhh
         YH/5o5VVU6EsJTaIx1NlH3dvlVDa66V2NCqQu87QoNK2S0DMkvOsZbGXSplm5mtIFDkY
         kuXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zQGgkwhpITcjrOqTn/vx4bnPXtkJ1EjbDOZV0tUD93Q=;
        b=e71nU/hlvn3oFpSXxwaqPCpoTs4vW4P7hr4PV7N88BKzjcUDyy4+TJ5MMNvX860sRa
         br1mND3sSojV10daP+2/SLiOvKFiJrrGoLl1DI01eBt1KmKJAEH2TmK6+I2gnoOEe4+H
         p6gaw5Q2Jg5tm39arP1VJmXu9vEkz7rr8a7qxziN9mw81wkdQx6dcznLQM7dCpdskZQX
         fmh/qHchvfpvy9V+pDD6fDQ792wJsQpTF0LnMAeYvy2BUOZwYOCO6E8nzt2iJJyblrze
         WSY55e3y4sZe8aOXpU0AILD2i+pbgTTWLy+z0/O/UfCMHK8e3T9J+E82Vp1Nx60hg0Bv
         aCiA==
X-Gm-Message-State: AOAM5307ldTVJON4ouSD8b1fxjEdfs5sKHmx8gur44N3qbezWHlCnAxS
        PQXjyE9kql/IK0Yn4vqqfWTDscrB9o19EuAQiLM=
X-Google-Smtp-Source: ABdhPJwafUqHZ62HeUV6i53mFwaqZS3u8Ly+Kzvm3sWMSTSQdDpLdtXSrfKcBbqLOQf1gzxlTJrDSDvnjkH5Z9G9iZE=
X-Received: by 2002:a0c:99c4:: with SMTP id y4mr1570699qve.9.1611869375260;
 Thu, 28 Jan 2021 13:29:35 -0800 (PST)
MIME-Version: 1.0
References: <20210123195916.2765481-1-jonas@norrbonn.se> <20210123195916.2765481-16-jonas@norrbonn.se>
 <bf6de363-8e32-aca0-1803-a041c0f55650@norrbonn.se> <YA8Cs3SD1zeR2JWz@nataraja>
In-Reply-To: <YA8Cs3SD1zeR2JWz@nataraja>
From:   Pravin Shelar <pravin.ovn@gmail.com>
Date:   Thu, 28 Jan 2021 13:29:24 -0800
Message-ID: <CAOrHB_Bk=2bgno_F1oN0zQjhVjPGDTQZU8MrXZ7eiKuVX=bMBw@mail.gmail.com>
Subject: Re: [RFC PATCH 15/16] gtp: add ability to send GTP controls headers
To:     Harald Welte <laforge@gnumonks.org>
Cc:     Jonas Bonn <jonas@norrbonn.se>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Pravin B Shelar <pbshelar@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 25, 2021 at 9:52 AM Harald Welte <laforge@gnumonks.org> wrote:
>
> Hi Jonas,
>

> On Sun, Jan 24, 2021 at 03:21:21PM +0100, Jonas Bonn wrote:
> > struct gtpu_metadata {
> >         __u8    ver;
> >         __u8    flags;
> >         __u8    type;
> > };
> >
> > Here ver is the version of the metadata structure itself, which is fine.
> > 'flags' corresponds to the 3 flag bits of GTP header's first byte:  E, S,
> > and PN.
> > 'type' corresponds to the 'message type' field of the GTP header.
>
> One more comment on the 'type': Of how much use is it?  After all, the
> GTP-U kernel driver only handles a single message type at all (G-PDU /
> 255 - the only message type that encapsulates user IP data), while all
> other message types are always processed in userland via the UDP socket.
>
There is NO userland UDP socket for the LWT tunnel. All UDP traffic is
terminated in kernel space. userland only sets rules over LTW tunnel
device to handle traffic. This is how OVS/eBPF handles other UDP based
LWT tunnel devices.


> Side-note: 3GPP TS 29.060 lists 5 other message types that can happen in
> GTP-U:
> * Echo Request
> * Echo Response
> * Error Indication
> * Supported Extension Headers Notification
> * End Marker
>
> It would be interesting to understand how the new flow-based tunnel would
> treat those, if those
>
Current code does handle Echo Request, Response and End marker.
