Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5EE4E3364
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 23:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbiCUWzj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 18:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230420AbiCUWzX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 18:55:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 131393B2A11
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 15:37:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6BD73B81A7F
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 22:10:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1EDBC36AE2
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 22:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647900649;
        bh=DnfAXbt0SlzWASTRDry65qPiIq3oHDgadE+0NusO/+w=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=M6C/qrZ2Lioqa8G8jtqexVNqDHhRY67uLwRPEwUJ/2FSQiFlLnzyuI108VFl/oRRX
         Bs9Jpy1HwYWuuAcbn/ovMB7jx8cP+cXX1e+Y8V08teLF9yWgE0PFSGbivIhurqIAM0
         0FSSu0iWdiw2Nm12fkMJapS4szZKYCcKbsRSAsDLeUCXZ7OQ4UDXzPs0RncIU26wxe
         rN+CS19sJaJQlh6so+TmJNfPf2PEBKPI0BUhqd2AdA5bgnuXiRQp+BiR5y/A2Bghn7
         cIj0U8liwAVxsGWqtkRIL/sxvtrWPwpPMFvqjdxZ+/Rp89UzajiomSZ/k6NdwRMYXq
         UWQDfbqTlXS+g==
Received: by mail-wr1-f42.google.com with SMTP id r10so22588928wrp.3
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 15:10:49 -0700 (PDT)
X-Gm-Message-State: AOAM533ryUejgj698fheq1wGSiWmMWU3HWV01KZyPQ7GRZBfdmQ2M0Ui
        LAvrFLxxHbGJ8nEPNJ8l8PMkPYWY/7++LcFJH1w=
X-Google-Smtp-Source: ABdhPJyePEb/hNjvVS02P/6Vl2v+F9/KYfdnlS0Ha+eR55JQjCIAohdaiyxGbL0Nvx5JhCbbTErpbn00PiIYqpRjXoA=
X-Received: by 2002:a5d:6d0f:0:b0:203:9157:1c48 with SMTP id
 e15-20020a5d6d0f000000b0020391571c48mr19539385wrq.192.1647900648196; Mon, 21
 Mar 2022 15:10:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220321144013.440d7fc0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220321144013.440d7fc0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Mon, 21 Mar 2022 23:10:32 +0100
X-Gmail-Original-Message-ID: <CAK8P3a12=qpMHn5daK3-E6PjWuSOYOyWp2u2XU0kfzZ8=EoRdA@mail.gmail.com>
Message-ID: <CAK8P3a12=qpMHn5daK3-E6PjWuSOYOyWp2u2XU0kfzZ8=EoRdA@mail.gmail.com>
Subject: Re: Is drivers/net/wan/lmc dead?
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     =?UTF-8?Q?Krzysztof_Ha=C5=82asa?= <khalasa@piap.pl>,
        Andrew Stanley-Jones <asj@cban.com>,
        Rob Braun <bbraun@vix.com>, Michael Graff <explorer@vix.com>,
        Matt Thomas <matt@3am-software.com>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 21, 2022 at 10:40 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Hi!
>
> The driver for LAN Media WAN interfaces spews build warnings on
> microblaze.
>
> CCing usual suspects and people mentioned as authors in the source code.
>
> As far as I can tell it has no maintainer.
>
> It has also received not received a single functional change that'd
> indicate someone owns this HW since the beginning of the git era.
>
> Can we remove this driver or should we invest effort into fixing it?

I have not seen the exact error, but I suspect the problem is that
microblaze selects CONFIG_VIRT_TO_BUS without actually
providing those interfaces. The easy workaround would be to
have microblaze not select that symbol.

Drivers using virt_to_bus() are inherently nonportable because
they don't work on architectures that use an IOMMU or swiotlb,
or that require cache maintenance for DMA operations.

$ git grep -wl virt_to_bus drivers/
drivers/atm/ambassador.c
drivers/atm/firestream.c
drivers/atm/horizon.c
drivers/atm/zatm.c
drivers/block/swim3.c
drivers/gpu/drm/mga/mga_dma.c
drivers/net/appletalk/ltpc.c
drivers/net/ethernet/amd/au1000_eth.c
drivers/net/ethernet/amd/ni65.c
drivers/net/ethernet/apple/bmac.c
drivers/net/ethernet/apple/mace.c
drivers/net/ethernet/dec/tulip/de4x5.c
drivers/net/ethernet/i825xx/82596.c
drivers/net/ethernet/i825xx/lasi_82596.c
drivers/net/ethernet/i825xx/lib82596.c
drivers/net/hamradio/dmascc.c
drivers/net/wan/cosa.c
drivers/net/wan/lmc/lmc_main.c
drivers/net/wan/z85230.c
drivers/scsi/3w-xxxx.c
drivers/scsi/a2091.c
drivers/scsi/a3000.c
drivers/scsi/dpt_i2o.c
drivers/scsi/gvp11.c
drivers/scsi/mvme147.c
drivers/scsi/qla1280.c
drivers/tty/serial/cpm_uart/cpm_uart_cpm2.c
drivers/vme/bridges/vme_ca91cx42.c

Among the drivers/net/wan/ drivers, I think lmc is actually
one of the newer pieces of hardware, most of the other ones
appear to even predate PCI.

        Arnd
