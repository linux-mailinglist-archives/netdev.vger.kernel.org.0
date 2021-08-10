Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCDAD3E5B85
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 15:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241350AbhHJN0N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 09:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241498AbhHJN0I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 09:26:08 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FD81C061371
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 06:25:14 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id h1so32100007iol.9
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 06:25:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5wI5vjZZ0N0xPr632Wczu3IGDMpiaptLG/Mo0n9fP34=;
        b=ZfoyY2VZnunw3CfnjGJAKYMSRIyhOIV5siCwbm3INKWaRSW8Zw/rXhiJ2y6z9I9tIS
         g+yN3lPlI5PdxikXDPOJSXLepb2GJPPF8R8cEZN/qEZBQEeH1+wfVr1xKxxxvTsbgZP7
         wLJKEy/3yrJELRieG1rQS1ihyPJu/0o4Ix7m1+BBuUKSyTIW2tDyoWlVVbecsx9k6kPV
         jERmCWPR25Qfw5NWckZb2pSum28Gbzp8klxAlvoq9Q+z5Zz0qmrdNBWxbQDfbNVTLPDy
         GhLwAb8SkeH5BS4XdK68mv0knPmb7s2UHvuTD4sYS5Rla9Z22nkP+WuMHGyUAvCSNYLL
         zK2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5wI5vjZZ0N0xPr632Wczu3IGDMpiaptLG/Mo0n9fP34=;
        b=mjQIV9/+8ToOkWLzhRwa/CWfM6IZNHjLA1vjvaYoerKCfVNNB2Lx1MHk44Er+SHCNP
         itci31ekx0tUb4ywVMaLSHjhbuWNg5XdDPHksF8ll6uq9fNP0++yQioXHcivCuE87dqf
         3+rHfbsqPrwmqEmHg9ZzEf0Vo6CB+D6nEHXJ3GwXA48LKXtcsRHDbJTwYmab7Vo9XhFy
         nS6wDoT/QrLiJ3DZ4tGZ6HDxY1Mvgvu4cqvTA06h6OZYR8GQeVeH706A0rP7awzWWgmk
         UfaNVMPEpEp1gVCllph/DY21G7PHy2V2bui28WCnlG/mYyLhMvxE+2P4P2l1I6v/I0fn
         r/dw==
X-Gm-Message-State: AOAM531FdQaGBdIcil+4Vk39ILLV/a0re6dTQl8JlfDbW43hmddaGD0v
        UxVCqLp9Ki/lfnPIAZdXqwLb9wzDBXCWomf0ayI=
X-Google-Smtp-Source: ABdhPJxDlloEUJPM2G4xXmE653VgNn9hSGGyLo83RJ/3iyquS9Taz9aP7eOvc38ew1mwl4ghkj6xF4ofyO7lemDiga4=
X-Received: by 2002:a02:3b11:: with SMTP id c17mr9557815jaa.63.1628601913899;
 Tue, 10 Aug 2021 06:25:13 -0700 (PDT)
MIME-Version: 1.0
References: <20210722110325.371-1-borisp@nvidia.com> <20210722110325.371-5-borisp@nvidia.com>
 <20210723060631.GA32369@lst.de> <CAJ3xEMjFOPFfU4ibFJPYdYUSh0nFkRwfW1cdAV2BMvg1aaP_eg@mail.gmail.com>
 <20210804072918.17ba9cff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <CAJ3xEMjYSPczpZ1c_5DnhFtGgpU9PT3VQ0_vgDinizXjLxL_0A@mail.gmail.com>
In-Reply-To: <CAJ3xEMjYSPczpZ1c_5DnhFtGgpU9PT3VQ0_vgDinizXjLxL_0A@mail.gmail.com>
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Tue, 10 Aug 2021 16:25:02 +0300
Message-ID: <CAJ3xEMhozmy3kDNU1=1kEM3Wqgvb4bFpMC7Wxrwq=U2xYMOMtg@mail.gmail.com>
Subject: Re: [PATCH v5 net-next 04/36] net/tls: expose get_netdev_for_sock
To:     Christoph Hellwig <hch@lst.de>
Cc:     Boris Pismenny <borisp@nvidia.com>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>,
        Yoray Zack <yorayz@nvidia.com>, benishay@nvidia.com,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 4, 2021 at 6:07 PM Or Gerlitz <gerlitz.or@gmail.com> wrote:
> On Wed, Aug 4, 2021 at 5:29 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Wed, 4 Aug 2021 16:26:31 +0300 Or Gerlitz wrote:
> > > On Fri, Jul 23, 2021 at 9:09 AM Christoph Hellwig <hch@lst.de> wrote:
> > > > On Thu, Jul 22, 2021 at 02:02:53PM +0300, Boris Pismenny wrote:
> > > > > From: Boris Pismenny <borisp@mellanox.com>
> > > > >
> > > > > get_netdev_for_sock is a utility that is used to obtain
> > > > > the net_device structure from a connected socket.
> > > > >
> > > > > Later patches will use this for nvme-tcp DDP and DDP DDGST offloads.
> > > > >
> > > > > Signed-off-by: Boris Pismenny <borisp@mellanox.com>
> > > > > Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
> > > >
> > > > I don't think this should be an inline.  Please move it to net/core/dev.c,
> > > > andd add an EXPORT_SYMBOL_GPL and a kerneldoc comment.

> > > Jakub,
> > > What's your preference here?

> > Fine either way.

> copying the list and few ppl

Christoph,

We will add the kdoc.

Prefer to leave it as inline which is fine by the networking maintainer.

Or.
