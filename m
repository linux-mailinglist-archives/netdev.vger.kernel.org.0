Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1E7286EA4
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 08:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727742AbgJHGXH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 02:23:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726201AbgJHGXH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 02:23:07 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBD8DC061755
        for <netdev@vger.kernel.org>; Wed,  7 Oct 2020 23:23:06 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id o9so132643ilo.0
        for <netdev@vger.kernel.org>; Wed, 07 Oct 2020 23:23:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vZdWhbFMoYivEEACXr3AS3S/u+/hKQfFwcnrnKOOWyM=;
        b=pQ+0smZVwQFpfJR71kyZUBO/mO+V1cI9YvKnJh4P5Fl2WfUMwAtXyTylVuAS9GfN85
         lAQFldflfAtx1VZuC/ZWHwogkv3m4WrtrLrDK35ATy93VzkR7QLFBdCQjIpa+Blh7rJ6
         M+OtbsOhJwktcK3clQJrJi/tIutTOOF1N/BgBwoBmAR//4EGSB3X5c8lz8rnBPUXJNun
         GI2bNgHggG2xfjN7kWasHIbiDG/UIbEfpIEYZSH3ZHcWW1EVfJIqOjv/MJ/bT5zrJa82
         Umr2FGimRr2kAw4jt9VIcdl7EA1PHAhUbFjpbJu//wHXN0NsbXIaFnFmjaI84NkwCSi+
         D6Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vZdWhbFMoYivEEACXr3AS3S/u+/hKQfFwcnrnKOOWyM=;
        b=cmTWoWrPRy+FtaPY+SjJGdW4BnkkRdAygB2Nx2eIFlUXoGkVmWCvFER4GRwOu1YJdp
         Bg1SZBf7pJR9P+DRFEpiMTCmuocnFfYSq409HGEUQIJOwJp3KTPjCbptgN/FsecE9UaD
         NeZzuqaVMjWCSuuoJ1X0QJjwDqc/6Mpl9vLzAaON22Uy9zrEPpF7MlLrBrreILmsYDEB
         0ymuhF+onq09e6bNC/dj9PBW6uHyTPEu8fwc8IdnetmB5qKXVzi7zhm/sFNbXn1CEb2K
         fuOncwu9rZeciybzjna+OEDw/Q8wgXD/nrISIoX9FgKTYUTNZB8Y2yL9P1GssPpXx565
         +QKA==
X-Gm-Message-State: AOAM531OFqldVS4L/Pztni1iaa5+OblWtqn4QMQwwG2+tklKOXfVLW57
        gelbgci5YhZQ4eEMHPVwVPcrgPdD0V82WQgdrquoLg==
X-Google-Smtp-Source: ABdhPJziYT7DrglGuqYPIp6WDdvgK1UpLED1GJNbblvlO5ssr64TUIo4Nwx5pdIBrTEp/WoRUZ4qsQ5aJMeqRiskoT0=
X-Received: by 2002:a92:9408:: with SMTP id c8mr5077534ili.61.1602138186139;
 Wed, 07 Oct 2020 23:23:06 -0700 (PDT)
MIME-Version: 1.0
References: <20201008033102.623894-1-zenczykowski@gmail.com> <CAKD1Yr3idc3zz1AT5kmqBE4A9QaOYVF-XvU9zh29gW66tjHQ3g@mail.gmail.com>
In-Reply-To: <CAKD1Yr3idc3zz1AT5kmqBE4A9QaOYVF-XvU9zh29gW66tjHQ3g@mail.gmail.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Wed, 7 Oct 2020 23:22:52 -0700
Message-ID: <CANP3RGea_UU8K5LsKKw312jEHA9hh46wvRAz8DxKc-+dOjt0pw@mail.gmail.com>
Subject: Re: [PATCH 1/2] net/ipv6: always honour route mtu during forwarding
To:     Lorenzo Colitti <lorenzo@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>, Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Sunmeet Gill <sgill@quicinc.com>,
        Vinay Paradkar <vparadka@qti.qualcomm.com>,
        Tyler Wear <twear@quicinc.com>,
        David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Thu, Oct 8, 2020 at 12:31 PM Maciej =C5=BBenczykowski
> <zenczykowski@gmail.com> wrote:
> > diff --git a/include/net/ip6_route.h b/include/net/ip6_route.h
> > index 2a5277758379..598415743f46 100644
> > --- a/include/net/ip6_route.h
> > +++ b/include/net/ip6_route.h
> > @@ -311,19 +311,13 @@ static inline bool rt6_duplicate_nexthop(struct f=
ib6_info *a, struct fib6_info *
> >  static inline unsigned int ip6_dst_mtu_forward(const struct dst_entry =
*dst)
> >  {
> >         struct inet6_dev *idev;
> > -       unsigned int mtu;
> > +       unsigned int mtu =3D dst_metric_raw(dst, RTAX_MTU);
> > +       if (mtu)
> > +               return mtu;
>
> What should happen here if mtu is less than idev->cnf.mtu6? Should the
> code pick the minimum? If not: will picking the higher value work, or
> will the packet be dropped? I suppose we already have this problem
> today if the administrator configures a route with a locked MTU.

This feels like a misconfiguration of some sort (ie maybe should be
denied at route config time), but honestly it could maybe potentially
be useful:  for example an ipv6 route out an ipv4 only interface with
ebpf doing translation should/could actually be higher (by 20 or even
28) then device mtu.  (Note: this is not the Android case, as we
translate on ingress, not egress, but a setup could be created that
would work, especially if there was no nat44 in the picture and the
ipv6 dst address would directly select the end host)

And either way... it's the same for v4, and it already behave this way
in other places.
