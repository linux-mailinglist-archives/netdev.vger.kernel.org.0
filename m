Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 977CD2DECC0
	for <lists+netdev@lfdr.de>; Sat, 19 Dec 2020 03:45:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbgLSClo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 21:41:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726177AbgLSCln (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 21:41:43 -0500
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56B9BC0617B0
        for <netdev@vger.kernel.org>; Fri, 18 Dec 2020 18:41:03 -0800 (PST)
Received: by mail-vs1-xe36.google.com with SMTP id s85so2427162vsc.3
        for <netdev@vger.kernel.org>; Fri, 18 Dec 2020 18:41:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tvT4nPYJ0BNOovOmoIN0NjQN58vCztT/CrN7hWp32dk=;
        b=XL/sEfRLMWqMWM3QBDtuImh/tfMGZXVAOwTJrdMeq5gvmo7nIZXr0QXT7Cp7DVnH5y
         J7KQ+KE7sGjrZnhtJzwnhj0qs9D7L97HIB/edoyeDuiHwu64MTfn1NUHHQtflsj8d6I6
         5wp7i/a+HEYoEiSjfMwbsAIl9VBTtaxFMnjbg1TGJSN/w27LleniGh+MrOtGmLlOWf/o
         vpPIAS7gDa/vEk5pomd1DKH1YpPEDRGLWKlrrFkQltkYpq4xQ23jfxvTz4hXgN3H2xrJ
         XqS41FKR8T4RBifV7GLLTm/6PfctXN+h+NyOirrU3W9NTVf+xLZ4a6ev8KLkGuhgKkJL
         zxfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tvT4nPYJ0BNOovOmoIN0NjQN58vCztT/CrN7hWp32dk=;
        b=izP3jaZ8BOsSJeIV196xTH4Z7l/cG/SRURDKh/gGyUfrfyCZpI/dI63As3eHoJy4eO
         G/a0CxqkhpI0swRHVxZ6W89QaHfi7hC0Sb6KXUoAUpsJEJG0LXE/DX9mQ61zPaMHGMX+
         RJJw5frG5DM/dQzlDWkJArCIUUhMZax1y/a2iRd4hg5pbcd9nG0wHrHxCV4dWv2gwxI7
         KboyuJWtYWGGlAK7/y8I9V6NtIa5iG14VlUpCV8XS+FUoANBnkSmDqwAFberW2eqLxZ/
         8IMQMWJTAtc+3ONfhyQBSdD3WPRcrXAzjM4RzrDBklLhLZOipSx1vbL/xbpxhWtL3MtD
         ISuA==
X-Gm-Message-State: AOAM531HkV2vG1lHFu7g8Bi/1CpVbdeoz/vLUcPnZCW7LhH+qCkWVkEt
        30UFRNck+GIbxCgwRuEKAos6i3cb6sgXgyJKE6JPjg==
X-Google-Smtp-Source: ABdhPJxvEmY5FQCOJx6EglO0HYeESeh0q+tA0vpRtnO0voKnNBRPdQ6L59nn2Gl0b8P3/kb2twNhEn0oUvNwrQYbd8U=
X-Received: by 2002:a05:6102:1cd:: with SMTP id s13mr7470744vsq.26.1608345662032;
 Fri, 18 Dec 2020 18:41:02 -0800 (PST)
MIME-Version: 1.0
References: <175b3433a4c.aea7c06513321.4158329434310691736@shytyi.net>
 <202011110944.7zNVZmvB-lkp@intel.com> <175bd218cf4.103c639bc117278.4209371191555514829@shytyi.net>
 <175bf515624.c67e02e8130655.7824060160954233592@shytyi.net>
 <175c31c6260.10eef97f6180313.755036504412557273@shytyi.net>
 <20201117124348.132862b1@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <175e0b9826b.c3bb0aae425910.5834444036489233360@shytyi.net>
 <20201119104413.75ca9888@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <175e1fdb250.1207dca53446410.2492811916841931466@shytyi.net>
 <175e4f98e19.bcccf9b7450965.5991300381666674110@shytyi.net>
 <176458a838e.100a4c464143350.2864106687411861504@shytyi.net>
 <1766d928cc0.11201bffa212800.5586289102777886128@shytyi.net> <20201218180323.625dc293@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201218180323.625dc293@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Fri, 18 Dec 2020 18:40:50 -0800
Message-ID: <CANP3RGfG=7nLFdL0wMUCS3W2qnD5e-m3CbV5kNyg_X2go1=MzQ@mail.gmail.com>
Subject: Re: [PATCH net-next V9] net: Variable SLAAC: SLAAC with prefixes of
 arbitrary length in PIO
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Dmytro Shytyi <dmytro@shytyi.net>,
        yoshfuji <yoshfuji@linux-ipv6.org>,
        liuhangbin <liuhangbin@gmail.com>, davem <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Joel Scherpelz <jscherpelz@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 18, 2020 at 6:03 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> It'd be great if someone more familiar with our IPv6 code could take a
> look. Adding some folks to the CC.
>
> On Wed, 16 Dec 2020 23:01:29 +0100 Dmytro Shytyi wrote:
> > Variable SLAAC [Can be activated via sysctl]:
> > SLAAC with prefixes of arbitrary length in PIO (randomly
> > generated hostID or stable privacy + privacy extensions).
> > The main problem is that SLAAC RA or PD allocates a /64 by the Wireless
> > carrier 4G, 5G to a mobile hotspot, however segmentation of the /64 via
> > SLAAC is required so that downstream interfaces can be further subnette=
d.
> > Example: uCPE device (4G + WI-FI enabled) receives /64 via Wireless, an=
d
> > assigns /72 to VNF-Firewall, /72 to WIFI, /72 to Load-Balancer
> > and /72 to wired connected devices.
> > IETF document that defines problem statement:
> > draft-mishra-v6ops-variable-slaac-problem-stmt
> > IETF document that specifies variable slaac:
> > draft-mishra-6man-variable-slaac
> >
> > Signed-off-by: Dmytro Shytyi <dmytro@shytyi.net>
>
> The RFC mentions checking a flag in RA, but I don't see that in this
> patch, could you explain?

IMHO acceptance of this should *definitely* wait for the RFC to be
accepted/published/standardized (whatever is the right term).

I'm not at all convinced that will happen - this still seems like a
very fresh *draft* of an rfc,
and I'm *sure* it will be argued about.

This sort of functionality will not be particularly useful without
widespread industry
adoption across *all* major operating systems (Windows, Mac/iOS,
Linux/Android, FreeBSD, etc.)
Additionally rollout will take years (due to need for OS updates), so
waiting a few
more months/quarters for the RFC to actually be agreed upon (assuming
it ever is),
will not hurt us.

An implementation that is incompatible with the published RFC will
hurt us more then help us.

Maciej =C5=BBenczykowski, Kernel Networking Developer @ Google
