Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C521D1F2AB2
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731623AbgFIALX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 8 Jun 2020 20:11:23 -0400
Received: from mga06.intel.com ([134.134.136.31]:54745 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730876AbgFHXTz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:19:55 -0400
IronPort-SDR: NDaaJ/Ny+sy/G2S0E2fRNB0+nhUGYr621BaExLu+k0l4+Pul4kzEmxMXI7MrJXpacf/0D5zwbE
 U8lkscrUzbkA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2020 16:19:54 -0700
IronPort-SDR: ENcRDvxUx7SzWNEGKKuiD3pr/Woir79+F7RleZPBqtMTkMpEdslW/os06eoMu3V3xFXJZd3mY1
 Ey5a/Gi+Y+aQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,489,1583222400"; 
   d="scan'208";a="314035243"
Received: from orsmsx105.amr.corp.intel.com ([10.22.225.132])
  by FMSMGA003.fm.intel.com with ESMTP; 08 Jun 2020 16:19:54 -0700
Received: from orsmsx123.amr.corp.intel.com (10.22.240.116) by
 ORSMSX105.amr.corp.intel.com (10.22.225.132) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 8 Jun 2020 16:19:53 -0700
Received: from orsmsx112.amr.corp.intel.com ([169.254.3.61]) by
 ORSMSX123.amr.corp.intel.com ([169.254.1.123]) with mapi id 14.03.0439.000;
 Mon, 8 Jun 2020 16:19:53 -0700
From:   "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
To:     Jarod Wilson <jarod@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: RE: [PATCH net-next 2/4] ixgbe_ipsec: become aware of when running
 as a bonding slave
Thread-Topic: [PATCH net-next 2/4] ixgbe_ipsec: become aware of when running
 as a bonding slave
Thread-Index: AQHWPdf3oUXiI5zht0y9X20eYPVjDajPWp2w
Date:   Mon, 8 Jun 2020 23:19:52 +0000
Message-ID: <61CC2BC414934749BD9F5BF3D5D94044986EFB8B@ORSMSX112.amr.corp.intel.com>
References: <20200608210058.37352-1-jarod@redhat.com>
 <20200608210058.37352-3-jarod@redhat.com>
In-Reply-To: <20200608210058.37352-3-jarod@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jarod Wilson <jarod@redhat.com>
> Sent: Monday, June 8, 2020 14:01
> To: linux-kernel@vger.kernel.org
> Cc: Jarod Wilson <jarod@redhat.com>; Jay Vosburgh
> <j.vosburgh@gmail.com>; Veaceslav Falico <vfalico@gmail.com>; Andy
> Gospodarek <andy@greyhouse.net>; David S. Miller <davem@davemloft.net>;
> Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; Jakub Kicinski
> <kuba@kernel.org>; Steffen Klassert <steffen.klassert@secunet.com>;
> Herbert Xu <herbert@gondor.apana.org.au>; netdev@vger.kernel.org; intel-
> wired-lan@lists.osuosl.org
> Subject: [PATCH net-next 2/4] ixgbe_ipsec: become aware of when running as
> a bonding slave
> 
> Slave devices in a bond doing hardware encryption also need to be aware that
> they're slaves, so we operate on the slave instead of the bonding master to do
> the actual hardware encryption offload bits.
> 
> CC: Jay Vosburgh <j.vosburgh@gmail.com>
> CC: Veaceslav Falico <vfalico@gmail.com>
> CC: Andy Gospodarek <andy@greyhouse.net>
> CC: "David S. Miller" <davem@davemloft.net>
> CC: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> CC: Jakub Kicinski <kuba@kernel.org>
> CC: Steffen Klassert <steffen.klassert@secunet.com>
> CC: Herbert Xu <herbert@gondor.apana.org.au>
> CC: netdev@vger.kernel.org
> CC: intel-wired-lan@lists.osuosl.org
> Signed-off-by: Jarod Wilson <jarod@redhat.com> 

Acked-by: Jeff Kirsher <Jeffrey.t.kirsher@intel.com>

> ---
>  .../net/ethernet/intel/ixgbe/ixgbe_ipsec.c    | 39 +++++++++++++++----
>  1 file changed, 31 insertions(+), 8 deletions(-)
