Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 506802F328C
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 15:04:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389492AbhALODe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 09:03:34 -0500
Received: from mail-eopbgr140050.outbound.protection.outlook.com ([40.107.14.50]:47843
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387695AbhALODc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 09:03:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FmhR/LCBvscoLYGiAPEIRHSbglWw5FNqObxAkhyPsbHQgk574w6N1PlB5w15jEnbF0yXXqrWFqhgxvkbb/Ens9BqFRwU5Ll6qvF/6io7TfqbD4jkVwvlHpancMPMdsyC13ifYPQcnb86Z04HkZwklB4f4pqTMaJaxToYo3nfKdRmIR5ZSkYniMb/7toR5ycPx7Pl7kL2eBlOvm9EfcB2xEwQK0U2HoW+XipsZprhKgK1Nd68UEzph2VSWlKYASbYenq8Rj8tPwWWBN7AM/lCDpbeOB+GNrRUYl6DlL6jgFuEN4vDPhXwfDNbZC3f/IOmY+ZmGD/XhL4+wM26IapeDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ehBycB5eXTd3bmYogDncW5KLnftnx2BuFFovkO4PtKs=;
 b=oajjP3GbLr8Jx0aVfgy02Xm7vSV5W8/+IfisF3fxfJO2njPSNAmSWv/dK8lFCj2PqIBC2BUfs06XkS4vYt7Lpe1qA1jN5bPApAQUASJz/ArKsSHIw2fwny9N8WmRvWvB7fUgyktIJuMJ8gepgkkxkOARa1V1PBnBycXA6RQAVz5gihmYKz0fntLC9DSXsvO0GAiaxD5g4UI17drfgxF3pDSzU/3piS5ZoUsvfpzejg1ATQGWC3tvYmCfM1zlCP7VfQmdo+LuUBegbQyjPNjLaTm29bB1UGHw+H1XeQzJFBHLp29AX5gth/IbNup4TUmy1IsmYLiC+JT7uFFNWPsHjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ehBycB5eXTd3bmYogDncW5KLnftnx2BuFFovkO4PtKs=;
 b=WW6PyNSgmJ9Dk2C/wr+oIRq7HGyGgf1IhbG6ueaPTB4EY6HGNkubVH5Yf7QT2a5JYEAjC8D5X614nT0AEIo3tR0Gsr/2MD7eAyDqv/RcEW7hwq3WjQ4b3FQbA5GuQlNmCssBAwJoEiR6lzcxoc03Jnisyjc+JXfuOHdrXy6Wh6g=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from VI1PR0401MB2671.eurprd04.prod.outlook.com
 (2603:10a6:800:55::10) by VI1PR04MB4318.eurprd04.prod.outlook.com
 (2603:10a6:803:47::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9; Tue, 12 Jan
 2021 14:02:43 +0000
Received: from VI1PR0401MB2671.eurprd04.prod.outlook.com
 ([fe80::dd31:2096:170b:c947]) by VI1PR0401MB2671.eurprd04.prod.outlook.com
 ([fe80::dd31:2096:170b:c947%5]) with mapi id 15.20.3742.012; Tue, 12 Jan 2021
 14:02:43 +0000
From:   Sebastien Laveze <sebastien.laveze@oss.nxp.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     linux-rt-users@vger.kernel.org
Subject: [PATCH net] net: stmmac: use __napi_schedule() for PREEMPT_RT
Date:   Tue, 12 Jan 2021 15:01:22 +0100
Message-Id: <20210112140121.1487619-1-sebastien.laveze@oss.nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [84.102.252.120]
X-ClientProxiedBy: AM3PR04CA0131.eurprd04.prod.outlook.com (2603:10a6:207::15)
 To VI1PR0401MB2671.eurprd04.prod.outlook.com (2603:10a6:800:55::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (84.102.252.120) by AM3PR04CA0131.eurprd04.prod.outlook.com (2603:10a6:207::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Tue, 12 Jan 2021 14:02:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 94f2fb19-e0ce-4790-1358-08d8b702bb22
X-MS-TrafficTypeDiagnostic: VI1PR04MB4318:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB4318179CA2A00AE0EC5FF089CDAA0@VI1PR04MB4318.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: drSEMZEBU3OGZJ5Xmf/E9xm644l1/ZuE4mc27zbGR/gpNv8bn/sWro4CCxba3+kxSeAUiy2lLlW8rQcDmzPGVvNYzSh3u64sbs5eZEE2QAH7rpbOOBQe+v6ioB4n+KAtx6rXZ48JAjLBBJ/fxFB8daoIMiSZ58fguX7nhJgV7ix2893rFQW4JHz0uKDpAl27UdlqxkC2nqD5esZshc9pXyx8T+jDB9x8ipmlyj+h3jOxjYbLp5DFcrbQWmo/RMERBkL28/tvuZLZIFTjgzTuQdpyzUmL/HIukeXFab6SpcuTb5EQUTYZqs3Ga9lDIGW1r6T59h7ZE+U6Gx68oEhfp+zYywR3HBxOthXLO1N3FjxZwNwgVA9VWgdtMypcdTP+j1CjpZOpJPJ0HeaFwjJdWOjfqHqYLhZZGE9JzcN73ftdHZfXuYI0c0eXL6lY0da9GcdJXWemrvCfXbE7I9Aecg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0401MB2671.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(136003)(39850400004)(396003)(26005)(7416002)(16526019)(6486002)(186003)(2616005)(5660300002)(956004)(8676002)(83380400001)(6512007)(2906002)(921005)(4326008)(1076003)(52116002)(110136005)(8936002)(6506007)(66476007)(44832011)(66946007)(66556008)(86362001)(478600001)(6666004)(69590400011)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?8Z/0PkI/Glfe2z/CCMLrMoYms8rqXRumPm9avjfuCkkg5ebqL4QVuLThSwBP?=
 =?us-ascii?Q?zWeDYs6c4tHmKJWUIfUeg9pXSDaJyQlDYO70r1MvGVD8lh7PhGE0vlAF5oVI?=
 =?us-ascii?Q?Ae7aHtAYZGPUYMU2vUD6IcbZCWjl+LqhSKffVYgUfbTOdlLQAWZEk7W7OaCJ?=
 =?us-ascii?Q?zQaJTg4FZhb4PCRmdxsegTFpxRtGyZi7pnMVEHAEw+D0FPayOOp6So0vrvp0?=
 =?us-ascii?Q?S6zUS/y8otd7RO7r3giVoyssZGkaMI5GOS6fR/jyAvXhiUttmN/lvu6MX13M?=
 =?us-ascii?Q?9uRLUf/JUbB4LrY7rHTcPkHRFBR0bQkXEazfd16lIXiSZXgh5oaxEAIEgcFZ?=
 =?us-ascii?Q?9q2FVJEF6rrxmkQxhiF0hZcNY2dGmgJA4vwD0689N4xPC4k/6kM2SKMhXcZd?=
 =?us-ascii?Q?is1jCAJIWfprlgGt6FzQy+bwWT43zRJDeeQ+q4QXQetDwxczckcgTvHo0Sjp?=
 =?us-ascii?Q?D30ABDdDdPumsZjSL8/BxhjH9Zqt1l2BxhliGY7rgSZnVK0v9ku+DlCUMCMy?=
 =?us-ascii?Q?O6ShXfLjGbcfHzIcJKhVIdHWdf3BzIHj4QHZ5AfGXtk29FpAtOqUW6/b/9Jw?=
 =?us-ascii?Q?hKJLDg1RTQxl10lbunlve6mveKpT48mukOHfJjluLoampWBAlYUueKMepMog?=
 =?us-ascii?Q?LDfNyfUhs9s64FI2MFbCFG9LDeiu3jZgkKzVLpTlIFHjifAZweXMYSUTdGhI?=
 =?us-ascii?Q?q5nnms5tpNdrde3i8z4S6sNbIKmQursHG5VvOzOGOnKj70fs/Of6NMCCEUGr?=
 =?us-ascii?Q?dI5fP6TjslW1TvUagpqVGJ8W0TH7TO3a1XLWl7buZIX2m2G5gBAy7IOBHNDl?=
 =?us-ascii?Q?v/s8JibEK6qCtMXlGva2DJ7zcchpASC0GUJB5IkfsDTzvk8l5JMWVOX0d5Aq?=
 =?us-ascii?Q?2THf1Vpf0ZcSo8JW+/kaGt1jwte82ot8WuOGamPyvwDjBXAqGXNI4m03ByFX?=
 =?us-ascii?Q?3f/Wu7OnHguCOIyqmK50Rm+w0UPq3z8Y+AeIFxW3RnWlIfM2i8MyoAL4R9YZ?=
 =?us-ascii?Q?s9Yh?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0401MB2671.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2021 14:02:42.8866
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 94f2fb19-e0ce-4790-1358-08d8b702bb22
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DBXZVWb1ihzz3hOlAcHFwKWLETcUNxu4FA5j0zRTckibPah5DbGHivFumNNwA9BD3Yt1k927X5lbzmIT5azjZOFR9wZtllHRhUQOCTRsMUE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4318
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Seb Laveze <sebastien.laveze@nxp.com>

Use of __napi_schedule_irqoff() is not safe with PREEMPT_RT in which
hard interrupts are not disabled while running the threaded interrupt.

Using __napi_schedule() works for both PREEMPT_RT and mainline Linux,
just at the cost of an additional check if interrupts are disabled for
mainline (since they are already disabled).

Similar to the fix done for enetc:
215602a8d212 ("enetc: use napi_schedule to be compatible with PREEMPT_RT")

Signed-off-by: Seb Laveze <sebastien.laveze@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 5b1c12ff98c0..2d90d6856ec5 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2184,7 +2184,7 @@ static int stmmac_napi_check(struct stmmac_priv *priv, u32 chan)
 			spin_lock_irqsave(&ch->lock, flags);
 			stmmac_disable_dma_irq(priv, priv->ioaddr, chan, 1, 0);
 			spin_unlock_irqrestore(&ch->lock, flags);
-			__napi_schedule_irqoff(&ch->rx_napi);
+			__napi_schedule(&ch->rx_napi);
 		}
 	}
 
@@ -2193,7 +2193,7 @@ static int stmmac_napi_check(struct stmmac_priv *priv, u32 chan)
 			spin_lock_irqsave(&ch->lock, flags);
 			stmmac_disable_dma_irq(priv, priv->ioaddr, chan, 0, 1);
 			spin_unlock_irqrestore(&ch->lock, flags);
-			__napi_schedule_irqoff(&ch->tx_napi);
+			__napi_schedule(&ch->tx_napi);
 		}
 	}
 
-- 
2.25.1

