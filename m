Return-Path: <netdev+bounces-605-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 34C8E6F873E
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 19:09:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C0E21281089
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 17:09:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EF78C2FD;
	Fri,  5 May 2023 17:09:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C58BC12D
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 17:09:11 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F258018DC7;
	Fri,  5 May 2023 10:09:09 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 345EYcAC032649;
	Fri, 5 May 2023 17:09:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=zWIY8s0DR61D1D0LVL7PFj3lYC7PUm7FVYRCTna/V38=;
 b=raUMx4wF6g9Ve+lvMaM4h0yU8qEXkGSZQY4YafJvvaIhoc+zKBUU9NJcTDdvrHaBwuMi
 E2eOF8WNFJNhStwu3aBRbqm+q5xVPntbpXLYtQaCLRDhLr3HL1NALldVCPcay2SCygKW
 XE/ZnUKW981QT/+7YT7uy0MsIzfHdWFKDnGbSawbJYBOUTIsfkLosENLwYfAYZo7zRax
 GwaiOATvyY6qpa09ZzVEv6dTV3qctra7JT7ZLMwGoLp/XHFcwaCfNZnBhJ3Fe6YQ/ENF
 8Aj5+0JJyTA5TZXq9PJo4CPx/balRtOcUUYNXo6eN2qntX8zz0K4610qcHNSZa6PuZmr HQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3q8usv5af8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 May 2023 17:09:04 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 345GWGtv010262;
	Fri, 5 May 2023 17:09:03 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3q8spamguq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 May 2023 17:09:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iBlAH01bsBEDZpU29ybHApyqZA/tyxMtucTXEcq1Nm3tTLeFDDU8VFHoHGLvHE753VZ58E9JZ/mxU5mKWkrCcs+3dbd6LadBPm/RQDjsuqCKPvzsQKuW7qA1j8gfwZNqXGsZBp03nUKD0ND9TEc6AqIUjv6vAQB6DkPQVB4A2ClffJv0PLjFGrz7SaghuR+1tGnZFxShpxHczxvFPR5as+xA0U4PB+uOPBH43ZZWpC5/IsyoM3WYwXu2v4ADZ+eSfV7Rx7YLf92nYxkVfxUxYqTUa2cowbgKpJlG1D9RnSQeDyFcEeWB8Nvc9zDBtWGkasVBGvoWFgOaQa4AanFhRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zWIY8s0DR61D1D0LVL7PFj3lYC7PUm7FVYRCTna/V38=;
 b=d2Cl5xNLf3abEJ844I8xIHfyN48IEveS+sjTNY8him8h8qkMOk0ujWC+B2YITZ15e9ojYGPjbz+NBdqs+P1TRXJkymL3ZhwRLeuVmRSN5qLjGNie1RaaomsU2Qr4+QLLQdWMQBJNo0T7zf6X2cahRVILckgl8yZC/GromNehEwpDc30uv/uJ3b1aUtrF03p+sJdGJXv8G3tSTcnKyfjoOBbKSmVi3M7iyMWhlIVMnGTxya1XecBUi0YGN18Eo4uCv+b6O8tbA7wIUBgfFC2gb0R4c/TVT3GF8BEwGcITM5Cw1LbnzMIyQ2Y/J17D+q0aIN0/8qvsM/jqE4j3mpcYTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zWIY8s0DR61D1D0LVL7PFj3lYC7PUm7FVYRCTna/V38=;
 b=Q/DMLX/oTeOXNI1KBnZFNX7D8nmtkFogBCptbR5DZafkWFJShGgYZ0xa6/auQTRmrRl0PbaphenDzxWkud5gnfAlq6WbQ95Ue/H1ByE6l4QLtuE8ZlxRftDODHx5ppqs1AynhyQrKTCUWU5h5oN5ggbttmzFZJJGTRQ3yT/pO10=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by SJ0PR10MB5408.namprd10.prod.outlook.com (2603:10b6:a03:3ba::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.27; Fri, 5 May
 2023 17:09:01 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db%5]) with mapi id 15.20.6363.027; Fri, 5 May 2023
 17:09:00 +0000
From: Chuck Lever III <chuck.lever@oracle.com>
To: Stephen Hemminger <stephen@networkplumber.org>
CC: Chuck Lever <cel@kernel.org>,
        "open list:NETWORKING [GENERAL]"
	<netdev@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        "BMT@zurich.ibm.com" <BMT@zurich.ibm.com>, Tom Talpey <tom@talpey.com>
Subject: Re: [PATCH RFC 1/3] net/tun: Ensure tun devices have a MAC address
Thread-Topic: [PATCH RFC 1/3] net/tun: Ensure tun devices have a MAC address
Thread-Index: AQHZf2g49JnoUfwLC0muv8DjQvSbLq9L5xwAgAACmQA=
Date: Fri, 5 May 2023 17:09:00 +0000
Message-ID: <23990054-8830-4F98-88DB-86DEDDDB03D9@oracle.com>
References: 
 <168330051600.5953.11366152375575299483.stgit@oracle-102.nfsv4bat.org>
 <168330132769.5953.7109360341846745035.stgit@oracle-102.nfsv4bat.org>
 <20230505095932.4025d469@hermes.local>
In-Reply-To: <20230505095932.4025d469@hermes.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|SJ0PR10MB5408:EE_
x-ms-office365-filtering-correlation-id: 69ef8fe9-8cfc-4eb5-5550-08db4d8b6beb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 9fxrsObdyhDhxESPv/eDFO8YkPDgWqq7HFDmqxVnW//6KCLGwtgUs/ilpsJxlwrISojmpIWeV/7TYaDbiZqNylnseUxKeVjhYdHRdOAjHZnKTz0lA9CJkVN81Bd2gZeyhyT3+565KqHyWIrR9AXMXWwbOJ7yGd1ggEkvCNBopdGeJ8AcWpP1WmMKu9GV/1uVe7D0pj4+9+87MAE8LqiDF/rmmnmAKctUOKiXU8R9W3PDHgm12S7Hm7tfZcDmzbpPYTV8J00amg+nn3OPQahIs5UV45NzlIwtR58eaIuGQn4Ux5FjPU8lr2TgkT0j/j9DO+SADxG3eanvj3wJQFQe2wwMFj5VAb7a8o9sF9p+vwkAZsF4wa9D6OenGP0QQ6YHHpAEKdQ7ZU9o/FEta0dN5lVF3ep/Sq0S+6pgUBwmYboI9H59H0pxaLQIFyyhE8TGzzgsZdPrToIXeh2yO1Mz5QggsDGIdjQDK++TwgDvoWFbLYms1XD3Ysd9FcfueeEis5PudhI3RgaGsCOfGplYO2b9t6NjTla/Pom+wOwk8lLpKCMcHs8u/7Qpkh//4dsFMXZ8BItgnZt0cAOlbxT4kQZkQBrYYBZKryuhb3xQTSKby2ECFA3Zumo4Q3+y+9E6GVDtWTryR8AGumaQNqvdVQ==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(396003)(376002)(366004)(346002)(39860400002)(451199021)(2616005)(36756003)(186003)(33656002)(2906002)(86362001)(38070700005)(122000001)(38100700002)(83380400001)(41300700001)(5660300002)(8676002)(8936002)(64756008)(66446008)(66476007)(6916009)(66946007)(76116006)(91956017)(71200400001)(4326008)(66556008)(6486002)(478600001)(316002)(26005)(6512007)(53546011)(6506007)(54906003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?OMcPcTioFsc5MlEumbCOemrxIqMyWONPqcJGfSMyBdQrER3lDuzQqQLCxoFw?=
 =?us-ascii?Q?rKGvGv+BxU5CWVHQOEX+rKEiXwb0vgjOtACx0zah+zY/kgAJUU+rGNi25crT?=
 =?us-ascii?Q?eAMuVhP4McFVD/IRq047OnJdNpkl86BaZekmrOdkAjg10NZTJ33nPMhh5NE3?=
 =?us-ascii?Q?ld29MYBx8wbSRTVIe9YoU6oSPzBFah+PhfLwRCS0pPG3S71BOPlSekU4oiaW?=
 =?us-ascii?Q?c9IN7KfBkEsal2ed3HgdxFARop8bf5vUShoks8zPOoa1sCKl4snKQWUvk6xU?=
 =?us-ascii?Q?/PJjClcrYz8miZl8wO2Ynw3X4UH27+vRGOi2ouPQ0I/Di6sD6hsY+CBQ0M54?=
 =?us-ascii?Q?3Rkzobh15VxWXe7DXWCz3eX+txaRNfXwhxCzX1IzDuJIQfEu7dKIf5/wdRGe?=
 =?us-ascii?Q?lP+S+4DtPYPKLk/PdgUFLXmQ3NONgyRdYwYyzWSNUVOoX437KuJH+fqWBFJN?=
 =?us-ascii?Q?k5xoQVFxyNDojH6BlLc3rGDPNeomNljhlDWSkGvuiS+TciLPIaxpI4AwfK0f?=
 =?us-ascii?Q?2IgfGvuiez1T3RI4l9OX44yfnYpPJUUq8ZUcio2LnwXbBdcfAmmXHzQZK/rJ?=
 =?us-ascii?Q?MEpLemp9StUZqVNtqYbPDuIS6T+w1LKQrVSvuUEOM5xpnc115MfdcmfuhP5V?=
 =?us-ascii?Q?vZ3o1cad0wLjIK0FFySdBskk9t6EgzyAnE9XCM2eaNb4BrABlfqzPQwDU3zZ?=
 =?us-ascii?Q?BCRpTBE8hUeWJIl13SPhK7IOPGd/kcJGqHbkm1xvkVKXGw9cRxEZ0C0EAMqT?=
 =?us-ascii?Q?mWOuMwG9ZZTdv4D8LVdHzZWEs5Osyk4fA8ZlwGbI0DfYPsNt1SDjOb6iVdHh?=
 =?us-ascii?Q?TkKU48r70RIKq5KwQt9Lf9JwLPQQ8RHOwNKAWweY1HGNga1o5oCZOCSk5/R7?=
 =?us-ascii?Q?+Gr6YaE1MZ/NQTHZV/wPk1TPugFpiTALDCC00M4eMHoTeOPSoIA61qw5F5OC?=
 =?us-ascii?Q?2N6EMuJ27g9VpbWwI+HkI5vuBmTwY2yJOSIkvW/ygYtmVEfxIvNscRl8Ve8v?=
 =?us-ascii?Q?GLCb3rFaoIr1VXBtsL1/UJK/bpCKiySP/bZab6pC+lK0Z3JXvF3GTFnryH/w?=
 =?us-ascii?Q?MLz3cNzsY3w4M0JhHzq/uhChUS7MNZBk4cGslA+6gVPlt5hJ+qiALTxnXEGA?=
 =?us-ascii?Q?p2X80KnCKavwJuPKnhvRhOGGeIIsVMjxnSv4Hdjy1CQZKmLFoDq1sIXOjkQ1?=
 =?us-ascii?Q?uE2TLIcZN1tXEPE9YM48DkDL277eQFuzFpV0/0dVbyOxeSpwag/4MVqhwbIu?=
 =?us-ascii?Q?idLQNDC4S/PSLsFM6kJ4xf7ZEf97PFEM6I+XXr1fHZ+B3D1f4tRTJldG2X0t?=
 =?us-ascii?Q?xp1Ug8hgNhohTDrBMT0U0FWda0ajE3h+MQ8AMx8Gl2LsPzqN5Vc3Z2mx9Kl7?=
 =?us-ascii?Q?5x1ljKpnWJb5vKqjGe9qv1qB46xX5ZP66qaGmQZDrMJ73MZH6NUCRoeE4+7D?=
 =?us-ascii?Q?6IluaCO2lNWtQmYxxH9ZqKW7Aa7/oux5QOoD+BCoV6kjpiHuoesTqb76mwQv?=
 =?us-ascii?Q?5YKXr6kDlBIhIJHFzuYeJ9r4Xoq6zSLjc8bfDhYaHvfV0ut3a8kQe0PfGtfX?=
 =?us-ascii?Q?RlwDjDK3HQ3LybFoQgsp7Pu5hqREmREbUctRfHaLmARDIToFZQyN5G8MIqA5?=
 =?us-ascii?Q?ZA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9DD1DDC49E2F744CBC9BA871BF06DBB5@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	z2XS6rPmF83hIXEbdY12LobVAt8K97BrY8QdCQzjbU5rLC50T+MnaGnLDs/QU/K/lDGg0L0tGw+bmU8kqvPX3pNYNLQY4Iw9MNZtczM2TZTZGyLjQXjjoKzrNmdJLaw11t2AKMsjiG4AfgsaNr/7FsaPy86WH03XJ4DMPHyn+HSRHcf06q2uPU+tmxk1uoZoywNxlRrUQuKzq4fjx4SMBrOshD+i5xjar2ZJ2uVjoFeAXVjOt4RU6m+po9+w6nAyFy4a/SKX9fs8EV94vAzqDZs7Ljz3iTLu1687KEvsLZ9ZMMjyOZ8+b6TnNFOovYWPwr6DGT2W+dYr5b/OkCiLHO5yghiqHQL+iP6lRFbNIUQd8wOX62mYOU2J7PgO4GEcT0ofMaVhhNoI6+vKtxnJ/hRq2ox69WpoocTsmMbN/cfH7Q1+vzuqeTXYKVWYWY9pA/3lcTd/RAU1p895RyLRhh0JwMET0ctaaDtePbBJD+AOFSS2SUG10pBqpQdQcWtBrFj3wL4zyAtrlGI3tCLxcj5k1QpD1fhQQ/+kX2fqaQEaAy+TD0tPJAguJL+EH3zfpgsNpLjPXvsNi707sL+E/Y7eobncwFSyOufmuSuFjEWpD1hNOksnn+ydeFB6YcpN7UsAQSpmgXSSqJ0SB++MZ4V5SNCZvUU+Eq0wPph7L9h6YRQEyk0/DSGgTKUCGofnFIwKpfnz+P1tYlsFVPw7CkZqGmCBdW6QoSPa1Mdd0QQOquDteiCT8B4KZvAC3zoaH+BQm3mRpIsGE+YdhCAYioAeEeONPaAPeorkjaQjYfnAemN2tpsnyXqCZkr2x+syJ1uJ0filJY1sTwX92/yRsPyr8vP2Bzpg1HJaLAlGCpJy2Tvkj6G7fyo8jV/T7lm7Kb32SwQ0C9hnjqcKAKckIw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69ef8fe9-8cfc-4eb5-5550-08db4d8b6beb
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 May 2023 17:09:00.9079
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HkveW9D4Q0SuIV2LWB286Lb7gYEpGlGAU/mPHG3+HJrArLuOeZGvxVpj+EBitYSC6JBV/8GSebdjyaYM1Kat4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5408
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-05_23,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2305050142
X-Proofpoint-ORIG-GUID: 1tkL2wSzf-SnkCI8H-Z4RwQnYrmk70q3
X-Proofpoint-GUID: 1tkL2wSzf-SnkCI8H-Z4RwQnYrmk70q3
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> On May 5, 2023, at 12:59 PM, Stephen Hemminger <stephen@networkplumber.or=
g> wrote:
>=20
> On Fri, 05 May 2023 11:42:17 -0400
> Chuck Lever <cel@kernel.org> wrote:
>=20
>> From: Chuck Lever <chuck.lever@oracle.com>
>>=20
>> A non-zero MAC address enables a network device to be assigned as
>> the underlying device for a virtual RDMA device. Without a non-
>> zero MAC address, cma_acquire_dev_by_src_ip() is unable to find the
>> underlying egress device that corresponds to a source IP address,
>> and rdma_resolve_address() fails.
>>=20
>> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
>> ---
>> drivers/net/tun.c |    6 +++---
>> 1 file changed, 3 insertions(+), 3 deletions(-)
>>=20
>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
>> index d4d0a41a905a..da85abfcd254 100644
>> --- a/drivers/net/tun.c
>> +++ b/drivers/net/tun.c
>> @@ -1384,7 +1384,7 @@ static void tun_net_initialize(struct net_device *=
dev)
>>=20
>> /* Point-to-Point TUN Device */
>> dev->hard_header_len =3D 0;
>> - dev->addr_len =3D 0;
>> + dev->addr_len =3D ETH_ALEN;
>> dev->mtu =3D 1500;
>>=20
>> /* Zero header length */
>=20
> This is a bad idea.
> TUN devices are L3 devices without any MAC address.
> This patch will change the semantics and break users.

I suspected this might be a problem, thanks for the quick
feedback.


> If you want an L2 address, you need to use TAP, not TUN device.

We can't assume how the VPN is implemented. In our case,
it's Tailscale, which creates a tun device. wireguard (in
kernel) is the same.

We would prefer a mechanism that can support tun. Having a
MAC is the easiest way forward, but is not a hard
requirement AFAICT.


--
Chuck Lever



