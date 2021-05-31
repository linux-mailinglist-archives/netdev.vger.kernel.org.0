Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96D0E396134
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 16:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233732AbhEaOhf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 10:37:35 -0400
Received: from mail-am6eur05on2099.outbound.protection.outlook.com ([40.107.22.99]:51826
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232091AbhEaOfI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 May 2021 10:35:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mzGQo0JtB51XVS6t7upZ0vx8QUFWf+mAoDSukF21xaYkPvlQRZEWe8NPXqMceO27QzQktBjPkuDpc6F4F7OcrvHupog7PNf2rSVyJpzqG1dSQc5tMtNtvumfd7QqJx1Z3oVPTdjV9u9i7mO+nj9d20yoixkgPQDDvzbAw9NEdB+qxhsrlYvzu/iqjONli2WQKljIa5HpQy6Abe2uLuRdOLi8hAwTmlDTMroFB5UcXfoiOGb9jkecDrOdAodz0GZidg7l2n4uk8+q1qKq7M7qQ8zxvS5YO8vfKvtRz/F6dSDAlD+vH91Z+UN0s4+Vh4Z202Hwb5wYbKRzzYwgbtvwWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Obcph5sUd0iHm8byLLHcLv2ZWozpIWcfgZFUCWXkrU=;
 b=IUTLmgT68LHfb1lG2F7d8SHn8pcFFX5h/dLdqztliY94v937qXGjRpE7xzZdiEszHeOYdhzREc48nqX0ceXMmfHt3fiIU55jKZ6+IOMuHhU3WcPFyJMtGDdAwtQUMAW0TTfWWdmifJEpAmXLvZ8j/PMBLUiHdagDy3gZ/kS5ywBag8nfN9r+ImK5vjuPesmVwrrZdhDI9NhFEpK/bi3OhimydNAkaFDDhG2ZeS2ER7trDXJm5DFCyaqsghbKH8dmF/aXgaM2T0kchVGMjTa1M3pGm61ExvhJxse8XlhouDGbdj4j6T+7mRgYfNB5+tg8UDzrJ9J15fl+sXH0jsReGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Obcph5sUd0iHm8byLLHcLv2ZWozpIWcfgZFUCWXkrU=;
 b=K8n+PQpKpKAN/DAKzccqqE7ymkjMKQFHWVUO5SIRtw9xggAUV0sggnz4rAc3UhvoymZPAwbgh3boDM7mFR1lgaAS0Ei8P+18bmnk0gUrMztjochLbE7r5R84RPZapzDgR0JbGVLe6C/eglxEhFsAQKuzhLMtC8OwxSQVlFGeSHo=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0459.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:5b::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4173.29; Mon, 31 May 2021 14:33:24 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::edb4:ae92:2efe:8c8a]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::edb4:ae92:2efe:8c8a%4]) with mapi id 15.20.4173.030; Mon, 31 May 2021
 14:33:24 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        linux-kernel@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>,
        Vadym Kochan <vkochan@marvell.com>
Subject: [PATCH net-next v2 0/4] Marvell Prestera Switchdev initial updates for firmware version 3.0
Date:   Mon, 31 May 2021 17:32:42 +0300
Message-Id: <20210531143246.24202-1-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM0PR04CA0036.eurprd04.prod.outlook.com
 (2603:10a6:208:122::49) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM0PR04CA0036.eurprd04.prod.outlook.com (2603:10a6:208:122::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.26 via Frontend Transport; Mon, 31 May 2021 14:33:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2b7ebacd-35f0-4c2a-0752-08d924410bd0
X-MS-TrafficTypeDiagnostic: HE1P190MB0459:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB04599954A025863905888970953F9@HE1P190MB0459.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XdswGmY4Zcrbtuj480LiYXAuILoF9sCleugnKxVIH0Iudo64ho3Owr/tn/0tv4YBAjRwcz2aO1b5N3FYSCtGO0WsI6mpckWjQTCKJbe/Ka4AB3tTIkhngjhf/BE414fe/VrO6QVHfXSMqVcl5dG/80BIghuHB4JJaH4Pjx/HV/2D0m8xKr7jyKoJmD4Q+U2m0GZM/a417IclNQ9u60XNFFIrQChEuZmGUAxrNdelXyS8TMvMoxS6b3JABN9D1EbVd4iM8/p+4bSlVhCuRV0HC1QF6tlcNloAoLcYsE5bN0zYMgRsKhfsubHEeFRMiZ9vSrmCJeQOcveuVw7N4w6ZPbEKf3xvDm6tuxk4EWhHerFzCsG2kKByF5wsk1wvrqMYLQKM2t6kj8wGfUBwBAjVd7c+lLdx6DbO7iKpWzrEB8ZxTzhnOVT21064D1ecfxfyC7NgKYo/RoGCWlE3Ff8mCwLiXAq5O4uCkrwlWBmWC+5f6TGJWDRGUJG+TueCB+wN1u43ujmw0rARsPL4FEIQrxL1ZAInMg6awkMSGzW0ZAyu9uTnOXFH2uCujLN2AB73//U+L38k321jbUlROwGJvEYzKMVumBNZzL9yI5iC75QVr2ub9T/RmKjyyJiuij3TPuwHiutsRbDwuLXABVIb6Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(376002)(396003)(39830400003)(136003)(366004)(16526019)(26005)(5660300002)(15650500001)(6506007)(8676002)(2906002)(6512007)(6486002)(38100700002)(38350700002)(44832011)(316002)(186003)(66476007)(54906003)(110136005)(478600001)(66946007)(86362001)(66556008)(2616005)(6666004)(4326008)(36756003)(83380400001)(1076003)(8936002)(956004)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?4j5SI7aEGtQ6Z4YdverKIEwoGzVUo2ThtkZZIkBhkLV6Xq//BK4oXmEjTMYt?=
 =?us-ascii?Q?HlWdF/LoICt1tmK4gvoBhmNaYNYlNq/xI+C2P3FS2tEzSe4UcSjfVFwumT44?=
 =?us-ascii?Q?sPoZOBc1cGqCpAflGQEyev5jU00yEe9WMnQUw0ARf3uEzz2ESXOQQNELOYgJ?=
 =?us-ascii?Q?Fqou+V45PmK2M99+2Vus4bNFWTsq3Ktu1qrqFLnDb+nVUr7ujP8KkhTmu9+O?=
 =?us-ascii?Q?NojgxwvDV1hl0LMwbTyF1ubM9VAbDggT/enxdkTnbguX4/jDLrGrLNhXudrT?=
 =?us-ascii?Q?wKZUhCp0ogs+FWxKXtL2nLw4+LOLTeR/hlY3ovTB6HEtOhuKdbmXo3DLuMUg?=
 =?us-ascii?Q?stymDSLhgLu/ZaOTjKMet4K/aYM+lEKbFey11C5Rd8vUUph7b3ZJ+33EDlre?=
 =?us-ascii?Q?gJfF9eOD7f2NS8b0IvSQdxBF2J43nv+HRVGJx7B+IRFqwSHnT+h5dFaYqlSc?=
 =?us-ascii?Q?XlIt8LUMEX84eUbb6j9qunp8/vfHP2FgAf6QNP5epYeWoX/xPe6LfU+DjPF2?=
 =?us-ascii?Q?WkqL2ClXZnXc26G78vLT2QRuqC+C4jBWbWP96+/gsOAUwn9QT4mN8M++xvlr?=
 =?us-ascii?Q?D4+Wt/mZh6i0C/Czd2w0zuJnIm3Yz+M7K3L39nzu13Rjb3ErLifc97oRY2wu?=
 =?us-ascii?Q?cumT5+gb5P+MPrhIWWjQbACWpcRrKGFvKPyOoHGt6jNg0LH23+wWhcmN5AuH?=
 =?us-ascii?Q?fhkelSxdPI3UXzycwXQzxWsml/s9Z8Kfy8MZWc+uejP0TFHrI//5g+Cey3YM?=
 =?us-ascii?Q?XYf7OtxtzzfnT097Ih53RwTKtjH1dVoVnasUjREg8FxWMGGrwtnDOEbv04xo?=
 =?us-ascii?Q?LIn5iuB03Nv7Hbc9ndG/zEaIDou8k302omLfzCLyoQy7RjUiZ5/NjBeRVYWS?=
 =?us-ascii?Q?8aU/aiFoHYguXdFOtEqAgzRWXgkVCzjZe6zQDXQvtm6eVP+MBXNJh+4+g4bV?=
 =?us-ascii?Q?+ybn4AKyY8Xr1Ii/oCIzcis+ve2r/CoFuSTSxNFfpSo7sEqkSB6VL+QKopAU?=
 =?us-ascii?Q?IWIoR8d8pbA2HwQoBI+wW0GuixTh3qagBRAl4KGfAc5A9SOyuuDPEaEEgHN9?=
 =?us-ascii?Q?nnQMTxBAGuwfLrynVRUG0d5ieNEMKoKGR4+XMIvac4h6VBYrCFDZD9ECYM67?=
 =?us-ascii?Q?DEmRf0hLT5/HxJLS9y7TLdWnjXH9OlFpO/HWpBGJKW/HX8JzB3o0qWxOC36n?=
 =?us-ascii?Q?/ckbHQAXpZ1SUKi4eiL/bGlsv9bOrkTNpRNhHthhCtczZ8Fh0Ls+R8DK9lbK?=
 =?us-ascii?Q?JRsJq2AYzWz95X7ehwbAehmNX93LDUjWWFftOEp83LMffN+wayfZkk9moCTL?=
 =?us-ascii?Q?v1lDrTTnsb3LldB8WbFALfUY?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b7ebacd-35f0-4c2a-0752-08d924410bd0
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2021 14:33:24.1581
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uDFYkL+LRnZHY2jD53auAy9EPVGK7c/xvSno/AN7lMlnzxbaVNVDrBMYGdJvAMddPyPe3cIPgI7pMFxHNkRtu6p046EJ2YPeivRSXIgF9rs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0459
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

