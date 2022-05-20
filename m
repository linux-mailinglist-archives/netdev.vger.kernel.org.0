Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 645CD52F248
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 20:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352491AbiETSNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 14:13:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352484AbiETSNr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 14:13:47 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D366D18FF12
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 11:13:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653070425; x=1684606425;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=L7Zh2x/GcUneggIfzHQGVKhW3hv8aAGAFa4h+NnIK/I=;
  b=cARf0Ad1gZaLXIbMozch3iwrCHjAbiEw4v61Ax3iZEUkB/GWu8+8K0Pg
   KMrCXj/ZfYQXWRbh7LH+GuxP4G96dB7c9ciCwFln96LdMqT2aG8dr7HRD
   BD6kNeN4SHa9S9jMYU0skQYnQY7OFAAlN/LolTs4w/64EFANsFAGQ8iMC
   s4Wi+BLh5OXPnJGlLIkoDWdHW5J8Lvsb8o572K3i2fRfZODraUDU/akmb
   yVsS8a1Vs9jfNVjEAL4C0PbS5lT3WJHDmMP8Qmf7XzvZBDDu72M5T1E4c
   hcYQETao3Y/heH8/IggAY3vjAGSBqsEHWDnCYpn0ek+NNg39CXVpgw5z5
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10353"; a="252577058"
X-IronPort-AV: E=Sophos;i="5.91,240,1647327600"; 
   d="scan'208";a="252577058"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2022 11:13:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,240,1647327600"; 
   d="scan'208";a="557567205"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga002.jf.intel.com with ESMTP; 20 May 2022 11:13:45 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 20 May 2022 11:13:44 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Fri, 20 May 2022 11:13:44 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Fri, 20 May 2022 11:13:44 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.43) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Fri, 20 May 2022 11:13:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UpjrocWhU4y7yjYwOzHh00iEuZ6atVR9M6mzJ4tBTI558HtYU0k/I1wx2UNvXz0IbtaWFtJVCdMlW+SD2gdIOD7pOms7pa06dQZHvIeoCQKuUzzFwtxcRXi0Hc+KtKH6OKadixcRwOwQc8DK/EvkDB6ktC/IWkfgpfSUqOH11fZlKCN4vZSV1wgmcTpw4QdQKoFAaE6Bqk7zAmirpB1hKEvGVA/c9CyHMBchzYs3Xe/giuYW4ifmuWoXcReWhkO10AHOFGDH/zZWk599QZEwSA0ObXcx8KbOhu82qIAgRXpZHNE6Sj5d4X/cpo0Od5hDcKTU4WI8dI8Fl6yqzy6NKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L7Zh2x/GcUneggIfzHQGVKhW3hv8aAGAFa4h+NnIK/I=;
 b=PN10VmM9wR8t9FWv3tfyZ2FxGpjB1wOCSVhbwzCmh1leuEq8AieQ65BRc/ZVGsmETjzDqVTEQdIh5bjijEOYY7taAVL4m7TrGQYI/g6A4p6RL/GgT6H9iKJL/9Xoj+SIlTrTUACHkYW8baNdUR9WSfNG5rqBl55dcDwTebgCFZuqhgCwfWLnF/XLpZ121Dllc0SLCiiUiFykc0VUhNT75nAz6AWQ0UK601YzlUIWbReyGcPy0bGIaIekpj24sUq224GgPu1Pe7CC3tqihshfZiK4ErERS1z0lL5L5m0N5iFtN+UJQnlC6H8MrueXWLxHUAvivkrgkCSMlS2PTBP2eA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ0PR11MB5008.namprd11.prod.outlook.com (2603:10b6:a03:2d5::17)
 by BN7PR11MB2707.namprd11.prod.outlook.com (2603:10b6:406:ac::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Fri, 20 May
 2022 18:13:41 +0000
Received: from SJ0PR11MB5008.namprd11.prod.outlook.com
 ([fe80::3968:a4a:e305:b6f2]) by SJ0PR11MB5008.namprd11.prod.outlook.com
 ([fe80::3968:a4a:e305:b6f2%4]) with mapi id 15.20.5273.017; Fri, 20 May 2022
 18:13:40 +0000
From:   "Kumar, M Chetan" <m.chetan.kumar@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        linuxwwan <linuxwwan@intel.com>,
        "loic.poulain@linaro.org" <loic.poulain@linaro.org>,
        "ryazanov.s.a@gmail.com" <ryazanov.s.a@gmail.com>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>
Subject: RE: [PATCH net-next] wwan: iosm: use a flexible array rather than
 allocate short objects
Thread-Topic: [PATCH net-next] wwan: iosm: use a flexible array rather than
 allocate short objects
Thread-Index: AQHYbA8OM/aGYjP29USMkevEfHFwv60oElGg
Date:   Fri, 20 May 2022 18:13:40 +0000
Message-ID: <SJ0PR11MB5008005633166EDB1BBE59B8D7D39@SJ0PR11MB5008.namprd11.prod.outlook.com>
References: <20220520060013.2309497-1-kuba@kernel.org>
In-Reply-To: <20220520060013.2309497-1-kuba@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.401.20
dlp-reaction: no-action
dlp-product: dlpe-windows
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0e8a87ea-1c75-489c-37a4-08da3a8c7798
x-ms-traffictypediagnostic: BN7PR11MB2707:EE_
x-microsoft-antispam-prvs: <BN7PR11MB27072546733B07CA10E7A191D7D39@BN7PR11MB2707.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5mtlZkwRAOk1ZQ9e60rIDmttLsBQaerMmw22jQHBVyz2J2645t/0eM1ipKFS+OZKk9tFE/w70A0y2hhnZ0i/fEpy3IHX6NgaiFsTrVkG+pHcKyRs0FeWZTVHMJT4f4ZC5mpatQKl6CFUTQreFNINU0cUhu1dWUgKmGez48c6AHhlzPAF2zZ6c/kO9fmtXILNqowCtLRZXgmfzuZsEQz+Fu1yCIBOX4kZelq9zO3WbmSTMmjpfXg9+xCKeOGgfDG8JYuwMciemEtEfEd9pqV04qmYRtkFf11Q1l8oA5f/6PSVl84A9CShiP/8hKT0wPutytJb6rB9gTQzFtVM0mew1cIuuvgxE1sptcfuKjnhDX20XmD7g0HfSfoX7slFdoVF2dcOJrjKh0BO8lVBT4jte/IKWT8Feq7xEqRMicUehKx6FwMCG+XtqF3AhJAQZDI6iYNyVMz7pnsP441fIP9LNvIsWzBUdR7E6TRDCf3KrssmO46c/w14o2r1etkRGiXuJXUfCRN88LiU5EwUG52iMO21woYF40ZBZgm3tnoR3T9cNS45IEYfOfzkVzY6grL7j5kbSNvUMisbyQATzTOQlMcf8dRg8waUhre7eUSJ9YeRasYv9McVOBMC4jEyedO2jgkoB2ryCaXAsgSSZzV/NNLtPcnDhHCGdCBnTC1kfC4UEiyxmg6iKw8E68m2StTpZPGli6j40Na2hCq2zyS33g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5008.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(6506007)(316002)(8676002)(7696005)(186003)(33656002)(4326008)(52536014)(8936002)(9686003)(26005)(53546011)(55016003)(4744005)(54906003)(508600001)(5660300002)(66476007)(66446008)(64756008)(38070700005)(38100700002)(110136005)(66946007)(76116006)(86362001)(66556008)(122000001)(82960400001)(71200400001)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?1E4Bmn+KNCKIr4wsa5/jWLABo7wTiT30wOE3HlDiyDmHcDTJquhedUppiXpx?=
 =?us-ascii?Q?V0/sSzGD+/7OcVECUUXaGstUNWu/NqyFNzjmAmbFJpJ3NYLhg+5sPZX302tC?=
 =?us-ascii?Q?SzK7Dp+SvrkOSV3NGVS/dJ77n3XuTHGqzTk8pf5O7aTd2uRiYNGfzojC4ZuB?=
 =?us-ascii?Q?mR+f8FcX6bneE7ZuauUjIeAJPpJH4LYszxaU5oma+MYGfEpYv1pLsNvVKYko?=
 =?us-ascii?Q?xTJjm7uxs7fQWPT7rp9mj+5wPWcxX0gJO67Kpwk0Z+EqnepjQ3mSsUxYGy4n?=
 =?us-ascii?Q?025+YXC2PtbjceXLRmYwk7zg/DkmEpsQ5URGkYVhAP8puAvdYLWaoorVO4DI?=
 =?us-ascii?Q?I71fzhCke2w+lhvXg52DCQqL1Bz7G1604j1QcqZDLQwazKk3qbrGfz4qOrV4?=
 =?us-ascii?Q?5D46yqnhlsavt90T/VYF0cl5s/BXGe5h1BYpACk/Dg0RcfCrVAymjiyPlYLU?=
 =?us-ascii?Q?E4ThlkBKXk6pdYn7QDVT/M7KFsHCKl8Igf6npJxz1IFvG8OfA4E19lpANfPU?=
 =?us-ascii?Q?/buYluA9MTzoHWg8xH0y8FMcY9xqLLqayvXOuuBPI/JDoUYauuafZLPOXOmL?=
 =?us-ascii?Q?2SkXXVxhQ8K9H4vL8NbG6NiOVWiZ6NJyRQ4e7KrcZdkL+AaxGpu8g5E+MoKj?=
 =?us-ascii?Q?6tWT+Sr1eIYQI7xVFzfzh9UiVX3tVsaFWSGEGa6+FOiKQF+FDvvMsUESi33k?=
 =?us-ascii?Q?klzLGbaRP0gdbTo/KNTa06NWG8O0B94+X6cMyPBz6+REhHwl/9EnCLSuTNUl?=
 =?us-ascii?Q?XJJtp66isU8d5benrz5wjK3pVqWI307lV4j6fMxoIydUw8VZqH4VbvwQx6FH?=
 =?us-ascii?Q?ucw/Ik1MJqkrS7+LCUsVrUZyd2yyIXuxW37VUlSaG2ixoKE0ui/xtTuNshTp?=
 =?us-ascii?Q?SaygHJRgvM0l5EMUzfL1PFLug4Wg3+qUCsTWECpnLc/ZRxQfrKfs1PTymahm?=
 =?us-ascii?Q?Ue6X7EMO8mtXGvOJ2/KV/R5UPiwOvHaaZzhLGLEDpy+dANF0yhwz+vwr0owm?=
 =?us-ascii?Q?OsRaCN4FyIXPHDIKrmnBtw36BM9BIewyAXNP3sZmKPD0fQrAV/+Pzhg7jO4B?=
 =?us-ascii?Q?WmAN4iVJpL2Wa0/xjv7imfo3HqU7fgWAkTA3Pkq1tWKJ9Rs0KeHi7gD45sCS?=
 =?us-ascii?Q?oXbdgdK1UAHJqHDM6eAQwlBczEripXCAFP0I908SWDt4rWcNvLn4w2UerVMb?=
 =?us-ascii?Q?iOzbpmS0IC+F3lh93PCrK7NHFgl7UrEL3zTtnL55/FC+pyso5K0xbTEKkfeW?=
 =?us-ascii?Q?LLSqp75l/XCJzdLt8aOGR8hLSm44TP8DjD668yvybRzP3xGhqnt3aZyIxOYN?=
 =?us-ascii?Q?oYI/DKQQWW/eKiNHjS7Y6E12ysbTEVfAi4t+A3DosOhhc+C37xlQIUGZrrSW?=
 =?us-ascii?Q?TCipFHi0Q9wTlclwfpROikTboNlAUuSazVKE/wbbCPDkzSunsDGkbTYgjVqC?=
 =?us-ascii?Q?UBgQZ3pTHS6k9QdYJWGFZBHXQBRPis/5Qqo+1g735rLvPaJ5f9fDL3OIZh+U?=
 =?us-ascii?Q?rdDPjWoWZZS3NLUBRYbgL4a3KL20pVTpBQHw9IWpSNLONN/Uq4fuAWMWtJk2?=
 =?us-ascii?Q?mTPXbRB0NV4G6Zs0vTB5V7veKyae2/1IrmATikeiolMOSbT+haNqcSW3QcTA?=
 =?us-ascii?Q?FHIEm0C77eQvhCK2oc5HNxtwiSwfVQqJGY6//5U6Kvrn2TIAIeisArCaQRnB?=
 =?us-ascii?Q?8ynIZSxn4fWlwsuuIqy9MtXXSp4iJLDOPgLyG7Ek/qLwExfQp+4A1DqCqp8X?=
 =?us-ascii?Q?ThDaVfqBzwRbbs9s8LO4WpYeAONXxog=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5008.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e8a87ea-1c75-489c-37a4-08da3a8c7798
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2022 18:13:40.2174
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y/bvninO+bUmraNeGkKogmG7gSTDayulsCfOyZivhXasl9Pv19RWZtaZbvc36kaqGeQSPKW66e/UOSbpzidH/c6zSAQqHWM98EGtXOVAP+8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR11MB2707
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Friday, May 20, 2022 11:30 AM
> To: davem@davemloft.net
> Cc: netdev@vger.kernel.org; edumazet@google.com; pabeni@redhat.com;
> Jakub Kicinski <kuba@kernel.org>; Kumar, M Chetan
> <m.chetan.kumar@intel.com>; linuxwwan <linuxwwan@intel.com>;
> loic.poulain@linaro.org; ryazanov.s.a@gmail.com;
> johannes@sipsolutions.net
> Subject: [PATCH net-next] wwan: iosm: use a flexible array rather than
> allocate short objects
>=20
> GCC array-bounds warns that ipc_coredump_get_list() under-allocates the
> size of struct iosm_cd_table *cd_table.
>=20
> This is avoidable - we just need a flexible array. Nothing calls
> sizeof() on struct iosm_cd_list or anything that contains it.
>=20
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: M Chetan Kumar <m.chetan.kumar@intel.com>
