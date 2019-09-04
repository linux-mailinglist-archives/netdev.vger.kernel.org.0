Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 490BCA9675
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 00:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730013AbfIDW3w convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 4 Sep 2019 18:29:52 -0400
Received: from mga07.intel.com ([134.134.136.100]:50440 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729863AbfIDW3w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 18:29:52 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Sep 2019 15:29:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,468,1559545200"; 
   d="scan'208";a="184045719"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by fmsmga007.fm.intel.com with ESMTP; 04 Sep 2019 15:29:51 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 4 Sep 2019 15:29:51 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 4 Sep 2019 15:29:51 -0700
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82]) by
 fmsmsx602.amr.corp.intel.com ([10.18.126.82]) with mapi id 15.01.1713.004;
 Wed, 4 Sep 2019 15:29:51 -0700
From:   "Bowers, AndrewX" <andrewx.bowers@intel.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: RE: [PATCH v2 net-next 1/2] i40e: fix hw_dbg usage in
 i40e_hmc_get_object_va
Thread-Topic: [PATCH v2 net-next 1/2] i40e: fix hw_dbg usage in
 i40e_hmc_get_object_va
Thread-Index: AQHVYoysai3Lha4iAUSz6QkNFmsN/accGz/Q
Date:   Wed, 4 Sep 2019 22:29:50 +0000
Message-ID: <e8052da5afc9446ca3562362bf5e00a0@intel.com>
References: <20190903192021.25789-1-maurosr@linux.vnet.ibm.com>
In-Reply-To: <20190903192021.25789-1-maurosr@linux.vnet.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNWU4ZmNkZmQtMzU1YS00M2RkLTkzYzQtZTY3OTZlNzU5Njk2IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiYmFCSDF2NHh0UEdCXC80VHN2MldFeDZsY1gwOCtjYjVud211SzlRQ0g0QUN2WEJiRWNsME5CVkozRktieFEwWSsifQ==
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
> From: Mauro S. M. Rodrigues [mailto:maurosr@linux.vnet.ibm.com]
> Sent: Tuesday, September 3, 2019 12:20 PM
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>
> Cc: intel-wired-lan@lists.osuosl.org; netdev@vger.kernel.org;
> davem@davemloft.net; Bowers, AndrewX <andrewx.bowers@intel.com>;
> Jakub Kicinski <jakub.kicinski@netronome.com>;
> maurosr@linux.vnet.ibm.com
> Subject: [PATCH v2 net-next 1/2] i40e: fix hw_dbg usage in
> i40e_hmc_get_object_va
> 
> The mentioned function references a i40e_hw attribute, as parameter for
> hw_dbg, but it doesn't exist in the function scope.
> Fixes it by changing  parameters from i40e_hmc_info to i40e_hw which can
> retrieve the necessary i40e_hmc_info.
> 
> v2:
>  - Fixed reverse xmas tree code style issue as suggested by Jakub Kicinski
> 
> Signed-off-by: Mauro S. M. Rodrigues <maurosr@linux.vnet.ibm.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_lan_hmc.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)

Tested-by: Andrew Bowers <andrewx.bowers@intel.com>


