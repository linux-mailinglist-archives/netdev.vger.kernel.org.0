Return-Path: <netdev+bounces-714-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BE406F9382
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 20:06:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 139F41C21B05
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 18:06:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 522C4C2F8;
	Sat,  6 May 2023 18:06:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E84B846B
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 18:06:06 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E33F3150FD;
	Sat,  6 May 2023 11:06:02 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 346Bvb1B022726;
	Sat, 6 May 2023 18:05:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=u1wvjtDDj6ZWwbtNvqmbTa58b4jM0lFzUd3YUf5ugwo=;
 b=KupfOLia3piBZLFxmw/oa8TbSiEPMF5lHzL4/KWKqamYhPL/OlF9yGFa34SX/aIu/56q
 pfuMaBaG++Y3sQWo9lTxThG8dkP2GMZUBbiR8RVe/JucgsVQEW8QWziHcgbHLYEhLybq
 WXzrMvNJwACKdfjUY8boSE1l8sBNcq8bXNhz+5rQUdRaXettBWpGlgVVgNJi4Y8P5zgi
 Ua+uSi7i+26DH89lBBF9r41zbSfEMnAqIUuRlHO77cnknnB7cOkJj2Wevqv5YvWr212k
 qlkyq/y3PVDGHtQd1Aa1nO3IxZuisgFQqQcEgCLJyTqjeuPM4nnVInkHKw42E+D8HD+O SQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qddtcgu45-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 06 May 2023 18:05:57 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 346F5s2J024148;
	Sat, 6 May 2023 18:05:55 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qddb37rjc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 06 May 2023 18:05:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kENYJGPjKnJa5SOAOhvP/PE1a3y5MnCtEbsYuacDBBmqHmVS804rfAOsDIH7ghzwrdne4b/TlwWo3Mi6q65mD6d/z4xpCvQBcCcu6qW0iDS8RsuZ5ebCCjIDyrlv7Xah8w4XsjGtD598pxv8RuPoxvS9+mlG+hDaLZwagnGzdchugvT/2+RqUCZ4Ckxtfiy3DQlU58g7tx78FTEcQnc3cw4C2MnZn7bTkXJ4kwiQpDNWn7o1tSUs6dgRj8h5FyNDRxlXLpV5TrMo0aPLUBKVVTRYs0I1QkgR+Cqbg5kr3G9vZEj1QqDDqUlt4aHAgWxb4kA6EndM/XtuDIr/4H0amg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u1wvjtDDj6ZWwbtNvqmbTa58b4jM0lFzUd3YUf5ugwo=;
 b=RHQJbYPhOwh40v/68qvKO9PBXCtbZcXMNfbDYdWicSLPo+0pIp5wLRfzWydS8NtMCLz5FjL2YS8Rz1DKl22CU3hOPHf9aMDa/Iy+ZD5iJTCJFZ3xj8Pj4gKluqUocMdlXLL0vyBJziBJiDzlMGwA/1kCbTdyENK/cF0FviPU/AzvPKCkyGUHNFbEtqh1AzX12mMUgVhYnHvo8DEeUnp3TagbVPTIOsrIpLwKYmCGMqzAy0QMqy2fE1Ym8Nj7yHfT9ArE6QVI3TmDhy027n2CgL4+uE1opjMY1a1CYwWDPChqDzxZqzQs8eQTD6NtQucO/6PljWp1jI6T6WqwxclLgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u1wvjtDDj6ZWwbtNvqmbTa58b4jM0lFzUd3YUf5ugwo=;
 b=mnFpPVKSmXVIPGJkZKW3oXOafrTSoDzuQJ23bQOvVxsJ7J61ZMM8O6rm34kbIqpK9ed1jf3KkefJQTVbVwyTg3IvlclwU0Whrkw9DU0LAWQ6PHmg+SmdboB/aeaOKR1qZ1mSdMiJ8w3LS39DxcgfJFqdLbmal48orJRpxzzvy/Y=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by DS0PR10MB7050.namprd10.prod.outlook.com (2603:10b6:8:14a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.29; Sat, 6 May
 2023 18:05:53 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db%5]) with mapi id 15.20.6363.029; Sat, 6 May 2023
 18:05:53 +0000
From: Chuck Lever III <chuck.lever@oracle.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
CC: Chuck Lever <cel@kernel.org>,
        "open list:NETWORKING [GENERAL]"
	<netdev@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Bernard
 Metzler <BMT@zurich.ibm.com>, Tom Talpey <tom@talpey.com>,
        "parav@nvidia.com"
	<parav@nvidia.com>
Subject: Re: [PATCH RFC 3/3] RDMA/siw: Require non-zero 6-byte MACs for soft
 iWARP
Thread-Topic: [PATCH RFC 3/3] RDMA/siw: Require non-zero 6-byte MACs for soft
 iWARP
Thread-Index: AQHZf2hilDPMQchDT02kRjpEKJKB+69MGTWAgAABHoCAAXGaAA==
Date: Sat, 6 May 2023 18:05:53 +0000
Message-ID: <5438C46F-743C-4AE4-8A83-A0A223C0CE74@oracle.com>
References: 
 <168330051600.5953.11366152375575299483.stgit@oracle-102.nfsv4bat.org>
 <168330138101.5953.12575990094340826016.stgit@oracle-102.nfsv4bat.org>
 <ZFVf+wzF6Px8nlVR@ziepe.ca> <3A1AE752-3229-4E7A-B9C8-6E2A134CAA14@oracle.com>
In-Reply-To: <3A1AE752-3229-4E7A-B9C8-6E2A134CAA14@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|DS0PR10MB7050:EE_
x-ms-office365-filtering-correlation-id: 19d03af0-3c33-4da3-db91-08db4e5c8857
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 14NIlhQOiGUOmzGOb89CYpDvHrCKbrA9TCIbQ5B3Xv3jOVlNJYogfh0eYRRhcYhNxEVMyDQ3xbAXBCQquZ0USanO9rz6z400IROyJT3wF/qjOTPxW6EszUwOAIov1u2i00ILKAoVDKjWHkLmqRxA92i26ZHRv7cMXZTNHZSHSZOV2sOLwzWoJ+cfuC6BOflb4xua89oznSgvgxdN7KrZdj3OT9lBu8/0Vkha4YurFAeGKP+mCm1WILS51qU14FcOWcssZlSVKZ9oRm/9BhHq8RI0KNs9X0GZ754DicU8MhX3z5WOWG4Q/arruebjansGBVIU6gTRJgD85GBgrwSvMwl2/nzsDznl0jT1WtGhobqbt04k3iyeGxrS5SLd2m+slio2oxRXAW7N9S0uZFiLtEvZKG86BAOmhSZmxi5aSoQ2IRqwjzjKe9wOJuKbc2XDXcenOoddW/7V5jxYKAO/kWj9+fZaOjfwCUq0XO9JOx7QJj2UUqR3rVAubNUwayStzZH5IMnFWR/RSEFf9eU0r5speOOtRIvvH30T3jo8mYB471Nsz2H4lUXvRrQB7yb3YPR/lS3ylvK9dy81tXefgMQ4IOw2s6VvUusU0nfIa334hVAPqucDXlA4t8fwD/APT2apyc6ByOMTadb6+qkrmA==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(136003)(346002)(366004)(396003)(451199021)(71200400001)(6486002)(36756003)(2616005)(186003)(122000001)(38100700002)(86362001)(38070700005)(33656002)(6512007)(53546011)(6506007)(26005)(2906002)(4326008)(91956017)(66556008)(76116006)(66946007)(6916009)(66476007)(66446008)(54906003)(64756008)(5660300002)(8676002)(41300700001)(8936002)(316002)(478600001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?e8VmrlA6+/VjJ/l+0wdfIK7+g4uoMFoxgravAaF95dKkWzn3XD2sFDu9j73C?=
 =?us-ascii?Q?aphHvttzpOdMxUTFO96T5PROjLlG4Cu10+t0emjW1UwrcmdLAVDctCdA8Z06?=
 =?us-ascii?Q?lnXOTI7QpvVmQA8IcsbAkreCOBUC2v0KRfKBrrqjRbWdUIJBFFZ3UnNO6LLd?=
 =?us-ascii?Q?3t1sfKX1lCLqiIi7UfMbOhtdecWRIytMLHnMBybsxprxFMKeHAPtzpvSF1FQ?=
 =?us-ascii?Q?zP4lFU6xovVXDDJ2ZOrqiU/EQh1VBeBRPI4dBuQHmaJO6kffkJ6nzZ8wsWsD?=
 =?us-ascii?Q?Cik5YRmQ2J10coRgC9H0zHJrzIspE1sPxapgo1ApMj/YE6gHfC8cwdrH3wGD?=
 =?us-ascii?Q?NBvUguoUf5ib0FX7KL9cdM6u6Zih4zM0yiSSWmIirtNBmfAqWebiJkVrOWqd?=
 =?us-ascii?Q?J4A679lboCVOhdgZflpQZT25q+jF3o/qdyPCPrWgI9vUoeXzEmNg/SyXY5C/?=
 =?us-ascii?Q?CTPcCVuJiy721M3/nrG1gVxilcu+KuM/CcX8S++u2G8SWB52lQIbf8uWDZhy?=
 =?us-ascii?Q?yiF9lI6tKFt3pm4JR+OeKURWBxXxoTg3pIQiBYwQ7B7JBq2rvNrkUcrW8tgB?=
 =?us-ascii?Q?nw5Kl+gjaIt+LXqenDAFzr8YghCwUEq0hTFRX5zb3huWaRcBXOjmfdgRb3Ye?=
 =?us-ascii?Q?UYJhjKiXDs+/rkiOTQHO/Yv9Tf9IkMBsPQEfCSWm+ZWMmQ4CziFv8Bp2KPOm?=
 =?us-ascii?Q?L9xiZ0Sek4iSlViz3oGE2diBK8dzboQ4px9jIcpbbR0d7jBQa++lzNFxZtui?=
 =?us-ascii?Q?52+4HOlxydg2LGsY07gYZgvFMvi41V7iIsIl22NbkpdpyOMshp4SKOQ/xPl3?=
 =?us-ascii?Q?UYMVGMBSGCS1XT+r5TaXYUlbWDm4dHNI/zjJVSPD0hjKiOQOPnnTNVcPhj5R?=
 =?us-ascii?Q?USUJODNufeLQuCv/9ISKH1VfwXluVVUB0uE0jH+FkB4fg3961HD5sPOBWjZv?=
 =?us-ascii?Q?GJGN4YHUsC9qykMoZO8S9i8wgaCaZW9JB8L+FteAeiJRxhOyaM9n0xauID/I?=
 =?us-ascii?Q?c7BJjdvo64mrDGwahwB6Kk4EIhq+xGUkeL8gu7EgqIDSs8WT8jMJ5MvcO/wT?=
 =?us-ascii?Q?yMzAv05YKDnLwYl7UCg+vV4Yyw7KV/EBLov5uwPzdOIu1Irc2Ya19d27uuXH?=
 =?us-ascii?Q?3TZ6oGEQ1A0I14fGKZA7dLHc7v16tyWHTdU9wAZdOkKkZyFIe8TQimM57VXe?=
 =?us-ascii?Q?kz7+kcs8dEvAnbWuwMC4XIZfRXdNWZRGfUIWNEbW9iemDvlTs7ycvcyW+Zsu?=
 =?us-ascii?Q?nh0EW5yqZWVQzeVjoghm6hHbjcisfql3C+Vz4vcewSArRPD5JCe52W+La3Vk?=
 =?us-ascii?Q?mWp/+BiEbJc3j/V2bJvNpuQNmMAE6FikOgqv0cCOg22KDWaIZzmI90Sv+MVy?=
 =?us-ascii?Q?NouxW1Zl60ZvQGtXXHRZmp4iU66n/pldy+b41rUlbGQHMgn+sI9okYXgNo85?=
 =?us-ascii?Q?azIip/ustihUFcbfHn7Pve9jG6dLtcLPaCBhGL+sSMLpIEKHYGlz6lGh5Ir1?=
 =?us-ascii?Q?PnbPL6bI91/ok1ORddmaNN84hPrthYh/Vb2jDRq8Aii1bSNrTV+1tAsMoGNP?=
 =?us-ascii?Q?aSaBO4wIZmKRh7GVwjTgVZH3LeIZqODgZrHuEmLG/BXP3PK8YdtkbYvM+cbt?=
 =?us-ascii?Q?fQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7C20A93EB401C244992B5DA02B701FC8@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	5ondLDgBhd2+RENEfLWRmjqmfO1gUc5sFiH74h+JlyKSKofa7B5I1CVsUbKaw9ed004oMORupL6oyWNHm8OoM/VcCzFsUfZ5HERoVl2Wp1tNXL5aS84Hmxj/T1Bv3z2DOcauMoxpnqaebd+wQRIy3v3xo56WYXjdNPKDKDfUB8VZkihdqvd9pDUjIinDgQiWav0Hk+AUF4rFxgZWQIvbFLQG+lxeRgVr03eCA/B6cNVRNq14mEt+ZcU6VFUhVHB5yCTMSgCMn9cTAR3Y7ycaYiKcLeAVDp38+kajh13ebkVSqStfp4Ewi807eM0HxMGJeHmkniRYgBh88P8UKxWSKtfNc1mSSnbUuJPJp0DChuUWfWSJ75Gz0fklCEGFvXa628LZ8/ygehA1pDldVdZzRZoGsRhNMZdxS/qkuI1rl93zL784T4kV4yMfaIaINNYgBrzOih3fMvUYsMofpvJghQHQFVQ7I5hyEvTQUM/VDnajoaFzw04LKB8Yjx07vPCcviigPHaBzP/X3hvMMHCzLdgz45tD7XzmsJvLp5Ubd2QpK7pIJvklsfotFSCi4OkQFly3Cymqmk64RCqXz4jJeTAlucVpacOsLeovHihX9fzSCLO0JgJG5/1/MySfGOJTPR4v67K4VeklxykXVtPlCY8ZUKoeHirRGIqZ1fFnkMYpOCU5qSu3LVMPPsXvuic0vLzK7rrdYIGepbwpprOfjL2GgHpfZscUFGX9IZsa5Iy/i+fEJPeyqGv5DuY0GXQVsuKHTIPLMU2ZdaMcg5ORQNNVPV/UQSH0gYSqnqEN95CFtEa0xZhevs7K3ih181ZnKaC1uF5ub28dIDNz3wnV1kmhP4tl7z3VrB3tGzq0anATQGC7VhoxfvyIFflBNkYPyyNCnwmYum0aPw/lSxZr2Lkto5FX7cLDh49KlVtTnhA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19d03af0-3c33-4da3-db91-08db4e5c8857
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 May 2023 18:05:53.4330
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AXx8BYjUrvQ/i3bwNh381NFpwk7LkgUVMm7CcW4W4PVHQs1DDeYBS6fNAyRl/IMcU1gxDc5aASOhgpJzGyjTIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7050
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-06_10,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=810 adultscore=0
 phishscore=0 suspectscore=0 mlxscore=0 spamscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305060140
X-Proofpoint-GUID: q5MVbx8oiEAKRAYVfFWVjyCbMGTUUUQ7
X-Proofpoint-ORIG-GUID: q5MVbx8oiEAKRAYVfFWVjyCbMGTUUUQ7
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


> On May 5, 2023, at 4:03 PM, Chuck Lever III <chuck.lever@oracle.com> wrot=
e:
>=20
>> On May 5, 2023, at 3:58 PM, Jason Gunthorpe <jgg@ziepe.ca> wrote:
>>=20
>> On Fri, May 05, 2023 at 11:43:11AM -0400, Chuck Lever wrote:
>>> From: Chuck Lever <chuck.lever@oracle.com>
>>>=20
>>> In the past, LOOPBACK and NONE (tunnel) devices had all-zero MAC
>>> addresses. siw_device_create() would fall back to copying the
>>> device's name in those cases, because an all-zero MAC address breaks
>>> the RDMA core IP-to-device lookup mechanism.
>>=20
>> Why not just make up a dummy address in SIW? It shouldn't need to leak
>> out of it.. It is just some artifact of how the iWarp stuff has been
>> designed
>=20
> I've been trying that.
>=20
> Even though the siw0 device is now registered with a non-zero GID,=20
> cma_acquire_dev_by_src_ip() still comes up with a zero GID which
> matches no device. Address resolution then fails.
>=20
> I'm still looking into why.

The tun0 device's flags are:

   UP|POINTOPOINT|NOARP|MULTICAST

That flag combination turns addr_resolve_neigh() into a no-op, so
that the returned GIDs and addresses are uninitialized.

Cc'ing Parav because he's the last person who did significant work
on this code path. I can hack this to make it work, but I have no
idea what the proper solution would be.


--
Chuck Lever



