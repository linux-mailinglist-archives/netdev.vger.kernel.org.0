Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D43CB6B0586
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 12:11:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbjCHLLC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 06:11:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbjCHLK7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 06:10:59 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C6A6A92DC;
        Wed,  8 Mar 2023 03:10:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678273848; x=1709809848;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1Lthwg1uR+he98OyvpmayTCPpQ25oGnbBuwDFn6Zi1E=;
  b=OJldeQt2wP2JK9ZUOfvGpIcSQrPrst38x5mzb14w+tOnTm3vDdPX4cVJ
   zgZWyFjKWbA4EMfbzUdJ17UBVALCB+UmJ9cHoZwna4UJpj3P93E/QSRhM
   w9m6HvfPyLGUwVtVmdfgMczhvzho4w1SToFSTwODEDn+H+2Z/4kGaZ22W
   HhDJGID0XAd6wLUYQ8j/JPPbEmHT0LkjRNTyBVzKHvC/Eqx2I4HjwmwvM
   OugaV8baYMc2jUX6cFSmxMt/fAhq9uYSrcqIWZrOJoZOB8n7JgrB39pRe
   6VeOjd8QUjTcOvHSLZJXRVgcqIz61WheJC5Zr/AVVJDDXqu7H+mTq7OiO
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="316527370"
X-IronPort-AV: E=Sophos;i="5.98,243,1673942400"; 
   d="scan'208";a="316527370"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2023 03:10:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="745877182"
X-IronPort-AV: E=Sophos;i="5.98,243,1673942400"; 
   d="scan'208";a="745877182"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga004.fm.intel.com with ESMTP; 08 Mar 2023 03:10:48 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 8 Mar 2023 03:10:47 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 8 Mar 2023 03:10:47 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.41) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 8 Mar 2023 03:10:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A/PmAmIi4HFPqOldUXlqsNSmXxdCui5Wt6za+xCByvYlESpmSKHo6dWLOpYY+pVdeS/T5IYjwQnEIW2D5gPeJYQ26zEQXmaLqm21joAcCaLSWe5UxJx2cv59ZiZ6ZjS4ln61kBZHPF+jnr/rIV9PJN0bDmqGPySIPg6AlmA+HrtEl9Zb4Lwh0ikRbPOPJ787D28dp2GT+MP0HJg+ERNu7QIqhmRrr6s+eLC2YTFY+NK5fSse0w+Gxtqjf3T32HYgye9cQfihnmegI3CWePDf+pISd0P0/gZBe7RyDI/HrY1eIEI/bRpdGEInueiXMnVSTwd2bwN1mRP/Mw2IeMyqvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e3bxfQBLjpveMULMyFCfzne72U1Bd8Cwk3yEK1/Qk2E=;
 b=F5NPiPLF3wPNCCeeYD64wESlgb3TC6J5l2pp75qiydlC9o6VsgiouKGUlMKBeTrG1c/eR7XSqQRjngxX3S4OLXX8RvhmwmM71PBzVwctVvjnKJvX1V42TSJXv5S951gJlCCdrRAJ+ITFW/QWhNWxS2gPizxbjMOCEkz1pVzAiUawBe9wkI8bBunQdT+ifZgYBM0kDo7Dc2qWZ2/Fy4jcUkuKM+FG5QJNejhN/0ejXyQtGht9FSaIQhxe4hIWbQNUmPFAYjPHbUaTKzzXllaLk43bzuyZzwvFPek8WkYFGaWizZs2Iy6M/Gavg06FVc769CiTib1/zZ2MSWnUU9cF6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5354.namprd11.prod.outlook.com (2603:10b6:408:11b::7)
 by PH7PR11MB7662.namprd11.prod.outlook.com (2603:10b6:510:27d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Wed, 8 Mar
 2023 11:10:38 +0000
Received: from BN9PR11MB5354.namprd11.prod.outlook.com
 ([fe80::464f:1bfb:43d4:416a]) by BN9PR11MB5354.namprd11.prod.outlook.com
 ([fe80::464f:1bfb:43d4:416a%7]) with mapi id 15.20.6156.029; Wed, 8 Mar 2023
 11:10:38 +0000
From:   "Arland, ArpanaX" <arpanax.arland@intel.com>
To:     ivecera <ivecera@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Eric Dumazet <edumazet@google.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        "Piotrowski, Patryk" <patryk.piotrowski@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Piotr Marczak <piotr.marczak@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>
Subject: RE: [Intel-wired-lan] [PATCH net] i40e: Fix kernel crash during
 reboot when adapter is in recovery mode
Thread-Topic: [Intel-wired-lan] [PATCH net] i40e: Fix kernel crash during
 reboot when adapter is in recovery mode
Thread-Index: AQHZR5intrhKoZRYj0KQpYhL42nvwa7wt45Q
Date:   Wed, 8 Mar 2023 11:10:38 +0000
Message-ID: <BN9PR11MB535465F6E6A668924319AE3580B49@BN9PR11MB5354.namprd11.prod.outlook.com>
References: <20230223150702.2802683-1-ivecera@redhat.com>
In-Reply-To: <20230223150702.2802683-1-ivecera@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5354:EE_|PH7PR11MB7662:EE_
x-ms-office365-filtering-correlation-id: 2c559bda-6f7b-4146-9978-08db1fc5bfaa
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Jqwv9LpD6+vDryYO93UakboIHbGoNAYdvJO5+8yo9P50fCUZ8fmebUZSRjBxiWOVmvnRj7xVD74dhpGkXdcsZmA1kGlk38thJ2hDT4jpz2YhWzDYBAiA2/seRiihaKLJFXOuxzx5PR4TbM5/SA11GtLtsrJwwTy94D1Zjoxkgs1AdxyUIGWXKiFpPI9GG5B5xfaRPvAtaLHT9w87SKqDY1vw4V/gQ9no0qolsxqfoe2nkY4C+NtWmdRaMGPyUcjZjwxicJd5XwfB39bMQRBLsVbWtP2gHydDvUomBeAvtXxZU3kjj494vqeN0XfxmTEblcAb7lYaJp7C0hCaN608Fsk7Oh1loJL4xmhClrdC1XTDnJBgh4Z+gmQ4BuZ5sds7234Lp7FdQUmcLroGSaej6lqFGqTWaoN9/i7at/bQZbfkn3lgdP1JjaRkvZJNLZx5YFKVXxyMQVTYb6u9NnWzf6nafXOSZjMLQ2/M8X8kLbKBBjmYBxSO2NOnM6ytIb8ItG6zrOwI56pcwD9yuWB+MaPRCwQuRhLckxZzhcVLK65ZYtawV/CfwU85eicrIkoICLipOzmJVtYtVtJK1uC8JEy0xKy2JccVyu20BDuzKJ0CsTHGBO3jRpik0p2h4L/0QCVd11juUZv/hwrm2HfV8mzGo/BWFOecP0kZLjin7HWiS0D+6IooPkwB925fa1LOZWMURNTkWMBPwvQlPZyMiw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5354.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39860400002)(346002)(366004)(136003)(396003)(451199018)(4326008)(66476007)(41300700001)(8676002)(76116006)(8936002)(66556008)(66446008)(2906002)(5660300002)(38070700005)(7696005)(86362001)(122000001)(38100700002)(82960400001)(33656002)(66946007)(64756008)(478600001)(55016003)(71200400001)(110136005)(316002)(54906003)(6506007)(186003)(26005)(52536014)(83380400001)(53546011)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?iNw6VasEXpews90lPtii/jI6/EyQ5z9dAPty0gVcxvsrm/qZCnL1nXYGrBND?=
 =?us-ascii?Q?eUtFF4oNJBw+KXlaDqqoA3700KYco3NYEMlylzYXu8PeTY/M0ZjGsfrtjoXs?=
 =?us-ascii?Q?EmR30LO+OaOqQwdxPF3qsnsg3wol2+/mLCq1T+UFkuQX5/cTDZOVKQca4Hjp?=
 =?us-ascii?Q?nDsQMUEbQKwJ16nCr7Q2G7URucOHI56+3soI+U2rTf/kCqiCw0BRz/ab7/XD?=
 =?us-ascii?Q?InqTbC9zKeyzC+NK+0rsNMZ8uT59USXP1D4Qp0Fn+GFH4AED9sshGLxGN6v4?=
 =?us-ascii?Q?Cge2SVRTt9wdLfPKR0g6FIfgNNdC5JlkIdbXaBYUtxASh/Q2xq+jKnFdbTxJ?=
 =?us-ascii?Q?pgiNLQLQiPRbilBp8J7F9mWG7qhZ+5nkA3+/o+9xwOnFj1MUXn79MPb5Wqyo?=
 =?us-ascii?Q?Hiak0dUJ/30gX/fuh2Xp2SURh8i+IB3k5+i1HX/VeCf+0LMScginEietdiXh?=
 =?us-ascii?Q?3VRkH7R8X0t4y0Xgv4S96bmYmohNaD2fU+fpOnAR0KQJ1IUAK4tISJxE8Kz0?=
 =?us-ascii?Q?dxkvDbRmV4LfjfpPIJClVeX6XpXO2/+ikA+sgIAqfgXsH7iMD8lqP1P5F2S6?=
 =?us-ascii?Q?Ur6dxQGK+Qt4GTbJkEfcqWhi/KUIvM2y/sRodu0sTfPJyKQWmd7KwY6BqN0S?=
 =?us-ascii?Q?YVcM7On4OGMyFVXi0kF/9YGJTNCMEe/1wUlcgUaVmF9SiQRSoq0/IFF4RFec?=
 =?us-ascii?Q?7XCmhBZFH4UDrl0QUNuwHizdIMyWS/0jov5k1colxunF/IAajx41YuHkAezg?=
 =?us-ascii?Q?8ORvdrP4GRdLvP2TStPbWZ4p4JqLgDJdZCe2MccM6Q2gheMa+huTRUf5K6Gb?=
 =?us-ascii?Q?EY8DNBmKPLj/EPepY7fvDDSMquN938AHSzFYt1gUesjBBN4/SEmXCkQNidri?=
 =?us-ascii?Q?RaBnwGLvCAkMQxCI1YuvRcGA0GF0TivfeX0QPY2n0pFGI6oFdeOM7wKUTrjZ?=
 =?us-ascii?Q?fcS0Dn5DyKd0em/jTGoTywCxLCJygbSA8t+VxBxOIV78BmjiY4i5/WDSe2fk?=
 =?us-ascii?Q?wNQgp2Q0VnHAP4u81G59InGEv8G1O7Oh/1xVU89waQkbQK4ovpHSenv2BnQi?=
 =?us-ascii?Q?DTN0f3blUY1tHdkNZ1VMP9V1gR3ze30i0iqohEUdBOCNWkYPsst4QqrsAuJi?=
 =?us-ascii?Q?rhe+mHsFXU3Rmb0gwTkwXXQkhYfxU6CNxHSx4+eu2US0KB4r83uQSsDOYBH9?=
 =?us-ascii?Q?ZR5/4PU50h1u+qoqJmLk2wvnh1o6SV+OiYSbC9AvDjgHkb+WtnKwmmgri5em?=
 =?us-ascii?Q?qXFBojFDsbBWPGu3xBmnwyESA17UjMtjqcCl8ntge8gDUKRxdixt+tGwBiNP?=
 =?us-ascii?Q?0DozFRMaK3IWqRwKVRL8Ef0NZuy8DaExMfzWOE5t3DZ1jb8U1hI+rIbHX9yO?=
 =?us-ascii?Q?nwT01yp+X0Vlf+EMZwKebjW0f7sv9EyPY9IPbqSt+ay8xPQEQaIwTQhy9J8U?=
 =?us-ascii?Q?R9pBrRyDhQ7M1uYMvTYMlww4e16/4es72gZR5jkl58Myh7oozvPcVXo1I1t8?=
 =?us-ascii?Q?DSmLY0jd9wkZyzniUyTD4CAGeJlFgm8PZvWsASYbAFBjsTK/97PWaZPDjdmH?=
 =?us-ascii?Q?bLC+iCKVQv3hLBB1EXolayFrK+GE+x1eSfqRwF4s?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5354.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c559bda-6f7b-4146-9978-08db1fc5bfaa
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2023 11:10:38.7079
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D15xfHeJJZvCmPMJkFrcNpMKauS70yLsKggjZZXHSpxu/4wd9r9vLhuLkc5lnzT36dTuFzKD7kRXWYE1xogKFfakf+eJ9hjMUd9Tykf/KIM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7662
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of i=
vecera
> Sent: Thursday, February 23, 2023 8:37 PM
> To: netdev@vger.kernel.org
> Cc: Eric Dumazet <edumazet@google.com>; Brandeburg, Jesse <jesse.brandebu=
rg@intel.com>; open list <linux-kernel@vger.kernel.org>; Piotrowski, Patryk=
 <patryk.piotrowski@intel.com>; Nguyen, Anthony L <anthony.l.nguyen@intel.c=
om>; Jeff Kirsher <jeffrey.t.kirsher@intel.com>; Piotr Marczak <piotr.marcz=
ak@intel.com>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat=
.com>; David S. Miller <davem@davemloft.net>; moderated list:INTEL ETHERNET=
 DRIVERS <intel-wired-lan@lists.osuosl.org>
> Subject: [Intel-wired-lan] [PATCH net] i40e: Fix kernel crash during rebo=
ot when adapter is in recovery mode
>
> If the driver detects during probe that firmware is in recovery mode then=
 i40e_init_recovery_mode() is called and the rest of probe function is skip=
ped including pci_set_drvdata(). Subsequent
i40e_shutdown() called during shutdown/reboot dereferences NULL pointer as =
pci_get_drvdata() returns NULL.
>
> To fix call pci_set_drvdata() also during entering to recovery mode.
>
> Reproducer:
> 1) Lets have i40e NIC with firmware in recovery mode
> 2) Run reboot
>
> Result:
> [  139.084698] i40e: Intel(R) Ethernet Connection XL710 Network Driver [ =
 139.090959] i40e: Copyright (c) 2013 - 2019 Intel Corporation.
> [  139.108438] i40e 0000:02:00.0: Firmware recovery mode detected. Limiti=
ng functionality.
> [  139.116439] i40e 0000:02:00.0: Refer to the Intel(R) Ethernet Adapters=
 and Devices User Guide for details on firmware recovery mode.
> [  139.129499] i40e 0000:02:00.0: fw 8.3.64775 api 1.13 nvm 8.30 0x8000b7=
8d 1.3106.0 [8086:1583] [15d9:084a] [  139.215932] i40e 0000:02:00.0 enp2s0=
f0: renamed from eth0 [  139.223292] i40e 0000:02:00.1: Firmware recovery m=
ode detected. Limiting functionality.
> [  139.231292] i40e 0000:02:00.1: Refer to the Intel(R) Ethernet Adapters=
 and Devices User Guide for details on firmware recovery mode.
> [  139.244406] i40e 0000:02:00.1: fw 8.3.64775 api 1.13 nvm 8.30 0x8000b7=
8d 1.3106.0 [8086:1583] [15d9:084a] [  139.329209] i40e 0000:02:00.1 enp2s0=
f1: renamed from eth0 ...
> [  156.311376] BUG: kernel NULL pointer dereference, address: 00000000000=
006c2 [  156.318330] #PF: supervisor write access in kernel mode [  156.323=
546] #PF: error_code(0x0002) - not-present page [  156.328679] PGD 0 P4D 0 =
[  156.331210] Oops: 0002 [#1] PREEMPT SMP NOPTI
> [  156.335567] CPU: 26 PID: 15119 Comm: reboot Tainted: G            E   =
   6.2.0+ #1
> [  156.343126] Hardware name: Abacus electric, s.r.o. - servis@abacus.cz =
Super Server/H12SSW-iN, BIOS 2.4 04/13/2022 [  156.353369] RIP: 0010:i40e_s=
hutdown+0x15/0x130 [i40e] [  156.358430] Code: c1 fc ff ff 90 90 90 90 90 9=
0 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 0f 1f 44 00 00 55 48 89 fd 5=
3 48 8b 9f 48 01 00 00 <f0> 80 8b c2 06 00 00 04 f0 80 8b c0 06 00 00 08 48=
 8d bb 08 08 00 [  156.377168] RSP: 0018:ffffb223c8447d90 EFLAGS: 00010282 =
[  156.382384] RAX: ffffffffc073ee70 RBX: 0000000000000000 RCX: 00000000000=
00001 [  156.389510] RDX: 0000000080000001 RSI: 0000000000000246 RDI: ffff9=
5db49988000 [  156.396634] RBP: ffff95db49988000 R08: ffffffffffffffff R09:=
 ffffffff8bd17d40 [  156.403759] R10: 0000000000000001 R11: ffffffff8a5e3d2=
8 R12: ffff95db49988000 [  156.410882] R13: ffffffff89a6fe17 R14: ffff95db4=
9988150 R15: 0000000000000000 [  156.418007] FS:  00007fe7c0cc3980(0000) GS=
:ffff95ea8ee80000(0000) knlGS:0000000000000000 [  156.426083] CS:  0010 DS:=
 0000 ES: 0000 CR0: 0000000080050033 [  156.431819] CR2: 00000000000006c2 C=
R3: 00000003092fc005 CR4: 0000000000770ee0 [  156.438944] PKRU: 55555554 [ =
 156.441647] Call Trace:
> [  156.444096]  <TASK>
> [  156.446199]  pci_device_shutdown+0x38/0x60 [  156.450297]  device_shut=
down+0x163/0x210 [  156.454215]  kernel_restart+0x12/0x70 [  156.457872]  _=
_do_sys_reboot+0x1ab/0x230 [  156.461789]  ? vfs_writev+0xa6/0x1a0 [  156.4=
65362]  ? __pfx_file_free_rcu+0x10/0x10 [  156.469635]  ? __call_rcu_common=
.constprop.85+0x109/0x5a0
> [  156.475034]  do_syscall_64+0x3e/0x90
> [  156.478611]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
> [  156.483658] RIP: 0033:0x7fe7bff37ab7
>
> Fixes: 4ff0ee1af01697 ("i40e: Introduce recovery mode support")
> Signed-off-by: Ivan Vecera <ivecera@redhat.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_main.c | 1 +
>  1 file changed, 1 insertion(+)
>

Tested-by: Arpana Arland <arpanax.arland@intel.com> (A Contingent worker at=
 Intel)
