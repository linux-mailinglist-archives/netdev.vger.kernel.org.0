Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04AD7367C86
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 10:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235331AbhDVIag (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 04:30:36 -0400
Received: from mail-eopbgr60119.outbound.protection.outlook.com ([40.107.6.119]:36216
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235275AbhDVIaf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 04:30:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D9oxHksg8YFNNjPdthZf/22dlciKUWS0Gm4mN+mTW0UfJn4lLsfkbVeJqXTYkEprP/gW1LdDbfHVbVK0Ccnn4kCrjRIN2BbBc57dVzY1Iq8gMqKc4IfsZ+BkLMusgxsL2K5zQlHXpIaniAgrimid4x0paIrPfedFPfvFCqcDXstGjUIsd2rO+deJ5+UxqXk1D1xAVNEuTv6stZiUXs9A17+C9kI+OtdP1A+PxlAA1i5RjtztQAb8bNrc1k7KOc7zq0ShQlzrTZ7crLxsK0Ku1sx65oMwa8zBHxJuaxlezu4zfNhzErnSytInaPQirtMAycdL6XAsXEyt3dixGsV37w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aAQHQCwKb4+4yc+7F6ugDOPvG8b6ygREBIq6JC4eYEI=;
 b=I0KfQxdApSYOpWcnydrcsSxbXCqoXyhO6XERmdKaGdyZDoga7k4FWjmbpviNlbov4HkAqBBRE+eviWennqXvrrZ2dMoascG1SvAgtDbOIsf/Ri4AUhEK49pIaIP2yYshjxxn65ZH6n78Qunlo74JEqqUAUoXrATWfkgxEv4b3t8p8kI/Y5Xu3vgzg2mYej/CNB+A7aWLdPVWJrxWGQ3KLQGMEeOynj586kkTDDZDkDFwoJ8yH366pHJ/YGu/tnzRvu0pU5nNYPoSLS70sV4/N8ZD9o3opw5b6kmE8qh+sW+AoS1/vAlMLyRcTFniFfu7PgQr8tKsKFHv9CIj9Z9uEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aAQHQCwKb4+4yc+7F6ugDOPvG8b6ygREBIq6JC4eYEI=;
 b=TBQTP/Ok4Ch6+37oosY3IcawRV+Ejh7StSxRIk7Ugld3qwWzjIv2VZMEXM+Qy9hLopGOxQ+qj8ELxcwzxQgsfkbPf+Ha4VGvPnhVBh+cF9s9Xv0eSmY9d3abkbjY94iv4cGk7BpEOoFTOsgHdhjUYQT90FGFDZUg7cHIexR1IU0=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0026.EURP190.PROD.OUTLOOK.COM (2603:10a6:3:c9::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4042.18; Thu, 22 Apr 2021 08:29:58 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::a03e:2330:7686:125c]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::a03e:2330:7686:125c%7]) with mapi id 15.20.4065.023; Thu, 22 Apr 2021
 08:29:58 +0000
Date:   Thu, 22 Apr 2021 11:29:55 +0300
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     linux-firmware@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Vadym Kochan <vadym.kochan@plvision.eu>
Subject: [GIT PULL] linux-firmware: mrvl: prestera: Add Marvell Prestera
 Switchdev firmware 3.0 version
Message-ID: <20210422082955.GA1864@plvision.eu>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM5PR0502CA0008.eurprd05.prod.outlook.com
 (2603:10a6:203:91::18) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plvision.eu (217.20.186.93) by AM5PR0502CA0008.eurprd05.prod.outlook.com (2603:10a6:203:91::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.22 via Frontend Transport; Thu, 22 Apr 2021 08:29:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eac7e82e-e9c3-4f71-1ca3-08d90568d039
X-MS-TrafficTypeDiagnostic: HE1P190MB0026:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB00263933588CCD6F2717137895469@HE1P190MB0026.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:378;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GN1llTU10syNprhZWNMDupBofXNUuPCC5V0lu/utTuXYCA61TG9Ly66Boztj1JxLrMGwKcz4fSEGRGs2uEB0SzqzcowJWcxGpLOR+AmB/ygmKaMysYXmEQp/FisbefKR+IKJQV17Azy7l/BLq3sq+k7uyvmu2xG3naErHBtK+FeuAVpTLZPCVb45NOIs0BuzAEZ0Q2gPeoOsgv9MJ+n5dofcRRGOuaSbzROkzEMC4B4FDVEZjD6n2cLiJBbGnfOXn0rSdW7O8Oe9MYnoMAlj3nzx1qe5TTcEgBtXcbWsW7pJtqBRHFRjhR5oywokegd7h10yN1AmBxQ6D+HkqBZgpbKV/9YbDm+9SUJKmEX4YMRyt4z7H+1EO9hpkEYZ3alWkcyFIlsW+kWdXEnZPvESK9tY+ETVLq0ZhyAz4UijiXOC2FsGM68dQV4IDIruVJRAOjef0EOkwaGgvCHlKAAf7Abp1WhkKM3F+uYKztxTmtUD6cCSmVfTi3ncigiUdvSSpdGhvR5xy07m6HzX1hHwbl1U2widhQNIskNL2drcqak5+97cvYi4P/dbSEgRapIWp/2eE8L/utytNkeuOJXnuDGy51tB466NOKxh+63IOV/SuMlU6T23qRPitj5TnzwBwJP9QvP1j3M4+hQLfhAGERlLuXcA0kyyaKK9sdqENHOHbHZcgUev2hDDDGx0JDBZ7IkG5ReiCcmK55wlqPlMHP3r3qgdck17Bw6sfFsPl+4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(376002)(136003)(39830400003)(396003)(366004)(346002)(316002)(52116002)(8676002)(8886007)(478600001)(55016002)(16526019)(186003)(54906003)(4744005)(2616005)(4326008)(83380400001)(33656002)(26005)(7696005)(38100700002)(5660300002)(66476007)(2906002)(66556008)(966005)(66946007)(956004)(44832011)(6916009)(36756003)(107886003)(38350700002)(86362001)(1076003)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?NtVE9SXZrvxUPCmbmDV6Crr0CUzR7kohFub2SFDqjegq5MeToXvAVZPkdhqc?=
 =?us-ascii?Q?cjxmijODmughJLnkeRxsGMJGZquzdsARUjfFFuxJB4DJp36uSxRJpcvGxuQI?=
 =?us-ascii?Q?ADVv2yKkXDNAOU5lG8CaLHYuq9pSYgyXSd+cxMRJbGe9Hi72R8HiG1xYNYWU?=
 =?us-ascii?Q?JMN8W0NTH5m/lJPumQg+q/00a217b8bDBFYMScJR2jVUZzOcnMjYzhaGr9Xb?=
 =?us-ascii?Q?a3/GJDGAKQeTp3peKtFFlcldrOsEC8+uC1xe3cnnBo6oS6y71bw2qlaKLZW/?=
 =?us-ascii?Q?qXyA5a/dcNUepfdB86ukUtr5UJzkNvdPyHdwTwHotbJ3h9ivkyAN8bp/u3yy?=
 =?us-ascii?Q?iEsdcvXQ1S5pX8z5Pg0CMCRHg3GYHgW5coUHbosVP9oSBh4/U62CkqJ17v7J?=
 =?us-ascii?Q?4LySQAxMBxPUFOkgLp0UiEU6MX0Gee2c3LIFMcCDRVUrZNldjb5030H5gcY/?=
 =?us-ascii?Q?Dje9n4BPF6BpIHp9/KeNjFR4AE0Dn5eMUFhQjB+3iHbL8Powj1zdLWDAKR/k?=
 =?us-ascii?Q?XQP9Gr6IFhXb973qYUYAcxUWS2PJaMLWlJmk/eYsvKXNYxPzRyLT6XRu8nOq?=
 =?us-ascii?Q?D/hvra7LIFJdpfuv+0vp+YgYCm6aJFK5BxHC5TSsgYUsYiBQZ2XfZISnWnIz?=
 =?us-ascii?Q?8dlix/DFFdpzdVXmS07psqitP0WE60d7eBpTS59rgYBig0t9rWydlwvw5hLn?=
 =?us-ascii?Q?Yg15MnFbdkyq4nRM/KnwcCZdc1TjiHBnaqA7wB5BXRvUrEI+3U00ZUBXr35/?=
 =?us-ascii?Q?8YynOIqwJwmI7ugEdpwZjp+URZr/m3a3SmHeMhxnKGSmfd5Ht3ME/I70mW/F?=
 =?us-ascii?Q?0gymbcgqFRB0+Sb7U/1T50bNqdFFgf6LZMqBdQgfDu8dcQdgI8mEX1Qr/w98?=
 =?us-ascii?Q?XW4U55sb8511L3voa7F2KP5o1JDJii2x2bV2r8qwq19QLz7hfkuQD4Dc2i4K?=
 =?us-ascii?Q?Gw6X3EZG1wGy3O82FXP50AxFnuIGXJwidlwkjXNeQ2cp90DOAa/lQQTpeaVi?=
 =?us-ascii?Q?WwW1FC6zIPpesPQ9DR5fQDXNSFXv9bzEFxaFMsRqfo84IrZ67s1GllpP7+nq?=
 =?us-ascii?Q?bJTR+3+F9ERjTp4w/62aj1B+F6b/IAibezybG2mkzyRxq5EnpX6MpOfZC9zT?=
 =?us-ascii?Q?+U7nHmmiguJlLgcK1FxKg6AkmC8OdOrmCzLQHwpYqgVnD+MiZ8ZW4pb6ekLb?=
 =?us-ascii?Q?Up1IstFEmRpH6p4bFV+mw5ZfUTnar05Gaa9Fomtez+REo9RDaqCL8+Qz4uNm?=
 =?us-ascii?Q?qiTaA7lTAzukovWMldsf0vbl49DwtvWBfyrceKgwZyDimjGpvFeUmzX8TG2F?=
 =?us-ascii?Q?TGm44CFFczmP5YV1M6YpW+BT?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: eac7e82e-e9c3-4f71-1ca3-08d90568d039
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2021 08:29:57.8766
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NClRHwqjirm0m/gtqcgnNaEcOOAsmQtmfAyrFHxm64GQZ6BGNKdGigDiLyo2+JaOAW9hzwVzHTsLfIvV8+6REeKYDgTgo+hWJ3RaFBY84m4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0026
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit cfa004c7d82e1903cc88a918ee9b270fb8f47b28:

  amdgpu: update arcturus firmware from 21.10 (2021-04-21 07:09:48 -0400)

are available in the Git repository at:

  https://github.com/PLVision/linux-firmware.git mrvl-prestera

for you to fetch changes up to 50d16db2e77332e0e89ec0f9604ab0bb2fbc3c02:

  mrvl: prestera: Add Marvell Prestera Switchdev firmware 3.0 version (2021-04-22 11:23:24 +0300)

----------------------------------------------------------------
Vadym Kochan (1):
      mrvl: prestera: Add Marvell Prestera Switchdev firmware 3.0 version

 mrvl/prestera/mvsw_prestera_fw-v3.0.img | Bin 0 -> 13721584 bytes
 1 file changed, 0 insertions(+), 0 deletions(-)
 create mode 100755 mrvl/prestera/mvsw_prestera_fw-v3.0.img
