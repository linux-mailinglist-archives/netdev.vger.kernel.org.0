Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 262F758EAB2
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 12:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbiHJKuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 06:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231579AbiHJKue (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 06:50:34 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22A6431A
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 03:50:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660128634; x=1691664634;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=i5jZZLZ8OyAR5dJ845mRABW2OmbViiN//JtehAJtGPU=;
  b=cd2yDkz7AVVG/MS6w6aLnJtpHD2h4SG7e+YzkuazLzs3lpN1uR6zFsr2
   OeddbgfAhJMJa8t4Sxbp/XLqNtV1dixJ9t/eNoL/Fbwt3JehR9lHqKoeP
   97PUnpgSq1EBshiFg6xAq5pD9Hw6oceRhgwbnt2EJSsVikZG92cUNQdAZ
   cFTiCyU2EyvadH8C7vgN1xIxzOMWdXT3eP1bAwQRw/ynv0dvVYW9mWOb1
   0cTBaYTMm7uqTXbU4XPAqJxBrcY66b8LU91KoZ4sqTISbALC+CZwG55VX
   fAaLceNs8EmgXImBqiN6n1ZwYCKGPhTygwQFoBz518OyckPdXa/mgNyB2
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10434"; a="317001115"
X-IronPort-AV: E=Sophos;i="5.93,227,1654585200"; 
   d="scan'208";a="317001115"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2022 03:50:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,227,1654585200"; 
   d="scan'208";a="731457219"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga004.jf.intel.com with ESMTP; 10 Aug 2022 03:50:31 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 27AAoUhM030800;
        Wed, 10 Aug 2022 11:50:30 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Jian Shen <shenjian15@huawei.com>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        ecree.xilinx@gmail.com, hkallweit1@gmail.com, saeed@kernel.org,
        leon@kernel.org, netdev@vger.kernel.org, linuxarm@openeuler.org
Subject: Re: [RFCv7 PATCH net-next 16/36] treewide: use replace features '0' by netdev_empty_features
Date:   Wed, 10 Aug 2022 12:48:41 +0200
Message-Id: <20220810104841.1306583-1-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220810030624.34711-17-shenjian15@huawei.com>
References: <20220810030624.34711-1-shenjian15@huawei.com> <20220810030624.34711-17-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>
Date: Wed, 10 Aug 2022 11:06:04 +0800

> For the prototype of netdev_features_t will be changed from
> u64 to bitmap, so it's unable to assignment with 0 directly.
> Replace it with netdev_empty_features.

Hmm, why not just netdev_features_zero() instead?
There's a couple places where empty netdev_features are needed, but
they're not probably worth a separate and rather pointless empty
variable, you could create one on the stack there.

> 
> Signed-off-by: Jian Shen <shenjian15@huawei.com>
> ---
>  drivers/hsi/clients/ssi_protocol.c             | 2 +-
>  drivers/net/caif/caif_serial.c                 | 2 +-
>  drivers/net/ethernet/amazon/ena/ena_netdev.c   | 2 +-
>  drivers/net/ethernet/broadcom/b44.c            | 2 +-
>  drivers/net/ethernet/broadcom/tg3.c            | 2 +-
>  drivers/net/ethernet/dnet.c                    | 2 +-
>  drivers/net/ethernet/ec_bhf.c                  | 2 +-
>  drivers/net/ethernet/emulex/benet/be_main.c    | 2 +-
>  drivers/net/ethernet/ethoc.c                   | 2 +-
>  drivers/net/ethernet/huawei/hinic/hinic_main.c | 5 +++--
>  drivers/net/ethernet/ibm/ibmvnic.c             | 6 +++---
>  drivers/net/ethernet/intel/iavf/iavf_main.c    | 9 +++++----
>  drivers/net/ethernet/microsoft/mana/mana_en.c  | 2 +-
>  drivers/net/ethernet/sfc/ef10.c                | 2 +-
>  drivers/net/tap.c                              | 2 +-
>  drivers/net/tun.c                              | 2 +-
>  drivers/net/usb/cdc-phonet.c                   | 3 ++-
>  drivers/net/usb/lan78xx.c                      | 2 +-
>  drivers/s390/net/qeth_core_main.c              | 2 +-
>  drivers/usb/gadget/function/f_phonet.c         | 3 ++-
>  net/dccp/ipv4.c                                | 2 +-
>  net/dccp/ipv6.c                                | 2 +-
>  net/ethtool/features.c                         | 2 +-
>  net/ethtool/ioctl.c                            | 6 ++++--
>  net/ipv4/af_inet.c                             | 2 +-
>  net/ipv4/tcp.c                                 | 2 +-
>  net/ipv4/tcp_ipv4.c                            | 2 +-
>  net/ipv6/af_inet6.c                            | 2 +-
>  net/ipv6/inet6_connection_sock.c               | 2 +-
>  net/ipv6/tcp_ipv6.c                            | 2 +-
>  net/openvswitch/datapath.c                     | 2 +-
>  31 files changed, 44 insertions(+), 38 deletions(-)

[...]

> -- 
> 2.33.0

Thanks,
Olek
