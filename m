Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70169394428
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 16:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235788AbhE1OY7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 10:24:59 -0400
Received: from mail-eopbgr130088.outbound.protection.outlook.com ([40.107.13.88]:57942
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235452AbhE1OY5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 May 2021 10:24:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fHAqq4g7WQA7t7xeEHKV+McZXBisJ9yCtl/vMi+XBAw=;
 b=387ZJ7JuvREbWzT/m2wpmmsB+FnNGjvuQ+EOZXBF9trJvFlHa//PhUZGVIy691lFhnNZvKJ6Npa0SijQLpE/o6aAQG1DR347/oGwuXppfiX4lNuCdKAt8FfaVFxd5WRI4uPNLBmvq1VBYxBHh1unYFYRnkm6ssF1kPsvvztFhSw=
Received: from AM6PR10CA0055.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:209:80::32)
 by AM4PR0802MB2147.eurprd08.prod.outlook.com (2603:10a6:200:61::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Fri, 28 May
 2021 14:23:19 +0000
Received: from AM5EUR03FT004.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:209:80:cafe::fa) by AM6PR10CA0055.outlook.office365.com
 (2603:10a6:209:80::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend
 Transport; Fri, 28 May 2021 14:23:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM5EUR03FT004.mail.protection.outlook.com (10.152.16.163) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4150.30 via Frontend Transport; Fri, 28 May 2021 14:23:19 +0000
Received: ("Tessian outbound a5ae8c02e74f:v93"); Fri, 28 May 2021 14:23:18 +0000
X-CR-MTA-TID: 64aa7808
Received: from 832eb8e6627f.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id A68925D0-6B8E-42BD-9EBC-863F3F7EF3B2.1;
        Fri, 28 May 2021 14:23:13 +0000
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 832eb8e6627f.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Fri, 28 May 2021 14:23:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nifhs1jueJmr2XLCzMfMupQqTVpGT5QYK6hcSk7agAiAVZtoKO9ge5qgXd7cbxz3Doe4unPGEhgqldnAhNCdybNAc7cdyZ9wOjyunn233kDIfik5t7WUabiO/qYf6mXXRhBEnXp/QKomDYc9CEkqpfc6qtjYW6LAsMJ9yj3CdniJUa+clk3lByfYtIuAaxIea3OvXuLVIzbENuOZzkHOeEROKDz2KgCrEbcuBvCrbCOqZuMQlYJ9GvRIyi0Y4u12U3mB24JQinkk1f8Ewm/nijnmZ8BZYIIvuYahBrEnUaUafSQvRwR2C/Y5KgPWUYl6k5ZI3l+CSjTMlky6qV/6wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fHAqq4g7WQA7t7xeEHKV+McZXBisJ9yCtl/vMi+XBAw=;
 b=fHvcFSJO4tUSJzpQo938JcBz6qr+GGcg9+yrxo7ZvIxnRAB9Z7Ov9/Q2C3WsN39b9f/qt1kreEJtLF/Ipb8QlEhTGdz3nkQtKD0yanoMOq8oZtk0veS+YFn8S7KIN2DgrWU4O61nrkfio1ZRzy10mvpelrnBvFh65vpjF2YR0yUVWDL7ZSAmwfa0zFgYN1UCzejvusqbZxm91C8/mhNR9NZXm6Putos4RyWAeN7Ach27FDHeg7XA5HTm+cOpZ3LQJSp0n0la7583na62kfIoIpcnBv0Tz577q3ESa5qIpEDql5a/7a4nBaOddwqBuSJ6eT1vi0Vq5BP7g9xoR46VCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fHAqq4g7WQA7t7xeEHKV+McZXBisJ9yCtl/vMi+XBAw=;
 b=387ZJ7JuvREbWzT/m2wpmmsB+FnNGjvuQ+EOZXBF9trJvFlHa//PhUZGVIy691lFhnNZvKJ6Npa0SijQLpE/o6aAQG1DR347/oGwuXppfiX4lNuCdKAt8FfaVFxd5WRI4uPNLBmvq1VBYxBHh1unYFYRnkm6ssF1kPsvvztFhSw=
Received: from AM6PR08MB4376.eurprd08.prod.outlook.com (2603:10a6:20b:bb::21)
 by AM6PR08MB3062.eurprd08.prod.outlook.com (2603:10a6:209:45::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.21; Fri, 28 May
 2021 14:23:08 +0000
Received: from AM6PR08MB4376.eurprd08.prod.outlook.com
 ([fe80::18c4:33fd:d055:fe60]) by AM6PR08MB4376.eurprd08.prod.outlook.com
 ([fe80::18c4:33fd:d055:fe60%3]) with mapi id 15.20.4173.021; Fri, 28 May 2021
 14:23:08 +0000
From:   Justin He <Justin.He@arm.com>
To:     Matthew Wilcox <willy@infradead.org>
CC:     Linus Torvalds <torvalds@linux-foundation.org>,
        Petr Mladek <pmladek@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Johannes Berg <johannes.berg@intel.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>
Subject: RE: [PATCH RFCv2 1/3] fs: introduce helper d_path_fast()
Thread-Topic: [PATCH RFCv2 1/3] fs: introduce helper d_path_fast()
Thread-Index: AQHXU7Zi1wKgbL37X06FgTdtF6ajcqr42Q+AgAAZQNA=
Date:   Fri, 28 May 2021 14:23:08 +0000
Message-ID: <AM6PR08MB43769A2CDB9584A2AD554A39F7229@AM6PR08MB4376.eurprd08.prod.outlook.com>
References: <20210528113951.6225-1-justin.he@arm.com>
 <20210528113951.6225-2-justin.he@arm.com>
 <YLDnbafc6mEXENfy@casper.infradead.org>
In-Reply-To: <YLDnbafc6mEXENfy@casper.infradead.org>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: DEB36E7F64792C4CA5D0900C1B209CE8.0
x-checkrecipientchecked: true
Authentication-Results-Original: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=arm.com;
x-originating-ip: [223.166.32.249]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-Correlation-Id: 2132ab73-f0d6-4142-001c-08d921e42490
x-ms-traffictypediagnostic: AM6PR08MB3062:|AM4PR0802MB2147:
X-Microsoft-Antispam-PRVS: <AM4PR0802MB2147C77F81D89A890715AE24F7229@AM4PR0802MB2147.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:4714;OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: Nngp9owH1jYKkg5SYjWHEFYAKNdi2MjXeRQKwRD6vTwaK4B3me6mmxME7zGMj/lWvdg1KAQavlQgXx/Who37IwzxMrT8698mr2cHRwUk+2Mx/IilahUNxyTq0WN+Ke54pwL+gDN4TRwiyfeMEJhodP/d4xPOpMrluz/SByBvf6pv2haEizgazFZveeq5c6uQuo/Q/+CsNWa6fcB5vQKnQfu99nqaaZjGPQL7LDxEDvN/2MmbglCquSlsGyXMu6QYj1NoX7ydBKyUgMPW4bjA5cNDS97t8kKhSrj7z+KgJszwCGDURG/tpS+1qK0kaRt+GmNnXJBCXOvba4UY/9PyPf+So9AxdS9THKHITO7d4h4p08K9JlFDxcpsF7M0FTy+h7snuxdxwg/EE4BkNMQRl4blgExj9NaRM5/hhfX7cx2aN1zhBPgKXCca04EFEd3fSXMflYU9/7vhCM+HLj6HrO9IC0D6OSdDuaNwIxLx4izawldYARDmMQWcSQdNmLzgXdbohYbq0/lAOqb18Z/fcI/uk2n64VauX+LNcQIj8AfDkRPxBDhprKvhbmY+tqgK6585BPFqnQjW3tcFuvyHJk6gxAYyoBdostaG0X9wZpM=
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB4376.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(396003)(136003)(346002)(39850400004)(186003)(38100700002)(26005)(6506007)(7696005)(33656002)(122000001)(54906003)(53546011)(55016002)(71200400001)(7416002)(6916009)(86362001)(66946007)(76116006)(52536014)(4326008)(66446008)(66556008)(64756008)(66476007)(5660300002)(8936002)(9686003)(8676002)(2906002)(478600001)(316002)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?S2wkQEkzqt8zm8KLH1kUqNTkDWVZ3QWr1nT972uXaxo5hrXyfTBIK4Em8S8f?=
 =?us-ascii?Q?+A1JM7JVRP5B1pVEXcX9e+l8hq+Aejbmdn2HmsW6K7OHlKZ3lEJopeqFpSmD?=
 =?us-ascii?Q?G86yuQQoffRSpGDQtSpEAFit9GaxSfyOh/suv/DFgQZ+m4thkfSaZiH6iQf2?=
 =?us-ascii?Q?r1uArE/7y4QR8+30t/G0RKehHsJ7yvbiTwK1zwEcb1d7jaOKdtw/1BGjmdKe?=
 =?us-ascii?Q?QVqyZckch3VyzTcxgz68RpFrGJnjIJeZW5mT/OajiPhZAR7fFajFVeVUzuGW?=
 =?us-ascii?Q?1d/WIELVqWcJVO+lyYS1KDZLE2clnJKp6Okxd1HXwi4oTApJZtb1H34fpRvv?=
 =?us-ascii?Q?6PUMIF/r6jrc07JAX+dugLWl+11UdEZsIVsEOeABYktBGi+v1YWrtNN80HT5?=
 =?us-ascii?Q?AWUgNIg5ZkUa16kGz34tLaPeT2Y1V5f/6GHu5N3AgbqdMj2nsw1Rw7f9WD6v?=
 =?us-ascii?Q?yWtQP2YtjRZt/F932H9XrIyq3TzSc0Rdjl/NGnz104lNVPNqgvCDUX+OVK3P?=
 =?us-ascii?Q?+KNQYExo0LM4lg8yi00Bw9JVSDvz8SAAHvoljmqP4FIz85yMI1LcDhaxjjJg?=
 =?us-ascii?Q?pp/EzWfCZ/A0Y//D1RrdZrksDvQ97W5YJZlswpymbLVJKGRnzaCYhwGmNkdG?=
 =?us-ascii?Q?s2F4UnAHu8qpR6oBiTRfNIloTuFPKc+aA6F4g+uOm7oIgM5cHEGryD5IyHS8?=
 =?us-ascii?Q?P9umBrD6XRL1YMPh7fBSRZGf6waVhpPKzxPWXjNfKZ0FjlWAYXRrS21BQTI+?=
 =?us-ascii?Q?C9IWRZpYZ4dgcPrHR3itZhBPG8Gz+3b9Flca9g5bc4t/d9nQy1MDg9i7TKI5?=
 =?us-ascii?Q?sYyMsNIdscJkXDxUQETfvSL9pI8bZHAN2PQ8aJXfHDImTjnOwjAw/LmVZG7F?=
 =?us-ascii?Q?ydxtFxuEZEMNQlQBsy+hfya3ivBN5gA9MtxkVbHCMxj1pM3imjGJjcJuH05k?=
 =?us-ascii?Q?afM+umhG1ahhHOVUFLc/eiVO5H35tXoVgtbi8ZVhSymnW69KCbNfFr0mCmcG?=
 =?us-ascii?Q?k2mDYmz0cTsp6aFSiYLK0o6c6fmNtipBrlP0SLAh8OyFbpvfwUfpv72XzFcl?=
 =?us-ascii?Q?1IJm5HsuonBhxZwsRpGaUQM4O5iFg8nFZs3auiAQNCqEoDyQAtSUpLRZpq9/?=
 =?us-ascii?Q?wvhysHIsUG7LLxFv5lvf9Ml1/rLYeqoQ6DuDH0e0ZivxzlCkECa7+sc1NVtB?=
 =?us-ascii?Q?SAAsl176deXc/nSuSJ/pe7oB6U9XLlNtafq67wjcNQGbOhNqpzCI3JGgkaou?=
 =?us-ascii?Q?nUFpfa3iAyQR+NEraVj9vY/HqYK5UEECFrYnS5Yg1KBfHsvHfF0BoFkC8w/6?=
 =?us-ascii?Q?O2Qi7C6yWRCMgmhWqTHCIlqo?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB3062
Original-Authentication-Results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM5EUR03FT004.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: fb776b47-5720-491e-5872-08d921e41de3
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r6kOYAzJ17o9D5D8tNwKxnm1Wnhe4PILSdMWryhMuFN2v1TZn+CiKclCrCqLj7XtNcI/N0bMaLWc+MukeC2d9+bbeUz9zzAgX6lEPkaPPQ1bLuiCMjj4w+VWpmONzV3LCQDmwLqcd7juKKMfLEVugxQy/AW7S4b42iwq7M42KdVBmvWvclo9PYYnlLHH9mGNXX+eSw86c9I0muAnkmXKW5zJ175l0e83qzrWTE91RIAWjWEgx4ELiwZn6rCpywWKxMGLl1DmB4Cbchfw+hU2bSncIRMql06XPRAc1VCc9tV1LfEgBKwceWex8lvHDlsJMNbw2/qbR7uo4uODksO2qJLRBdZYabyJBRSovEc4Ye6m70M7bIrC6yxiZKkDhQoYNaDV+fnFN5b4K570JJvmY0NKzsiUdxquFI6K/vvbKmwTKf7p69L/gvcgVih0W39wQaa8jKCXkSF/nDGi9JMyJ91aSU/3MKRHkp7ahQQQ21xtnyWNaks8c0H48f6ehlodlg2i+LG8R+mI11i3+5WazehqX+PGHkQkORUUPWjspSxO73hYw8k2Xl7NqLSvSSrXZBawyFF2jmkM+dICMl6rSjusEZmLWk4augUK2DxM/877FBDa8yMQZOCi4hQUTc+ueMDC323vLgb1rfMTLqsnUg==
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(376002)(396003)(346002)(136003)(39850400004)(46966006)(36840700001)(55016002)(6862004)(186003)(4326008)(26005)(83380400001)(8936002)(70206006)(478600001)(82740400003)(6506007)(450100002)(53546011)(9686003)(33656002)(47076005)(7696005)(82310400003)(52536014)(86362001)(81166007)(8676002)(2906002)(54906003)(356005)(336012)(70586007)(316002)(36860700001)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2021 14:23:19.7933
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2132ab73-f0d6-4142-001c-08d921e42490
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: AM5EUR03FT004.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0802MB2147
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Matthew Wilcox <willy@infradead.org>
> Sent: Friday, May 28, 2021 8:52 PM
> To: Justin He <Justin.He@arm.com>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>; Petr Mladek
> <pmladek@suse.com>; Steven Rostedt <rostedt@goodmis.org>; Sergey
> Senozhatsky <senozhatsky@chromium.org>; Andy Shevchenko
> <andriy.shevchenko@linux.intel.com>; Rasmus Villemoes
> <linux@rasmusvillemoes.dk>; Jonathan Corbet <corbet@lwn.net>; Alexander
> Viro <viro@zeniv.linux.org.uk>; Luca Coelho <luciano.coelho@intel.com>;
> Kalle Valo <kvalo@codeaurora.org>; David S. Miller <davem@davemloft.net>;
> Jakub Kicinski <kuba@kernel.org>; Heiko Carstens <hca@linux.ibm.com>;
> Vasily Gorbik <gor@linux.ibm.com>; Christian Borntraeger
> <borntraeger@de.ibm.com>; Johannes Berg <johannes.berg@intel.com>; linux-
> doc@vger.kernel.org; linux-kernel@vger.kernel.org; linux-
> wireless@vger.kernel.org; netdev@vger.kernel.org; linux-
> s390@vger.kernel.org
> Subject: Re: [PATCH RFCv2 1/3] fs: introduce helper d_path_fast()
>
> On Fri, May 28, 2021 at 07:39:49PM +0800, Jia He wrote:
> > +/**
> > + * d_path_fast - fast return the full path of a dentry without taking
> > + * any seqlock/spinlock. This helper is typical for debugging purpose
> > + */
> > +char *d_path_fast(const struct path *path, char *buf, int buflen)
>
> I'd suggest calling it d_path_unsafe().  Otherwise people will call it
> instead of d_path because who doesn't like fast?
>
Okay, thanks

> > +{
> > +   struct path root;
> > +   struct mount *mnt =3D real_mount(path->mnt);
> > +   DECLARE_BUFFER(b, buf, buflen);
> > +
> > +   rcu_read_lock();
> > +   get_fs_root_rcu(current->fs, &root);
> > +
> > +   prepend(&b, "", 1);
> > +   __prepend_path(path->dentry, mnt, &root, &b);
> > +   rcu_read_unlock();
> > +
> > +   return extract_string(&b);
> > +}
> > +EXPORT_SYMBOL(d_path_fast);
>
> Why export it?  What module needs this?
Okay, indeed

--
Cheers,
Justin (Jia He)


IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
