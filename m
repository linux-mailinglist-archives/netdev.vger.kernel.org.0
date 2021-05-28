Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96F363944CA
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 17:09:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235899AbhE1PLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 11:11:20 -0400
Received: from mail-eopbgr80078.outbound.protection.outlook.com ([40.107.8.78]:55022
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230281AbhE1PLR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 May 2021 11:11:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YdfE4j13cYexnGPSLUGMSIUCYmpcipQMGWWnxopef+E=;
 b=KwbCUrVivKg0BlOIiFR+6Y0HtL5cer46shrlPokujSG7vwn9ayqNul6U6py8KwzVyXvZsy+N4Ye68whQFf817/Iy4+B6Kj7KcPeIo5tiumX7kaS9AB6xO/+E8Lsxh2g6CcF1Pjmprfyw5XLrLHG2DxgYxd4qhMbtD9hvoeQACu4=
Received: from PR3P192CA0006.EURP192.PROD.OUTLOOK.COM (2603:10a6:102:56::11)
 by AM0PR08MB5297.eurprd08.prod.outlook.com (2603:10a6:208:18a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Fri, 28 May
 2021 15:09:39 +0000
Received: from VE1EUR03FT053.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:102:56:cafe::ac) by PR3P192CA0006.outlook.office365.com
 (2603:10a6:102:56::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.24 via Frontend
 Transport; Fri, 28 May 2021 15:09:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT053.mail.protection.outlook.com (10.152.19.198) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4150.30 via Frontend Transport; Fri, 28 May 2021 15:09:38 +0000
Received: ("Tessian outbound a5ae8c02e74f:v93"); Fri, 28 May 2021 15:09:38 +0000
X-CR-MTA-TID: 64aa7808
Received: from 280d285b2b6a.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 7D3B7C08-5E1C-4F5E-AAB4-2B4051226F16.1;
        Fri, 28 May 2021 15:09:32 +0000
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id 280d285b2b6a.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Fri, 28 May 2021 15:09:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QONDeJos+aoPXFPwMUlsaktRsGqY5POTBdVSgJVe9Ea+fcKPc5or5KoBpfEzhl5L7UMSHtS3Phs6jOjQJC+hKKAeMRV68Vjvca6HvGoxoF874f4gmDvsRkOr1H4LyN8N1aUWylPgmhEuJie6ROLuUaJLEf4C7JedLKnbdvvI7+haYvvE5VS+eRauWZqk+v/CltRr29fnc0e3Hh9UagMMsWPF5P72rPRtNZrr3LKI/5Jsktvn7tQF4f4LHcS7h/OoQCA+pZ4jzobKJQk69XuyEOYSX3bOJ8reaCr2IBq3L+UvXyaG6cOnrB4Qh3ameK9XlMxBuYyYAEO/5Cx5fCUiTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YdfE4j13cYexnGPSLUGMSIUCYmpcipQMGWWnxopef+E=;
 b=nPyWG7pDDqz8cf5ocwoeLmpeRUD/3f8RPAET6B0AiTBj1dTYFpjHnwLQClF2GqV2nw/7s0EdFKHX7c5WFTwwYppAsYOt2BY6Mty4hSp0JSHfouMjeu1qtuWa5Vl37WdvVMiPM/r5odWneP1R8EBFP4NWlaT/50p7ox6Y+irUHgFLIJ1fTOD802ChBEt93o3U4g53BdXyaG5jeEG6c+E4a40TtqqXTtxL1CQBs8iAFWwvuvxc01e/xeKcv+yN940f/Hw2MtDNk4xPXH8xEcra70pXdfJdFebfU7I53chXrlBPw8oMxnPyq64BXsFHk1LzZqX6Vq3P+cKtHxhxDMjiEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YdfE4j13cYexnGPSLUGMSIUCYmpcipQMGWWnxopef+E=;
 b=KwbCUrVivKg0BlOIiFR+6Y0HtL5cer46shrlPokujSG7vwn9ayqNul6U6py8KwzVyXvZsy+N4Ye68whQFf817/Iy4+B6Kj7KcPeIo5tiumX7kaS9AB6xO/+E8Lsxh2g6CcF1Pjmprfyw5XLrLHG2DxgYxd4qhMbtD9hvoeQACu4=
Received: from AM6PR08MB4376.eurprd08.prod.outlook.com (2603:10a6:20b:bb::21)
 by AM6PR08MB3638.eurprd08.prod.outlook.com (2603:10a6:20b:4b::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.25; Fri, 28 May
 2021 15:09:28 +0000
Received: from AM6PR08MB4376.eurprd08.prod.outlook.com
 ([fe80::18c4:33fd:d055:fe60]) by AM6PR08MB4376.eurprd08.prod.outlook.com
 ([fe80::18c4:33fd:d055:fe60%3]) with mapi id 15.20.4173.021; Fri, 28 May 2021
 15:09:28 +0000
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
Thread-Index: AQHXU7ZL838wopFuOEK5GzAxNom8qqr420gAgAAQ9UCAAA6WAIAAAE0g
Date:   Fri, 28 May 2021 15:09:28 +0000
Message-ID: <AM6PR08MB437615DB6A6DEC33223A3138F7229@AM6PR08MB4376.eurprd08.prod.outlook.com>
References: <20210528113951.6225-1-justin.he@arm.com>
 <20210528113951.6225-3-justin.he@arm.com>
 <YLDpSnV9XBUJq5RU@casper.infradead.org>
 <AM6PR08MB437691E7314C6B774EFED4BDF7229@AM6PR08MB4376.eurprd08.prod.outlook.com>
 <YLEDwFCPcFx+qeul@casper.infradead.org>
In-Reply-To: <YLEDwFCPcFx+qeul@casper.infradead.org>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 7B4DE93170D460498552859C63039929.0
x-checkrecipientchecked: true
Authentication-Results-Original: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=arm.com;
x-originating-ip: [223.166.32.249]
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-Correlation-Id: b6689fdf-d129-421b-3bbf-08d921ea9d27
x-ms-traffictypediagnostic: AM6PR08MB3638:|AM0PR08MB5297:
X-Microsoft-Antispam-PRVS: <AM0PR08MB5297DE7ECFB63ED6B959D09FF7229@AM0PR08MB5297.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:4303;OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: QuHygpZZ82zFWYvK5iFmILLfBYptUEyG8/3EDiHICPUCzGS2VingBtnQsaq4XPFHygwDlVWJbLAmq3i6Wm8ARxwHiJWH2VywCKclvnjmRkealEqnXVmMwIf2mIz0ZNfMmOFG8/esYIFi1IhychEiNj36oG/Pz1w0D6gLzIIa4hRD4zHlYiuymrJrUAJlBi0seZm403iZHU/bMl6RxTxNV+kTRoBR3BpoQCu9sTyrIzjbmGV/scmSTUXcEzUdBvMbuXYuPvhbv49D15y7UqOPvjwH9EkyLJN6xvucck2FxiFfniH9CfWR7lPqeBKo2W1y2EmPXzS5rggkSCy4x6aIDZlExVrgJNGQJB/tl6ohagECYPZp9Ysw6iJB3yoLTLQCUytV6k71dH2Sm9XhPmse/2H+8N8BEe3nx4vAb8M81t3K924Wd7wcYfzQ3S9iIZLz+XUVzNAqG1BvdlpROIAQ4SoN7kavwfbRFCLMBozpBfitXNvPAnKW4t88YWK0EMl2greyk3/JdJCYeloS1UJFIkx+Rjryu85p4vD6I7GUk6j++nttFvuEojoYVNLqA1qwKel9wI/AQCmt5Rcp7UkW/wlRgvyBVBLM6XElTOHieKA=
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB4376.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(376002)(39850400004)(136003)(366004)(9686003)(4326008)(7696005)(71200400001)(53546011)(6506007)(26005)(83380400001)(5660300002)(186003)(55016002)(7416002)(122000001)(54906003)(33656002)(38100700002)(316002)(2906002)(76116006)(478600001)(64756008)(66476007)(66946007)(8676002)(86362001)(6916009)(8936002)(52536014)(66446008)(66556008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?ZrOEXKKHGMKWIDqAAIfHoFrw0OjaBb5Ymr4MzHOhvjQengIw0HucQaaqBhpB?=
 =?us-ascii?Q?uWWpI5lzFucJBx7+Qfm1mZMi/IQLVK1DVFyYu3i3KgezaqkG9pH9FPSiXiCx?=
 =?us-ascii?Q?FvhBTzUQqcQzVgEtCCW31d9wJrYGRESKpxLWNt19lRbG0yaxP5mh/rp/LaX5?=
 =?us-ascii?Q?YsErLmMotOdjbslK2z87Uk+c6sD1Qvkfi6Clr4/2dEZ1Qyi5fwSes30g85OQ?=
 =?us-ascii?Q?vGpefTHB4C6jFe9CVMNLXigPBPCwIhtY8PJFKBY4sLjpguVGTpmNFd7quLLr?=
 =?us-ascii?Q?kTYA/4jqhljhWbtpzHcqKmXU+NCihJY/2Eku5MXIV7TVWkq5ActRABZgmYfp?=
 =?us-ascii?Q?X9kSCe/evOSum9XT7NQTNqhII1VWGUcTb5MI0tKWlsayXc1sODlMXCwDJC4I?=
 =?us-ascii?Q?Tnly6hqLl/9AsnqTc9DnTp9xkXOkkzK/9pGy+Z+dv/oSgEudkZmMmIoXMz7j?=
 =?us-ascii?Q?9e9PuE23KIVLDbmmD9j6QpZfpIRkLfi6I5+BKjet7M6rnnpoWcmXpfPC1jpF?=
 =?us-ascii?Q?wBiOFU/nV0MuTH5PPZaO85TtvyR0g4U7lBt/zGivPEpZGdCbABzlK3lVOywT?=
 =?us-ascii?Q?8h/wAkXG7wwQnnMFI/HvRmZxjirD53Gz/wAfwHyRYbHRLo5E9YeKSYk3V4CL?=
 =?us-ascii?Q?inXxFdoKvviolUPG3StsNoawv5NqjkgLEnFiztY7AMb+TEcgYBnYpHb5c69L?=
 =?us-ascii?Q?4A1D9tDDZpjgH2wgx9HCBXQvOSUKK2zWGBvAEbKcChepOW//HPPDDOR/eRYr?=
 =?us-ascii?Q?weDcg6raZxcnyxnvkcrR90oASeWYlhBx2FWdSNjQGq/6ZXZoN8ofYePdDzyO?=
 =?us-ascii?Q?bRY0+3pSLY+mmN/aAlDFVnnfW/Zv514FWWWi/ZF4hvaXmfETAUn9P1/ddqXE?=
 =?us-ascii?Q?6m7rpqBc3FyuGgLz5L7H+eqhc9hkg+3UWp7PQkuYm4ARBgfQzuet8fIG/i0F?=
 =?us-ascii?Q?C4iYtncKGU1cA7scyeAT8Oxj1WTglAcoWwPe//P2UGLHmG5eGNWJ20SaN3Yf?=
 =?us-ascii?Q?UdxuKBcH/a/rJzceLExXeJklewxG8OPhQ70rsV0cRTBFB4HiB8xi6qkKyfLe?=
 =?us-ascii?Q?6v8jbyDPiW5R7MuhT1Vz/xQ5gnhGSpKWP0FevPlQnE0siuG6cJqFqkyZg9eL?=
 =?us-ascii?Q?FSy/1GAcF3uz9/IseKd9JLbkGF3sNufmmmTrTH/wMbqOqEOP61FfAsJqbLT1?=
 =?us-ascii?Q?sVqHw/xTEP6vdgITKYJCvD3ZktFnIHlI8Gv16Sc0/dSBvawg5UahQyUdBFQ6?=
 =?us-ascii?Q?5mDSzA7jj8xQ3HBLcdXm8cwV5yCxOrco7izF9NaXvxQOMpMJUUD2TvAugQfk?=
 =?us-ascii?Q?RH3uTIFAyjc4DmlpRAiAvIWU?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB3638
Original-Authentication-Results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT053.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 083fb5a5-4da0-4e8b-ac25-08d921ea96e0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RzMRDqnRz6j14C+/Eo2n1i1TuDcp2FMDQD8a3f4/OKymS8qKlV8N96Ia3dIqNCW2oqjorXrj3Kqk5Df86nX7UgLo9E8NYJd7eUbmvIBXKwotrX2QstYAypXyk4B+EghtkAm47EJLsnc6BfqNs+gnci1kDZPuZBLQY7QUDxPuIXnEQl7xmLER6gPmE28qQGa0L7oef89yYMN8eOLi8Bba3/UJhh5TwQ9SzbbRa1nDkHjdjgbWC36h6+Jlhva8axOx/ey9YBE6yw2gjpHQjs6fFzBUPWQTeKsEnDB6Vx3bSRQG2SpmwjTHQCLByze9FTjEd0xbn2cqoj1zuazCBp+MihUonwRSLHIVN8N2sX5EFNQSBs6erbuZvHyR66F4yi66zWYNhhbwoiNs9lySfWx3hSR+XvI4WECWMxm/A1KkU98KYR4LeaUFHqRnzsnldDSlfpzupaPAMwLbPS7uYc+qjD64zzQJIRsv3z0WuF67XkxPjllfuUDIcOBxOwwjOiXMZ4tWfTaS6bmQRgNHO+LkMQRG+J2rRXeybrIAubyLibGq0Eoigw5q24tO1/HzD3FUKRWxlvcru0o+NnZUHgCT3wMObO4IxI+98LmYbPzFnig5tb0AX4xvl6+LIqrL4xt6nGqCdcxOjFRKGtkeCJE/DaVZ2EmugxgEsLuAXFCtK74=
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(396003)(376002)(39850400004)(346002)(136003)(46966006)(36840700001)(52536014)(82310400003)(70586007)(478600001)(5660300002)(7696005)(53546011)(33656002)(6506007)(47076005)(316002)(9686003)(54906003)(70206006)(336012)(186003)(26005)(8676002)(81166007)(450100002)(4326008)(83380400001)(2906002)(8936002)(6862004)(86362001)(36860700001)(82740400003)(55016002)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2021 15:09:38.9284
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b6689fdf-d129-421b-3bbf-08d921ea9d27
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR03FT053.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB5297
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Matthew

> -----Original Message-----
> From: Matthew Wilcox <willy@infradead.org>
> Sent: Friday, May 28, 2021 10:53 PM
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
> On Fri, May 28, 2021 at 02:22:01PM +0000, Justin He wrote:
> > > On Fri, May 28, 2021 at 07:39:50PM +0800, Jia He wrote:
> > > > We have '%pD' for printing a filename. It may not be perfect (by
> > > > default it only prints one component.)
> > > >
> > > > As suggested by Linus at [1]:
> > > > A dentry has a parent, but at the same time, a dentry really does
> > > > inherently have "one name" (and given just the dentry pointers, you
> > > > can't show mount-related parenthood, so in many ways the "show just
> > > > one name" makes sense for "%pd" in ways it doesn't necessarily for
> > > > "%pD"). But while a dentry arguably has that "one primary component=
",
> > > > a _file_ is certainly not exclusively about that last component.
> > > >
> > > > Hence "file_dentry_name()" simply shouldn't use "dentry_name()" at
> all.
> > > > Despite that shared code origin, and despite that similar letter
> > > > choice (lower-vs-upper case), a dentry and a file really are very
> > > > different from a name standpoint.
> > > >
> > > > Here stack space is preferred for file_d_path_name() because it is
> > > > much safer. The stack size 256 is a compromise between stack
> overflow
> > > > and too short full path.
> > >
> > > How is it "safer"?  You already have a buffer passed from the caller.
> > > Are you saying that d_path_fast() might overrun a really small buffer
> > > but won't overrun a 256 byte buffer?
> > No, it won't overrun a 256 byte buf. When the full path size is larger
> than 256, the p->len is < 0 in prepend_name, and this overrun will be
> > dectected in extract_string() with "-ENAMETOOLONG".
> >
> > Each printk contains 2 vsnprintf. vsnprintf() returns the required size
> after formatting the string.
> > 1. vprintk_store() will invoke 1st vsnprintf() will 8 bytes space to ge=
t
> the reserve_size. In this case, the _buf_ could be less than _end_ by
> design.
> > 2. Then it invokes 2nd printk_sprint()->vscnprintf()->vsnprintf() to
> really fill the space.
>
> I think you need to explain _that_ in the commit log, not make some
> nebulous claim of "safer".

Okay

>
> > If we choose the stack space, it can meet above 2 cases.
> >
> > If we pass the parameter like:
> > p =3D d_path_fast(path, buf, end - buf);
> > We need to handle the complicated logic in prepend_name()
> > I have tried this way in local test, the code logic is very complicated
> > and not so graceful.
> > e.g. I need to firstly go through the loop and get the full path size o=
f
> > that file. And then return reserved_size for that 1st vsnprintf
>
> I'm not sure why it's so complicated.  p->len records how many bytes
> are needed for the entire path; can't you just return -p->len ?

prepend_name() will return at the beginning if p->len is <0 in this case,
we can't even get the correct full path size if keep __prepend_path unchang=
ed.
We need another new helper __prepend_path_size() to get the full path size
regardless of the negative value p->len.

More than that, even the 1st vsnprintf could have _end_ > _buf_ in some cas=
e:
What if printk("%pD", filp) ? The 1st vsnprintf has positive (end-buf).

This make things more complicated.

Hope I have described it clearly as above.

--
Cheers,
Justin (Jia He)


IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
