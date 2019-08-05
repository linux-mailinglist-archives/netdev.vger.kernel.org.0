Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30CAC82715
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 23:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730698AbfHEVnH convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 5 Aug 2019 17:43:07 -0400
Received: from mga12.intel.com ([192.55.52.136]:64268 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728717AbfHEVnH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Aug 2019 17:43:07 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Aug 2019 14:43:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,350,1559545200"; 
   d="scan'208";a="198107284"
Received: from orsmsx106.amr.corp.intel.com ([10.22.225.133])
  by fmsmga004.fm.intel.com with ESMTP; 05 Aug 2019 14:43:07 -0700
Received: from orsmsx154.amr.corp.intel.com (10.22.226.12) by
 ORSMSX106.amr.corp.intel.com (10.22.225.133) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 5 Aug 2019 14:43:06 -0700
Received: from orsmsx104.amr.corp.intel.com ([169.254.4.30]) by
 ORSMSX154.amr.corp.intel.com ([169.254.11.96]) with mapi id 14.03.0439.000;
 Mon, 5 Aug 2019 14:43:06 -0700
From:   "Bowers, AndrewX" <andrewx.bowers@intel.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: RE: [Intel-wired-lan] [PATCH 2/2] ixgbe: Use refcount_t for refcount
Thread-Topic: [Intel-wired-lan] [PATCH 2/2] ixgbe: Use refcount_t for
 refcount
Thread-Index: AQHVSSDGlTwuGHWtMECrsXmtZFTBhabtGzOA
Date:   Mon, 5 Aug 2019 21:43:06 +0000
Message-ID: <26D9FDECA4FBDD4AADA65D8E2FC68A4A1D40F174@ORSMSX104.amr.corp.intel.com>
References: <20190802105507.16650-1-hslester96@gmail.com>
In-Reply-To: <20190802105507.16650-1-hslester96@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYWVjMjMwYWUtMmNmZC00NDE5LTk4ZWItNDc1YmUyMGIwNTA3IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiOUNxUUI3a0V4RmYyVWtSaUIzMkFpMlBreWJ0UVROQ1RaNjFyQkZBZUkyOEdNRU5cL3JVZ0kwZnFRVkZWWmJkMWkifQ==
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
> Behalf Of Chuhong Yuan
> Sent: Friday, August 2, 2019 3:55 AM
> Cc: netdev@vger.kernel.org; Chuhong Yuan <hslester96@gmail.com>; linux-
> kernel@vger.kernel.org; intel-wired-lan@lists.osuosl.org; David S . Miller
> <davem@davemloft.net>
> Subject: [Intel-wired-lan] [PATCH 2/2] ixgbe: Use refcount_t for refcount
> 
> refcount_t is better for reference counters since its implementation can
> prevent overflows.
> So convert atomic_t ref counters to refcount_t.
> 
> Also convert refcount from 0-based to 1-based.
> 
> This patch depends on PATCH 1/2.
> 
> Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.c | 6 +++---
> drivers/net/ethernet/intel/ixgbe/ixgbe_fcoe.h | 2 +-
>  2 files changed, 4 insertions(+), 4 deletions(-)

Tested-by: Andrew Bowers <andrewx.bowers@intel.com>


