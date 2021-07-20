Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5CF3CF1C3
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 04:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235406AbhGTBXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 21:23:01 -0400
Received: from mail-eopbgr140089.outbound.protection.outlook.com ([40.107.14.89]:41606
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243279AbhGTBWS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Jul 2021 21:22:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZoUtdCTPmV0paQNQeL1C8CpPZAGB6720px7DqtjgVA8=;
 b=CGYZGQOeHpm6ScRmsGIeq3UrciQoiqJqt9wRAoGCVNlx1DpiCtcDzNxs5xZst1b7D4TkK0e2IYoFrVeYhQkXnTLIa5kADLOuXMegUkwEsN6DGzdTIfAu7Ifkpea7/yUjpE9wo37SjRI/L/K0GaAnHw5duF7YyqY6WoWFW1Qrk0c=
Received: from AM5PR0201CA0016.eurprd02.prod.outlook.com
 (2603:10a6:203:3d::26) by AM6PR08MB3990.eurprd08.prod.outlook.com
 (2603:10a6:20b:a3::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.28; Tue, 20 Jul
 2021 02:02:37 +0000
Received: from AM5EUR03FT013.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:203:3d:cafe::5) by AM5PR0201CA0016.outlook.office365.com
 (2603:10a6:203:3d::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend
 Transport; Tue, 20 Jul 2021 02:02:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 AM5EUR03FT013.mail.protection.outlook.com (10.152.16.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4331.21 via Frontend Transport; Tue, 20 Jul 2021 02:02:37 +0000
Received: ("Tessian outbound 57330d0f8f60:v99"); Tue, 20 Jul 2021 02:02:36 +0000
X-CR-MTA-TID: 64aa7808
Received: from af90990270aa.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id 1F840EDF-2D87-43E9-8ACC-89F996C36C44.1;
        Tue, 20 Jul 2021 02:02:30 +0000
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id af90990270aa.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Tue, 20 Jul 2021 02:02:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LNLkdzmwknWj/ZMOlR8ZvV9wLtHs2K/7gfGZCUMzJ9IDDcMQr1rbOQWsKmV+GJqvtH61CTEwvhU93ZQO+b+ptaWgLvuc0lJJ/bVuY7GMbXWxbIU9HvrcpWJ9BlyKbrKiQhne5xVKjWJcbk8pS9dIyLxPCnXK9KeCPhio+aTYw5txMEGlvQ/W6yIep5Z7+WJZpqkV8/jo/05REpfR+C1gNd2iRXDTKp71Nj3/FgfOADjbV2bxMrK/UWyMeZk5per1xn5V1LE0T0g1/17+lCLmPPCSPhdyUx2Xqh3rQxoxoYbY8qHjLuHwqWiaMD2xg0UBGFW9hr1QOOPRomfE88RPqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZoUtdCTPmV0paQNQeL1C8CpPZAGB6720px7DqtjgVA8=;
 b=UkOH/OXwNkgCXXEMWbFraqXez1dgkR83vEL9Y0fEAON4Xi5iZ4LROWyI6X5azn7AarMXfQtG37OzNL4j5bDeSMPAIlxeNieI9Us7nOIw//i50lQAUn/Uimbu+y8ZsX27pRrPOrISg8J13+Cn7Eh0JW7UQaRSd0iK0yoHx024TTfih/bX90FojVG76+P0H+SgdqNbM+0hAOrR4RjsY4lpuONeHvw9Q5cnXexjq6MLU2K5ifVG0ehZqjUdbehIiqi0EHCZD8sjnRc9qdskX3kakInXoCraz0OMkDlP4hJ5qQDFXWDavUMfSixx07NOum5ZAJb1iZF3Wt6hoIGwkn9kqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZoUtdCTPmV0paQNQeL1C8CpPZAGB6720px7DqtjgVA8=;
 b=CGYZGQOeHpm6ScRmsGIeq3UrciQoiqJqt9wRAoGCVNlx1DpiCtcDzNxs5xZst1b7D4TkK0e2IYoFrVeYhQkXnTLIa5kADLOuXMegUkwEsN6DGzdTIfAu7Ifkpea7/yUjpE9wo37SjRI/L/K0GaAnHw5duF7YyqY6WoWFW1Qrk0c=
Received: from AM6PR08MB4376.eurprd08.prod.outlook.com (2603:10a6:20b:bb::21)
 by AS8PR08MB6341.eurprd08.prod.outlook.com (2603:10a6:20b:33f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.29; Tue, 20 Jul
 2021 02:02:26 +0000
Received: from AM6PR08MB4376.eurprd08.prod.outlook.com
 ([fe80::3452:c711:d09a:d8a1]) by AM6PR08MB4376.eurprd08.prod.outlook.com
 ([fe80::3452:c711:d09a:d8a1%5]) with mapi id 15.20.4331.031; Tue, 20 Jul 2021
 02:02:26 +0000
From:   Justin He <Justin.He@arm.com>
To:     Prabhakar Kushwaha <prabhakar.pkin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     Ariel Elior <aelior@marvell.com>,
        "GR-everest-linux-l2@marvell.com" <GR-everest-linux-l2@marvell.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        nd <nd@arm.com>, Shai Malin <malin1024@gmail.com>,
        Shai Malin <smalin@marvell.com>,
        Prabhakar Kushwaha <pkushwaha@marvell.com>
Subject: RE: [PATCH] qed: fix possible unpaired spin_{un}lock_bh in
 _qed_mcp_cmd_and_union()
Thread-Topic: [PATCH] qed: fix possible unpaired spin_{un}lock_bh in
 _qed_mcp_cmd_and_union()
Thread-Index: AQHXeVClyEXp90xYxUyzsooHikRZAqtKIQeAgAApWfCAAB3xAIAAutzQ
Date:   Tue, 20 Jul 2021 02:02:26 +0000
Message-ID: <AM6PR08MB4376CD003BF58F85E0121F39F7E29@AM6PR08MB4376.eurprd08.prod.outlook.com>
References: <20210715080822.14575-1-justin.he@arm.com>
 <CAJ2QiJLWgxw0X8rkMhKgAGgiFS5xhrhMF5Dct_J791Kt-ys7QQ@mail.gmail.com>
 <AM6PR08MB4376894A46B47B024F50FBB3F7E19@AM6PR08MB4376.eurprd08.prod.outlook.com>
 <CAJ2QiJJ8=jkbRVscnXM2m_n2RX2pNdJG4iA3tYiNGDYefb-hjA@mail.gmail.com>
In-Reply-To: <CAJ2QiJJ8=jkbRVscnXM2m_n2RX2pNdJG4iA3tYiNGDYefb-hjA@mail.gmail.com>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-Mentions: davem@davemloft.net
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 20A19A978617C4448F672BF37A439860.0
x-checkrecipientchecked: true
Authentication-Results-Original: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=arm.com;
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-Correlation-Id: b9ce30fe-c341-46d3-d397-08d94b227296
x-ms-traffictypediagnostic: AS8PR08MB6341:|AM6PR08MB3990:
X-Microsoft-Antispam-PRVS: <AM6PR08MB3990A2DD407CC6DDC5DFBF60F7E29@AM6PR08MB3990.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:10000;OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: zl04/J6TVyO6ZnjTXtUu3FFiwrjbbnXMzVI8zJhLcRwUtxJ+cmRTnp0PkF5MtjkEcg7yXdAv35G109dlLgIIXdqk1QeIdw3pNFZUDmvfirsQLwHjAiG7g/GRURixxJI7YlitNnEENCmB7ByEpZvVDsTrxQZ/G0ijBSdsc6kJF8AuOcZwsbwl8gVazqUG9mXFWxMNr9dcSd6ahcR4+7ETBq2P+jmyx7Yaj80/veiw/w25STPg1fQxuB1297l4c9eY1LlA84WupTV385exz8cZzuKh9aXI1qB2zHb38d3Qo1FQYCnKSkqhUk+D4OJAIr7pJpPyE6sLjQc7a7CiBJFX0so0gwByoChSajgTO0xc7kEZHLHDcpTbD/B/wxM9VRd5vMFakByAuZ8/fQc/C9Jeynjhp0qXSsE58M4d7jYWY/9XrKVV67eszKKYBQPht/8yus347hrZ516IqBg6G1CYiioe0IfZbI8DkwiAwon3ZwkZkb04WHP/4bceJKK9VWbKvX0lkcAqs6j8wDyVeREFCe8i9pLHhTkQF7aKTrtG9Off00NcPYaHWvKr3Yd44BHjNSJxD9BL0FlMlCLQN7T2g90A/+41WGD67rGmtQj2pggd3lr8e/IfzdRoC/5CJmnrwkcdTEKmuP5/Ys9Sx8xPmhLbUOFKhH1AiWrJOL3W5+wODpR6P/TMN0jy9lqPcFFSjLXpDhvEhSKXO/bGkA5MJg==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB4376.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(366004)(396003)(136003)(83380400001)(71200400001)(54906003)(478600001)(8936002)(66446008)(2906002)(122000001)(64756008)(186003)(38100700002)(7416002)(52536014)(86362001)(316002)(7696005)(55016002)(76116006)(53546011)(6506007)(66476007)(33656002)(66946007)(4326008)(9686003)(8676002)(26005)(110136005)(66556008)(5660300002)(38070700004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eFJzcGRRSEVQRlI2L004RTF0NWdUemVNYzRzdFpsVTFqOGVwT216SWFjelE0?=
 =?utf-8?B?RElTS2Y5b0pxQVQxZXFFK25YRjBxVkhQcDVsM3F3NHVtRm5EN3ZESUVlQjN5?=
 =?utf-8?B?QmVWMVRoRXRVOWNodC8rL1pJRWxJa0t5ekdJSkdmV2hkR0pSalk0KzZOT1d4?=
 =?utf-8?B?dFhvNmdtWHp6Tlk3d1laUWprRXlWTHk4dlRZNGw2bnRQRkxGdjFLUHZueWZ4?=
 =?utf-8?B?TVRwdzBnelROSjJzMGVhdU5ubUZVZnZRN1hNVnpOSkJzSzl6QitYVDVMM1E4?=
 =?utf-8?B?dXNoTGdlY3U2NFpUU1dRbnpGTThhc2J5Z1NuUG1FNFJFOHNuVHU3NWNzSUxW?=
 =?utf-8?B?NjR0QmNqazQwVWpiUHhCZkRFTWNQZVErR1d6NXRFeVNjY0FidHUySks1K2Vv?=
 =?utf-8?B?a3RQeFhmY3ZqUzZxaWFnb2dsc0JCOVJPUVNuU21mc2VwdUFNdEVOd2xVUUI5?=
 =?utf-8?B?TE1PTWhwUlFiL0J0L3VmenNRMEJFZWFNbERFYmgzSWxmY25KM2xMQ1J2K3lG?=
 =?utf-8?B?b3RuSENUbEQxWFVlQTQ5UnlnbFZva1NDc04vOFg2aEVhM2lWN3hiVTZlSit5?=
 =?utf-8?B?MlZZLzIwNFppK0dJOG55cHJoOGRmblRYNkIweTNhWlNveEF2RXhzOCsvZlFa?=
 =?utf-8?B?ZUlxZU5RQU5LVnJIeUlPZE5HYUI5TUVRQk56dFNqaGc3SHRsZWZ2cFFKL2hY?=
 =?utf-8?B?MDZSNUpiaFVLYkNtNi8vdHdVQStOYU00b05UNXRaRmFRMmNMK05qSVFnaE8z?=
 =?utf-8?B?UWdGcTZWWUN2VHQ5bWhFZi80azNRN2Y5UjVMaml4VEJkM0M1RHVKdVFabEM1?=
 =?utf-8?B?OFRTNEdaWTBENXZiYjZlZmFnRE5BdTh0dmUrQWJ3L1RqalZHaXdwZWhkVXdj?=
 =?utf-8?B?OHhOWnNSWTRoNUJ3c1ZKZjYrRUZmbWgwSmhwTlFVVFZSdHZXdENGWFlTMWtJ?=
 =?utf-8?B?Y0JGYnVWWkFtZ2VzNmZzWS91QmUzM2lqZWx2UWowZm5IT3c2dEFaKzJwaTBE?=
 =?utf-8?B?a3MzWmlTSnBNZEpNR3hTMWVrQ0VLbXJyaGJ2NTBGeCtReHZ4UjJoMXlROHlE?=
 =?utf-8?B?dVVCeVFYc2ZDVmxPQlJaNmRjNkQyUVp0UjBjcjlIZ1NMNm4zNHFjZUcyQ3dX?=
 =?utf-8?B?TnFreXdoSlBkcXFIVGZPSTc5bmo3ZnVZSk1TT0lQY2gzdUxaMDZHQWRFVDNC?=
 =?utf-8?B?ZGJCODcyTmxFaEN1TmEvSm5kcUxZblJ0RXZTZ2hzUEtwYUYyZW92cmJ4eGpI?=
 =?utf-8?B?R2YxK2hITHcxY2ZVVWZha2ZkZVRRQ1Fsemp6SHBQbVNKaG5pWVJ6MCs4eXNY?=
 =?utf-8?B?MS9MMGgwS0wydkxvb25ra2Z6WkI5VGJWTExBWTJVRnFjOGVyMGtJVWhoR1da?=
 =?utf-8?B?NHpDOVY4VXFGYVJ5Z3V2MlE4MkdsNEFYcnpNN044Yk9OUnJKUXJFUTJaOEY4?=
 =?utf-8?B?RGErWExLMS9Oa2liWjlnMCtoTVoySmYrdmlwZ0E3QkRXWHVuUWZteVRlckdY?=
 =?utf-8?B?cjVMNXdoT0ViM0x5ZUpobnB2RVFuZTNPUE1YL1lweG9Fc1VBd3o0a3h2VW03?=
 =?utf-8?B?WmRwK0RSeFBsQWhETVh1eVZqWFVWRFRjMzFyY21RbVJjY093UEJJOUhBQ0dZ?=
 =?utf-8?B?V05Lc0d1UEJXdjZxRk9RTGZBc0oxWEZFaHJLOUtLK1g3Z1dlNEZqN2dsYkd6?=
 =?utf-8?B?ZklNWmhUcHZBRXFnMmMwOE16elB6dVNiNGdnV2t5dDdxWjNkQW5wRmZMd2xY?=
 =?utf-8?Q?G+IejWYU4lKlSekAGBsFbHXN+mNiJyAp0TkZlw5?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6341
Original-Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: AM5EUR03FT013.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 039158d6-1163-4fcf-354b-08d94b226c1a
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B8EwNlZ3WslI1b0Xa9JS1LO3g1l4WkR+hH9GJ0q0IL4wxW85GehQQev9+LrxpRbgzmUAzScKIS+vrx/PlgNgOCv/E7NaODhpogYxJNdknGzFCopn8xR4DGuAciQ5o3NlsXDliZI1+oFgneAgByKOFCBLAdOL8hTOC5uxBBeNC7Ph1DsUzG/I6ektXiJHThGuXYkvNIZSjQHAJeXRzUNFGKg5ffcG5TvcrYOgnxfsOhirMJjxdXfN9Ig9z4mjnB+ATVcuVipCJaAPeyPpqFIZXT8mP+aL26N7xAoR2U5oFN1EGutUjHkSWPEin6yBKxLi78aIMSXZjQLJwYTc7k9bUdkG9iE1SWxf80B5FGTUbLr/2jwKc0W47zYTTRgPX7Kd6d+8jOYctgQHbwOsxdHIGsXmCZmi/+jRH/Ux2bVLqqq5tNS1zigBPG0uBNj02vUD5q1YG33YeZaVPrGgHPKZCUGO9I2oCBRli+1RkIWQfBzm1LiJS4ZMWU+b72wUq4D9fD9j8i0K+MoAIoptA/F1Lw7op3oXFEBa/cfUuUncj98vAiLZPdHSVe6Q4mQ+PcrFOZwuqHYlhaEeZ3S9auxZzSQjhnOyGppcbg8aSnPM0vReWihEQZ1+hFd4GuGZ25IGjrPGfjmIPp8f4cUqrN8Ui5dJ+cNorfHh5Ps9c1S0r7nxaA8/0s53VXWbkSiOcNvnh2FPvmAJdSslPlttyvfg3Q==
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(376002)(39860400002)(396003)(136003)(346002)(36840700001)(46966006)(70206006)(356005)(33656002)(26005)(82740400003)(2906002)(83380400001)(478600001)(8936002)(70586007)(8676002)(82310400003)(9686003)(7696005)(53546011)(55016002)(6506007)(52536014)(5660300002)(107886003)(54906003)(450100002)(4326008)(36860700001)(316002)(81166007)(336012)(186003)(47076005)(110136005)(86362001);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2021 02:02:37.2264
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b9ce30fe-c341-46d3-d397-08d94b227296
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: AM5EUR03FT013.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR08MB3990
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogUHJhYmhha2FyIEt1c2h3
YWhhIDxwcmFiaGFrYXIucGtpbkBnbWFpbC5jb20+DQo+IFNlbnQ6IE1vbmRheSwgSnVseSAxOSwg
MjAyMSAxMDo1MSBQTQ0KPiBUbzogSnVzdGluIEhlIDxKdXN0aW4uSGVAYXJtLmNvbT4NCj4gQ2M6
IEFyaWVsIEVsaW9yIDxhZWxpb3JAbWFydmVsbC5jb20+OyBHUi1ldmVyZXN0LWxpbnV4LWwyQG1h
cnZlbGwuY29tOw0KPiBEYXZpZCBTLiBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBKYWt1
YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPjsNCj4gbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsg
TGludXggS2VybmVsIE1haWxpbmcgTGlzdCA8bGludXgtDQo+IGtlcm5lbEB2Z2VyLmtlcm5lbC5v
cmc+OyBuZCA8bmRAYXJtLmNvbT47IFNoYWkgTWFsaW4gPG1hbGluMTAyNEBnbWFpbC5jb20+Ow0K
PiBTaGFpIE1hbGluIDxzbWFsaW5AbWFydmVsbC5jb20+OyBQcmFiaGFrYXIgS3VzaHdhaGEgPHBr
dXNod2FoYUBtYXJ2ZWxsLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSF0gcWVkOiBmaXggcG9z
c2libGUgdW5wYWlyZWQgc3Bpbl97dW59bG9ja19iaCBpbg0KPiBfcWVkX21jcF9jbWRfYW5kX3Vu
aW9uKCkNCj4gDQo+IEhpIEp1c3RpbiwNCj4gDQo+IE9uIE1vbiwgSnVsIDE5LCAyMDIxIGF0IDY6
NDcgUE0gSnVzdGluIEhlIDxKdXN0aW4uSGVAYXJtLmNvbT4gd3JvdGU6DQo+ID4NCj4gPiBIaSBQ
cmFiaGFrYXINCj4gPg0KPiA+ID4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gPiA+IEZy
b206IFByYWJoYWthciBLdXNod2FoYSA8cHJhYmhha2FyLnBraW5AZ21haWwuY29tPg0KPiA+ID4g
U2VudDogTW9uZGF5LCBKdWx5IDE5LCAyMDIxIDY6MzYgUE0NCj4gPiA+IFRvOiBKdXN0aW4gSGUg
PEp1c3Rpbi5IZUBhcm0uY29tPg0KPiA+ID4gQ2M6IEFyaWVsIEVsaW9yIDxhZWxpb3JAbWFydmVs
bC5jb20+OyBHUi1ldmVyZXN0LWxpbnV4LWwyQG1hcnZlbGwuY29tOw0KPiA+ID4gRGF2aWQgUy4g
TWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0PjsgSmFrdWIgS2ljaW5za2kgPGt1YmFAa2VybmVs
Lm9yZz47DQo+ID4gPiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBMaW51eCBLZXJuZWwgTWFpbGlu
ZyBMaXN0IDxsaW51eC0NCj4gPiA+IGtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc+OyBuZCA8bmRAYXJt
LmNvbT47IFNoYWkgTWFsaW4NCj4gPG1hbGluMTAyNEBnbWFpbC5jb20+Ow0KPiA+ID4gU2hhaSBN
YWxpbiA8c21hbGluQG1hcnZlbGwuY29tPjsgUHJhYmhha2FyIEt1c2h3YWhhDQo+IDxwa3VzaHdh
aGFAbWFydmVsbC5jb20+DQo+ID4gPiBTdWJqZWN0OiBSZTogW1BBVENIXSBxZWQ6IGZpeCBwb3Nz
aWJsZSB1bnBhaXJlZCBzcGluX3t1bn1sb2NrX2JoIGluDQo+ID4gPiBfcWVkX21jcF9jbWRfYW5k
X3VuaW9uKCkNCj4gPiA+DQo+ID4gPiBIaSBKaWEsDQo+ID4gPg0KPiA+ID4gT24gVGh1LCBKdWwg
MTUsIDIwMjEgYXQgMjoyOCBQTSBKaWEgSGUgPGp1c3Rpbi5oZUBhcm0uY29tPiB3cm90ZToNCj4g
PiA+ID4NCj4gPiA+ID4gTGlhamlhbiByZXBvcnRlZCBhIGJ1Z19vbiBoaXQgb24gYSBUaHVuZGVy
WDIgYXJtNjQgc2VydmVyIHdpdGgNCj4gRmFzdExpblENCj4gPiA+ID4gUUw0MTAwMCBldGhlcm5l
dCBjb250cm9sbGVyOg0KPiA+ID4gPiAgQlVHOiBzY2hlZHVsaW5nIHdoaWxlIGF0b21pYzoga3dv
cmtlci8wOjQvNTMxLzB4MDAwMDAyMDANCj4gPiA+ID4gICBbcWVkX3Byb2JlOjQ4OCgpXWh3IHBy
ZXBhcmUgZmFpbGVkDQo+ID4gPiA+ICAga2VybmVsIEJVRyBhdCBtbS92bWFsbG9jLmM6MjM1NSEN
Cj4gPiA+ID4gICBJbnRlcm5hbCBlcnJvcjogT29wcyAtIEJVRzogMCBbIzFdIFNNUA0KPiA+ID4g
PiAgIENQVTogMCBQSUQ6IDUzMSBDb21tOiBrd29ya2VyLzA6NCBUYWludGVkOiBHIFcgNS40LjAt
NzctZ2VuZXJpYw0KPiAjODYtDQo+ID4gPiBVYnVudHUNCj4gPiA+ID4gICBwc3RhdGU6IDAwNDAw
MDA5IChuemN2IGRhaWYgK1BBTiAtVUFPKQ0KPiA+ID4gPiAgQ2FsbCB0cmFjZToNCj4gPiA+ID4g
ICB2dW5tYXArMHg0Yy8weDUwDQo+ID4gPiA+ICAgaW91bm1hcCsweDQ4LzB4NTgNCj4gPiA+ID4g
ICBxZWRfZnJlZV9wY2krMHg2MC8weDgwIFtxZWRdDQo+ID4gPiA+ICAgcWVkX3Byb2JlKzB4MzVj
LzB4Njg4IFtxZWRdDQo+ID4gPiA+ICAgX19xZWRlX3Byb2JlKzB4ODgvMHg1YzggW3FlZGVdDQo+
ID4gPiA+ICAgcWVkZV9wcm9iZSsweDYwLzB4ZTAgW3FlZGVdDQo+ID4gPiA+ICAgbG9jYWxfcGNp
X3Byb2JlKzB4NDgvMHhhMA0KPiA+ID4gPiAgIHdvcmtfZm9yX2NwdV9mbisweDI0LzB4MzgNCj4g
PiA+ID4gICBwcm9jZXNzX29uZV93b3JrKzB4MWQwLzB4NDY4DQo+ID4gPiA+ICAgd29ya2VyX3Ro
cmVhZCsweDIzOC8weDRlMA0KPiA+ID4gPiAgIGt0aHJlYWQrMHhmMC8weDExOA0KPiA+ID4gPiAg
IHJldF9mcm9tX2ZvcmsrMHgxMC8weDE4DQo+ID4gPiA+DQo+ID4gPiA+IEluIHRoaXMgY2FzZSwg
cWVkX2h3X3ByZXBhcmUoKSByZXR1cm5zIGVycm9yIGR1ZSB0byBody9mdyBlcnJvciwgYnV0DQo+
IGluDQo+ID4gPiA+IHRoZW9yeSB3b3JrIHF1ZXVlIHNob3VsZCBiZSBpbiBwcm9jZXNzIGNvbnRl
eHQgaW5zdGVhZCBvZiBpbnRlcnJ1cHQuDQo+ID4gPiA+DQo+ID4gPiA+IFRoZSByb290IGNhdXNl
IG1pZ2h0IGJlIHRoZSB1bnBhaXJlZCBzcGluX3t1bn1sb2NrX2JoKCkgaW4NCj4gPiA+ID4gX3Fl
ZF9tY3BfY21kX2FuZF91bmlvbigpLCB3aGljaCBjYXVzZXMgYm90dG9uIGhhbGYgaXMgZGlzYWJs
ZWQNCj4gPiA+IGluY29ycmVjdGx5Lg0KPiA+ID4gPg0KPiA+ID4gPiBSZXBvcnRlZC1ieTogTGlq
aWFuIFpoYW5nIDxMaWppYW4uWmhhbmdAYXJtLmNvbT4NCj4gPiA+ID4gU2lnbmVkLW9mZi1ieTog
SmlhIEhlIDxqdXN0aW4uaGVAYXJtLmNvbT4NCj4gPiA+ID4gLS0tDQo+ID4gPg0KPiA+ID4gVGhp
cyBwYXRjaCBpcyBhZGRpbmcgYWRkaXRpb25hbCBzcGluX3t1bn1sb2NrX2JoKCkuDQo+ID4gPiBD
YW4geW91IHBsZWFzZSBlbmxpZ2h0ZW4gYWJvdXQgdGhlIGV4YWN0IGZsb3cgY2F1c2luZyB0aGlz
IHVucGFpcmVkDQo+ID4gPiBzcGluX3t1bn1sb2NrX2JoLg0KPiA+ID4NCj4gPiBGb3IgaW5zdGFu
Y2U6DQo+ID4gX3FlZF9tY3BfY21kX2FuZF91bmlvbigpDQo+ID4gICBJbiB3aGlsZSBsb29wDQo+
ID4gICAgIHNwaW5fbG9ja19iaCgpDQo+ID4gICAgIHFlZF9tY3BfaGFzX3BlbmRpbmdfY21kKCkg
KGFzc3VtZSBmYWxzZSksIHdpbGwgYnJlYWsgdGhlIGxvb3ANCj4gDQo+IEkgYWdyZWUgdGlsbCBo
ZXJlLg0KPiANCj4gPiAgIGlmIChjbnQgPj0gbWF4X3JldHJpZXMpIHsNCj4gPiAuLi4NCj4gPiAg
ICAgcmV0dXJuIC1FQUdBSU47IDwtLSBoZXJlIHJldHVybnMgLUVBR0FJTiB3aXRob3V0IGludm9r
aW5nIGJoIHVubG9jaw0KPiA+ICAgfQ0KPiA+DQo+IA0KPiBCZWNhdXNlIG9mIGJyZWFrLCBjbnQg
aGFzIG5vdCBiZWVuIGluY3JlYXNlZC4NCj4gICAgLSBjbnQgaXMgc3RpbGwgbGVzcyB0aGFuIG1h
eF9yZXRyaWVzLg0KPiAgIC0gaWYgKGNudCA+PSBtYXhfcmV0cmllcykgd2lsbCBub3QgYmUgKnRy
dWUqLCBsZWFkaW5nIHRvIHNwaW5fdW5sb2NrX2JoKCkuDQo+IEhlbmNlIHBhaXJpbmcgY29tcGxl
dGVkLg0KDQpTb3JyeSwgaW5kZWVkLiBMZXQgbWUgY2hlY2sgb3RoZXIgcG9zc2liaWxpdGllcy4N
CkBEYXZpZCBTLiBNaWxsZXIgU29ycnkgZm9yIHRoZSBpbmNvbnZlbmllbmNlLCBjb3VsZCB5b3Ug
cGxlYXNlIHJldmVydCBpdA0KaW4gbmV0ZGV2IHRyZWU/DQoNCkFwb2xvZ2llcyBhZ2Fpbi4NCg0K
LS0NCkNoZWVycywNCkp1c3RpbiAoSmlhIEhlKQ0KDQoNCg==
