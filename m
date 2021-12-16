Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1C15477A00
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 18:09:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239805AbhLPRJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 12:09:03 -0500
Received: from mail-db8eur05on2136.outbound.protection.outlook.com ([40.107.20.136]:25359
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233221AbhLPRJD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Dec 2021 12:09:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WuavDo6wfYbTSOcfTTbkOyNUDuFsaX6Ph8loMMuyZHQZQWjrjHkbsxVxKZHsUtmRFnHFDds2hF1DUyWJC8dAcBwsrK6rKp22Y2qGrA8F84SOPLyIJ+N/BxlotmDe+XdEqy+Mhuc0e3+FQH7ni/zNlyfaAzgJ2JVfRzU00a7NBXk3lukMmpjrjJj4NbGt643JEsj4hRjxe95Gzp5ikQwzQyNuNPNvpXFYrDIuVrioz0xWDHWngMbMr23CncPfaTV/1RK3wQeB4fuPgZsWwuUd0r77ZU7nGp2NlzvPFIGJq8K1Oub44XMC+OrDgHmsbvphIF6WuwOeWR0braWb440NKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bIGzEQ5vn5UU5YII1bNiNOy7BNgESMBgoQne8x/YjXw=;
 b=fPODd/wLxeY8Hv+3gE1dWxEIKZrcU5gpun9jsLKCSleFPArnWSI8CsqoIvtl0QCyreWzwUdZj3d9dxLvZezNtI9NfJi03kG2sPgr98sX3ofDT5FFnOW//IoNLFAfN/69Iqf9RPvKolIVwASS/aHkna/7ZTOIiZ0Ig35/tXklpyV0bMkAx4o3iOW7h2p2eoy20PrBHVHTgNRgcKJo9spxOcSzbbpgmsJxCmIc5/3/6XbI2r46QkUaUTRBs0JPDmYZrpTZwjCPlvhQXMsZ1YV3EcjomQCKOvNCXl3h9DemTg47QstN4+Dv2nkWaSMSTVfSZyLCDB6P2Zddv+XgkGvMDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bIGzEQ5vn5UU5YII1bNiNOy7BNgESMBgoQne8x/YjXw=;
 b=RIRRmVZMzf5O0ubu8UPdrGjmy+3vOXY+Q9DysXvcP910r3IIjKDkxvd8rimH3DnxDwvBjXVOkM5vmFVOg2/kc1GUdi6oW1KGDv6BwRYSaCnRFazx2ULm8y6FcvdY4t11uz4JclUGm+vcQIIzSPnlIXaYS1pvjVtYGOgQg/Vp3Og=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:262::24)
 by AM9P190MB1364.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:271::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Thu, 16 Dec
 2021 17:08:59 +0000
Received: from AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::14c6:2e15:77ea:c17f]) by AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 ([fe80::14c6:2e15:77ea:c17f%9]) with mapi id 15.20.4778.018; Thu, 16 Dec 2021
 17:08:59 +0000
From:   Yevhen Orlov <yevhen.orlov@plvision.eu>
To:     netdev@vger.kernel.org
Cc:     Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrii Savka <andrii.savka@plvision.eu>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net] net: marvell: prestera: fix incorrect return of port_find
Date:   Thu, 16 Dec 2021 19:07:36 +0200
Message-Id: <20211216170736.8851-1-yevhen.orlov@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0005.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:15::10) To AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:262::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8378a159-4cc4-489a-de2f-08d9c0b6c03a
X-MS-TrafficTypeDiagnostic: AM9P190MB1364:EE_
X-Microsoft-Antispam-PRVS: <AM9P190MB1364D5A57A6C6AE1DB0E222B93779@AM9P190MB1364.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bW3DGHVkIcElDhOpeP2K8RkVdUWWN2elwZ1GSvpMzOzXn7Vx9Ofk7ydfG6/6725Swgtejc/Q2zfNj4loowhzphoR3ZTXPBx02mYkjjFtP7V3YOc71p2ZEXp7oJPVRSyqcmSNRlMnFWGTHZJo5R1gCzSaasBYXFqpSmkhyfUlaWqGHjYSGnsDBlw3u28W+zY7b4NiLQmb9+kRLe3/hbBll8Lq3gbA64HIO1wEvF9boPeOAwtd6ZlXLLWXVeupCgtgfRA0Nvc/T9WlyyhBTebI1UY8nxrzwTAl3LeSnY2Gen0HWfbegCSaSIv2FnDbf+Iou58aIgKw5ZBir1jNzx4eO3vUSBYLG0lDwchuyyRFHn+KeX1P9xWw8qdMVcC4xZ1QPCg6QmUFS3iSMQP6sBwUrXKG6ZZaHQgZoUFbh7VBmM21T3f4fE7ABT0DM+wnsqQEUKFlbxSgFANNqmYZLJOzZoxonKbf4tsHapaFbsOLD9/dU44dkSd++f0gZllalWexexgwAGRueDKwfCTuYI7p1Lvdyz+rWcYTW+11jl+rgawpku9L9AsiMucZByrH6z1nBo3XtJAD6JLfJh/iYeo/Xb6eoYr4n1G4g/rCfVOGvx6M35M45zMRIpQ6vZ+9ervZxMuOyRZVioC8PdqwF0ItyXyDKyRunOZlsbbLLGt4JMUsicy52t54j2zJYnpDmB//l3YCQ9Aa44uGQbN+l+MAiA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9P190MB1122.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(136003)(366004)(376002)(396003)(346002)(39830400003)(2616005)(86362001)(6486002)(66556008)(66476007)(2906002)(26005)(66946007)(6916009)(8676002)(5660300002)(44832011)(508600001)(54906003)(4326008)(83380400001)(36756003)(6506007)(52116002)(38350700002)(38100700002)(6512007)(186003)(316002)(6666004)(8936002)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZyGHooGle4C9Ej1N9wvydly0Y1w9lDJ8llDyti33OWg8dohMpoxcFjdnIwwi?=
 =?us-ascii?Q?AycYolilTSBu4POLG0/4RUHB2QnCIlkLIjv//MxKm+p6h8+dr2/lmMvIvKEk?=
 =?us-ascii?Q?JGQwy4WHzM/fMizvtmHWHAN/64FRl4BiNu8nEemoDkwT9SLkQ+KMPRlAOyRl?=
 =?us-ascii?Q?ZOiVdUZRg8r9HbGWq5xS7wZtKxIC7IYv0JA68nm29qfZPNIho4xngkJlurS8?=
 =?us-ascii?Q?C1dJ8dRUcGi1P3xg0OcludSvCCmR4ALz/UmYlJSruGOXmFF6FqU/KQE6/Ib7?=
 =?us-ascii?Q?uL2jfqg75QL2SFaIf2mi0noGHoyon0jafcvE+fDnQt/V3jbnQukgwN/ocMXq?=
 =?us-ascii?Q?ksdbyJPTcLbjH/f57uFAekitgqpt5xc8FGUlcSgEH9Z38wlPJaXhBo8w/S4c?=
 =?us-ascii?Q?9aoJO5rOZpeiMKmixs45ZAmwftdG6R38mX5JjrrB7IToLLOnPXtMhpAuZu3Z?=
 =?us-ascii?Q?lHwTm7SJPoNqHJauj2lNyxlBzapFapBLdW2W99wGtosO/CR8hQuzfRkn6ax3?=
 =?us-ascii?Q?rwgD+eSYH+rUXUIbVsUbEKo8tFvArddItZNknxJ8TY/CUeH/ooFXK+LTq8ox?=
 =?us-ascii?Q?1LY6bnHbYQSTlXJvqW1qiRNVj/mU6pyWiwPFqp23VtrIyj7VjSy6uXfJjlAL?=
 =?us-ascii?Q?BZyXOm1dXQPO5tU7FwpGV0c/IfP5yZXeCnJaB8RiYpUJ1ybQq/mlLqGLdjyZ?=
 =?us-ascii?Q?OD+QoGEz8L0DkzJ+SkKuBQfNebb37iYSjmAIOIsJTCS6BehWBOZHP3Z1ND3/?=
 =?us-ascii?Q?ecuPpuPTuYmOZdXUrOtKtglLlrxpYDmLYEyAL/paOfBPayH2+e1qRCFMEwGY?=
 =?us-ascii?Q?kTWnCfwWl66acmPKXKbo/m5ULI5zFaELsFioIDOa13H3PjnHt3Njk2qNEicA?=
 =?us-ascii?Q?pceNVY9pkfUDqE1gNFXGNS5/uUvE2Hn/H8JHzUvVwhobB5tJT7RLjCp2fsUx?=
 =?us-ascii?Q?J9kvXIYlCiVhNPfwDkE0I3SdrkJh3f6gBk3k/bltr7KTnMqDQRebcxIUh5Qg?=
 =?us-ascii?Q?jJaEGpMt8HhfmBw/nOQKkvt/dQT+YjauxHlCzFt9YB10VnEvQQg59EDGXwSF?=
 =?us-ascii?Q?f4sO8wPltFQJDPXDlPLGe/pwnZaLgQkTNoctL+cAAIWeFHfPc1VZM9neATfP?=
 =?us-ascii?Q?6GdZnRkzIUbF3qJpDCjyE7Icc3nGQFbTT3BhJqFwRHaR4PkGks9/Wt4oyWlU?=
 =?us-ascii?Q?Kxhd3MqMOSbi+fnvgM+eMUczHf1cmyBw1Mp6aNanY9so9vDl/LJyB3QsUd6U?=
 =?us-ascii?Q?fm3ROHwhNmQwDwdtUEl7S4uV23McHty5yla54hC6ktwX2QuLhJ+7ub6+3QY/?=
 =?us-ascii?Q?tsmjHhKsBtLP4QfF+t8dk/5UioLlmzXKJi3pZrU5pDf9x3FnIJANszbpUON2?=
 =?us-ascii?Q?3+S/UyeBdG65sZq3x0YjFfipis+pWZOZNSJLiKG5eELRsDEBEj/qkwqeiBOf?=
 =?us-ascii?Q?PziwfUjI2DwSNYyXj1+ed8aw1Cok1Sc0q9fGG1nRO136r6W0hnM0YFvZyuji?=
 =?us-ascii?Q?AcCA06I+NUXKaGpmauI+Fh503+GCKjxexh9oCzTGHtY2Z6pg2wHSPa0l5Aoe?=
 =?us-ascii?Q?TG0hegBaSkJeP0M40h7YGlc4STzomiYi4yGQtrXrkWMiGF/k+3t3eWdwuQgw?=
 =?us-ascii?Q?T9XeilHzqjeB7a6tkwiS7oKuhezerW6AqvGNU5MYWlKwlbWrafbKA8RFUYw1?=
 =?us-ascii?Q?hxgOQg=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 8378a159-4cc4-489a-de2f-08d9c0b6c03a
X-MS-Exchange-CrossTenant-AuthSource: AM9P190MB1122.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2021 17:08:59.3749
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3RP18+uj2BerEMbyXDnSnRns+cgmguvUatXNS+G8o1Q0U7PT9UkWc6usqD7NSiMZDhPdHQHx8iTAB9ueitFq4BsDZjZnYaqYmYJFQL4iKIo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9P190MB1364
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In case, when some ports is in list and we don't find requested - we
return last iterator state and not return NULL as expected.

Fixes: 501ef3066c89 ("net: marvell: prestera: Add driver for Prestera family ASIC devices")
Signed-off-by: Yevhen Orlov <yevhen.orlov@plvision.eu>
---
 .../ethernet/marvell/prestera/prestera_main.c    | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index a0dbad5cb88d..2a5029fe5c77 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -55,12 +55,14 @@ int prestera_port_pvid_set(struct prestera_port *port, u16 vid)
 struct prestera_port *prestera_port_find_by_hwid(struct prestera_switch *sw,
 						 u32 dev_id, u32 hw_id)
 {
-	struct prestera_port *port = NULL;
+	struct prestera_port *port = NULL, *tmp;
 
 	read_lock(&sw->port_list_lock);
-	list_for_each_entry(port, &sw->port_list, list) {
-		if (port->dev_id == dev_id && port->hw_id == hw_id)
+	list_for_each_entry(tmp, &sw->port_list, list) {
+		if (tmp->dev_id == dev_id && tmp->hw_id == hw_id) {
+			port = tmp;
 			break;
+		}
 	}
 	read_unlock(&sw->port_list_lock);
 
@@ -69,12 +71,14 @@ struct prestera_port *prestera_port_find_by_hwid(struct prestera_switch *sw,
 
 struct prestera_port *prestera_find_port(struct prestera_switch *sw, u32 id)
 {
-	struct prestera_port *port = NULL;
+	struct prestera_port *port = NULL, *tmp;
 
 	read_lock(&sw->port_list_lock);
-	list_for_each_entry(port, &sw->port_list, list) {
-		if (port->id == id)
+	list_for_each_entry(tmp, &sw->port_list, list) {
+		if (tmp->id == id) {
+			port = tmp;
 			break;
+		}
 	}
 	read_unlock(&sw->port_list_lock);
 
-- 
2.17.1

