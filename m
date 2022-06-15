Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 785E254BEE7
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 02:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240397AbiFOAwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 20:52:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240494AbiFOAwV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 20:52:21 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D106E4D25C
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 17:52:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=N1WOFAao0/oc/ECMpt7Tc3wAP002c/nMS/Y+vpo5VuY=; b=lW4wsl62Oj91uV3KUC5l/Nlpyy
        DYd7L3yc+YJva90Plc58zLTcMYa8xJ9enY3+5RwuZPtysXjf1KpIGuAlulhD9kI/dkFOZfAIC4rAQ
        eeHvrMp3Ofeu/8t15/vUovExpTJUVGYXMt5duYmXG5zcI9jh6Xr0m3ZOc8aegLSsKU+g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o1HGX-006wu0-W2; Wed, 15 Jun 2022 02:52:13 +0200
Date:   Wed, 15 Jun 2022 02:52:13 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org, 'Leon Romanovsky' <leon@kernel.org>
Subject: Re: [PATCH net-next v4] net: txgbe: Add build support for txgbe
Message-ID: <YqktPcFrEstedV3E@lunn.ch>
References: <20220531032640.27678-1-jiawenwu@trustnetic.com>
 <00b701d87a11$7b9ba420$72d2ec60$@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00b701d87a11$7b9ba420$72d2ec60$@trustnetic.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 07, 2022 at 09:54:10AM +0800, Jiawen Wu wrote:
> Hi,
> 
> On Tuesday, May 31, 2022 11:27 AM, Jiawen Wu wrote:
> > Add doc build infrastructure for txgbe driver.
> > Initialize PCI memory space for WangXun 10 Gigabit Ethernet devices.
> > 
> > Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
> > ---
> >  .../device_drivers/ethernet/index.rst         |   1 +
> >  .../device_drivers/ethernet/wangxun/txgbe.rst |  20 ++
> >  MAINTAINERS                                   |   7 +
> >  drivers/net/ethernet/Kconfig                  |   1 +
> >  drivers/net/ethernet/Makefile                 |   1 +
> >  drivers/net/ethernet/wangxun/Kconfig          |  32 ++++
> >  drivers/net/ethernet/wangxun/Makefile         |   6 +
> >  drivers/net/ethernet/wangxun/txgbe/Makefile   |   9 +
> >  drivers/net/ethernet/wangxun/txgbe/txgbe.h    |  24 +++
> >  .../net/ethernet/wangxun/txgbe/txgbe_main.c   | 178
> > ++++++++++++++++++
> >  .../net/ethernet/wangxun/txgbe/txgbe_type.h   |  57 ++++++
> >  drivers/pci/quirks.c                          |  15 ++
> >  include/linux/pci_ids.h                       |   2 +
> >  13 files changed, 353 insertions(+)
> >  create mode 100644
> > Documentation/networking/device_drivers/ethernet/wangxun/txgbe.rst
> >  create mode 100644 drivers/net/ethernet/wangxun/Kconfig
> >  create mode 100644 drivers/net/ethernet/wangxun/Makefile
> >  create mode 100644 drivers/net/ethernet/wangxun/txgbe/Makefile
> >  create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe.h
> >  create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
> >  create mode 100644 drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
> > 
> 
> Can I get some suggestions on this patch?

I suggest you repost. In general, don't post more than once per 24
hours, but if you don't receiver any comments, or it is not merged
within 3 days, you probably need to repost. Also, if you post during
the merge window, you won't get too many comments, so you need to
repost once the merge window opens.

       Andrew
