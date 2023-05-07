Return-Path: <netdev+bounces-757-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B77C6F9953
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 17:27:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 676311C214DF
	for <lists+netdev@lfdr.de>; Sun,  7 May 2023 15:27:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D78155244;
	Sun,  7 May 2023 15:27:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDB123D67
	for <netdev@vger.kernel.org>; Sun,  7 May 2023 15:27:10 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 768F840E1;
	Sun,  7 May 2023 08:27:08 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 347CAaB3012278;
	Sun, 7 May 2023 15:26:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=DmLdFf5GbKuXALcyl6r8ua9yPdo6+ISCb8BlbyVddbE=;
 b=JzTlNbaAUCjd/vODqTlpAYaIz755kSxKc5O/hE/OSis5JRa9/VN4I5BjrlFCS8NGcjJj
 S8s2w7A2YXYIXlt8eALBZ/I2uzY33JHoZCvoP3XDr3KdD4sIzh+gbHEQZ+i39AL5+gvC
 1aRCVjGx5vhqzKKuIPYGoEnTSSm+1I2naArw+vaLG2qKT/GAmeqzSCoRobFQKq/RQWkZ
 qexeCTGdr0TIXgoMqGa922Jy69+ltSBSubAuBu+b+LYJxrwygESj0C4zBb3MrL7v13W1
 4YvA8UyeNT7XcCCnWTjFocwiNIP4qM0sDqDozOvdkPg3ZqkTFfvMYkBLrv+LTzcjn3KS RQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qddg21v3d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 07 May 2023 15:26:53 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 347AOwN6024060;
	Sun, 7 May 2023 15:26:52 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2042.outbound.protection.outlook.com [104.47.57.42])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3qddb3tpx2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 07 May 2023 15:26:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MJpJKgb9plD0Ypq3esOSKPQai1iY2TB6Yb4cYod1+7MOk4I/WW3TrzlPFBSJh9OIxsLcQrsEX7vEeFtqe5F3CrZxn4f2wyWDa5v4n/xXsyBXP9ntS32jZ5o5XzqXx8BYGMk2+BR1ZzHOAHQInN5acuRMgm+YkYklAHgatEmaE8vfGJAJzP4b8VL+FbPujMZ4a1Bt1S0xd/RkkUlfZqj17PRfuIjn451tyFi7rf0WX4Ze4hIyULitPXotDOT/NdFt3kGB70A69RXwMUcEPKE55L3dR/KGSGG57CLo687FBNWboycksWhrbC1u+AyeAsKR+ZNfO61cDOuDj685/hHW7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DmLdFf5GbKuXALcyl6r8ua9yPdo6+ISCb8BlbyVddbE=;
 b=aCfhdbuLWE9O4DZ3Nla6zG1pW7rnPqn/kFILgGMcAiOMOAdhrhk7GYYqDqdoFijuNB1PMGqHWn4jv/hb9l0ko3v1G4dFAmzC7qAib3RNg/tkrpHCF67Q2B+0ZlAw33KDTcEV/sM2YlyrJ7RcW073wjakrFebobhCxN6pmz3W7DnBFr37VzhQrviI1CgoQTM4qlHxme9TPyZCwIPOVtVdB6nBFmPdC+X3w8nCC5aduyNShbPA94TvVAUQHIdI8+Oi1ViyfihYwsARYRSulamdIDXRurVcbfWjO9b0LRigdiUY+5gTrL9dhVuVI21HO+vYx2IWhw4dV9nNa3df5jRcig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DmLdFf5GbKuXALcyl6r8ua9yPdo6+ISCb8BlbyVddbE=;
 b=EgsDl56xZ9VP7AQOTW83RcM5Bh9tV2F1HOUx0qi1ezlTe/g9hqCV23eAZOJ6IhSrKSebNTRVJTB5sezX0B3L/V0ZpCXwZnuznNNJJrmkqf3qHtD8gN+QnyE/XzvPRRqbA4uhJ2dzc72VZ3C9C77lFa6DZ55iB61b5enocbgYzGY=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.31; Sun, 7 May
 2023 15:26:50 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db%5]) with mapi id 15.20.6363.032; Sun, 7 May 2023
 15:26:49 +0000
From: Chuck Lever III <chuck.lever@oracle.com>
To: Ding Hui <dinghui@sangfor.com.cn>
CC: "jlayton@kernel.org" <jlayton@kernel.org>,
        "trond.myklebust@hammerspace.com" <trond.myklebust@hammerspace.com>,
        "anna@kernel.org" <anna@kernel.org>,
        "davem@davemloft.net"
	<davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        Bruce Fields <bfields@redhat.com>,
        Linux NFS Mailing List
	<linux-nfs@vger.kernel.org>,
        "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] SUNRPC: Fix UAF in svc_tcp_listen_data_ready()
Thread-Topic: [RFC PATCH] SUNRPC: Fix UAF in svc_tcp_listen_data_ready()
Thread-Index: AQHZgMQOKc4fcioBR0q2bzqWePFl4a9O7x4A
Date: Sun, 7 May 2023 15:26:49 +0000
Message-ID: <EED05302-8BC6-4593-B798-BFC476FA190E@oracle.com>
References: <20230507091131.23540-1-dinghui@sangfor.com.cn>
In-Reply-To: <20230507091131.23540-1-dinghui@sangfor.com.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|SJ0PR10MB4429:EE_
x-ms-office365-filtering-correlation-id: 4cb76d22-57e5-4c09-1660-08db4f0f7a48
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 zwu9eb8iv+ApcHE/0SSjmfXV6JTgvklaBinQU9kUiCQ26JyOLTNNpauuRdwSeFWu+3m2HbDIWEU5zjqj3cTSP1NRAbgq1kTj6TBMKGYIMP6722wdeEjrpOLaGyB8TNQy0kdALzIMTaUuyWFzXHiODk9vj5qzq9qSDMxWEhVqpAZ8bcJmj5It8o84ABxGLdvwO82AzksLYdw1KkF9M8gpOKfI9VBnla2IdDpvovgkHr5ZAmY3d4elJMXvl+q/zHHfsuDDbGm4ofxkhuC33a8XoccUkkMcnXm1f7pwPyIQnO8mbTaxIOlysNrdEIs3qsWyg9SOrYLKOYSj+gEhbuNiq06K0gqlrtIi+tgZa4riCmQ3bb9H1cAy6voOaXn1CBj9EwQjR3zrvf75w7h/yKvcQ4YBCd1YN5++wgoRlPJhcPZUkPl+NY655oqrYqSYmmulY1HrcGXdsXFk9DDxm/qUuGutN/CnqUc5vR06a1Wh7r8JnSMpvHtNgKe9KSzlgxYSizn2i4hpCjAioriCGqrhdgtN7r6017hCpp20IfgpTxGcNT3E4YnO/hGsFuRMXba1ozr162WA6+/EVx1VnMVHEw+nCeNC6shklzLeHOvV+2MQKhVF1bm4MT6QYaeIdJp/sJzlxR2QSK3l549qmOTZMA==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(346002)(39860400002)(136003)(366004)(451199021)(36756003)(33656002)(38100700002)(7416002)(2906002)(38070700005)(5660300002)(8676002)(8936002)(316002)(86362001)(64756008)(66446008)(66476007)(66556008)(66946007)(76116006)(4326008)(6916009)(41300700001)(122000001)(91956017)(83380400001)(53546011)(186003)(6512007)(6506007)(478600001)(6486002)(2616005)(71200400001)(54906003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?1oHxjdNwoAKuhrFOZ34nkNWVSqCGPWRtUcTntDqIyEEvZLd2KhCr6laUDA6C?=
 =?us-ascii?Q?/WkUrB0ToJTKkRQEXSG+u4mUiaUbEBq1rNWvz5/qGMZZHvYWXdOaaKvmhLEb?=
 =?us-ascii?Q?m71YvOTuUpHhQnFpB5khWTTipvx5GF1VPxfED42AdLUOaygxLqdGyLtcRtdQ?=
 =?us-ascii?Q?/Rd44IF3zhRzvDdS3h8PoqR7piyGh6Vy2aNu+gUn+MF9XfwdcyOWCZWxZw0q?=
 =?us-ascii?Q?yQw3zzMjSLs/5aPBOL9vK2BYtwcIpRN6QaBwLSP6WS4GMXbBK7cxWEP1YLoz?=
 =?us-ascii?Q?H6EyU+LFpseHqFvWLkepqb4FBfMlCkBWzCOjmXY/kHOWO7Zoz0VvoMJZyviT?=
 =?us-ascii?Q?JVbk3YRrqaNr6jzX1CqwhldR++nT5Yulylmnr84gUZKoWg5oz7zNDfBS4Nv7?=
 =?us-ascii?Q?IqkiKzorg93PJarybUvVHNa5Y5Uvg3gmKV1irYevGPGy/399e3hcGstNkJXl?=
 =?us-ascii?Q?g2fce4FAf1Ibgvbz/5hCuaICaRU+F4O4ls6n4Mbt6x/2weJvJlge0zWjbESW?=
 =?us-ascii?Q?q4CyazVVUDrqKDkuyKVzVTniBFANxLb67xwfIMGiGy8Qzk5TAVi1hlkQhL+V?=
 =?us-ascii?Q?ylQz03XEeRaYTiL5NDtJQBrryqYt8UJDMxAUFtrUqePGm7CjD8TVJgd5lhFZ?=
 =?us-ascii?Q?cN4IXreKbCVI5BZzB5h1IDuRVmLj6TOUX11cvrOY8GXko4MfWj8P8KqrBtH9?=
 =?us-ascii?Q?pzyCTmQ8BH1ILLPwk3Ya4qMUdRaPB3w21CLoqrojUL/Uy8DZpUKfw1ZjVFQ0?=
 =?us-ascii?Q?Wtwgn31wRSIAYBtagsK7AzMQ7qRZlE0xOne/2C5vztVffZ0HGA+nS72aw1zf?=
 =?us-ascii?Q?njm2Q/nBEB12xE7YZ2IB1AOeV/CQH+aRlfa9AiVYA6a7ES5gJ74IRVznUQU9?=
 =?us-ascii?Q?67Fp68vQtY4np579l18I7pToDUeC8bJBhtxUL/p+BVnCIWTKvvy193W9CeaZ?=
 =?us-ascii?Q?VmJy8Ni8a7yH8UgmFprrI7U5CSSnjxyW37p8uU5na7DV0SfPnEg9PaGh8tpm?=
 =?us-ascii?Q?98L9S516thKhIbGg4NE29r1asobQ+dDYGf7djF7DVZWAvnJ9deviLzEOvHxG?=
 =?us-ascii?Q?u/+PP//TutPUP5yWJnBjw66cWX8nTdigAeQJJFjn+4oyrCARckJgDdouLDgN?=
 =?us-ascii?Q?+99NU2fp+swMpEsBkYFVl6Tm+e85vNFz+xTDR4X1j5rB8mKa0z+V6OEAjkfn?=
 =?us-ascii?Q?zdbnPS6RwG3Mq02xi7xWOTrkb807igcxHYjhkTxVSSD9DKStK3EHWcxpTPWw?=
 =?us-ascii?Q?vZJJbeWBeFhGFnJlrg7qhHtFOeZRc0C0Bst4cU6Wr6BdPnzLBPjG31TbsNkO?=
 =?us-ascii?Q?tvs7PS2zeEWfOY3Uz7570sGrnA5fuqD0tQ7dWo7W+an7o2AD4JMb8LF3x8XJ?=
 =?us-ascii?Q?y5TpIbrP+oJUyPrY0HbswefwsXgAxpiGJ/xtctqhBOjEFqxFy69LROEPwRe5?=
 =?us-ascii?Q?sc6vSVQxOW7dCjHKKJjG7xtM2wvlmIZ78XSLEL7Ec2254DrOFe1VMRjynDcD?=
 =?us-ascii?Q?sAD2LUB1ZqZi2bpjTlLH1qyxEQ8jpESpmFZVMSq71h5ZE3Ly09Iy0Zl/PCV0?=
 =?us-ascii?Q?QJhY8wutLYEg3H0UYyMMBzAF2vBKwYOIl5EKZcbg/lpko57KcxzXEb9BMz73?=
 =?us-ascii?Q?+P/WCfUVRlVaBRuP8Z1ar0izu+GoO/eWHD7lcURXb6mBDu7fvCkraLCoTIBA?=
 =?us-ascii?Q?s+W0Rw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1016E75C4BE0244DA283132BB030A1B9@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	=?us-ascii?Q?yzALB42qpbEVAXkNyhMZx4D1iiKjmBpt2XlfGRDfDLwOvsXqtAFYcCPDy71N?=
 =?us-ascii?Q?Ej+Q7Q7CO15LArSnGsFhLOMtvjKPIvAWpTYlqxmiBDiq8jmI54qlqPwsfsyi?=
 =?us-ascii?Q?LTVuwrlDEfxUTSSzP6g4w8gSr3lFuv67li5ltxX+w3Uh0oytMGXko6MPhdLi?=
 =?us-ascii?Q?ej8dOiluTAsvGbKIgVuZ1DJHoVHNx1OinpYqxc2eV+fxYHZM6ly0UVuwb2mm?=
 =?us-ascii?Q?jOvwO1ZJfL/hLeh8EILITovDjzi2vm5ixsfMipdWfZP25AAWNkyy3qQk8Euu?=
 =?us-ascii?Q?fwcxH0zZ+b7O//aAdYyMzEDnNlNe0SZGjc8PV0cx+B4azK7CJteFVbvh5GNz?=
 =?us-ascii?Q?fgxzYgXhPZoya4PH0URUzsrsUthKOKke4BxAJ8JJdZzC2YxO/uUpRpVEcNdi?=
 =?us-ascii?Q?HlMt8hHndLMh3/EFQ5H2fr+ppzCYzQuPLl6UKmguH3U96+WT7IlO6h2Q1Ppl?=
 =?us-ascii?Q?THEBSf/CChkTrFs9r7EdkI6T/q3nWQ/6DsUxdkDdaRxVAPMFV7iWZbMkDEDm?=
 =?us-ascii?Q?cJfiAslGnRGTnEPTsnzVoh1r7wbDbc//sMwjJLaWTC8GQp89iriV0hAiMV+8?=
 =?us-ascii?Q?O+YTR9z2IdJo8s5Z1Dp4HcalN1vUktEbs6FrcTiH2Aj0szBmUnheCWSFaaBh?=
 =?us-ascii?Q?pxREWgCHe29hI0Cr7R8Awmy/DNDxeh+p2TpZFu9EiC46/KjOdQ7hz354FBXa?=
 =?us-ascii?Q?FECGCOCFv9gv1TqYSxFL0vpb3pTUJnuNbI/p6XBHRTkVBj4SKVN8BXoM8EzO?=
 =?us-ascii?Q?NmKupgTkWwmq6IUq6ziV3XlGZsy8HWUj4NpPRTd9vbA1adqhZpmtXhxMK456?=
 =?us-ascii?Q?uL1SydrqC+Sl1tCPo6Cj8pmXXY62h4z+uln+IEDg1Ja72QIps79SxnH9S1U/?=
 =?us-ascii?Q?8DdsavIBLhcMkQYbto1ij6cDWdWEHJxTwT8Z1bR0UysqdSR3nlEjCmUF90u/?=
 =?us-ascii?Q?8jMIUWHvsDQBVSi4E5WIvw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cb76d22-57e5-4c09-1660-08db4f0f7a48
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2023 15:26:49.7227
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9u2x783S9I7LGrMaiiyGPnmy15j9yuzjZFxnyDsu4Ed09kYycx0IEi01QNxI1JdNkaE3IbDIlheMiYoq3Efjbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4429
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-07_06,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 suspectscore=0 mlxscore=0 spamscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305070120
X-Proofpoint-ORIG-GUID: uLVi48UgqV8vb96oPddB-Jhco-AY-C6-
X-Proofpoint-GUID: uLVi48UgqV8vb96oPddB-Jhco-AY-C6-
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> On May 7, 2023, at 5:11 AM, Ding Hui <dinghui@sangfor.com.cn> wrote:
>=20
> After the listener svc_sock freed, and before invoking svc_tcp_accept()
> for the established child sock, there is a window that the newsock
> retaining a freed listener svc_sock in sk_user_data which cloning from
> parent. In the race windows if data is received on the newsock, we will
> observe use-after-free report in svc_tcp_listen_data_ready().

My thought is that not calling sk_odata() for the newsock
could potentially result in missing a data_ready event,
resulting in a hung client on that socket.

IMO the preferred approach is to ensure that svsk is always
safe to dereference in tcp_listen_data_ready. I haven't yet
thought carefully about how to do that.


> Reproduce by two tasks:
>=20
> 1. while :; do rpc.nfsd 0 ; rpc.nfsd; done
> 2. while :; do echo "" | ncat -4 127.0.0.1 2049 ; done
>=20
> KASAN report:
>=20
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>  BUG: KASAN: slab-use-after-free in svc_tcp_listen_data_ready+0x1cf/0x1f0=
 [sunrpc]
>  Read of size 8 at addr ffff888139d96228 by task nc/102553
>  CPU: 7 PID: 102553 Comm: nc Not tainted 6.3.0+ #18
>  Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Refere=
nce Platform, BIOS 6.00 11/12/2020
>  Call Trace:
>   <IRQ>
>   dump_stack_lvl+0x33/0x50
>   print_address_description.constprop.0+0x27/0x310
>   print_report+0x3e/0x70
>   kasan_report+0xae/0xe0
>   svc_tcp_listen_data_ready+0x1cf/0x1f0 [sunrpc]
>   tcp_data_queue+0x9f4/0x20e0
>   tcp_rcv_established+0x666/0x1f60
>   tcp_v4_do_rcv+0x51c/0x850
>   tcp_v4_rcv+0x23fc/0x2e80
>   ip_protocol_deliver_rcu+0x62/0x300
>   ip_local_deliver_finish+0x267/0x350
>   ip_local_deliver+0x18b/0x2d0
>   ip_rcv+0x2fb/0x370
>   __netif_receive_skb_one_core+0x166/0x1b0
>   process_backlog+0x24c/0x5e0
>   __napi_poll+0xa2/0x500
>   net_rx_action+0x854/0xc90
>   __do_softirq+0x1bb/0x5de
>   do_softirq+0xcb/0x100
>   </IRQ>
>   <TASK>
>   ...
>   </TASK>
>=20
>  Allocated by task 102371:
>   kasan_save_stack+0x1e/0x40
>   kasan_set_track+0x21/0x30
>   __kasan_kmalloc+0x7b/0x90
>   svc_setup_socket+0x52/0x4f0 [sunrpc]
>   svc_addsock+0x20d/0x400 [sunrpc]
>   __write_ports_addfd+0x209/0x390 [nfsd]
>   write_ports+0x239/0x2c0 [nfsd]
>   nfsctl_transaction_write+0xac/0x110 [nfsd]
>   vfs_write+0x1c3/0xae0
>   ksys_write+0xed/0x1c0
>   do_syscall_64+0x38/0x90
>   entry_SYSCALL_64_after_hwframe+0x72/0xdc
>=20
>  Freed by task 102551:
>   kasan_save_stack+0x1e/0x40
>   kasan_set_track+0x21/0x30
>   kasan_save_free_info+0x2a/0x50
>   __kasan_slab_free+0x106/0x190
>   __kmem_cache_free+0x133/0x270
>   svc_xprt_free+0x1e2/0x350 [sunrpc]
>   svc_xprt_destroy_all+0x25a/0x440 [sunrpc]
>   nfsd_put+0x125/0x240 [nfsd]
>   nfsd_svc+0x2cb/0x3c0 [nfsd]
>   write_threads+0x1ac/0x2a0 [nfsd]
>   nfsctl_transaction_write+0xac/0x110 [nfsd]
>   vfs_write+0x1c3/0xae0
>   ksys_write+0xed/0x1c0
>   do_syscall_64+0x38/0x90
>   entry_SYSCALL_64_after_hwframe+0x72/0xdc
>=20
> In this RFC patch, I try to fix the UAF by skipping dereferencing
> svsk for all child socket in svc_tcp_listen_data_ready(), it is
> easy to backport for stable.
>=20
> However I'm not sure if there are other potential risks in the race
> window, so I thought another fix which depends on SK_USER_DATA_NOCOPY
> introduced in commit f1ff5ce2cd5e ("net, sk_msg: Clear sk_user_data
> pointer on clone if tagged").
>=20
> Saving svsk into sk_user_data with SK_USER_DATA_NOCOPY tag in
> svc_setup_socket() like this:
>=20
>  __rcu_assign_sk_user_data_with_flags(inet, svsk, SK_USER_DATA_NOCOPY);
>=20
> Obtaining svsk in callbacks like this:
>=20
>  struct svc_sock *svsk =3D rcu_dereference_sk_user_data(sk);
>=20
> This will avoid copying sk_user_data for sunrpc svc_sock in
> sk_clone_lock(), so the sk_user_data of child sock before accepted
> will be NULL.
>=20
> Appreciate any comment and suggestion, thanks.
>=20
> Fixes: fa9251afc33c ("SUNRPC: Call the default socket callbacks instead o=
f open coding")
> Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>
> ---
> net/sunrpc/svcsock.c | 23 +++++++++++------------
> 1 file changed, 11 insertions(+), 12 deletions(-)
>=20
> diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
> index a51c9b989d58..9aca6e1e78e4 100644
> --- a/net/sunrpc/svcsock.c
> +++ b/net/sunrpc/svcsock.c
> @@ -825,12 +825,6 @@ static void svc_tcp_listen_data_ready(struct sock *s=
k)
>=20
> trace_sk_data_ready(sk);
>=20
> - if (svsk) {
> - /* Refer to svc_setup_socket() for details. */
> - rmb();
> - svsk->sk_odata(sk);
> - }
> -
> /*
> * This callback may called twice when a new connection
> * is established as a child socket inherits everything
> @@ -839,13 +833,18 @@ static void svc_tcp_listen_data_ready(struct sock *=
sk)
> *    when one of child sockets become ESTABLISHED.
> * 2) data_ready method of the child socket may be called
> *    when it receives data before the socket is accepted.
> - * In case of 2, we should ignore it silently.
> + * In case of 2, we should ignore it silently and DO NOT
> + * dereference svsk.
> */
> - if (sk->sk_state =3D=3D TCP_LISTEN) {
> - if (svsk) {
> - set_bit(XPT_CONN, &svsk->sk_xprt.xpt_flags);
> - svc_xprt_enqueue(&svsk->sk_xprt);
> - }
> + if (sk->sk_state !=3D TCP_LISTEN)
> + return;
> +
> + if (svsk) {
> + /* Refer to svc_setup_socket() for details. */
> + rmb();
> + svsk->sk_odata(sk);
> + set_bit(XPT_CONN, &svsk->sk_xprt.xpt_flags);
> + svc_xprt_enqueue(&svsk->sk_xprt);
> }
> }
>=20
> --=20
> 2.17.1
>=20

--
Chuck Lever



