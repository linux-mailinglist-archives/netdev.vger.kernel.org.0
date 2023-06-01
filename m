Return-Path: <netdev+bounces-7169-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 84B9F71EFB6
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 18:53:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0A49D1C20FD7
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 16:53:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A014222605;
	Thu,  1 Jun 2023 16:53:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 930CC13AC3
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 16:53:29 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AC01D1;
	Thu,  1 Jun 2023 09:53:28 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 351E4sY0008548;
	Thu, 1 Jun 2023 16:53:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=rABUAq3L6UGAK442+4flLX2gEFLHtThWhyreRDX0Qs4=;
 b=wkx0mPdFV9pEnC4pKW+xd6zbV2JQmQaF8Hbkkal2CriFA/q9TCZIwj55HfOX9NweH6eZ
 +XlQ7MLnsoi7T9An9OCPXjfhb8GfIH8ZGuQyBq6VWlruaj3GSfBQAc5o0fV8OU9k/GZi
 YQHP/fH8+YmMMTciLpu4dt4vi+ZyuyDwTlgwgCWwYwoCAAUQnebP2ub+VSiI7zyOhOuL
 eCVO2Fl7Wgsqpj99whORjOOCmjLPsgeVRLN4Rm5bxtnZonjKSedrm5m0EvEhefC9A0US
 c3YnsN5UIn3igLlO/Hizd4SbUguPk82ZIsDtk4mjTgL3pTvBfZW7Om0GOUmhBLY3JpF0 Xg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qvhjh995n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 01 Jun 2023 16:53:11 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 351GdoEi026022;
	Thu, 1 Jun 2023 16:53:10 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2042.outbound.protection.outlook.com [104.47.73.42])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qu8ae15jd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 01 Jun 2023 16:53:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oy6DhzTukiarHC0RW45/ipt7WaDE70Koa4vY5Y4j4R0RlQ11K04+vQcUfAtfAsCJmcQdXNFsfEB8IerUHq5MVE2OFgq+lZxsDsOQbwukJWIuDeub5EtOsqg+rnBFllpWaCzEBCKzwzuObxoO5xlIk3AYeqjItN93UV8brKcQacDq4xGMNISyLoVLCZm79R5/9yTAV5QRdPp6WJu+/hF5suLBDjtYeJEx0Ri2ZDSnhNe+2WUmJl+kksOiW5iInu+fsKv2r0uR9o6ObqJXnpOcMF0hmOfd429JJubizs2DS+vf4GcDVq9DtD4j1sohtJqvBMbrTAcGl/EZYzSgt8ukTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rABUAq3L6UGAK442+4flLX2gEFLHtThWhyreRDX0Qs4=;
 b=ZLYoSPMkXt+Ol8T/ViPJez3PPX5F5QnEAEV0oDOp9kh8dDN+a7tIwXmlnaJjgl9/TTwunQr4wezTrt2++wiHp7bi/Wz74Uy9HvFQvMYc99O0UR78wzutoI2Xy93L80jcCSN4KgbuFoPBIjGTs68U1H+zIopz+iS2W+1LJAL/ynhvyEoEeYW3SuTfuKU15U6bOhfP/WbV414ZwdpgJ22jb+LfuNoSfG9Is7xGXI8o17CZ6l4ka2ovz/KvAzpYKnenYinI7w3cHuYaatDN6UrAb3Q+SC8YZz9XIgR58aGvBf9VVsWXKAPwfxzUY1sPV/C+LVEsojRWQAWaK99kDs9adw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rABUAq3L6UGAK442+4flLX2gEFLHtThWhyreRDX0Qs4=;
 b=aTpYo2Y8IJ+ggknkvuJmjYt94b+vO1OzvD7uslmZbY9DkVrM4yf4SoicTzPS6+qOEkIFosotaVCBmcF3xa3fY4I3PN27K2UiiHEozY+ACS0/9+h75iRKzSSRJNR26mJe6OP72NyDjlLygEq2rM/W8w7rK7fG/I7exlyiLvbq21g=
Received: from BY5PR10MB4129.namprd10.prod.outlook.com (2603:10b6:a03:210::21)
 by IA0PR10MB6818.namprd10.prod.outlook.com (2603:10b6:208:439::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.23; Thu, 1 Jun
 2023 16:53:07 +0000
Received: from BY5PR10MB4129.namprd10.prod.outlook.com
 ([fe80::ec9b:ef74:851b:6aa9]) by BY5PR10MB4129.namprd10.prod.outlook.com
 ([fe80::ec9b:ef74:851b:6aa9%5]) with mapi id 15.20.6455.020; Thu, 1 Jun 2023
 16:53:07 +0000
From: Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
To: Jakub Kicinski <kuba@kernel.org>
CC: "davem@davemloft.net" <davem@davemloft.net>,
        Eric Dumazet
	<edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        Evgeniy
 Polyakov <zbr@ioremap.net>,
        Christian Brauner <brauner@kernel.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        "leon@kernel.org"
	<leon@kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "socketcan@hartkopp.net" <socketcan@hartkopp.net>,
        "petrm@nvidia.com"
	<petrm@nvidia.com>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>
Subject: Re: [PATCH v4 5/6] connector/cn_proc: Performance improvements
Thread-Topic: [PATCH v4 5/6] connector/cn_proc: Performance improvements
Thread-Index: AQHZZCxMA20H0kIuSECLZNtWm5vHUK92gweAgAADfoCAAALogIAAAUyA
Date: Thu, 1 Jun 2023 16:53:07 +0000
Message-ID: <FD84A5B5-8C98-4796-8F69-5754C34D2172@oracle.com>
References: <20230331235528.1106675-1-anjali.k.kulkarni@oracle.com>
 <20230331235528.1106675-6-anjali.k.kulkarni@oracle.com>
 <20230601092533.05270ab1@kernel.org>
 <B9B5E492-36A1-4ED5-97ED-1ED048F51FCF@oracle.com>
 <20230601094827.60bd8db1@kernel.org>
In-Reply-To: <20230601094827.60bd8db1@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4129:EE_|IA0PR10MB6818:EE_
x-ms-office365-filtering-correlation-id: 786067d8-8743-44c8-10f7-08db62c0ac93
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 nSzYThzND2SZcf09Dx7C9jwe258z4sJdyG8S6FOCpugK/RvOr30gOlxr4IAZ3Oq58IB5/drHfPBrjGzttm292ksuWy6QhzjXw+yhJ5rypimbluXh1H4+GqFTwWWclpsNjsxs44OkXB93FVUw2rH4SrS6jQNkdVT8BvT3WH107A+j+f1XtwJkzkzYhzNEmLkVlFQlInSZbVs354+DtzMt5Huz4YrwKfLsxTJtHvYDsTuMHyBWJ52VJOWbJ003eJzOmIpwLBeHrn5roLx1KsPMaws3i9zljxXWSArf7dkwyXRbsZbybAjahtza0ImlCImAXMIxyNU3opW9pwtr4yI3UBr9nc+Pp0spwLDWPxIh60ethli39NKZLMBF+96Tsdte5YwG6UB+HuciYIeRbnWX1ikBSTKzxAOAYeRO9LLmsLJ70+rnshIFtm3ELjKUCtGUCLKprtNC6kc4oPEsUhLzObcJyQ4duqVuMePTdZpqlVY9ANmhdf5UnNix775jZbnfzc3UQ3b5d0tlg2X2H7tRsMigFviNfDuvarJwRjorZZ/EVgj/ezBdCYZQ9Fb7V9uFOWQX+y+eh5KpBoZ1ILC4pBXf6qM0ays0Q2NAzwIESbGURg4Ic3ypfSdVUJwHm2+nTK0imGbIN29B731RqXh1bg==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4129.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(39860400002)(366004)(396003)(376002)(451199021)(36756003)(2906002)(86362001)(33656002)(38070700005)(5660300002)(7416002)(83380400001)(6486002)(71200400001)(186003)(6512007)(6506007)(26005)(53546011)(91956017)(478600001)(54906003)(76116006)(66556008)(66476007)(66446008)(64756008)(66946007)(4326008)(122000001)(6916009)(2616005)(41300700001)(316002)(38100700002)(8936002)(8676002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?aVd0qqWucvIDUnxWpp2NG6B60JaT79rGIBfwCqREi63BODmbgDNya70O1Wcb?=
 =?us-ascii?Q?KqzfuFoZYe9JqXUMPsfs+1RUrIbR5QQCE8V1EufzSEZnf9CEE0Is54ORc6Dh?=
 =?us-ascii?Q?fV0Cyuqu6/O3cpXBDc66uh4cylvbNf6ir0KJ4t/P3KRzHawCnLn/85O9MGnY?=
 =?us-ascii?Q?HSozos4Kex9YRWOsbz6xw0S6K3HaCCdtY2E+MoVPDXzaJ5/Xkz61VLDlzXmV?=
 =?us-ascii?Q?KckQHGuwv2EfhOdrNPxLs6vWoRcc9OA9hqqik7hjmT9drZfDb04G+QOXq+YH?=
 =?us-ascii?Q?w+L22d2Wl76aoJWHlAV5PsdcOO/PBVrmBALb4llv3GNQ9wHEUJHbXydQWoVJ?=
 =?us-ascii?Q?ubi6NazKuC5v8UafEl+PxQi9vpZ3ox956BXUmKkF2+l3IvMVYpUoVvSx8Eic?=
 =?us-ascii?Q?cb8WRZqJXePIU0IowyT66FpDokz9gnQq4HMBF6jh8O1Y3wxIJFpGUGnVLFhF?=
 =?us-ascii?Q?KZREsnSQJHuzpiyggJIZR1Ivxd9cDEK/GY0DdYI4RB76GvpdwYGgRiodUrBx?=
 =?us-ascii?Q?e/AWqkrzxOShv2NOVgYDMkJOCpuyUIV9Cbzw/elOos09tm8EWVBLkg9PlKUn?=
 =?us-ascii?Q?du3Ah9bfVQLna7Lmog6fDam/miQIdWKRycra17cufnuRAO70VuOmrnTwoEgz?=
 =?us-ascii?Q?q5JyfRqnYD+fZrsGBg5ympdCEsBl6LdXmVqtjDdcn3LVBzEwPkeijX08OnOq?=
 =?us-ascii?Q?Hul8PKek7i3/cuTyyLk5efnEwEWUMUOJq+SgxDTj/gEWETdQkrkDjH52G3il?=
 =?us-ascii?Q?Y/pFAX/BE6wfcWYjok5sbyy7Vih7t11Fu2MOxVAYXERNH+0r770rxvLlJsqE?=
 =?us-ascii?Q?/FQqdscygUh780Po8HRGzwYxSDCEBDtq5G1weqYtoJnpX+FsTzNP8Dv5yUgP?=
 =?us-ascii?Q?YxPMYMLP41u0wq7q2Xvu0VZrEqVhDiUfwWAU7smN9NvsSq8NO5p+vC9hfXbu?=
 =?us-ascii?Q?Jlq29n1MaQuYf31wC5BfajhhPTpSil2WDBysfGMNnaWeMJ7XutdHBTAr9S1+?=
 =?us-ascii?Q?thdiVG3DRUuKqwYewC9ngcErTwT3rLpGZIsnj+koEoHYRE4ru8mKe5s+ApmP?=
 =?us-ascii?Q?5BWeD0QPUKyyEtcUKvZi3JTwrbvQWAEGxlv94dFWgzpBi20IAXxBXJawYtXM?=
 =?us-ascii?Q?f74tFDzkHH7BGJdy0g8vE+/hGOyE0n+cein/g2jH+qj5iZASCXVHnuWR/zdF?=
 =?us-ascii?Q?XzHpQnmWVrcb60w9mt4XrXVJTWAXKizkWfUBEF4IWddjZTj4M9X7EgAxfNGo?=
 =?us-ascii?Q?5MP4bcz0JQP7E5HiMf18rSE+V7tab/s6yNn2vAc0wmM7YsGxoFT8T1u84DwL?=
 =?us-ascii?Q?bCs2I4RfOMB8s5BRJX5LJPczpRh/K8MrAejlPgyXhbk371ojFZCLrAPg+Dq8?=
 =?us-ascii?Q?5zoZRD9P7b/r8E7DrcyRlABMoUg9tpquMKGyN1kASc54i2F3PBNkYIlPbz7V?=
 =?us-ascii?Q?t8np2RTD8ThPq1HAGvZ37i80yeTCcU4d2AfnVliPGFhJIbUnCtnBotWW1tqY?=
 =?us-ascii?Q?Cxc4+w4yPg1q4EBGfcec9Cqd/dw5k+tt879BLtmpcENrVQnbkDbVDaVlIdkA?=
 =?us-ascii?Q?3+J3DDHS3clz/PJ2ctgoDARvmVdS44L5EBOF429nzOC5/yfK18PK1bTxEIFM?=
 =?us-ascii?Q?/Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7F11A43F1032EE46930BEFB8455F098F@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	=?us-ascii?Q?GOL4MRLzlg7zBBCOJB3m46COyLcDSlGk9fxPls3qYbjj3si+1mTgVas2j8V4?=
 =?us-ascii?Q?nucv7Zlvzls9jo7kSHgJV2pCO9K5BF++0qJvxOixFRrhKDH5+rDAjzK1mdK8?=
 =?us-ascii?Q?VmCzUhA1GeQpCM02eKWmPwLkU0WT2HnWa8YfBN+Ebvk3Vs1bHCcdsxJtSIF8?=
 =?us-ascii?Q?qC1iVU+UtlDPV0/8EwEjx1rFklZdESjGbi8bzHSQM9Z9K8vavxsWzPPHV5rU?=
 =?us-ascii?Q?RNlGFYW1rQu2jYi9GHGvTIXOcoYxk2xfwGMxhFotZbO1Lt8HdFXCC1LZj0Dt?=
 =?us-ascii?Q?pSs5bseOaT2Mylv3cdvD5u3IDuibrMCETtDeplEvewiStdE4+pLZFFgYTJfj?=
 =?us-ascii?Q?Tnyf5zZ04bdUA2MMxpX6yn6u9BReDYOKH0Y8JST9ZtmekHJ34OcrNb9Do0QU?=
 =?us-ascii?Q?LAlFJgtotEskKYuGIRPQ2k5sHEMpOOeSUmrzV2aBlL6bTKG2ijU2f7e0aCbf?=
 =?us-ascii?Q?3c5OONGQ5+FJ59wbn8Pzt24mTSvGsvFeP+NFXdtXjmszT9xZzXIIJlDEFGcU?=
 =?us-ascii?Q?qkZedkQFjTyQrn8ZtyMTDzOnzxtlVC89ESW8mzukILI0XjQnb4+c8aonkZKY?=
 =?us-ascii?Q?xchnbk9It/7MrG3p631Wkf/ni/tjfMoK7wX9+WYr++LpJ0MobxeLezdnySb/?=
 =?us-ascii?Q?tPIXY93GZXrNnjU2tL1GnLQpkPb+xzhnb6RpUSfpMeu8b8CPve7N2r84cYrA?=
 =?us-ascii?Q?gcGBGe4gIJscgx7/NROyk9ElBdsK7TDzOICahqacClPNKnCe0WBB3dR0z6MU?=
 =?us-ascii?Q?XvKYsrcPqTeXy3Z+8pxjCZqwezDSeQwLQa84X1xQHHZP0uqLL52GU5Zo/fI0?=
 =?us-ascii?Q?FWjAniVJViWdaCGwpPTepHbVXpVnzdqBxPu50avR1AITkVpgmOos/H7nZL/v?=
 =?us-ascii?Q?3if8csdYhFnuPD8kC/ymq2WUeBC+A84SQZkZKYDBINmOBC5Ij+1ReRgHdRZb?=
 =?us-ascii?Q?HbilOSHo6mD1tCu6a7FBcdW7oKxQqK4vJjpscuTuJgk2SP9j5XrjdE6wrxMg?=
 =?us-ascii?Q?kSGkVAZdBdaPKU/RYvnD4X72VDRX8jwb7q+MFrL04DdU6IU+FsJFVqcqz7Nw?=
 =?us-ascii?Q?9/dQu6mRNvh6dkNZjGqoEJAuCyTMhg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4129.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 786067d8-8743-44c8-10f7-08db62c0ac93
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jun 2023 16:53:07.1357
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qJj9awBO87t5/kSyphjYlm8GW6NiwEoossVnS3PByCBroldKujMMzw/Os9eeVPyrNG5S8gXrWxZQxgSHKSa7hFsy7foHX/8hy0NK9+0whU0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6818
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-01_08,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 adultscore=0 mlxlogscore=764 bulkscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2306010146
X-Proofpoint-GUID: 74LDKp-bZtm7iiJyPjtRjMoMagSy2mKI
X-Proofpoint-ORIG-GUID: 74LDKp-bZtm7iiJyPjtRjMoMagSy2mKI
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> On Jun 1, 2023, at 9:48 AM, Jakub Kicinski <kuba@kernel.org> wrote:
>=20
> On Thu, 1 Jun 2023 16:38:04 +0000 Anjali Kulkarni wrote:
>>> The #define FILTER and ifdefs around it need to go, this much I can
>>> tell you without understanding what it does :S We have the git history
>>> we don't need to keep dead code around. =20
>>=20
>> The FILTER option is for backwards compatibility for those who may be
>> using the proc connector today - so they do not need to immediately
>> switch to using the new method - the example just shows the old
>> method which does not break or need changes - do you still want me to
>> remove the FILTER?=20
>=20
> Is it possible to recode the sample so the format can be decided based
> on cmd line argument? To be honest samples are kinda dead, it'd be best
> if the code was rewritten to act as a selftest.

Yes, I can recode to use a cmd line argument. Where would a selftest be com=
mitted? This is kind of a self test in the sense that this is working code =
 to test the other kernel code. What else is needed to make it a selftest?

Anjali


