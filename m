Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA5A930DC7D
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 15:19:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232411AbhBCOSy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 09:18:54 -0500
Received: from mail-vi1eur05on2121.outbound.protection.outlook.com ([40.107.21.121]:30304
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231791AbhBCOSn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 09:18:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FlYljSyv3fYR4+iraJpIuJRG1dQ/sSqmqHTeAS6kXkbVYKxlsFP4y5a8VqcNhQD+mT+0O+De8HVqM4o+riDZibQneeKv8jIHwwYXlosokc4loyN7H9HLwxXxyVcmro1EHXdsUAMlhQr+BnK2NMYdjUC5oy0PsFU/jqyFMBY5ioSmsRofU/t1ITuyuA+3X1IdXEQHcJqxqjdJLQ55WmKLGu35muFGuG2sRUO7ZnIogNA9K8kZULBbwJy3jmUr4SVvakWvk6NrRnvUYJI1d/2AoouGgGXI26a10nIMueQtzMaQTrO1EM+Y5cW2zrXpWT6A2QbE9CxVBunJlhmOKCnIZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=48q8T4Jgt41b4sMkY+EOIUU9Ib3qp3+rvPFYqAbLnAA=;
 b=bjhwM5jK3Cu1m+I106gedSYQDErcCT9MijxxG3uIwVI7E7jIOu7Nnzhs3O6zpqDhstcUhBonU/pvnGh1WgCoDzhqozem6Dm5CLwkh28I46grq66VT/sC5ysP1obE1dRDozA2LhEsVTMg727VbPp5IYxrDr4ewLp2us+o/bIUf+Bt+f7iuJtkLbNP8BE6YZy9jhwpsCN5FlUQ7xukFBzAF4UyfCQUBTAKz06EzMaPhoi5+OOWpiw6B2+V5GJE41kx53wLC/p4/lkaiaIJJeyrk3hgrKaNUV/YUakmgO5aJ5qOHsEo+1N2jJj8vijTESP+f1WiLwqxcV0fqr+rlzVmGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=48q8T4Jgt41b4sMkY+EOIUU9Ib3qp3+rvPFYqAbLnAA=;
 b=NTdwNs/B2LoD8pMYXHkRYNsB4UqgMhTeBGGTrefJV8jdcfa6H0+PhYQe7cWAmysfxbhnmA7rMSdz0J7wnIerc2bGoCGTMOLiqDELWrDJnu2iT0+mzWnzeHNF5HasO23aI0o/vuvZ3VW17MWaei2plnCVXoiZvhjEQ1Guu+6BITE=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0490.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:61::31) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3805.26; Wed, 3 Feb 2021 14:17:51 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::bc8b:6638:a839:2a8f]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::bc8b:6638:a839:2a8f%5]) with mapi id 15.20.3805.023; Wed, 3 Feb 2021
 14:17:51 +0000
Date:   Wed, 3 Feb 2021 16:17:48 +0200
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     linux-firmware@kernel.org
Cc:     netdev@vger.kernel.org, Mickey Rachamim <mickeyr@marvell.com>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Subject: [GIT PULL linux-firmware] mrvl: prestera: Add Marvell Prestera
 Switchdev firmware 2.5 version
Message-ID: <20210203141748.GA18116@plvision.eu>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM6P195CA0069.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:209:87::46) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plvision.eu (217.20.186.93) by AM6P195CA0069.EURP195.PROD.OUTLOOK.COM (2603:10a6:209:87::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Wed, 3 Feb 2021 14:17:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0bc883c2-9d76-46fe-052c-08d8c84e7d8b
X-MS-TrafficTypeDiagnostic: HE1P190MB0490:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB0490205D71974BF03D04B37795B49@HE1P190MB0490.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:330;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +yLeqcFRyUbxIJsQJNJcPryLI0F7YPtQ+B0S1Hja1nKOuZ8HoJe7Tv6zsfkk66u7doYXZc92bcP6KZmJLGN5wbhNEEL2K4igHbmdWWrLyLVYhEz2JY5NhqMbMkq4Ah1iaNuZBxr6XgyFjb3zC3QDPXAtWYk+30Dgf7uDX+AGnp79DUCaLYvrR018KZJtq+yBcPtYG/OIZ8+oXoPWvrNq9p8v4EFHnmYb/0Hg9W0MyCXfbAnY0fxuq/yQQFnI61Q0a5j0TcITL5hWk5ov/ERzaMgV3CnZoRe1uJgNRMATqHt0qIKnzxr8xB6B4ztgStytZAUj7hirEzCucSXE3yTvvJJhf8TiztdqQtrQLg1RQJlyl9Tzn9LVHbNpL1yby4gNTKuCzy/atLVP7owEUo49xEs2ZZuMx0KATYwH9/jxEPVoJ/ujNCXGrcea6Kj/UBIEUR820/WKa1EVdhCtHCQ/BAJTQ/xB+KzymCxagrbVhwBVZqJzd3kvJKD+bRC7IsgkwNk21YUjhOeOnQx6F6wlRrR64TkCBvdf3lDihaaShbK2WbR5mSz+ykIX3xUTBNfkvgNXwqQS7gtxy6BUFVOj2br8YWkMN44XQ/3D3XWIqbQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(396003)(136003)(376002)(346002)(366004)(39830400003)(44832011)(2616005)(956004)(8676002)(966005)(66476007)(1076003)(33656002)(66556008)(66946007)(52116002)(5660300002)(55016002)(86362001)(6916009)(36756003)(186003)(107886003)(8936002)(478600001)(7696005)(4744005)(16526019)(26005)(8886007)(4326008)(2906002)(316002)(83380400001)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Oi+M9uMqRg5j3HlmkgKHx6DSvaPRwbO2r2JRHaIketg6zcOraDqS1bKJemY/?=
 =?us-ascii?Q?o8wpVY7du2es5Jmr0ozuW2IKbrNuZcRCbGiQx0zxsC4QGo0s6ImnouvXLUxT?=
 =?us-ascii?Q?XN1SkCD81u/Zi08gfmJYlm0lkH6Mtr/gqMxrx2Clikrz0QcSJRHbDAiFQPA0?=
 =?us-ascii?Q?BgvC7pg7phA+vgwIPMR+W3HJbQZgHTmmzaiuG6aLqEcLKIeFN4mdK92gSHoj?=
 =?us-ascii?Q?HsahtHZOcktXg+z7pI8wkm5DxRJcqB09Y1tOHLYNnB+WxcsEoxOo/bWUHz0E?=
 =?us-ascii?Q?3lxCwP1DrZ5FKeziTbKZP0KcnL8IGxCkrPn3QyVK4LEeChGDK/rbE3sPjAjD?=
 =?us-ascii?Q?6i3B6vMq3U2Gdn7tw15Gshrv4JKkaar8YsBv6KMsZDa9fQYyxoN2yuKgBthL?=
 =?us-ascii?Q?0yh98pPswymAtHpfuWg6gwrr1QJWqPprD7w6bgwkW3pHBKc3LMjB0ZVN0jG/?=
 =?us-ascii?Q?EpruOVEdtUx38HZUUeU5ZMOMtRiM21eagSytFV94Mw8B1ecPjPqq1z7GSEUY?=
 =?us-ascii?Q?etxXmVeM34LER7IR9Rc+BMIhKI54p1/Htc97Ar1Rs82QEEdpMRkXqPfjQrV3?=
 =?us-ascii?Q?fZZ4BRT32Xi317b/XOCVZyWcUd+1kwB0JZZAB4kfH5YbCv65y5bEnwyucosD?=
 =?us-ascii?Q?wWsSuuXdFUB/9kdB+y2iVrzYHELVKopomKRCY+4RCdnF2wDr+BR8o8HWt39l?=
 =?us-ascii?Q?rMOC69ikr50Jw7rPRtVwHCFUbtM8AD9Gr0l7mu3MBksVfz90uFQJbKmyizGw?=
 =?us-ascii?Q?Wjs+P971rr8LNiYr/rLkPMrMnOU/3IBI88C2j9NzaiMBorNlkSqpwA3yypP+?=
 =?us-ascii?Q?5KW8aLTYh1rGVVI5PWISx6U6/2X4vmBahgcb9a2MpSbackLBlJcJrKUYZdR9?=
 =?us-ascii?Q?j29Z5i7sl9iLDU7jeeFc5kFeY3foruk2k1DcsDHfrlRdRCZSNu+zm3iTYgAv?=
 =?us-ascii?Q?CLs5rA/jCRBfnY24dF2gv0AR3vanSGnU0aXTkHDD0DcE8js4HeGcroOWBXZN?=
 =?us-ascii?Q?L0idz99s+Ba1LLr669KScQK/6jSkrjD06HinomEoh3GY/RgYmtQrdKDygSrH?=
 =?us-ascii?Q?Qw3OwwzSNaQmfRxZzC9eXm5dVckPGhIt5Z+Hg5svsqLTEHVXyMuXbLSXuF3u?=
 =?us-ascii?Q?1KznO3E3p4AKnwo0ViTu2r4m87pffDHNpOupfKYgXGMwsyzOrLX+B+teMeYn?=
 =?us-ascii?Q?n58cZuOA9w+Y+MuICzEZEMB4ptDNNvIRr24eBlJXnXL4bcNDys/dsxh95bdm?=
 =?us-ascii?Q?IvVafapKDOw05Yk3xesspMI4Z53BHR/j4td+V3Vataec0Lg0DnJIGY25F+x4?=
 =?us-ascii?Q?w3hN8oHVvCiv//h4OT+951gq?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bc883c2-9d76-46fe-052c-08d8c84e7d8b
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2021 14:17:51.5260
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UW6MI7lKHtI+CWjjJA+7Czr8lb8tlKXqZs4QGm2ct64KmfLxq3wnvgPEqNP2o7sej3ykofGfxozRrQU5ByYliRXJv2X63K3U2ERT6ifjkBc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0490
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit 05789708b79b38eb0f1a20d8449b4eb56d39b39f:

  brcm: Link RPi4's WiFi firmware with DMI machine name. (2021-01-19 07:42:43 -0500)

are available in the Git repository at:

  https://github.com/PLVision/linux-firmware.git mrvl-prestera

for you to fetch changes up to 1722d0deb575e4bd5433914bb2eeabfd0703ed2f:

  mrvl: prestera: Add Marvell Prestera Switchdev firmware 2.5 version (2021-02-03 16:04:13 +0200)

----------------------------------------------------------------
Vadym Kochan (1):
      mrvl: prestera: Add Marvell Prestera Switchdev firmware 2.5 version

 mrvl/prestera/mvsw_prestera_fw-v2.5.img | Bin 0 -> 13721600 bytes
 1 file changed, 0 insertions(+), 0 deletions(-)
 create mode 100755 mrvl/prestera/mvsw_prestera_fw-v2.5.img
