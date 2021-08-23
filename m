Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05EE43F4AE8
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 14:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236868AbhHWMnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 08:43:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:50648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233755AbhHWMnF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 08:43:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88A83613AC;
        Mon, 23 Aug 2021 12:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629722542;
        bh=Ggwchvs84GPqibIZ0xAZy50qZZakHVUzDDoEZDT3RE4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=C2nL8/BLctxvnTUPudVmyoNqy8c8pZ+PMDwIgLye4/tCeqPBwwQh6p5tNgVpQsb5e
         pZPmjX2+ymZGOYQS1AhcCRdpc6jHkmQt9Oc+Z87Re9/VT/ztS0FnJAnIUaqnXq9rxe
         aQf7GOmHrtzmJZrt+gyDwKSodbleWsohQ9y2lvQDUuid/jIltF65Nk4Yy699of9W0H
         uyWPmfcGZsEbuCP3Wq2qo5K50TBXNL5fypHSNuZO19uap7KazuuAltbv4tn8fXsWGL
         5vJ3cep4NoisawJLMtgrp7x6Nkdwo10mrtRl2SOJCKw/IssZUYfkf9t+6dpnfoSVJ5
         U1Y4+TC5oSQOw==
Received: by mail-ej1-f42.google.com with SMTP id lc21so4324622ejc.7;
        Mon, 23 Aug 2021 05:42:22 -0700 (PDT)
X-Gm-Message-State: AOAM533J3T7b7V3H8ayPEXZqS812Y8yVsnoxevt3GOsPdjdbiKpOaSFg
        1f30/npirf3a1ILLopJ3rzMFn3BL9JKr5COPGg==
X-Google-Smtp-Source: ABdhPJz9aEVSU49faJLZnqJhCIZ53qCZLTmM1TpsMhCaPqt3iGo1r07w4vMA2hc4rS/swQ+zi21Afq2zu8Y5LNN8jmw=
X-Received: by 2002:a17:906:8cd:: with SMTP id o13mr35853250eje.341.1629722541063;
 Mon, 23 Aug 2021 05:42:21 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20210823120849eucas1p11d3919886444358472be3edd1c662755@eucas1p1.samsung.com>
 <20210818021717.3268255-1-saravanak@google.com> <0a2c4106-7f48-2bb5-048e-8c001a7c3fda@samsung.com>
In-Reply-To: <0a2c4106-7f48-2bb5-048e-8c001a7c3fda@samsung.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Mon, 23 Aug 2021 07:42:08 -0500
X-Gmail-Original-Message-ID: <CAL_JsqJ50mU2OfHs5eJmgn_8YnJsAsQXzGrzr4_3LQFb6336hg@mail.gmail.com>
Message-ID: <CAL_JsqJ50mU2OfHs5eJmgn_8YnJsAsQXzGrzr4_3LQFb6336hg@mail.gmail.com>
Subject: Re: [PATCH v2] of: property: fw_devlink: Add support for "phy-handle" property
To:     Marek Szyprowski <m.szyprowski@samsung.com>
Cc:     Saravana Kannan <saravanak@google.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 23, 2021 at 7:08 AM Marek Szyprowski
<m.szyprowski@samsung.com> wrote:
>
> Hi,
>
> On 18.08.2021 04:17, Saravana Kannan wrote:
> > Allows tracking dependencies between Ethernet PHYs and their consumers.
> >
> > Cc: Andrew Lunn <andrew@lunn.ch>
> > Cc: netdev@vger.kernel.org
> > Signed-off-by: Saravana Kannan <saravanak@google.com>
>
> This patch landed recently in linux-next as commit cf4b94c8530d ("of:
> property: fw_devlink: Add support for "phy-handle" property"). It breaks
> ethernet operation on my Amlogic-based ARM64 boards: Odroid C4
> (arm64/boot/dts/amlogic/meson-sm1-odroid-c4.dts) and N2
> (meson-g12b-odroid-n2.dts) as well as Khadas VIM3/VIM3l
> (meson-g12b-a311d-khadas-vim3.dts and meson-sm1-khadas-vim3l.dts).
>
> In case of OdroidC4 I see the following entries in the
> /sys/kernel/debug/devices_deferred:
>
> ff64c000.mdio-multiplexer
> ff3f0000.ethernet
>
> Let me know if there is anything I can check to help debugging this issue.

Looks to me like we need to handle 'mdio-parent-bus' dependency.

Rob
