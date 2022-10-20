Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3B16069D1
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 22:48:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbiJTUsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 16:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229949AbiJTUr6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 16:47:58 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E009A21552E;
        Thu, 20 Oct 2022 13:47:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1666298858; x=1697834858;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=9I88ZVRaZf8uIrCpHeEkFE8y8YswgC2AXMbuz25GRu4=;
  b=zO/dzdFWwrBXKoALQxgY4O0Qqd1jkUbeiQaYR6hkAUVWc1xCktoHigwz
   GteVDHk72/LJrPqMJbSf7vUJ9IJCgWavdyaNY2MjJnrbOJtWdDPwqRWuL
   srARxDdxXSn0pXoRkUVAH5UcunseycTzMB3Sz5KuIFOgKN7ImWnI2xPKn
   ykvs6OPpRIR0zcYgoCj1l9cEKZdqRh72+Vw6diqlAniBj3Q/bFathDEu+
   l4cQOEZy6iB1ZL589RAnNfWzCWVBqTWGm1PxGR50VYQkfa3qc6hdO5WQk
   w/ZCqtEAE9n9J8cOk4NqTphWI+R8FSHuLY1TKwhFzJuuMo3XrvmQavoLF
   w==;
X-IronPort-AV: E=Sophos;i="5.95,199,1661842800"; 
   d="scan'208";a="185760420"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Oct 2022 13:47:17 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 20 Oct 2022 13:47:16 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2507.12 via Frontend
 Transport; Thu, 20 Oct 2022 13:47:16 -0700
Date:   Thu, 20 Oct 2022 22:51:54 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <hawk@kernel.org>, <john.fastabend@gmail.com>,
        <linux@armlinux.org.uk>, <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next 0/5] net: lan966x: Add xdp support
Message-ID: <20221020205154.rkmr2lvk7436vftt@soft-dev3-1>
References: <20221019135008.3281743-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20221019135008.3281743-1-horatiu.vultur@microchip.com>
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 10/19/2022 15:50, Horatiu Vultur wrote:
> Add support for xdp in lan966x driver. Currently on XDP_PASS and
> XDP_DROP are supported.
> 
> The first 3 patches are just moving things around just to simplify
> the code for when the xdp is added.
> Patch 4 actually adds the xdp. Currently the only supported actions
> are XDP_PASS and XDP_DROP. In the future this will be extended with
> XDP_TX and XDP_REDIRECT.
> Patch 5 changes to use page pool API, because the handling of the
> pages is similar with what already lan966x driver is doing. In this
> way is possible to remove some of the code.
> 
> All these changes give a small improvement on the RX side:
> Before:
> iperf3 -c 10.96.10.1 -R
> [  5]   0.00-10.01  sec   514 MBytes   430 Mbits/sec    0         sender
> [  5]   0.00-10.00  sec   509 MBytes   427 Mbits/sec              receiver
> 
> After:
> iperf3 -c 10.96.10.1 -R
> [  5]   0.00-10.02  sec   540 MBytes   452 Mbits/sec    0         sender
> [  5]   0.00-10.01  sec   537 MBytes   450 Mbits/sec              receiver

If it is possible I would like to withdraw the submission for this patch
series.
The reason is that patch 2 touches some code that has some issues. The
issues were not introduced in this patch series. So I prefer to send first
the patches to fix those issues which need to go in net and only when those
fixes reaches net-next to resend this patch series. Otherwise will be some
pretty ugly merge conflicts.
So just to make the life easier for everyone, please ignore for now
this patch series.

> 
> 
> Horatiu Vultur (5):
>   net: lan966x: Add define IFH_LEN_BYTES
>   net: lan966x: Rename lan966x_fdma_get_max_mtu
>   net: lan966x: Split function lan966x_fdma_rx_get_frame
>   net: lan966x: Add basic XDP support
>   net: lan96x: Use page_pool API
> 
>  .../net/ethernet/microchip/lan966x/Kconfig    |   1 +
>  .../net/ethernet/microchip/lan966x/Makefile   |   3 +-
>  .../ethernet/microchip/lan966x/lan966x_fdma.c | 194 +++++++++++-------
>  .../ethernet/microchip/lan966x/lan966x_ifh.h  |   1 +
>  .../ethernet/microchip/lan966x/lan966x_main.c |  26 ++-
>  .../ethernet/microchip/lan966x/lan966x_main.h |  28 +++
>  .../ethernet/microchip/lan966x/lan966x_xdp.c  | 100 +++++++++
>  7 files changed, 275 insertions(+), 78 deletions(-)
>  create mode 100644 drivers/net/ethernet/microchip/lan966x/lan966x_xdp.c
> 
> -- 
> 2.38.0
> 

-- 
/Horatiu
