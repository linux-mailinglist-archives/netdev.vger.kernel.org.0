Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49EAF31B14A
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 17:41:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbhBNQkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 11:40:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhBNQkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Feb 2021 11:40:19 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6ED2C061574
        for <netdev@vger.kernel.org>; Sun, 14 Feb 2021 08:39:39 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id lg21so7492882ejb.3
        for <netdev@vger.kernel.org>; Sun, 14 Feb 2021 08:39:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XAHHiq/9kKkadfZpbGVc0yQIw9+ckJY/dxbJj8lgJEQ=;
        b=hySOW50FFXUeNghe8P5utCf1yRxMdxZZGTb7lSksacg8KBqij/bLQHjCJaoVuFfhcg
         PjNJiUS2G30nv62dqzrF5RLT9m9bGOYFqo/LppLZhdIzt2LTDZrppXfWArI36EQNmaFh
         xJNq+WekFBq5HpGwt87fvDNIWKJZNmGKV3RWL4FDuPaktYZ8gMMJAkNaVWsZM2d0ohL8
         /TX6IQ0nhh74w75CicROQDU+eZAZURrZYD/3RLmUdACuB/mW2VSUdLIp5HkmdtyF8Kit
         LTje6XI0qbcllzLi+EOJA8dkgYXZ3PudyziDtSQvVUPmO9Rve0HYBpVNUuqYDDuubpmD
         neZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XAHHiq/9kKkadfZpbGVc0yQIw9+ckJY/dxbJj8lgJEQ=;
        b=mLVgSR0zznCwc795bnzDpt2bm8/l42yNujigelqnpbUvOo1rWkYmj6k5Awhmn2e4hd
         f+WO7HwgmRtfe20xP3hhS8suk4HEYIVpYUBhGB4TGldplT/0AcLfHD2NzkxVL1ZSIt75
         wHwWnJNNFqmEj8rKEFry3J+Li4izXD09cvbVFpjtSlItg6WGyY7+kZaGzNpzsCUVOzKH
         WbUvz6ZxaC/D4RzKOPVElOR9mWhhnVtTVmco3U8dNEfYY9SuH+nOkH577lt4uRcKKdNg
         ERqZSHO2jyc9F9VBQ03RglRUJc+8BH/CT+fRC08WUP+ciM0v2KGkRarXRwxxRwv9AG0T
         HR6w==
X-Gm-Message-State: AOAM5334Dio/9O9h7qXkHYeM4j5ymOzakEPtNGjoC3oGo6FzY9ApQ5hz
        KoUFVjSG4QRruyfDdqr1ZWHy6Ado4fo=
X-Google-Smtp-Source: ABdhPJyNFORMtAMe5VfdQkakCPCbK0xze50y8PTQxCnoJ/ORc898h1HQ9nEc3p4hh7lICurlIzSmHg==
X-Received: by 2002:a17:906:4ed6:: with SMTP id i22mr2993449ejv.213.1613320778581;
        Sun, 14 Feb 2021 08:39:38 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id o10sm9326613eju.89.2021.02.14.08.39.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Feb 2021 08:39:38 -0800 (PST)
Date:   Sun, 14 Feb 2021 18:39:36 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Ido Schimmel <idosch@idosch.org>
Subject: Re: [PATCH net-next 3/5] net: bridge: propagate extack through
 switchdev_port_attr_set
Message-ID: <20210214163936.ut33qwe7opr4rhfk@skbuf>
References: <20210213204319.1226170-1-olteanv@gmail.com>
 <20210213204319.1226170-4-olteanv@gmail.com>
 <74e91dbb-7584-1201-da88-77fbf93e26ab@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <74e91dbb-7584-1201-da88-77fbf93e26ab@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nikolay,

On Sun, Feb 14, 2021 at 12:45:11PM +0200, Nikolay Aleksandrov wrote:
> On 13/02/2021 22:43, Vladimir Oltean wrote:
> > From: Vladimir Oltean <vladimir.oltean@nxp.com>
> >
> > The benefit is the ability to propagate errors from switchdev drivers
> > for the SWITCHDEV_ATTR_ID_BRIDGE_VLAN_FILTERING and
> > SWITCHDEV_ATTR_ID_BRIDGE_VLAN_PROTOCOL attributes.
> >
> > Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > ---
> >  include/net/switchdev.h       |  3 ++-
> >  net/bridge/br_mrp_switchdev.c |  4 ++--
> >  net/bridge/br_multicast.c     |  6 +++---
> >  net/bridge/br_netlink.c       |  2 +-
> >  net/bridge/br_private.h       |  3 ++-
> >  net/bridge/br_stp.c           |  4 ++--
> >  net/bridge/br_switchdev.c     |  6 ++++--
> >  net/bridge/br_vlan.c          | 13 +++++++------
> >  net/switchdev/switchdev.c     | 19 ++++++++++++-------
> >  9 files changed, 35 insertions(+), 25 deletions(-)
> >
>
> You have to update the !CONFIG_NET_SWITCHDEV switchdev_port_attr_set() stub as well.

Thanks for pointing this out, you are right, the build fails.
What is really curious is that I had this issue on my radar but I forgot
to address it nonetheless.
I will take a step back and defer this series for after the break.
