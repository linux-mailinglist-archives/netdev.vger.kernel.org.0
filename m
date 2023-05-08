Return-Path: <netdev+bounces-780-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F33616F9E7F
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 06:01:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CD77B1C20948
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 04:00:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05F3B1096A;
	Mon,  8 May 2023 04:00:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E24C1320A
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 04:00:57 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 147F83C24;
	Sun,  7 May 2023 21:00:56 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 347MnVaf010842;
	Mon, 8 May 2023 04:00:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=5TG+F2v30g3lpjejGO5Gbjw3NcSbDZJKwBPRTufZIec=;
 b=ZfxLFCsjv4GrcvEWsJk8qXbXsAFLmomhUoAghQONREabjRNMSY1sOHXy9+trYsIjTsrD
 x/gD6XWDrfPNYo0XSb4i31BbJAUpfVg6iZHid5QAsylAoDOhucvWsvN9Efazhzmx5Hwu
 VE5fAFK93NeBmyEHe0Vx4epdkcV2OoDexT/UQUSqQFYw+u/3odHdp1XgkNEd1REMvUCQ
 +7ASEMeNKYF3zcSwiTW2AgMiKdiF2I+k/mWb+e01mzAwT5GRXvAuISACDQ9mZdaTy7ap
 oO8DEqkF7M6z2VPf16Mhd/6p+dHYyhnqYAyUF5uWZAgWWp3s2H/NLFs1/sKGtX5uyXTl /w== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qdegua7pu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 May 2023 04:00:42 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3482Kpie014774;
	Mon, 8 May 2023 04:00:41 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qddb3pb7e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 May 2023 04:00:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=maUoobyNnidZ0S9Vr0Jo3nqYczDN1k5TM7Dnt8fdd9QC1euEdO5tN6dgYpFVjDTE/iB2bnn3rW/nTg5MuEdL2ymmGJftGuLuasdwD4uK4jJGWpELiSzVXlgBaZGXkugZ1Gf4f4e8lC2BoHmom0ibX78CTEu+wzs8Mj3nHsmyUXWJk13hUqOjleGbvhzTsXGsjSa8tj11g/kFRCv3fxiKPK0wiVPErHBGld/T1TDtxC9Xxlkb/Ld3W62FFfdsy8a2W6yToSBjd/UM7k2GaKeRtnhOTBO4O4Iz3Zu0+9MS+RCk0BODvOw5xe+XoEB24tTQHYX8NatHp0F9xspWWHpDrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5TG+F2v30g3lpjejGO5Gbjw3NcSbDZJKwBPRTufZIec=;
 b=dJ55nVurxFHzicFqsLRbofL/TADYwiyBB6eVZYjhLKLT5cClRnRXcM9Vtri/U+g55ZG1QjprFC+oBqd6BJoGjttyHPT+g1KXLB7iia5z1oKvMj0ON0OFT6qj3qmPPr4b9ixCPd6uTStaOdH/yNCiiaOUxhr/s9HN3fjSxMHLoAEZWjcOtFW7WKhVsbz0yOusAwKmPnfOnFlzLkff15yo0moOXUo+YhVDILQYUX7l2OBg8Tp8HM9C3yQ2TTVpd3tpu4XTTOdld8XRnfYgeHTf0JMCIE2sVUjSXEAczi8hwdbE2wrJFcWzlAn3NbImcCZT/CSKOpcALu6EtHGKWW1cdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5TG+F2v30g3lpjejGO5Gbjw3NcSbDZJKwBPRTufZIec=;
 b=IjQMX6C+SJSqb9lGF+esaOiyMUCNGVhIy4JNUiH4o1q/NKA4V8294JRZxJGHu4gOkq/ecbC7GNrtik10QO5r1Zpkh4GyxMqyYMNHgzEcrYOLBd3JFhA9ixGqRm0eTnWzgfzmItxwZQ/dgsts5fYSe0gWLJjpMSeIF2SM6A2lHG4=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by IA1PR10MB7214.namprd10.prod.outlook.com (2603:10b6:208:3f3::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.31; Mon, 8 May
 2023 04:00:39 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db%5]) with mapi id 15.20.6363.032; Mon, 8 May 2023
 04:00:39 +0000
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
Thread-Index: AQHZgMQOKc4fcioBR0q2bzqWePFl4a9O7x4AgACpTgCAAClLAA==
Date: Mon, 8 May 2023 04:00:39 +0000
Message-ID: <47C36B96-581F-4D51-8247-3ED9F1B4B948@oracle.com>
References: <20230507091131.23540-1-dinghui@sangfor.com.cn>
 <EED05302-8BC6-4593-B798-BFC476FA190E@oracle.com>
 <19f9a9bb-7164-dca0-1aff-da4a46b0ee74@sangfor.com.cn>
In-Reply-To: <19f9a9bb-7164-dca0-1aff-da4a46b0ee74@sangfor.com.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|IA1PR10MB7214:EE_
x-ms-office365-filtering-correlation-id: b85d5e49-3f9e-4008-7282-08db4f78c906
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 Y/XEQpziZ7rMVIZ40cHjxDiKCIMs6kGwg+wa+YMU6S8TDo84Q7DJz0BBBIzg5veW2+MJqqLBZQiMSr9p8JXijXRx/aGDMD5YunffcAxgYf3QU/TOP2zMaoCOkY4uPPT+YlDmnshhq2bdxsZu54cC8VEye5y3N79xrrHmLIt0d30cO//MNicOtn+0qoCjHLETToNXKOJ7Uq1pwKR0BkXrXD+6uceHtA29ZG35Tl9HL3hgpfesmx8VgclZDehzoLQeFgZg6EM4Uf7UhnKZQAT1Ve+mTb5hbG7SgzMCXMgYFaGj9Wy2fDi+FlVzEDyd8Jj1fVqQMnXEREMDZrWmswwsHpCtGVeqYcVIDQkIdN2FfutSwLRUkFIFuaES6NO0GK1EbUmzfR0ubKUUSNMoF3P34JEfsgbGBbBG0VS4NJ/5aG9ZFkrG6HGR6njtu8DZwYr9mz6iba8t7vUKkXzQ1sPCybT7i4JEiWw+YEOyDm1c4c3QtCnltM2o6HkXw88bJoNiMITyxTuuku+Mcs1AheX/NgibhI7JfAnuRsU1CSKTwX+Ptt/zMq2M+O86r8adrOF77yrVW9bdT/74ZPaH9yQEpinn65oYK+toLff0SUzAsPxa6C1BFQni3ny/mXIUeDHFBNVWAXJzS6efzTqKxIsvDA==
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(366004)(136003)(346002)(376002)(451199021)(76116006)(66946007)(66556008)(66476007)(66446008)(64756008)(6916009)(4326008)(478600001)(6486002)(316002)(91956017)(54906003)(86362001)(33656002)(36756003)(71200400001)(83380400001)(6506007)(53546011)(26005)(6512007)(2616005)(8936002)(5660300002)(8676002)(7416002)(41300700001)(2906002)(38100700002)(38070700005)(186003)(122000001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?D5M35+DxT3HEUWpjQHFG56KtcP4ObUo5cs696n7JLRzh735wg1lq6DDR5uI6?=
 =?us-ascii?Q?Zlepvkt33bjR5NzVlxuoB/ds6/hgDFTG7C9B/JuGUnZOBXyRGLRPK3rSkD8G?=
 =?us-ascii?Q?hSPUtQUmTe8zHIoHjar41uDRSgAsbAysRLVUeak2jRtuqoOLSJsoy368GXTC?=
 =?us-ascii?Q?LIsae7Hc1PU3HM9HI7WHiU9jy31fZpn9mKC5typsP5CdYeZfwuf7So0jHWkQ?=
 =?us-ascii?Q?scvvP5i4EFIQtK5Iq8YzIhm/H+MebzX1mGZn9HnEEbsKGkZebLQn5hZhpzt+?=
 =?us-ascii?Q?ubYWEAQ80tXma/wn//SPs3jbWdm1qWaKrbcR7mDcTgotCN2UTv2jSaqYEaOG?=
 =?us-ascii?Q?arpL0Z9q6Iag9uQVcpej742H3lRi+8Kp9rmoqV3GRrRfxK8RvrckeX0rS/Zz?=
 =?us-ascii?Q?Lu6/pCj4iuDcPSm/MIjIZX+p8dAxUZ4RozP0PTEXt7gDN6WcydGg/E80Zx2+?=
 =?us-ascii?Q?ava2Iy4AXbH/FpaZbvqTJIWdvqrWMvPvG04VeiFW/kwN950KJXk2p54tpzvq?=
 =?us-ascii?Q?FSgs2STbOlhe7i9SBNQP890WI8TFsQ9+znTo6dCoxxy3byz8B8penUYGr3a2?=
 =?us-ascii?Q?mzMzDI9TL/CvFCd64SwQzEs6j+i/SgeSd5Yp4srq6qD2bawZhaECKr3g+3IE?=
 =?us-ascii?Q?Ie3tEKDI7niic+tXdOMQJWMNijIvgun6gKa2xXlu7fO3HMk1gYTE3ZBRy23o?=
 =?us-ascii?Q?Rx4D5jFHxvYi/ZT1IwlAtIhVD8EvJHfVjE792rUbXOYPZKOjjY5JnDJFoaOO?=
 =?us-ascii?Q?9UKoU16H8Zk15d/fg3zQeO6J/gc4XyZC3zB3yLWZtYh8mS9Fb9jbE2dgAYnH?=
 =?us-ascii?Q?8qNN0rWZp+h0nj02YtUTZC3zUx0lo5jIwjRfdfiJg1Gbk5Jrrbc2Cie5tpG/?=
 =?us-ascii?Q?ly6wgr1LW8/QTCAS/cQemCfIWQCid+30+uTQw2WaVa2mVBUgvns1ZCJXteCS?=
 =?us-ascii?Q?dOhbc9myfi44QjrbiJrl6TRhT2Z+vaukT8GG+SyqT5Tdr3cH1Oe5FoG99Pfm?=
 =?us-ascii?Q?BNbgMo5dUor3ty20c4PBT6c4B5yIOVjLQQdaWohwtI8FaHoVeZCUFRLZsV4i?=
 =?us-ascii?Q?5NpRVrgt/o7xqpDNy0T5c/fDITQ6NY2jET5E4+G1Pmu+QIsOxvCJukcyPDjn?=
 =?us-ascii?Q?wOiAIXH90TZD7q4rz14+PM+flF2tCR37UaoMAn/s7brughDLm277S0IoasJ7?=
 =?us-ascii?Q?t3qgLN//GRjvGA2QhNCu6cz8//pmXeTG6JcgVBMYafDRhoa+Lcfo7swLHfCN?=
 =?us-ascii?Q?mMWEHrmCr7AaHarrku0WuLCY2/eGofh59hkfA1EnAMJ+LhdyA0eKK5wr/tGZ?=
 =?us-ascii?Q?6W/ZH7h+f8XVpl2il5bA6IBnQXOroybVrL3NjashZQEz2WATvckJDWN/X3iE?=
 =?us-ascii?Q?HLSNJ7AFCvR5QAI09ygLWI3iwBml/8LTvEXlFSxes7bWC3CzNajXj00HTNqd?=
 =?us-ascii?Q?xMFY9QUPTOB3ndEkAcreWBXw0WPNwAFCs8RvD7i4M3mVdlE585As/oxJP9q9?=
 =?us-ascii?Q?tC7gM+VfJcEcaBFHtX78/qzkFgDm2Y75iy64024wappEB9wHdpXGG/T5TKnn?=
 =?us-ascii?Q?svUmeaJuDJptV95sOUZTwL6NMXIn52pvpE9TaHVi115jYxTBDXBG7tp+EyZm?=
 =?us-ascii?Q?hg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0F9D808451DC7242B8A0648435C1AAE8@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	=?us-ascii?Q?rhmBW5g1aFu97cN7Altq2fqSwBSWn0NrFEhLaiNt0M999150V2Y3QkX6GF0O?=
 =?us-ascii?Q?aQf1JlnxH3Xb1lZdP4lNofZoTaeQq2U5E5EfvoGmn16D5+Oj6zTDSQVlnWfy?=
 =?us-ascii?Q?PC21cyzchHMJsdKv3c7beo0F6f5Iu5d5/HtHSSogKjwForwT2piQO0wQxTQo?=
 =?us-ascii?Q?RYMKJ8SbQNWCR+Fi5VjyWCB5T9O9RzODtEQ8UoW3TfuNp/6+FbsPxmDI9lVg?=
 =?us-ascii?Q?VJDO+2E5fVHwmZGbmVIzBekI0uEeAjiDQfMKR78U3mEm5UAiC3RyWR836Bgr?=
 =?us-ascii?Q?Zmpdn7a88KiEPOmcVtLI7we5OgKVyZBlpgslynyWmK7qMVGg5RGNqvjKJcME?=
 =?us-ascii?Q?i+kvv8oYkXa2XyK1vVe/mk7zhbBk415zJ3vBwyHs0X1+De0lUAUVhMk++lmg?=
 =?us-ascii?Q?ZzLPjhQHkOBz1S8wrstmEsnRwqA8LoKWqOnjfSD//3XeHpTIu0aU6ORHBjIK?=
 =?us-ascii?Q?0MqkPhQn0TYd0AlGBFIeodd9VfJVawW0gtG9bxl3q+tC/NTMygXugyoqJG9N?=
 =?us-ascii?Q?xWSSdjVCFaU7sbbcjaesyQ07tUkqjVHnBHtSOl3TMC0/H5RUlvf6N1YBnRqR?=
 =?us-ascii?Q?XZ6KncDqGY4+sWsNUC2U9WU/GTWc58c5Qpj83CwQxTDcxUetgLBGS1KrBGNv?=
 =?us-ascii?Q?vFqEnZFDZtrxzdwHZ+UFwKO/dMYqaPtKYG7iWhN0d4RUpAybJGD0C2E82Vgr?=
 =?us-ascii?Q?yyK3hQmsTtAwFvdb31datcc95AN8tGAKfKCKmKCT8Y8CRSlXcz4uK5JnBTf6?=
 =?us-ascii?Q?fwQUwnGcOTjQQhfUJQj3Q9wIHsaBrEAkrLcK74Dl8U39RnxGNa5pwCofB/Gc?=
 =?us-ascii?Q?DmoYeyeBulQLPbcDpe1pWF5QLrfiZllhoGWN6UqmJ8kws+I4WIzYiyYipj4J?=
 =?us-ascii?Q?zsvzRwFuIaUs8oqCUEE9tRAl6JqFfHZU79v5DOYcijMlv1xb+Yl/1f85N8gT?=
 =?us-ascii?Q?gRjHbgseE5dbXa2Fs5+8HQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b85d5e49-3f9e-4008-7282-08db4f78c906
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 May 2023 04:00:39.0370
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iRvvq77oeAksJPweFw2Hkwj7aeRGx10fJv3SvwaH/m163CyRTgb67Cb2IwWf3oiAfpKdfNTRfVRUAPg676IQgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7214
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-08_01,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 suspectscore=0
 adultscore=0 phishscore=0 mlxlogscore=999 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2305080026
X-Proofpoint-GUID: _UpQkyMPoTB552UZTA0g-yyrUjX2KptZ
X-Proofpoint-ORIG-GUID: _UpQkyMPoTB552UZTA0g-yyrUjX2KptZ
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> On May 7, 2023, at 6:32 PM, Ding Hui <dinghui@sangfor.com.cn> wrote:
>=20
> On 2023/5/7 23:26, Chuck Lever III wrote:
>>> On May 7, 2023, at 5:11 AM, Ding Hui <dinghui@sangfor.com.cn> wrote:
>>>=20
>>> After the listener svc_sock freed, and before invoking svc_tcp_accept()
>>> for the established child sock, there is a window that the newsock
>>> retaining a freed listener svc_sock in sk_user_data which cloning from
>>> parent. In the race windows if data is received on the newsock, we will
>>> observe use-after-free report in svc_tcp_listen_data_ready().
>> My thought is that not calling sk_odata() for the newsock
>> could potentially result in missing a data_ready event,
>> resulting in a hung client on that socket.
>=20
> I checked the vmcore, found that sk_odata points to sock_def_readable(),
> and the sk_wq of newsock is NULL, which be assigned by sk_clone_lock()
> unconditionally.
>=20
> Calling sk_odata() for the newsock maybe do not wake up any sleepers.
>=20
>> IMO the preferred approach is to ensure that svsk is always
>> safe to dereference in tcp_listen_data_ready. I haven't yet
>> thought carefully about how to do that.
>=20
> Agree, but I don't have a good way for now.

Would a smartly-placed svc_xprt_get() hold the listener in place
until accept processing completes?


>>> Reproduce by two tasks:
>>>=20
>>> 1. while :; do rpc.nfsd 0 ; rpc.nfsd; done
>>> 2. while :; do echo "" | ncat -4 127.0.0.1 2049 ; done
>>>=20
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
>>> In this RFC patch, I try to fix the UAF by skipping dereferencing
>>> svsk for all child socket in svc_tcp_listen_data_ready(), it is
>>> easy to backport for stable.
>>>=20
>>> However I'm not sure if there are other potential risks in the race
>>> window, so I thought another fix which depends on SK_USER_DATA_NOCOPY
>>> introduced in commit f1ff5ce2cd5e ("net, sk_msg: Clear sk_user_data
>>> pointer on clone if tagged").
>>>=20
>>> Saving svsk into sk_user_data with SK_USER_DATA_NOCOPY tag in
>>> svc_setup_socket() like this:
>>>=20
>>>  __rcu_assign_sk_user_data_with_flags(inet, svsk, SK_USER_DATA_NOCOPY);
>>>=20
>>> Obtaining svsk in callbacks like this:
>>>=20
>>>  struct svc_sock *svsk =3D rcu_dereference_sk_user_data(sk);
>>>=20
>>> This will avoid copying sk_user_data for sunrpc svc_sock in
>>> sk_clone_lock(), so the sk_user_data of child sock before accepted
>>> will be NULL.
>>>=20
>>> Appreciate any comment and suggestion, thanks.
>>>=20
>>> Fixes: fa9251afc33c ("SUNRPC: Call the default socket callbacks instead=
 of open coding")
>>> Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>
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
> - Ding Hui


--
Chuck Lever



