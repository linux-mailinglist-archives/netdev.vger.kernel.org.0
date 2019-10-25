Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6C1DE4216
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 05:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390818AbfJYD0w convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 24 Oct 2019 23:26:52 -0400
Received: from mga14.intel.com ([192.55.52.115]:1582 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730294AbfJYD0w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Oct 2019 23:26:52 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Oct 2019 20:26:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,227,1569308400"; 
   d="scan'208";a="223787033"
Received: from orsmsx110.amr.corp.intel.com ([10.22.240.8])
  by fmsmga004.fm.intel.com with ESMTP; 24 Oct 2019 20:26:51 -0700
Received: from orsmsx114.amr.corp.intel.com (10.22.240.10) by
 ORSMSX110.amr.corp.intel.com (10.22.240.8) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 24 Oct 2019 20:26:50 -0700
Received: from orsmsx103.amr.corp.intel.com ([169.254.5.9]) by
 ORSMSX114.amr.corp.intel.com ([169.254.8.19]) with mapi id 14.03.0439.000;
 Thu, 24 Oct 2019 20:26:51 -0700
From:   "Brown, Aaron F" <aaron.f.brown@intel.com>
To:     Josh Hunt <johunt@akamai.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
CC:     "willemb@google.com" <willemb@google.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        "alexander.h.duyck@linux.intel.com" 
        <alexander.h.duyck@linux.intel.com>,
        "Duyck, Alexander H" <alexander.h.duyck@intel.com>
Subject: RE: [PATCH v3 1/3] igb: Add UDP segmentation offload support
Thread-Topic: [PATCH v3 1/3] igb: Add UDP segmentation offload support
Thread-Index: AQHVgFRuWcnUryzvDUWJ/YBl1Higkadqxzeg
Date:   Fri, 25 Oct 2019 03:26:50 +0000
Message-ID: <309B89C4C689E141A5FF6A0C5FB2118B971565B0@ORSMSX103.amr.corp.intel.com>
References: <1570812820-20052-1-git-send-email-johunt@akamai.com>
 <1570812820-20052-2-git-send-email-johunt@akamai.com>
In-Reply-To: <1570812820-20052-2-git-send-email-johunt@akamai.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMGNmNTE0MjctOTBiZC00NjYwLTgwNjEtMzAwN2JhZDZjNTlkIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiVmZwMUpacWNFbFV0Vlh5ZjZXU2hReFd3b0VzR1wvVm1sVlFLaGd1ZWVjWWJtcUx1VFpISHZxVXlDeUVwSHZONUUifQ==
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.138]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Josh Hunt <johunt@akamai.com>
> Sent: Friday, October 11, 2019 9:54 AM
> To: netdev@vger.kernel.org; intel-wired-lan@lists.osuosl.org; Kirsher,
> Jeffrey T <jeffrey.t.kirsher@intel.com>
> Cc: willemb@google.com; Samudrala, Sridhar
> <sridhar.samudrala@intel.com>; Brown, Aaron F
> <aaron.f.brown@intel.com>; alexander.h.duyck@linux.intel.com; Josh Hunt
> <johunt@akamai.com>; Duyck, Alexander H
> <alexander.h.duyck@intel.com>
> Subject: [PATCH v3 1/3] igb: Add UDP segmentation offload support
> 
> Based on a series from Alexander Duyck this change adds UDP segmentation
> offload support to the igb driver.
> 
> CC: Alexander Duyck <alexander.h.duyck@intel.com>
> CC: Willem de Bruijn <willemb@google.com>
> Signed-off-by: Josh Hunt <johunt@akamai.com>
> ---
>  drivers/net/ethernet/intel/igb/e1000_82575.h |  1 +
>  drivers/net/ethernet/intel/igb/igb_main.c    | 23 +++++++++++++++++------
>  2 files changed, 18 insertions(+), 6 deletions(-)

Tested-by: Aaron Brown <aaron.f.brown@intel.com>

