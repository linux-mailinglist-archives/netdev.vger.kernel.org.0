Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 573FEFCE70
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 20:07:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbfKNTHA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 14 Nov 2019 14:07:00 -0500
Received: from mga09.intel.com ([134.134.136.24]:13278 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726289AbfKNTHA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Nov 2019 14:07:00 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Nov 2019 11:06:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,304,1569308400"; 
   d="scan'208";a="198926552"
Received: from orsmsx107.amr.corp.intel.com ([10.22.240.5])
  by orsmga008.jf.intel.com with ESMTP; 14 Nov 2019 11:06:59 -0800
Received: from orsmsx113.amr.corp.intel.com (10.22.240.9) by
 ORSMSX107.amr.corp.intel.com (10.22.240.5) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 14 Nov 2019 11:06:59 -0800
Received: from orsmsx121.amr.corp.intel.com ([169.254.10.169]) by
 ORSMSX113.amr.corp.intel.com ([169.254.9.200]) with mapi id 14.03.0439.000;
 Thu, 14 Nov 2019 11:06:59 -0800
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
Subject: RE: [PATCH net 01/13] ptp: Validate requests to enable time
 stamping of external signals.
Thread-Topic: [PATCH net 01/13] ptp: Validate requests to enable time
 stamping of external signals.
Thread-Index: AQHVmxuqPgHfLdKDTUG2qf6cbdj4gaeLBvVQ
Date:   Thu, 14 Nov 2019 19:06:58 +0000
Message-ID: <02874ECE860811409154E81DA85FBB589698F67E@ORSMSX121.amr.corp.intel.com>
References: <20191114184507.18937-2-richardcochran@gmail.com>
In-Reply-To: <20191114184507.18937-2-richardcochran@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNmZmOTYzMWUtZTM0Ny00NmNhLTg3ZDUtMzI2OWYwZDQwZGRmIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiZEpsUTVOSDFIanJndHhIbWdlMG5WK01hQUNhZlZtVFpCSG9LcVU5Z1Nrd0RlSHZoM2dWbEkwUVFZaGV2a2dTYyJ9
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
> Subject: [PATCH net 01/13] ptp: Validate requests to enable time stamping of
> external signals.
> 
> Commit 415606588c61 ("PTP: introduce new versions of IOCTLs")
> introduced a new external time stamp ioctl that validates the flags.
> This patch extends the validation to ensure that at least one rising
> or falling edge flag is set when enabling external time stamps.
> 
> Signed-off-by: Richard Cochran <richardcochran@gmail.com>
> ---
>  drivers/ptp/ptp_chardev.c      | 18 +++++++++++++-----
>  include/uapi/linux/ptp_clock.h |  1 +
>  2 files changed, 14 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/ptp/ptp_chardev.c b/drivers/ptp/ptp_chardev.c
> index 67d0199840fd..cbbe1237ff8d 100644
> --- a/drivers/ptp/ptp_chardev.c
> +++ b/drivers/ptp/ptp_chardev.c
> @@ -149,11 +149,19 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd,
> unsigned long arg)
>  			err = -EFAULT;
>  			break;
>  		}
> -		if (((req.extts.flags & ~PTP_EXTTS_VALID_FLAGS) ||
> -			req.extts.rsv[0] || req.extts.rsv[1]) &&
> -			cmd == PTP_EXTTS_REQUEST2) {
> -			err = -EINVAL;
> -			break;
> +		if (cmd == PTP_EXTTS_REQUEST2) {
> +			/* Make sure no reserved bit is set. */
> +			if ((req.extts.flags & ~PTP_EXTTS_VALID_FLAGS) ||
> +			    req.extts.rsv[0] || req.extts.rsv[1]) {
> +				err = -EINVAL;
> +				break;
> +			}
> +			/* Ensure one of the rising/falling edge bits is set. */
> +			if ((req.extts.flags & PTP_ENABLE_FEATURE) &&
> +			    (req.extts.flags & PTP_EXTTS_EDGES) == 0) {
> +				err = -EINVAL;
> +				break;
> +			}

Just to confirm, these new ioctls haven't been around long enough to be concerned about this change?

Thanks,
Jake

