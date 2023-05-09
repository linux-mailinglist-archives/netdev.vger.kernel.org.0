Return-Path: <netdev+bounces-1196-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 605826FC914
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 16:34:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8981D1C20B24
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 14:34:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5888617FEC;
	Tue,  9 May 2023 14:34:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4498917FE7
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 14:34:41 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2109.outbound.protection.outlook.com [40.107.92.109])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92C68FA;
	Tue,  9 May 2023 07:34:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nx20YU5ue0TAbIhFbPL9jNrvKb9CtfnO60j/0FKO39ln4u/tk7pCLqekFwsCPeioRpQor39oLwEXDbggcl3e+34RnMcjTYf7vaREmJ2JSvMXEZX0SavbueH1FmUtIuTHUqjrUFIzZvlQSvBKl/UUEn4t+8HingnayzfgbNgxjgqF/ud9v8TBxZzXetEpOgk6p08ZPH2opP753DIzq9ULz2CLEx0uhC5XGQfsHM1VadbNZJSvagyc/PaFiXsnzkgPcSpv1zYIJPTcVQx0CVp6/NH9HhntEjF4eCEmbnu9c+LR4k+TnimFasgV/tbcZoMhtaWjbaczV4MWHWDzKMm6VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/vzxucU/wG/FdEeuelKgL/dz/0tFB0CkygPQ0Hx81AQ=;
 b=gCX0XqD+9y4WkwX1gMg0uclR3fxQCIa7X8FwaRmaYcuD/rPMgfrpf5Yld9jacbqACoxBie3RfHsNAjdkm0llqbwAsSTWiMqg08BVg2yJ8iGuPzd+gp7ClNBB6MDh6s5093sBZdHvpPCIzEthhvWRzd/3RVvjdtfb4Nl3oqUViAbf4CY3MCaLLMxqWr+YlEkJME6hekQWXASNwKqpdyQ257DLfKImdd8y95J3rfwNhx0oahx37DlWtZH1tRlNNo0VHTs0ERwcx+5rynzFzf3VtQN2pHmIGSkwYHhQ+RW8Fmr4LcGC+PCdEQN4OSYYSjf/+Z3zGf/NLfeAIINAnrDFww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/vzxucU/wG/FdEeuelKgL/dz/0tFB0CkygPQ0Hx81AQ=;
 b=L5aUm6jcuPaouRSU6Ag9p1OGD9Qmr8+TN94js/Ufa/x1Gu101tOjZGfUxWuJPf8SNN6JEkhgmmdpxMfb4MERRQU43xu4iYioSxp4Id88PQmgA2a0NV/pOU3UYUWUgAuW+1oU7V04oNmF0pzbWsriANJHjmFJQTQBhgtgLNH736M=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4844.namprd13.prod.outlook.com (2603:10b6:510:76::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.18; Tue, 9 May
 2023 14:34:35 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6363.032; Tue, 9 May 2023
 14:34:35 +0000
Date: Tue, 9 May 2023 16:34:28 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Ivan Mikhaylov <fr0st61te@gmail.com>
Cc: Samuel Mendoza-Jonas <sam@mendozajonas.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	netdev@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, openbmc@lists.ozlabs.org
Subject: Re: [PATCH v2 4/5] net/ncsi: add shift MAC address property
Message-ID: <ZFpZ9Ko5DHWiBXDu@corigine.com>
References: <20230509143504.30382-1-fr0st61te@gmail.com>
 <20230509143504.30382-5-fr0st61te@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230509143504.30382-5-fr0st61te@gmail.com>
X-ClientProxiedBy: AS4P251CA0023.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d3::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB4844:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e049c3b-ee53-464e-1473-08db509a82a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	GJhV6HeVjjhvSz9qUMZ2TjVOqStwzODx8Bg3TK28C1z/eNDO+QX8xT3wYtbLD1115Jd1jL0sI0ashGbP+yAue0wwKN07JsCmu7x/aDYfru98xgFhkIrela4hW98DaEotWeIXrb/s5nFFgVDy2OlXohrXwASph3czRy+LKUpmDrAYC0KrLx80UwPFnhz6YsaCuYR7P8irgCCeiHIohyzUTwX71etBPl8BkAg/BMlnDrgizIB14+zY/IsWSAqE/nrDvsCQZ6oVBPeUI/B9aAtT+sEl57GW050Hdyv+DtlwmgI60PuSE3tQ1oGSTr2X4wYH6TzwWVlyNfNqfoM2KXt5+fvwHk8hDVO6A7WPqlHL/ivVFK5A5NuHfFvxSPJ2W00AOXtxxU3jI1mSnM43A9y+6WqZusxbpfGgUVo4oC5HshF17R+QL7v9mPEe8477e+oubs/ouHbQpdZIPCqR5XFUWWhntMGNOJAplTws8rT3fTonznCQzHpmuN0dQekOrHA+ahw3u5dQY4HXWpSw3pyGtlfpek+mYCVfe/tu0c+7mIgLNCN2O1PxRWTO7m1MTrHWycWrwMNMmaLHSltpT1JQQ2afgRL7pmQOV+XbJdQp9Oo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39830400003)(346002)(376002)(366004)(136003)(451199021)(2616005)(8936002)(8676002)(38100700002)(186003)(6486002)(6666004)(6506007)(6512007)(36756003)(2906002)(5660300002)(44832011)(478600001)(7416002)(316002)(66946007)(83380400001)(6916009)(66556008)(66476007)(4326008)(54906003)(86362001)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?A+aEm8o1+aWPmRk4TqmmScC3t5L+OSGHq8xcVdH/m4qGCj7USCnsEjfQSbyO?=
 =?us-ascii?Q?7TZMrwfbNrOHo9dIK4qtGlx6wdN+/U4icJku22to/HnPXVe3PDbDI5xGjWnV?=
 =?us-ascii?Q?pOTgjxkEhkMK0LIVnn6misFR42vdAULUgQiSxlDfpqZUp0eEhU2kl4E6dAm1?=
 =?us-ascii?Q?hkl0T+m0wbJvJeDHzyNXInNl2xOCBY67o7phEI+U0f0+E3U/nhAVpVbniTmH?=
 =?us-ascii?Q?8kkZ7a855OUV3kqmoS1Y2nkV8cnS+UXxMB1EiErCHdX6SR3I6YJT3P31dRUL?=
 =?us-ascii?Q?yWKfSOUpKiUcLQ3a48iqf3HfHBu1EsQD5uWzXlOFDmmbW0lzQkISBE4FLegn?=
 =?us-ascii?Q?GcKQI8X6QPmaFXYBC6zcfe9Q9U3Ly/xUhhLFbau7vp5RTCFUXd5j+XDze0e9?=
 =?us-ascii?Q?JaE8eK/NwqqLOiJV0leCcaziwCxxKwUHrLOtob6uqEl8bNDpT6DPZQjAFLcZ?=
 =?us-ascii?Q?beFWfA0I8cGlf+v0x3Hp1UDbtY5LerpckP6Z7pBiE7W38LEgcDdqHoVihOn0?=
 =?us-ascii?Q?/028ey0MWQQfkWoooljcS60+aeAX1Hihc7A/2+nYONRcjNWvWyu/1WAagSku?=
 =?us-ascii?Q?jd8tleKrw4ghuxvXlqOEMmamYE+Z3wLKd5qIQc7uPTuxult+1cUO2MfQidU0?=
 =?us-ascii?Q?Ostyyyjw7Kj4mldOZW7/hjNsHH35QCPtiDYGVaxZhkzoI+JyuDokjhr5qg5S?=
 =?us-ascii?Q?REL1pXe21tzITVNEnCi9Opsqb+2Eq1uhLfrzhbvlN7Uxa6hrWeQZL8jojJvK?=
 =?us-ascii?Q?63Gh+svEUIo59z3+B7ajmpxkTs+hNbEUFc/I6i8WPGF4lt5jWktNX2ng298+?=
 =?us-ascii?Q?FU1m0QdVO9O6INI4aSMHCh3RjnD3OO0Hj+/q/dN2Ml7OWdDzhOOxCYgsfaFJ?=
 =?us-ascii?Q?vOXxQ/q+0AlENzMawes0c6LQipB13I19MM5BqzgWvOGT8LEKm3PQnqDauc8v?=
 =?us-ascii?Q?NGdnB33IOYBcYW6R18rF2qb87Eoe1O5vbKsAEiPzT8C3ZMiD65c1MViMIWnN?=
 =?us-ascii?Q?bYKLMUnXAFSV13WiNyjZEA0tvW0qTAuL62ptoSp9gzYdZZTobVeiWky+FVwl?=
 =?us-ascii?Q?+fgvFsINAVaWLs/ORTHv2Ooi7PpDP2f7Wd32Bne2WFSQ49tL3tQQsPtvftOs?=
 =?us-ascii?Q?bTSgu9Zmz1sM1gMhudK9yJ8LBI8HsXvWhFGzuagAuSvJ2HJcI6FMdC0i4/kf?=
 =?us-ascii?Q?D3yDD3AJEP+ARPlt7eV2JqFYiXdP/PAeHCMa1f+XCJFz6QJ/haBE8fFG8xLM?=
 =?us-ascii?Q?sBRfFgMiEX1c4CEbtrDRYXBXW+XrcqK5VgXD9Jtq6fXEgwfUAWbCUHN256Bt?=
 =?us-ascii?Q?m28w7J/kDMWgdlq0fMbEaRt0I9Slhy/WT26v/DDh7xjkthse3JRwsCB3QguG?=
 =?us-ascii?Q?1j376gfJDrU7BkMY5m/w4u1JmxY6T4rFFy8QR4DWMg4+vxtv0pszms2PCuJa?=
 =?us-ascii?Q?AIzmi/+ffNufXMCxg6nIO6qkSPDndxCEoVaIBthuj+ny+4CK2aEy1riFjg0l?=
 =?us-ascii?Q?LMsQfzL8O1JVfmnYoIyeot0s/KWcmGCVZIk31MlJvCFim4ywiVLyFmOINJw5?=
 =?us-ascii?Q?evk9H1Wn+/MjTfZWQy3v5XPBw/+3ZnwCgznMRxir1RSE8RoN1JDENFAWPZV7?=
 =?us-ascii?Q?6jgHsoRkiB8Ir6yAc8+rsGT4m/v9A8dey60FKAt+iaV4SUJXrgtABLBrqDeM?=
 =?us-ascii?Q?olptjQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e049c3b-ee53-464e-1473-08db509a82a5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2023 14:34:35.2045
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zfx61nPNNTddJwWPtQJ95so4rHf4kYT8OVB6DUrzo0x6iDTucjzSMvTimSShKQbX7uKbaiwNZ7GkU+vs83KcWQhS0PF97CnO5vUTap6QlkM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4844
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 09, 2023 at 02:35:03PM +0000, Ivan Mikhaylov wrote:
> Add the shift MAC address property for GMA command which provides which
> shift should be used but keep old one values for backward compatability.

nit: s/compatability/compatibility/

> 
> Signed-off-by: Ivan Mikhaylov <fr0st61te@gmail.com>
> ---
>  net/ncsi/ncsi-rsp.c | 17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/net/ncsi/ncsi-rsp.c b/net/ncsi/ncsi-rsp.c
> index 069c2659074b..1f108db34d85 100644
> --- a/net/ncsi/ncsi-rsp.c
> +++ b/net/ncsi/ncsi-rsp.c
> @@ -9,6 +9,8 @@
>  #include <linux/netdevice.h>
>  #include <linux/etherdevice.h>
>  #include <linux/skbuff.h>
> +#include <linux/platform_device.h>
> +#include <linux/of.h>
>  
>  #include <net/ncsi.h>
>  #include <net/net_namespace.h>
> @@ -616,9 +618,12 @@ static int ncsi_rsp_handler_oem_gma(struct ncsi_request *nr, int mfr_id)
>  {
>  	struct ncsi_dev_priv *ndp = nr->ndp;
>  	struct net_device *ndev = ndp->ndev.dev;
> +	struct platform_device *pdev;
>  	struct ncsi_rsp_oem_pkt *rsp;
>  	struct sockaddr saddr;
>  	u32 mac_addr_off = 0;
> +	s32 shift_mac_addr = 0;
> +	u64 mac_addr;
>  	int ret = 0;

nit: please preserve reverse xmas tree - longest line to shortest - order
     for local variables in networking code. Or in this case,
     move towards rather than away from that pattern.

>  	/* Get the response header */
> @@ -635,7 +640,17 @@ static int ncsi_rsp_handler_oem_gma(struct ncsi_request *nr, int mfr_id)
>  
>  	memcpy(saddr.sa_data, &rsp->data[mac_addr_off], ETH_ALEN);
>  	if (mfr_id == NCSI_OEM_MFR_BCM_ID || mfr_id == NCSI_OEM_MFR_INTEL_ID)
> -		eth_addr_inc((u8 *)saddr.sa_data);
> +		shift_mac_addr = 1;
> +
> +	pdev = to_platform_device(ndev->dev.parent);
> +	if (pdev)
> +		of_property_read_s32(pdev->dev.of_node,
> +				     "mac-address-increment", &shift_mac_addr);
> +
> +	/* Increase mac address by shift value for BMC's address */
> +	mac_addr = ether_addr_to_u64((u8 *)saddr.sa_data);
> +	mac_addr += shift_mac_addr;
> +	u64_to_ether_addr(mac_addr, (u8 *)saddr.sa_data);
>  	if (!is_valid_ether_addr((const u8 *)saddr.sa_data))
>  		return -ENXIO;
>  
> -- 
> 2.40.1
> 
> 

