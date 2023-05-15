Return-Path: <netdev+bounces-2626-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C610702C27
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 14:02:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B8665281205
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 12:01:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3054C2FB;
	Mon, 15 May 2023 12:01:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F2A8C151
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 12:01:57 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D539410A;
	Mon, 15 May 2023 05:01:46 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34F6Toei008218;
	Mon, 15 May 2023 12:01:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=pn4naWlNi25YnZM3BNl1vnW5W3nXKlHAFEX8SUdXFdI=;
 b=mUWGp/aZT+X7sgG+poEwPbLMmPmsDvkv6iERnyGN4vjrKPu7MpiIr2uPrsnp+si+xTqE
 j6Eo8PFzixuS7XiLhvII08fTRqeN15IP35OeF/Pzrm+7ingGpScJsxckYCynqaxCDRWP
 u4/iPBPWYEja3K8Hhhryf11f/pVVKP+xs0//kbVeyYYA/ZQyJ4JQM0iQTCMTXajN1apS
 lZ4suW1owNV7pCuqDlHpJBj1uOt8K4IE6qIV2jCdxPJw2T245HbBdYguzpAzP5ZgQ8AV
 mclr3HP2PiaE8Qkur2+Ix03VBwBD9W6joottxdvIrIeGYcsKYSYNEgnbsYReKweQhS87 9g== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qj2kdfu4p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 May 2023 12:01:30 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34FBkCar029518;
	Mon, 15 May 2023 12:01:29 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qj102jsbq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 May 2023 12:01:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EQIGRzGWBWkNk2pyuhLWdliMT3VW9ezpCgEjZLdREG6YdmY8sBMQ1dy2P35hD4/K6n3hNHEmzupBmrk7sSZnkFwtrIyjlvMfvlqRVnZuuLcRyPu9b+Sfs0qmJJ3OqfYbliOohtL9+ilmGdxIQbzuzJ0ts2nH4Yb3Fqcm1o18zQxmVzxiVQjoxVatZSFHh/lAN1FhXtyqmf1TyOlbc7FOjCIXnBiFe9gEjzicLJkZrzzHKwN7B6cZWy7NbHHh5IJ3ifwhEC1wJBchbRvgRMwVVdBljVZppKRaeih0TnuMQZ8/K8x3+BEu3qaWNHZ/7WsWPin4gAHYMSsxWwmqZtHX8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pn4naWlNi25YnZM3BNl1vnW5W3nXKlHAFEX8SUdXFdI=;
 b=VdXHebxuFZfPEk5RhfVZhWCCRvIk42lXnQxQMJgUeEDy0y7KDw2x6o8wK3M6B7DOqk8RVkGZDYPio0BD9cFyNWmRT6yuWlsowep577cPyakUlEqTPUuV9sZwCT5qm8yY5vFSX4VManZlw5OMlKh5cf4IGZmuKC0SKTEEyZftO0qqzOcFw8zIZTXP15rhxgG8bU62WKKt1z3kQmmOOVkd34WpXPFOS5/G1mf81JlGnRmpJOch4Kc/5Co1ghW4Ghv/8zie9/KPTV/3SJ8I+jICTmp5+yAiFZGxoFVBnhSUN6Ky3OoXin8nlKLk087qAgv2SPVokfUxZfPpc5t3hSLyEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pn4naWlNi25YnZM3BNl1vnW5W3nXKlHAFEX8SUdXFdI=;
 b=D8CpmqFYDPn6T9b3PxUVWF1R6zdIKtajxuf36A2i4nGBfaQbqhUDX9HpNr/nImnPZNaqSntEbgw/cvWnbXXvfNa59TUJRMqBXNe6lei9HpNDIDydY/6SURLckLz9yKehsGSjIv8ZUL3G1iWrHAQT6AG4BmGNfjfMyD9qBqulkKc=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by PH7PR10MB6250.namprd10.prod.outlook.com (2603:10b6:510:212::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Mon, 15 May
 2023 12:01:26 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db%5]) with mapi id 15.20.6387.030; Mon, 15 May 2023
 12:01:26 +0000
From: Chuck Lever III <chuck.lever@oracle.com>
To: Ding Hui <dinghui@sangfor.com.cn>
CC: Jeff Layton <jlayton@kernel.org>,
        Trond Myklebust
	<trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        "David
 S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub
 Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Linux NFS
 Mailing List <linux-nfs@vger.kernel.org>,
        "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org"
	<stable@vger.kernel.org>
Subject: Re: [PATCH] SUNRPC: Fix UAF in svc_tcp_listen_data_ready()
Thread-Topic: [PATCH] SUNRPC: Fix UAF in svc_tcp_listen_data_ready()
Thread-Index: AQHZhtLq+L3kSAzUU0ymb8KZFD5YDK9bPECA
Date: Mon, 15 May 2023 12:01:26 +0000
Message-ID: <65AFD2EF-E5D3-4461-B23A-D294486D5F65@oracle.com>
References: <20230515021307.3072-1-dinghui@sangfor.com.cn>
In-Reply-To: <20230515021307.3072-1-dinghui@sangfor.com.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|PH7PR10MB6250:EE_
x-ms-office365-filtering-correlation-id: 3621bb23-1e1e-477d-6baf-08db553c1c49
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 z+J2BAGE+4SXDxFJ3Gh+QIpejKdYcti8vI2KeU4wyWjD68+SRMiYuvArFkhT86tnPnnLbicVhbWe9P8NsB3RnIcPND0ynxeTaKE9YSkNhT9k8gVrJGi6sqXb4A4H3XG9TDtoR+zPMTN/DBCAQeCUB6SX5pggBl3/+kjse7bZSCBz/Iu2wvOW6aHcu37vmPNEpjZG9q4jdyi1kNHQ0lZIwj/nVxNVsIA5s/UoNkRXdbrbraSxxQP3iC40hMOgKrQVPkOfPZz12xoyP4bVu/ulr6Vu+dx3U5BuoDeZHD51By+VSpcFE1mN2L99+3o3fcdvRz+eMb18PKsisDeg8ctudSMdP/uia49uVwBiHp5lOmLIZpOSXc9NU39SRfwimxPGN/kyTwGazwFd5ntiA0kK1YGZskWLvp6qc2hl4BrFymS86Gn0iLYXqVP9Gd0xxwxNlBDX71Fo3MumpxZdwPVgGwzHk8MD8K4U47XfRkucxquUD42hqcP/QziBY/3TMUy+X0YjdAxXf1aVPDF9Z7Lick2izpKpQ8T0es7n81Io4/VM726P2XVrlC2Zo9Ll4VhfxP7B2mj02O8BfAJGLWa6iADfpyCZdgQOvyxQri4fTI/FfXHnJQlT4YjLgFD/wpQyQkbGUK7gm9hq0/sqxVqyug==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(366004)(396003)(136003)(39860400002)(346002)(451199021)(7416002)(38070700005)(38100700002)(2906002)(316002)(41300700001)(122000001)(5660300002)(8676002)(8936002)(36756003)(33656002)(86362001)(71200400001)(478600001)(53546011)(26005)(6506007)(6512007)(186003)(966005)(6486002)(2616005)(76116006)(66946007)(91956017)(54906003)(66476007)(66556008)(66446008)(64756008)(83380400001)(6916009)(4326008)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?XuHDbbYhTH2t/NfCzVQVq5R7Zw26PeM9AnZt7/odNNOq1GJBQVo1LOQwvnM0?=
 =?us-ascii?Q?JK5lJIgGhzfA8EWlXjTl3wF+DdY5wchm4EfrYjeeyQkJCjNsqdIdriIbPMbU?=
 =?us-ascii?Q?zwQLMqhXOE9X7oeRsLSjitVrtIpHpZsTFhbddydpAj+Lbzwj3IL/m3iQoHTl?=
 =?us-ascii?Q?lOtHDb9Sbs+5cSSMlNjQDzUEUXyP+h4HC0eZw+EpZmdI6V/xNsYrZISW23jc?=
 =?us-ascii?Q?egXo6i31rIwvp2gARyIEDHBEf5cgz9ten3BKE+VtuFTIzHXm5GMS8nlkMHDb?=
 =?us-ascii?Q?sMIyVk9IkQvmUKHsY9LrYnq/+t85NZE82P9MNu41lTl5m2Kw/mNY7R8TdGk3?=
 =?us-ascii?Q?8wfW6nYqBffirPwypSlUP/weq3H26pERwafLmYmii7VV3bJHMOiWKos2GiSP?=
 =?us-ascii?Q?LInrhN61R8vhzG0JUBNA9l/lyO7+QmiPCHsGxhUhQltrAuR7HJGbiKZze50M?=
 =?us-ascii?Q?n50VrN9sQeGPWhCK6FqBSHFOWFORbtDiODJPu2A84AxHaZl9B0dPYPMF5q8K?=
 =?us-ascii?Q?zcbHqwk26silWKQfmHyGeQ8DEtoafyFixb084mbRUqK1ZYIrPWuBgQKY7s2c?=
 =?us-ascii?Q?0zl/bOSYH0lkBRDcOjmPAeoPU+v/y5PxlOzqo5+SuWOOSbuJD5DgbQu5Wl5z?=
 =?us-ascii?Q?0FeLs0pKTB80G/FAUqCMQjR6h8Vgdais7vVIqoEb12SznbEHkaOx0fryOwJ9?=
 =?us-ascii?Q?SdN+KMiA1VN5npu/l+yQq6XjI+wnjs4ACO8HXXPFrUWIbAJfSm5YjBFiJ9N9?=
 =?us-ascii?Q?e+CFDVnEarultU7/Ln4eNtJtYm/KqCZ4PYBnXX0kFxBoUlfyAQiBLWnSA7y1?=
 =?us-ascii?Q?yy7XpxnUWOHk1JpGiewZ6ztzQu6JNSLdYy5g53UYP6Iwnh8nmYILt+GH15GS?=
 =?us-ascii?Q?8GMwAr6X+QGJGnt9fesMFMLZhv5Wk0Q41AmDdpoYFGv2d+TNioAC1LF9tj1U?=
 =?us-ascii?Q?NRMeBMUhQSIZd65Za9FAW+IWZF92CC9N377lw52E/o/PGrit1GS754YmCVF/?=
 =?us-ascii?Q?ecyaATmht0mfYXafErUgKKNS4/tuj5RI4xIsLF4g4/Du4n1kruN7XSCN7ol4?=
 =?us-ascii?Q?DO5QYBLqx5hsmROBT+Lw4LqqsrnDs8NGVCgbjhFx7hL2Yo0nrMPPQW36y6d3?=
 =?us-ascii?Q?2w5LpwDeZQ6Y9Z/HXPvF7Nv9NLGt83fvbOeKHRGsWVBPvHtvq5yNLp1lZ7ma?=
 =?us-ascii?Q?S1rchgVtPba7mBo5Xj2V5Unn/WSPJ9/5IFYvG7tqMqGOaFp/lPb3yEXsW0+3?=
 =?us-ascii?Q?C8HpHRo5kJDdaQu9yXBf2cIc1aNWujiF4/2J/vOG/qGOL2YpAzgAvWmkG5O7?=
 =?us-ascii?Q?FFMk/XYbRBIOigGxarxV4VDqdRlRi7oymyUTfgwkAwnlSPi5eZZzZVr642P9?=
 =?us-ascii?Q?6OaOx5EZ7i5iAYPQnj/XCPoXkIrRND+02VJrs+gzpXL/a4H6N8mE1UDhUbs+?=
 =?us-ascii?Q?Ih7sEAYERk/YQGgf1Psf+vLCLA6d9m0m9xIsNFw4s9zfnXrkCGVT0WYHP4K2?=
 =?us-ascii?Q?CphufOFDJU8wGDi0297Bz2RTxBejqxcVZtuKvYiMn/BryKNPKBOVVq42W1Se?=
 =?us-ascii?Q?+uBNJur+kbukM9SLC8Q0kITSthebrpg8Uj3Ulur96MTzoLBZ60Q/vmP8yMrJ?=
 =?us-ascii?Q?qQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <A2FC8C2B379F084091281B8DA8034FBD@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	=?us-ascii?Q?sd0ODBIj0YTqS+p7epXGZR0hgR5flm9oHhv5qckF4cxsR0qOzXWdQ3JYfOVx?=
 =?us-ascii?Q?5Oxk1UTv219U9NvC16IEwgWaEvusqllQ+RqMhNowPwhBcvGTLidzitrPUNjM?=
 =?us-ascii?Q?3CEiDdb6v4qoxTe2qGxFXpSaAyHWO3p4wM8xMtkz3sj3HJmAJUcYdsjvfvYB?=
 =?us-ascii?Q?HHM6XHS+WLRxUSYQBLSytlnvy5t3O/CVtw2mTMeF/C2mPlNuk0R1LI6QzAcq?=
 =?us-ascii?Q?mRiyjRH7YdEuIc9KzNe3HfdJP6RK5Tcp0RDofg4D2Rn2Hit3lTEf/DxX4m6s?=
 =?us-ascii?Q?NU6MQAV3XAOBIvEJeoTSuZxfFDV+Wu71CFmoUNakS6AW9DJTlhyLUAZwt/4P?=
 =?us-ascii?Q?1Cq2aN8uif7Ax3kIWJ76vUFyicmh+VcJg4f4eG5fzH7rU7f/hq+8AECuOoPi?=
 =?us-ascii?Q?ddxDHW8f+Qr/PqXzlWPCR+X72ETjTSci+nXx3g1Q8i6wiqxT1bsgz2gQLDyc?=
 =?us-ascii?Q?DuZ5f7wgktOTstg/Wwe6RVbuDFfFRV7zaOAmRaRQU+SAYUa4K9JrLXrLIsBQ?=
 =?us-ascii?Q?yHslowRVKTVEFRW1MurdD4PbSIlLZBwixIwuaINuJU92htBVS3X8bROxCcuA?=
 =?us-ascii?Q?Hh7PRTQ2kIgspeLIH/Sl+Z1U4cVhoHxJ4Lb7x4APwMwlkBRmxxlSnakzu5hh?=
 =?us-ascii?Q?CnD2INJDMyiAK5GDSjowi53VaFAEYQOB6ERfEJMnPyJZRsLWE/vDmmu0rARJ?=
 =?us-ascii?Q?EAYD8Vjfn7+LZl0lJ0uchJhHKdFCviBjLKeGDaJZPEP2D/kiBRcjAa68WSJL?=
 =?us-ascii?Q?nbYhDA/x09OxsTdpbOjAa5a7wZJQuex3583Ok7bxgydBQaBvTxSQkgvWQhl0?=
 =?us-ascii?Q?FqZti5CV1ye0Xf7oaBn1+Aum0KQP7G2f52gW9Eb/KFHL5TZ9QahCoFB7ZAij?=
 =?us-ascii?Q?nHrvsiE+bJBx8QiTWHQ8Oim59NHWmxjD/CWXE1gHtf73jJK+aU0sh4BzUP8d?=
 =?us-ascii?Q?1I4/Nh7pvh5ZaBpG77tUBw66M6DXRcl/XFciM2mww6U=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3621bb23-1e1e-477d-6baf-08db553c1c49
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2023 12:01:26.3974
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FWHzr/km6DarXLeBKM78IWDOOr+xX8oOYJVO6A7bjoPZYWD1KOmZeCDCrO/X2s9cMyFUjEV7sbsx1r2gaBGBvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6250
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-15_09,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305150104
X-Proofpoint-GUID: fXlX5oxPFs4RAvkyLnZG80mrVvhiMI-Y
X-Proofpoint-ORIG-GUID: fXlX5oxPFs4RAvkyLnZG80mrVvhiMI-Y
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> On May 14, 2023, at 10:13 PM, Ding Hui <dinghui@sangfor.com.cn> wrote:
>=20
> After the listener svc_sock be freed, and before invoking svc_tcp_accept(=
)
> for the established child sock, there is a window that the newsock
> retaining a freed listener svc_sock in sk_user_data which cloning from
> parent.

Thank you, I will apply this (after testing it).

The next step is to figure out why SUNRPC is trying to accept
on a dead listener. Any thoughts about that?


> In the race windows if data is received on the newsock, we will
> observe use-after-free report in svc_tcp_listen_data_ready().
>=20
> Reproduce by two tasks:
>=20
> 1. while :; do rpc.nfsd 0 ; rpc.nfsd; done
> 2. while :; do echo "" | ncat -4 127.0.0.1 2049 ; done

I will continue attempting to reproduce, as I would like a
root cause for this issue.


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
> Fix the UAF by simply doing nothing in svc_tcp_listen_data_ready()
> if state !=3D TCP_LISTEN, that will avoid dereferencing svsk for all
> child socket.
>=20
> Link: https://lore.kernel.org/lkml/20230507091131.23540-1-dinghui@sangfor=
.com.cn/
> Fixes: fa9251afc33c ("SUNRPC: Call the default socket callbacks instead o=
f open coding")
> Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>
> Cc: <stable@vger.kernel.org>
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



