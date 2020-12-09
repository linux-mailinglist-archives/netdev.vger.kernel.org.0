Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C10EF2D377B
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 01:20:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730940AbgLIASR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 19:18:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730236AbgLIASQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 19:18:16 -0500
Received: from mail-vk1-xa42.google.com (mail-vk1-xa42.google.com [IPv6:2607:f8b0:4864:20::a42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 822C8C0613CF;
        Tue,  8 Dec 2020 16:17:36 -0800 (PST)
Received: by mail-vk1-xa42.google.com with SMTP id u67so131881vkb.5;
        Tue, 08 Dec 2020 16:17:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CvJ9oxgZGuLdmONciPenun/XEjnFDxPC4BpIda05bBA=;
        b=W+X9DvLZSrT92p0S/60Fxz7I4UCUxRtIeWddqYq0PB9oqbEDlPvHTDaUsamCpDWZl5
         K5NYg+1VZMUvg1I9aci1F/f/fxtspgegJBuxe2CSwkNBf7Q1dp7pnKlEcZKODgFU+6mH
         t2nFyAs/n3YQDY3fu2iS/tQOeaTW9oYHk/Bm3kF9DYsapYakN+7vkVuyUczmY467BXt0
         /WwUsGrdkGMaVc2zKbFPQ8lP9Li+IwFUinuxLe8LbETairUQJHuw33P7cJUaNwZmi91l
         0i7yL6Q6PWP/AX9+Dam5BXvLvSryv3o7cGFy1f+fA1BVS9yxEZCLbh/Cwoe3eTNhc6oQ
         V47w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CvJ9oxgZGuLdmONciPenun/XEjnFDxPC4BpIda05bBA=;
        b=h0TPrwpvw40t40PGXcuV+n/2rmb0tIlBnVWLRByNiiiRUeukOnhuVsxyyIDLopgYVB
         uM5wHiV+DqnXnL1OpxFOi73UvWRUBQCk93y6dZkKs7omsRwQjcYZhueSc8WCbj3TYDAH
         uvh8satJWy493TVs4z1YEeFSDFM9MeVY2SynhcL+6fKSAup154neX6Py4KyHzxdNpWih
         5ZKfI4pccL/JHikA7lpjQh9tTyUDYCPuCqTORuBoYQR1l38ZqrcD5IK9WiUXRfGx2vWj
         06+fFVEH7JJY+I3PUaEeUjwaQebXMNo7jkvM2ujyajwGrJ4F5ZF/dhkPednJ7Uly5EFS
         WOUQ==
X-Gm-Message-State: AOAM530EQ6S+8uGPK+PUgYjmqk1/iCgXdulFTZNBA3ZlVtito1ztTo4v
        X55j0O4jrjVFZVG5DOLUKoxhC4zBvYeVAzqY7/g=
X-Google-Smtp-Source: ABdhPJyMQ09LtgkLU2C4n7OXLJH58ZtfShUNwrGeDfKJMRzol1JpkGk6nE2WrxaoNXcsN7bJQXCKLsNmYow/Apbks4c=
X-Received: by 2002:a05:6122:69c:: with SMTP id n28mr398873vkq.21.1607473055679;
 Tue, 08 Dec 2020 16:17:35 -0800 (PST)
MIME-Version: 1.0
References: <20201206034408.31492-1-TheSven73@gmail.com> <20201208115035.74221c31@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <CAGngYiVpToas=offBuPgQ6t8wru64__NQ7MnNDYb0i0E+m6ebw@mail.gmail.com>
 <20201208152948.006606b3@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com> <CANn89iKxjQawkMBCg5Mt=eMgqvD_cpYSs4664GoGZFrMTgWJFw@mail.gmail.com>
In-Reply-To: <CANn89iKxjQawkMBCg5Mt=eMgqvD_cpYSs4664GoGZFrMTgWJFw@mail.gmail.com>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Tue, 8 Dec 2020 19:17:24 -0500
Message-ID: <CAGngYiXa+RS0tnu6VzVKgCJH8mqiY-9Q-f210D_i=J=NHHYBNw@mail.gmail.com>
Subject: Re: [PATCH net v1 1/2] lan743x: improve performance: fix
 rx_napi_poll/interrupt ping-pong
To:     Eric Dumazet <edumazet@google.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        David S Miller <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 8, 2020 at 6:50 PM Eric Dumazet <edumazet@google.com> wrote:
>
> Driver could be called with an arbitrary budget (of 64),
> and if its ring buffer has been depleted, return @budget instead of skb counts,
> and not ream the interrupt
>

Aha, so the decision to re-arm the interrupts is made by looking
at whether the device has run out of ring buffers to fill... instead
of checking whether the weight was reached !

That makes complete sense.
Thank you Eric and Jakub for your expert suggestions.
