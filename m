Return-Path: <netdev+bounces-3939-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DD87C709A8D
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 16:54:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 86D8E1C2118E
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 14:54:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CE7510950;
	Fri, 19 May 2023 14:54:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63BF5747C
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 14:54:32 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3B3A189;
	Fri, 19 May 2023 07:54:29 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34JENpiY000437;
	Fri, 19 May 2023 14:54:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=sFvV/XRct16cFAiQOQSXTyBNJIAjGV6UeuYhXyBg2k4=;
 b=OZI8UmCPn9OyP9lCL1NHMPvBZdIUX07ic6sXH94KkZAMIJIoikcdYR9x1CWiGRAYlyta
 gTp1zEpzYJQwlPFiwb6qZhiobKFD3P4zhzBa0yj+xRDn5BAP6EIXBX1acUiWsk4vY0DC
 Lfj4NoUj9fM4VIHZZtFawttjNQsWgjvhjAED9UkDOUH9Ap2VHXEhg74M+WIgmP0tZD5y
 4OYPwuumRX0pahjd16EAowk4mD5qHNbSSrhxmq04CE+6nDNH4+LvqsLm/S40omRSFUvk
 XwnfiwehuYurzNRS+YuGwnr5TjXemXg1fwz9ywrpP+QlVWo4dA2nwUIpIFqsCPhGiUQZ Lw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qnkuxajf5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 May 2023 14:54:15 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34JD1b1O033861;
	Fri, 19 May 2023 14:54:14 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qj108nk3m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 May 2023 14:54:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Macw3PacKn17wclfomIpWlAwIL3aPIzYKGJS6BWDh6mtzSPczU/9oLAzDvAe/1dak4IkRE8I0tpt6mhwKHdKwR13Kw8GaKWAHdi7XeQsG+1aiOx/i8re4qI9OjySL3USCm3ITBtLvd2iIlxof4lqCO/cplXmaDnG/GC2jZrmsRbh3BVy1v70X7EO/YrzA7PC8v0BrhOlxVH/fuuVlu7gOB5EcCLj2XW5omgOd1GKKpFb7oXj93jzgO7kvZrqmoEV8EvH22qVnhk3N7MqCaUp8qN9FfljRh/W5vIvMe6TAxkx+8SIxVPIHl3qxqieIFdwdA5uWkMtGnqdd64YX3pxEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sFvV/XRct16cFAiQOQSXTyBNJIAjGV6UeuYhXyBg2k4=;
 b=QMwyrQHsT4hyxiiWL1Yb9ZBjHg+/rxKek1SC3n8ikgDGMp+/BNakyzHrNPs0VPBufoRw55UioCJsHwL7g1G/+8hz5AJWOwi5moXJqj2aRJXQF740LDO9HtV9ylAcqY59L37ZKq5aaF6jeEj0eB4xv6XgTFyp2t3fs83mFVMI9bIUW6g19/HG8OXWzFD5C0RKG/PC/Hi6d4wxsGl21jpJ50wPJBUdiD0UeqFljl0vXov5PPIXE270LnHdo5G+Yk0KXPcJTKHnSGnTZQ5f4iP8nUQaJiIBjK+wNqQln0+bWDEk27vm6WbufoduEzoj8q4USuap6vMzQJVcMDP4kHWDgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sFvV/XRct16cFAiQOQSXTyBNJIAjGV6UeuYhXyBg2k4=;
 b=IE4MJ1aCxcMGZVC3rZYjibT3dYkPq3EFCxuFQ5qa52jHYoAXt9qHtO/UCAG8ZZrY+VegfVKnHZLfnzcUIEQFeqajQR4l9UQPg9SBQSi9LUkKopy03S8NNRqntb49PMs/m8+8M0EC4AKoraLkWgXQ4kRShCtD7YEpRGabjDsN4EQ=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by BN0PR10MB5062.namprd10.prod.outlook.com (2603:10b6:408:12c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.21; Fri, 19 May
 2023 14:54:11 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db%5]) with mapi id 15.20.6411.021; Fri, 19 May 2023
 14:54:11 +0000
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
Thread-Index: AQHZhtLq+L3kSAzUU0ymb8KZFD5YDK9bPECAgAAwmICABkkAgA==
Date: Fri, 19 May 2023 14:54:11 +0000
Message-ID: <D2F7BBDB-B164-4D38-B4F6-AA33F1EE1773@oracle.com>
References: <20230515021307.3072-1-dinghui@sangfor.com.cn>
 <65AFD2EF-E5D3-4461-B23A-D294486D5F65@oracle.com>
 <0c007040-be5b-a372-6fb6-8ce1b601d74b@sangfor.com.cn>
In-Reply-To: <0c007040-be5b-a372-6fb6-8ce1b601d74b@sangfor.com.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|BN0PR10MB5062:EE_
x-ms-office365-filtering-correlation-id: e2cf79de-ffa4-41ca-b887-08db5878e831
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 i3GO9GipOkKmzOUO6+optYlAfsQHajbT0VVH+od1Es3a1CEVA4oislYJg6/LoQbIZkTxFEziEQbmq8QA0TMu6VyP47okHNIoFOR3kAVogeglgC2PS3ONZUnROLGmmavHU3k3sjqnb4upSYTo0V46m2PwNqqp7kGsYzem8hhxbB/bw6Vqn35hShPiFgL9Bu7rLCn/1wBgd8/9yA7+xirY10UR9r1O1p3w65yE3RoblhrnNy/Owlczy3n40oDm/rHioZP1r8tAvsYnq98WF70s219X7vVvkF6x4WYnSFw+HMCsmnd/zpfLQ0oIB2omT2qBrkGnw9mHpz1HXN6+GFUqs4mdvWwT4HGztQWdUcyhf7i1hndPefKdEPdRpzfcmJr0Ez60HPSJZoTsQRLIpOZMfk5kKldDE1yovrDB9nV/YpSyREvHL8B5joLW9Fw4cMoZAkN5tQPJlJPhFN9oZEq89KuHZ5W3IVBhirWdVrarucGcn9DIJEgV7EKBidvHbDqsQ4FKjVtqvNbySWC4AV9MK7C4rD/oTyHwOhQCGP/dltrV/cHgrdEtCjfnIYMytikWEHXTzzQDT0oJ+D1OdMn9qGNaD0jmxxfFfS0Sn4kL2KGa2t0zxuxKLEtAYSrshtdqFkuSf/jimwAf3Mhvv8AElA==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(366004)(346002)(396003)(136003)(451199021)(122000001)(91956017)(64756008)(66556008)(66946007)(6916009)(4326008)(66446008)(76116006)(66476007)(54906003)(8936002)(8676002)(478600001)(316002)(41300700001)(6486002)(71200400001)(966005)(2906002)(33656002)(86362001)(53546011)(6506007)(6512007)(26005)(38100700002)(83380400001)(2616005)(186003)(38070700005)(7416002)(36756003)(5660300002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?rMaEd4pE3CawVk2WeBLSi+3GOg/50b0PmIJH/FFjs7dcTY/qavmDJRV1OkYT?=
 =?us-ascii?Q?ihgnMEgVL/QOLFpawxCna8UQ2HC8gTVKFMoURzLL4/nXQM0P/WTfs1q2nfcH?=
 =?us-ascii?Q?3WAs1cnP9u4SheNkR2GyP70l7JiDWaKE1LHYjXF6A2J85UQd79YJbIl3NOm3?=
 =?us-ascii?Q?MldcATlzWxy7pg3SfVdg/Z8sldhxOJ3h7IU1/FpesKLLAGB24zqA97Z5Bti4?=
 =?us-ascii?Q?yi04vRdp/aiSy3NK70Qqrq0RsQTDrORqLCMRp9uuIOc1XNSr3gNdBcps/nKX?=
 =?us-ascii?Q?I0E+KEuAbkcS9Ixi+Pe/TJYorN4y7yEVJYR6Ki2LL0fv6L+jvwN95gMXd26s?=
 =?us-ascii?Q?Ge1KGVMnCAx4Njjmw79nIVTyeS/hY6Hbe3XbmNC4xtPPBLLF2VvTa0iYZuJ0?=
 =?us-ascii?Q?r56ECTKOp6kHywtKQxNiOR91sdotzb2UXVfQPP+BJWEH13r1WvH7N7+QDKGy?=
 =?us-ascii?Q?YYEYg9R+sTykZAPfTey8EoB6e0dfFqgtxbF4S0uS+rAfTY91Vm1KD8XMU2XW?=
 =?us-ascii?Q?XZ+rBxwELTP30swahItCR12530EHeBB6lPDkYoJtOAOHTzAw7wq50IkJotUa?=
 =?us-ascii?Q?IYvtrVazwImk+5Wsq8RQBYbxPMqIioUHeYDmOicsDCN3la30wsk36Pdw6gtm?=
 =?us-ascii?Q?OcJVKRXo7oUl14nQRFLEJT2DCC3bcWKP+P2sf7hFyNfxn+ouqBZ5dgNTcRz8?=
 =?us-ascii?Q?jB2g62AvbFzqR+Qslw5dyU7tMyJik/Og5XEUmhdMbByt8BgkPy7N+0WHNzmx?=
 =?us-ascii?Q?tl29vT6Ww3RVpKKE3CtoHMUtWuvVejGDa6QuE2LamJPDCOeZn+aWihou2tXN?=
 =?us-ascii?Q?5U7DHOgpmxGZzDtJzGz47bWGK5QxApW1t9HJx4pSZIMjHC5j0II68WnQ7DNH?=
 =?us-ascii?Q?ywIyUUErC0Q3tC5J8Rzb3em9F1jgwHZM1s+3qBDYR1jt1HN43lEh7z/bT4DH?=
 =?us-ascii?Q?eRa6Gvblvuk3QMfVdimGZT15gF8k9T7wFGx8mD2I2zQQhElGvysdn9geHvAj?=
 =?us-ascii?Q?MwKp0afNIUd5g4FVU9qBC3HgLPBABNRENljwM/zdApOjg5Vz9xXklTMdk9rU?=
 =?us-ascii?Q?7+Wu8nCjY3pYFa/ZmgyJAQmTfZg02QbCKayOCN3GGp4mvszqWj6nvranO3GI?=
 =?us-ascii?Q?ETgqEATmEACRKZJav3wjo0rthJgJ5GnOvawWq+m3GCrmA2UvFQ/EUVU17qdq?=
 =?us-ascii?Q?OgxbXhbMEl1uPndGGvY7IK/T98ayFcPGeWaUo3Gnn9pJv0whLuf2+jp39XPt?=
 =?us-ascii?Q?l9uWyzQI7iAZUZZ8FuJWJwlCyqcN2MPbcbgIBvTRasrJTAlKxJP0IvHpV7GK?=
 =?us-ascii?Q?AVQUl0rZQb/UhSI/haa0mUxf4YEuzWkoHsVX6lDzubNHEqxqpbk/kVVB7bzw?=
 =?us-ascii?Q?KMvL/F2pfkgvsPMBNF82/lVUQh2nlOsv/9LIf2m5Oaowjs9DGvY4Gh4sr2hf?=
 =?us-ascii?Q?M2IEsV1la/a27dgO5v5cA2IY8fhhNy7k4xU89Tf5TDmwgFCpCsbQydvJlJmn?=
 =?us-ascii?Q?finAwqSUR0mpOqz/HAlOqYiNISQszzwCtcqcVEUxpibZzXEx3E8AE8ZbOhG2?=
 =?us-ascii?Q?qcxWrIzT3livTWuO9qLta5ObzytjfwhW0r7C/s5SAO4tz4IcHG02iMVSqTPh?=
 =?us-ascii?Q?2A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <EA6ED78FC8635B4E99A7F685CC78E937@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	=?us-ascii?Q?w+1iCkSpwk9ER97FmwvDILpDnyt2XrBlFDMwAMLKP8WGCd5zSU6RKFlp4QN+?=
 =?us-ascii?Q?m9jk86zTqhSc06mk2wAILi/X45NSVMsSxESBgjORJlQT2w3X8KWl173i5WFS?=
 =?us-ascii?Q?+Gp/2Dl/GxBJKlpwN5GXum9XpqZ3o/rXWdteBZqNJGV8b0U6Q7lOZgqws1mp?=
 =?us-ascii?Q?2SEyaFD57+SYqlb/GsMuNhMXtIqihxFprTfDD/RpTuv6nXmfl6B4RStqlLr+?=
 =?us-ascii?Q?eLjhYy044utBus4IL+MUf36yeC7rN1lYBsdKGZ+jDzKaCNFkAbZvueNgoh/0?=
 =?us-ascii?Q?dj3SY0tOusTbAyNBHhISivoyiwIaBG29ZwyYLQnets8z0nFlf7LDT+HL/IKV?=
 =?us-ascii?Q?6TpTuOK1SRl45DyRPXAqpuyBn7DWievw1/CP6Ij0Eco7rLk6+pn+JoGopFSK?=
 =?us-ascii?Q?O0/tZs2fvsRyChwAPwJS4nCS6QKnxsA6e/A6/vqILORykGwFOTJYSvmm8JAB?=
 =?us-ascii?Q?HppAvCxAYUe1OtXaIUcDkiLsnniQlbQF6NOe5OMUtgsLfdk1tRjQOrReHmXt?=
 =?us-ascii?Q?m3LIw2Fuud4X/+CE2Sng6KJSXfpMfjmKEHwweVMVCAtQoqfkzIdEWjuiWPw+?=
 =?us-ascii?Q?YYwuy5+lR55F9/dqXe8WQpfr8LTWrNoTHgN2V9jFkYfhL0mBgDNxSaBUtNq6?=
 =?us-ascii?Q?REfIwmp2Uy84FlvfcbqUZ0L+6zELgLzIWuxPuetmdFos0Cx4L/uKHpS382za?=
 =?us-ascii?Q?PHKfIcBpX24iwxTbi8H1bHszdznSeuav8HDgKsMAVWfxyCTvKPbU6ef15AAm?=
 =?us-ascii?Q?/OdKc5BC5LcXF9QtFntx9pHwJLE+aDhHLDTHwl+/wRuBMP/F+F5T8zoJJlwI?=
 =?us-ascii?Q?N2sg/r0HiPn6eXbYn0afOLFrsWpAUDytpvCb+Iswn5eihyffEfqdvqwi12fo?=
 =?us-ascii?Q?pwwEjnpKccpA3GB4VLwKTQaBLGZl8BXLd2/4yjJQuE0ebL6GoTS9t5J3h7me?=
 =?us-ascii?Q?LsIvHI2LAKcJt2gqjOurIw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2cf79de-ffa4-41ca-b887-08db5878e831
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 May 2023 14:54:11.7346
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pP2EKgI5LgHah38ZFOWvbACf8ON+xDM637MaXPOmsXVAC/fBbruEduF5CCg+/lq0mCitdiOpUfFZ1P4LgIyjRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5062
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-19_10,2023-05-17_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 spamscore=0
 bulkscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305190126
X-Proofpoint-ORIG-GUID: xFnMcaF6QNkAFNLckE4CBt7zLhNQBBbd
X-Proofpoint-GUID: xFnMcaF6QNkAFNLckE4CBt7zLhNQBBbd
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> On May 15, 2023, at 10:55 AM, Ding Hui <dinghui@sangfor.com.cn> wrote:
>=20
> On 2023/5/15 20:01, Chuck Lever III wrote:
>>> On May 14, 2023, at 10:13 PM, Ding Hui <dinghui@sangfor.com.cn> wrote:
>>>=20
>>> After the listener svc_sock be freed, and before invoking svc_tcp_accep=
t()
>>> for the established child sock, there is a window that the newsock
>>> retaining a freed listener svc_sock in sk_user_data which cloning from
>>> parent.
>> Thank you, I will apply this (after testing it).
>> The next step is to figure out why SUNRPC is trying to accept
>> on a dead listener. Any thoughts about that?
>=20
> A child sock is cloned from the listener sock, it inherits sk_data_ready
> and sk_user_data from its parent sock, which is svc_tcp_listen_data_ready=
()
> and listener svc_sock, the sk_state of the child becomes ESTABLISHED once
> after TCP handshake in protocol stack.
>=20
> Case 1:
>=20
> listener sock      | child sock            |   nfsd thread
> =3D>sk_data_ready    | =3D>sk_data_ready       |
> -------------------+-----------------------+----------------------
> svc_tcp_listen_data_ready
>  svsk is listener svc_sock
>  set_bit(XPT_CONN)
>                                             svc_recv
>                                               svc_tcp_accept(listener)
>                                                 kernel_accept get child s=
ock as newsock
>                                                 svc_setup_socket(newsock)
>                                                   newsock->sk_data_ready=
=3Dsvc_data_ready
>                                                   newsock->sk_user_data=
=3Dnewsvsk
>                    svc_data_ready
>                      svsk is newsvsk
>=20
>=20
> Case 2:
>=20
> listener sock      | child sock            |   nfsd thread
> =3D>sk_data_ready    | =3D>sk_data_ready       |
> -------------------+-----------------------+----------------------
> svc_tcp_listen_data_ready
>  svsk is listener svc_sock
>  set_bit(XPT_CONN)
>                    svc_tcp_listen_data_ready
>                      svsk is listener svc_sock
>                                             svc_recv
>                                               svc_tcp_accept(listener)
>                                                 kernel_accept get the chi=
ld sock as newsock
>                                                 svc_setup_socket(newsock)
>                                                   newsock->sk_data_ready=
=3Dsvc_data_ready
>                                                   newsock->sk_user_data=
=3Dnewsvsk
>                    svc_data_ready
>                      svsk is newsvsk
>=20
>=20
> The UAF case:
>=20
> listener sock      | child sock            |   rpc.nfsd 0
> =3D>sk_data_ready    | =3D>sk_data_ready       |
> -------------------+-----------------------+----------------------
> svc_tcp_listen_data_ready
>  svsk is listener svc_sock
>  set_bit(XPT_CONN)
>                                            svc_xprt_destroy_all
>                                              svc_xprt_free
>                                                kfree listener svc_sock
>                                            // the child sock has not yet =
been accepted,
>                                            // so it is not managed by SUN=
RPC for now.
>                    svc_tcp_listen_data_ready
>                      svsk is listener svc_sock
>                      svsk->sk_odata // UAF!

Thanks for the ladder diagrams, that helps.


>>> In the race windows if data is received on the newsock, we will
>>> observe use-after-free report in svc_tcp_listen_data_ready().
>>>=20
>>> Reproduce by two tasks:
>>>=20
>>> 1. while :; do rpc.nfsd 0 ; rpc.nfsd; done
>>> 2. while :; do echo "" | ncat -4 127.0.0.1 2049 ; done
>> I will continue attempting to reproduce, as I would like a
>> root cause for this issue.

svc_xprt shutdown seems to be unordered. I would think that
it should unregister with the portmapper, close the listener
so no new connections can be established, then close the
children last. That doesn't appear to be how it works, though.

But if the listener happens to be closed first, that frees
the svc_sock that might be relied upon by children sockets.
The shutdown ordering seems to be the crux of the problem,
and pinning the svc_xprt won't help, as you pointed out.

Making the children not rely on the listener does address
the crash, but doesn't fix the design. But the design
problem doesn't seem to be urgent. So I'm going to file a
low priority bug to document the design issue.


>>> KASAN report:
>>>=20
>>>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>>  BUG: KASAN: slab-use-after-free in svc_tcp_listen_data_ready+0x1cf/0x1=
f0 [sunrpc]
>>>  Read of size 8 at addr ffff888139d96228 by task nc/102553
>>>  CPU: 7 PID: 102553 Comm: nc Not tainted 6.3.0+ #18
>>>  Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Refe=
rence Platform, BIOS 6.00 11/12/2020
>>>  Call Trace:
>>>   <IRQ>
>>>   dump_stack_lvl+0x33/0x50
>>>   print_address_description.constprop.0+0x27/0x310
>>>   print_report+0x3e/0x70
>>>   kasan_report+0xae/0xe0
>>>   svc_tcp_listen_data_ready+0x1cf/0x1f0 [sunrpc]
>>>   tcp_data_queue+0x9f4/0x20e0
>>>   tcp_rcv_established+0x666/0x1f60
>>>   tcp_v4_do_rcv+0x51c/0x850
>>>   tcp_v4_rcv+0x23fc/0x2e80
>>>   ip_protocol_deliver_rcu+0x62/0x300
>>>   ip_local_deliver_finish+0x267/0x350
>>>   ip_local_deliver+0x18b/0x2d0
>>>   ip_rcv+0x2fb/0x370
>>>   __netif_receive_skb_one_core+0x166/0x1b0
>>>   process_backlog+0x24c/0x5e0
>>>   __napi_poll+0xa2/0x500
>>>   net_rx_action+0x854/0xc90
>>>   __do_softirq+0x1bb/0x5de
>>>   do_softirq+0xcb/0x100
>>>   </IRQ>
>>>   <TASK>
>>>   ...
>>>   </TASK>
>>>=20
>>>  Allocated by task 102371:
>>>   kasan_save_stack+0x1e/0x40
>>>   kasan_set_track+0x21/0x30
>>>   __kasan_kmalloc+0x7b/0x90
>>>   svc_setup_socket+0x52/0x4f0 [sunrpc]
>>>   svc_addsock+0x20d/0x400 [sunrpc]
>>>   __write_ports_addfd+0x209/0x390 [nfsd]
>>>   write_ports+0x239/0x2c0 [nfsd]
>>>   nfsctl_transaction_write+0xac/0x110 [nfsd]
>>>   vfs_write+0x1c3/0xae0
>>>   ksys_write+0xed/0x1c0
>>>   do_syscall_64+0x38/0x90
>>>   entry_SYSCALL_64_after_hwframe+0x72/0xdc
>>>=20
>>>  Freed by task 102551:
>>>   kasan_save_stack+0x1e/0x40
>>>   kasan_set_track+0x21/0x30
>>>   kasan_save_free_info+0x2a/0x50
>>>   __kasan_slab_free+0x106/0x190
>>>   __kmem_cache_free+0x133/0x270
>>>   svc_xprt_free+0x1e2/0x350 [sunrpc]
>>>   svc_xprt_destroy_all+0x25a/0x440 [sunrpc]
>>>   nfsd_put+0x125/0x240 [nfsd]
>>>   nfsd_svc+0x2cb/0x3c0 [nfsd]
>>>   write_threads+0x1ac/0x2a0 [nfsd]
>>>   nfsctl_transaction_write+0xac/0x110 [nfsd]
>>>   vfs_write+0x1c3/0xae0
>>>   ksys_write+0xed/0x1c0
>>>   do_syscall_64+0x38/0x90
>>>   entry_SYSCALL_64_after_hwframe+0x72/0xdc
>>>=20
>>> Fix the UAF by simply doing nothing in svc_tcp_listen_data_ready()
>>> if state !=3D TCP_LISTEN, that will avoid dereferencing svsk for all
>>> child socket.
>>>=20
>>> Link: https://lore.kernel.org/lkml/20230507091131.23540-1-dinghui@sangf=
or.com.cn/
>>> Fixes: fa9251afc33c ("SUNRPC: Call the default socket callbacks instead=
 of open coding")
>>> Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>
>>> Cc: <stable@vger.kernel.org>
>>> ---
>>> net/sunrpc/svcsock.c | 23 +++++++++++------------
>>> 1 file changed, 11 insertions(+), 12 deletions(-)
>>>=20
>>> diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
>>> index a51c9b989d58..9aca6e1e78e4 100644
>>> --- a/net/sunrpc/svcsock.c
>>> +++ b/net/sunrpc/svcsock.c
>>> @@ -825,12 +825,6 @@ static void svc_tcp_listen_data_ready(struct sock =
*sk)
>>>=20
>>> trace_sk_data_ready(sk);
>>>=20
>>> - if (svsk) {
>>> - /* Refer to svc_setup_socket() for details. */
>>> - rmb();
>>> - svsk->sk_odata(sk);
>>> - }
>>> -
>>> /*
>>> * This callback may called twice when a new connection
>>> * is established as a child socket inherits everything
>>> @@ -839,13 +833,18 @@ static void svc_tcp_listen_data_ready(struct sock=
 *sk)
>>> *    when one of child sockets become ESTABLISHED.
>>> * 2) data_ready method of the child socket may be called
>>> *    when it receives data before the socket is accepted.
>>> - * In case of 2, we should ignore it silently.
>>> + * In case of 2, we should ignore it silently and DO NOT
>>> + * dereference svsk.
>>> */
>>> - if (sk->sk_state =3D=3D TCP_LISTEN) {
>>> - if (svsk) {
>>> - set_bit(XPT_CONN, &svsk->sk_xprt.xpt_flags);
>>> - svc_xprt_enqueue(&svsk->sk_xprt);
>>> - }
>>> + if (sk->sk_state !=3D TCP_LISTEN)
>>> + return;
>>> +
>>> + if (svsk) {
>>> + /* Refer to svc_setup_socket() for details. */
>>> + rmb();
>>> + svsk->sk_odata(sk);
>>> + set_bit(XPT_CONN, &svsk->sk_xprt.xpt_flags);
>>> + svc_xprt_enqueue(&svsk->sk_xprt);
>>> }
>>> }
>>>=20
>>> --=20
>>> 2.17.1
>>>=20
>> --
>> Chuck Lever
>=20
> --=20
> Thanks,
> -dinghui


--
Chuck Lever



