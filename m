Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 353AE39441C
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 16:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234882AbhE1OXx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 10:23:53 -0400
Received: from mail-eopbgr60044.outbound.protection.outlook.com ([40.107.6.44]:55171
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232146AbhE1OXv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 May 2021 10:23:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hhyGpEG5dv5VlVZPLn7zTKkEQkHfpkLS9Ka3BL6cZmM=;
 b=ERuv8zFrUhjz9DmbDyn/jArHN85g2I+/lf+SG9VTkmsadmM7MLhVE6rGqV/eINweu2b2aewPgGbrk8l1v9DTFl5/Qajmx+DjAMC89YqXXAit59PeGwi8Y3BonkjI6RtSDqX2+fmU9p8olN9ICbpIS+V2WpkfEsHpKxnupKDvzCo=
Received: from PR0P264CA0197.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1f::17)
 by AM6PR08MB4836.eurprd08.prod.outlook.com (2603:10a6:20b:cc::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Fri, 28 May
 2021 14:22:11 +0000
Received: from VE1EUR03FT046.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:100:1f:cafe::24) by PR0P264CA0197.outlook.office365.com
 (2603:10a6:100:1f::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend
 Transport; Fri, 28 May 2021 14:22:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT046.mail.protection.outlook.com (10.152.19.226) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4150.30 via Frontend Transport; Fri, 28 May 2021 14:22:10 +0000
Received: ("Tessian outbound f02dc08cb398:v93"); Fri, 28 May 2021 14:22:10 +0000
X-CR-MTA-TID: 64aa7808
Received: from e832f0144398.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id BE51365D-58DD-41DF-BEB3-2F0CA5E527CA.1;
        Fri, 28 May 2021 14:22:04 +0000
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id e832f0144398.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Fri, 28 May 2021 14:22:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a1s+ij9Bye7Rb012DrjMmOEYhvEmoSddUb5XCp3UNEkyELus9VCKieAkm0WTYKBA1RslUrXZLuEn6XjbKA3XngdZxJr1wqJDPFOwsrhkq658w1oaCJfyBrJpkFdXGWuAeYgK1no07fhBuJ0cWNSsenxPHfLdxc1Go5TIyhV5Xtm9Gkyg0FUNHyqU5iu7x04udlvKUanpph5w6+qzd1XOAXvbzKTrcoyLOFD4SgBCPhg9Pv4k8rydzI/pPwuTGRhUqrIcSSYptreBd+E5P4Gdu3zZ5GUmolLl79eeA5ZfmoODvLRLW0zRV3zk8z0sDfLGPRKM39x2HwGDbnRffbxcyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hhyGpEG5dv5VlVZPLn7zTKkEQkHfpkLS9Ka3BL6cZmM=;
 b=CkNOseYv8+dHLti0zbKBSfy1ujZDSXpOu9u/CS22plFyIR7EaFUe/fXQ+qIU9pzCsNyIkKtSdq03Lj8ZG1EC9XW77HndUvRB+Q3ca9X4mNCGfRsD8g+DXPSD6ZOm22wcMd1apHtXXs9FVxZBQF77Oq6TDjIwnccjk6CDGLcXyhqiLqiR4zXujGpRZVJ4JMn+BQ3CfSPUAp9DzE4k42+5Pech7goOmDXyUaL1hWJX+BQx9J2BLP7JVnEP/evuDOkfKOh93ekBZe7hWs94nWWXf0u99QTKvzMA7CZ649PbaRvTm/+iYfWUHzv8vbKBRmerglh7l8EElRgOHVdHPWn3cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hhyGpEG5dv5VlVZPLn7zTKkEQkHfpkLS9Ka3BL6cZmM=;
 b=ERuv8zFrUhjz9DmbDyn/jArHN85g2I+/lf+SG9VTkmsadmM7MLhVE6rGqV/eINweu2b2aewPgGbrk8l1v9DTFl5/Qajmx+DjAMC89YqXXAit59PeGwi8Y3BonkjI6RtSDqX2+fmU9p8olN9ICbpIS+V2WpkfEsHpKxnupKDvzCo=
Received: from AM6PR08MB4376.eurprd08.prod.outlook.com (2603:10a6:20b:bb::21)
 by AS8PR08MB6456.eurprd08.prod.outlook.com (2603:10a6:20b:336::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Fri, 28 May
 2021 14:22:01 +0000
Received: from AM6PR08MB4376.eurprd08.prod.outlook.com
 ([fe80::18c4:33fd:d055:fe60]) by AM6PR08MB4376.eurprd08.prod.outlook.com
 ([fe80::18c4:33fd:d055:fe60%3]) with mapi id 15.20.4173.021; Fri, 28 May 2021
 14:22:01 +0000
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
Thread-Index: AQHXU7ZL838wopFuOEK5GzAxNom8qqr420gAgAAQ9UA=
Date:   Fri, 28 May 2021 14:22:01 +0000
Message-ID: <AM6PR08MB437691E7314C6B774EFED4BDF7229@AM6PR08MB4376.eurprd08.prod.outlook.com>
References: <20210528113951.6225-1-justin.he@arm.com>
 <20210528113951.6225-3-justin.he@arm.com>
 <YLDpSnV9XBUJq5RU@casper.infradead.org>
In-Reply-To: <YLDpSnV9XBUJq5RU@casper.infradead.org>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: EF4BEE3F0B914B4997FBEADBFF905A7C.0
x-checkrecipientchecked: true
Authentication-Results-Original: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=arm.com;
x-originating-ip: [223.166.32.249]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-Correlation-Id: 7a110562-cd2f-43a5-2e61-08d921e3fba3
x-ms-traffictypediagnostic: AS8PR08MB6456:|AM6PR08MB4836:
X-Microsoft-Antispam-PRVS: <AM6PR08MB48361812049C3E4757BFB83AF7229@AM6PR08MB4836.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:10000;OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: MtOMxqo+kslGiJDTXZ538O9FvY8/WuR5Yrn+erFFlWWGj5W3C5Ahj10N7kFNhrtuixmxvJH/9ox1OjtrNNkzx1aKbUPvz6f6TRrknFbUxs19Ug5DnTNbg4GdHnZZKxUub2xG/kOuaFm77U3+zLj5ziI8KX1OjZzVxxXRVDZI3S+os1gpixHinZI6rucH+ciE6FyPpCS8xPY0IxJw/DKWYk+ObF56B4klpotsc2ZNXqBI8lWSC0oqhcw19LdClq8Ugvpqk+pdFzLNc5Ujc7Mkh5m7HfcDl50RpF9P0hUrrq4gwA55D9SaiaZHyfrko4evI8qkOEqupVndpsDezNcpiX5rhjBwah4xOy17K3cFF3BvuZxARMX4aoLsBPG7bwxU0+i0djc8p4EQayb1kkRBabkxCsXFSmyG2m5ghry70nfhk67BAv33UguT59BElXug6gSz4PvlqPSeCmNVIYJvg9/Uvd/AIn/Bv8zUC/zUsog1dGPfNnyb7si1CWiGKTwse4wzjelMTWHWK1GPW9HGZl6Fo6TmvzjPxvn/lNxjypcNIAWQVq7nDyh+c+6iKJUWxhsBz4rowTsKeWMU79u1MhPSEAJeIZyFYVwqYM5hdx8=
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB4376.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39850400004)(346002)(376002)(366004)(396003)(66556008)(66476007)(64756008)(66946007)(76116006)(316002)(71200400001)(7696005)(52536014)(6916009)(66446008)(54906003)(478600001)(5660300002)(186003)(33656002)(26005)(9686003)(2906002)(83380400001)(55016002)(122000001)(53546011)(6506007)(4326008)(7416002)(86362001)(38100700002)(8936002)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?rdn8ql6ZOTqf3yxIE+mEd0Q0mNeyW/E8gDSmNBwO9K1RyZhzcPhn50DblFEj?=
 =?us-ascii?Q?HXS9ISzYLn9sIfZVgvHm26Z+o0IwPNo8k4EJk7Fj4ZHXNjuGH8k/YOekN0Fj?=
 =?us-ascii?Q?7X/Zk6Fv9E9slH6pCZ3OlQMkIZAhakiwSfqDJ+1pdXYPVSnCZDLU0EgjAgpD?=
 =?us-ascii?Q?cBtV3zuOX1pcINJdMd75yk/QdzGDQ6ljcs2Jnd0H6vIWGrQTIu4tbZR7I40c?=
 =?us-ascii?Q?kl/JnNwV/Cyr6g12AROjZtNQsiI3UrmSN3W9mz1WYop9oOw1Qu2p2bZxnJcz?=
 =?us-ascii?Q?ScVrWKoIVd2OD9GScjwpy0OQ8PJvX+kpBoD6+t1pNx2e+hT9IMdJzOU6MZWS?=
 =?us-ascii?Q?Fq9p6lWiajdD55nQeIX3V3FsFrRqXgrVRnTypKyThST376R1nxM4tjgi+i1H?=
 =?us-ascii?Q?1lpFOVdd8+cXNO2bKnP0hxvRVIi+JeR5JmdDdjW4EHIcPC+vQvFT9JLV+Jdk?=
 =?us-ascii?Q?R2dE1fBhPXupQ8QWJH34v7yRbMVpahEX6U/V5bv0VyheE0AhnWMrNID59N+D?=
 =?us-ascii?Q?XGSwOHpG7l0ZFx34WI8PoUL843urYWVSI1SEDLi5aWKk8u4bah4QSX6R8FuG?=
 =?us-ascii?Q?e+kF/ghMWFl8edC5ZX/f0E9T75tB34XRAEJeCfryNyh196as5wXbqKfS3e5E?=
 =?us-ascii?Q?Wi+3NdspMWqbK2iE6571x24M9rFRn4OgbP4kb1pUdh4ZzdsqPTopkBHujgPN?=
 =?us-ascii?Q?TVaMdyOqqE34lNXzdXV1Qq5U95gX6b5wGv61mm3vIbs5nYyYvPOTvFhNqBdJ?=
 =?us-ascii?Q?I7KcaLpa8Uv6uCF3KNLzWiOorfPixVAArzw3UXnR9eNxEz+NoOAptNi1nYdm?=
 =?us-ascii?Q?myaKvwWSyfl1gjC8D3iy4kjskU58jo+lGUBDtHe5MgL5OdNkGi/IEY+od3bP?=
 =?us-ascii?Q?zld/tBzpfFPF7vRTFF3mDigeXk4ueU6twGMdPjJ96QntwzSa2WogeYIlsoa5?=
 =?us-ascii?Q?mb2lE5mX5NEe90dwguKhilVbtZkpzC7Yl/Bv9IyNl1+W4ZMRwQP1oMNewqoC?=
 =?us-ascii?Q?hxEGsOaq04XUk/9KDlzHXRoQUpay+pA9TDqemVwp3V2r+5RgLX6zpOksE2M7?=
 =?us-ascii?Q?ogZtd3srQ6TdJMm/2l8h7oq5uSQt04D3AIrgGObrKbYHoX2+p2BYXfhblN1H?=
 =?us-ascii?Q?CoryxvGaQoCgAyDmHkmhFxqe+EoIvU+KgOOMpv6EqP+6WcPLk8iRm7LmV8Bi?=
 =?us-ascii?Q?+4t+58NoCiQLBYROOJ8NpSSbcUQ0gXeSYEdcqg8Wt/iQyY/9+H4pliq7YfWW?=
 =?us-ascii?Q?nRibZXfZrOxdgddwZhrpypYWC2erJdHv1uXTzLKwiaC8FZbUrWWCnnmpy/x4?=
 =?us-ascii?Q?UzTVbpcU8cqWToedAr/tE3KH?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6456
Original-Authentication-Results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT046.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 9a3bf014-32b0-4e39-e0ed-08d921e3f5a6
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 32SAZ17yNN30bB61JMIT9YxSAScm9oqMBJz5IzGP0ClHlv6ZeNKStmWZakX1RyPwtgUlMb4PzRYJlztZo55f0QYWH0E2DraXM0fCw0uIltx8YjN6Cg2QEuqY3jTaY0GCWZ1eyhPSZhy3Mp1OLvtxoi3+3LPWA/po+A2QesBR/l2i2aQP0AUtO+ArC6NxFsGBaTgeoyrzZKtKiv6fVPVRjCP3PynuVt4O1d6a7xVg4uZtlsS3xjAZiWw0VgWNHZFeJ3fE0fSe+jnMSeXgM8LYr3gTnh3phOjR++r/TfcmN68B89akd/l3MNsZBrehpjmGgHEOgX8cVd28Evcgb0tXlsiVhCbCPKEdBhtJeDKiWYpK2e5fsV7JP0ZGb9Ko1CBuPNBwbf/8tLh786a2+dGZ59hcWeMOK+zmG6H2tjP2acswQhkola2sGuPelBKQKMFN+5JhzaEqdoaZ5r8/vfx5giOhLe5znSQ1eY/XWO3tr+TTpIZsbpTPKDHPogc/qARALJqNZeGvi7nVlQYtsPbyHnv8nAih17dC7J9ii/ZF5yd9llDEA5Ni0MUap7CdLnJsNcXa5DjutpjU3Vkv6sdZ6FXBerAEkvI7wU/zWgyG1KKXu+SLg1jxR7wb9Cshx14g1CV9Z6SyAxPAu2rFENgkdzm2UouNuy1N2/1UL+xSXL0=
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(376002)(396003)(346002)(39850400004)(136003)(36840700001)(46966006)(478600001)(7696005)(53546011)(83380400001)(82740400003)(26005)(8676002)(316002)(6506007)(186003)(33656002)(8936002)(6862004)(2906002)(54906003)(81166007)(450100002)(336012)(356005)(86362001)(82310400003)(36860700001)(55016002)(5660300002)(52536014)(9686003)(4326008)(70206006)(70586007)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2021 14:22:10.8695
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a110562-cd2f-43a5-2e61-08d921e3fba3
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR03FT046.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB4836
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Matthew
> -----Original Message-----
> From: Matthew Wilcox <willy@infradead.org>
> Sent: Friday, May 28, 2021 9:00 PM
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
> On Fri, May 28, 2021 at 07:39:50PM +0800, Jia He wrote:
> > We have '%pD' for printing a filename. It may not be perfect (by
> > default it only prints one component.)
> >
> > As suggested by Linus at [1]:
> > A dentry has a parent, but at the same time, a dentry really does
> > inherently have "one name" (and given just the dentry pointers, you
> > can't show mount-related parenthood, so in many ways the "show just
> > one name" makes sense for "%pd" in ways it doesn't necessarily for
> > "%pD"). But while a dentry arguably has that "one primary component",
> > a _file_ is certainly not exclusively about that last component.
> >
> > Hence "file_dentry_name()" simply shouldn't use "dentry_name()" at all.
> > Despite that shared code origin, and despite that similar letter
> > choice (lower-vs-upper case), a dentry and a file really are very
> > different from a name standpoint.
> >
> > Here stack space is preferred for file_d_path_name() because it is
> > much safer. The stack size 256 is a compromise between stack overflow
> > and too short full path.
>
> How is it "safer"?  You already have a buffer passed from the caller.
> Are you saying that d_path_fast() might overrun a really small buffer
> but won't overrun a 256 byte buffer?
No, it won't overrun a 256 byte buf. When the full path size is larger than=
 256, the p->len is < 0 in prepend_name, and this overrun will be
dectected in extract_string() with "-ENAMETOOLONG".

Each printk contains 2 vsnprintf. vsnprintf() returns the required size aft=
er formatting the string.
1. vprintk_store() will invoke 1st vsnprintf() will 8 bytes space to get th=
e reserve_size. In this case, the _buf_ could be less than _end_ by design.
2. Then it invokes 2nd printk_sprint()->vscnprintf()->vsnprintf() to really=
 fill the space.

If we choose the stack space, it can meet above 2 cases.

If we pass the parameter like:
p =3D d_path_fast(path, buf, end - buf);
We need to handle the complicated logic in prepend_name()
I have tried this way in local test, the code logic is very complicated
and not so graceful.
e.g. I need to firstly go through the loop and get the full path size of
that file. And then return reserved_size for that 1st vsnprintf

Thanks for any suggestion

--
Cheers,
Justin (Jia He)

IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
