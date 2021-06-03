Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB58399FA6
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 13:18:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbhFCLUA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 07:20:00 -0400
Received: from mail-bn8nam11on2081.outbound.protection.outlook.com ([40.107.236.81]:13761
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229764AbhFCLTc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 07:19:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ToEwRs2l/Ypm4bx2zCGMqwpsJqqpdXn1M59aVNwonk4/dP5jnPVdy8/yt5+d70JOgdHH5fZycTV0YenaTASDbhLYpCjsKcJKEJD2C0AVDvNfftSx84vPIcs8pTxsY1x90zhZQdvxhWFQPg8qnOzgUqjLfivgU3j5+XXPHi9aupikbNlp4g5HBRx69BvIVPNGVSBgSrYH3xroahwlHlo4f44l0HOORuZLbWGMD1VO75+jDjD0YRujyrWsKBIBJtvqPsxoeFqjWeaoGcl53jc9O36H0ESy7yeWqvW1qHqYr6sdcsyKbWElTwI+RqXgKs1j4vU7OToJCE3VLcWUwctloQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y662K0wmZrvw8FvIPZyRqHfGj3aPm+cFBzFJCW5E7Dw=;
 b=ZKkuUwnEekuOtpJCuHP6wWm44xZdd3ijDWHIwGNtmwQ+BjBy5xA+i6jJDVRJx3KKGvBIlyEOuLf+IpIV28EmyPO0/lPRpf/qwzJTbvj1+Lwna+Vk3pheP8/JP3ExWRNPBA0+WvTgNVnM/C0CMwZBwuc9yJl/4BAuJQEgd06rGKa44tG4liB4JjtMfwT7cpFSgxuv+uoALnM1vYzY/TBPvrO+KZAcFJt2hrwieqcmw9Wmf5R+N0h1ZPnRtvXFAvcElX7tfohADOIdVmoF85lan3H7yrO5kbBTx/fCdPKJbZ5n0XGLNjPKBTk5QjnxCZJ7CDos4STuLfodzvWH7o7HZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y662K0wmZrvw8FvIPZyRqHfGj3aPm+cFBzFJCW5E7Dw=;
 b=Vv1ldjqxqJptFUEbnGxKSwbXthIRau5BZc940YZ+SXw6/f0Imfr0WnU27Id7wUicNli1sLtKdgcTHataHBrGv4TZ1jg47X4qdcL8EBXil3ZKXd7HI6sstepm5vltYezVuNGRujJAiX9aYnren2MS5RR8BAO3FzlMmt7oWckUB+pTgfOfixOzbYEouGZwnrpsiGbQTyBScFvRKWf1ctKfwAWCuED0LiGeKNm2LNuz0H+K22n51/8SoBzKayu3XpzpYF6Z+OFIy31CEW3UZOhoIR4Se9GiEOOj3S8azy1yGYDN7L4n/vAzO1yq/vmT6WPUJBzwNmXeQqfZmlpAsh09jA==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by PH0PR12MB5452.namprd12.prod.outlook.com (2603:10b6:510:d7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.29; Thu, 3 Jun
 2021 11:17:46 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::b0d9:bff5:2fbf:b344]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::b0d9:bff5:2fbf:b344%6]) with mapi id 15.20.4195.023; Thu, 3 Jun 2021
 11:17:46 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     "dsahern@gmail.com" <dsahern@gmail.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Jiri Pirko <jiri@nvidia.com>
Subject: RE: [PATCH iproute2-next internal] devlink: Add optional controller
 user input
Thread-Topic: [PATCH iproute2-next internal] devlink: Add optional controller
 user input
Thread-Index: AQHXWGnknjTcaCBuUke3MSjwm9jdkasCIxyg
Date:   Thu, 3 Jun 2021 11:17:46 +0000
Message-ID: <PH0PR12MB54811D062A746EF4E0A6614DDC3C9@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20210603111603.9822-1-parav@nvidia.com>
In-Reply-To: <20210603111603.9822-1-parav@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.207.167]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c1faa91a-4d32-4047-749f-08d926813731
x-ms-traffictypediagnostic: PH0PR12MB5452:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR12MB5452F0FC8ADE4C63D0159551DC3C9@PH0PR12MB5452.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /X9IqQSyoS4PWFJb/hrx3WqSWX4FNQEMwl6l43PUgaU9XGWrafCv4UjsQumtBQKM3Gxp6Y6oj7uRsBzPR7Fo3HptflGCPQzRrQuhPTWYnhbdSVXubWnf1HzaJvYqBtNbmIXprstxA9Y9e7OBiJcyTSvJF3rjfmP5pOYHRDorpRqIP9nHN4NC5+d++RsactB8GWhGYStnkptjyUXI/hfhOz7D3qSC7ruykVKY6oDwTUaSKDbC3tQkxaHnnUU33STgfX1mqBSqf5ncpDeDFbELtxjXqolgT3g+ktxlNZii4XnMzajQMPbkJKzQHpcOplVenYh4G0IaCjFJ1kJNWHtlEPHb8+/f4mCSTlGR1i5NsfKobENr7j/M9TxuEJckf09uMOgp4L7jJvfVU1cU7IqthktHEzvyEjJGcWYw52LPx8vyDUCBz7mJ2K5JrB4RY8XM/wDK6zZyaQua1tkFLFLCEDR178o7vGR822g5e41aGZCt2O1vjGq3jsvOkw78NAlMjGg5ZWMt+7oW1fPnVio9gRrOYEMHyIk+80GPxYZL1avK2kUI1y2Dy7NQJNpbQAvJBvomYILyJoqswbW3yfZ2KRUZtyoM+7MxKeo39sYg/y8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(376002)(39860400002)(136003)(346002)(8936002)(4744005)(55016002)(66946007)(2906002)(7696005)(86362001)(9686003)(38100700002)(26005)(53546011)(55236004)(478600001)(5660300002)(33656002)(4326008)(8676002)(66446008)(122000001)(6506007)(64756008)(66556008)(66476007)(186003)(107886003)(316002)(110136005)(76116006)(71200400001)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?BzlmrqmhCKAHYlwspmlyGAEHP/y5QvI3iWpzrUhEcnB4sJMYmRuwziZhxjwD?=
 =?us-ascii?Q?MtX96xgkYVPm+NLSFVebgEtmCvAEcgEY5I3W7w4cJOGIu+nqB6w1M7sZhzbu?=
 =?us-ascii?Q?m08Ajy94QWKXaMzyvSvvh1DJ60hlP8lOb9rKkGD4cwvlupuWa2yV5JEbjcqc?=
 =?us-ascii?Q?/mN0ty+NAmi1BOmq8/jDIEBAi40+CGbtOBx0z9V2aRIzfEMoyzNRB0eE54lp?=
 =?us-ascii?Q?hWCG9PkGTX5HO8i0b741yt7sVNkdfIGk723ljuSvQggbwEnI6NuFVLr6j4dl?=
 =?us-ascii?Q?aH5jOKM2jscHVFtRPas6AHB57NSfQ7xDkGNiCF1Qt6mCMQMWtqVecF521R7L?=
 =?us-ascii?Q?2etiijMpHohd+Yje6ImUKPFef1owVyG8VQW4dvgfZ+hgl9H5hCvjpdt3JAyN?=
 =?us-ascii?Q?6+slMKezbEATrSmimAHpc6N6Hc9m3Y2tDSfvK9fxSZ9S56gSJOZrdAReGzRX?=
 =?us-ascii?Q?0wx+x25HVE4Uw4pF5drzG6JyCNCO78kqs4ix3dt5SeY5+2HvZR7bpuGP3YCr?=
 =?us-ascii?Q?QOqr7mH2DLuC6lzHSKrwrytqmea9UE9tR/dnaIt5rnfgNkDi2pDs2lYOTGYZ?=
 =?us-ascii?Q?jruwn7TTcMq38illcu6mckLEA8KtRNmxHt/daxC4mGIf5JEIV1XaggYMZQ+l?=
 =?us-ascii?Q?+rcAA42yphlL1LRmfoqAiUJ4ESTraZmzLGV+7RIX2QKuFk4G4qsZ3fE1MLw4?=
 =?us-ascii?Q?S9o4/dA0cbJOQBfd2ebOIbmc97heCcXdIPGi7/KLfxS18FKtst6g/B7qjpTF?=
 =?us-ascii?Q?ndWdPAQ+ZyRNSJD+UumD8SG2L63x0y/DpYQdPQVuuU8UeJql3fzMG42als2Y?=
 =?us-ascii?Q?qCR4Tjro0r9R9rlTN6ZsWzo+9HDuQx/COFWOFFf+5hs7JVGTHka9bvwlR2Hv?=
 =?us-ascii?Q?l985MsBMML8kyxv/DZXmuLEodnadnJJ+dVQk9QaljLZFCpb3S1wbGlk1CEAp?=
 =?us-ascii?Q?BrTY2HjSXhPwn2cegm0LNgM+OoXs8LHXStSy3vvdU+uJfwaCS5Miwaf3150w?=
 =?us-ascii?Q?TCRAs05d2hamS8xJbr7FoZCirERk9s5jIefXRBHr35/MK8PpQI8gdqQuzSM9?=
 =?us-ascii?Q?q5apZ4wSI7EybQ9qR9YDJJncy+BQxFoCDASXeOinBgOCLauwrxUmFXAe5CYM?=
 =?us-ascii?Q?cAO787Kmgq8tbjd+Qsrt4K1TmZyBcUgtRrPKO0kVuCRfy0FPNDh0phT1q4z7?=
 =?us-ascii?Q?ikIET4Wzz5X7Yr/S1CutTxHZ1O+7RoglBalkJX1lJI7f7O2cveAKHIlgIJTj?=
 =?us-ascii?Q?blrE+6x0YQuzcMLAS8Rf8XZCaDQ47rprDNbljlj6gqC09SLX1Clj6QnCkPbk?=
 =?us-ascii?Q?p78q/iItHwVhm1JmhAw0lE7u?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1faa91a-4d32-4047-749f-08d926813731
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2021 11:17:46.6418
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gkDY/VFkHjxhRXvz8Zwawno9ECO+1pylkni/HbU7YNalNneh4PFexWZ3gNVUIJICRgQYqaiwZzGxHl60ZFtI+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5452
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Parav Pandit <parav@nvidia.com>
> Sent: Thursday, June 3, 2021 4:46 PM
> To: dsahern@gmail.com; stephen@networkplumber.org;
> netdev@vger.kernel.org
> Cc: Parav Pandit <parav@nvidia.com>; Jiri Pirko <jiri@nvidia.com>
> Subject: [PATCH iproute2-next internal] devlink: Add optional controller =
user
> input
I missed to drop "internal" from the subject. Resending it.
