Return-Path: <netdev+bounces-7600-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D996720CA2
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 02:33:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 764F01C2125B
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 00:33:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2E34C12B;
	Sat,  3 Jun 2023 00:33:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D23FC128
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 00:33:36 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 582221BF;
	Fri,  2 Jun 2023 17:33:34 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 352HfCgV008568;
	Sat, 3 Jun 2023 00:33:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=Uo3ftDLneq8BNodjliIRggwxo28cPz2Mq1g4k1R7Jpg=;
 b=dLXaYWcAQhUdgofQITbPYRFNXdqLu7SKhjl5Y5JcJWwNSIQTAyPZhJC3hHrDZJZSGCpU
 pS2J5UH79z0ojNfk4sS/FDUa/ECmvpAWJf8nmtVBmUN2PNMBwItC3c7TNdTHATOBv3li
 Fmvmfhj4xlcvpUMyXWAtwi/zAcUmspqTxSeqdF7wWT9O/pMtsMNksm50vB1waJpvBcEN
 YfpgmHiaOhuDKINzm3InAzKtCueKKJAE0QO89i2hydV4yXdqb7HjsBw03bOzfI1TV0Y6
 amtXNFJO4MI2zYU90EU4ifN0aiK3UFQl5InztD32tIZNrZWwsgZkWxr54GqsmAVwdwBI Sg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qvhmjv1m8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 03 Jun 2023 00:33:28 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 352M6HAl040176;
	Sat, 3 Jun 2023 00:33:27 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qu8a9h3p3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 03 Jun 2023 00:33:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D8NJS1lxUMbDujeMf3YJxFN4RbNvDDKSe+Urp/NpOVUlVIx2hvO0m6r2dpYI3G47htCCDP+8G1978vnEs2U296FWH+2YGXhE8rYeD0f8AUgHjMEPM0paPVP9AtUZdorhXJDGyroPdQJnMH5cBASZ4BGsVyOOeJ7DKjtwA4CwkfVRXUbQxR3ERXZAK8tBab8GLrvQShShYhLFhrFiBieeimt2ghWjW/SIFcUkkL2u5tC4qPMKZ0CXpG21kaZ0vIu3T6MYIUngL1SnDfwD/IqL+LiK142qNg0tjq9fmk5YsVus/f5UyFFdybZSM3pxOt2oh1UAjvuA1KJG44LQ+9ZvOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Uo3ftDLneq8BNodjliIRggwxo28cPz2Mq1g4k1R7Jpg=;
 b=PJFMopOkoQYCL4euJxGdU6AAezF9cl6hulQ2yxbabZcI3MA6Ibz/47VpqL8WXOME8koaFIgUn4pP8+P2LqsUb8gMkU43PWzMPCFRfdFdnxIZgj5B9oA+uPKcazMD2cvonBO4XPhO8I+yR3L9aypWKVUetXKvyXMA5SqmivZ6DxwmCBfSRjNUXJ95qPQKbs4UQcREaeaTwlE51Pdfmout+W2ThjhLr4/IcgHM/wfM42s667FVE3XBgdkzmtHdy1FSSeY9aSGxSNXJs4IL8s52iuJBL7pOoncxFp/SUQ4aLVbR2ttg7mttUUms4ZQ8smEC8LG13qI9dKwSZuezU0Ji6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uo3ftDLneq8BNodjliIRggwxo28cPz2Mq1g4k1R7Jpg=;
 b=LiP5ec3zIYYGYjxU2YpySoOtaiDIWVLs2+oCO80W6bCQHaju2erAYf6rucIGBet17oEJvrMSLFHKRbExOSlwgISlSNQ+tYUVaNy8c4E7H/XNEVfEk1Esb9Q3dsnv7QacjfIRGc84wvQtw6R3Y1HVa4BxHiyFLhiKv3cyQfoC3Jo=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by MN6PR10MB7543.namprd10.prod.outlook.com (2603:10b6:208:473::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.24; Sat, 3 Jun
 2023 00:33:05 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db%5]) with mapi id 15.20.6455.028; Sat, 3 Jun 2023
 00:33:05 +0000
From: Chuck Lever III <chuck.lever@oracle.com>
To: Tom Talpey <tom@talpey.com>
CC: Chuck Lever <cel@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>,
        linux-rdma
	<linux-rdma@vger.kernel.org>,
        Bernard Metzler <BMT@zurich.ibm.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH RFC] RDMA/core: Handle ARPHRD_NONE devices
Thread-Topic: [PATCH RFC] RDMA/core: Handle ARPHRD_NONE devices
Thread-Index: AQHZlYfl1VISa1yiqkOAQn9cpjE/2694FVwAgAAlcwA=
Date: Sat, 3 Jun 2023 00:33:04 +0000
Message-ID: <F0D9A24E-CFC9-4100-89E5-A5BDF24D3621@oracle.com>
References: 
 <168573386075.5660.5037682341906748826.stgit@oracle-102.nfsv4bat.org>
 <783511ce-8950-c52c-2351-eef8841c67da@talpey.com>
In-Reply-To: <783511ce-8950-c52c-2351-eef8841c67da@talpey.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.600.7)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|MN6PR10MB7543:EE_
x-ms-office365-filtering-correlation-id: d6c22a22-1da8-4c48-8cee-08db63ca1868
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 DLERQpkA9cPPQdgnYa0rXdL66XIBev2J/QszhnNhrxCNgHxrXiYT25F38bCuVFnM/Xpj21GNhy+kX7dPHmv8I6bnHoVKBWo4Nf7OiXFPIYa4ycFnczhUwe7P2C+H4GGdZAFo4wK+0wikFYWCjvL1g3wvB9Dne0gTmaNxz40PtR4JVCJugNrsQRciI6X4FVIia93YjISLVieuQpijIBKCNiIk+tme6FGFAfezo5Z0l9qvVQ4uq39XSEO2g3vTJo0Pz2vY5yc2cEb7QUIOKAcM2DG5DBpL/Y3/ZmWMPObQU/pboR21ebPk0D9/i8Gpu7vJ8DD335Kp1DPb66L3Ifb0+MjCTxA31YLRUy9ggM9Zuv1bAjuomjv5906C2QZFFtUILNgHAsmgDZEin7fSfmmSe5EkAMR9JFmyJjINy3cTw1lc4W/DIrCviZYIDCHg0srcoP6mL9n39A8RalgHcxSgAleUsVjkW7+iVyJRsqYHryOizAC3knUjrUEbLlItzjzaWM977ZT6Kx5z7Yur2/PXapP9Ih5xjb13XSx6Lq052jZsZJ/MWUDVlBmkQR4KjAEjzoI5kkNketgG/kI+IjwHIIz/WW/8TR/fzyEqhKwn+Libr0yBu77ZOrOKzLZ5f+yFf/0yIQM1mwJ+GrVQnreWKQ==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(346002)(136003)(39860400002)(396003)(451199021)(66446008)(6506007)(53546011)(6512007)(2616005)(26005)(5660300002)(8936002)(186003)(2906002)(83380400001)(8676002)(41300700001)(478600001)(54906003)(316002)(6486002)(122000001)(91956017)(38100700002)(33656002)(66476007)(86362001)(64756008)(71200400001)(66946007)(76116006)(66556008)(38070700005)(4326008)(6916009)(36756003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?6vmL7lUysr7CKDGfVgrfdyyfOrBiLgQgnkBpMt2aAWQCOcJZC3TBN+tTaCck?=
 =?us-ascii?Q?HiF2gVaIRU7QToMAKGZcxovl1Lpu5t34aFuHNgRW/CQ7ySHjvGJbzjDSZV7X?=
 =?us-ascii?Q?d1NLoW4kBP7th9s9rcA0Rn4XDxUsY9489ET3UUXwMYZM36BR8RGFULLKy9z7?=
 =?us-ascii?Q?SYd3hloFCn2eUZGb9xDG+J9h/Q184dMUv4i+Qe9odauT87a6Vf7/eoaBdo9p?=
 =?us-ascii?Q?8H5ZtRcvnquocvnBcCJoLtzs0n/RVmOZ55qsX3yHLEqXeNFQ07y9fZWiGxvS?=
 =?us-ascii?Q?HYB2D2KE5u/NOxcS3tdo57b56tvEV57pixHJRa0ukdh0hRnG0BewM/m9bx33?=
 =?us-ascii?Q?qAK8W4aqE63fjZxQD8zcmbwXRr/aHzsi7CgGq61uD+1d2NjJ3s+d27ecQbqg?=
 =?us-ascii?Q?9PZ7F5EQYu+MIvcSiXg6kfbitmRb5NnpIIqsjNwXA8vjxIcR7f1+qIDpcURW?=
 =?us-ascii?Q?dwBfJnB46y44edzzKVljXD3S9d5ssxS1nVFWXExY/v7mKEYX5bRDGFDepuQo?=
 =?us-ascii?Q?royr8I99OrwmQEk9HHBl8sT8j+tu1B+HRKOSMbqzJJgzzNGlUj570CudM6o8?=
 =?us-ascii?Q?lwXUqnTdP1HwGMPaGsMSkVDSpjhb0yyHZzKTu78iPAMp8L9QpyYzK53FI++o?=
 =?us-ascii?Q?Oav3+rGbyY8mvwMjr/SLqjk+0iJITFQlfiJBnkRhpfaw8oGIg5UpbymroRDq?=
 =?us-ascii?Q?kMiGvQBaoilesTEtS/qnghlds6gXIupdLrHfm+Gu1tlL8inMRsfI7tiJG1Lq?=
 =?us-ascii?Q?GNgB8xBCB4sEL9FYFaMaxcNgewS7kCAjK7xJjwQvWi9k1+Cg2fNOFUJ9gyKI?=
 =?us-ascii?Q?f/oQiTZyP8E9fMIj98f3ADuNF3fGfmsacZd98M9ld4++RBkWGYG7XiNCCXV9?=
 =?us-ascii?Q?YC5cJkk8LDUnPhsokUF4KMblkQgnkDFZ4A0gkOGaE0AMfHfag2mcAQiW6CZ9?=
 =?us-ascii?Q?6shg5lGOAs6S05ndQavx8Wur/0RqBohcrY8gzTN2Od99GmuOUZWT1LSMfui9?=
 =?us-ascii?Q?jFGrqipMBKZmJgQJZ3JnPr/nr/MHL1RFjuutg/RM3sRLLOO9/tB6vZTPMzN8?=
 =?us-ascii?Q?WD0t3rPEjzIcMgJQhpEai5QAoSMuLkut7qUT9p5roy7BOHD0ODCumwVVYdcN?=
 =?us-ascii?Q?9FaaLt3gO5lM/XG7+1cxfQjJcVg0H4denOWfk9JhED6Hj9tnWxAB/yawKBvh?=
 =?us-ascii?Q?SkZjoVfv/db8c8GfSv+SaB65dPZBbgFhegrAAutWQJqT9ixoA9jDSOFKvgmA?=
 =?us-ascii?Q?6ZepiemMDSgKi25HhG+y3BZncYPRjUfXfxClGL3OFGjpmQLY98eDVIArNTSG?=
 =?us-ascii?Q?YlfdKgE7Q7XZ7VGrinqXxaGj6u67284Js9T/wChrLpTrRVTaym/tfJjAHVQE?=
 =?us-ascii?Q?+BBkkbIu3lPubSPxhRTddOWO5H7qdCTrHFOY18RLTIhAWiSQl3B4r3E6+5TI?=
 =?us-ascii?Q?yss+Dnc5oZt/36Heu00EYUExWrXv7ACzawWNzzQp96uG9SFwMIpaugW7Lxt8?=
 =?us-ascii?Q?kP0wQtvypJGsgY4gZbKT7FDYL0BG5MRH2stb8PLS1twgP80P4Z8L1MPysUH1?=
 =?us-ascii?Q?bkPYAzkNuaQ26BvXwDcoCNin+SHWjnyGWV4lTFDLNT64bEdDdHkJfkrjMzFN?=
 =?us-ascii?Q?zw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FF186E646271A840B6B94A0D2BCF6DD5@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	ISjr9F1u8apRcipfVazwjEECfxwmwt98FBOoxmS275uzUVRsrsJECofeg9VxiFc1HR6casTLTnwFlcTRH2isXq/Z7fnJeHYomR81OCO7Cn/94zOS35r0FBZctp9vGgijz8AJkk6WiIwWpIxY2OELvSMkyRi66hvo8bABlUJNTkWsvRwu7KA0eWtGAebLzYiQpnWqYMPyh9iXirF7WvHFrpJEE9R54s8c8BE5nU7s8H9qlYTJ8g1m0pjp1e8MkMKJRBH/6BXSAhSBUKGCaAiJKlwy9bFAI2rJfHM/QTOZ+h5KI3lSZJOVGT02A5Gy+PU4IrCBq7SOetrLGB/nqrhzd/FuDnSt3Zo0JSoAK/2As+8V+q9Ep4mFMZF8zsdcOgYIMQ+P+f7SIOfrOSS0UrpXwa6E1QdW9N7GgEsFjiVx4qfV77XdUJX3hNcKC/HmbJdTpyq+bRM8C6XqbrkRdpQFnZksLn/9TWgapYh1TCYlKl8wEzrP1pTcp6Uh+3yp3MDTrRXl5e88meZuYT6wE+NepZzQr0nm5RgcvwlGmNqCaFf45+c/132F04c6L62TK/577gwPSzVFpbc6I76DLjEP+3tbyWf8i0OZFY7M+g67plNWtyx9qy3VsPoPU9tqBYW/8q44iYYkqAZyJ4V8sIoZ0RRNDvIm6ZrnRED1rVqCtfi6vTrGnKucI8cKe4nNKvopoxX1/PJ6Q9/NX8TZzS5mIAemITggfb15f8x+bB/qL9SmVwxlTPQPZQuhsfPOTJqfZrKeGf3ElKavWj0tmLIXwuKBk8LETHmCMg+LxpgulJ77d7kNlbsKyEr2jaUFgX2UcdUdGUoC9RN1hZnnfULm5E5pQXfAm32o6riUBTeVArJU47PvHj7vPikpSl6qz2E5tjEnK4ZAF60qViFP650FOQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6c22a22-1da8-4c48-8cee-08db63ca1868
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2023 00:33:04.6840
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hQB+35wplcs76cQxyPceeUcJQu5kuTDOKnTV17JB51/8JW/q6KhzwcBkfMs7OjTT9prUi6JiZOM8d8hwjh+oSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR10MB7543
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-02_18,2023-06-02_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 phishscore=0
 bulkscore=0 adultscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2306030003
X-Proofpoint-ORIG-GUID: r3lJDLGp62mSp2ktWzNBigvdaNynaYG7
X-Proofpoint-GUID: r3lJDLGp62mSp2ktWzNBigvdaNynaYG7
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> On Jun 2, 2023, at 6:18 PM, Tom Talpey <tom@talpey.com> wrote:
>=20
> On 6/2/2023 3:24 PM, Chuck Lever wrote:
>> From: Chuck Lever <chuck.lever@oracle.com>
>> We would like to enable the use of siw on top of a VPN that is
>> constructed and managed via a tun device. That hasn't worked up
>> until now because ARPHRD_NONE devices (such as tun devices) have
>> no GID for the RDMA/core to look up.
>> But it turns out that the egress device has already been picked for
>> us. addr_handler() just has to do the right thing with it.
>> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
>> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
>> ---
>>  drivers/infiniband/core/cma.c |    4 ++++
>>  1 file changed, 4 insertions(+)
>> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma=
.c
>> index 56e568fcd32b..3351dc5afa17 100644
>> --- a/drivers/infiniband/core/cma.c
>> +++ b/drivers/infiniband/core/cma.c
>> @@ -704,11 +704,15 @@ cma_validate_port(struct ib_device *device, u32 po=
rt,
>>   ndev =3D dev_get_by_index(dev_addr->net, bound_if_index);
>>   if (!ndev)
>>   return ERR_PTR(-ENODEV);
>> + } else if (dev_type =3D=3D ARPHRD_NONE) {
>> + sgid_attr =3D rdma_get_gid_attr(device, port, 0);
>> + goto out;
>>   } else {
>>   gid_type =3D IB_GID_TYPE_IB;
>>   }
>>     sgid_attr =3D rdma_find_gid_by_port(device, gid, gid_type, port, nde=
v);
>> +out:
>>   dev_put(ndev);
>>   return sgid_attr;
>>  }
>=20
> I like it, but doesn't this test in siw_main.c also need to change?
>=20
> static struct siw_device *siw_device_create(struct net_device *netdev)
> {
> ...
> --> if (netdev->type !=3D ARPHRD_LOOPBACK && netdev->type !=3D ARPHRD_NON=
E) {
> addrconf_addr_eui48((unsigned char *)&base_dev->node_guid,
>    netdev->dev_addr);
> } else {
> /*
> * This device does not have a HW address,
> * but connection mangagement lib expects gid !=3D 0
> */
> size_t len =3D min_t(size_t, strlen(base_dev->name), 6);
> char addr[6] =3D { };
>=20
> memcpy(addr, base_dev->name, len);
> addrconf_addr_eui48((unsigned char *)&base_dev->node_guid,
>    addr);
> }

I'm not sure that code does anything. The base_dev's name field
is actually not initialized at that point, so nothing is copied
here.

If you're asking whether siw needs to build a non-zero GID to
make the posted patch work, more testing is needed; but I don't
believe the GID has any relevance -- the egress ib_device is
selected based entirely on the source IP address in this case.


--
Chuck Lever



