Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FBA26933DC
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 21:56:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbjBKU4P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Feb 2023 15:56:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbjBKU4O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Feb 2023 15:56:14 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43A97126F4
        for <netdev@vger.kernel.org>; Sat, 11 Feb 2023 12:56:12 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31BBshhq011690;
        Sat, 11 Feb 2023 20:56:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=ARGDAOFgd57SADQAoR2zxX8I11QgLOkSBUZGvy3XUGs=;
 b=UOYl/S4AwMxKLxjIybBqCtDNcGH3HfjAH8YPFl6lLC4WoFX9HXuBuPePCcU9lkMq0EM1
 BhwN5ZGJDtXx83XhixcT4ihbcmVDUm66CFzTVjaRk+FZkG58uHuHGJqOQNfNz0MzK2Bk
 gx7oj1zuitI9VsxNLtB1laXVl2/lri7+sfxgaxOII1Ef3g51mPO8ySjoHD0Io1wtPJ6G
 ybqAPdbh3q9RGHbKragAiqK+atE4s/gNn/SpkQCuYl6d8r3HeGr8fqKldYo+wMISemkq
 HVfaspBo7fSXn4Np+Y+2oGIt+0v+4fFDKCtFDuhOXF121QAaUPStH1evWNQmJeO8GBaP xw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3np1xb0q5g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 11 Feb 2023 20:56:02 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31BHO262010916;
        Sat, 11 Feb 2023 20:56:01 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3np1f2p0bh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 11 Feb 2023 20:56:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CKvwVhalufSqEz1Of5n6bbai3j5gDqK1N7drZETKF6Cn1/VeC+NWu1amtrXQv4Uv7XOwQZr/KRqsZnz+5aFP7YHZvZNiLgB8kxNTiGDtTmVbQYhbupfuTflFGb2r48l/SMPCYJ293y8utDcun8FnWxqVz0jvt1sQTPnaq8ab6qY8XPptWqXK5+WmmQWO7RR2YRIdDnBsZy5B1EGrYZyyyiOwOc0vvLyv1bXabPSPwoO7BvhQ+Pfd2t7bQA1ML8lPqPayiNOdZwATbBJ/dxfL2kDc8or0mG0TuE761LzVw4xfzA7FyAkCST40LWR1G52miWiKg0v47v1lnT7EJg5uDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ARGDAOFgd57SADQAoR2zxX8I11QgLOkSBUZGvy3XUGs=;
 b=YAHJHoVhJKqFusb8TN6malqPvbCfnB5dyMRvb+WTeHItfCO1GM0IRnr9G8aHKav8Z9nbI4/DdFT0yVGmshGe06JfT7P/X7jwynAUwIJq8l3eACMOUYG7HAtYebRx66BjLTNJPGtl5/nJyeCnSvonSyiS6KbJyEoFHId0rq1L5MMq3R7qmfKqkAY1JFidKtGwWly99vX+wmFpRPB6ORVPF47+EtJ2jPclTBIo/ZlUIXIfRWrmR2XFCy40dSl3FqCsinLGEMlLzpnYjWkg28I75+KojcJOQLv+KaGtaGsqnP05gdcwtpWeKAw2d2BrunipQkWZcJxE2LjEzjH6xcAABQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ARGDAOFgd57SADQAoR2zxX8I11QgLOkSBUZGvy3XUGs=;
 b=KS1BgO2/OypARJOI2Ve4Gu/5nOR64rkSw+1hRz+5I0tYQD+jwSjG1Ql62IfJyf6tY4cxYvXOk/pfjt3n9LEu2pORDH/LS5gLm+u6C1IYxY9NLeoH6IcVJbUJOjRyKU1c1vdn92FP3aUVAd9qENqhYcJIPLqrAjSKiaHsWg5WklA=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by SA2PR10MB4748.namprd10.prod.outlook.com (2603:10b6:806:112::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.8; Sat, 11 Feb
 2023 20:55:58 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::5c2f:5e81:b6c4:a127]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::5c2f:5e81:b6c4:a127%6]) with mapi id 15.20.6111.008; Sat, 11 Feb 2023
 20:55:58 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "hare@suse.com" <hare@suse.com>,
        David Howells <dhowells@redhat.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Olga Kornievskaia <kolga@netapp.com>,
        "jmeneghi@redhat.com" <jmeneghi@redhat.com>
Subject: Re: [PATCH v3 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
Thread-Topic: [PATCH v3 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
Thread-Index: AQHZPEvN++FMdi3fdkGdZmQw8wcosK7Gwc0AgACuc4CAAMv2gIAAQMSAgAAPc4CAACygAIABhNWA
Date:   Sat, 11 Feb 2023 20:55:58 +0000
Message-ID: <4FBAAB34-1FCA-4DB8-BA3E-7625E4F74973@oracle.com>
References: <167580444939.5328.5412964147692077675.stgit@91.116.238.104.host.secureserver.net>
 <167580607317.5328.2575913180270613320.stgit@91.116.238.104.host.secureserver.net>
 <20230208220025.0c3e6591@kernel.org>
 <5D62859B-76AD-431C-AC93-C42A32EC2B69@oracle.com>
 <20230209180727.0ec328dd@kernel.org>
 <EB241BE0-8829-4719-99EC-2C3E74384FA9@oracle.com>
 <20230210100915.3fde31dd@kernel.org>
 <1B1298B2-C884-48BA-A4E8-BBB95C42786B@oracle.com>
 <20230210134416.0391f272@kernel.org>
In-Reply-To: <20230210134416.0391f272@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.2)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|SA2PR10MB4748:EE_
x-ms-office365-filtering-correlation-id: 6516e508-6a73-4fdf-65c6-08db0c726065
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /9loYimXNZ5TrgNGM/eF1uTaj/w5pdLXKemfMdfNzAoa4vVrAiroejbAqy+WfUQIiIPHuX966SKdHFwYhqzxaQUJAuni15c9Er6sODeHOxB/5zjoNB2kgtZno/RN1UyHjr+pZKYxnAEbLpK6GJ/fhAau8QKv9TOotG9Q/scBhCJ8xnuPB/bAiajN8qZfPBC9d3CoxTORdK82K75Wg2uKOC5CmRV+BPS9tOc1LDE4kOTKEIQDFJE6CnEh9Iqj7/kWxzFQvmdR+Tx980Uf4vT8Fn7q2XrM2SYV4iuDypFnuh+i2+mSP/YMbcH3FWfBf+4q96xI4WluzcHXEkNsvifboz21BVHXURgucRJiUAkyfxrnXV3V0U8Jtfl0wIhCsDD1bNk6aQY0ZkbPU3HcDd++1s+/mH0Qqu3/x2bxUDKW7kkept0vi6KzIRuaiPJ+KzsRRIX3+TTDyvoQPPw1AJxUCWuLRcCTulq9hEsEljgoaJ3dsFMLZGZl0RInivn8ih6BRB3Ni9E/Lj4HAI9c6CnAiey88FKH76G1/cj2XXuOnumEac5Z2QUDOfSXRg4mo0zLquUBcmPwRrl4tvjdCG5OI9Bewb1n55VpzPiYj5U6A6/0EvzwT+g2sJgKGn5Vn06oJJyVwN8YCRVJ2lYxdqS7iaH+kvMQtR3vT+BdyW2uJKZ1I08gEaSga61lCeKQd4sMaZTIsJnYukRVpKv33jLiHI+PiDnwtnhS910nyrS7trBAoezJ9F3U+3glBBYbDfFY6ASJN+XfKbTfjr9PrlxnsoBICME1zDB6Yh56F0rdp8j5wuh7bkNphzl80QaJam5K
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(366004)(346002)(39860400002)(376002)(136003)(451199018)(71200400001)(26005)(186003)(6512007)(6506007)(38070700005)(53546011)(478600001)(6486002)(966005)(2616005)(66574015)(38100700002)(86362001)(122000001)(83380400001)(33656002)(41300700001)(5660300002)(2906002)(66946007)(8936002)(66476007)(8676002)(66446008)(64756008)(66556008)(36756003)(4326008)(6916009)(76116006)(91956017)(316002)(54906003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ag5wB+ZIuDcKCT4x5LH9J6Oby7qfy5qK2zJF0umtu8XK+Shf8+Bg2mJkhISL?=
 =?us-ascii?Q?d6gP2LN8wMAIjECdtWP2eyZN74HohSMjV5zd1DnQuhP7UPNM91khMmdMVV1Z?=
 =?us-ascii?Q?UxPmffQvAEgs6RtkueynQ+RWgE8yn2/4ob1E/zfJQjaPkAT32b2Ud4Klygc9?=
 =?us-ascii?Q?EsXD8yN/djc/7EBf7zp5NhXyG3S6YueJODvPeAICWuiAF2IzmUK8YKOjNy0G?=
 =?us-ascii?Q?CJrgK17zCYU94hgDkyP4eAZyrP5eytKE7U/KBDqDCK1N4+E9UocEU/dto+fF?=
 =?us-ascii?Q?k+xdQ0rK/V2lJc/yrp90Tn2yffRiFj3euzio8jyX3A6E3UTL7HkDzh15qpDS?=
 =?us-ascii?Q?f2+9mUhuew/idHSbjloYdVIR5RVbInaw/nsYTgUHxw714gPTCdRfbcQYlGwr?=
 =?us-ascii?Q?wcP7o57kDasSwfygkEmlcCw37Djxvzr1yXV7ft5+0j7jtNvzMunDCiPS/crV?=
 =?us-ascii?Q?3LNIMZTfOc1ds4in/QG6Y7RNHqav7RG1S0FMQiSpfic+OQrL/KNiQDP2zp0S?=
 =?us-ascii?Q?siVqRjAfgsEOf1LuslKYgtYhjH5C3Ngc2ko2k3mXzHYgfs+3JGkUKvMNJy2T?=
 =?us-ascii?Q?Fr8E0UVnhv3+izXQbWVhNRKbP0ynsmQeXpAQ0CumMAFSA/b9rktkB8aZHhCp?=
 =?us-ascii?Q?YR3koXKwzqk+Fqyj0kIg3IDQnQ804Ct0LTDWRGq5IXR+ZOzzHej/5dmzMmDV?=
 =?us-ascii?Q?ph5aY9jOhMti6me3GAIL/UMPCse/QiFPrmayXtk1n4lbfCsw1sxQZj4PZ2Gq?=
 =?us-ascii?Q?37APLzVhPNimv5VximFlNgNua0Y04zPh1YqzUMFPTPkNZECPvlEfyaGezdcR?=
 =?us-ascii?Q?uO8EXLWaHn6cJfDRRzYs4KxX+u9/XheQs2Pe/HLYTVYFndYVd9Ngb2ld2vGZ?=
 =?us-ascii?Q?sAQBJyD7gOPJdm+6LrRAfMGj16gX+JfXv1q2ayFRLrx2+lZ3YJOiga1PEwPe?=
 =?us-ascii?Q?ntKlanB/2dCCqM8h/Gyh+J5Johpdxroj5Cg+pRHvT27ccoNN9UW1DKlHiUkN?=
 =?us-ascii?Q?gxWWGXsb5dy0xgK2L+GL7v1A27ZyX1QRmQD0RL+ldQx9s0jgIzdIsCYKe4iR?=
 =?us-ascii?Q?E/Uo4meKXA9/I2VC3GsQIzrp+GL981WRZjReITJ2V6QHytC041oGnrESft4C?=
 =?us-ascii?Q?0de5C7Pyf0xMk1h7avaGcPEkgD33yMiJezjM84IhoFKqjOyIrAuDCL6h4w5T?=
 =?us-ascii?Q?A1/18JARm0Rl1DPlb8lm6fXvqqt7rCyd+9sEjfGIQ+FfwqXaPIA2oGBCiIyd?=
 =?us-ascii?Q?9GbVJddafDwG8Md56dqi60VaJrIkwHo0Jw+ajvhQ4dWTCdxixwFy9zhdbh4R?=
 =?us-ascii?Q?+2MbppkQeJOgyQOmnGNdOTIb+FvVSC3ZTxeTRWUWhFLJIH8UJvjn4wlkhieh?=
 =?us-ascii?Q?/CXyZOg3clnBL26vsObMbrGfpa4acjvTN1JHtTmGRNjohR/es2HVTzrvkl9k?=
 =?us-ascii?Q?KrzRTOOc43n+Ie9cpqbwEYLA1GNApkvoy6f5hguZ1IrIvmJnu0WFsbfYAfUI?=
 =?us-ascii?Q?VJX19ugAn2rbsGO6lXkVs6aEY07mDRaQNHRcZNlwAAS382USkSCPTXtQL5Wy?=
 =?us-ascii?Q?dSFF6dsutUhYIj9yR0kvGbHeKLjT0r+8NBqBZ6pQ4UNbjcfyk9u2wo8kGK9F?=
 =?us-ascii?Q?5w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <10716FF6E829FE479693532169FA428D@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: uQSRLozG42SKW6aP52haSgVyUPzGCCsxaVajUpNBFEhZO5TA+KzY6kG9Uj8W3dthtUOa4zFiyY/b7KL88Knec32WkRopBMtlh4N3E3O5cWcru7pCgjXcIBfHyGfyj3qgSKw+I7LZjTYK3GpUJhHZcrUMPonmAUyLTFY0ivICCZ7uRsuK1sKs4cwmvRIqU3B11NWtXUPfdoieihuQ/2u4Q0OlHacSQTqtog7TRkdcuHrP0K27LBSGG4ObttaNoPFlBPtDhVkFCZVK9sRpvEXQ55eOJ83mn40l69KDK2scXlp/dKwsD5J8FKp+88ML4v2n/EBAc6VZxeWp2VJN5YMXGNIFEyPTcOkupNqw520kjsOa/j/fUMDK2QHgcxt/lof1m7Fc5VAvr3/S26KYXAE20ymSh6U//MbMl/NFGpsWIPCYphxhVJRmZszMlUT0zqCKUBcA81jEXUVysLGBsZJuL9wFFHTbZcqY0ZFjaSAE7H120idHGntJV3A8tiGvg62gjnu/2lql3H/rzGQJ+ifvh7r1b1CrV7qI+qDpfMazL9QkSyhlcSYESTISM57W1eqWxcCZt8bWqjLBmWtM2k5DZO2UcybYDJzcb2rK0YORE/Wr87Iw72Ly7eOn6OO2ElqI56lpAK1dbasQXd/setpCzfOzpeX+xufn5cIl9wf0lUOpEUv1V41/LSBlls81dgaJyPL4qJeFLxFjGfMiHwOI7oDFm2ADq62u57aROGvW9GAlNf7w+dwch/waxLgjt1I1XQp9+maGhK0T4AxgZwxSh17Xi6PI/hESpbb8DLETWziNoM8j7gZ8rbdDl4uJbdUijyi3LW9nClwuMVwMyDczjJBDcwPy2HcbnJFKiL1sXhbvuz8RsbkLEi1tMiuGZwUKrWB91/TE0sVxfLlyJc6PTg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6516e508-6a73-4fdf-65c6-08db0c726065
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Feb 2023 20:55:58.5651
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SNaSK+S65Pcg3AkTTF1NdUJVJMvEPBbe0YlcIGgC0xDbXIro/1KlLK7j3XZgZbaVewrWVVGnxOCnFIt4r1ywpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4748
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-11_14,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxscore=0 spamscore=0 mlxlogscore=988 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302110195
X-Proofpoint-ORIG-GUID: nH0a2HZs16vu1c9enrGuPPh7dpkxkU9k
X-Proofpoint-GUID: nH0a2HZs16vu1c9enrGuPPh7dpkxkU9k
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Feb 10, 2023, at 4:44 PM, Jakub Kicinski <kuba@kernel.org> wrote:
>=20
> On Fri, 10 Feb 2023 19:04:34 +0000 Chuck Lever III wrote:
>>>> v2 of the series used generic netlink for the downcall piece.
>>>> I can convert back to using generic netlink for v4 of the
>>>> series. =20
>>>=20
>>> Would you be able to write the spec for it? I'm happy to help with that
>>> as I mentioned. =20
>>=20
>> I'm coming from an RPC background, we usually do start from an
>> XDR protocol specification. So, I'm used to that, and it might
>> give us some new ideas about protocol correctness or
>> simplification.
>=20
> Nice, our thing is completely homegrown and unprofessional.
> Hopefully it won't make you run away.
>=20
>> Point me to a sample spec or maybe a language reference and we
>> can discuss it further.
>=20
> There are only two specs so far in net-next:
>=20
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/=
Documentation/netlink/specs
>=20
> Neither of these is great (fou is a bit legacy, and ethtool is not
> fully expressed), a better example may be this one which is pending=20
> in the bpf-next tree:
>=20
> https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/tree/Doc=
umentation/netlink/specs/netdev.yaml
>=20
> There is a JSON schema spec (which may be useful for checking available
> fields quickly):
>=20
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/=
Documentation/netlink/genetlink.yaml
>=20
> And (uncharacteristically?), docs:
>=20
> https://docs.kernel.org/next/userspace-api/netlink/index.html

Based on this reply I was unsure whether you wanted an English
spec (similar to an Internet Draft) or a machine-readable one.

But now that I look at these, I think I get it: you'd like a
YAML file that can be used with tools to either generate a
parser or maybe do some correctness analysis.

I think others will benefit as more security protocols come
to this party, so it's a good thing to do for extensibility.

I will look into this for v5 definitely and maybe v4. v4
already has significant churn...


>>> Perhaps you have the user space already hand-written
>>> here but in case the mechanism/family gets reused it'd be sad if people
>>> had to hand write bindings for other programming languages. =20
>>=20
>> Yes, the user space implementation is currently hand-written C,
>> but it can easily be converted to machine-generated if you have
>> a favorite tool to do that.
>=20
> I started hacking on a code generator for C in net-next in
> tools/net/ynl/ynl-gen-c.py but it's likely bitrotted already.
> I don't actually have a strong user in C to justify the time
> investment. All the cool kids these days want to use Rust or Go
> (and the less cool C++). For development I use Python
> (tools/net/ynl/cli.py tools/net/ynl/lib/).
>=20
> It should work fairly well for generating the kernel bits=20
> (uAPI header, policy and op tables).

Makes sense.


--
Chuck Lever



