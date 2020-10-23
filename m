Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0FA297540
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 18:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S375940AbgJWQvk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 12:51:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752835AbgJWQvS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 12:51:18 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E25EBC0613CE
        for <netdev@vger.kernel.org>; Fri, 23 Oct 2020 09:51:17 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id n6so2538808ioc.12
        for <netdev@vger.kernel.org>; Fri, 23 Oct 2020 09:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DmFI4CxVV7TudqMTviEtcNfGxb5h9F5Q2IKtouYB1hE=;
        b=LlEXD4kLLiSoxBpI240zn1UfC62F49ZtKjMvF7CB1GROCq0qmKooibsDhIvGz6T+zn
         ngUdE1T1VPuBbRSV6FN9EbPP5YCrueaZXLSZjxWWWO5fi/5v5QJlJZ2xdbx3cKeFT+Sf
         Lx3p6yf6euF32EFur+ZK8MY/7pb0qhd6GO0zGx0qjH7H6w663MSiiTtgPKxqrp/xsIN1
         y4wrsfeLtnZuGcQisWiNSuhVqL/rynqfVT8IqlxVD4bF+2gCRaef89YfKB8Zf+1+54HI
         Kld3Uqyg56crCtv+Q7aLeUcIGooWEQb3ZqsDCYqKU3iokdXYffcjIORoIBve8dyAxDsd
         TwZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DmFI4CxVV7TudqMTviEtcNfGxb5h9F5Q2IKtouYB1hE=;
        b=P1vl5u44FXA64qYRwABzNKCuI7ldYB5/GAO+GcYfC/vyfThnSQZh45ax+jYDJfMGeO
         gWQ1Q8iFd7StYbVZ83Rh+mM0TiRye/tSSa3sHENrpgIAGoB1zPym5BaA1Gn+Amps6ygG
         1Om4hKu0EfI0vIjgZUWftfZ9eLHdR/96x3Fg4jQpLsuESJwghjl1xvhrF8N+RX3vYI0U
         DRV0v6r3bXxc3JNlGqWRdeu8dUhcwTvtvKSJ16DUlZ/rSafcUBgDUNOnJc3ooqo464mo
         oVpXPdVtvXR/uG3qVs8kR9naJa6wSW1jdQOlwboHO9a2BC6sPmHOrENOBwbGLlIuwtHM
         F7yg==
X-Gm-Message-State: AOAM533mvF6aQu/AApm2RGsbP8EEfPr9c1+7pQ1+wY1vLfG9lfC0DL4L
        He3PtH9gd/TRyeqsLo2g7SF0AaK5VJS7nDBbmstC2Q==
X-Google-Smtp-Source: ABdhPJxO84LY34qh8Lu4tjpjxiP21DFKo5lhbPCzTRhUKADeYIQLMyruEDCxTp64jHNAkSwkp7KxC2MhiM7Nv+jZ6cw=
X-Received: by 2002:a5e:9411:: with SMTP id q17mr2266246ioj.157.1603471877101;
 Fri, 23 Oct 2020 09:51:17 -0700 (PDT)
MIME-Version: 1.0
References: <20201023111352.GA289522@rdias-suse-pc.lan> <CANn89iJDt=XpUZA_uYK98cK8tctW6M=f4RFtGQpTxRaqwnnqSQ@mail.gmail.com>
 <20201023155145.GA316015@rdias-suse-pc.lan> <CANn89iL2VOH+Mg9-U7pkpMkKykDfhoX-GMRnF-oBmZmCGohDtA@mail.gmail.com>
 <20201023160628.GA316690@rdias-suse-pc.lan> <CANn89i+OZF2HJQYT0FGtzyFeZMdof9RAfGXQRKUVY6Hg9ZPpcg@mail.gmail.com>
 <20201023164825.GA321826@rdias-suse-pc.lan>
In-Reply-To: <20201023164825.GA321826@rdias-suse-pc.lan>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 23 Oct 2020 18:51:05 +0200
Message-ID: <CANn89iKOiAp96yu=7OVn72R8EMukErBSXeWURJp3qTqrurtt0Q@mail.gmail.com>
Subject: Re: [PATCH] tcp: fix race condition when creating child sockets from syncookies
To:     Ricardo Dias <rdias@memsql.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 23, 2020 at 6:48 PM Ricardo Dias <rdias@memsql.com> wrote:
>

> In that case, I can change the patch to only iterate the ehash bucket
> only when the listening socket is using the loopback interface, correct?

No, the fix should be generic.

We could still have bad NIC, or bad configuration, spreading packets
on random cpus ;)
