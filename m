Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4ECFCE72
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 20:08:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbfKNTIS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 14 Nov 2019 14:08:18 -0500
Received: from mga07.intel.com ([134.134.136.100]:43365 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726444AbfKNTIS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Nov 2019 14:08:18 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Nov 2019 11:08:17 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,304,1569308400"; 
   d="scan'208";a="288315203"
Received: from orsmsx103.amr.corp.intel.com ([10.22.225.130])
  by orsmga001.jf.intel.com with ESMTP; 14 Nov 2019 11:08:17 -0800
Received: from orsmsx125.amr.corp.intel.com (10.22.240.125) by
 ORSMSX103.amr.corp.intel.com (10.22.225.130) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 14 Nov 2019 11:08:17 -0800
Received: from orsmsx121.amr.corp.intel.com ([169.254.10.169]) by
 ORSMSX125.amr.corp.intel.com ([169.254.3.139]) with mapi id 14.03.0439.000;
 Thu, 14 Nov 2019 11:08:17 -0800
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Richard Cochran <richardcochran@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        David Miller <davem@davemloft.net>,
        Brandon Streiff <brandon.streiff@ni.com>,
        "Hall, Christopher S" <christopher.s.hall@intel.com>,
        Eugenia Emantayev <eugenia@mellanox.com>,
        Felipe Balbi <felipe.balbi@linux.intel.com>,
        "Feras Daoud" <ferasda@mellanox.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Stefan Sorensen <stefan.sorensen@spectralink.com>
Subject: RE: [PATCH net 03/13] mv88e6xxx: reject unsupported external
 timestamp flags
Thread-Topic: [PATCH net 03/13] mv88e6xxx: reject unsupported external
 timestamp flags
Thread-Index: AQHVmxuqoyuZAt2Q/kiNsy7f91B6uaeLB11Q
Date:   Thu, 14 Nov 2019 19:08:16 +0000
Message-ID: <02874ECE860811409154E81DA85FBB589698F6A6@ORSMSX121.amr.corp.intel.com>
References: <20191114184507.18937-4-richardcochran@gmail.com>
In-Reply-To: <20191114184507.18937-4-richardcochran@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiODYyNDY2NDItN2FlMy00YjhhLTg4NTYtOThmZjJjYTlkNzVkIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiaU1FYm1sQ1Jvb2QwN2srZWJkR0FhT3JqZnhGWElyZVI4Rk5BTHdoRk5ObkZpN3pSbGtMYklJVGYwTEllK292MCJ9
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

> -----Original Message-----
> From: Richard Cochran <richardcochran@gmail.com>
> Sent: Thursday, November 14, 2019 10:45 AM
> To: netdev@vger.kernel.org
> Cc: intel-wired-lan@lists.osuosl.org; David Miller <davem@davemloft.net>;
> Brandon Streiff <brandon.streiff@ni.com>; Hall, Christopher S
> <christopher.s.hall@intel.com>; Eugenia Emantayev <eugenia@mellanox.com>;
> Felipe Balbi <felipe.balbi@linux.intel.com>; Feras Daoud
> <ferasda@mellanox.com>; Keller, Jacob E <jacob.e.keller@intel.com>; Kirsher,
> Jeffrey T <jeffrey.t.kirsher@intel.com>; Sergei Shtylyov
> <sergei.shtylyov@cogentembedded.com>; Stefan Sorensen
> <stefan.sorensen@spectralink.com>
> Subject: [PATCH net 03/13] mv88e6xxx: reject unsupported external timestamp
> flags
> 
> From: Jacob Keller <jacob.e.keller@intel.com>
> 
> Fix the mv88e6xxx PTP support to explicitly reject any future flags that
> get added to the external timestamp request ioctl.
> 
> In order to maintain currently functioning code, this patch accepts all
> three current flags. This is because the PTP_RISING_EDGE and
> PTP_FALLING_EDGE flags have unclear semantics and each driver seems to
> have interpreted them slightly differently.
> 
> For the record, the semantics of this driver are:
> 
>   flags                                                 Meaning
>   ----------------------------------------------------  --------------------------
>   PTP_ENABLE_FEATURE                                    Time stamp falling edge

For the new version of the ioctl this isn't possible, but we still support the v1 ioctl which would still have this mode. Ok.

>   PTP_ENABLE_FEATURE|PTP_RISING_EDGE                    Time stamp rising edge
>   PTP_ENABLE_FEATURE|PTP_FALLING_EDGE                   Time stamp falling edge
>   PTP_ENABLE_FEATURE|PTP_RISING_EDGE|PTP_FALLING_EDGE   Time stamp
> rising edge
> 

Thanks,
Jake

