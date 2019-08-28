Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED86A0739
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 18:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbfH1QXs convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 28 Aug 2019 12:23:48 -0400
Received: from mga06.intel.com ([134.134.136.31]:13199 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726415AbfH1QXs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 12:23:48 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Aug 2019 09:23:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,441,1559545200"; 
   d="scan'208";a="197589807"
Received: from fmsmsx105.amr.corp.intel.com ([10.18.124.203])
  by fmsmga001.fm.intel.com with ESMTP; 28 Aug 2019 09:23:47 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 FMSMSX105.amr.corp.intel.com (10.18.124.203) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 28 Aug 2019 09:23:47 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 28 Aug 2019 09:23:46 -0700
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82]) by
 fmsmsx602.amr.corp.intel.com ([10.18.126.82]) with mapi id 15.01.1713.004;
 Wed, 28 Aug 2019 09:23:46 -0700
From:   "Bowers, AndrewX" <andrewx.bowers@intel.com>
To:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH] i40e: check __I40E_VF_DISABLE bit in
 i40e_sync_filters_subtask
Thread-Topic: [Intel-wired-lan] [PATCH] i40e: check __I40E_VF_DISABLE bit in
 i40e_sync_filters_subtask
Thread-Index: AQHVWCtztYGpzMHi60KQXoxB9mZYiacQyX4w
Date:   Wed, 28 Aug 2019 16:23:46 +0000
Message-ID: <094c89e92baa4f5e96ffb766263ce07f@intel.com>
References: <20190821140929.26985-1-sassmann@kpanic.de>
In-Reply-To: <20190821140929.26985-1-sassmann@kpanic.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMWM2NGY2NjYtODQxZS00MTA5LWI1NGEtNzBiYWEwYzVlOWZjIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiNTZ6VTZjRnRITUdFZFFLUXNkTEJyOGpcL1Q0XC9UMkhQQklZYjgrZHJOV1wveU5STU90RThkQnd6Um5IemVtSjU1dCJ9
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
> Sent: Wednesday, August 21, 2019 7:09 AM
> To: intel-wired-lan@lists.osuosl.org
> Cc: netdev@vger.kernel.org; davem@davemloft.net; sassmann@kpanic.de
> Subject: [Intel-wired-lan] [PATCH] i40e: check __I40E_VF_DISABLE bit in
> i40e_sync_filters_subtask
> 
> While testing VF spawn/destroy the following panic occured.
> 
> BUG: unable to handle kernel NULL pointer dereference at
> 0000000000000029 [...]
> Workqueue: i40e i40e_service_task [i40e]
> RIP: 0010:i40e_sync_vsi_filters+0x6fd/0xc60 [i40e] [...] Call Trace:
>  ? __switch_to_asm+0x35/0x70
>  ? __switch_to_asm+0x41/0x70
>  ? __switch_to_asm+0x35/0x70
>  ? _cond_resched+0x15/0x30
>  i40e_sync_filters_subtask+0x56/0x70 [i40e]
>  i40e_service_task+0x382/0x11b0 [i40e]
>  ? __switch_to_asm+0x41/0x70
>  ? __switch_to_asm+0x41/0x70
>  process_one_work+0x1a7/0x3b0
>  worker_thread+0x30/0x390
>  ? create_worker+0x1a0/0x1a0
>  kthread+0x112/0x130
>  ? kthread_bind+0x30/0x30
>  ret_from_fork+0x35/0x40
> 
> Investigation revealed a race where pf->vf[vsi->vf_id].trusted may get
> accessed by the watchdog via i40e_sync_filters_subtask() although
> i40e_free_vfs() already free'd pf->vf.
> To avoid this the call to i40e_sync_vsi_filters() in
> i40e_sync_filters_subtask() needs to be guarded by __I40E_VF_DISABLE,
> which is also used by i40e_free_vfs().
> 
> Note: put the __I40E_VF_DISABLE check after the
> __I40E_MACVLAN_SYNC_PENDING check as the latter is more likely to
> trigger.
> 
> Signed-off-by: Stefan Assmann <sassmann@kpanic.de>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_main.c | 5 +++++
>  1 file changed, 5 insertions(+)

Tested-by: Andrew Bowers <andrewx.bowers@intel.com>


