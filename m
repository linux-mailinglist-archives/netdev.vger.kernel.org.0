Return-Path: <netdev+bounces-8450-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E4580724206
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 14:25:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BC6841C20F85
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 12:25:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96DCD2A9C3;
	Tue,  6 Jun 2023 12:25:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8318B15ACE
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 12:25:16 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2072.outbound.protection.outlook.com [40.107.244.72])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A26D010CB
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 05:25:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ApBpn7XPib5EKFyJazBerLTLGQ0akBpUMQKXfJ93dQZmAUqow7dRoZEpqSVj1z0KRMeEmDPvo2HA4HoGj/F4jRmd/VnNGV7U7EZxS23kOg6+JelT3Z9/Wsh663WRbVwug1GXhkIMWXH8+DX3XrK7TuxxXEr9IjwcrZgDHD+Z7NpQTknrGzSqS6d0a0wtd6s/bbG45j7DqnEbS/txhdEiE/1fuUKlSBJSAzGRA/q5UNktyiPOWZU8b1lxZTEbsFwP4wOcqyxyXXdRD8iDFCCalpOE8pOnp5eBcB57pWNNVmft/cbVACeaOhOg4YXMbbdAniSAMQYRvALx4UQ4Hnfpwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2otjDRg8ApEomEFod/FffrPSOYozhjMLMapRvM0zQl4=;
 b=QuBqJp/pDFKoSD+7xzGgsjriyp89e0iPsSSZ4fLICnR0Oxngq37OoqDoPttI/HD71MuKAmpyvZ/+kT7vxsnOuTD/awgelh/VHZqy00Z+5Bf6tvv/n7gvBNL6FjhwE5aG72hyRWDX3CkxlGpTFVJWxiqsl6VkhdAEuP3x1LhnDCf1lnIII0ky8XlKvN2hBeJCRYsDAvFwcyrl7USnmiZy3WNtaX0sfOxnPIii0/NnlISXTF/bD+Q2TG5p/QcrlH49Zt0xjq6wgd7DmuspXgYQC2NZoK48SpuBzOmIq1K9hJCbpLe/HXma9R2QjfCGEdtqcVORmZ0gbbx4l1BdVvA0PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2otjDRg8ApEomEFod/FffrPSOYozhjMLMapRvM0zQl4=;
 b=T/SLU6U9iTAup5fOUSZTKvDUnUrm7aoe/uaMV0NQKQ04S/xmp5+8y9IX5OhdzzV8rcixU7Cfi95oo2bmPqIKD1sGeXpEu0LhgerDqzl9M1oG5Vma3E/8biI9WrinvluAj22WRhlibz7gKrrRjUhAyrNOZtgXVmLHQb+KMkebDFrlSk4y2iGyvKGDQ6z0SOa3bmvyzHauLatJ7AsjEeFb79HhuHqBa1//BoYFB6h7mjaXJt7/cDy7hY7eToX/2rUvharo4Xkru/oUmDLwIqu0LpM9VwL2IYfLXLnP+/wSP/aBKwAK9mQ/TpIlDs9sRtzxtvKuH5omN470bwZfozhuHg==
Received: from CH2PR12MB3895.namprd12.prod.outlook.com (2603:10b6:610:2a::13)
 by BY5PR12MB4212.namprd12.prod.outlook.com (2603:10b6:a03:202::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Tue, 6 Jun
 2023 12:25:11 +0000
Received: from CH2PR12MB3895.namprd12.prod.outlook.com
 ([fe80::fb8a:a6f5:8554:292e]) by CH2PR12MB3895.namprd12.prod.outlook.com
 ([fe80::fb8a:a6f5:8554:292e%6]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 12:25:10 +0000
From: Asmaa Mnebhi <asmaa@nvidia.com>
To: Jakub Kicinski <kuba@kernel.org>
CC: "davem@davemloft.net" <davem@davemloft.net>, "edumazet@google.com"
	<edumazet@google.com>, "pabeni@redhat.com" <pabeni@redhat.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>, "cai.huoqing@linux.dev"
	<cai.huoqing@linux.dev>, "brgl@bgdev.pl" <brgl@bgdev.pl>,
	"chenhao288@hisilicon.com" <chenhao288@hisilicon.com>,
	"huangguangbin2@huawei.com" <huangguangbin2@huawei.com>, David Thompson
	<davthompson@nvidia.com>
Subject: RE: [PATCH net-next v1 1/1] mlxbf_gige: Fix kernel panic at shutdown
Thread-Topic: [PATCH net-next v1 1/1] mlxbf_gige: Fix kernel panic at shutdown
Thread-Index: AQHZlX+JJDuaDuAbbk6lZFqBQ/F84K983COAgADciMA=
Date: Tue, 6 Jun 2023 12:25:10 +0000
Message-ID:
 <CH2PR12MB389532AD669A33C7CF0904EDD752A@CH2PR12MB3895.namprd12.prod.outlook.com>
References: <20230602182443.25514-1-asmaa@nvidia.com>
 <20230605161507.654a3c1b@kernel.org>
In-Reply-To: <20230605161507.654a3c1b@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH2PR12MB3895:EE_|BY5PR12MB4212:EE_
x-ms-office365-filtering-correlation-id: 212034bb-5adc-49b6-1388-08db6689125b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 ZFvN2Tv2C/S/bu2UGWbC2E4PMQllr058cZa9OxcuguNax7+BFOECj5x+fOoMbBTZSDDoGd0OqrtePBcNkXVprztsThMwaFF+kX71gSzqZx+SORquJoFf6rZFa7JN1IO33dhqgNDfTczMiy1l2WbcsM3no2s5+IwyYr+PYFRNgULhXENDuILkLngoZw78xhcn+3bxin0dVl2lKdouaHc5wkCiUuUpVfvk0v5JQATFUSr+i7wx60EZzLp904S0b1Ll6Uxg76ldnAYVSXMkvndnKrrIW5sr1cWnk2aLnXgCRFlZDzH9PNxtYi/9j6HlULwFKNsujP2e+sLieCWixYDop4f/lcpLeUq4WoYFjJCIS3yQ3gwkxSF7tk2tJ5wNO8FWOmnJNKcH/p+maO4HUeoKBd05Bi+WaTEUqwYOUSw+wTDeN//aDvzQVWmfuiM5SNS40i9iv0mF7BosHC6s2ZXq57Da+DTOhqeqV7xTkNBTfg9ZGFV506q8k8ows0ffN7A0thnecpqBp0IrZgmubMgc5efzv3g8Pd/zy7ptpUR5BtyQNG7Vk8Ef9Hln1Us0vfeXcRgpI0i96iIoRIRe1wyENGSX2EuDLievZiGsuQAT0+DTzYsT4OsrIa8dR2a/64uqnGWh9cP4fgr6VrVwmrnQsQ==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB3895.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(346002)(376002)(39860400002)(366004)(451199021)(83380400001)(966005)(478600001)(54906003)(33656002)(55016003)(8676002)(8936002)(66446008)(38070700005)(41300700001)(316002)(122000001)(76116006)(52536014)(66556008)(66946007)(66476007)(6916009)(5660300002)(38100700002)(64756008)(4326008)(86362001)(71200400001)(2906002)(4744005)(7696005)(26005)(6506007)(9686003)(107886003)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?Ksp6VFxVZy7w31beA4HrkhW9G2yWuwW9Zo15ntx2K9MPkV/b8XJ9vN58bKmP?=
 =?us-ascii?Q?epNS/84INFQs14LPbdNgsk5XWYnBVOUBdpgwmwAlKGhyx2X4d5YEPnCkHbz+?=
 =?us-ascii?Q?UBLzPHinhfFJkoPQJqmuZ//+C/xhs7cyux+vQUTgZk/NaUfN467MjjMxae5z?=
 =?us-ascii?Q?FS43tBpffMZDRpmfzxdXXOppguutKgSA2TSc5cU/86nPoqTQT33QsrogacMr?=
 =?us-ascii?Q?hNbacW6og2hshNATtnTOy74hupSzhpos4mx6BU4ukrChvOrc4z1TBxve/tUx?=
 =?us-ascii?Q?y99Y+OChblJzQ/FAGjMo1rSbryd7G5uDkTMnRuGZG9NLo/wFh404YrbykGC5?=
 =?us-ascii?Q?0EXr+UaqN6+71Z07OU1rAOKXRIUPhnZDYVDYtXSiti3yYMj3T4lXd5caxv0v?=
 =?us-ascii?Q?MFVDuxYmytomQoc7I2WXhFJfZRY0aNokeSHcYXRr9VQWp8x6/BhPpklGDwAY?=
 =?us-ascii?Q?rwkUgtTJBAcAaRQm/5JuRjjEGp+GkrQbAb49AKji169hPECiI+KoVTpivEe/?=
 =?us-ascii?Q?jGAtrIekRBIL3G33rFBDdUd4wNlhufZe+314th/eo8C+74pq2nDBP1oZIl33?=
 =?us-ascii?Q?YnRc5OLiwfewljAs5sYnWsjUzhBHr+GNsDQOPcJyKC40XTyoxqut0Y5FInVu?=
 =?us-ascii?Q?r8JjmJaXTrPcAsjlg5RzeZmFkKDxseD2O/JlI1NzlbdYtHjv//NOJBx3G7oz?=
 =?us-ascii?Q?vxjllXs1PH5bXLDPQKmh2xkYTi6CH3nd3Fhud7vCr7qPBs68CXJkjqDpT4kF?=
 =?us-ascii?Q?/wyJAk4f5AfBL3CZ632Ym4GAhZ3mIv1yEhiVVtm+Qzh/yeZiOWc3ZQIdHDoT?=
 =?us-ascii?Q?y3cBUcSBDxLsCJUdwDrM0TrTQAif4rRUiY0GMoheV1Td+hcv8hMmcQVJyEsL?=
 =?us-ascii?Q?R5J6SD38uxcgh/40oqMTTNxpobQH3zF61l6HHDOhMBZuD1EFUzG06JOMg3x7?=
 =?us-ascii?Q?uzIEOlxqeJRihC6kIZbtLU3q1xNP1WxEuifTyHdPZWecfLMmNFKPzOI5MUPN?=
 =?us-ascii?Q?aEDaG0KlHHN+ZFwQ11RQppfyLDuwPZspVnb2PaZcYS9MWMRY1cZAVRDixyKO?=
 =?us-ascii?Q?JMBSRt1SysdB0ThUUaqNlacIHki5Jlb6y8c4jXROY7PYfmDIOBgh3mjsUuu6?=
 =?us-ascii?Q?2Z1BfITnJ8NWNFKITIBxt8xMrcT7tiM0Bx1CS4yuDi7KEseDl43NV4JVJP9N?=
 =?us-ascii?Q?vqrvNOWClA6Pp9Cy/qMWZ/BcnkU+t6WVkj5UMfe8BubniomgaN+3uAaduYWb?=
 =?us-ascii?Q?UD/iNFPwpw9n8HzRH/mwg/OIVkVMoOjBKfxeTV9Vm1LXPBwzCDFyO1RZMTCp?=
 =?us-ascii?Q?4ADSmWA/oXE/xvM4SpOzFB9u6nFL5eoVUQiaLd8COH+23TOVyFpxtgB1Ui9/?=
 =?us-ascii?Q?06p+PJVgs/0BuIlGF7bWajYSXaQ9ixrNVW1YV3Uw52/xFqtghk8FIF+Q5Jcc?=
 =?us-ascii?Q?G7YSi7N9VBoqsK/iHIRaiBXqNt9FhdPxB7F1yyYEKxxImNpAFpTMveucfCJJ?=
 =?us-ascii?Q?/Ny+YLuLIOQ9x7llSmNtRV+9p5MnTgUJEt7KUjdhY208/VrvbSbq5CXFEpwy?=
 =?us-ascii?Q?Kj3n30d+HUWFD9o+6mo=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB3895.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 212034bb-5adc-49b6-1388-08db6689125b
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2023 12:25:10.7537
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q6a2r8KIHxREN9qLVxBYcMaqXVskrtEXizqVWCE0Di7VWYsu+1Lhz18m3H81LGKTHPHwoJMSNtUAXtH4y6nL3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4212
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Jakub ,=20

Yes indeed. Thank you!

Best,
Asmaa
>=20
> Judging by the Fixes tag the problem can happen on 6.4-rc5 already, right=
? So
> the tree in the [PATCH ] tag should have been net rather than net-next?
>=20
> https://www.kernel.org/doc/html/next/process/maintainer-netdev.html#git-
> trees-and-patch-flow
>=20
> No need to repost confirmation is enough.

