Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C724F134376
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 14:09:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbgAHNJS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 08:09:18 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:41620 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726683AbgAHNJS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 08:09:18 -0500
Received: by mail-qk1-f193.google.com with SMTP id x129so2498584qke.8
        for <netdev@vger.kernel.org>; Wed, 08 Jan 2020 05:09:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=T1UOaKySeFJ0zKePKXqAI7V9b9QgvGnZL/Q3FtxcxRw=;
        b=hooMOcE6opMbVdDJ7nmkFDN8Zp6CmRzc5r5pztAQmfT0T6Q1tdPnQ46RLDwiG02Day
         Glb6+fWlPHqMGE9GXQWAQomFlk35zPedNaVupcNKQiNjMJXS4GUA/zJybWpFVHH9EkVZ
         ixPvXakHhWguyTMogEGL06x+MLJtSPzn0mPEzm4240ZDFOvhNWXEK/XwxfZqgJz4G6gn
         MlvgbeGwRwSubDfzRhlgQrFwi64Bhyo45xPY6tHjw9N8RDxY57R4G3aeOW/v7JfFqicR
         pAbN58Z5EtHvqqLRPKnlkje8EyXgzlNToN4DZjPiMXLCH/G5TR3xSJDJv4JZMqrEACj3
         V3rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=T1UOaKySeFJ0zKePKXqAI7V9b9QgvGnZL/Q3FtxcxRw=;
        b=c7N1QPvIK1U6IZfPYjd77emfs6sl/EuTrA5F4bx5nof84aE8Hv32E0kYDM18rp9L+T
         RFXG6Ekn6vHp9GUWXKaFWGNNkL+76cVRFBcwSb32kYQ7h+/xN+8f7LE+lJhx8qE5BFkI
         KWP/maHUovlQKLmhmOJcYVr4FnRZULpNbVnGuZ2GgK4s/A/W8sKuG2O259RUewCWro0c
         Aq6/4ulxeZmX/2mPSBSvixU+RdmL8jyoW727eeCeN6AMN6Cvzh5rp6i7BIszfnY5lVlt
         VfeKX1ZBR74jIN5RZVLz7YUEeU3loLKvyGJozMnm5VprOuve/xMHu69v2mPpLw25wWmr
         dZbg==
X-Gm-Message-State: APjAAAUW5P9gisTz7dyozIKReY4QDtLylPjrD2USHpKmLJWcqxOOSk83
        rOjt4sThs6hKKYqwOKLJCsYRjTP1dqA=
X-Google-Smtp-Source: APXvYqzc8kfgPN9AN9MgcitXkpdCWilW0meQ9p/ArvJ2UJspNn9/Jjt6TwseF4fe6UUI8HtF11Z8UA==
X-Received: by 2002:a37:66c2:: with SMTP id a185mr4060253qkc.211.1578488957243;
        Wed, 08 Jan 2020 05:09:17 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id s11sm1325512qkg.99.2020.01.08.05.09.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2020 05:09:17 -0800 (PST)
Date:   Wed, 8 Jan 2020 05:09:12 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Simon Horman <simon.horman@netronome.com>,
        John Hurley <john.hurley@netronome.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        oss-drivers@netronome.com, Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] netronome: fix ipv6 link error
Message-ID: <20200108050912.6a07008b@cakuba.netronome.com>
In-Reply-To: <CAK8P3a27tFJpMeEuJDQWCHvGyETjM+XbPKenQwroxjc8Qpw=TQ@mail.gmail.com>
References: <20200107200659.3538375-1-arnd@arndb.de>
        <20200107124417.5239a6cf@cakuba.netronome.com>
        <CAK8P3a27tFJpMeEuJDQWCHvGyETjM+XbPKenQwroxjc8Qpw=TQ@mail.gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 7 Jan 2020 23:01:50 +0100, Arnd Bergmann wrote:
> On Tue, Jan 7, 2020 at 9:44 PM Jakub Kicinski wrote:
> > On Tue,  7 Jan 2020 21:06:40 +0100, Arnd Bergmann wrote:  
> > > When the driver is built-in but ipv6 is a module, the flower
> > > support produces a link error:
> > >
> > > drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.o: In function `nfp_tunnel_keep_alive_v6':
> > > tunnel_conf.c:(.text+0x2aa8): undefined reference to `nd_tbl'  
> >
> > Damn, I guess the v2 of that patch set did not solve _all_ v6 linking
> > issues :/ Thanks for the patch.
> >  
> > > Add a Kconfig dependency to avoid that configuration.
> > >
> > > Fixes: 9ea9bfa12240 ("nfp: flower: support ipv6 tunnel keep-alive messages from fw")
> > > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > > ---
> > >  drivers/net/ethernet/netronome/Kconfig | 1 +
> > >  1 file changed, 1 insertion(+)
> > >
> > > diff --git a/drivers/net/ethernet/netronome/Kconfig b/drivers/net/ethernet/netronome/Kconfig
> > > index bac5be4d4f43..dcb02ce28460 100644
> > > --- a/drivers/net/ethernet/netronome/Kconfig
> > > +++ b/drivers/net/ethernet/netronome/Kconfig
> > > @@ -31,6 +31,7 @@ config NFP_APP_FLOWER
> > >       bool "NFP4000/NFP6000 TC Flower offload support"
> > >       depends on NFP
> > >       depends on NET_SWITCHDEV
> > > +     depends on IPV6 != m || NFP =m  
> >
> > Could we perhaps do the more standard:
> >
> >         depends on IPV6 || IPV6=n  
> 
> That would have to be on CONFIG_NFP instead of CONFIG_NFP_APP_FLOWER
> then, making the entire driver a module if IPV6=m but always allowing
> CONFIG_NFP_APP_FLOWER.

Ah, indeed.

> > The whitespace around = and != seems a little random as is..  
> 
> Yep, my mistake. I can send a fixed version, please let me know which
> version you want, or fix it up yourself if you find that easier.

Adding the dependency just to NFP_APP_FLOWER seems clean, please just
fix the whitespace and feel free to add my Acked-by to v2.
