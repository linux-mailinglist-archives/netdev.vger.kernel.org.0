Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AFC421E2EE
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 00:21:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbgGMWUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 18:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726742AbgGMWTw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 18:19:52 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A994C061755;
        Mon, 13 Jul 2020 15:19:52 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id k71so601713pje.0;
        Mon, 13 Jul 2020 15:19:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wlS+SrJ1At0Y30vYRvZttOy99z1jpaOiiIPmyhb9Ml4=;
        b=SZc0mePOLPkM8suKnl42aCZU8qbo1+nkeiK4zK/rppBg5PIKM2/oVqznAx/L5S9HGu
         f2Oy+1Ows+HGeq8g3ZfrMcp+vds2KCDZCxdibGJE0IPMfhk6us7P8OBJwXnVSBuBios2
         EtYw5FkGy7iBsR0yisc8uUNEBz0Ak+4nizxWnl91L6juu5qlwDYFKdQa82kdNPXa8Uqp
         oWLRLfHgFngnfWzfV9ftTfTTtxLZ+awdREZZRF1nQl3/omEy3MedgKvbqMLnOxAjf5E7
         BBn5YQ1gBF4o6eIc9JpVvZ1+L78TquyiKOOs+/E2+hHWJ8c0ZIi0nPjZEKmhQ38TBplC
         m2ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wlS+SrJ1At0Y30vYRvZttOy99z1jpaOiiIPmyhb9Ml4=;
        b=Bc1sjGmaxhjOy96meTxqNwsLSQQ64Mer2mBUA3t/LllK/VR9T0alRIJIqgTDzaoZwh
         zF2aoPC5cXATDywu4QfE6ZfLbSwitIfto5UkW+6J4CD0TI9qLhc9FT6hAoMzc2yy9cr3
         jKDbhnbzNUraKwwEjig/zh166Jk9Z2wxA/hB8E0ZLm76l7+o9+YMc9AtDE4ujp9D+AuN
         aYesJ3VwhiBPiaA7Os7auX7WQ0g7q0sVyqmqL6fm76pSGJwxz1ov5Sj+4Mx0aK5Qnqyx
         ewVix8uRYi1ETjFqGU04IBeLIf9xv1lDwHU0vqEkb5m/RZqxOQlMzy6xFg9eSmfwIBW/
         bAGw==
X-Gm-Message-State: AOAM533cTY0XgNkUADv9EpaV+r3cAJ2kf1QhBhezBBRzHz5sa8NQdEzc
        uNfIuAs+2xjKqvc/oTDM4TEKPg2rpbRlHdA9YCw=
X-Google-Smtp-Source: ABdhPJxbwLVlRvHK/+MG1x/6woHP7PD4EX7f2JQR/H7+5atQI2SfSgHpNem4GXmhzjnfxXNdySYlU7OLv5CHeGztG9c=
X-Received: by 2002:a17:90b:34c:: with SMTP id fh12mr1512876pjb.210.1594678791777;
 Mon, 13 Jul 2020 15:19:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200708043754.46554-1-xie.he.0141@gmail.com> <4b46b0f6-8424-5a6e-a4ae-3729f54c5d4b@gmail.com>
In-Reply-To: <4b46b0f6-8424-5a6e-a4ae-3729f54c5d4b@gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Mon, 13 Jul 2020 15:19:40 -0700
Message-ID: <CAJht_ENaDzwwtqupZf=pK4MBUsU1=OdXO=TRVn0a44YxC5U1SQ@mail.gmail.com>
Subject: Re: [PATCH] drivers/net/wan/x25_asy: Fix to make it work
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Shannon Nelson <snelson@pensando.io>,
        Martin Habets <mhabets@solarflare.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-x25@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 13, 2020 at 2:21 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> It is not clear to me what guarantee we have to have one byte of headroom in the skb
> at this point.
>
> You might add to be safe : (as done in lapbeth_data_indication(), but after the skb_push() which seems wrong)
>
>       if (skb_cow(skb, 1)) {
>             kfree_skb(skb); /* This line I am not sure, but looking at
>                              * lapb_data_indication() this might be needed.
>                              */
>             return NET_RX_DROP;
>       }
>
Thank you for your review, Eric!

The function "x25_asy_data_indication" is called by the "lapb" module
(net/lapb/). Before the "lapb" module calls this function, it has
removed from the skb an LAPB header which is at least 2 bytes (in the
function "lapb_decode"). So I thought there would always be a headroom
of one byte at this point.

But yes, it is always safer to add "skb_cow" at this point, so that it
is clearer the code would not crash here. I'll add it in the second
version of this patch. Thank you for your suggestion!

And yes, I agree that in "lapbeth_data_indication", the order of
"skb_push" and "skb_cow" is probably wrong. Let us submit another
patch to fix this problem!
