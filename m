Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1795A8272A
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 23:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729921AbfHEVtV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 5 Aug 2019 17:49:21 -0400
Received: from mga05.intel.com ([192.55.52.43]:42601 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728483AbfHEVtU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Aug 2019 17:49:20 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Aug 2019 14:49:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,350,1559545200"; 
   d="scan'208";a="198108646"
Received: from orsmsx110.amr.corp.intel.com ([10.22.240.8])
  by fmsmga004.fm.intel.com with ESMTP; 05 Aug 2019 14:49:20 -0700
Received: from orsmsx158.amr.corp.intel.com (10.22.240.20) by
 ORSMSX110.amr.corp.intel.com (10.22.240.8) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 5 Aug 2019 14:49:19 -0700
Received: from orsmsx104.amr.corp.intel.com ([169.254.4.30]) by
 ORSMSX158.amr.corp.intel.com ([169.254.10.82]) with mapi id 14.03.0439.000;
 Mon, 5 Aug 2019 14:49:19 -0700
From:   "Bowers, AndrewX" <andrewx.bowers@intel.com>
To:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH][net-next] ice: fix potential infinite
 loop
Thread-Topic: [Intel-wired-lan] [PATCH][net-next] ice: fix potential
 infinite loop
Thread-Index: AQHVSUpL9gftzLL2UkeGUTDva3hnqabtHJuA
Date:   Mon, 5 Aug 2019 21:49:19 +0000
Message-ID: <26D9FDECA4FBDD4AADA65D8E2FC68A4A1D40F188@ORSMSX104.amr.corp.intel.com>
References: <20190802155217.16996-1-colin.king@canonical.com>
In-Reply-To: <20190802155217.16996-1-colin.king@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiOWFmZjJjMWMtNTgzNS00NTQyLTgwNTEtMzVmNWJkNjA3Y2NlIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiZm9ZQ3NGYUlPd2MxenQzcTJLSndsNEhpYUJTTUUxbEY0RUVQWU9QUVBTbVpyUk5LWDg0c3R4K1huanNRcllRVyJ9
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.0.400.15
dlp-reaction: no-action
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Intel-wired-lan [mailto:intel-wired-lan-bounces@osuosl.org] On
> Behalf Of Colin King
> Sent: Friday, August 2, 2019 8:52 AM
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; David S . Miller
> <davem@davemloft.net>; intel-wired-lan@lists.osuosl.org;
> netdev@vger.kernel.org
> Cc: kernel-janitors@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [Intel-wired-lan] [PATCH][net-next] ice: fix potential infinite loop
> 
> From: Colin Ian King <colin.king@canonical.com>
> 
> The loop counter of a for-loop is a u8 however this is being compared to an
> int upper bound and this can lead to an infinite loop if the upper bound is
> greater than 255 since the loop counter will wrap back to zero. Fix this
> potential issue by making the loop counter an int.
> 
> Addresses-Coverity: ("Infinite loop")
> Fixes: c7aeb4d1b9bf ("ice: Disable VFs until reset is completed")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Tested-by: Andrew Bowers <andrewx.bowers@intel.com>


