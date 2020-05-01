Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5708C1C0DF4
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 08:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728271AbgEAGC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 02:02:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbgEAGC0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 02:02:26 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2536C035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 23:02:25 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id x10so1968882oie.1
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 23:02:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BoNz0cEIpfl8h+7hyvOfwRTG2DRLdXD+r9i2X6RcnGY=;
        b=NCLtv+wNUxRsSWGZxRoXf2r3Kc+PjQ+sjE6M68F6KPc50UW8WXyzjEgIXTJOY/e2KD
         doHNAYD7Dqa1KdpVzlMQzaaWwkpMU/33GZceSPPY6q0z8I2seOBXUEvd47IUsWhwQgq6
         6Yrp8KC4oXF94gOFODCKhUEQ5b7QuZW0RAdBFnOcNmuIi4J7Vou1kBO9FJ7DpH+bbdxG
         Em4tsXpeltBPRYLkSygCoFDM7uaIBgPKr7t6ZDy9k3OqxsSnRFkcwcpbCGwmf0rpVPWC
         QEUyReL3SfSyYEx7/HiC5egunHLxkXxx7R/T0h16MXVF7BRYtg1T9WgHbFIZmDSQUk6t
         0VkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BoNz0cEIpfl8h+7hyvOfwRTG2DRLdXD+r9i2X6RcnGY=;
        b=ZYHCXh81gL+uWeQOyMUi6d3U3DyxCs2nbT5zH6nqn0wjMg5qBJ6xEEVooJ6zVCSuBg
         /hz33BFDva0UwnE+qtYelO3hX8WUGfUqRkvHI1NtR8Nlq6nWfGwN2hCGHV0wDOKKpqXN
         +pM4WEYbiBNkigRHvABX/AI6mkp6TGPfr/FFaqc+OC39FqoZGWaotoVuJ/BviFRnQkyp
         /KuWRX+8Admq3bAe4Hk+GEOZTNr4DLAiDDgL64YmyEuxjIdPpSrNW2Ljv+w+LTAXPqB5
         rOte58r4jKd9iiWKJmI9aswRzeA0X6oCX4aaW/nBkebpoA9Qghg7UEA+FAspLi+9wYdd
         YRsg==
X-Gm-Message-State: AGi0PubayOmoGx6SIlG3bDP2xjM6EG+BH2GpTLLOMPglAWkTPBDAfjNr
        Jt3teKm0Ej/S/VpgWkBtEH9Hw14up5jQx8Vp8DI=
X-Google-Smtp-Source: APiQypLsxf7me+g8V6EDB/BrzErraGl6ESm4paiAU3rDlG2ngJ1QhpZpwsW5we+MO9n2Z75V2dE+oyE54rjCQaY9CSo=
X-Received: by 2002:aca:4c95:: with SMTP id z143mr2070444oia.5.1588312945203;
 Thu, 30 Apr 2020 23:02:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200428060206.21814-1-xiyou.wangcong@gmail.com>
 <20200428060206.21814-2-xiyou.wangcong@gmail.com> <CAMArcTU2r2undM5119_1W=pc2fu5AtUDp2RtizjVayRY=fGVEg@mail.gmail.com>
In-Reply-To: <CAMArcTU2r2undM5119_1W=pc2fu5AtUDp2RtizjVayRY=fGVEg@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 30 Apr 2020 23:02:14 -0700
Message-ID: <CAM_iQpWdf+K7n+YfZv-+_Cz5b9+kxXV0F0PfYuUyHJ574OEGsA@mail.gmail.com>
Subject: Re: [Patch net-next 1/2] net: partially revert dynamic lockdep key changes
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        syzbot <syzbot+aaa6fa4949cc5d9b7b25@syzkaller.appspotmail.com>,
        Dmitry Vyukov <dvyukov@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 30, 2020 at 12:40 AM Taehee Yoo <ap420073@gmail.com> wrote:
> > +static void vlan_dev_set_lockdep_one(struct net_device *dev,
> > +                                    struct netdev_queue *txq,
> > +                                    void *_subclass)
> > +{
> > +       lockdep_set_class_and_subclass(&txq->_xmit_lock,
> > +                                      &vlan_netdev_xmit_lock_key,
> > +                                      *(int *)_subclass);
>
> I think lockdep_set_class() is enough.
> How do you think about it?

Good catch. I overlooked this one. Is lockdep_set_class() safe
for vlan stacked on vlan?

Thanks.
