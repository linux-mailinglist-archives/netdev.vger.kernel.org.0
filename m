Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38F3D2AF068
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 13:18:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbgKKMMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 07:12:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726430AbgKKMJc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 07:09:32 -0500
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 283BBC0613D1;
        Wed, 11 Nov 2020 04:09:15 -0800 (PST)
Received: by mail-pj1-x1041.google.com with SMTP id f12so609334pjp.4;
        Wed, 11 Nov 2020 04:09:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tfXm0jbzd6kaJ3w8XhI/Kny3PMYSPBXOoteaYSPbpNk=;
        b=pBSzBpVlpU6oXapfR7FR5dRmvCwgaFwrTogU1HOAswyHrDkDtI+h8xwYzC/xd6P3sK
         fDyoKce/SXhWJDLPAqKzuLenlARtExlbeDQyhcVYIL/tQ1Vnr3vfaSrat3S9HplpqqXF
         rrwErTh95CsKzw5s5zTcrXWSfF1dqyiRjSevH4z1S6ZyzOsxmuUf0PHMgd27Icwvhsdn
         JKmxS9/4U5LZ5SwOxNYjSBbMdRjYdQRikkmTKuvMZB170WUSjpU9MrAJVZwh9JfYWmeL
         TvHFeGbLEUC7ykbiGR1+W7NcNpIUaGrSvNDb3Wp6cW7yQjc/qMGOHKwqMfdERA2pIMt5
         bjFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tfXm0jbzd6kaJ3w8XhI/Kny3PMYSPBXOoteaYSPbpNk=;
        b=NwTlLnHk6By5yVGs+kZmIxqbl37eP8fKVw/Qkox5RRoNXFVvV68ri/vmSP+o4owTti
         PFLPL8o2gKHOHKQXzadoJ6XdLaHf+Y7dJx8dKw1ro/VlBvXA+ypjIBmsIzWwpBD8ZbUJ
         hHzXYeXeF6Qd0TkqAaGDCPsceYnrAy/s+b2jATKjPGAPM3e5yaX8kBm2HRp2X56A0D/E
         /Os1rdz0SlgH9jjT9ZGQAy6SWIMj3z7uESb8/qlDfUBBWVpJxNn1JRfDdqeM+rSXnhiU
         1tgmDzup7q/UOZes4gvyCLzyCCBiOXdb0BDWNjbZYpFsRYfICDJmzlrG2i9+XDQ0VX9i
         WXAw==
X-Gm-Message-State: AOAM530Qb0qMBxzVuGpHGPKZ44VhUctrImsaFN3FST8/nh2jWVwxQUdG
        PyPLYWsfmXh6LwSE00cetZaB+0E5rkXre5VfXTM=
X-Google-Smtp-Source: ABdhPJzznitHyf9aF+zWKbLeqBWLNlpjvSivU0ae9BAz34h+iLkhZH3wP7i3iSYtC56JjPlHZTzuRJFUjN05OB9Bugw=
X-Received: by 2002:a17:90a:4884:: with SMTP id b4mr3499145pjh.198.1605096554750;
 Wed, 11 Nov 2020 04:09:14 -0800 (PST)
MIME-Version: 1.0
References: <20201111100424.3989-1-xie.he.0141@gmail.com> <89483cb5fbf9e06edf3108fa4def6eef@dev.tdt.de>
In-Reply-To: <89483cb5fbf9e06edf3108fa4def6eef@dev.tdt.de>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Wed, 11 Nov 2020 04:09:03 -0800
Message-ID: <CAJht_ENQsGVdkzSgQ3C1wDXBJyo9i-xdtzS=hsmMM339RGNRqA@mail.gmail.com>
Subject: Re: [PATCH net] net: x25: Fix kernel crashes due to x25_disconnect
 releasing x25_neigh
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 11, 2020 at 3:41 AM Martin Schiller <ms@dev.tdt.de> wrote:
>
> > 1) When we receive a connection, the x25_rx_call_request function in
> > af_x25.c does not increase the refcount when it assigns the pointer.
> > When we disconnect, x25_disconnect is called and the struct's refcount
> > is decreased without being increased in the first place.
>
> Yes, this is a problem and should be fixed. As an alternative to your
> approach, you could also go the way to prevent the call of
> x25_neigh_put(nb) in x25_lapb_receive_frame() in case of a Call Request.
> However, this would require more effort.

Yes, right. I think my approach is easier.

> > This causes frequent kernel crashes when using AF_X25 sockets.
> >
> > 2) When we initiate a connection but the connection is refused by the
> > remote side, x25_disconnect is called which decreases the refcount and
> > resets the pointer to NULL. But the x25_connect function in af_x25.c,
> > which is waiting for the connection to be established, notices the
> > failure and then tries to decrease the refcount again, resulting in a
> > NULL-pointer-dereference error.
> >
> > This crashes the kernel every time a connection is refused by the
> > remote
> > side.
>
> For this bug I already sent a fix some time ago (last time I sent a
> RESEND yesterday), but unfortunately it was not merged yet:
> https://lore.kernel.org/patchwork/patch/1334917/

I see. Thanks! Hope it will be merged soon!

I'll re-submit my patch without your part after your patch is merged.
