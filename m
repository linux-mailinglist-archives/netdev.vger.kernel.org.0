Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40C90F0380
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 17:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390341AbfKEQze convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 5 Nov 2019 11:55:34 -0500
Received: from mga07.intel.com ([134.134.136.100]:39299 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390060AbfKEQze (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Nov 2019 11:55:34 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Nov 2019 08:55:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,271,1569308400"; 
   d="scan'208";a="205035243"
Received: from orsmsx106.amr.corp.intel.com ([10.22.225.133])
  by orsmga003.jf.intel.com with ESMTP; 05 Nov 2019 08:55:33 -0800
Received: from orsmsx122.amr.corp.intel.com (10.22.225.227) by
 ORSMSX106.amr.corp.intel.com (10.22.225.133) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 5 Nov 2019 08:55:33 -0800
Received: from orsmsx113.amr.corp.intel.com ([169.254.9.28]) by
 ORSMSX122.amr.corp.intel.com ([169.254.11.32]) with mapi id 14.03.0439.000;
 Tue, 5 Nov 2019 08:55:33 -0800
From:   "Creeley, Brett" <brett.creeley@intel.com>
To:     Arkady Gilinsky <arkady.gilinsky@harmonicinc.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
CC:     Arkady Gilinsky <arcadyg@gmail.com>
Subject: RE: [EXTERNAL] RE: [PATCH net] i40e/iavf: Fix msg interface between
 VF and PF
Thread-Topic: [EXTERNAL] RE: [PATCH net] i40e/iavf: Fix msg interface
 between VF and PF
Thread-Index: AQHVktE9LXQEe1tn8E2yMWCX6YmauKd7neLQgABu5ACAALtz8A==
Date:   Tue, 5 Nov 2019 16:55:32 +0000
Message-ID: <3508A0C5D531054DBDD98909F6FA64FA11B39863@ORSMSX113.amr.corp.intel.com>
References: <1572845537.13810.225.camel@harmonicinc.com>
         <3508A0C5D531054DBDD98909F6FA64FA11B3936D@ORSMSX113.amr.corp.intel.com>
 <1572931430.13810.227.camel@harmonicinc.com>
In-Reply-To: <1572931430.13810.227.camel@harmonicinc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiM2JkM2UyZWEtNzM1Yi00N2I3LWE3M2EtMzBiNmE5NTc1MDc1IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiN2ZKcjhWRllLblNwWmtObG1WNE5KNWdcL3JlRmgzd2pJbGpHMVNlK1U4ZXh1ZVpiSkRNWGdIY1pkOEk2MEx6QjIifQ==
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Arkady Gilinsky <arkady.gilinsky@harmonicinc.com>
> Sent: Monday, November 4, 2019 9:24 PM
> To: Creeley, Brett <brett.creeley@intel.com>; intel-wired-lan@lists.osuosl.org; netdev@vger.kernel.org; Kirsher, Jeffrey T
> <jeffrey.t.kirsher@intel.com>
> Cc: Arkady Gilinsky <arcadyg@gmail.com>
> Subject: Re: [EXTERNAL] RE: [PATCH net] i40e/iavf: Fix msg interface between VF and PF
> > static bool i40e_vc_verify_vqs_bitmaps(struct virtchnl_queue_select *vqs)
> > {
> > 	/* this will catch any changes made to the virtchnl_queue_select bitmap */
> > 	if (sizeof(vqs->rx_queues) != sizeof(u32) ||
> > 	     sizeof(vqs->tx_queues) != sizeof(u32))
> > 		return false;
> If so, then is it better to check the type of the fields in compile-time rather than in runtime ?
> Something like this:
> BUILD_BUG_ON(sizeof(vqs->rx_queues) != sizeof(u32));
> BUILD_BUG_ON(sizeof(vqs->tx_queues) != sizeof(u32));
> This is not required comparison each time when function is called and made code more optimized.

I don't think this is required with the change you suggested below.

> >
> > 	if ((vqs->rx_queues == 0 && vqs->tx_queues == 0) ||
> > 	      hweight32(vqs->rx_queues) > I40E_MAX_VF_QUEUES ||
> > 	      hweight32(vqs->tx_queues) > I40E_MAX_VF_QUEUES)
> > 		return false;
> Again, from optimization POV it is better to have constant changed than variable,
> since it is compile time and not run time action:
> 	if ((vqs->rx_queues == 0 && vqs->tx_queues == 0) ||
> 	      vqs->rx_queues >= (BIT(I40E_MAX_VF_QUEUES)) ||
> 
>       vqs->tx_queues >= (BIT(I40E_MAX_VF_QUEUES)))
> 		return false;

This seems much better than my solution. It fixes the original issue, handles if the
vqs->[r|t]x_queues variables have changed in size, and the queue bitmap comparison
uses a constant. Thanks!

> > 	return true;
> > }

