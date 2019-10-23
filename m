Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74C0BE0FED
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 04:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388593AbfJWCKU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 22 Oct 2019 22:10:20 -0400
Received: from mga07.intel.com ([134.134.136.100]:16589 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731549AbfJWCKU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 22:10:20 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Oct 2019 19:10:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,219,1569308400"; 
   d="scan'208";a="227955514"
Received: from orsmsx109.amr.corp.intel.com ([10.22.240.7])
  by fmsmga002.fm.intel.com with ESMTP; 22 Oct 2019 19:10:09 -0700
Received: from orsmsx159.amr.corp.intel.com (10.22.240.24) by
 ORSMSX109.amr.corp.intel.com (10.22.240.7) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 22 Oct 2019 19:10:09 -0700
Received: from orsmsx103.amr.corp.intel.com ([169.254.5.9]) by
 ORSMSX159.amr.corp.intel.com ([169.254.11.61]) with mapi id 14.03.0439.000;
 Tue, 22 Oct 2019 19:10:09 -0700
From:   "Brown, Aaron F" <aaron.f.brown@intel.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>,
        "alexander.h.duyck@linux.intel.com" 
        <alexander.h.duyck@linux.intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "zdai@us.ibm.com" <zdai@us.ibm.com>,
        "zdai@linux.vnet.ibm.com" <zdai@linux.vnet.ibm.com>
Subject: RE: [Intel-wired-lan] [next-queue PATCH v2 2/2] e1000e: Drop
 unnecessary __E1000_DOWN bit twiddling
Thread-Topic: [Intel-wired-lan] [next-queue PATCH v2 2/2] e1000e: Drop
 unnecessary __E1000_DOWN bit twiddling
Thread-Index: AQHVgEl6YHHR8y+xKk22zja70f7iIadnjU4A
Date:   Wed, 23 Oct 2019 02:10:09 +0000
Message-ID: <309B89C4C689E141A5FF6A0C5FB2118B97154E17@ORSMSX103.amr.corp.intel.com>
References: <20191011153219.22313.60179.stgit@localhost.localdomain>
 <20191011153459.22313.17985.stgit@localhost.localdomain>
In-Reply-To: <20191011153459.22313.17985.stgit@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMjIxZGEyMjgtYTNhMy00ZDkxLTkwMjgtNmMxODIwMDUxNjkwIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoidmIyUmpNZVNYUWROeTk3K01xR25CZWY2MVhhZzN1U0VnYk83bjVGWEJFdzU0ejhtc0F2R0x4SUI5YlwvZVdHU1EifQ==
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Alexander Duyck
> Sent: Friday, October 11, 2019 8:35 AM
> To: alexander.h.duyck@linux.intel.com; intel-wired-lan@lists.osuosl.org;
> Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>
> Cc: netdev@vger.kernel.org; zdai@us.ibm.com; zdai@linux.vnet.ibm.com
> Subject: [Intel-wired-lan] [next-queue PATCH v2 2/2] e1000e: Drop
> unnecessary __E1000_DOWN bit twiddling
> 
> From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> 
> Since we no longer check for __E1000_DOWN in e1000e_close we can drop
> the
> spot where we were restoring the bit. This saves us a bit of unnecessary
> complexity.
> 
> Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
> ---
>  drivers/net/ethernet/intel/e1000e/netdev.c |    7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 

Tested-by: Aaron Brown <aaron.f.brown@intel.com>
