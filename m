Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A02738B350
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 17:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233115AbhETPhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 11:37:10 -0400
Received: from mail-vi1eur05on2090.outbound.protection.outlook.com ([40.107.21.90]:8577
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233009AbhETPhI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 May 2021 11:37:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IKQrS6ldq1++LO0Gt/NM/iIfTeudNg2JGRD2iwnuD/wynh4fNZ85ta9nbywZqeJCWjP+Xv1h9lBYSO9yGVdOgI9aJP86QixyIiOnfGeow0a02Gm/OpD3QtNAvS5o6Bvwy8EHvS38O7B6B4MeDEVbZTVhNfP4qhPQ16uqeFlpNYx4Qr473B0EvrcpW0uugy45hez+BuMnWZW2wMT3y/Cr6WhX4n2986bUj+bRr1fw6X9a5wksk0Wq/DnkD9vYyfEVQIn3RjtRz9Kd1L7OBT93iUaOdbEGb+ioKV9GRbEBmLFuKnBHiSo1ZuhalXBO3Sv/JwjTLLzmsihE3vb/vg88vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u1eS9YU1Q83/OSBG2ow9gYlgLviqnLbY4FY7uWJZ9WU=;
 b=ExQxANkNi+eNsjW83oo1dZCOkhw8AWuYcKLgjLk+chnU7x8HW9NrWJeyPx/OppMqg0CUeeCIEINXiXKP8XP60yys/ti+c5FwWqNhYu0/h4tyTGVU1wIbhsrDDF3NCUYKYRlEhFF/i31k+GkxTHFM0kXvLa2jPnonRf4Nf1iViK27OgpAGDdQM44FGz0tY+jykfmPcEA5RBp9N3CMPoB8qroQs5qyp6Xo9STVA7FPs49pgd3BfhRiONwPu4aeOdFs15Jd0pP5ltUjT401WfKRKzlsLBWScA34rc43fyOfy+C4zd1rZSfTwIzwL+kw4uC6+bD43y8nHEACLR9DvM131w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u1eS9YU1Q83/OSBG2ow9gYlgLviqnLbY4FY7uWJZ9WU=;
 b=nV5/3kbz7+ZhhDjIXCAj8cBJDRGj9aLTp8lGXlTyWJtEPRb3yot+AE1m5Cs/C6/eeIUmhAUuq+P/mQCqKhEXpPm8onKhhZ65Z3Bth0D0WDJgb5Wg1t+LoNC4EiQoDV1/VosJWsegvGTdqwZq/YIu1vJxhYsdmqMwkv+eEopFYMY=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0268.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:62::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4129.28; Thu, 20 May 2021 15:35:42 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::edb4:ae92:2efe:8c8a]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::edb4:ae92:2efe:8c8a%5]) with mapi id 15.20.4129.033; Thu, 20 May 2021
 15:35:42 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        linux-kernel@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>,
        Vadym Kochan <vkochan@marvell.com>
Subject: [RFC net-next v2 0/4] Marvell Prestera Switchdev initial updates for firmware version 3.0
Date:   Thu, 20 May 2021 18:34:56 +0300
Message-Id: <20210520153500.22930-1-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM4PR0101CA0065.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::33) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM4PR0101CA0065.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend Transport; Thu, 20 May 2021 15:35:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2c6bc00a-2016-44c8-07c5-08d91ba4ed9b
X-MS-TrafficTypeDiagnostic: HE1P190MB0268:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB0268BB307047FC8E40342DC2952A9@HE1P190MB0268.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YXWvaw9U/CJ4rxgnTPNLplv7Ejaa7LOhPBpbDgKGpDrBgPal4ZkJ+6GKYCAdzkpocrr9wv7QUH0AyhL4iM5JEpFjUGrMLP5YmR9QNGybN8kRhHubY3gLs3a81wIyaTttcCBctntqVIsYK41lGtO6CxGYIWRet8lGKHppbZ1UGkcZ3yo43MPL+bGf+57klPSDlA/JlGawK3/lYhZLZ6xn/+HqQJmcAk5AlzBUC1WoCKfJQFMClroPjfgZkZsxt28QuaRbLK22XUyFZhPCdOm5u1i8xQP1zwU/GI/lOR/b6b11CS2K343hL9PPT/8Tz6XM+4gGfcNTpOSnDwLQhdB/37O8VyuVINz9fDOkQdFnelvZj6bJdDZQKbc449d/U1wTaZDu3vAxTV+hJrVKk3DOXrr0/NW+3lWK2Ezs/hEt4xgLl/IU82fpnjVnYbhOHi2B5GSINT8gl40v8JUsyfkJG1CnegALQEKmpJCyB/uuuNG4vcWMtH9C2PzfNt8SYLRprcbXoUv+F7lfCas7c+YnSauuC99oTYcIN/OCQV9GFuKw8abTDwtTr7LZWa5PoMTOYFx4Uwsko+/STphIJMKwmTvt0uaecdZ6HuNpDVWpLGESybS42i6Y4NYorePs01F0PciLBI0sTIXWU20+uJvF8g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(396003)(136003)(376002)(39830400003)(346002)(366004)(6666004)(26005)(15650500001)(5660300002)(4326008)(6512007)(66476007)(8676002)(66946007)(316002)(66556008)(110136005)(956004)(54906003)(36756003)(186003)(16526019)(52116002)(1076003)(2906002)(8936002)(83380400001)(38100700002)(38350700002)(86362001)(2616005)(44832011)(6506007)(6486002)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?MtU2kJhqwCeJ3aJOrCLtWxXJxJ1aoe8bv01FIFWL0Bn6moaKECM33Ob+hhzm?=
 =?us-ascii?Q?KBjEF2UypGF+1F4U6QYYZHep8yqBUaZyQwMinBIu2hIQyEsg+uu9wHFbQGK2?=
 =?us-ascii?Q?dme17oe13D6T43gii4KwkWW8q015/y0GEcZCwFpraksKBwJn4n7pnxM6CARx?=
 =?us-ascii?Q?NusZheirfU7vjkC4GjyrmOaVWf4t5Gl35wEkblwW9f5NKiMDsz72JGoxSnTL?=
 =?us-ascii?Q?+9NT07N8vpR/a8bsbTfI0dhUvI3bkdBPJc9RBeGq5x6Xb31EveiwPIFNrdrQ?=
 =?us-ascii?Q?hs4NJov5IS8FCvHSxRAKqkYIkxBGtHLxJ3N8+y0elZInO4+xzOXt8t07n9HN?=
 =?us-ascii?Q?ICZ8pJ38317nTh2Flbq3VpmyWUZiOWRpctomWJlorJMaPWO0FieZ1Ff776sc?=
 =?us-ascii?Q?dN90aa03h0O1FNpPC6Hg26/gba3ueS/zKgRYp9cu3l1W2XHlS/1qijEginyC?=
 =?us-ascii?Q?xlrHNWQF6wvrWU3/7Bj1JlY138GZHsdR7PvZUHIAMT+xtSqCa1u2Eua7MqxF?=
 =?us-ascii?Q?j4sJogsFIXtebzG3hhq7gfwnkunAbkWpgMW2FpG7NgHp4MySImA/2+YAMKrj?=
 =?us-ascii?Q?325DhfcB1R5KHIr8K+ePXGaqdrB1kNxXv5lWuwvBS4k9xKR2qlaTghYEAT6j?=
 =?us-ascii?Q?guNJIqyHFgzz4Rfhr85J1g7IfKoD8J0TBY3TIduG8mAoUljioFbStdAYrk13?=
 =?us-ascii?Q?KjLnV6ADn5nlrtELBiNLOKx2Sl/gX/74H9QR9H3m28Vidbdii9BmYmy209Ux?=
 =?us-ascii?Q?4H7hQ2OSIlo4Tlsz1ndHVae/SDQiOI4Bk3DtzlR/FdidNSgqU8Q+JYUWY5cA?=
 =?us-ascii?Q?I8EUQiUu2TU7UirOwI3bbIIb96pNsaDFaTBk8IRji17otgR7P25bQVBnKuJ2?=
 =?us-ascii?Q?5ENI73wvGJiQGSwJhKCgQ/8cSDTwHyO3p6MFnS1IhjoHFTa5zx5Ck43wvqsi?=
 =?us-ascii?Q?iSOwIoAPDlpaxxOZUmVCKdPIoFcVoSCsqmowlalYRGm0+ABgUbArFololKfI?=
 =?us-ascii?Q?ttPG/e4jTBYGDqSBO6PqvSODiLM4mpHcY3e/gY4XKo/rXuvzgtzg8PTcx4Gd?=
 =?us-ascii?Q?BlOwrpwxRpdFNeKXZsEjCSbMnngHAQckstrPEw+4HhxyaCH1qRQ0QY5E/WKq?=
 =?us-ascii?Q?HQrr4N1fxmMsvSwcRQpjU7GU0yg1YoVMqqcohTLIetj+w8T9UI4X9Yx82GM+?=
 =?us-ascii?Q?AtnwNb6W+6UVjiCgdBvEzdivHP/oBCoQ3LlT8OT0Vq26KC5JPHX+PjlJwtL9?=
 =?us-ascii?Q?ixYStCAnfBXbOGqWs/XjevmgPeGeguZsSoqoW3fptz5L3RUfOsId4srQbl/4?=
 =?us-ascii?Q?WBflNjXEHp43X/aMBzHaH4xn?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c6bc00a-2016-44c8-07c5-08d91ba4ed9b
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2021 15:35:42.8490
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mvUromHyI+hvEHi2FdJhF8W9PzjCO3pMB7sWEq/AChNwvtYkDtZO6kS++rGKwMAG40xFQd/WoXEJMhrHxPPidmOf1s4o1PzehGe2z2k6yao=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0268
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

RFC v2:
    1) Get rid of automatic decrementing of
       major version but hard code it.

    2) Print error message with file path if
       previous FW could not be loaded.


Vadym Kochan (4):
  net: marvell: prestera: disable events interrupt while handling
  net: marvell: prestera: align flood setting according to latest
    firmware version
  net: marvell: prestera: bump supported firmware version to 3.0
  net: marvell: prestera: try to load previous fw version

 .../ethernet/marvell/prestera/prestera_hw.c   |  85 +++++++++++++-
 .../ethernet/marvell/prestera/prestera_hw.h   |   3 +-
 .../ethernet/marvell/prestera/prestera_pci.c  | 104 ++++++++++++++----
 .../marvell/prestera/prestera_switchdev.c     |  17 ++-
 4 files changed, 175 insertions(+), 34 deletions(-)

-- 
2.17.1

