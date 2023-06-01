Return-Path: <netdev+bounces-7163-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BAF271EF34
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 18:38:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 30D78281885
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 16:38:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44427182DC;
	Thu,  1 Jun 2023 16:38:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3752F171D6
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 16:38:47 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F104B18D;
	Thu,  1 Jun 2023 09:38:46 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 351E4dM4022425;
	Thu, 1 Jun 2023 16:38:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=nGS7VcP3mPhSwKCHZv3eUjGTvfpR6oGGclPOQ9MbbWQ=;
 b=YXLSl6SVcEfQ/hU66slZvvD1iGrH++ybpk5db0xEu5IsYLakvvJ3YonspMBzX8P9Sobm
 NxlrL84/KDtoCLaA0/WSGf5Rys9ghb3AuECbp5xaOzTO1zj12EPsypdXKxWwPbJCH6Xf
 Sy5FqvtqxtDxOkLapIJiNnGlxYAQwJcCWPFDg9I7QxnrNv7Kvh08hWr/0QoYxnkPbgFL
 i08vs925qAp8pvNSac6kpD6UoT41H4+L4LJzFtL1V6MT7B2aWw0wdmkiX8+ALx9BBu3n
 p+vItvf1O8akMCYQ3AraFB951AgYREktxXjKk0dcXLYU1jEcNuIcWEcPjKynv51DTueC Zg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qvhb997st-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 01 Jun 2023 16:38:28 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 351G37wt014607;
	Thu, 1 Jun 2023 16:38:27 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2108.outbound.protection.outlook.com [104.47.55.108])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qu8a7eh30-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 01 Jun 2023 16:38:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hrcFVjrlpPin5hodDfoRkqecyeHcowhS6eX2gwwEHomfC6tE7NihgLFBG47Qd2vodwaRAzbwJgFAZ6uPNX/3qgjYey5q83k84GpC8U5zV1qRTEHvjRB+hCwgTH5s6gVXWkXbm4uoHl0g0Plwg8pTBnjw2swQwvbjESnJU4VtLpnviYBd16rw4HjM82oRb0KKHbUUR7bzVpPHq/GYPyk/uuKZl8RqNYrBaJAr58d2o9j9ck2ipuuhhxwY8TNE/p71yLp8NEQvh1+3ErFhviXhgjtEPL5FHy1kKx8y4qS9NiUXsKUtO7zaPxsLwgtD6WjCx87XmHwtn62t5pi6C/PkNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nGS7VcP3mPhSwKCHZv3eUjGTvfpR6oGGclPOQ9MbbWQ=;
 b=gA7IJQepr9c0Vc0j1HO3oOg2Uv0fsiu0QE4u0llTAsgSOCsxQYPTk1AS7ueIxEHYAj42fu+xDltJMtjR8/qMAsbyVnx2893xAK3jK3+CN2lRBl3ndLn6hyyCeMr+kCC0Rljf6hpfjMGeQNMj/qRKB7qRX9D9kwVVkRKrlbbQBVLydg0c5Il6sCdEeXsIFc9DoWqJuDRWsP//ufxn/gv8fKDg+wbEcMWu9sgs1AMoNodmX7XVpps3VFnJhl0vgnvGLvbc39b93Wob4nmNBZrKFjdSpPKgXTFal8BCtCV3opC9R5L6bNRECj9UYO4iD5xtwJr+AZyO9IjunaKkKK7aWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nGS7VcP3mPhSwKCHZv3eUjGTvfpR6oGGclPOQ9MbbWQ=;
 b=vtrH023YDVVHndsn3ecaZkw1XRKq6peo9n1YX0abvoB6Y1mQr+Q43CxtCB7ca1+d0LckFoT2sQx/QWXdeYDjA4wnA5fNfTrSEx0migUP5EPilFo/mDD/ToIKH/d4jNdtAvPisbdhFB+w5h8MysfJnaXVCf33wH9F9z/NRhktdT4=
Received: from BY5PR10MB4129.namprd10.prod.outlook.com (2603:10b6:a03:210::21)
 by IA0PR10MB7370.namprd10.prod.outlook.com (2603:10b6:208:3dd::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Thu, 1 Jun
 2023 16:38:04 +0000
Received: from BY5PR10MB4129.namprd10.prod.outlook.com
 ([fe80::ec9b:ef74:851b:6aa9]) by BY5PR10MB4129.namprd10.prod.outlook.com
 ([fe80::ec9b:ef74:851b:6aa9%5]) with mapi id 15.20.6455.020; Thu, 1 Jun 2023
 16:38:04 +0000
From: Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
To: Jakub Kicinski <kuba@kernel.org>
CC: "davem@davemloft.net" <davem@davemloft.net>,
        Eric Dumazet
	<edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        Evgeniy
 Polyakov <zbr@ioremap.net>,
        Christian Brauner <brauner@kernel.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        "leon@kernel.org"
	<leon@kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "socketcan@hartkopp.net" <socketcan@hartkopp.net>,
        "petrm@nvidia.com"
	<petrm@nvidia.com>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>
Subject: Re: [PATCH v4 5/6] connector/cn_proc: Performance improvements
Thread-Topic: [PATCH v4 5/6] connector/cn_proc: Performance improvements
Thread-Index: AQHZZCxMA20H0kIuSECLZNtWm5vHUK92gweAgAADfoA=
Date: Thu, 1 Jun 2023 16:38:04 +0000
Message-ID: <B9B5E492-36A1-4ED5-97ED-1ED048F51FCF@oracle.com>
References: <20230331235528.1106675-1-anjali.k.kulkarni@oracle.com>
 <20230331235528.1106675-6-anjali.k.kulkarni@oracle.com>
 <20230601092533.05270ab1@kernel.org>
In-Reply-To: <20230601092533.05270ab1@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4129:EE_|IA0PR10MB7370:EE_
x-ms-office365-filtering-correlation-id: 1fd5b240-27c6-44ee-0b3e-08db62be925e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 NWxg0z5sjD7dD/lJAwSTB4W9OTvUzpVvCgNLM8wLt/Y4BFkTBUSBK+FjK6i1I2pFptVc4MOunfIVCnHQCRoUiUsMgdM4uVJdqkR8LDSki15AINVVdqlC7OXRt2yrlr0mVxmTbIEjLGKlBy3l6NUdk0Ren/RVM78Czj+N1tGRpGdcfHh56bKvmEtU8SmJN6UFqLMahb3jRfxI5diGXGg2Nr+uC+tf8vWhgFKot7N9/cgvpuvRXmdGlAy6KBh7yNjpbIF9rQtv4PeRVICAC5q1v8XMXGz9hzuyJoGyWbBStHquDakm7dmd0wNtmWPkd1MY89AWnBsLOtZTIwIhOhry46Eyri+za8iUmpCjdKnBe5C0imB47PKWgtm457TA30Eaj3uUd3z05ECcU01MAkBKltSKbCyyX5wlyROfS3pHuNluQPF0DJxGKtkKxDf4hkxVjQpkP3/WSYK5ng47MFCh5eC6nCoRaDw4RNP5FxT3P/xOMDLDwfsVBvh96KLeNLTK7qlYF9BAC64Dqkl62/qCStw+liHperQwPId+BlBdGsJxk1gi7/5b6lG0LqrRuIoe/bC5FFh1+Xq5HXDyQR6JXUhgphij9+FKqGOnhkYZLmmwAgks77xwnFbfBDBlFmrYyfGs2Ecu4Yq6nWBStgViLA==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4129.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(136003)(396003)(39860400002)(366004)(451199021)(8676002)(8936002)(478600001)(33656002)(54906003)(41300700001)(5660300002)(86362001)(71200400001)(6486002)(316002)(76116006)(7416002)(64756008)(6512007)(66946007)(4326008)(66446008)(6916009)(66556008)(66476007)(26005)(6506007)(53546011)(186003)(38070700005)(83380400001)(2616005)(2906002)(4744005)(36756003)(122000001)(38100700002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?/4ZhalhOb/CmXHmChgESaQKrmve4WqsTXQopXgCRZOe8xFzV6//ex2tqBo3c?=
 =?us-ascii?Q?fOSMI8fkamFZxLmKQtxDSy5hd/PMJwEqFFEm5DVYXx+DWNyaDnztI9LaVDth?=
 =?us-ascii?Q?0mK8/smG2wlneHimZhyMlY8Ce8R/1r8EYVhGQeQp8Z2a7ugyWaYWxCP3j/Zb?=
 =?us-ascii?Q?T0nbG97UCOal9kgoWe05OgJTzT8y0BV8c+W1rayrLgUQrsO4AeCTMBclzzyK?=
 =?us-ascii?Q?rynvQ/1R9RKOAZxj5RjtLTjmzhnkpy+dkcurv16X8f2OcUPuf+S+GD9NBGpr?=
 =?us-ascii?Q?3FWcCA/0GPPUt9xq2LeyAwc44Td1VnYLNNiQeRrVfj5LsOb8ad/Xz3Uxz4kI?=
 =?us-ascii?Q?Ho+wGX59kTquCc3pWvOF0nWqvOOkN38CUB/hYtUr8KNuQuzj5QhR9RJuJlpx?=
 =?us-ascii?Q?l+niehHJyiDFHsNdUh1KOCAWjJjcjiZCivMy7syL92VDhTl9YVirMzo+z//a?=
 =?us-ascii?Q?oK/AD1wtjfBy74gYbH60m0FIz891SyW/jiDNQEE1OazXDXD5d1bLjBHfc26+?=
 =?us-ascii?Q?X3Puf8p5Y2y67QInIPKv+cXddtvzWVKXDaFsdUxsy4pyT32dU/OQ4Jpqeema?=
 =?us-ascii?Q?cgW6cd+PsFvD4xrhgQtFd/6+CMk4mBc+FNoScWbChed9xYdsPvfQ/pJP3zwU?=
 =?us-ascii?Q?zNfZ3MzQSILlRRzuGNFFpkD/dUk/JTX5Tig4D0xuIzozg5cDAKFE0I48PPWW?=
 =?us-ascii?Q?zKqtfqhNt010Kd9btXLToufU7N/+/dfolDSgSlz+LRy4FeikY9Zxc8UalRre?=
 =?us-ascii?Q?sDeYhaCvmMmOYGcP0e3BbIswYsDY6ONRY5+My9pRLV3W14/VYbaOHXS/XNJR?=
 =?us-ascii?Q?//uHhYDr+2CtJlUq5mpnq+mTgkK7LaXoI8kTHXDtnUjDCTWTHHxwNc9HIJ0g?=
 =?us-ascii?Q?gU7qFxYF9rTsyhKHu3RYGkpZRbCYLViL0i2Zzdh77c0j9mmTxPV2qoxrSZOc?=
 =?us-ascii?Q?vnfIO27BXXu5r5vnwVC31V1nty5Rm3pth3N/q+U9B49YhkJQsWurlJL2VO8D?=
 =?us-ascii?Q?erJs3smRY2o98XIu3FSNYFXbnXJUkRoiv3XkiTwlmytG+MR3Hu0/X3wD+2CK?=
 =?us-ascii?Q?qsRyPY/uGXzAVqasOjgNOkr+w8AZElkH+b96CB0SXU2xvJNv/+/JOpiuP6JH?=
 =?us-ascii?Q?VHGqp1tHuRv8w/JqcScRDvuOtNXwwj9pIv1Dmu6wD9SdQ5d2XPSIBlQJPGAJ?=
 =?us-ascii?Q?UqAl3ugVTcAVoCerz1WoJgDj0WG+TqKMePYzLqpIDn5w1/6hGBxhWm5CxWpj?=
 =?us-ascii?Q?M+eHLC3HgwhwR99Nth3BUSPVl4dao4CJA6slfOgZa52ATwSm/466suBjQ8TJ?=
 =?us-ascii?Q?1xmceNRt5UcPxBjRUo0GH22qIeHNaId2ZCZZLIhlxJZ1zpKlA3RHoQrIoXGw?=
 =?us-ascii?Q?Sa58QIoiwyFZoDRH7HJWRyo+qKAHfoTUzOR4ZRuIKBuXUpVaRH+PI8yGXCQe?=
 =?us-ascii?Q?8mBLY707JSXcZ/hgVcBy9SVAcEEB5Vn74FSBnlIPyce/RWCGsOFTrn/nPrcy?=
 =?us-ascii?Q?uLmPHfOrVGZN9l4H29c35KQnR/2i0iABoSNqigDPxkWXd4f8KDOCH2HG+c10?=
 =?us-ascii?Q?Ea9T364nDN5+WUwIJHwmVbFVOXDkXwgaoSe0eSXk+RcjbhtthwKcUq+GAIhR?=
 =?us-ascii?Q?Vw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E4467883B049014DB2BBA336531C837F@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	=?us-ascii?Q?Ii3gtfkR75dfq+VHuWRK+yrRrhZjOwJmh+8wvdAxOmB9RIvPsOMGP1o84fCq?=
 =?us-ascii?Q?cJUsk1t5VBIEhJY4ZEgQbiFHNjo5MNDt8uYUdAyRYS71uPERGYtQNmf4k8u4?=
 =?us-ascii?Q?9CPmPh6HpLBLt+0rPbUg3PxGzhUBi+ulCzMUhdUgTMGMHRh+g9OVy/W4ZR8F?=
 =?us-ascii?Q?xyv0PO3fgCl1iV3550NrsL2iHkV+AD69LKrBTNi0Oa/OHLFyWSbUZaEIurTf?=
 =?us-ascii?Q?KxXvx20sXn4s3YHDFPmsL4AKTr2k9cKm5wW9kSi76lSniKw8Y5vea+bmE6n5?=
 =?us-ascii?Q?b1mVzRgVBAFTYc5sGgCRjoZilyMxQYxaBrWx5FEsPK06wSi12eFPEMEHrH/A?=
 =?us-ascii?Q?RLEp6+f3vJ4Hy6pj3isekLWnZje4Fvm2Fjz9SOR74erKDgqMmdLiB1KdJPXO?=
 =?us-ascii?Q?/Ku+aAadwGqAb4ulX1HbEm9f+6XwVEkkYCUP0Z1UqlfxEciqrVaEeO5ifkoP?=
 =?us-ascii?Q?gSxSB3/+Phwz+O2qTEd6g1Xw8fyM9cvoiB/3ofPge4vNdtQMuefg2ltY/mZ4?=
 =?us-ascii?Q?BrZAnFzOaI1v5pfhrL+bjtMC6tCcyAh0dE5QzGm+vEj9oYzz0ydPwBcK1KHd?=
 =?us-ascii?Q?4fXDKnn5boQ3MouBtOCEoUtEP2UaDjcz2eJFkXMb6oz1jsR+5StBMlCe3IWv?=
 =?us-ascii?Q?Dx6dnhA3o8MusNfiX9VpapV2bbRvtzL430RvESNy8XfEto2FHESZChbVR198?=
 =?us-ascii?Q?e6q16Zun6dj0kq/+mc4f+N3UUlIoqJnWFEKIrg5vqzdnxEV+yshUgMhV/jrO?=
 =?us-ascii?Q?sb4IcG0IVgUhDyRp3LaQkTdgXSWHNNB2p+kgu1Kdmfn3oIVfzAE1gK7tUv0a?=
 =?us-ascii?Q?4eGkLtxTOzjTjvAHtoM9WUnpicNzcGk9ER/+w35ra3CRYt/gh5gf9MN+MEVH?=
 =?us-ascii?Q?OPD8vW8P5U7aIsfq0HkyMBcm6RuS8woOWBUOLPXbUeArzg/Kzrcjusfd0XsC?=
 =?us-ascii?Q?zx6o1BKVobcYFHOeiUZnAZ4UWOfWsj4kRU7CiuMAkGeITmVKpHK9CBa6kCC5?=
 =?us-ascii?Q?Qgu/z/8ewsRW0CVbhpEe43hQV62HhgN1lhwxluHb6wzy4PUEfuKXOMDrX1Bf?=
 =?us-ascii?Q?92HWId5AexnCGH5R1ADsMfWrP8dz7g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4129.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fd5b240-27c6-44ee-0b3e-08db62be925e
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jun 2023 16:38:04.1763
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ssftjggalYsIgjRd4uK8nsHuOa8iYFWp4MDsIvseRic9b7RHFu9qVVP6y+Jok+ecQT35b4RBqGSuze5gH5WjDxUQk/sK8MASscbIBDbCXWg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7370
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-01_08,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 spamscore=0
 phishscore=0 malwarescore=0 mlxlogscore=937 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2306010145
X-Proofpoint-GUID: KXf4nvLu58LR86ehq2WG8AII9adEyPLP
X-Proofpoint-ORIG-GUID: KXf4nvLu58LR86ehq2WG8AII9adEyPLP
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> On Jun 1, 2023, at 9:25 AM, Jakub Kicinski <kuba@kernel.org> wrote:
>=20
> On Fri, 31 Mar 2023 16:55:27 -0700 Anjali Kulkarni wrote:
>> +#define FILTER
>> +
>> +#ifdef FILTER
>> +#define NL_MESSAGE_SIZE (sizeof(struct nlmsghdr) + sizeof(struct cn_msg=
) + \
>> +			 sizeof(struct proc_input))
>> +#else
>> #define NL_MESSAGE_SIZE (sizeof(struct nlmsghdr) + sizeof(struct cn_msg)=
 + \
>> 			 sizeof(int))
>> +#endif
>=20
> The #define FILTER and ifdefs around it need to go, this much I can
> tell you without understanding what it does :S We have the git history
> we don't need to keep dead code around.

The FILTER option is for backwards compatibility for those who may be using=
 the proc connector today - so they do not need to immediately switch to us=
ing the new method - the example just shows the old method which does not b=
reak or need changes - do you still want me to remove the FILTER?=20

Anjali


