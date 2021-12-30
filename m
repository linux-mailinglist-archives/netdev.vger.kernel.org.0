Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2A0D482057
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 21:56:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242134AbhL3U4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 15:56:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242120AbhL3U4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 15:56:24 -0500
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3103BC061574
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 12:56:23 -0800 (PST)
Received: by mail-lj1-x229.google.com with SMTP id v15so42605576ljc.0
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 12:56:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oMMtIqXHzYB/M3zsnIZOh1gP4yopaX27pgBBaEEbYT8=;
        b=CgLZmBmXESvxEwmlHGAEmCZlK1t4b0rTdycHcIjUgK7wJhPq/3iE+YUi4voUjxd6II
         RVtLNvjp0Zr378o/nwklc8EwCK1eyKYo7kIjw5ZTxDeoOuSD/P/vvDs48B2S2NjU07Df
         8bMzs8GR33TfYaQhqM/HdFA/no0UnYZYq68NA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oMMtIqXHzYB/M3zsnIZOh1gP4yopaX27pgBBaEEbYT8=;
        b=GfwZajqaDImPzo90NH8vbeKE8uQEM1qg6JzXKrJRB6wEmC1o/jmbuAw7PMIJQ7l4Ki
         4to0F9x3kgTaBYZfyYk2ejduP27GOmr2n69loWQ2Z+HaDNThT3ggTuIt+Szq//FV8IJI
         UrGKd5zgKMEVyxDjwJ6njX2xiJp2aqrCxXK22Z8SZmZCpnAm5+mG+ihxfoUF9lFM+iXI
         hQnUYYTo3cRupBLXDCtJVh1ASqj8mdlTppVVAVCPKMLJ7QoX2iDVmgyfn9boXGPa9LIP
         ZS+9h4BzxT7exYRFg2LwiYwne7GVBQ0dD1tZbPAMNBZQcZ4Wa7mdb1WG64EGxriQnvi7
         I90w==
X-Gm-Message-State: AOAM530MMwQqu6K16efmnMpGBIqLq3Uf2LAkAWQJBbpq8Km5Mc4RjRr9
        Jg0s/4BcDO0S0+VyBRsG/FMFQmQObzebOiTvDk2Ayw==
X-Google-Smtp-Source: ABdhPJxV62N5WhI/woxTRUoZao7dxgu5wgy+1IfjvNj27wi3G64jrvIASnCBJZgrIMVHhXMWYDVztv0aG3aPucG24y8=
X-Received: by 2002:a2e:a4d2:: with SMTP id p18mr26865054ljm.471.1640897781350;
 Thu, 30 Dec 2021 12:56:21 -0800 (PST)
MIME-Version: 1.0
References: <20211230163909.160269-1-dmichail@fungible.com>
 <20211230163909.160269-5-dmichail@fungible.com> <Yc30mG7tPQIT2HZK@lunn.ch>
 <20211230122227.6ca6bfb7@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CAOkoqZm2uA--rd1JwaR7hD4mc4Mevbu=H+eFK=+A1btmpzB7iA@mail.gmail.com> <20211230124316.0a6f5fe6@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20211230124316.0a6f5fe6@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Dimitris Michailidis <d.michailidis@fungible.com>
Date:   Thu, 30 Dec 2021 12:56:09 -0800
Message-ID: <CAOkoqZ=PPhS0Xnu6ecBR9YbKoXLfkbQ7jUxWtVaD2ofJ0LK89g@mail.gmail.com>
Subject: Re: [PATCH net-next 4/8] net/funeth: ethtool operations
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, davem@davemloft.net,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 30, 2021 at 12:43 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 30 Dec 2021 12:30:34 -0800 Dimitris Michailidis wrote:
> > On Thu, Dec 30, 2021 at 12:22 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > On Thu, 30 Dec 2021 19:04:08 +0100 Andrew Lunn wrote:
> > > > > +static void fun_get_drvinfo(struct net_device *netdev,
> > > > > +                       struct ethtool_drvinfo *info)
> > > > > +{
> > > > > +   const struct funeth_priv *fp = netdev_priv(netdev);
> > > > > +
> > > > > +   strscpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
> > > > > +   strcpy(info->fw_version, "N/A");
> > > >
> > > > Don't set it, if you have nothing useful to put in it.
> > >
> > > Also, if user has no way of reading the firmware version how do they
> > > know when to update the FW in the flash? FW flashing seems pointless
> > > without knowing the current FW version.
> >
> > It will be available, but FW hasn't settled on the API for it yet.
> > There are several FW images on the devices, one will be reported here but
> > will rely on devlink for the full set.
>
> Can we defer the FW flashing to that point as well, then?
> It's always a bit risky to add support for subset of functionality
> upstream given the strict backward compat requirements.

Sure, I'll cut out the bulk of the devlink file.
