Return-Path: <netdev+bounces-6923-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D4EB8718AFA
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 22:20:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 89A4D281602
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 20:20:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E6463C0AB;
	Wed, 31 May 2023 20:20:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4886634CE2
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 20:20:22 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0549121;
	Wed, 31 May 2023 13:20:20 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34VKFo0J032515;
	Wed, 31 May 2023 20:19:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=0jngcTrmr097hEZDho5vy5MSdArnqJv2pckcz0w6BCA=;
 b=aj+VtvLKIfuVKNfWaD8KCOb+7pm/1p48pL0O1r4Qx79Qo+5pRzc7IWcAeZZmjA3qIUKq
 szwrBuW/H+oabi9I8xjRC3dVBU7BdAP8fuyEI5YaCOfJA9xsZUNMxUNFhxTCaR3V1+7L
 8VrLwCRVfH6zhRgJOUfV2QjjXyJYr+VGLRR60OozXUvyz7w9sTHh7fOo9cF3m0jTxiSb
 2SGUP2juf2OLSjxtNTloIoSgnCfZ+ZFuVa2D8HPEXfFtBU12D1Ha0mM4oD0SEsup/L1u
 +jKOghOZll+1bx5G4IPgfd2vy5UaDEXGD85VqDAAQNhocAcWeIpJkXkNfyJGZDJvINQ4 sA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qvhb96wae-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 May 2023 20:19:44 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34VJZYBU003696;
	Wed, 31 May 2023 20:19:43 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qv4ydsega-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 May 2023 20:19:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ctN/zlNa74oj4qhMcbj1x/Jrr7abX+K9Gjqc9iV9NSrIJwMQFvpD/0gkBxGrKBub7QYIcfWX4udK41ECpQuFRdfbql0dpSydGdl0zU9h9ggW7DB7eXcSbLqsPwrAD9/6xuU7oen3batIVqUJA0udSnEaWDITjSvLByuxbTiHDBz+jH86taHlIzg6OPZ4pRlOF0N8gYhxt+E/KHmL8UqeLpHNn2No8OCm3EUzXClCZ7+jknEuKUSLpcsZEw07ixYCl/EQjszc80ipgKayliSy6mutW9+9IL2rIYo670fY9eD9L3779lOmah2qKauQjcAVwdk97O1s4ZSz77uX1bsN8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0jngcTrmr097hEZDho5vy5MSdArnqJv2pckcz0w6BCA=;
 b=jLbTD4OyoE1lpAHwWrIiptrbER8qVdxW+tbyqPttT8HTfUgjFQirkxnWN9dGtblMcWvy5uC+H/SgBMwVSOsNIC5ER5KUXwTc3l0vQVh+r8nnLBMy2+SO2Pj/gBYsZ3fZLBLp0y+nyLW1m+iwIxNr6bcmOM7QcQ4/VfQRFynI94sjcyD0BiQXlP8SwPoruReb4bMvZBq82MCg9pqv7ghKNNWpAPNwi3BAsg4DGM39PT3Depfnfk7sk3xX9CWnbtzmVAlTPbPCpU/9pX0X1d4zBxqwoJZu/DJXGbvtafm9+jryIHwR0evfCktURXlVLM66nkfh1R8MQxTS/iwvcmjLgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0jngcTrmr097hEZDho5vy5MSdArnqJv2pckcz0w6BCA=;
 b=KEtwAjz/JXXKC4j6huNpPdO42BcNQNG5ze2Zj7snM2kkx0q7c8NmWYGVJU4jHahxxi60mD//qJsRs28LY3d/BqRxzCi3XjyGSA4q27yjTdWt1q426FcSp1Lq6g0Frzc3aXEuRxrVIFw3Yt28lF6a3dFpHWUjXscV0lc1AG2mzM4=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by SJ0PR10MB5631.namprd10.prod.outlook.com (2603:10b6:a03:3e1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.24; Wed, 31 May
 2023 20:19:40 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db%5]) with mapi id 15.20.6455.020; Wed, 31 May 2023
 20:19:40 +0000
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
Thread-Index: 
 AQHZf2hilDPMQchDT02kRjpEKJKB+69MGTWAgBw+lwCADI7zgIAAAeaAgAAQLYCAAALEgA==
Date: Wed, 31 May 2023 20:19:39 +0000
Message-ID: <AA2EDC2E-662F-47FC-AB5B-3EE09DEDAB58@oracle.com>
References: 
 <168330051600.5953.11366152375575299483.stgit@oracle-102.nfsv4bat.org>
 <168330138101.5953.12575990094340826016.stgit@oracle-102.nfsv4bat.org>
 <ZFVf+wzF6Px8nlVR@ziepe.ca> <7825F977-3F62-4AFC-92F2-233C5EAE01D3@oracle.com>
 <ZHeaVdsMUz8gDjEU@ziepe.ca> <B0D24A4F-8E82-4696-ACE1-453E45866DAC@oracle.com>
 <ZHepf6/z8ZxRPe+B@ziepe.ca>
In-Reply-To: <ZHepf6/z8ZxRPe+B@ziepe.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.600.7)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|SJ0PR10MB5631:EE_
x-ms-office365-filtering-correlation-id: 653cbde0-975b-4c5f-21dd-08db62145cd5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 uVA9gr56JKOMpvwIoaqpBsd686CGK2tNSWe1fWSEiaHqWDh7k8KP5l7Af37zneXckcS1Tlh40gReE6OdZsT34tjOclCoBjbbGbi3Xsfe+7vcBCiw+BGX01P8eTzBj9HcTfKnoRGFJo5RsFRu+g4K1/oZlGoVsufDp9hU/Tg+5Vxg+202itG+LoNWmrY5r5Dnzi/8MbAIjNcrv3HDdx77eGmf97Tb0Z6a0P158vrwb/A7obQ4pS2o8MK3br25Kv3EQUzkLrrqr6JWpbwZrNS8iNWy/Cpxw0onfY7lByNKr6i2s+FUfDaqQKS/zExdWeH7uKwrc0Qzso7KyvfP93RO+kJfO5PxfManUAeRtrvWvkgGK46ZrQV6KuHE4bQ3r4AaI6rDHa4akOGvpsR7aK1zP/811RTFK6V4HjZRYWu/XcOBwp8fe7qSjSd2ZI5+RUoF5QQgMbgYkLWJXpV/2vYvgdh29c6EKNqKteyXJJcKAa3yQgAgBlbcKpjhQFkdX7aT7leqYMy8DyxgexnRqPdjs6a4ZsHh1nXMKEQLPUMjFg3c2TMiHN2y/TFDKvTWb3X383X9BTKQI/zh2I2rOXONKfeDt1Jlcqy1RkOEVr5RdNRedxuW49LvjN+OVpQqA+fw7qFYcYtZLOjWcPaQ0oXCDMRePbDkhj0C2PwMxyYvMAT0Vmsq86QuP6Wd2zYQosp5EhBuQp9olPk57wf/pCutjtye29sm+j8PsU7lHZRyu9A=
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(136003)(396003)(346002)(376002)(451199021)(54906003)(5660300002)(316002)(8676002)(8936002)(66446008)(2906002)(76116006)(6916009)(66946007)(4326008)(66476007)(66556008)(64756008)(91956017)(41300700001)(478600001)(6486002)(71200400001)(6506007)(33656002)(122000001)(6512007)(53546011)(186003)(26005)(83380400001)(36756003)(86362001)(38070700005)(2616005)(38100700002)(45980500001)(505234007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?x3PNn2xVtkXlbfrMQ4SIWFr2DF6VYDOuXbCcWXZymedPzYPApt+v6N3IeWDx?=
 =?us-ascii?Q?LOtP3ZedRsBrYi9F4dlaujNpBr6WdmegESUtKqhdAzlNgLCZM/YU/7pWNl++?=
 =?us-ascii?Q?8gzCrZ+aiMMyMN9LN3Pyy9Gs6iozrFMLIJJuyZzU+P8JbdxMvvBkNiIZVtPo?=
 =?us-ascii?Q?RYXCmVpWwH0UkUrmy2WhnvjPg0lydnHb5YQMRddJoqXa5rGaItQqiXs4RKnl?=
 =?us-ascii?Q?hMJ4+VQGRalC29rAk1ep2xumLMVSyu2+52KpQFmr8vmsYvtm6ykcGRrBTHTI?=
 =?us-ascii?Q?yqUEY8gewodZWiC/h0WW88ZREKAYmAHWFtLjLGndicZCJa7ySCeRTOtuC0VY?=
 =?us-ascii?Q?ubz1fh0VydQnJCebBAwN7tR7GlftA4Q6iAY8Zm0oXuPetHHo5iqARpj63cdD?=
 =?us-ascii?Q?M/SizJUiHTi6HXG6FhnOso59sdDslqJK8T4jvvBdFCrl/j43/UpY+YIc1Yxo?=
 =?us-ascii?Q?nbfLxlec+dMeSaFgp0njjzGuesunANSi1i+AvzHnNhNihl9NGYbdTeO4gaj+?=
 =?us-ascii?Q?BJTujZMUrBgq4EXwWm1AjayShGi+Jk2zR+Qq/s8f7K0HVTHDO/Nko/RXJCZV?=
 =?us-ascii?Q?OkA1bIRncpwkQAzJaJvcroe5yuZoRL1Guw+zso4G2MfMx8FKSWIBzfgW1kcA?=
 =?us-ascii?Q?bQoLsENlNQlbcY+FgBhbxV63aQUOBa/9jDbJzVAmF2K+0vdzkF2jXvBxH8Bc?=
 =?us-ascii?Q?3EIlnVoHNkv8S6XT4D31PdjxtHjUSLfmsn00hDivGjVRE5I4Hhxgbl3DkXcA?=
 =?us-ascii?Q?sEG7TjBtHU4JEKZ/7jbJmxTP+RUeBwXEgQv3anfoaj/PwNexNn9GdVxyyMRp?=
 =?us-ascii?Q?jVKl7a9kNt2Cdw6P+LmCrwlCSskGJHFXLcougkPeqHaar4zx1gQZTi1AGqo3?=
 =?us-ascii?Q?mSxJVwbuh3InB5BJ4n3pXQoALvyiXvo/Syhoh9eTttYOfPFmmWbp+LljI0p3?=
 =?us-ascii?Q?WhRLG578PSlGvir+k4cin3mI4XuX9Ap0o2qtOsTzTTvrfambsmmjeI3UHLdF?=
 =?us-ascii?Q?jVglieP3wVl04pkhqa+Ruc7m+/7itWi7Vhlz6i9pQawXJ6hMSR2pAa8aVywu?=
 =?us-ascii?Q?XEPwjB8nXflkraJcvpA8MZ6SYwCLdqV5+oHZXM08KRPwIGvTjxPnNFEaWA3h?=
 =?us-ascii?Q?ZTQ/SaPWKtX5DKS2KesL4ASXx2bSKJKSE4E0hbMZ55uRtPLlsWIqCTMuiBpg?=
 =?us-ascii?Q?fPw49U7WEEOTO1zPYDaQmHfyuFUP94tRGS/TepuZH/O9lfeVf/ewIvzgi7DC?=
 =?us-ascii?Q?kj6RxuNx0GC/9gi4Lzno1AZuZiNF8O3PjxG8eyCk2NFlpJc4rB3KjBegdmHQ?=
 =?us-ascii?Q?GYYevx/jZfGcEFVdHS4z55CXYMlsLJKDYZClWlCfnqkBm83mSe3gPbUAUG20?=
 =?us-ascii?Q?qIxpeLKNoOx0RQBlHR9GLrESOldyCTQhc3s4lOVALT3ZOug9SVc3LFCzbD15?=
 =?us-ascii?Q?Jj35ac3Rfn5T2b/f3+cCRUQX7qFZIkJgPiwcCWsp9ZK4EyYeRU2soLj+sFaL?=
 =?us-ascii?Q?BZPdVaPU2tdM8Bj6LGZN2MCGgsZf2VW0d44VprJPe4VQyy8KhTLvAqIrlyGT?=
 =?us-ascii?Q?doPGXmtNEaYaE+FEHxu78QUXo4mBoClj6E5k6QlzmCd415dG41a1fNeTlMxf?=
 =?us-ascii?Q?+A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <88FCEBEA0D252A4B9260EAEC7BE675D0@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	b0lyLevGWrnglsH1hQrguWckN7g6pWe/OYD22SvuVJf8jkbwu3vJVhARmRNfkz3i00xAXJnE893w2SWYtRvtv/Qk04jjude21X+7gxmj7HzLwtzF7T0RuTzOq0MLWJ1BnV4EmVOS5qFZcNasL1Gwq4runMbLN6liDDnsAfV4IspoyyaV5O1AqJZ9oObx0uvsVlbUvYeNraCnH7CoZMId/uPJIMXJaEQ0AT+omtg7niherhbpx/MaN8O2tbesxNjegId2H1/zxD9dIjWLzvhrIYf9F9tabSx0DnOzZSaoyIyIrXMRUVfazGc+X2tSnGtTfrLpHLUCFUzgLNptuAsQ+EzJm2wbXxMqJrWhCCKa+d/mA1kmFqwVa81FamRRQQoTcg87ugbyjeuHnkc/RC2YK/1EZiXY+r3+tBHK8rjfs6TJ6o0iIQ1bgtAZE1U12UuJ6lcRXuWCwUvH38fKIhSO06Y3amphFiFPhjAct/HtLNuLF4jwk7OEMhEecvfSnQOUx9BIiz8exF6wirY2GVXHY4VgfFN4+Dr1fWoyq8CrOy2qs3dBLajRK54G3D+7i3l2A36nFuTYmR9nlfj9Is/ZVD6UyRYeoVOFVrbc/V0RstyDYmwBnfD9gC/izXsqhoiGBeyLXfe8bwxj26DRHdbMC1zRvvlcRdv/7Ky1s2zAjx3awM3q+dlwA/LHHD8eQOiw9pPH93hoc8WbD3E2bH+UPkcUb2Mwald0naIs987NohBkoOqc1VAfv52KM+/uZAJ2Li8EokcLyTt6kWOw0EHqDyEkEkW5DCMqpeGgGbSqY1o+7m9Wlk0yM7I8E7EXRVPrjeDsJZyd3b3X8J8xpWJGrhGiYdpOxnuMihg+ZJ7ct7XDGfljsYp6yjMUjgu71cqr
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 653cbde0-975b-4c5f-21dd-08db62145cd5
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2023 20:19:39.8878
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OPkd+6HQOB+x3JbzWljvtrwSfR63H5cjHZTHT1vPwk6qiHMD8OMRiRk8io/mG8Unr9lZd7Q9oaE3P3gX/mRYVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5631
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-31_14,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 bulkscore=0 suspectscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305310172
X-Proofpoint-GUID: Rq7Cshy_tNTNuD0DXyMGLlRMFc_khQ52
X-Proofpoint-ORIG-GUID: Rq7Cshy_tNTNuD0DXyMGLlRMFc_khQ52
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> On May 31, 2023, at 4:09 PM, Jason Gunthorpe <jgg@ziepe.ca> wrote:
>=20
> On Wed, May 31, 2023 at 07:11:52PM +0000, Chuck Lever III wrote:
>>=20
>>=20
>>> On May 31, 2023, at 3:04 PM, Jason Gunthorpe <jgg@ziepe.ca> wrote:
>>>=20
>>> On Tue, May 23, 2023 at 07:18:18PM +0000, Chuck Lever III wrote:
>>>=20
>>>> The core address resolution code wants to find an L2 address
>>>> for the egress device. The underlying ib_device, where a made-up
>>>> GID might be stored, is not involved with address resolution
>>>> AFAICT.
>>>=20
>>> Where are you hitting this?
>>=20
>>     kworker/2:0-26    [002]   551.962874: funcgraph_entry:              =
     |  addr_resolve() {
>>     kworker/2:0-26    [002]   551.962874: bprint:               addr_res=
olve: resolve_neigh=3Dtrue resolve_by_gid_attr=3Dfalse
>>     kworker/2:0-26    [002]   551.962874: funcgraph_entry:              =
     |    addr4_resolve.constprop.0() {
>>     kworker/2:0-26    [002]   551.962875: bprint:               addr4_re=
solve.constprop.0: src_in=3D0.0.0.0:35173 dst_in=3D100.72.1.2:20049
>>     kworker/2:0-26    [002]   551.962875: funcgraph_entry:              =
     |      ip_route_output_flow() {
>>     kworker/2:0-26    [002]   551.962875: funcgraph_entry:              =
     |        ip_route_output_key_hash() {
>>     kworker/2:0-26    [002]   551.962876: funcgraph_entry:              =
     |          ip_route_output_key_hash_rcu() {
>>     kworker/2:0-26    [002]   551.962876: funcgraph_entry:        4.526 =
us   |            __fib_lookup();
>>     kworker/2:0-26    [002]   551.962881: funcgraph_entry:        0.264 =
us   |            fib_select_path();
>>     kworker/2:0-26    [002]   551.962881: funcgraph_entry:        1.022 =
us   |            __mkroute_output();
>>     kworker/2:0-26    [002]   551.962882: funcgraph_exit:         6.705 =
us   |          }
>>     kworker/2:0-26    [002]   551.962882: funcgraph_exit:         7.283 =
us   |        }
>>     kworker/2:0-26    [002]   551.962883: funcgraph_exit:         7.624 =
us   |      }
>>     kworker/2:0-26    [002]   551.962883: funcgraph_exit:         8.395 =
us   |    }
>>     kworker/2:0-26    [002]   551.962883: funcgraph_entry:              =
     |    rdma_set_src_addr_rcu.constprop.0() {
>>     kworker/2:0-26    [002]   551.962883: bprint:               rdma_set=
_src_addr_rcu.constprop.0: ndev=3D0xffff91f5135a4000 name=3Dtailscale0
>>     kworker/2:0-26    [002]   551.962884: funcgraph_entry:              =
     |      copy_src_l2_addr() {
>>     kworker/2:0-26    [002]   551.962884: funcgraph_entry:        0.984 =
us   |        iff_flags2string();
>>     kworker/2:0-26    [002]   551.962885: bprint:               copy_src=
_l2_addr: ndev=3D0xffff91f5135a4000 dst_in=3D100.72.1.2:20049 flags=3DUP|PO=
INTOPOINT|NOARP|MULTICAST
>>     kworker/2:0-26    [002]   551.962885: funcgraph_entry:              =
     |        rdma_copy_src_l2_addr() {
>>     kworker/2:0-26    [002]   551.962886: funcgraph_entry:        0.148 =
us   |          devtype2string();
>>     kworker/2:0-26    [002]   551.962887: bprint:               rdma_cop=
y_src_l2_addr: name=3Dtailscale0 type=3DNONE src_dev_addr=3D00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00 broadcast=3D00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 ifindex=3D3
>>     kworker/2:0-26    [002]   551.962887: funcgraph_exit:         1.488 =
us   |        }
>>     kworker/2:0-26    [002]   551.962887: bprint:               copy_src=
_l2_addr: network type=3DIB
>>     kworker/2:0-26    [002]   551.962887: funcgraph_exit:         3.636 =
us   |      }
>>     kworker/2:0-26    [002]   551.962887: funcgraph_exit:         4.275 =
us   |    }
>>=20
>>=20
>> Address resolution finds the right device, but there's
>> a zero-value L2 address.
>=20
> Sure, but why is that a problem?
>=20
> This got to rdma_set_src_addr_rcu, so the resolution suceeded, where
> is the failure? From the above trace I think addr_resolve() succeeded?

Possibly it did succeed. But the ULP consumer sees CM_ADDR_ERROR_EVENT,
and does not proceed to route resolution.


>> Thus it cannot form a unique GID from that. Perhaps there needs to
>> be a call to query_gid in here?
>=20
> So your issue is cma_iw_acquire_dev() which looks like it is encoding
> the MAC into the GID for some reason? We don't do that on rocee, the
> GID encodes the IP address

Well, I'm not getting there at all on the initiator side.
cma_iw_acquire_dev() is called only for listeners, I thought.


>=20
> I have no idea how iWarp works, but this is surprising that it puts a
> MAC in the GID..
>=20
> If the iwarp device has only one GID ever and it is always the "MAC"
> the cma_iw_acquire_dev()'s logic is simply wrong, it should check that
> the dev_addr's netdev matches the one and only GID and just use the
> GID. No reason to search for GIDs.
>=20
> A small edit to cma_validate_port() might make sense, it is kind of
> wrong to force the gid_type to IB_GID_TYPE_IB for whatever ARPHRD type
> the tunnel is using.

I will have a look.

--
Chuck Lever



