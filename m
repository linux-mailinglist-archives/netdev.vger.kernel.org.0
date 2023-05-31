Return-Path: <netdev+bounces-6900-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 883757189E9
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 21:12:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 31A55280F73
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 19:12:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F18219E71;
	Wed, 31 May 2023 19:12:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A16F805
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 19:12:33 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38F35107;
	Wed, 31 May 2023 12:12:31 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34VERRjq027594;
	Wed, 31 May 2023 19:11:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=oSJ32MEy1wnMv2tU4Y4q0+mtQfx6hnY/OxqWYOonGWI=;
 b=jehYKN5jdr9jM82t6wgwsKAoB3q7W1WFCy99UL938TPaYebCoct3cCzmcJFL/7qbeM2K
 lYXxjUucrUx90MnbCgRLwbEFfgPPNxs2A2HmOfANt6n8xul2XS5nFAKsWOOJpwXGi4Wi
 udvXxMCteMrNG8cmG5aT/GMubXI9XWu0ZWIBFt2NBE/Us1gSJqWmzneGs3utHQ7QS4lo
 K9CXwB3DXM4f49UzQy0GJHfo9TaycrQsgSs+IXHYL+itmlYNsbADVjuSXz/03PwrlOGm
 jfEmyXTaLiiOTkd9KY4O9s9nkiB3tNbSEMiqjozz+i5jy7ZS+4FWu7bgxUcX3EUhkGYI iQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qvhwwenrt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 May 2023 19:11:55 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34VJ752k030186;
	Wed, 31 May 2023 19:11:54 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qu8a6tt84-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 May 2023 19:11:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HKFqWm6CKPXKVZCy3q6VTyDTxLrXXqOowBxxfoK5nGmXU6y3MXES5x0AYN5TljwWtV2lvGVyMhtK8PQRsXOrx1rAagW9PMMCVNYXr8RM/1WKhUXURonFb0QjgxB/0ryoT2A5nIvP2fdNkLKfCPgJpdPLuhND6740kBi2g+qATmWL6J+scfh+HG1hj+aU6NvVxczS5hyWTh8yeDdRWDSthgTjWdfrjIDAAizHVPTLErDidfSLHm5qImkDSkFaDNKFiNDB4xWlyuulOpp13FyiUs4pIQsiPX6tAnJJuNPchqySbNyepO7wT0qWc5V2KdNyRLnb7H3hN9kfSoiMgMcJog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oSJ32MEy1wnMv2tU4Y4q0+mtQfx6hnY/OxqWYOonGWI=;
 b=cSRi5MqIr4VDKqLke7F+hJf2shpBBpbG0MELebkB8ezjhT5O/FDMSggLNZzoOUJJ40brdSCyRHe2D8D7yMsWorcPpAc5wcbKt2pcwURvNjZdmmvmsazPh0LbSf947nhTmVNXc/ozc/Sm/hPi7t5q1NZk5TjKeQaQmm2pUWvcZeZ6c3G4FHCgLee3TywSBgN4z4fmnzHfQPJ3OkJLkZyKP3yQ2W2oZukof43SkHaRlFIFHfjk/Wa4oX75H3eQTzMJ0mUeHf50KxMZOL5z8OZruIqzvxcaAGPbBRo7dn/BeOL+KIol7ITuck5KE2EjLke+otoLWF4T64+S0cBexaaxsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oSJ32MEy1wnMv2tU4Y4q0+mtQfx6hnY/OxqWYOonGWI=;
 b=tw8c7aG3qwFEPq+Sc15d6RmOP5Cl3JT/2Vq2UspYowb6jXUSt89LnvvTUzIrQHdRRMlOBVeyvXdkT5TBlQocP93gdmFVt3F+INSsaEzzS9FwbAiL+Wcli3Kz/Nbm8f10uKgMZXF9UZY/s762WUYVDptY1LuOZVPj93u4Vo6vCzw=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by DS7PR10MB7180.namprd10.prod.outlook.com (2603:10b6:8:ed::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.22; Wed, 31 May 2023 19:11:52 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db%5]) with mapi id 15.20.6455.020; Wed, 31 May 2023
 19:11:52 +0000
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
Thread-Index: AQHZf2hilDPMQchDT02kRjpEKJKB+69MGTWAgBw+lwCADI7zgIAAAeaA
Date: Wed, 31 May 2023 19:11:52 +0000
Message-ID: <B0D24A4F-8E82-4696-ACE1-453E45866DAC@oracle.com>
References: 
 <168330051600.5953.11366152375575299483.stgit@oracle-102.nfsv4bat.org>
 <168330138101.5953.12575990094340826016.stgit@oracle-102.nfsv4bat.org>
 <ZFVf+wzF6Px8nlVR@ziepe.ca> <7825F977-3F62-4AFC-92F2-233C5EAE01D3@oracle.com>
 <ZHeaVdsMUz8gDjEU@ziepe.ca>
In-Reply-To: <ZHeaVdsMUz8gDjEU@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.600.7)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|DS7PR10MB7180:EE_
x-ms-office365-filtering-correlation-id: 0fdb4e77-1098-4c4a-82b1-08db620ae439
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 tqcHTm72d9ioC8CGkMWH4309NSgCusr3Cgy3Ut5VGJYUw1RUavParUhGZHNf5K/bhGvesZ0dPdFlEOBJR66ie8O6aa69LGPuhM54A3Fiz8EWjI1IJKNE88k4qQO4SoT3amuFtXVk7t91Xg3G6TtZP27i+xWHb0XhizijYw6pmWxfJe98qAwZyvLLj7jTiiSNAM6lF0C7RslwqMZ33cesJLJpjXzdl/4Q+KAtHQS1yVk5CF2zpv5P0/xz7lbfe9pNlaHiLWDqLSQohoh2qqO2SHy7IpxzDw/SGDZbw3o+QaTb9FuBoOaKk+b1VcTvr0oNzLbVC7aUTht9DQKLTcGlbK0U0hJQddnhYkylypLd33EtGmLEyP/k3ZnxoDAm3j4IlsZizux+KJLNEOYRBZMhckhrL0xtPZ2s6ewfu2XzfUzN6CRL/JTQP/xGdCWOCdvNhY2G6CbfE02iOoQvTMYQpIxGYIk+i672qQxOlapHF2eb/iFRWuH6+MjL2oVn/JTzheapuYaFhxT7zRsrcwoQzInYYjt8x3zE1z87BrzLZv3h5R6/9KVsS6zxCu2FsqiVV7wKvWDhHy0XaKrJI+dh2UD7Kw5YpxAkGIo3HN1EykTXhZFSeESectA2+gGIzP4wgYxwnxz/QaumhVQkRhNQu9kqFAJw63AC/vl3P5GjT9SCtXdkvOfUDiiBJiXETzwL
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(136003)(366004)(376002)(346002)(451199021)(71200400001)(6486002)(478600001)(33656002)(26005)(36756003)(6512007)(53546011)(6506007)(186003)(2616005)(86362001)(38070700005)(38100700002)(122000001)(41300700001)(316002)(66446008)(64756008)(66556008)(66946007)(76116006)(6916009)(66476007)(91956017)(4326008)(8676002)(5660300002)(2906002)(54906003)(8936002)(45980500001)(505234007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?9jckZP2rQo4QvG+DvP2SbZMukcbI2GmwO1kwMFk9wDy6ipBRFY+7AFXNAHxu?=
 =?us-ascii?Q?ejpDBj0SXsMBJqhXHHii8oWTCoCX9nwMqp5KTFy37ILhAsXyiXZvFXcQ09/Q?=
 =?us-ascii?Q?exbldQLWj3TdaPJWRpJrBZvOaDJEPtejEqqKjyWB8SW32icvfXMxlUVOjSwg?=
 =?us-ascii?Q?JACSiyynfzMapgADMNSi0IMWF57oemH/GM5+9sCTkY4PaaEP+aSuS6rQSRor?=
 =?us-ascii?Q?W86/LkO3l0VHQ/7D0bQT0ZTm0fsxCg1kpPH9IB3J3FiUfLsY6uw6Yx7ZMxJj?=
 =?us-ascii?Q?swJh1zDL7alYE4QLsCqqEX/+Q2PFeUCghPBpGHUVo6Zs8RPXoRmeuz9w7XEm?=
 =?us-ascii?Q?tRZIK/V7njYQ4QXVP/UpgjTfpP6xt+Or/X8pOKA7ZY4AmimokxYOCVndgPnx?=
 =?us-ascii?Q?S2CzNpXgv2kzg6viDIjJ3BX7oeBC6GlHgfPcFC/JqIs3PaB3YWQSwFJn5HbK?=
 =?us-ascii?Q?YUkf2vbVyyQmJficQGl1zi3EJcfa/LfRi1vC6/47AG6EJW5yepU1ZWviU4iO?=
 =?us-ascii?Q?SQIlfsocGnRQPZHIWGQltLCkpK6P2rOP50iIkCoJU+DcQkqQa3dbYmL6syK+?=
 =?us-ascii?Q?K3xvGFL0MoEPBfAdyjDKw8P+hN/kfBF6d43cbT+kOph8U2ZBfvK4VA2RV9B2?=
 =?us-ascii?Q?+LVGabUjgNLe08StrI0Qli/c+T/6pXyARQIwgXBaoYo8hm4xU/38Fn3XU8Kh?=
 =?us-ascii?Q?wXTItf5aEFO26wYmD8NAhr8IU0aQ0PovbQFod51T0fw2PDtQjiZAWlsOU2KS?=
 =?us-ascii?Q?XGlqeA7TvuDkmj/V/pDBXhUkAMDcIRZ26faCv77z75NKGVUuIiO8FSU7eKtV?=
 =?us-ascii?Q?IxABIP/mHOd6fVb62S7vCq2hUEn00UPOzDfB2//S+8lpjGCxIDp3BoNaDYJy?=
 =?us-ascii?Q?YxJ0qHVI8uvQqxWhPO8PHNkdXABwwYWqZkAzVtKavC1iO8ydCfrftfN4kRON?=
 =?us-ascii?Q?N+K63qs2ptrASwzC6OoiRVM/SfozPZEfRlm3OVPFM2wzNKZdhL3nJRfngUsy?=
 =?us-ascii?Q?vBEpjj2KrYS8kUwBpQeWzE/dyNPfv3Sc0EDXqiD9j4FYxk3xEgVI/6cReSEE?=
 =?us-ascii?Q?branBRyTAIEA+cgrcroKvovVfjYS9USNqSqSD6GyZtGLvvJ4eaweYPOcC5eu?=
 =?us-ascii?Q?zGPknkyaQQ5Zs2i43ZeZgLh95xZe4Hufw8xi/F5Shc3Ww7H9Wv6OxEM0oGqu?=
 =?us-ascii?Q?EMwWi57hbrsvQPH21JFPv+MXxSyLcpBJKXTYMKxEH4ML2yCMD5bkmSUMzYrF?=
 =?us-ascii?Q?B/uJRvEd3/lNgKKMoxGoKh0VRVHTW6Z0SfbXsJH88kd7sIizoIpyZUZ6OVgp?=
 =?us-ascii?Q?vpmmDRmJfzaPYAOU5Ak5Ba++LF4Xv5RxcQx/S8cVxzN/aUnKmrN0X5w+GzZb?=
 =?us-ascii?Q?HiVPud7gDaJqRs610NBgVwGS4GetE7cKUas8dVewd/iKky4T9lQBmP7dALal?=
 =?us-ascii?Q?aJjPiPs69/ixdxCbI3t4r6m5jJJGLnkRNYcDB3Be81J5p2DZ2lGqCc7JMHIt?=
 =?us-ascii?Q?6McHcWi9h4tdpKu1Da0rzc5KuBJSxhtgxlobVRXGRrNdJZGfmYzRDbT8bLTm?=
 =?us-ascii?Q?SIh9clZsFzJ3b6+4hHhMrp7jP74soMzL4ojD2Q6gMNxAW3y/c2aIFsGfGEce?=
 =?us-ascii?Q?SQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7896F23D013954439ED8E6611E7D572D@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	gjCEGVAcPdq6w2sZcPbLam/4Ngq3Pt68QdOHVg8iYVGweRU2nVyaflw7IWee6YGtSZn2JbqjHXv/Vs+mBbkLDsP/FCzy72krMa0iGuBEVTxJVswf66cOGL3YbG6+XX/ew0X4YNDjuZng/o0z6ro6vFxgnEnyz8H2z6m82nkLedSwGg+6NdBn9v04MMLacW1VK2YNpObeopeAriVKe9NaedVVYcPylAES3dc6SR4FNYo660zlGjyv3n7E95TnmaKrxUtXfYsbdpCG2RiEhvUG7BqjUe80eMlTG4hbrKROpoQGi7oTKdxNfDoo2yoT/r0xwWAj0S7hbOm69eu0h6G/7QHuZVxYdO7wvHixQmKdYugxPntNjYxfOBz3h54JwZk/2nRkMhkr8DuRyE3ZeKZPnz4iyY0Hw5t1fIwvNy4OVShnxFrGPfKZlKYqjVS8/0XpYl0Ul81fGKexqSEYto3qyEzBZanocBgbZljbWALuregOG7exHatTPXV8yPHn+UYUFOtiq+tuj8DKmKFeMFwK5S7IvDR6BwFhMnXt7nEUqOIy/c1AML+xsk6KfS3k79S7+feKD9o0Hdv9A6k4Fkd8zfcSBz1Vub7wu7vKS+xBOdpPXGLwwEm8xCyamjfhkLIHKQiwwRIqQWa1rrrDnX6x2uKd4ZLAkQgc/DCVX9hnQOpd4yqIsZ2SR0SpW594v81gz0xi/2Dya4dQbwwHZtBwi7q56rX/NDy0VNJ9/YMKnGvNu6j/HekjUO2NjJOxuRFp+g7p8mSavDSiaQEOqLjkGp32sjWdPyidc3gcIU3WhilC3FPbUhZd6QyZILVZIBYG83pB6jvwxt7aM84VezQL5GehqYKQabHWMPTs4FrBG9TVEcckBHWq6AlmB6K1/+VD
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fdb4e77-1098-4c4a-82b1-08db620ae439
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2023 19:11:52.1154
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JyK504SGylLqMWFjAWi+w1IZxp4qEO1CZlTfnrqg6OTagxL/VwBCIKyEmS+kt4w9m+iP4XA4HCaGLZTG1KCcfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7180
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-31_14,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 mlxlogscore=872 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305310162
X-Proofpoint-ORIG-GUID: ah20Wfwlpq9TeOmurTjGbdD_0vlOZrG5
X-Proofpoint-GUID: ah20Wfwlpq9TeOmurTjGbdD_0vlOZrG5
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> On May 31, 2023, at 3:04 PM, Jason Gunthorpe <jgg@ziepe.ca> wrote:
>=20
> On Tue, May 23, 2023 at 07:18:18PM +0000, Chuck Lever III wrote:
>=20
>> The core address resolution code wants to find an L2 address
>> for the egress device. The underlying ib_device, where a made-up
>> GID might be stored, is not involved with address resolution
>> AFAICT.
>=20
> Where are you hitting this?

     kworker/2:0-26    [002]   551.962874: funcgraph_entry:                =
   |  addr_resolve() {
     kworker/2:0-26    [002]   551.962874: bprint:               addr_resol=
ve: resolve_neigh=3Dtrue resolve_by_gid_attr=3Dfalse
     kworker/2:0-26    [002]   551.962874: funcgraph_entry:                =
   |    addr4_resolve.constprop.0() {
     kworker/2:0-26    [002]   551.962875: bprint:               addr4_reso=
lve.constprop.0: src_in=3D0.0.0.0:35173 dst_in=3D100.72.1.2:20049
     kworker/2:0-26    [002]   551.962875: funcgraph_entry:                =
   |      ip_route_output_flow() {
     kworker/2:0-26    [002]   551.962875: funcgraph_entry:                =
   |        ip_route_output_key_hash() {
     kworker/2:0-26    [002]   551.962876: funcgraph_entry:                =
   |          ip_route_output_key_hash_rcu() {
     kworker/2:0-26    [002]   551.962876: funcgraph_entry:        4.526 us=
   |            __fib_lookup();
     kworker/2:0-26    [002]   551.962881: funcgraph_entry:        0.264 us=
   |            fib_select_path();
     kworker/2:0-26    [002]   551.962881: funcgraph_entry:        1.022 us=
   |            __mkroute_output();
     kworker/2:0-26    [002]   551.962882: funcgraph_exit:         6.705 us=
   |          }
     kworker/2:0-26    [002]   551.962882: funcgraph_exit:         7.283 us=
   |        }
     kworker/2:0-26    [002]   551.962883: funcgraph_exit:         7.624 us=
   |      }
     kworker/2:0-26    [002]   551.962883: funcgraph_exit:         8.395 us=
   |    }
     kworker/2:0-26    [002]   551.962883: funcgraph_entry:                =
   |    rdma_set_src_addr_rcu.constprop.0() {
     kworker/2:0-26    [002]   551.962883: bprint:               rdma_set_s=
rc_addr_rcu.constprop.0: ndev=3D0xffff91f5135a4000 name=3Dtailscale0
     kworker/2:0-26    [002]   551.962884: funcgraph_entry:                =
   |      copy_src_l2_addr() {
     kworker/2:0-26    [002]   551.962884: funcgraph_entry:        0.984 us=
   |        iff_flags2string();
     kworker/2:0-26    [002]   551.962885: bprint:               copy_src_l=
2_addr: ndev=3D0xffff91f5135a4000 dst_in=3D100.72.1.2:20049 flags=3DUP|POIN=
TOPOINT|NOARP|MULTICAST
     kworker/2:0-26    [002]   551.962885: funcgraph_entry:                =
   |        rdma_copy_src_l2_addr() {
     kworker/2:0-26    [002]   551.962886: funcgraph_entry:        0.148 us=
   |          devtype2string();
     kworker/2:0-26    [002]   551.962887: bprint:               rdma_copy_=
src_l2_addr: name=3Dtailscale0 type=3DNONE src_dev_addr=3D00 00 00 00 00 00=
 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=
 00 broadcast=3D00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=
 00 00 00 00 00 00 00 00 00 00 00 00 ifindex=3D3
     kworker/2:0-26    [002]   551.962887: funcgraph_exit:         1.488 us=
   |        }
     kworker/2:0-26    [002]   551.962887: bprint:               copy_src_l=
2_addr: network type=3DIB
     kworker/2:0-26    [002]   551.962887: funcgraph_exit:         3.636 us=
   |      }
     kworker/2:0-26    [002]   551.962887: funcgraph_exit:         4.275 us=
   |    }


Address resolution finds the right device, but there's
a zero-value L2 address. Thus it cannot form a unique
GID from that. Perhaps there needs to be a call to
query_gid in here?


--
Chuck Lever



