Return-Path: <netdev+bounces-6387-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A4A0B716124
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 15:09:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 552A4281055
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 13:09:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D9BD1EA6E;
	Tue, 30 May 2023 13:09:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A5531DDD9
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 13:09:38 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 444AD114;
	Tue, 30 May 2023 06:09:30 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34U9xJ9S020980;
	Tue, 30 May 2023 13:09:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=pfENIUelBwc+P4+GJ+4sVW76JJ8hbUxQXHjvfArqsuA=;
 b=PsH+ozH53OitVTaG6HJBFaHSsSAVHjYpirYoUXQCEZps5RZDnyr2ffAJOWply7CcO42o
 Fuvm2rPVY2POEjCLUUQ2RQqwUdSRx6OEs9C/GLyOPw3ZzLfhQ9YLK/g5UMpwVXrh3BMJ
 6XaCs4YmGTE94YuTMWVa6o+KZip57Opy0W0Xw4LaTslLwwy8JP6UqtjOgwHXbYmERTcB
 d5oT9/XJ5Myl/6Lckpnuc/rOzMbOZo1UUj5lrrYOCmEl1E+BH8kYt+HrlXajGbk/5Rj/
 b4iOiBUgldOw+WgNwzL+fTOhe2bFHNJqQ8ZRxMiE1QYvf6wrC7hi+Ry1y8iDKTNs9MrZ 5w== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qvhmjjmv5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 May 2023 13:09:17 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34UBDpwX026089;
	Tue, 30 May 2023 13:09:16 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2177.outbound.protection.outlook.com [104.47.73.177])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qu8aabae6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 May 2023 13:09:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PW8V+4fyDh28gIW/qqZeDKb8wjAGybsxLfpRWIuDSPTHMadbX4H2MnMUs6mJvm/HyCh1f1twzbEkp9CftJ6Ctte87UqVkTxG4debw2P4eJozk1Mt9KP8Kml7xnS/4nm+se59bkhcd2odYE4bM3naG5DdGFzZkjxtKae2eRd5vIsPqLQG2A0jSXNm0BVB/uy68VYKOCxAbPLJH3+O7ktnrFOwNT36Zcw74i7TQ13YMVhROabXDYsqN2uPUJstJX21oVQbReVnsJ21iqTKdX4QoYbc5a7qEZOEBXhwte3icpKJ/Mbk22Zje0KXcAQvwqUaISaCua8YIxxYbf7O0+lc1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pfENIUelBwc+P4+GJ+4sVW76JJ8hbUxQXHjvfArqsuA=;
 b=OLNtJ78Nh56baf4adYmXf+eoFTeOy4yXt1ZSqfk+ZZdQYxdJdylqny/3qQMUxW3gIcdOHSvtrTpR7ty22/epDhgTar2xwh7DI1Xirs47Qlf1ytUBn5vcVXUeu07tlQpcuz21Y5SL23Q5yXCNKJfkVECZf5nAxCg4mGNsSd5tlvFlBQjmbyr1HhpWKf8/5YPD2LpQarRFBeVF0tRxl6EqS2IjObOTitzM3H+pjOysB1nRAVdrjgFdwZpNJ4Bn0qZRx7gZ8Cb2/7xtNrZ5xbioBQv+wekqCtuHcHbJf1rbB9vx3pbOuO+WuOdrXNQsYvgN+aiVS0FfTYmT0NyDl7z8Ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pfENIUelBwc+P4+GJ+4sVW76JJ8hbUxQXHjvfArqsuA=;
 b=JOwlZD0+88bd6nDR/GzpJ4fV5NQ4sdMjVBhsJG2oZ+pDY3J6yRxr6Ukn5AyUiPvK3p6i4Ky/2ctfr4/0vKgGOS92MMcWwLKiZ1mdm6taCqdDGrkWSe6/n4z5H0w91LYO/QiFrWF4NMMBsRrI1ZTCiIxGQTGfc54jhqBfQMXg8lo=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by DS7PR10MB5325.namprd10.prod.outlook.com (2603:10b6:5:3a1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 13:09:13 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db%5]) with mapi id 15.20.6455.020; Tue, 30 May 2023
 13:09:13 +0000
From: Chuck Lever III <chuck.lever@oracle.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: Eli Cohen <elic@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
        Saeed
 Mahameed <saeedm@nvidia.com>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        "open
 list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Subject: Re: system hang on start-up (mlx5?)
Thread-Topic: system hang on start-up (mlx5?)
Thread-Index: 
 AQHZfVsR2ZsLRCph30aJIrQ6PtNPGa9IF9MAgAB9OQCAASStgIAAwYyAgAPUTgCAIGXVgIADNpOAgAEJHQA=
Date: Tue, 30 May 2023 13:09:13 +0000
Message-ID: <0C0389AD-5DB9-42A8-993C-2C9DEDC958AC@oracle.com>
References: <A1E5B427-897B-409E-B8E3-E417678E81F6@oracle.com>
 <DM8PR12MB54003FBFCABCCB37EE807B45AB6C9@DM8PR12MB5400.namprd12.prod.outlook.com>
 <91176545-61D2-44BF-B736-513B78728DC7@oracle.com>
 <20230504072953.GP525452@unreal>
 <46EB453C-3CEB-43E8-BEE5-CD788162A3C9@oracle.com>
 <DM8PR12MB54001D6A1C81673284074B37AB709@DM8PR12MB5400.namprd12.prod.outlook.com>
 <A54A0032-C066-4243-AD76-1E4D93AD9864@oracle.com> <875y8altrq.ffs@tglx>
In-Reply-To: <875y8altrq.ffs@tglx>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.600.7)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|DS7PR10MB5325:EE_
x-ms-office365-filtering-correlation-id: a5a7bdde-3da2-4417-7222-08db610f1089
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 mDbkWB1nY+dwfxdB3t/Y1gr5pU2jIE+tym4d/xz+Zhwn71u9Aa61mFr2WBkh1FxCpNYKQSM7v6K+XLxJSipusf0bFF9ERUXslwOWTPwFTA2heX/u31Ns7vNtBluSQX4fWnN/bFT9BI7KGBhSREBE33d6CrfXF+0zPtwwWn41TBtd0/rwVPeFuSuL5RjNvYne7dVUxMxB1fTKNYrY9Fv/VXCxAmaJfCd6mBhWaB2ZSupd7Y2VrIwNKwRo01ghLJH1D3FnMYt4Rp2DcMnU/sC/0Z5K4AYAKW36t8Xajb3gXuJmatqaO03XsnKMXEQHiwX11gfYXPrVQTrJgWul2GVlaJGL+NUo6yvDfnJLC+rk4bH74vOjOKBaUsYoQJCaMP95tk41uPhLg4eY/KGpBPVjGvJlBL3Wa0Nt7OBIlqC6IWusJJdFP9t8jq9e3YUNe+HGj4j0161JfwnEnD46LgQ/qtbmudlPAqnv5sIIvpSuePMHZ7FJkyFPO6xvKKBTtNw8QzyUhifWrHzQfGL8D6F8lWeaeGFiFU3jxVWPhCQ9REkNffcM+yV78M76Mwrq+6sAmP38kZzgiCPB+yq93VvY1roSYChaJ1rbO4B/D0s+dA4syTINhlyjln708izxvc4bwBy2d9LP+MNN9srKHSsMEg==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(346002)(396003)(376002)(39860400002)(451199021)(6486002)(41300700001)(86362001)(6916009)(316002)(4326008)(71200400001)(33656002)(38070700005)(76116006)(66446008)(66476007)(64756008)(66556008)(91956017)(66946007)(36756003)(2906002)(186003)(2616005)(5660300002)(54906003)(122000001)(8676002)(8936002)(83380400001)(6506007)(53546011)(6512007)(26005)(478600001)(38100700002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?7QFs0yr9jDw4iUAzJoui7p72rnA3//2Bc+zedrordx2fFQ5rSYYAkieePG8c?=
 =?us-ascii?Q?T0WG58UI2p/eXMZ1Xdx+f8rba3edFPjPq+W3eldXdk/bV/mBnbDRDiCsY8aB?=
 =?us-ascii?Q?h6Nu1ATyRRzAz4DtAQ2WEIho/1lF2lV2SMrpkdtwLvKlEaQ8AzZWaM4O8DSL?=
 =?us-ascii?Q?bQp0NKiE24CnphhUqze7+94NI+bRwe8xR0Opz+N/22cqkKEnz6/Ajs0iD1Yt?=
 =?us-ascii?Q?1uQ52J5A4HockoxQuYmcIvAsZjd6B47TUlY1oP/rAvuuvdXw+03HvEZ3ZNBj?=
 =?us-ascii?Q?OnxcluhioaPPH/1zzDVXjZall0UCy3mm9GQ0CH5RJkMiZVAkpeOUIr7Kdc6t?=
 =?us-ascii?Q?wVR1PZVYDYo4LfbrVIBMQ/Tp5U71QVed6AwROkOdjcV6WRzMjRk+jZhwRkJT?=
 =?us-ascii?Q?xXlbOBWaXv152uQKxw1rdsvFyfow6LsIsIvFa0TIMsKwUdYAGsv9qCkPvu/k?=
 =?us-ascii?Q?8U8XjYYgeW0QaNeovwz6Sq3YbTqdl9Qvm/diZRELuZnAiLpGFiZ+Dd88OtBV?=
 =?us-ascii?Q?if55FT92TSdZdDf9vN5w+HfA78VSIgFzGhbfBE8uJks9KJxHAlh4gbrM67ly?=
 =?us-ascii?Q?WlFPFe0qvQ0eu0Gx7jp1nKMvSz7urbyFz2sn267MTpLO272YKRFbdXwDuYd7?=
 =?us-ascii?Q?pHh+zrXetrSq7yQ1t0QnLQiFd/nRc68uDTrHFUEG0Fos7t3GBZj/Rz+jW6yZ?=
 =?us-ascii?Q?WldAUUVhKPvURTZS4KzvHJY70evUy02yMebmaaEK3/Mi2qCv+styfJLTOXI8?=
 =?us-ascii?Q?bvPMTFWr+Iu7TIAm5yuYUFMXxTB/6jNirPXIDIhsdq6Y/M+E9vMt07Dug+/O?=
 =?us-ascii?Q?vKv7mRDjuXYni2tIvYxVJLz4a6DOaglekfys9JS125n9OhGpaIBLiPWReKBo?=
 =?us-ascii?Q?aGeZHvS8/gNm18Fx2Ey1prI/RmfjruYPxAUmJnzmVopcK+x1vYbT+2EzS4nH?=
 =?us-ascii?Q?jGxfSn4d54aukL0xWksPVt1oS/aXlNT8wXW/eLcJIOXtMrdvOvYE07znWGl7?=
 =?us-ascii?Q?nvmO5SOIzqdzpz9ads7o504dJTlDfiboYv0g2lnAlqlePbL8V5DiN6izsJqQ?=
 =?us-ascii?Q?MzydHuOsZsZVSL/6efWS10FHjSs0PzzptYJDV3+EuCgj9+4WC0rega/YcQqJ?=
 =?us-ascii?Q?3hzP+Ip4RfWjYIpnn9WQAsdBB9UjWSkcgHlZ7gDJLJ1WQxI115GsOZb5pHn2?=
 =?us-ascii?Q?o4884amYWjiwIY04v8f4IbvE/+4vuV7MbcSkNt8XQzdq/nXlwUN28BV47n+t?=
 =?us-ascii?Q?z/q6AfrITWpMHW4IU5XAMNNFrYJYmd2KTIL7OGwHjO3Q0il9MzTMWDb8DaPi?=
 =?us-ascii?Q?jMU1pb/FbaepL7PBSpU79FxigMM6k9fz1oH2IFJoy5WMdLHk8w6AYp5LdMxl?=
 =?us-ascii?Q?HenOAPbktuorSwe0oioTrbP0Aw+zSAXu6oMddjI6B4iBO3njlttuDnHDRD/E?=
 =?us-ascii?Q?Mlpgdn7cWUz/GQDVO/ZUKfVGNdI3/3PTD7gvD2srsCCPq85992fSrLEz5KR8?=
 =?us-ascii?Q?6o1LJyjQSLzWudzO1ew4ypxzYSVbyYTE2hV4CNWKtGFyH+FepmTpGJbuYkHP?=
 =?us-ascii?Q?B1s87kfKty4VoKAWyLKEbNHgGeG4smS29Zzcu9OzkN8oAdQvFOTyjfNpkt4k?=
 =?us-ascii?Q?fw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FC3CBCD97880B54281F1B73DFE448B19@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	1ozDl3jDKsgbI02cRudvmYGuCsI3C44e53eXkIhcFrpwNtdVjiszLW4X8Ve+rpyxNdY3d0lqocuFvwX3zmUYiMO0eMRm5AZFhtovpPlrN0bjg67bNYF31hQLoB9Vr9cf4+5eS9Nnn4HXIRS7IbnemzX9ja5EaOU+72QBLzGOM0xeFjYSps7DhnBIuQR9GdgtMOZJIT1aIUcj4hYqOfxo1rbZDP7Fpl/WPc+dh9UqAw67K5vlofkrYWEQ11O5unCJ5KtWCrdmXHbj0BPblxQLgK8Qe2HZk7C4dP4ib1++1DDCazsegARPhn6rgv8uQM0ynW6t7gssuPInr+ieE5yKTdfyheHYPtteu9pADTG6qnTApXWyDAiCp2DSkv2vwozcP3F/seIiSI4mHPdTXMyBM2VV0RCGpEw6rfI8MrXx7tQCznGw7BVcy4m9xB+2zqPdI3aa72wW4VSM7502xop65TZbnmWqt4H1OaeeXshY7Kdya2c0RKwro0HjWY1DIiRbPyd96pC+tp0Clx8cg/sTuwfcrSbxq3aYC9d0CO+MSdkuKfotP6ri6UZmy0WfnOqIb43GmhwD1aJMTq76iqygvbDpVemix+ef9OO9w4SGM0k/VChddZ9oUMK+JfZ5QI2Bst+9SsHkcIKW/PuNOlumBTDYbqgBPPehYj5pM7uyl/i/L7qRVMSY7HTfj1F0GAj14Z+Gb+WYTBWyYwXYrL2a/FjIHJDquR/X6G/HAgSVMqY1irM3fstreMUoMIXPFlBkf5S4SgWH9/OeE5PniibD0GdWofpz3Al7Huzmbo615wdvicLoTNZNx2X2geTqE9szycgAG1qcO454rz3PNdNv283mSg2pqHlZH79kuPwlNxM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5a7bdde-3da2-4417-7222-08db610f1089
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2023 13:09:13.2815
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BKAUVZDmXtWbdbBnBFNU59BaVmFtsjtYrMNc/S1i+4+q59iQm4sjaryMe4R6N5jGevKB8gUINUeFWeLmDvefUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5325
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-30_09,2023-05-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305300107
X-Proofpoint-ORIG-GUID: CZhery2VnCgqO4pQRIxJ1YkXhugcg0Zc
X-Proofpoint-GUID: CZhery2VnCgqO4pQRIxJ1YkXhugcg0Zc
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> On May 29, 2023, at 5:20 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>=20
> On Sat, May 27 2023 at 20:16, Chuck Lever, III wrote:
>>> On May 7, 2023, at 1:31 AM, Eli Cohen <elic@nvidia.com> wrote:
>> I can boot the system with mlx5_core deny-listed. I log in, remove
>> mlx5_core from the deny list, and then "modprobe mlx5_core" to
>> reproduce the issue while the system is running.
>>=20
>> May 27 15:47:45 manet.1015granger.net kernel: mlx5_core 0000:81:00.0: fi=
rmware version: 16.35.2000
>> May 27 15:47:45 manet.1015granger.net kernel: mlx5_core 0000:81:00.0: 12=
6.016 Gb/s available PCIe bandwidth (8.0 GT/s PCIe x16 link)
>> May 27 15:47:46 manet.1015granger.net kernel: mlx5_irq_alloc: pool=3Dfff=
f9a3718e56180 i=3D0 af_desc=3Dffffb6c88493fc90
>> May 27 15:47:46 manet.1015granger.net kernel: matrix_alloc_area: m->scra=
tch_map=3Dffff9a33801990b0 cm->managed_map=3Dffff9a3aefcf0f80 m->system_map=
=3Dffff9a33801990d0 end=3D236
>> May 27 15:47:46 manet.1015granger.net kernel: matrix_alloc_area: m->scra=
tch_map=3Dffff9a33801990b0 cm->alloc_map=3Dffff9a3aefcf0f60 end=3D236
>> May 27 15:47:46 manet.1015granger.net kernel: mlx5_core 0000:81:00.0: Po=
rt module event: module 0, Cable plugged
>> May 27 15:47:46 manet.1015granger.net kernel: mlx5_irq_alloc: pool=3Dfff=
f9a3718e56180 i=3D1 af_desc=3Dffffb6c88493fc60
>> May 27 15:47:46 manet.1015granger.net kernel: mlx5_core 0000:81:00.0: ml=
x5_pcie_event:301:(pid 10): PCIe slot advertised sufficient power (27W).
>> May 27 15:47:46 manet.1015granger.net kernel: matrix_alloc_area: m->scra=
tch_map=3Dffff9a33801990b0 cm->managed_map=3Dffff9a36efcf0f80 m->system_map=
=3Dffff9a33801990d0 end=3D236
>> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m->scra=
tch_map=3Dffff9a33801990b0 cm->alloc_map=3Dffff9a36efcf0f60 end=3D236
>> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m->scra=
tch_map=3Dffff9a33801990b0 cm->managed_map=3Dffff9a36efd30f80 m->system_map=
=3Dffff9a33801990d0 end=3D236
>> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m->scra=
tch_map=3Dffff9a33801990b0 cm->alloc_map=3Dffff9a36efd30f60 end=3D236
>> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m->scra=
tch_map=3Dffff9a33801990b0 cm->managed_map=3Dffff9a3aefc30f80 m->system_map=
=3Dffff9a33801990d0 end=3D236
>> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m->scra=
tch_map=3Dffff9a33801990b0 cm->alloc_map=3Dffff9a3aefc30f60 end=3D236
>> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m->scra=
tch_map=3Dffff9a33801990b0 cm->managed_map=3Dffff9a3aefc70f80 m->system_map=
=3Dffff9a33801990d0 end=3D236
>> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m->scra=
tch_map=3Dffff9a33801990b0 cm->alloc_map=3Dffff9a3aefc70f60 end=3D236
>> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m->scra=
tch_map=3Dffff9a33801990b0 cm->managed_map=3Dffff9a3aefd30f80 m->system_map=
=3Dffff9a33801990d0 end=3D236
>> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m->scra=
tch_map=3Dffff9a33801990b0 cm->alloc_map=3Dffff9a3aefd30f60 end=3D236
>> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m->scra=
tch_map=3Dffff9a33801990b0 cm->managed_map=3Dffff9a3aefd70f80 m->system_map=
=3Dffff9a33801990d0 end=3D236
>> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m->scra=
tch_map=3Dffff9a33801990b0 cm->alloc_map=3Dffff9a3aefd70f60 end=3D236
>> May 27 15:47:47 manet.1015granger.net kernel: matrix_alloc_area: m->scra=
tch_map=3Dffff9a33801990b0 cm->managed_map=3Dffffffffb9ef3f80 m->system_map=
=3Dffff9a33801990d0 end=3D236
>> May 27 15:47:47 manet.1015granger.net kernel: BUG: unable to handle page=
 fault for address: ffffffffb9ef3f80
>>=20
>> ###
>>=20
>> The fault address is the cm->managed_map for one of the CPUs.
>=20
> That does not make any sense at all. The irq matrix is initialized via:
>=20
> irq_alloc_matrix()
>  m =3D kzalloc(sizeof(matric);
>  m->maps =3D alloc_percpu(*m->maps);
>=20
> So how is any per CPU map which got allocated there supposed to be
> invalid (not mapped):
>=20
>> May 27 15:47:47 manet.1015granger.net kernel: BUG: unable to handle page=
 fault for address: ffffffffb9ef3f80
>> May 27 15:47:47 manet.1015granger.net kernel: #PF: supervisor read acces=
s in kernel mode
>> May 27 15:47:47 manet.1015granger.net kernel: #PF: error_code(0x0000) - =
not-present page
>> May 27 15:47:47 manet.1015granger.net kernel: PGD 54ec19067 P4D 54ec1906=
7 PUD 54ec1a063 PMD 482b83063 PTE 800ffffab110c062
>=20
> But if you look at the address: 0xffffffffb9ef3f80
>=20
> That one is bogus:
>=20
>     managed_map=3Dffff9a36efcf0f80
>     managed_map=3Dffff9a36efd30f80
>     managed_map=3Dffff9a3aefc30f80
>     managed_map=3Dffff9a3aefc70f80
>     managed_map=3Dffff9a3aefd30f80
>     managed_map=3Dffff9a3aefd70f80
>     managed_map=3Dffffffffb9ef3f80
>=20
> Can you spot the fail?
>=20
> The first six are in the direct map and the last one is in module map,
> which makes no sense at all.

Indeed. The reason for that is that the affinity mask has bits
set for CPU IDs that are not present on my system.

After bbac70c74183 ("net/mlx5: Use newer affinity descriptor")
that mask is set up like this:

 struct mlx5_irq *mlx5_ctrl_irq_request(struct mlx5_core_dev *dev)
 {
        struct mlx5_irq_pool *pool =3D ctrl_irq_pool_get(dev);
-       cpumask_var_t req_mask;
+       struct irq_affinity_desc af_desc;
        struct mlx5_irq *irq;
-       if (!zalloc_cpumask_var(&req_mask, GFP_KERNEL))
-               return ERR_PTR(-ENOMEM);
-       cpumask_copy(req_mask, cpu_online_mask);
+       cpumask_copy(&af_desc.mask, cpu_online_mask);
+       af_desc.is_managed =3D false;

Which normally works as you would expect. But for some historical
reason, I have CONFIG_NR_CPUS=3D32 on my system, and the
cpumask_copy() misbehaves.

If I correct mlx5_ctrl_irq_request() to clear @af_desc before the
copy, this crash goes away. But mlx5_core crashes during a later
part of its init, in cpu_rmap_update(). cpu_rmap_update() does
exactly the same thing (for_each_cpu() on an affinity mask created
by copying), and crashes in a very similar fashion.

If I set CONFIG_NR_CPUS to a larger value, like 512, the problem
vanishes entirely, and "modprobe mlx5_core" works as expected.

Thus I think the problem is with cpumask_copy() or for_each_cpu()
when NR_CPUS is a small value (the default is 8192).


> Can you please apply the debug patch below and provide the output?
>=20
> Thanks,
>=20
>        tglx
> ---
> --- a/kernel/irq/matrix.c
> +++ b/kernel/irq/matrix.c
> @@ -51,6 +51,7 @@ struct irq_matrix {
>   unsigned int alloc_end)
> {
> struct irq_matrix *m;
> + unsigned int cpu;
>=20
> if (matrix_bits > IRQ_MATRIX_BITS)
> return NULL;
> @@ -68,6 +69,8 @@ struct irq_matrix {
> kfree(m);
> return NULL;
> }
> + for_each_possible_cpu(cpu)
> + pr_info("ALLOC: CPU%03u: %016lx\n", cpu, (unsigned long)per_cpu_ptr(m->=
maps, cpu));
> return m;
> }
>=20
> @@ -215,6 +218,8 @@ int irq_matrix_reserve_managed(struct ir
> struct cpumap *cm =3D per_cpu_ptr(m->maps, cpu);
> unsigned int bit;
>=20
> + pr_info("RESERVE MANAGED: CPU%03u: %016lx\n", cpu, (unsigned long)cm);
> +
> bit =3D matrix_alloc_area(m, cm, 1, true);
> if (bit >=3D m->alloc_end)
> goto cleanup;

--
Chuck Lever



