Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5893635111
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 08:27:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235988AbiKWH1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 02:27:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235343AbiKWH1b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 02:27:31 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDC4DF1F
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 23:27:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669188450; x=1700724450;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=J5IxVjtLWksfASqWRvdwOnnc9xpT3qGrzkrSkVZPJ5A=;
  b=jQhLOp1XPhvsD5CeNGZ9tmB6BUrG7ME1wQTn/QE/UIDxkUQ5knz5ME6H
   7gQZx9VCu/7emIcJ5tXJidIsNsNTWyqfA9GFcU28DuMCfGqSJhx12kgtX
   ORp2yj2JRxsHeK8zn1ES1gWhXp/tQzNAlJGoAyVSsHZkvGads13aaD7/i
   FsFOcG37VetTZ8zH4hAvg2fpbxvKIIcnn00HrKSv5fQiNA5j2eqLrm2Vr
   kFIcS+18O70r3I1ipyQ70nGNg1GVkeRkuhiBt9ZFepIZtl7p9x5/k3pMF
   u/f+ro4I2EDAYTu5BIkaHjib5HOAl3xYbod4Mihgr/QIKSsk/wN5EomJ0
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="340880288"
X-IronPort-AV: E=Sophos;i="5.96,186,1665471600"; 
   d="scan'208";a="340880288"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2022 23:27:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10539"; a="886837115"
X-IronPort-AV: E=Sophos;i="5.96,186,1665471600"; 
   d="scan'208";a="886837115"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga006.fm.intel.com with ESMTP; 22 Nov 2022 23:27:30 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 22 Nov 2022 23:27:30 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 22 Nov 2022 23:27:29 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 22 Nov 2022 23:27:29 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 22 Nov 2022 23:27:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GWex190TUpbqcyw5gDePvTeD9TVaR8wCmLJF3pFqTAUKPmUgjIw08VvgMDbTBv9sK6vDCJS0TMDA71/zuKtJW0Gjf1zVck0Lovr8OJq+aNX9TSY8hE2XLcxHh8rHwEqXFX5ePLI1X5US6o7QbTP2cMIE/SnawuDVeqcdtHDDOKnohjJDe9Hun9tNQrlfqenDTDmgj+8X+HoMQkvma+hUSiDre5c0vDEQo/x+gJr52GZ/uX595FBRSCqcY93A9PW93s9rLj28Wj26P312tv35KmWNxi1cQxWKMOG5pUG0Se+PsisV1ZTFMAsBlefoAq3RXaD2nqSzOLgfoLeMQCcbgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FTVE/c8ECtAcMoWB7GnEFubm2gackOqCYWyp+QWKMcQ=;
 b=AFYC9Jp/sG7tdtWhMZaLPzoIpB+XP2Ac4DagpW9Ck7s2Ws8oxHfc5lzOEpI93ZvTZtAqWQnpAogg66Duw9shebPNWkwE3XLbogomHig1YHhFnX6KW3R9iuCxy3Vds84nhKOG1HvyTM/N5AgvRJqXQ/hGsvRubLgVbIPsMQvcgS0LaMQ5EwAA0TwRVcPLxBepMg/A6yzCmN/QDm9bNab37jKMWPMzp3YyPjkRmNCTqyFJPJ0zBp+6H3d1fgK1hun/0ySeVmH5a2tu8KMmaJbvQ7Rk/yDZf3IZsB8ZaxkL46k9SXJq40tHuk+ZV1QabVdS83pH2gYgIOOSYEENqI3HyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5621.namprd11.prod.outlook.com (2603:10b6:8:38::14) by
 PH7PR11MB5958.namprd11.prod.outlook.com (2603:10b6:510:1e1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Wed, 23 Nov
 2022 07:27:27 +0000
Received: from DM8PR11MB5621.namprd11.prod.outlook.com
 ([fe80::38d9:fdfd:ec27:1da2]) by DM8PR11MB5621.namprd11.prod.outlook.com
 ([fe80::38d9:fdfd:ec27:1da2%5]) with mapi id 15.20.5834.015; Wed, 23 Nov 2022
 07:27:27 +0000
From:   "Jankowski, Konrad0" <konrad0.jankowski@intel.com>
To:     Yuan Can <yuancan@huawei.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "alexander.h.duyck@intel.com" <alexander.h.duyck@intel.com>,
        "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>,
        "Vick, Matthew" <matthew.vick@intel.com>,
        "Keller, Jacob E" <jacob.e.keller@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH 2/2] iavf: Fix error handling in
 iavf_init_module()
Thread-Topic: [Intel-wired-lan] [PATCH 2/2] iavf: Fix error handling in
 iavf_init_module()
Thread-Index: AQHY+EN7Tt7628iQr0OdEgvlanlIBK5MKWoQ
Date:   Wed, 23 Nov 2022 07:27:27 +0000
Message-ID: <DM8PR11MB562139536E10268B1FEFAEE3AB0C9@DM8PR11MB5621.namprd11.prod.outlook.com>
References: <20221114082640.91128-1-yuancan@huawei.com>
 <20221114082640.91128-3-yuancan@huawei.com>
In-Reply-To: <20221114082640.91128-3-yuancan@huawei.com>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5621:EE_|PH7PR11MB5958:EE_
x-ms-office365-filtering-correlation-id: 16b253e0-d20d-4b5c-b294-08dacd242c61
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9pdL0ToYkECbwJDofpi9vDuAx4isjd1Rgzx73O4O7OAUmIXHM5AP+tG8AELEVYSGAe5rO7iOYD2S6Cp2uvUsDHwMaEO1R53Mp+Knq3q4f92horJiwJHhhPvL1Lyzo3YCp11v380rSHVoJIWT70gtPW0bzOdN2opie0tXpBdCwVKWgCslTreUgDIdWh48hWehjyrHGv9X8tiHnkOCPUHX7rHDhMexuSzeEPUCVOHoOIpD/Vw0KN2HDTRxsgt+IkxGoftk5z42I/hLyLv6+nhOBbavPI6TBSAEssQ2QEoNIAGU6r8KXLZXyN2y5/drb06cX+c6M0Qhbl+o6yv8LPH973EcI3AnKwdGcI263mANxI6T4A5QUoN2deXTHRdP2UPwAwK1KsVukPbpeuK1kbAAgvlGwkUtwE28KSh0n3RYIPvd46CnOuu+htel1YFJCokxlRAPR0w9n4cpAxPdQ/Pk6+Ea5YyV/XtE8Z4Xs/X0B7Qoy3VrC9balxA3OCe9mfaKuztTcZ6Cmyhcl+ihwReVDjdamYlguS91shjowZoCZC7rVBb0HDB0Q2NKL2gc33vrsBfQfk3IO08HxPKXPdfPFNUu4uIavOyF193RCwqWXQuOgBjGR12awfj5GaWbTfy1Tk20azF4mCyFbOGatRlu3VqSkO5B0qZFc0BSbH785UVo0nKnqCYgdPitQugAr/vd740LwxT3YUexo+7pZejqGPcAxwTxOe2jU6B8JRD5Mu6CGqkjLdvbC8HDrDdIj4NK
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5621.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(39860400002)(376002)(366004)(346002)(451199015)(66556008)(55016003)(66946007)(83380400001)(82960400001)(41300700001)(38070700005)(66476007)(66446008)(76116006)(64756008)(8676002)(2906002)(122000001)(38100700002)(53546011)(110136005)(6506007)(52536014)(7696005)(26005)(8936002)(921005)(316002)(71200400001)(86362001)(478600001)(186003)(966005)(9686003)(33656002)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?68l9bGuv8TVY8VdQ3rvhT+cdThxPHxPa2CqGBRcqBo/l/r5YSKtfv5duR1cS?=
 =?us-ascii?Q?coHmCAwZa6BsF/IrPt3eWzEuOZDD+qjS5zzkY1LB1Bj2E0BBtsCnChQUWydB?=
 =?us-ascii?Q?B8y84m8BgOr57BJnDRNChfRQGvjhot9d4wgOV4S4ZnAdO/4fibUmTte0om5q?=
 =?us-ascii?Q?Y1VKaaFoa4fWKz2TyDMM1a6k5usCx1z+7lKbKADW6USLR3TKB1jXJEOt0e6j?=
 =?us-ascii?Q?3UyeVdIujr/Vo/TqSWewIY90nf17CUEfbmJHe1GkFarww9MPyZjhrJaeyA/S?=
 =?us-ascii?Q?oFt7nBp79RKLOUU/lvkx1wsAzmNu+2SKKxFoiKS071dYPLHXN+pooiJZeqiA?=
 =?us-ascii?Q?KixLCLkqbL2ntSU+s/KA/gz2L5mwsQtwpS0U0Lw2l0HbwWbBLqjyKI+eR7j9?=
 =?us-ascii?Q?WvG2DS/fnR/yGgkaKvdUj5oZGMHiU+ycn3m9+OpHhZVIyvNt72laVLQmMTp5?=
 =?us-ascii?Q?kadmQ3O4iQhdG/w5FhGv0/SSZOWAaC0lftgntLkbWYQjT+JdXrnBU0zTO9q3?=
 =?us-ascii?Q?Pgp+5PBDhncG/YlqvZ93sjqTQjdK5WL5XPt53kYoT/iz/YeHiXZihnRk4Hy+?=
 =?us-ascii?Q?OLbdjYEODsBW8Bfl43KE5fzwS8Hu/uJRLOWS0J5q/4axjCSIWCTJu5jTicSL?=
 =?us-ascii?Q?H7ZLUBxkKrft0SYh7qHEY4j7cH4uMUr9XSrqG3SLaTbzbT+LcpCzXs9LMrmk?=
 =?us-ascii?Q?j9oEtfgAXmHpA/rGDe66E8nMAPZxY4xuCRMOonQwAmozR0rKzhRukM/orcku?=
 =?us-ascii?Q?6/Y3PDsUpw2DxIrXQAP8fywHai8JkCWRsDejOQfR6p+bNcqkdlczyz3cQ83Z?=
 =?us-ascii?Q?ModaO3aUwao58cvlZ8EMTAhALwxSkE4o4dL2GL0nQV1k2uqB2Qo9JTbXQ3lI?=
 =?us-ascii?Q?uYTmHBj/dotBYMLseSnrH1Nqpy6r2Q6RLFDn0nnaWYkr5QcITfPGD16MA2yB?=
 =?us-ascii?Q?Ya0xICYuWDlGhaNmcwTJ4MmwxO6TQ8cj9Rg8OexDX4k+zd6L64y+ctsZZq15?=
 =?us-ascii?Q?HjdlOW/akCXUVsFzjIlRDxGcw6syQuaSTFtJWQY+u5zySD5owsUchF6Oqde6?=
 =?us-ascii?Q?FCLZZFRUzr+ctTahyHmP9YrL/7JlO+sAhb7gOgXbF8xUpVE0oR91Io8fOrZG?=
 =?us-ascii?Q?6yEuvuyLq/Wd9azhJOr/XmNtETu6/bdvzKD8RqKx0SK92t/Iao+CG4DL99FD?=
 =?us-ascii?Q?443jcYYFWJ3f2GPHMdBOPWmfF3a4b0YCntAMxY32ZTThIj6aoBMSNY10UweP?=
 =?us-ascii?Q?BBbYMpH9FBjebeTTYTNYTHQiKTu0myOxZ+8gVE8LCSb1uJcMUIyvqOaTGkBq?=
 =?us-ascii?Q?+tdBXOvZlBTY6mhjxuTOiYJcfuYEhfSctAgTj6spW/FILN1cGUdyXhK7dWYS?=
 =?us-ascii?Q?2Q6qKVlJRBdNI5Y+VRN1VdZzTBjtpsDGCurKc5ls60WihdxUQiEUw+dZoy2w?=
 =?us-ascii?Q?cZ/r7HhVeC4XJQQ/KADL+DtIacDJu7BHrMLlbt6sEr7eCaUIeEBKE77ylj9M?=
 =?us-ascii?Q?wBvV3NjwQcxp5vpwzUJHWdmtZHko04Auzbvb8SKSUqME9K+tZNHZUPcb/6MJ?=
 =?us-ascii?Q?AvCCt3e582jrmTe7Vv8JYYo0rR3DwxhTjDYSx6mDbSGn2U4tXeFF224wr01F?=
 =?us-ascii?Q?ZQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR11MB5621.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16b253e0-d20d-4b5c-b294-08dacd242c61
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2022 07:27:27.3150
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Qke0glBo0k3b/jJqwBOKIxKyGn+b+YjhRa9j/D+ZH2UltTHKvqdp4jRr/DU7Qybag47hUMpW64ytflF9ydqluhIiW1b8lQtc+K1PBj5QLLw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5958
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of Y=
uan
> Can
> Sent: Monday, November 14, 2022 9:27 AM
> To: Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; davem@davemloft.net;
> edumazet@google.com; kuba@kernel.org; pabeni@redhat.com;
> alexander.h.duyck@intel.com; jeffrey.t.kirsher@intel.com; Vick, Matthew
> <matthew.vick@intel.com>; Keller, Jacob E <jacob.e.keller@intel.com>; int=
el-
> wired-lan@lists.osuosl.org; netdev@vger.kernel.org
> Cc: yuancan@huawei.com
> Subject: [Intel-wired-lan] [PATCH 2/2] iavf: Fix error handling in iavf_i=
nit_module()
>=20
> The iavf_init_module() won't destroy workqueue when pci_register_driver()
> failed. Call destroy_workqueue() when pci_register_driver() failed to pre=
vent the
> resource leak.
>=20
> Similar to the handling of u132_hcd_init in commit f276e002793c
> ("usb: u132-hcd: fix resource leak")
>=20
> Fixes: 2803b16c10ea ("i40e/i40evf: Use private workqueue")
> Signed-off-by: Yuan Can <yuancan@huawei.com>
> ---
>  drivers/net/ethernet/intel/iavf/iavf_main.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c
> b/drivers/net/ethernet/intel/iavf/iavf_main.c
> index 3fc572341781..69fded35e476 100644
> --- a/drivers/net/ethernet/intel/iavf/iavf_main.c
> +++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
> https://lists.osuosl.org/mailman/listinfo/intel-wired-lan

Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
