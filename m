Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0BD36EA0C
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 19:23:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729410AbfGSRWw convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 19 Jul 2019 13:22:52 -0400
Received: from mga18.intel.com ([134.134.136.126]:51090 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728435AbfGSRWw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jul 2019 13:22:52 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Jul 2019 10:22:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,283,1559545200"; 
   d="scan'208";a="168612025"
Received: from orsmsx106.amr.corp.intel.com ([10.22.225.133])
  by fmsmga008.fm.intel.com with ESMTP; 19 Jul 2019 10:22:50 -0700
Received: from orsmsx114.amr.corp.intel.com (10.22.240.10) by
 ORSMSX106.amr.corp.intel.com (10.22.225.133) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 19 Jul 2019 10:22:49 -0700
Received: from orsmsx104.amr.corp.intel.com ([169.254.4.232]) by
 ORSMSX114.amr.corp.intel.com ([169.254.8.237]) with mapi id 14.03.0439.000;
 Fri, 19 Jul 2019 10:22:49 -0700
From:   "Bowers, AndrewX" <andrewx.bowers@intel.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>
CC:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH v2 05/10] ixgbe: modify driver for
 handling offsets
Thread-Topic: [Intel-wired-lan] [PATCH v2 05/10] ixgbe: modify driver for
 handling offsets
Thread-Index: AQHVO8jADe0dFIZmAkOLSwzcbZi3pqbSNXpA
Date:   Fri, 19 Jul 2019 17:22:48 +0000
Message-ID: <26D9FDECA4FBDD4AADA65D8E2FC68A4A1D40C33D@ORSMSX104.amr.corp.intel.com>
References: <20190620090958.2135-1-kevin.laatz@intel.com>
 <20190716030637.5634-1-kevin.laatz@intel.com>
 <20190716030637.5634-6-kevin.laatz@intel.com>
In-Reply-To: <20190716030637.5634-6-kevin.laatz@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYWMzZjNjZjAtNGEzZS00YmM5LTkxOTgtZGZmZGQ4NWRiNDg0IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiVk9QOXZUTlRyc0JuUnNZVFwvZHVCT0FTaHU4YnpTRXh2SEd6eUp2TG1acXY1ZDdmRW8xTzM1UW9pYnR0Y1wvemd4In0=
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.0.400.15
dlp-reaction: no-action
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Intel-wired-lan [mailto:intel-wired-lan-bounces@osuosl.org] On
> Behalf Of Kevin Laatz
> Sent: Monday, July 15, 2019 8:07 PM
> To: netdev@vger.kernel.org; ast@kernel.org; daniel@iogearbox.net; Topel,
> Bjorn <bjorn.topel@intel.com>; Karlsson, Magnus
> <magnus.karlsson@intel.com>; jakub.kicinski@netronome.com;
> jonathan.lemon@gmail.com
> Cc: Richardson, Bruce <bruce.richardson@intel.com>; Loftus, Ciara
> <ciara.loftus@intel.com>; intel-wired-lan@lists.osuosl.org;
> bpf@vger.kernel.org; Laatz, Kevin <kevin.laatz@intel.com>
> Subject: [Intel-wired-lan] [PATCH v2 05/10] ixgbe: modify driver for handling
> offsets
> 
> With the addition of the unaligned chunks option, we need to make sure we
> handle the offsets accordingly based on the mode we are currently running
> in. This patch modifies the driver to appropriately mask the address for each
> case.
> 
> Signed-off-by: Kevin Laatz <kevin.laatz@intel.com>
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 26 ++++++++++++++++----
>  1 file changed, 21 insertions(+), 5 deletions(-)

Tested-by: Andrew Bowers <andrewx.bowers@intel.com>


