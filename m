Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45D0ACFF55
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 18:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729548AbfJHQyG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 8 Oct 2019 12:54:06 -0400
Received: from mga14.intel.com ([192.55.52.115]:16411 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727730AbfJHQyG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Oct 2019 12:54:06 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Oct 2019 09:54:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,270,1566889200"; 
   d="scan'208";a="394735224"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by fmsmga006.fm.intel.com with ESMTP; 08 Oct 2019 09:54:05 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 8 Oct 2019 09:54:05 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 8 Oct 2019 09:54:05 -0700
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81]) by
 fmsmsx601.amr.corp.intel.com ([10.18.126.81]) with mapi id 15.01.1713.004;
 Tue, 8 Oct 2019 09:54:05 -0700
From:   "Bowers, AndrewX" <andrewx.bowers@intel.com>
To:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH 1/1] ixgbe: protect TX timestamping from
 API misuse
Thread-Topic: [Intel-wired-lan] [PATCH 1/1] ixgbe: protect TX timestamping
 from API misuse
Thread-Index: AQHVfTO/dlmnz+fADEeNMRhKGINk9qdQ93Jw
Date:   Tue, 8 Oct 2019 16:54:04 +0000
Message-ID: <a53362a9afee4995919c117016209701@intel.com>
References: <1570288803-14880-1-git-send-email-manjunath.b.patil@oracle.com>
In-Reply-To: <1570288803-14880-1-git-send-email-manjunath.b.patil@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiODY3Mjk4YWUtYTgzNy00ZTYwLWJlMGItOWRjYzRhM2RhYzQ3IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiWUdEblVmbnM1b1NLVlYwVDlzN3B4NjJkMGlscFEzR3Rja3NpZVJERWh5M21wSWdkUEVHM2V0UFBPZFVzMDlXdiJ9
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
> Behalf Of Manjunath Patil
> Sent: Saturday, October 5, 2019 8:20 AM
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; davem@davemloft.net;
> intel-wired-lan@lists.osuosl.org; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Cc: manjunath.b.patil@oracle.com; christophe.jaillet@wanadoo.fr;
> cspradlin@google.com
> Subject: [Intel-wired-lan] [PATCH 1/1] ixgbe: protect TX timestamping from
> API misuse
> 
> HW timestamping can only be requested for a packet if the NIC is first setup
> via ioctl(SIOCSHWTSTAMP). If this step was skipped, then the ixgbe driver
> still allowed TX packets to request HW timestamping. In this situation, we see
> 'clearing Tx Timestamp hang' noise in the log.
> 
> Fix this by checking that the NIC is configured for HW TX timestamping before
> accepting a HW TX timestamping request.
> 
> similar-to:
> 	(26bd4e2 igb: protect TX timestamping from API misuse)
> 	(0a6f2f0 igb: Fix a test with HWTSTAMP_TX_ON)
> 
> Signed-off-by: Manjunath Patil <manjunath.b.patil@oracle.com>
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)

Tested-by: Andrew Bowers <andrewx.bowers@intel.com>


