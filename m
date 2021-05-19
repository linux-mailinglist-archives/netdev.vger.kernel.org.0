Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9D2D389109
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 16:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347786AbhESOgE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 10:36:04 -0400
Received: from mail-eopbgr130129.outbound.protection.outlook.com ([40.107.13.129]:28761
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240366AbhESOgC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 10:36:02 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iGQH4+t6DHnzNTjzZGSBCVbYWcQMB59VZTSFsrFrO/6/ThQndPIxibAjpN+Z8+4BKG/iHGhzPq4GkEF7pVACMfmKNCVoAaKEyVpR8JHYEgwcgwHnpg3mEwjvscZr3ESaBRkZW+4bJf4HD25PPXn/c/6KXun9bRbQ2PmvtifbyEE7s/OU2aYp6ita9H8vxCADIYWnnfIKbQ0yU0Eh0eZdH6DsaTjH1r4dRmuGPTlPnW3fNDdiB3owmSG2zm7mpGBjHtVeywoNtYFBdgQwyS6Gt7+RK98TCqO1HJ6+aW75Rd+Z21ve4v/a+zT7hGzOCpFW2UIx4AC2S8dazjBxiN/BIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bIytReb0phNIZIbBNrLGzC6URfg5kYpLYbEg/hzRZMg=;
 b=V0UVrpt6ej0D0dM0Vkz4ClhHmaJYiOwKJMY9lNNGh3dheserG+t5uZFVwLQIMaM0Ufa8Cuis3MJkAdYjpyiStIiVNk2vEyn5rmRpEmaXtqQ7u3nKDJSyejh/BGq6KI8cLtZGWSGTETCvA1qKe+S6Z77Mkwhx11jsz9gcS7r3ngx6cHxtSetwusQVlI2CNuH90quVvp4S4K1QrSW3vDqi3Nhh84iWYQ+M4TAiMvkWw9iyvATJf8CNvyS5NwNBObvy14uNhwqhFlsZ4vchqLPYAhY+0iMzL7UgdndqtyE7nJSIBLhLQS0/Z940+ewU6QfY6GCM7OIv+3VurntL3xBPGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bIytReb0phNIZIbBNrLGzC6URfg5kYpLYbEg/hzRZMg=;
 b=XIKSNVpuSECaWisdIyQol8LHFYhiboR+UOJrkcjIoZR3CNYTIYHkiV6aAYwXMED6rx012puCcYFiTjlROMpB86BnbqcbJmQpIWlrSwl5UrCBi7phidd0kJVYB7hg9n1BJRG/Afqdt8NkYjYQd3VzufLSbTVNNKgXNrgfJy2OHp0=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0025.EURP190.PROD.OUTLOOK.COM (2603:10a6:3:c0::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4129.26; Wed, 19 May 2021 14:34:41 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::edb4:ae92:2efe:8c8a]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::edb4:ae92:2efe:8c8a%5]) with mapi id 15.20.4129.033; Wed, 19 May 2021
 14:34:41 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        linux-kernel@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>,
        Vadym Kochan <vkochan@marvell.com>
Subject: [RFC net-next 0/4] Marvell Prestera Switchdev initial updates for firmware version 3.0
Date:   Wed, 19 May 2021 17:33:17 +0300
Message-Id: <20210519143321.849-1-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM5PR0601CA0074.eurprd06.prod.outlook.com
 (2603:10a6:206::39) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM5PR0601CA0074.eurprd06.prod.outlook.com (2603:10a6:206::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.33 via Frontend Transport; Wed, 19 May 2021 14:34:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4dcbe55a-ef20-4bd7-7636-08d91ad33cd0
X-MS-TrafficTypeDiagnostic: HE1P190MB0025:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB0025A8FC4523CC268DD21BA9952B9@HE1P190MB0025.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zDDlwtREG9cEGsAm8j0mzGDZBa/+qFg1OYxBBxTh0hl3dFvdyRpUzmkhPr2RZ9AJyHD0jnaSFWoIOdpSLRD4mdAn1cD4ltbJRMUSbUdUl3IexdF8qpq0z9AK63Jo57TYlFPc2SDgpQWS64IgO+AzLBT7SCW9ZMA2zdOnQ79BWnOWKJ3+at3CctDedy8j2C2HdA4CbORS4k142gYQdtFLu0SM2HHCJ8Ucf5ncc90yb/4wHxUhX789uEKJSL2aegWtOHIqUexkQ6CPFafqcfxupZH/rZ8jNa1/cKLpSPqsnFWus0lueSja9YG+webfK1q/hJX2PhnCV6A3paYbo+sCQ4VLrOBXfG/QVDWPV7eGKXdJulzFhkhcgPPTSsZQPnTG0Iq4d4qMbiufM+VafI2JQfbElBUsv+bmamZUqERVmC1HRZ3rH1bvRxZc6yaDqrKcsCgQ8ejvpybkBx2Z2HOkY7Lj/TWu5qnWfN5S4nKID/oXq0uasSfnXvHzcDKelRBayBZw9ywJ6F46bny3byH+RbpKLtv5FceWS9yLoftTjriD7Bzrtni07tfCXIuiQAOmSfuYoqfiPi34ld3n6cPxI3HP5sPcetqeIdgfZ/VdwD46DP2/TbwiTO0GbdzA/ICfqjt74hB+zlWS/GsGvnLAcw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(396003)(366004)(39830400003)(376002)(346002)(136003)(66556008)(66946007)(38350700002)(316002)(66476007)(38100700002)(5660300002)(86362001)(52116002)(8676002)(54906003)(6666004)(1076003)(8936002)(478600001)(26005)(110136005)(44832011)(6506007)(6486002)(16526019)(186003)(956004)(2616005)(4326008)(36756003)(2906002)(6512007)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ruJzUIlNQFfriTgd1XsaTyJWDX/uDOFgrh5dt916jcdMg5g2SBcEvCxa9aHa?=
 =?us-ascii?Q?OIXI5/9N746YT3SROsQfvyFqwQskQgJYHqGUFMUOGd4EaXTR4UEH0uutxPG5?=
 =?us-ascii?Q?CSvXEucQHvfzckl/Fuyyy8YnBcTS39bhmo5AjAcgA9rmAzFoPBF08QNklj/0?=
 =?us-ascii?Q?oNa1avhKjKdYQwb8mWoJpJ+O79ib5FcEvHlZ9wBzWVdaUHyJ6Xs1/IVhfyHr?=
 =?us-ascii?Q?yTp3dMuBaVhDaezFLhmAmiMy/Ae6EUDFbtmcrMaWDcZ+fTs99vBH10u/iYoF?=
 =?us-ascii?Q?2jab6lh8TMge1LdAGjfmr3RG8B8SVoXU7YYzUlAGsVtJdYK8quKqC4FPvb8U?=
 =?us-ascii?Q?HFeZRaCYhI3P5dqsKxnqc1zjfYlpSsOk03xN7catGsjSjzWbnwZuOp+5tqU5?=
 =?us-ascii?Q?YSBGKYZZ7b8Xt63r2UYNLZDLSZOe2FiOW87PeFySLIYVC8t74uj+vpCmyc+s?=
 =?us-ascii?Q?U+ot9/aI1SoOqEil7eZFTYJhqOxjyGbc9hf9jl6CWsV5TCoDm+Z69mXnniIp?=
 =?us-ascii?Q?u03pBApE3/2L7R+Ta0HtN/scxk1ie3Rl986zYyEMCSs34SBdnCY4ckFeVRri?=
 =?us-ascii?Q?mHLDbHXSDrmQ1S9uesSqIY6viEdgUY8TMvXmJNZu2V49wIJyvk784xW8Hzgn?=
 =?us-ascii?Q?VacK3GSdU08psD8KDp05Em3r6b9HqEHKbcgLCTFy4blb2mPsnSEP/RNcU9A/?=
 =?us-ascii?Q?D09gGQhJSWOOhdGvQkggXiK9HUL6Vy7mVAxEZjSh0hC/ONOFx/8Z/6HFHWs5?=
 =?us-ascii?Q?bb4GsNlXcPrW1RxJckC8MurfwkPneKml9dCgYz2/yiprDk5cgKmQfYKRzjaE?=
 =?us-ascii?Q?oWFpeS4J1PteXtGLWF4GX7mM8ElMIIoq+U7hJIBILzXoI8Ppf1A0oJYrQYTl?=
 =?us-ascii?Q?EXZkvzPeEIxoPOrywLxHs+izugRs5z8L7VxtD6IBj/q+AgjfVfoFhhypG37F?=
 =?us-ascii?Q?ywtXQiY6d3THBKmwmqAW+o5zerRVhLryKai9SIpymYMt/QoJEG3bqfvNZGvT?=
 =?us-ascii?Q?f4ofE4JiMd+an0911A1KXIWDLHDZhXN+0ptl43cLv+GTRXvVx/xh+45YTKHL?=
 =?us-ascii?Q?cpDzChGcibcGJFmXFz0wC6TT/rdm2ThVsqg65Fr+UJBy4DHCtV+n6e1038wJ?=
 =?us-ascii?Q?3E7IAubls0V8tuvizsICCGso3hB6FM0fJFAWzDpvLjMLII0b+uPItrJcar/B?=
 =?us-ascii?Q?cW48Y3hd+8Jc7WpS7QBdwVuPllDN81CFoKH0i5wyG6P6C9y5HrzA/PG7/sFC?=
 =?us-ascii?Q?WkUoxPOg6OlAPDgrk7CNYKCmQ6Xi9MjEu+W85dkCX7/EZ1CCgLNcklxN11DQ?=
 =?us-ascii?Q?pcScgWtSXbrycSzsOctl2WIl?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 4dcbe55a-ef20-4bd7-7636-08d91ad33cd0
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2021 14:34:41.2610
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HvURFz+qS6pR6BAg4RX2QqhMDFwheCDNrogwFIDcuhfQU9F4vOiMvuJhDffA9Rr8WLxFLoC99vi7uDCxxbYwm/6mmL9Y/VHPVInVxxQIFVg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0025
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadym Kochan <vkochan@marvell.com>

This series adds minimal support for firmware version 3.0 which
has such changes like:

    - initial routing support

    - LAG support

    - events interrupt handling changes

Changes just make able to work with new firmware version but
supported features in driver will be added later.

New firmware version was recently merged into linux-firmware tree.

Added ability of loading previous fw major version if the latest one
is missing, also add support for previous FW ABI.

PATCH -> RFC:
    1) Load previous fw version if the latest one is missing (suggested by Andrew Lunn)

    2) Add support for previous FW ABI version (suggested by Andrew Lunn)

Vadym Kochan (4):
  net: marvell: prestera: try to load previous fw version
  net: marvell: prestera: disable events interrupt while handling
  net: marvell: prestera: align flood setting according to latest
    firmware version
  net: marvell: prestera: bump supported firmware version to 3.0

 .../ethernet/marvell/prestera/prestera_hw.c   | 85 +++++++++++++++-
 .../ethernet/marvell/prestera/prestera_hw.h   |  3 +-
 .../ethernet/marvell/prestera/prestera_pci.c  | 96 +++++++++++++++----
 .../marvell/prestera/prestera_switchdev.c     | 17 ++--
 4 files changed, 170 insertions(+), 31 deletions(-)

-- 
2.17.1

