Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19483537AA8
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 14:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236150AbiE3M3G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 08:29:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231952AbiE3M3G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 08:29:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E38E712D4
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 05:29:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9AD3B80B8C
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 12:29:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E539FC385B8;
        Mon, 30 May 2022 12:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653913742;
        bh=WqK0Uuuf8+07PmrprABHOs2Fnk9auBASEplApnkMwu0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fvJPWGiDPVyNf8syn8KnpGdCJf05W6lx1tH2VyKq39OPnL6ElG94et83UU4wOfl20
         q180NGguIt2i961e6edGoRdw+ny0u4UQA40sMHUjb2vCAH4rsT6Nmhi3cYwfEAPRkC
         AUwhBRGwrHovpOvHzoKy2vKaWMTqrW2gFFVsMJsyAGqhY75ws98ECS6AXIKJDuemhl
         pvuh8gu31DvdvPNSyYAm3UrVVAI/34nGAEIBlSFfNxLDKP21E9Txhcr40XA+ri8KHJ
         0OWXD/X692+bUEBE4obMTbl6M2sDPzQZ8KRuo6RbI7t26wCm04AAIkrod/cCg78pj1
         PPrwEag4n2+1g==
Date:   Mon, 30 May 2022 15:28:58 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next v3] net: txgbe: Add build support for txgbe
Message-ID: <YpS4itZ91fAdiLm2@unreal>
References: <20220527063157.486686-1-jiawenwu@trustnetic.com>
 <YpD/9dqThFZZgs2K@unreal>
 <001501d873ec$e4f13a00$aed3ae00$@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <001501d873ec$e4f13a00$aed3ae00$@trustnetic.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 30, 2022 at 02:17:08PM +0800, Jiawen Wu wrote:
> On Saturday, May 28, 2022 12:45 AM, Leon Romanovsky wrote:
> > On Fri, May 27, 2022 at 02:31:57PM +0800, Jiawen Wu wrote:
> > > Add doc build infrastructure for txgbe driver.
> > > Initialize PCI memory space for WangXun 10 Gigabit Ethernet devices.
> > >
> > > Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
> > > ---
> > >  .../device_drivers/ethernet/index.rst         |   1 +
> > >  .../device_drivers/ethernet/wangxun/txgbe.rst |  20 ++
> > >  MAINTAINERS                                   |   7 +
> > >  drivers/net/ethernet/Kconfig                  |   1 +
> > >  drivers/net/ethernet/Makefile                 |   1 +
> > >  drivers/net/ethernet/wangxun/Kconfig          |  32 +++
> > >  drivers/net/ethernet/wangxun/Makefile         |   6 +
> > >  drivers/net/ethernet/wangxun/txgbe/Makefile   |   9 +
> > >  drivers/net/ethernet/wangxun/txgbe/txgbe.h    |  27 ++
> > >  .../net/ethernet/wangxun/txgbe/txgbe_main.c   | 241
> > ++++++++++++++++++
> > >  .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  65 +++++
> > >  11 files changed, 410 insertions(+)
> > >  create mode 100644
> > > Documentation/networking/device_drivers/ethernet/wangxun/txgbe.rst
> > >  create mode 100644 drivers/net/ethernet/wangxun/Kconfig
> > >  create mode 100644 drivers/net/ethernet/wangxun/Makefile
> > >  create mode 100644 drivers/net/ethernet/wangxun/txgbe/Makefile
> > >  create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe.h
> > >  create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
> > >  create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
> > 
> > <...>
> >
> > > +	pci_set_master(pdev);
> > > +	/* errata 16 */
> > > +	pcie_capability_clear_and_set_word(pdev, PCI_EXP_DEVCTL,
> > > +					   PCI_EXP_DEVCTL_READRQ,
> > > +					   0x1000);
> > 
> > Why do you need this in probe function and not as PCI quirk?
> > 
> 
> It is necessary to set read request size 256 bytes for us.
> Otherwise, some PCI exception issues may occur.

It is not what I asked.
I would expect such code in PCI quirk and not in probe function.

Thanks

> 
> 
> 
> 
