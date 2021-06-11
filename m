Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FC813A4485
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 16:58:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231742AbhFKPAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 11:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231613AbhFKPAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 11:00:20 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB74CC0613A3
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 07:58:10 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id g24so5829228pji.4
        for <netdev@vger.kernel.org>; Fri, 11 Jun 2021 07:58:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VC6mpmCDPx0rK/2F14/9ztvVCbURzb1fIYmhhVUTn0U=;
        b=HVSo0cU/3dIAfI5QbhDNbm6XR7p9jeGfdHNZVfThnSZkfPq0mJp2kiLx/G2Bhal0po
         ttEDaSgHFHprIcKI7msS/G5juy/AAGGRVSd1SDjvzyvqCFQGXxbY9bTL+2RA1BbO8wCM
         OHs4L88xvrB7cGduihRlCgRbEYWFFsFYZCCS5wFjlD8cmOVneHg0kOhMxubVWtneD7Nl
         u99AW8W86wi6aTObqTAmOhCys6QoqxARHVGnB78EiO60/9S1PW2+XOey0Qwj54lDMPFR
         9LSkh4ltHff4YOQTm3tLRjBi+a47qf/13elV3bDud7MozrOJJwA4aKYnIsdlphjqiHK5
         7KhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VC6mpmCDPx0rK/2F14/9ztvVCbURzb1fIYmhhVUTn0U=;
        b=R8UZHKPhK3xpwdDqfwSbMDImbo9j6zgZz1Mk9PkHy45sgj9LbPVdBUT4LHAWxlC7Bf
         HFP96IuuodA8vvRufT3o2yD+ngl8GhA6rQoq4dLDVBMNDRPNeICX9o7cINnA8bA2oijG
         GS19ZmER/9rijEC4SOkg66AHMItApnsvQ+2O7hOU+OOL21PYarw8Xy3UUbAm1syMbUgT
         9RxA588R65ciwPod+xvK/ENwxxeIKd1tp4YulSPxMhDgOGliVAIJVMHByCWS8eoRWZgH
         vI25P5mcMAmlxh9QjOjMmGgA3sZLdizToAQWpUxc1vB1FexzSzugMRpY5oc6WGyLEsx4
         4wnA==
X-Gm-Message-State: AOAM53306ipj3xd+M+DkA8RyQDdb1IwNJRGAX6ek7WgOnlTW8sKfXkxy
        wQ50Zxwm47CmkqVEeEYUIcy1xdUODF8MZJWRlv6xGQ==
X-Google-Smtp-Source: ABdhPJxi2RfIiDO9urz+rbT159NgS1D+scKeahxB2qjSPktH8gfidObxEEnGI62zEMKZHr27ceoUX+2BX+Q3KzoWTr8=
X-Received: by 2002:a17:90a:f88:: with SMTP id 8mr9612608pjz.231.1623423490000;
 Fri, 11 Jun 2021 07:58:10 -0700 (PDT)
MIME-Version: 1.0
References: <1623347089-28788-1-git-send-email-loic.poulain@linaro.org>
 <1623347089-28788-2-git-send-email-loic.poulain@linaro.org> <PH0PR12MB5481986BF646806E23909CD7DC349@PH0PR12MB5481.namprd12.prod.outlook.com>
In-Reply-To: <PH0PR12MB5481986BF646806E23909CD7DC349@PH0PR12MB5481.namprd12.prod.outlook.com>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Fri, 11 Jun 2021 17:07:16 +0200
Message-ID: <CAMZdPi_tv_MDFbSAx-hKTBsoi9=u7hQxcWNBcer5LQ+J37zgdw@mail.gmail.com>
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
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Parav,

On Fri, 11 Jun 2021 at 15:01, Parav Pandit <parav@nvidia.com> wrote:
>
>
>
> > From: Loic Poulain <loic.poulain@linaro.org>
> > Sent: Thursday, June 10, 2021 11:15 PM
> >
> > From: Johannes Berg <johannes.berg@intel.com>
> >
> > In some cases, for example in the upcoming WWAN framework changes,
> > there's no natural "parent netdev", so sometimes dummy netdevs are
> > created or similar. IFLA_PARENT_DEV_NAME is a new attribute intended to
> > contain a device (sysfs, struct device) name that can be used instead when
> > creating a new netdev, if the rtnetlink family implements it.
> >
> > As suggested by Parav Pandit, we also introduce
> > IFLA_PARENT_DEV_BUS_NAME attribute in order to uniquely identify a
> > device on the system (with bus/name pair).
> >
> > ip-link(8) support for the generic parent device attributes will help us avoid
> > code duplication, so no other link type will require a custom code to handle
> > the parent name attribute. E.g. the WWAN interface creation command will
> > looks like this:
> >
> > $ ip link add wwan0-1 parent-dev wwan0 type wwan channel-id 1
> >
> > So, some future subsystem (or driver) FOO will have an interface creation
> > command that looks like this:
> >
> > $ ip link add foo1-3 parent-dev foo1 type foo bar-id 3 baz-type Y
> >
> > Below is an example of dumping link info of a random device with these new
> > attributes:
> >
> > $ ip --details link show wlp0s20f3
> >   4: wlp0s20f3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc
> > noqueue
> >      state UP mode DORMANT group default qlen 1000
> >      ...
> >      parent_devname 0000:00:14.3 parent_busname pci
>
> Showing bus first followed device is more preferred approach to see hierarchy.
> Please change their sequence.
>
> You should drop "name" suffix.
> "parent_bus" and "parent_dev" are just fine.

Do you think it can also be dropped for the IFLA symbol
(IFLA_PARENT_DEV && IFLA_PARENT_BUS_NAME).

>
> >
> > Co-developed-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
> > Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
> > Co-developed-by: Loic Poulain <loic.poulain@linaro.org>
> > Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> > Suggested-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> > ---
> >  v2: - Squashed Johannes and Sergey changes
> >      - Added IFLA_PARENT_DEV_BUS_NAME attribute
> >      - reworded commit message + introduce Sergey's comment
> >
> >  include/uapi/linux/if_link.h |  7 +++++++
> >  net/core/rtnetlink.c         | 12 ++++++++++++
> >  2 files changed, 19 insertions(+)
> >
> > diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h index
> > a5a7f0e..4882e81 100644
> > --- a/include/uapi/linux/if_link.h
> > +++ b/include/uapi/linux/if_link.h
> > @@ -341,6 +341,13 @@ enum {
> >       IFLA_ALT_IFNAME, /* Alternative ifname */
> >       IFLA_PERM_ADDRESS,
> >       IFLA_PROTO_DOWN_REASON,
> > +
> > +     /* device (sysfs) name as parent, used instead
> > +      * of IFLA_LINK where there's no parent netdev
> > +      */
> > +     IFLA_PARENT_DEV_NAME,
> > +     IFLA_PARENT_DEV_BUS_NAME,
> > +
> >       __IFLA_MAX
> >  };
> >
> > diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c index 92c3e43..32599f3
> > 100644
> > --- a/net/core/rtnetlink.c
> > +++ b/net/core/rtnetlink.c
> > @@ -1821,6 +1821,16 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
> >       if (rtnl_fill_prop_list(skb, dev))
> >               goto nla_put_failure;
> >
> > +     if (dev->dev.parent &&
> > +         nla_put_string(skb, IFLA_PARENT_DEV_NAME,
> > +                        dev_name(dev->dev.parent)))
> > +             goto nla_put_failure;
> > +
> > +     if (dev->dev.parent && dev->dev.parent->bus &&
> > +         nla_put_string(skb, IFLA_PARENT_DEV_BUS_NAME,
> > +                        dev->dev.parent->bus->name))
> > +             goto nla_put_failure;
> > +
> >       nlmsg_end(skb, nlh);
> >       return 0;
> >
> > @@ -1880,6 +1890,8 @@ static const struct nla_policy
> > ifla_policy[IFLA_MAX+1] = {
> >       [IFLA_PERM_ADDRESS]     = { .type = NLA_REJECT },
> >       [IFLA_PROTO_DOWN_REASON] = { .type = NLA_NESTED },
> >       [IFLA_NEW_IFINDEX]      = NLA_POLICY_MIN(NLA_S32, 1),
> > +     [IFLA_PARENT_DEV_NAME]  = { .type = NLA_NUL_STRING },
> > +     [IFLA_PARENT_DEV_BUS_NAME] = { .type = NLA_NUL_STRING },
> >  };
> >
> This hunk should go in the patch that enables users to use these fields to specify it for new link creation.

ack.

Thx,
Loic
