Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3EE45D3FF
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 05:49:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238643AbhKYEwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 23:52:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236673AbhKYEuu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 23:50:50 -0500
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00EB7C061574
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 20:47:39 -0800 (PST)
Received: by mail-qk1-x730.google.com with SMTP id q64so8500292qkd.5
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 20:47:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JnU+vLTZUc+P+rpnTRvOe/0U7nS/y30+QFTeaIaWbh4=;
        b=Uryt1CKrDOqeV63BQ2OTsElGUVXSSWv63sITaQktMrBtBPIV7bGKmMbRHUy1CzoI6E
         6fYYpQXTbus/yyPA9Kq0oSmb+c2y0IOX68fxgDCGuhsIrJsvtcpDvPm9gOYiKqnJPBf0
         unNoWjifaAL3EDNaCOD/5NxJyOeToVpqQUBJ3GzAHa8PrJuPLpR9W02N+8qT7y7eyrQt
         qGINez5NcP+U24Y0zy6879PTi/8LyvYzGYEAhWVVfhTBzs/+unRxCanx/Mr7QlMMLijZ
         ST+ET9VWBT+l8SCjT0SaBVToztwKGirvqWTjsL1YujAA/Kr4DsJdlR06YsA5RQ3fkPPR
         46Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JnU+vLTZUc+P+rpnTRvOe/0U7nS/y30+QFTeaIaWbh4=;
        b=U1HxbAvOzWzKeNcw115WQGGZNt5TuzjM8ea0GBicmHLh83PjExgGRae8fTEaR0cevj
         PREO2mJCDMozNKso1u1l/8IIOs7fKhYzy7rdakTW83kvVgYx8aXsKW+9xwqr/P/oaPCZ
         w/BNRC8kPUvhdiXB3WA95hiyS0Dvu2ztr5nIB1sJYfeiPr+kDEEDGikDpi2E8lm0oHut
         usum7j0GEwhTG45Tl8pS3jDggFdh/hqW/QW6sQYpPSZFFUIyXJ20y4gRdC5Zlab/Whw/
         pSMWZ84HoOlWqijcJxS/PD3tMSxPGStOJxjZSfqVvecQjaMIAPR8umPMSO58IiLvLJuC
         6CrQ==
X-Gm-Message-State: AOAM532ZyTV+9DCMAMW262ojEozw2d7yaX3LfSa552BogOMA1nTNO5YQ
        OxJCawYo09zIDJrWmPG5VbLWm0onn21M2GNidp2wtA==
X-Google-Smtp-Source: ABdhPJydcHqfq2Ec7qSuXY15ed2PNTJS2TcO6+PvB5FzoPMxH39GX6AHTupHZEAHzodhs+1INw01oVivTEvRF4YAmns=
X-Received: by 2002:a25:d04d:: with SMTP id h74mr3298228ybg.266.1637815658808;
 Wed, 24 Nov 2021 20:47:38 -0800 (PST)
MIME-Version: 1.0
References: <20211123223208.1117871-1-zenczykowski@gmail.com> <20211124190125.494f62ab@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211124190125.494f62ab@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Wed, 24 Nov 2021 20:47:26 -0800
Message-ID: <CANP3RGcYE8w=izZUg-+5q0kCodgFpXUfV9ZVDSgr6bz0hy5jPg@mail.gmail.com>
Subject: Re: [PATCH] net-ipv6: changes to ->tclass (via IPV6_TCLASS) should sk_dst_reset()
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Neal Cardwell <ncardwell@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 24, 2021 at 7:01 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 23 Nov 2021 14:32:08 -0800 Maciej =C5=BBenczykowski wrote:
> > From: Maciej =C5=BBenczykowski <maze@google.com>
> >
> > This is to match ipv4 behaviour, see __ip_sock_set_tos()
> > implementation.
> >
> > Technically for ipv6 this might not be required because normally we
> > do not allow tclass to influence routing, yet the cli tooling does
> > support it:
> >
> > lpk11:~# ip -6 rule add pref 5 tos 45 lookup 5
> > lpk11:~# ip -6 rule
> > 5:      from all tos 0x45 lookup 5
> >
> > and in general dscp/tclass based routing does make sense.
> >
> > We already have cases where dscp can affect vlan priority and/or
> > transmit queue (especially on wifi).
> >
> > So let's just make things match.  Easier to reason about and no harm.
> >
> > Cc: Eric Dumazet <edumazet@google.com>
> > Cc: Neal Cardwell <ncardwell@google.com>
> > Signed-off-by: Maciej =C5=BBenczykowski <maze@google.com>
>
> Please send related patches as a series. There are dependencies here
> which prevent the build bot from doing its job (plus it's less work
> for me since I apply by series :)).

Ah, sorry, while the patches were stacked on each other, they're kind
of orthogonal to each other,
and neither one actually depends on the other (outside of their being
a conflict because of touching nearby code).
That's why I sent them out separately.

Additionally, I've also noticed that often the first patch out of two
won't be merged if there's disagreement on the second, even though the
first might be entirely acceptable.
