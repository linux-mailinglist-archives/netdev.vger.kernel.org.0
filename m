Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7DBE414B3B
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 15:57:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233441AbhIVN6v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 09:58:51 -0400
Received: from mail-eopbgr30053.outbound.protection.outlook.com ([40.107.3.53]:30286
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232199AbhIVN6u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 09:58:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kVxPYiiULmumiJif7QJ+JuphqJcH8CN7RwXPvCWcNYuiWjTC3+yr2YymwY+1RoseO3B40SJCkRsMyvDelT8p2PJjdrzzV3uUxJAk8z4cQNYHlOm+lstsUK/dx0dMSfgfG4carTITXfpHuo4UmfY/qJcnRrirp366WiIaE0ovMK5U55YpNPeFTEe71+PfUEorE1Mum0Wbkq4hAzfQXY+cD2is3gTjgauF+B1V+ItslqUVw4JknlERKw6PTam6XUsw+/0/xfAWbdW29AZgiWWpsArwrnRE+mhXlKWqPmcGlkn9JvpYg5ubAYZArI4sJfwe2AiSxRVa8I1WIf+1o69kMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=sUr3mpcqEWvRS9+dH97XHIPjuKhohpHd6+CBb3D/r78=;
 b=QDD7qmFcSSausiIFEWXmu5NqqYfzSbbZ1fW4KZBihVEfEw8fLQ51S3SZMaTa4Cv+JWDHfmNUB/noLxODL8OkEZo3wOkn4G3T6gOda563pmOfDcCRwrPucB0nUiZhdICIPuviVXFHDyV0NsCIeXr5WfpS3qmm/iiwcWKMNkG4Qke+b6lROFkZlGGCqYD3lORDPZRgX/xm4OB6EmVn9xTpWLOSPn8xjLAtvIy2AibJKWW1ZiE6El+XknzKZ7OJpsP/NvyAA4fCq3rFqWq39bHdBfjNa2cWKFKIxV+ZmLHHx1GfaoEuPXM0V/u1DSpt4ZH1PCHxhzwBxwpkM5QHIoWgYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sUr3mpcqEWvRS9+dH97XHIPjuKhohpHd6+CBb3D/r78=;
 b=ISWWjX20Trc9XApJpTyUtmcLgZMZ+NifPN+sVqr+77KzjWsTj+a7C/kjeHckpf++LBEfqmj3cLGt4K23m8WqEy12HS3UxM5Hvhx2EoRwBVVR9wwLVxSsYmRzvC94DErIUZYDa4cT0jLP9OCnGTPLgaUuIVrjXPJ+ic60xNqzGzg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2861.eurprd04.prod.outlook.com (2603:10a6:800:b5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.17; Wed, 22 Sep
 2021 13:57:18 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4523.018; Wed, 22 Sep 2021
 13:57:18 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] net: dsa: sja1105: remove sp->dp
Date:   Wed, 22 Sep 2021 16:57:03 +0300
Message-Id: <20210922135703.2381376-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0007.eurprd04.prod.outlook.com
 (2603:10a6:208:122::20) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.53.217) by AM0PR04CA0007.eurprd04.prod.outlook.com (2603:10a6:208:122::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Wed, 22 Sep 2021 13:57:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bdb3121b-306b-49e2-83cc-08d97dd0e3d2
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2861:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2861F1D206DC2EB6C0BC2CD2E0A29@VI1PR0402MB2861.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:153;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w9baQxvNxV8vUhWiTyCj405m8Grw2vZsjYbIsyZUKJxEbnpdsp71SoLy5PJOFsyiI5pXb8Y4nbOT48MfRuWvP3WflqXqGr0Ne2Uk7BW4zv6rIFSO8Xa64qFqotlHQqBiOscWLxaV9SQJaVJiyVa6vqJlbTn2Fj8Rv+uSvKRfPBrBsU9iDh3jIKwyELcVKo5X6xCWS1p1UW+UrGrNHfWa+ZQj+KHUo5kMNr7Y32/Loi9GSdbDZdgOxRYGnzxc1KE19pXYNxSUAsbdrzonO+F2ERUFkSmtH8f/azUbPct07CNUjNpu6cSmdrMVLrRT6ljea5daY24Rm1oXWF+QfmSd39gQ+9gxz50syfbMHYvnsTnoWV6ty3vTx7tTY+20KqfWlvztNNenrQHVBqs95ASVWQlixXu7wFTbv3VkYFL0fPXjMLHLhhexDMx+pfV607BkqdhxNnS8oagdmCQS6FK7oWfrzhWENxWSl2QEKXl++GZ1FPTFG96bBjy2oDTC7q9Kl4OfFr6AayjrH7VjxnJz3Hl5hK9bTt9zoNHfiKmhpDVe5aiam5pLB5MSZVS4LgdyKu0wmRpO7FO16q2SrI2vmSX7rvv18yk7y27ogCcyAwhmo+aZ70ha38qMZojkfAeIN38vmrX3nwdtSUTUmX2S/Qut+/0GIHX0E+MKG9XqU2Ssqb3N9h+IXYgbYLM8NzNosAjkvilxNjBsKM7wNLkUdQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(6486002)(66556008)(8936002)(66946007)(6916009)(2906002)(86362001)(54906003)(83380400001)(508600001)(38350700002)(186003)(52116002)(36756003)(44832011)(6506007)(26005)(1076003)(5660300002)(38100700002)(956004)(2616005)(4326008)(66476007)(6512007)(316002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yTefUucZBruA7JwdWsKABETCbZ5/j8fOTdu3i261ANEsoX21AaZhCiEjFtWf?=
 =?us-ascii?Q?D1OST20coUpZzVEhjiKOVzRXuJqDO0K3fGjh3+69zcF97/T2pndV379/FtBl?=
 =?us-ascii?Q?TN19RXR5b0m0PPJQBHpFYw5mi85Vx7d+thm6kRZtiIXIAa2EuA59skvT3qY9?=
 =?us-ascii?Q?oQvK6KyTEJhwfW0qdrNFw6/LUdBSwdapjKolDUj66y+3TRTbgjPVbmqwt1KV?=
 =?us-ascii?Q?amHzLtOEWn2jZ4t8de5Xj9mfLOAM6Efa/Veu8uDNbdJRQEycSoDDTQ6vst40?=
 =?us-ascii?Q?lGyjH4zjWYPzCtW9LB+x1SrNKT8uj6yJw9ObbCFkkF/ART/2jUwMeyik8X86?=
 =?us-ascii?Q?g+dbLCq53eR0se6Cu3qeO5xASkpNPAbs7km1o9IVH4lLWjU5bMaEHS1je5nS?=
 =?us-ascii?Q?pAcza716ROQMYcf0tykEU2sxokRgHC19FMQhRzgQfxGk7bK5nyQyEb1v5ZYO?=
 =?us-ascii?Q?T9zAsEGr904AJFOtLtj7//Vaz5iTeOvjNBwCjS6r9j49fTO+6Kt35UAptYVU?=
 =?us-ascii?Q?OWe6l50knrUC0+8tDEkKyOkGCx6/UBzS6XMNEJC98w3ws/gg+YHmj6E69LA8?=
 =?us-ascii?Q?7+hQoGIwe68TIJxkB9q16oVnPyAqUMiyj1TMlaxFFH9VnrNdSy67ooTccTpO?=
 =?us-ascii?Q?8jQCuQAFnCDElvDtuLhGriwVT8YLcKnpfTQUz2Po5dHk4jr3+3unzmm9mZ+s?=
 =?us-ascii?Q?VKCQvqfHoZN3M5b9P1NZWysyNA5OkL2xkBLn7QlfrdOm9ChE1zbWKNM8fX0+?=
 =?us-ascii?Q?xDaRKVLlITnAcVEBeESctORdGq78emYMy0xY9BScg7GseEdLVbrC0pgJfQPA?=
 =?us-ascii?Q?LY8lFZPiuN9ZXXx5goqJ38WhMvcGZgxBx7nwjAPxc1nG2nbCvN9IGl7M5L6c?=
 =?us-ascii?Q?zjiNuRZHEwTqRuQ7f+ozE42QOUtOLSSkKiW8IxccNG04fE08z8v3np5yWg3S?=
 =?us-ascii?Q?+PCWebGaFr/oSRgwlhCPN7gj7hPDT+bvjI3TPcBikaR/oPniQSzXejMT45+2?=
 =?us-ascii?Q?Tr0OYzXdzQWQamxRHtm68tB7e5sQbSXMwCll8FLtuNjZxF/G+ksDVMLojNZ+?=
 =?us-ascii?Q?t1xyrzVSEpgLtJZUDW2k9yjUfdGYbzqpHtMYexJTfICf30ULEJyGj1FnVp+I?=
 =?us-ascii?Q?IH1NzkW/5i1Ox1zzkvfZ6mf5oYVNxiKasl9//OsHp24uVGBi+VCJYMdL6Gjs?=
 =?us-ascii?Q?Bobw3tplrl6OuWovf1HpaLKEhtWOmQC2ExZZAsmSooI13KbLwUk0963MUiur?=
 =?us-ascii?Q?3v++MgFTUbYK8BJVDCFWxc+HZk2fRP2zooWmpaEHYxwIRLUaqcTMI0d/8sYu?=
 =?us-ascii?Q?3Qj506gfgsdwbR86jlMEJFrQ?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdb3121b-306b-49e2-83cc-08d97dd0e3d2
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 13:57:18.1008
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hP5UoAsCdSWOTjsZyYwgecbiOvS4zEdCnwwC1k2ycsZmk/57MldbfAKucRI0rzGXADMLKo4Tcnmyla2Zv7ATIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2861
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It looks like this field was never used since its introduction in commit
227d07a07ef1 ("net: dsa: sja1105: Add support for traffic through
standalone ports") remove it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 1 -
 include/linux/dsa/sja1105.h            | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 2f8cc6686c38..7ce69dc07800 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2965,7 +2965,6 @@ static int sja1105_setup_ports(struct sja1105_private *priv)
 			continue;
 
 		dp->priv = sp;
-		sp->dp = dp;
 		sp->data = tagger_data;
 		slave = dp->slave;
 		kthread_init_work(&sp->xmit_work, sja1105_port_deferred_xmit);
diff --git a/include/linux/dsa/sja1105.h b/include/linux/dsa/sja1105.h
index 0485ab2fcc46..9d5a1053b276 100644
--- a/include/linux/dsa/sja1105.h
+++ b/include/linux/dsa/sja1105.h
@@ -69,7 +69,6 @@ struct sja1105_port {
 	struct kthread_work xmit_work;
 	struct sk_buff_head xmit_queue;
 	struct sja1105_tagger_data *data;
-	struct dsa_port *dp;
 	bool hwts_tx_en;
 };
 
-- 
2.25.1

