Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0BCD35FD53
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 23:32:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233248AbhDNVcr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 17:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233281AbhDNVcp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 17:32:45 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA71CC061574
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 14:32:21 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id 65-20020a9d03470000b02902808b4aec6dso15974211otv.6
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 14:32:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=euc1VXuz6Kl9Wzo3v1AaAQ+aFpv1dxQuVZxDCzfR7V8=;
        b=JwmI0w/jpjmBdjb1VRMtBpAQh6q9oNYdnbN43qBGb3xfTo+gNn9VjK07I5NP+WeztU
         z0DXVDz/37VUYrFd8Zhx0H/TYctQcWNUJY+syw/Gw3znewjM0WzhMJZT/nLAWOcvgrI7
         jRMXxH05K0AZSMaVm08o7ZH3iVjfiIZy133V9eU+m4tgNGZvwa61H/Gs4/X/E2YxJl46
         2U4gab7+ES05r5PqESn+ctE53e1B7dmy3+wD0sdr/UmuhI3XkQ+F57fAklrZ3JaJRAgl
         mI+AWsfWXSmqfAByuBE90PRDECgThxaX8dcr/bmt8RcZvl8gLZMHwDnonItFRToa8Ni4
         R9dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=euc1VXuz6Kl9Wzo3v1AaAQ+aFpv1dxQuVZxDCzfR7V8=;
        b=h38OSFTPXiyg7pJewWWqHYuxhVXDlz3prxhJ3DRTiNy3sko+NbxNJXyLCmnxb6TF2j
         upUEJ3MLmh55RTjMbjVI+zqPi62SdTGTLNCN4pWq0xE7YMwEo3fSQujaOxOCHc+ibsDW
         +sH4ed39ffpAWNind7Yo8O8mYgPQZq0tzHkQJr4QU2lxZm5xUU31NHtkMGRF+Jkc16BE
         F/N4132DihbysER9IHXxhG5dZHMlDqHt9InstEBarSnGTDO91wpY4gonIEtGHm3IgVGX
         5CR9UFb6R1gmSSksD5OnUaJyTVqyNfskE6h/IYblIIXgGTZTfAsG0oC3/3eak67H0uig
         B47A==
X-Gm-Message-State: AOAM533JcmEgNqeMXo6CuLkfw0gPmaXNH6RyHPCg570RfmX5qhyZDW3R
        J4NWxMrOjd4v3ASs9OHmSYF7Y/rCB+7D1q8sVzYTAq/d01w8cg==
X-Google-Smtp-Source: ABdhPJx3eTEhI6r+bGcGJ6ntShYZh9dZ0w/YXrbR8KjTG0EoKNsmtkcOqqmWdxMlB/51W62IhAS1fvFc11IdUN5Fzh0=
X-Received: by 2002:a05:6830:1411:: with SMTP id v17mr89302otp.87.1618435941085;
 Wed, 14 Apr 2021 14:32:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210413070848.7261-1-jonathon.reinhart@gmail.com> <20210413112339.263089fb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210413112339.263089fb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jonathon Reinhart <jonathon.reinhart@gmail.com>
Date:   Wed, 14 Apr 2021 17:31:55 -0400
Message-ID: <CAPFHKzdgNiwdChUnAyAt8keNwd12mkFczrLLFx7i-d6OXJ5VXw@mail.gmail.com>
Subject: Re: [PATCH] net: Make tcp_allowed_congestion_control readonly in
 non-init netns
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Christian Brauner <christian.brauner@ubuntu.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 2:23 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 13 Apr 2021 03:08:48 -0400 Jonathon Reinhart wrote:
> > Fixes: 9cb8e048e5d9: ("net/ipv4/sysctl: show tcp_{allowed, available}_congestion_control in non-initial netns")
>
> nit: no semicolon after the hash

Oops. scripts/checkpatch.pl didn't catch this, but it looks like patchwork did.

You indicated "nit": Shall I resubmit, or can something trivial like
this be fixed up when committed? I'm fine either way, I just need to
know what's expected.

Also, this patch shows up in patchwork as "Not Applicable". I didn't
see any notification about that state change, nor do I really know
what that means. Was that due to this nit, or something else?

Thanks for guiding me through this.
Jonathon
