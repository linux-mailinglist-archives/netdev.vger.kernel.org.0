Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C13225B36E
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 20:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726177AbgIBSHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 14:07:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727980AbgIBSHH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 14:07:07 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F87BC061244
        for <netdev@vger.kernel.org>; Wed,  2 Sep 2020 11:07:07 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id v4so295049wmj.5
        for <netdev@vger.kernel.org>; Wed, 02 Sep 2020 11:07:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5W5tADREb76SQnHT4yvnZFbzawupyGoPTSNz4PRRGZA=;
        b=FIv7cSrz2bc2HakEJvj/cJsFAkJ3gPrFd/tmtfJTPw+XFWo20hN88WKzuRUTPWDZDV
         xMcu+UVB/fMJL5ju0eoLztYCzwqiYNWJ1zf90PoGobnI/cJk3aZKWAfDX3PuJ4W2CsWs
         Vb8YGE5auS4UYoFKNjOoHvoxSgxsm1Ucd9Pu4ygndQLvlkUbo/2xGCyTELOYYBtz/YuS
         5xvkbKJX7tnHkD1JrHemgNWUi+gWMqswbfSCz3lbmK8jEa1/ik4gkrLEn56Bmd5hhGd5
         uf5aKWrPereFeY9jYvgUFDrltKguHEPYOBwsVrK75wG5BhVho9LU0xD3e+gpMaq/FwA3
         uBew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5W5tADREb76SQnHT4yvnZFbzawupyGoPTSNz4PRRGZA=;
        b=kiTKIinZ9t9thXUKS3Ujs2dIu3aPIsQBo/Wki2uTQj4h/P8Bb0q1m5PFdlMheK6UvC
         RYXfvIY11htx+OeMt4/pUGrqRrQTztsDvIG3CVLX6L0Cx5/tOFDmY74Lebi8d6nvX8k8
         rHK4sUyd+ajMIMgdd3KHVNSmGRz3wqgREpC8Zc1zcfyHCbkh7tx6Ez7LxxG8BCzwt6fy
         IY6bauLbt2knkc+qUWRoLnssKo0qup+H+sZi2K7vj7YImSuSUHrad/+DD00fGwjgaA8b
         ZX6S7tV/F6UhxfBIH0IG7fc1201GAbMqf3auNhrJOgQMqsmP/CraelKWNlLz7uadQVOP
         yOvA==
X-Gm-Message-State: AOAM533VYWeaWPpbmtC3Aogkm/e5PEyo/aJjgk5UpWgHr/Lr4Y4RvPTY
        PX8Ytu5OLefVSeAEGAt3vYD2XbqLmO581fNRjFDYZg==
X-Google-Smtp-Source: ABdhPJywua+J79SqwFQ+bswT9SFCCQHINbuvx+WoL88BpV9EOA3iKHj/Tk3OV0ZsYE8yLo8Vb8WqOzA5R5Gae2cFzi8=
X-Received: by 2002:a7b:c14d:: with SMTP id z13mr1790276wmi.19.1599070025858;
 Wed, 02 Sep 2020 11:07:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200901212009.1314401-1-yyd@google.com> <20200901220200.GB3050651@lunn.ch>
 <CAPREpbaFi6Tqw+YKx=1c1nFRtUt9G2gRW2BT83siqojy=DOEmA@mail.gmail.com> <20200902070359.upkax24olhzksxhi@lion.mk-sys.cz>
In-Reply-To: <20200902070359.upkax24olhzksxhi@lion.mk-sys.cz>
From:   Kevin Yang <yyd@google.com>
Date:   Wed, 2 Sep 2020 14:06:54 -0400
Message-ID: <CAPREpbYwhte+KED5f2hq96b1oUxaM9QOwdEtqv14qWMG=ZAVrg@mail.gmail.com>
Subject: Re: [PATCH ethtool] ethtool: add support show/set-hwtstamp
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     Andrew Lunn <andrew@lunn.ch>, Networking <netdev@vger.kernel.org>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 2, 2020 at 3:04 AM Michal Kubecek <mkubecek@suse.cz> wrote:
>
> On Tue, Sep 01, 2020 at 08:36:08PM -0400, Kevin Yang wrote:
> > On Tue, Sep 1, 2020 at 6:02 PM Andrew Lunn <andrew@lunn.ch> wrote:
> > > On Tue, Sep 01, 2020 at 05:20:09PM -0400, Kevin(Yudong) Yang wrote:
> > > > Before this patch, ethtool has -T/--show-time-stamping that only
> > > > shows the device's time stamping capabilities but not the time
> > > > stamping policy that is used by the device.
> > >
> > > How does this differ from hwstamp_ctl(1)?
> >
> > They are pretty much the same, both use ioctl(SIOCSHWTSTAMP).
> >
> > Adding this to ethtool is because:
> > - This time stamping policy is a hardware setting aligned with ethtool's
> > purpose "query and control network device driver and hardware settings"
> > - ethtool is widely used, system administrators don't need to install
> > another binary to control this feature.
>
> Adding this feature to ethtool IMHO makes good sense, I'm just not sure
> if it's necessary to add new subcommands, perhaps we could add the
> "show" part to -T / --show-time-stamping and add --set-time-stamping.

Thanks for the nice suggestion. This sounds good to me, I will work on v2
to have:
"-T / --show-time-stamping" to show capabilities AND current policy;
and "--set-time-stamping" to change the policy.

> However, I don't like the idea of adding a new ioctl based interface to
> ethtool while we are working on replacing and deprecating existing one.
> I would much rather like adding this to the netlink interface (which
> would, of course, require also kernel side implementation).
>
> Michal
