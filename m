Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0B303AB7C2
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 17:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233449AbhFQPo2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 11:44:28 -0400
Received: from mail-am6eur05on2128.outbound.protection.outlook.com ([40.107.22.128]:1313
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232521AbhFQPoT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 11:44:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MPXuiNJg1hpetEGZrKEitPEBwTcTV7aTTcHD9YqZRLlqwJgWVPSYqOeIp+1RIekEwQeQL73Es05Z2KeRUkK9T0TcgDK4sgRbSdjNGafHVazx3wS2c9ZtvTKJtmgun5xMrPUi3yyVKhWrkZmBghnffycHQAaYWxhZ2zQFIc8jJ7Q373mBE+Ke3gIXu2Ad0+LVDN7daIyxt4q1TeyS3HUOsUz39KsCpsb+kWwCWdLPWmqQo1Bl01FF5yjtU6JCd8BRwblfqliTjmV2y+h50XvQJET6PM4AYKzSbH1dugjTDMxBEUM6o9eRX2aNrSqSly7VBUQUKnrDjdAKwmTqABIEDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3LhcxKH4u2oqI6/naDC2NUenmJnRUZTMf1a/pGHOwks=;
 b=TlqtqSZvztRBh0pZS7gniNAs7cKxhp6XEZBkU++VXmyHpjvUA1CBI1LfKmGS/z/sCKGRj/3aVMvwV+dUqV+xfb6w8Zg/aB9ipoL9/c9bL68zgitZGpuylE3fvtmUWpMKmtrlfZWeHhBNa7wg7CDoLk+fp5bBDYdpOQJoPNh21FwXyc/p6dHb+stvaQ64YDMNL4hazOGYMd0bucAsWfPXXDV7y9y5tjehks6HyIE9Su8JgaVBpO9ibNrDNWUAxESx/OQf0kKOnJFPkyqTp/MvgKZZ5X5G51a5TYkY3fSJ/uMu0CtCuDJNdwbVdkMW7ffqG914NlppLvXIW8njwQp3EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3LhcxKH4u2oqI6/naDC2NUenmJnRUZTMf1a/pGHOwks=;
 b=gWYkN/zTx/j6tM24U58RxDQV541MoCy1LrzYlveQ9+c0Wv9cIcysYbofKzyOWXyPyF5kXlw0uxHp4M/qx8U069UX+36I9AqR49Lqb2tByR2SqqISEkdh0HlatNEOhjF0vaQCLBgBRloOyTQMd1rNLek+eRsM20kkuwQcW3Q5RII=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0026.EURP190.PROD.OUTLOOK.COM (2603:10a6:3:c9::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4219.24; Thu, 17 Jun 2021 15:42:09 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::e58c:4b87:f666:e53a]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::e58c:4b87:f666:e53a%6]) with mapi id 15.20.4219.025; Thu, 17 Jun 2021
 15:42:09 +0000
Date:   Thu, 17 Jun 2021 18:42:06 +0300
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
Subject: [GIT PULL] linux-firmware: mrvl: prestera: Update Marvell Prestera
 Switchdev v3.0 with policer support
Message-ID: <20210617154206.GA17555@plvision.eu>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AS8P251CA0002.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:2f2::15) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plvision.eu (217.20.186.93) by AS8P251CA0002.EURP251.PROD.OUTLOOK.COM (2603:10a6:20b:2f2::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15 via Frontend Transport; Thu, 17 Jun 2021 15:42:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c466dafe-8a4b-4a1f-9761-08d931a6775d
X-MS-TrafficTypeDiagnostic: HE1P190MB0026:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB0026AA0ECFD49C1186B97344950E9@HE1P190MB0026.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:330;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kMKeYbp0FmAH2xDfiDDKvopBox4642uckCRjAVjdM4jWclvfEVb5KkGCAs9AAKaq11AVXn7AiIJPwq9Yj51vgYrLkgv6KJx8dchLhFaL1CwOnM7N+GENdEi8H74FS/IUqMpzRNm2V9sG3jQx7WsTOkD3o2qEi8Vuk5pS5/fDwrHYed0kEdZM1K+MFD2sthhRjJMC2XvZtJp6mmRsOiDSgtDnoq2tbDmc+0af/iw0WQD3uCagD5c3GMTi51fh95ZntdpH1XSZ3K8Sa6fSVA0PDupSTYm9qwZ2SpmaqFv2L8hCcD3TiCEqitmuLtqq0j1YwTI7GOsnvaXn10qM2RGyTEBtM1ieHGxjsksyFfrHVjwVdTX8im1DH6KDNH8IePMikRwPf6NrpNyIgBJG3hCpxYvbiGkjbibtXQPJOqpr5E7klS1YNEsQQYEmOPgGO/SlQILy9h26KI9zzj+rLoqx4bbC1LNQn1FdwR/pM8yKDfR78c1ESDi727Tqr9Q4cKPmyctDk4UMYDZoUR34EZBjhlN8M45sf5x4/JoNHtBaL6h7Za173jtETky1c3G6M0sADhEMH5tgJiV9UoPdff7rykWw3x/u8jJqazvQ/uZXTXDfY6MLMsbfgHlMZt95WO8UOaskpEj8bGcHsTQKDG93SmyoxXOHfokDV0Numcz8Ij6DIeosNHyMzuuvca/hpHq5jlhBAKgM7it1LuHOScjk9MD4SgkXoGF5eYJNDBA7RK+vcdnxlitQJ65lLzvAQmrb74/LuySUBTBGwPF7go/erA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(136003)(39830400003)(376002)(346002)(396003)(366004)(26005)(8886007)(8936002)(54906003)(1076003)(44832011)(956004)(316002)(86362001)(4326008)(6916009)(478600001)(2616005)(15650500001)(4744005)(966005)(8676002)(66556008)(5660300002)(107886003)(36756003)(52116002)(7696005)(2906002)(186003)(66476007)(55016002)(38350700002)(33656002)(38100700002)(83380400001)(16526019)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tWa90e8C0xuV5DioUD8HLNd27y3IcllSv3gLs/kYy5bMtqv92Hne4a42hJW2?=
 =?us-ascii?Q?o9GOTYqy9U6B35YSAXGsQjyiXt6YXzb+XmajbJPsb1Qz+tmRuiByYn4o4ORJ?=
 =?us-ascii?Q?5ga+gnKMTeTT64mCCFrW/SLcpYSblZ+KkVrhSwTa8lEqUQ7fnPZraD6ZZi9N?=
 =?us-ascii?Q?Q5CJcItrWZBbJP0/3UVltN90gpP4S6XHS439mX80pkNU53nnBsatCVxibwqN?=
 =?us-ascii?Q?K2fJ6CLfNUvYRpA73xNIy7LrYZoSjmll09389Mh2zlYgVGZgzes9q3oJnZy+?=
 =?us-ascii?Q?qakeYp7a2omL/hmDXmPi+y9IKvwJCGwkJOuEDC5Qzk9OXW1oGavFv8dyoTr7?=
 =?us-ascii?Q?Q63kY2k2+G+lvNAHdj7qKNXspc7Lh0g+arJxTXhgu6w7u9cJ6r1alOoCu7tD?=
 =?us-ascii?Q?uQXJzwfffkkodPzFAOg8Aqs2ddlw2ejYJkflvqeppne78chHvOZcOCuMDlMk?=
 =?us-ascii?Q?xvGX+vRgFPjj8/Eq+l4ugvE8FbwNRBHK7JRIiqHLjKK2POZ7rqaqOHtFEL2f?=
 =?us-ascii?Q?MziMXoR1l8kzl/rQmggvHSWEYziBgHfpvrS7iouTjOdCSP6G8sE5/o5qrXB+?=
 =?us-ascii?Q?4Wqz9poxYatgaZJR7QXHvEf8xeqouV3BMaE/0D3qjbgFDBnuoNSvAGlouFOt?=
 =?us-ascii?Q?lniY4Btey7sVd1dtG9ATgNITXKLxnKpRVG1wY+p4b7j/6LZAaLOxqpzAQcgf?=
 =?us-ascii?Q?8Sjji1GdLg9yagCxMBntGzmq5HMt70Kv1SR3mpWNMW1NYcMRbp1+youSftvz?=
 =?us-ascii?Q?S8gMJh4yAUXi9uvWbxIo0Cf6eWSspRO4R/t7Df4iFVV7fqn7NqQdA9f7Pk46?=
 =?us-ascii?Q?3We+N5EnnQluESKBJcFHJF+Vd+UEN1dcPy9gc7/z4i9zK93vHqreRgCmlCWQ?=
 =?us-ascii?Q?DYTRLbeEKbNnwsrZpsdiKsppx0vY8o+Mbp3STujCpX+I9bNcJzeICsFLAHB0?=
 =?us-ascii?Q?z5F4GthdkU09N1w798jdfb+pYjRbFOX3uXafmJW5A+EUSWyvFaPijLh1dVSp?=
 =?us-ascii?Q?r5CqARwSBnLNIY1k8gDEmw9sNsfZp7QMy9KcG6Dcf4EsW10H6pM+oKOxOXzR?=
 =?us-ascii?Q?E1SPtmkOeZWnLxIp+xyMxQepcUycmLk4YRreHiaFzgHMb2oDLsXwRmABDYhg?=
 =?us-ascii?Q?TZI+ii7oiGwNCWj1Z3S0QlZvShGZBgcgcFy1VW9vu52ZO5XcY6UV2sfKASE5?=
 =?us-ascii?Q?05H88o+Lto7+J5yn1k0VXq9j5KomUnS2qZYJ2kMzGZH9EZOJvfQdgH10qtBP?=
 =?us-ascii?Q?jQQiT/bg1i1ZGJdellbhecx6VW+NJRgY6rjpB6vBiBqjUHX03gIJdVbgKFDu?=
 =?us-ascii?Q?q265wU7aMSOOnBkcUShFqyiK?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: c466dafe-8a4b-4a1f-9761-08d931a6775d
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2021 15:42:08.8599
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EvF591WwSJONKZZQyK6964AS15hL1eD1kzyqgQ6b2UETrB1Q/cmJWOmW1KQGg9514xdkTGbHynA6JEUYmtKVtseTNRR93WuGlyY3X3tG684=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0026
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit 0f66b74b6267fce66395316308d88b0535aa3df2:

  cypress: update firmware for cyw54591 pcie (2021-06-09 07:12:02 -0400)

are available in the Git repository at:

  https://github.com/PLVision/linux-firmware.git mrvl-prestera

for you to fetch changes up to a43d95a48b8e8167e21fb72429d860c7961c2e32:

  mrvl: prestera: Update Marvell Prestera Switchdev v3.0 with policer support (2021-06-17 18:22:57 +0300)

----------------------------------------------------------------
Vadym Kochan (1):
      mrvl: prestera: Update Marvell Prestera Switchdev v3.0 with policer support

 mrvl/prestera/mvsw_prestera_fw-v3.0.img | Bin 13721584 -> 13721676 bytes
 1 file changed, 0 insertions(+), 0 deletions(-)
