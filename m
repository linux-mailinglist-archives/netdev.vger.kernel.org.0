Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06C80D97B7
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 18:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406368AbfJPQnm convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 16 Oct 2019 12:43:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:40444 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405336AbfJPQnm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Oct 2019 12:43:42 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Oct 2019 09:43:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,304,1566889200"; 
   d="scan'208";a="225850055"
Received: from fmsmsx104.amr.corp.intel.com ([10.18.124.202])
  by fmsmga002.fm.intel.com with ESMTP; 16 Oct 2019 09:43:41 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx104.amr.corp.intel.com (10.18.124.202) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 16 Oct 2019 09:43:41 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 16 Oct 2019 09:43:40 -0700
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82]) by
 fmsmsx602.amr.corp.intel.com ([10.18.126.82]) with mapi id 15.01.1713.004;
 Wed, 16 Oct 2019 09:43:40 -0700
From:   "Bowers, AndrewX" <andrewx.bowers@intel.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: RE: [Intel-wired-lan] [PATCH v3 2/3] ixgbe: Add UDP segmentation
 offload support
Thread-Topic: [Intel-wired-lan] [PATCH v3 2/3] ixgbe: Add UDP segmentation
 offload support
Thread-Index: AQHVgFRowN/KEkch8E+1dVc4ca4O5KddgPXg
Date:   Wed, 16 Oct 2019 16:43:40 +0000
Message-ID: <a99acf6128404c54ba837e2b0afe1d98@intel.com>
References: <1570812820-20052-1-git-send-email-johunt@akamai.com>
 <1570812820-20052-3-git-send-email-johunt@akamai.com>
In-Reply-To: <1570812820-20052-3-git-send-email-johunt@akamai.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYmFjNDI3YmItOGZjZi00ZjU4LThiZjktNWI3NzY3YmM2MzI3IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiS2pBTStqOUtVMGhZSkxxUmRheUZuVmRZd0E4WEJZamRiMnRHMGxqXC95cXRuMHNQS1dmTzBcL1ZTR3pkNFV6ekRJIn0=
dlp-reaction: no-action
dlp-version: 11.0.400.15
x-originating-ip: [10.22.254.132]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Intel-wired-lan [mailto:intel-wired-lan-bounces@osuosl.org] On
> Behalf Of Josh Hunt
> Sent: Friday, October 11, 2019 9:54 AM
> To: netdev@vger.kernel.org; intel-wired-lan@lists.osuosl.org; Kirsher,
> Jeffrey T <jeffrey.t.kirsher@intel.com>
> Cc: Duyck, Alexander H <alexander.h.duyck@intel.com>;
> willemb@google.com; Josh Hunt <johunt@akamai.com>;
> alexander.h.duyck@linux.intel.com
> Subject: [Intel-wired-lan] [PATCH v3 2/3] ixgbe: Add UDP segmentation
> offload support
> 
> Repost from a series by Alexander Duyck to add UDP segmentation offload
> support to the igb driver:
> https://lore.kernel.org/netdev/20180504003916.4769.66271.stgit@localhost.l
> ocaldomain/
> 
> CC: Alexander Duyck <alexander.h.duyck@intel.com>
> CC: Willem de Bruijn <willemb@google.com>
> Suggested-by: Alexander Duyck <alexander.h.duyck@intel.com>
> Signed-off-by: Josh Hunt <johunt@akamai.com>
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 24
> ++++++++++++++++++------
>  1 file changed, 18 insertions(+), 6 deletions(-)

Tested-by: Andrew Bowers <andrewx.bowers@intel.com>


