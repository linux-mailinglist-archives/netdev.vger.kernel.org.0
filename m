Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66CA5479519
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 20:55:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbhLQTy5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 14:54:57 -0500
Received: from mail-db8eur05on2116.outbound.protection.outlook.com ([40.107.20.116]:8640
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229876AbhLQTy4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Dec 2021 14:54:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N2doJapjTifYQTEynonR6/z1ipSCqMjJXCYS+e/URJ6WY+CNW+UAOUGTQm88zdj9XOi+mQ6XKIqRVzQkBVO3IW/vSElJ9+odsxqRilhZIJOgcjs3sLEfpFgZDa+H2C6Ac3+hf5osH7PsYc6MI2go1tIm9Wt0FA0CSbmSONIVrEzYhtUZabx/CvSgz10Ekrw0GHOFSlOfhoDfJnv/7DikVOP3bXVMk651Kg72L8NyjbkK13yfMLjKywv5tlz1YBcbxYlcqfeD3+o6c+3xTOTIQ85HWSiWtNNhA7QrnilOr3d+4u0HfrhhIw6W9FFyL91Zh6LLmryr663ntv05Ne7RTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZT2EujmMXRLKIAMElpbIuyHHdmD4XrXngc1PHnZWIi8=;
 b=CV3ejJ4RmaqfbBVy0mEILnrkIPKqJ9TF9fUCAt9qbKr6qWQT6YV8aCsbMcsF5LublQ84yZ91RGqBULLQGCZ1CXdoOeYNWlOWoLmr3IeUTZvnD6uLsNt0WaiaE5UOzIL4yAHJPJUdW7oaeETHDDXrG5VNhb+Ms0UDZRmJDG2MAFmAhQx1uK4ish5LkSVgWx7eKq389HBsrEz73LiZukYZJPDbHFbcOBHmPJBmb3DvcqMULZcfD/xWjJIp9iIBav8Z7m67ze1tynilzpe4rp0o9pGCQmZPSeJB8RWXny9USB9i9twsSJZX5n+IYcClnUoJmoJfBEgqaly+42B9wbz9wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZT2EujmMXRLKIAMElpbIuyHHdmD4XrXngc1PHnZWIi8=;
 b=x9S9DptHcDjyPGA+hy88eIc3WlgoJ5Gr/y8NdtYPA6DBScCIJpjPkfDBX/jJCBTKUAvykX7WZQQkysVaUrv23q7fiL7qBApcuj4xe+Q6LaJUIy3PsXXoviygjAGpLizOKnN8aPOvUzwVo6dc+0KfiaX+1qoxS9fwReZrLBujX6Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:262::24)
 by AM9P190MB1058.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:265::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Fri, 17 Dec
 2021 19:54:54 +0000
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::b93b:8d91:d56a:8256]) by AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::b93b:8d91:d56a:8256%5]) with mapi id 15.20.4801.017; Fri, 17 Dec 2021
 19:54:53 +0000
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 0/6] prestera: add basic router driver support
Date:   Fri, 17 Dec 2021 21:54:32 +0200
Message-Id: <20211217195440.29838-1-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0070.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:49::20) To AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:262::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6df0a363-39b7-4b67-76c9-08d9c19717f6
X-MS-TrafficTypeDiagnostic: AM9P190MB1058:EE_
X-Microsoft-Antispam-PRVS: <AM9P190MB105873E9DD6A47EDF227A9E193789@AM9P190MB1058.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E8Lcv6UrKHfOoxD18M/9WxOBn+N42Md3wogmcoDlXYLi0WJ2kF3rp/RNp6TfBFBaO50pxy1z3fkYJ04f8G3JCGQkeSSTM71odDlwCMvriRvcMaUSYXDacic5yCpXI7mUlf6MRg3ho1xeg47aMNLkdUqqwhUttZfwnswJoABCS4jamoM2+38MbRZc18hAFjQ1yzEp0HyhofiGCsntrzWWYyl9P9csHd5eaEYZNEnGYxqrHiRDBelpMKs7zsJnpLyE4WsnCHM1ifHs9OhFG46qWVbbUfdSweSWINQBFzM9Dq47fb7vHNvLtyunP8ab5LxNxfxblHCaEPh8zpscuHMkevTOFgrEbv1JGHXD+J9akIUgTaSBfIUG5vjzlLYaV6mL2LNSMNiz3HCSgZB18y6JGIazezJ1SG+dZii5qPgxoBY2o/tHaFjB6TjS2BgQ0Ittp/lOA9BrT2GnvMvqkaapDpdx7nEDsmZaMfb6GDV4zY6ZhvPngnFsf0XKA1KdsIoGw7+PXEy6sFle8QNO5DaOoLeBlg39XDqcDapPpRf6Zuob549LHlOphnXC/Bk1iy0/iicYiHnJ+5lw3tJSMwdLJHFk6E1Efa83wC3/AzoL+2NrG9snik5vNdl8CGXbUUawp1TCZa6/1xT6g+vTIDx7EAMECaURIib7BiTp+IKJ1bXWd1tC2GjnuX//O+wwveF2lqVKuZP10cyQcsReJiL90Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9P190MB1122.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(136003)(39830400003)(376002)(366004)(396003)(6512007)(36756003)(6506007)(6486002)(6666004)(8936002)(26005)(52116002)(508600001)(5660300002)(4326008)(86362001)(186003)(2616005)(66574015)(44832011)(6916009)(2906002)(316002)(66556008)(66476007)(66946007)(1076003)(8676002)(83380400001)(38100700002)(38350700002)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VUG8h00u1UAYWcga2AfGPcE6uCUnOmTQu9a9y9Eq9Ey3Z5DPzataghaaiQpR?=
 =?us-ascii?Q?SuckbOyPWv244/xDCvGbsEWz2bzc0Z2lTSWgmMsK3eu8ISjPO6/pK80QRd4o?=
 =?us-ascii?Q?aMSpizeOFPlqFBQor0i9a5zuORhevv90VsRTgswQVWfK5FHYABHN5/Ph7RWP?=
 =?us-ascii?Q?odFWJYJ6oMG34dsTfneXiEnwa/3El9Yv/2ujKxjWetSGawg4z81+M+xY8Rpj?=
 =?us-ascii?Q?MXNG50ATytLPnnwBEq9SoXi1mopUk6sbAHy8Ry6a+WZnCpty2K6BiF5Vj9wV?=
 =?us-ascii?Q?z9Tll7bbm8BA8xXz5kr4woOGDv2qms7hH/fELQZSJYSjPcb73JlMx/zhsbqO?=
 =?us-ascii?Q?TH+zK/o+9OB5a5s/3iacJOpkjaRCaW8wWlKrQGNHhFGxamRnvTgieRfyjQ5T?=
 =?us-ascii?Q?LkqJE/+tm4d7DAzWauU7w19ueYVzex1FKEoB4xe4c9wYVUgdcamNGBARiTN2?=
 =?us-ascii?Q?W9CblyTSG6FXXPH32v5qjK4K1QXIZ7tYaqI38CKHsNoRHXEJQuSrbPuwHi8g?=
 =?us-ascii?Q?kG8WK4Y6dscfxWX7b+Dyz29Chhthd6defO2n8wBaF4dHFsGxPrZk+CPbJztQ?=
 =?us-ascii?Q?42rW9aE922eTGgxMLwb6eKn1C0vGg4E+1zKF8TDIFnPJviUkpIPWtSkrILTe?=
 =?us-ascii?Q?j1LtOp6NNr2SIB/67qvEvU5BgfzNr5Pyb/YY5FQDK41HGfui6jj5j/2dVVeI?=
 =?us-ascii?Q?tbxNxQmNQF4YG5mEwKJQsFU43iUR1QluxjGbhxPxIRoC4Ba4WES6pPD69Yx4?=
 =?us-ascii?Q?Ax4cR6fIgooi/nfc3jVlRdZjzrT92d1TJxHZgkCc2rWZi4FTCgjYflS9SOg7?=
 =?us-ascii?Q?niOV1SJMS2iHMgZUK7ctbImhQFyVKlC+ve0gHF9zW+gE/oH+NtSmUDhLT1nW?=
 =?us-ascii?Q?dQdZzBtbxzbrwSiP06GGS2EzPzZSodVcxy3s7TvKsg1otqWWzmqW9yoCtxmF?=
 =?us-ascii?Q?0Onzno+r/b+ftsZKbA7EMNqEwKI6v9X3aAG6cgMfNlkbq73kwulpSAoW1v0+?=
 =?us-ascii?Q?Fc/1PS+9re/hUGB9i1eVzCvEjjHRb9Cae5lMi8af6CLuX5nQqpKYIDDELgEw?=
 =?us-ascii?Q?QfnCRC/S8LQ4yhlRNQki0oL8zxP880JSeNQhgsIBZHGX9B1BNzm+LSSHgrkt?=
 =?us-ascii?Q?mYWNFQzdkNT0pqtpGkkXhJZZRklgHRV2wBbm4+eXIUvF0QyGomZB9QekSeUB?=
 =?us-ascii?Q?+CZFswyYKEPlv2DEufSbaJlIuitdpY4kGWPK+MGoaKERKpqih4MjtXCtUDFW?=
 =?us-ascii?Q?boK69JKwP7bfEwzpPX9ThQKvO3ax41PA83d4HhhsMMUZGiAu6mSXcwsZ84SO?=
 =?us-ascii?Q?WhT2BMgbpkxC6BDkJk4jcn78H1RbKC2qrPsDXE6/LAILeyhP6n9daF6HBcn8?=
 =?us-ascii?Q?g1Pa8h9MLEc0fjzPplJSPYXeXgxLb1rCKyr/yCYlNE8tPqOU+cqNDnhS2HNk?=
 =?us-ascii?Q?6cpkUjhmlBUDxXcZioUKvhal9MN+uMXtmHB3sniBPoG1J07CjOseqDm3+Lu4?=
 =?us-ascii?Q?5cSw8EXWcDwLnp3MrH0GwtJhdZezgtVdFBlUjZmiYToh7XFBqaFugy9+BR9J?=
 =?us-ascii?Q?O9/dH/D+hhGQKIhZsOXuF8Z+sTMi/qpFzypCQ2DAbSb7oIkrfh0gzu+bRRzP?=
 =?us-ascii?Q?Yr2KCc+zvPDd1z9/JBU6UQJ2WIHUf9pH9zd0L/VCgYSH7jR7R1nEhE2QbdQC?=
 =?us-ascii?Q?MtDQyA=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 6df0a363-39b7-4b67-76c9-08d9c19717f6
X-MS-Exchange-CrossTenant-AuthSource: AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2021 19:54:53.6980
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hs29Cd/PDYu5zWgknvaAndVeDPeV5GyuFLWLiFEgRKU8KZDjZgIsGVKzP6EEXriU+C8TkhcW7g/tQWEXHwt63PiTGumh2sK+VXJtEPHrrbg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9P190MB1058
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add initial router support for Marvell Prestera driver.
Subscribe on inetaddr notifications. TRAP packets, that has to be routed
(if packet has router's destination MAC address).

Add features:
 - Support ip address adding on port.
   e.g.: "ip address add PORT 1.1.1.1/24"

Limitations:
 - Only regular port supported. Vlan will be added soon.
 - It is routing through CPU. Offloading will be added in
   next patches.

Co-developed-by: Taras Chornyi <tchornyi@marvell.com>
Signed-off-by: Taras Chornyi <tchornyi@marvell.com>
Co-developed-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>

Yevhen Orlov (6):
  net: marvell: prestera: add virtual router ABI
  net: marvell: prestera: Add router interface ABI
  net: marvell: prestera: Add prestera router infra
  net: marvell: prestera: add hardware router objects accounting
  net: marvell: prestera: Register inetaddr stub notifiers
  net: marvell: prestera: Implement initial inetaddr notifiers

 .../net/ethernet/marvell/prestera/Makefile    |   3 +-
 .../net/ethernet/marvell/prestera/prestera.h  |  38 ++++
 .../ethernet/marvell/prestera/prestera_hw.c   | 139 ++++++++++++
 .../ethernet/marvell/prestera/prestera_hw.h   |  11 +
 .../ethernet/marvell/prestera/prestera_main.c |   8 +-
 .../marvell/prestera/prestera_router.c        | 183 +++++++++++++++
 .../marvell/prestera/prestera_router_hw.c     | 209 ++++++++++++++++++
 .../marvell/prestera/prestera_router_hw.h     |  36 +++
 8 files changed, 625 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_router.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_router_hw.c
 create mode 100644 drivers/net/ethernet/marvell/prestera/prestera_router_hw.h

-- 
2.17.1

