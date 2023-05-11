Return-Path: <netdev+bounces-1782-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D55BB6FF22A
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 15:09:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9C9FB1C20F30
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 13:09:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40D3C1F951;
	Thu, 11 May 2023 13:09:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26A261F936
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 13:09:33 +0000 (UTC)
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2095.outbound.protection.outlook.com [40.107.102.95])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A84C40ED;
	Thu, 11 May 2023 06:09:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oVPwiJBf+RiFigRB6a0k72TzRBOdwJeB3DzC0GqNssIy7SgXbgPVmfuSNctAqHQCT8IjYTSzaQE7EdLQkmqTRxv8n3trin4gKLQKqx2IfcaUS0R86Z5ldS8H+NWOT+XPklNAkhVLXZFA3H636D80gSd7iK9KaZKHE5305AtWaTPSwKaFrFJHW+gmKBfQ7VEDRevDuxYiTXqB4Awy343B6H7kPmN3b01CHXrzqNfhQdN+ArViS+WwmAf3kiUHbaZSBtgOmO6999hZtH5fPRlOrgPw81tTE1a3knNvxN3EAq+5VcGqX4D8feXVBdfak9JJkl7H1VALPWsfD1+PlkcbtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G6I5NQowe6+zS0ATbxr5KM5Cx4tqXOPG64NwhZNImIM=;
 b=ZbXf5CtSf0iJZRbevka01rfuP1LKnlI57FlVT8d0VLtSEYHQRgRqd3tOmOYvWoIy1TN+tMj01VFjWgFNeocDoNU34dmQikLP2W7QYeAEWgZezi10zTrAGUMDKpBCqVwXIHCaCfG3gWJ2P/181TUdr+lQkeUY14Sm8sQkZOG5FmKIoEh7HmZJ8jjfSeGthDxRMihjZc/bhgNcxrBWK2pg5HnbSgdkvisjugqvF6qRSt19/P3v7DheodGy5WgYBtHeW/qtj2oodUjgXgXlzTnWx+HzVpUhqMHI57acaZCINksKEw6Ki6zlIKQAcyesXHPiNsifncjA2eCrNTfJn4o75Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G6I5NQowe6+zS0ATbxr5KM5Cx4tqXOPG64NwhZNImIM=;
 b=v3Ad7z6EMQGzVImxor+dn8bpqQpPTdVD2fJbxKa2UcAokg+DyQEHr9lp1+mGa40oCMY0db6R5GZBdTiQp+hAUw/jGxGkr5Coxf9CYEcLrPhLEeS+9PAyqbUjqG3N+ewylRsZgBRlmMqstPpPo+IZvG1UC9W7/Nn83w0QDFQVjJ0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL3PR13MB5122.namprd13.prod.outlook.com (2603:10b6:208:351::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.22; Thu, 11 May
 2023 13:08:53 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.020; Thu, 11 May 2023
 13:08:53 +0000
Date: Thu, 11 May 2023 15:08:45 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Pranavi Somisetty <pranavi.somisetty@amd.com>
Cc: nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, richardcochran@gmail.com, linux@armlinux.org.uk,
	palmer@dabbelt.com, git@amd.com, michal.simek@amd.com,
	harini.katakam@amd.com, radhey.shyam.pandey@amd.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org
Subject: Re: [PATCH net-next v2 2/2] net: macb: Add support for partial store
 and forward
Message-ID: <ZFzo3X1L3JRa98HK@corigine.com>
References: <20230511071214.18611-1-pranavi.somisetty@amd.com>
 <20230511071214.18611-3-pranavi.somisetty@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230511071214.18611-3-pranavi.somisetty@amd.com>
X-ClientProxiedBy: AS4P195CA0025.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d6::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL3PR13MB5122:EE_
X-MS-Office365-Filtering-Correlation-Id: f8c56293-c1af-4b58-971a-08db5220de5c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	+YqxuC75tH4svWRZa8LeAOqvrsTvx0wtDR6oYC2SWG0ao6ReSjoMfaFhOPN9lNxuz12eXv7jQxUoM/s0mkHGG7VQi+nZwfbyVYgL92TG4LhI2VP/BlxTWZU5XrMr3CnXxjRYUSNJvhz0qYKk16BpnQa0P4cp9hWBNnLG3Dg4W7nQuDtUUYyZjAzO7NSrp8eTsycDbIxcIAZ+nsw6Ami81U2/MX4xgPVE0znHY6cvpK9+G4+MLDfr2xyQ0guBoXMgDvXbOHoSjTrC1fC0M1DtLQCuaPVITws/X0vpUVTHwTLYnlEAhYgcLJPaDlP9meBW1L7DVIqtVldqAODbYUA3kQua3yG7xKz61WEqIadmrG4IUsh/Flunmd/KumiMDL2xC7sWPARlxladAkLrzoI28j3tvMuF268iOpP1PMFu/jHy0Nl1UNbnfD6dbxOgDRasVlqKoOnDDbVOQnb3CR2kyEx+HqmWl36gTzPYzh5uYlEn5BoOun5MEc/8xHkrWJWNGLP4ihKATopZpz1hyC6NdYTrTeBuvaHdbzy5Z7F7PVYWUOy8vLxFCPvR7VjhGA+1zJtIn8W//dD5CmbMMZmuv3BNQICiu+b8NPT6JnHr6sk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(136003)(39840400004)(396003)(376002)(451199021)(478600001)(66946007)(66556008)(66476007)(6486002)(6666004)(36756003)(316002)(6916009)(4326008)(86362001)(186003)(6506007)(2616005)(6512007)(38100700002)(41300700001)(7416002)(5660300002)(2906002)(8936002)(44832011)(8676002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?uEnwHAigO4ZP4K8m7dp6D6x738vOsIOtsjUXi7O3DR51I9/NODgnh9/18w9a?=
 =?us-ascii?Q?rtHj5WMr5kTTU/5Zjf4BDanRot3iU/e4mKVqAib85Rg2I5fgQJZul/2cvoYK?=
 =?us-ascii?Q?2nBODGKJQJgmp/w3U/92RbuOHAWJxgIAi5YtTuOw10gZ43UOeOuU7YpVRS2Z?=
 =?us-ascii?Q?KqtOcMcaKiBtHl+InX5hoY35/Q8vVfPk+baBLg7ftqJfHps45tBe5Xfkaz95?=
 =?us-ascii?Q?ZgNC3lBhmNx7kdGoldTnCYp/u0lrCKSbefPBnApVbqb7Rpa1VeS0utfIz++V?=
 =?us-ascii?Q?Esw4GBmnOWS0sG5lT0FLSg8bq5imtcm2d4LGoYW9slq/dz8xyUEJXo7RT16y?=
 =?us-ascii?Q?ODQjDa3XQZGMG5hj9+yoS3VzfEdfE1lC10EGy2+wMGu5ilE7JYRx0mLpqeRm?=
 =?us-ascii?Q?4RyMAfnmmnn9AmzmSXcAQrhsiyuYMpSflTfoWlfNh1fCRR6oZh679Ag1+7hP?=
 =?us-ascii?Q?mUjtkZYxUmvHZr+PgRgC+XKrj7vR5yTSawoQEv38w9xCM6vblZLuz8aeVGdN?=
 =?us-ascii?Q?gU1rMgw4F3qxN4zhZaesTh7nKTPKcas3roYGoaVT7ZAW7RYVTNoHJwOJvrhz?=
 =?us-ascii?Q?IGxvknk9YPwZwlzR1iCKq8YZWN+O6EEvgfqMrahqm/6e+ZbSMiCbNHaL70z3?=
 =?us-ascii?Q?bJJhqqnaKZodaA3TXQrWgyE52AaGhJAxb2ykuc8FJt3CzWiZwsOzqgG1Pnhl?=
 =?us-ascii?Q?OzTeo9lSC656q1gfuddY3U7asjr7kws/Nv6drg5mFVlRoZsucYCEr3Xomszs?=
 =?us-ascii?Q?SkE94kKYQmx2U39MpYTF2SHvrY1gbvdzVBjmFZiMvQuWsHk459w6wbn7rvUy?=
 =?us-ascii?Q?JEftZi3aN61XvcSC+CSXxWz46yvsdUAa4myi9ilFcMk+Qwhf7frUsXXfXGTm?=
 =?us-ascii?Q?Fi13C13CGJ8TCK0yhX60HMCZcvyzGBRqdiSJcQmS16ufaCLYvzw2bHU5fVXf?=
 =?us-ascii?Q?OwfcqFTz3M/H6O7OLEUskDTNrR8/r0nNzV+7tPFNGUvdzUTyD784l4K6/zpW?=
 =?us-ascii?Q?NAtWiWAUFV/wEZpFSxX7l75VeUbPQxVfpky9bBbmaUfWlWEAsvwXTOR6Sejn?=
 =?us-ascii?Q?zdRngZmDAVWO7OSSEP3/Rb+zmXYKZCQgUAMUPQItq01juDUxmBOO09Dw35ve?=
 =?us-ascii?Q?swDnF2mUn7pZb4aGYpempoEH+5VrFkcEZCO7MvnUgTYzIfv5Hp0IfULiWO69?=
 =?us-ascii?Q?o/ckXVDOb/qhSC7hs5nD3lLauBhs3Vi3QrZvrfk+0CYbS45AINjlrNYdsvSV?=
 =?us-ascii?Q?uTiXuq8ImNoD/BRdiujG9nKEX+mUg9yI3jb4GjARhu7GKSfDD7NfbZAKVNoB?=
 =?us-ascii?Q?EusKCnU745zocTYU55KtvFgBEEDax6EaEmAJkyx00/GDemNjtRletk4vTzFT?=
 =?us-ascii?Q?qP47OmeGMfs85E5kiyXHKAhLvdRJInhCuU97jpew/7OWKEIWZruxWbiCoMxh?=
 =?us-ascii?Q?u1geklxKU+JZdECl0j5/4BU9ypacWsDhkQQmBJvVuLHGRCPxGlZOnzBMVA6E?=
 =?us-ascii?Q?xYa3ZDPDUE+DcjkSxPRzYiTLIJP1SVmKXoTW4cfxCqRZfi/mVEvUs1zQ2VXD?=
 =?us-ascii?Q?7kKj8sgI+v6lmyyY0NmcUvkfwzeC/amC5Wne5tnKc4Fbg4czTJgGUZUeGzZx?=
 =?us-ascii?Q?MntEdvMJ+gnUOYwmLn6ak5Y+Na55Q7zbHimAZF81bh5y3dWcD6Azv3Iab7f4?=
 =?us-ascii?Q?K0ghxg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8c56293-c1af-4b58-971a-08db5220de5c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 13:08:52.9972
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w80AQK1K4UU9j2VZ+bHu9gieo6Xst/79jUUEDQSI/Re2UqoyTFP12CsFtjwAuBe1Q7Z5RoKbe4jVAIgiDYa643qwYJdM65yXTpJ2ZUFyMME=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR13MB5122
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 11, 2023 at 01:12:14AM -0600, Pranavi Somisetty wrote:
> When the receive partial store and forward mode is activated, the
> receiver will only begin to forward the packet to the external AHB
> or AXI slave when enough packet data is stored in the packet buffer.
> The amount of packet data required to activate the forwarding process
> is programmable via watermark registers which are located at the same
> address as the partial store and forward enable bits. Adding support to
> read this rx-watermark value from device-tree, to program the watermark
> registers and enable partial store and forwarding.
> 
> Signed-off-by: Maulik Jodhani <maulik.jodhani@xilinx.com>
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
> Signed-off-by: Harini Katakam <harini.katakam@xilinx.com>
> Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
> Signed-off-by: Pranavi Somisetty <pranavi.somisetty@amd.com>
> ---
> Changes v2:
> 
> 1. Removed all the changes related to validating FCS when Rx checksum offload is disabled.
> 2. Instead of using a platform dependent number (0xFFF) for the reset value of rx watermark,
> derive it from designcfg_debug2 register.
> 3. Added a check to see if partial s/f is supported, by reading the
> designcfg_debug6 register.
> ---
>  drivers/net/ethernet/cadence/macb.h      | 14 +++++++
>  drivers/net/ethernet/cadence/macb_main.c | 49 +++++++++++++++++++++++-
>  2 files changed, 61 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
> index 14dfec4db8f9..46833662094d 100644
> --- a/drivers/net/ethernet/cadence/macb.h
> +++ b/drivers/net/ethernet/cadence/macb.h
> @@ -82,6 +82,7 @@
>  #define GEM_NCFGR		0x0004 /* Network Config */
>  #define GEM_USRIO		0x000c /* User IO */
>  #define GEM_DMACFG		0x0010 /* DMA Configuration */
> +#define GEM_PBUFRXCUT		0x0044 /* RX Partial Store and Forward */
>  #define GEM_JML			0x0048 /* Jumbo Max Length */
>  #define GEM_HS_MAC_CONFIG	0x0050 /* GEM high speed config */
>  #define GEM_HRB			0x0080 /* Hash Bottom */
> @@ -343,6 +344,11 @@
>  #define GEM_ADDR64_SIZE		1
>  
>  
> +/* Bitfields in PBUFRXCUT */
> +#define GEM_WTRMRK_OFFSET	0 /* Watermark value offset */
> +#define GEM_ENCUTTHRU_OFFSET	31 /* Enable RX partial store and forward */
> +#define GEM_ENCUTTHRU_SIZE	1
> +
>  /* Bitfields in NSR */
>  #define MACB_NSR_LINK_OFFSET	0 /* pcs_link_state */
>  #define MACB_NSR_LINK_SIZE	1
> @@ -509,6 +515,8 @@
>  #define GEM_TX_PKT_BUFF_OFFSET			21
>  #define GEM_TX_PKT_BUFF_SIZE			1
>  
> +#define GEM_RX_PBUF_ADDR_OFFSET			22
> +#define GEM_RX_PBUF_ADDR_SIZE			4
>  
>  /* Bitfields in DCFG5. */
>  #define GEM_TSU_OFFSET				8
> @@ -517,6 +525,8 @@
>  /* Bitfields in DCFG6. */
>  #define GEM_PBUF_LSO_OFFSET			27
>  #define GEM_PBUF_LSO_SIZE			1
> +#define GEM_PBUF_CUTTHRU_OFFSET			26
> +#define GEM_PBUF_CUTTHRU_SIZE			1
>  #define GEM_DAW64_OFFSET			23
>  #define GEM_DAW64_SIZE				1
>  
> @@ -718,6 +728,7 @@
>  #define MACB_CAPS_NEEDS_RSTONUBR		0x00000100
>  #define MACB_CAPS_MIIONRGMII			0x00000200
>  #define MACB_CAPS_NEED_TSUCLK			0x00000400
> +#define MACB_CAPS_PARTIAL_STORE_FORWARD		0x00000800
>  #define MACB_CAPS_PCS				0x01000000
>  #define MACB_CAPS_HIGH_SPEED			0x02000000
>  #define MACB_CAPS_CLK_HW_CHG			0x04000000
> @@ -1283,6 +1294,9 @@ struct macb {
>  
>  	u32			wol;
>  
> +	/* holds value of rx watermark value for pbuf_rxcutthru register */
> +	u16			rx_watermark;
> +
>  	struct macb_ptp_info	*ptp_info;	/* macb-ptp interface */
>  
>  	struct phy		*sgmii_phy;	/* for ZynqMP SGMII mode */
> diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
> index 41964fd02452..07b9964e7aa3 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -2600,6 +2600,7 @@ static void macb_init_rings(struct macb *bp)
>  static void macb_reset_hw(struct macb *bp)
>  {
>  	struct macb_queue *queue;
> +	u16 watermark_reset_value;
>  	unsigned int q;
>  	u32 ctrl = macb_readl(bp, NCR);

Given the review of Conor Dooley of both patches in this series I think
there will be a v3.

Please consider adjusting the hunk above to move towards rather than
away from reverse xmas tree - longest line to shortest - for local
variable names.

That would be:

	u16 watermark_reset_value;
	struct macb_queue *queue;
	...

pw-bot: cr

