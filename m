Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD7A91C79E9
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 21:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728065AbgEFTIs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 15:08:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728052AbgEFTIr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 15:08:47 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3414C061A0F
        for <netdev@vger.kernel.org>; Wed,  6 May 2020 12:08:47 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id t3so2306289otp.3
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 12:08:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ecBYceWjDgZ/2fZ72buGKHk7iZ9mzG9U5SbQIXW25v0=;
        b=P19XaUFk7DUdpT3aNVnbXtOBBudH0AirMDp8PbA5ONffgmpZpXaxVtSq6GmJ9egVEK
         oYCtdbQc5wLThf42yTL+PFg533NYbFVEvU89iEACIjpqigYyp+rJoneiELtEO3Iz2pK7
         Ymt+j8nGkw1lebLWn9ippYqtEX66oFaqp63rkYtbr7Yrp6vqDOZF8FiZi58BM9XX3aPQ
         QFFXBAMZlVnVuEhg0s29IK9gvKAq/vFKTjwvJJbt5v8+DyZG83YG/7OpTOIRkpBYBwUf
         10Cmv4W3wJVOCXRAUxIXClih8/Tk+84D+7QuvR6hICJOL8vHWPLiEhIhA/8kZrPGldUv
         cRTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ecBYceWjDgZ/2fZ72buGKHk7iZ9mzG9U5SbQIXW25v0=;
        b=arbyr5Yg5Tqnkgcz8cuqbg+jWkM39WsgYSkxI0uzki/dlBffc3ldLpONnc9zOu0q+E
         GaSfyxh6F81+KSSkcc5uvOlQll7jckDhk23x8VONeIIicJxIovQ/1fZs3cOI2A5LvlJq
         dmGdVD82sMxORNxIG+5NdU51NdXE7+FWrsKbERfoGU/bWdD388hdC0pYo3vuT+CpY08t
         SL9vVzA3wwik3eDFSllmWYzSsnB+eerL1lmKxuj3LlWYxRpmn+HVpDwkNMu+wCxC0Lpq
         olpfbZrPitYc0Mjgp8GLKteM8GVNXZKI4Vp2be6e8LIJaE3V3uErgeThyQwl1cjlL6vA
         I+Gw==
X-Gm-Message-State: AGi0Pub6VqNC4nrdpVCYnFTVK6M24y86yjFtg4jbOZVg7vxlW0Qk/ddQ
        AVHumMn9fKRIcX7QsD4timKVPAdfrgIJSdc0NTQ=
X-Google-Smtp-Source: APiQypJ5ivykOe62LZsJi7h0gUqNl7dRfWpM13n67j6dYZssP4yCG6l6k40lAbPi4+TL3syZgOpolegehiKg8CYiSpg=
X-Received: by 2002:a9d:1c97:: with SMTP id l23mr5966495ota.189.1588792127042;
 Wed, 06 May 2020 12:08:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200505215819.1997-1-xiyou.wangcong@gmail.com>
 <20200505222748.GQ8237@lion.mk-sys.cz> <CAM_iQpWf95vVC4dsWTuxCNbNLN6RAMJQYdNeB37VZMN2P2Xf2w@mail.gmail.com>
 <20200506052604.GM5989@lion.mk-sys.cz>
In-Reply-To: <20200506052604.GM5989@lion.mk-sys.cz>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 6 May 2020 12:08:35 -0700
Message-ID: <CAM_iQpWTW_O7WHx5-4BLXqiV3e-eYowGRv-aG-LRZmJwvdyt5A@mail.gmail.com>
Subject: Re: [Patch net] net: fix a potential recursive NETDEV_FEAT_CHANGE
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzbot <syzbot+e73ceacfd8560cc8a3ca@syzkaller.appspotmail.com>,
        syzbot+c2fb6f9ddcea95ba49b5@syzkaller.appspotmail.com,
        Jarod Wilson <jarod@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Jann Horn <jannh@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 5, 2020 at 10:26 PM Michal Kubecek <mkubecek@suse.cz> wrote:
>
> On Tue, May 05, 2020 at 03:35:27PM -0700, Cong Wang wrote:
> > On Tue, May 5, 2020 at 3:27 PM Michal Kubecek <mkubecek@suse.cz> wrote:
> > > On Tue, May 05, 2020 at 02:58:19PM -0700, Cong Wang wrote:
> > > > diff --git a/net/core/dev.c b/net/core/dev.c
> > > > index 522288177bbd..ece50ae346c3 100644
> > > > --- a/net/core/dev.c
> > > > +++ b/net/core/dev.c
> > > > @@ -8907,7 +8907,7 @@ static void netdev_sync_lower_features(struct net_device *upper,
> > > >                       netdev_dbg(upper, "Disabling feature %pNF on lower dev %s.\n",
> > > >                                  &feature, lower->name);
> > > >                       lower->wanted_features &= ~feature;
> > > > -                     netdev_update_features(lower);
> > > > +                     __netdev_update_features(lower);
> > > >
> > > >                       if (unlikely(lower->features & feature))
> > > >                               netdev_WARN(upper, "failed to disable %pNF on %s!\n",
> > >
> > > Wouldn't this mean that when we disable LRO on a bond manually with
> > > "ethtool -K", LRO will be also disabled on its slaves but no netlink
> > > notification for them would be sent to userspace?
> >
> > What netlink notification are you talking about?
>
> There is ethtool notification sent by ethnl_netdev_event() and rtnetlink
> notification sent by rtnetlink_event(). Both are triggered by
> NETDEV_FEAT_CHANGE notifier so unless I missed something, when you
> suppress the notifier, there will be no netlink notifications to
> userspace.

Oh, interesting, why ethtool_notify() can't be called directly, for example,
in netdev_update_features()? To me, using a NETDEV_FEAT_CHANGE
event handler seems unnecessary for ethtool netlink.

BTW, as pointed out by Jay, actually we only need to skip
NETDEV_FEAT_CHANGE for failure case, so I will update my patch.

Thanks.
