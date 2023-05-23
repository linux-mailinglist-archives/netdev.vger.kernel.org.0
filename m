Return-Path: <netdev+bounces-4795-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EC2E970E536
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 21:18:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8388F1C20BBF
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 19:18:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 627EB21CDB;
	Tue, 23 May 2023 19:18:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41F3B1F934
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 19:18:35 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77F05121;
	Tue, 23 May 2023 12:18:33 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34NJEEbW022098;
	Tue, 23 May 2023 19:18:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=mGsp65ITCKJj/Z4k/M55t3ffxWK0hQ5EjIa+rink9c4=;
 b=RMWj8EqfaqrfedHbFgg6SzlW9uO/2zaD22Vwk66Ucg4VA6cWX3XbqsO/Kih5P2IE7D2G
 j+NWq3oyfkH+xiBioKMrycwzzoosIoEJbf3q1wZ+92Lpj7ou0KLVcLwWcaeBwSekrAKc
 tVXvWusKo3OZREa0v9tlr485gqy2Lc65rQvbNdYD07ch/h6n7AvLh5X+zU7GKpPFkkf3
 Vfg6f4O4foBginwnThNgi/3OQZRTY6hTDaoEoc6PWZPuaA4Fu/0EQ72k0Zl1+d9qSXd0
 /2rOQvnXC0VqJcR5j3XKOOTdHRhJVPCoLLCmNWzFzyPC8AApuNayM9KlHMSob2WVFRWN Zg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qpp8ce3g9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 May 2023 19:18:22 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34NJ7Upt028665;
	Tue, 23 May 2023 19:18:21 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qqk2rgtny-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 May 2023 19:18:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hPV2hZJiLaFM+cu2eyFUgGm1gApUSvDofIR8RRej0eoD7KdgbTnEpzWUXMfGKYHaM1O9iwbiihDd8Mls/aMp6fPDs+eNxSGSx3NtV0gZpFGBD3Rg6QEAIVs/5wNQhdBTi5aEA0PSpcSbX70KCcVmDckO+KGFyO7ukYx/uYv2K3ROrcCqweeirOhPNw9o/81Racwp70lXNjnNqbUghyy9k6q8WanldqmJmGQ/tMA3iLwcJ8yFNnh9v/zwAp/hPBIUldJHjrBXSMSUzUY9+5gRN0E0l0LJvIL7+jnuY+S16+78Kxs3av6rvy3iHOug2b6E6pWRrOG3rV5RL0oF7UQHtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mGsp65ITCKJj/Z4k/M55t3ffxWK0hQ5EjIa+rink9c4=;
 b=BZzMfuqYN6LmXGHQYiHgC1BHINEv8PFDdi0Af6fZTXam+/qLIv8j3MIGOcOEH79lE9b0IGnZTH90O/uc3mAaJRHvxc6m2QIifS8nXArycuUQAcY5wY44RuIzweqjiLlUvlUyIGc5k37yYDQQVLGqhXoOElIven6VqddX8RvEoveKnWgEVnHilywKV+9R5iiTXKv4SlpgoUqtHJiv4Cog8rX+klMMe8pmYCBuoKUnDuCC1azREM6s09otcbWzLGi19nDzc7cmSFtypVXZwmkZeFhrbfmJ4uh70E6rEbMBpIzS0p7/wkCzDFke/aW+27Hz5+su9wtuP7SzsM6irqr+Sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mGsp65ITCKJj/Z4k/M55t3ffxWK0hQ5EjIa+rink9c4=;
 b=NyJLrftmHP3hDAT5n9bQL4vt+BLfgrMxx5ShLhIJ63Ka31UvdmZfVIdkQGOBBlqwxgO7nkDriBN/MRSfTCPWP+jFAgQSZYp1kt55zCy2zan4bxpd6v6UD2CfOOIlE4fWTDsIg0eswm/OxJ0f3VUnWwkaOl+72Rcb2RdmACHSNAA=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by DM4PR10MB6039.namprd10.prod.outlook.com (2603:10b6:8:b7::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6411.27; Tue, 23 May 2023 19:18:19 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db%5]) with mapi id 15.20.6411.029; Tue, 23 May 2023
 19:18:18 +0000
From: Chuck Lever III <chuck.lever@oracle.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
CC: Chuck Lever <cel@kernel.org>, Netdev <netdev@vger.kernel.org>,
        linux-rdma
	<linux-rdma@vger.kernel.org>,
        Bernard Metzler <BMT@zurich.ibm.com>, Tom
 Talpey <tom@talpey.com>
Subject: Re: [PATCH RFC 3/3] RDMA/siw: Require non-zero 6-byte MACs for soft
 iWARP
Thread-Topic: [PATCH RFC 3/3] RDMA/siw: Require non-zero 6-byte MACs for soft
 iWARP
Thread-Index: AQHZf2hilDPMQchDT02kRjpEKJKB+69MGTWAgBw+lwA=
Date: Tue, 23 May 2023 19:18:18 +0000
Message-ID: <7825F977-3F62-4AFC-92F2-233C5EAE01D3@oracle.com>
References: 
 <168330051600.5953.11366152375575299483.stgit@oracle-102.nfsv4bat.org>
 <168330138101.5953.12575990094340826016.stgit@oracle-102.nfsv4bat.org>
 <ZFVf+wzF6Px8nlVR@ziepe.ca>
In-Reply-To: <ZFVf+wzF6Px8nlVR@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|DM4PR10MB6039:EE_
x-ms-office365-filtering-correlation-id: 6262bc6a-c202-4f55-e003-08db5bc27761
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 mkLmR02Mwh6I4XTK6cxIOiK8o/cF0uTF5Vy1tyETLAWJ5l6+W4RpT9qdNhchS8ousGwS5Gg6x+gO/vISTn/HUqFoE7RrYk6JpNcgGRIjJ4h8g6hA3okQPbL8Is8vGgSyuxgQer9MoVJE8rJPHR74AZ9OD1CzAk5djWpRP3Ktd5Zorz4nOt5zxMeHzm+ADgtGVuw6JkeGdhZ5nEgT7IiPQDsVcI5l424R/XuYqAAS9p6BA6fZg+OtYa3Mnk1PNH0gzXNCZIoCYpiJgduKTdYyqww0jrVgTaKtyxaWBvVTilS9Q8JIzKLowC6oDfwQDNqJrh2mA5HzvBLjtp6lwrU5kUBtotj5q3dSO1p016lYIQG/A03/MkchToz6TjPLMQyNyJoycMm5ak0of1GyN243aqqDCphbKYfqaXC74G5TeIjPjkPlsqUxfUYHsBOadBuWzc3MKvOIZmEqLTbWXAvLyMxsCfUMZqCghTXPRTFQgxhN4vmfGYOO8C35pHxjOVorcbu9AHX+9IFeg02wz/OFNhjtIpOkQ2kgbWkTx7aF9St9xQXwM9PeaPIoXs0hwMcD9jZEHT58otGwYfDKpJa37o8DABejRPZZMV6g9r3E4aRFhBzKatBRRQ4TUbKXnvL0m1V+zf025mAdy0mvR+HPSQ==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(376002)(39860400002)(346002)(136003)(451199021)(478600001)(66446008)(66946007)(66556008)(66476007)(64756008)(76116006)(4326008)(6916009)(91956017)(6486002)(41300700001)(316002)(54906003)(71200400001)(5660300002)(8676002)(8936002)(38070700005)(86362001)(38100700002)(122000001)(6512007)(6506007)(33656002)(26005)(186003)(53546011)(2906002)(2616005)(36756003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?PAbDQr4g1UQBOpqJEnhuPrrfmhtMF4Piji/DnoInUAWaN+/gybcYK32OsvqR?=
 =?us-ascii?Q?avZRuQaVVvXIAojH4Nd3mjnqTaBXF7yPoqBt2zu3tVjxTHcYRwHl9+Pp/On0?=
 =?us-ascii?Q?7tpn3pPfeqpEMz0YrNQeLZLDYMIEixFIeQslupolqgkhouuUurj6EQEQbhJt?=
 =?us-ascii?Q?TBsVJ6jful9NS1ACk3x17HhQu/pusV4IcH8/rmMsAJpJNLkvBbb4UrPh6c3L?=
 =?us-ascii?Q?XO1DmugSAo+zwrb6e6x9SC/D/83a+szwkEKrDF34LymYW/PnWxAzSYWFMS9x?=
 =?us-ascii?Q?XjGHOZIOdhpr8iDSo5o0q3UV0cf8whtOBIT9IppAzEzeaxopEge1fcfHzA49?=
 =?us-ascii?Q?fhfYrbzKWkuXdifGU1KXNPwvDMLVamle1SBckshH7vvaMxIJrOXCbf6Et5y4?=
 =?us-ascii?Q?/4rVLTpNnCc3szlJe72UFhiNFK8phLiVz2TCJ9sTBjbbhwTlgdWxGJePK55G?=
 =?us-ascii?Q?JAcgSWTi5tqrWBohXuDGfCJA8PLER3FAzFkQ/b/mCjX+6s07umFkqIjdCA91?=
 =?us-ascii?Q?MF7NQyuBenkJURyB2p0bc53HW6Ye86iFkKteZmcqRHbt/gRRBCKdJcl8l780?=
 =?us-ascii?Q?RtTr0nT/GASGtAHlS9mONvRuIdyofUY+wl5pUHHtj3xoZPO8jccfn+AqoGrB?=
 =?us-ascii?Q?g0D9eggpDB0u7sBBHSvds9uvAHOzbm20kg259mW10ieW1e8GrXcz42xWN50v?=
 =?us-ascii?Q?mvJWBN4wUcsxFnuGveIUN/1g8NHzqwKYsgRVroYSJvsBqmHosf+vG74alR6B?=
 =?us-ascii?Q?zbJO2bpWDiQYLj3clWamVDes+uBhgNNgjpXeS7minqQV2p13S7llNlxjvHdd?=
 =?us-ascii?Q?MCG3Xj/jSOtfRLPIV84BryJmdYmuu7HROrXE4FkwsH1mV5EeGDKu4lLtvgYh?=
 =?us-ascii?Q?coAqr3M780h0+amcWNxRQkcD4bj4r2SyJ9e0Sb0Az4bSqPWICFbgBrVSXqBd?=
 =?us-ascii?Q?CeeQq/ImX98yrITkBAwfEdEEPHY//Sa4JOSb98SX1SOsMYcSCuPE3T/kyERF?=
 =?us-ascii?Q?E4JpeifzirgvFwl55N8UD5a1tsnsE3J3+0qUucVn2PtCxEftyRPQaUSXwJIo?=
 =?us-ascii?Q?lojYll9tX/jV+hBlPdoluXZ9yfIHafthDdrNZlVtPmObAWfdtt2iIPEDuXba?=
 =?us-ascii?Q?AC2dKwd+rGcCDR/DkGrosjPwq3iWE53qsmZhyyW8XNlq+FRFuncEkQRTD2k0?=
 =?us-ascii?Q?KRPYB+HAf+rFdJpAXQNv5IK68pm5jGbLlc9JN8b9UhtP9/F+UQ4eXFEg2G06?=
 =?us-ascii?Q?TvTLdCTPL/OSHHkh0ffi0Ni/hjmYtZlDSGB1GyBt33HHVwHqyyridCiwXQ94?=
 =?us-ascii?Q?Tzd6MHUQ4TaIdw2hltcW2ML+UfbkSiyL1yDpa1yqT8iE05ZOR5cBLs3XHAIH?=
 =?us-ascii?Q?wglZhWqovPhRlvRVpYlyIE/YxY8XxTEb3Wdp2wsLnbZaG/YjlxI78z4RE9Dc?=
 =?us-ascii?Q?QlHzOB42KmMZ4taE7/Px6BKDTtX10ZbxhhbShae/w9iL7Et3n+qY6LwCyhIy?=
 =?us-ascii?Q?eT9VniVBirS0LxDCym6T66CHlJfOOjExM2i2GwxcmCqve0T8iX4kxWBuHwQr?=
 =?us-ascii?Q?aoY5xTElNBOHOXsdHJMAkCTcmtJXE6rGFx+HrYYw2goD/kE1SpI8uncL61Jz?=
 =?us-ascii?Q?Hg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <841E5EBF31033645842BA49AA0D1E71B@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	SQNnuz6OQQcMjSeu0/xTJJxYBwh7Y3/LBm4JdlerP+HStkzsMLwtoD1DyfCUMKm52cht1fNl4M67Oet5nHfSMjdGhB/I1orVtZ+JbnBkXAh7wArn3rYCjkmWq0ZhdhKIFkgTC6SZs/5dawy+h3L/uxFX/0zFAGhCa0O+WkJ0QrTuX2REbB3yu76Qt1BmKm/vEMWyMO3R4KovjJmnHqNnYNTWbz5FtvzmLXZbciV911Q+YaS08tlqktc+SCEo+VP6ltAh42pNBubpRUKG2D8ibuN5j3QN2lbfQ3iNYrXDk8ricgwtqha5SPEv1Z6qOatNPc/rip3usSVm6WJgiCI4vo9neYvkgwwREE+9mkBF6UBwno9qkS/RAM6dyomNku1YIZyG1G3/gtAEfmZ1/5z5UIO5aSx8ZnKugAZbBdV7Jpn7HsugBClIhTpsjrm12e1DybjnSClqs/gk/Ep5V3+PNH4nC515nE7QOy2BAjyUDWwzWzd+XwQhc56m85+ZK+VnGGS7fbPOKvjs3XwFJhFYpK3nMNje46EqarDwr+KqwYC1p9y5tMhD3xx0DSkCiEoYEizKJ4ZPbMX/Huvil3qxkAgNIdNQmZsWbfNa5fde+WsE8ZUZkIjd8HhlpYgZcHETTaVN6lEkjD5jKyusXU+QfWKlNJnuxgE89qDsZE3CcuQJzWGmCGKfPbOsT1NFCtZakf/fJjIOwyGhgB/J7KflPli4vA+x+JUnVn9Onaw88tAmYoits4EVs5POaJ+xR8S4KQcJtXu6TF4KCSLSBxyV6Fb13FzyFxZuEHJk8dPV1xsOt0pPs3hsrvdxBnewL587qP+RccRgF2ly0fFnPrAWpHa+3U0MeQa7Dpc8PKiLzwddU2nCjxRefJfgCXcgPlCn
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6262bc6a-c202-4f55-e003-08db5bc27761
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2023 19:18:18.7230
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Io0QuqflZX7dUavcvRDto07l6cPMrrBK2etHjqTIsMy4Nghi8v8505N39MsQO0hrziiuifAjF2UB3ETU4Q7TYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6039
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-23_12,2023-05-23_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 mlxscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305230156
X-Proofpoint-ORIG-GUID: u5aufUgUDce3_u4rwzHLoYdM2iGGSDcX
X-Proofpoint-GUID: u5aufUgUDce3_u4rwzHLoYdM2iGGSDcX
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


> On May 5, 2023, at 3:58 PM, Jason Gunthorpe <jgg@ziepe.ca> wrote:
>=20
> On Fri, May 05, 2023 at 11:43:11AM -0400, Chuck Lever wrote:
>> From: Chuck Lever <chuck.lever@oracle.com>
>>=20
>> In the past, LOOPBACK and NONE (tunnel) devices had all-zero MAC
>> addresses. siw_device_create() would fall back to copying the
>> device's name in those cases, because an all-zero MAC address breaks
>> the RDMA core IP-to-device lookup mechanism.
>=20
> Why not just make up a dummy address in SIW? It shouldn't need to leak
> out of it.. It is just some artifact of how the iWarp stuff has been
> designed

So that approach is already being done in siw_device_create(),
even though it is broken (the device name hasn't been initialized
when the phony MAC is created, so it is all zeroes). I've fixed
that and it still doesn't help.

siw cannot modify the underlying net_device to add a made-up
MAC address.

The core address resolution code wants to find an L2 address
for the egress device. The underlying ib_device, where a made-up
GID might be stored, is not involved with address resolution
AFAICT.

tun devices have no L2 address. Neither do loopback devices,
but address resolution makes an exception for LOOPBACK devices
by redirecting to a local physical Ethernet device.

Redirecting tun traffic to the local Ethernet device seems
dodgy at best.

I wasn't sure that an L2 address was required for siw before,
but now I'm pretty confident that it is required by our
implementation.

--
Chuck Lever



