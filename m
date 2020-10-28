Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 060EA29DE67
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 01:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732307AbgJ1WTJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:19:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:60526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731661AbgJ1WRk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 18:17:40 -0400
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03F3B24746;
        Wed, 28 Oct 2020 13:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603891239;
        bh=+zcA/6pTJEiqhEIB6b9u13iGz/vyrIiNkbw5+OfR3RU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=G8BbRQyz/59LYY1N42cxCAJhwL18YtebLWmX5CIxnlOO5I2ajUNwDm2lyKa9cslSa
         vQY7OdvwsOhagPj5BoHEV4HJ3tuxYWcLqCNhIwoKiuqVpk4NL3i1jX9p2cUUbEdOPy
         KA+YZ6F+a9vywgLP/ys9YSb7KiyrzgLubZq7l5gU=
Received: by mail-lj1-f169.google.com with SMTP id y16so6313501ljk.1;
        Wed, 28 Oct 2020 06:20:38 -0700 (PDT)
X-Gm-Message-State: AOAM531qtEGQyjQZNPEI+7miht5Sk4MoSM67qEH1C1l57DZrXm/xXlS7
        oOomT8wRdnYUKjE+uVX/fyMQpQB09iU1+rS5Wkg=
X-Google-Smtp-Source: ABdhPJwPj+jJVO+NGNXNwzAOQ7QC4CMa7GE7JJfMww785BE/4plVH+2GBu818TRJNl+lheV7rkZknd5yyXXDquGphqE=
X-Received: by 2002:a2e:b8c8:: with SMTP id s8mr3141184ljp.189.1603891237138;
 Wed, 28 Oct 2020 06:20:37 -0700 (PDT)
MIME-Version: 1.0
References: <20201027212448.454129-1-arnd@kernel.org> <20201028103456.GB1042@kadam>
In-Reply-To: <20201028103456.GB1042@kadam>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Wed, 28 Oct 2020 14:20:20 +0100
X-Gmail-Original-Message-ID: <CAK8P3a03Oi-hKh9Db95K_ou_Lk5svWAo5HV8ZgxuktJi2RWS2A@mail.gmail.com>
Message-ID: <CAK8P3a03Oi-hKh9Db95K_ou_Lk5svWAo5HV8ZgxuktJi2RWS2A@mail.gmail.com>
Subject: Re: [RFC] wimax: move out to staging
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        driverdevel <devel@driverdev.osuosl.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 11:34 AM Dan Carpenter <dan.carpenter@oracle.com> wrote:
> On Tue, Oct 27, 2020 at 10:20:13PM +0100, Arnd Bergmann wrote:
> > From: Arnd Bergmann <arnd@arndb.de>
> >
> > There are no known users of this driver as of October 2020, and it will
> > be removed unless someone turns out to still need it in future releases.
> >
> > According to https://en.wikipedia.org/wiki/List_of_WiMAX_networks, there
> > have been many public wimax networks, but it appears that these entries
> > are all stale, after everyone has migrated to LTE or discontinued their
> > service altogether.
>
> Wimax is still pretty common in Africa.  But you have to buy an outdoor
> antenae with all the software on it and an ethernet cable into your
> house.

Ah, good to know, thanks for the information. I'll include that when
I resend the patch, which I have to do anyway to avoid a small
regression. I did a look at a couple of African ISPs that seemed to
all have discontinued service, but I suppose I should have looked
more carefully.

>  I don't know what software the antennaes are using.  Probably
> Linux but with an out of tree kernel module is my guess.

Right, it seems very unlikely that they would be using the old
Intel drivers, and it's also unlikely that they are updating those
boxes to new kernels. I found a firmware image for Huawei
BM623m, which runs a proprietary kernel module for the wimax
stack on an MT7108 (arm926) phone chip running a
linux-2.6.26.8-rt16 kernel.

       Arnd
