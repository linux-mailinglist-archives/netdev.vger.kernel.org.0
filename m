Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5AF33BC7A0
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 10:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230351AbhGFIJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 04:09:01 -0400
Received: from mga12.intel.com ([192.55.52.136]:21571 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230257AbhGFIJA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Jul 2021 04:09:00 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10036"; a="188755265"
X-IronPort-AV: E=Sophos;i="5.83,328,1616482800"; 
   d="scan'208";a="188755265"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2021 01:06:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,328,1616482800"; 
   d="scan'208";a="647196452"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by fmsmga005.fm.intel.com with ESMTP; 06 Jul 2021 01:06:20 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Tue, 6 Jul 2021 01:06:19 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Tue, 6 Jul 2021 01:06:19 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Tue, 6 Jul 2021 01:06:19 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Tue, 6 Jul 2021 01:06:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mLvfNWmEd+d3Bm0lOLtUNJ+AMYF/hHYshvQEHd5iM/DKkI/4wAQbx+j0bQALwuvLKvWSiUC6KQlbTyxD3MRgA3VGh4+0tFC/rWCDEAp2+ispqRjXSI3xE5pvGFssHRFv0lHdI5T0/RxCtCCQZgocnMigv1e90fFctaXhv3b4e8boVvWDH+h2zNzwpKoqJfDsWJniVsiOgZ17Can9Nl42O2mxbMYa2K9cDgIoNsKJLJUZp5Xmjfb5A7dmkCV0OthUlLHfND8ijOAzAXklw+nJT6bJlY4SwpfIMdFfAbLDfQn4YeUmoUZTy9s7ifi2SXnFQa+HW6usynyOzVY+mjmL1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X7+B2YcpOt0MzGEuPQ+veRFcp4HySR7N6/yXBoMpM3E=;
 b=ECYUyn33dzEcAouccmhwa74IP3Qh0qnvyOS312LNOzZcLDX38yBBdApydZaOKIpySV0HxNm0piaqU7Onm1lG8x+jKX4bGavU4/JZMc5Yiqi0AZvB3BTY5C0ARhkldMTksW8Smyi5X7KfgYRrs3xpTmyec92DPpiPkGGu9IryW+lUOFPUPG9Adw0g0RzspAveuJyoel0a2sOKLnc+xsO3Pmwe1cKuWqDuMvhLMwxrnn3m55LROYoyi79gwLc43GJ9RGih51Cg3TKqg33k2sUBZ0O2jiTkUFeir+2MSRWnavTI+nTM1PxTXcoQrZsfR2sEeoKVinXviKrWc/+85CJ1Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X7+B2YcpOt0MzGEuPQ+veRFcp4HySR7N6/yXBoMpM3E=;
 b=yE3rwVv++P2MuZgV1Lk8olmqEzZJP8LVNoBMT+IcDWSx/2XjdgfNU3jIPh8cNPS1a8Jj5CbsIH2yZIMoMFfkYdwB3CvTKTtILvQqMt0vwaA3zjvPhDi7WpnpgQGQpCUELms9Qzrp0b5ifExj9Cq+rpAV0mN1tKh/HMmCP+IL71g=
Received: from CY4PR11MB1576.namprd11.prod.outlook.com (2603:10b6:910:d::15)
 by CY4PR1101MB2262.namprd11.prod.outlook.com (2603:10b6:910:18::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.32; Tue, 6 Jul
 2021 08:06:17 +0000
Received: from CY4PR11MB1576.namprd11.prod.outlook.com
 ([fe80::b1bd:33e5:3890:e999]) by CY4PR11MB1576.namprd11.prod.outlook.com
 ([fe80::b1bd:33e5:3890:e999%6]) with mapi id 15.20.4287.033; Tue, 6 Jul 2021
 08:06:17 +0000
From:   "Jankowski, Konrad0" <konrad0.jankowski@intel.com>
To:     Stefan Assmann <sassmann@kpanic.de>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH] iavf: do not override the adapter state
 in the watchdog task
Thread-Topic: [Intel-wired-lan] [PATCH] iavf: do not override the adapter
 state in the watchdog task
Thread-Index: AQHXEbzlOyOerDFHl0GuXa194pDiaas2WATA
Date:   Tue, 6 Jul 2021 08:06:17 +0000
Message-ID: <CY4PR11MB15767B03803E7D3DAAC4A356AB1B9@CY4PR11MB1576.namprd11.prod.outlook.com>
References: <20210305123856.14302-1-sassmann@kpanic.de>
In-Reply-To: <20210305123856.14302-1-sassmann@kpanic.de>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: kpanic.de; dkim=none (message not signed)
 header.d=none;kpanic.de; dmarc=none action=none header.from=intel.com;
x-originating-ip: [188.147.96.41]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 182d1a97-4522-4fdd-a3c2-08d94054eed7
x-ms-traffictypediagnostic: CY4PR1101MB2262:
x-microsoft-antispam-prvs: <CY4PR1101MB22629FAD750997D13B688DBFAB1B9@CY4PR1101MB2262.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EbEkQ1TzFTznnMpFG+3hA0mIZVghLCJFTvkB2sqK8W4qkUyHZXbzuSlEq6w9+al4pZm0KwByiTGf0rDTgm2uc7p50csulW1Vhpdxa8GHuj2PkCjMWwAe25ILQG+E5Mlod5kDe3a1r7W/GWvIc9x8/9zLbUyCIUrzrj9es8shoS80mhNKSWipac1JmgTTOPM/vJ85zIsdP2EiiIv5VC53duFidAAvWJkyzFT6X22vAVgQ/PxLdWSscGmE6WfrByPanyj0RIoeqDrf5SN6Nl8FR9CX6+AQYytUDumO8QUefKKcNjsxiTGGmetY37zGX4YkjgwIGb0cNLKlclv3FBkPCj5tLuvid1FSuebha6WnFRacO6/5JA/kokBtQhwhJN5DeDNR20MB8SFQkLIJJGSTF7XrI+G3FGsNRPETKmQtVjIO1PCK+1b0g2N0maEGRuvsjaRzw2Vpr3A797f+18Ua9FHC4E36dWLApQm7xwmnLGR5n5giBH4Xz5lZ4vC58DtNCWBoAuBESVwdD5zwjw0MwmB9Xnq2a38TTv5nImYsn5T4kS2knKGJz17xzZ5bPw9Du3FxOQaU6dD2iUUAwOojhn0SihlBMYCZWSYicvDA2JiEQeKQxQJ68RhjOdujktt1rhViZBqP3FbIzIjoKu3ycA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB1576.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(396003)(136003)(346002)(376002)(8936002)(33656002)(186003)(55016002)(6506007)(83380400001)(7696005)(64756008)(66946007)(26005)(52536014)(8676002)(478600001)(4326008)(110136005)(71200400001)(66574015)(9686003)(66476007)(38100700002)(76116006)(66446008)(53546011)(5660300002)(316002)(2906002)(86362001)(122000001)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-2?Q?/e+rlE1g8nyDC5uLFZnABuHMg260F3W7ltXTczdV+8kJ0VQdY/rUbLaNoP?=
 =?iso-8859-2?Q?SU6Uhi2D1pOLhgbj3JqgAGM8C794ZbXxbqapi2IBDoHozhbtnSRqfUTZHR?=
 =?iso-8859-2?Q?X9tIMotesnYE9ins7Q+A20FtxVPWLQgHzWxvHwjyHll140SFd2z4nreb0A?=
 =?iso-8859-2?Q?ssFNte7lLX9B7fWOTV3r+ySpEmbRS1rWkqOQ0q8pu0n3+8qV+jNuQ/3aoX?=
 =?iso-8859-2?Q?yamZ3dhj6HB4RGoxtrVR6u7Mcvhg60/73EVzvgE6/fUDI34yy7gUNnnZCJ?=
 =?iso-8859-2?Q?ETIeI6l5wk8Du5QvbZM0UmDFYbj2VQ1rqtVar8Izdb4A9PeExU57YlEX6N?=
 =?iso-8859-2?Q?N9sZxnH/Vtn9hclshc3f3ZYGfS4RcKaXE2rHjOBchf6VE5IyOgkq9l+u72?=
 =?iso-8859-2?Q?Y62l2YMgXHrpcdUNxHcSrdJ0SS88GtOByw88kAOQSzSXlMDM4W/RQxtCFJ?=
 =?iso-8859-2?Q?CsQNMl3X64i/pBoDvlQ9qh7amaDjD70Cpjnt9G56mwKMefMQX0JPmXo/6s?=
 =?iso-8859-2?Q?j7fA2MPpR8F4zvmk56QQjVYHjPE1dLTQ12kxcW0jsNeO19/1EcrbUCa1H+?=
 =?iso-8859-2?Q?FsIq2eQUyhrvZzfBY9ntK1pOfcBodluGyKZUqfUDjU/8nCThvoFCAfvUcr?=
 =?iso-8859-2?Q?SRwadyi48Wpn6J3WTGi9HXhjzOydXOYyNIXDiUKYEQdDOxHrAyn0wCtKuP?=
 =?iso-8859-2?Q?MUolCzQEEQuRJxSjgUFRnwTDxkKCRAht+SoUTumyjFcywO+lLhV/c9uxAJ?=
 =?iso-8859-2?Q?yPvDXhUyyXbyl7ZS8CwsDqgooOCjy6cZhFSLvuL1CuYK242kMi32pJR79T?=
 =?iso-8859-2?Q?FE6tgthRDE1LW16tdxxCxhxa4vSuw3+d/LXm5aGGIhIMAOGC2F6PbzOcHG?=
 =?iso-8859-2?Q?BQeyOOzm9/u0GwcB29e6v2MiKtHF75ScX9YARQFJMpEk0vSRQS9POQb6qO?=
 =?iso-8859-2?Q?bIrwONSJ++5Ti8X7hkTogDVPeUKApRZdJni9RBvze2VjmZqFSUyWSo1PMQ?=
 =?iso-8859-2?Q?eEltpNWg4ifULdSJoovec4JHq40N+7FHwur1VuaZ5eZb2tPuFhq+jRtgC+?=
 =?iso-8859-2?Q?PlqfLa5tDgt9a+3kWLamD0mmV/TfG/cunFKbPlLowsmnO7uJRewo3QYD1I?=
 =?iso-8859-2?Q?AapINQVILxTkzg/BJ6fQU3Mjno4D9qLWCnfdpYTgchxSUUQWeTGQWf81OE?=
 =?iso-8859-2?Q?gYA9XOQsoGe0N3L0DD3smg4oRak0Xw1WhmM0OUe6H0qaHgkZz1MhdT9Guj?=
 =?iso-8859-2?Q?pPfzPA0P8Sk4PCpbsR7EbSPZ0UtAawyUWMZwwmKz5L+FQuD+R+jivA4UIq?=
 =?iso-8859-2?Q?kePxOeCluUaab4TUeamVrW56RZInonUaaxPOLE1giysPY/fpNtwamo76AW?=
 =?iso-8859-2?Q?HWsR7JBWEI?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR11MB1576.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 182d1a97-4522-4fdd-a3c2-08d94054eed7
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jul 2021 08:06:17.6186
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xJLbF0rNKyyAHLA/evBM5KEQNcl7zupCq/zz7CXaNz+w04YwvEA8lkJr8p9Yip3jh+1vN2qTN6OyJUZshCy2hlgWVkenGLSq++amakXulmI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1101MB2262
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Stefan Assmann
> Sent: pi=B1tek, 5 marca 2021 13:39
> To: intel-wired-lan@lists.osuosl.org
> Cc: netdev@vger.kernel.org; sassmann@kpanic.de
> Subject: [Intel-wired-lan] [PATCH] iavf: do not override the adapter stat=
e in
> the watchdog task
>=20
> The iavf watchdog task overrides adapter->state to __IAVF_RESETTING
> when it detects a pending reset. Then schedules iavf_reset_task() which
> takes care of the reset.
>=20
> The reset task is capable of handling the reset without changing
> adapter->state. In fact we lose the state information when the watchdog
> task prematurely changes the adapter state. This may lead to a crash if
> instead of the reset task the iavf_remove() function gets called before t=
he
> reset task.
> In that case (if we were in state __IAVF_RUNNING previously) the
> iavf_remove() function triggers iavf_close() which fails to close the dev=
ice
> because of the incorrect state information.
>=20
> This may result in a crash due to pending interrupts.
> kernel BUG at drivers/pci/msi.c:357!
> [...]
> Call Trace:
>  [<ffffffffbddf24dd>] pci_disable_msix+0x3d/0x50  [<ffffffffc08d2a63>]
> iavf_reset_interrupt_capability+0x23/0x40 [iavf]  [<ffffffffc08d312a>]
> iavf_remove+0x10a/0x350 [iavf]  [<ffffffffbddd3359>]
> pci_device_remove+0x39/0xc0  [<ffffffffbdeb492f>]
> __device_release_driver+0x7f/0xf0  [<ffffffffbdeb49c3>]
> device_release_driver+0x23/0x30  [<ffffffffbddcabb4>]
> pci_stop_bus_device+0x84/0xa0  [<ffffffffbddcacc2>]
> pci_stop_and_remove_bus_device+0x12/0x20
>  [<ffffffffbddf361f>] pci_iov_remove_virtfn+0xaf/0x160  [<ffffffffbddf3bc=
c>]
> sriov_disable+0x3c/0xf0  [<ffffffffbddf3ca3>] pci_disable_sriov+0x23/0x30
> [<ffffffffc0667365>] i40e_free_vfs+0x265/0x2d0 [i40e]  [<ffffffffc0667624=
>]
> i40e_pci_sriov_configure+0x144/0x1f0 [i40e]  [<ffffffffbddd5307>]
> sriov_numvfs_store+0x177/0x1d0
> Code: 00 00 e8 3c 25 e3 ff 49 c7 86 88 08 00 00 00 00 00 00 5b 41 5c 41 5=
d 41 5e
> 41 5f 5d c3 48 8b 7b 28 e8 0d 44 RIP  [<ffffffffbbbf1068>]
> free_msi_irqs+0x188/0x190
>=20
> The solution is to not touch the adapter->state in iavf_watchdog_task() a=
nd
> let the reset task handle the state transition.
>=20
> Signed-off-by: Stefan Assmann <sassmann@kpanic.de>
> ---
>  drivers/net/ethernet/intel/iavf/iavf_main.c | 1 -
>  1 file changed, 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c
> b/drivers/net/ethernet/intel/iavf/iavf_main.c
> index 0a867d64d467..d9e3a70abb47 100644
> --- a/drivers/net/ethernet/intel/iavf/iavf_main.c
> +++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
> @@ -1954,7 +1954,6 @@ static void iavf_watchdog_task(struct work_struct
> *work)
>  		/* check for hw reset */
>  	reg_val =3D rd32(hw, IAVF_VF_ARQLEN1) &
> IAVF_VF_ARQLEN1_ARQENABLE_MASK;
>  	if (!reg_val) {
> -		adapter->state =3D __IAVF_RESETTING;
>  		adapter->flags |=3D IAVF_FLAG_RESET_PENDING;
>  		adapter->aq_required =3D 0;
>  		adapter->current_op =3D VIRTCHNL_OP_UNKNOWN;
> --
> 2.29.2

Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>

