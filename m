Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD28D699880
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 16:16:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbjBPPQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 10:16:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbjBPPQK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 10:16:10 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC1D948E16
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 07:16:04 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31G8Fqcu026691;
        Thu, 16 Feb 2023 15:15:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=Syylf1QiNTaxdupqevRLKL3E2LeUgtXRf8pBZzn8Joc=;
 b=jhwlvJXWgEMG6WRjVbQ+eKt1gLmBvMbMIzSbxHYfbJDGLJqRQSMwWAfU/fZgQJQrPfCG
 uxsHLVenu+0owAxkAGAwi2NvZENw10aUYd7fG8DPfP284SqYsYYM2LBY6BlDoDZVPvbI
 XmgyKpJ7MczRj6zw69F5VZCyrLrw2KemA1dI3ezZuCDl/m2m3fKS9hK3TvYB922NkDb+
 1TeFwo9lCTwDpiwwg35VSCwvyRb2ZljngbK0s+uSyYyhn0o4O8Mmcpo7HGA5CbtcRmCa
 oE2Pj9SaS6Yld8tlA8LdBTnlTL+1DXcvbNr8l3I6dGKfCWS4woGuZvGNg83VadAt9H1d PA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np3ju3cvd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 15:15:55 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31GEF5j1016754;
        Thu, 16 Feb 2023 15:15:54 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f8tc3r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 15:15:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QjzrmjEQOvspncvdHagTKi/mMkL3akU+rRK6xTXbbSzmNRbDPYux32p50sfMzkMCZlJCz5eCmBEENhr20Cb2leMhHa766kspaj0GTwo9sxgvK9+5P1zmYZudaaC3m0cetc5fs9OWylukRS9Q7ivy73N0NRas6ZWM8+KCeRuCZ4bMjQ++lTvE0Zndx5JF37NYnfbKl8uhaYW+9bwMx3y+qZz34kuAkPLRXCBsazi7UvarF8XvqwMopBz/q56vPpMi/0vjNwg3GLFUvdCxcHMYKnIV025csH3ZR2kqkNinAEmnu8QDIt+suZIrTb3Vz17AjI2DVnhekucownRWC6KuAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Syylf1QiNTaxdupqevRLKL3E2LeUgtXRf8pBZzn8Joc=;
 b=N5qUbUdRSO2gg6j1lf9lIwodNmdKJxbKWwmkJc6X18Kh8sQYvTu20fM0lIfPb+f6Tz9XP3fcj6JCRNzJRs/eec2X+Ip2g7lQAapd0zD57vcQ4MQyvskj/ukdnHrxkT8nuXxEUVb0DFhrJvBbu+OLeT9xY2v5pCrgxLgMpnU+dlFp2reuBbsCObwV4oa0CRKWrJjmOBur07Mqg8TXArNT8pgRo7T+m08pltzmnqZB9cbQtobsVV6dHyOTdu6b4cyeSQvYVydeXVPcleeFogNQ79koy+GX90alTaFBqcHuQy/5brK9YUPQ1do9u/zrQ/qD5L1wSiHaeWopY+uYuSGk1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Syylf1QiNTaxdupqevRLKL3E2LeUgtXRf8pBZzn8Joc=;
 b=iPdL2vcYzMMXQ/px5LzcR/phaZWaQxg0Ci5zRwm9J/YLE0YKw+TQiNuMXrZtA0u3q1P7En3ruWSGU3JkCj4G82jEjUHb8GlkBez0D8qFZcfxxxaJDzhv6WEXQLtTyGQBy+mKufRFdG3iP/Pyv4uacPdz/6e8ES3lr0Rk+HUUG98=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by DM4PR10MB6912.namprd10.prod.outlook.com (2603:10b6:8:100::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.10; Thu, 16 Feb
 2023 15:15:51 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::5c2f:5e81:b6c4:a127]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::5c2f:5e81:b6c4:a127%6]) with mapi id 15.20.6111.012; Thu, 16 Feb 2023
 15:15:51 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Paolo Abeni <pabeni@redhat.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "hare@suse.com" <hare@suse.com>,
        David Howells <dhowells@redhat.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Olga Kornievskaia <kolga@netapp.com>,
        "jmeneghi@redhat.com" <jmeneghi@redhat.com>
Subject: Re: [PATCH v4 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
Thread-Topic: [PATCH v4 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
Thread-Index: AQHZQXL4y0AJVz+Er0ij5JPtxaDJBK7RjaUAgAAikAA=
Date:   Thu, 16 Feb 2023 15:15:51 +0000
Message-ID: <EF32EEAE-EEE3-4715-8048-F5E47A360D74@oracle.com>
References: <167648817566.5586.11847329328944648217.stgit@91.116.238.104.host.secureserver.net>
 <167648899461.5586.1581702417186195077.stgit@91.116.238.104.host.secureserver.net>
 <df1c06c2a2b516e4adb5d74cf1f50935e745abdc.camel@redhat.com>
In-Reply-To: <df1c06c2a2b516e4adb5d74cf1f50935e745abdc.camel@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.2)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|DM4PR10MB6912:EE_
x-ms-office365-filtering-correlation-id: 063fe62d-2283-456f-1a25-08db1030b0ce
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6DLo+JBeHimddDuntXzI1Ldhuqc5k3WpWJ5PiE8g0OIxhdEBP8fiYk7PmEeUzgh5Pru3uMbVFq2lM2CrmbUt3M7Ijiq/TTFVKHSVG/+VmIOrLhVCUk1QxeZtLndhJxBuCflm+QEhUAs+ihy9FjuTIbVZan/XoJVDOnLCTwgPoqUujFqDKNHu7YZ/fA2VNvO/qiTGLp7zwd7KAL99RXda9STW9SLUAGgLOv0GZ5M1WdJzLq+ikFaOpjzLTfCHSF1fqSFeCfrJ3kiOd9N3godgN8RHBylUz2QgLFh4ksNPJg1kXAwCsGDR+BXlvn3c1IouDyP+EL5qzpRDCe3SRpqG/CeeTqedg9XqJ18T5N80SvtafQGRIpY7yyhlR+mj0f8EArWwQZNQAxCUBygseFfA8Y7qR7ohhukKov3hoF4HghZsO+9fhTQ96ZYqoUNfBsN3ogyFGBHfPimDkvcF6zJHXnDnQzWDiXhm+tKE5E6uoVoG1L7H1LogfXJYrslsV8jB3FxlYgxdiEMWyoWObpQhJo8bV0DW62XW2eDKlRdBcZQTW99ZAd5V/W5bVNijcUrDer9WQ0Hqe+zfFKavfrmKzA2Vk2NqbJZffm7ps0LG+j4yLWvmQe3x3SLjsNwEnx75oPVaKZm6v6OV/xuU71UoQCmseCynCXWjEqeRYmcgQgxKsNMVP1fzVG9/YSZsURKy/b73xhDNGcY0vgLWUk5iL4aVV9vojQU0UvNwZ8JJrgD+GRJTzP8CHAiY6I+3g6Kq
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(396003)(136003)(39860400002)(376002)(346002)(451199018)(66899018)(8676002)(91956017)(2616005)(6486002)(36756003)(4326008)(71200400001)(6506007)(478600001)(66946007)(26005)(186003)(76116006)(6512007)(66556008)(66476007)(66446008)(53546011)(64756008)(6916009)(316002)(86362001)(41300700001)(54906003)(33656002)(38100700002)(122000001)(38070700005)(2906002)(8936002)(5660300002)(83380400001)(21314003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hPDdkh1augBGOZpRM2obWrBE/ZDbzmwir+zqseU7/D9kg6RJVk9+lJrqXgR7?=
 =?us-ascii?Q?BSZpn14RjHnKoo/8DFh0PA0jX3P2+Q8jG83dOe8Dn9N4J9lRbxk9rX/YKWsO?=
 =?us-ascii?Q?lSog163q29E/oGbTEZiGJrdm+9pKEREhjxSE87bMcwfIZUTPe8Sanejm4pkk?=
 =?us-ascii?Q?rWua+Sa8boaIZfg7cqJzc9qJvtFklgDYJPuK3+axEWilFf0H/O98wUs83DyD?=
 =?us-ascii?Q?NM+Z4Ng+xGDB2SrBOnggrprgSC3uG/Jebav9OV+f12vbbnXSl9Xz8QKfggz8?=
 =?us-ascii?Q?vtj8dLTiGFFoThSiQQqfB5vi1vgMvmo0TvGuQivFEjC3bR4nLjStry+6it+5?=
 =?us-ascii?Q?O3ZLXlBuP/wDQTjGkj+X4LfW78SQHd9hxx2fw7XRsdgFEmtRn/OHSJFKbF8I?=
 =?us-ascii?Q?MD75Cw/b0X39v4IbabBNo8v/3wMnRBNSMF2REqBCi8QnBdtwCOOIFGUpV8gu?=
 =?us-ascii?Q?KzOKAIW8u9AIO2XcztCH5G3KgHhZEm0zQeAe9e6n7W1tOgRvx1up+mRYduiZ?=
 =?us-ascii?Q?bt+CiDjTH3ah3FvgpyFlb6FJPaxQ+2o/pterr6sPq2ncVCjCOYaw5JyU5C3X?=
 =?us-ascii?Q?mGz59j4KMSwCbTb1Okd6eBrxRoPHzT0T8xinMrPug/d/ioiuymRJFMk1alaM?=
 =?us-ascii?Q?b++PXJYXC4jfextX61VMX6qqOBUZrive33QiJyIXbIDzyOctJeOERbthFlsn?=
 =?us-ascii?Q?+rMcbIC1HlVOVYHpSYHW8WTzIEQSKf8Aa+U3r0eWT615lSPLLi3UyeC/D5Ml?=
 =?us-ascii?Q?u5T8diPAkuLen+3uZs4HdGu+io0XicLbIMSZw+44mbYnK98Bt2ZV16yrEoFS?=
 =?us-ascii?Q?eylxO1vpgEStaQEPWjPlrrRBkeysa+xiufhJk/DF8Bk8i+fKAuqCEtEJJj/P?=
 =?us-ascii?Q?8/uRKjlq/NcvnoZvneghAk6WfLybUOboNIdWJLW1aWYPmz0NpEEWrCRikPbF?=
 =?us-ascii?Q?EwOB3sYFm9wk2HvAgIWx6BflXX8wdckeE2GJNmjFjodeL/TbRs0zx+ft2FJ9?=
 =?us-ascii?Q?Q8wbVeM49CfzmoUDh8dk7rPjoLHSDuKCCwoqtihhgkhNFaHrppcFcfAeP6zy?=
 =?us-ascii?Q?djg6BOC4wBvPUl2VGjQI6zPQ9xz8k53cuQdvnIfOKuCcxKvVeK+YmKR6XTlW?=
 =?us-ascii?Q?DSk1USDEknWAgFT+WKtdovhChRdPJo01dLh0Nw2X8YbZ2FmPncCi3BCgkGKo?=
 =?us-ascii?Q?LUlCunuYbuSHtjbbuPNLkUaxbxW6FljJP6oWPHmz9GW4HS5nTSV9Ywu22xM5?=
 =?us-ascii?Q?0jx21o/JFCR9bTCb+NyRT7xIV8QGjZzX/c8Irv7e8wgwD0/gy+/bqnIphe8M?=
 =?us-ascii?Q?Iauf3OB/YUEVoejL7+gSy4/8ESpbJw4R59ada4Ebn8b2NIqNHv9P4HDtqoO8?=
 =?us-ascii?Q?7+Yrz3Lo7L/nrf0wM32vJT0YkcF2sA/XxHjTkbG8to9NK8BuNWWy6cImx+nA?=
 =?us-ascii?Q?wbxYC6zyVkbxjBN5vIgaMBe5elD8ky4QMy0drxmbWoJjuZDZSZAtSVKzQ02+?=
 =?us-ascii?Q?6t+h7zSFIofE10Mrj2/pD1eyK4i0P3SHVsGtSle80AjdkU04aCFXQPz2Dfc/?=
 =?us-ascii?Q?x1jb67Auuv3X7aN97bTOOeFse88i92c+vJScf/PEz0g3wIFa+DV5yWu8eJLc?=
 =?us-ascii?Q?HA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <11CD06DC71B108408B0F652773AC4A75@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Va+v4vWdC5C1t7oqrycaNIfbEnhQOTmh6QrLOF7sUY9we/EZJ66E2SquMnqFTHvczec8hzVr6XWni6lUz3/MVzHpIq5RItOofM2Guem7cNwTvCWS/KJt/ki0mOO4D8EeUUz8evJhc4af3HCeqY898DrVX84Mw+6vj/K3MBKxw00CGk78sasvT86ct8DX+v5FkU0rL11luHbcyc9ngMq5xhvt0YqqyakXAM+yU3aPmZoAKzgDvA7a3OCb+J9vrCzYnE+9aaA3m/yoE/rK/vTGIimFNZdAeNWU6r6pcVfTSkp5TSghSKdrlOFRTCJSGWHVPmtRZt23BLpv5CeCyGlYGiQPDX1ulr36RtwaQd4uVpCadoAp2wGcgoG2RrD5KGhmojSlilg2lUrm1y83CxtKieWT6/+gCbaBnVofWYMyiRGMVvNw5JsXOWFMjL5+HrSXERNzR852m3wePvLZVtcQXbYJx2olOcTbSvydDvPY2OT2ORr9fRYPXR2wnoQSChWAXFzCpTX1AHL40cSb4tpqqtydz+du339ikZd8Q2l0lPXGiXGTgI1h/upo835rRZPyvagbLMS5Jlwh+ikfK4x1xFNgcIuVSQ7sxCz4I/7qsglMjrOXN0aaNehigiTWoaEQ/l97fI1NvAxp0blNKGqvB47ztHdo8bjKjTFRjEMl01AZemQyfK2XJsiTkWfxiC2XjfljHeWmBYFOFI1wK9hcF3lWMC7XZyJWinb5ow8hOgTLWCFi1Th6V+TxYkoQbTDuVc1QRSXNPnrCPe9cqKyn/2L/BWryDePSCuhpXi3oeE1yIf/dkhDe9RHYzQaxRm82tVNq0iYqd4PvknnRc7ZYUXodFtdPnFVLXkCLDNJXAwn2puecHku9LjGsY9BeSXh40+dZy05lor5kDK61IwtZnw==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 063fe62d-2283-456f-1a25-08db1030b0ce
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Feb 2023 15:15:51.3203
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u19OMz2Zq2SLYwF3a0rVh5LDOHgsgH3wmyhIb69+0oxGTkWrW1Au6+ClIKVtUw1xrV3YRiBpuJsTC3bqu27xFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6912
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-16_11,2023-02-16_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxscore=0 spamscore=0 mlxlogscore=999 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302160132
X-Proofpoint-ORIG-GUID: q2zsPpbY4CRI82QkbbvJN1-tFNk8i-yJ
X-Proofpoint-GUID: q2zsPpbY4CRI82QkbbvJN1-tFNk8i-yJ
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On Feb 16, 2023, at 8:12 AM, Paolo Abeni <pabeni@redhat.com> wrote:
>=20
> [partial feedback /me is still a bit lost in the code ;]

Thanks to you, Hannes, and Jakub for your review.

Responses/questions below.


> On Wed, 2023-02-15 at 14:23 -0500, Chuck Lever wrote:
>> +/*
>> + * This function is careful to not close the socket. It merely removes
>> + * it from the file descriptor table so that it is no longer visible
>> + * to the calling process.
>> + */
>> +static int handshake_genl_cmd_done(struct sk_buff *skb, struct genl_inf=
o *gi)
>> +{
>> +	struct nlattr *tb[HANDSHAKE_GENL_ATTR_MAX + 1];
>> +	struct handshake_req *req;
>> +	struct socket *sock;
>> +	int fd, status, err;
>> +
>> +	err =3D genlmsg_parse(nlmsg_hdr(skb), &handshake_genl_family, tb,
>> +			    HANDSHAKE_GENL_ATTR_MAX, handshake_genl_policy,
>> +			    NULL);
>> +	if (err) {
>> +		pr_err_ratelimited("%s: genlmsg_parse() returned %d\n",
>> +				   __func__, err);
>> +		return err;
>> +	}
>> +
>> +	if (!tb[HANDSHAKE_GENL_ATTR_SOCKFD])
>> +		return handshake_genl_status_reply(skb, gi, -EINVAL);
>> +	err =3D 0;
>> +	fd =3D nla_get_u32(tb[HANDSHAKE_GENL_ATTR_SOCKFD]);
>> +	sock =3D sockfd_lookup(fd, &err);
>> +	if (err)
>> +		return handshake_genl_status_reply(skb, gi, -EBADF);
>> +
>> +	req =3D sock->sk->sk_handshake_req;
>> +	if (req->hr_fd !=3D fd)	/* sanity */
>> +		return handshake_genl_status_reply(skb, gi, -EBADF);
>> +
>> +	status =3D -EIO;
>> +	if (tb[HANDSHAKE_GENL_ATTR_SESS_STATUS])
>> +		status =3D nla_get_u32(tb[HANDSHAKE_GENL_ATTR_SESS_STATUS]);
>> +
>> +	put_unused_fd(req->hr_fd);
>=20
> If I read correctly, at this point the user-space is expected to have
> already closed hr_fd , but that is not enforced, right? a buggy or
> malicious user-space could cause bad things not closing such fd.

No, user space is no longer supposed to close the fd. The
CMD_DONE operation functions as "close" now. But maybe
that's a bad idea. More below.

The problem is what happens if user space /does/ close
without calling DONE; for example, if the daemon seg faults
and exits? (In other words, I'm not sure if the upcall
mechanism as it is now handles that kind of behavior).


> Can we use sockfd_put(sock) instead? will make the code more readable,
> I think.

Not sure yet, I need more detail; and if we use an
sk_destructor function, maybe that won't be needed.


> BTW I don't think there is any problem with the sock->sk dereference
> above, the fd reference count will prevent __sock_release from being
> called.

Yes, I tried to ensure that socket reference counting
keeps it alive where it might be used or dereferenced.


> [...]
>=20
>> +static void __net_exit handshake_net_exit(struct net *net)
>> +{
>> +	struct handshake_req *req;
>> +	LIST_HEAD(requests);
>> +
>> +	/*
>> +	 * XXX: This drains the net's pending list, but does
>> +	 *	nothing about requests that have been accepted
>> +	 *	and are in progress.
>> +	 */
>> +	spin_lock(&net->hs_lock);
>> +	list_splice_init(&requests, &net->hs_requests);
>> +	spin_unlock(&net->hs_lock);
>=20
> If I read correctly accepted, uncompleted reqs are leaked.

Yes, that's exactly right.


> I think that
> could be prevented installing a custom sk_destructor in sock->sk
> tacking care of freeing the sk->sk_handshake_req. The existing/old
> sk_destructor - if any - could be stored in an additional
> sk_handshake_req field and tail-called by the req's one.

I've been looking for a way to modify socket close behavior
for these sockets, and this sounds like it's in the
neighborhood. I'll have a look.

So one thing we might do is have CMD_DONE act just as a way
to report handshake results, and have the handshake daemon
close the fd to signal it's finished with it. sk_destructor
would then fire handshake_complete and free the
handshake_req.

Might make things a little more robust?


> [...]
>=20
>> +/*
>> + * This limit is to prevent slow remotes from causing denial of service=
.
>> + * A ulimit-style tunable might be used instead.
>> + */
>> +#define HANDSHAKE_PENDING_MAX (10)
>=20
> I liked the idea of a core mem based limit ;) not a big deal anyway ;)

Well, this is a placeholder, carried over from the last
version of this series. It's based on the same concept for
the maximum length of a listener queue.

I'm not dropping your idea, but instead trying to get the
high order bits taken care of first. If you have some
sample code, I'm happy to integrate it sooner rather than
later!


>> +
>> +struct handshake_req *handshake_req_get(struct handshake_req *req)
>> +{
>> +	return likely(refcount_inc_not_zero(&req->hr_ref)) ? req : NULL;
>> +}
>=20
> It's unclear to me under which circumstances the refcount should be >
> 1: AFAICS the req should have always a single owner: initially the
> creator, then the accept queue and finally the user-space serving the
> request.

I think during request cancelation there are some moments
where a race between cancel and complete might result in
one of those two ending up with a reference to a freed
handshake_req. So I added reference counting.

Hannes is concerned about handshakes taking too long, and
would like a timeout mechanism. A handshake timeout would
be the same as a call to handshake_cancel, and thus be
likewise racy.

However if we use close/sk_destructor to fire the
completion and free the handshake_req, then maybe cancel/
timeout could be done simply by killing the user space
process that is handling the handshake request.


--
Chuck Lever



