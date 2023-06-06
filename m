Return-Path: <netdev+bounces-8617-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E9F36724DD6
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 22:15:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A1BC028104C
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 20:15:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 904F32721C;
	Tue,  6 Jun 2023 20:15:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7918C22E46
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 20:15:49 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADF319E;
	Tue,  6 Jun 2023 13:15:47 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 356IZ0JP032718;
	Tue, 6 Jun 2023 20:15:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=vInz2eaVQ7XDQ94CS18ooU04FOJIksJEopPI3MU5CQM=;
 b=z5tgmXZv1NeCMTRUHhUnmgCfQ1VSRozceC39nrbrKFCChganpDM02AcsJ0NhFerQvvrq
 WhD5Prd9MvZvTa9BuLEwmrxDVXR+TUPUPKlU1Ri1adJvEI5RSIVFI2qyIZerKLXRyKDE
 PP6RIhH2uGgrdN8Sc+RdGRusqOJUKX5RCTW3eKubFAzYknBODGwQeRu/DdViQD2QVkhu
 upED1aAEWvLSY8WKJBwS6vJc09roYfpcPG5LdqHVg6elA7ySsZqlfVhZXvQmkhNXHAIT
 bRle6LXW3+A7LZowhLOKCL4VgQb3Aj2NUFvMFXysFU3cdkuToOd5tLc+GrvtYJcIV2I3 Dw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r2a6r86bc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jun 2023 20:15:39 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 356IY9Q5010507;
	Tue, 6 Jun 2023 20:15:39 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3r2a6pkbfy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jun 2023 20:15:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aeVAsaDgvyCmyx1pvSzL86cFm6e4k1X1UfaL19jB8sh4Uce28PjTkZoIWQx5nztQK3vAbMvd6N13LKKkTgAmPASgaNNAiQWgD2nF/YUzrOPfTApkD6sJMKHGk1X9A7rxaqo1f0rg8zpAskaMgNetVq6ZSX0t1fOk0RbjEK3KN/wfIU4ek9smFgUNWZA0vZ2gBpanyjU803tPk7nrpyfyRNUnfCvxuebDrXyBbP2RDe1F+5Zk8sr6TNfSF+HtVdaIW877SXFyphC545PFiE88wAvmtLhtgR9Nojg8qrobPthp+qn9gogJJqoALgfLTnrHrl7oe1K9P8XklDplsIVaAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vInz2eaVQ7XDQ94CS18ooU04FOJIksJEopPI3MU5CQM=;
 b=mgZJlpaNzCAZhjpS2hn2BPSYnPG+JuTRVniOTIf3oaXFhLfIaM0rBQvu2ChhPU78NX3bfjo/nZgdyMfRTaaxl7yDGdCw5h22OQzlIIz8o6IuXcN+UFaODgbpMPIVZq4i0ce3TbZsNhAE/4R8VMlV80xgjiLKeo3JCmbgOI6KCfCnbKH9euP62aAdSHC2ch2bKTTr1uEs6Vc+X/yrPNo/2UxnKnZ9T+LbcPSv935xgisLtydkwPUiwGaVhGkhlRlHvA4xTtKluGmHnrYK6gAE8oz/cFhHwgU2UqZ0mdM5l1w3UMsIxjtYVIUNMaevOrDvd0xBkcAilz6rbkXORSc2fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vInz2eaVQ7XDQ94CS18ooU04FOJIksJEopPI3MU5CQM=;
 b=Epawzts+SFN+7XfUdJqrHB/YGc5FhyTtzUqrJa4d9RTOkaNdyVmndmTCy+RICAoqLJyKgZtCC0yb4TTDrMlB/VocSNlBdVIkOGVALppQ9305P2h/1zoFJ7NiQqOQU4CDYgPc5vQH8PiJuqHqx5LWf09fcAZvaqklZhMZEBmKiJ0=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by MW6PR10MB7688.namprd10.prod.outlook.com (2603:10b6:303:246::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Tue, 6 Jun
 2023 20:15:37 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db%5]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 20:15:37 +0000
From: Chuck Lever III <chuck.lever@oracle.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: Chuck Lever <cel@kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>,
        Bernard Metzler <BMT@zurich.ibm.com>, Tom Talpey <tom@talpey.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH RFC] RDMA/core: Handle ARPHRD_NONE devices
Thread-Topic: [PATCH RFC] RDMA/core: Handle ARPHRD_NONE devices
Thread-Index: AQHZlYfl1VISa1yiqkOAQn9cpjE/26998bCAgABKgwA=
Date: Tue, 6 Jun 2023 20:15:36 +0000
Message-ID: <325C9DBC-5474-427C-9431-19A59D64F28D@oracle.com>
References: 
 <168573386075.5660.5037682341906748826.stgit@oracle-102.nfsv4bat.org>
 <ZH9VXSUeOHFnvalg@nvidia.com>
In-Reply-To: <ZH9VXSUeOHFnvalg@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.600.7)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|MW6PR10MB7688:EE_
x-ms-office365-filtering-correlation-id: 330db874-fdd5-4a8e-9a2a-08db66caca67
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 gHt8EaYRcVBATr9gB26YoCeqC//twQeFwx8aiJgpFQJ2aZj6PR0QKqensgXjbrxBq+7W2AIvwjq6HtR8O+7/xog1p10seYrB0Hj6cH9vTwViz14K0yyJlcvb3diKqgMLG9IkWkwARNBkcNRfxF94uy5N5wH/FfHhcv0870hXj1IhqvkZK03zF+FwySe24rK6wIpgHsO9uipkvKl56WKpYsrmqEwTxP7UVTKWipXjXiG8Po1bqbZG387Sjvmn6gN13wRVum5hNz2QdK6PAQxVnpKHwxt92URboc9zhBfQHL4/v6xEDHQfxNL1UjCbO4gRDiTI8GAWgDiDfYClz7RrnkIEFetJx4T0xGIS9ORBJSsP7ZrYDkxq9rTcFU3C6eYf93wrcju95oR80vmF4vN+cTWLt2eDY36BaSTXpzNEh1vRPv+zQtAjQ/x074DWMKDcOkgvk8mHA8vSJ0TxUVJyeFQW/PHYoFQXDCZbCvOWG+ET2pLsAD6dkpRtg/VW0EalfsXuiJBwEewb4xaIgF7w0pWbbz8RQ0/ow3wVC5YGrfzAJg4YE6o6yIWkQMjlHYVyOdzziBeJGeTAFPrK/k/rMRt2waRUF4UihgEpxO1BumB9IuprchISpNN2WT9WF1OOyLvNnL6JkxkeLhDg8ETPQQ==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(136003)(346002)(366004)(376002)(451199021)(83380400001)(2906002)(2616005)(38070700005)(36756003)(86362001)(33656002)(38100700002)(122000001)(316002)(41300700001)(5660300002)(8936002)(186003)(8676002)(54906003)(6486002)(478600001)(71200400001)(64756008)(66556008)(6916009)(66446008)(4326008)(66476007)(6506007)(76116006)(53546011)(6512007)(26005)(91956017)(66946007)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?+313Ay0v/FualaHvPqhlagT0N+wseeWhSm63/Fw29J85H0yrAjkGpvcbqUl0?=
 =?us-ascii?Q?Y70p/lKNReh0w7aFbTVnpHHQqfMwNxEEM3RVdUHEc7jOu63E14ehhr12Kb0n?=
 =?us-ascii?Q?DyN+0eVYlreaomRgFRSVdO2P+7AgIXw6rvxumrrrGSKBR3QHsz4rOHHUrj1o?=
 =?us-ascii?Q?PxyoAgZqCRkqhtVwd3iwnCjKFoSBpVp0vAskYMxLbinaqw64mRWATNP+0GYM?=
 =?us-ascii?Q?xZxu94mW7YMzRs6grWBgMkeNdhTHwV8fNA8MwYr5p+5fAKthzONH0h1W/+ii?=
 =?us-ascii?Q?tlMi+mkyqB2GvIqe6YlKDhnbSD72U5U2wajp2LJ7jXfEhOZu7C4zqk0scSZf?=
 =?us-ascii?Q?/fSCGcr9yTJbcRXKWD/FAL+TbbWNcDMHdHcZMDQsH4Ql8p3lvXKD5jbIvua3?=
 =?us-ascii?Q?EFGhsbSqdcJTl+/ESdt0aCCS1CrKGFHkgZgPuaybyksZsKKrDEl8EOxGkiTf?=
 =?us-ascii?Q?ABuV09daN2cdaoEBdxz+lc+fJoinbBrakw2YXkGCnSo9rgorYyqC+L2zEpj6?=
 =?us-ascii?Q?6n+JIKVbP2Yn2/k2e5dTAS0fF1JPU3Nc1cghWLJm1I3F1k+9FsTsU9WH5OEV?=
 =?us-ascii?Q?cwzTJ6WYp/curWyvOO6HRtJRwGMlDy24Ifgd9NG48JteCE0Tjq2SQf9/wA60?=
 =?us-ascii?Q?r1dMKsmFDN/xK9jhYrYLF4+RG2cUEs6FpST1LqRQ5Y8Yy+Bv7HAWNWGNoLX2?=
 =?us-ascii?Q?OFunDrRFC1u6Vyi+JaXPSlF9JK5MP0qwER5dhmIu3NjR4HVXcBWLpi0qdnyC?=
 =?us-ascii?Q?6Uoo4MEqoen33HvSi+3rF7UDQIOMrcJO3ClAsDxxGyoP2aMzF0udfXm6C/VS?=
 =?us-ascii?Q?75QwHD2O1MUQ1ARb+CjS6nXPjic92jrJyD+xBkmB5Oamz+k+LgzedvK3o9sU?=
 =?us-ascii?Q?CYnTRT5fhST0JsojLsfqdhYdTqcGpOTCyfm5PT6ODM3FaWL4TZ05twvpJmwz?=
 =?us-ascii?Q?jl+6iDuWIzmpUx0o8VtcOWxOrZo+Ix3UYadlzF0G0BT8MaPt/OmpACRSBZTK?=
 =?us-ascii?Q?buxm4XjiC+0OBhWnRMLojVpIubhzylXTYG7KjXybKhxxPklvnOCetSjI1b+q?=
 =?us-ascii?Q?N5lF+CMwqCbH3Ya5KlQqyewpDAe3CugWDWXxJMFcrUpbEwqnd3eeF70lahJA?=
 =?us-ascii?Q?tGEe6lKfWEhSks38vS4bMmL+kmb2/VD2UXcIRzLG0QQZ3IqmOfQ2+vo6+DEQ?=
 =?us-ascii?Q?6vlxBsjlg6R2Jc5V9GfDUa1yaQHE8UWram8oyKy9TE5Ox3OPmN2amP3KaV6q?=
 =?us-ascii?Q?IaN5vLIYOpd+S8Mc2luxOdluhm+TlDtC5hkjeYxd2Xk4HG5MXhXf7GVrRVvu?=
 =?us-ascii?Q?qRnfg9wXsF0A2n6y73wgqotLD+/2xXCvP63skVKjFJyeCGmqAl+p1WfOj3u9?=
 =?us-ascii?Q?GaId0vsmLvDpsbBFP4G5+xHcShDLLVIxXv4WSRLdK4CHTQG9Py2nnnUfv8hr?=
 =?us-ascii?Q?nUgr1QcVaqlKbUx3xn6eLBiBS1JuRzqFmvSJ0HLmEARlhm0ZyrhYr0P/sukP?=
 =?us-ascii?Q?9eHJdRY4+5/A+0F/IJUap/tWIOIH9zbb9a/p7zh11A1mhwDBwUx3eqWZ/HSi?=
 =?us-ascii?Q?c80bWYgWzRCMaO1MHtvdTWNK5LxYm1O7qFI5a+a36CxGTDdY7jh1eyu2VIka?=
 =?us-ascii?Q?LA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <C8B6B2F210DDD148B9F4B721654E4CC9@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	5j7yaR5xBLk49UoOBbQt6Mf3qM9NWPumuUJAoGY+OgjJ8cslSKp79Yv8zwzNBK1TpJJppOyhEOf1nYjkeqz+zvw1Gy1CsWX+rQmFpgTVTvTdW0rtaFENoZ/KWDUCY2VQXKcOVwW+jb6St0tBQ9Yh2o4fJFx2/QVj2Ym3VDPuvgY/jr1jjsjEnSWrqgbKCnNTqezrlz6JiVglBoyRZg+mOzmSVTmVCnVUDrRBFpzoHIOChqgcPV3uxZ/nrBpF2vl4m1O3Q6X9t4Xqx7CtFfzFWHJ5kYaejf5f4dwuO9UQ/xnwEkna43f9Mq4RVxUCrnL0Ab5F2Jj3Rpb5XddwRpBRgutch7MkSAGYPzdJwZ1OJGQizdhHST9YYvdmC6TlSLENM6MKJIzyNEqg8Xr5tdIBg1d9zZNsxSZuTM/Lr6RVJ2SP2h+Q8NC7ifBBxPVdxskYM0y3VTKoNdjeU7OOGdr5f3wiGUlv8uEvInEHzoUKoMxMFmuw0ZuZtMJj+SeSk4Xn+1LwOL++RSnjsKa/6+MvZntT5sASYMnvoNxV94M1lXxH84OPIUtPJ6HaImAyU3W8vmBgIFl4DQJyt20RyD68WErvgEVDRNfJRg16oJlBnRYCSrolqWm1Z+WJGFYu7qNPAV+udCEC7dSZm+vKBNzjBH0ZqOcIv4d9L/aWx2Q89/IlCtlH1JJ0NE5HmcqwKxAPpJSg1BZf4k02jsvP0ZgJuAmrMxj+9cyihdsLf31wxsMsqy6xCum4m0lC1psfDghx5xbEGjNYmPU60ncWEHLG9tkgq+W72HYR8yNfmXPny8fcs+3x8bRxbdO0NO/+eHVUC5hma26CORMQFcTdapGQtcRYSHhwi/cWXxG6JewZlF40ehxf67rOBk2paRcQGbNZ
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 330db874-fdd5-4a8e-9a2a-08db66caca67
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2023 20:15:36.8227
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8YdImRDblCzsU/Dr11s4bsPemd97qmkaDFGP/mvxnNNhdqmFVc4pdKpMZ50lSg8MMKSrZUZ1a2kV7TuCLaKcXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR10MB7688
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-06_15,2023-06-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxscore=0 bulkscore=0 phishscore=0 mlxlogscore=999 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306060172
X-Proofpoint-ORIG-GUID: dnQg-NOCIt4nO-_Y5wK6N19iHRWs4L2T
X-Proofpoint-GUID: dnQg-NOCIt4nO-_Y5wK6N19iHRWs4L2T
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> On Jun 6, 2023, at 11:48 AM, Jason Gunthorpe <jgg@nvidia.com> wrote:
>=20
> On Fri, Jun 02, 2023 at 03:24:30PM -0400, Chuck Lever wrote:
>> From: Chuck Lever <chuck.lever@oracle.com>
>>=20
>> We would like to enable the use of siw on top of a VPN that is
>> constructed and managed via a tun device. That hasn't worked up
>> until now because ARPHRD_NONE devices (such as tun devices) have
>> no GID for the RDMA/core to look up.
>>=20
>> But it turns out that the egress device has already been picked for
>> us. addr_handler() just has to do the right thing with it.
>>=20
>> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
>> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
>> ---
>> drivers/infiniband/core/cma.c |    4 ++++
>> 1 file changed, 4 insertions(+)
>>=20
>> diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma=
.c
>> index 56e568fcd32b..3351dc5afa17 100644
>> --- a/drivers/infiniband/core/cma.c
>> +++ b/drivers/infiniband/core/cma.c
>> @@ -704,11 +704,15 @@ cma_validate_port(struct ib_device *device, u32 po=
rt,
>> ndev =3D dev_get_by_index(dev_addr->net, bound_if_index);
>> if (!ndev)
>> return ERR_PTR(-ENODEV);
>> + } else if (dev_type =3D=3D ARPHRD_NONE) {
>> + sgid_attr =3D rdma_get_gid_attr(device, port, 0);
>=20
> It seems believable, should it be locked to iwarp devices?
>=20
> More broadly, should iwarp devices just always do this and skip all
> the rest of it?
>=20
> I think it also has to check that the returned netdev in the sgid_attr
> matches the egress netdev selected?

Both @ndev and sgid_attr.ndev are NULL here. So I assume you want
the code to check, on return, that sgid_attr.device =3D=3D device?


--
Chuck Lever



