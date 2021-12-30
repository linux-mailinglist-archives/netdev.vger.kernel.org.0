Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93DE5482045
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 21:30:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242096AbhL3Uat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 15:30:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242088AbhL3Uat (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 15:30:49 -0500
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83A3DC061574
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 12:30:48 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id q8so26606205ljp.9
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 12:30:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fungible.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DL4aodp5CYPL83EmvEB4xdO9ZsdKYoX6PImtP+LzsC0=;
        b=e69qMv9yGoRCjPhvy1oH0/sqeo0Jv6m84aWaoEfVlbdgNBb1sq4F8ulxyuy21fEwL1
         EAv0jfPh3Kd7I9EiyQ75ceuMPWs73iaIxUdFv/LhehleOREDJy4lWUdhR1HkCHTQXpEC
         ca2r9pfb0NdOm8GYDZ3AwTrV0eZskbKrJZTus=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DL4aodp5CYPL83EmvEB4xdO9ZsdKYoX6PImtP+LzsC0=;
        b=Yb2y2stEZY16M2iLO4UT78LtMv/FMHU0VKtnpUTHh7KnhQ8bVZEl5x+HEwptL9M6BU
         PA2gicPDjwMYBtNlr7vrx9KLtYiALRKTYFmxN66KKt/SFZvjsctCkLtXA3zxiJqS3pFP
         7aOui9rU3xXgEIN1WBoIaf3T/kH6jwPJ4WYs1+xECQ8yJdeH32pQmQfkpsG2P+fuH47x
         BdHtF3NTIy2og5WGBlL585epnVX9Qxr/gHJ6Uh5PotqKkpenkd4WgNAiOYYMbqAeorHJ
         bP913W920h237HSWxIzk3KHdtDgQzmNdi63dGD6fBLYyXRugDGG1uDDTMQQTJIdzI030
         xjZA==
X-Gm-Message-State: AOAM531dmbk5br0dGBgA7NJdxortGxxsmda43rFLSzXPFTnlWRQInk8L
        Skt7+2v8K8k9wI9vdn0hORSPmsuOyuUDq98+Om8YFw==
X-Google-Smtp-Source: ABdhPJwNRDSuEZUv9M7/116V3YIJRr5P0sKXaLBX+fAPlxGFfzdRlla0cmC6aeKayXhEJ7OZvF+FOkGzlzzqZLdQhOk=
X-Received: by 2002:a2e:7c0b:: with SMTP id x11mr23247444ljc.198.1640896246727;
 Thu, 30 Dec 2021 12:30:46 -0800 (PST)
MIME-Version: 1.0
References: <20211230163909.160269-1-dmichail@fungible.com>
 <20211230163909.160269-5-dmichail@fungible.com> <Yc30mG7tPQIT2HZK@lunn.ch> <20211230122227.6ca6bfb7@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20211230122227.6ca6bfb7@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Dimitris Michailidis <d.michailidis@fungible.com>
Date:   Thu, 30 Dec 2021 12:30:34 -0800
Message-ID: <CAOkoqZm2uA--rd1JwaR7hD4mc4Mevbu=H+eFK=+A1btmpzB7iA@mail.gmail.com>
Subject: Re: [PATCH net-next 4/8] net/funeth: ethtool operations
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, davem@davemloft.net,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 30, 2021 at 12:22 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 30 Dec 2021 19:04:08 +0100 Andrew Lunn wrote:
> > > +static void fun_get_drvinfo(struct net_device *netdev,
> > > +                       struct ethtool_drvinfo *info)
> > > +{
> > > +   const struct funeth_priv *fp = netdev_priv(netdev);
> > > +
> > > +   strscpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
> > > +   strcpy(info->fw_version, "N/A");
> >
> > Don't set it, if you have nothing useful to put in it.
>
> Also, if user has no way of reading the firmware version how do they
> know when to update the FW in the flash? FW flashing seems pointless
> without knowing the current FW version.

It will be available, but FW hasn't settled on the API for it yet.
There are several FW images on the devices, one will be reported here but
will rely on devlink for the full set.
