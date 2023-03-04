Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 147DB6AABA0
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 18:45:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbjCDRo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Mar 2023 12:44:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbjCDRo4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Mar 2023 12:44:56 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF867F95B
        for <netdev@vger.kernel.org>; Sat,  4 Mar 2023 09:44:54 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32473B4F022376;
        Sat, 4 Mar 2023 17:44:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=tH8jiKRxDs4yoyzzlcjTWsFJ754KLLJIEQVpjoJgWR0=;
 b=w//o5e5BdrWB5WIbhvwP3IEzK8pcSt6iBVTl8eOlQX8TYIZR/pC0GHVKOXmdM0i0Gh6k
 evLiWlU6Vsf+2pAN/oMF/O6CLMQHdYk3xDy1MrLr+v+tl30KK5ZTSh81OoC7apNRlPtD
 UDUsan8J2e4C2PN+e2Rao7IbzkXguQsvSInI3Gjj7eDHaszgkFNYlzuqoYl28FraSZKQ
 nvUqZqD3P4uiQflvyV0odPgJu88Xdmna7iQPkAcYfcHbN5bsLXqw95fSctVKMKPie1Fc
 vve37RBjez7bo3kx6Yz1BNTcyyASauOlWj32xJaQT4XmQGkr+0YjfCAkAhojv6eRNqmU Dw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p41560jd7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 04 Mar 2023 17:44:37 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 324E3oqA040049;
        Sat, 4 Mar 2023 17:44:37 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2104.outbound.protection.outlook.com [104.47.70.104])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p3ve2shs9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 04 Mar 2023 17:44:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IQrJp7DoXGtDz5R+03Fm9Prp02cEU8heEzdzrc/9f3pbH61Vo4RXSWup/ijN0a+kK56nwhW7++1pJ8tQsnQv2rBc4bterwvDt5ZJLk9ejwEhszMmlHx0VviB4ntWOFjN3uRXu7xBs1AEnfvXwiVp/hhs3mdoR7PeUGaAIxYRSGtVBD7mryEQyiOO75KRuuyDNh1hXqQDdKr1DPrD2l7plGr5uZc2kTYZy9P1P127JHsHh+SOO4iyjR2gT5G22LxVN5DYdP1L6sP6suZMg20ZcPBaI/6euNd+BqYtyPwK9BvM+lQDEUcenth7IMqfQULFXKjWo6LtDj+l8uhxKB+ooQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tH8jiKRxDs4yoyzzlcjTWsFJ754KLLJIEQVpjoJgWR0=;
 b=g/dr6CLVCpkgLS/rgR338TZ1UtHxzrPVZ+ApCwfnAzFHwD8HAfJC27MdhKDEazZrFLbsBw2N9DlFECUeyJ7FjR57QjK16fCRzic/8NFgxtoraGY9UAJ3LR6KQ7v4lGodzTDuSttXDSk9c9zhfxZmWMONPYjsRCkxcfdXsGqCXEYvRUGfyHuiyulQ+AhRq97UIYJEOrcueDMVXXAox/yjgFDGwifQk6xH0diSbkFC7uXWLQQm0YrQknIHK4PpcyCf/z61F2wDSShjhC8dhLIIxHJqWHIyeQxws5ZW9M+dVik0Dcqh1aj2AqHWqCqGXaUS0NsLBaQwQo8XcO2u4o709w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tH8jiKRxDs4yoyzzlcjTWsFJ754KLLJIEQVpjoJgWR0=;
 b=JbRcMpKp5xMTdf1AQpKhNpKNLEBhkRI71y1WKTG65qkKKfq8VU8pMCY94uYc72m3yRPTs/AuNhT1cOKRGoS746ePJXGbi8cz7tKLZwAhNetY+W34hStRMCIZGf/4+f3s5/qSlSYAxTievm6kGGDl1/s6miX2qbJ2fZ6ggOBuXDg=
Received: from DS7PR10MB5134.namprd10.prod.outlook.com (2603:10b6:5:3a1::23)
 by BN0PR10MB5095.namprd10.prod.outlook.com (2603:10b6:408:123::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.25; Sat, 4 Mar
 2023 17:44:35 +0000
Received: from DS7PR10MB5134.namprd10.prod.outlook.com
 ([fe80::3b4a:db93:ce56:6d08]) by DS7PR10MB5134.namprd10.prod.outlook.com
 ([fe80::3b4a:db93:ce56:6d08%5]) with mapi id 15.20.6156.023; Sat, 4 Mar 2023
 17:44:35 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Chuck Lever <cel@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "kernel-tls-handshake@lists.linux.dev" 
        <kernel-tls-handshake@lists.linux.dev>,
        John Haxby <john.haxby@oracle.com>
Subject: Re: [PATCH v6 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
Thread-Topic: [PATCH v6 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
Thread-Index: AQHZTgEx5sDM5wq7q0GXZWBkY2YJz67p5A6AgAD8h4CAAAVfAA==
Date:   Sat, 4 Mar 2023 17:44:34 +0000
Message-ID: <83CDD55A-703B-4A61-837A-C98F1A28BE17@oracle.com>
References: <167786872946.7199.12490725847535629441.stgit@91.116.238.104.host.secureserver.net>
 <167786949141.7199.15896224944077004509.stgit@91.116.238.104.host.secureserver.net>
 <20230303182131.1d1dd4d8@kernel.org>
 <62D38E0F-DA0C-46F7-85D4-80FD61C55FD3@oracle.com>
In-Reply-To: <62D38E0F-DA0C-46F7-85D4-80FD61C55FD3@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.2)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS7PR10MB5134:EE_|BN0PR10MB5095:EE_
x-ms-office365-filtering-correlation-id: a17652c1-02c6-49a1-256d-08db1cd81e57
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nPnbuxikQJlu/5SZHHE1QOA+mP3ZiuQhXtynbQ3Tg3vYaBaBfzQ+PDK1OpDVQJoF2GFx7U6mfY7H620wo7xwKnqAyp1ahJECI6kRe6e8AnPD01NhrWYgx+5CA9wfQZp4oGi4I+vaoHR5RTz0Vn6C8rCxS2Yfi9K8f3amv1ih1YX9ngN9GZUas07urDEWlmP0B0QLrMEPhAoDtryfpAy0ybSvym1RiV7gqn1kF6eoKLLUIf+FZ6TKvvGS6JwpgkaIwPUZNSVUW/c8Y6vzNVA/Y1Fs0hbgJd2Or8c6PwMu44kawlbI8XVhqQUocliQANaSEH/YiSGWlK93NJaZ02t7mFZpASnHH4eJcnWSS6bhNvKJe4vdPNfkJS3vny4A/i7YDrZJgkGKR9b/dKCwtAFHNt7cRprm+dWNDpHoetDkBJcIH1UI2BjX5ibpVYzaPZ0RikiKWA2F4Cs3Nc+2Sxo8a1ulAvM7+OkhE1pEo1GGA7lHJVq3XrGeRSqThr0P1sPiVWfqkKwEkRTQO5ySJRhqWnIdNOn0ZNv0sGIukYb1iiYMnELcUX8nPLqz0qSmt/hanuIja8chJUroGvgEDO1c+dchxqBxGcDWZhHEO0imVYGpljZ/MCAfGQnA+/Yw4riRnmzRwBo8MGN0GU2knly4S2l3nk7UPVwKc/iddE+u05RcuA9AHa1S5SqrQCIRnEOnI0UNkTXwABBDH2h9Hh4nojhp7NRpie4xIevudIBvCH4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5134.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(39860400002)(376002)(346002)(136003)(451199018)(2906002)(38070700005)(5660300002)(38100700002)(122000001)(8936002)(41300700001)(6512007)(8676002)(6916009)(4326008)(26005)(186003)(71200400001)(76116006)(91956017)(66446008)(66476007)(66556008)(66946007)(64756008)(54906003)(86362001)(36756003)(316002)(53546011)(478600001)(107886003)(83380400001)(6506007)(6486002)(33656002)(2616005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hIlxoo7ZOXUlkFYffmDDK1PX/yJ3NgVcpSpS6BrdXvaC5yP1TqoadrnA4WIT?=
 =?us-ascii?Q?1fXx3peKOf864IcW5mUQk/vXRyS4+I9GYJ1lC0+6Ifp0s4ti+XzAPJ2tenO5?=
 =?us-ascii?Q?8443zBDVX6UvNTzwjxehDNuiRdQHQRvDsxYiks240jVhIF0E5GQfWCZTIl/K?=
 =?us-ascii?Q?6zHo1+Ya6XPWCsxqvpttmqOeDmN8XG/kRDyGQ40JuFQ7bzQUCv0RK2WtzjJv?=
 =?us-ascii?Q?eypw7RF3lPXdxELglRl7hXXBB5qCaVcndQ9oRFm94dbahWl/IInf8gO/y+sh?=
 =?us-ascii?Q?8qFar671HcYYznBTsgR3R1Bw0s47aPOiBmI7W+OEGf5R1m6RVqXEBG5f4GdL?=
 =?us-ascii?Q?o78XS2CcegzxPMTd5kV1a666xlzNCQrWMpejZ5Xmip3F6S7el8r/p08HBAOz?=
 =?us-ascii?Q?7Fj2AFgeowdiN2j7Ek+BtxRZOT7MZgYo3eWr9/HBVtAhC4AhsziIhhuo5qfd?=
 =?us-ascii?Q?V2EVHCDvHEGN/SDRR85xptZY08wOmht0+ZLN0+plr+ndUMuBRF9bMXzNwDAX?=
 =?us-ascii?Q?c9GYyUDKiEerOlcwEuObm0y8wl3O5D4onrMctMgeFXUkGzWYCZyG4OlQ0MIq?=
 =?us-ascii?Q?INQey8DKGkssHsvvzXQ6j6DHdi8IZlLTapPxOx/cMDFRvLN3olVVRVEtWPKP?=
 =?us-ascii?Q?7HUv4JQy5xmiGdGzuhUHmT4GNkjxbyhY9Gj8lnAvoPZT16LsTYM6GhOB0hQ6?=
 =?us-ascii?Q?EyCRxqoY2SZjHOMHdBvYX5EiTAEpoU5Y5TwcmuZH6vRpiTlTKT5cV4T2S/Da?=
 =?us-ascii?Q?s2vzWvVzrlN1r1+YKrslnMg8vZ5pZwWJLPe68PwP9o1lFfhDvDIyY5WmnZGV?=
 =?us-ascii?Q?3xy2oxBECNHnPn0xNV6l0Zf4e7xfUcfRFK3kSClb3q8Wh7ZXo9Sj7qOLCjfL?=
 =?us-ascii?Q?aAVja6P5083Xe8Mnoh2d/sy3+fCcqqS91j1tPuDZGwuVMSxTLgXJeuX1ATMV?=
 =?us-ascii?Q?QfZBkd1D/EBiBxC6hUvth6DB/hi8ZsJgUP47UxckR1RZ5zb4eGDukD8cYfGn?=
 =?us-ascii?Q?jAGBMo3YxJ1+XwTyuvgiZqk7sxjjOuWQ0kdTLIJrR7mFioYpNxzEYfHKd5LT?=
 =?us-ascii?Q?ocG5eOUDIs7v2d6nFaEAFfKo6Sfjabi1Lg6dfwmoQgF19cr5x/wbz+BobOYb?=
 =?us-ascii?Q?EBvUzdwts7nikP7CljaW9yiR+6BFfEANXuyaqCGsIcdoFK/7+Z29vHxHI3sC?=
 =?us-ascii?Q?w6kCQU0WUWG/yyJ5Zm+55H97g5ZJPiKRS9DNDX4iqxxPRFCH7AZOQJd4Niux?=
 =?us-ascii?Q?pBy9MUYQL4BTOdWOe+m87ubclxF7CSAnKNGVU25S3mYVAew3yzcuTCV7XQni?=
 =?us-ascii?Q?xuZZ8GqKz/MhlkJIk5uaXpD6K0uUfqkdkEBEL9v0vQ9rPfE/UKhE4JmZ/J98?=
 =?us-ascii?Q?Bq9dv9M/QZJfIRvef068wbBcgl6geMDoq6h/Gcl9tGNCqCNQmpxTaoKJsgK2?=
 =?us-ascii?Q?QqRQ5N4tWKq74ocZT3eONCn4gUbpO/oaB4cyQTmwluvnbU0udf3DWM8qO6Kv?=
 =?us-ascii?Q?rgO3kLeewtZwFg6G28/L6KZx/t9fLpN5lgvp9Y41H/2tFDKocFRFOl8m8Zlf?=
 =?us-ascii?Q?IenNuAp/+FsnEaeCj5VZk0YoxJG37VoliiQCl2199Z9cvR+bJho9CA2wDdj6?=
 =?us-ascii?Q?3w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <723065C92D9FE8428A298A951930E8EB@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: cdn4YWR7/RIg0fWu/AD3+WQ5vuY6EJy0NN262DOKYOa42j5LNtXn6UAAVLWGFDuuIrGEtob55codI64qPr74amVDoEoqCBwwp0e2CM8i5124SCnQuImG9ZR3geuCOTUaPflyBmXUqqO5j77fL4KLC0AAIoVy2jBnn/02fQ1qC9LbgcfHhZ9A4zbrLO+19myt7GI+BBycGlAsyN7JLgK0ktp7LM7aO44cyqdjMXdp7Nkg7hzTDr/kFcuXGaPtEB8gImum3SEU0cL+zfMBDoIEH4md2ucUKvsOTR8EN/HqzxEyHR/Fns0PPj3r+ekW1b0f0dqJjOZ1ddyOhQy6/dLjvoWxIlBeDerZ0njw8jfe+r/JhZyXftUUQWywZHQVTUJbmzINl4SIZVsQGcGza1K5T+6rKARezdUFHU0vYtokXJ5O61zyRCpg4NijVMwUPlCPcdyJeiFkGeJN/dyo6vFGR8qGCUdXtIkWDLWX7E+CBlODIxmjfgYTMaCeNeAR9IIkfNy5h3VLKy3SzSIDD8mu5xsNvJ1zPPrhfnKtDAIPC2GP3LVItTpAR3pAyZYBPfWcvjPi2g0hI7ndxNJkwgCbV627TcAEdkNxcv9rckLh6jjS+vHfp3GFSXhNMFekRsM49B/I6J23hoefErfiTLXPbkM0/QMIK1W0PJrWW4SFw3jlguWfFuWBt+xdLowqH+kks+MXN6Uh7yWx470orzNAuJhTQiExXCR84N4Ml0TEDOC27w6+yiOjBiuBx9kNGmUW7qJOcpUJ654hODilRkjsId3h1fQ0gpIjz1NNDAIauown55zrqdo2+LubZFEgkFVC9aMkagvgQUASpRnovHubJUDmnvV4QwKAMQ95Xylk47QABhDe/j+NKMMK3Q6FVcFO/kEeDq/ir7GWDL13qdTwIA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5134.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a17652c1-02c6-49a1-256d-08db1cd81e57
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2023 17:44:34.9973
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Oa2IhJWbuurBeLChsJtMItROZQ2qpuhFviylZ8VwPosccvWto7lhwWC41Y0xQ5/I4BXOUs84lnuNVi3go2N8RA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5095
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-04_10,2023-03-03_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303040152
X-Proofpoint-GUID: JjH1kv7_9m6i4YowYA-layw8nasOzJqF
X-Proofpoint-ORIG-GUID: JjH1kv7_9m6i4YowYA-layw8nasOzJqF
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 4, 2023, at 12:25 PM, Chuck Lever III <chuck.lever@oracle.com> wro=
te:
>=20
>=20
>=20
>> On Mar 3, 2023, at 9:21 PM, Jakub Kicinski <kuba@kernel.org> wrote:
>>=20
>> On Fri, 03 Mar 2023 13:51:31 -0500 Chuck Lever wrote:
>>=20
>>> +static const struct genl_split_ops handshake_nl_ops[] =3D {
>>> +	{
>>> +		.cmd		=3D HANDSHAKE_CMD_ACCEPT,
>>> +		.doit		=3D handshake_nl_accept_doit,
>>> +		.policy		=3D handshake_accept_nl_policy,
>>> +		.maxattr	=3D HANDSHAKE_A_ACCEPT_HANDLER_CLASS,
>>> +		.flags		=3D GENL_ADMIN_PERM | GENL_CMD_CAP_DO,
>>> +	},
>>> +	{
>>> +		.cmd		=3D HANDSHAKE_CMD_DONE,
>>> +		.doit		=3D handshake_nl_done_doit,
>>> +		.policy		=3D handshake_done_nl_policy,
>>> +		.maxattr	=3D HANDSHAKE_A_DONE_MAX,
>>> +		.flags		=3D GENL_CMD_CAP_DO,
>>> +	},
>>> +};
>>> +
>>> +static const struct genl_multicast_group handshake_nl_mcgrps[] =3D {
>>> +	[HANDSHAKE_HANDLER_CLASS_NONE] =3D { .name =3D HANDSHAKE_MCGRP_NONE, =
},
>>> +};
>>> +
>>> +static struct genl_family __ro_after_init handshake_genl_family =3D {
>>> +	.hdrsize		=3D 0,
>>> +	.name			=3D HANDSHAKE_FAMILY_NAME,
>>> +	.version		=3D HANDSHAKE_FAMILY_VERSION,
>>> +	.netnsok		=3D true,
>>> +	.parallel_ops		=3D true,
>>> +	.n_mcgrps		=3D ARRAY_SIZE(handshake_nl_mcgrps),
>>> +	.n_split_ops		=3D ARRAY_SIZE(handshake_nl_ops),
>>> +	.split_ops		=3D handshake_nl_ops,
>>> +	.mcgrps			=3D handshake_nl_mcgrps,
>>> +	.module			=3D THIS_MODULE,
>>> +};
>>=20
>> You're not auto-generating the family, ops, and policies?
>> Any reason?
>=20
> I couldn't find a way to have the generated source appear
> in the middle of a source file. But I see that's not the
> way others are doing it, so I have added separate files
> under net/handshake for the generated source and header
> material. Two things, though:
>=20
> 1. I don't see a generated struct genl_family.

Some experimentation revealed that this is because the spec
was a "genetlink-c" spec which prevents the generation of
"struct genl_family".

But switching it to a "genetlink" spec means it wants my
main header to be linux/handshake.h, and it won't allow the
use of "uapi-header" to put that header somewhere else (in
my case, I thought linux/net/handshake.h was more appropriate).


> 2. The SPDX tags in the generated source files is "BSD
>   3-clause", but the tag in my spec is "GPL-2.0 with
>   syscall note". Oddly, the generated uapi header still
>   has the latter (correct) tag.
>=20
> --
> Chuck Lever
>=20
>=20

--
Chuck Lever


