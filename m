Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29FEA1E6569
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 17:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404175AbgE1PEl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 11:04:41 -0400
Received: from mail-eopbgr140098.outbound.protection.outlook.com ([40.107.14.98]:50633
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2403876AbgE1PEj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 11:04:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P/2H2Nvi73C4klz1srsS1WwXiivZQCha4uXrh1mnEGHiAuE8fUa8vnDPMfcxr+FXA3SUM1AVUpzyIrxcM7+8Tknoh0X77HCTka8oYFVar/VC7nEOs67O9i19pE2/88DBXcy0us3MG2UqnZRuGhGL7w7ttVqUaU9oqwx5gn5yXlV+4O5o9LhnHf40MeGTwjXnpYh7CjKve9XyK2dONqPVx6pWUf8CrcU/u7fLrEJvfo2z5GDWLx6SphCaYVwbuHzGzWgjJgcA+jsYFib1xMATUANc9MpyILvi3X/n/MpNgQV9IIQw3uQPzWwJ6HDFQlwTKcUnViCNO1cTFevH9YWpAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nzXk1J+B80TCT4lmElIl8IETkow556enx+REfNroyMM=;
 b=SYjGtYhhdbM6i84ilJgs2LRd9Iu2FB8kf4K6sfnE3ZymlDmWaqDG11ZUtxwBgsK1A1x+K+FRxiJ93ANw+QExdtRKqgktrTZL1d76Mjn/ZUPZjEVLWVdg2H2FtHojmUbp9DmkL5pL8U0BWiQv6h95T0TjLe2/Wl/OzV4Ga+ldABG+IB+7IVlaFiS/tIVeTn7ajS9u6zT38SYQG/27QBguEymb2c4Ve5k8B5I1QlBfk47d5eeQ8igflRN7yPSinz70IOJZ7nLB3KD3D6AtZu8Ju7eqq+/EFksRssYvxt0U1ay/w4COXWu/pPidm/lOZDTeV8//p52LjsE3QmjMI4v0pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nzXk1J+B80TCT4lmElIl8IETkow556enx+REfNroyMM=;
 b=uC52VpSnmjur26m3HDyGxVUGhL4efc3ae5pOmpLOr7ZGrJotkzIvWn1BqxOzaos6hkvK+UYhWq9B6UWlYhqWY3OdV16cH/b7oVXdqyJ7OUWEr0bPR5WRkOCQAibgOCDKZNXA4/fKCTHkNzXfcV9VHPL5PIy+xXO5Ww9O0g5r8i8=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=plvision.eu;
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:35::10)
 by VI1P190MB0590.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:123::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23; Thu, 28 May
 2020 15:04:35 +0000
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::8149:8652:3746:574f]) by VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::8149:8652:3746:574f%7]) with mapi id 15.20.3045.018; Thu, 28 May 2020
 15:04:35 +0000
Date:   Thu, 28 May 2020 18:04:31 +0300
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     linux-firmware@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        Andrew Lunn <andrew@lunn.ch>, Jiri Pirko <jiri@mellanox.com>
Subject: pull: mrvl: add firmware for Prestera ASIC devices
Message-ID: <20200528150431.GC13898@plvision.eu>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: AM5PR0202CA0023.eurprd02.prod.outlook.com
 (2603:10a6:203:69::33) To VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:35::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plvision.eu (217.20.186.93) by AM5PR0202CA0023.eurprd02.prod.outlook.com (2603:10a6:203:69::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Thu, 28 May 2020 15:04:33 +0000
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 75aa7240-e1d2-4b24-d96f-08d803186efc
X-MS-TrafficTypeDiagnostic: VI1P190MB0590:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1P190MB05907280FAE96B1528628691958E0@VI1P190MB0590.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:352;
X-Forefront-PRVS: 0417A3FFD2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z0OY3eiDZ/TsS2j4AUiKgYm2yHCwIHf/FnU9Aea2x9+PGhmxuAbo9GAkyQY1CL4tGeYR/R0HYHIin51GsjSnmYvF24YnX+cyvHTMgF/lJxD3eRV23of4FkegRqhlSDuly8sZ6eRix5/v5JiAQ5mcYfZHFRqR6vh8Jig7w9UmroLI/lBAnJh2w7Ft5y6ZYu+rveYpMICKiwCBNM9QyKOQ1O2w4ACpZxq0qibZQnALuNy/CCd/R5tc0lEoPe1ap5nE81Mx5I7akDMAMzqV6bqLN5gtoqvCX5AIivpQCVFG63wzGBg9Je+uVdGXKA2LCKwz7j1V0qa4r9VXzYa2SCiSC/ct+s8ao6qbmkCeHfG/ba69PyN0l5+LtBUu1+q2b617l0gC6GQLmR+gRudyEIMXkA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0399.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(346002)(396003)(39830400003)(376002)(136003)(366004)(186003)(26005)(7696005)(508600001)(4326008)(36756003)(8936002)(52116002)(2906002)(33656002)(54906003)(6916009)(316002)(55016002)(86362001)(8676002)(966005)(16526019)(66556008)(44832011)(2616005)(956004)(66946007)(66476007)(8886007)(4744005)(1076003)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: IojViB35SwQT1AJkZWroazVan3xThfFUDWAFH3Qe+qX/EWzBqJ1PNbmsTd8FwBr8WpHbdz5s+i/sxlVXQ4l0wPy/bI+cte3lb8CfWhuvtRjoAu9a6yFRTvtLURnOgiI9IuqhdXyctbChtyMCfeLKSwNiWTYsOBPLzDGItlyNQGxUyF4p8I49Zgdok1Y/lTCpbAzCtbThX9QBdKdjFwSe2BJfvYN55uAeUG3zz2Yh8RfBIXQXeKHr5Xckkon9Hn6J0faePrqIVezLV3/1OmIIxxxykhl2bihPrtX40z4PCdwNSkOWUfMM3rnzuTkEuTaERIEhu5LYhYV83F5BcUaeTXg7e50oN/bTFmaPw/FkXhrurs7NG+k9vUyWqQ6flQEwohdf1WnJ0QoNjTvozN2s46mlGls2SJn6xoeLshMjPxOXFC15aAYosaXb+nyIURvYwsRO2MrD6OzAQccEKosWB0M0X8yuK1LxjIRNrEpBAU0=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 75aa7240-e1d2-4b24-d96f-08d803186efc
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2020 15:04:35.2466
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d0bs7yLyhGVvJzogB8jIjX44pDdzwXctLTGjsryLjY/aW3ZWRn5gzuDrF47+z2ENPqGLToASSkxYyXvLqfNBTeKUJEXR9mR2ZXiLpLAuHSY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0590
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following changes since commit 8ba6fa665c52093ddc0d81137fc3c82cee2c5ef8:

  Merge tag 'iwlwifi-fw-2020-05-19' of git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/linux-firmware (2020-05-19 07:28:12 -0400)

are available in the Git repository at:

  https://github.com/PLVision/linux-firmware.git mrvl-prestera

for you to fetch changes up to 561100014bb60b17c070aaa5449ee9970afa6620:

  mrvl: add firmware for Prestera ASIC devices (2020-05-28 14:07:49 +0300)

----------------------------------------------------------------
Vadym Kochan (1):
      mrvl: add firmware for Prestera ASIC devices

 WHENCE                                  |   8 ++++++++
 mrvl/prestera/mvsw_prestera_fw-v2.0.img | Bin 0 -> 13687252 bytes
 2 files changed, 8 insertions(+)
 create mode 100755 mrvl/prestera/mvsw_prestera_fw-v2.0.img
