Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 520BC306A8C
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 02:42:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231405AbhA1BkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 20:40:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231377AbhA1Bjx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 20:39:53 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA7A8C061573;
        Wed, 27 Jan 2021 17:38:56 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id p15so2912656pjv.3;
        Wed, 27 Jan 2021 17:38:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mhj94VplAFkADQfm7BXxj5A1TW1GeKrFb8pkt/UHLlo=;
        b=NZO020QXNtYDc4PTbzqPCFpYJQy0RYANuzcRyVB9u/s6BMK/fGUB4ejWb2+tBKJYgE
         h2KOusHIU8giTq4BgXMUzucQFLZmg4sm1M3T2w9Z9MuIp0m/ZGrV1N7CRImRf60BXgaS
         8kbCAtsREpDW4V650VdxJIzr6GCAmg1bBcmMnQ75cAQPsEQoZ4xoKmqtzdNoR+ZeGALv
         rik77Ik/Ao0DBEE2TnTH4w/xkUqLFxNNmZ+DoF6IyK6OWnh4wjNsXDe6f7n6RTQYhp4w
         j6IeNTSDepsq7jdjTgWiDw0GMYMGswzNMyIOYDfV91xwHPM7TvC45buWJjBolUGLOyFt
         FmIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mhj94VplAFkADQfm7BXxj5A1TW1GeKrFb8pkt/UHLlo=;
        b=n0TLn8LGeF2OlKs9iaWEwzPjYBAi2sLBcutYvRL2SjboQx846ugy5nH6GMqdbuGteV
         vXprk964JVmGfDFr3N/39IKujgK+ipxwh9yWtcoYgeAYN/cQB8FBpPG3KXCNdKXJGNNs
         Zu5uPnjCUBH591QZiBTFwIVM3OkNMEm9FKmbJdLUeRTBVKIIoyBX6IcWjjLUzakUnYJ3
         s6XnTG/ogAZ8X/awIjqlAyCiJCVJQXyY1gngeo4ksn8XsvFu8hZo2QAadq/lls3dFxUy
         1/9AwAqWQ1bln5lsojN1Cl1O2+uEQgJbOzd18Yw0huY7ZrG2MfWkVxp51wHtHKUJRv08
         tpdQ==
X-Gm-Message-State: AOAM530sHokyOXhcNO1xzA2nEuscxFtoHO0gGrrmKgw5d6lGFyqNATMy
        VODRT8uXQjKZFa2o2xm6HK5ZTsgQg8fM4GRN0AC38+36Qcssdw==
X-Google-Smtp-Source: ABdhPJxdzuuOQjc4/lTsSK3XjKXtdKFUFZjKJ6Bi17WmwFbXt++FSnSVg7++TFCMO/7S+td0Hf7tXHZG3TybaGbpF+I=
X-Received: by 2002:a17:90a:f98c:: with SMTP id cq12mr8495343pjb.191.1611797936230;
 Wed, 27 Jan 2021 17:38:56 -0800 (PST)
MIME-Version: 1.0
References: <e2dde066-44b2-6bb3-a359-6c99b0a812ea@slava.cc> <20210127165602.610b10c0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210127165602.610b10c0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 27 Jan 2021 17:38:44 -0800
Message-ID: <CAM_iQpUe+UAQ_G8mGJ_R-nupSfVpH3ykaqtNn3WXY+kCKN-u7A@mail.gmail.com>
Subject: Re: BUG: Incorrect MTU on GRE device if remote is unspecified
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Slava Bacherikov <mail@slava.cc>,
        Willem de Bruijn <willemb@google.com>,
        open list <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Xie He <xie.he.0141@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 27, 2021 at 4:56 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 25 Jan 2021 22:10:10 +0200 Slava Bacherikov wrote:
> > Hi, I'd like to report a regression. Currently, if you create GRE
> > interface on the latest stable or LTS kernel (5.4 branch) with
> > unspecified remote destination it's MTU will be adjusted for header size
> > twice. For example:
> >
> > $ ip link add name test type gre local 127.0.0.32
> > $ ip link show test | grep mtu
> > 27: test@NONE: <NOARP> mtu 1452 qdisc noop state DOWN mode DEFAULT group
> > default qlen 1000
> >
> > or with FOU
> >
> > $ ip link add name test2   type gre local 127.0.0.32 encap fou
> > encap-sport auto encap-dport 6666
> > $ ip link show test2 | grep mtu
> > 28: test2@NONE: <NOARP> mtu 1436 qdisc noop state DOWN mode DEFAULT
> > group default qlen 1000
> >
> > The same happens with GUE too (MTU is 1428 instead of 1464).
> > As you can see that MTU in first case is 1452 (1500 - 24 - 24) and with
> > FOU it's 1436 (1500 - 32 - 32), GUE 1428 (1500 - 36 - 36). If remote
> > address is specified MTU is correct.
> >
> > This regression caused by fdafed459998e2be0e877e6189b24cb7a0183224 commit.
>
> Cong is this one on your radar?

Yeah, I guess ipgre_link_update() somehow gets called twice,
but I will need to look into it.

Thanks.
