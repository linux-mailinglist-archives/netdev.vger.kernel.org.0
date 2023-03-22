Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA6266C50D1
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 17:33:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbjCVQdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 12:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbjCVQdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 12:33:04 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACEAEA25E
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 09:33:01 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32MCYOEj029423;
        Wed, 22 Mar 2023 16:32:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=Z6w3WRnYZPkhhm5P6+VuWWbGlT6udhxtVBoRbyBnLfM=;
 b=KyBTMGlX3clyQ2IOT0XvZ+w8N/qgqRWZKtcdGAE4NPMInZWuQF5lsE2WjdebV4aGTmXc
 GuSe0evQvhr/dx4TVVb58ud2k6bskupupa/RSAtqvR7aAc/v6x+Qq3siUulawdQQwigI
 jsniwEJHSvsakhIVaxmogPwZJe3ve3bFolWPutSXKljqlR2hAaIDSWZ2Om/KgfeAQEjm
 5txiX805sWtXs5nr6DCT1wVMLKFIlxhLi+0vMJ7oU1Hr3HPtn5grA1jdACNpvukFibP3
 q3rYJLOpzQO8dn8l0KYfWEV0AD2ymunaMhEU4FexxVe/EbH+LANGdtJGNaTHdheU0BET iw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pd56b1c9f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Mar 2023 16:32:50 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32MG8Dct029392;
        Wed, 22 Mar 2023 16:32:47 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3pg3m8mtjg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Mar 2023 16:32:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DWiHC92DDoDcSloJjN77YKK7XvLCcc18ZeqfErbipUEekFKpkRTv5SyjezH2KP/sOZKzNsx7ZW6UHrXSkiisGqPLdVGm6LOlPuf75l3GxovGaB6UjFEqIqCHxPwTa9Ysciype/xwLOojVv9G4Enw3hRHYytYdgBW6T9PyDnFjzx3Z1VpJ1S74jDGxa+zucswobmN37cbyzEmbrSekcl0VNrbxvHCTFaNcaXy+bQ4EH9Oyg/CIlCxuoMV3AvdN34bto3nba5ser1Jvav2xbEhGHglF4AeTjWfBegL7DcK0ZGL/s/NLSXMGRKhp322ltCfx7TaM/C/0XZwxzAIo9b3lQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z6w3WRnYZPkhhm5P6+VuWWbGlT6udhxtVBoRbyBnLfM=;
 b=nocU5TSbrzjiKobAmAoOP+Bse5Pg5AEV9ut4wF691qwo/AW8taiFYcq6R2rO11mqsuJSgOaibESketNOZlCKqBm2eWaMqV1jM2qHWtjqbbhZOkRpeovmkPe1Y+F5I6I3KMD5/nnaIQ38DLVAr6Xv9k5tW7Z7QV0lh8tzMS5WrRnZoJ2WKw1MvQ8bvwZicNqMYnwUW3bXyeNV0yJyR8I9lGgd5pypZVB16PgRZ18UP6gxjyHjElQZ9WLIlSVY1yv10l4+h/aXmHkDG5+w2IrlsV622/3R43JTCokT69h/hDhwco18m2S0s4zfTXvnswfLLjc1/3QmvAdNyfAwBBSKSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z6w3WRnYZPkhhm5P6+VuWWbGlT6udhxtVBoRbyBnLfM=;
 b=Le/BDkd+E2NjuFC7EcLE/ygGTI4WttbgXNKcYYnoxAyqk5DXPEHMRiR1OgcFo8TgO9yfuAlXw+l03I7X8Mqlf0ILL8vMPBm98GhHDbNDfs3cVrJ1MwY/Nq8SXhP2/xKJ17VgPsZ+8SPT9iRlk3M3eN9/Em5QhpULWG7LeRJ1OFE=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by BLAPR10MB5316.namprd10.prod.outlook.com (2603:10b6:208:326::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 16:32:39 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::5c2f:5e81:b6c4:a127]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::5c2f:5e81:b6c4:a127%8]) with mapi id 15.20.6178.037; Wed, 22 Mar 2023
 16:32:39 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Paolo Abeni <pabeni@redhat.com>
CC:     Chuck Lever <cel@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "kernel-tls-handshake@lists.linux.dev" 
        <kernel-tls-handshake@lists.linux.dev>,
        John Haxby <john.haxby@oracle.com>
Subject: Re: [PATCH v7 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
Thread-Topic: [PATCH v7 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
Thread-Index: AQHZWbVGJzLbQ29BsEW987typvYRiq8FHPAAgAAqL4CAAT/BgIAAS+8AgAAxm4A=
Date:   Wed, 22 Mar 2023 16:32:39 +0000
Message-ID: <5CE43DB5-8171-4C44-82AA-726E71D5C087@oracle.com>
References: <167915594811.91792.15722842400657376706.stgit@manet.1015granger.net>
 <167915629953.91792.17220269709156129944.stgit@manet.1015granger.net>
 <3dc6b9290984bc07ae5ac9c5a9fba01742b64f84.camel@redhat.com>
 <674AEE9C-BDB7-440E-902E-73918D6E2370@oracle.com>
 <dc32e3654de0bee5d8c6cf64375fa491b89d655f.camel@redhat.com>
 <1BD8AD98-0775-4E65-ABC5-23A83AC98D4B@oracle.com>
In-Reply-To: <1BD8AD98-0775-4E65-ABC5-23A83AC98D4B@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.2)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|BLAPR10MB5316:EE_
x-ms-office365-filtering-correlation-id: f8736e73-daa4-49c7-7ced-08db2af30db7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bTjBlNzRNZ3jMGOitwif++2xNe6k7mpAz2Cr3zSlluMjacRwc7C3KLhrg5W0YY5dXs/a2Bll/W9QXID2C9SlTIvL2NoOlzkxICyHIFCNlduw8Xmhl6h9+wssI6pu9j/vjoxeYSvAgX1uV7Xog23jmQpkbDq2FcEGzUymz1e3Fk4CDGV33bYDu9b0JkFiEo7ugnUqeR/LfMbKl9694zBaIqPMTOWyf8ME00WgNQItQuxIuzWHbA6bTbZJmTzfTh2YE1pPEV2wCqldjVHLHzbGhEsOXFFuYz1sczYY32VzFHHDbsWEd23bFwzlsU+R8OapackAhFv03vZavjMd7PLwyokRB3vbFQzCLmBGhX824URPOawkDSRzZinzxbaaM1dcymohuF/uLmV/AkS4IbKUHZ7hDj5pth9OycnPa0gkzoGW6Vb69HQgk34bJztlba07egaVBMsrcBCFIGouYM55tkM4hFrq4x1A1cqFDueRfehh/ubh8FpVMu4BWtYQQeCcc2A5SX6kjN9j5+PzbH2Cim2c6xJY0SCeUe4yIehX24wh87CyIJMcdvtrvyvF7497NvBKHkkxJdOPvN5FtAd7dcboa/IyB9PweYZTd9MIuSGy6ec9kIQf6JDt1zPavtkNfn0Mj1Niwd45r+97GghtQLRo8oZI6ya4snu/EACoUdaUw9bjcLBeieYje6/bB4SnDZapTXz5FSCEBCj50i7Ht/fA73ftXBmQcAo4muEETH4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(396003)(346002)(366004)(39860400002)(136003)(451199018)(4744005)(8936002)(5660300002)(41300700001)(38070700005)(33656002)(86362001)(122000001)(38100700002)(2906002)(36756003)(186003)(4326008)(478600001)(107886003)(2616005)(6486002)(71200400001)(6506007)(26005)(6512007)(53546011)(54906003)(316002)(8676002)(76116006)(66446008)(6916009)(64756008)(91956017)(66946007)(66476007)(66556008)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?q+F5zprDvkYliEOfUUiyHuVtBo3a8L/5YqsxBWnmoxwpayqnqXbxrDHuDadE?=
 =?us-ascii?Q?S3sa8MUT3pK7A1rowMNjnkNKuQU+pjT0DQLCrU2RYsqxGWQQ+oHfETCu3n3U?=
 =?us-ascii?Q?FhPuAadrd2ttijP55OomxuHWRO1qf8bJ15yQgXCEu0GYv5IZu8QmvnbouzLV?=
 =?us-ascii?Q?KWcLpneXX3r072siT1eW+0b8FgSSW05iY7uTc7KjwZ2bTV25jE28w/Mh6rZ/?=
 =?us-ascii?Q?O2NOHMVs70Tz94ppRctoJ8K8hQMYRlHfqEWdOuZvVoXTRqnxYTsvzHIMQdCK?=
 =?us-ascii?Q?zB3PgC/ylHL1IsA69np42rrXZUcPqc8B+aFxGTVUrAh6+AhUSnWE/Rn3wC2d?=
 =?us-ascii?Q?csK9iqYuQeugEBkx5Orgd9BxU2dEDUu1/lnEYvpTcUn5QOZxPdxkIg7UqPGx?=
 =?us-ascii?Q?eQUik/OpoimkRTlcrAM9whiKZ0oznJHFq1jrs+rwmwYdjGd0x+/EtWwIKU0O?=
 =?us-ascii?Q?ZF8c5tfJXrdCzwSzoxr2e7k9SaTieozFMSi/uOLmmHkEmVmumIWJZpE8Fb1l?=
 =?us-ascii?Q?xGeoU8ZJj9kuMzb3AD6IBKv2VbC1JvBcYLDKNXGZHN5zO0hqxNsnMx6y+p6a?=
 =?us-ascii?Q?Zy0zoue3b+oQOJGWiDa7VI/xcZ289gsjjCS3Kz8NbHJLjA88B/Kfz1EfgqbW?=
 =?us-ascii?Q?6HytrFyAmRnXXmveCUGdSvLAQiJeh6kRLIInGs4PwVm0dUBy9OC8VZxR7Whd?=
 =?us-ascii?Q?D3u00VYVgJwnA7wtnfSYF5ZTN/pWFy33rq97zmgrNUwKL3djMalleRZg7NZt?=
 =?us-ascii?Q?iuZ+amMwYSqgxBLP5w1e1kfbczf63Ujgz93WITzWk6sNPRxaiAbRp+T6OCsW?=
 =?us-ascii?Q?Uic8BcpTdo1bu0/WZoppYpGDy9QWDU6KhURsx19AzlBEiInRYcyEYQtWX8as?=
 =?us-ascii?Q?yYcPHMwKlESV3ffv/HcKHKjc8HS5jFjnGKWt6YUVqxZF04MOf4CcPgiT2beB?=
 =?us-ascii?Q?j0HRLOR4HiUXJWuP1LuGoN9R5TWedYpwM0WWLKyagJC0LWOf804m8x1ZTrGM?=
 =?us-ascii?Q?+RslWL9eflu4D/cMrtDmpyrMdEt8csk5bt9vxThI18YL65newm5XJ0QRoEl6?=
 =?us-ascii?Q?V42zY4w9JHPAORokDkIU5CpYCHNnwq3clw/MLoyz2uAiCTLFHO5cBrMw5thv?=
 =?us-ascii?Q?i+2/Toe/54+JjAIyXErlhdZ7/SZvWLF6es6KawEI8x9seHlYXTicuyVOPvLK?=
 =?us-ascii?Q?kmmwXdRO9dssYFYzETI1GfAurNgUI010oYBZ/wDuMhdomHjJmM7Nt5YQ3XaC?=
 =?us-ascii?Q?ck72l4PfkVhodiOTy1fDNql3ilevinUw6Yr/g5Xw9AdniOwqTLsoakY9TIt0?=
 =?us-ascii?Q?uXh3XqB29hJOYZ6rheJxvalZj/5MdnypxhcE9pmfumtHPTntrkTQy8C8aEVL?=
 =?us-ascii?Q?IA31VKZIbPJ5TEyqaAuA9lPdXkDrwfeSdIALaTQw8RmSAEQZ/dN44kfWLi3C?=
 =?us-ascii?Q?F9AX79RsNVy4hEP46jI+Fg/ThkODdHkI6BtqSM1wfRQMQqM9dUDGl68HHVbo?=
 =?us-ascii?Q?E1PkezNnyQOFa7OwUNxKLA1jHg8yx1ieRYN4aIUr+tOIVtfHsYk92clzxaUb?=
 =?us-ascii?Q?ZWfMBqfCdQCbJZqztscKylMgTPRvkGG9eRl5LEw4gbELaDeK2zCg6L3LDAWq?=
 =?us-ascii?Q?0A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9401F16A2BDA374486655156C25739CD@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: aLp+YsnmSu4Q09nw22I9EK9sv1qhmKo8jFRG3/ojL4If+7jkoXqgScFDaafkn7xwiOtxjpGMCT55pdJAY/BPqZ2r0DlITjTKl4vSKItExjPGKmappoYC4wrfm4B7yKVLgBP1WmeYRjIZqqDPlkrsoTPRBS4TZHmZdMDs2S7FkMigqCLLQwn2bxmADSew8sq3l3GRJLXTlPNsLxtdsbuE+JAZaaCMxyYb/FazbaOoZ050AE4doAAMPIH3+eqFTh/h6XlOaH0CvOByJnlN6PcDfU3g/bRVvWH9f1SvkVK+s+HtbsDHCMu/mosujkM7YF/YFeja+R6CkCoxokV4xjyg5YAOP7pOCMDFQdCFdHTvMQr7awze+M57O/7XUkGYeVoo3MdGTw3OS9NTor5M96gMPNFF32eajX3KAw47e3B+AM3kZVMtCcbBsuxzsbMLwzIZTwecmwFiwP3FWQn/EUeHgceYi+ka0SG6495GW46vllqREq93RygSgCmlkSPakCi6kx3MnU9UwfGTk25wZG5LuWYpGeqilPWjPo8DC9RVRq7J728oiYqnQQ1DaR9DpzLgSLZUP4F3ajwYpqHEZO7sTy24BIllU6AfjrX9X7RPkUXZ4REi6LYdViqcwfkGhz8gG5twWyQ/u4B2ZSH8naLwkNRIWL85UsC0qwi/oWOdqi/iAONUPESFBALuWmcY2ioyv/eIr5IiIszv5f09hubpvMrp1vmmcMQ+zIq/CqPoYNPTYU7xFx+l9aI0XCkudfomxfsW5nkBe284Bbvr6ASSgP3TshQM8oXWWWy3XiGYVprsMJDBIt32C1pBxo4nd3PIPXFZNDjdPrwXdk9edNdYlC32z73Bi3v8OSN5z9Lgc9t026NXieC582t0IiQp/+W8THNM+UBv42kEXEdQgw82pA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8736e73-daa4-49c7-7ced-08db2af30db7
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2023 16:32:39.8293
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2OW5C54appXMA2BP7xFKETaeHSXQ67IKi+ageHMyO82+0f3Up//8p/ljr3ATQcnQqSxrS5z4cLoXOhoJiJjgIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5316
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-22_13,2023-03-22_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 mlxscore=0 mlxlogscore=953 phishscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303150002
 definitions=main-2303220116
X-Proofpoint-ORIG-GUID: F6kV6xIVCwMzHszqGjPSU1O765MpCrvM
X-Proofpoint-GUID: F6kV6xIVCwMzHszqGjPSU1O765MpCrvM
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On Mar 22, 2023, at 9:35 AM, Chuck Lever III <chuck.lever@oracle.com> wro=
te:
>=20
>> On Mar 22, 2023, at 5:03 AM, Paolo Abeni <pabeni@redhat.com> wrote:
>=20
>> plus explicitly triggering some errors path e.g.=20
>>=20
>> hn_pending_max+1 consecutive submit with no accept
>> handshake_cancel after handshake_complete
>> multiple handshake_complete on the same req
>> multiple handshake_cancel on the same req
>=20
> OK. I'm wondering if a user agent needs to be running
> for these, in which case, running Kunit in its stand-
> alone mode (ie, under UML) might not work at all.
>=20
> Just thinking out loud... Kunit after all might not be
> the right tool for this job.

Actually, maybe I can make handshake_genl_notify() a
no-op when running under Kunit. That should enable
tests to run without a user space handler agent.


--
Chuck Lever


