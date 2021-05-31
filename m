Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 932EC39537A
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 02:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbhEaAmI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 May 2021 20:42:08 -0400
Received: from mail-eopbgr80077.outbound.protection.outlook.com ([40.107.8.77]:24645
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229891AbhEaAmC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 May 2021 20:42:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pIUwjfsiy3Anx7mDLIIQdu9Vyxuv91el6+VP70wbbqI=;
 b=zt4YRlXK1r5VWJg6D1m48zqSze7/Vr1EsLOnDSEISgZNC6j3P9Acv7D4TQcK9nd1vStKTv0MIRlgd/NeqQqSVbCZnyLIJ7DXHzKJS8VTwjUu42cn+7j9Tz32OG/Imylg18tdKmy4rK9foCF8539gE8fi4R/voqBL0FEWLetXb84=
Received: from AM4PR0902CA0016.eurprd09.prod.outlook.com
 (2603:10a6:200:9b::26) by DB6PR0802MB2455.eurprd08.prod.outlook.com
 (2603:10a6:4:a0::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.24; Mon, 31 May
 2021 00:40:02 +0000
Received: from AM5EUR03FT048.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:200:9b:cafe::f6) by AM4PR0902CA0016.outlook.office365.com
 (2603:10a6:200:9b::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend
 Transport; Mon, 31 May 2021 00:40:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM5EUR03FT048.mail.protection.outlook.com (10.152.17.177) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4150.30 via Frontend Transport; Mon, 31 May 2021 00:40:01 +0000
Received: ("Tessian outbound 836922dda4f1:v93"); Mon, 31 May 2021 00:40:00 +0000
X-CR-MTA-TID: 64aa7808
Received: from a6302f3ae201.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 73853B50-EA89-4AA8-B9F8-7470600224ED.1;
        Mon, 31 May 2021 00:39:55 +0000
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id a6302f3ae201.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Mon, 31 May 2021 00:39:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ll1aZ/CXjJpQNrpLy6Nn97EbiZ8hmO1OBlAocAlqqgSGDKxe4U9fZK5LxHoQoI+yijoaPw4GF2Awjcu5fGOYG9GBj737K14qzA0pWI0u24NORCHU4Txd+N5v8KLWasb9SZL395MpCutXsfxDINRwYDhxljXHnywbNpf3r7JN/a5+iDOgm9jmzK/mcyTeNGcqtHKUywJzxDsldLsKl91+Fd0heYFrHLnJkDyMMkz/xuGPkkVbD16kZdWfGdRLGfZEmZCuHj+Bce1lr7WenOXwiDzc4mM9sQB2ISOwphZEqMnMPpN3/LbTqUBQqnx1v/heTpjDBDApCNibr3j+xWJJkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pIUwjfsiy3Anx7mDLIIQdu9Vyxuv91el6+VP70wbbqI=;
 b=CelKaojH6UhrT/I1OZ66PK8vJ+Bw4Ta4+qEMKLah/sBQohJ+l5UeyB9BF3eHwc146mR/uPa6u8luwlkm3FvTYA3PZ7bCqw1I09VBbU4jXU6rex+KhsGGlv3fHmvO3RMXmA3XEr8ASbQCwzgEsedQYmBh6tJA5kZ34QV3t0D8u8uc3AeeNsaBbudbkS3Nr0euDvhmYt6U+w5RQUYFOdE/tC9ZKYPgh4GWOQ0NHHhzKHYNb2mGXdiAx0qXegut5XWu14KCNxG9VyxBY4PutvToDPzrIHTE3Qq0Z5SFAWtONtbxKGOTav9guUZy9e74bNwh3CdzM+Pa1BSk3L4NZfYuQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pIUwjfsiy3Anx7mDLIIQdu9Vyxuv91el6+VP70wbbqI=;
 b=zt4YRlXK1r5VWJg6D1m48zqSze7/Vr1EsLOnDSEISgZNC6j3P9Acv7D4TQcK9nd1vStKTv0MIRlgd/NeqQqSVbCZnyLIJ7DXHzKJS8VTwjUu42cn+7j9Tz32OG/Imylg18tdKmy4rK9foCF8539gE8fi4R/voqBL0FEWLetXb84=
Received: from AM6PR08MB4376.eurprd08.prod.outlook.com (2603:10a6:20b:bb::21)
 by AM6PR08MB3062.eurprd08.prod.outlook.com (2603:10a6:209:45::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.21; Mon, 31 May
 2021 00:39:51 +0000
Received: from AM6PR08MB4376.eurprd08.prod.outlook.com
 ([fe80::18c4:33fd:d055:fe60]) by AM6PR08MB4376.eurprd08.prod.outlook.com
 ([fe80::18c4:33fd:d055:fe60%3]) with mapi id 15.20.4173.030; Mon, 31 May 2021
 00:39:50 +0000
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
Subject: RE: [PATCH RFCv2 2/3] lib/vsprintf.c: make %pD print full path for
 file
Thread-Topic: [PATCH RFCv2 2/3] lib/vsprintf.c: make %pD print full path for
 file
Thread-Index: AQHXU7ZL838wopFuOEK5GzAxNom8qqr420gAgAAQ9UCAAA6WAIAAAE0ggAAH7gCAAVMJYA==
Date:   Mon, 31 May 2021 00:39:50 +0000
Message-ID: <AM6PR08MB4376DD4B202E967078B45D2FF73F9@AM6PR08MB4376.eurprd08.prod.outlook.com>
References: <20210528113951.6225-1-justin.he@arm.com>
 <20210528113951.6225-3-justin.he@arm.com>
 <YLDpSnV9XBUJq5RU@casper.infradead.org>
 <AM6PR08MB437691E7314C6B774EFED4BDF7229@AM6PR08MB4376.eurprd08.prod.outlook.com>
 <YLEDwFCPcFx+qeul@casper.infradead.org>
 <AM6PR08MB437615DB6A6DEC33223A3138F7229@AM6PR08MB4376.eurprd08.prod.outlook.com>
 <YLEKqGkm8bX6LZfP@casper.infradead.org>
In-Reply-To: <YLEKqGkm8bX6LZfP@casper.infradead.org>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: A7177C2FEF446743B4318CF85BF21D7E.0
x-checkrecipientchecked: true
Authentication-Results-Original: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=arm.com;
x-originating-ip: [223.167.32.10]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-Correlation-Id: d3de7459-f814-4589-46c7-08d923cca01b
x-ms-traffictypediagnostic: AM6PR08MB3062:|DB6PR0802MB2455:
X-Microsoft-Antispam-PRVS: <DB6PR0802MB24554CD54CF210385134C94EF73F9@DB6PR0802MB2455.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:9508;OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: lKbMdwaoxyla4u17j0hfIhL1x+ZIfGGwoQcKuNkcEwLxlESI3UhKIb0+zNON0Yc/TXdcqtVCIfwh99TzMJ7+1JQUW2OvaAAcHQS5gqD43ayv0T80gF9PDx2WJ8fd2hhualhEX35jXZRg/8FKDM7EZ1ckJULZZuXOxxPJ8Rahwx5NBFGpnkwz0Jjqmj0NyfF370zooChX8K5PeVNTl066hZp1O4YksyulORS4h/GBk/mvhfH+mdZOeuvr0EykPpKXOgf69yhJDBwijN8ZsQp5bjkra9MjKIBGbqhgNl9FL57vLVgwtm9LUqAf40FSrzBdhY6H9rgnfCF5o9eIWMp6xkmDEce7/u7IrYTN4mVNoXiSUXmTeImacpu98S7WKmht51CBXZeS+BMBMLhBG52T+T2PYuyYYKdMwBZzr9TQqvhd+oj+7FdYutnfvLRdQWDiyh5h8fF6IzwAMXkVKJ0inRzWgPLoHNZVAtjIHGMaITonbfZjekRm3rkhwrxh00iaXALSZI6q6NbbZw4IJkP8JLWsLsK64YGbAFGrGkgwehQh7BlDINXddg49KPMeWGMdSPfuF14zwwBaqZubSg61xCHx6inDpMECeuYc7SKEqNsEwS54LxI8g5yUembPL5rzZK0xblqvbLGscztfgERIELXXfPq+MtcEvfPvjHk6CZ6MZjKieVWmF4PweEEYX35voxpS7oGe4QUWC3UqWxTEFMf0vp5oY6GkdiGpt0oIuoo=
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB4376.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(396003)(39850400004)(366004)(7696005)(316002)(54906003)(9686003)(83380400001)(4326008)(71200400001)(8936002)(2906002)(8676002)(55016002)(966005)(33656002)(38100700002)(7416002)(6916009)(5660300002)(76116006)(66946007)(122000001)(186003)(86362001)(66556008)(66476007)(66446008)(64756008)(26005)(52536014)(53546011)(6506007)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?3/8J199NjUnqKxmubM/OaNrGV4G+qI+TgFoo0/tPRn5yEH2uciBK4Eb5AUpu?=
 =?us-ascii?Q?byv6NqlCtAb+U0vg9aftj7ID39xpLvz5iq+tI4RYA5+t5xWxjp0QhSPUQ9WK?=
 =?us-ascii?Q?mS4P0nHH/RLTkYCSrEFTe3uKb9cXOeyqOR6UZtU3JHpD706S+PRiWVcjOxpl?=
 =?us-ascii?Q?INmqgJjXDfCYoo7Wi4iOk9ecKDTQ58fV229N154+3ngPsNVDH7QsW55lFt0O?=
 =?us-ascii?Q?nXHa7BVh1qVE225bXzsqPkCHem4xt191JvuErlm0xGUBPqKZYTTb7bKg+zuX?=
 =?us-ascii?Q?vxqNG+MuTzrkIPEpRv0PM9F2EmHR6L/mLMN3SWTqeHSWbFd6p0KTT/WtYtxt?=
 =?us-ascii?Q?y6wb42xXRHErSLl4HhoY9KKxZMh2RyiExAHIdZo3k2t+Chb5ANDlqldEvhO8?=
 =?us-ascii?Q?+OCD+Vk/5vLeLB5vF0YvL/a0HJbrPPf8A4ppB1myhRr2Gk/TbcmbRJym5JmX?=
 =?us-ascii?Q?hb6nkpsefzWJND91r7Wg9tBqv4T0btsdLsHXlsUmfWMEuBi4kI6WR4ExMxpn?=
 =?us-ascii?Q?+KA8Hx5P1mQ4rUC0wNYK1jUrLebwnZP/ZtPF2+MCZOjYlwWPAwOhUK9053zo?=
 =?us-ascii?Q?guu9skl9Uw3atnFtCm2/Nh46zTWu0J9M2/hvoOimvmigyFQc1PL7ZlzDu9uj?=
 =?us-ascii?Q?x4L133Mr/HlswEP3XyWmVLSTHgeGE1NtSt9msNCuKF2JGL7QnTQ62Pgy9iFd?=
 =?us-ascii?Q?Va7SCwy7LJdl77tewBhyS0c8s335Oqr/RH5ptmce0Mk0Qc4N2ufImIagn33c?=
 =?us-ascii?Q?awuxlRgzRRVypFKh4ABngcraLzLxbhU9PEZKBJROWIUjIh0iSmCt6mFP2qRh?=
 =?us-ascii?Q?CbslXkQbfBPp506LF4R0//h3tNhCjaDdTQFtOqNHDhDcpDY+qa6CoKakkDVr?=
 =?us-ascii?Q?Lw5f5jmgwqnrUehHtuMljcRPeIOZ28brlm9AFmoge1Ly4gisFIjWjmawK4lU?=
 =?us-ascii?Q?LxjcuFADtXcM9p2/8nEL6KEhWjJVykjDop5kxxuAEXy+HGIqmlAfUYPGQIS1?=
 =?us-ascii?Q?XGZCDZ8sXmK495fQ+MITS6NgtUaHpWCswLZKjFa+xZzoTYMufxlTUzSUaDZO?=
 =?us-ascii?Q?70in05/SsMhwuSj+/PL3Lshg4DTCLDK+fYcc3g7vhj2kIs5mTuKKDTB0yA7P?=
 =?us-ascii?Q?PMWTJoqfTHZUJGzzNDeayVA3DM4P6db2TVr1o4S5qT+tj9VVBYrb7CF3Mc4d?=
 =?us-ascii?Q?CVCTC+uryMe2KHgQh/+mttLBLUpqiF2Hho8ta5BYbfAXtyOn5R6m4i3OHmf5?=
 =?us-ascii?Q?QY63tB++KO+nefuwjIVo7WI4HD+MpjT459GN0Jd8CTsk5y3oVTHWjvHBFpJx?=
 =?us-ascii?Q?lCe5iShS2k+RJ1Z6NQQKVOrk?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB3062
Original-Authentication-Results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM5EUR03FT048.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 9e285a14-4c26-449a-2248-08d923cc99a8
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sZmIOZO31XFgSisBYNbePNbY2EZTtFc9bPi98h37m1gKuvnB2TE8++HqGnFWlUxxmZ1t+cnkVNt2NfIkkBsmKYIxNLjvyqOYsgtH4HcqX9rj6PWxDznqxMBzwkAhfXFI7MqXwz07nrlz6aZckc07Ik1vHjhe8VgM87UqsykdF/DHX02OFFdr/GJ85xrvYfQ0XqfKfgOPAJfBcQiku8rPWtiLOZ7a2yHSew98Sm9cyHnvpm9Yi+EDOgrhv7CaUmtcisvfBwbeIlOeM1nTSRGnJ3rJ7VNOw+e5XguAQpNcJyOBxkZEkg/HbqX36e6SyY5iGX4vNn29888TPeQPDl2gR7gF5obDJTeTWAUrmLYX8t0+jhfkAPZkBSVkyidcJDu4MvZ8xfUAXyo5E0JWH+z9/JKru877RPVk2uEywwdoZh7GCXcx1maqhOXttMrqRtVgM9C9K5l3jrD/vMoKHnCBx9jdZQLFEhWE9nLhwnH3QmeRoI6HwGhggo/8V+x38Qcjcdy9pMxmF/appf5Ox0TLpP3YToqCjlr2KF3fGeWPhd5ooA0dnXZW6mJ/M7IMgWeWM2zt3LOdj1U6W+3FlaEZFlEhhMxqWuhtB/SMHH2b7ENECpb8oyMVzjKZmgftA545dtVJcvBaacv/1p37QFNJRz5/igqvY4iiu/0cvQFsokWHA1Lft8bmAWwWtOfo72FFazkTcv1lwHaevqNveHurnYyjVvwneTRhm3Ryy5fCPI75MCVNGjMihUsmvqaVJx62nC3S2N/dNWQHCaARw+8klg==
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(396003)(376002)(136003)(39850400004)(346002)(36840700001)(46966006)(52536014)(36860700001)(83380400001)(478600001)(4326008)(8676002)(316002)(8936002)(5660300002)(9686003)(336012)(70206006)(82740400003)(2906002)(7696005)(55016002)(186003)(26005)(54906003)(6506007)(53546011)(82310400003)(356005)(966005)(450100002)(47076005)(81166007)(6862004)(86362001)(33656002)(70586007);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2021 00:40:01.4689
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d3de7459-f814-4589-46c7-08d923cca01b
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: AM5EUR03FT048.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0802MB2455
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Matthew Wilcox <willy@infradead.org>
> Sent: Friday, May 28, 2021 11:22 PM
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
> Subject: Re: [PATCH RFCv2 2/3] lib/vsprintf.c: make %pD print full path
> for file
>
> On Fri, May 28, 2021 at 03:09:28PM +0000, Justin He wrote:
> > > I'm not sure why it's so complicated.  p->len records how many bytes
> > > are needed for the entire path; can't you just return -p->len ?
> >
> > prepend_name() will return at the beginning if p->len is <0 in this cas=
e,
> > we can't even get the correct full path size if keep __prepend_path
> unchanged.
> > We need another new helper __prepend_path_size() to get the full path
> size
> > regardless of the negative value p->len.
>
> It's a little hard to follow, based on just the patches.  Is there a
> git tree somewhere of Al's patches that you're based on?

The git tree of Al's patches is at:
https://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git/log/?h=3Dwork.=
d_path

>
> Seems to me that prepend_name() is just fine because it updates p->len
> before returning false:
>
>  static bool prepend_name(struct prepend_buffer *p, const struct qstr
> *name)
>  {
>       const char *dname =3D smp_load_acquire(&name->name); /* ^^^ */
>       u32 dlen =3D READ_ONCE(name->len);
>       char *s;
>
>       p->len -=3D dlen + 1;
>       if (unlikely(p->len < 0))
>               return false;
>
> I think the only change you'd need to make for vsnprintf() is in
> prepend_path():
>
> -             if (!prepend_name(&b, &dentry->d_name))
> -                     break;
> +             prepend_name(&b, &dentry->d_name);
>
> Would that hurt anything else?
I will try your suggestion soon.

>
> > More than that, even the 1st vsnprintf could have _end_ > _buf_ in some
> case:
> > What if printk("%pD", filp) ? The 1st vsnprintf has positive (end-buf).
>
> I don't understand the problem ... if p->len is positive, then you
> succeeded.  if p->len is negative then -p->len is the expected return
> value from vsnprintf().  No?

There are 3 cases I once met in my debugging:
1. p->len is positive but too small (e.g. end-buf is 6). In first prepend_n=
ame
loop p-len-=3Ddlen, then p->len is negative

2. p->len is negative at the very beginning (i.e. end-buf is negative)

3. p->len positive and large enough. Typically the 2nd vsnprintf of printk


--
Cheers,
Justin (Jia He)


IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
