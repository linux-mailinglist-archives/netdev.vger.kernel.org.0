Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F8944E4DCD
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 09:09:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238026AbiCWIKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 04:10:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242450AbiCWIKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 04:10:30 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60049.outbound.protection.outlook.com [40.107.6.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68E2E74DF6;
        Wed, 23 Mar 2022 01:08:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dfXflOG9BClWulugzAdZUXNMc0NyGVhbhkUENBP5lOiNxxwwVDe7Gqu6Pmg5XC151fxy1pyuhkSAz7iRjolntfmlDQHo0nlUgtM0DUH1raMhhdt3RYdLhQrljkgNVfa4/zY25wpG6tpyjo6xo4xMckz8ah0TySHZv6TW3Q/kUNwy434cdbfAR95zvbHggwvvF+dEOvejluHW2WTnL33ecOFHWPqmKXNqNIVjW4FuPxEdPfxAxC5fpqpr+eAJrvLj4O5/bULQss2IIktMblsnGXyxZuAtPpV2xcOIGxYFANef8ylD/jqilWC0JYxK9pFEIxqAYbNJ+0iYoWu+xD1XnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e66uONHHP7E0l2fzL84Zuc6NN9BsE6jSqD1zwpciaz0=;
 b=QDOj4WVJdUe9j662R+4zON4fsERA9ZhJWQ5JHOn8Dy84lqYPbBHbRdj9W+6kaG+T1h83dvtUhqqWYtsBVEegIQPOZSHWs7mTLO8xAGyp0XEN7cxbxcrp5wp2UfAYg3NpMKKwe1ibJoBaREqefRsCp2TiS9C4Zk/MPopliVzkHjSY05YlKVSkNzuKG4KKSIqAP3Yvv1AnYyByAE+2ZDAHD61MnhuX+niv94LFxNzs61DE7bU/tBGrk6hVi9Jsw2pODcWlDrCprafGHD+XVv7nifjjyg4hhogHNHfEP/q+zxxzJAQbSq7+j1BO9eSmCj+5G70dCNyLqTjmSPsDu+Nsyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vaisala.com; dmarc=pass action=none header.from=vaisala.com;
 dkim=pass header.d=vaisala.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vaisala.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e66uONHHP7E0l2fzL84Zuc6NN9BsE6jSqD1zwpciaz0=;
 b=qzSG7zg85UZkHHQoB0MqO9LkK/TGaFK+J3Ai8adsCoMRii5iV2b843JamFzzHNeo9jj2Y+l3QMZ7CV3kH2gzpEold/vPtqRFJOjfN05BSs4XiTrcXevEvZuB6wtGTZf8vmuKpIqQ9zGgWi+HDBCobYJOvZJ4DcF67f1RWVdqeAIsmKpzAYQlHPxfP532w0JPIjFejwi48B7lTKp2lpLrwjMCyNi7A9aD6zIEEuWE++M+XIH/s5+i0E3v1VH5ECc3H/0rP/Y2ohbiDkpVzF5OIYt2kd5Ucn8nB7S9AbIYg9jbWpnrmDD3sEWjWPJ15U65FYtTmglKYS9FRviUKeQkmg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vaisala.com;
Received: from HE1PR0602MB3625.eurprd06.prod.outlook.com (2603:10a6:7:81::18)
 by AS8PR06MB8214.eurprd06.prod.outlook.com (2603:10a6:20b:3d0::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.17; Wed, 23 Mar
 2022 08:08:55 +0000
Received: from HE1PR0602MB3625.eurprd06.prod.outlook.com
 ([fe80::c8bc:3aa9:eab3:99e8]) by HE1PR0602MB3625.eurprd06.prod.outlook.com
 ([fe80::c8bc:3aa9:eab3:99e8%7]) with mapi id 15.20.5081.022; Wed, 23 Mar 2022
 08:08:55 +0000
From:   Tomas Melin <tomas.melin@vaisala.com>
To:     claudiu.beznea@microchip.com
Cc:     Nicolas.Ferre@microchip.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3] net: macb: restart tx after tx used bit read
Date:   Wed, 23 Mar 2022 10:08:20 +0200
Message-Id: <20220323080820.137579-1-tomas.melin@vaisala.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <1545040937-6583-1-git-send-email-claudiu.beznea@microchip.com>
References: <1545040937-6583-1-git-send-email-claudiu.beznea@microchip.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: GV3P280CA0006.SWEP280.PROD.OUTLOOK.COM (2603:10a6:150:b::6)
 To HE1PR0602MB3625.eurprd06.prod.outlook.com (2603:10a6:7:81::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b8fbc32c-8ccb-4236-2702-08da0ca45ffa
X-MS-TrafficTypeDiagnostic: AS8PR06MB8214:EE_
X-Microsoft-Antispam-PRVS: <AS8PR06MB82145945D9E5092F7028BA21FD189@AS8PR06MB8214.eurprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KK7K7TbmzpW4Lii/a3v6kBxRTT67HU+f/HvaabMs4asNlKHNOzvHR+RGSxx85nHrakFR8ZKzTTw8RQQRL2TzxsM/ytPAJguzd3mObP3t3BPBCLqbru7eEo7omPCKWDYbtp9Qx5OuSPlIk7hSYk31UEF5t6MujYZnjtGmNWHRppjmFf5Ma3HKyscTohzneApaFi9sTJUdljH9HqdyytgvgWYiFaqDk9o7UTZmlk2kQWbslvxs0FuuRzBZTrKm2ermcqRclOX8QsHh+qvTvsA7P0S8oqjOD8MXTE5DSjIeTf67LSSdRbrjJNNDK+llrGj25oU0YIO//TDDz8xYUXg+hFhvY1MTuheofNqMjshKLq257wPwU3IwY3tSWaF0NFoj1cD5BC0laPM07spSgmeoQwBvGtmHFIYvdPDKQiiYtv4mE9cQI9+U4WGWnpq9Oi6B84wGF2YK3y3WYtvO2xftA7Tab6U/GNGiHpOGzRLu9wm4wLxemWhPxNKJhr35nZDeiGA/7XoXXOcAeuMtSFiQuAqqKvMTLAD1ODg9LQQ6uHt8XDFNp/e4wBZow5PTo0zaF+/JR7eMLbYI0jXQ7a8HbyjTfWgW++KJjMfkrnQLBLVN0ovz7hkBK39U8cMybakajZt5rSxqEmTB1l60BkQlmL8mwdW8wppw6KWcATAA+SFVhVfLZfsqcgDilNN3YzjwuTr9fofSn2hNQKCNA/iiPg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0602MB3625.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(2906002)(38350700002)(38100700002)(6486002)(6666004)(6512007)(6506007)(52116002)(36756003)(508600001)(6916009)(66946007)(2616005)(4326008)(66476007)(66556008)(186003)(1076003)(86362001)(83380400001)(316002)(26005)(8936002)(44832011)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tZjl4Y2dSo1P4ECI5xAcAVjBWduZEdhIX717BoCEomQAKio3V74ncDzY2GbV?=
 =?us-ascii?Q?GITt772ZeiN26Jtr9bnwAiwQt3EILWywROUjzuIn1lM1d5hpGkKfHykmIbw3?=
 =?us-ascii?Q?oU2K9YvNhVhpJqSPwDOt5JqybJqXHMCaMcZ6b21o9RfzzmZ30WewCR2wqZ2W?=
 =?us-ascii?Q?X6W8yUvX+e32Qg5sxFlVivTKe5Dx24jEuEiWtMkUyRI0PxgQr/frQn06xeeF?=
 =?us-ascii?Q?hCgwuNXuL3RB3cNhfQunl5FMOW3MGZZKGFc3b7eT8g4dT3Z70j4wsygVvtyh?=
 =?us-ascii?Q?s8RY0eN8Y7AsXoEi1GB5Y/WJtzel7FTClSLoyCzngW/tyPIXmGOLHOTaAMla?=
 =?us-ascii?Q?C1JappW4UG/JnrKZuGknMrHm13/L4S1B5Puk7HiL5z0+PXzg/BJo3Sf9jwoO?=
 =?us-ascii?Q?t+kLLCR12EjhqWtYKyu47678E7GQVB1rN87/pslGwIH2535gOmr1wvFzsUVn?=
 =?us-ascii?Q?VRreTNa0JlAz2cKDVwnEjYdZXBr5BQQ0Sbzbs0rhVdLj/D+KlVfMeG+Vv3Rn?=
 =?us-ascii?Q?6weSvpz7povvzOIP+JjJiNGI3diFzHf4w4zU1qrIX70NjpLMssN8KoaomX7G?=
 =?us-ascii?Q?snGPFYaD+tse4ueSxVt/JesfCZE+fbTQbnFi2IIrXT0bnBEGTeAqcFsXs7rA?=
 =?us-ascii?Q?nlDQi8jme1QoQcU6o7DjKxu1bJbzUuQl16TWn0CRAGIqdK/fDWLrkiyCAklv?=
 =?us-ascii?Q?DtDW4LohEeyOv+G/4yME3YB8MLhmHGmPjfKlFNpQMg1uthFEt+L5TmSJF8dA?=
 =?us-ascii?Q?xRTgsrG9EfHSE2uGI6sljLRvbJynhIirK5Xxe/CacSQFwhgGo/JydlhluF3K?=
 =?us-ascii?Q?6L6CxzKxxMDxhiuQDxEMKuUekGnFka4Socs3wpPXGuhm9sN1Kq4N9EXJnS7Q?=
 =?us-ascii?Q?twIKcZOHmL7S4B/46xFXmzPCouCkQaIZRFvqpUWOJ/Q5+1u+8gyKHHO8eUr/?=
 =?us-ascii?Q?ATCKqLDlGERV4+i+w/yaVHdFINawJmwfIzLGmU/XnphsfS7PmGOdHTnGvCdY?=
 =?us-ascii?Q?hHdgIbwHrQPvk8A0TlTXkpN2lH5XmN22e5oWw7oa2I2ewQGZ20ReeZ2EpMZC?=
 =?us-ascii?Q?5e6uay8ZrBv+zZPGB+SVF1Xp86aqQ9n5Jw+MXQxfnI2oQtuFCWPDx5ApIGZ3?=
 =?us-ascii?Q?sP9xyW5WGEOjqadvnFXDNE5xweUWsUgei/36cs5d7ZADZyZJntXhK8PqwAl/?=
 =?us-ascii?Q?gpcW7jzhMlAvbAEaeJS7HNhsuVqVBjxWtiQJ+EMUETXmpBx5tXZ0HXSSAFQK?=
 =?us-ascii?Q?wytqSukCxLJjHcAii+ClToJEM35fnhsd/4Ve54A7HzAJZYq4Mpt0C1Qt6vNQ?=
 =?us-ascii?Q?w5tfH3HXlWx5A5kHEFMSaZt4/rbcyxPFN1n+uGREfaixtt0BLIX6A3iGX5/H?=
 =?us-ascii?Q?67ysZdmy7I/XyccdhN3IMDpRl80aE74izqCnbtETcT/f65zbblq5eoc8YfcU?=
 =?us-ascii?Q?O4X9S0vvhaJti+9gB+D6K9awlAd/wz8sJrjs0L6ASxGtReVuO5Hhsw=3D=3D?=
X-OriginatorOrg: vaisala.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8fbc32c-8ccb-4236-2702-08da0ca45ffa
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0602MB3625.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2022 08:08:55.3089
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 6d7393e0-41f5-4c2e-9b12-4c2be5da5c57
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6tsxSxyWbIFt5zRY3PsAJIAVspmHP7H3FhwugircE8fB1pTWYzkGPgYQrUPM9GCsjNYb7d67FPFwTFt57WQgCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR06MB8214
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> From: <Claudiu.Beznea@microchip.com>
> To: <Nicolas.Ferre@microchip.com>, <davem@davemloft.net>
> Cc: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
> 	<Claudiu.Beznea@microchip.com>
> Subject: [PATCH v3] net: macb: restart tx after tx used bit read
> Date: Mon, 17 Dec 2018 10:02:42 +0000	[thread overview]
> Message-ID: <1545040937-6583-1-git-send-email-claudiu.beznea@microchip.com> (raw)
> 
> From: Claudiu Beznea <claudiu.beznea@microchip.com>
> 
> On some platforms (currently detected only on SAMA5D4) TX might stuck
> even the pachets are still present in DMA memories and TX start was
> issued for them. This happens due to race condition between MACB driver
> updating next TX buffer descriptor to be used and IP reading the same
> descriptor. In such a case, the "TX USED BIT READ" interrupt is asserted.
> GEM/MACB user guide specifies that if a "TX USED BIT READ" interrupt
> is asserted TX must be restarted. Restart TX if used bit is read and
> packets are present in software TX queue. Packets are removed from software
> TX queue if TX was successful for them (see macb_tx_interrupt()).
> 
> Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>

On Xilinx Zynq the above change can cause infinite interrupt loop leading 
to CPU stall. Seems timing/load needs to be appropriate for this to happen, and currently
with 1G ethernet this can be triggered normally within minutes when running stress tests
on the network interface.

The events leading up to the interrupt looping are similar as the issue described in the
commit message. However in our case, restarting TX does not help at all. Instead
the controller is stuck on the queue end descriptor generating endless TX_USED           
interrupts, never breaking out of interrupt routine.

Any chance you remember more details about in which situation restarting TX helped for
your use case? was tx_qbar at the end of frame or stopped in middle of frame?

thanks,
Tomas Melin


> ---
> 
> Changes in v3:
> - remove "inline" keyword
> 
> Changes in v2:
> - use "static inline" instead of "inline static" for macb_tx_restart()
> 
>  drivers/net/ethernet/cadence/macb_main.c | 21 ++++++++++++++++++++-
>  1 file changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> index 1d86b4d5645a..f920230386ee 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -61,7 +61,8 @@
>  #define MACB_TX_ERR_FLAGS	(MACB_BIT(ISR_TUND)			\
>  					| MACB_BIT(ISR_RLE)		\
>  					| MACB_BIT(TXERR))
> -#define MACB_TX_INT_FLAGS	(MACB_TX_ERR_FLAGS | MACB_BIT(TCOMP))
> +#define MACB_TX_INT_FLAGS	(MACB_TX_ERR_FLAGS | MACB_BIT(TCOMP)	\
> +					| MACB_BIT(TXUBR))
>  
>  /* Max length of transmit frame must be a multiple of 8 bytes */
>  #define MACB_TX_LEN_ALIGN	8
> @@ -1312,6 +1313,21 @@ static void macb_hresp_error_task(unsigned long data)
>  	netif_tx_start_all_queues(dev);
>  }
>  
> +static void macb_tx_restart(struct macb_queue *queue)
> +{
> +	unsigned int head = queue->tx_head;
> +	unsigned int tail = queue->tx_tail;
> +	struct macb *bp = queue->bp;
> +
> +	if (bp->caps & MACB_CAPS_ISR_CLEAR_ON_WRITE)
> +		queue_writel(queue, ISR, MACB_BIT(TXUBR));
> +
> +	if (head == tail)
> +		return;
> +
> +	macb_writel(bp, NCR, macb_readl(bp, NCR) | MACB_BIT(TSTART));
> +}
> +
>  static irqreturn_t macb_interrupt(int irq, void *dev_id)
>  {
>  	struct macb_queue *queue = dev_id;
> @@ -1369,6 +1385,9 @@ static irqreturn_t macb_interrupt(int irq, void *dev_id)
>  		if (status & MACB_BIT(TCOMP))
>  			macb_tx_interrupt(queue);
>  
> +		if (status & MACB_BIT(TXUBR))
> +			macb_tx_restart(queue);
> +
>  		/* Link change detection isn't possible with RMII, so we'll
>  		 * add that if/when we get our hands on a full-blown MII PHY.
>  		 */
> -- 
> 2.7.4
> 
