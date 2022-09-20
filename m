Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5695BEF9C
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 00:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbiITWEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 18:04:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiITWEu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 18:04:50 -0400
Received: from na01-obe.outbound.protection.outlook.com (mail-cusazon11020019.outbound.protection.outlook.com [52.101.61.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A285530549;
        Tue, 20 Sep 2022 15:04:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EFxgmjws99Z+9+3w3hh2dpESJ2OlROkRRAVSOqp6Dr3ZoW4WBlBaMAlxGJ0aCMmDWsOwJjYKvdZydyk8ungHFTVfnog9eLB2nmCs/SYN6NfDgJQwEeYvX6e8CytzAegafDmTIhBvbyRM9DX/cidGB1EwGfCasECjtWtE2zw70wMzhwp6Iao3B9382pIsguJgOYyrcDArpJFy9JeDAGry8xj2wV9Z7sPQW4JH/U76Pk9XMy7OiikRltfSo3soU3LRNXNmzSpnRCZEF/WePIpao3N78K+n8h0xWgTLIG4wXuVARVvwemVdaog8iDwjjr6di0f/wjrOmMeehU3iREHvLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UgBNJ5+ZxopxdORtBFSuSCMV0m/AgzSJvYEYIS8/uxg=;
 b=c3nBcfcUa7AzG6oTomcejMwEvHCbuKPL1QTBgJV0ALiuo6EkrmBJSSZmuqofFOb581rLlxV0Sy3yVaLKbc5nVGW273DJwBr848BxMzbLgh2nd3Qht9OAfGVorYPbK1h+GLKU5vT5Phjqa+XXdnlwLXq3pMNob5+58KdN/4xtQN1IAzLT6Q2/oR1V6SdQfjyHXK67BS0j5DCMxttH170fCDs+2hYPQbWYSEdvo2/T9z03Re1LF68kpuRSsyfk4nsoSY8miCYAs4HkH1X4Pow9HBCQI9/KeljO+T9YSRwQa9xlKD2uG+WRrxJoYsw06pZJuVgefRl0YTIbeFWAE2bfUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UgBNJ5+ZxopxdORtBFSuSCMV0m/AgzSJvYEYIS8/uxg=;
 b=b1DQu9F0IlmjNybpARSj7HiUATWWDjdHuknzeAeOapww+hmzc5wHJfs6RRGDO2DMoY86jSzJZJB1GOkY4TTCNogb89XCJFuNlDhAE1bSSzhMbARH0eLU62iWIVB86vdv/k8K3NSWMpc27svjfC74rKSayFRZFAp42Uik8i9TEgk=
Received: from PH7PR21MB3116.namprd21.prod.outlook.com (2603:10b6:510:1d0::10)
 by BL1PR21MB3043.namprd21.prod.outlook.com (2603:10b6:208:387::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.5; Tue, 20 Sep
 2022 22:04:47 +0000
Received: from PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::6de3:c8b:d526:cf7b]) by PH7PR21MB3116.namprd21.prod.outlook.com
 ([fe80::6de3:c8b:d526:cf7b%9]) with mapi id 15.20.5676.004; Tue, 20 Sep 2022
 22:04:47 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     Long Li <longli@microsoft.com>, KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        Ajay Sharma <sharmaajay@microsoft.com>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [Patch v5 02/12] net: mana: Record the physical address for
 doorbell page region
Thread-Topic: [Patch v5 02/12] net: mana: Record the physical address for
 doorbell page region
Thread-Index: AQHYvNF5E0lZyhJSckiah4znGQBIYq3pAD+A
Date:   Tue, 20 Sep 2022 22:04:47 +0000
Message-ID: <PH7PR21MB31167143447A9991D5F0773DCA4C9@PH7PR21MB3116.namprd21.prod.outlook.com>
References: <1661906071-29508-1-git-send-email-longli@linuxonhyperv.com>
 <1661906071-29508-3-git-send-email-longli@linuxonhyperv.com>
In-Reply-To: <1661906071-29508-3-git-send-email-longli@linuxonhyperv.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=a6cfffa5-4402-4156-9ef9-780b4f06ca8c;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2022-09-20T22:04:23Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR21MB3116:EE_|BL1PR21MB3043:EE_
x-ms-office365-filtering-correlation-id: 9112a035-def9-4ffe-ecee-08da9b5421df
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OeA2/IDkF/3dn6bgKo0NHbUjCYZKM2iWabiepVaYqb8sIuowGJKnp85x0VsEHUVguu0ls5l9DteLw2sEMT1KOT6dtNhxveT3lqVSqBPcWCOdsx//grp8My/+16KqplZL42WaRPgSwaceJULJRE2cUVP/hRdR6J5hV8n9hRlaZ0i+lbG6GHBLZDu5ZM4ZvLzFxjZ9Rp2i7vvfz2dy3eWpxvZVy5k4om0vjhHanqW9fewUWRrMD/FLYPfQOBKFOYhfKKHE73++mQ7NE8YVpyAkvxkaPwPYOuAdde+RhUYSP9GJEaIuwSE373N9XIIOHCPlLjGeXqxbIaNRcpB2nvYC4YX0Qvl8HkxiL39l/jOENcaMtLPDL95iZ84rX77CGadsjhtWuCX61Zmdh7eGPyK4Qbe3lm57WFNQCxgV9PrI3Oaquhz3HlOpq8XF1Kri9Nffchq7eDZpCPMbnlDDssy7uU31U86y9WLqHFdhsXnhtH88QDqpdUgbppROQs8M/DX0WeM/srMBf786Umm7mr/m/nvs0Z4172KXwd3/L5Px1yG+G1LFhXENm5DIbcTPhAYZiE07siQM7UKQ55s+IJ9plqR/i2zWQoQdyFyaalC8DFAJe4WL6MFO59QBh4FGCicMD+wquUBnS/BNzrALm69UZZctBLM8GFdCWXbe4tjJUsSYNRYVTG2P7sswzTg72C6OPCnsdBIu7gn8ejXu6VLGz95vGUZ8keCuFMDm7ByNreX95n6SOHURanib0VM8tb4DkyDuShu0l950rVEqA6UcXpsF/l5F72K53pjBZk7ULQwJ3aKYMuEXP5HrbQvbzzooyRGoQXI+je5q8tcjtjgv6A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR21MB3116.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(346002)(39860400002)(136003)(376002)(451199015)(53546011)(26005)(9686003)(55016003)(71200400001)(41300700001)(6506007)(10290500003)(7696005)(110136005)(5660300002)(8936002)(186003)(54906003)(6636002)(8676002)(4326008)(7416002)(76116006)(33656002)(86362001)(66946007)(2906002)(38070700005)(66556008)(66476007)(66446008)(64756008)(52536014)(316002)(8990500004)(83380400001)(4744005)(478600001)(122000001)(38100700002)(82950400001)(82960400001)(921005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?boQfhpkhSJOGsIk+BsGFHEgwTh2hv7efcUbXawJpN0BGqfuOiiUodzPbWgGD?=
 =?us-ascii?Q?TywICWQb9lmaoiWH6VP2eQ1+h5ZWm+xo3eE0GpQJYjYejmgQLQXw5YSmvoLG?=
 =?us-ascii?Q?tC+ElytAhGjQ3M6L1ayYZyWgpwRDmGjpyt4ylw51iztIcQU9/yxUsOwPp3q2?=
 =?us-ascii?Q?RghMZ68SBp6O0x+W6VFDvUmtJUCmgsvYGglvOuKN8847w28cRHx3dMEdQREZ?=
 =?us-ascii?Q?MJ76x16h33DmkOB0ksUgBlj4BRSugnOneYIUcfacLbJQACiTA95xDQyJU4At?=
 =?us-ascii?Q?R4DqhulGkQMvL6b9wdTCBvQGEQf14Bs+AtCgZTS6M4N81JzBn+lzhrLyyzcd?=
 =?us-ascii?Q?9DkhcM8+GNmR9RRhcFUvOhtlw8xk+jhIAsuPl4xAgEzMtoyr/ER7RoE+X7GY?=
 =?us-ascii?Q?sBWxt4bTNP2ghN+RlScKjWtK0Uv/xS44mfBpCSYc1FaU55DID77GygPlF86i?=
 =?us-ascii?Q?/Q5Yhkma3REoL52TUym0EyxPLiF7kJd6ILZpXkKUoXKdu6nrRjbMoph7yOam?=
 =?us-ascii?Q?ctHNIK/6Uty+wXD2/Ywqu02AFR/7sBn3su383WFcKnruN3fsA3EzRW4jJcGP?=
 =?us-ascii?Q?GED4Ci4ZXRG9g8exasa/RgPjcOMif+o+Bhxd5rR9SQAsI1YwrC0Wf1klEDrn?=
 =?us-ascii?Q?OztcRM+9s0SbRfWiMbdTkK5om8R/CzgzDk40XNXSne/UgGmxV64ac+KvH5pd?=
 =?us-ascii?Q?U0jZjOtFSSYHYHtKMjkTmKg7b3knxH6HXcdtv5a1W/t3WCoUnq6h7R8wHDbp?=
 =?us-ascii?Q?uglrmH+PbF3ZgZl0kh4aaR9UtIOJu7Pz9kdB14ANQs7x1Z6N9ygFvBobXSQ0?=
 =?us-ascii?Q?aMekL0wAK27F4seNY3Utd3CaZOYuWEkf5aznofktygIFArnL3+tRShlMdq20?=
 =?us-ascii?Q?gXo45jj9yYy24GBCO/TlHwOCxTb/5WFfLHqqs8SXCa5T3kzPysgWXNUs22pH?=
 =?us-ascii?Q?u2bhDTFPBlItCA8DC90ZzBzf4fHvHEILChdQuXFSd3CMoiGV3uhrNXlhhkr8?=
 =?us-ascii?Q?/E1IQ8VfeC+BJxyUiEOrPwGNkhvnFVH2x0BAGbg45yhY6G9oQE/C0Gdy4Nit?=
 =?us-ascii?Q?RFxeB+QSFbFcyHSUu+GMv7orAMkNmnj8Kdzi+AJIDsGYTELb9+hRSjpSvV27?=
 =?us-ascii?Q?NurrI4Zzj3IMCJKwBoWsO7h/8x9rRONPTOcUbIB4eA9Lq9Pt/Z7xOtwcVhK2?=
 =?us-ascii?Q?nb+mEgte/zTw+nhC4dueC/Ud3CxqcyhR2K8MsKCyAkgmq6SqHfAs1XkAH5sM?=
 =?us-ascii?Q?tS9+irreztVFQu7Q0oVjxHJ8AiB95yALESDEOqau0oxK/NOcVdVQILMxi8hi?=
 =?us-ascii?Q?vBwLobHAFaUzzMfuhWM466WFlqsf9kENKtrMKScEB0rmdk0JY08N2zALNQ7l?=
 =?us-ascii?Q?4/PUMewQiipQEpClxbD5FPlDGLixbbYutUCcBonHO8jHpdxXKW8pnDUPpp8e?=
 =?us-ascii?Q?eiTagqYE24Z2RCmv94KjRHX2Xvpps8xc98Xaovl0rs6s1ralkTyAXU9VrSIO?=
 =?us-ascii?Q?2UfUloYD5E6Skw7nRJ3fw0YGs/Gj4wZqQvl65HUbv3c6JLVqk75YJLioYCmD?=
 =?us-ascii?Q?xawgZj3jqZJ0S92cS6zHI5o2vD08SALV0bLyZ55v?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR21MB3116.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9112a035-def9-4ffe-ecee-08da9b5421df
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2022 22:04:47.3602
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2B9A9JrcAr91o1Qw/NaoOoAeD4txhztEe7GdsUBWTQ7AtA3zrpvzHBcCPbXsKwHQcQP0LUEXIBDuDB/42BMIPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR21MB3043
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: longli@linuxonhyperv.com <longli@linuxonhyperv.com>
> Sent: Tuesday, August 30, 2022 8:34 PM
> To: KY Srinivasan <kys@microsoft.com>; Haiyang Zhang
> <haiyangz@microsoft.com>; Stephen Hemminger
> <sthemmin@microsoft.com>; Wei Liu <wei.liu@kernel.org>; Dexuan Cui
> <decui@microsoft.com>; David S. Miller <davem@davemloft.net>; Jakub
> Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; Jason
> Gunthorpe <jgg@ziepe.ca>; Leon Romanovsky <leon@kernel.org>;
> edumazet@google.com; shiraz.saleem@intel.com; Ajay Sharma
> <sharmaajay@microsoft.com>
> Cc: linux-hyperv@vger.kernel.org; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; linux-rdma@vger.kernel.org; Long Li
> <longli@microsoft.com>
> Subject: [Patch v5 02/12] net: mana: Record the physical address for door=
bell
> page region
>=20
> From: Long Li <longli@microsoft.com>
>=20
> For supporting RDMA device with multiple user contexts with their
> individual doorbell pages, record the start address of doorbell page
> region for use by the RDMA driver to allocate user context doorbell IDs.
>=20
> Reviewed-by: Dexuan Cui <decui@microsoft.com>
> Signed-off-by: Long Li <longli@microsoft.com>

Acked-by: Haiyang Zhang <haiyangz@microsoft.com>
