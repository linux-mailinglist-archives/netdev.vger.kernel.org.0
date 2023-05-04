Return-Path: <netdev+bounces-456-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C33046F76E4
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 22:22:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0451B1C21465
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 20:22:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58DF1156C7;
	Thu,  4 May 2023 19:59:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 442A5156E7
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 19:59:02 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22799156B7;
	Thu,  4 May 2023 12:58:43 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 344Fs8ZT028937;
	Thu, 4 May 2023 19:02:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=ueZoi9ehFmvemYUDgX5s1v22Xr3vWJWKp945xIE7uQU=;
 b=ez96vgXgDI4QjjiNTLgdiSgp7vmECUNx603/yC4iOvFRSftCCpxnKZZNFujiIkj02syv
 D7xuytobaV5QN5/Qhqkdjw8aYo1manMvzBBLYPhw5HfoICXvApFH+9Xs6YcWDVX0Bp2e
 nk+pp4AwG1GbyuVfLRniYuXswzxq9BguFClBQ198dZVrxzul72js4b6H7c483ajWo9/5
 4yuLsbOZJtL6Vj3PwbG5EpcSocxM4/ULmJPSo8cnkzf8cVTlH6ZyIJ2qF/mNwSSTWVyK
 dlwrTXgfAlswWYluKqrDZYPdSdOG3y1nyyVqW5OkoeFYDlE3sTvm7ARrYvLdpAIzrzk2 Bg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3q8t5ftqqt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 May 2023 19:02:52 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 344HLbpN020760;
	Thu, 4 May 2023 19:02:52 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3q8sp8wbc6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 May 2023 19:02:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IImUM+WYkQCZ0kCZuF5GEXNep0e517uw2tBgclXlv5KVDrsLz5ss1LQOstp5E9HFSt7Bw7sxfIgDejbpwM36nLZvCE1ccUPEblr9rN2JXetb1OjCVSmElxPdwBwdY5XHtkmxyxtrB7lgcKrn6NWDGtcZZ7txvg5jIyqDsvsELSdA3tL09VRU2s+XA/O4JdH8eE+kjPAllGffMFazbyByvAcmC8To2GCYrNiOTIXhmwv3YJvsYQXv8IZR4ozu2LVK8lZtYNtXGDClGpDxw3k/Qq6DeUTwJ2l1WjEWJy+mV0kwRhGE4dP8gwT83BB5gE1DQ0crH6l3vjs8eeV0vxNcSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ueZoi9ehFmvemYUDgX5s1v22Xr3vWJWKp945xIE7uQU=;
 b=OEZ4VOfqJzYnhBwa914CwfHHS4KihD2Pbq++fzgQGnCGYMVocS/FMR595UlYKwwyCwybz4P9CR78bgDkqqxvYJoSrwRr0nKxFOWq67VPe9cVw0ZkjqhYqt8XZIJsOCGvj1wbGTLtv0smz3tsetACIxFLEI+s03QX1H2v8d+Vzz5MPWks5bUG6TShBAJpnDqabjuRdtDKK7e0huA+TmblUrmkpJl/oSRRSe+qQ3cHM+oXIu+WyjmrykTS+rBA2DBvJpija2WEyLqONixryePlPiiaqzKzLwiJp/6ye5M1FCgUj0dNfOtUvgKWnJ7+wXdidR5EwURX5AhxIjXE947LEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ueZoi9ehFmvemYUDgX5s1v22Xr3vWJWKp945xIE7uQU=;
 b=VGkIMGMLTgod5dWrThUn3J7Up13opRKZQ3OGCPwW8jsCk+mU+K31OY5DpfrUP6DLxa/53+dOfhknrbvOJUalvPB9ml/m9iwzK/oqgFeZ2/8uKOikO0mHkedJRhYT6A6YyQGEqGZ6+NyD7P03Mr/W2elkQtK9KF/V5lZKI5215k4=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by CH0PR10MB7500.namprd10.prod.outlook.com (2603:10b6:610:192::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.20; Thu, 4 May
 2023 19:02:48 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db%5]) with mapi id 15.20.6363.026; Thu, 4 May 2023
 19:02:48 +0000
From: Chuck Lever III <chuck.lever@oracle.com>
To: Leon Romanovsky <leon@kernel.org>, Eli Cohen <elic@nvidia.com>
CC: Saeed Mahameed <saeedm@nvidia.com>,
        linux-rdma
	<linux-rdma@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]"
	<netdev@vger.kernel.org>
Subject: Re: system hang on start-up (mlx5?)
Thread-Topic: system hang on start-up (mlx5?)
Thread-Index: AQHZfVsR2ZsLRCph30aJIrQ6PtNPGa9IF9MAgAB9OQCAASStgIAAwYyA
Date: Thu, 4 May 2023 19:02:48 +0000
Message-ID: <46EB453C-3CEB-43E8-BEE5-CD788162A3C9@oracle.com>
References: <A1E5B427-897B-409E-B8E3-E417678E81F6@oracle.com>
 <DM8PR12MB54003FBFCABCCB37EE807B45AB6C9@DM8PR12MB5400.namprd12.prod.outlook.com>
 <91176545-61D2-44BF-B736-513B78728DC7@oracle.com>
 <20230504072953.GP525452@unreal>
In-Reply-To: <20230504072953.GP525452@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|CH0PR10MB7500:EE_
x-ms-office365-filtering-correlation-id: a743684d-d274-4763-5923-08db4cd22717
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 v+KyzzLrGi7Q2pj1qe9Azo/fnl88nonr40pu2rhSQ2niGzbXkiRZv6ViLY5okG8RgYLhHoffEgbDKNkNasuERgGuFMAvnN4ibg9zRvlJR/QzzOzVHkd85Y0oNW9JeZOvuVKO0I3hlX9bn9c0+63IxPk4cDLclD7pYULeRweaz5kajJXC4PoMfg/T0R7UIqnV8DpAkXwWnZkCzp3SKXK95Ac6wceopSbSA/WfPWcwXXJOkKbwCx+u7S0gQ8PgmypYVmgyGQY9CH54ft9eOsKYjXxROnzcbC0y1srYdLf4syq0UPU/GMBP9LDBsD64k9DDRrHHy7wRdSsSZ4oz1OOIcnrdCgXG8z5zT2t6f4ieSvnVB0idovTS1IVfB+dmyXPUCH4N6dAoyY4YOuiNBsjkdU4clVlmQZ2ViQoP4zAr8ubk2RbTt1ikxCZlyyEoHc8r+xX0FwIqATnNWqNtIZYZkX5e71N8r1hZKSk3HTD1972WBLSEmi/7+BjRVXD0D8s3UotTr5xNkh3ymfyiIV0X3bLSY4AHokaDVOAARs1UyLRSRBLpAXsFsKX1SeEGAlSQVZJb3KJUrakaf6PgM0YuBfyYlgdnJHd+4fMaOsbu6ehHC/xzv/uFDZDuqidpSHM0Q7afVY7vfi4JXYnEDrGqow==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(376002)(136003)(396003)(346002)(451199021)(5660300002)(66556008)(86362001)(2616005)(83380400001)(6506007)(186003)(53546011)(26005)(6512007)(38100700002)(6486002)(122000001)(38070700005)(8676002)(45080400002)(8936002)(316002)(41300700001)(54906003)(33656002)(71200400001)(478600001)(110136005)(36756003)(4326008)(91956017)(66946007)(64756008)(76116006)(66446008)(66476007)(2906002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?Of0lwEwjLqhpBzftsKzylQFfbzyQNEuFx5jRsZJMhelch5nf7+zDbrzqvnvx?=
 =?us-ascii?Q?OCz02Mh9NZ23bnXk2qYfwF0uKzK2EC7CipXnc653sxiPMOQoPHq/WZVBlxFW?=
 =?us-ascii?Q?LllaSXfPGu/UP2xNKtxhUVTR+dRstHtlq2e8qKmNI2wmDLcZeSD6n6eiurzE?=
 =?us-ascii?Q?v7E3Yn6O/BZSwfvW+XL7RvRGeIC7JGzT+yZsDaAf438I/58NkBpb9YkF9Ejw?=
 =?us-ascii?Q?uCxpsGOTMAP9Fws323EvJlbiTI7aEfwKPQWs8aPDep9l1x8lgzFlVCjDHhVg?=
 =?us-ascii?Q?0aRI7A7GJ0YjGarE970A9BsgpKF+VOhh1lZkb5pmEbz+rDVlE1KpHPTpqCG0?=
 =?us-ascii?Q?DOiLZ+KrDBmYtB5XvEN4wCyCU2l8TLBITEi7B/Qv+sopQ0GEyAY3xwTU3uIW?=
 =?us-ascii?Q?Ud9nVSURSJh0LNwIc/RgZxsFFxWtKv82hGXVhacm0YvQZMJ7tcx6LKV/1ahB?=
 =?us-ascii?Q?UUXubTxCK/upYs2OKZfI2/CtOTRUSg2CeMs7QzoWPMDOs4Vwv7whIO+g6r3N?=
 =?us-ascii?Q?C4N6xlp8xeCXQc+llOPu8ZR7PQo+5ItdmW2DIkFL7s727RoliBQ81vDUT/fy?=
 =?us-ascii?Q?1i87fwUTOAYcYUzwz2zAFuHXSj2fjPOwZD0SJ9Lt4KNvr/2rANGc0j64S7FM?=
 =?us-ascii?Q?IFhSHmIHS2FKC3bo3m9R0Ot4SvHoix+9/8FeLFqMiCo/EJqRTDo0CepUMr+l?=
 =?us-ascii?Q?YDmUvZg/TXgdJfVg79Hew+2LrkyarY8yYPOavPQKj1kfJLQcP1EtUqLgqOE8?=
 =?us-ascii?Q?2X1TjPxW2xXGov5vXABA71WCXsAPsm0/lv57aDSRDiW2ycq22owP1Z/BKj+4?=
 =?us-ascii?Q?eibC3zwOVeYgY5N2GGB9oatD/2sXeg+9NYeOAA/JtBenJ5pW4NccEDdgIW+h?=
 =?us-ascii?Q?h5OW5rHFekimRtS71FynCmwu8C9qI7lcQaKOAN5uZEDeNMzppo2DImtNoLSH?=
 =?us-ascii?Q?5MxRD6T2j383FHuwcqLCOrjRGPhIMUzRBESwiX9y8G4NcLh17U7XmLcsW3cO?=
 =?us-ascii?Q?CiE7jRwqL06YGWj7fmwrdgjgtNgOLZeL0X8U3sHYqsuT8wqSeae07qCfukTc?=
 =?us-ascii?Q?v1gIO/JDlaz+Nfcswu3TN9O0jgTKcT1mQpPVgMU3FzCuUL2OEZNUzquFcbon?=
 =?us-ascii?Q?sayyMG2PqgHbBrSJLQeQEvoAlukstvrK0qcvfOYQa0mzOwCu80+yWWOelsgS?=
 =?us-ascii?Q?vm7W/jq3kEF7k1+FUYFLN96qOrZIsc0wyD5Xg4qYdwxR67TLfpJ5eaTObvRb?=
 =?us-ascii?Q?z5RDIhlMtJ5w2Ql1tiZMP7o/w+d5hrGq+gUDtVBA5edUBt7t0NCrTIGG8fR7?=
 =?us-ascii?Q?rf9b9Z3p3V/45POVwUQp0zUnhGw33NmNHJjR9hyxr1kN0iKmQ2vduI/mooFg?=
 =?us-ascii?Q?ShVUIVpreeLS7CTN1dCmw1R6IDZK9NKfaRu1LxPekkarmUGBCyF6UAdkwk/E?=
 =?us-ascii?Q?zDOI9C+xMSnN6hzurHHmF9dkLORPOtD4NRCFFYxbpF0FBeMVO6PrD1y9EFmL?=
 =?us-ascii?Q?smOrAKRuzIKP6XOMDco7QAgk3nPKJrqVg9Pnla8k80dxXR96Lasz4QUNdZcP?=
 =?us-ascii?Q?jQLdOoEa+yvhI8j6o5qObG5SyHjRoiEm0ZHn8sXZP7OB5UODtWwKDE/NSIQg?=
 =?us-ascii?Q?Fg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7AC9C73C5D5DD84C90220B82A9BD4A3C@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	Pg+N3zURV1ckPWJ3+kg1F0irDvcmr5dvOz9VLQHoOmXOWuumBIwyUMRYEZat4WFS33jesRYVQbAO0yBHUNYrZijahSQP3RVdHQ7qN3f0nmmn4BcunqRbivW+zOVJ/oowQx4vhAKyLfDUsD4k9MWr32/2z/TNP9lEhn9ZZrHcTuaAQFOMER63lLPnluSTTUsk59ZNCzMMgDPtH2VB+Z/WvMJJ1fhY3kUq7frX0z3IOBWN4P8xe1o5Z9Aick9YsrRNoCJCQdTFuo+pZ2LbwFtHpXYzY7h6e0X2QGSfM43fcxxmUFryTfdeYWv2w0EuCyRiddN4SYwfQ8evYjI6CkLuEBsqpBQjvaBAZpkOL1XyZ/MyOe8mN4tcyGtJn1eSNAz3G6sLebzdRKz61uUrZmsZfWfgk9d+UPovrdyC65BkoO0VOJNZmrVrqakOIebah8eBORncj3wZorYBO1LcAh0gOdbgTaVvzT/l2nCm/ziq3KYsg7itXTr/vlHmbLzbVqMUYX6hXYD5k5vbUbAtI7fZo2tQ+UJbt6iVs38M5inoFh0ePY+MEMEdWM2GFWbPrsYFqIWs+tndER8XjkOkcdG/sOIA8+00UkujA+deO0gMwniedRUicnqXMi/ckK/nRlamWluEb1JnAgOdih08szpToyohfzbRyo30PbMawXDSxT7c3rVLaFZBAP6lChqrtRNq3dYWvFYr+btrzBlO7Gx57J63wzpOPKxBSFJpa4A8/VP9zP5KRxPai6YT5UkB/xOXngzUL26lH4flrxFRee4DQMd3BG+VfXSgBSy28T1MAQuiZp/6WMnw2w4Bfi77RC5A
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a743684d-d274-4763-5923-08db4cd22717
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 May 2023 19:02:48.5344
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FHc8rnzVAkIpCdO+5TDhX7pZ3g+h+9GWDoVsqynH3psSqU0T5QNCcGpBFhM1HiaYrJK+toT73vfZIsgxikmJGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB7500
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-04_13,2023-05-04_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2305040153
X-Proofpoint-GUID: TbA9d85tLhDZ3VgH13l7-FjVkZRUbPRf
X-Proofpoint-ORIG-GUID: TbA9d85tLhDZ3VgH13l7-FjVkZRUbPRf
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> On May 4, 2023, at 3:29 AM, Leon Romanovsky <leon@kernel.org> wrote:
>=20
> On Wed, May 03, 2023 at 02:02:33PM +0000, Chuck Lever III wrote:
>>=20
>>=20
>>> On May 3, 2023, at 2:34 AM, Eli Cohen <elic@nvidia.com> wrote:
>>>=20
>>> Hi Chuck,
>>>=20
>>> Just verifying, could you make sure your server and card firmware are u=
p to date?
>>=20
>> Device firmware updated to 16.35.2000; no change.
>>=20
>> System firmware is dated September 2016. I'll see if I can get
>> something more recent installed.
>=20
> We are trying to reproduce this issue internally.

More information. I captured the serial console during boot.
Here are the last messages:

[    9.837087] mlx5_core 0000:02:00.0: firmware version: 16.35.2000
[    9.843126] mlx5_core 0000:02:00.0: 126.016 Gb/s available PCIe bandwidt=
h (8.0 GT/s PCIe x16 link)
[   10.311515] mlx5_core 0000:02:00.0: Rate limit: 127 rates are supported,=
 range: 0Mbps to 97656Mbps
[   10.321948] mlx5_core 0000:02:00.0: E-Switch: Total vports 2, per vport:=
 max uc(128) max mc(2048)
[   10.344324] mlx5_core 0000:02:00.0: mlx5_pcie_event:301:(pid 88): PCIe s=
lot advertised sufficient power (27W).
[   10.354339] BUG: unable to handle page fault for address: ffffffff8ff0ad=
e0
[   10.361206] #PF: supervisor read access in kernel mode
[   10.366335] #PF: error_code(0x0000) - not-present page
[   10.371467] PGD 81ec39067 P4D 81ec39067 PUD 81ec3a063 PMD 114b07063 PTE =
800ffff7e10f5062
[   10.379544] Oops: 0000 [#1] PREEMPT SMP PTI
[   10.383721] CPU: 0 PID: 117 Comm: kworker/0:6 Not tainted 6.3.0-13028-g7=
222f123c983 #1
[   10.391625] Hardware name: Supermicro X10SRA-F/X10SRA-F, BIOS 2.0b 06/12=
/2017
[   10.398750] Workqueue: events work_for_cpu_fn
[   10.403108] RIP: 0010:__bitmap_or+0x10/0x26
[   10.407286] Code: 85 c0 0f 95 c0 c3 cc cc cc cc 90 90 90 90 90 90 90 90 =
90 90 90 90 90 90 90 90 89 c9 31 c0 48 83 c1 3f 48 c1 e9 06 39 c8 73 11 <4c=
> 8b 04 c6 4c 0b 04 c2 4c 89 04 c7 48 ff c0 eb eb c3 cc cc cc cc
[   10.426024] RSP: 0000:ffffb45a0078f7b0 EFLAGS: 00010097
[   10.431240] RAX: 0000000000000000 RBX: ffffffff8ff0adc0 RCX: 00000000000=
00004
[   10.438365] RDX: ffff9156801967d0 RSI: ffffffff8ff0ade0 RDI: ffff9156801=
967b0
[   10.445489] RBP: ffffb45a0078f7e8 R08: 0000000000000030 R09: 00000000000=
00000
[   10.452613] R10: 0000000000000000 R11: 0000000000000000 R12: 00000000000=
000ec
[   10.459737] R13: ffffffff8ff0ade0 R14: 0000000000000001 R15: 00000000000=
00020
[   10.466862] FS:  0000000000000000(0000) GS:ffff9165bfc00000(0000) knlGS:=
0000000000000000
[   10.474936] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   10.480674] CR2: ffffffff8ff0ade0 CR3: 00000001011ae003 CR4: 00000000003=
706f0
[   10.487800] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[   10.494922] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000000=
00400
[   10.502046] Call Trace:
[   10.504493]  <TASK>
[   10.506589]  ? matrix_alloc_area.constprop.0+0x43/0x9a
[   10.511729]  ? prepare_namespace+0x84/0x174
[   10.515914]  irq_matrix_reserve_managed+0x56/0x10c
[   10.520699]  x86_vector_alloc_irqs+0x1d2/0x31e
[   10.525146]  irq_domain_alloc_irqs_hierarchy+0x39/0x3f
[   10.530284]  irq_domain_alloc_irqs_parent+0x1a/0x2a
[   10.535155]  intel_irq_remapping_alloc+0x59/0x5e9
[   10.539859]  ? kmem_cache_debug_flags+0x11/0x26
[   10.544383]  ? __radix_tree_lookup+0x39/0xb9
[   10.548649]  irq_domain_alloc_irqs_hierarchy+0x39/0x3f
[   10.553779]  irq_domain_alloc_irqs_parent+0x1a/0x2a
[   10.558650]  msi_domain_alloc+0x8c/0x120
[ rqs_hierarchy+0x39/0x3f
[   10.567697]  irq_domain_alloc_irqs_locked+0x11d/0x286
[   10.572741]  __irq_domain_alloc_irqs+0x72/0x93
[   10.577179]  __msi_domain_alloc_irqs+0x193/0x3f1
[   10.581789]  ? __xa_alloc+0xcf/0xe2
[   10.585273]  msi_domain_alloc_irq_at+0xa8/0xfe
[   10.589711]  pci_msix_alloc_irq_at+0x47/0x5c
[   10.593987]  mlx5_irq_alloc+0x99/0x319 [mlx5_core]
[   10.598881]  ? xa_load+0x5e/0x68
[   10.602112]  irq_pool_request_vector+0x60/0x7d [mlx5_core]
[   10.607668]  mlx5_irq_request+0x26/0x98 [mlx5_core]
[   10.612617]  mlx5_irqs_request_vectors+0x52/0x82 [mlx5_core]
[   10.618345]  mlx5_eq_table_create+0x613/0x8d3 [mlx5_core]
[   10.623806]  ? kmalloc_trace+0x46/0x57
[   10.627549]  mlx5_load+0xb1/0x33e [mlx5_core]
[   10.631971]  mlx5_init_one+0x497/0x514 [mlx5_core]
[   10.636824]  probe_one+0x2fa/0x3f6 [mlx5_core]
[   10.641330]  local_pci_probe+0x47/0x8b
[   10.645073]  work_for_cpu_fn+0x1a/0x25
[   10.648817]  process_one_work+0x1e0/0x2e0
[   10.652822]  process_scheduled_works+0x2c/0x37
[   10.657258]  worker_thread+0x1e2/0x25e
[   10.661003]  ? __pfx_worker_thread+0x10/0x10
[   10.665267]  kthread+0x10d/0x115
[   10.668501]  ? __pfx_kthread+0x10/0x10
[   10.672244]  ret_from_fork+0x2c/0x50
[   10.675824]  </TASK>
[   10.678007] Modules linked in: mlx5_core(+) ast drm_kms_helper crct10dif=
_pclmul crc32_pclmul drm_shmem_helper crc32c_intel drm ghash_clmulni_intel =
sha512_ssse3 igb dca i2c_algo_bit mlxfw pci_hyperv_intf pkcs8_key_parser
[   10.697447] CR2: ffffffff8ff0ade0
[   10.700758] ---[ end trace 0000000000000000 ]---
[   10.707706] pstore: backend (erst) writing error (-28)
[   10.712838] RIP: 0010:__bitmap_or+0x10/0x26
[   10.717014] Code: 85 c0 0f 95 c0 c3 cc cc cc cc 90 90 90 90 90 90 90 90 =
90 90 90 90 90 90 90 90 89 c9 31 c0 48 83 c1 3f 48 c1 e9 06 39 c8 73 11 <4c=
> 8b 04 c6 4c 0b 04 c2 4c 89 04 c7 48 ff c0 eb eb c3 cc cc cc cc
[   10.735752] RSP: 0000:ffffb45a0078f7b0 EFLAGS: 00010097
[   10.740969] RAX: 0000000000000000 RBX: ffffffff8ff0adc0 RCX: 00000000000=
00004
[   10.748093] RDX: ffff9156801967d0 RSI: ffffffff8ff0ade0 RDI: ffff9156801=
967b0
[   10.755218] RBP: ffffb45a0078f7e8 R08: 0000000000000030 R09: 00000000000=
00000
[   10.762341] R10: 0000000000000000 R11: 0000000000000000 R12: 00000000000=
000ec
[   10.769467] R13: ffffffff8ff0ade0 R14: 0000000000000001 R15: 00000000000=
00020
[   10.776590] FS:  0000000000000000(0000) GS:ffff9165bfc00000(0000) knlGS:=
0000000000000000
[   10.784666] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   10.790405] CR2: ffffffff8ff0ade0 CR3: 00000001011ae003 CR4: 00000000003=
706f0
[   10.797529] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[   10.804651] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000000=
00400
[   10.811775] note: kworker/0:6[117] exited with irqs disabled
[   10.817444] note: kworker/0:6[117] exited with preempt_count 1

HTH

--
Chuck Lever



