Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D528D11A71C
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 10:29:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728432AbfLKJ3s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 04:29:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:40114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726988AbfLKJ3s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Dec 2019 04:29:48 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13F6721556;
        Wed, 11 Dec 2019 09:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576056587;
        bh=3Tcy42OxmATBvLAbXAB33Q4kf7Js606vWyhaA/QXSI8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GMuzyhTNcsug/7HRsKhBGROV+melLGy4jgCjfYiK5jM4TGie9y0lLUD6CwMgkuKWj
         L/1kfRfmEmCAGZr2S6JhO5/PodhqZempq1xpQ2lETBj4KXySAiibb/Qq+92moKrF3g
         /DV2rxyrPlSk7L6xUlhCFnqr2MpibLEOvG/4FLE8=
Date:   Wed, 11 Dec 2019 10:29:44 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jack Ping CHNG <jack.ping.chng@intel.com>
Cc:     devel@driverdev.osuosl.org, cheol.yong.kim@intel.com,
        andriy.shevchenko@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Amireddy Mallikarjuna reddy 
        <mallikarjunax.reddy@linux.intel.com>, davem@davemloft.net
Subject: Re: [PATCH v2] staging: intel-gwdpa: gswip: Introduce Gigabit
 Ethernet Switch (GSWIP) device driver
Message-ID: <20191211092944.GB505511@kroah.com>
References: <5f85180573a3fb20238d6a340cdd990f140ed6f0.1576054234.git.jack.ping.chng@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f85180573a3fb20238d6a340cdd990f140ed6f0.1576054234.git.jack.ping.chng@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 11, 2019 at 04:57:28PM +0800, Jack Ping CHNG wrote:
> - Added TODO (upstream plan)

Wait, your TODO file references things not even in this patch:

> ---
>  drivers/staging/Kconfig                        |   2 +
>  drivers/staging/Makefile                       |   1 +
>  drivers/staging/intel-gwdpa/Kconfig            |  22 +
>  drivers/staging/intel-gwdpa/Makefile           |   5 +
>  drivers/staging/intel-gwdpa/TODO               |  52 ++
>  drivers/staging/intel-gwdpa/gswip/Makefile     |  10 +
>  drivers/staging/intel-gwdpa/gswip/TODO         |   4 +
>  drivers/staging/intel-gwdpa/gswip/gswip.h      | 399 +++++++++++++
>  drivers/staging/intel-gwdpa/gswip/gswip_core.c | 755 +++++++++++++++++++++++++
>  drivers/staging/intel-gwdpa/gswip/gswip_core.h | 106 ++++
>  drivers/staging/intel-gwdpa/gswip/gswip_dev.c  | 184 ++++++
>  drivers/staging/intel-gwdpa/gswip/gswip_dev.h  |  18 +
>  drivers/staging/intel-gwdpa/gswip/gswip_mac.c  | 225 ++++++++
>  drivers/staging/intel-gwdpa/gswip/gswip_port.c | 296 ++++++++++
>  drivers/staging/intel-gwdpa/gswip/gswip_reg.h  | 487 ++++++++++++++++
>  drivers/staging/intel-gwdpa/gswip/gswip_tbl.c  | 345 +++++++++++
>  drivers/staging/intel-gwdpa/gswip/gswip_tbl.h  | 195 +++++++
>  drivers/staging/intel-gwdpa/gswip/lmac.c       |  46 ++
>  drivers/staging/intel-gwdpa/gswip/mac_cfg.c    | 491 ++++++++++++++++
>  drivers/staging/intel-gwdpa/gswip/mac_common.h | 237 ++++++++
>  drivers/staging/intel-gwdpa/gswip/mac_dev.c    | 265 +++++++++
>  drivers/staging/intel-gwdpa/gswip/xgmac.c      | 636 +++++++++++++++++++++
>  drivers/staging/intel-gwdpa/gswip/xgmac.h      | 239 ++++++++
>  drivers/staging/intel-gwdpa/intel-gwdpa.txt    | 264 +++++++++
>  24 files changed, 5284 insertions(+)

<snip>

> --- /dev/null
> +++ b/drivers/staging/intel-gwdpa/TODO
> @@ -0,0 +1,52 @@
> +Intel gateway datapath architecture framework (gwdpa)
> +=====================================================
> +
> +Drivers for gwdpa
> +-----------------
> +1. drivers/staging/intel-gwdpa/gswip
> +        patch: switch driver (GSWIP)
> +
> +2. drivers/staging/intel-gwdpa/cqm
> +        patch: queue manager (CQM)

Where is this directory?

> +3. drivers/staging/intel-gwdpa/pp
> +        patch: packet processor (pp)

And this one?

> +4. drivers/staging/intel-gwdpa/dpm
> +        patch: datapath manager (DPM)
> +        dependencies: GSWIP, CQM, PP

And this one?

> +5. driver/net/ethernet/intel
> +        patch: ethernet driver
> +        dependencies: DPM

Why is this listed?

> +6. drivers/staging/intel-gwdpa/dcdp
> +        patch: direct connect datapath (DCDP)
> +        dependencies: DPM

Where is this one?

> +7.1 drivers/net/wireless
> +7.2 drivers/net/wan
> +        patch: wireless driver and DSL driver
> +        dependencies: DCDP

What does this even mean?

Have you worked with the Intel Linux networking developers to try to get
this all working properly?

totally confused,

greg k-h
