Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F16E63FD16A
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 04:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241681AbhIACin (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 22:38:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241662AbhIACim (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 22:38:42 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85CC4C061764
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 19:37:46 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id f15so2311978ybg.3
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 19:37:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0opF/kr0ejNwsbqFLuijHFAHYYE8veDJxbbCiW1Xdvk=;
        b=ZnRT7KinbU5mx6PR+Tr0/wUycD7EyhO81kA4J8P/0p0LmW9RFfAM6W7tivTV8QbjZW
         wr6Bb7Yq2EpJ7ybbQfGE8qMfehVRs1cL04zCdfFKXNxM8GTn+ILA40IpZVcoINUAZD3F
         yL7VpS/WEJzHJzdDONndAS/V0Nx+pWc0tzL4n3GmFipfjdefCWra88HGs9KnxCCYEMjq
         GHJa1YLnUJhSbQLakI5kEfsRJBolmLPJDz37l2iFguB6QGvYOXVQQuTrwVMRUQbUrfHi
         yX5B/vQUyY85yWMXLOE5GwdRqzO4FtwNlHGylGzEvhWhRy3NQykzcFu8S02WM2ZZjTJ1
         HovA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0opF/kr0ejNwsbqFLuijHFAHYYE8veDJxbbCiW1Xdvk=;
        b=RliZtjdgEOoUp2MzEDI/CXJdhhfkBFBXrGNeCtRnAOS9oPAk84nTbX35srXsjuEMeK
         7IqZJ2Qvpo7ioyWAWiE8+bTzb+kK+4FdjEpNgQgY8Fz6lWFXkJzUJGrNSYUSuyzDiTpa
         ostiwarHG87Fp/fWC61gE7nvGZMG0YsFwbJqQ/Czera8Z9yZHsKSBwG7lHC3HGs+IBA0
         8MPgsZgUaqY/FBeTF1yeZzkvL5nAcA++mIdLXqjrOgbAvDSvw4s0KZJQUDX/AoCA4HA/
         0vmXZolnQ67ycUiSGaIKuU58QieffoC7whPuDtYK9FFrEFqi90Ezlh4gIuYNLuc8EowS
         f4rg==
X-Gm-Message-State: AOAM5307OJhAuQXaq0OXjldeq4GuBxZt7pg94FKRMwgZAPymoXr+wcfl
        QtlY+Ad999U8xIefZfynZjVNa5xdbKkisVQx+XLYkA==
X-Google-Smtp-Source: ABdhPJwFHQtr3OtEiZ8Z+LO0gsZha7a26K9bGuUqiTulJwfuwnyVxhZiQG1Km4vGapVVc+8KG4gfMnZ76wf7jggIzAA=
X-Received: by 2002:a5b:50b:: with SMTP id o11mr34819958ybp.466.1630463865509;
 Tue, 31 Aug 2021 19:37:45 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20210823120849eucas1p11d3919886444358472be3edd1c662755@eucas1p1.samsung.com>
 <20210818021717.3268255-1-saravanak@google.com> <0a2c4106-7f48-2bb5-048e-8c001a7c3fda@samsung.com>
 <CAGETcx_xJCqOWtwZ9Ee2+0sPGNLM5=F=djtbdYENkAYZa0ynqQ@mail.gmail.com>
 <427ce8cd-977b-03ae-2020-f5ddc7439390@samsung.com> <CAGETcx8cRXDciKiRMSb=ybKo8=SyiNyAv=7oeHU1HUhkZ60qmg@mail.gmail.com>
In-Reply-To: <CAGETcx8cRXDciKiRMSb=ybKo8=SyiNyAv=7oeHU1HUhkZ60qmg@mail.gmail.com>
From:   Saravana Kannan <saravanak@google.com>
Date:   Tue, 31 Aug 2021 19:37:09 -0700
Message-ID: <CAGETcx-SqTeGdKF=CD9=Ujo2xrWMw3NnimE7zj+d-4HckmaJVQ@mail.gmail.com>
Subject: Re: [PATCH v2] of: property: fw_devlink: Add support for "phy-handle" property
To:     Marek Szyprowski <m.szyprowski@samsung.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        kernel-team@android.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Neil Armstrong <narmstrong@baylibre.com>,
        linux-amlogic@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 24, 2021 at 12:31 AM Saravana Kannan <saravanak@google.com> wrote:
>
> On Tue, Aug 24, 2021 at 12:03 AM Marek Szyprowski
> <m.szyprowski@samsung.com> wrote:
> >
> > Hi,
> >
> > On 23.08.2021 20:22, Saravana Kannan wrote:
> > > On Mon, Aug 23, 2021 at 5:08 AM Marek Szyprowski
> > > <m.szyprowski@samsung.com> wrote:
> > >> On 18.08.2021 04:17, Saravana Kannan wrote:
> > >>> Allows tracking dependencies between Ethernet PHYs and their consumers.
> > >>>
> > >>> Cc: Andrew Lunn <andrew@lunn.ch>
> > >>> Cc: netdev@vger.kernel.org
> > >>> Signed-off-by: Saravana Kannan <saravanak@google.com>
> > >> This patch landed recently in linux-next as commit cf4b94c8530d ("of:
> > >> property: fw_devlink: Add support for "phy-handle" property"). It breaks
> > >> ethernet operation on my Amlogic-based ARM64 boards: Odroid C4
> > >> (arm64/boot/dts/amlogic/meson-sm1-odroid-c4.dts) and N2
> > >> (meson-g12b-odroid-n2.dts) as well as Khadas VIM3/VIM3l
> > >> (meson-g12b-a311d-khadas-vim3.dts and meson-sm1-khadas-vim3l.dts).
> > >>
> > >> In case of OdroidC4 I see the following entries in the
> > >> /sys/kernel/debug/devices_deferred:
> > >>
> > >> ff64c000.mdio-multiplexer
> > >> ff3f0000.ethernet
> > >>
> > >> Let me know if there is anything I can check to help debugging this issue.
> > > I'm fairly certain you are hitting this issue because the PHY device
> > > doesn't have a compatible property. And so the device link dependency
> > > is propagated up to the mdio bus. But busses as suppliers aren't good
> > > because busses never "probe".
> > >
> > > PHY seems to be one of those cases where it's okay to have the
> > > compatible property but also okay to not have it. You can confirm my
> > > theory by checking for the list of suppliers under
> > > ff64c000.mdio-multiplexer. You'd see mdio@0 (ext_mdio) and if you look
> > > at the "status" file under the folder it should be "dormant". If you
> > > add a compatible property that fits the formats a PHY node can have,
> > > that should also fix your issue (not the solution though).
> >
> > Where should I look for the mentioned device links 'status' file?
> >
> > # find /sys -name ff64c000.mdio-multiplexer
> > /sys/devices/platform/soc/ff600000.bus/ff64c000.mdio-multiplexer
> > /sys/bus/platform/devices/ff64c000.mdio-multiplexer
> >
> > # ls -l /sys/devices/platform/soc/ff600000.bus/ff64c000.mdio-multiplexer
> > total 0
>
> This is the folder I wanted you to check.
>
> > lrwxrwxrwx 1 root root    0 Jan  1 00:04
> > consumer:platform:ff3f0000.ethernet ->
> > ../../../../virtual/devlink/platform:ff64c000.mdio-multiplexer--platform:ff3f0000.ethernet
>
> But I should have asked to look for the consumer list and not the
> supplier list. In any case, we can see that the ethernet is marked as
> the consumer of the mdio-multiplexer instead of the PHY device. So my
> hunch seems to be right.
>
> > -rw-r--r-- 1 root root 4096 Jan  1 00:04 driver_override
> > -r--r--r-- 1 root root 4096 Jan  1 00:04 modalias
> > lrwxrwxrwx 1 root root    0 Jan  1 00:04 of_node ->
> > ../../../../../firmware/devicetree/base/soc/bus@ff600000/mdio-multiplexer@4c000
> > drwxr-xr-x 2 root root    0 Jan  1 00:02 power
> > lrwxrwxrwx 1 root root    0 Jan  1 00:04 subsystem ->
> > ../../../../../bus/platform
> > lrwxrwxrwx 1 root root    0 Jan  1 00:04
> > supplier:platform:ff63c000.system-controller:clock-controller ->
> > ../../../../virtual/devlink/platform:ff63c000.system-controller:clock-controller--platform:ff64c000.mdio-multiplexer
> > -rw-r--r-- 1 root root 4096 Jan  1 00:04 uevent
> > -r--r--r-- 1 root root 4096 Jan  1 00:04 waiting_for_supplier
> >
> > # cat
> > /sys/devices/platform/soc/ff600000.bus/ff64c000.mdio-multiplexer/waiting_for_supplier
> > 0
> >
> > I'm also not sure what compatible string should I add there.
>
> It should have been added to external_phy: ethernet-phy@0. But don't
> worry about it (because you need to use a specific format for the
> compatible string).
>

Marek,

Can you give this a shot?
https://lore.kernel.org/lkml/20210831224510.703253-1-saravanak@google.com/

This is not the main fix for the case you brought up, but it should
fix your issue as a side effect of fixing another issue.

The main fix for your issue would be to teach fw_devlink that
phy-handle always points to the actual DT node that'll become a device
even if it doesn't have a compatible property. I'll send that out
later.

-Saravana
