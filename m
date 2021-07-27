Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B9D43D76B0
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 15:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237136AbhG0Na6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 09:30:58 -0400
Received: from mail-eopbgr130070.outbound.protection.outlook.com ([40.107.13.70]:1764
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236745AbhG0Naj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 09:30:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YD+sAg6ojCkLqxWdHQPXgiMVvFzxNn+DzNZb1ELKyAc=;
 b=aRiI4aEb66Gos0ftrrBjPHObmcFyXmrmxb/p5r0s/hmazanXrvFKU7rm0rRmCxNIm09VZ9F+6CDgKANsw81zjqtvyj8CaupvQQwfq/rro2Gdty6qQWB3TcNhrATvUxYaugdPoR26vGnJ3sLMqy+GcdYmH9s3u1zsK5JmDqhVQRE=
Received: from AM5PR0301CA0019.eurprd03.prod.outlook.com
 (2603:10a6:206:14::32) by DBBPR08MB6011.eurprd08.prod.outlook.com
 (2603:10a6:10:209::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25; Tue, 27 Jul
 2021 13:30:30 +0000
Received: from VE1EUR03FT011.eop-EUR03.prod.protection.outlook.com
 (2603:10a6:206:14:cafe::1) by AM5PR0301CA0019.outlook.office365.com
 (2603:10a6:206:14::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25 via Frontend
 Transport; Tue, 27 Jul 2021 13:30:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 63.35.35.123)
 smtp.mailfrom=arm.com; vger.kernel.org; dkim=pass (signature was verified)
 header.d=armh.onmicrosoft.com;vger.kernel.org; dmarc=pass action=none
 header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 63.35.35.123 as permitted sender) receiver=protection.outlook.com;
 client-ip=63.35.35.123; helo=64aa7808-outbound-1.mta.getcheckrecipient.com;
Received: from 64aa7808-outbound-1.mta.getcheckrecipient.com (63.35.35.123) by
 VE1EUR03FT011.mail.protection.outlook.com (10.152.18.134) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4352.24 via Frontend Transport; Tue, 27 Jul 2021 13:30:29 +0000
Received: ("Tessian outbound 4c02392472aa:v100"); Tue, 27 Jul 2021 13:30:29 +0000
X-CR-MTA-TID: 64aa7808
Received: from ff0661555cf2.1
        by 64aa7808-outbound-1.mta.getcheckrecipient.com id DD128642-76B6-43C5-9A83-9D9B7F576C69.1;
        Tue, 27 Jul 2021 13:30:19 +0000
Received: from EUR02-HE1-obe.outbound.protection.outlook.com
    by 64aa7808-outbound-1.mta.getcheckrecipient.com with ESMTPS id ff0661555cf2.1
    (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384);
    Tue, 27 Jul 2021 13:30:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WX0czxxoCpuutBZRvZuTa1ZJzF2KCL984GJGvJXfgd8QVU3Abn0QmWw7p7cle5Msz51UBsIJV/zMYtfFBx/tjzcaLRxWWL+0phw4u09y4t+kavmNawtZ0IRTUF9j3lWw+HA6fM/NCAps93N997wX/SgO6/yWMa6pAqzCcdOTkrJJeGFebtEZx6HTrU4kgCjJZCBUuBD3V9kiQcyHJF/MlcTyitOtj9Uv9Cp/+Mh4glcqX4Xhq1mJwyEP/UkY5r7sw1I22h7GTimKo68DyWcBcW4Dp26PPtiuBcdn/0pzKjjq/4zMVY69pSfeu5n+oz46kqp6TjKHjMEJ/xs1iBu/wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YD+sAg6ojCkLqxWdHQPXgiMVvFzxNn+DzNZb1ELKyAc=;
 b=hFLU9hnsSUg1oiLj/4B/kJEaaOrG9IChETQ/vsjsuDnrgnGi+drYG1jjEC7qRLT5hxSF8HR0l+6TZXB1O1gmJIH2+srADlmcJvgFvqHPv63ZIEbNEehWkRVuE+LzLYwVYmavoM6RkiwgYI9mzTvnt54Y0qS6bs3O/g4bba65QRD7PKHZzd4igf/2gMSIU0oOHeOZwwO6NQFwCG2LZiphlRidxcTKkq7ry46SdFPrp5bdWqE2h8uE2yCM+CvjjkmOQtv8ZmmVhs7YjRZJ1O+F6m+704dy5eL3PR+HoqC1ZNiEzc5R3cS+bbgmsr49cOKVzdAHtYZBO+SqDfms+pqsIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=armh.onmicrosoft.com;
 s=selector2-armh-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YD+sAg6ojCkLqxWdHQPXgiMVvFzxNn+DzNZb1ELKyAc=;
 b=aRiI4aEb66Gos0ftrrBjPHObmcFyXmrmxb/p5r0s/hmazanXrvFKU7rm0rRmCxNIm09VZ9F+6CDgKANsw81zjqtvyj8CaupvQQwfq/rro2Gdty6qQWB3TcNhrATvUxYaugdPoR26vGnJ3sLMqy+GcdYmH9s3u1zsK5JmDqhVQRE=
Received: from AM6PR08MB4376.eurprd08.prod.outlook.com (2603:10a6:20b:bb::21)
 by AS8PR08MB6993.eurprd08.prod.outlook.com (2603:10a6:20b:34a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.28; Tue, 27 Jul
 2021 13:30:15 +0000
Received: from AM6PR08MB4376.eurprd08.prod.outlook.com
 ([fe80::3452:c711:d09a:d8a1]) by AM6PR08MB4376.eurprd08.prod.outlook.com
 ([fe80::3452:c711:d09a:d8a1%5]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 13:30:15 +0000
From:   Justin He <Justin.He@arm.com>
To:     Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     Lijian Zhang <Lijian.Zhang@arm.com>,
        "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH AUTOSEL 5.13 09/21] qed: fix possible unpaired
 spin_{un}lock_bh in _qed_mcp_cmd_and_union()
Thread-Topic: [PATCH AUTOSEL 5.13 09/21] qed: fix possible unpaired
 spin_{un}lock_bh in _qed_mcp_cmd_and_union()
Thread-Index: AQHXguoQtq+K8SE5PUupjSdhtFP5gqtW0Hww
Date:   Tue, 27 Jul 2021 13:30:15 +0000
Message-ID: <AM6PR08MB4376DF5C31C64EBFCB0276ECF7E99@AM6PR08MB4376.eurprd08.prod.outlook.com>
References: <20210727131908.834086-1-sashal@kernel.org>
 <20210727131908.834086-9-sashal@kernel.org>
In-Reply-To: <20210727131908.834086-9-sashal@kernel.org>
Accept-Language: en-US, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ts-tracking-id: 102F9BF951C6D2498A75B9B4F54F2433.0
x-checkrecipientchecked: true
Authentication-Results-Original: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
x-ms-publictraffictype: Email
X-MS-Office365-Filtering-Correlation-Id: e66841f1-3b5c-4fba-cd45-08d95102b3cb
x-ms-traffictypediagnostic: AS8PR08MB6993:|DBBPR08MB6011:
x-ms-exchange-transport-forked: True
X-Microsoft-Antispam-PRVS: <DBBPR08MB60112E0EF69377B4A41ECD8EF7E99@DBBPR08MB6011.eurprd08.prod.outlook.com>
x-checkrecipientrouted: true
nodisclaimer: true
x-ms-oob-tlc-oobclassifiers: OLM:9508;OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;
X-Microsoft-Antispam-Message-Info-Original: uK3flb1pQwsbLtpsdoLQgQz9S4+60PdpPswV8CPdoRpDX2yffa6VYmQS+XyUcK+mx8WxnuAxB1yw+7sFwGD5ameTCqeX9Z+CJ0erhqr4fa6u3iphWj7JN2dIYaq86gw3Vvmqb6t3x3lgy2hNqwby4ckfl2ixOSPBNj1kXAJBDPaFf9gm67YOti9Q9wtRMJo/K3AP3xWthC3YwzeO6q9q6v7YUNZXW6PSkyaK5U3poLRdl/WPHHyo6F1uICEYq5bn7AJjyxsztE8+cYy8JEcF0ZUb6dSJJP5Gm+jZYch3eYTBlsjnqnr/8JYUjygLk4TzpFLgcVIoPN0MHXekVsYtP97kZEgEqbVJ8TJYcat8mTChdiV/7f6CMdZ7jQg3mixLt/j5L1JT04OPsERasex7MHaDmJjTv8ncQLT6jvypvOjd1W4/QF6rf+KYAh9D/KcsUY3rkMHvk5G3RdYbG+LyNc4kFmSlH1uih4Jb7ygTFKInyt7jjQU6MayRtxVgP/2sPCJigjGzeLvize+E134rO88SthpNzGW3hf3EIG1PIhntJBFV1wBjaZXxEpS+r/lHsb3xu25nNWX1s2q0qeoPZYm3PaUJXAe8W9cwhvYMw63v+fcmSzOXQVpatpA1tkESERi3j5JXsbSIxSzolcEhR8FCSvJhNjEWHzUuxGdnyEQWD4eeOVO1HB1k0XK8lAoa31phIu3RplTm6oJagNgBbw==
X-Forefront-Antispam-Report-Untrusted: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB4376.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(366004)(39830400003)(396003)(376002)(6506007)(66446008)(66476007)(66946007)(9686003)(5660300002)(8676002)(53546011)(110136005)(86362001)(76116006)(8936002)(186003)(316002)(26005)(33656002)(83380400001)(4326008)(7696005)(55016002)(52536014)(71200400001)(54906003)(122000001)(66556008)(478600001)(2906002)(64756008)(38100700002)(38070700004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?zGYc9t4q8FUVRX+xDwPCJLcvxB2RZEirwbLiD2lVgYo/y7UdhgnKsIftNR1V?=
 =?us-ascii?Q?gTWLCY/HhMaZDwaDSP2wji4w2qzJ7Tr1IT0U2QMoSUyz/KTnaZ+/bD0mPPzj?=
 =?us-ascii?Q?V2ESqF4Er2VTWuSM1CZDMXuBu0RoxPBR68BOK4B0yHv+4vy6gflO4lZp7BGg?=
 =?us-ascii?Q?vt+6UkH+F6xy9vGvZ6jDKRkJyraAq/o8Y+vP7Il6cRKtchFnvygGvSAPzaX1?=
 =?us-ascii?Q?u1cRmriwvhzrOAlOM6YFBty+4sIg9u6gunt9j4kAKoNpj+HE4/qmeyEYLowK?=
 =?us-ascii?Q?qSk8ds4zjcsD94cuM5vAlCB2+O3bjZNJyNniz/qqSWqBtxW5l0/iElRNg0mF?=
 =?us-ascii?Q?c704zFo8iQXfgLPYWBF7gMCH6oN9LrfV9qMUDyy8UXAJUZuHJQro91JgtgEY?=
 =?us-ascii?Q?ypuDm1gH8Kz1Yz49WLlqxdMZrIUUJDQjvcyq37XzxX4F6TRuSuiuEX2Wiqee?=
 =?us-ascii?Q?SI1snnW0Y/dAhrug9nQSSQ5jwlIxUAMTJeKyhXBjTkzfRbZdSqgvuJ63GW+O?=
 =?us-ascii?Q?yQH5uzfJRrApDrayZnvjyiaoIGNlD1CSjdw1dK7m4tSsT2r4/SAIuW0v08g4?=
 =?us-ascii?Q?1vGhOVziH7fVl13MJ1U+Zo/drxPMukc99rG0jklVTPyw8Do35ipYIu+ro+2d?=
 =?us-ascii?Q?dFkLjTtbORvzKxgVsyjftx3prPrE3FlnQ/18APy2SPp5X11AohJVwdwt0oCr?=
 =?us-ascii?Q?XDQfv7j/chV//hY5l8vT4+WfmgejxjqosE54X1cIFjS13h/8YjWP0jdQROM6?=
 =?us-ascii?Q?/uCMvld1z6tO4QqZyYdKD6XG/TrSBpHjUDYkxH3pcItmzfYiCMikw0ZCBYxu?=
 =?us-ascii?Q?9rUq81Of4ufUBolp8xuFVJHGXhrOkrEi5tJhpSLgKnZRUQfE3PRBXFh6QDDV?=
 =?us-ascii?Q?VG8aPu/g+Gtr6laGA64GiVnbM2OzQw66FMEnoOMVTu8nM9IUs5fmdhSvIb+5?=
 =?us-ascii?Q?jvZpJ95rEn9R+DYmr4qm5/PjVMrve5jvpPGfpBpYq6Gg5nHmYSVi7BDjPm5v?=
 =?us-ascii?Q?YvYsmQiyoz5oXuJ+J5I62ILrRpIzAGMnmI5KBg4tJTEWzjXt2SyuGTankgmp?=
 =?us-ascii?Q?ozeorx4MnhfM5jtxf+qBbJ4SmyHtHTmgI6ockqMuNdtHnUzjxqpyJMU2I0RV?=
 =?us-ascii?Q?Bxynqw2FYhv699atCGbBKcXTGGLyDW5C8Vs6ruxCDuyMoEsIyDYGDRdxEwBl?=
 =?us-ascii?Q?efXEMhqzr/SEoQs767ZmjSnAU6nZTQJSmxtvUZDqPu/jKr5fzuP51HWlHzE1?=
 =?us-ascii?Q?nW6X8UOIYIvcuF+z9PccjzIVA9wySPqSiYfCp/wepsdOuqaroCR54mv0zq6s?=
 =?us-ascii?Q?Lx+S57pRSa4kPLZ5uJLd+88t?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6993
Original-Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=arm.com;
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped: VE1EUR03FT011.eop-EUR03.prod.protection.outlook.com
X-MS-Office365-Filtering-Correlation-Id-Prvs: 5537b79b-d144-4741-fe51-08d95102ab8c
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rULxXKv7JkywitE88SeJpIGR0TooXS9tExn0saAAKn/Sj3DHnP8s3Alv0V8EDByG5jYr/e32HW5970BwUSUruznATiG18GySC7KJf8o+aIExQSjavcrervU1RNroXasLJRk8+qok1osjd+6Qffoj3g4hkbjOvedwq6E4FA0M5Q6ea/8FEl0QIf9rZw8UlZ+Elu5eXXUNxho13wNnOhfM66Lu1gR1XOliJdtao6KNjZkGNHIl7oBRFn+mrM2B/PWqj6mhqFeppFPe7DqrtzuIAwoSE0SxXdUj5zxPRyA+LIOfh/MCLAC0v0Svk2Puq1cOig/RE4hLfhcXPbR5JkQFzTch3Yt7GsjE1F9BoVArtpdnley5yr9IB+jlWP44utC8K9qgmVX9witCC88j3Qw+dDSklwU6k0gjSKNsP3ytfCJrX8epVfCu0fp/blWhYSAhLBqNRHP67XqwshgnhvNTiOKhJ/stoc2dBO1IAwAYiq9p8JpyjeKIArJpeyNGgjXkh8iODb/KPFDUiseGlSWUCqImWLGfTeefVhqwqQluF1TuyVrYU7TM+T4/Xdru6/7o7HIC09oAQAtLTZ30ea1m1XbPtoCVJZg/ap8wJt6RDGCUsosl2/5fSgcJMTyxG/ZQAd7SdVbr6gON9Sd83LiQvzQrEECMPg9O1X8gwvUOEI9cVh8/u/nwVYEc9DxvjmyNTeLLOqDiY5YlNxma5Iw1mQ==
X-Forefront-Antispam-Report: CIP:63.35.35.123;CTRY:IE;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:64aa7808-outbound-1.mta.getcheckrecipient.com;PTR:ec2-63-35-35-123.eu-west-1.compute.amazonaws.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(2906002)(6506007)(53546011)(70206006)(508600001)(70586007)(9686003)(450100002)(8936002)(82310400003)(55016002)(356005)(86362001)(8676002)(7696005)(186003)(52536014)(36860700001)(4326008)(5660300002)(110136005)(54906003)(33656002)(316002)(26005)(336012)(81166007)(83380400001)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 13:30:29.5949
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e66841f1-3b5c-4fba-cd45-08d95102b3cb
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[63.35.35.123];Helo=[64aa7808-outbound-1.mta.getcheckrecipient.com]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR03FT011.eop-EUR03.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB6011
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Sasha

> -----Original Message-----
> From: Sasha Levin <sashal@kernel.org>
> Sent: Tuesday, July 27, 2021 9:19 PM
> To: linux-kernel@vger.kernel.org; stable@vger.kernel.org
> Cc: Justin He <Justin.He@arm.com>; Lijian Zhang <Lijian.Zhang@arm.com>;
> David S . Miller <davem@davemloft.net>; Sasha Levin <sashal@kernel.org>;
> netdev@vger.kernel.org
> Subject: [PATCH AUTOSEL 5.13 09/21] qed: fix possible unpaired
> spin_{un}lock_bh in _qed_mcp_cmd_and_union()
>
> From: Jia He <justin.he@arm.com>
If possible, please stop taking this commit to any stable version because
it has been reverted by later commit.

This patch is harmless but pointless.

Sorry for the inconvenience.

--
Cheers,
Justin (Jia He)


>
> [ Upstream commit 6206b7981a36476f4695d661ae139f7db36a802d ]
>
> Liajian reported a bug_on hit on a ThunderX2 arm64 server with FastLinQ
> QL41000 ethernet controller:
>  BUG: scheduling while atomic: kworker/0:4/531/0x00000200
>   [qed_probe:488()]hw prepare failed
>   kernel BUG at mm/vmalloc.c:2355!
>   Internal error: Oops - BUG: 0 [#1] SMP
>   CPU: 0 PID: 531 Comm: kworker/0:4 Tainted: G W 5.4.0-77-generic #86-
> Ubuntu
>   pstate: 00400009 (nzcv daif +PAN -UAO)
>  Call trace:
>   vunmap+0x4c/0x50
>   iounmap+0x48/0x58
>   qed_free_pci+0x60/0x80 [qed]
>   qed_probe+0x35c/0x688 [qed]
>   __qede_probe+0x88/0x5c8 [qede]
>   qede_probe+0x60/0xe0 [qede]
>   local_pci_probe+0x48/0xa0
>   work_for_cpu_fn+0x24/0x38
>   process_one_work+0x1d0/0x468
>   worker_thread+0x238/0x4e0
>   kthread+0xf0/0x118
>   ret_from_fork+0x10/0x18
>
> In this case, qed_hw_prepare() returns error due to hw/fw error, but in
> theory work queue should be in process context instead of interrupt.
>
> The root cause might be the unpaired spin_{un}lock_bh() in
> _qed_mcp_cmd_and_union(), which causes botton half is disabled incorrectl=
y.
>
> Reported-by: Lijian Zhang <Lijian.Zhang@arm.com>
> Signed-off-by: Jia He <justin.he@arm.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/net/ethernet/qlogic/qed/qed_mcp.c | 23 +++++++++++++++++------
>  1 file changed, 17 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/net/ethernet/qlogic/qed/qed_mcp.c
> b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
> index cd882c453394..caeef25c89bb 100644
> --- a/drivers/net/ethernet/qlogic/qed/qed_mcp.c
> +++ b/drivers/net/ethernet/qlogic/qed/qed_mcp.c
> @@ -474,14 +474,18 @@ _qed_mcp_cmd_and_union(struct qed_hwfn *p_hwfn,
>
>               spin_lock_bh(&p_hwfn->mcp_info->cmd_lock);
>
> -             if (!qed_mcp_has_pending_cmd(p_hwfn))
> +             if (!qed_mcp_has_pending_cmd(p_hwfn)) {
> +                     spin_unlock_bh(&p_hwfn->mcp_info->cmd_lock);
>                       break;
> +             }
>
>               rc =3D qed_mcp_update_pending_cmd(p_hwfn, p_ptt);
> -             if (!rc)
> +             if (!rc) {
> +                     spin_unlock_bh(&p_hwfn->mcp_info->cmd_lock);
>                       break;
> -             else if (rc !=3D -EAGAIN)
> +             } else if (rc !=3D -EAGAIN) {
>                       goto err;
> +             }
>
>               spin_unlock_bh(&p_hwfn->mcp_info->cmd_lock);
>
> @@ -498,6 +502,8 @@ _qed_mcp_cmd_and_union(struct qed_hwfn *p_hwfn,
>               return -EAGAIN;
>       }
>
> +     spin_lock_bh(&p_hwfn->mcp_info->cmd_lock);
> +
>       /* Send the mailbox command */
>       qed_mcp_reread_offsets(p_hwfn, p_ptt);
>       seq_num =3D ++p_hwfn->mcp_info->drv_mb_seq;
> @@ -524,14 +530,18 @@ _qed_mcp_cmd_and_union(struct qed_hwfn *p_hwfn,
>
>               spin_lock_bh(&p_hwfn->mcp_info->cmd_lock);
>
> -             if (p_cmd_elem->b_is_completed)
> +             if (p_cmd_elem->b_is_completed) {
> +                     spin_unlock_bh(&p_hwfn->mcp_info->cmd_lock);
>                       break;
> +             }
>
>               rc =3D qed_mcp_update_pending_cmd(p_hwfn, p_ptt);
> -             if (!rc)
> +             if (!rc) {
> +                     spin_unlock_bh(&p_hwfn->mcp_info->cmd_lock);
>                       break;
> -             else if (rc !=3D -EAGAIN)
> +             } else if (rc !=3D -EAGAIN) {
>                       goto err;
> +             }
>
>               spin_unlock_bh(&p_hwfn->mcp_info->cmd_lock);
>       } while (++cnt < max_retries);
> @@ -554,6 +564,7 @@ _qed_mcp_cmd_and_union(struct qed_hwfn *p_hwfn,
>               return -EAGAIN;
>       }
>
> +     spin_lock_bh(&p_hwfn->mcp_info->cmd_lock);
>       qed_mcp_cmd_del_elem(p_hwfn, p_cmd_elem);
>       spin_unlock_bh(&p_hwfn->mcp_info->cmd_lock);
>
> --
> 2.30.2

IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
