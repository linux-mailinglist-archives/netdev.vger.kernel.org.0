Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27BCDC0BE0
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 21:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727965AbfI0TBR convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 27 Sep 2019 15:01:17 -0400
Received: from mga05.intel.com ([192.55.52.43]:37953 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725980AbfI0TBR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Sep 2019 15:01:17 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Sep 2019 12:01:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,556,1559545200"; 
   d="scan'208";a="273908415"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by orsmga001.jf.intel.com with ESMTP; 27 Sep 2019 12:01:16 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 27 Sep 2019 12:01:16 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 27 Sep 2019 12:01:15 -0700
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81]) by
 fmsmsx601.amr.corp.intel.com ([10.18.126.81]) with mapi id 15.01.1713.004;
 Fri, 27 Sep 2019 12:01:15 -0700
From:   "Bowers, AndrewX" <andrewx.bowers@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: RE: [Intel-wired-lan] [PATCH] i40e: prevent memory leak in
 i40e_setup_macvlans
Thread-Topic: [Intel-wired-lan] [PATCH] i40e: prevent memory leak in
 i40e_setup_macvlans
Thread-Index: AQHVc7jPmEh7Ea81lkWN7Xt2d7dypac/5EeQ
Date:   Fri, 27 Sep 2019 19:01:15 +0000
Message-ID: <97cc947a0a08406096349699b6a8dc47@intel.com>
References: <20190925154831.19044-1-navid.emamdoost@gmail.com>
In-Reply-To: <20190925154831.19044-1-navid.emamdoost@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMDM2NWU2NzMtYzA1Yi00YzBkLWJjZDQtZDYwMTNjODNjYTEzIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiMkdpZzNzeGdXMFZrMkdBSWIzaldraVF0aGdpd0NHOGJzdW9mcnlHdFwvREo3enRjQ0NlSmgzYWN1ZFRoUWN3QlUifQ==
dlp-reaction: no-action
dlp-version: 11.0.400.15
x-originating-ip: [10.22.254.132]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Intel-wired-lan [mailto:intel-wired-lan-bounces@osuosl.org] On
> Behalf Of Navid Emamdoost
> Sent: Wednesday, September 25, 2019 8:49 AM
> Cc: netdev@vger.kernel.org; kjlu@umn.edu; linux-kernel@vger.kernel.org;
> emamd001@umn.edu; intel-wired-lan@lists.osuosl.org;
> smccaman@umn.edu; David S. Miller <davem@davemloft.net>; Navid
> Emamdoost <navid.emamdoost@gmail.com>
> Subject: [Intel-wired-lan] [PATCH] i40e: prevent memory leak in
> i40e_setup_macvlans
> 
> In i40e_setup_macvlans if i40e_setup_channel fails the allocated memory for
> ch should be released.
> 
> Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_main.c | 1 +
>  1 file changed, 1 insertion(+)

Tested-by: Andrew Bowers <andrewx.bowers@intel.com>


