Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3FA63A7E77
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 14:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230380AbhFOM5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 08:57:16 -0400
Received: from mail-eopbgr60122.outbound.protection.outlook.com ([40.107.6.122]:62803
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230079AbhFOM5P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 08:57:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fs7JFNXGbtlW+AknVFLYcNBoRsKRaH5aHz6tkenRe7gVmpYq6Y46unj+zRdeA8blgjCy24jdnyllHveYiZToFUmzcbxZuHNz7uG6pP4P61LOH0GzmiZ/OZVM2IDpxrO1km76fXD/JT7lfxgP5XBRuhtvBRr4IaW7fZJXFf6RAI16CI8M+qTBGZrE1sPlCntOoX9HFKnwdgOCu+zi3GX/6b6V5pR+h+HeTN16vUTC9YPSdPyKfkvM/NaTy24ngdWsD1cLjT34vCBAE4EvG+PHg9n3h5853kUaA7l7rhZSEEd/YzdScm9A2QnbYyvblnLycgohJVQCJR4bJdT+62UJrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rM2RgKar/nTrRxRKoJSYrXqcPrpzEAnWArRiVlgehY0=;
 b=nCxzep/6EfQj/0ASMpPVE+oBvtdz+iRnVgJm6IAoE9t1sZk5l1JVpG6YbKT+DX3HW9Znlv2yUK9UaMBvjPVy0A+SYwVFxdr7PgeE0D0LI2n7mCztzJnVSf6VRV2ErezH6haO8kQ22Vn4nTQfFGfJuMF2LLvPLMPRpx+f8JE5mzS+p4p00A9VIh7W3dQzD8SNYocT5ZFzt2CRYYkewW4NfNe0rWnKaPAtDBRWaPJylYodVgGtJ7Jsc11WF3AIUX/GcU1ris7mNVD4GuIo+7gwm7xmNllRzDKYWVUqWIEoBWWKJJxmgbV3UhzX/pD2Car7bchFr4P9Yb+6ywQxuV/m+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rM2RgKar/nTrRxRKoJSYrXqcPrpzEAnWArRiVlgehY0=;
 b=KqLurN2if+y4FLVm78MvLtFOteo8pjlqXCk0HWegsz4QCGAM03HXx/3KnIUMVRH97fTRISXDChRPtwiAVi3BYenRVlGZAh0GAT63HfjPqAVfwGBmxiIR1kQIU4b9oOMPOQUH3Y2+XDbs4iYWlM3OElFEguz15q1HRSBcrx8IC2o=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0124.EURP190.PROD.OUTLOOK.COM (2603:10a6:3:cc::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4219.23; Tue, 15 Jun 2021 12:55:07 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::e58c:4b87:f666:e53a]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::e58c:4b87:f666:e53a%6]) with mapi id 15.20.4219.025; Tue, 15 Jun 2021
 12:55:07 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        linux-kernel@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>,
        Vadym Kochan <vkochan@marvell.com>
Subject: [PATCH net-next 0/2] Marvell Prestera add flower and match all support
Date:   Tue, 15 Jun 2021 15:54:42 +0300
Message-Id: <20210615125444.31538-1-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM0PR10CA0036.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::16) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM0PR10CA0036.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Tue, 15 Jun 2021 12:55:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 85bfdb7f-5a33-402e-5027-08d92ffccd75
X-MS-TrafficTypeDiagnostic: HE1P190MB0124:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB01247B871EA1F418018FF24395309@HE1P190MB0124.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +zsvGc4OHFQ3yU+TFh9r9zaBvA5tHgu0WP1rI0z7+U/XTiVzNSkMQNtJniETiO807+DLGn1ug4jSbpYfCG84wE7KENjmlgceOyaM43FOTN0ZIxnRK53zrriW8pfx72qA0C5UuCuXHS8UxrY982EvrGVjRBOjNV1CJUudvgIGhpghfyaWUKCZDQldAEmjI5EX6SOd9gdGeuXZP9vfbw4knE/CdWmaRniqYF3PJpyjp1dLD0tJY58Ju04QPERzU+5bDurBZfsRwVKy+2mb+EWQnmB8lYNQqdaVpO1qsVnoRly7iczTc4IzujK+nrmsE0BoGiwNSGH55neQFbH/Aa7aRzux/qvdpwm8RbztU2lexT4pn8ETzOb+u1BegUUFA0+5gPttUzC4caZDh/+plmeBGQ/iEIJ7GezPHfsC/lGl/FC2AwXeiey1CD/YmUI6uXoyOgoiiuZcPKkoJ7hJnRVaFpC607WJV8OVyDwsyK5ABV9PpmAzxhlEjoCeK1X8z6ZVmlmgVZE9+nctxKuesY0noEY1l6x+Wnc1LJa0DqG85Addc6Z9olRYILdW8O1yitkPJRwptOESfGQL5PYmF29dkXJtKXyaqLbQQ0XdO4zBZDcUznmQg6PriNlwMUsSxDzhMyaDwPlPQu3yVX+d+3jMvw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(396003)(136003)(39830400003)(376002)(346002)(186003)(316002)(86362001)(6666004)(36756003)(2616005)(6506007)(956004)(44832011)(8936002)(8676002)(6512007)(4326008)(52116002)(6486002)(478600001)(110136005)(38350700002)(26005)(38100700002)(54906003)(1076003)(83380400001)(2906002)(5660300002)(66946007)(66556008)(16526019)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ibJbHO5lWhIVZnkc0BBcZpzOlMko/ENUVpnIc6MDUwXYOJHLRmuiEsdHRosp?=
 =?us-ascii?Q?88Tyc7TwcvKbyjhXvuAuxNJs1wWFPeX/fJYUXW6YDJ0gdyegNG5qUHzYsI9A?=
 =?us-ascii?Q?a7AMPVY0NzQz57pzvvWPPFLq20YyOhV25xK38GgyvMuHVwfTqVmLAIlsFfqT?=
 =?us-ascii?Q?rIhE+q4FwcndUiJ/UzK+PR3bjGFolSwvsjMA1XuFIsB1+8nfNCPjgPiF0eV9?=
 =?us-ascii?Q?5yWK6zB4aGRN+j+lm0I7Qekg8PB8wSUv9iCOQt+DIZstUj0pvBamPFWM1gPt?=
 =?us-ascii?Q?mqmUxci+mIO15eLX9+Dmo+avtXFuVCYq0X/WcUjGFhIzTcvC5FAk0kshgJ81?=
 =?us-ascii?Q?iiWonFX0awNVIfxnGdlyqmOTwlfs2uVikSDzvEV6Vz1r42/yPeZDnGfe3QYS?=
 =?us-ascii?Q?IkZGLSgA6tOARXN6/uehVTdyp3vwpbUfOM7OkcZI5C6xmrCqRuwMI4xlMtrD?=
 =?us-ascii?Q?UUSL3HnvNZZK+642GuLE0Ei505e78DxbAOy1wOrlqG+3dSR1Y4ybBRzYJSGu?=
 =?us-ascii?Q?yRQFf2xGswzFpyW4Y2zDhsEJ4mDXINiUuAGO2v+/rGMuabZDfQftnqkSyIpa?=
 =?us-ascii?Q?+HQC4mT/p/zrAIaUi2pu9O68qIujwCFQIcjmi/2qJSeB4U6w6+4v4gUv3VaB?=
 =?us-ascii?Q?9nh2xTnco+Nls5WqlCCVQWjttZ5GKh0uzSDq1J+02DSZEP8S91c/nvCXvh+w?=
 =?us-ascii?Q?9+snzw8BwWcsJlY5ty+3xSgdV+wJ98EvD+NXxCdNVFWj+QhMdx1jcQMWq2AX?=
 =?us-ascii?Q?Sc6Qb1ZtZba9wYiKciPuf8At3TkLWC3mdEC3abSaz49bTvQntmTLgtfeVwKw?=
 =?us-ascii?Q?kVyFPElRD+kVSmiFH7JqlG2d8k8pWWfUkw+8dsf4+Dn8jlGXKN5VGatk3GH4?=
 =?us-ascii?Q?majX3PjciwRaJj65zQkyZNx0GTnsI4DJ4ACd58rTu/XQZGquJ8aIZePPSmVH?=
 =?us-ascii?Q?MWhqVfZPV5aC761FnmLFohLnJJONdjV+790qlKxVg+BOfMjIt7G2jA+oeKHL?=
 =?us-ascii?Q?E5D3cLNqdDqILyzVzZlRN7dColWPLAO6sLzjWD9HedXeakBWC0eQOIf2rlvT?=
 =?us-ascii?Q?Za+JxTV44VrV5mIQZ0TruZK/2aeikPdOW8/ZJIPsb4UFY5/hMDz+V+4Lqjj0?=
 =?us-ascii?Q?s8ag2U1GQ2p0xlhdKxSsnUtvKPTSe7cHmdl8z1BEe4iLWheNRcg05H8+px/e?=
 =?us-ascii?Q?YU/K1bRBaXjjayxvQEyCtzLC4mOsjyePmSCOLeIN6AOSWoNvrSJTbF42gZDr?=
 =?us-ascii?Q?rljIQULUPsVuIE9EGSVK5/hfqiID53JH2NR+3q7xy6kPeczYxppW6kUAoqm8?=
 =?us-ascii?Q?SicDNkoIzAqL7Zm/1Ev1Hdjg?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 85bfdb7f-5a33-402e-5027-08d92ffccd75
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2021 12:55:07.7186
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yc7cYdLDCyeEyFgsNJPP+7CsX7NfxOSBsR4HavIAIrIoJPQNaN9ZIxa1owoibN90j/k3+ZWDrRLseXTVuKmtNDt91Swj0EpwqRmvUUZaC90=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0124
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadym Kochan <vkochan@marvell.com>

Add ACL infrastructure for Prestera Switch ASICs family devices to
offload cls_flower rules to be processed in the HW.

ACL implementation is based on tc filter api. The flower classifier
is supported to configure ACL rules/matches/action.

Supported actions:

    - drop
    - trap
    - pass

Supported dissector keys:

    - indev
    - src_mac
    - dst_mac
    - src_ip
    - dst_ip
    - ip_proto
    - src_port
    - dst_port
    - vlan_id
    - vlan_ethtype
    - icmp type/code

- Introduce matchall filter support
- Add SPAN API to configure port mirroring.
- Add tc mirror action.

At this moment, only mirror (egress) action is supported.

Example:
    tc filter ... action mirred egress mirror dev DEV

Serhiy Boiko (2):
  net: marvell: Implement TC flower offload
  net: marvell: prestera: Add matchall support

 .../net/ethernet/marvell/prestera/Makefile    |   3 +-
 .../net/ethernet/marvell/prestera/prestera.h  |   7 +
 .../ethernet/marvell/prestera/prestera_acl.c  | 400 ++++++++++++++++++
 .../ethernet/marvell/prestera/prestera_acl.h  | 130 ++++++
 .../ethernet/marvell/prestera/prestera_flow.c | 215 ++++++++++
 .../ethernet/marvell/prestera/prestera_flow.h |  14 +
 .../marvell/prestera/prestera_flower.c        | 359 ++++++++++++++++
 .../marvell/prestera/prestera_flower.h        |  18 +
 .../ethernet/marvell/prestera/prestera_hw.c   | 361 ++++++++++++++++
 .../ethernet/marvell/prestera/prestera_hw.h   |  23 +
 .../ethernet/marvell/prestera/prestera_main.c |  98 ++++-
 .../ethernet/marvell/prestera/prestera_span.c | 245 +++++++++++
 .../ethernet/marvell/prestera/prestera_span.h |  20 +
 13 files changed, 1891 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_acl.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_acl.h
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_flow.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_flow.h
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_flower.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_flower.h
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_span.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_span.h

-- 
2.17.1

