Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 627C5D97BD
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 18:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391519AbfJPQoR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 16 Oct 2019 12:44:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:38862 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389763AbfJPQoR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Oct 2019 12:44:17 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Oct 2019 09:44:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,304,1566889200"; 
   d="scan'208";a="186205058"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by orsmga007.jf.intel.com with ESMTP; 16 Oct 2019 09:44:16 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 16 Oct 2019 09:44:16 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 16 Oct 2019 09:44:15 -0700
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82]) by
 fmsmsx602.amr.corp.intel.com ([10.18.126.82]) with mapi id 15.01.1713.004;
 Wed, 16 Oct 2019 09:44:15 -0700
From:   "Bowers, AndrewX" <andrewx.bowers@intel.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: RE: [Intel-wired-lan] [PATCH v3 3/3] i40e: Add UDP segmentation
 offload support
Thread-Topic: [Intel-wired-lan] [PATCH v3 3/3] i40e: Add UDP segmentation
 offload support
Thread-Index: AQHVgFR3mhYx11D+T0qQMCa+Q7tQdKddgSPw
Date:   Wed, 16 Oct 2019 16:44:14 +0000
Message-ID: <5a780256fa3047c88f2ea9cb7c14c3eb@intel.com>
References: <1570812820-20052-1-git-send-email-johunt@akamai.com>
 <1570812820-20052-4-git-send-email-johunt@akamai.com>
In-Reply-To: <1570812820-20052-4-git-send-email-johunt@akamai.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiZDRmM2Y3ZDAtZDllZC00N2U1LTkxODItODdlZGYzZDg3NmIwIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoibmcxV3NyeTJINkJtOWk4dzRwQTN4TVdkMFZDcDVPenZnZDl2Tlk4alU2WkdKTlk4ZG1MNFQ2elE3a0lQUGRqayJ9
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
> Subject: [Intel-wired-lan] [PATCH v3 3/3] i40e: Add UDP segmentation
> offload support
> 
> Based on a series from Alexander Duyck this change adds UDP segmentation
> offload support to the i40e driver.
> 
> CC: Alexander Duyck <alexander.h.duyck@intel.com>
> CC: Willem de Bruijn <willemb@google.com>
> Signed-off-by: Josh Hunt <johunt@akamai.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_main.c |  1 +
> drivers/net/ethernet/intel/i40e/i40e_txrx.c | 12 +++++++++---
>  2 files changed, 10 insertions(+), 3 deletions(-)

Tested-by: Andrew Bowers <andrewx.bowers@intel.com>


