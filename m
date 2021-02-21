Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5B7320D17
	for <lists+netdev@lfdr.de>; Sun, 21 Feb 2021 20:15:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230223AbhBUTO2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Feb 2021 14:14:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbhBUTOZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Feb 2021 14:14:25 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BA21C061574;
        Sun, 21 Feb 2021 11:13:45 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id m6so5233145pfk.1;
        Sun, 21 Feb 2021 11:13:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9okeHahnxkQIyczL5QktCGq4Y0Vq91gH7S23ae5Xnxo=;
        b=ZVyvhv+PO5zERn53QqLCYhRDu/Jd831HCK2eVChketfdSpEZbSeL1z/aaPFo2vnvR+
         25NrSf2RBYEw/2jgb4TzsEuXAuu0CgdBWBjN6/FZbldIgnVbOryelwcts9SMGC2vXrcK
         nrEVbWyHLo6uUnSK8iUnIZ0qBiEKU7OkcysTCPwkxe4FZjdTyHw7514agzy/ZflykECN
         /K4zIxWGiNMo0ShlxNA1tnKhp+hJjjwVUsbfV3ozj3/iZ7l3MZBbTutwzg0dCEAjjXnL
         zixXdaV7BfjAZPNbYxmY9kiBshChyxJ0Vbn6VARZHR5TLWr8ZfVX6OTTMePxbFhNOnSr
         VzFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9okeHahnxkQIyczL5QktCGq4Y0Vq91gH7S23ae5Xnxo=;
        b=GwU45pWVDHxpBJQbTXEafiXMvWbcB6mXWDor05nKrRKBiNIPSxEqUVPeq52HQYOoC2
         2TtvhX3Bm11LO0KXXxK76l9eORFASCC0dbQBE6/1udaUfaELtrTaU0xA1FUEyT9a+x0T
         ujiK7dmc2LRHP5Jee7hYRdwsiO/sA1TArO8vCQQTISTz9t4tsrAm8u5mD0bvZ4aKZsY6
         bgn5kzuPED79iZgxAX7w6YIoeV7kp4ViuIIznZdonY+sVy1dLdvCZGbttsDKnwQpo548
         eUeMm5Koefrhe993GZUkQ+AlC5hUBtk4NJ6nw/m4YlOkfKBLlQHCq+yuWXZjfkmS6PSu
         rxeA==
X-Gm-Message-State: AOAM530+eqV5ZTK6WbZikV7y3OTHbVKeioQWYQbal55pdkuI+p7hkpKI
        iYzP5QpYmgFFQvmXx56ufxZRaehT125JDQ+J5ZA=
X-Google-Smtp-Source: ABdhPJwlEj7b5dtHO9WJKEVfnpgQJ3refQ75n3pGOhZHvQB6zRYMTGIwDLxZYVibZjwv3uNwrpLW2Bu5QHmXRaifhQI=
X-Received: by 2002:a65:56c6:: with SMTP id w6mr17014227pgs.368.1613934824969;
 Sun, 21 Feb 2021 11:13:44 -0800 (PST)
MIME-Version: 1.0
References: <20210216201813.60394-1-xie.he.0141@gmail.com> <YC4sB9OCl5mm3JAw@unreal>
 <CAJht_EN2ZO8r-dpou5M4kkg3o3J5mHvM7NdjS8nigRCGyih7mg@mail.gmail.com>
 <YC5DVTHHd6OOs459@unreal> <CAJht_EOhu+Wsv91yDS5dEt+YgSmGsBnkz=igeTLibenAgR=Tew@mail.gmail.com>
 <YC7GHgYfGmL2wVRR@unreal> <CAJht_EPZ7rVFd-XD6EQD2VJTDtmZZv0HuZvii+7=yhFgVz68VQ@mail.gmail.com>
 <CAJht_EPPMhB0JTtjWtMcGbRYNiZwJeMLWSC5hS6WhWuw5FgZtg@mail.gmail.com>
 <20210219103948.6644e61f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAJht_EOru3pW6AHN4QVjiaERpLSfg-0G0ZEaqU_hkhX1acv0HQ@mail.gmail.com> <YDIAIwLVQK0P4EQW@unreal>
In-Reply-To: <YDIAIwLVQK0P4EQW@unreal>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Sun, 21 Feb 2021 11:13:34 -0800
Message-ID: <CAJht_ENK=X1hXhM2qkwZW6xoFwMB5R+iS0GSnsXR3EERd+S35g@mail.gmail.com>
Subject: Re: [PATCH net-next RFC v4] net: hdlc_x25: Queue outgoing LAPB frames
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Martin Schiller <ms@dev.tdt.de>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 20, 2021 at 10:39 PM Leon Romanovsky <leon@kernel.org> wrote:
>
> > Yes, this patch will break backward compatibility. Users with old
> > scripts will find them no longer working.
>
> Did you search in debian/fedora code repositories to see if such scripts exist
> as part of any distro package?

I just tried to search in Debian and Fedora packages but didn't seem
to find anything related.

I searched "hdlc" and "x25". The only things I can find are "AX.25"
related things. But "AX.25" is not related to "X.25".

I guess a script that brings a network interface up might not be very
useful? So we might not be able to find it in public repositories.
