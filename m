Return-Path: <netdev+bounces-171-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 13E986F597E
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 16:02:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5025B1C20F0D
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 14:02:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0C91D535;
	Wed,  3 May 2023 14:02:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF2E321E
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 14:02:47 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4840955B1;
	Wed,  3 May 2023 07:02:45 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3436jvo0031800;
	Wed, 3 May 2023 14:02:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=yTLHZ2RS73dWRr4OwZibO/rWKH/8J4UuczvpTYc6lKo=;
 b=BOjbybwpzz8y7PHaXBBcCqel+PRUDWQ5X//Rz63/Hirh72cazFNMmuafuZ6hZHXzGgJ9
 sOD8/UV9w40jbUdM05T+WKG3tKHRuVe1A2JqLOK6Oq/P1oziqUdPNhbNNivvdkkQmIrJ
 CGr9Jpo2tym8qtvGL0n+IQCViiPUrV7VL7Wz0fq6ucyrLYSuPXoQyW7U1JJi04QQ2UrS
 X5cKcbeT5pTrAGIT73h4nxO6b56aYNqG4H0XcMQszT25NW2Sovnc2OlqC7Xz4Mtv/QCF
 8nrMHvF0SBH1B7hF2LiOMEYoI+yca+QsHuDfgmWPzAxEfmzyTgyuz/oOwem0T05E8EMt qQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3q8u4aqb53-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 May 2023 14:02:37 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 343E1c46024882;
	Wed, 3 May 2023 14:02:36 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3q8sp7d62w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 May 2023 14:02:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M86O1A2biWwfo7iwOKARAK+XY8sxF01Eum5eO7mLeBxuxO4ZolDFODYPPnWrTHkmfxAh1j0b6S8U1yNgzULrZUljZwUU3Cw8OKkncsZ+qxFeOaSEOZt3whf612DXFJZi5OAW3o0PHjk2vQkorGunvbKHySlhvRZEIZzc/PwO/MXMHNSvtd6PPTuaaMN+NQX5q7UsdVFz1vgYGH6831xVgdmRsnlhz48WghezHYFmXzBwQzC4+opeSMxFNz3RRJivaEGMMBpYMOOVKgMlKMahTkxjkNazG2WCutqmTTKF4Uo4pfiOp0/SG6i2tMy08f/vz7j+8NeOW4QdllBWe3e4eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yTLHZ2RS73dWRr4OwZibO/rWKH/8J4UuczvpTYc6lKo=;
 b=no1hxuAAi1RDHAbtseUGsZaLMetTMPxkd6wi508bf/aJ6GfdfQh+3mAPmkTQLAmDgaVb6YHdGaJsHdEzLm7lAozIOoR2LijTzQU/dnCPADsmcJ6cK6iWABqt4+FwGr8RcHq8GXjMTAIHqc0vu95famIvr16Zj+VVFO+0dVNvX9DrQh8jZulZWWilTiQn/supxT351QaWOP2+LO8elJtijtZi3OoJ8SpiIq6h6hjcP0m1IaNH9tVtaGgCLXW1PvMXL+EtNayUtFV7RfFwVRiK02j9NPXxoZfLea1g8slAd3wpUuNDxBazlgAvIF73Vu7T0qXSXmHIjpsFL/c8ZXl3pQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yTLHZ2RS73dWRr4OwZibO/rWKH/8J4UuczvpTYc6lKo=;
 b=LC6h4jN6A69PFmcT/4SgnPPHMkiemwgpZqLQ/c4CKL7zcUKiZnPx07ecB5Na6gKbWoHv4cN5KTCD41fNoCN4VvUaKG3oxxBCUv8epub76POfn5fXSVfAL/Lt2jQabuD20tjViq/5y30KgG6iwnQfvlpR2kxZrARgNtymWhqV9SU=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by BY5PR10MB4353.namprd10.prod.outlook.com (2603:10b6:a03:201::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.22; Wed, 3 May
 2023 14:02:33 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db%5]) with mapi id 15.20.6363.022; Wed, 3 May 2023
 14:02:33 +0000
From: Chuck Lever III <chuck.lever@oracle.com>
To: Eli Cohen <elic@nvidia.com>
CC: Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]"
	<netdev@vger.kernel.org>
Subject: Re: system hang on start-up (mlx5?)
Thread-Topic: system hang on start-up (mlx5?)
Thread-Index: AQHZfVsR2ZsLRCph30aJIrQ6PtNPGa9IF9MAgAB9OQA=
Date: Wed, 3 May 2023 14:02:33 +0000
Message-ID: <91176545-61D2-44BF-B736-513B78728DC7@oracle.com>
References: <A1E5B427-897B-409E-B8E3-E417678E81F6@oracle.com>
 <DM8PR12MB54003FBFCABCCB37EE807B45AB6C9@DM8PR12MB5400.namprd12.prod.outlook.com>
In-Reply-To: 
 <DM8PR12MB54003FBFCABCCB37EE807B45AB6C9@DM8PR12MB5400.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|BY5PR10MB4353:EE_
x-ms-office365-filtering-correlation-id: dc5c9ca5-e96a-4ef3-725d-08db4bdf0abc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 4JKvIf59+l5yvhP8cTJEGyx2kO2P7ti6qU/FQWBLuB5pNDphAsv32ASl4vFErvGiUb4iOFUxC6t63qc1SRZY8C1D9IK2LkZsz8+gZ89tSaA87Nve4BmNR/FwNfkfsTqPyEmVtDeY8Lg2imwdthIHFIRDnmMxBdW20IxprJqvvVWpLV7/sjq9NclWm12TiT4/i3jmPHjpjDGHBwwo/fjNuB2LLNOpw9fu/+qheAINEfCeTU2rU3AfU37ganUzSknbl6lk92ZIurcXPg8P0yhdskRvCgwe3VyuwJujk/wuQF+lpQcTn/hGdso2FQNEimQB8jtGiwrBA/vgQpzRuhko4gNJq9t5Sy0CxIio2KX+Tl+P3A222Ya/asNlCoewxVNJl4QCy1oiGLE5FrE2SEYJYlZ9Gk15StH1ZPqkDib8GBPy6Zg0F1PcMasbjUjdiWsXbwgYQulvb0yiq35kCC10gXxhiyuSlU4uK7f4vz4DhDArCrnGgTLe38Lxgb3ogQYX20w9vHd8oyJ+oE/zgU/7v/HSHnf1MbiUA8ZPZbUkn0nBpOEpe9GFGo09wXvMUpLSeoVW3GiPrVF3mP2TgRM4Ap8ocxPWuCD8B3fz/31gmKFqSel+jWmM8vC1D3coRV40K+7SfM9I31oT1WkpPl6ntQ==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(376002)(39860400002)(366004)(396003)(346002)(451199021)(6486002)(76116006)(66476007)(66446008)(64756008)(6916009)(4326008)(66946007)(66556008)(71200400001)(478600001)(91956017)(316002)(54906003)(33656002)(36756003)(86362001)(83380400001)(53546011)(6506007)(26005)(6512007)(8676002)(8936002)(5660300002)(41300700001)(2906002)(38100700002)(186003)(122000001)(38070700005)(2616005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?TlRhdFBQcTY3cDBGNWk1MzV0dE5abG1aSGV2VDFGRzBIY09nL3NyeG1nWmpS?=
 =?utf-8?B?ZlgyQzZiL3VJd0kxRThKSTFiNzFFN1pvcVJDYlNQTmdlQVlTY3czOXRDcmt5?=
 =?utf-8?B?QUY5NE5rMmxQd2lJVlhDWlhadE5OcEZrQkxtanUyZjllNWU3ZHA5QzN2VVJs?=
 =?utf-8?B?bVA4S202RXV3YndaU25vTjE2S2E0aHd6V3ZsWkRMMzJmdHYyRlVuakZPdG41?=
 =?utf-8?B?b0taWWRTNDYvK2ZITkhzKzN3VXJHN0RqaFFXVUgvbTNSeE1RNGN2UDZMZ0lq?=
 =?utf-8?B?Ny9CNXU2VVlXVTdpblY3bjFiRUFRVG1oTDk1RTZOWnEyTmdJc2F6aXNTZU05?=
 =?utf-8?B?eGhuY1hpNThtVTVpWVhDOXBJd1grcUFjQVVVR0xmRXRrSUFXTitBaldkRTRw?=
 =?utf-8?B?QW8ycENBcVVJSGNuY1hkaEZCTGxDT25pTWtGbXF3endYMzBVY0VFSWNtT1Nx?=
 =?utf-8?B?SUVBaUo1aWZRTWFRaGFnTzRJNnBCdmtzNnJRcnNKWFluUWpyRkFrR3BQSi9x?=
 =?utf-8?B?aUpia2d0dDBPTVZxOU9SMGRjYktkb2Fhc1VISm1KZGJQOG5Ndnl0QXphWXQ1?=
 =?utf-8?B?UVNoamJVZ1dJZnEwSDlweWptK3VoSVN5TWhyMzIwbkxNQnNMUFFoME1jVkp3?=
 =?utf-8?B?d1BMZU5Bd05WNkRGbXVxZTZiNmdLdUdyQm5BalZ5bTlSWWRkNGxLWS9nQ1dJ?=
 =?utf-8?B?ZEUvdE53bFFNOE1iT2JEMFliNjkwY3Y0bUhGeCtZU3dqVE4zaVFnZWFZRXY1?=
 =?utf-8?B?SkFIUXpMUjI5enpKdTVtWUdPczcwc25qTUpzTEFnam15KzBpZVE1TkRuVVQ4?=
 =?utf-8?B?R1kvZi9ieUJER0l2clI1dHQrTXF6bnF0bWd2cXFydnRXbUpoY1RYT0I4Kzlm?=
 =?utf-8?B?VlcrZi82OGVKTjRBNmtFTWRGSDAxbnFrWDIvMjZJQkZCeUNtbU1PcGI4N3FF?=
 =?utf-8?B?dmkyUEUzTDRBNmtCdzQ4Vk5zVnNUUUtYZ0gvQTZjSDQ4OTdCaHVNWmp3S0p5?=
 =?utf-8?B?K0E1SVpGMzgyOEdhemlOdkluSDVnTlNXWWNVa3FWODBob1AyNUt2bW9OemRF?=
 =?utf-8?B?akRKOExNVDNFb0YrMXkzZkdjTmQ2dDFVam9pcEkycVVxSXpGejhoY3NZOTc2?=
 =?utf-8?B?WU05OWxLWGg2dkNYZTVuSC9tbkxYeHFqVjVzcHREc2QwYm1ZeHBtNEpHSUM3?=
 =?utf-8?B?WUlnbHd5d0NiV0dBOHJFeW5qQ2lhallEVnZMVlcwbzA1dFNydzFZT0RVVmxZ?=
 =?utf-8?B?Z29qQThtWTIxNzh2ZE95MW1TbytYYnVqS29IZ3owU0F5TTVEZW0vd3FrQk90?=
 =?utf-8?B?dEh5Q3lPWm5ZZ29qRUdDWGx2YllCL2xSN0c4TXJ5MHhVc0xSK0xjMktEYktT?=
 =?utf-8?B?RlFhU2pVSzBxUzU2NjhEelloK3Rlc3FrbVpIY0xPY3RlV00yaWhkUE9lcmVB?=
 =?utf-8?B?OGl3K0ViYitTY2dIRlYrRk5hZXpVZUVvNmJ5ZUs4N2QvWHkyRVhQTEdhWFVp?=
 =?utf-8?B?T0l0U2NiTERPU24wMkRwMmJ5VzRReGZoMFB6a0p0RlkzVUU5QWIxZjE5UlFC?=
 =?utf-8?B?OVY1aEVFaXZzS1FKZ3B3aThJTytzVlBubUE5QzhyWHI4a2Vab3IvclIwd1hQ?=
 =?utf-8?B?WHRFNUdobG5kbSswVkovSzVTcklNWTlrNWxKUWdFNXMyOHBpZ1NTTTBSZlpD?=
 =?utf-8?B?aXJlVEN4WllIcmd2Q0RSempmSFJOR2hNY0s2b0xQTGdIU25ySFB1R0ZXbmZD?=
 =?utf-8?B?Tm51NWJjc1hNemJlUXlwSUlQVkd2M09qQ2FrU2t0UzBVREhKbmJwc2s3RzRy?=
 =?utf-8?B?Um96azFEQVpPSE1qdVpQUjNEeHp4anBHTkx1ZzBkQUE3OWxGWmVLNW1SRWJ2?=
 =?utf-8?B?Sy9HTnVTUDN4RjBWUGlHN3lDR29zMDZvRUZ6Z29ocHZsT294NTVsb0RQQUd6?=
 =?utf-8?B?WTQxY3BEZDU4b1kxVWRRN055UXBzdk8vcUFmMlBNUDdNNHNxRDk4TGxyeVNy?=
 =?utf-8?B?S0pKY0xrc3ZTRXdGelNRWGhFMEswcEdIYVp0cEpESmZHRnlLc3N4eTZDeVI1?=
 =?utf-8?B?U2RKZGQ0dG1udHl3ZVNxOHYvMzVzUmNTaUFLbkY2Yk5jYUgrTnRJcVBmekx3?=
 =?utf-8?B?aXlaalY4bVREWU1vSkFicndidG5ibnJvUEZJT0gweWo2eG15S1M4UTFHWjBv?=
 =?utf-8?B?dHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3852CF8E67B0FF49A6FAAB323620180B@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	dnlUElrZMVRDCQcvNlMiw9MQBKhXUMB8Q56JiCTemic5/NJSR9mmeXexxNvzr4kyvg/y6PQROSaZZLRZA//cR125wwItTpUz83gRQKLAr6IQ3XUcfZelZltGp7nOB2DCl8Bm/21myz8WjMJsX5ICWupalUaI3MEa6WRcKjieMfUeb9gzcnvwtP/71zU4REDjrCS3c59qbJek3kWASUzDuWBdyA4OHiQ8KfpfOjC6SDH6L5nsW7i5EB4PS7NXu/bvba8PrJPSmr53CkpeoKsnbPqX9KTNOp/yMc9sJ5z4VVXNrhK5U22XhjvzVkioqZdK4xSQ4TTOieAXFhycDR0YktBzPUtCUzkacmPzuS9yGb+1tv9ISwi2obr9lVFWB6SKLJ34WsiH/WKthkVs3fr9vMAeyEd+ggLPuxZbmUb8q1UxpJSDcO/jqaAg1150Dzo9/nWFoPrWRCYUkYgiAtrJVhl1nEb2RyxzKo67vQsjLt7cyn6rguMizsMbXBGg0/tXp1IBVUIhY12d4caC/8VhskEy14484XUvBUfF0PiCXYfnqnaPQ7iejR4nAqYOXqzgk70ZYGLBrrNYWxR59P0rNMhOoT8UjmCukj1Le1cS4OULlqDD0cu2IFvKdPn3gLUNlgkEThZknfZPN4DYUoSLgeR4eQdVY5ve96V7OTUuKDlKYdjcpcXVLVR8jzrQ0wZNR605IT+6TsubA/zwXadpas+w8EV2i+SFWkytN2BHUo2+5sLvuvACRJATzVrc7PxvmA+JVJVsFoNZk3Qogxyk46qAH5GAnhxIBss1froHSBl+50x55n9jxveC6ePdwl35
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc5c9ca5-e96a-4ef3-725d-08db4bdf0abc
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2023 14:02:33.2739
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FMefWORL2u0rTVnr/CEzFQU5rpf0t/ugVKqkN2gZpxk0lnGMYDRWY31/mEsMCUZ7NqD8qnLNUv6+JTMLCUIRHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4353
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-03_09,2023-05-03_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 phishscore=0 adultscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305030118
X-Proofpoint-GUID: mwuEGRZTw-zAGaF-nXCYt9NY7V7qqmZ_
X-Proofpoint-ORIG-GUID: mwuEGRZTw-zAGaF-nXCYt9NY7V7qqmZ_
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

DQoNCj4gT24gTWF5IDMsIDIwMjMsIGF0IDI6MzQgQU0sIEVsaSBDb2hlbiA8ZWxpY0BudmlkaWEu
Y29tPiB3cm90ZToNCj4gDQo+IEhpIENodWNrLA0KPiANCj4gSnVzdCB2ZXJpZnlpbmcsIGNvdWxk
IHlvdSBtYWtlIHN1cmUgeW91ciBzZXJ2ZXIgYW5kIGNhcmQgZmlybXdhcmUgYXJlIHVwIHRvIGRh
dGU/DQoNCkRldmljZSBmaXJtd2FyZSB1cGRhdGVkIHRvIDE2LjM1LjIwMDA7IG5vIGNoYW5nZS4N
Cg0KU3lzdGVtIGZpcm13YXJlIGlzIGRhdGVkIFNlcHRlbWJlciAyMDE2LiBJJ2xsIHNlZSBpZiBJ
IGNhbiBnZXQNCnNvbWV0aGluZyBtb3JlIHJlY2VudCBpbnN0YWxsZWQuDQoNCg0KPiBXaWxsIHRy
eSB0byBzZWUgaWYgSSBjYW4gcmVwcm9kdWNlIHRoaXMgaGVyZS4NCj4gDQo+PiAtLS0tLU9yaWdp
bmFsIE1lc3NhZ2UtLS0tLQ0KPj4gRnJvbTogQ2h1Y2sgTGV2ZXIgSUlJIDxjaHVjay5sZXZlckBv
cmFjbGUuY29tPg0KPj4gU2VudDogV2VkbmVzZGF5LCAzIE1heSAyMDIzIDQ6MDMNCj4+IFRvOiBF
bGkgQ29oZW4gPGVsaWNAbnZpZGlhLmNvbT4NCj4+IENjOiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRt
QG52aWRpYS5jb20+OyBMZW9uIFJvbWFub3Zza3kNCj4+IDxsZW9uQGtlcm5lbC5vcmc+OyBsaW51
eC1yZG1hIDxsaW51eC1yZG1hQHZnZXIua2VybmVsLm9yZz47IG9wZW4NCj4+IGxpc3Q6TkVUV09S
S0lORyBbR0VORVJBTF0gPG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc+DQo+PiBTdWJqZWN0OiBzeXN0
ZW0gaGFuZyBvbiBzdGFydC11cCAobWx4NT8pDQo+PiANCj4+IEhpLQ0KPj4gDQo+PiBJIGhhdmUg
YSBTdXBlcm1pY3JvIFgxMFNSQS1GL1gxMFNSQS1GIHdpdGggYSBDb25uZWN0WMKuLTUgRU4gbmV0
d29yaw0KPj4gaW50ZXJmYWNlIGNhcmQsIDEwMEdiRSBzaW5nbGUtcG9ydCBRU0ZQMjgsIFBDSWUz
LjAgeDE2LCB0YWxsIGJyYWNrZXQ7DQo+PiBNQ1g1MTVBLUNDQVQNCj4+IA0KPj4gV2hlbiBib290
aW5nIGEgdjYuMysga2VybmVsLCB0aGUgYm9vdCBwcm9jZXNzIHN0b3BzIGNvbGQgYWZ0ZXIgYQ0K
Pj4gZmV3IHNlY29uZHMuIFRoZSBsYXN0IG1lc3NhZ2Ugb24gdGhlIGNvbnNvbGUgaXMgdGhlIE1M
WDUgZHJpdmVyDQo+PiBub3RlIGFib3V0ICJQQ0llIHNsb3QgYWR2ZXJ0aXNlZCBzdWZmaWNpZW50
IHBvd2VyICgyN1cpIi4NCj4+IA0KPj4gYmlzZWN0IHJlcG9ydHMgdGhhdCBiYmFjNzBjNzQxODMg
KCJuZXQvbWx4NTogVXNlIG5ld2VyIGFmZmluaXR5DQo+PiBkZXNjcmlwdG9yIikgaXMgdGhlIGZp
cnN0IGJhZCBjb21taXQuDQo+PiANCj4+IEkndmUgdHJvbGxlZCBsb3JlIGEgY291cGxlIG9mIHRp
bWVzIGFuZCBoYXZlbid0IGZvdW5kIGFueSBkaXNjdXNzaW9uDQo+PiBvZiB0aGlzIGlzc3VlLg0K
Pj4gDQo+PiANCj4+IC0tDQo+PiBDaHVjayBMZXZlcg0KPj4gDQo+IA0KDQotLQ0KQ2h1Y2sgTGV2
ZXINCg0KDQo=

