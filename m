Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30EC644DB68
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 19:01:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232203AbhKKSET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 13:04:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbhKKSES (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 13:04:18 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5A7EC061766
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 10:01:28 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id c8so27003605ede.13
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 10:01:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mihalicyn.com; s=mihalicyn;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WlOb0tCt1z+3pPfL+Z8iALspo6XXY8KStKb5FBKjQ+Y=;
        b=ehIA19UaeysA+iPQFxh9Zksz2yniYUlcy8oFhl5YNSD5GHhsa1yOzPg9wnVlxWZQXS
         +IYquHOaCmirTIk3sKIZpSuZs9jrUTExTK1tRs6vs+4zxVPoEgI2SCbqwu6EPEMhSuc8
         qYyz0a4i5YIvG/9Yca59+iyw1gwR1hsZUgSVY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WlOb0tCt1z+3pPfL+Z8iALspo6XXY8KStKb5FBKjQ+Y=;
        b=uoBRQv9OciN9pug70M7uR5py6Ztg17jx2w2ZRgr8hvPXdKFUOwidYLbs9WdKXILzwR
         xNAtJS9t8X2pmKfisnToqg4Dsa4giNgqVJNpVcex1Ie91AbPVRO/1uNDuTX8Irolxv0R
         GHBrRhlktqMuO8chZ6z3Cl/3cYerp9D3eeCcXw/J4B7tNbAh3M+eQq3+L1AwIo1vxCcY
         wdVyCvX9R2oOZzxCa3eUxyrKJR1q+ZPrtQy3x7tOwSXTTTrZ2FtvzF4xvF259oNxl9/d
         Nl8pSlDAUJYucyR+Eroqle7Um+5WqLZgweJGE1c95d6wfJnjxhdGwatBK1rsHLpbbFH5
         lckg==
X-Gm-Message-State: AOAM532TQNW43h6C+7BD8LmDAD2XAG68LM8S4EwyINfd3H+gtBHdPUjn
        0Wo2szuHX1ftondtyG4l7BPMWq7jHEkAnL2usdFXmw==
X-Google-Smtp-Source: ABdhPJxF3q4h0DI9DW8NqbJHIJ9oJDagjHMwO+LupC0LS5JJcoIREfhPbouA96a58iJbvElllGp7zHPFzz2a0mw58Vs=
X-Received: by 2002:aa7:d4d4:: with SMTP id t20mr12379552edr.374.1636653686857;
 Thu, 11 Nov 2021 10:01:26 -0800 (PST)
MIME-Version: 1.0
References: <20211111160240.739294-1-alexander.mikhalitsyn@virtuozzo.com>
 <20211111160240.739294-2-alexander.mikhalitsyn@virtuozzo.com>
 <20211111094837.55937988@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAJqdLrrY9zfk_i3fUhCORY33xpFPX8k4ZKWkVsL2D8sPMnNEZw@mail.gmail.com> <20211111095632.40e80062@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211111095632.40e80062@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Alexander Mikhalitsyn <alexander@mihalicyn.com>
Date:   Thu, 11 Nov 2021 21:01:14 +0300
Message-ID: <CAJqdLrqEhNYJ_zkFebU9-N_3-dNs50u6wN3H2SEBBqv-0H5t2A@mail.gmail.com>
Subject: Re: [RFC PATCH net-next] rtnetlink: add RTNH_F_REJECT_MASK
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Andrei Vagin <avagin@gmail.com>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 11, 2021 at 8:56 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 11 Nov 2021 20:51:20 +0300 Alexander Mikhalitsyn wrote:
> > Thanks for your attention to the patch. Sure, I will do it.
> >
> > Please, let me know, what do you think about RTNH_F_OFFLOAD,
> > RTNH_F_TRAP flags? Don't we need to prohibit it too?
>
> Looks like an omission indeed but I'll let Dave and Ido comment.
Sure.

>
> Reminder: please don't top post on the ML.
Oh, yep. I'm sorry.
