Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D049319545
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 22:40:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbhBKVkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 16:40:15 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:64632 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229501AbhBKVkK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 16:40:10 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11BLX3qD029263;
        Thu, 11 Feb 2021 13:39:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=vVvKrSNFYQahQuq1mERyoCf+pEMNJPcM0NOsCYMJt4Q=;
 b=NxMRp9UnWa4Kgec3aSRkRBfJsBaBdQaxtX75zr80FCG9eA9wLxyDUD+2JNEZNac0RJ6t
 cKBRehLiqbHofhSIM/o5ZnKdOARyDlTGwZqagJeaAET6pegDB+h3mZpGyuA0cpx6D4LD
 EfPI19IwJ0PuWTwsieRsZiDlnjwutsZ9NXZbmX5BPnVWKbfGTO8yRuW+wYNQB4DbNFim
 9aBoZ5ooCoyluVRCs7AXMjCM8spGZ07nbMqVzVsm6aFIMKdvyw1FtSN5kKELSVQbbn48
 7RVQkg+19EJDSoumDDhbucHwIRKxnP5q9BZQazp46Zf3gJMhzki1aBuF2P1LLm0oK5lw 0A== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 36hugqge5h-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 11 Feb 2021 13:39:22 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Feb
 2021 13:37:39 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Feb
 2021 13:37:39 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 11 Feb 2021 13:37:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L1MtMn+Hjp8PtJ0d7WeJcCgfSWcnRglt5kgjlE/axUO/fn3Ra4jXZfh51pmAcgRdcc7VKDKq1hOQihzRZm+fgUcQLrdXQ0flBj9h92rEz2zKjsvRIMfsRMrnHVgTQs3hWs1wb8Nxa4CxPe9jLmPFnXNT7zJQF6am7KOtDTNfsRmjWwYVn2T4eg52wGO76Xb7/WRyDwRn9ZrCNYn7aZpszzEn3oMqFg/IZqwlcElaSBG7OKVqwMKNz9MpH1SfHJt1yi8o/jhi/LqqaGwW2Gb3Tr3WZISGj9ESUfocCKTzfX11rTWxWzzK2C57gbSAI1bD3Wdh2xlQY8dFBnlK1lwg6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vVvKrSNFYQahQuq1mERyoCf+pEMNJPcM0NOsCYMJt4Q=;
 b=ZimLGKeUxOMxx0ERNXXY1JO8vaQlhmP4ob0FuqOM2GYg5EYMw/4JanSb6OBliq3sShG5xFbXWzah+iy1UkTxagCK3ytxMvbu12rBoaMM9T8U9OJ6XW7ox73KO6YdSYP+au47pLACZ4+hEGuM88Lu/lCnHiHvFvkgAEKeyusJv0WsWiuTUf3VXIkxnBn/dMJdc7wJZtYgzTvm/4lBuvxesPoMxldHy/ncUf6fMfOJkQLh46hEIZDQPDLf+maTKXeY+jZs8mwGOZ0NdrZ4Vzf7TQhi7LDIAj9txoeSeHYISPEnBlaFgtTvucnEvjt0IyKPmOuqwUqXb8/hllnOSos48A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vVvKrSNFYQahQuq1mERyoCf+pEMNJPcM0NOsCYMJt4Q=;
 b=lTUeqBqloXMeezyosibcxfIRB6cR7cYpUwnLpJKoayxNO7Qx+4Ax4mlbJojlaHn5Mx9rb3pVVxRZFSOKWGu2hKuAO019AZDn+ofN5bFRO6UM1O5kKHF2cWoWBlFxVB7a8BrPuj7i4HaDG74XbvVf3EoCrx49PGoFAvaMbb+Ke78=
Received: from CY4PR1801MB1816.namprd18.prod.outlook.com
 (2603:10b6:910:7f::33) by CY4PR18MB1096.namprd18.prod.outlook.com
 (2603:10b6:903:a8::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.25; Thu, 11 Feb
 2021 17:39:35 +0000
Received: from CY4PR1801MB1816.namprd18.prod.outlook.com
 ([fe80::a9f1:4957:cb7c:96bb]) by CY4PR1801MB1816.namprd18.prod.outlook.com
 ([fe80::a9f1:4957:cb7c:96bb%7]) with mapi id 15.20.3805.028; Thu, 11 Feb 2021
 17:39:35 +0000
From:   Igor Russkikh <irusskikh@marvell.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: RE: [EXT] Re: [PATCH v2 net-next 1/2] samples: pktgen: allow to
 specify delay parameter via new opt
Thread-Topic: [EXT] Re: [PATCH v2 net-next 1/2] samples: pktgen: allow to
 specify delay parameter via new opt
Thread-Index: AQHXAI597SuD7sUZM0qZ2lDgaxA8YqpTMPSAgAAGvIA=
Date:   Thu, 11 Feb 2021 17:39:35 +0000
Message-ID: <CY4PR1801MB1816E10B20760B287BF27DC8B78C9@CY4PR1801MB1816.namprd18.prod.outlook.com>
References: <20210211155626.25213-1-irusskikh@marvell.com>
        <20210211155626.25213-2-irusskikh@marvell.com>
 <20210211181211.5c2d61b0@carbon>
In-Reply-To: <20210211181211.5c2d61b0@carbon>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [46.223.163.243]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 78afe5c3-ce60-4af8-fe87-08d8ceb3ff50
x-ms-traffictypediagnostic: CY4PR18MB1096:
x-microsoft-antispam-prvs: <CY4PR18MB10964415451622C044778C62B78C9@CY4PR18MB1096.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pZlFE6pKqGj0r0n5ZSJl9iL0RzEVd84uQGTkn8emKtaOu/77RlIVfxmT7RW4CpcOcvEqXkpwbN3v5p6Q8JXq77a9pP5oS5hOUcD1s134w7T0rd7kKTeZphhLl0zeH9kFcjZXdCCDRUBm4z4M71re8cfkSod3MkNqdnebDsAvh27ReYQFRC4BR5Pb0Gj+Y/tNuw5k+BKNRquuf3n3WeOZXdKFZILDx2Ck+DyRyE4avP4oTEpn5ZaxQ1TfqbMVMfOAX5jWZj7ZgQJNm7++OQeW/W4CNUKwR9oowwK6SSLAl0Lb6ECBp3KUBd8HuZOGMTvHEzvNF3qfT4lAQRLgzRi7VcMr/zcGmcKS660Br+wS8iJRGW+eWtRdtnuxiO7fKsvv4VczWc+mFYm7TiBBSv55x/4zHq6DMLtk4L5qObNyiXJzzHX9+Nhi2ZGs9gxrKPfMLuKTiTcztzES+Q6E/0MyqRmbbLGYQr9JvRfxhTH+FyCNhK1JoVEnOh6GjUYeNQ1CWpr0u8j5EA4+xWnhjA+wgQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1801MB1816.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(366004)(396003)(346002)(136003)(6916009)(54906003)(316002)(66476007)(66946007)(9686003)(33656002)(2906002)(55016002)(478600001)(5660300002)(64756008)(186003)(66446008)(52536014)(71200400001)(66556008)(26005)(76116006)(8676002)(4326008)(86362001)(4744005)(7696005)(6506007)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?NGmPSN2H5C8KkgF7JWwnYkebssyPMaPkGdBrFYnLyiFu61PH6fDs/kAxYJic?=
 =?us-ascii?Q?mYfZ5SfL/UzRBFylAfpHDim0FkTP4+jGphvvHTw2zlm1b24migJqCCesdxuo?=
 =?us-ascii?Q?OEFYMYc9IXQvlMTkgejyZYPKD4zMN4BnWewVhg0T+QFUbJdUcBXdwGFiYfVJ?=
 =?us-ascii?Q?ou/7/MbdiT7HHuneMvuQJamqoF++uYAzjk8t51qw8lPoC8z/JDh1ChmdU2g0?=
 =?us-ascii?Q?BljHkBbg7aV4fr7T7Np2ZiMeUycBm39kygtgl9zYAJUKdW93edXQjOq1ZBiS?=
 =?us-ascii?Q?f2p+VyH6gvdnxNDNmO8yg6IjvHexjMictgn4EsRqCnNXsWho8ANY4q4KQM9u?=
 =?us-ascii?Q?AcBt2DbM/Bkrml/SXuqLno6+RmgBCs77xS2QAjZSW0qkhj/EoS0jKsRsGbhS?=
 =?us-ascii?Q?AScnCLSltRg1CbhTqBTnNdyfP/8iZg9FzAC9XyXFLwETPZUpYCQjAi22CzWz?=
 =?us-ascii?Q?U8kH9wjtqJI5MKDI89FjA2cXFmpwpCSwuaJLNZImsD35vbnvCiTwMnLLe8b8?=
 =?us-ascii?Q?yeUiYCiUYSvB3/Hdm/1YrijYT9MGZqPW73h9ZfcoLom9juSk7MkQSrf9XCi/?=
 =?us-ascii?Q?d5AHaIojEVqhvzmkcgyKYHiJadItto1CMdh04rq/dyG+HtWh7v92/nxhSHRs?=
 =?us-ascii?Q?hVAdi4snFxToeAQ9KmL/mJE4IKFzxJ6E+ZAe9KMR/XwRUF50UbQCTkIj3Te8?=
 =?us-ascii?Q?H5zX4agWySKskEMNC0ibLf6aPMbMWfHBk1IhZ1fCJpSP1ZOn3ENknUMYxd7T?=
 =?us-ascii?Q?DbAn0AllrM1kHEJkoaQvem/TDr8QhvKjOhIwtOHD9mZe5X6R8Z371pM8z4R9?=
 =?us-ascii?Q?Cq23f9LRFg4WMbeJOSeZuDp8ZtY6q6xs9RuR1PbVqo8iT4MYqVNqbINJZ09g?=
 =?us-ascii?Q?MxstIdfTWRzxd7CbU7BIThVZERbutHEKcqRl2xmeMRbnxhMMnm+oXQtMUeiY?=
 =?us-ascii?Q?H2ksbycTzJFAYyRnPjTvnIJMfUPkbFRwMKuwd2v/9/u0Vq69DX++0/KZhvQF?=
 =?us-ascii?Q?B96KnqXPX0ZmtZB3ob/tZeyzecMF70vJr4WAxIS9XaJZ/q5+h4W/F8bCaUTJ?=
 =?us-ascii?Q?oZTZD5vD8vJUITEDhkLONRxT0uSPInge+p/nzl8LGKsDAhpTwntG3oeaOrvm?=
 =?us-ascii?Q?H6Re28r6zq5L45k2waFD0NFJE6AfNTOUgxd5SqmkGUfxnfsUVTwJy8Fwjt8F?=
 =?us-ascii?Q?yrIU8hXI8Cox1m55fQ03kFGMwz9N8OIwtiF/mehHzAdknw2X1pgFXsGfNAfi?=
 =?us-ascii?Q?zcwnj1ZthAUyV49zFV9aSAJJ31Tgeeldrpt2ybNGFetUjrw1+UDTjytIDqpG?=
 =?us-ascii?Q?aKoP3X91yxl4u1wIpqe64Lsw?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1801MB1816.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78afe5c3-ce60-4af8-fe87-08d8ceb3ff50
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Feb 2021 17:39:35.0301
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UUu2oZviXPzGfXk9DEoj1q7woQPL9Cxh0YSK7XdLvV6Czw9OuoqCzvJEdIN2cZKjqR2uFRxllinLFYwtnia6jg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR18MB1096
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-11_07:2021-02-11,2021-02-11 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> +    echo "  -w : (\$DELAY)     Tx Delay value (us)"
>This is not in "us" it is in "ns" (nanosec). (Like I pointed out last time=
...)

Ah, sorry lost that. Will fix.

One extra thing I wanted to raise is "set -o errexit" in functions.sh.
It basically contradicts with the usecase I'm using (doing source ./functio=
ns.sh).
After that, any error in current shell makes it to quit.

Honestly, for my tests, I do always disable that line.

  Igor
