Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70CF833FDD9
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 04:31:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbhCRDbP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 23:31:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbhCRDbL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 23:31:11 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31885C06174A
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 20:31:11 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id j26so827828iog.13
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 20:31:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3ayN6kd8eFiv/o95lqB0U9IbfqStNQxIVua+1FQVGq8=;
        b=ehjFO/YgKy8MJ5SrLXYF4rDfJmIxx1Tjple3bmbSuDN2zb5PyDaBpH7Kp9SqfYtLor
         rYfAbnXrZ0CLRT6QZ2pRVKZA4RM9iQRPWVV0qH6utMqDsxPa0qhTH+Mgi1hKLT7H6jXG
         Su7kXZMv9zfRU6dM+iWd3SQkDB/jriDH4s5JP3a5RhFMb5rTAsgXMErTCe+XNOQDp8eu
         1UUCdIcfnywNoVpZtCARDnd73K8S1l9xDI8i/Kd9pRTpv1wuWhqwb5fFFQl/41UtqlB5
         GLqN4XCGpRlzpqbejr2C2HPYVllqXB6NDSXyBKDJ9wTxwz2K9Ffvbz9fqs4rDaoHs30d
         2duw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3ayN6kd8eFiv/o95lqB0U9IbfqStNQxIVua+1FQVGq8=;
        b=Yntc7J9db7HzFSCLkQgSExCIWKyUx8cn0yOyNYjg3Q9waenSNTKQrm9Uv4zXBSqCkQ
         0UB4seuyP7kP0yllRkuKTDJN0Ag7iAN1es48ITUCX7Kx9qYcB87VQVU7IP42/ID8oaMh
         KriGyO1B+EUHZQ3IvnGNVSt88bO+gQdnpI6z3Ss4gsnvZSqFgTGcUvX6ba1Y0Re1r1DA
         88Q9BgiYjLQhDxrroTdqMFBgJpIA6gxLVx8ukTRV6jgSvgHiGDpX7Rmpj99iz+OACEwd
         2lYs7BFdYkSrQVQTrmvxvdyKTxw+hks0tbKhJLe0Q4/hMd9EEk2hKQQxC63wFQRU7enS
         tKzw==
X-Gm-Message-State: AOAM532aahHxlhTyuT/B+mGaUf8gUsR+L1JbANpEZjXRmzgBTVlZ0w1n
        KlliwkI7JDVNQr+P7hNasYsR6UW9HBDNttyxdug=
X-Google-Smtp-Source: ABdhPJyUS7XKaQXIc61ynaa5jfZES/fNZhNmKTZwJD4STz9rpOj4gTpm58vgTSb7PADbn7jkUpKpYAeLxXgxON9q81k=
X-Received: by 2002:a5d:938e:: with SMTP id c14mr9100616iol.88.1616038270463;
 Wed, 17 Mar 2021 20:31:10 -0700 (PDT)
MIME-Version: 1.0
References: <1615811031-55209-1-git-send-email-tanhuazhong@huawei.com>
 <1615811031-55209-9-git-send-email-tanhuazhong@huawei.com>
 <20210315130448.2582a0c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <b7b23988-ecba-1ce4-6226-291938c92c08@huawei.com> <20210317182828.70fcc61d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210317182828.70fcc61d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Wed, 17 Mar 2021 20:30:59 -0700
Message-ID: <CAKgT0UdD_s_99nVAXBmYgKhzdt+YQxgT6UsYMgEc4TwwgMHw-g@mail.gmail.com>
Subject: Re: [PATCH net-next 8/9] net: hns3: add support for queue bonding
 mode of flow director
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Huazhong Tan <tanhuazhong@huawei.com>,
        David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Salil Mehta <salil.mehta@huawei.com>, yisen.zhuang@huawei.com,
        huangdaode@huawei.com, linuxarm@openeuler.org,
        LinuxArm <linuxarm@huawei.com>, Jian Shen <shenjian15@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 17, 2021 at 6:28 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 18 Mar 2021 09:02:54 +0800 Huazhong Tan wrote:
> > On 2021/3/16 4:04, Jakub Kicinski wrote:
> > > On Mon, 15 Mar 2021 20:23:50 +0800 Huazhong Tan wrote:
> > >> From: Jian Shen <shenjian15@huawei.com>
> > >>
> > >> For device version V3, it supports queue bonding, which can
> > >> identify the tuple information of TCP stream, and create flow
> > >> director rules automatically, in order to keep the tx and rx
> > >> packets are in the same queue pair. The driver set FD_ADD
> > >> field of TX BD for TCP SYN packet, and set FD_DEL filed for
> > >> TCP FIN or RST packet. The hardware create or remove a fd rule
> > >> according to the TX BD, and it also support to age-out a rule
> > >> if not hit for a long time.
> > >>
> > >> The queue bonding mode is default to be disabled, and can be
> > >> enabled/disabled with ethtool priv-flags command.
> > > This seems like fairly well defined behavior, IMHO we should have a full
> > > device feature for it, rather than a private flag.
> >
> > Should we add a NETIF_F_NTUPLE_HW feature for it?
>
> It'd be better to keep the configuration close to the existing RFS
> config, no? Perhaps a new file under
>
>   /sys/class/net/$dev/queues/rx-$id/
>
> to enable the feature would be more appropriate?
>
> Otherwise I'd call it something like NETIF_F_RFS_AUTO ?
>
> Alex, any thoughts? IIRC Intel HW had a similar feature?

Yeah, this is pretty much what Intel used to put out as ATR aka Flow
Director. Although with that there was also a component of XPS. Flow
Director was the name of the hardware feature and ATR, Application
Targeted Routing, was the software feature that had the Tx path adding
rules by default.

The i40e driver supports disabling it via the "flow-director-atr" private flag.

As far as tying this into NTUPLE that is definitely a no-go. Generally
NTUPLE rules and ATR are mutually exclusive since they compete for
resources within the same device.

> > > Does the device need to be able to parse the frame fully for this
> > > mechanism to work? Will it work even if the TCP segment is encapsulated
> > > in a custom tunnel?
> >
> > no, custom tunnel is not supported.
>
> Hm, okay, it's just queue mapping, if device gets it wrong not the end
> of the world (provided security boundaries are preserved).

So yes/no in terms of this not causing serious issues. Where this
tends to get ugly is if it is combined with something like XPS, which
appears to be enabled for hns3. In that case the flow can jump queues
and when it does that can lead to the Rx either jumping to follow
causing an out of order issue on the Rx side, or being left behind,
with being left behind which is the safer case.

Really I think this feature would be better served by implementing
Accelerated RFS and adding support for ndo_rx_flow_steer.
