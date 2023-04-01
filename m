Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4ABA6D331A
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 20:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbjDASYl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 14:24:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjDASYk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 14:24:40 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3062CE39A;
        Sat,  1 Apr 2023 11:24:39 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3313StnH005605;
        Sat, 1 Apr 2023 18:24:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=li5pUQem358kW8Zddp3kx9IenPOftQVZwdw0ctM8Yqg=;
 b=YrB5ofHb9i76DxG9LtgJjGAMreDOC8Pb2rNRmUCdQUPRkj3yz37qv7P5FOTm6dnDaXTV
 DQf2ki2n+TQsLh40q3IkxmbBn7mWC/5D3zX1fhvjSCjTTP3FinEcGFb1ljGqVdZptDel
 D/i8FjVdUTHXezbtvPv8PoilxdlRQC2Z64EL/YtadsEU4v4iXosg53IzX8n5z2iKf6os
 fxrEK/rU5oq323idqV3G59wHah2xs7caJciu1Jm/QVrOH+nf9BB4Ue2WlKK5dVVvhV9H
 h01w/iNwECJ+rhZ+ws0irJg2lyhyoCLXNVtVEJrQamtVoS2Na8LLlvkX4WT4Rq8DPzAH wQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ppcncrrgc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 01 Apr 2023 18:24:15 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 331ILlHo005054;
        Sat, 1 Apr 2023 18:24:14 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ppstr82va-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 01 Apr 2023 18:24:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g40WdEd5gQFxf/QsLRgVislP7tl+GqaN2gGjj7SlBkJKEUawJZJtCDiRRIFm7V5lFGLVCBzL7cp4M2E6eDbi2oIdJ0+WSSESK0/+Au59XZ2DXgkIFL5SA6NpIH1LZPwF4CDvPubvGnIAaz7CMDWUMgWQVeE6UTE/yZyGu8toHK2UZxiFsP6D0vUoqbE+wV/7yTTqoSIoHsSVNKBaCA6+DaDgdzITLSaKTw9aZqjKTqDYp2WptE65o906U58wEFv/6fnt8yyBuvwg2i+5jyvaBVP55O8YjY8kvfXYKyhzujM6QPL0VWOClnsnaiE8agePUvVl/nMKrPa8wSfs08f6Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=li5pUQem358kW8Zddp3kx9IenPOftQVZwdw0ctM8Yqg=;
 b=L2HOAr3oINHmFpqv7WclQng3+xGgKKdx88/WJXOMQofvceP30OmeT6p241wOFhr5NIUeZ8gTrA71AC8MowxQREf94XJsUade9XISjI2Oj6HIhHhCYd8AjNKaz+trEllJ4Ivxukxi17oM0aR56kybf8IEoJgi/7jMJmyVJs64YC5Lk1lSPG/pH0tbEADqSpSjXxWisp9iqLXBh5kR2OlaHGPG+mRW/l2FbM7GUZnR0F4+io55XDen8JeBw7R6UBB+dAi8WVTgWVdoMre6BOAiXdhdlxUhLHo1XnlGfY0rpSr354mrwL+uJd5AOSDfPBzcS0lO4s9lePejH319U4Ul4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=li5pUQem358kW8Zddp3kx9IenPOftQVZwdw0ctM8Yqg=;
 b=LysuTQZcpShYpjuH74VSB8W9peRpk+CzP3wT8Bkf/EG2f2lQ32JjsydH6XpshRuqfUuhEHba3F/USQxX2QgAZ2yfQaoX9fQRxcfz7XxWgYcIOnIV2XmARHVHbQIduikLktIYDJ6lK01nRjS+QnmyAoC2mT+L+cP+X5mhfB9rUWU=
Received: from BY5PR10MB4129.namprd10.prod.outlook.com (2603:10b6:a03:210::21)
 by SA1PR10MB6663.namprd10.prod.outlook.com (2603:10b6:806:2ba::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.24; Sat, 1 Apr
 2023 18:24:12 +0000
Received: from BY5PR10MB4129.namprd10.prod.outlook.com
 ([fe80::311:f22:99b6:7db7]) by BY5PR10MB4129.namprd10.prod.outlook.com
 ([fe80::311:f22:99b6:7db7%3]) with mapi id 15.20.6254.028; Sat, 1 Apr 2023
 18:24:12 +0000
From:   Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "zbr@ioremap.net" <zbr@ioremap.net>,
        "brauner@kernel.org" <brauner@kernel.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "socketcan@hartkopp.net" <socketcan@hartkopp.net>,
        "petrm@nvidia.com" <petrm@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v4 1/6] netlink: Reverse the patch which removed filtering
Thread-Topic: [PATCH v4 1/6] netlink: Reverse the patch which removed
 filtering
Thread-Index: AQHZZCxJt7hHR9OT2UmzMPODBe2VMK8V1x8AgADu1gA=
Date:   Sat, 1 Apr 2023 18:24:11 +0000
Message-ID: <88FD5EFE-6946-42C4-881B-329C3FE01D26@oracle.com>
References: <20230331235528.1106675-1-anjali.k.kulkarni@oracle.com>
 <20230331235528.1106675-2-anjali.k.kulkarni@oracle.com>
 <20230331210920.399e3483@kernel.org>
In-Reply-To: <20230331210920.399e3483@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4129:EE_|SA1PR10MB6663:EE_
x-ms-office365-filtering-correlation-id: 64c096d2-705c-4c2e-214d-08db32de4a80
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VeeC8W7v27yrwwIy/sOX9Que91fvcx/du2hW0q4jVvBmpUtfjkAr+gOGAfpqgfLdDc3Yy3FJhQqHc7qNhotoU8BskrdjPMyTvOxPiBuFbiLQLWf4yQmhQBiTbmWu779XQsjJ4UUaMgIhyJft81gVzmH9IgtgxUvX95QYxozmL0ZofhP5w4oHTWYDiMGiIxT0fzl0zPQwKZcxQ8tEo45PV/Gbtnwl6HQXBy2X+M5OALd+b11DZW6LljwCX22R6iin+MIfrEV2n0ZabImIKiXIXjClgjn2165y627moNcrNwZYTPHCHbJ87MmrRDqBhCk/npbXeeqqym1MhXVvWzwGBLykG6GeyMIhaGwmiwaJXxySF3v6hifjoCmf3XC+g73CPMBcmH7sGzO6JAABheUNSMGW8QZOpNj9pKmmEiB3ubkOJEZ1vi19Uty9+Z/g7C9WdtapGqMgyGRAz5W4ibwdyRB3UvMw1enxPFP3RlV9bzmY8SAl7lDglX4nguOKRrCCghS25Hges6fvxahvW1mpyWenDzEyVZmU0gvO+CsujboIyEr6tOljvohJw1oHKeld14kMhho0JCCxbKPaaiqAB3HvinQfl6MjTqmyHivXhZYLzia1i9VUcpgefs8u+NOrGQiOm8QifjA0VxAiIEwRAA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4129.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(376002)(366004)(136003)(346002)(396003)(451199021)(6486002)(71200400001)(2616005)(86362001)(33656002)(186003)(36756003)(6506007)(53546011)(6512007)(4326008)(66446008)(316002)(66946007)(66476007)(64756008)(66556008)(76116006)(6916009)(8676002)(4744005)(38100700002)(2906002)(5660300002)(478600001)(7416002)(122000001)(8936002)(54906003)(41300700001)(38070700005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?iygBvD30/YGiU4WQYsU66HExqa7Iot9kAcCmb1krEox/h8hPHiW7fYWGFceF?=
 =?us-ascii?Q?y1AxKDoBnrokgrp+9siOG9VKHc+qH8V3g7cTmvujRMUr4zfLWB638v0QYfbu?=
 =?us-ascii?Q?vSwp2NI8I66bBO9k4kcZDnb+pTWiXj5QunRiELhPThJkTCSkRxjUO+gKjXoZ?=
 =?us-ascii?Q?jY5yAHTvQ6kvh9KAanI0jEY/iT7++r6tXQif+IxV/YAtAVxZPcWluiIW0a+e?=
 =?us-ascii?Q?exDoVc15WpdrR6pSYOMZkPSUHHWRuqPr6pXeCHW3i8347oUZo8nYb2HzCfiF?=
 =?us-ascii?Q?xMHMh/Vh26L2Ho+moLbqKNj4+0de7TP+L9wSB/tjI/5VFMoNCsgrZGKzNWXe?=
 =?us-ascii?Q?hsQlMq3JSWxmFTTuJlE7qqPhXQ1gweYW4qf4DFI5PdChCLVrRQcGN4EQ7GA/?=
 =?us-ascii?Q?urtIa8/2KZ9ebmufVRq/QoTVznNIJvywJ0FfSbQYz4cIL7CzAsafJ6kKe3sB?=
 =?us-ascii?Q?pF5GB6v5UaymQ6CvQZjTVNDDbSu41HM7C2hKtVGFNrky8YhUTXquelxQKVRQ?=
 =?us-ascii?Q?DLBD1PPsNUruz/B49dccIIuHfVnjwNSfy+7c2wf/8d1bCEUqDQoZG5RBqAVV?=
 =?us-ascii?Q?Tb0TnAFJpy4Q+z0kZFR/NmYdpzep1HI56EDp6AOYt6kbJEV7hpVHclz+W3le?=
 =?us-ascii?Q?AmrmE7eeWJDFpButPPdNT8rB8pkQS8k4nfaLda1RdVLFpbwfCetGdNfIb0gO?=
 =?us-ascii?Q?GfpBhq3b+UFLmx3FHka3zGeMnFIHJDe0yCHFJQ3ypi1uoweeU6H+vX+rgUrw?=
 =?us-ascii?Q?UULBdQhgSQjZPqwz6wyt9RG4kNx11u3raK/qDuxHrI04iBSvJzMpu79gJiFw?=
 =?us-ascii?Q?zFCgP0lnVMkarPa7mIkgOoqL2FjGYGNXfNVJJit2c+Tt0G7LfyegLLLTNoz6?=
 =?us-ascii?Q?mL8GMYR7S2wskY+H2Z6XMlkpNPZe6VPgVP4CaCYVmEqDFFBzqlzq4l2m5DvX?=
 =?us-ascii?Q?Mzn3a6b7pFfKgSiMJkyRWdA6qJw3aMO3X/dabS0D1rGRBzi3nftEZtC7Xg7i?=
 =?us-ascii?Q?/QmHU8oLp9a9MSC25ihBS7SODp9WSuAwHDx/hxCZTA3k/Kn/BjwEZcZOsAbc?=
 =?us-ascii?Q?h7J/dYNyxdJofe5GmwGRPFi7EJHjHi1VSLVcWyn4vaH9bmwwkSua1Skl6Z6b?=
 =?us-ascii?Q?MWSmI7rWhw8nt4mw+obKljt+4qO2dqfPPK5B9w5VuQTt9brj5FrupVAivhRo?=
 =?us-ascii?Q?9JkOd90JqczaII5xM4vjXIK1DcOicGoRU+d975d+XCwjPzp7ViXdS+xz2HRm?=
 =?us-ascii?Q?cI5zHCSPzftSOJsYF7rvYjRime5jnTKFpo7UpqC+2GIS2QZnTM03Dt+C0DJ4?=
 =?us-ascii?Q?u7vAvdy/tRGwUK3FyCYtM95+mw7QElYbrot8kwIyN26RpNAG0l41s8ejp4Wn?=
 =?us-ascii?Q?/dNXKPcps7HZ/Q5cxOy3llnjFwucMKM2t4zaxVw49QG67vexv8l9FIuV6gxc?=
 =?us-ascii?Q?vGC/gtXP+AFXUMJ4d6GamILilVgRI45bsPWOlwf40fl2eI9rTgPgP1m/Ndoe?=
 =?us-ascii?Q?DhfDK4ayd3airiAJ1vL5tMSGAPa/vtEjgktcjT9cPeEJAOmxKTEMSulCBUxy?=
 =?us-ascii?Q?uf5PTNzLmlPAlI6fMlM6V/CKarM/gS9SqawRjb2DFZEjUBimPpiSFQj5ULCr?=
 =?us-ascii?Q?a12BIVBcZz0l5voB2edgETZAWN0Tx/o3egB1yCxk0IBi?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3D2137406CD7134BB57D0CFB26C67053@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?f4ML0JNO8ca+M6P9+C1uC0F6qXsjcxEONx5khNYARAAwKoRoVGMWao78yK7v?=
 =?us-ascii?Q?6pxwE8aD1x6H+diJXHsyOmxqZkOqiSPaeykZLahBwXKDI3eI8QRGTSOQ/id8?=
 =?us-ascii?Q?4X+F3HCSmgWimUJi7c+jorTS/Rdz08qfnuYL+X+h3n+WVgDVe2VWEZGa8kEl?=
 =?us-ascii?Q?i3PkqgkXA8WIpu+4OQNsUV+qxYf0iWpgOWwZzXaVwbwA1s2Nli13Oj9kwwbF?=
 =?us-ascii?Q?vJUkVwmSOlqe9vH0WWuVr6tLAsk/xXEs38wl8ciI7u+XfxPVP0oINkB4YU8q?=
 =?us-ascii?Q?x6xiYpwoFWFUaQGSmAshjFsGNnBCA6INAtmHelpzb/7kt8MZ4P17KaL6f+k1?=
 =?us-ascii?Q?UX1VFADybO3/4ubvH3EHpjOGN5D6/KfHLaxOO0a553kdl4p1KwkI2uJAZ2S+?=
 =?us-ascii?Q?0cxJM6jpTk5VcAT00+sK8++Jj9XeK/7zJyHZxW7yzSQlR43Eh5sGcBS1n6C4?=
 =?us-ascii?Q?5ECgyKPApnDe8X6pP8gjjBuBHrN7M2EWtY+WRBG35URN3h6hs/a9mrHJYned?=
 =?us-ascii?Q?EszfDOQ5QPw+LdDNO0/IW40Yhq5ZZ1pOANw365gbDVMQYJqdzTcRjbfk6K9R?=
 =?us-ascii?Q?ry+K+qasBHwX00XL94TyP7y8O/9d0ZE0vFZHe9cL4k1F5cd/aQT0Xt47F8J2?=
 =?us-ascii?Q?ewVQ+NYMXnddcf4PZJU74KPk9PmGBqTqYtDCGxpV2OJDulQYnZqVUFfrVnqJ?=
 =?us-ascii?Q?rOOilNwnfrVPNtP7K2V1fJ4JwNeV8eE8BbW/GhYskJh6MtIrAW3SWcPE/PGK?=
 =?us-ascii?Q?M6UMbEbNd4MpRCaHCRmMHuMGrzT+F3oDiqMCoiv1movQ89vkUMTg7jKWfL18?=
 =?us-ascii?Q?FnQVwH2Q4R2Yaue+SoYnyP9BW6FarNF8+3+SHlpro2vadn6QpJea7LS8Hynp?=
 =?us-ascii?Q?3TAcIVeAgPnRToK4GtdeU9EyqN/pRWml/LvYebhOJBTyX/lxIkBR7yHQ/Jfu?=
 =?us-ascii?Q?JtwensklfDV7Nk6cxb9TAUV6DBlQnBbBias0Zxqsjktw7I71e4GdsSzD+EKC?=
 =?us-ascii?Q?TcvyBxbL8FX3XLtwoPNj7wHyXjc7hp0EPJeOHTFbiXxUMa9QkBVjkww1FOWc?=
 =?us-ascii?Q?ZKQu3SNIiJDUmOwKvv4VIl+09JNPDQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4129.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64c096d2-705c-4c2e-214d-08db32de4a80
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Apr 2023 18:24:11.6649
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NOnPnB9GAL9uRkOSX/NHpLFWO+Ff2sGx2PHbUt6taHtagZ92Cwz7m0c5jFd+w4ppGCp/Bn+0EjyXx6/pu27Igufm7NEdw0RmfMWQhV4Pbfo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6663
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-31_07,2023-03-31_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=974 spamscore=0
 adultscore=0 malwarescore=0 bulkscore=0 suspectscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304010167
X-Proofpoint-GUID: JOCSOr1R8QMzh_0q3LUDu1_CpUHijqq7
X-Proofpoint-ORIG-GUID: JOCSOr1R8QMzh_0q3LUDu1_CpUHijqq7
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 31, 2023, at 9:09 PM, Jakub Kicinski <kuba@kernel.org> wrote:
>=20
> On Fri, 31 Mar 2023 16:55:23 -0700 Anjali Kulkarni wrote:
>> +int netlink_broadcast_filtered(struct sock *ssk, struct sk_buff *skb,
>> +			       __u32 portid, __u32 group, gfp_t allocation,
>> +			       int (*filter)(struct sock *dsk,
>> +					     struct sk_buff *skb, void *data),
>> +			       void *filter_data);
>=20
>> -int netlink_broadcast(struct sock *ssk, struct sk_buff *skb, u32 portid=
,
>> -		      u32 group, gfp_t allocation)
>> +int netlink_broadcast_filtered(struct sock *ssk, struct sk_buff *skb,
>> +			       u32 portid,
>> +			       u32 group, gfp_t allocation,
>> +			       int (*filter)(struct sock *dsk,
>> +					     struct sk_buff *skb, void *data),
>> +			       void *filter_data)
>=20
> nit: slight divergence between __u32 and u32 types, something to clean
> up if you post v5
Thanks so much! Will do. Any comments on the connector patches?
Anjali

