Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3FBA6AACC1
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 22:40:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbjCDVky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Mar 2023 16:40:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbjCDVkx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Mar 2023 16:40:53 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F1C71B303
        for <netdev@vger.kernel.org>; Sat,  4 Mar 2023 13:40:50 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 324KfLeu015035;
        Sat, 4 Mar 2023 21:40:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=kicPzlt00XiMIvLXcVSjwdJQVl25sFm3WkWor9kh8Pc=;
 b=wiv2n4IXDpEPVtX5MEvigoCjeW4kPKpfMGT5lR+dlphvZYbHwNS80axqUCdarXZtdzRi
 VCWRmcKN+hO/BnZPzqRWxRAwK2GldsQKdj19hDxZCvtAHCvFxX2RrJ7TkHS/1Dh9FIEk
 T8U/VZhUWrvun2GZCp8yGJ5zIXfgHpixYcTXxuJcJI0fOayZd7Jks7M4eQI0HItSbkyx
 KObYpxG/Wy/bz6NxZaPWCY9TYRT8Vk3J5fS9OZxXVlhjZ31vPHArphovsiqJVsG93Qql
 hwccGcqG3SnBfx36AjVYysHYu0ZUVaXvBkLjWWLbghs8Lyt1bz6nJUwz6ZIWNS+a18a1 ZQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p415hrqth-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 04 Mar 2023 21:40:36 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 324JOEeZ021289;
        Sat, 4 Mar 2023 21:40:35 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2049.outbound.protection.outlook.com [104.47.56.49])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p3ve3n8mt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 04 Mar 2023 21:40:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K+uEwRl/oDXikfYEgS6ZV0bhei/OXDvf8xBvrDtb6LQ7v0jZn0xGI3/UhhcPKW3hDTzHEwBQJ6bwuxea79tReOGzYWjoLmjFsoWbE5DBgiz8SsvmYmxyWQH/XbTSJKWG5bbycIsztNUSWYtqIYRdTsoNUkjB1HxY+PjtZbgMJ0wb75uRbxqgAWFdFdcnv3ZAkyYnzUFNQcMYCKt1Z5NNc0osbbPGfCryVl7g68hr+CtDCOf61AF6BoFk+X+HvoAP8Owu9eTTqLDneyuBX9c96bZcvG8ITYpS/LdilvnV872oB6LSkNA9yILIajN8kjy4W6WX4MkVKfK/0iMp2hXcww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kicPzlt00XiMIvLXcVSjwdJQVl25sFm3WkWor9kh8Pc=;
 b=RfQU9mqLTVdjesWnwbBrKSIdbQZeBAP6CS4LK1V6SS8fhLTiLDuP8p9xTHa3hNrwo/VLViDiN6ZHb4rEQvsrcn/2M7/o+mrf4pn0udF5obUCyLCm56bbxs4q5bQv5lfQp75P/RIl9EYIoOgsvp5sifZhHFitgt29grlRhHV9m6crW/bRo1yA+M8YgCl+Qo0iLjX3LNsPRJpHFiPWBMAGUNeA2hRoJMdFJNIoyrJPW3/DlitQX2cRteScqYkWW1q9AxSv/sjjyY05ERTgDqoyx3+lTi1ZM08NxGBZ58V4eK21YSejc+eBttEboQ4xm3rOU3KZgUMKRnpLjWTDJxh0lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kicPzlt00XiMIvLXcVSjwdJQVl25sFm3WkWor9kh8Pc=;
 b=NNcXV8z4vvE8yHRfsadOzPoO67Nzy1UNQztTT266GaBvSAMTsMVkzXwpxWwzh+1JwZSEXtPJShWH9i5gg23zX5ACp2mMMnHyYFbDiy9JcnSQIhXA5cnNpHoZdQerIkziZbzg6W0n6VQscgQQBXGRoxZlv2Cf8ulWqgsAw5h6TjU=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by PH7PR10MB6156.namprd10.prod.outlook.com (2603:10b6:510:1f3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.23; Sat, 4 Mar
 2023 21:40:33 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::5c2f:5e81:b6c4:a127]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::5c2f:5e81:b6c4:a127%8]) with mapi id 15.20.6156.025; Sat, 4 Mar 2023
 21:40:32 +0000
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
Thread-Index: AQHZTgEx5sDM5wq7q0GXZWBkY2YJz67p5A6AgAD8h4CAAAVfAIAAGZ8AgAAJGoCAAANvAIAABQOAgAAHUoCAAA9vgA==
Date:   Sat, 4 Mar 2023 21:40:32 +0000
Message-ID: <086255A1-50A5-4183-9180-A5716ABC6520@oracle.com>
References: <167786872946.7199.12490725847535629441.stgit@91.116.238.104.host.secureserver.net>
 <167786949141.7199.15896224944077004509.stgit@91.116.238.104.host.secureserver.net>
 <20230303182131.1d1dd4d8@kernel.org>
 <62D38E0F-DA0C-46F7-85D4-80FD61C55FD3@oracle.com>
 <83CDD55A-703B-4A61-837A-C98F1A28BE17@oracle.com>
 <20230304111616.1b11acea@kernel.org>
 <C236CECE-702B-4410-A509-9D33F51392C2@oracle.com>
 <20230304120108.05dd44c5@kernel.org>
 <0C0B6439-B3D0-46F3-8CD2-6AACD0DDE923@oracle.com>
 <20230304124517.394695e8@kernel.org>
In-Reply-To: <20230304124517.394695e8@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.2)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|PH7PR10MB6156:EE_
x-ms-office365-filtering-correlation-id: 34839aac-1fbb-4e9b-bc55-08db1cf91512
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: o0OOj+M8tGDkJnkHfyApNmP8G0SDoLEusrhlKB0xKeF7AO24qk7x2MaYt3t/Xlo+MaU8lcn8KCHTq0IdQi/eMRnW8RQ4xNnwqBeZR1SssP4aYgHHyt3O/OeQrVcS6f1k/BWi8eKo3IiqQY5br9UmQBRrFodn6EwqZii1fqrEU92QhfXCHpJTg3bjvyQnMSLW0YFaNppiw1MlaV+7mDVIcGX+sV4tRoz50xcvF27weQr/xJUSCkLFSNWSjmFEicwkm449m97NYTN5YTj4EyP7Wft3aTC1uUrq/ewl5n4cuVXIlma/WQLlTVvbvz8MBz6T8zE26VrIUDttAupoQkcPKlHgP0T1OrmnDTmBEy+QiZuyUOXLjm2fzk6GhqcdEx3a1ZMOY81/QwaOxQ/L1g5zZNCVk+Dcrg/P1eVvDcuZ5cjB/9f24vltcpshlJYQEptzIL/20uJt7vwBlvAEA8pbVcKY+/7oxzQjCJnfNkAqoT1WINffG8ENYNMEpFSXKhW6f7pzqgv3NkFxVLWoHjgiSkhuuhj8FSs9yYQx5VnSR4rYASc5Y1zBcgrOvlMCNj8/gTmwutYS7kJqnvCf6NTWemnwnovRiMAUThP7YCc5kARya/I0tUZKE14UyspanBqk2+l90P8NF1h21l2Ro29WCF1wVzvLozkn6r8rfuF9DByWOpe6NLxwWLAj8KYNySpL2PqRbfEN6sAS6aB2TETGp8ffKd2GG99nGhV2f/drClQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(346002)(39860400002)(396003)(366004)(376002)(451199018)(26005)(6512007)(6506007)(53546011)(2906002)(36756003)(38070700005)(71200400001)(478600001)(2616005)(186003)(107886003)(38100700002)(41300700001)(8936002)(6486002)(122000001)(8676002)(64756008)(6916009)(66556008)(66476007)(66446008)(91956017)(4326008)(66946007)(76116006)(5660300002)(33656002)(316002)(54906003)(86362001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?I5E/9MifhzeXGbXbg99i9DNA3CAJzovncPGhpraIohXFvIDl9tora6PoUOdJ?=
 =?us-ascii?Q?+Cyz4DJh4W+OZs1wBTmniBRrxBEnXCVL/PE2C6aohMwZAeQw7cX+TiL3GHuo?=
 =?us-ascii?Q?QnVBaMphIWdhUXdo5I/gC5m8xW0SunolC/mvApfB3JXxQDzTo9ycUmh/fmKn?=
 =?us-ascii?Q?eWtwMxyPzTW8io6Ie69YJHvCRJBMWxx7HNwPDs52VMzIh9qQYg3UKi4AURBL?=
 =?us-ascii?Q?Yv3+TfHkI4yH0fDX9KTwZ9mHxHF0Hg/O3pppkZ9yjVGoUc3OfjF0NKR6GiRV?=
 =?us-ascii?Q?7HdFkyF0/POoHoMOhaAfyDBGBXawWoo+4CXy40Nqv9tdys1qcfa2nrP+u5En?=
 =?us-ascii?Q?ZNWgNol3kV0k5nnrqQ6SXKd8KovOV0T2vz8yL/M0qaijkAmZ6i4OpYIWHfgG?=
 =?us-ascii?Q?OZnINVzUoSrpScVfSr+bnA3kmttTEP9Vdm1iZj8HkIMwn8TgeITpcnjOe6ka?=
 =?us-ascii?Q?h9pOE74FoMJV+AzpwHpQXOQDruZxNtew/RLAzf0mWapMWX12b3osgdPw7B/E?=
 =?us-ascii?Q?xqLaDVSatudmBVO2kU3QY5904YmiNBAWRi+B2Tf4L+KEwTWVK97jU5xYY3xu?=
 =?us-ascii?Q?Bg5ax/q/HvHUv8CvMWoBFYy2HEY2JZr8nmfnbz4uuSIzRjShDkr5Thyvx9iN?=
 =?us-ascii?Q?+7BRjL6roywQ8+5jHisshCgxaGTawzdcN1CHVIhMXmMXMBa842c7+3R1PKT5?=
 =?us-ascii?Q?lWoBeTgw79g8O0YesH9JybjAAVRbIXe9/F+C6ve/snFn3wPLyKUsufZ6/y5t?=
 =?us-ascii?Q?qjzFdeaJKusxZFXGdjAQYGNMmHgsAXlQ3yKrH13gNS5O4dWMmpCrq8yS8K22?=
 =?us-ascii?Q?wEbZ4Aut2j/CqR3+U19m0p7kBS+Str2HCI258ANvoHrbbu24KSgCAtIgU6T4?=
 =?us-ascii?Q?NQrVBhcaC/QI1smEADbLz13gO+m8aZMKIXDxn/2wZNMgUqCpE7W1KO9RJ8by?=
 =?us-ascii?Q?FChgo2vY/mK2ry57B7s2KVqH0SelZSSFJtGDwR5QQpgKRT69AXeTwnyl/dqH?=
 =?us-ascii?Q?umFEbYskC9FmeZVT6vs4NeuD63TWeHVF1pmt6/SuQEz/YbKU3JE1FDyNd8ib?=
 =?us-ascii?Q?qiYtET94gSsGON/UVyRL5d6lu2zA97btanMpdk87jwJ9it7GJmSkg+OR2xLK?=
 =?us-ascii?Q?NtiBvawLvbP6rlqxC9cozbe+xaO64sCN2oxkfllYjxUUjoUu2AJ+pUhaPEPS?=
 =?us-ascii?Q?Ez2MMPEqgSDdfC6Xc8ezN8IPU3wC28LmWhkXe+8kUMyvuuAoSQlF7F8Ge2+4?=
 =?us-ascii?Q?7KRtnPmpuPknX1FaX0AtfF0xrDjc3ZP58VvbYnwqeSLo27yVgztFKhCd+dMR?=
 =?us-ascii?Q?uZCv+9KpsBs62mE6me8Hx8Na8AyN/3UV/B4Z1CWmxVpxdA3m7MVfF+4G7QDA?=
 =?us-ascii?Q?xUzMfHkjqp/xWv8Qb0JrLkGTXecNdMetdMl24lgpo5KyXExS5/IKN55H7Fla?=
 =?us-ascii?Q?83Yeqs+A5cWDC4XmnqCj+wRqAF9vAMeOKVEXUdJqpS+xRSZHeo2fnwEiqC/J?=
 =?us-ascii?Q?jCNVvJpM32rjBVZxGVdivMt5DOPQTowsrbNgqgvs8TzVn4JUMNGQpaT/Lol6?=
 =?us-ascii?Q?ux3zazlY24JO3KH/jRF7pvE2ACU1dPOxaPsWIks2reG01mNRKcj0/hLkw0I/?=
 =?us-ascii?Q?Nw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8E84697B93A20544A2F1F9A1EB82C320@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Xb76qnDMeGdEn6140dz2ypnnUVvj0K89a425F+n6g3Ty1YM17ZM60H87oimZ1i9+SxQXFeABVkMoDnlZGQm/C0Pxet6uuuxZ5EG0RH4YnzMCa51BYt6EHKZWqtYO9aqhj6Y+1PLq/0UKt+kq0sy5v/r06nOP55moij+Jllzaws5C+rnQzrUE/Qa8QQVq8DxDlrZAUKRMUfVVOtuzXo8FoXdEg/xME4WKqnknRJsgt4CvDW9M3d5nVLsU3/kcuUTfitZXzHW71DJf97x8Nzusn4GdtIUiOUHOE33MMKl6GJ7e6CAywM2XqbL9fcWd0B34b+dCuUHjKWzqABs+zTDMKpfe37J1WP8NnEGG9kOc+Hjqnncr0pKJ/KcaRuf6mh1gj30jaZooZEDjqaFiTrKQYH/HE29Dx1tnbGfTpS1icsWYxCcaRYx9aivsNCBtgYPHhbOa+lu+eZoFAMFhD7brI/0whK/cAXKJeK6n2m1iWMHInQoya5lJqwmCBPxqndKqgYmqzjAacGypVNtDjaQ05wlD31ZJPwqYKZIypIk0qHmniNiKxeUnDH/t2nlYbfJHfHWXuCkXZf7hS1duRbs/XcZP3iU8fMe+ADTGVRxj/xnOLZ0vee1iWlTy8wQ8CIxQEPMQnKMhSKFJw2GyZhFgGsDvPfW5ccJq/qdFYxji4il6bxDAJYkG1yBxySwJ3cJJOHQf8E3yYSODqkwwy34YSmA0gcSEwhdEUwzQK+jB9pnmA9Ak7W2YhFOIXFseyrTnvU2EDsVwI8x8CAfXOQHK+7CbYQ0LDFE2yXZRr5NYHBljc04Z3OmslCjKN12qTDTEg9BskHVP/CD+/OHEC8F88u8HZvpYgfCKukizSu/uZu9vo+47xkZxiQlR8OIhjTdpLqhnUCUfmCvhPG4EyUSNDA==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34839aac-1fbb-4e9b-bc55-08db1cf91512
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2023 21:40:32.8416
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pTJnVHs4LqoPKRbbsni1f4ubPGMsFBSEHUQEaetzQQDUe5JikRXENkbkm4/9NPxw6dbVGeuXvNI6p77u4FtIKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6156
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-04_14,2023-03-03_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 adultscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303040189
X-Proofpoint-GUID: V3IZYmCDzsnpC54d2nBQiQmhsJW-ArD5
X-Proofpoint-ORIG-GUID: V3IZYmCDzsnpC54d2nBQiQmhsJW-ArD5
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 4, 2023, at 3:45 PM, Jakub Kicinski <kuba@kernel.org> wrote:
>=20
> On Sat, 4 Mar 2023 20:19:06 +0000 Chuck Lever III wrote:
>>>> Sorry to make trouble -- hopefully this discussion is also
>>>> keeping you out of trouble too. =20
>>>=20
>>> I was hoping choice of BSD would keep me out of trouble :)
>>> My second choice was to make them public domain.. but lawyers should
>>> like BSD-3-clause more because of the warranty statement. =20
>>=20
>> The issue is that the GPL forces our hand. Derived code
>> is under GPL if the spec is under GPL. The 3 existing
>> specs in Documentation/netlink/specs are unlabeled, and
>> therefore I think would be subsumed under the blanket
>> license that other kernel source falls under.
>=20
> Understood.
>=20
>> I don't think you can simply choose a license for
>> the derived code. The only way to fix this so that the
>> generated code is under BSD-3-clause is to explicitly
>> re-license the specs under Documentation/netlink/specs/
>> as BSD-3-clause. (which is as easy as asking the authors
>> for permission to do that - I assume this stuff is new
>> enough that it won't be difficult to track them down).
>=20
> Fair point. I'll relicense, they are all written by me.
> The two other people who touched them should be easy to
> get hold of.
>=20
>> Again, it would be convenient for contributors in this
>> area to specify the spec and code license in the YAML
>> spec. Anyone can contribute under BSD-3-clause or GPL,
>> but the code and spec licenses have to match, IMO.
>=20
> Yes, I'll clean the existing specs up. The only outstanding
> question AFAICT is whether we really need the GPL

I don't believe GPL to be a general contribution
requirement.

My bugaboo is that these are currently unlabeled and
potentially inconsistent with existing license
requirements. All fixable.


> or you can=20
> get an exception for yourself and use BSD?

Yes, I will ask if handshake.yaml may be contributed
under BSD. They might suggest dual license.


> I care more about the downstream users than kernel devs on this,
> I'd really prefer for the users not to have to worry about=20
> licensing. There may be a codegen for some funky new language=20
> which requires a specific license which may not be compatible
> with GPL.

Sure. IMO it starts with the licensing of the specs. Fix
that and you should be good.


> For normal C this is covered by the "uAPI note" but I doubt
> that will cover generated code. And frankly would prefer not=20
> to have to ask :( So let's try BSD?
>=20
> FWIW I always thought that companies which have an explicit
> "can contribute to the kernel in GPL" policy do it because
> one needs an exception _for_GPL_, not for the kernel.
> Logically the answer to BSD-3-Clause to be "oh, yea, we=20
> don't care"... I said "logically", you can make the obvious
> joke yourself :)
>=20
>> I can start with the LF first to see if we actually have
>> a problem.

--
Chuck Lever


