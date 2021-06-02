Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 501FE3980CD
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 07:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230258AbhFBFt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 01:49:56 -0400
Received: from mail-am6eur05on2067.outbound.protection.outlook.com ([40.107.22.67]:29696
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230139AbhFBFtv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 01:49:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=milIaKkoii5zHWJAIqzuDfIvHmz3EtqfGQbxzYfPxjw=;
 b=n4oCqj0iUfLvyUw4VluZXDxWLq9Nc+d/VhuoyLig12tGCDo/lEBT186zT4ZscKsFGJ94O3Yhi1wHQN8LZ2BPrDD/XmyvXIKUI4EJEPILBbLKnOXELC23dFoY16cqnK3StI0NTnbCDfI16+Rvabpxk4Gh9djfxdCeaXAJWLkXQjA=
Received: from DU2PR04CA0207.eurprd04.prod.outlook.com (2603:10a6:10:28d::32)
 by VE1PR08MB5277.eurprd08.prod.outlook.com (2603:10a6:803:10c::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.24; Wed, 2 Jun
 2021 05:48:02 +0000
Received: from DB5EUR03FT028.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:10:28d:cafe::2e) by DU2PR04CA0207.outlook.office365.com
 (2603:10a6:10:28d::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.15 via Frontend
 Transport; Wed, 2 Jun 2021 05:48:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 DB5EUR03FT028.mail.protection.outlook.com (10.152.20.99) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4150.30 via Frontend Transport; Wed, 2 Jun 2021 05:48:02 +0000
Received: ("Tessian outbound a5ae8c02e74f:v93"); Wed, 02 Jun 2021 05:48:02 +0000
X-CR-MTA-TID: 64aa7808
Received: from 02831cac3a98.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 9E34DA49-5E43-420E-8CEE-3B0E6B2F499A.1;
        Wed, 02 Jun 2021 05:47:56 +0000
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 02831cac3a98.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Wed, 02 Jun 2021 05:47:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ntyi3Cu+A6yVW1SXNvnmnt0GzDYWX9IMQRuNvyYCkjvO7Cuy6MVy7CLCwxwhz8/35bLemAI1iOjB28FyeUyKas3ezj70Gy5YLbFpEDQsZLuDFEN8PxUyGA/Xoo1eQ+xLb0vPRwPBg90aOwH5xKp97z3Ige9n8BIfjpT916Jy3wQFmlwUGsSvQ+GZb7mV4aK6IgGG5Q2sRmKYfpiS+qBXVW0ZYetur3grNMlqiIEO/ZFgN5okcekAHU3m7AToMqyDAKY31/sGqlVzdxFLfjODKm8su01tKIwx5qt1OvzHEGWqlZEb10PHaqFnZM4nSXvECHmf5JMQNJOkDT6uC/O34A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=milIaKkoii5zHWJAIqzuDfIvHmz3EtqfGQbxzYfPxjw=;
 b=B/OYPEqdOe1ARLIjaLdYNG5lf90AR0r0YkNtkzTq4KwDK6nqzhaXxnkFODvmQtalXu/RpCCWttpbIrJTQkrTYC0Dvh1fZSFyfrSwznZlw9ifGvhCEX+Jnv0RY0+UWolJ2Fvg1YhEVWLAdvE86kjvyPDGLQjgl1Wg0NCcKz7fmMJfPANNwgOfLJtwDGu8WytzPaQhU3RvsiKY4HikS43awlR+sTZxx/L/jj4LNpyL1g5HNwy9ndU97BIN39K8IfC4QevI5TQNm8XPK5Sg++AYzWC21bZNVaJgdBES5aPBLXhO0Tij5mjrQyyNC29bxEP4gKuOZaTfLlRS8S0Ys55L5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=milIaKkoii5zHWJAIqzuDfIvHmz3EtqfGQbxzYfPxjw=;
 b=n4oCqj0iUfLvyUw4VluZXDxWLq9Nc+d/VhuoyLig12tGCDo/lEBT186zT4ZscKsFGJ94O3Yhi1wHQN8LZ2BPrDD/XmyvXIKUI4EJEPILBbLKnOXELC23dFoY16cqnK3StI0NTnbCDfI16+Rvabpxk4Gh9djfxdCeaXAJWLkXQjA=
Received: from AM6PR08MB4376.eurprd08.prod.outlook.com (2603:10a6:20b:bb::21)
 by AM6PR08MB5189.eurprd08.prod.outlook.com (2603:10a6:20b:e7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.21; Wed, 2 Jun
 2021 05:47:43 +0000
Received: from AM6PR08MB4376.eurprd08.prod.outlook.com
 ([fe80::18c4:33fd:d055:fe60]) by AM6PR08MB4376.eurprd08.prod.outlook.com
 ([fe80::18c4:33fd:d055:fe60%3]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 05:47:43 +0000
From:   Justin He <Justin.He@arm.com>
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Matthew Wilcox <willy@infradead.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
CC:     Linus Torvalds <torvalds@linux-foundation.org>,
        Petr Mladek <pmladek@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
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
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: RE: [PATCH RFCv2 2/3] lib/vsprintf.c: make %pD print full path for
 file
Thread-Topic: [PATCH RFCv2 2/3] lib/vsprintf.c: make %pD print full path for
 file
Thread-Index: AQHXU7ZL838wopFuOEK5GzAxNom8qqr420gAgAAQ9UCAAA6WAIAAAE0ggAAH7gCABjupYIAAD9+AgAAB04CAAAILAIAAFtA5gAAgcICAALJt4A==
Date:   Wed, 2 Jun 2021 05:47:43 +0000
Message-ID: <AM6PR08MB4376DB8B76EB0563A0FB75D7F73D9@AM6PR08MB4376.eurprd08.prod.outlook.com>
References: <AM6PR08MB437691E7314C6B774EFED4BDF7229@AM6PR08MB4376.eurprd08.prod.outlook.com>
 <YLEDwFCPcFx+qeul@casper.infradead.org>
 <AM6PR08MB437615DB6A6DEC33223A3138F7229@AM6PR08MB4376.eurprd08.prod.outlook.com>
 <YLEKqGkm8bX6LZfP@casper.infradead.org>
 <AM6PR08MB43764764B52AAC7F05B71056F73E9@AM6PR08MB4376.eurprd08.prod.outlook.com>
 <YLZSgZIcWyYTmqOT@casper.infradead.org>
 <CAHp75VfYgEtJeiVp8b10Va54QShyg4DmWeufuB_WGC8C2SE2mQ@mail.gmail.com>
 <YLZVwFh9MZJR3amM@casper.infradead.org> <YLZX9oicn8u4ZVCl@smile.fi.intel.com>
 <YLZcAesVG1SYL5fp@smile.fi.intel.com> <YLZoyjSJyzU5w1qO@casper.infradead.org>
 <39f599a7-9175-f220-3803-b1920ddb8d40@rasmusvillemoes.dk>
In-Reply-To: <39f599a7-9175-f220-3803-b1920ddb8d40@rasmusvillemoes.dk>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 5636A308F9A88942A4C8198DCD39F8F2.0
x-checkrecipientchecked: true
Authentication-Results-Original: rasmusvillemoes.dk; dkim=none (message not
 signed) header.d=none;rasmusvillemoes.dk; dmarc=none action=none
 header.from=arm.com;
x-originating-ip: [203.126.0.112]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-Correlation-Id: 0e888162-ca3b-40f4-b4f4-08d92589fca2
x-ms-traffictypediagnostic: AM6PR08MB5189:|VE1PR08MB5277:
X-Microsoft-Antispam-PRVS: <VE1PR08MB5277054A01567D106AD83626F73D9@VE1PR08MB5277.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:7691;OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: kgDXYkf0HB/V/k8fyP0urikJLSZYIEeTui3tSiEqKpa0WPb3H5f7eZU3qJZ0+i0Swks1RO5Beq/bA6USbBOE05b3KMwyLgXnc5vLmt4ZHguHve8yOP2NUr/W2mS6F8F3wK//m3TvOrqGP2aQBNZSxbMGtKVCh6pUgUci+KtuDYsRa51NF/tN48TYeDVmUQuUZORDFe8xBtYa4DOBWECfknbvJmYTvc3vxJ09oAaRx2zsnU4ukFzGsiPNiLDyC+yDviJIlghcaUKeBtRsE9T41VuoS29XAf+56Qu24zjsrwh3Gzi349oaIKnUgrKUjvE2XIiYfe2AM4olksfmKQB/HTSqyDJa0mPkOdeuIs0gDsJHWurFt9qpiktuQWRAe/I3AKBURPwPEDe+RWdg5MShCqbZ0bB45nDauxbF5VCes1sLvGn8bdIv1RyVIfEHJyxZDrMLuNKmETUbmAxS9pJM+L68w4Scf/1cBnA0bBBSdS9VKz9/KmSIwlbmAJ/Z407NQN54MCvxnOc+SNu+utYr6+GXavIYm4Kki6hvMcSAw0O49rPjhzeiIZqIMMJ8vN1FexSwoN9E9tmQIloyllPBWu8igUP3ZIS9hl6MdhXe6jU=
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB4376.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(136003)(396003)(376002)(39850400004)(52536014)(83380400001)(4326008)(26005)(8676002)(33656002)(71200400001)(53546011)(186003)(6506007)(8936002)(2906002)(7416002)(55016002)(38100700002)(478600001)(110136005)(7696005)(122000001)(316002)(5660300002)(9686003)(66946007)(66446008)(76116006)(66556008)(54906003)(86362001)(64756008)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?1qu7cheLFfVXVOHJJNEOhLNHrxfjBJdNVTxVgcp7RcBIw20UK3H4c/CKKlCR?=
 =?us-ascii?Q?zYCHujJ3H9jlDA3W2pgXXKyK113QKsQD0o/t0vvVyLhScfxbFKRhtlhiCKoJ?=
 =?us-ascii?Q?13AkPbkZh4d5X49dhUvhED8bBtlG0Z3Z+6aXX/KZTAA9leM+gjOq6fsq4WMZ?=
 =?us-ascii?Q?xfNImqPJeGNgQD0buNeUwqpW10c90ZZAFb9fbbcvFcV5yO86y99gxFKfGgtP?=
 =?us-ascii?Q?gKSogDYRHymZ9sWsk3cCW5+2RYWwBPSC/J97k9xs1Hvub24Wg9oURWeqLnnC?=
 =?us-ascii?Q?Gv+sD1gqe+V/aeT79t4GoCbeYBQkjPv7nRRILDKnjVfSX08172z4GM6t+L3Q?=
 =?us-ascii?Q?i0VwVhf7kiQ3RKflNHaGMshu13v3Yg8vMxHLOuNtXrWsNmETxxOc/GE9FsU0?=
 =?us-ascii?Q?KFKQCxQM1uvswkN5XvF+nbaEDkvNnbxTjijgpLzIVm4HtzSktrHgiARjP7Tz?=
 =?us-ascii?Q?LTf+ZExTauGHFI9Domuqdmw+umkwEQN8/uy4oQWPxECa47dES/IDOrujvrhx?=
 =?us-ascii?Q?V3N6YFmjyH3lRYhwW4CVbavoJcyPVuQQlwIW2JWaUHyrcE2nUffZ+gsyCuBh?=
 =?us-ascii?Q?A3OEK8YJIWkmwgEAaIItZZI6JW8mixTQVJ3/mEFbv1IswbW3Eba8kthBHC3v?=
 =?us-ascii?Q?fTj7+NiyHgjX79j4ATdxLIk7ZvXyujn65arpmXNYjswdrv4M5rhbHcZeARhc?=
 =?us-ascii?Q?eZ+gFMz4Z+NGo05rfh523JBdSoseFVRUZQGt/NO8pAsHHjrXpRlP7vUsp3Rz?=
 =?us-ascii?Q?oYyAT7q28DHXpFajDf69Y0b+1a6Xa2Ig5yjBEu89IHPfq82hYXJ7tZZBu8JF?=
 =?us-ascii?Q?yKIdmAMX9pd25ERUjnvKAltfqukiqcsr23Y9nWWj/zMoAMB1tLp1kWDgxZ4B?=
 =?us-ascii?Q?LLqrYYIPV6vQJBkGqA5YoYItqNAnv9SvaV2lRXzsXbtLvIyBo0xVSWTVTYwC?=
 =?us-ascii?Q?Gg0Rrr/EjDzsrkzdbkFaD4moPOF6CzgR9Cfj3mN0gxbAtSIDB7B8bz6MSSoY?=
 =?us-ascii?Q?tltHdx3BdhgTVNbCs+wBs0COd142iIDhIsgiaNHbAlUi2Bd3NCNDQnnvjgHr?=
 =?us-ascii?Q?QGqMHNhsMch3FXGLjGt4Y6dCGevGASpLO0Di5IXukEaDZ+zoMftkfiPQKwuQ?=
 =?us-ascii?Q?8j98EytRQo0N/8wsUdZ7xqmKZq7vFQA9mlOxTxqK8pTgmr0SmT4ii8vVoTMJ?=
 =?us-ascii?Q?iRSPshVxusD5NTNm0nTKL9v6S/x32okq872GJB2jyZtk2JD1GAX/qm73B4uL?=
 =?us-ascii?Q?ST+uUUy4dp6zCUzYJ7J2b7Dm8+RMZ9xvAv+tE1NYZ2DZXwIMMceMSAN85kMJ?=
 =?us-ascii?Q?1z4YCAtO8wnWD1jfMRqqOJno?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB5189
Original-Authentication-Results: rasmusvillemoes.dk; dkim=none (message not signed)
 header.d=none;rasmusvillemoes.dk; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: DB5EUR03FT028.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: e6ae827f-3cd2-45cb-b7a9-08d92589f154
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6WJAq7QchtrJJkbEdbwuSgAUDMUSRQzreEfnOqiG/0vjpkgFgh8A42m+andrzE39znjW8E6oLW9aMsiN4sZODAKfT4pd8Yqdyf95LqMxmLvELZyDeUjeZOBA2TUtqIqK7tqsQCop6RaNjSH3mxjkEI6iOxrRaWpvcb98LqAGW6BUabR0snEQCrhN1ijVP21YUcI3XYXdNHpQ9w0sKSCkJVEg4bKq5Foe2/JugHNTa6gwcIMq2sqxPJbSi5wiTmHZoKKRMkW3V6qpBbj13doHzDTvOJV/VeCJmKxlYjUe0EIZQo79ywEgCB0g2SxlX0yRGgQZ3VL9pzyGJo/4kE/4o0ihBclDkC00mPex3GSbJ2SS9EEfQpN+xDv9oRTViZfX7K1BHJjpxXAJfhTagXTobMGTnv9868HKNMCDi/b6Bgk/uFThH4YxugPz9XQ3Gt2DILNaMa/4Tqz+MZcf5w2lUlAr2Nc2TpxhgPSMDg0a6ywbqXmx3fO9rDODkGVpmMlJ2gDrvOZ+/0VfMM6lH5lhNyXw1KEFiJhbe3wKsz9BvDIkg7NLbQRs1UBbI1sDzveOSbBwROBqb2LTza4+aOy3v0GpAInyJYIsvdIFdIDrAbvYUlvUul6BHiHXkVHstjI37ygRvr9xViy0NV6eYs034q1l2mpFtoY43IIjc0q3I70=
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(376002)(346002)(396003)(136003)(39850400004)(36840700001)(46966006)(336012)(7696005)(82740400003)(8676002)(5660300002)(81166007)(316002)(55016002)(82310400003)(70206006)(52536014)(70586007)(9686003)(356005)(478600001)(33656002)(54906003)(26005)(83380400001)(53546011)(86362001)(6506007)(2906002)(110136005)(47076005)(36860700001)(186003)(8936002)(4326008)(450100002);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 05:48:02.8684
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e888162-ca3b-40f4-b4f4-08d92589fca2
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: DB5EUR03FT028.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR08MB5277
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rasmus

> -----Original Message-----
> From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> Sent: Wednesday, June 2, 2021 3:02 AM
> To: Matthew Wilcox <willy@infradead.org>; Andy Shevchenko
> <andy.shevchenko@gmail.com>
> Cc: Justin He <Justin.He@arm.com>; Linus Torvalds <torvalds@linux-
> foundation.org>; Petr Mladek <pmladek@suse.com>; Steven Rostedt
> <rostedt@goodmis.org>; Sergey Senozhatsky <senozhatsky@chromium.org>;
> Jonathan Corbet <corbet@lwn.net>; Alexander Viro <viro@zeniv.linux.org.uk=
>;
> Luca Coelho <luciano.coelho@intel.com>; Kalle Valo <kvalo@codeaurora.org>=
;
> David S. Miller <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>;
> Heiko Carstens <hca@linux.ibm.com>; Vasily Gorbik <gor@linux.ibm.com>;
> Christian Borntraeger <borntraeger@de.ibm.com>; Johannes Berg
> <johannes.berg@intel.com>; linux-doc@vger.kernel.org; linux-
> kernel@vger.kernel.org; linux-wireless@vger.kernel.org;
> netdev@vger.kernel.org; linux-s390@vger.kernel.org; Linux FS Devel <linux=
-
> fsdevel@vger.kernel.org>
> Subject: Re: [PATCH RFCv2 2/3] lib/vsprintf.c: make %pD print full path f=
or
> file
>
> On 01/06/2021 19.05, Matthew Wilcox wrote:
>
> > Here's some examples, what do you think makes sense?
> >
> > snprintf(buf, 16, "bad file '%pD'\n", q);
> >
> > what content do you want buf to have when q is variously:
> >
> > 1. /abcd/efgh
> > 2. /a/bcdefgh.iso
> > 3. /abcdef/gh
> >
> > I would argue that
> > "bad file ''\n"
> > is actually a better string to have than any of (case 2)
> > "bad file '/a/bc"
> > "bad file 'bcdef"
> > "bad file 'h.iso"
> >
>
> Whatever ends up being decided, _please_ document that in
> machine-readable and -verifiable form. I.e., update lib/test_printf.c
> accordingly.
>
> Currently (and originally) it only tests %pd because %pD is/was
> essentially just %pd with an indirection to get the struct dentry* from
> a struct file*.

Okay, I can add more test_printf cases for '%pD'

>
> The existing framework is strongly centered around expecting '/a/bc (see
> all the logic where we do multiple checks with size 0, size random, size
> plenty, and for the random case check that the buffer contents match the
> complete output up till the randomly chosen size), so adding tests for
> some other semantics would require a bit more juggling.
>

Yes, agree.
In other way, if the user:
char* full_path =3D d_path(...);
snprintf("%s", limited_size, full_path);

He/she will get the inconsistent result if we return "" for '%pD'.

--
Cheers,
Justin (Jia He)

> Not that that should be an argument in favor of that behaviour. But FWIW
> that would be my preference.
>
> Rasmus
>

IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
