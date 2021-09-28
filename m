Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 584D141B775
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 21:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242471AbhI1TWo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 15:22:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240589AbhI1TWm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Sep 2021 15:22:42 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68EA2C06161C;
        Tue, 28 Sep 2021 12:21:02 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id g41so614916lfv.1;
        Tue, 28 Sep 2021 12:21:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=hrytyxRe9DwUMknTOVWT9f+PrwKpSWleT8xzoaaG15A=;
        b=QXAFboF2T7KDAsGlEFjAqqwk6js0gA61y0u4ZfD8NbxH5IdJWOXI9RjLkvLtVNIhLq
         KFz1NwUCWa9Spco9sCNdI885MTL9sRDsGo4qOo6S8qJQKC6jUQiNKcOOMXy2lfQAJOL7
         3TxwDOohw3+n/0HDs3Up96dRMuMnsck2Hevlj1Gg1dILuSN+7LFA8a4VJmbQ+ZG7m+IX
         ct7sqHsZRfjRHtu13jN3lB5z3EVCkLbBlMZQs50rseqY+7nZxVPE+iaBzDYc0TtRf2qD
         Gs1nePtdZbxifSDBbZdGBXLweT6JoJg0v9VcXR09h1/R70MnaGaBc1rNyEagh9bv71gZ
         oknQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hrytyxRe9DwUMknTOVWT9f+PrwKpSWleT8xzoaaG15A=;
        b=atSFnwa28m8QjFClVt+/kqZFotED1jK9ArCgqvQyNc3K+q1YkIrS3icwuOLvbiHXcx
         OIX9VFMESfFuLgBkoB2hXkmXeR4a1boCGYqw9voGh1HF3OhfJU1SOhPgOQP55CdIjiA/
         dEfz4yUY1Flp4vLhh04hus9M5bHd68vkKN+L+SGxabsT0To0fHOXfKbFTPCyrOitIHuB
         RlFwobXRdVXncHEODRQI0+IkJRt183Pv78Lev4oe/RgftWMApEVzfDQaaD7rwmE8a2lu
         x+aiKdW9rSKjjAOrKI6VuNpsmUN+JJRyv2NPUnQX6cgkhzdr77LLXKWb6l6RbDcCqnQd
         5WVg==
X-Gm-Message-State: AOAM531/R2qNvLJwn67qENgFwPPOj9i3T94Q30FdXRLaon89G6wR1S5s
        a92au63o9KivXL74O+a0806R4GzHpmhkZ1SuFdw=
X-Google-Smtp-Source: ABdhPJy4+Sj2gVWZ0CHahAVU8A1TXqvlXixGplrli2Pj9ksgaBr5ZSIENM/oJpsamazt65WuctjkowFlu6rw6v+1aPY=
X-Received: by 2002:ac2:5f71:: with SMTP id c17mr7220696lfc.555.1632856860809;
 Tue, 28 Sep 2021 12:21:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210920182038.1510501-1-cpp.code.lv@gmail.com>
 <0d70b112-dc7a-7083-db8d-183782b8ef8f@6wind.com> <CAASuNyUWoZ1wToEUYbdehux=yVnWQ=suKDyRkQfRD-72DOLziw@mail.gmail.com>
 <e4bb09d1-8c8f-bfdf-1582-9dd8c560411b@6wind.com>
In-Reply-To: <e4bb09d1-8c8f-bfdf-1582-9dd8c560411b@6wind.com>
From:   Cpp Code <cpp.code.lv@gmail.com>
Date:   Tue, 28 Sep 2021 12:20:49 -0700
Message-ID: <CAASuNyUv-dZmws77dDurgaE-VQ=pmXm7YZAnQwig8rGE8d5w5Q@mail.gmail.com>
Subject: Re: [PATCH net-next v5] net: openvswitch: IPv6: Add IPv6 extension
 header support
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     netdev@vger.kernel.org, pshelar@ovn.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        ovs dev <dev@openvswitch.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 28, 2021 at 7:51 AM Nicolas Dichtel
<nicolas.dichtel@6wind.com> wrote:
>
> Le 27/09/2021 =C3=A0 21:12, Cpp Code a =C3=A9crit :
> > To use this code there is a part of code in the userspace. We want to
> > keep compatibility when we only update userspace part code or only
> > kernel part code. This means we should have same values for constants
> > and we can only add new ones at the end of list.
> All attributes after OVS_KEY_ATTR_CT_STATE (ie 7 attributes) were added b=
efore
> OVS_KEY_ATTR_TUNNEL_INFO.
> Why is it not possible anymore?
>
>
> Regards,
> Nicolas
>
> >
> > Best,
> > Tom
> >
> > On Wed, Sep 22, 2021 at 11:02 PM Nicolas Dichtel
> > <nicolas.dichtel@6wind.com> wrote:
> >>
> >> Le 20/09/2021 =C3=A0 20:20, Toms Atteka a =C3=A9crit :
> >>> This change adds a new OpenFlow field OFPXMT_OFB_IPV6_EXTHDR and
> >>> packets can be filtered using ipv6_ext flag.
> >>>
> >>> Signed-off-by: Toms Atteka <cpp.code.lv@gmail.com>
> >>> ---
> >>>  include/uapi/linux/openvswitch.h |  12 +++
> >>>  net/openvswitch/flow.c           | 140 +++++++++++++++++++++++++++++=
++
> >>>  net/openvswitch/flow.h           |  14 ++++
> >>>  net/openvswitch/flow_netlink.c   |  24 +++++-
> >>>  4 files changed, 189 insertions(+), 1 deletion(-)
> >>>
> >>> diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/op=
envswitch.h
> >>> index a87b44cd5590..dc6eb5f6399f 100644
> >>> --- a/include/uapi/linux/openvswitch.h
> >>> +++ b/include/uapi/linux/openvswitch.h
> >>> @@ -346,6 +346,13 @@ enum ovs_key_attr {
> >>>  #ifdef __KERNEL__
> >>>       OVS_KEY_ATTR_TUNNEL_INFO,  /* struct ip_tunnel_info */
> >>>  #endif
> >>> +
> >>> +#ifndef __KERNEL__
> >>> +     PADDING,  /* Padding so kernel and non kernel field count would=
 match */
> >>> +#endif
> >>> +
> >>> +     OVS_KEY_ATTR_IPV6_EXTHDRS,  /* struct ovs_key_ipv6_exthdr */
> >> Naive question, why not moving OVS_KEY_ATTR_IPV6_EXTHDRS above
> >> OVS_KEY_ATTR_TUNNEL_INFO?
> >>
> >>
> >>
> >> Regards,
> >> Nicolas

These 3 commits does not support compatibility for scenarios when only
kernel gets updated. I assume at that point this requirement wasn't
required.

Best,
Tom
