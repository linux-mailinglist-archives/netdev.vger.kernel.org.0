Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10D16AE01A
	for <lists+netdev@lfdr.de>; Mon,  9 Sep 2019 23:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728385AbfIIVAQ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 9 Sep 2019 17:00:16 -0400
Received: from mga17.intel.com ([192.55.52.151]:2690 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727265AbfIIVAQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Sep 2019 17:00:16 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Sep 2019 14:00:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,487,1559545200"; 
   d="scan'208";a="268195801"
Received: from fmsmsx108.amr.corp.intel.com ([10.18.124.206])
  by orsmga001.jf.intel.com with ESMTP; 09 Sep 2019 14:00:15 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 FMSMSX108.amr.corp.intel.com (10.18.124.206) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 9 Sep 2019 14:00:14 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 9 Sep 2019 14:00:14 -0700
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82]) by
 fmsmsx602.amr.corp.intel.com ([10.18.126.82]) with mapi id 15.01.1713.004;
 Mon, 9 Sep 2019 14:00:14 -0700
From:   "Bowers, AndrewX" <andrewx.bowers@intel.com>
To:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH] i40e: clear __I40E_VIRTCHNL_OP_PENDING
 on invalid min tx rate
Thread-Topic: [Intel-wired-lan] [PATCH] i40e: clear __I40E_VIRTCHNL_OP_PENDING
 on invalid min tx rate
Thread-Index: AQHVYh3+xhY9fUhFcESFvkAjSnYfaKcj3sMA
Date:   Mon, 9 Sep 2019 21:00:10 +0000
Message-ID: <4bbcbce0cd2f419682fc390af5cd35e5@intel.com>
References: <20190903060810.30775-1-sassmann@kpanic.de>
In-Reply-To: <20190903060810.30775-1-sassmann@kpanic.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNmE1MmQ1NDUtZjVkMy00ZWIyLWI5N2EtYWMzZjFiM2QxYTFlIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiZSt2NDRqNlhGWStnXC81WGc4c2xWZXdIOThMSEdCYkdKMDdvMjg3Qk9tRnR5enR6SW1YaVhwSzczTE1UZDA0cVIifQ==
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
> Behalf Of Stefan Assmann
> Sent: Monday, September 2, 2019 11:08 PM
> To: intel-wired-lan@lists.osuosl.org
> Cc: netdev@vger.kernel.org; davem@davemloft.net; sassmann@kpanic.de
> Subject: [Intel-wired-lan] [PATCH] i40e: clear
> __I40E_VIRTCHNL_OP_PENDING on invalid min tx rate
> 
> In the case of an invalid min tx rate being requested
> i40e_ndo_set_vf_bw() immediately returns -EINVAL instead of releasing
> __I40E_VIRTCHNL_OP_PENDING first.
> 
> Signed-off-by: Stefan Assmann <sassmann@kpanic.de>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Tested-by: Andrew Bowers <andrewx.bowers@intel.com>


