Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EBEE2D01A3
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 09:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbgLFI0H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Dec 2020 03:26:07 -0500
Received: from mga18.intel.com ([134.134.136.126]:8127 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726181AbgLFI0G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Dec 2020 03:26:06 -0500
IronPort-SDR: TH2DtK4ts+lUb4TMTqBfuuzggN9nwd34bgb1bbJGhqgrHnF7Xb2dYgBydDo720+tWrqLyAM0e4
 PLH1o2R8jZsg==
X-IronPort-AV: E=McAfee;i="6000,8403,9826"; a="161338912"
X-IronPort-AV: E=Sophos;i="5.78,397,1599548400"; 
   d="scan'208";a="161338912"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2020 00:25:25 -0800
IronPort-SDR: BQhU3R1VMtil2saxseId70qzRtO3sG+NIb469olD1zV74xC+yOprkBauX9F0ZHZMZNdQpTHFeN
 dToYARj/P6/w==
X-IronPort-AV: E=Sophos;i="5.78,397,1599548400"; 
   d="scan'208";a="316675933"
Received: from tfmonnel-mobl2.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.249.45.58])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2020 00:25:22 -0800
Subject: Re: linux-next: ERROR: build error for arm64
To:     Hui Su <sh_def@163.com>, madalin.bucur@nxp.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     sfr@canb.auug.org.au
References: <20201206073231.GA3805@rlk>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <a6899dcd-eee7-3559-6f4e-584f5f5973ce@intel.com>
Date:   Sun, 6 Dec 2020 09:25:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201206073231.GA3805@rlk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-12-06 08:32, Hui Su wrote:
> hi, all:
> 
> The error came out like this when i build the linux-next kernel
> with ARCH=arm64, with the arm64_defconfig:
> 
>    CC      drivers/net/ethernet/freescale/dpaa/dpaa_eth.o
> ../drivers/net/ethernet/freescale/dpaa/dpaa_eth.c: In function ‘dpaa_fq_init’:
> ../drivers/net/ethernet/freescale/dpaa/dpaa_eth.c:1135:9: error: too few arguments to function ‘xdp_rxq_info_reg’
>   1135 |   err = xdp_rxq_info_reg(&dpaa_fq->xdp_rxq, dpaa_fq->net_dev,
>        |         ^~~~~~~~~~~~~~~~
> In file included from ../include/linux/netdevice.h:42,
>                   from ../include/uapi/linux/if_arp.h:27,
>                   from ../include/linux/if_arp.h:23,
>                   from ../drivers/net/ethernet/freescale/dpaa/dpaa_eth.c:40:
> ../include/net/xdp.h:229:5: note: declared here
>    229 | int xdp_rxq_info_reg(struct xdp_rxq_info *xdp_rxq,
>        |     ^~~~~~~~~~~~~~~~
> make[6]: *** [../scripts/Makefile.build:283: drivers/net/ethernet/freescale/dpaa/dpaa_eth.o] Error 1
> 
> 
> Branch: git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
> HEAD: 2996bd3f6ca9ea529b40c369a94b247657abdb4d
> ARCH: arm64
> CONFIG: arch/arm64/configs/defconfig
> CMD: make ARCH=arm64 CROSS_COMPILE=/usr/bin/aarch64-linux-gnu- Image
> 
> It maybe introduced by the commit b02e5a0ebb172(xsk: Propagate napi_id to XDP socket Rx path),
> and if anyone solved this, please add:
> 
> Reported-by: Hui Su <sh_def@163.com>
>

Hui, was already resolved in commit fdd8b8249ef8 ("dpaa_eth: fix build
errorr in dpaa_fq_init").

Thanks,
Björn

