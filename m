Return-Path: <netdev+bounces-7366-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D1CED71FE5B
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 11:52:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5EECA1C20D98
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 09:52:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A7C818017;
	Fri,  2 Jun 2023 09:52:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4870F1800C
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 09:52:12 +0000 (UTC)
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2057.outbound.protection.outlook.com [40.107.7.57])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1642196;
	Fri,  2 Jun 2023 02:52:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J2mc2ZeaGD3bFIK0FfpoujwUZ7By1DbRLqNic9x5JNB5+hY0cL4pt6LK/gPfBQtMI4YyJRyT9FDw0E+jSudI5TdIbDHHm6uQRGDKWOTz9+KuysVD1dDj6PZi8AWL/fT/bPmn+QniaywfwMn2F+pM7tOEDnDgVmwQE2sxoTXS0rf7VJ/MFi7fE65Q1i8Rh0yBIaWrwB5rxyO7/ZBGexyZ/7QD+3suERyJisurownoXs0kWmOlmK33ysfRwLZA4zUUkuuSLLxfiFH8yHQ/0MlnNlgF4FDTff6SCRLdoehnti6XgGb9s08ETG/yBoEJI373t2ihUJjzmw526o0Of9EcSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8rtw7onmBotbH9Y9CCEXhcB9EEdeyAerPAAusH5Rcjs=;
 b=MMcUPeRHppBAaVXZSqtCUUqk64gD1+3IGh7USvQjnZNhVgyin+/3l/tFhxCBbrSuPMjkyD53/auUfTN6vqOujJ4TrvfI7mrR1lZPFA8vrl6/Uu1PB1HLaIDnnK66e99ULXuT4GyIIoWBk3qZh3oj2rV54HSELqsYuKf9Uo6icCzNxwZ+D/3Tj6WGKm6+EEyCTuuVOu65Q2uWR1Hyx7Qdzz+XEu0q8fehn7eikrRShDQBWffGte4qL4LxjVyUJ2ZtY/C0st6R6/jQ1YWoBVy64hQw8AdyzqZd1rHhJzFeEwIEjEIazaPwgW4t6QJUK5hptBQUPyVgK0BoifHDj2yP0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8rtw7onmBotbH9Y9CCEXhcB9EEdeyAerPAAusH5Rcjs=;
 b=gX6W1XJHHUgqiyurf02qyAKheAbHvEbJnVStmfupYd+S/NJtv5J7TpgxSwaNBsL40dhUh31nz0yXoYNw1iR8BOU34q9aTZa8sUkf6C0N8e6tLYjnb/iYh+8tmuj1GQHBac5W+ek6qX7cK6UVLBJVOyhMksXPi3bwc7RdJwIn0p8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM5PR04MB3139.eurprd04.prod.outlook.com (2603:10a6:206:8::20)
 by AS8PR04MB8165.eurprd04.prod.outlook.com (2603:10a6:20b:3fd::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.23; Fri, 2 Jun
 2023 09:52:04 +0000
Received: from AM5PR04MB3139.eurprd04.prod.outlook.com
 ([fe80::682b:185:581f:7ea2]) by AM5PR04MB3139.eurprd04.prod.outlook.com
 ([fe80::682b:185:581f:7ea2%4]) with mapi id 15.20.6433.018; Fri, 2 Jun 2023
 09:52:04 +0000
From: wei.fang@nxp.com
To: claudiu.manoil@nxp.com,
	vladimir.oltean@nxp.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.or,
	pabeni@redhat.com,
	ast@kernel.org,
	daniel@iogearbox.net,
	hawk@kernel.org,
	john.fastabend@gmail.com,
	netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH net 2/2] net: enetc: correct rx_bytes statistics of XDP
Date: Fri,  2 Jun 2023 17:46:59 +0800
Message-Id: <20230602094659.965523-3-wei.fang@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230602094659.965523-1-wei.fang@nxp.com>
References: <20230602094659.965523-1-wei.fang@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI1PR02CA0043.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::19) To AM5PR04MB3139.eurprd04.prod.outlook.com
 (2603:10a6:206:8::20)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM5PR04MB3139:EE_|AS8PR04MB8165:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ef0d031-b9f8-4226-0d87-08db634f0534
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	TO148P3Ea7iMordwhRomgjWl4WNC2wy8JTdrVGKMO1Gf0Npi2tGJZxWWRWDqsXWlbZMEB0XlL2JTsPrbNMbfQ3UA8GfT7iLhF8XB5P2byHIXvC5Hpfn9py01UyqHq/QaPnU1PWo/QRLdcqD19ImANYbyJqLl5K7Qh/IRlNdL7j8ik9ilTRIQ762/aC3MNjO1AoBhImfjfw5KR8om3Bhf06RIBMEVCB1w/JSt6vT6XLFQo9DjLNrElUJuEIFRgQ6VG7/uGUIhY5PwX5elieQ0hwagqeQP8rHda8Jn9vk2b+xhUjm00ve+R6gXXyCzi4g4rvp9CeCqSswYaDO9gvz9J1tsz+e9VBuS0mWd/GEXfp55r8U7G1NUTRcHt/86B8rsZfaNhygU7br1ppHpni88WFE6y/cg5y0w3QDyea3vvGmlA8IsB+ljsgsT6zXxHljQZENc5/gyXi3IlzEmpWGDEHYCzHKcEBIIkDAtTJcPmlXjY1WrNs6gacupZn4a9UdmC60iys3gWdiwDZRZ0/qxwEEPt9Oo+WLtZJ6hwz6YgUAx13fy5XJsCGRGuZUPVf2o2tlLOi0PVgDp9ijzTtjd7xVbOlpgYGA9uwefY6B4o2efAYYw8MhkDarSNel6xGqpaCCX5xAcUgKmAUFO3yV3ow==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3139.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(376002)(346002)(136003)(366004)(451199021)(9686003)(1076003)(6512007)(26005)(6506007)(83380400001)(186003)(38100700002)(38350700002)(41300700001)(6486002)(6666004)(52116002)(2616005)(4326008)(478600001)(66946007)(66476007)(921005)(66556008)(316002)(5660300002)(7416002)(8936002)(8676002)(86362001)(2906002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yep+gz874TjzyZhPFFPvBHHSDy1QCWz/6wOyMyezu80AT3T7Wld/94WWqA5S?=
 =?us-ascii?Q?xrltTy0Dq4Sjy5fSqLhTkvhtSNNz5hwQp4tPTDTq8Cmkjs5kkEkW046ZnNLd?=
 =?us-ascii?Q?NWYTB4afXuZQcU4uXOPMhTG8XGUZNvKlPX34xL1JYG134BzIBQ6Zz3uUpdQu?=
 =?us-ascii?Q?MbpzgexLKBFgVisbwIxW7FdAjSQcnd1YCkHlvPTBc3zrMZjTSawo/ytqBJza?=
 =?us-ascii?Q?NXeemW2sbHpt4kvJD51x+gt75VadQO/QAoPomax6DMZoV0ZhJv0Av0lQhVxl?=
 =?us-ascii?Q?m0opAXVrEg2YM9DSsE0gXavRVmBbZXbeyFpCUN7p9UlplYEs6EAydq4mGuKC?=
 =?us-ascii?Q?QrMZ0+NWRj3J3t0an5gFIjqFfQbhre86PCwVke+1FuKimMickaGWXAmDklj5?=
 =?us-ascii?Q?8WivZhVjOTMF65wLj4RTeTfDNwp8q0vXHNrceRkSEWJOhSW6bryIqG29Jr4c?=
 =?us-ascii?Q?5eWGRRf4nEgqINs9LIzUM24D+VIg+gdQnaDPfT9++5zZPT1URI6sTN0OTvl8?=
 =?us-ascii?Q?RTKWC9OE++bwnjMctZfx5S/sxgdGqm7FFmTaNP5GDt6MpKohOo9a0w4f8DEm?=
 =?us-ascii?Q?/6gfXRHJWSOwL5I5aKGAjrRXsgJBQolPw/OpOsf9z5mvOS2kqZjmzid0uMMr?=
 =?us-ascii?Q?BDQqm13NMlMR0LlmuPJVQr6udn3Id8g1Pl/mlsM2JNq06hyZfjgJtgkepWAY?=
 =?us-ascii?Q?9RJNYvqUnXz//TJHtxFqcGD9AmsYKO/crHQSDhYGfc0PrhfZ2dejgga6sRqq?=
 =?us-ascii?Q?IY3NTCNsqdHZkv+GCZFhLnI5auRlFTlY2w5gMsEnUsKKYf2e3sytxeiKIjvX?=
 =?us-ascii?Q?4sps1wWkD3e7IQtFafvxR6gM/4yY/jaheuiogJeMEcS7wfXjBYQ43oEtnHVb?=
 =?us-ascii?Q?9YWMQLgtzOKBgjnKcl4JrWUOh04/IF2JMB1KybehGppAiGRXIk0Xh96uRHCh?=
 =?us-ascii?Q?aOjRERMKkG7SDm3bvUakckDqcdqPSog/yIOQ5o/PAGSwS+B3V1UQdYQNcIG8?=
 =?us-ascii?Q?/gGR/j+U3YIO0ZdKw4DrK+bmPBRAhiZqoCkey9hxsPw7pNY36qLhhJmNsZYM?=
 =?us-ascii?Q?3obH4xiMfWgIQx9E6HkM8bpxMvdddbsmL15ePoaex01Io/hz9F6TKuNVnGe1?=
 =?us-ascii?Q?s4AkAGGtYibinGGx6BdGL6hDa436xf3bYAif5jNgo0RCQJymfRdOxL+bKF1c?=
 =?us-ascii?Q?MoS7AlIgbz0r5LO1EYHLvS9dVTkaazaIDBhKcRFca8y9vflciJ6J5oXMn2MJ?=
 =?us-ascii?Q?JxA7ScxJX7rE5m8r0PovgZCLkir4uyCXfkc6+Cy0TrJOzmh7UDvtV5UjFn1S?=
 =?us-ascii?Q?FTgiaBbz6dz4DXmgpaMRvIpkCGSNIJ0HZ80KKE4nTx4Sr5mkBlIw+fufVehB?=
 =?us-ascii?Q?bgCvuCxgY30KnZeiIGL6u+o7Y996cGgVrl/zc1DESBP1AbNg+oiJZdfQduKs?=
 =?us-ascii?Q?Zfg3CKR3KEqcVbQU5Snv+6iLZoSr1T7WhLwd2bj+xMKv7W2sgdV1/hbCDm9q?=
 =?us-ascii?Q?AFmqcU5kcvsH7q4RYoH45oUKSl9XdnoiVQa+t+LvrlpZeqtjdW+HbnjKEIXI?=
 =?us-ascii?Q?oNJTjJ0kKgslnD+CJqrJnOg91GrWWgW+G62/Vbk2?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ef0d031-b9f8-4226-0d87-08db634f0534
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3139.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2023 09:52:04.7351
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G7hX6d9m8eIkgnzA3qF/+gTwP7Sf8Sgaun8JB0LR7/bY4RyhQldCGkoL8R39XM6kUo2n22jGWUQWlAybP7TIVw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8165
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Wei Fang <wei.fang@nxp.com>

The rx_bytes statistics of XDP are always zero, because rx_byte_cnt
is not updated after it is initialized to 0. So fix it.

Fixes: d1b15102dd16 ("net: enetc: add support for XDP_DROP and XDP_PASS")
Signed-off-by: Wei Fang <wei.fang@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index d6c0f3f46c2a..9e1b2536e9a9 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1571,6 +1571,14 @@ static int enetc_clean_rx_ring_xdp(struct enetc_bdr *rx_ring,
 		enetc_build_xdp_buff(rx_ring, bd_status, &rxbd, &i,
 				     &cleaned_cnt, &xdp_buff);
 
+		/* When set, the outer VLAN header is extracted and reported
+		 * in the receive buffer descriptor. So rx_byte_cnt should
+		 * add the length of the extracted VLAN header.
+		 */
+		if (bd_status & ENETC_RXBD_FLAG_VLAN)
+			rx_byte_cnt += VLAN_HLEN;
+		rx_byte_cnt += xdp_get_buff_len(&xdp_buff);
+
 		xdp_act = bpf_prog_run_xdp(prog, &xdp_buff);
 
 		switch (xdp_act) {
-- 
2.25.1


