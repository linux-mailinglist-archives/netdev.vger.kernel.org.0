Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC9373A4620
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 18:04:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231371AbhFKQG2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 12:06:28 -0400
Received: from mail-pg1-f170.google.com ([209.85.215.170]:44646 "EHLO
        mail-pg1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231610AbhFKQGK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 12:06:10 -0400
Received: by mail-pg1-f170.google.com with SMTP id y11so2816670pgp.11
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 09:03:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LFmDj29W+ZxaCRet0MpwoPiDOpfYcZjGsEz7cZN6NGQ=;
        b=wHDz9e2QbxaQ5GZ2mwO3fDHyybaNCUJEXhk5bzYnzpDEXIXePSj24EzxxXdd/tig2e
         UVEt32IuXNDbQU1E6tF5IQ4KTiu+F6JpRVL8+yCGUCOVXlY5ZrlRzUFEIrBmck64oDbZ
         nznhoquoS3w+Xl44+rqpH+rvs4Stld2KVVYqS0W9VY9ACdMIfYQoiAwVuh7mcO6p/TPO
         3pv8cFL5qHWBnI88ZvQfqfyWIfZeQ1ttX9Rxln3fOMdfRerXLFiusNC2s32sf8e0x0VX
         9+8FKjFLE2VEfjQcfFfDzEq1LJLgLG5KF5TBZ0ifd1Q3g0Ra0n/TbNEnV6LwlBDPMP/f
         BFdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LFmDj29W+ZxaCRet0MpwoPiDOpfYcZjGsEz7cZN6NGQ=;
        b=X63ngwaKVNqWhF1eH330VchARZfXKSFw3ar+0ld27Or7/1wtxqRwbjZrI8Gb/hYKUx
         lyG982i708SN62A8LHPJsQP/IBzPMMM555MHyGl1Aw31mehLlH/3Q6diO8mi/mT+1p3p
         6JX+XhMp7w6zg7Q2f7ZBPEUUYmglkfc9tb+SQjz7bZ7hEx10UvX2hrw936/t6bvY5+Bs
         y88Ha0WQijL1qjcDSxNRFhodH/jRvQBfKqesVxoHX+GjOP7EoswUJJSmNFm/kj01WX5/
         rEzWY0DcmfYN4ji712ydrSqiQzFdbuuO2veIwOZhch63fHmv7jEf18mCPeRfBOznB7Gy
         krXA==
X-Gm-Message-State: AOAM5329evbkGPS4N7mFg5bA4RxddPeUyARxaG5mcGlF5dT/x/4scdd3
        w7rFvum6NRE5ffpICMoJP4TIXu2a2JePDQln6lXQA6m6XDqXeA==
X-Google-Smtp-Source: ABdhPJxGQ2zunH7fYmC5jB25rufBk9x2H65oIQCG0LXTkTAmQp2ffsO3r2ogj6zEG/n+GVgsUG/o1JHKfAwVcccSF9s=
X-Received: by 2002:a62:5c1:0:b029:2a9:7589:dd30 with SMTP id
 184-20020a6205c10000b02902a97589dd30mr8978509pff.66.1623427378581; Fri, 11
 Jun 2021 09:02:58 -0700 (PDT)
MIME-Version: 1.0
References: <1623347089-28788-1-git-send-email-loic.poulain@linaro.org>
 <1623347089-28788-2-git-send-email-loic.poulain@linaro.org>
 <PH0PR12MB5481986BF646806E23909CD7DC349@PH0PR12MB5481.namprd12.prod.outlook.com>
 <CAMZdPi9HhO9Z0W9hDLgNaj6jwiofVyQEp6pAwAO1Z8zqFGmGCA@mail.gmail.com> <PH0PR12MB5481E2A21AE5E9B7BF0B2C73DC349@PH0PR12MB5481.namprd12.prod.outlook.com>
In-Reply-To: <PH0PR12MB5481E2A21AE5E9B7BF0B2C73DC349@PH0PR12MB5481.namprd12.prod.outlook.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Fri, 11 Jun 2021 18:12:05 +0200
Message-ID: <CAMZdPi-_1y7nxovrNVgBH45QAtr_t4pozmUGQpDhymKNETq3Bg@mail.gmail.com>
Subject: Re: [PATCH net-next v2 2/3] rtnetlink: add IFLA_PARENT_[DEV|DEV_BUS]_NAME
To:     Parav Pandit <parav@nvidia.com>
Cc:     "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "johannes.berg@intel.com" <johannes.berg@intel.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "m.chetan.kumar@intel.com" <m.chetan.kumar@intel.com>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Jun 2021 at 18:00, Parav Pandit <parav@nvidia.com> wrote:
>
>
>
> > From: Loic Poulain <loic.poulain@linaro.org>
> > Sent: Friday, June 11, 2021 9:16 PM
> >
> > Hi Parav,
> >
> > On Fri, 11 Jun 2021 at 15:01, Parav Pandit <parav@nvidia.com> wrote:
> > >
> > >
> > >
> > > > From: Loic Poulain <loic.poulain@linaro.org>
> > > > Sent: Thursday, June 10, 2021 11:15 PM
> > > >
> > > > From: Johannes Berg <johannes.berg@intel.com>
> > > >
> > > > In some cases, for example in the upcoming WWAN framework changes,
> > > > there's no natural "parent netdev", so sometimes dummy netdevs are
> > > > created or similar. IFLA_PARENT_DEV_NAME is a new attribute intende=
d
> > > > to contain a device (sysfs, struct device) name that can be used
> > > > instead when creating a new netdev, if the rtnetlink family impleme=
nts it.
> > > >
> > > > As suggested by Parav Pandit, we also introduce
> > > > IFLA_PARENT_DEV_BUS_NAME attribute in order to uniquely identify a
> > > > device on the system (with bus/name pair).
> >
> > [...]
> >
> > > > diff --git a/include/uapi/linux/if_link.h
> > > > b/include/uapi/linux/if_link.h index
> > > > a5a7f0e..4882e81 100644
> > > > --- a/include/uapi/linux/if_link.h
> > > > +++ b/include/uapi/linux/if_link.h
> > > > @@ -341,6 +341,13 @@ enum {
> > > >       IFLA_ALT_IFNAME, /* Alternative ifname */
> > > >       IFLA_PERM_ADDRESS,
> > > >       IFLA_PROTO_DOWN_REASON,
> > > > +
> > > > +     /* device (sysfs) name as parent, used instead
> > > > +      * of IFLA_LINK where there's no parent netdev
> > > > +      */
> > > > +     IFLA_PARENT_DEV_NAME,
> > > > +     IFLA_PARENT_DEV_BUS_NAME,
> > > > +
> > > >       __IFLA_MAX
> > > >  };
> > > >
> > > > diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c index
> > > > 92c3e43..32599f3
> > > > 100644
> > > > --- a/net/core/rtnetlink.c
> > > > +++ b/net/core/rtnetlink.c
> > > > @@ -1821,6 +1821,16 @@ static int rtnl_fill_ifinfo(struct sk_buff *=
skb,
> > > >       if (rtnl_fill_prop_list(skb, dev))
> > > >               goto nla_put_failure;
> > > >
> > > > +     if (dev->dev.parent &&
> > > > +         nla_put_string(skb, IFLA_PARENT_DEV_NAME,
> > > > +                        dev_name(dev->dev.parent)))
> > > > +             goto nla_put_failure;
> > > > +
> > > > +     if (dev->dev.parent && dev->dev.parent->bus &&
> > > > +         nla_put_string(skb, IFLA_PARENT_DEV_BUS_NAME,
> > > > +                        dev->dev.parent->bus->name))
> > > > +             goto nla_put_failure;
> > > > +
> > > >       nlmsg_end(skb, nlh);
> > > >       return 0;
> > > >
> > > > @@ -1880,6 +1890,8 @@ static const struct nla_policy
> > > > ifla_policy[IFLA_MAX+1] =3D {
> > > >       [IFLA_PERM_ADDRESS]     =3D { .type =3D NLA_REJECT },
> > > >       [IFLA_PROTO_DOWN_REASON] =3D { .type =3D NLA_NESTED },
> > > >       [IFLA_NEW_IFINDEX]      =3D NLA_POLICY_MIN(NLA_S32, 1),
> > > > +     [IFLA_PARENT_DEV_NAME]  =3D { .type =3D NLA_NUL_STRING },
> > > > +     [IFLA_PARENT_DEV_BUS_NAME] =3D { .type =3D NLA_NUL_STRING },
> > > >  };
> > > >
> > > This hunk should go in the patch that enables users to use these fiel=
ds to
> > specify it for new link creation.
> >
> > Don't get it, the previous changes I see in the tree change both if_lin=
k.h and
> > rtnetlink.c for new atributes (e.g. f74877a5457d). Can you elaborate on=
 what
> > you expect here?
> >
> Commit f74877a5457d did in same patch because one of the objective of com=
mit f74877a5457d is to also block PERM_ADDR using policy NLA_REJECT.
> This patch-2 is not enabling user to pass these params via new_link comma=
nd.
> It is done in a later patch. So ifla_policy doesn=E2=80=99t need to have =
these fields in this patch.

Understood, thanks.
Loic
