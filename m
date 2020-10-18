Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EBDE2920A4
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 01:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729783AbgJRXvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 19:51:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728212AbgJRXvG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Oct 2020 19:51:06 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C6BAC061755;
        Sun, 18 Oct 2020 16:51:06 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id w21so4927975pfc.7;
        Sun, 18 Oct 2020 16:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uw+aYLYiJGyrDrMZb/nx2w+eKuS/axoOgFXJxufPotQ=;
        b=vUIQrBGf0OmZIeb04zw12omzwGDUBfS7uF/AZi/t/KjJz8Ox3iJWsTpNcC1WH4nGLD
         AyVc7/3zihN9mdYP2Xeck8zhncSVdCYnD1f9muK+u9WqdnhlNSHy/sMits6o0tqLuyIy
         BABDgRe0qXn8xa+fzmzrmIZ45Z7g0aa4+hRKJUNj18ayg0j1ZQ5efnU/Mp8VVZFWBBIn
         an6zDaSKetwX/yHwOlfCc+QNk/ZQrIQVWbolaKmj3FZ0EDYpbiqXodqhRM8alaBeJIcx
         TN9HSazC3VHwV5z3laibqpCStSNS+4ECuXQgOJd/cSTpF/zie8YYFGqOiqaUbod4QE8R
         AjSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uw+aYLYiJGyrDrMZb/nx2w+eKuS/axoOgFXJxufPotQ=;
        b=PEjM9xYku1c+xoCuNWZ5u9PZ1atRepe4U0MpGtduNYg0hO/k1Xe78gDjRHfy3v7Mn3
         bxD12hJKVzVEGfDTpKwJCIBDTQm4RkLZgMnppJzVeAWKN4qRKit5mchv6riyheafEcTo
         QPtzV/6WixqUB8117pXsKFUwa8w4SDfC66GYNR5S9q4heqy1lu78XGRzsYMSCIMiDF4i
         sFapbdSNEe7eur1PbIuVhtb91RxIJ9b3P1jxQwoSRXttqcgfGUzEz7VGdtkaAHYDyYUR
         kv6nK5xn6eTEzY8hnJZuXrlxoV4upQOyuh3+hwNAp4Wp+8wkR0Pt2qsILL3kE0xmO0UE
         s87g==
X-Gm-Message-State: AOAM5323rHij9p2pCKiEL69OObD1WowaU2XHSw6yrO9OIiojxTdz9C0b
        PrczPZk78Rvnrg3DbCtMEVft4Qt5C4UTLtmkrg8=
X-Google-Smtp-Source: ABdhPJwUOQqQgvxG038okq/jB4hBcc/S0RxWmJZHbd3TReKoKTW7d0XMQZZHi0SxjOjHsmFp4wUNXueWUfUg25+Qxpo=
X-Received: by 2002:aa7:96f8:0:b029:152:94c0:7e5 with SMTP id
 i24-20020aa796f80000b029015294c007e5mr14208283pfq.76.1603065065977; Sun, 18
 Oct 2020 16:51:05 -0700 (PDT)
MIME-Version: 1.0
References: <20201017051951.363514-1-xie.he.0141@gmail.com> <20201018150517.2f3dfb5c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201018150517.2f3dfb5c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Sun, 18 Oct 2020 16:50:55 -0700
Message-ID: <CAJht_EPnidrjS0Am+Vwp9W0dXP+6VJsmuHzy0eL9c7h5vpWwPA@mail.gmail.com>
Subject: Re: [PATCH net-next] drivers/net/wan/hdlc_fr: Improve fr_rx and add
 support for any Ethertype
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Krzysztof Halasa <khc@pm.waw.pl>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 18, 2020 at 3:05 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Whenever you make a list like that it's a strong indication that
> each of these should be a separate commit. That makes things easier
> to review.
>
>
> We have already sent a pull request for 5.10 and therefore net-next
> is closed for new drivers, features, and code refactoring.
>
> Please repost when net-next reopens after 5.10-rc1 is cut.
>
> (http://vger.kernel.org/~davem/net-next.html will not be up to date
>  this time around, sorry about that).
>
> RFC patches sent for review only are obviously welcome at any time.

OK. Thanks!

I'll divide this into smaller commits and repost after rc1.
