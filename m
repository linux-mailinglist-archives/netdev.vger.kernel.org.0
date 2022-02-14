Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7762D4B53A0
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 15:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355326AbiBNOqA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 09:46:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353435AbiBNOp7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 09:45:59 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2040.outbound.protection.outlook.com [40.107.93.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 285614BFC6;
        Mon, 14 Feb 2022 06:45:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pk1xk5ZSIZhbQ73MnDOBxgs43+xtZwR49JSPtV8NLQADXahj9LfmSZNEEDFDdtKzQm6ycOjPW7PGrGK85Wv3CmlupTMqcMXhM3c+5RDf6fdd/lr+ck+/XCSQNv49w2WbjWxvBR3l+s+Kgl4lbb1FHC9ic0F2J0ThXtUAIfTQJwvqWZWiuEng19/OR8jc6xkg2lFhaqnqLLZ9WEAlUUxSdO4pEV6vG51oHbbFeqnjK7CmYzdSHxRHbmPHW9GZ6yDQpvjK6IlYXO29hCwbleKUvimr0Fq/f6Uo1uzCIxf63hrTff74Btq0wxZlfn92iJm7un0N9OmBeyXNRwqHaqeNgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5YvLm4C9y+H+y0r6WDprxyq97qgCsqEcJn81pqcTF3o=;
 b=lWZ1v9Il/ypk9uaL6iaDxW6dkmCn25H/isNS3E8BNiCIJEsvz2/y/NNiVWeV46P8yYclCEdmJWqCxY9BA11g8W/PnFEyqWAcaagGXlC4VedbM5pc0cHaEjW4qVONF4OrxIJamTKvit0CjWirTeQLFySX36ZqHK0eqs3aC5U38/wMbMZBM/M8HkaENjyZzNmDHk7M4IngALOtcDbGdNKThJXFNBCDffJ8axadNDR2RN9ReNd0sYB8wLz/J5LOHS02MLwrphhaAbdUcZeWED2FrqeECPfaZfbrV+4DslyDG0P/8eD/eDZqbIrFkKlWez2Lzk7Qg3PUkrsN1yTm61LqvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5YvLm4C9y+H+y0r6WDprxyq97qgCsqEcJn81pqcTF3o=;
 b=HgPAGlg/ftvmLexYaaVg3CNPvCO6tu3kvs0zvYVaddtE6gTHjJLIScJaPY+sRRqD77QCk1DWz2eybHpczNw8MG76SbYyOp4Wbiie2BzrmiNigZ7ZJibPGMSxTbxfkytQIP8JgyzvZyFNi3lYnWNczJb/I/GR4XCcsOJoOU0RXcNDpXQx03vJWtrlQ3lsydKyxl7tK90sNABsywwM7Jhfl8OGR4s2kaEY/U1Sb5XntPpHas/xejMhxWdF1RfKwkal6/KRb+uXbtMTj1M4sO5Aytk+K1Nop2BA4WIrxFKqwDYe3kpoxj94yKlrKZd7+gxRHCybgzLC/QSh/P6YpRQYuw==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by CY4PR12MB1848.namprd12.prod.outlook.com (2603:10b6:903:11d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.18; Mon, 14 Feb
 2022 14:45:50 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::8527:54fa:c63d:16b]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::8527:54fa:c63d:16b%5]) with mapi id 15.20.4975.019; Mon, 14 Feb 2022
 14:45:49 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>, Moshe Shemesh <moshe@nvidia.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next v2 0/4] net/mlx5: Introduce devlink param to
 disable SF aux dev probe
Thread-Topic: [PATCH net-next v2 0/4] net/mlx5: Introduce devlink param to
 disable SF aux dev probe
Thread-Index: AQHYHyi7LP1bSM9810iOk5A08UDRx6yPHP2AgAPzdgA=
Date:   Mon, 14 Feb 2022 14:45:48 +0000
Message-ID: <PH0PR12MB548137BB5A70195983DFF74EDC339@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <1644571221-237302-1-git-send-email-moshe@nvidia.com>
 <20220211171251.29c7c241@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220211171251.29c7c241@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0102c106-e547-45ec-89df-08d9efc8b0f5
x-ms-traffictypediagnostic: CY4PR12MB1848:EE_
x-microsoft-antispam-prvs: <CY4PR12MB18482E096347204EA5D94A82DC339@CY4PR12MB1848.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QD+U/vnnJqpmqHRs3MNA7Ftrs2olJqnaKeGih7jNoR5iwWK2mzI2JaDlxyDBlzVjyAHbVJ0rTdITTSH+pvi0Xpc0PGrKLkrP+yA8qDMeblPuF04gNaFz0AQBi2UhASjk40ywXcOMHx6gE2BX3mSR+LcpIVMMlQHrcFx6R3stC8dvV8lC6oVblCCKzNBFZ4DX9ogLVOLHrl/LOJ4aQXY4PcTdrlUJbjG/eeZzAbjyLdOESGIMp/uNmQYEWg7T0hFW4ieQmiwvHYd0CxiovOzoG9eWAFbMTDUm+h7H75/NwNAxgUmVqdRjDccBBZzxsj9h70R/gPDGL3WRf+rzurSlJ0EMkgyTw6dzBI/mnc2TcX0dykF4/vXTlZCb7b+jtG/EPXc99chuwlhv0tbMgXJBi/h+anBhI81GUBpSwzlVDAbg9yAaD/hj93g4uIZiZL7VXL7JmFYzvdpLiSp5N9sZlB1LdpLTLZvUFVmZ8pwhCeeSup29XCBRAO/mZg20ictC9+mnB5USdWUkP7ahivCSM0GUy/Oi6jijd5swckwGIEWKGVasxbSEYlJ7MN0wD/U8ihdvbo7GaFdYrxYlvKg7rdkqC9+pBnug2HCulLoxrfZQyJI+6HYhdO5GhjJTOn6PKEvQi/xr7kHlRZ+pDM9Mn7pPuRu0EnlgJTYylaqYXHLb3Rpmfrxn6NGkOvRp8Isvdzg5cEmSh941dzTUoXNMcw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(76116006)(7696005)(6506007)(9686003)(66476007)(33656002)(71200400001)(64756008)(83380400001)(66446008)(186003)(26005)(52536014)(2906002)(8936002)(5660300002)(66556008)(4326008)(508600001)(66946007)(8676002)(38100700002)(86362001)(6636002)(54906003)(110136005)(55016003)(38070700005)(122000001)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?CzGBHcVODYjxhwlBfHVUE0czb8hYccSU0wOSY3HJ1MxGjFF/Q2XB4ZGI/dKO?=
 =?us-ascii?Q?XlxLl8p1VMZqzyFwW6p2kr6TrvMvbUrVjvdb2DR+SJUXY7wj3VfRUhflLijS?=
 =?us-ascii?Q?L+3izl7UWrCvFhQpv2Xd+Q7NPOlvR8NiEFbDWD2Dl52SMxtyLRueu8PcCUNO?=
 =?us-ascii?Q?a/a+QAnTu7+n+GdJAUOCtCCGdeovOoAOsFf9XAL+yla32oVvph4mMc/PPnWE?=
 =?us-ascii?Q?0PK18DLjU/TGQZbhflPQzYXQAfW9KZ22qfr9Zd+4mG3FcfQWfpa3mfhQCsrS?=
 =?us-ascii?Q?vzLTVOpy6Ud76yPwKgyUUKf28rJzQy+tUII6Q+Yb0NRT+IQUFjOVk1986fcP?=
 =?us-ascii?Q?ewEM4m7rwe1/0lyCAz+RJbk+i3kCEcam+9MXMO20P6s+JLWm/DpdRi980hf/?=
 =?us-ascii?Q?0r5vqKmm03HbtQWzOnLrU7GeUuzEPu0RizcOb5c5ou8VHwaHFR4tRHJ83MET?=
 =?us-ascii?Q?2hQMpBfhpsMxFOAOyWGowNV4xKpSzOXU0GGGqI2M6oVS98YgLZLOAAiVLp0D?=
 =?us-ascii?Q?ExhvXe7ZjBZGlFuvG73/MaPV2YY+yIiQTSsgVo3Bl66Bk6yaRvWZjfWU0adU?=
 =?us-ascii?Q?OxdzGmDA9R54kC+TzIFBq8iSeeh0HepSEICT8sQ1NwYEfwhmThDvksKeeKPT?=
 =?us-ascii?Q?UIizKO4avS8/7Pw+VdfUGSR7dLRlfEKktn/cVDh3XglO8Ltk0EhaiQVFnqh0?=
 =?us-ascii?Q?s+68g8AWM/PSlDH3HiIp4t53X2dXEQld7FPZYj+sR8/QR1/0pzZ1vt4orkZi?=
 =?us-ascii?Q?1UavGbQtrxUPmIUwf2NRh7vbQ9ok3dWC178cmeYLsu61e86NY3MqRTJLNjgr?=
 =?us-ascii?Q?qeiZVMWJ1Mkf8RRlLNlq11O+6AT09/s8rhfyt/A+0m5kZOQI3a0GdeatP4hp?=
 =?us-ascii?Q?LX2oDaL38pEsJCSL46nfAYpHLcZ8QDK3u5ZDhAjs59iBKxLowgGNZYuKl+fN?=
 =?us-ascii?Q?j72fTyMhapZq5mZWn0LyvBCbFtG1pxB48G7a7JmeWWnaTmJ/vWFOL2IuXeYr?=
 =?us-ascii?Q?8vKPJpeGuut+c+5GB3diWabYoQG25EuWFKwRuFV/C0YtMcR4XUgC2iHQhBb1?=
 =?us-ascii?Q?GmfNF0HgPKes3ee5vd6wOzNounZ0iTHDOOAJsoBsLsuy7Q20yZIwH8iwmAS2?=
 =?us-ascii?Q?vO1yMGnaQaSdGJQfw+o9S6vdKmyDCukfn0oWUCBV1rLzJZ10EU9OHPtgbqVE?=
 =?us-ascii?Q?551KRqrSF6hCWtAeF4hiT/M5Q6PbqzuTk7GFkldlH9DFYd6n4lo21spcyIqm?=
 =?us-ascii?Q?w6QRLqPH4RlrjLdbr5Etk5DOUZ2Mguk7TAlC/CQ3Jp64Zb5ILTfjcmERpDkr?=
 =?us-ascii?Q?ifqFvwDyCyRgRpLs5wJdpTKOIv68OOGijziz1vLWfoplmEwOLrdZwhr8KA3F?=
 =?us-ascii?Q?xxhrGiSMK/IHrLD/6Uhz/myDyNTADAsM4ViVRY2irhckhmLBeSE9xovqU9eF?=
 =?us-ascii?Q?5qeIbTB3OARYSolQftHxD1DTA545lfQL/MmPJQQecoEgvXNFlKzDteZm6R/+?=
 =?us-ascii?Q?wchcZqL1TL3jsq6UipOjuO3vooXiLh3MFVdiSlTvaKI/6E/u9jAYD/LovZ98?=
 =?us-ascii?Q?BwPSliONXzfIXtcBIXaUeLEcJESL5crczo1i6ur+pitdtFSn3WDZo6tJ+BXr?=
 =?us-ascii?Q?plc2Lv+dFCHk4AmGz6W2Kmc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0102c106-e547-45ec-89df-08d9efc8b0f5
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2022 14:45:49.0077
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8JG76y8qqxSTJUYKdas97TCXbMvw9E0flbmNfFJ2iLMOwyOIRyaxR/RBt130wlGTLlE+nAMQT+mLyUXkD/eilQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1848
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Saturday, February 12, 2022 6:43 AM
>=20
> On Fri, 11 Feb 2022 11:20:17 +0200 Moshe Shemesh wrote:
> > v1->v2:
> >  - updated example to make clear SF port and SF device creation PFs
> >  - added example when SF port and device creation PFs are on different
> > hosts
>=20
> How does this address my comments?
>
Which one?
Your suggestion in [1] to specify vnet during port function spawning time?
Or=20
Your suggestion in [2] to add "noprobe" option?

> We will not define Linux APIs based on what your firmware can or cannot d=
o
> today.=20
Sure. I just answered and clarified what it is the device capable to do.
We can possibly enhance the fw if it looks correct.

> Otherwise, why the global policy and all the hoops to jump thru?
> User wants a device with a vnet, give them a device with a vnet.
>
User wants a device with specific attributes.
Do you suggest to tunnel those params at port spawning time to share to dif=
ferent host via fw?
Some are HW/FW capabilities, and some are hints.
Some are hints because vnet also uses some eth resources by its very nature=
 of being vnet.

Lets discuss two use cases.
Use case -1:
User wants params of [3] to below value.
eth=3Dfalse, vnet=3Dfalse, rdma=3Dtrue, roce=3Dfalse, io_eq_size=3D4, event=
_eq_size=3D256, max_macs=3D1.

Use case -2:
User wants params of [3] be below value.
eth=3Dtrue, vnet=3Dfalse, rdma=3Dtrue, roce=3Dtrue, rest=3Ddon't care.

Last year, when we added "roce" in [4] on the eswitch side, you commented i=
n [4] to leave the decision on the SF side.
Based on this feedback, you can see growth of such params on the SF side in=
 [5], [6] and reusing existing params in [7].
(instead of doing them on port spawning side)

Port spawning time attributes should cover minimum of below attributes of [=
3].
(a) enable_vnet,eth,roce,rdma,iwarp (b) io_eq_size, (c) event_eq_size (d) m=
ax_macs.

Do you agree if above list is worth addition as port function attributes?
If not, its not addressing the user needs.

Did you get a chance to read my reply in [8]?
In future when user wants to change the cpu affinity of a SF, user needs to=
 perform devlink reload.
And params of [3] + any new devlink params also benefit from single devlink=
 reload?
For example, which and how many cpus to use is something best decided by th=
e depending on the workload and use case.

> You left out from your steps how ESW learns that the device has to be
> spawned.=20
I read above note few times, but didn't understand. Can you please explain?

> Given there's some form of communication between user intent and
> ESW the location of the two is completely irrelevant.
I find it difficult to have all attributes on the port function, specially =
knobs which are very host specific.
Few valid knobs that I see on host side are=20
(a) cpu affinity mask
(b) number of msix vectors to consume within driver internally vs map to us=
er space

At present I see knobs on both sides.
Saeed is offline this week, and I want to gather his feedback as well on pa=
ssing hints from port spawning side to host side.
