Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A732BA2BC
	for <lists+netdev@lfdr.de>; Sun, 22 Sep 2019 14:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728549AbfIVMyw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Sep 2019 08:54:52 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:41232 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728488AbfIVMyw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Sep 2019 08:54:52 -0400
Received: by mail-lf1-f66.google.com with SMTP id r2so8057746lfn.8
        for <netdev@vger.kernel.org>; Sun, 22 Sep 2019 05:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=32U2HC0XKAxxH72BPQKrBG2V8xzlwOe6B9x4xCVjFOY=;
        b=VKfR8VSw2uor2fltLOPEUewXMOyG30yzlbfGPOnsIZHpNXMLIYwXXjEpZRZLbBI+Tb
         NWKQC6eWasGq9qEpisvI2utGspCofjfvOBYxdN2pnWc9eGDwhvQiTHuIKtAH2fROAGy+
         MMYLQln1pw+6QXMo5mTA/ngDJ1sEFz1T2BTyeflU2boxFB9AlqofSKFWa6Enu9nCmm9D
         tuWds9EGW03SRoGAMciVp0u7qr70yUPIREuRM8vmKYw1KfN4B1s+rYowTJdlniMubnsW
         xYx3b0tcVJDT4IAaQfPqSt4BWW+3mS031n3JntX8oNKUpJrzE9Bpeo24rzz+AAGsC/KQ
         BaPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=32U2HC0XKAxxH72BPQKrBG2V8xzlwOe6B9x4xCVjFOY=;
        b=HBzXR/lMaJZXKlmEmrqOQWKIkJLeO15/aN0ZYixMNvdxJoitpZP6xFriyCyC/zDL/u
         XXRn7SpymXVz4e/klzkzFNphMgRqSnE5SIpsljNGBdpT7T58onmsqCiWwSReKwPAtnFp
         jOvg9+lD8s2tSD/ufgkJMXqy0qXJrmZTJ1z0HhQgMBa1E9T05ZDVxeP0s0HYQuIRCIo8
         Np/pG1Z6sB7fR0HEraJbT8zEzo03wRpPWpjDND++s512+7/zP7vZpXTieoLqyN6fZBTk
         13oyS9doorTA6sYLa5tfEGLi6+SHMqms7Yp0Xhak9/EzmNA4AZqr6fEUfusdbBJ+SdH3
         gx5g==
X-Gm-Message-State: APjAAAXh/Jv1d63+p7RCfBIunzPM3zTvME8uIW6OZpJS80CWZ9BqLE+C
        cON89gf9o+KtAVmzZrToE91lnVZoVdg/7LOf1x8=
X-Google-Smtp-Source: APXvYqzXOsmkPwQ8VeVsJ3uMFRAD7OSdUBZS/6ctm9Dx2YTTJojqV3c1B90rTZh2DPKQAen51rGo/UBiJhtPSB9JMp0=
X-Received: by 2002:a19:2207:: with SMTP id i7mr14023106lfi.185.1569156888988;
 Sun, 22 Sep 2019 05:54:48 -0700 (PDT)
MIME-Version: 1.0
References: <20190916134802.8252-1-ap420073@gmail.com> <20190916134802.8252-10-ap420073@gmail.com>
 <20190920165504.2ed552ac@cakuba.netronome.com>
In-Reply-To: <20190920165504.2ed552ac@cakuba.netronome.com>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Sun, 22 Sep 2019 21:54:37 +0900
Message-ID: <CAMArcTXv2B8uOVKqvJiPv2c3uBKvXBf_Fb+R2Wr+AJGmN6=q4w@mail.gmail.com>
Subject: Re: [PATCH net v3 09/11] net: core: add ignore flag to
 netdev_adjacent structure
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, j.vosburgh@gmail.com,
        vfalico@gmail.com, Andy Gospodarek <andy@greyhouse.net>,
        =?UTF-8?B?SmnFmcOtIFDDrXJrbw==?= <jiri@resnulli.us>,
        sd@queasysnail.net, Roopa Prabhu <roopa@cumulusnetworks.com>,
        saeedm@mellanox.com, manishc@marvell.com, rahulv@marvell.com,
        kys@microsoft.com, haiyangz@microsoft.com,
        Stephen Hemminger <stephen@networkplumber.org>,
        sashal@kernel.org, hare@suse.de, varun@chelsio.com,
        ubraun@linux.ibm.com, kgraul@linux.ibm.com,
        Jay Vosburgh <jay.vosburgh@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 21 Sep 2019 at 08:55, Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Mon, 16 Sep 2019 22:48:00 +0900, Taehee Yoo wrote:
> > In order to link an adjacent node, netdev_upper_dev_link() is used
> > and in order to unlink an adjacent node, netdev_upper_dev_unlink() is used.
> > unlink operation does not fail, but link operation can fail.
> >
> > In order to exchange adjacent nodes, we should unlink an old adjacent
> > node first. then, link a new adjacent node.
> > If link operation is failed, we should link an old adjacent node again.
> > But this link operation can fail too.
> > It eventually breaks the adjacent link relationship.
> >
> > This patch adds an ignore flag into the netdev_adjacent structure.
> > If this flag is set, netdev_upper_dev_link() ignores an old adjacent
> > node for a moment.
> > So we can skip unlink operation before link operation.
> >
> > Signed-off-by: Taehee Yoo <ap420073@gmail.com>
>
> Could this perhaps be achieved by creating prepare, commit, and abort
> helpers? That would make the API look slightly more canonical.
>
> netdev_adjacent_change_prepare(old, new, dev)
> netdev_adjacent_change_commit(old, new, dev)
> netdev_adjacent_change_abort(old, new, dev)
>
> The current naming makes the operation a little harder to follow if one
> is just reading the vxlan code.
>

I fully agree with your opinion.
I will provide these three functions that you mentioned.
   netdev_adjacent_change_prepare
   netdev_adjacent_change_commit
   netdev_adjacent_change_abort

> Please let me know if I didn't read the code closely enough to
> understand why that's not fitting here.
>
> > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > index 5bb5756129af..4506810c301b 100644
> > --- a/include/linux/netdevice.h
> > +++ b/include/linux/netdevice.h
> > @@ -4319,6 +4319,10 @@ int netdev_master_upper_dev_link(struct net_device *dev,
> >                                struct netlink_ext_ack *extack);
> >  void netdev_upper_dev_unlink(struct net_device *dev,
> >                            struct net_device *upper_dev);
> > +void netdev_adjacent_dev_disable(struct net_device *upper_dev,
> > +                              struct net_device *lower_dev);
> > +void netdev_adjacent_dev_enable(struct net_device *upper_dev,
> > +                             struct net_device *lower_dev);
> >  void netdev_adjacent_rename_links(struct net_device *dev, char *oldname);
> >  void *netdev_lower_dev_get_private(struct net_device *dev,
> >                                  struct net_device *lower_dev);

I found that I missed static keyword.
So I will fix this too.

Thank you!
