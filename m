Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5466EAB74
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 15:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232234AbjDUNZk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 09:25:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbjDUNZj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 09:25:39 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30350C17C;
        Fri, 21 Apr 2023 06:25:38 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33LCYrV3010159;
        Fri, 21 Apr 2023 13:25:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=EJJUuraiyU4Az59/yVd+bL07P3RLqlwzEkLdMvnhZqc=;
 b=ZtZ1+i77AIYiHXaNhDlFnpHYvgoM45Ruv1m0/M9TWFmsj0KczJ84tcsrVxowCSwPvC6h
 8F1+lEQG0Ny5PLSvu9Gon5TFJmUSBSuyRaPe56RSNJcxsu26WvXivnbt0XN5lcxq1XtZ
 NYrCLJuzBSgm/yBlwaVNQBvY4ceFRG5koD7jlWRwEDOSoe8jGZKAe1Mg58DkdePZoobH
 pIKsvLh0qCB/Vz3qSIahUuE7Ga9MUBJ2nJ3n6hlzBdqkwQJBbZy7o2zFp5tcf+zANZw/
 dw6k8W5L/k+BQu0Ls+ZJZAIR976h30l/tSKu2RNSvbBeaLGBA8jUyApTGqoyf+ohk06l Uw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pyktaw5w8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Apr 2023 13:25:21 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33LC0BJU015721;
        Fri, 21 Apr 2023 13:25:19 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pyjcfnx0b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Apr 2023 13:25:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O3Uv5RN8O4ybmlWFyNDyFjos1JNu1brjyT2hN1yCmesqKo6s99ucMDaqetydTYKInCFcGzzWygv0dZpOlXizeMy3v6ErvnJ8LaB4Cej5MPYGDYxEh4Iv+vE1/iCXEWoJkE1UHg11rWsSQmB3HtILe/gBBcnzna9DpmbY98m26Aw1rbuAFVeQQSL0DKHXdymG4xZci8Fle2uSHSKBUnUOFB1lKkLb6ab59mUl4dW0O094dFlJo+LMRpnD/k+svZUJ+1dOMkMPvV9Tm9CtwKFnlFiNGVV+95X24O4GkrFHY5WSsVYANb0qIf8aWNJad7fxsDGIqSrir/zlZpUBjdBdTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EJJUuraiyU4Az59/yVd+bL07P3RLqlwzEkLdMvnhZqc=;
 b=cSPLQHOT4tZNUOsHKl8EPSWnlI1s3NPbRCh3fsy8l3fwFn+wdEGgpGPG4xWDNmfRrppnCx8grShSEMz38xsWBdmgaksqp6xblAxKpLuk34ClXKuhR5TuvuCSXvQMeJrJpMbdMWx1ZPWgOZC6dpG2WVUPro0xZr0y2XL/Ixt9QyZrcN8XnKRAiHv8r28gd/3mkOIEdd1+Apu6lFQxi1DlwZkkreJH9i5Xq7VxMSwUNVAzdm9t0HByHrYpTTuZemq1C0OPjDra5PnrDnFzI85ABP3R2TuZkluic+83IDdoai2pHVhcv7i8d7jkmN+TGTf2NJ5+gwT2EhQTJaYlk5uZGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EJJUuraiyU4Az59/yVd+bL07P3RLqlwzEkLdMvnhZqc=;
 b=OpgVt6bVdCmOG1zOiwVXcwPXr4dqpHfw4LD/pT5Kgp9JEzeoXgDMNxku0C7gDv3NUr+Bv38c0MnhDxBinhRlZFOLMAJyt7xqF1zRThqvK+0XVf8FqzFtjXQN6nXBcnnljqcCPYixWmMP2onrxHdfltAzNjh+4Fb/1osNP++lgs4=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by CH3PR10MB6883.namprd10.prod.outlook.com (2603:10b6:610:151::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Fri, 21 Apr
 2023 13:25:16 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db%6]) with mapi id 15.20.6319.022; Fri, 21 Apr 2023
 13:25:16 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Arnd Bergmann <arnd@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        "kernel-tls-handshake@lists.linux.dev" 
        <kernel-tls-handshake@lists.linux.dev>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net/handshake: fix section mismatch error for
 handshake_genl_net_ops
Thread-Topic: [PATCH] net/handshake: fix section mismatch error for
 handshake_genl_net_ops
Thread-Index: AQHZdCrJbFYwZyHCs0+AR8XiNgzQMq81wQoA
Date:   Fri, 21 Apr 2023 13:25:16 +0000
Message-ID: <01A42FB6-9391-4E31-AF58-A522F284A893@oracle.com>
References: <20230421082450.2572594-1-arnd@kernel.org>
In-Reply-To: <20230421082450.2572594-1-arnd@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|CH3PR10MB6883:EE_
x-ms-office365-filtering-correlation-id: dbcde1f6-0d9c-44e2-25cc-08db426bd8b2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2tkKK6U/d8/JvpUXFs9P4WVlaMlcxCSZrO9giFKbI7hoVwrEAEZ1pcC0K9NmvIyD/HcUQFSxp9J87ffrVboZvrnNcl9FDzyzoIKTU+KNsC7WNboVZfN/KEYlVSmQcMBkP5kc4cPayVAFg2GFto0kQTkiez9o8zF4gWdszxSTZj0dzqMVpGeN17UHOORem54Mi2Qf9Hu/hC7Vc38IjG8hdGbr8w9S3mwhFlCGWouLWIigkHOLizV98FkP8StFLRdW0X6l/PB/n8tbCQCdPs2UqVQCSzySE5llhYpKDO1aPM8tacqMWbasznMvv9VuKcYwWtyjMTNkP5wdFkD77BwF8RadL1sHQKsuatwKc0fodQHsERL+Z9Ypz/uKrwj80CT9tFNCcQQAqAoDcjVzOgx+DgNYRRkLGms4TRNDo+ARQw1U893dSoHzYwnVe6d8KZfshkNLKZglqiJuoVdrAQV8uv/T6JZ8CMwWWTXNiceyIfOUv4m73axSy8VzSWnuLbR9QR/hD9QbsqZQsvHc2FwuRgq68nXT2EfqjnTg5e4ODRK3g37oXg6KwFXS413pULoJwp0N7tgO0qWVvzxiGOcZp8d8OyKhvm+o0Y/UKYPZEUo55y3AQqfKflTtKhKTMukwHXfnptSIGYIhWtfCT/dMcg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(376002)(366004)(136003)(39860400002)(451199021)(186003)(38100700002)(122000001)(6506007)(6512007)(26005)(71200400001)(38070700005)(53546011)(33656002)(5660300002)(2616005)(8936002)(8676002)(2906002)(83380400001)(478600001)(54906003)(86362001)(6486002)(36756003)(76116006)(66446008)(66476007)(41300700001)(6916009)(66556008)(64756008)(66946007)(316002)(4326008)(91956017)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?/l5TisWfkCQEBUApl/ECmPv2PPYQ+V1ZimmNknr87Bc9susGtUfTwmCVLVXl?=
 =?us-ascii?Q?xL9MTXBnoMCWaeKqT25Pqt+WjKpI03imAn5UZaXzfV046tcdQq8Qf/bSxjAk?=
 =?us-ascii?Q?/3/V9mVq/BzQWZL5V/SmX7WqgHWB3elMXyl6RPIY1PqLlNlMopl3QKCTFS74?=
 =?us-ascii?Q?yjr624V5t5coAT6BE9mgnSxT/7Am/FjhTLgZHcYa6TtrpJolhiLhtpaZBxUc?=
 =?us-ascii?Q?FxkRdNHOYf8d02lUh+A4FVAd0lAcIB3xqHZceDRQTSbNDXMDXIf3yFPFbGVo?=
 =?us-ascii?Q?zYX7ZHTF1TsnkalpZCTahPSZCf/AXn50jqElbue3H42r/Ba1MpMv2vNEXvMd?=
 =?us-ascii?Q?F2nFKCmgGaIq502tML2nJ48yfihd3oNnm+ofHopS1Dk/eYPWFpvB/5khzjG4?=
 =?us-ascii?Q?hTTcPaI86pDMCFBXcCohgZp68r/+SI5Km67LGk6m75Bd6VLpYgm5qzsLWwJS?=
 =?us-ascii?Q?WuT9ZSiDJfSj+tcRyqiUr30x4aeb/7jWil/m7QbMAtGASTxTWa04cXs+Vk9N?=
 =?us-ascii?Q?v5RdvM7iJiTw11q/B7+RIdOvjffXk9WI6w/6gfutkrkBuQMTD6wBH5xQdZ31?=
 =?us-ascii?Q?phnAA/e7jCyTNdWtjFNYbc8hoCuxysIzIp0ubiDEXJInbPkIMcyhOK4H11VE?=
 =?us-ascii?Q?pFFm0ACl2Nn3Nk+//tvo7nQwPFD+SJD3wDT3BVNhQk6tnoLbhIEY9fh9tX7/?=
 =?us-ascii?Q?Emw5/DPa5BVT6G8qp5p6XVZKzNEfJ6XLfSro90amuqSxxzsu0x0doruTQ3a5?=
 =?us-ascii?Q?N41e1IjBa/8IdxLGqzSEPARyKaEMBrDEaAWJjJxHo7WXxtJeCuskpr2gEDUg?=
 =?us-ascii?Q?Z1PQqg9SsRvo0IN7lL6taa44U9VA7TGl1g+EGj/RE58VIvMdyPxqYQhZODz1?=
 =?us-ascii?Q?UKpwWcUAqkJay0km19vaPkDd3Ln57sDZxi82CO3l67gmuRRkzvODRDnKi0V6?=
 =?us-ascii?Q?3Sqn6sfUFU1F5o5nrLO8/dxpj/eCtGbT1+XAvk2Ga7L6wNb00u9CfJf8Jot7?=
 =?us-ascii?Q?VJsgmGLWhDz1TmTTMMeBlPwTQ/s9896v1DlGhSMjD0vBpfktZVBts4WkbDV5?=
 =?us-ascii?Q?JhkpqC+dC6v4OqJGv89FxSY28hj6mwPgO4GTFC34+MlL6MlzyuZKLwrQFe60?=
 =?us-ascii?Q?WmaH+CuXe1rTKVQMdcykbs5FKPutPgjlV33lnhrXXv7JNHZECwBAzfcCvtWG?=
 =?us-ascii?Q?B7cM0uzDon7L6oFZwgRZyiZTstlZuY8jKEIzzspQn1Ble2XKgQNHsfXLSeuI?=
 =?us-ascii?Q?Uqr4lvbPu5llKSaPpV6YMaSi92PZhO/b42Zq19xVfmAyfZsAy977LqvN3Pq+?=
 =?us-ascii?Q?uxNo58pcBqILD38pgldHEWyq/kTetHBLnEEgMjtHsDWBxH403O/cvEkTnD1E?=
 =?us-ascii?Q?bEtQEh7Ysa6lmxU2RpjHOTb3TeavCYDdGENeRVXUzS19LMIH1sI0ZUDj4Z3h?=
 =?us-ascii?Q?B9txEl0Qn+doN/w8YHn+FyHH4jN8MbXl6Q+HWaE4ebWqVOlqr+JLWl5XqozW?=
 =?us-ascii?Q?vB61lrg8BjvkYqwexrddFbQRBCWZfrFT/tD3RDa68gLWZS5DKPgrwHqbK+/p?=
 =?us-ascii?Q?q5SthmNdxfbRZq17bQqRm1Hwt5mHjPApJYvkWRnxPs3Y+XnHHBmyY8Wxko7+?=
 =?us-ascii?Q?yg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0DE7A0AC60064D4393EBAD039B57ED9D@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?EISN653DhdJWhSrUeNtrnqllL6iQuAJLqFl2IrkuB/ZUSnKltugkBrHDcm3J?=
 =?us-ascii?Q?BV/0dnA7eNfsqO8p6XfDFrsZ+ugBQt71etD7PK6TxJBdIZpiOa0xn8BLquUN?=
 =?us-ascii?Q?d0GPJRfEjX+1LUBvdmqKXwPEmga7143C3nfpT2Jqot/cP4z9VF1prRADkeww?=
 =?us-ascii?Q?b1+uZ00ETKBurAV6RZ6tDMaLIPDKISMVRKLZnmLXyeXCfxHtuEPkLOcF/kpc?=
 =?us-ascii?Q?+8B1r0Zi8wc2p3so0wSlwfn1ODaiRhKhOydn+Zye+aRpIvo9nhNES7wIc+I7?=
 =?us-ascii?Q?/eQW8nAtfck9ijYrKqTx9X8qfrPy963LEJlepDAbUNVkjY9Yx1Acd6Jp1nax?=
 =?us-ascii?Q?ZqpUHaG3+Fkk7Cs6UL3gTap9iSy0/diAKKlXg6YjTBWVRKAJecIXa7/ywlvC?=
 =?us-ascii?Q?jbcWGzG7+ftIJQNseF4v8zNW9lR+hFGMNJYQ1HjjlbLg2gDdoddmNLd66KYh?=
 =?us-ascii?Q?j4xWVt+lHoROnsILYfOIFcqfZoaoAILOtFU9n1YJI1koz105Jt6iq1YzGHht?=
 =?us-ascii?Q?F4WUf+ZZrakp4/m29Dla6D0XrP1DNjC/DdMxn3bL2WXyY17pnaoQJ+XlUV+5?=
 =?us-ascii?Q?T0W6tz+krR985Xuq894W8kqqklfOfO0QiYwHwfAh3yyOHMCm8H65eA22DxzR?=
 =?us-ascii?Q?XXMjEoMcDAyLcFTNbe+nZ4R5955L3NOUjY/xMtBqeBZNH4Zp9eWvMMO7LCRe?=
 =?us-ascii?Q?2xrX03AM4T/QGLHemhP+YPIp1BNXy/bMeFjvtR4fKE/CEVV0MRGWDo49rUKA?=
 =?us-ascii?Q?8zWSrmRSKYXGh0RpR4uzVfeRAAMO255jkMrNgpxltrkNJYlZuhknqTd96TCa?=
 =?us-ascii?Q?8QhWpuxQU5J9CV7nSnIRKj6LlC42b//jgAjRn01cq7ClLbECrRj759mmGBAk?=
 =?us-ascii?Q?uZS/2MKMeo7HkxLHMtOhBf8ERzZzkB5nLicbPXr7d+i1Nb3JaqXeAgHp/Sy0?=
 =?us-ascii?Q?PywVlPBisyhi989SvZJeKw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbcde1f6-0d9c-44e2-25cc-08db426bd8b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Apr 2023 13:25:16.7488
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XD1GkiLTl1h+KObeZO7QRxEjlRpdM+qSoP3MyRO3liaVC1mjFIyETXMGDovIcFSP1hlB/OykrzyL1HLfCLwBBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6883
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-21_06,2023-04-21_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 malwarescore=0 spamscore=0 bulkscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304210117
X-Proofpoint-ORIG-GUID: bx2lHGbrpnXkNARhjDJSqEBijwkgakl6
X-Proofpoint-GUID: bx2lHGbrpnXkNARhjDJSqEBijwkgakl6
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Apr 21, 2023, at 4:24 AM, Arnd Bergmann <arnd@kernel.org> wrote:
>=20
> From: Arnd Bergmann <arnd@arndb.de>
>=20
> The new netlink interface causes a link-time warning about the use of
> a discarded symbol:
>=20
> WARNING: modpost: vmlinux.o: section mismatch in reference: handshake_exi=
t (section: .exit.text) -> (unknown) (section: .init.data)
> ERROR: modpost: Section mismatches detected.
>=20
> There are other instances of pernet_operations that are marked as
> __net_initdata as well, so I'm not sure what the lifetime rules are,
> but it's clear that any discarded symbol cannot be referenced from an
> exitcall, so remove that annotation here.
>=20
> Fixes: 3b3009ea8abb ("net/handshake: Create a NETLINK service for handlin=
g handshake requests")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Thank you, Arnd. We received two other patches yesterday
with the same build error report and suggested fix.


> ---
> net/handshake/netlink.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/net/handshake/netlink.c b/net/handshake/netlink.c
> index 8ea0ff993f9f..35c9c445e0b8 100644
> --- a/net/handshake/netlink.c
> +++ b/net/handshake/netlink.c
> @@ -249,7 +249,7 @@ static void __net_exit handshake_net_exit(struct net =
*net)
> }
> }
>=20
> -static struct pernet_operations __net_initdata handshake_genl_net_ops =
=3D {
> +static struct pernet_operations handshake_genl_net_ops =3D {
> .init =3D handshake_net_init,
> .exit =3D handshake_net_exit,
> .id =3D &handshake_net_id,
> --=20
> 2.39.2
>=20

--
Chuck Lever


